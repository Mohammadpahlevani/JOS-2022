
obj/user/num:     file format elf64-x86-64


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
  80003c:	e8 97 02 00 00       	callq  8002d8 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  800052:	e9 da 00 00 00       	jmpq   800131 <num+0xee>
		if (bol) {
  800057:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80005e:	00 00 00 
  800061:	8b 00                	mov    (%rax),%eax
  800063:	85 c0                	test   %eax,%eax
  800065:	74 54                	je     8000bb <num+0x78>
			printf("%5d ", ++line);
  800067:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80006e:	00 00 00 
  800071:	8b 00                	mov    (%rax),%eax
  800073:	8d 50 01             	lea    0x1(%rax),%edx
  800076:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80007d:	00 00 00 
  800080:	89 10                	mov    %edx,(%rax)
  800082:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800089:	00 00 00 
  80008c:	8b 00                	mov    (%rax),%eax
  80008e:	89 c6                	mov    %eax,%esi
  800090:	48 bf 60 3a 80 00 00 	movabs $0x803a60,%rdi
  800097:	00 00 00 
  80009a:	b8 00 00 00 00       	mov    $0x0,%eax
  80009f:	48 ba b4 2e 80 00 00 	movabs $0x802eb4,%rdx
  8000a6:	00 00 00 
  8000a9:	ff d2                	callq  *%rdx
			bol = 0;
  8000ab:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8000b2:	00 00 00 
  8000b5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		}
		if ((r = write(1, &c, 1)) != 1)
  8000bb:	48 8d 45 f3          	lea    -0xd(%rbp),%rax
  8000bf:	ba 01 00 00 00       	mov    $0x1,%edx
  8000c4:	48 89 c6             	mov    %rax,%rsi
  8000c7:	bf 01 00 00 00       	mov    $0x1,%edi
  8000cc:	48 b8 77 23 80 00 00 	movabs $0x802377,%rax
  8000d3:	00 00 00 
  8000d6:	ff d0                	callq  *%rax
  8000d8:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000db:	83 7d f4 01          	cmpl   $0x1,-0xc(%rbp)
  8000df:	74 38                	je     800119 <num+0xd6>
			panic("write error copying %s: %e", s, r);
  8000e1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8000e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000e8:	41 89 d0             	mov    %edx,%r8d
  8000eb:	48 89 c1             	mov    %rax,%rcx
  8000ee:	48 ba 65 3a 80 00 00 	movabs $0x803a65,%rdx
  8000f5:	00 00 00 
  8000f8:	be 13 00 00 00       	mov    $0x13,%esi
  8000fd:	48 bf 80 3a 80 00 00 	movabs $0x803a80,%rdi
  800104:	00 00 00 
  800107:	b8 00 00 00 00       	mov    $0x0,%eax
  80010c:	49 b9 8b 03 80 00 00 	movabs $0x80038b,%r9
  800113:	00 00 00 
  800116:	41 ff d1             	callq  *%r9
		if (c == '\n')
  800119:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
  80011d:	3c 0a                	cmp    $0xa,%al
  80011f:	75 10                	jne    800131 <num+0xee>
			bol = 1;
  800121:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800128:	00 00 00 
  80012b:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
{
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  800131:	48 8d 4d f3          	lea    -0xd(%rbp),%rcx
  800135:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800138:	ba 01 00 00 00       	mov    $0x1,%edx
  80013d:	48 89 ce             	mov    %rcx,%rsi
  800140:	89 c7                	mov    %eax,%edi
  800142:	48 b8 2d 22 80 00 00 	movabs $0x80222d,%rax
  800149:	00 00 00 
  80014c:	ff d0                	callq  *%rax
  80014e:	48 98                	cltq   
  800150:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800154:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800159:	0f 8f f8 fe ff ff    	jg     800057 <num+0x14>
		if ((r = write(1, &c, 1)) != 1)
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
			bol = 1;
	}
	if (n < 0)
  80015f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800164:	79 39                	jns    80019f <num+0x15c>
		panic("error reading %s: %e", s, n);
  800166:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80016a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80016e:	49 89 d0             	mov    %rdx,%r8
  800171:	48 89 c1             	mov    %rax,%rcx
  800174:	48 ba 8b 3a 80 00 00 	movabs $0x803a8b,%rdx
  80017b:	00 00 00 
  80017e:	be 18 00 00 00       	mov    $0x18,%esi
  800183:	48 bf 80 3a 80 00 00 	movabs $0x803a80,%rdi
  80018a:	00 00 00 
  80018d:	b8 00 00 00 00       	mov    $0x0,%eax
  800192:	49 b9 8b 03 80 00 00 	movabs $0x80038b,%r9
  800199:	00 00 00 
  80019c:	41 ff d1             	callq  *%r9
}
  80019f:	c9                   	leaveq 
  8001a0:	c3                   	retq   

00000000008001a1 <umain>:

void
umain(int argc, char **argv)
{
  8001a1:	55                   	push   %rbp
  8001a2:	48 89 e5             	mov    %rsp,%rbp
  8001a5:	53                   	push   %rbx
  8001a6:	48 83 ec 28          	sub    $0x28,%rsp
  8001aa:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8001ad:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int f, i;

	binaryname = "num";
  8001b1:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8001b8:	00 00 00 
  8001bb:	48 bb a0 3a 80 00 00 	movabs $0x803aa0,%rbx
  8001c2:	00 00 00 
  8001c5:	48 89 18             	mov    %rbx,(%rax)
	if (argc == 1)
  8001c8:	83 7d dc 01          	cmpl   $0x1,-0x24(%rbp)
  8001cc:	75 20                	jne    8001ee <umain+0x4d>
		num(0, "<stdin>");
  8001ce:	48 be a4 3a 80 00 00 	movabs $0x803aa4,%rsi
  8001d5:	00 00 00 
  8001d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8001dd:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001e4:	00 00 00 
  8001e7:	ff d0                	callq  *%rax
  8001e9:	e9 d7 00 00 00       	jmpq   8002c5 <umain+0x124>
	else
		for (i = 1; i < argc; i++) {
  8001ee:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%rbp)
  8001f5:	e9 bf 00 00 00       	jmpq   8002b9 <umain+0x118>
			f = open(argv[i], O_RDONLY);
  8001fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001fd:	48 98                	cltq   
  8001ff:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800206:	00 
  800207:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80020b:	48 01 d0             	add    %rdx,%rax
  80020e:	48 8b 00             	mov    (%rax),%rax
  800211:	be 00 00 00 00       	mov    $0x0,%esi
  800216:	48 89 c7             	mov    %rax,%rdi
  800219:	48 b8 03 27 80 00 00 	movabs $0x802703,%rax
  800220:	00 00 00 
  800223:	ff d0                	callq  *%rax
  800225:	89 45 e8             	mov    %eax,-0x18(%rbp)
			if (f < 0)
  800228:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80022c:	79 4b                	jns    800279 <umain+0xd8>
				panic("can't open %s: %e", argv[i], f);
  80022e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800231:	48 98                	cltq   
  800233:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80023a:	00 
  80023b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80023f:	48 01 d0             	add    %rdx,%rax
  800242:	48 8b 00             	mov    (%rax),%rax
  800245:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800248:	41 89 d0             	mov    %edx,%r8d
  80024b:	48 89 c1             	mov    %rax,%rcx
  80024e:	48 ba ac 3a 80 00 00 	movabs $0x803aac,%rdx
  800255:	00 00 00 
  800258:	be 27 00 00 00       	mov    $0x27,%esi
  80025d:	48 bf 80 3a 80 00 00 	movabs $0x803a80,%rdi
  800264:	00 00 00 
  800267:	b8 00 00 00 00       	mov    $0x0,%eax
  80026c:	49 b9 8b 03 80 00 00 	movabs $0x80038b,%r9
  800273:	00 00 00 
  800276:	41 ff d1             	callq  *%r9
			else {
				num(f, argv[i]);
  800279:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80027c:	48 98                	cltq   
  80027e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800285:	00 
  800286:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80028a:	48 01 d0             	add    %rdx,%rax
  80028d:	48 8b 10             	mov    (%rax),%rdx
  800290:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800293:	48 89 d6             	mov    %rdx,%rsi
  800296:	89 c7                	mov    %eax,%edi
  800298:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80029f:	00 00 00 
  8002a2:	ff d0                	callq  *%rax
				close(f);
  8002a4:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002a7:	89 c7                	mov    %eax,%edi
  8002a9:	48 b8 0b 20 80 00 00 	movabs $0x80200b,%rax
  8002b0:	00 00 00 
  8002b3:	ff d0                	callq  *%rax

	binaryname = "num";
	if (argc == 1)
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8002b5:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  8002b9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8002bc:	3b 45 dc             	cmp    -0x24(%rbp),%eax
  8002bf:	0f 8c 35 ff ff ff    	jl     8001fa <umain+0x59>
			else {
				num(f, argv[i]);
				close(f);
			}
		}
	exit();
  8002c5:	48 b8 68 03 80 00 00 	movabs $0x800368,%rax
  8002cc:	00 00 00 
  8002cf:	ff d0                	callq  *%rax
}
  8002d1:	48 83 c4 28          	add    $0x28,%rsp
  8002d5:	5b                   	pop    %rbx
  8002d6:	5d                   	pop    %rbp
  8002d7:	c3                   	retq   

00000000008002d8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002d8:	55                   	push   %rbp
  8002d9:	48 89 e5             	mov    %rsp,%rbp
  8002dc:	48 83 ec 10          	sub    $0x10,%rsp
  8002e0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002e3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  8002e7:	48 b8 2c 1a 80 00 00 	movabs $0x801a2c,%rax
  8002ee:	00 00 00 
  8002f1:	ff d0                	callq  *%rax
  8002f3:	48 98                	cltq   
  8002f5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002fa:	48 89 c2             	mov    %rax,%rdx
  8002fd:	48 89 d0             	mov    %rdx,%rax
  800300:	48 c1 e0 03          	shl    $0x3,%rax
  800304:	48 01 d0             	add    %rdx,%rax
  800307:	48 c1 e0 05          	shl    $0x5,%rax
  80030b:	48 89 c2             	mov    %rax,%rdx
  80030e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800315:	00 00 00 
  800318:	48 01 c2             	add    %rax,%rdx
  80031b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800322:	00 00 00 
  800325:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800328:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80032c:	7e 14                	jle    800342 <libmain+0x6a>
		binaryname = argv[0];
  80032e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800332:	48 8b 10             	mov    (%rax),%rdx
  800335:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80033c:	00 00 00 
  80033f:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800342:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800346:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800349:	48 89 d6             	mov    %rdx,%rsi
  80034c:	89 c7                	mov    %eax,%edi
  80034e:	48 b8 a1 01 80 00 00 	movabs $0x8001a1,%rax
  800355:	00 00 00 
  800358:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80035a:	48 b8 68 03 80 00 00 	movabs $0x800368,%rax
  800361:	00 00 00 
  800364:	ff d0                	callq  *%rax
}
  800366:	c9                   	leaveq 
  800367:	c3                   	retq   

0000000000800368 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800368:	55                   	push   %rbp
  800369:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80036c:	48 b8 56 20 80 00 00 	movabs $0x802056,%rax
  800373:	00 00 00 
  800376:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800378:	bf 00 00 00 00       	mov    $0x0,%edi
  80037d:	48 b8 e8 19 80 00 00 	movabs $0x8019e8,%rax
  800384:	00 00 00 
  800387:	ff d0                	callq  *%rax
}
  800389:	5d                   	pop    %rbp
  80038a:	c3                   	retq   

000000000080038b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80038b:	55                   	push   %rbp
  80038c:	48 89 e5             	mov    %rsp,%rbp
  80038f:	53                   	push   %rbx
  800390:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800397:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80039e:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8003a4:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8003ab:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8003b2:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8003b9:	84 c0                	test   %al,%al
  8003bb:	74 23                	je     8003e0 <_panic+0x55>
  8003bd:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8003c4:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8003c8:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8003cc:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8003d0:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8003d4:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8003d8:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8003dc:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8003e0:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8003e7:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8003ee:	00 00 00 
  8003f1:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8003f8:	00 00 00 
  8003fb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003ff:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800406:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80040d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800414:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80041b:	00 00 00 
  80041e:	48 8b 18             	mov    (%rax),%rbx
  800421:	48 b8 2c 1a 80 00 00 	movabs $0x801a2c,%rax
  800428:	00 00 00 
  80042b:	ff d0                	callq  *%rax
  80042d:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800433:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80043a:	41 89 c8             	mov    %ecx,%r8d
  80043d:	48 89 d1             	mov    %rdx,%rcx
  800440:	48 89 da             	mov    %rbx,%rdx
  800443:	89 c6                	mov    %eax,%esi
  800445:	48 bf c8 3a 80 00 00 	movabs $0x803ac8,%rdi
  80044c:	00 00 00 
  80044f:	b8 00 00 00 00       	mov    $0x0,%eax
  800454:	49 b9 c4 05 80 00 00 	movabs $0x8005c4,%r9
  80045b:	00 00 00 
  80045e:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800461:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800468:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80046f:	48 89 d6             	mov    %rdx,%rsi
  800472:	48 89 c7             	mov    %rax,%rdi
  800475:	48 b8 18 05 80 00 00 	movabs $0x800518,%rax
  80047c:	00 00 00 
  80047f:	ff d0                	callq  *%rax
	cprintf("\n");
  800481:	48 bf eb 3a 80 00 00 	movabs $0x803aeb,%rdi
  800488:	00 00 00 
  80048b:	b8 00 00 00 00       	mov    $0x0,%eax
  800490:	48 ba c4 05 80 00 00 	movabs $0x8005c4,%rdx
  800497:	00 00 00 
  80049a:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80049c:	cc                   	int3   
  80049d:	eb fd                	jmp    80049c <_panic+0x111>

000000000080049f <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80049f:	55                   	push   %rbp
  8004a0:	48 89 e5             	mov    %rsp,%rbp
  8004a3:	48 83 ec 10          	sub    $0x10,%rsp
  8004a7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004aa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8004ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004b2:	8b 00                	mov    (%rax),%eax
  8004b4:	8d 48 01             	lea    0x1(%rax),%ecx
  8004b7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004bb:	89 0a                	mov    %ecx,(%rdx)
  8004bd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8004c0:	89 d1                	mov    %edx,%ecx
  8004c2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004c6:	48 98                	cltq   
  8004c8:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8004cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004d0:	8b 00                	mov    (%rax),%eax
  8004d2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004d7:	75 2c                	jne    800505 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8004d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004dd:	8b 00                	mov    (%rax),%eax
  8004df:	48 98                	cltq   
  8004e1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004e5:	48 83 c2 08          	add    $0x8,%rdx
  8004e9:	48 89 c6             	mov    %rax,%rsi
  8004ec:	48 89 d7             	mov    %rdx,%rdi
  8004ef:	48 b8 60 19 80 00 00 	movabs $0x801960,%rax
  8004f6:	00 00 00 
  8004f9:	ff d0                	callq  *%rax
        b->idx = 0;
  8004fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004ff:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800505:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800509:	8b 40 04             	mov    0x4(%rax),%eax
  80050c:	8d 50 01             	lea    0x1(%rax),%edx
  80050f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800513:	89 50 04             	mov    %edx,0x4(%rax)
}
  800516:	c9                   	leaveq 
  800517:	c3                   	retq   

0000000000800518 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800518:	55                   	push   %rbp
  800519:	48 89 e5             	mov    %rsp,%rbp
  80051c:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800523:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80052a:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800531:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800538:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80053f:	48 8b 0a             	mov    (%rdx),%rcx
  800542:	48 89 08             	mov    %rcx,(%rax)
  800545:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800549:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80054d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800551:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800555:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80055c:	00 00 00 
    b.cnt = 0;
  80055f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800566:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800569:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800570:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800577:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80057e:	48 89 c6             	mov    %rax,%rsi
  800581:	48 bf 9f 04 80 00 00 	movabs $0x80049f,%rdi
  800588:	00 00 00 
  80058b:	48 b8 77 09 80 00 00 	movabs $0x800977,%rax
  800592:	00 00 00 
  800595:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800597:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80059d:	48 98                	cltq   
  80059f:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8005a6:	48 83 c2 08          	add    $0x8,%rdx
  8005aa:	48 89 c6             	mov    %rax,%rsi
  8005ad:	48 89 d7             	mov    %rdx,%rdi
  8005b0:	48 b8 60 19 80 00 00 	movabs $0x801960,%rax
  8005b7:	00 00 00 
  8005ba:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8005bc:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8005c2:	c9                   	leaveq 
  8005c3:	c3                   	retq   

00000000008005c4 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8005c4:	55                   	push   %rbp
  8005c5:	48 89 e5             	mov    %rsp,%rbp
  8005c8:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8005cf:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8005d6:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8005dd:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8005e4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8005eb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8005f2:	84 c0                	test   %al,%al
  8005f4:	74 20                	je     800616 <cprintf+0x52>
  8005f6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8005fa:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8005fe:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800602:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800606:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80060a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80060e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800612:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800616:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80061d:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800624:	00 00 00 
  800627:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80062e:	00 00 00 
  800631:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800635:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80063c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800643:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80064a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800651:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800658:	48 8b 0a             	mov    (%rdx),%rcx
  80065b:	48 89 08             	mov    %rcx,(%rax)
  80065e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800662:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800666:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80066a:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80066e:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800675:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80067c:	48 89 d6             	mov    %rdx,%rsi
  80067f:	48 89 c7             	mov    %rax,%rdi
  800682:	48 b8 18 05 80 00 00 	movabs $0x800518,%rax
  800689:	00 00 00 
  80068c:	ff d0                	callq  *%rax
  80068e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800694:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80069a:	c9                   	leaveq 
  80069b:	c3                   	retq   

000000000080069c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80069c:	55                   	push   %rbp
  80069d:	48 89 e5             	mov    %rsp,%rbp
  8006a0:	53                   	push   %rbx
  8006a1:	48 83 ec 38          	sub    $0x38,%rsp
  8006a5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006a9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006ad:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8006b1:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8006b4:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8006b8:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006bc:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8006bf:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8006c3:	77 3b                	ja     800700 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006c5:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8006c8:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8006cc:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8006cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d8:	48 f7 f3             	div    %rbx
  8006db:	48 89 c2             	mov    %rax,%rdx
  8006de:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8006e1:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8006e4:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8006e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ec:	41 89 f9             	mov    %edi,%r9d
  8006ef:	48 89 c7             	mov    %rax,%rdi
  8006f2:	48 b8 9c 06 80 00 00 	movabs $0x80069c,%rax
  8006f9:	00 00 00 
  8006fc:	ff d0                	callq  *%rax
  8006fe:	eb 1e                	jmp    80071e <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800700:	eb 12                	jmp    800714 <printnum+0x78>
			putch(padc, putdat);
  800702:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800706:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800709:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070d:	48 89 ce             	mov    %rcx,%rsi
  800710:	89 d7                	mov    %edx,%edi
  800712:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800714:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800718:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80071c:	7f e4                	jg     800702 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80071e:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800721:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800725:	ba 00 00 00 00       	mov    $0x0,%edx
  80072a:	48 f7 f1             	div    %rcx
  80072d:	48 89 d0             	mov    %rdx,%rax
  800730:	48 ba f0 3c 80 00 00 	movabs $0x803cf0,%rdx
  800737:	00 00 00 
  80073a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80073e:	0f be d0             	movsbl %al,%edx
  800741:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800745:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800749:	48 89 ce             	mov    %rcx,%rsi
  80074c:	89 d7                	mov    %edx,%edi
  80074e:	ff d0                	callq  *%rax
}
  800750:	48 83 c4 38          	add    $0x38,%rsp
  800754:	5b                   	pop    %rbx
  800755:	5d                   	pop    %rbp
  800756:	c3                   	retq   

0000000000800757 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800757:	55                   	push   %rbp
  800758:	48 89 e5             	mov    %rsp,%rbp
  80075b:	48 83 ec 1c          	sub    $0x1c,%rsp
  80075f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800763:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800766:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80076a:	7e 52                	jle    8007be <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80076c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800770:	8b 00                	mov    (%rax),%eax
  800772:	83 f8 30             	cmp    $0x30,%eax
  800775:	73 24                	jae    80079b <getuint+0x44>
  800777:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80077f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800783:	8b 00                	mov    (%rax),%eax
  800785:	89 c0                	mov    %eax,%eax
  800787:	48 01 d0             	add    %rdx,%rax
  80078a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80078e:	8b 12                	mov    (%rdx),%edx
  800790:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800793:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800797:	89 0a                	mov    %ecx,(%rdx)
  800799:	eb 17                	jmp    8007b2 <getuint+0x5b>
  80079b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007a3:	48 89 d0             	mov    %rdx,%rax
  8007a6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ae:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007b2:	48 8b 00             	mov    (%rax),%rax
  8007b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007b9:	e9 a3 00 00 00       	jmpq   800861 <getuint+0x10a>
	else if (lflag)
  8007be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007c2:	74 4f                	je     800813 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8007c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c8:	8b 00                	mov    (%rax),%eax
  8007ca:	83 f8 30             	cmp    $0x30,%eax
  8007cd:	73 24                	jae    8007f3 <getuint+0x9c>
  8007cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007db:	8b 00                	mov    (%rax),%eax
  8007dd:	89 c0                	mov    %eax,%eax
  8007df:	48 01 d0             	add    %rdx,%rax
  8007e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e6:	8b 12                	mov    (%rdx),%edx
  8007e8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ef:	89 0a                	mov    %ecx,(%rdx)
  8007f1:	eb 17                	jmp    80080a <getuint+0xb3>
  8007f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007fb:	48 89 d0             	mov    %rdx,%rax
  8007fe:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800802:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800806:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80080a:	48 8b 00             	mov    (%rax),%rax
  80080d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800811:	eb 4e                	jmp    800861 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800813:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800817:	8b 00                	mov    (%rax),%eax
  800819:	83 f8 30             	cmp    $0x30,%eax
  80081c:	73 24                	jae    800842 <getuint+0xeb>
  80081e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800822:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800826:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082a:	8b 00                	mov    (%rax),%eax
  80082c:	89 c0                	mov    %eax,%eax
  80082e:	48 01 d0             	add    %rdx,%rax
  800831:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800835:	8b 12                	mov    (%rdx),%edx
  800837:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80083a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083e:	89 0a                	mov    %ecx,(%rdx)
  800840:	eb 17                	jmp    800859 <getuint+0x102>
  800842:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800846:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80084a:	48 89 d0             	mov    %rdx,%rax
  80084d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800851:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800855:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800859:	8b 00                	mov    (%rax),%eax
  80085b:	89 c0                	mov    %eax,%eax
  80085d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800861:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800865:	c9                   	leaveq 
  800866:	c3                   	retq   

0000000000800867 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800867:	55                   	push   %rbp
  800868:	48 89 e5             	mov    %rsp,%rbp
  80086b:	48 83 ec 1c          	sub    $0x1c,%rsp
  80086f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800873:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800876:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80087a:	7e 52                	jle    8008ce <getint+0x67>
		x=va_arg(*ap, long long);
  80087c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800880:	8b 00                	mov    (%rax),%eax
  800882:	83 f8 30             	cmp    $0x30,%eax
  800885:	73 24                	jae    8008ab <getint+0x44>
  800887:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80088b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80088f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800893:	8b 00                	mov    (%rax),%eax
  800895:	89 c0                	mov    %eax,%eax
  800897:	48 01 d0             	add    %rdx,%rax
  80089a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80089e:	8b 12                	mov    (%rdx),%edx
  8008a0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a7:	89 0a                	mov    %ecx,(%rdx)
  8008a9:	eb 17                	jmp    8008c2 <getint+0x5b>
  8008ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008af:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008b3:	48 89 d0             	mov    %rdx,%rax
  8008b6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008be:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008c2:	48 8b 00             	mov    (%rax),%rax
  8008c5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008c9:	e9 a3 00 00 00       	jmpq   800971 <getint+0x10a>
	else if (lflag)
  8008ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8008d2:	74 4f                	je     800923 <getint+0xbc>
		x=va_arg(*ap, long);
  8008d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d8:	8b 00                	mov    (%rax),%eax
  8008da:	83 f8 30             	cmp    $0x30,%eax
  8008dd:	73 24                	jae    800903 <getint+0x9c>
  8008df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008eb:	8b 00                	mov    (%rax),%eax
  8008ed:	89 c0                	mov    %eax,%eax
  8008ef:	48 01 d0             	add    %rdx,%rax
  8008f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f6:	8b 12                	mov    (%rdx),%edx
  8008f8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ff:	89 0a                	mov    %ecx,(%rdx)
  800901:	eb 17                	jmp    80091a <getint+0xb3>
  800903:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800907:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80090b:	48 89 d0             	mov    %rdx,%rax
  80090e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800912:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800916:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80091a:	48 8b 00             	mov    (%rax),%rax
  80091d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800921:	eb 4e                	jmp    800971 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800923:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800927:	8b 00                	mov    (%rax),%eax
  800929:	83 f8 30             	cmp    $0x30,%eax
  80092c:	73 24                	jae    800952 <getint+0xeb>
  80092e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800932:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800936:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80093a:	8b 00                	mov    (%rax),%eax
  80093c:	89 c0                	mov    %eax,%eax
  80093e:	48 01 d0             	add    %rdx,%rax
  800941:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800945:	8b 12                	mov    (%rdx),%edx
  800947:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80094a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80094e:	89 0a                	mov    %ecx,(%rdx)
  800950:	eb 17                	jmp    800969 <getint+0x102>
  800952:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800956:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80095a:	48 89 d0             	mov    %rdx,%rax
  80095d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800961:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800965:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800969:	8b 00                	mov    (%rax),%eax
  80096b:	48 98                	cltq   
  80096d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800971:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800975:	c9                   	leaveq 
  800976:	c3                   	retq   

0000000000800977 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800977:	55                   	push   %rbp
  800978:	48 89 e5             	mov    %rsp,%rbp
  80097b:	41 54                	push   %r12
  80097d:	53                   	push   %rbx
  80097e:	48 83 ec 60          	sub    $0x60,%rsp
  800982:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800986:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80098a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80098e:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800992:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800996:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80099a:	48 8b 0a             	mov    (%rdx),%rcx
  80099d:	48 89 08             	mov    %rcx,(%rax)
  8009a0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8009a4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8009a8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8009ac:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009b0:	eb 17                	jmp    8009c9 <vprintfmt+0x52>
			if (ch == '\0')
  8009b2:	85 db                	test   %ebx,%ebx
  8009b4:	0f 84 cc 04 00 00    	je     800e86 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8009ba:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009be:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009c2:	48 89 d6             	mov    %rdx,%rsi
  8009c5:	89 df                	mov    %ebx,%edi
  8009c7:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009c9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009cd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8009d1:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009d5:	0f b6 00             	movzbl (%rax),%eax
  8009d8:	0f b6 d8             	movzbl %al,%ebx
  8009db:	83 fb 25             	cmp    $0x25,%ebx
  8009de:	75 d2                	jne    8009b2 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009e0:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8009e4:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8009eb:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8009f2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8009f9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a00:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a04:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a08:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a0c:	0f b6 00             	movzbl (%rax),%eax
  800a0f:	0f b6 d8             	movzbl %al,%ebx
  800a12:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a15:	83 f8 55             	cmp    $0x55,%eax
  800a18:	0f 87 34 04 00 00    	ja     800e52 <vprintfmt+0x4db>
  800a1e:	89 c0                	mov    %eax,%eax
  800a20:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a27:	00 
  800a28:	48 b8 18 3d 80 00 00 	movabs $0x803d18,%rax
  800a2f:	00 00 00 
  800a32:	48 01 d0             	add    %rdx,%rax
  800a35:	48 8b 00             	mov    (%rax),%rax
  800a38:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800a3a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a3e:	eb c0                	jmp    800a00 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a40:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800a44:	eb ba                	jmp    800a00 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a46:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800a4d:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800a50:	89 d0                	mov    %edx,%eax
  800a52:	c1 e0 02             	shl    $0x2,%eax
  800a55:	01 d0                	add    %edx,%eax
  800a57:	01 c0                	add    %eax,%eax
  800a59:	01 d8                	add    %ebx,%eax
  800a5b:	83 e8 30             	sub    $0x30,%eax
  800a5e:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800a61:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a65:	0f b6 00             	movzbl (%rax),%eax
  800a68:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a6b:	83 fb 2f             	cmp    $0x2f,%ebx
  800a6e:	7e 0c                	jle    800a7c <vprintfmt+0x105>
  800a70:	83 fb 39             	cmp    $0x39,%ebx
  800a73:	7f 07                	jg     800a7c <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a75:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a7a:	eb d1                	jmp    800a4d <vprintfmt+0xd6>
			goto process_precision;
  800a7c:	eb 58                	jmp    800ad6 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800a7e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a81:	83 f8 30             	cmp    $0x30,%eax
  800a84:	73 17                	jae    800a9d <vprintfmt+0x126>
  800a86:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a8a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a8d:	89 c0                	mov    %eax,%eax
  800a8f:	48 01 d0             	add    %rdx,%rax
  800a92:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a95:	83 c2 08             	add    $0x8,%edx
  800a98:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a9b:	eb 0f                	jmp    800aac <vprintfmt+0x135>
  800a9d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aa1:	48 89 d0             	mov    %rdx,%rax
  800aa4:	48 83 c2 08          	add    $0x8,%rdx
  800aa8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800aac:	8b 00                	mov    (%rax),%eax
  800aae:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800ab1:	eb 23                	jmp    800ad6 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800ab3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ab7:	79 0c                	jns    800ac5 <vprintfmt+0x14e>
				width = 0;
  800ab9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800ac0:	e9 3b ff ff ff       	jmpq   800a00 <vprintfmt+0x89>
  800ac5:	e9 36 ff ff ff       	jmpq   800a00 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800aca:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800ad1:	e9 2a ff ff ff       	jmpq   800a00 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800ad6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ada:	79 12                	jns    800aee <vprintfmt+0x177>
				width = precision, precision = -1;
  800adc:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800adf:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800ae2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800ae9:	e9 12 ff ff ff       	jmpq   800a00 <vprintfmt+0x89>
  800aee:	e9 0d ff ff ff       	jmpq   800a00 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800af3:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800af7:	e9 04 ff ff ff       	jmpq   800a00 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800afc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aff:	83 f8 30             	cmp    $0x30,%eax
  800b02:	73 17                	jae    800b1b <vprintfmt+0x1a4>
  800b04:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b08:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b0b:	89 c0                	mov    %eax,%eax
  800b0d:	48 01 d0             	add    %rdx,%rax
  800b10:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b13:	83 c2 08             	add    $0x8,%edx
  800b16:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b19:	eb 0f                	jmp    800b2a <vprintfmt+0x1b3>
  800b1b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b1f:	48 89 d0             	mov    %rdx,%rax
  800b22:	48 83 c2 08          	add    $0x8,%rdx
  800b26:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b2a:	8b 10                	mov    (%rax),%edx
  800b2c:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b30:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b34:	48 89 ce             	mov    %rcx,%rsi
  800b37:	89 d7                	mov    %edx,%edi
  800b39:	ff d0                	callq  *%rax
			break;
  800b3b:	e9 40 03 00 00       	jmpq   800e80 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800b40:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b43:	83 f8 30             	cmp    $0x30,%eax
  800b46:	73 17                	jae    800b5f <vprintfmt+0x1e8>
  800b48:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b4c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b4f:	89 c0                	mov    %eax,%eax
  800b51:	48 01 d0             	add    %rdx,%rax
  800b54:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b57:	83 c2 08             	add    $0x8,%edx
  800b5a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b5d:	eb 0f                	jmp    800b6e <vprintfmt+0x1f7>
  800b5f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b63:	48 89 d0             	mov    %rdx,%rax
  800b66:	48 83 c2 08          	add    $0x8,%rdx
  800b6a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b6e:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800b70:	85 db                	test   %ebx,%ebx
  800b72:	79 02                	jns    800b76 <vprintfmt+0x1ff>
				err = -err;
  800b74:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b76:	83 fb 15             	cmp    $0x15,%ebx
  800b79:	7f 16                	jg     800b91 <vprintfmt+0x21a>
  800b7b:	48 b8 40 3c 80 00 00 	movabs $0x803c40,%rax
  800b82:	00 00 00 
  800b85:	48 63 d3             	movslq %ebx,%rdx
  800b88:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b8c:	4d 85 e4             	test   %r12,%r12
  800b8f:	75 2e                	jne    800bbf <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800b91:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b95:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b99:	89 d9                	mov    %ebx,%ecx
  800b9b:	48 ba 01 3d 80 00 00 	movabs $0x803d01,%rdx
  800ba2:	00 00 00 
  800ba5:	48 89 c7             	mov    %rax,%rdi
  800ba8:	b8 00 00 00 00       	mov    $0x0,%eax
  800bad:	49 b8 8f 0e 80 00 00 	movabs $0x800e8f,%r8
  800bb4:	00 00 00 
  800bb7:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800bba:	e9 c1 02 00 00       	jmpq   800e80 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800bbf:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bc3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bc7:	4c 89 e1             	mov    %r12,%rcx
  800bca:	48 ba 0a 3d 80 00 00 	movabs $0x803d0a,%rdx
  800bd1:	00 00 00 
  800bd4:	48 89 c7             	mov    %rax,%rdi
  800bd7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bdc:	49 b8 8f 0e 80 00 00 	movabs $0x800e8f,%r8
  800be3:	00 00 00 
  800be6:	41 ff d0             	callq  *%r8
			break;
  800be9:	e9 92 02 00 00       	jmpq   800e80 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800bee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bf1:	83 f8 30             	cmp    $0x30,%eax
  800bf4:	73 17                	jae    800c0d <vprintfmt+0x296>
  800bf6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bfa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bfd:	89 c0                	mov    %eax,%eax
  800bff:	48 01 d0             	add    %rdx,%rax
  800c02:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c05:	83 c2 08             	add    $0x8,%edx
  800c08:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c0b:	eb 0f                	jmp    800c1c <vprintfmt+0x2a5>
  800c0d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c11:	48 89 d0             	mov    %rdx,%rax
  800c14:	48 83 c2 08          	add    $0x8,%rdx
  800c18:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c1c:	4c 8b 20             	mov    (%rax),%r12
  800c1f:	4d 85 e4             	test   %r12,%r12
  800c22:	75 0a                	jne    800c2e <vprintfmt+0x2b7>
				p = "(null)";
  800c24:	49 bc 0d 3d 80 00 00 	movabs $0x803d0d,%r12
  800c2b:	00 00 00 
			if (width > 0 && padc != '-')
  800c2e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c32:	7e 3f                	jle    800c73 <vprintfmt+0x2fc>
  800c34:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c38:	74 39                	je     800c73 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c3a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c3d:	48 98                	cltq   
  800c3f:	48 89 c6             	mov    %rax,%rsi
  800c42:	4c 89 e7             	mov    %r12,%rdi
  800c45:	48 b8 3b 11 80 00 00 	movabs $0x80113b,%rax
  800c4c:	00 00 00 
  800c4f:	ff d0                	callq  *%rax
  800c51:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800c54:	eb 17                	jmp    800c6d <vprintfmt+0x2f6>
					putch(padc, putdat);
  800c56:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800c5a:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c5e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c62:	48 89 ce             	mov    %rcx,%rsi
  800c65:	89 d7                	mov    %edx,%edi
  800c67:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c69:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c6d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c71:	7f e3                	jg     800c56 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c73:	eb 37                	jmp    800cac <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800c75:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800c79:	74 1e                	je     800c99 <vprintfmt+0x322>
  800c7b:	83 fb 1f             	cmp    $0x1f,%ebx
  800c7e:	7e 05                	jle    800c85 <vprintfmt+0x30e>
  800c80:	83 fb 7e             	cmp    $0x7e,%ebx
  800c83:	7e 14                	jle    800c99 <vprintfmt+0x322>
					putch('?', putdat);
  800c85:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c89:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c8d:	48 89 d6             	mov    %rdx,%rsi
  800c90:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c95:	ff d0                	callq  *%rax
  800c97:	eb 0f                	jmp    800ca8 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800c99:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c9d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ca1:	48 89 d6             	mov    %rdx,%rsi
  800ca4:	89 df                	mov    %ebx,%edi
  800ca6:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ca8:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cac:	4c 89 e0             	mov    %r12,%rax
  800caf:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800cb3:	0f b6 00             	movzbl (%rax),%eax
  800cb6:	0f be d8             	movsbl %al,%ebx
  800cb9:	85 db                	test   %ebx,%ebx
  800cbb:	74 10                	je     800ccd <vprintfmt+0x356>
  800cbd:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800cc1:	78 b2                	js     800c75 <vprintfmt+0x2fe>
  800cc3:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800cc7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ccb:	79 a8                	jns    800c75 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ccd:	eb 16                	jmp    800ce5 <vprintfmt+0x36e>
				putch(' ', putdat);
  800ccf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cd3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd7:	48 89 d6             	mov    %rdx,%rsi
  800cda:	bf 20 00 00 00       	mov    $0x20,%edi
  800cdf:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ce1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ce5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ce9:	7f e4                	jg     800ccf <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800ceb:	e9 90 01 00 00       	jmpq   800e80 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800cf0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cf4:	be 03 00 00 00       	mov    $0x3,%esi
  800cf9:	48 89 c7             	mov    %rax,%rdi
  800cfc:	48 b8 67 08 80 00 00 	movabs $0x800867,%rax
  800d03:	00 00 00 
  800d06:	ff d0                	callq  *%rax
  800d08:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d10:	48 85 c0             	test   %rax,%rax
  800d13:	79 1d                	jns    800d32 <vprintfmt+0x3bb>
				putch('-', putdat);
  800d15:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d19:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d1d:	48 89 d6             	mov    %rdx,%rsi
  800d20:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d25:	ff d0                	callq  *%rax
				num = -(long long) num;
  800d27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d2b:	48 f7 d8             	neg    %rax
  800d2e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d32:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d39:	e9 d5 00 00 00       	jmpq   800e13 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d3e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d42:	be 03 00 00 00       	mov    $0x3,%esi
  800d47:	48 89 c7             	mov    %rax,%rdi
  800d4a:	48 b8 57 07 80 00 00 	movabs $0x800757,%rax
  800d51:	00 00 00 
  800d54:	ff d0                	callq  *%rax
  800d56:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800d5a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d61:	e9 ad 00 00 00       	jmpq   800e13 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  800d66:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d6a:	be 03 00 00 00       	mov    $0x3,%esi
  800d6f:	48 89 c7             	mov    %rax,%rdi
  800d72:	48 b8 57 07 80 00 00 	movabs $0x800757,%rax
  800d79:	00 00 00 
  800d7c:	ff d0                	callq  *%rax
  800d7e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  800d82:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  800d89:	e9 85 00 00 00       	jmpq   800e13 <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  800d8e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d92:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d96:	48 89 d6             	mov    %rdx,%rsi
  800d99:	bf 30 00 00 00       	mov    $0x30,%edi
  800d9e:	ff d0                	callq  *%rax
			putch('x', putdat);
  800da0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800da4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800da8:	48 89 d6             	mov    %rdx,%rsi
  800dab:	bf 78 00 00 00       	mov    $0x78,%edi
  800db0:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800db2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800db5:	83 f8 30             	cmp    $0x30,%eax
  800db8:	73 17                	jae    800dd1 <vprintfmt+0x45a>
  800dba:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800dbe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dc1:	89 c0                	mov    %eax,%eax
  800dc3:	48 01 d0             	add    %rdx,%rax
  800dc6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dc9:	83 c2 08             	add    $0x8,%edx
  800dcc:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800dcf:	eb 0f                	jmp    800de0 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800dd1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dd5:	48 89 d0             	mov    %rdx,%rax
  800dd8:	48 83 c2 08          	add    $0x8,%rdx
  800ddc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800de0:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800de3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800de7:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800dee:	eb 23                	jmp    800e13 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800df0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800df4:	be 03 00 00 00       	mov    $0x3,%esi
  800df9:	48 89 c7             	mov    %rax,%rdi
  800dfc:	48 b8 57 07 80 00 00 	movabs $0x800757,%rax
  800e03:	00 00 00 
  800e06:	ff d0                	callq  *%rax
  800e08:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e0c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e13:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e18:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e1b:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e1e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e22:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e26:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e2a:	45 89 c1             	mov    %r8d,%r9d
  800e2d:	41 89 f8             	mov    %edi,%r8d
  800e30:	48 89 c7             	mov    %rax,%rdi
  800e33:	48 b8 9c 06 80 00 00 	movabs $0x80069c,%rax
  800e3a:	00 00 00 
  800e3d:	ff d0                	callq  *%rax
			break;
  800e3f:	eb 3f                	jmp    800e80 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e41:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e45:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e49:	48 89 d6             	mov    %rdx,%rsi
  800e4c:	89 df                	mov    %ebx,%edi
  800e4e:	ff d0                	callq  *%rax
			break;
  800e50:	eb 2e                	jmp    800e80 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e52:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e56:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e5a:	48 89 d6             	mov    %rdx,%rsi
  800e5d:	bf 25 00 00 00       	mov    $0x25,%edi
  800e62:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e64:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e69:	eb 05                	jmp    800e70 <vprintfmt+0x4f9>
  800e6b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e70:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e74:	48 83 e8 01          	sub    $0x1,%rax
  800e78:	0f b6 00             	movzbl (%rax),%eax
  800e7b:	3c 25                	cmp    $0x25,%al
  800e7d:	75 ec                	jne    800e6b <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800e7f:	90                   	nop
		}
	}
  800e80:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e81:	e9 43 fb ff ff       	jmpq   8009c9 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800e86:	48 83 c4 60          	add    $0x60,%rsp
  800e8a:	5b                   	pop    %rbx
  800e8b:	41 5c                	pop    %r12
  800e8d:	5d                   	pop    %rbp
  800e8e:	c3                   	retq   

0000000000800e8f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e8f:	55                   	push   %rbp
  800e90:	48 89 e5             	mov    %rsp,%rbp
  800e93:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e9a:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800ea1:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800ea8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800eaf:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800eb6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ebd:	84 c0                	test   %al,%al
  800ebf:	74 20                	je     800ee1 <printfmt+0x52>
  800ec1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ec5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ec9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ecd:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ed1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ed5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ed9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800edd:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ee1:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800ee8:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800eef:	00 00 00 
  800ef2:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800ef9:	00 00 00 
  800efc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f00:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f07:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f0e:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f15:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f1c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800f23:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800f2a:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800f31:	48 89 c7             	mov    %rax,%rdi
  800f34:	48 b8 77 09 80 00 00 	movabs $0x800977,%rax
  800f3b:	00 00 00 
  800f3e:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f40:	c9                   	leaveq 
  800f41:	c3                   	retq   

0000000000800f42 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f42:	55                   	push   %rbp
  800f43:	48 89 e5             	mov    %rsp,%rbp
  800f46:	48 83 ec 10          	sub    $0x10,%rsp
  800f4a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f4d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800f51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f55:	8b 40 10             	mov    0x10(%rax),%eax
  800f58:	8d 50 01             	lea    0x1(%rax),%edx
  800f5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f5f:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800f62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f66:	48 8b 10             	mov    (%rax),%rdx
  800f69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f6d:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f71:	48 39 c2             	cmp    %rax,%rdx
  800f74:	73 17                	jae    800f8d <sprintputch+0x4b>
		*b->buf++ = ch;
  800f76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f7a:	48 8b 00             	mov    (%rax),%rax
  800f7d:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800f81:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f85:	48 89 0a             	mov    %rcx,(%rdx)
  800f88:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f8b:	88 10                	mov    %dl,(%rax)
}
  800f8d:	c9                   	leaveq 
  800f8e:	c3                   	retq   

0000000000800f8f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f8f:	55                   	push   %rbp
  800f90:	48 89 e5             	mov    %rsp,%rbp
  800f93:	48 83 ec 50          	sub    $0x50,%rsp
  800f97:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f9b:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f9e:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800fa2:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800fa6:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800faa:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800fae:	48 8b 0a             	mov    (%rdx),%rcx
  800fb1:	48 89 08             	mov    %rcx,(%rax)
  800fb4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fb8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fbc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fc0:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fc4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fc8:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800fcc:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800fcf:	48 98                	cltq   
  800fd1:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800fd5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fd9:	48 01 d0             	add    %rdx,%rax
  800fdc:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800fe0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800fe7:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800fec:	74 06                	je     800ff4 <vsnprintf+0x65>
  800fee:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ff2:	7f 07                	jg     800ffb <vsnprintf+0x6c>
		return -E_INVAL;
  800ff4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ff9:	eb 2f                	jmp    80102a <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ffb:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800fff:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801003:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801007:	48 89 c6             	mov    %rax,%rsi
  80100a:	48 bf 42 0f 80 00 00 	movabs $0x800f42,%rdi
  801011:	00 00 00 
  801014:	48 b8 77 09 80 00 00 	movabs $0x800977,%rax
  80101b:	00 00 00 
  80101e:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801020:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801024:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801027:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80102a:	c9                   	leaveq 
  80102b:	c3                   	retq   

000000000080102c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80102c:	55                   	push   %rbp
  80102d:	48 89 e5             	mov    %rsp,%rbp
  801030:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801037:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80103e:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801044:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80104b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801052:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801059:	84 c0                	test   %al,%al
  80105b:	74 20                	je     80107d <snprintf+0x51>
  80105d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801061:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801065:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801069:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80106d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801071:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801075:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801079:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80107d:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801084:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80108b:	00 00 00 
  80108e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801095:	00 00 00 
  801098:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80109c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8010a3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010aa:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8010b1:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8010b8:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8010bf:	48 8b 0a             	mov    (%rdx),%rcx
  8010c2:	48 89 08             	mov    %rcx,(%rax)
  8010c5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8010c9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8010cd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8010d1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8010d5:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8010dc:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8010e3:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8010e9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8010f0:	48 89 c7             	mov    %rax,%rdi
  8010f3:	48 b8 8f 0f 80 00 00 	movabs $0x800f8f,%rax
  8010fa:	00 00 00 
  8010fd:	ff d0                	callq  *%rax
  8010ff:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801105:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80110b:	c9                   	leaveq 
  80110c:	c3                   	retq   

000000000080110d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80110d:	55                   	push   %rbp
  80110e:	48 89 e5             	mov    %rsp,%rbp
  801111:	48 83 ec 18          	sub    $0x18,%rsp
  801115:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801119:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801120:	eb 09                	jmp    80112b <strlen+0x1e>
		n++;
  801122:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801126:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80112b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80112f:	0f b6 00             	movzbl (%rax),%eax
  801132:	84 c0                	test   %al,%al
  801134:	75 ec                	jne    801122 <strlen+0x15>
		n++;
	return n;
  801136:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801139:	c9                   	leaveq 
  80113a:	c3                   	retq   

000000000080113b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80113b:	55                   	push   %rbp
  80113c:	48 89 e5             	mov    %rsp,%rbp
  80113f:	48 83 ec 20          	sub    $0x20,%rsp
  801143:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801147:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80114b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801152:	eb 0e                	jmp    801162 <strnlen+0x27>
		n++;
  801154:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801158:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80115d:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801162:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801167:	74 0b                	je     801174 <strnlen+0x39>
  801169:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116d:	0f b6 00             	movzbl (%rax),%eax
  801170:	84 c0                	test   %al,%al
  801172:	75 e0                	jne    801154 <strnlen+0x19>
		n++;
	return n;
  801174:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801177:	c9                   	leaveq 
  801178:	c3                   	retq   

0000000000801179 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801179:	55                   	push   %rbp
  80117a:	48 89 e5             	mov    %rsp,%rbp
  80117d:	48 83 ec 20          	sub    $0x20,%rsp
  801181:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801185:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801189:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801191:	90                   	nop
  801192:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801196:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80119a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80119e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011a2:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011a6:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011aa:	0f b6 12             	movzbl (%rdx),%edx
  8011ad:	88 10                	mov    %dl,(%rax)
  8011af:	0f b6 00             	movzbl (%rax),%eax
  8011b2:	84 c0                	test   %al,%al
  8011b4:	75 dc                	jne    801192 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8011b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011ba:	c9                   	leaveq 
  8011bb:	c3                   	retq   

00000000008011bc <strcat>:

char *
strcat(char *dst, const char *src)
{
  8011bc:	55                   	push   %rbp
  8011bd:	48 89 e5             	mov    %rsp,%rbp
  8011c0:	48 83 ec 20          	sub    $0x20,%rsp
  8011c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011c8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8011cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011d0:	48 89 c7             	mov    %rax,%rdi
  8011d3:	48 b8 0d 11 80 00 00 	movabs $0x80110d,%rax
  8011da:	00 00 00 
  8011dd:	ff d0                	callq  *%rax
  8011df:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8011e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011e5:	48 63 d0             	movslq %eax,%rdx
  8011e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ec:	48 01 c2             	add    %rax,%rdx
  8011ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011f3:	48 89 c6             	mov    %rax,%rsi
  8011f6:	48 89 d7             	mov    %rdx,%rdi
  8011f9:	48 b8 79 11 80 00 00 	movabs $0x801179,%rax
  801200:	00 00 00 
  801203:	ff d0                	callq  *%rax
	return dst;
  801205:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801209:	c9                   	leaveq 
  80120a:	c3                   	retq   

000000000080120b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80120b:	55                   	push   %rbp
  80120c:	48 89 e5             	mov    %rsp,%rbp
  80120f:	48 83 ec 28          	sub    $0x28,%rsp
  801213:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801217:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80121b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80121f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801223:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801227:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80122e:	00 
  80122f:	eb 2a                	jmp    80125b <strncpy+0x50>
		*dst++ = *src;
  801231:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801235:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801239:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80123d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801241:	0f b6 12             	movzbl (%rdx),%edx
  801244:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801246:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80124a:	0f b6 00             	movzbl (%rax),%eax
  80124d:	84 c0                	test   %al,%al
  80124f:	74 05                	je     801256 <strncpy+0x4b>
			src++;
  801251:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801256:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80125b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801263:	72 cc                	jb     801231 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801265:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801269:	c9                   	leaveq 
  80126a:	c3                   	retq   

000000000080126b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80126b:	55                   	push   %rbp
  80126c:	48 89 e5             	mov    %rsp,%rbp
  80126f:	48 83 ec 28          	sub    $0x28,%rsp
  801273:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801277:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80127b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80127f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801283:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801287:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80128c:	74 3d                	je     8012cb <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80128e:	eb 1d                	jmp    8012ad <strlcpy+0x42>
			*dst++ = *src++;
  801290:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801294:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801298:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80129c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012a0:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8012a4:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8012a8:	0f b6 12             	movzbl (%rdx),%edx
  8012ab:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8012ad:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8012b2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012b7:	74 0b                	je     8012c4 <strlcpy+0x59>
  8012b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012bd:	0f b6 00             	movzbl (%rax),%eax
  8012c0:	84 c0                	test   %al,%al
  8012c2:	75 cc                	jne    801290 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8012c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c8:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8012cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d3:	48 29 c2             	sub    %rax,%rdx
  8012d6:	48 89 d0             	mov    %rdx,%rax
}
  8012d9:	c9                   	leaveq 
  8012da:	c3                   	retq   

00000000008012db <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8012db:	55                   	push   %rbp
  8012dc:	48 89 e5             	mov    %rsp,%rbp
  8012df:	48 83 ec 10          	sub    $0x10,%rsp
  8012e3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012e7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8012eb:	eb 0a                	jmp    8012f7 <strcmp+0x1c>
		p++, q++;
  8012ed:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012f2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8012f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012fb:	0f b6 00             	movzbl (%rax),%eax
  8012fe:	84 c0                	test   %al,%al
  801300:	74 12                	je     801314 <strcmp+0x39>
  801302:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801306:	0f b6 10             	movzbl (%rax),%edx
  801309:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80130d:	0f b6 00             	movzbl (%rax),%eax
  801310:	38 c2                	cmp    %al,%dl
  801312:	74 d9                	je     8012ed <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801314:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801318:	0f b6 00             	movzbl (%rax),%eax
  80131b:	0f b6 d0             	movzbl %al,%edx
  80131e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801322:	0f b6 00             	movzbl (%rax),%eax
  801325:	0f b6 c0             	movzbl %al,%eax
  801328:	29 c2                	sub    %eax,%edx
  80132a:	89 d0                	mov    %edx,%eax
}
  80132c:	c9                   	leaveq 
  80132d:	c3                   	retq   

000000000080132e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80132e:	55                   	push   %rbp
  80132f:	48 89 e5             	mov    %rsp,%rbp
  801332:	48 83 ec 18          	sub    $0x18,%rsp
  801336:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80133a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80133e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801342:	eb 0f                	jmp    801353 <strncmp+0x25>
		n--, p++, q++;
  801344:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801349:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80134e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801353:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801358:	74 1d                	je     801377 <strncmp+0x49>
  80135a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80135e:	0f b6 00             	movzbl (%rax),%eax
  801361:	84 c0                	test   %al,%al
  801363:	74 12                	je     801377 <strncmp+0x49>
  801365:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801369:	0f b6 10             	movzbl (%rax),%edx
  80136c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801370:	0f b6 00             	movzbl (%rax),%eax
  801373:	38 c2                	cmp    %al,%dl
  801375:	74 cd                	je     801344 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801377:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80137c:	75 07                	jne    801385 <strncmp+0x57>
		return 0;
  80137e:	b8 00 00 00 00       	mov    $0x0,%eax
  801383:	eb 18                	jmp    80139d <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801385:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801389:	0f b6 00             	movzbl (%rax),%eax
  80138c:	0f b6 d0             	movzbl %al,%edx
  80138f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801393:	0f b6 00             	movzbl (%rax),%eax
  801396:	0f b6 c0             	movzbl %al,%eax
  801399:	29 c2                	sub    %eax,%edx
  80139b:	89 d0                	mov    %edx,%eax
}
  80139d:	c9                   	leaveq 
  80139e:	c3                   	retq   

000000000080139f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80139f:	55                   	push   %rbp
  8013a0:	48 89 e5             	mov    %rsp,%rbp
  8013a3:	48 83 ec 0c          	sub    $0xc,%rsp
  8013a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013ab:	89 f0                	mov    %esi,%eax
  8013ad:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013b0:	eb 17                	jmp    8013c9 <strchr+0x2a>
		if (*s == c)
  8013b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b6:	0f b6 00             	movzbl (%rax),%eax
  8013b9:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013bc:	75 06                	jne    8013c4 <strchr+0x25>
			return (char *) s;
  8013be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c2:	eb 15                	jmp    8013d9 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013c4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013cd:	0f b6 00             	movzbl (%rax),%eax
  8013d0:	84 c0                	test   %al,%al
  8013d2:	75 de                	jne    8013b2 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8013d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013d9:	c9                   	leaveq 
  8013da:	c3                   	retq   

00000000008013db <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013db:	55                   	push   %rbp
  8013dc:	48 89 e5             	mov    %rsp,%rbp
  8013df:	48 83 ec 0c          	sub    $0xc,%rsp
  8013e3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013e7:	89 f0                	mov    %esi,%eax
  8013e9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013ec:	eb 13                	jmp    801401 <strfind+0x26>
		if (*s == c)
  8013ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f2:	0f b6 00             	movzbl (%rax),%eax
  8013f5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013f8:	75 02                	jne    8013fc <strfind+0x21>
			break;
  8013fa:	eb 10                	jmp    80140c <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8013fc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801401:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801405:	0f b6 00             	movzbl (%rax),%eax
  801408:	84 c0                	test   %al,%al
  80140a:	75 e2                	jne    8013ee <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80140c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801410:	c9                   	leaveq 
  801411:	c3                   	retq   

0000000000801412 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801412:	55                   	push   %rbp
  801413:	48 89 e5             	mov    %rsp,%rbp
  801416:	48 83 ec 18          	sub    $0x18,%rsp
  80141a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80141e:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801421:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801425:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80142a:	75 06                	jne    801432 <memset+0x20>
		return v;
  80142c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801430:	eb 69                	jmp    80149b <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801432:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801436:	83 e0 03             	and    $0x3,%eax
  801439:	48 85 c0             	test   %rax,%rax
  80143c:	75 48                	jne    801486 <memset+0x74>
  80143e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801442:	83 e0 03             	and    $0x3,%eax
  801445:	48 85 c0             	test   %rax,%rax
  801448:	75 3c                	jne    801486 <memset+0x74>
		c &= 0xFF;
  80144a:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801451:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801454:	c1 e0 18             	shl    $0x18,%eax
  801457:	89 c2                	mov    %eax,%edx
  801459:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80145c:	c1 e0 10             	shl    $0x10,%eax
  80145f:	09 c2                	or     %eax,%edx
  801461:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801464:	c1 e0 08             	shl    $0x8,%eax
  801467:	09 d0                	or     %edx,%eax
  801469:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80146c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801470:	48 c1 e8 02          	shr    $0x2,%rax
  801474:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801477:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80147b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80147e:	48 89 d7             	mov    %rdx,%rdi
  801481:	fc                   	cld    
  801482:	f3 ab                	rep stos %eax,%es:(%rdi)
  801484:	eb 11                	jmp    801497 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801486:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80148a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80148d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801491:	48 89 d7             	mov    %rdx,%rdi
  801494:	fc                   	cld    
  801495:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801497:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80149b:	c9                   	leaveq 
  80149c:	c3                   	retq   

000000000080149d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80149d:	55                   	push   %rbp
  80149e:	48 89 e5             	mov    %rsp,%rbp
  8014a1:	48 83 ec 28          	sub    $0x28,%rsp
  8014a5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014a9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014ad:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8014b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8014b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014bd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8014c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c5:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014c9:	0f 83 88 00 00 00    	jae    801557 <memmove+0xba>
  8014cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014d7:	48 01 d0             	add    %rdx,%rax
  8014da:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014de:	76 77                	jbe    801557 <memmove+0xba>
		s += n;
  8014e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e4:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8014e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ec:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f4:	83 e0 03             	and    $0x3,%eax
  8014f7:	48 85 c0             	test   %rax,%rax
  8014fa:	75 3b                	jne    801537 <memmove+0x9a>
  8014fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801500:	83 e0 03             	and    $0x3,%eax
  801503:	48 85 c0             	test   %rax,%rax
  801506:	75 2f                	jne    801537 <memmove+0x9a>
  801508:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150c:	83 e0 03             	and    $0x3,%eax
  80150f:	48 85 c0             	test   %rax,%rax
  801512:	75 23                	jne    801537 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801514:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801518:	48 83 e8 04          	sub    $0x4,%rax
  80151c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801520:	48 83 ea 04          	sub    $0x4,%rdx
  801524:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801528:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80152c:	48 89 c7             	mov    %rax,%rdi
  80152f:	48 89 d6             	mov    %rdx,%rsi
  801532:	fd                   	std    
  801533:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801535:	eb 1d                	jmp    801554 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801537:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80153b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80153f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801543:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801547:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154b:	48 89 d7             	mov    %rdx,%rdi
  80154e:	48 89 c1             	mov    %rax,%rcx
  801551:	fd                   	std    
  801552:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801554:	fc                   	cld    
  801555:	eb 57                	jmp    8015ae <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801557:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155b:	83 e0 03             	and    $0x3,%eax
  80155e:	48 85 c0             	test   %rax,%rax
  801561:	75 36                	jne    801599 <memmove+0xfc>
  801563:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801567:	83 e0 03             	and    $0x3,%eax
  80156a:	48 85 c0             	test   %rax,%rax
  80156d:	75 2a                	jne    801599 <memmove+0xfc>
  80156f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801573:	83 e0 03             	and    $0x3,%eax
  801576:	48 85 c0             	test   %rax,%rax
  801579:	75 1e                	jne    801599 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80157b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157f:	48 c1 e8 02          	shr    $0x2,%rax
  801583:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801586:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80158a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80158e:	48 89 c7             	mov    %rax,%rdi
  801591:	48 89 d6             	mov    %rdx,%rsi
  801594:	fc                   	cld    
  801595:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801597:	eb 15                	jmp    8015ae <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801599:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80159d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015a1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015a5:	48 89 c7             	mov    %rax,%rdi
  8015a8:	48 89 d6             	mov    %rdx,%rsi
  8015ab:	fc                   	cld    
  8015ac:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8015ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015b2:	c9                   	leaveq 
  8015b3:	c3                   	retq   

00000000008015b4 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8015b4:	55                   	push   %rbp
  8015b5:	48 89 e5             	mov    %rsp,%rbp
  8015b8:	48 83 ec 18          	sub    $0x18,%rsp
  8015bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015c0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015c4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8015c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015cc:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8015d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d4:	48 89 ce             	mov    %rcx,%rsi
  8015d7:	48 89 c7             	mov    %rax,%rdi
  8015da:	48 b8 9d 14 80 00 00 	movabs $0x80149d,%rax
  8015e1:	00 00 00 
  8015e4:	ff d0                	callq  *%rax
}
  8015e6:	c9                   	leaveq 
  8015e7:	c3                   	retq   

00000000008015e8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8015e8:	55                   	push   %rbp
  8015e9:	48 89 e5             	mov    %rsp,%rbp
  8015ec:	48 83 ec 28          	sub    $0x28,%rsp
  8015f0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015f4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015f8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8015fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801600:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801604:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801608:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80160c:	eb 36                	jmp    801644 <memcmp+0x5c>
		if (*s1 != *s2)
  80160e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801612:	0f b6 10             	movzbl (%rax),%edx
  801615:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801619:	0f b6 00             	movzbl (%rax),%eax
  80161c:	38 c2                	cmp    %al,%dl
  80161e:	74 1a                	je     80163a <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801620:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801624:	0f b6 00             	movzbl (%rax),%eax
  801627:	0f b6 d0             	movzbl %al,%edx
  80162a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80162e:	0f b6 00             	movzbl (%rax),%eax
  801631:	0f b6 c0             	movzbl %al,%eax
  801634:	29 c2                	sub    %eax,%edx
  801636:	89 d0                	mov    %edx,%eax
  801638:	eb 20                	jmp    80165a <memcmp+0x72>
		s1++, s2++;
  80163a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80163f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801644:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801648:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80164c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801650:	48 85 c0             	test   %rax,%rax
  801653:	75 b9                	jne    80160e <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801655:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80165a:	c9                   	leaveq 
  80165b:	c3                   	retq   

000000000080165c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80165c:	55                   	push   %rbp
  80165d:	48 89 e5             	mov    %rsp,%rbp
  801660:	48 83 ec 28          	sub    $0x28,%rsp
  801664:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801668:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80166b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80166f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801673:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801677:	48 01 d0             	add    %rdx,%rax
  80167a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80167e:	eb 15                	jmp    801695 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801680:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801684:	0f b6 10             	movzbl (%rax),%edx
  801687:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80168a:	38 c2                	cmp    %al,%dl
  80168c:	75 02                	jne    801690 <memfind+0x34>
			break;
  80168e:	eb 0f                	jmp    80169f <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801690:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801695:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801699:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80169d:	72 e1                	jb     801680 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80169f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016a3:	c9                   	leaveq 
  8016a4:	c3                   	retq   

00000000008016a5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016a5:	55                   	push   %rbp
  8016a6:	48 89 e5             	mov    %rsp,%rbp
  8016a9:	48 83 ec 34          	sub    $0x34,%rsp
  8016ad:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016b1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8016b5:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8016b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8016bf:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8016c6:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016c7:	eb 05                	jmp    8016ce <strtol+0x29>
		s++;
  8016c9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d2:	0f b6 00             	movzbl (%rax),%eax
  8016d5:	3c 20                	cmp    $0x20,%al
  8016d7:	74 f0                	je     8016c9 <strtol+0x24>
  8016d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016dd:	0f b6 00             	movzbl (%rax),%eax
  8016e0:	3c 09                	cmp    $0x9,%al
  8016e2:	74 e5                	je     8016c9 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e8:	0f b6 00             	movzbl (%rax),%eax
  8016eb:	3c 2b                	cmp    $0x2b,%al
  8016ed:	75 07                	jne    8016f6 <strtol+0x51>
		s++;
  8016ef:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016f4:	eb 17                	jmp    80170d <strtol+0x68>
	else if (*s == '-')
  8016f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016fa:	0f b6 00             	movzbl (%rax),%eax
  8016fd:	3c 2d                	cmp    $0x2d,%al
  8016ff:	75 0c                	jne    80170d <strtol+0x68>
		s++, neg = 1;
  801701:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801706:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80170d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801711:	74 06                	je     801719 <strtol+0x74>
  801713:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801717:	75 28                	jne    801741 <strtol+0x9c>
  801719:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171d:	0f b6 00             	movzbl (%rax),%eax
  801720:	3c 30                	cmp    $0x30,%al
  801722:	75 1d                	jne    801741 <strtol+0x9c>
  801724:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801728:	48 83 c0 01          	add    $0x1,%rax
  80172c:	0f b6 00             	movzbl (%rax),%eax
  80172f:	3c 78                	cmp    $0x78,%al
  801731:	75 0e                	jne    801741 <strtol+0x9c>
		s += 2, base = 16;
  801733:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801738:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80173f:	eb 2c                	jmp    80176d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801741:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801745:	75 19                	jne    801760 <strtol+0xbb>
  801747:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174b:	0f b6 00             	movzbl (%rax),%eax
  80174e:	3c 30                	cmp    $0x30,%al
  801750:	75 0e                	jne    801760 <strtol+0xbb>
		s++, base = 8;
  801752:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801757:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80175e:	eb 0d                	jmp    80176d <strtol+0xc8>
	else if (base == 0)
  801760:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801764:	75 07                	jne    80176d <strtol+0xc8>
		base = 10;
  801766:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80176d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801771:	0f b6 00             	movzbl (%rax),%eax
  801774:	3c 2f                	cmp    $0x2f,%al
  801776:	7e 1d                	jle    801795 <strtol+0xf0>
  801778:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177c:	0f b6 00             	movzbl (%rax),%eax
  80177f:	3c 39                	cmp    $0x39,%al
  801781:	7f 12                	jg     801795 <strtol+0xf0>
			dig = *s - '0';
  801783:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801787:	0f b6 00             	movzbl (%rax),%eax
  80178a:	0f be c0             	movsbl %al,%eax
  80178d:	83 e8 30             	sub    $0x30,%eax
  801790:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801793:	eb 4e                	jmp    8017e3 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801795:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801799:	0f b6 00             	movzbl (%rax),%eax
  80179c:	3c 60                	cmp    $0x60,%al
  80179e:	7e 1d                	jle    8017bd <strtol+0x118>
  8017a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a4:	0f b6 00             	movzbl (%rax),%eax
  8017a7:	3c 7a                	cmp    $0x7a,%al
  8017a9:	7f 12                	jg     8017bd <strtol+0x118>
			dig = *s - 'a' + 10;
  8017ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017af:	0f b6 00             	movzbl (%rax),%eax
  8017b2:	0f be c0             	movsbl %al,%eax
  8017b5:	83 e8 57             	sub    $0x57,%eax
  8017b8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017bb:	eb 26                	jmp    8017e3 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8017bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c1:	0f b6 00             	movzbl (%rax),%eax
  8017c4:	3c 40                	cmp    $0x40,%al
  8017c6:	7e 48                	jle    801810 <strtol+0x16b>
  8017c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cc:	0f b6 00             	movzbl (%rax),%eax
  8017cf:	3c 5a                	cmp    $0x5a,%al
  8017d1:	7f 3d                	jg     801810 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8017d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d7:	0f b6 00             	movzbl (%rax),%eax
  8017da:	0f be c0             	movsbl %al,%eax
  8017dd:	83 e8 37             	sub    $0x37,%eax
  8017e0:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8017e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017e6:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8017e9:	7c 02                	jl     8017ed <strtol+0x148>
			break;
  8017eb:	eb 23                	jmp    801810 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8017ed:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017f2:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8017f5:	48 98                	cltq   
  8017f7:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8017fc:	48 89 c2             	mov    %rax,%rdx
  8017ff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801802:	48 98                	cltq   
  801804:	48 01 d0             	add    %rdx,%rax
  801807:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80180b:	e9 5d ff ff ff       	jmpq   80176d <strtol+0xc8>

	if (endptr)
  801810:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801815:	74 0b                	je     801822 <strtol+0x17d>
		*endptr = (char *) s;
  801817:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80181b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80181f:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801822:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801826:	74 09                	je     801831 <strtol+0x18c>
  801828:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80182c:	48 f7 d8             	neg    %rax
  80182f:	eb 04                	jmp    801835 <strtol+0x190>
  801831:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801835:	c9                   	leaveq 
  801836:	c3                   	retq   

0000000000801837 <strstr>:

char * strstr(const char *in, const char *str)
{
  801837:	55                   	push   %rbp
  801838:	48 89 e5             	mov    %rsp,%rbp
  80183b:	48 83 ec 30          	sub    $0x30,%rsp
  80183f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801843:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801847:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80184b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80184f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801853:	0f b6 00             	movzbl (%rax),%eax
  801856:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801859:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80185d:	75 06                	jne    801865 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80185f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801863:	eb 6b                	jmp    8018d0 <strstr+0x99>

	len = strlen(str);
  801865:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801869:	48 89 c7             	mov    %rax,%rdi
  80186c:	48 b8 0d 11 80 00 00 	movabs $0x80110d,%rax
  801873:	00 00 00 
  801876:	ff d0                	callq  *%rax
  801878:	48 98                	cltq   
  80187a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80187e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801882:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801886:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80188a:	0f b6 00             	movzbl (%rax),%eax
  80188d:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801890:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801894:	75 07                	jne    80189d <strstr+0x66>
				return (char *) 0;
  801896:	b8 00 00 00 00       	mov    $0x0,%eax
  80189b:	eb 33                	jmp    8018d0 <strstr+0x99>
		} while (sc != c);
  80189d:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8018a1:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8018a4:	75 d8                	jne    80187e <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8018a6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018aa:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8018ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b2:	48 89 ce             	mov    %rcx,%rsi
  8018b5:	48 89 c7             	mov    %rax,%rdi
  8018b8:	48 b8 2e 13 80 00 00 	movabs $0x80132e,%rax
  8018bf:	00 00 00 
  8018c2:	ff d0                	callq  *%rax
  8018c4:	85 c0                	test   %eax,%eax
  8018c6:	75 b6                	jne    80187e <strstr+0x47>

	return (char *) (in - 1);
  8018c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018cc:	48 83 e8 01          	sub    $0x1,%rax
}
  8018d0:	c9                   	leaveq 
  8018d1:	c3                   	retq   

00000000008018d2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8018d2:	55                   	push   %rbp
  8018d3:	48 89 e5             	mov    %rsp,%rbp
  8018d6:	53                   	push   %rbx
  8018d7:	48 83 ec 48          	sub    $0x48,%rsp
  8018db:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8018de:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8018e1:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018e5:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8018e9:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8018ed:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  8018f1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018f4:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8018f8:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8018fc:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801900:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801904:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801908:	4c 89 c3             	mov    %r8,%rbx
  80190b:	cd 30                	int    $0x30
  80190d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  801911:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801915:	74 3e                	je     801955 <syscall+0x83>
  801917:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80191c:	7e 37                	jle    801955 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80191e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801922:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801925:	49 89 d0             	mov    %rdx,%r8
  801928:	89 c1                	mov    %eax,%ecx
  80192a:	48 ba c8 3f 80 00 00 	movabs $0x803fc8,%rdx
  801931:	00 00 00 
  801934:	be 4a 00 00 00       	mov    $0x4a,%esi
  801939:	48 bf e5 3f 80 00 00 	movabs $0x803fe5,%rdi
  801940:	00 00 00 
  801943:	b8 00 00 00 00       	mov    $0x0,%eax
  801948:	49 b9 8b 03 80 00 00 	movabs $0x80038b,%r9
  80194f:	00 00 00 
  801952:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  801955:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801959:	48 83 c4 48          	add    $0x48,%rsp
  80195d:	5b                   	pop    %rbx
  80195e:	5d                   	pop    %rbp
  80195f:	c3                   	retq   

0000000000801960 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801960:	55                   	push   %rbp
  801961:	48 89 e5             	mov    %rsp,%rbp
  801964:	48 83 ec 20          	sub    $0x20,%rsp
  801968:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80196c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801970:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801974:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801978:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80197f:	00 
  801980:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801986:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80198c:	48 89 d1             	mov    %rdx,%rcx
  80198f:	48 89 c2             	mov    %rax,%rdx
  801992:	be 00 00 00 00       	mov    $0x0,%esi
  801997:	bf 00 00 00 00       	mov    $0x0,%edi
  80199c:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  8019a3:	00 00 00 
  8019a6:	ff d0                	callq  *%rax
}
  8019a8:	c9                   	leaveq 
  8019a9:	c3                   	retq   

00000000008019aa <sys_cgetc>:

int
sys_cgetc(void)
{
  8019aa:	55                   	push   %rbp
  8019ab:	48 89 e5             	mov    %rsp,%rbp
  8019ae:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8019b2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019b9:	00 
  8019ba:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019c0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019c6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d0:	be 00 00 00 00       	mov    $0x0,%esi
  8019d5:	bf 01 00 00 00       	mov    $0x1,%edi
  8019da:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  8019e1:	00 00 00 
  8019e4:	ff d0                	callq  *%rax
}
  8019e6:	c9                   	leaveq 
  8019e7:	c3                   	retq   

00000000008019e8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8019e8:	55                   	push   %rbp
  8019e9:	48 89 e5             	mov    %rsp,%rbp
  8019ec:	48 83 ec 10          	sub    $0x10,%rsp
  8019f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8019f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019f6:	48 98                	cltq   
  8019f8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019ff:	00 
  801a00:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a06:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a0c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a11:	48 89 c2             	mov    %rax,%rdx
  801a14:	be 01 00 00 00       	mov    $0x1,%esi
  801a19:	bf 03 00 00 00       	mov    $0x3,%edi
  801a1e:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  801a25:	00 00 00 
  801a28:	ff d0                	callq  *%rax
}
  801a2a:	c9                   	leaveq 
  801a2b:	c3                   	retq   

0000000000801a2c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801a2c:	55                   	push   %rbp
  801a2d:	48 89 e5             	mov    %rsp,%rbp
  801a30:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801a34:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a3b:	00 
  801a3c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a42:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a48:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a4d:	ba 00 00 00 00       	mov    $0x0,%edx
  801a52:	be 00 00 00 00       	mov    $0x0,%esi
  801a57:	bf 02 00 00 00       	mov    $0x2,%edi
  801a5c:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  801a63:	00 00 00 
  801a66:	ff d0                	callq  *%rax
}
  801a68:	c9                   	leaveq 
  801a69:	c3                   	retq   

0000000000801a6a <sys_yield>:

void
sys_yield(void)
{
  801a6a:	55                   	push   %rbp
  801a6b:	48 89 e5             	mov    %rsp,%rbp
  801a6e:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801a72:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a79:	00 
  801a7a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a80:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a86:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a8b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a90:	be 00 00 00 00       	mov    $0x0,%esi
  801a95:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a9a:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  801aa1:	00 00 00 
  801aa4:	ff d0                	callq  *%rax
}
  801aa6:	c9                   	leaveq 
  801aa7:	c3                   	retq   

0000000000801aa8 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801aa8:	55                   	push   %rbp
  801aa9:	48 89 e5             	mov    %rsp,%rbp
  801aac:	48 83 ec 20          	sub    $0x20,%rsp
  801ab0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ab3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ab7:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801aba:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801abd:	48 63 c8             	movslq %eax,%rcx
  801ac0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ac4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ac7:	48 98                	cltq   
  801ac9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ad0:	00 
  801ad1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad7:	49 89 c8             	mov    %rcx,%r8
  801ada:	48 89 d1             	mov    %rdx,%rcx
  801add:	48 89 c2             	mov    %rax,%rdx
  801ae0:	be 01 00 00 00       	mov    $0x1,%esi
  801ae5:	bf 04 00 00 00       	mov    $0x4,%edi
  801aea:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  801af1:	00 00 00 
  801af4:	ff d0                	callq  *%rax
}
  801af6:	c9                   	leaveq 
  801af7:	c3                   	retq   

0000000000801af8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801af8:	55                   	push   %rbp
  801af9:	48 89 e5             	mov    %rsp,%rbp
  801afc:	48 83 ec 30          	sub    $0x30,%rsp
  801b00:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b03:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b07:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b0a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b0e:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b12:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b15:	48 63 c8             	movslq %eax,%rcx
  801b18:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b1c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b1f:	48 63 f0             	movslq %eax,%rsi
  801b22:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b29:	48 98                	cltq   
  801b2b:	48 89 0c 24          	mov    %rcx,(%rsp)
  801b2f:	49 89 f9             	mov    %rdi,%r9
  801b32:	49 89 f0             	mov    %rsi,%r8
  801b35:	48 89 d1             	mov    %rdx,%rcx
  801b38:	48 89 c2             	mov    %rax,%rdx
  801b3b:	be 01 00 00 00       	mov    $0x1,%esi
  801b40:	bf 05 00 00 00       	mov    $0x5,%edi
  801b45:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  801b4c:	00 00 00 
  801b4f:	ff d0                	callq  *%rax
}
  801b51:	c9                   	leaveq 
  801b52:	c3                   	retq   

0000000000801b53 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801b53:	55                   	push   %rbp
  801b54:	48 89 e5             	mov    %rsp,%rbp
  801b57:	48 83 ec 20          	sub    $0x20,%rsp
  801b5b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b5e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801b62:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b66:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b69:	48 98                	cltq   
  801b6b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b72:	00 
  801b73:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b79:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b7f:	48 89 d1             	mov    %rdx,%rcx
  801b82:	48 89 c2             	mov    %rax,%rdx
  801b85:	be 01 00 00 00       	mov    $0x1,%esi
  801b8a:	bf 06 00 00 00       	mov    $0x6,%edi
  801b8f:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  801b96:	00 00 00 
  801b99:	ff d0                	callq  *%rax
}
  801b9b:	c9                   	leaveq 
  801b9c:	c3                   	retq   

0000000000801b9d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b9d:	55                   	push   %rbp
  801b9e:	48 89 e5             	mov    %rsp,%rbp
  801ba1:	48 83 ec 10          	sub    $0x10,%rsp
  801ba5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ba8:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801bab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bae:	48 63 d0             	movslq %eax,%rdx
  801bb1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bb4:	48 98                	cltq   
  801bb6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bbd:	00 
  801bbe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bc4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bca:	48 89 d1             	mov    %rdx,%rcx
  801bcd:	48 89 c2             	mov    %rax,%rdx
  801bd0:	be 01 00 00 00       	mov    $0x1,%esi
  801bd5:	bf 08 00 00 00       	mov    $0x8,%edi
  801bda:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  801be1:	00 00 00 
  801be4:	ff d0                	callq  *%rax
}
  801be6:	c9                   	leaveq 
  801be7:	c3                   	retq   

0000000000801be8 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801be8:	55                   	push   %rbp
  801be9:	48 89 e5             	mov    %rsp,%rbp
  801bec:	48 83 ec 20          	sub    $0x20,%rsp
  801bf0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bf3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801bf7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bfb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bfe:	48 98                	cltq   
  801c00:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c07:	00 
  801c08:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c0e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c14:	48 89 d1             	mov    %rdx,%rcx
  801c17:	48 89 c2             	mov    %rax,%rdx
  801c1a:	be 01 00 00 00       	mov    $0x1,%esi
  801c1f:	bf 09 00 00 00       	mov    $0x9,%edi
  801c24:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  801c2b:	00 00 00 
  801c2e:	ff d0                	callq  *%rax
}
  801c30:	c9                   	leaveq 
  801c31:	c3                   	retq   

0000000000801c32 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801c32:	55                   	push   %rbp
  801c33:	48 89 e5             	mov    %rsp,%rbp
  801c36:	48 83 ec 20          	sub    $0x20,%rsp
  801c3a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c3d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c41:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c45:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c48:	48 98                	cltq   
  801c4a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c51:	00 
  801c52:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c58:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c5e:	48 89 d1             	mov    %rdx,%rcx
  801c61:	48 89 c2             	mov    %rax,%rdx
  801c64:	be 01 00 00 00       	mov    $0x1,%esi
  801c69:	bf 0a 00 00 00       	mov    $0xa,%edi
  801c6e:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  801c75:	00 00 00 
  801c78:	ff d0                	callq  *%rax
}
  801c7a:	c9                   	leaveq 
  801c7b:	c3                   	retq   

0000000000801c7c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801c7c:	55                   	push   %rbp
  801c7d:	48 89 e5             	mov    %rsp,%rbp
  801c80:	48 83 ec 20          	sub    $0x20,%rsp
  801c84:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c87:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c8b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c8f:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c92:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c95:	48 63 f0             	movslq %eax,%rsi
  801c98:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c9f:	48 98                	cltq   
  801ca1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ca5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cac:	00 
  801cad:	49 89 f1             	mov    %rsi,%r9
  801cb0:	49 89 c8             	mov    %rcx,%r8
  801cb3:	48 89 d1             	mov    %rdx,%rcx
  801cb6:	48 89 c2             	mov    %rax,%rdx
  801cb9:	be 00 00 00 00       	mov    $0x0,%esi
  801cbe:	bf 0c 00 00 00       	mov    $0xc,%edi
  801cc3:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  801cca:	00 00 00 
  801ccd:	ff d0                	callq  *%rax
}
  801ccf:	c9                   	leaveq 
  801cd0:	c3                   	retq   

0000000000801cd1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801cd1:	55                   	push   %rbp
  801cd2:	48 89 e5             	mov    %rsp,%rbp
  801cd5:	48 83 ec 10          	sub    $0x10,%rsp
  801cd9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801cdd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ce1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ce8:	00 
  801ce9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cef:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cf5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cfa:	48 89 c2             	mov    %rax,%rdx
  801cfd:	be 01 00 00 00       	mov    $0x1,%esi
  801d02:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d07:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  801d0e:	00 00 00 
  801d11:	ff d0                	callq  *%rax
}
  801d13:	c9                   	leaveq 
  801d14:	c3                   	retq   

0000000000801d15 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801d15:	55                   	push   %rbp
  801d16:	48 89 e5             	mov    %rsp,%rbp
  801d19:	48 83 ec 08          	sub    $0x8,%rsp
  801d1d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d21:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d25:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d2c:	ff ff ff 
  801d2f:	48 01 d0             	add    %rdx,%rax
  801d32:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801d36:	c9                   	leaveq 
  801d37:	c3                   	retq   

0000000000801d38 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d38:	55                   	push   %rbp
  801d39:	48 89 e5             	mov    %rsp,%rbp
  801d3c:	48 83 ec 08          	sub    $0x8,%rsp
  801d40:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801d44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d48:	48 89 c7             	mov    %rax,%rdi
  801d4b:	48 b8 15 1d 80 00 00 	movabs $0x801d15,%rax
  801d52:	00 00 00 
  801d55:	ff d0                	callq  *%rax
  801d57:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801d5d:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801d61:	c9                   	leaveq 
  801d62:	c3                   	retq   

0000000000801d63 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d63:	55                   	push   %rbp
  801d64:	48 89 e5             	mov    %rsp,%rbp
  801d67:	48 83 ec 18          	sub    $0x18,%rsp
  801d6b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d6f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d76:	eb 6b                	jmp    801de3 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801d78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d7b:	48 98                	cltq   
  801d7d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d83:	48 c1 e0 0c          	shl    $0xc,%rax
  801d87:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d8f:	48 c1 e8 15          	shr    $0x15,%rax
  801d93:	48 89 c2             	mov    %rax,%rdx
  801d96:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d9d:	01 00 00 
  801da0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801da4:	83 e0 01             	and    $0x1,%eax
  801da7:	48 85 c0             	test   %rax,%rax
  801daa:	74 21                	je     801dcd <fd_alloc+0x6a>
  801dac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801db0:	48 c1 e8 0c          	shr    $0xc,%rax
  801db4:	48 89 c2             	mov    %rax,%rdx
  801db7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801dbe:	01 00 00 
  801dc1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dc5:	83 e0 01             	and    $0x1,%eax
  801dc8:	48 85 c0             	test   %rax,%rax
  801dcb:	75 12                	jne    801ddf <fd_alloc+0x7c>
			*fd_store = fd;
  801dcd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dd1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dd5:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801dd8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ddd:	eb 1a                	jmp    801df9 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801ddf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801de3:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801de7:	7e 8f                	jle    801d78 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801de9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ded:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801df4:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801df9:	c9                   	leaveq 
  801dfa:	c3                   	retq   

0000000000801dfb <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801dfb:	55                   	push   %rbp
  801dfc:	48 89 e5             	mov    %rsp,%rbp
  801dff:	48 83 ec 20          	sub    $0x20,%rsp
  801e03:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e06:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e0a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e0e:	78 06                	js     801e16 <fd_lookup+0x1b>
  801e10:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801e14:	7e 07                	jle    801e1d <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e16:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e1b:	eb 6c                	jmp    801e89 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801e1d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e20:	48 98                	cltq   
  801e22:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e28:	48 c1 e0 0c          	shl    $0xc,%rax
  801e2c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e34:	48 c1 e8 15          	shr    $0x15,%rax
  801e38:	48 89 c2             	mov    %rax,%rdx
  801e3b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e42:	01 00 00 
  801e45:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e49:	83 e0 01             	and    $0x1,%eax
  801e4c:	48 85 c0             	test   %rax,%rax
  801e4f:	74 21                	je     801e72 <fd_lookup+0x77>
  801e51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e55:	48 c1 e8 0c          	shr    $0xc,%rax
  801e59:	48 89 c2             	mov    %rax,%rdx
  801e5c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e63:	01 00 00 
  801e66:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e6a:	83 e0 01             	and    $0x1,%eax
  801e6d:	48 85 c0             	test   %rax,%rax
  801e70:	75 07                	jne    801e79 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e72:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e77:	eb 10                	jmp    801e89 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801e79:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e7d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e81:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801e84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e89:	c9                   	leaveq 
  801e8a:	c3                   	retq   

0000000000801e8b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801e8b:	55                   	push   %rbp
  801e8c:	48 89 e5             	mov    %rsp,%rbp
  801e8f:	48 83 ec 30          	sub    $0x30,%rsp
  801e93:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e97:	89 f0                	mov    %esi,%eax
  801e99:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e9c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ea0:	48 89 c7             	mov    %rax,%rdi
  801ea3:	48 b8 15 1d 80 00 00 	movabs $0x801d15,%rax
  801eaa:	00 00 00 
  801ead:	ff d0                	callq  *%rax
  801eaf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801eb3:	48 89 d6             	mov    %rdx,%rsi
  801eb6:	89 c7                	mov    %eax,%edi
  801eb8:	48 b8 fb 1d 80 00 00 	movabs $0x801dfb,%rax
  801ebf:	00 00 00 
  801ec2:	ff d0                	callq  *%rax
  801ec4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ec7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ecb:	78 0a                	js     801ed7 <fd_close+0x4c>
	    || fd != fd2)
  801ecd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ed1:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801ed5:	74 12                	je     801ee9 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801ed7:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801edb:	74 05                	je     801ee2 <fd_close+0x57>
  801edd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ee0:	eb 05                	jmp    801ee7 <fd_close+0x5c>
  801ee2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee7:	eb 69                	jmp    801f52 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801ee9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eed:	8b 00                	mov    (%rax),%eax
  801eef:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801ef3:	48 89 d6             	mov    %rdx,%rsi
  801ef6:	89 c7                	mov    %eax,%edi
  801ef8:	48 b8 54 1f 80 00 00 	movabs $0x801f54,%rax
  801eff:	00 00 00 
  801f02:	ff d0                	callq  *%rax
  801f04:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f07:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f0b:	78 2a                	js     801f37 <fd_close+0xac>
		if (dev->dev_close)
  801f0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f11:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f15:	48 85 c0             	test   %rax,%rax
  801f18:	74 16                	je     801f30 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801f1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f1e:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f22:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f26:	48 89 d7             	mov    %rdx,%rdi
  801f29:	ff d0                	callq  *%rax
  801f2b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f2e:	eb 07                	jmp    801f37 <fd_close+0xac>
		else
			r = 0;
  801f30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f37:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f3b:	48 89 c6             	mov    %rax,%rsi
  801f3e:	bf 00 00 00 00       	mov    $0x0,%edi
  801f43:	48 b8 53 1b 80 00 00 	movabs $0x801b53,%rax
  801f4a:	00 00 00 
  801f4d:	ff d0                	callq  *%rax
	return r;
  801f4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801f52:	c9                   	leaveq 
  801f53:	c3                   	retq   

0000000000801f54 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801f54:	55                   	push   %rbp
  801f55:	48 89 e5             	mov    %rsp,%rbp
  801f58:	48 83 ec 20          	sub    $0x20,%rsp
  801f5c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f5f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801f63:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f6a:	eb 41                	jmp    801fad <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801f6c:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801f73:	00 00 00 
  801f76:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f79:	48 63 d2             	movslq %edx,%rdx
  801f7c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f80:	8b 00                	mov    (%rax),%eax
  801f82:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801f85:	75 22                	jne    801fa9 <dev_lookup+0x55>
			*dev = devtab[i];
  801f87:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801f8e:	00 00 00 
  801f91:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f94:	48 63 d2             	movslq %edx,%rdx
  801f97:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801f9b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f9f:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801fa2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa7:	eb 60                	jmp    802009 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801fa9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801fad:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801fb4:	00 00 00 
  801fb7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fba:	48 63 d2             	movslq %edx,%rdx
  801fbd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fc1:	48 85 c0             	test   %rax,%rax
  801fc4:	75 a6                	jne    801f6c <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801fc6:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801fcd:	00 00 00 
  801fd0:	48 8b 00             	mov    (%rax),%rax
  801fd3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801fd9:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fdc:	89 c6                	mov    %eax,%esi
  801fde:	48 bf f8 3f 80 00 00 	movabs $0x803ff8,%rdi
  801fe5:	00 00 00 
  801fe8:	b8 00 00 00 00       	mov    $0x0,%eax
  801fed:	48 b9 c4 05 80 00 00 	movabs $0x8005c4,%rcx
  801ff4:	00 00 00 
  801ff7:	ff d1                	callq  *%rcx
	*dev = 0;
  801ff9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ffd:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802004:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802009:	c9                   	leaveq 
  80200a:	c3                   	retq   

000000000080200b <close>:

int
close(int fdnum)
{
  80200b:	55                   	push   %rbp
  80200c:	48 89 e5             	mov    %rsp,%rbp
  80200f:	48 83 ec 20          	sub    $0x20,%rsp
  802013:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802016:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80201a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80201d:	48 89 d6             	mov    %rdx,%rsi
  802020:	89 c7                	mov    %eax,%edi
  802022:	48 b8 fb 1d 80 00 00 	movabs $0x801dfb,%rax
  802029:	00 00 00 
  80202c:	ff d0                	callq  *%rax
  80202e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802031:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802035:	79 05                	jns    80203c <close+0x31>
		return r;
  802037:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80203a:	eb 18                	jmp    802054 <close+0x49>
	else
		return fd_close(fd, 1);
  80203c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802040:	be 01 00 00 00       	mov    $0x1,%esi
  802045:	48 89 c7             	mov    %rax,%rdi
  802048:	48 b8 8b 1e 80 00 00 	movabs $0x801e8b,%rax
  80204f:	00 00 00 
  802052:	ff d0                	callq  *%rax
}
  802054:	c9                   	leaveq 
  802055:	c3                   	retq   

0000000000802056 <close_all>:

void
close_all(void)
{
  802056:	55                   	push   %rbp
  802057:	48 89 e5             	mov    %rsp,%rbp
  80205a:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80205e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802065:	eb 15                	jmp    80207c <close_all+0x26>
		close(i);
  802067:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80206a:	89 c7                	mov    %eax,%edi
  80206c:	48 b8 0b 20 80 00 00 	movabs $0x80200b,%rax
  802073:	00 00 00 
  802076:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802078:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80207c:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802080:	7e e5                	jle    802067 <close_all+0x11>
		close(i);
}
  802082:	c9                   	leaveq 
  802083:	c3                   	retq   

0000000000802084 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802084:	55                   	push   %rbp
  802085:	48 89 e5             	mov    %rsp,%rbp
  802088:	48 83 ec 40          	sub    $0x40,%rsp
  80208c:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80208f:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802092:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802096:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802099:	48 89 d6             	mov    %rdx,%rsi
  80209c:	89 c7                	mov    %eax,%edi
  80209e:	48 b8 fb 1d 80 00 00 	movabs $0x801dfb,%rax
  8020a5:	00 00 00 
  8020a8:	ff d0                	callq  *%rax
  8020aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020b1:	79 08                	jns    8020bb <dup+0x37>
		return r;
  8020b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020b6:	e9 70 01 00 00       	jmpq   80222b <dup+0x1a7>
	close(newfdnum);
  8020bb:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020be:	89 c7                	mov    %eax,%edi
  8020c0:	48 b8 0b 20 80 00 00 	movabs $0x80200b,%rax
  8020c7:	00 00 00 
  8020ca:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8020cc:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020cf:	48 98                	cltq   
  8020d1:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8020d7:	48 c1 e0 0c          	shl    $0xc,%rax
  8020db:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8020df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020e3:	48 89 c7             	mov    %rax,%rdi
  8020e6:	48 b8 38 1d 80 00 00 	movabs $0x801d38,%rax
  8020ed:	00 00 00 
  8020f0:	ff d0                	callq  *%rax
  8020f2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8020f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020fa:	48 89 c7             	mov    %rax,%rdi
  8020fd:	48 b8 38 1d 80 00 00 	movabs $0x801d38,%rax
  802104:	00 00 00 
  802107:	ff d0                	callq  *%rax
  802109:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80210d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802111:	48 c1 e8 15          	shr    $0x15,%rax
  802115:	48 89 c2             	mov    %rax,%rdx
  802118:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80211f:	01 00 00 
  802122:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802126:	83 e0 01             	and    $0x1,%eax
  802129:	48 85 c0             	test   %rax,%rax
  80212c:	74 73                	je     8021a1 <dup+0x11d>
  80212e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802132:	48 c1 e8 0c          	shr    $0xc,%rax
  802136:	48 89 c2             	mov    %rax,%rdx
  802139:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802140:	01 00 00 
  802143:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802147:	83 e0 01             	and    $0x1,%eax
  80214a:	48 85 c0             	test   %rax,%rax
  80214d:	74 52                	je     8021a1 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80214f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802153:	48 c1 e8 0c          	shr    $0xc,%rax
  802157:	48 89 c2             	mov    %rax,%rdx
  80215a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802161:	01 00 00 
  802164:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802168:	25 07 0e 00 00       	and    $0xe07,%eax
  80216d:	89 c1                	mov    %eax,%ecx
  80216f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802173:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802177:	41 89 c8             	mov    %ecx,%r8d
  80217a:	48 89 d1             	mov    %rdx,%rcx
  80217d:	ba 00 00 00 00       	mov    $0x0,%edx
  802182:	48 89 c6             	mov    %rax,%rsi
  802185:	bf 00 00 00 00       	mov    $0x0,%edi
  80218a:	48 b8 f8 1a 80 00 00 	movabs $0x801af8,%rax
  802191:	00 00 00 
  802194:	ff d0                	callq  *%rax
  802196:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802199:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80219d:	79 02                	jns    8021a1 <dup+0x11d>
			goto err;
  80219f:	eb 57                	jmp    8021f8 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8021a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021a5:	48 c1 e8 0c          	shr    $0xc,%rax
  8021a9:	48 89 c2             	mov    %rax,%rdx
  8021ac:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021b3:	01 00 00 
  8021b6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021ba:	25 07 0e 00 00       	and    $0xe07,%eax
  8021bf:	89 c1                	mov    %eax,%ecx
  8021c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021c5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021c9:	41 89 c8             	mov    %ecx,%r8d
  8021cc:	48 89 d1             	mov    %rdx,%rcx
  8021cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8021d4:	48 89 c6             	mov    %rax,%rsi
  8021d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8021dc:	48 b8 f8 1a 80 00 00 	movabs $0x801af8,%rax
  8021e3:	00 00 00 
  8021e6:	ff d0                	callq  *%rax
  8021e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021ef:	79 02                	jns    8021f3 <dup+0x16f>
		goto err;
  8021f1:	eb 05                	jmp    8021f8 <dup+0x174>

	return newfdnum;
  8021f3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8021f6:	eb 33                	jmp    80222b <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8021f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021fc:	48 89 c6             	mov    %rax,%rsi
  8021ff:	bf 00 00 00 00       	mov    $0x0,%edi
  802204:	48 b8 53 1b 80 00 00 	movabs $0x801b53,%rax
  80220b:	00 00 00 
  80220e:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802210:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802214:	48 89 c6             	mov    %rax,%rsi
  802217:	bf 00 00 00 00       	mov    $0x0,%edi
  80221c:	48 b8 53 1b 80 00 00 	movabs $0x801b53,%rax
  802223:	00 00 00 
  802226:	ff d0                	callq  *%rax
	return r;
  802228:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80222b:	c9                   	leaveq 
  80222c:	c3                   	retq   

000000000080222d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80222d:	55                   	push   %rbp
  80222e:	48 89 e5             	mov    %rsp,%rbp
  802231:	48 83 ec 40          	sub    $0x40,%rsp
  802235:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802238:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80223c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802240:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802244:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802247:	48 89 d6             	mov    %rdx,%rsi
  80224a:	89 c7                	mov    %eax,%edi
  80224c:	48 b8 fb 1d 80 00 00 	movabs $0x801dfb,%rax
  802253:	00 00 00 
  802256:	ff d0                	callq  *%rax
  802258:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80225b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80225f:	78 24                	js     802285 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802261:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802265:	8b 00                	mov    (%rax),%eax
  802267:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80226b:	48 89 d6             	mov    %rdx,%rsi
  80226e:	89 c7                	mov    %eax,%edi
  802270:	48 b8 54 1f 80 00 00 	movabs $0x801f54,%rax
  802277:	00 00 00 
  80227a:	ff d0                	callq  *%rax
  80227c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80227f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802283:	79 05                	jns    80228a <read+0x5d>
		return r;
  802285:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802288:	eb 76                	jmp    802300 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80228a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80228e:	8b 40 08             	mov    0x8(%rax),%eax
  802291:	83 e0 03             	and    $0x3,%eax
  802294:	83 f8 01             	cmp    $0x1,%eax
  802297:	75 3a                	jne    8022d3 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802299:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8022a0:	00 00 00 
  8022a3:	48 8b 00             	mov    (%rax),%rax
  8022a6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022ac:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8022af:	89 c6                	mov    %eax,%esi
  8022b1:	48 bf 17 40 80 00 00 	movabs $0x804017,%rdi
  8022b8:	00 00 00 
  8022bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c0:	48 b9 c4 05 80 00 00 	movabs $0x8005c4,%rcx
  8022c7:	00 00 00 
  8022ca:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8022cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022d1:	eb 2d                	jmp    802300 <read+0xd3>
	}
	if (!dev->dev_read)
  8022d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022d7:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022db:	48 85 c0             	test   %rax,%rax
  8022de:	75 07                	jne    8022e7 <read+0xba>
		return -E_NOT_SUPP;
  8022e0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8022e5:	eb 19                	jmp    802300 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8022e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022eb:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022ef:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8022f3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8022f7:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8022fb:	48 89 cf             	mov    %rcx,%rdi
  8022fe:	ff d0                	callq  *%rax
}
  802300:	c9                   	leaveq 
  802301:	c3                   	retq   

0000000000802302 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802302:	55                   	push   %rbp
  802303:	48 89 e5             	mov    %rsp,%rbp
  802306:	48 83 ec 30          	sub    $0x30,%rsp
  80230a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80230d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802311:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802315:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80231c:	eb 49                	jmp    802367 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80231e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802321:	48 98                	cltq   
  802323:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802327:	48 29 c2             	sub    %rax,%rdx
  80232a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80232d:	48 63 c8             	movslq %eax,%rcx
  802330:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802334:	48 01 c1             	add    %rax,%rcx
  802337:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80233a:	48 89 ce             	mov    %rcx,%rsi
  80233d:	89 c7                	mov    %eax,%edi
  80233f:	48 b8 2d 22 80 00 00 	movabs $0x80222d,%rax
  802346:	00 00 00 
  802349:	ff d0                	callq  *%rax
  80234b:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80234e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802352:	79 05                	jns    802359 <readn+0x57>
			return m;
  802354:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802357:	eb 1c                	jmp    802375 <readn+0x73>
		if (m == 0)
  802359:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80235d:	75 02                	jne    802361 <readn+0x5f>
			break;
  80235f:	eb 11                	jmp    802372 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802361:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802364:	01 45 fc             	add    %eax,-0x4(%rbp)
  802367:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80236a:	48 98                	cltq   
  80236c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802370:	72 ac                	jb     80231e <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802372:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802375:	c9                   	leaveq 
  802376:	c3                   	retq   

0000000000802377 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802377:	55                   	push   %rbp
  802378:	48 89 e5             	mov    %rsp,%rbp
  80237b:	48 83 ec 40          	sub    $0x40,%rsp
  80237f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802382:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802386:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80238a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80238e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802391:	48 89 d6             	mov    %rdx,%rsi
  802394:	89 c7                	mov    %eax,%edi
  802396:	48 b8 fb 1d 80 00 00 	movabs $0x801dfb,%rax
  80239d:	00 00 00 
  8023a0:	ff d0                	callq  *%rax
  8023a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023a9:	78 24                	js     8023cf <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023af:	8b 00                	mov    (%rax),%eax
  8023b1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023b5:	48 89 d6             	mov    %rdx,%rsi
  8023b8:	89 c7                	mov    %eax,%edi
  8023ba:	48 b8 54 1f 80 00 00 	movabs $0x801f54,%rax
  8023c1:	00 00 00 
  8023c4:	ff d0                	callq  *%rax
  8023c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023cd:	79 05                	jns    8023d4 <write+0x5d>
		return r;
  8023cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023d2:	eb 75                	jmp    802449 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8023d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023d8:	8b 40 08             	mov    0x8(%rax),%eax
  8023db:	83 e0 03             	and    $0x3,%eax
  8023de:	85 c0                	test   %eax,%eax
  8023e0:	75 3a                	jne    80241c <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8023e2:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8023e9:	00 00 00 
  8023ec:	48 8b 00             	mov    (%rax),%rax
  8023ef:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023f5:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023f8:	89 c6                	mov    %eax,%esi
  8023fa:	48 bf 33 40 80 00 00 	movabs $0x804033,%rdi
  802401:	00 00 00 
  802404:	b8 00 00 00 00       	mov    $0x0,%eax
  802409:	48 b9 c4 05 80 00 00 	movabs $0x8005c4,%rcx
  802410:	00 00 00 
  802413:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802415:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80241a:	eb 2d                	jmp    802449 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80241c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802420:	48 8b 40 18          	mov    0x18(%rax),%rax
  802424:	48 85 c0             	test   %rax,%rax
  802427:	75 07                	jne    802430 <write+0xb9>
		return -E_NOT_SUPP;
  802429:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80242e:	eb 19                	jmp    802449 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802430:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802434:	48 8b 40 18          	mov    0x18(%rax),%rax
  802438:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80243c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802440:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802444:	48 89 cf             	mov    %rcx,%rdi
  802447:	ff d0                	callq  *%rax
}
  802449:	c9                   	leaveq 
  80244a:	c3                   	retq   

000000000080244b <seek>:

int
seek(int fdnum, off_t offset)
{
  80244b:	55                   	push   %rbp
  80244c:	48 89 e5             	mov    %rsp,%rbp
  80244f:	48 83 ec 18          	sub    $0x18,%rsp
  802453:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802456:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802459:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80245d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802460:	48 89 d6             	mov    %rdx,%rsi
  802463:	89 c7                	mov    %eax,%edi
  802465:	48 b8 fb 1d 80 00 00 	movabs $0x801dfb,%rax
  80246c:	00 00 00 
  80246f:	ff d0                	callq  *%rax
  802471:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802474:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802478:	79 05                	jns    80247f <seek+0x34>
		return r;
  80247a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80247d:	eb 0f                	jmp    80248e <seek+0x43>
	fd->fd_offset = offset;
  80247f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802483:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802486:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802489:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80248e:	c9                   	leaveq 
  80248f:	c3                   	retq   

0000000000802490 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802490:	55                   	push   %rbp
  802491:	48 89 e5             	mov    %rsp,%rbp
  802494:	48 83 ec 30          	sub    $0x30,%rsp
  802498:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80249b:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80249e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024a2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024a5:	48 89 d6             	mov    %rdx,%rsi
  8024a8:	89 c7                	mov    %eax,%edi
  8024aa:	48 b8 fb 1d 80 00 00 	movabs $0x801dfb,%rax
  8024b1:	00 00 00 
  8024b4:	ff d0                	callq  *%rax
  8024b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024bd:	78 24                	js     8024e3 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024c3:	8b 00                	mov    (%rax),%eax
  8024c5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024c9:	48 89 d6             	mov    %rdx,%rsi
  8024cc:	89 c7                	mov    %eax,%edi
  8024ce:	48 b8 54 1f 80 00 00 	movabs $0x801f54,%rax
  8024d5:	00 00 00 
  8024d8:	ff d0                	callq  *%rax
  8024da:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024e1:	79 05                	jns    8024e8 <ftruncate+0x58>
		return r;
  8024e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024e6:	eb 72                	jmp    80255a <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8024e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024ec:	8b 40 08             	mov    0x8(%rax),%eax
  8024ef:	83 e0 03             	and    $0x3,%eax
  8024f2:	85 c0                	test   %eax,%eax
  8024f4:	75 3a                	jne    802530 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8024f6:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8024fd:	00 00 00 
  802500:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802503:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802509:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80250c:	89 c6                	mov    %eax,%esi
  80250e:	48 bf 50 40 80 00 00 	movabs $0x804050,%rdi
  802515:	00 00 00 
  802518:	b8 00 00 00 00       	mov    $0x0,%eax
  80251d:	48 b9 c4 05 80 00 00 	movabs $0x8005c4,%rcx
  802524:	00 00 00 
  802527:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802529:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80252e:	eb 2a                	jmp    80255a <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802530:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802534:	48 8b 40 30          	mov    0x30(%rax),%rax
  802538:	48 85 c0             	test   %rax,%rax
  80253b:	75 07                	jne    802544 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80253d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802542:	eb 16                	jmp    80255a <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802544:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802548:	48 8b 40 30          	mov    0x30(%rax),%rax
  80254c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802550:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802553:	89 ce                	mov    %ecx,%esi
  802555:	48 89 d7             	mov    %rdx,%rdi
  802558:	ff d0                	callq  *%rax
}
  80255a:	c9                   	leaveq 
  80255b:	c3                   	retq   

000000000080255c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80255c:	55                   	push   %rbp
  80255d:	48 89 e5             	mov    %rsp,%rbp
  802560:	48 83 ec 30          	sub    $0x30,%rsp
  802564:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802567:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80256b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80256f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802572:	48 89 d6             	mov    %rdx,%rsi
  802575:	89 c7                	mov    %eax,%edi
  802577:	48 b8 fb 1d 80 00 00 	movabs $0x801dfb,%rax
  80257e:	00 00 00 
  802581:	ff d0                	callq  *%rax
  802583:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802586:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80258a:	78 24                	js     8025b0 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80258c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802590:	8b 00                	mov    (%rax),%eax
  802592:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802596:	48 89 d6             	mov    %rdx,%rsi
  802599:	89 c7                	mov    %eax,%edi
  80259b:	48 b8 54 1f 80 00 00 	movabs $0x801f54,%rax
  8025a2:	00 00 00 
  8025a5:	ff d0                	callq  *%rax
  8025a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025ae:	79 05                	jns    8025b5 <fstat+0x59>
		return r;
  8025b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025b3:	eb 5e                	jmp    802613 <fstat+0xb7>
	if (!dev->dev_stat)
  8025b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025b9:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025bd:	48 85 c0             	test   %rax,%rax
  8025c0:	75 07                	jne    8025c9 <fstat+0x6d>
		return -E_NOT_SUPP;
  8025c2:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025c7:	eb 4a                	jmp    802613 <fstat+0xb7>
	stat->st_name[0] = 0;
  8025c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025cd:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8025d0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025d4:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8025db:	00 00 00 
	stat->st_isdir = 0;
  8025de:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025e2:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8025e9:	00 00 00 
	stat->st_dev = dev;
  8025ec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025f0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025f4:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8025fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ff:	48 8b 40 28          	mov    0x28(%rax),%rax
  802603:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802607:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80260b:	48 89 ce             	mov    %rcx,%rsi
  80260e:	48 89 d7             	mov    %rdx,%rdi
  802611:	ff d0                	callq  *%rax
}
  802613:	c9                   	leaveq 
  802614:	c3                   	retq   

0000000000802615 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802615:	55                   	push   %rbp
  802616:	48 89 e5             	mov    %rsp,%rbp
  802619:	48 83 ec 20          	sub    $0x20,%rsp
  80261d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802621:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802625:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802629:	be 00 00 00 00       	mov    $0x0,%esi
  80262e:	48 89 c7             	mov    %rax,%rdi
  802631:	48 b8 03 27 80 00 00 	movabs $0x802703,%rax
  802638:	00 00 00 
  80263b:	ff d0                	callq  *%rax
  80263d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802640:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802644:	79 05                	jns    80264b <stat+0x36>
		return fd;
  802646:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802649:	eb 2f                	jmp    80267a <stat+0x65>
	r = fstat(fd, stat);
  80264b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80264f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802652:	48 89 d6             	mov    %rdx,%rsi
  802655:	89 c7                	mov    %eax,%edi
  802657:	48 b8 5c 25 80 00 00 	movabs $0x80255c,%rax
  80265e:	00 00 00 
  802661:	ff d0                	callq  *%rax
  802663:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802666:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802669:	89 c7                	mov    %eax,%edi
  80266b:	48 b8 0b 20 80 00 00 	movabs $0x80200b,%rax
  802672:	00 00 00 
  802675:	ff d0                	callq  *%rax
	return r;
  802677:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80267a:	c9                   	leaveq 
  80267b:	c3                   	retq   

000000000080267c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80267c:	55                   	push   %rbp
  80267d:	48 89 e5             	mov    %rsp,%rbp
  802680:	48 83 ec 10          	sub    $0x10,%rsp
  802684:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802687:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80268b:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  802692:	00 00 00 
  802695:	8b 00                	mov    (%rax),%eax
  802697:	85 c0                	test   %eax,%eax
  802699:	75 1d                	jne    8026b8 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80269b:	bf 01 00 00 00       	mov    $0x1,%edi
  8026a0:	48 b8 49 39 80 00 00 	movabs $0x803949,%rax
  8026a7:	00 00 00 
  8026aa:	ff d0                	callq  *%rax
  8026ac:	48 ba 04 60 80 00 00 	movabs $0x806004,%rdx
  8026b3:	00 00 00 
  8026b6:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8026b8:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  8026bf:	00 00 00 
  8026c2:	8b 00                	mov    (%rax),%eax
  8026c4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8026c7:	b9 07 00 00 00       	mov    $0x7,%ecx
  8026cc:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8026d3:	00 00 00 
  8026d6:	89 c7                	mov    %eax,%edi
  8026d8:	48 b8 ac 38 80 00 00 	movabs $0x8038ac,%rax
  8026df:	00 00 00 
  8026e2:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8026e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8026ed:	48 89 c6             	mov    %rax,%rsi
  8026f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8026f5:	48 b8 e6 37 80 00 00 	movabs $0x8037e6,%rax
  8026fc:	00 00 00 
  8026ff:	ff d0                	callq  *%rax
}
  802701:	c9                   	leaveq 
  802702:	c3                   	retq   

0000000000802703 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802703:	55                   	push   %rbp
  802704:	48 89 e5             	mov    %rsp,%rbp
  802707:	48 83 ec 20          	sub    $0x20,%rsp
  80270b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80270f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  802712:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802716:	48 89 c7             	mov    %rax,%rdi
  802719:	48 b8 0d 11 80 00 00 	movabs $0x80110d,%rax
  802720:	00 00 00 
  802723:	ff d0                	callq  *%rax
  802725:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80272a:	7e 0a                	jle    802736 <open+0x33>
  80272c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802731:	e9 a5 00 00 00       	jmpq   8027db <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  802736:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80273a:	48 89 c7             	mov    %rax,%rdi
  80273d:	48 b8 63 1d 80 00 00 	movabs $0x801d63,%rax
  802744:	00 00 00 
  802747:	ff d0                	callq  *%rax
  802749:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80274c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802750:	79 08                	jns    80275a <open+0x57>
		return r;
  802752:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802755:	e9 81 00 00 00       	jmpq   8027db <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  80275a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802761:	00 00 00 
  802764:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802767:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  80276d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802771:	48 89 c6             	mov    %rax,%rsi
  802774:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  80277b:	00 00 00 
  80277e:	48 b8 79 11 80 00 00 	movabs $0x801179,%rax
  802785:	00 00 00 
  802788:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  80278a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80278e:	48 89 c6             	mov    %rax,%rsi
  802791:	bf 01 00 00 00       	mov    $0x1,%edi
  802796:	48 b8 7c 26 80 00 00 	movabs $0x80267c,%rax
  80279d:	00 00 00 
  8027a0:	ff d0                	callq  *%rax
  8027a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027a9:	79 1d                	jns    8027c8 <open+0xc5>
		fd_close(fd, 0);
  8027ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027af:	be 00 00 00 00       	mov    $0x0,%esi
  8027b4:	48 89 c7             	mov    %rax,%rdi
  8027b7:	48 b8 8b 1e 80 00 00 	movabs $0x801e8b,%rax
  8027be:	00 00 00 
  8027c1:	ff d0                	callq  *%rax
		return r;
  8027c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027c6:	eb 13                	jmp    8027db <open+0xd8>
	}
	return fd2num(fd);
  8027c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027cc:	48 89 c7             	mov    %rax,%rdi
  8027cf:	48 b8 15 1d 80 00 00 	movabs $0x801d15,%rax
  8027d6:	00 00 00 
  8027d9:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  8027db:	c9                   	leaveq 
  8027dc:	c3                   	retq   

00000000008027dd <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8027dd:	55                   	push   %rbp
  8027de:	48 89 e5             	mov    %rsp,%rbp
  8027e1:	48 83 ec 10          	sub    $0x10,%rsp
  8027e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8027e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027ed:	8b 50 0c             	mov    0xc(%rax),%edx
  8027f0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027f7:	00 00 00 
  8027fa:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8027fc:	be 00 00 00 00       	mov    $0x0,%esi
  802801:	bf 06 00 00 00       	mov    $0x6,%edi
  802806:	48 b8 7c 26 80 00 00 	movabs $0x80267c,%rax
  80280d:	00 00 00 
  802810:	ff d0                	callq  *%rax
}
  802812:	c9                   	leaveq 
  802813:	c3                   	retq   

0000000000802814 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802814:	55                   	push   %rbp
  802815:	48 89 e5             	mov    %rsp,%rbp
  802818:	48 83 ec 30          	sub    $0x30,%rsp
  80281c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802820:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802824:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802828:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80282c:	8b 50 0c             	mov    0xc(%rax),%edx
  80282f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802836:	00 00 00 
  802839:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80283b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802842:	00 00 00 
  802845:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802849:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  80284d:	be 00 00 00 00       	mov    $0x0,%esi
  802852:	bf 03 00 00 00       	mov    $0x3,%edi
  802857:	48 b8 7c 26 80 00 00 	movabs $0x80267c,%rax
  80285e:	00 00 00 
  802861:	ff d0                	callq  *%rax
  802863:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802866:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80286a:	79 05                	jns    802871 <devfile_read+0x5d>
		return r;
  80286c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80286f:	eb 26                	jmp    802897 <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  802871:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802874:	48 63 d0             	movslq %eax,%rdx
  802877:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80287b:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802882:	00 00 00 
  802885:	48 89 c7             	mov    %rax,%rdi
  802888:	48 b8 b4 15 80 00 00 	movabs $0x8015b4,%rax
  80288f:	00 00 00 
  802892:	ff d0                	callq  *%rax
	return r;
  802894:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802897:	c9                   	leaveq 
  802898:	c3                   	retq   

0000000000802899 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802899:	55                   	push   %rbp
  80289a:	48 89 e5             	mov    %rsp,%rbp
  80289d:	48 83 ec 30          	sub    $0x30,%rsp
  8028a1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028a5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028a9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  8028ad:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  8028b4:	00 
	n = n > max ? max : n;
  8028b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028b9:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8028bd:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  8028c2:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8028c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ca:	8b 50 0c             	mov    0xc(%rax),%edx
  8028cd:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028d4:	00 00 00 
  8028d7:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8028d9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028e0:	00 00 00 
  8028e3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028e7:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8028eb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028f3:	48 89 c6             	mov    %rax,%rsi
  8028f6:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  8028fd:	00 00 00 
  802900:	48 b8 b4 15 80 00 00 	movabs $0x8015b4,%rax
  802907:	00 00 00 
  80290a:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  80290c:	be 00 00 00 00       	mov    $0x0,%esi
  802911:	bf 04 00 00 00       	mov    $0x4,%edi
  802916:	48 b8 7c 26 80 00 00 	movabs $0x80267c,%rax
  80291d:	00 00 00 
  802920:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  802922:	c9                   	leaveq 
  802923:	c3                   	retq   

0000000000802924 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802924:	55                   	push   %rbp
  802925:	48 89 e5             	mov    %rsp,%rbp
  802928:	48 83 ec 20          	sub    $0x20,%rsp
  80292c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802930:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802934:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802938:	8b 50 0c             	mov    0xc(%rax),%edx
  80293b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802942:	00 00 00 
  802945:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802947:	be 00 00 00 00       	mov    $0x0,%esi
  80294c:	bf 05 00 00 00       	mov    $0x5,%edi
  802951:	48 b8 7c 26 80 00 00 	movabs $0x80267c,%rax
  802958:	00 00 00 
  80295b:	ff d0                	callq  *%rax
  80295d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802960:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802964:	79 05                	jns    80296b <devfile_stat+0x47>
		return r;
  802966:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802969:	eb 56                	jmp    8029c1 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80296b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80296f:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802976:	00 00 00 
  802979:	48 89 c7             	mov    %rax,%rdi
  80297c:	48 b8 79 11 80 00 00 	movabs $0x801179,%rax
  802983:	00 00 00 
  802986:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802988:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80298f:	00 00 00 
  802992:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802998:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80299c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8029a2:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029a9:	00 00 00 
  8029ac:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8029b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029b6:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8029bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029c1:	c9                   	leaveq 
  8029c2:	c3                   	retq   

00000000008029c3 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8029c3:	55                   	push   %rbp
  8029c4:	48 89 e5             	mov    %rsp,%rbp
  8029c7:	48 83 ec 10          	sub    $0x10,%rsp
  8029cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8029cf:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8029d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029d6:	8b 50 0c             	mov    0xc(%rax),%edx
  8029d9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029e0:	00 00 00 
  8029e3:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8029e5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029ec:	00 00 00 
  8029ef:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8029f2:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8029f5:	be 00 00 00 00       	mov    $0x0,%esi
  8029fa:	bf 02 00 00 00       	mov    $0x2,%edi
  8029ff:	48 b8 7c 26 80 00 00 	movabs $0x80267c,%rax
  802a06:	00 00 00 
  802a09:	ff d0                	callq  *%rax
}
  802a0b:	c9                   	leaveq 
  802a0c:	c3                   	retq   

0000000000802a0d <remove>:

// Delete a file
int
remove(const char *path)
{
  802a0d:	55                   	push   %rbp
  802a0e:	48 89 e5             	mov    %rsp,%rbp
  802a11:	48 83 ec 10          	sub    $0x10,%rsp
  802a15:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802a19:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a1d:	48 89 c7             	mov    %rax,%rdi
  802a20:	48 b8 0d 11 80 00 00 	movabs $0x80110d,%rax
  802a27:	00 00 00 
  802a2a:	ff d0                	callq  *%rax
  802a2c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802a31:	7e 07                	jle    802a3a <remove+0x2d>
		return -E_BAD_PATH;
  802a33:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802a38:	eb 33                	jmp    802a6d <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802a3a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a3e:	48 89 c6             	mov    %rax,%rsi
  802a41:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802a48:	00 00 00 
  802a4b:	48 b8 79 11 80 00 00 	movabs $0x801179,%rax
  802a52:	00 00 00 
  802a55:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802a57:	be 00 00 00 00       	mov    $0x0,%esi
  802a5c:	bf 07 00 00 00       	mov    $0x7,%edi
  802a61:	48 b8 7c 26 80 00 00 	movabs $0x80267c,%rax
  802a68:	00 00 00 
  802a6b:	ff d0                	callq  *%rax
}
  802a6d:	c9                   	leaveq 
  802a6e:	c3                   	retq   

0000000000802a6f <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802a6f:	55                   	push   %rbp
  802a70:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802a73:	be 00 00 00 00       	mov    $0x0,%esi
  802a78:	bf 08 00 00 00       	mov    $0x8,%edi
  802a7d:	48 b8 7c 26 80 00 00 	movabs $0x80267c,%rax
  802a84:	00 00 00 
  802a87:	ff d0                	callq  *%rax
}
  802a89:	5d                   	pop    %rbp
  802a8a:	c3                   	retq   

0000000000802a8b <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802a8b:	55                   	push   %rbp
  802a8c:	48 89 e5             	mov    %rsp,%rbp
  802a8f:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802a96:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802a9d:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802aa4:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802aab:	be 00 00 00 00       	mov    $0x0,%esi
  802ab0:	48 89 c7             	mov    %rax,%rdi
  802ab3:	48 b8 03 27 80 00 00 	movabs $0x802703,%rax
  802aba:	00 00 00 
  802abd:	ff d0                	callq  *%rax
  802abf:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802ac2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ac6:	79 28                	jns    802af0 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802ac8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802acb:	89 c6                	mov    %eax,%esi
  802acd:	48 bf 76 40 80 00 00 	movabs $0x804076,%rdi
  802ad4:	00 00 00 
  802ad7:	b8 00 00 00 00       	mov    $0x0,%eax
  802adc:	48 ba c4 05 80 00 00 	movabs $0x8005c4,%rdx
  802ae3:	00 00 00 
  802ae6:	ff d2                	callq  *%rdx
		return fd_src;
  802ae8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aeb:	e9 74 01 00 00       	jmpq   802c64 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802af0:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802af7:	be 01 01 00 00       	mov    $0x101,%esi
  802afc:	48 89 c7             	mov    %rax,%rdi
  802aff:	48 b8 03 27 80 00 00 	movabs $0x802703,%rax
  802b06:	00 00 00 
  802b09:	ff d0                	callq  *%rax
  802b0b:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802b0e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b12:	79 39                	jns    802b4d <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802b14:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b17:	89 c6                	mov    %eax,%esi
  802b19:	48 bf 8c 40 80 00 00 	movabs $0x80408c,%rdi
  802b20:	00 00 00 
  802b23:	b8 00 00 00 00       	mov    $0x0,%eax
  802b28:	48 ba c4 05 80 00 00 	movabs $0x8005c4,%rdx
  802b2f:	00 00 00 
  802b32:	ff d2                	callq  *%rdx
		close(fd_src);
  802b34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b37:	89 c7                	mov    %eax,%edi
  802b39:	48 b8 0b 20 80 00 00 	movabs $0x80200b,%rax
  802b40:	00 00 00 
  802b43:	ff d0                	callq  *%rax
		return fd_dest;
  802b45:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b48:	e9 17 01 00 00       	jmpq   802c64 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802b4d:	eb 74                	jmp    802bc3 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802b4f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802b52:	48 63 d0             	movslq %eax,%rdx
  802b55:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802b5c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b5f:	48 89 ce             	mov    %rcx,%rsi
  802b62:	89 c7                	mov    %eax,%edi
  802b64:	48 b8 77 23 80 00 00 	movabs $0x802377,%rax
  802b6b:	00 00 00 
  802b6e:	ff d0                	callq  *%rax
  802b70:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802b73:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802b77:	79 4a                	jns    802bc3 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802b79:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802b7c:	89 c6                	mov    %eax,%esi
  802b7e:	48 bf a6 40 80 00 00 	movabs $0x8040a6,%rdi
  802b85:	00 00 00 
  802b88:	b8 00 00 00 00       	mov    $0x0,%eax
  802b8d:	48 ba c4 05 80 00 00 	movabs $0x8005c4,%rdx
  802b94:	00 00 00 
  802b97:	ff d2                	callq  *%rdx
			close(fd_src);
  802b99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b9c:	89 c7                	mov    %eax,%edi
  802b9e:	48 b8 0b 20 80 00 00 	movabs $0x80200b,%rax
  802ba5:	00 00 00 
  802ba8:	ff d0                	callq  *%rax
			close(fd_dest);
  802baa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bad:	89 c7                	mov    %eax,%edi
  802baf:	48 b8 0b 20 80 00 00 	movabs $0x80200b,%rax
  802bb6:	00 00 00 
  802bb9:	ff d0                	callq  *%rax
			return write_size;
  802bbb:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802bbe:	e9 a1 00 00 00       	jmpq   802c64 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802bc3:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802bca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bcd:	ba 00 02 00 00       	mov    $0x200,%edx
  802bd2:	48 89 ce             	mov    %rcx,%rsi
  802bd5:	89 c7                	mov    %eax,%edi
  802bd7:	48 b8 2d 22 80 00 00 	movabs $0x80222d,%rax
  802bde:	00 00 00 
  802be1:	ff d0                	callq  *%rax
  802be3:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802be6:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802bea:	0f 8f 5f ff ff ff    	jg     802b4f <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802bf0:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802bf4:	79 47                	jns    802c3d <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802bf6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802bf9:	89 c6                	mov    %eax,%esi
  802bfb:	48 bf b9 40 80 00 00 	movabs $0x8040b9,%rdi
  802c02:	00 00 00 
  802c05:	b8 00 00 00 00       	mov    $0x0,%eax
  802c0a:	48 ba c4 05 80 00 00 	movabs $0x8005c4,%rdx
  802c11:	00 00 00 
  802c14:	ff d2                	callq  *%rdx
		close(fd_src);
  802c16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c19:	89 c7                	mov    %eax,%edi
  802c1b:	48 b8 0b 20 80 00 00 	movabs $0x80200b,%rax
  802c22:	00 00 00 
  802c25:	ff d0                	callq  *%rax
		close(fd_dest);
  802c27:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c2a:	89 c7                	mov    %eax,%edi
  802c2c:	48 b8 0b 20 80 00 00 	movabs $0x80200b,%rax
  802c33:	00 00 00 
  802c36:	ff d0                	callq  *%rax
		return read_size;
  802c38:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c3b:	eb 27                	jmp    802c64 <copy+0x1d9>
	}
	close(fd_src);
  802c3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c40:	89 c7                	mov    %eax,%edi
  802c42:	48 b8 0b 20 80 00 00 	movabs $0x80200b,%rax
  802c49:	00 00 00 
  802c4c:	ff d0                	callq  *%rax
	close(fd_dest);
  802c4e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c51:	89 c7                	mov    %eax,%edi
  802c53:	48 b8 0b 20 80 00 00 	movabs $0x80200b,%rax
  802c5a:	00 00 00 
  802c5d:	ff d0                	callq  *%rax
	return 0;
  802c5f:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802c64:	c9                   	leaveq 
  802c65:	c3                   	retq   

0000000000802c66 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802c66:	55                   	push   %rbp
  802c67:	48 89 e5             	mov    %rsp,%rbp
  802c6a:	48 83 ec 20          	sub    $0x20,%rsp
  802c6e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802c72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c76:	8b 40 0c             	mov    0xc(%rax),%eax
  802c79:	85 c0                	test   %eax,%eax
  802c7b:	7e 67                	jle    802ce4 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802c7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c81:	8b 40 04             	mov    0x4(%rax),%eax
  802c84:	48 63 d0             	movslq %eax,%rdx
  802c87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c8b:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802c8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c93:	8b 00                	mov    (%rax),%eax
  802c95:	48 89 ce             	mov    %rcx,%rsi
  802c98:	89 c7                	mov    %eax,%edi
  802c9a:	48 b8 77 23 80 00 00 	movabs $0x802377,%rax
  802ca1:	00 00 00 
  802ca4:	ff d0                	callq  *%rax
  802ca6:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802ca9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cad:	7e 13                	jle    802cc2 <writebuf+0x5c>
			b->result += result;
  802caf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cb3:	8b 50 08             	mov    0x8(%rax),%edx
  802cb6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cb9:	01 c2                	add    %eax,%edx
  802cbb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cbf:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802cc2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cc6:	8b 40 04             	mov    0x4(%rax),%eax
  802cc9:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802ccc:	74 16                	je     802ce4 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802cce:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cd7:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802cdb:	89 c2                	mov    %eax,%edx
  802cdd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ce1:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802ce4:	c9                   	leaveq 
  802ce5:	c3                   	retq   

0000000000802ce6 <putch>:

static void
putch(int ch, void *thunk)
{
  802ce6:	55                   	push   %rbp
  802ce7:	48 89 e5             	mov    %rsp,%rbp
  802cea:	48 83 ec 20          	sub    $0x20,%rsp
  802cee:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802cf1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802cf5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cf9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802cfd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d01:	8b 40 04             	mov    0x4(%rax),%eax
  802d04:	8d 48 01             	lea    0x1(%rax),%ecx
  802d07:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802d0b:	89 4a 04             	mov    %ecx,0x4(%rdx)
  802d0e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802d11:	89 d1                	mov    %edx,%ecx
  802d13:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802d17:	48 98                	cltq   
  802d19:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  802d1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d21:	8b 40 04             	mov    0x4(%rax),%eax
  802d24:	3d 00 01 00 00       	cmp    $0x100,%eax
  802d29:	75 1e                	jne    802d49 <putch+0x63>
		writebuf(b);
  802d2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d2f:	48 89 c7             	mov    %rax,%rdi
  802d32:	48 b8 66 2c 80 00 00 	movabs $0x802c66,%rax
  802d39:	00 00 00 
  802d3c:	ff d0                	callq  *%rax
		b->idx = 0;
  802d3e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d42:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802d49:	c9                   	leaveq 
  802d4a:	c3                   	retq   

0000000000802d4b <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802d4b:	55                   	push   %rbp
  802d4c:	48 89 e5             	mov    %rsp,%rbp
  802d4f:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802d56:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802d5c:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802d63:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802d6a:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802d70:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802d76:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802d7d:	00 00 00 
	b.result = 0;
  802d80:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802d87:	00 00 00 
	b.error = 1;
  802d8a:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802d91:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802d94:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802d9b:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802da2:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802da9:	48 89 c6             	mov    %rax,%rsi
  802dac:	48 bf e6 2c 80 00 00 	movabs $0x802ce6,%rdi
  802db3:	00 00 00 
  802db6:	48 b8 77 09 80 00 00 	movabs $0x800977,%rax
  802dbd:	00 00 00 
  802dc0:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802dc2:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802dc8:	85 c0                	test   %eax,%eax
  802dca:	7e 16                	jle    802de2 <vfprintf+0x97>
		writebuf(&b);
  802dcc:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802dd3:	48 89 c7             	mov    %rax,%rdi
  802dd6:	48 b8 66 2c 80 00 00 	movabs $0x802c66,%rax
  802ddd:	00 00 00 
  802de0:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  802de2:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802de8:	85 c0                	test   %eax,%eax
  802dea:	74 08                	je     802df4 <vfprintf+0xa9>
  802dec:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802df2:	eb 06                	jmp    802dfa <vfprintf+0xaf>
  802df4:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  802dfa:	c9                   	leaveq 
  802dfb:	c3                   	retq   

0000000000802dfc <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802dfc:	55                   	push   %rbp
  802dfd:	48 89 e5             	mov    %rsp,%rbp
  802e00:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802e07:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  802e0d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802e14:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802e1b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802e22:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802e29:	84 c0                	test   %al,%al
  802e2b:	74 20                	je     802e4d <fprintf+0x51>
  802e2d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802e31:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802e35:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802e39:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802e3d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802e41:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802e45:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802e49:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802e4d:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802e54:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  802e5b:	00 00 00 
  802e5e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802e65:	00 00 00 
  802e68:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802e6c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802e73:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802e7a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  802e81:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802e88:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  802e8f:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802e95:	48 89 ce             	mov    %rcx,%rsi
  802e98:	89 c7                	mov    %eax,%edi
  802e9a:	48 b8 4b 2d 80 00 00 	movabs $0x802d4b,%rax
  802ea1:	00 00 00 
  802ea4:	ff d0                	callq  *%rax
  802ea6:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802eac:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802eb2:	c9                   	leaveq 
  802eb3:	c3                   	retq   

0000000000802eb4 <printf>:

int
printf(const char *fmt, ...)
{
  802eb4:	55                   	push   %rbp
  802eb5:	48 89 e5             	mov    %rsp,%rbp
  802eb8:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802ebf:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802ec6:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802ecd:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802ed4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802edb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802ee2:	84 c0                	test   %al,%al
  802ee4:	74 20                	je     802f06 <printf+0x52>
  802ee6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802eea:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802eee:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802ef2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802ef6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802efa:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802efe:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802f02:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802f06:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802f0d:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802f14:	00 00 00 
  802f17:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802f1e:	00 00 00 
  802f21:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802f25:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802f2c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802f33:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  802f3a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802f41:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802f48:	48 89 c6             	mov    %rax,%rsi
  802f4b:	bf 01 00 00 00       	mov    $0x1,%edi
  802f50:	48 b8 4b 2d 80 00 00 	movabs $0x802d4b,%rax
  802f57:	00 00 00 
  802f5a:	ff d0                	callq  *%rax
  802f5c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802f62:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802f68:	c9                   	leaveq 
  802f69:	c3                   	retq   

0000000000802f6a <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802f6a:	55                   	push   %rbp
  802f6b:	48 89 e5             	mov    %rsp,%rbp
  802f6e:	53                   	push   %rbx
  802f6f:	48 83 ec 38          	sub    $0x38,%rsp
  802f73:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802f77:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802f7b:	48 89 c7             	mov    %rax,%rdi
  802f7e:	48 b8 63 1d 80 00 00 	movabs $0x801d63,%rax
  802f85:	00 00 00 
  802f88:	ff d0                	callq  *%rax
  802f8a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f8d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f91:	0f 88 bf 01 00 00    	js     803156 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f97:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f9b:	ba 07 04 00 00       	mov    $0x407,%edx
  802fa0:	48 89 c6             	mov    %rax,%rsi
  802fa3:	bf 00 00 00 00       	mov    $0x0,%edi
  802fa8:	48 b8 a8 1a 80 00 00 	movabs $0x801aa8,%rax
  802faf:	00 00 00 
  802fb2:	ff d0                	callq  *%rax
  802fb4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802fb7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802fbb:	0f 88 95 01 00 00    	js     803156 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802fc1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802fc5:	48 89 c7             	mov    %rax,%rdi
  802fc8:	48 b8 63 1d 80 00 00 	movabs $0x801d63,%rax
  802fcf:	00 00 00 
  802fd2:	ff d0                	callq  *%rax
  802fd4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802fd7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802fdb:	0f 88 5d 01 00 00    	js     80313e <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802fe1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fe5:	ba 07 04 00 00       	mov    $0x407,%edx
  802fea:	48 89 c6             	mov    %rax,%rsi
  802fed:	bf 00 00 00 00       	mov    $0x0,%edi
  802ff2:	48 b8 a8 1a 80 00 00 	movabs $0x801aa8,%rax
  802ff9:	00 00 00 
  802ffc:	ff d0                	callq  *%rax
  802ffe:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803001:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803005:	0f 88 33 01 00 00    	js     80313e <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80300b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80300f:	48 89 c7             	mov    %rax,%rdi
  803012:	48 b8 38 1d 80 00 00 	movabs $0x801d38,%rax
  803019:	00 00 00 
  80301c:	ff d0                	callq  *%rax
  80301e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803022:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803026:	ba 07 04 00 00       	mov    $0x407,%edx
  80302b:	48 89 c6             	mov    %rax,%rsi
  80302e:	bf 00 00 00 00       	mov    $0x0,%edi
  803033:	48 b8 a8 1a 80 00 00 	movabs $0x801aa8,%rax
  80303a:	00 00 00 
  80303d:	ff d0                	callq  *%rax
  80303f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803042:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803046:	79 05                	jns    80304d <pipe+0xe3>
		goto err2;
  803048:	e9 d9 00 00 00       	jmpq   803126 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80304d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803051:	48 89 c7             	mov    %rax,%rdi
  803054:	48 b8 38 1d 80 00 00 	movabs $0x801d38,%rax
  80305b:	00 00 00 
  80305e:	ff d0                	callq  *%rax
  803060:	48 89 c2             	mov    %rax,%rdx
  803063:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803067:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80306d:	48 89 d1             	mov    %rdx,%rcx
  803070:	ba 00 00 00 00       	mov    $0x0,%edx
  803075:	48 89 c6             	mov    %rax,%rsi
  803078:	bf 00 00 00 00       	mov    $0x0,%edi
  80307d:	48 b8 f8 1a 80 00 00 	movabs $0x801af8,%rax
  803084:	00 00 00 
  803087:	ff d0                	callq  *%rax
  803089:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80308c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803090:	79 1b                	jns    8030ad <pipe+0x143>
		goto err3;
  803092:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803093:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803097:	48 89 c6             	mov    %rax,%rsi
  80309a:	bf 00 00 00 00       	mov    $0x0,%edi
  80309f:	48 b8 53 1b 80 00 00 	movabs $0x801b53,%rax
  8030a6:	00 00 00 
  8030a9:	ff d0                	callq  *%rax
  8030ab:	eb 79                	jmp    803126 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8030ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030b1:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  8030b8:	00 00 00 
  8030bb:	8b 12                	mov    (%rdx),%edx
  8030bd:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8030bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030c3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8030ca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030ce:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  8030d5:	00 00 00 
  8030d8:	8b 12                	mov    (%rdx),%edx
  8030da:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8030dc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030e0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8030e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030eb:	48 89 c7             	mov    %rax,%rdi
  8030ee:	48 b8 15 1d 80 00 00 	movabs $0x801d15,%rax
  8030f5:	00 00 00 
  8030f8:	ff d0                	callq  *%rax
  8030fa:	89 c2                	mov    %eax,%edx
  8030fc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803100:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803102:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803106:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80310a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80310e:	48 89 c7             	mov    %rax,%rdi
  803111:	48 b8 15 1d 80 00 00 	movabs $0x801d15,%rax
  803118:	00 00 00 
  80311b:	ff d0                	callq  *%rax
  80311d:	89 03                	mov    %eax,(%rbx)
	return 0;
  80311f:	b8 00 00 00 00       	mov    $0x0,%eax
  803124:	eb 33                	jmp    803159 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803126:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80312a:	48 89 c6             	mov    %rax,%rsi
  80312d:	bf 00 00 00 00       	mov    $0x0,%edi
  803132:	48 b8 53 1b 80 00 00 	movabs $0x801b53,%rax
  803139:	00 00 00 
  80313c:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80313e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803142:	48 89 c6             	mov    %rax,%rsi
  803145:	bf 00 00 00 00       	mov    $0x0,%edi
  80314a:	48 b8 53 1b 80 00 00 	movabs $0x801b53,%rax
  803151:	00 00 00 
  803154:	ff d0                	callq  *%rax
err:
	return r;
  803156:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803159:	48 83 c4 38          	add    $0x38,%rsp
  80315d:	5b                   	pop    %rbx
  80315e:	5d                   	pop    %rbp
  80315f:	c3                   	retq   

0000000000803160 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803160:	55                   	push   %rbp
  803161:	48 89 e5             	mov    %rsp,%rbp
  803164:	53                   	push   %rbx
  803165:	48 83 ec 28          	sub    $0x28,%rsp
  803169:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80316d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803171:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803178:	00 00 00 
  80317b:	48 8b 00             	mov    (%rax),%rax
  80317e:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803184:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803187:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80318b:	48 89 c7             	mov    %rax,%rdi
  80318e:	48 b8 cb 39 80 00 00 	movabs $0x8039cb,%rax
  803195:	00 00 00 
  803198:	ff d0                	callq  *%rax
  80319a:	89 c3                	mov    %eax,%ebx
  80319c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031a0:	48 89 c7             	mov    %rax,%rdi
  8031a3:	48 b8 cb 39 80 00 00 	movabs $0x8039cb,%rax
  8031aa:	00 00 00 
  8031ad:	ff d0                	callq  *%rax
  8031af:	39 c3                	cmp    %eax,%ebx
  8031b1:	0f 94 c0             	sete   %al
  8031b4:	0f b6 c0             	movzbl %al,%eax
  8031b7:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8031ba:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8031c1:	00 00 00 
  8031c4:	48 8b 00             	mov    (%rax),%rax
  8031c7:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8031cd:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8031d0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031d3:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8031d6:	75 05                	jne    8031dd <_pipeisclosed+0x7d>
			return ret;
  8031d8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8031db:	eb 4f                	jmp    80322c <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8031dd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031e0:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8031e3:	74 42                	je     803227 <_pipeisclosed+0xc7>
  8031e5:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8031e9:	75 3c                	jne    803227 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8031eb:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8031f2:	00 00 00 
  8031f5:	48 8b 00             	mov    (%rax),%rax
  8031f8:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8031fe:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803201:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803204:	89 c6                	mov    %eax,%esi
  803206:	48 bf d4 40 80 00 00 	movabs $0x8040d4,%rdi
  80320d:	00 00 00 
  803210:	b8 00 00 00 00       	mov    $0x0,%eax
  803215:	49 b8 c4 05 80 00 00 	movabs $0x8005c4,%r8
  80321c:	00 00 00 
  80321f:	41 ff d0             	callq  *%r8
	}
  803222:	e9 4a ff ff ff       	jmpq   803171 <_pipeisclosed+0x11>
  803227:	e9 45 ff ff ff       	jmpq   803171 <_pipeisclosed+0x11>
}
  80322c:	48 83 c4 28          	add    $0x28,%rsp
  803230:	5b                   	pop    %rbx
  803231:	5d                   	pop    %rbp
  803232:	c3                   	retq   

0000000000803233 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803233:	55                   	push   %rbp
  803234:	48 89 e5             	mov    %rsp,%rbp
  803237:	48 83 ec 30          	sub    $0x30,%rsp
  80323b:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80323e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803242:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803245:	48 89 d6             	mov    %rdx,%rsi
  803248:	89 c7                	mov    %eax,%edi
  80324a:	48 b8 fb 1d 80 00 00 	movabs $0x801dfb,%rax
  803251:	00 00 00 
  803254:	ff d0                	callq  *%rax
  803256:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803259:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80325d:	79 05                	jns    803264 <pipeisclosed+0x31>
		return r;
  80325f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803262:	eb 31                	jmp    803295 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803264:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803268:	48 89 c7             	mov    %rax,%rdi
  80326b:	48 b8 38 1d 80 00 00 	movabs $0x801d38,%rax
  803272:	00 00 00 
  803275:	ff d0                	callq  *%rax
  803277:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80327b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80327f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803283:	48 89 d6             	mov    %rdx,%rsi
  803286:	48 89 c7             	mov    %rax,%rdi
  803289:	48 b8 60 31 80 00 00 	movabs $0x803160,%rax
  803290:	00 00 00 
  803293:	ff d0                	callq  *%rax
}
  803295:	c9                   	leaveq 
  803296:	c3                   	retq   

0000000000803297 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803297:	55                   	push   %rbp
  803298:	48 89 e5             	mov    %rsp,%rbp
  80329b:	48 83 ec 40          	sub    $0x40,%rsp
  80329f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8032a3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8032a7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8032ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032af:	48 89 c7             	mov    %rax,%rdi
  8032b2:	48 b8 38 1d 80 00 00 	movabs $0x801d38,%rax
  8032b9:	00 00 00 
  8032bc:	ff d0                	callq  *%rax
  8032be:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8032c2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032c6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8032ca:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8032d1:	00 
  8032d2:	e9 92 00 00 00       	jmpq   803369 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8032d7:	eb 41                	jmp    80331a <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8032d9:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8032de:	74 09                	je     8032e9 <devpipe_read+0x52>
				return i;
  8032e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032e4:	e9 92 00 00 00       	jmpq   80337b <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8032e9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032f1:	48 89 d6             	mov    %rdx,%rsi
  8032f4:	48 89 c7             	mov    %rax,%rdi
  8032f7:	48 b8 60 31 80 00 00 	movabs $0x803160,%rax
  8032fe:	00 00 00 
  803301:	ff d0                	callq  *%rax
  803303:	85 c0                	test   %eax,%eax
  803305:	74 07                	je     80330e <devpipe_read+0x77>
				return 0;
  803307:	b8 00 00 00 00       	mov    $0x0,%eax
  80330c:	eb 6d                	jmp    80337b <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80330e:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  803315:	00 00 00 
  803318:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80331a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80331e:	8b 10                	mov    (%rax),%edx
  803320:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803324:	8b 40 04             	mov    0x4(%rax),%eax
  803327:	39 c2                	cmp    %eax,%edx
  803329:	74 ae                	je     8032d9 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80332b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80332f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803333:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803337:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80333b:	8b 00                	mov    (%rax),%eax
  80333d:	99                   	cltd   
  80333e:	c1 ea 1b             	shr    $0x1b,%edx
  803341:	01 d0                	add    %edx,%eax
  803343:	83 e0 1f             	and    $0x1f,%eax
  803346:	29 d0                	sub    %edx,%eax
  803348:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80334c:	48 98                	cltq   
  80334e:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803353:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803355:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803359:	8b 00                	mov    (%rax),%eax
  80335b:	8d 50 01             	lea    0x1(%rax),%edx
  80335e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803362:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803364:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803369:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80336d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803371:	0f 82 60 ff ff ff    	jb     8032d7 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803377:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80337b:	c9                   	leaveq 
  80337c:	c3                   	retq   

000000000080337d <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80337d:	55                   	push   %rbp
  80337e:	48 89 e5             	mov    %rsp,%rbp
  803381:	48 83 ec 40          	sub    $0x40,%rsp
  803385:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803389:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80338d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803391:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803395:	48 89 c7             	mov    %rax,%rdi
  803398:	48 b8 38 1d 80 00 00 	movabs $0x801d38,%rax
  80339f:	00 00 00 
  8033a2:	ff d0                	callq  *%rax
  8033a4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8033a8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033ac:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8033b0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8033b7:	00 
  8033b8:	e9 8e 00 00 00       	jmpq   80344b <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8033bd:	eb 31                	jmp    8033f0 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8033bf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033c7:	48 89 d6             	mov    %rdx,%rsi
  8033ca:	48 89 c7             	mov    %rax,%rdi
  8033cd:	48 b8 60 31 80 00 00 	movabs $0x803160,%rax
  8033d4:	00 00 00 
  8033d7:	ff d0                	callq  *%rax
  8033d9:	85 c0                	test   %eax,%eax
  8033db:	74 07                	je     8033e4 <devpipe_write+0x67>
				return 0;
  8033dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8033e2:	eb 79                	jmp    80345d <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8033e4:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  8033eb:	00 00 00 
  8033ee:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8033f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033f4:	8b 40 04             	mov    0x4(%rax),%eax
  8033f7:	48 63 d0             	movslq %eax,%rdx
  8033fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033fe:	8b 00                	mov    (%rax),%eax
  803400:	48 98                	cltq   
  803402:	48 83 c0 20          	add    $0x20,%rax
  803406:	48 39 c2             	cmp    %rax,%rdx
  803409:	73 b4                	jae    8033bf <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80340b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80340f:	8b 40 04             	mov    0x4(%rax),%eax
  803412:	99                   	cltd   
  803413:	c1 ea 1b             	shr    $0x1b,%edx
  803416:	01 d0                	add    %edx,%eax
  803418:	83 e0 1f             	and    $0x1f,%eax
  80341b:	29 d0                	sub    %edx,%eax
  80341d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803421:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803425:	48 01 ca             	add    %rcx,%rdx
  803428:	0f b6 0a             	movzbl (%rdx),%ecx
  80342b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80342f:	48 98                	cltq   
  803431:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803435:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803439:	8b 40 04             	mov    0x4(%rax),%eax
  80343c:	8d 50 01             	lea    0x1(%rax),%edx
  80343f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803443:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803446:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80344b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80344f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803453:	0f 82 64 ff ff ff    	jb     8033bd <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803459:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80345d:	c9                   	leaveq 
  80345e:	c3                   	retq   

000000000080345f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80345f:	55                   	push   %rbp
  803460:	48 89 e5             	mov    %rsp,%rbp
  803463:	48 83 ec 20          	sub    $0x20,%rsp
  803467:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80346b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80346f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803473:	48 89 c7             	mov    %rax,%rdi
  803476:	48 b8 38 1d 80 00 00 	movabs $0x801d38,%rax
  80347d:	00 00 00 
  803480:	ff d0                	callq  *%rax
  803482:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803486:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80348a:	48 be e7 40 80 00 00 	movabs $0x8040e7,%rsi
  803491:	00 00 00 
  803494:	48 89 c7             	mov    %rax,%rdi
  803497:	48 b8 79 11 80 00 00 	movabs $0x801179,%rax
  80349e:	00 00 00 
  8034a1:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8034a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034a7:	8b 50 04             	mov    0x4(%rax),%edx
  8034aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034ae:	8b 00                	mov    (%rax),%eax
  8034b0:	29 c2                	sub    %eax,%edx
  8034b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034b6:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8034bc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034c0:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8034c7:	00 00 00 
	stat->st_dev = &devpipe;
  8034ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034ce:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  8034d5:	00 00 00 
  8034d8:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8034df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034e4:	c9                   	leaveq 
  8034e5:	c3                   	retq   

00000000008034e6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8034e6:	55                   	push   %rbp
  8034e7:	48 89 e5             	mov    %rsp,%rbp
  8034ea:	48 83 ec 10          	sub    $0x10,%rsp
  8034ee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8034f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034f6:	48 89 c6             	mov    %rax,%rsi
  8034f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8034fe:	48 b8 53 1b 80 00 00 	movabs $0x801b53,%rax
  803505:	00 00 00 
  803508:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80350a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80350e:	48 89 c7             	mov    %rax,%rdi
  803511:	48 b8 38 1d 80 00 00 	movabs $0x801d38,%rax
  803518:	00 00 00 
  80351b:	ff d0                	callq  *%rax
  80351d:	48 89 c6             	mov    %rax,%rsi
  803520:	bf 00 00 00 00       	mov    $0x0,%edi
  803525:	48 b8 53 1b 80 00 00 	movabs $0x801b53,%rax
  80352c:	00 00 00 
  80352f:	ff d0                	callq  *%rax
}
  803531:	c9                   	leaveq 
  803532:	c3                   	retq   

0000000000803533 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803533:	55                   	push   %rbp
  803534:	48 89 e5             	mov    %rsp,%rbp
  803537:	48 83 ec 20          	sub    $0x20,%rsp
  80353b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80353e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803541:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803544:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803548:	be 01 00 00 00       	mov    $0x1,%esi
  80354d:	48 89 c7             	mov    %rax,%rdi
  803550:	48 b8 60 19 80 00 00 	movabs $0x801960,%rax
  803557:	00 00 00 
  80355a:	ff d0                	callq  *%rax
}
  80355c:	c9                   	leaveq 
  80355d:	c3                   	retq   

000000000080355e <getchar>:

int
getchar(void)
{
  80355e:	55                   	push   %rbp
  80355f:	48 89 e5             	mov    %rsp,%rbp
  803562:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803566:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80356a:	ba 01 00 00 00       	mov    $0x1,%edx
  80356f:	48 89 c6             	mov    %rax,%rsi
  803572:	bf 00 00 00 00       	mov    $0x0,%edi
  803577:	48 b8 2d 22 80 00 00 	movabs $0x80222d,%rax
  80357e:	00 00 00 
  803581:	ff d0                	callq  *%rax
  803583:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803586:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80358a:	79 05                	jns    803591 <getchar+0x33>
		return r;
  80358c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80358f:	eb 14                	jmp    8035a5 <getchar+0x47>
	if (r < 1)
  803591:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803595:	7f 07                	jg     80359e <getchar+0x40>
		return -E_EOF;
  803597:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80359c:	eb 07                	jmp    8035a5 <getchar+0x47>
	return c;
  80359e:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8035a2:	0f b6 c0             	movzbl %al,%eax
}
  8035a5:	c9                   	leaveq 
  8035a6:	c3                   	retq   

00000000008035a7 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8035a7:	55                   	push   %rbp
  8035a8:	48 89 e5             	mov    %rsp,%rbp
  8035ab:	48 83 ec 20          	sub    $0x20,%rsp
  8035af:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8035b2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8035b6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035b9:	48 89 d6             	mov    %rdx,%rsi
  8035bc:	89 c7                	mov    %eax,%edi
  8035be:	48 b8 fb 1d 80 00 00 	movabs $0x801dfb,%rax
  8035c5:	00 00 00 
  8035c8:	ff d0                	callq  *%rax
  8035ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035d1:	79 05                	jns    8035d8 <iscons+0x31>
		return r;
  8035d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035d6:	eb 1a                	jmp    8035f2 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8035d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035dc:	8b 10                	mov    (%rax),%edx
  8035de:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  8035e5:	00 00 00 
  8035e8:	8b 00                	mov    (%rax),%eax
  8035ea:	39 c2                	cmp    %eax,%edx
  8035ec:	0f 94 c0             	sete   %al
  8035ef:	0f b6 c0             	movzbl %al,%eax
}
  8035f2:	c9                   	leaveq 
  8035f3:	c3                   	retq   

00000000008035f4 <opencons>:

int
opencons(void)
{
  8035f4:	55                   	push   %rbp
  8035f5:	48 89 e5             	mov    %rsp,%rbp
  8035f8:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8035fc:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803600:	48 89 c7             	mov    %rax,%rdi
  803603:	48 b8 63 1d 80 00 00 	movabs $0x801d63,%rax
  80360a:	00 00 00 
  80360d:	ff d0                	callq  *%rax
  80360f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803612:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803616:	79 05                	jns    80361d <opencons+0x29>
		return r;
  803618:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80361b:	eb 5b                	jmp    803678 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80361d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803621:	ba 07 04 00 00       	mov    $0x407,%edx
  803626:	48 89 c6             	mov    %rax,%rsi
  803629:	bf 00 00 00 00       	mov    $0x0,%edi
  80362e:	48 b8 a8 1a 80 00 00 	movabs $0x801aa8,%rax
  803635:	00 00 00 
  803638:	ff d0                	callq  *%rax
  80363a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80363d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803641:	79 05                	jns    803648 <opencons+0x54>
		return r;
  803643:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803646:	eb 30                	jmp    803678 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803648:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80364c:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  803653:	00 00 00 
  803656:	8b 12                	mov    (%rdx),%edx
  803658:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80365a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80365e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803665:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803669:	48 89 c7             	mov    %rax,%rdi
  80366c:	48 b8 15 1d 80 00 00 	movabs $0x801d15,%rax
  803673:	00 00 00 
  803676:	ff d0                	callq  *%rax
}
  803678:	c9                   	leaveq 
  803679:	c3                   	retq   

000000000080367a <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80367a:	55                   	push   %rbp
  80367b:	48 89 e5             	mov    %rsp,%rbp
  80367e:	48 83 ec 30          	sub    $0x30,%rsp
  803682:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803686:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80368a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80368e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803693:	75 07                	jne    80369c <devcons_read+0x22>
		return 0;
  803695:	b8 00 00 00 00       	mov    $0x0,%eax
  80369a:	eb 4b                	jmp    8036e7 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80369c:	eb 0c                	jmp    8036aa <devcons_read+0x30>
		sys_yield();
  80369e:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  8036a5:	00 00 00 
  8036a8:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8036aa:	48 b8 aa 19 80 00 00 	movabs $0x8019aa,%rax
  8036b1:	00 00 00 
  8036b4:	ff d0                	callq  *%rax
  8036b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036bd:	74 df                	je     80369e <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8036bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036c3:	79 05                	jns    8036ca <devcons_read+0x50>
		return c;
  8036c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036c8:	eb 1d                	jmp    8036e7 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8036ca:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8036ce:	75 07                	jne    8036d7 <devcons_read+0x5d>
		return 0;
  8036d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8036d5:	eb 10                	jmp    8036e7 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8036d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036da:	89 c2                	mov    %eax,%edx
  8036dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036e0:	88 10                	mov    %dl,(%rax)
	return 1;
  8036e2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8036e7:	c9                   	leaveq 
  8036e8:	c3                   	retq   

00000000008036e9 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8036e9:	55                   	push   %rbp
  8036ea:	48 89 e5             	mov    %rsp,%rbp
  8036ed:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8036f4:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8036fb:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803702:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803709:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803710:	eb 76                	jmp    803788 <devcons_write+0x9f>
		m = n - tot;
  803712:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803719:	89 c2                	mov    %eax,%edx
  80371b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80371e:	29 c2                	sub    %eax,%edx
  803720:	89 d0                	mov    %edx,%eax
  803722:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803725:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803728:	83 f8 7f             	cmp    $0x7f,%eax
  80372b:	76 07                	jbe    803734 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80372d:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803734:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803737:	48 63 d0             	movslq %eax,%rdx
  80373a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80373d:	48 63 c8             	movslq %eax,%rcx
  803740:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803747:	48 01 c1             	add    %rax,%rcx
  80374a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803751:	48 89 ce             	mov    %rcx,%rsi
  803754:	48 89 c7             	mov    %rax,%rdi
  803757:	48 b8 9d 14 80 00 00 	movabs $0x80149d,%rax
  80375e:	00 00 00 
  803761:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803763:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803766:	48 63 d0             	movslq %eax,%rdx
  803769:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803770:	48 89 d6             	mov    %rdx,%rsi
  803773:	48 89 c7             	mov    %rax,%rdi
  803776:	48 b8 60 19 80 00 00 	movabs $0x801960,%rax
  80377d:	00 00 00 
  803780:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803782:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803785:	01 45 fc             	add    %eax,-0x4(%rbp)
  803788:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80378b:	48 98                	cltq   
  80378d:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803794:	0f 82 78 ff ff ff    	jb     803712 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80379a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80379d:	c9                   	leaveq 
  80379e:	c3                   	retq   

000000000080379f <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80379f:	55                   	push   %rbp
  8037a0:	48 89 e5             	mov    %rsp,%rbp
  8037a3:	48 83 ec 08          	sub    $0x8,%rsp
  8037a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8037ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037b0:	c9                   	leaveq 
  8037b1:	c3                   	retq   

00000000008037b2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8037b2:	55                   	push   %rbp
  8037b3:	48 89 e5             	mov    %rsp,%rbp
  8037b6:	48 83 ec 10          	sub    $0x10,%rsp
  8037ba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8037be:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8037c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037c6:	48 be f3 40 80 00 00 	movabs $0x8040f3,%rsi
  8037cd:	00 00 00 
  8037d0:	48 89 c7             	mov    %rax,%rdi
  8037d3:	48 b8 79 11 80 00 00 	movabs $0x801179,%rax
  8037da:	00 00 00 
  8037dd:	ff d0                	callq  *%rax
	return 0;
  8037df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037e4:	c9                   	leaveq 
  8037e5:	c3                   	retq   

00000000008037e6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8037e6:	55                   	push   %rbp
  8037e7:	48 89 e5             	mov    %rsp,%rbp
  8037ea:	48 83 ec 30          	sub    $0x30,%rsp
  8037ee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8037f2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8037f6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  8037fa:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8037ff:	74 18                	je     803819 <ipc_recv+0x33>
  803801:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803805:	48 89 c7             	mov    %rax,%rdi
  803808:	48 b8 d1 1c 80 00 00 	movabs $0x801cd1,%rax
  80380f:	00 00 00 
  803812:	ff d0                	callq  *%rax
  803814:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803817:	eb 19                	jmp    803832 <ipc_recv+0x4c>
  803819:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  803820:	00 00 00 
  803823:	48 b8 d1 1c 80 00 00 	movabs $0x801cd1,%rax
  80382a:	00 00 00 
  80382d:	ff d0                	callq  *%rax
  80382f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  803832:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803837:	74 26                	je     80385f <ipc_recv+0x79>
  803839:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80383d:	75 15                	jne    803854 <ipc_recv+0x6e>
  80383f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803846:	00 00 00 
  803849:	48 8b 00             	mov    (%rax),%rax
  80384c:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  803852:	eb 05                	jmp    803859 <ipc_recv+0x73>
  803854:	b8 00 00 00 00       	mov    $0x0,%eax
  803859:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80385d:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  80385f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803864:	74 26                	je     80388c <ipc_recv+0xa6>
  803866:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80386a:	75 15                	jne    803881 <ipc_recv+0x9b>
  80386c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803873:	00 00 00 
  803876:	48 8b 00             	mov    (%rax),%rax
  803879:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  80387f:	eb 05                	jmp    803886 <ipc_recv+0xa0>
  803881:	b8 00 00 00 00       	mov    $0x0,%eax
  803886:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80388a:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  80388c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803890:	75 15                	jne    8038a7 <ipc_recv+0xc1>
  803892:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803899:	00 00 00 
  80389c:	48 8b 00             	mov    (%rax),%rax
  80389f:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  8038a5:	eb 03                	jmp    8038aa <ipc_recv+0xc4>
  8038a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8038aa:	c9                   	leaveq 
  8038ab:	c3                   	retq   

00000000008038ac <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8038ac:	55                   	push   %rbp
  8038ad:	48 89 e5             	mov    %rsp,%rbp
  8038b0:	48 83 ec 30          	sub    $0x30,%rsp
  8038b4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038b7:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8038ba:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8038be:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  8038c1:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  8038c8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8038cd:	75 10                	jne    8038df <ipc_send+0x33>
  8038cf:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8038d6:	00 00 00 
  8038d9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  8038dd:	eb 62                	jmp    803941 <ipc_send+0x95>
  8038df:	eb 60                	jmp    803941 <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  8038e1:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8038e5:	74 30                	je     803917 <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  8038e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038ea:	89 c1                	mov    %eax,%ecx
  8038ec:	48 ba fa 40 80 00 00 	movabs $0x8040fa,%rdx
  8038f3:	00 00 00 
  8038f6:	be 33 00 00 00       	mov    $0x33,%esi
  8038fb:	48 bf 16 41 80 00 00 	movabs $0x804116,%rdi
  803902:	00 00 00 
  803905:	b8 00 00 00 00       	mov    $0x0,%eax
  80390a:	49 b8 8b 03 80 00 00 	movabs $0x80038b,%r8
  803911:	00 00 00 
  803914:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  803917:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80391a:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80391d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803921:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803924:	89 c7                	mov    %eax,%edi
  803926:	48 b8 7c 1c 80 00 00 	movabs $0x801c7c,%rax
  80392d:	00 00 00 
  803930:	ff d0                	callq  *%rax
  803932:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  803935:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  80393c:	00 00 00 
  80393f:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  803941:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803945:	75 9a                	jne    8038e1 <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  803947:	c9                   	leaveq 
  803948:	c3                   	retq   

0000000000803949 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803949:	55                   	push   %rbp
  80394a:	48 89 e5             	mov    %rsp,%rbp
  80394d:	48 83 ec 14          	sub    $0x14,%rsp
  803951:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803954:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80395b:	eb 5e                	jmp    8039bb <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80395d:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803964:	00 00 00 
  803967:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80396a:	48 63 d0             	movslq %eax,%rdx
  80396d:	48 89 d0             	mov    %rdx,%rax
  803970:	48 c1 e0 03          	shl    $0x3,%rax
  803974:	48 01 d0             	add    %rdx,%rax
  803977:	48 c1 e0 05          	shl    $0x5,%rax
  80397b:	48 01 c8             	add    %rcx,%rax
  80397e:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803984:	8b 00                	mov    (%rax),%eax
  803986:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803989:	75 2c                	jne    8039b7 <ipc_find_env+0x6e>
			return envs[i].env_id;
  80398b:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803992:	00 00 00 
  803995:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803998:	48 63 d0             	movslq %eax,%rdx
  80399b:	48 89 d0             	mov    %rdx,%rax
  80399e:	48 c1 e0 03          	shl    $0x3,%rax
  8039a2:	48 01 d0             	add    %rdx,%rax
  8039a5:	48 c1 e0 05          	shl    $0x5,%rax
  8039a9:	48 01 c8             	add    %rcx,%rax
  8039ac:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8039b2:	8b 40 08             	mov    0x8(%rax),%eax
  8039b5:	eb 12                	jmp    8039c9 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8039b7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8039bb:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8039c2:	7e 99                	jle    80395d <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8039c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039c9:	c9                   	leaveq 
  8039ca:	c3                   	retq   

00000000008039cb <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8039cb:	55                   	push   %rbp
  8039cc:	48 89 e5             	mov    %rsp,%rbp
  8039cf:	48 83 ec 18          	sub    $0x18,%rsp
  8039d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8039d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039db:	48 c1 e8 15          	shr    $0x15,%rax
  8039df:	48 89 c2             	mov    %rax,%rdx
  8039e2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8039e9:	01 00 00 
  8039ec:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8039f0:	83 e0 01             	and    $0x1,%eax
  8039f3:	48 85 c0             	test   %rax,%rax
  8039f6:	75 07                	jne    8039ff <pageref+0x34>
		return 0;
  8039f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8039fd:	eb 53                	jmp    803a52 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8039ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a03:	48 c1 e8 0c          	shr    $0xc,%rax
  803a07:	48 89 c2             	mov    %rax,%rdx
  803a0a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803a11:	01 00 00 
  803a14:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803a18:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803a1c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a20:	83 e0 01             	and    $0x1,%eax
  803a23:	48 85 c0             	test   %rax,%rax
  803a26:	75 07                	jne    803a2f <pageref+0x64>
		return 0;
  803a28:	b8 00 00 00 00       	mov    $0x0,%eax
  803a2d:	eb 23                	jmp    803a52 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803a2f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a33:	48 c1 e8 0c          	shr    $0xc,%rax
  803a37:	48 89 c2             	mov    %rax,%rdx
  803a3a:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803a41:	00 00 00 
  803a44:	48 c1 e2 04          	shl    $0x4,%rdx
  803a48:	48 01 d0             	add    %rdx,%rax
  803a4b:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803a4f:	0f b7 c0             	movzwl %ax,%eax
}
  803a52:	c9                   	leaveq 
  803a53:	c3                   	retq   
