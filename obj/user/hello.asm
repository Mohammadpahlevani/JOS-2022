
obj/user/hello:     file format elf64-x86-64


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
  80003c:	e8 5e 00 00 00       	callq  80009f <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	cprintf("hello, world\n");
  800052:	48 bf a0 1a 80 00 00 	movabs $0x801aa0,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 7f 02 80 00 00 	movabs $0x80027f,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	cprintf("i am environment %08x\n", thisenv->env_id);
  80006d:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  800074:	00 00 00 
  800077:	48 8b 00             	mov    (%rax),%rax
  80007a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800080:	89 c6                	mov    %eax,%esi
  800082:	48 bf ae 1a 80 00 00 	movabs $0x801aae,%rdi
  800089:	00 00 00 
  80008c:	b8 00 00 00 00       	mov    $0x0,%eax
  800091:	48 ba 7f 02 80 00 00 	movabs $0x80027f,%rdx
  800098:	00 00 00 
  80009b:	ff d2                	callq  *%rdx
}
  80009d:	c9                   	leaveq 
  80009e:	c3                   	retq   

000000000080009f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80009f:	55                   	push   %rbp
  8000a0:	48 89 e5             	mov    %rsp,%rbp
  8000a3:	48 83 ec 20          	sub    $0x20,%rsp
  8000a7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8000aa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8000ae:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000b5:	00 00 00 
  8000b8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	envid_t id = sys_getenvid();
  8000bf:	48 b8 e7 16 80 00 00 	movabs $0x8016e7,%rax
  8000c6:	00 00 00 
  8000c9:	ff d0                	callq  *%rax
  8000cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
        id = ENVX(id);
  8000ce:	81 65 fc ff 03 00 00 	andl   $0x3ff,-0x4(%rbp)
	thisenv = &envs[id];
  8000d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d8:	48 63 d0             	movslq %eax,%rdx
  8000db:	48 89 d0             	mov    %rdx,%rax
  8000de:	48 c1 e0 03          	shl    $0x3,%rax
  8000e2:	48 01 d0             	add    %rdx,%rax
  8000e5:	48 c1 e0 05          	shl    $0x5,%rax
  8000e9:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000f0:	00 00 00 
  8000f3:	48 01 c2             	add    %rax,%rdx
  8000f6:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000fd:	00 00 00 
  800100:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800103:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800107:	7e 14                	jle    80011d <libmain+0x7e>
		binaryname = argv[0];
  800109:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80010d:	48 8b 10             	mov    (%rax),%rdx
  800110:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  800117:	00 00 00 
  80011a:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80011d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800121:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800124:	48 89 d6             	mov    %rdx,%rsi
  800127:	89 c7                	mov    %eax,%edi
  800129:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800130:	00 00 00 
  800133:	ff d0                	callq  *%rax
	
	//cprintf("\noutside\n");
	// exit gracefully
	exit();
  800135:	48 b8 43 01 80 00 00 	movabs $0x800143,%rax
  80013c:	00 00 00 
  80013f:	ff d0                	callq  *%rax
}
  800141:	c9                   	leaveq 
  800142:	c3                   	retq   

0000000000800143 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800143:	55                   	push   %rbp
  800144:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  800147:	bf 00 00 00 00       	mov    $0x0,%edi
  80014c:	48 b8 a3 16 80 00 00 	movabs $0x8016a3,%rax
  800153:	00 00 00 
  800156:	ff d0                	callq  *%rax
}
  800158:	5d                   	pop    %rbp
  800159:	c3                   	retq   

000000000080015a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80015a:	55                   	push   %rbp
  80015b:	48 89 e5             	mov    %rsp,%rbp
  80015e:	48 83 ec 10          	sub    $0x10,%rsp
  800162:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800165:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800169:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80016d:	8b 00                	mov    (%rax),%eax
  80016f:	8d 48 01             	lea    0x1(%rax),%ecx
  800172:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800176:	89 0a                	mov    %ecx,(%rdx)
  800178:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80017b:	89 d1                	mov    %edx,%ecx
  80017d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800181:	48 98                	cltq   
  800183:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  800187:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80018b:	8b 00                	mov    (%rax),%eax
  80018d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800192:	75 2c                	jne    8001c0 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800194:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800198:	8b 00                	mov    (%rax),%eax
  80019a:	48 98                	cltq   
  80019c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001a0:	48 83 c2 08          	add    $0x8,%rdx
  8001a4:	48 89 c6             	mov    %rax,%rsi
  8001a7:	48 89 d7             	mov    %rdx,%rdi
  8001aa:	48 b8 1b 16 80 00 00 	movabs $0x80161b,%rax
  8001b1:	00 00 00 
  8001b4:	ff d0                	callq  *%rax
		b->idx = 0;
  8001b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001ba:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8001c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001c4:	8b 40 04             	mov    0x4(%rax),%eax
  8001c7:	8d 50 01             	lea    0x1(%rax),%edx
  8001ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001ce:	89 50 04             	mov    %edx,0x4(%rax)
}
  8001d1:	c9                   	leaveq 
  8001d2:	c3                   	retq   

00000000008001d3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001d3:	55                   	push   %rbp
  8001d4:	48 89 e5             	mov    %rsp,%rbp
  8001d7:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8001de:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8001e5:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8001ec:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8001f3:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8001fa:	48 8b 0a             	mov    (%rdx),%rcx
  8001fd:	48 89 08             	mov    %rcx,(%rax)
  800200:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800204:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800208:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80020c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800210:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800217:	00 00 00 
	b.cnt = 0;
  80021a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800221:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800224:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80022b:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800232:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800239:	48 89 c6             	mov    %rax,%rsi
  80023c:	48 bf 5a 01 80 00 00 	movabs $0x80015a,%rdi
  800243:	00 00 00 
  800246:	48 b8 32 06 80 00 00 	movabs $0x800632,%rax
  80024d:	00 00 00 
  800250:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800252:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800258:	48 98                	cltq   
  80025a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800261:	48 83 c2 08          	add    $0x8,%rdx
  800265:	48 89 c6             	mov    %rax,%rsi
  800268:	48 89 d7             	mov    %rdx,%rdi
  80026b:	48 b8 1b 16 80 00 00 	movabs $0x80161b,%rax
  800272:	00 00 00 
  800275:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800277:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80027d:	c9                   	leaveq 
  80027e:	c3                   	retq   

000000000080027f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80027f:	55                   	push   %rbp
  800280:	48 89 e5             	mov    %rsp,%rbp
  800283:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80028a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800291:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800298:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80029f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8002a6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8002ad:	84 c0                	test   %al,%al
  8002af:	74 20                	je     8002d1 <cprintf+0x52>
  8002b1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8002b5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8002b9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8002bd:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8002c1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8002c5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8002c9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8002cd:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8002d1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8002d8:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8002df:	00 00 00 
  8002e2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8002e9:	00 00 00 
  8002ec:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002f0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8002f7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8002fe:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800305:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80030c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800313:	48 8b 0a             	mov    (%rdx),%rcx
  800316:	48 89 08             	mov    %rcx,(%rax)
  800319:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80031d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800321:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800325:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800329:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800330:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800337:	48 89 d6             	mov    %rdx,%rsi
  80033a:	48 89 c7             	mov    %rax,%rdi
  80033d:	48 b8 d3 01 80 00 00 	movabs $0x8001d3,%rax
  800344:	00 00 00 
  800347:	ff d0                	callq  *%rax
  800349:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  80034f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800355:	c9                   	leaveq 
  800356:	c3                   	retq   

0000000000800357 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800357:	55                   	push   %rbp
  800358:	48 89 e5             	mov    %rsp,%rbp
  80035b:	53                   	push   %rbx
  80035c:	48 83 ec 38          	sub    $0x38,%rsp
  800360:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800364:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800368:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80036c:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80036f:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800373:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800377:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80037a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80037e:	77 3b                	ja     8003bb <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800380:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800383:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800387:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80038a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80038e:	ba 00 00 00 00       	mov    $0x0,%edx
  800393:	48 f7 f3             	div    %rbx
  800396:	48 89 c2             	mov    %rax,%rdx
  800399:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80039c:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80039f:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8003a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003a7:	41 89 f9             	mov    %edi,%r9d
  8003aa:	48 89 c7             	mov    %rax,%rdi
  8003ad:	48 b8 57 03 80 00 00 	movabs $0x800357,%rax
  8003b4:	00 00 00 
  8003b7:	ff d0                	callq  *%rax
  8003b9:	eb 1e                	jmp    8003d9 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003bb:	eb 12                	jmp    8003cf <printnum+0x78>
			putch(padc, putdat);
  8003bd:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003c1:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8003c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003c8:	48 89 ce             	mov    %rcx,%rsi
  8003cb:	89 d7                	mov    %edx,%edi
  8003cd:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003cf:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8003d3:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8003d7:	7f e4                	jg     8003bd <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003d9:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8003dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8003e5:	48 f7 f1             	div    %rcx
  8003e8:	48 89 d0             	mov    %rdx,%rax
  8003eb:	48 ba d0 1b 80 00 00 	movabs $0x801bd0,%rdx
  8003f2:	00 00 00 
  8003f5:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8003f9:	0f be d0             	movsbl %al,%edx
  8003fc:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800400:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800404:	48 89 ce             	mov    %rcx,%rsi
  800407:	89 d7                	mov    %edx,%edi
  800409:	ff d0                	callq  *%rax
}
  80040b:	48 83 c4 38          	add    $0x38,%rsp
  80040f:	5b                   	pop    %rbx
  800410:	5d                   	pop    %rbp
  800411:	c3                   	retq   

0000000000800412 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800412:	55                   	push   %rbp
  800413:	48 89 e5             	mov    %rsp,%rbp
  800416:	48 83 ec 1c          	sub    $0x1c,%rsp
  80041a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80041e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800421:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800425:	7e 52                	jle    800479 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800427:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042b:	8b 00                	mov    (%rax),%eax
  80042d:	83 f8 30             	cmp    $0x30,%eax
  800430:	73 24                	jae    800456 <getuint+0x44>
  800432:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800436:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80043a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80043e:	8b 00                	mov    (%rax),%eax
  800440:	89 c0                	mov    %eax,%eax
  800442:	48 01 d0             	add    %rdx,%rax
  800445:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800449:	8b 12                	mov    (%rdx),%edx
  80044b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80044e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800452:	89 0a                	mov    %ecx,(%rdx)
  800454:	eb 17                	jmp    80046d <getuint+0x5b>
  800456:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80045a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80045e:	48 89 d0             	mov    %rdx,%rax
  800461:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800465:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800469:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80046d:	48 8b 00             	mov    (%rax),%rax
  800470:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800474:	e9 a3 00 00 00       	jmpq   80051c <getuint+0x10a>
	else if (lflag)
  800479:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80047d:	74 4f                	je     8004ce <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80047f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800483:	8b 00                	mov    (%rax),%eax
  800485:	83 f8 30             	cmp    $0x30,%eax
  800488:	73 24                	jae    8004ae <getuint+0x9c>
  80048a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80048e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800492:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800496:	8b 00                	mov    (%rax),%eax
  800498:	89 c0                	mov    %eax,%eax
  80049a:	48 01 d0             	add    %rdx,%rax
  80049d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004a1:	8b 12                	mov    (%rdx),%edx
  8004a3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004aa:	89 0a                	mov    %ecx,(%rdx)
  8004ac:	eb 17                	jmp    8004c5 <getuint+0xb3>
  8004ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004b6:	48 89 d0             	mov    %rdx,%rax
  8004b9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004c1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004c5:	48 8b 00             	mov    (%rax),%rax
  8004c8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004cc:	eb 4e                	jmp    80051c <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8004ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d2:	8b 00                	mov    (%rax),%eax
  8004d4:	83 f8 30             	cmp    $0x30,%eax
  8004d7:	73 24                	jae    8004fd <getuint+0xeb>
  8004d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004dd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e5:	8b 00                	mov    (%rax),%eax
  8004e7:	89 c0                	mov    %eax,%eax
  8004e9:	48 01 d0             	add    %rdx,%rax
  8004ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004f0:	8b 12                	mov    (%rdx),%edx
  8004f2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004f9:	89 0a                	mov    %ecx,(%rdx)
  8004fb:	eb 17                	jmp    800514 <getuint+0x102>
  8004fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800501:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800505:	48 89 d0             	mov    %rdx,%rax
  800508:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80050c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800510:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800514:	8b 00                	mov    (%rax),%eax
  800516:	89 c0                	mov    %eax,%eax
  800518:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80051c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800520:	c9                   	leaveq 
  800521:	c3                   	retq   

0000000000800522 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800522:	55                   	push   %rbp
  800523:	48 89 e5             	mov    %rsp,%rbp
  800526:	48 83 ec 1c          	sub    $0x1c,%rsp
  80052a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80052e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800531:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800535:	7e 52                	jle    800589 <getint+0x67>
		x=va_arg(*ap, long long);
  800537:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80053b:	8b 00                	mov    (%rax),%eax
  80053d:	83 f8 30             	cmp    $0x30,%eax
  800540:	73 24                	jae    800566 <getint+0x44>
  800542:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800546:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80054a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054e:	8b 00                	mov    (%rax),%eax
  800550:	89 c0                	mov    %eax,%eax
  800552:	48 01 d0             	add    %rdx,%rax
  800555:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800559:	8b 12                	mov    (%rdx),%edx
  80055b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80055e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800562:	89 0a                	mov    %ecx,(%rdx)
  800564:	eb 17                	jmp    80057d <getint+0x5b>
  800566:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80056a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80056e:	48 89 d0             	mov    %rdx,%rax
  800571:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800575:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800579:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80057d:	48 8b 00             	mov    (%rax),%rax
  800580:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800584:	e9 a3 00 00 00       	jmpq   80062c <getint+0x10a>
	else if (lflag)
  800589:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80058d:	74 4f                	je     8005de <getint+0xbc>
		x=va_arg(*ap, long);
  80058f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800593:	8b 00                	mov    (%rax),%eax
  800595:	83 f8 30             	cmp    $0x30,%eax
  800598:	73 24                	jae    8005be <getint+0x9c>
  80059a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a6:	8b 00                	mov    (%rax),%eax
  8005a8:	89 c0                	mov    %eax,%eax
  8005aa:	48 01 d0             	add    %rdx,%rax
  8005ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b1:	8b 12                	mov    (%rdx),%edx
  8005b3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ba:	89 0a                	mov    %ecx,(%rdx)
  8005bc:	eb 17                	jmp    8005d5 <getint+0xb3>
  8005be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005c6:	48 89 d0             	mov    %rdx,%rax
  8005c9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005d5:	48 8b 00             	mov    (%rax),%rax
  8005d8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005dc:	eb 4e                	jmp    80062c <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8005de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e2:	8b 00                	mov    (%rax),%eax
  8005e4:	83 f8 30             	cmp    $0x30,%eax
  8005e7:	73 24                	jae    80060d <getint+0xeb>
  8005e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ed:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f5:	8b 00                	mov    (%rax),%eax
  8005f7:	89 c0                	mov    %eax,%eax
  8005f9:	48 01 d0             	add    %rdx,%rax
  8005fc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800600:	8b 12                	mov    (%rdx),%edx
  800602:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800605:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800609:	89 0a                	mov    %ecx,(%rdx)
  80060b:	eb 17                	jmp    800624 <getint+0x102>
  80060d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800611:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800615:	48 89 d0             	mov    %rdx,%rax
  800618:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80061c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800620:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800624:	8b 00                	mov    (%rax),%eax
  800626:	48 98                	cltq   
  800628:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80062c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800630:	c9                   	leaveq 
  800631:	c3                   	retq   

0000000000800632 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800632:	55                   	push   %rbp
  800633:	48 89 e5             	mov    %rsp,%rbp
  800636:	41 54                	push   %r12
  800638:	53                   	push   %rbx
  800639:	48 83 ec 60          	sub    $0x60,%rsp
  80063d:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800641:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800645:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800649:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80064d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800651:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800655:	48 8b 0a             	mov    (%rdx),%rcx
  800658:	48 89 08             	mov    %rcx,(%rax)
  80065b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80065f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800663:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800667:	48 89 50 10          	mov    %rdx,0x10(%rax)
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80066b:	eb 17                	jmp    800684 <vprintfmt+0x52>
			if (ch == '\0')
  80066d:	85 db                	test   %ebx,%ebx
  80066f:	0f 84 cc 04 00 00    	je     800b41 <vprintfmt+0x50f>
                }
#endif

			  return;
			}
			putch(ch, putdat);
  800675:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800679:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80067d:	48 89 d6             	mov    %rdx,%rsi
  800680:	89 df                	mov    %ebx,%edi
  800682:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800684:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800688:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80068c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800690:	0f b6 00             	movzbl (%rax),%eax
  800693:	0f b6 d8             	movzbl %al,%ebx
  800696:	83 fb 25             	cmp    $0x25,%ebx
  800699:	75 d2                	jne    80066d <vprintfmt+0x3b>
			  return;
			}
			putch(ch, putdat);
		}
		// Process a %-escape sequence
		padc = ' ';
  80069b:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80069f:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8006a6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8006ad:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8006b4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006bb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006bf:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006c3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006c7:	0f b6 00             	movzbl (%rax),%eax
  8006ca:	0f b6 d8             	movzbl %al,%ebx
  8006cd:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8006d0:	83 f8 55             	cmp    $0x55,%eax
  8006d3:	0f 87 34 04 00 00    	ja     800b0d <vprintfmt+0x4db>
  8006d9:	89 c0                	mov    %eax,%eax
  8006db:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8006e2:	00 
  8006e3:	48 b8 f8 1b 80 00 00 	movabs $0x801bf8,%rax
  8006ea:	00 00 00 
  8006ed:	48 01 d0             	add    %rdx,%rax
  8006f0:	48 8b 00             	mov    (%rax),%rax
  8006f3:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006f5:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8006f9:	eb c0                	jmp    8006bb <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006fb:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8006ff:	eb ba                	jmp    8006bb <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800701:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800708:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80070b:	89 d0                	mov    %edx,%eax
  80070d:	c1 e0 02             	shl    $0x2,%eax
  800710:	01 d0                	add    %edx,%eax
  800712:	01 c0                	add    %eax,%eax
  800714:	01 d8                	add    %ebx,%eax
  800716:	83 e8 30             	sub    $0x30,%eax
  800719:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80071c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800720:	0f b6 00             	movzbl (%rax),%eax
  800723:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800726:	83 fb 2f             	cmp    $0x2f,%ebx
  800729:	7e 0c                	jle    800737 <vprintfmt+0x105>
  80072b:	83 fb 39             	cmp    $0x39,%ebx
  80072e:	7f 07                	jg     800737 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800730:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800735:	eb d1                	jmp    800708 <vprintfmt+0xd6>
			goto process_precision;
  800737:	eb 58                	jmp    800791 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800739:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80073c:	83 f8 30             	cmp    $0x30,%eax
  80073f:	73 17                	jae    800758 <vprintfmt+0x126>
  800741:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800745:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800748:	89 c0                	mov    %eax,%eax
  80074a:	48 01 d0             	add    %rdx,%rax
  80074d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800750:	83 c2 08             	add    $0x8,%edx
  800753:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800756:	eb 0f                	jmp    800767 <vprintfmt+0x135>
  800758:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80075c:	48 89 d0             	mov    %rdx,%rax
  80075f:	48 83 c2 08          	add    $0x8,%rdx
  800763:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800767:	8b 00                	mov    (%rax),%eax
  800769:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80076c:	eb 23                	jmp    800791 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80076e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800772:	79 0c                	jns    800780 <vprintfmt+0x14e>
				width = 0;
  800774:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80077b:	e9 3b ff ff ff       	jmpq   8006bb <vprintfmt+0x89>
  800780:	e9 36 ff ff ff       	jmpq   8006bb <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800785:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80078c:	e9 2a ff ff ff       	jmpq   8006bb <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800791:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800795:	79 12                	jns    8007a9 <vprintfmt+0x177>
				width = precision, precision = -1;
  800797:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80079a:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80079d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8007a4:	e9 12 ff ff ff       	jmpq   8006bb <vprintfmt+0x89>
  8007a9:	e9 0d ff ff ff       	jmpq   8006bb <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007ae:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8007b2:	e9 04 ff ff ff       	jmpq   8006bb <vprintfmt+0x89>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			putch(va_arg(aq, int), putdat);
  8007b7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007ba:	83 f8 30             	cmp    $0x30,%eax
  8007bd:	73 17                	jae    8007d6 <vprintfmt+0x1a4>
  8007bf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007c3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007c6:	89 c0                	mov    %eax,%eax
  8007c8:	48 01 d0             	add    %rdx,%rax
  8007cb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007ce:	83 c2 08             	add    $0x8,%edx
  8007d1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007d4:	eb 0f                	jmp    8007e5 <vprintfmt+0x1b3>
  8007d6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007da:	48 89 d0             	mov    %rdx,%rax
  8007dd:	48 83 c2 08          	add    $0x8,%rdx
  8007e1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007e5:	8b 10                	mov    (%rax),%edx
  8007e7:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8007eb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007ef:	48 89 ce             	mov    %rcx,%rsi
  8007f2:	89 d7                	mov    %edx,%edi
  8007f4:	ff d0                	callq  *%rax
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  8007f6:	e9 40 03 00 00       	jmpq   800b3b <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  8007fb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007fe:	83 f8 30             	cmp    $0x30,%eax
  800801:	73 17                	jae    80081a <vprintfmt+0x1e8>
  800803:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800807:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80080a:	89 c0                	mov    %eax,%eax
  80080c:	48 01 d0             	add    %rdx,%rax
  80080f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800812:	83 c2 08             	add    $0x8,%edx
  800815:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800818:	eb 0f                	jmp    800829 <vprintfmt+0x1f7>
  80081a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80081e:	48 89 d0             	mov    %rdx,%rax
  800821:	48 83 c2 08          	add    $0x8,%rdx
  800825:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800829:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80082b:	85 db                	test   %ebx,%ebx
  80082d:	79 02                	jns    800831 <vprintfmt+0x1ff>
				err = -err;
  80082f:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800831:	83 fb 09             	cmp    $0x9,%ebx
  800834:	7f 16                	jg     80084c <vprintfmt+0x21a>
  800836:	48 b8 80 1b 80 00 00 	movabs $0x801b80,%rax
  80083d:	00 00 00 
  800840:	48 63 d3             	movslq %ebx,%rdx
  800843:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800847:	4d 85 e4             	test   %r12,%r12
  80084a:	75 2e                	jne    80087a <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  80084c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800850:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800854:	89 d9                	mov    %ebx,%ecx
  800856:	48 ba e1 1b 80 00 00 	movabs $0x801be1,%rdx
  80085d:	00 00 00 
  800860:	48 89 c7             	mov    %rax,%rdi
  800863:	b8 00 00 00 00       	mov    $0x0,%eax
  800868:	49 b8 4a 0b 80 00 00 	movabs $0x800b4a,%r8
  80086f:	00 00 00 
  800872:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800875:	e9 c1 02 00 00       	jmpq   800b3b <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80087a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80087e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800882:	4c 89 e1             	mov    %r12,%rcx
  800885:	48 ba ea 1b 80 00 00 	movabs $0x801bea,%rdx
  80088c:	00 00 00 
  80088f:	48 89 c7             	mov    %rax,%rdi
  800892:	b8 00 00 00 00       	mov    $0x0,%eax
  800897:	49 b8 4a 0b 80 00 00 	movabs $0x800b4a,%r8
  80089e:	00 00 00 
  8008a1:	41 ff d0             	callq  *%r8
			break;
  8008a4:	e9 92 02 00 00       	jmpq   800b3b <vprintfmt+0x509>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
  8008a9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008ac:	83 f8 30             	cmp    $0x30,%eax
  8008af:	73 17                	jae    8008c8 <vprintfmt+0x296>
  8008b1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008b5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008b8:	89 c0                	mov    %eax,%eax
  8008ba:	48 01 d0             	add    %rdx,%rax
  8008bd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008c0:	83 c2 08             	add    $0x8,%edx
  8008c3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008c6:	eb 0f                	jmp    8008d7 <vprintfmt+0x2a5>
  8008c8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008cc:	48 89 d0             	mov    %rdx,%rax
  8008cf:	48 83 c2 08          	add    $0x8,%rdx
  8008d3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008d7:	4c 8b 20             	mov    (%rax),%r12
  8008da:	4d 85 e4             	test   %r12,%r12
  8008dd:	75 0a                	jne    8008e9 <vprintfmt+0x2b7>
				p = "(null)";
  8008df:	49 bc ed 1b 80 00 00 	movabs $0x801bed,%r12
  8008e6:	00 00 00 
			if (width > 0 && padc != '-')
  8008e9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008ed:	7e 3f                	jle    80092e <vprintfmt+0x2fc>
  8008ef:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8008f3:	74 39                	je     80092e <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f5:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008f8:	48 98                	cltq   
  8008fa:	48 89 c6             	mov    %rax,%rsi
  8008fd:	4c 89 e7             	mov    %r12,%rdi
  800900:	48 b8 f6 0d 80 00 00 	movabs $0x800df6,%rax
  800907:	00 00 00 
  80090a:	ff d0                	callq  *%rax
  80090c:	29 45 dc             	sub    %eax,-0x24(%rbp)
  80090f:	eb 17                	jmp    800928 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800911:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800915:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800919:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80091d:	48 89 ce             	mov    %rcx,%rsi
  800920:	89 d7                	mov    %edx,%edi
  800922:	ff d0                	callq  *%rax
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800924:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800928:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80092c:	7f e3                	jg     800911 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80092e:	eb 37                	jmp    800967 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800930:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800934:	74 1e                	je     800954 <vprintfmt+0x322>
  800936:	83 fb 1f             	cmp    $0x1f,%ebx
  800939:	7e 05                	jle    800940 <vprintfmt+0x30e>
  80093b:	83 fb 7e             	cmp    $0x7e,%ebx
  80093e:	7e 14                	jle    800954 <vprintfmt+0x322>
					putch('?', putdat);
  800940:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800944:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800948:	48 89 d6             	mov    %rdx,%rsi
  80094b:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800950:	ff d0                	callq  *%rax
  800952:	eb 0f                	jmp    800963 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800954:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800958:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80095c:	48 89 d6             	mov    %rdx,%rsi
  80095f:	89 df                	mov    %ebx,%edi
  800961:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800963:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800967:	4c 89 e0             	mov    %r12,%rax
  80096a:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80096e:	0f b6 00             	movzbl (%rax),%eax
  800971:	0f be d8             	movsbl %al,%ebx
  800974:	85 db                	test   %ebx,%ebx
  800976:	74 10                	je     800988 <vprintfmt+0x356>
  800978:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80097c:	78 b2                	js     800930 <vprintfmt+0x2fe>
  80097e:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800982:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800986:	79 a8                	jns    800930 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800988:	eb 16                	jmp    8009a0 <vprintfmt+0x36e>
				putch(' ', putdat);
  80098a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80098e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800992:	48 89 d6             	mov    %rdx,%rsi
  800995:	bf 20 00 00 00       	mov    $0x20,%edi
  80099a:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80099c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009a0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009a4:	7f e4                	jg     80098a <vprintfmt+0x358>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  8009a6:	e9 90 01 00 00       	jmpq   800b3b <vprintfmt+0x509>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getint(&aq, 3);
  8009ab:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009af:	be 03 00 00 00       	mov    $0x3,%esi
  8009b4:	48 89 c7             	mov    %rax,%rdi
  8009b7:	48 b8 22 05 80 00 00 	movabs $0x800522,%rax
  8009be:	00 00 00 
  8009c1:	ff d0                	callq  *%rax
  8009c3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8009c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009cb:	48 85 c0             	test   %rax,%rax
  8009ce:	79 1d                	jns    8009ed <vprintfmt+0x3bb>
				putch('-', putdat);
  8009d0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009d4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009d8:	48 89 d6             	mov    %rdx,%rsi
  8009db:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8009e0:	ff d0                	callq  *%rax
				num = -(long long) num;
  8009e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e6:	48 f7 d8             	neg    %rax
  8009e9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8009ed:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009f4:	e9 d5 00 00 00       	jmpq   800ace <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			
			num = getuint(&aq, 3);
  8009f9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009fd:	be 03 00 00 00       	mov    $0x3,%esi
  800a02:	48 89 c7             	mov    %rax,%rdi
  800a05:	48 b8 12 04 80 00 00 	movabs $0x800412,%rax
  800a0c:	00 00 00 
  800a0f:	ff d0                	callq  *%rax
  800a11:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a15:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a1c:	e9 ad 00 00 00       	jmpq   800ace <vprintfmt+0x49c>
                  ch = *(unsigned char *) color;
                }
#endif

			// Replace this with your code.
		        num = getuint(&aq, 3);
  800a21:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a25:	be 03 00 00 00       	mov    $0x3,%esi
  800a2a:	48 89 c7             	mov    %rax,%rdi
  800a2d:	48 b8 12 04 80 00 00 	movabs $0x800412,%rax
  800a34:	00 00 00 
  800a37:	ff d0                	callq  *%rax
  800a39:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800a3d:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800a44:	e9 85 00 00 00       	jmpq   800ace <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			putch('0', putdat);
  800a49:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a4d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a51:	48 89 d6             	mov    %rdx,%rsi
  800a54:	bf 30 00 00 00       	mov    $0x30,%edi
  800a59:	ff d0                	callq  *%rax
			putch('x', putdat);
  800a5b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a5f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a63:	48 89 d6             	mov    %rdx,%rsi
  800a66:	bf 78 00 00 00       	mov    $0x78,%edi
  800a6b:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a6d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a70:	83 f8 30             	cmp    $0x30,%eax
  800a73:	73 17                	jae    800a8c <vprintfmt+0x45a>
  800a75:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a79:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a7c:	89 c0                	mov    %eax,%eax
  800a7e:	48 01 d0             	add    %rdx,%rax
  800a81:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a84:	83 c2 08             	add    $0x8,%edx
  800a87:	89 55 b8             	mov    %edx,-0x48(%rbp)
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a8a:	eb 0f                	jmp    800a9b <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800a8c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a90:	48 89 d0             	mov    %rdx,%rax
  800a93:	48 83 c2 08          	add    $0x8,%rdx
  800a97:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a9b:	48 8b 00             	mov    (%rax),%rax
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a9e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800aa2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800aa9:	eb 23                	jmp    800ace <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getuint(&aq, 3);
  800aab:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800aaf:	be 03 00 00 00       	mov    $0x3,%esi
  800ab4:	48 89 c7             	mov    %rax,%rdi
  800ab7:	48 b8 12 04 80 00 00 	movabs $0x800412,%rax
  800abe:	00 00 00 
  800ac1:	ff d0                	callq  *%rax
  800ac3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ac7:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:

			printnum(putch, putdat, num, base, width, padc);
  800ace:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ad3:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ad6:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ad9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800add:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ae1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae5:	45 89 c1             	mov    %r8d,%r9d
  800ae8:	41 89 f8             	mov    %edi,%r8d
  800aeb:	48 89 c7             	mov    %rax,%rdi
  800aee:	48 b8 57 03 80 00 00 	movabs $0x800357,%rax
  800af5:	00 00 00 
  800af8:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			break;
  800afa:	eb 3f                	jmp    800b3b <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800afc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b00:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b04:	48 89 d6             	mov    %rdx,%rsi
  800b07:	89 df                	mov    %ebx,%edi
  800b09:	ff d0                	callq  *%rax
			break;
  800b0b:	eb 2e                	jmp    800b3b <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b0d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b11:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b15:	48 89 d6             	mov    %rdx,%rsi
  800b18:	bf 25 00 00 00       	mov    $0x25,%edi
  800b1d:	ff d0                	callq  *%rax

			for (fmt--; fmt[-1] != '%'; fmt--)
  800b1f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b24:	eb 05                	jmp    800b2b <vprintfmt+0x4f9>
  800b26:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b2b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b2f:	48 83 e8 01          	sub    $0x1,%rax
  800b33:	0f b6 00             	movzbl (%rax),%eax
  800b36:	3c 25                	cmp    $0x25,%al
  800b38:	75 ec                	jne    800b26 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800b3a:	90                   	nop
		}
	}
  800b3b:	90                   	nop
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b3c:	e9 43 fb ff ff       	jmpq   800684 <vprintfmt+0x52>
			break;
		}
	}
    
va_end(aq);
}
  800b41:	48 83 c4 60          	add    $0x60,%rsp
  800b45:	5b                   	pop    %rbx
  800b46:	41 5c                	pop    %r12
  800b48:	5d                   	pop    %rbp
  800b49:	c3                   	retq   

0000000000800b4a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b4a:	55                   	push   %rbp
  800b4b:	48 89 e5             	mov    %rsp,%rbp
  800b4e:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b55:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b5c:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b63:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b6a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b71:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b78:	84 c0                	test   %al,%al
  800b7a:	74 20                	je     800b9c <printfmt+0x52>
  800b7c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b80:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b84:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b88:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b8c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b90:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b94:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b98:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800b9c:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800ba3:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800baa:	00 00 00 
  800bad:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800bb4:	00 00 00 
  800bb7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800bbb:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800bc2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800bc9:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800bd0:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800bd7:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800bde:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800be5:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800bec:	48 89 c7             	mov    %rax,%rdi
  800bef:	48 b8 32 06 80 00 00 	movabs $0x800632,%rax
  800bf6:	00 00 00 
  800bf9:	ff d0                	callq  *%rax
	va_end(ap);
}
  800bfb:	c9                   	leaveq 
  800bfc:	c3                   	retq   

0000000000800bfd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bfd:	55                   	push   %rbp
  800bfe:	48 89 e5             	mov    %rsp,%rbp
  800c01:	48 83 ec 10          	sub    $0x10,%rsp
  800c05:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c08:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800c0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c10:	8b 40 10             	mov    0x10(%rax),%eax
  800c13:	8d 50 01             	lea    0x1(%rax),%edx
  800c16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c1a:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c21:	48 8b 10             	mov    (%rax),%rdx
  800c24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c28:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c2c:	48 39 c2             	cmp    %rax,%rdx
  800c2f:	73 17                	jae    800c48 <sprintputch+0x4b>
		*b->buf++ = ch;
  800c31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c35:	48 8b 00             	mov    (%rax),%rax
  800c38:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c3c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c40:	48 89 0a             	mov    %rcx,(%rdx)
  800c43:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c46:	88 10                	mov    %dl,(%rax)
}
  800c48:	c9                   	leaveq 
  800c49:	c3                   	retq   

0000000000800c4a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c4a:	55                   	push   %rbp
  800c4b:	48 89 e5             	mov    %rsp,%rbp
  800c4e:	48 83 ec 50          	sub    $0x50,%rsp
  800c52:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c56:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c59:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c5d:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c61:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c65:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c69:	48 8b 0a             	mov    (%rdx),%rcx
  800c6c:	48 89 08             	mov    %rcx,(%rax)
  800c6f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c73:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c77:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c7b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c7f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c83:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800c87:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800c8a:	48 98                	cltq   
  800c8c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800c90:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c94:	48 01 d0             	add    %rdx,%rax
  800c97:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800c9b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ca2:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ca7:	74 06                	je     800caf <vsnprintf+0x65>
  800ca9:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800cad:	7f 07                	jg     800cb6 <vsnprintf+0x6c>
		return -E_INVAL;
  800caf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cb4:	eb 2f                	jmp    800ce5 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800cb6:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800cba:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800cbe:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800cc2:	48 89 c6             	mov    %rax,%rsi
  800cc5:	48 bf fd 0b 80 00 00 	movabs $0x800bfd,%rdi
  800ccc:	00 00 00 
  800ccf:	48 b8 32 06 80 00 00 	movabs $0x800632,%rax
  800cd6:	00 00 00 
  800cd9:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800cdb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800cdf:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800ce2:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800ce5:	c9                   	leaveq 
  800ce6:	c3                   	retq   

0000000000800ce7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ce7:	55                   	push   %rbp
  800ce8:	48 89 e5             	mov    %rsp,%rbp
  800ceb:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800cf2:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800cf9:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800cff:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d06:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d0d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d14:	84 c0                	test   %al,%al
  800d16:	74 20                	je     800d38 <snprintf+0x51>
  800d18:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d1c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d20:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d24:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d28:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d2c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d30:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d34:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d38:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d3f:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d46:	00 00 00 
  800d49:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d50:	00 00 00 
  800d53:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d57:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d5e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d65:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d6c:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800d73:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800d7a:	48 8b 0a             	mov    (%rdx),%rcx
  800d7d:	48 89 08             	mov    %rcx,(%rax)
  800d80:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d84:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d88:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d8c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800d90:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800d97:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800d9e:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800da4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800dab:	48 89 c7             	mov    %rax,%rdi
  800dae:	48 b8 4a 0c 80 00 00 	movabs $0x800c4a,%rax
  800db5:	00 00 00 
  800db8:	ff d0                	callq  *%rax
  800dba:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800dc0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800dc6:	c9                   	leaveq 
  800dc7:	c3                   	retq   

0000000000800dc8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800dc8:	55                   	push   %rbp
  800dc9:	48 89 e5             	mov    %rsp,%rbp
  800dcc:	48 83 ec 18          	sub    $0x18,%rsp
  800dd0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800dd4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ddb:	eb 09                	jmp    800de6 <strlen+0x1e>
		n++;
  800ddd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800de1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800de6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dea:	0f b6 00             	movzbl (%rax),%eax
  800ded:	84 c0                	test   %al,%al
  800def:	75 ec                	jne    800ddd <strlen+0x15>
		n++;
	return n;
  800df1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800df4:	c9                   	leaveq 
  800df5:	c3                   	retq   

0000000000800df6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800df6:	55                   	push   %rbp
  800df7:	48 89 e5             	mov    %rsp,%rbp
  800dfa:	48 83 ec 20          	sub    $0x20,%rsp
  800dfe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e02:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e0d:	eb 0e                	jmp    800e1d <strnlen+0x27>
		n++;
  800e0f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e13:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e18:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e1d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e22:	74 0b                	je     800e2f <strnlen+0x39>
  800e24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e28:	0f b6 00             	movzbl (%rax),%eax
  800e2b:	84 c0                	test   %al,%al
  800e2d:	75 e0                	jne    800e0f <strnlen+0x19>
		n++;
	return n;
  800e2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e32:	c9                   	leaveq 
  800e33:	c3                   	retq   

0000000000800e34 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e34:	55                   	push   %rbp
  800e35:	48 89 e5             	mov    %rsp,%rbp
  800e38:	48 83 ec 20          	sub    $0x20,%rsp
  800e3c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e40:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e48:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800e4c:	90                   	nop
  800e4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e51:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e55:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e59:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e5d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e61:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800e65:	0f b6 12             	movzbl (%rdx),%edx
  800e68:	88 10                	mov    %dl,(%rax)
  800e6a:	0f b6 00             	movzbl (%rax),%eax
  800e6d:	84 c0                	test   %al,%al
  800e6f:	75 dc                	jne    800e4d <strcpy+0x19>
		/* do nothing */;
	return ret;
  800e71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e75:	c9                   	leaveq 
  800e76:	c3                   	retq   

0000000000800e77 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e77:	55                   	push   %rbp
  800e78:	48 89 e5             	mov    %rsp,%rbp
  800e7b:	48 83 ec 20          	sub    $0x20,%rsp
  800e7f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e83:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800e87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e8b:	48 89 c7             	mov    %rax,%rdi
  800e8e:	48 b8 c8 0d 80 00 00 	movabs $0x800dc8,%rax
  800e95:	00 00 00 
  800e98:	ff d0                	callq  *%rax
  800e9a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800e9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ea0:	48 63 d0             	movslq %eax,%rdx
  800ea3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea7:	48 01 c2             	add    %rax,%rdx
  800eaa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800eae:	48 89 c6             	mov    %rax,%rsi
  800eb1:	48 89 d7             	mov    %rdx,%rdi
  800eb4:	48 b8 34 0e 80 00 00 	movabs $0x800e34,%rax
  800ebb:	00 00 00 
  800ebe:	ff d0                	callq  *%rax
	return dst;
  800ec0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800ec4:	c9                   	leaveq 
  800ec5:	c3                   	retq   

0000000000800ec6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ec6:	55                   	push   %rbp
  800ec7:	48 89 e5             	mov    %rsp,%rbp
  800eca:	48 83 ec 28          	sub    $0x28,%rsp
  800ece:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ed2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800ed6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800eda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ede:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800ee2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800ee9:	00 
  800eea:	eb 2a                	jmp    800f16 <strncpy+0x50>
		*dst++ = *src;
  800eec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ef0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ef4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ef8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800efc:	0f b6 12             	movzbl (%rdx),%edx
  800eff:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f01:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f05:	0f b6 00             	movzbl (%rax),%eax
  800f08:	84 c0                	test   %al,%al
  800f0a:	74 05                	je     800f11 <strncpy+0x4b>
			src++;
  800f0c:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f11:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f1a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f1e:	72 cc                	jb     800eec <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f24:	c9                   	leaveq 
  800f25:	c3                   	retq   

0000000000800f26 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f26:	55                   	push   %rbp
  800f27:	48 89 e5             	mov    %rsp,%rbp
  800f2a:	48 83 ec 28          	sub    $0x28,%rsp
  800f2e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f32:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f36:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f3e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f42:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f47:	74 3d                	je     800f86 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800f49:	eb 1d                	jmp    800f68 <strlcpy+0x42>
			*dst++ = *src++;
  800f4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f4f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f53:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f57:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f5b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f5f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f63:	0f b6 12             	movzbl (%rdx),%edx
  800f66:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f68:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f6d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f72:	74 0b                	je     800f7f <strlcpy+0x59>
  800f74:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f78:	0f b6 00             	movzbl (%rax),%eax
  800f7b:	84 c0                	test   %al,%al
  800f7d:	75 cc                	jne    800f4b <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800f7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f83:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800f86:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f8a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f8e:	48 29 c2             	sub    %rax,%rdx
  800f91:	48 89 d0             	mov    %rdx,%rax
}
  800f94:	c9                   	leaveq 
  800f95:	c3                   	retq   

0000000000800f96 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f96:	55                   	push   %rbp
  800f97:	48 89 e5             	mov    %rsp,%rbp
  800f9a:	48 83 ec 10          	sub    $0x10,%rsp
  800f9e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fa2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800fa6:	eb 0a                	jmp    800fb2 <strcmp+0x1c>
		p++, q++;
  800fa8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fad:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fb2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fb6:	0f b6 00             	movzbl (%rax),%eax
  800fb9:	84 c0                	test   %al,%al
  800fbb:	74 12                	je     800fcf <strcmp+0x39>
  800fbd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fc1:	0f b6 10             	movzbl (%rax),%edx
  800fc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fc8:	0f b6 00             	movzbl (%rax),%eax
  800fcb:	38 c2                	cmp    %al,%dl
  800fcd:	74 d9                	je     800fa8 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fcf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fd3:	0f b6 00             	movzbl (%rax),%eax
  800fd6:	0f b6 d0             	movzbl %al,%edx
  800fd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fdd:	0f b6 00             	movzbl (%rax),%eax
  800fe0:	0f b6 c0             	movzbl %al,%eax
  800fe3:	29 c2                	sub    %eax,%edx
  800fe5:	89 d0                	mov    %edx,%eax
}
  800fe7:	c9                   	leaveq 
  800fe8:	c3                   	retq   

0000000000800fe9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800fe9:	55                   	push   %rbp
  800fea:	48 89 e5             	mov    %rsp,%rbp
  800fed:	48 83 ec 18          	sub    $0x18,%rsp
  800ff1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800ff5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800ff9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  800ffd:	eb 0f                	jmp    80100e <strncmp+0x25>
		n--, p++, q++;
  800fff:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801004:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801009:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80100e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801013:	74 1d                	je     801032 <strncmp+0x49>
  801015:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801019:	0f b6 00             	movzbl (%rax),%eax
  80101c:	84 c0                	test   %al,%al
  80101e:	74 12                	je     801032 <strncmp+0x49>
  801020:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801024:	0f b6 10             	movzbl (%rax),%edx
  801027:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80102b:	0f b6 00             	movzbl (%rax),%eax
  80102e:	38 c2                	cmp    %al,%dl
  801030:	74 cd                	je     800fff <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801032:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801037:	75 07                	jne    801040 <strncmp+0x57>
		return 0;
  801039:	b8 00 00 00 00       	mov    $0x0,%eax
  80103e:	eb 18                	jmp    801058 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801040:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801044:	0f b6 00             	movzbl (%rax),%eax
  801047:	0f b6 d0             	movzbl %al,%edx
  80104a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80104e:	0f b6 00             	movzbl (%rax),%eax
  801051:	0f b6 c0             	movzbl %al,%eax
  801054:	29 c2                	sub    %eax,%edx
  801056:	89 d0                	mov    %edx,%eax
}
  801058:	c9                   	leaveq 
  801059:	c3                   	retq   

000000000080105a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80105a:	55                   	push   %rbp
  80105b:	48 89 e5             	mov    %rsp,%rbp
  80105e:	48 83 ec 0c          	sub    $0xc,%rsp
  801062:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801066:	89 f0                	mov    %esi,%eax
  801068:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80106b:	eb 17                	jmp    801084 <strchr+0x2a>
		if (*s == c)
  80106d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801071:	0f b6 00             	movzbl (%rax),%eax
  801074:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801077:	75 06                	jne    80107f <strchr+0x25>
			return (char *) s;
  801079:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80107d:	eb 15                	jmp    801094 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80107f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801084:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801088:	0f b6 00             	movzbl (%rax),%eax
  80108b:	84 c0                	test   %al,%al
  80108d:	75 de                	jne    80106d <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80108f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801094:	c9                   	leaveq 
  801095:	c3                   	retq   

0000000000801096 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801096:	55                   	push   %rbp
  801097:	48 89 e5             	mov    %rsp,%rbp
  80109a:	48 83 ec 0c          	sub    $0xc,%rsp
  80109e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010a2:	89 f0                	mov    %esi,%eax
  8010a4:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010a7:	eb 13                	jmp    8010bc <strfind+0x26>
		if (*s == c)
  8010a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010ad:	0f b6 00             	movzbl (%rax),%eax
  8010b0:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010b3:	75 02                	jne    8010b7 <strfind+0x21>
			break;
  8010b5:	eb 10                	jmp    8010c7 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010b7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010c0:	0f b6 00             	movzbl (%rax),%eax
  8010c3:	84 c0                	test   %al,%al
  8010c5:	75 e2                	jne    8010a9 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8010c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010cb:	c9                   	leaveq 
  8010cc:	c3                   	retq   

00000000008010cd <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8010cd:	55                   	push   %rbp
  8010ce:	48 89 e5             	mov    %rsp,%rbp
  8010d1:	48 83 ec 18          	sub    $0x18,%rsp
  8010d5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010d9:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8010dc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8010e0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010e5:	75 06                	jne    8010ed <memset+0x20>
		return v;
  8010e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010eb:	eb 69                	jmp    801156 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8010ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010f1:	83 e0 03             	and    $0x3,%eax
  8010f4:	48 85 c0             	test   %rax,%rax
  8010f7:	75 48                	jne    801141 <memset+0x74>
  8010f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010fd:	83 e0 03             	and    $0x3,%eax
  801100:	48 85 c0             	test   %rax,%rax
  801103:	75 3c                	jne    801141 <memset+0x74>
		c &= 0xFF;
  801105:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80110c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80110f:	c1 e0 18             	shl    $0x18,%eax
  801112:	89 c2                	mov    %eax,%edx
  801114:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801117:	c1 e0 10             	shl    $0x10,%eax
  80111a:	09 c2                	or     %eax,%edx
  80111c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80111f:	c1 e0 08             	shl    $0x8,%eax
  801122:	09 d0                	or     %edx,%eax
  801124:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801127:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80112b:	48 c1 e8 02          	shr    $0x2,%rax
  80112f:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801132:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801136:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801139:	48 89 d7             	mov    %rdx,%rdi
  80113c:	fc                   	cld    
  80113d:	f3 ab                	rep stos %eax,%es:(%rdi)
  80113f:	eb 11                	jmp    801152 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801141:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801145:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801148:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80114c:	48 89 d7             	mov    %rdx,%rdi
  80114f:	fc                   	cld    
  801150:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801152:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801156:	c9                   	leaveq 
  801157:	c3                   	retq   

0000000000801158 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801158:	55                   	push   %rbp
  801159:	48 89 e5             	mov    %rsp,%rbp
  80115c:	48 83 ec 28          	sub    $0x28,%rsp
  801160:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801164:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801168:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80116c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801170:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801174:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801178:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80117c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801180:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801184:	0f 83 88 00 00 00    	jae    801212 <memmove+0xba>
  80118a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80118e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801192:	48 01 d0             	add    %rdx,%rax
  801195:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801199:	76 77                	jbe    801212 <memmove+0xba>
		s += n;
  80119b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80119f:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8011a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011a7:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011af:	83 e0 03             	and    $0x3,%eax
  8011b2:	48 85 c0             	test   %rax,%rax
  8011b5:	75 3b                	jne    8011f2 <memmove+0x9a>
  8011b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011bb:	83 e0 03             	and    $0x3,%eax
  8011be:	48 85 c0             	test   %rax,%rax
  8011c1:	75 2f                	jne    8011f2 <memmove+0x9a>
  8011c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011c7:	83 e0 03             	and    $0x3,%eax
  8011ca:	48 85 c0             	test   %rax,%rax
  8011cd:	75 23                	jne    8011f2 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8011cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011d3:	48 83 e8 04          	sub    $0x4,%rax
  8011d7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011db:	48 83 ea 04          	sub    $0x4,%rdx
  8011df:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8011e3:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8011e7:	48 89 c7             	mov    %rax,%rdi
  8011ea:	48 89 d6             	mov    %rdx,%rsi
  8011ed:	fd                   	std    
  8011ee:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8011f0:	eb 1d                	jmp    80120f <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8011f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8011fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011fe:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801202:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801206:	48 89 d7             	mov    %rdx,%rdi
  801209:	48 89 c1             	mov    %rax,%rcx
  80120c:	fd                   	std    
  80120d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80120f:	fc                   	cld    
  801210:	eb 57                	jmp    801269 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801212:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801216:	83 e0 03             	and    $0x3,%eax
  801219:	48 85 c0             	test   %rax,%rax
  80121c:	75 36                	jne    801254 <memmove+0xfc>
  80121e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801222:	83 e0 03             	and    $0x3,%eax
  801225:	48 85 c0             	test   %rax,%rax
  801228:	75 2a                	jne    801254 <memmove+0xfc>
  80122a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80122e:	83 e0 03             	and    $0x3,%eax
  801231:	48 85 c0             	test   %rax,%rax
  801234:	75 1e                	jne    801254 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801236:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80123a:	48 c1 e8 02          	shr    $0x2,%rax
  80123e:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801241:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801245:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801249:	48 89 c7             	mov    %rax,%rdi
  80124c:	48 89 d6             	mov    %rdx,%rsi
  80124f:	fc                   	cld    
  801250:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801252:	eb 15                	jmp    801269 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801254:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801258:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80125c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801260:	48 89 c7             	mov    %rax,%rdi
  801263:	48 89 d6             	mov    %rdx,%rsi
  801266:	fc                   	cld    
  801267:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801269:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80126d:	c9                   	leaveq 
  80126e:	c3                   	retq   

000000000080126f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80126f:	55                   	push   %rbp
  801270:	48 89 e5             	mov    %rsp,%rbp
  801273:	48 83 ec 18          	sub    $0x18,%rsp
  801277:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80127b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80127f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801283:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801287:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80128b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80128f:	48 89 ce             	mov    %rcx,%rsi
  801292:	48 89 c7             	mov    %rax,%rdi
  801295:	48 b8 58 11 80 00 00 	movabs $0x801158,%rax
  80129c:	00 00 00 
  80129f:	ff d0                	callq  *%rax
}
  8012a1:	c9                   	leaveq 
  8012a2:	c3                   	retq   

00000000008012a3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8012a3:	55                   	push   %rbp
  8012a4:	48 89 e5             	mov    %rsp,%rbp
  8012a7:	48 83 ec 28          	sub    $0x28,%rsp
  8012ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012af:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012b3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8012b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012bb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8012bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012c3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8012c7:	eb 36                	jmp    8012ff <memcmp+0x5c>
		if (*s1 != *s2)
  8012c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012cd:	0f b6 10             	movzbl (%rax),%edx
  8012d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012d4:	0f b6 00             	movzbl (%rax),%eax
  8012d7:	38 c2                	cmp    %al,%dl
  8012d9:	74 1a                	je     8012f5 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8012db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012df:	0f b6 00             	movzbl (%rax),%eax
  8012e2:	0f b6 d0             	movzbl %al,%edx
  8012e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012e9:	0f b6 00             	movzbl (%rax),%eax
  8012ec:	0f b6 c0             	movzbl %al,%eax
  8012ef:	29 c2                	sub    %eax,%edx
  8012f1:	89 d0                	mov    %edx,%eax
  8012f3:	eb 20                	jmp    801315 <memcmp+0x72>
		s1++, s2++;
  8012f5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012fa:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8012ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801303:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801307:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80130b:	48 85 c0             	test   %rax,%rax
  80130e:	75 b9                	jne    8012c9 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801310:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801315:	c9                   	leaveq 
  801316:	c3                   	retq   

0000000000801317 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801317:	55                   	push   %rbp
  801318:	48 89 e5             	mov    %rsp,%rbp
  80131b:	48 83 ec 28          	sub    $0x28,%rsp
  80131f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801323:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801326:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80132a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80132e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801332:	48 01 d0             	add    %rdx,%rax
  801335:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801339:	eb 15                	jmp    801350 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80133b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80133f:	0f b6 10             	movzbl (%rax),%edx
  801342:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801345:	38 c2                	cmp    %al,%dl
  801347:	75 02                	jne    80134b <memfind+0x34>
			break;
  801349:	eb 0f                	jmp    80135a <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80134b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801350:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801354:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801358:	72 e1                	jb     80133b <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80135a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80135e:	c9                   	leaveq 
  80135f:	c3                   	retq   

0000000000801360 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801360:	55                   	push   %rbp
  801361:	48 89 e5             	mov    %rsp,%rbp
  801364:	48 83 ec 34          	sub    $0x34,%rsp
  801368:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80136c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801370:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801373:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80137a:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801381:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801382:	eb 05                	jmp    801389 <strtol+0x29>
		s++;
  801384:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801389:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80138d:	0f b6 00             	movzbl (%rax),%eax
  801390:	3c 20                	cmp    $0x20,%al
  801392:	74 f0                	je     801384 <strtol+0x24>
  801394:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801398:	0f b6 00             	movzbl (%rax),%eax
  80139b:	3c 09                	cmp    $0x9,%al
  80139d:	74 e5                	je     801384 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80139f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a3:	0f b6 00             	movzbl (%rax),%eax
  8013a6:	3c 2b                	cmp    $0x2b,%al
  8013a8:	75 07                	jne    8013b1 <strtol+0x51>
		s++;
  8013aa:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013af:	eb 17                	jmp    8013c8 <strtol+0x68>
	else if (*s == '-')
  8013b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b5:	0f b6 00             	movzbl (%rax),%eax
  8013b8:	3c 2d                	cmp    $0x2d,%al
  8013ba:	75 0c                	jne    8013c8 <strtol+0x68>
		s++, neg = 1;
  8013bc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013c1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013c8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013cc:	74 06                	je     8013d4 <strtol+0x74>
  8013ce:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8013d2:	75 28                	jne    8013fc <strtol+0x9c>
  8013d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d8:	0f b6 00             	movzbl (%rax),%eax
  8013db:	3c 30                	cmp    $0x30,%al
  8013dd:	75 1d                	jne    8013fc <strtol+0x9c>
  8013df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e3:	48 83 c0 01          	add    $0x1,%rax
  8013e7:	0f b6 00             	movzbl (%rax),%eax
  8013ea:	3c 78                	cmp    $0x78,%al
  8013ec:	75 0e                	jne    8013fc <strtol+0x9c>
		s += 2, base = 16;
  8013ee:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8013f3:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8013fa:	eb 2c                	jmp    801428 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8013fc:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801400:	75 19                	jne    80141b <strtol+0xbb>
  801402:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801406:	0f b6 00             	movzbl (%rax),%eax
  801409:	3c 30                	cmp    $0x30,%al
  80140b:	75 0e                	jne    80141b <strtol+0xbb>
		s++, base = 8;
  80140d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801412:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801419:	eb 0d                	jmp    801428 <strtol+0xc8>
	else if (base == 0)
  80141b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80141f:	75 07                	jne    801428 <strtol+0xc8>
		base = 10;
  801421:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801428:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142c:	0f b6 00             	movzbl (%rax),%eax
  80142f:	3c 2f                	cmp    $0x2f,%al
  801431:	7e 1d                	jle    801450 <strtol+0xf0>
  801433:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801437:	0f b6 00             	movzbl (%rax),%eax
  80143a:	3c 39                	cmp    $0x39,%al
  80143c:	7f 12                	jg     801450 <strtol+0xf0>
			dig = *s - '0';
  80143e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801442:	0f b6 00             	movzbl (%rax),%eax
  801445:	0f be c0             	movsbl %al,%eax
  801448:	83 e8 30             	sub    $0x30,%eax
  80144b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80144e:	eb 4e                	jmp    80149e <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801450:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801454:	0f b6 00             	movzbl (%rax),%eax
  801457:	3c 60                	cmp    $0x60,%al
  801459:	7e 1d                	jle    801478 <strtol+0x118>
  80145b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145f:	0f b6 00             	movzbl (%rax),%eax
  801462:	3c 7a                	cmp    $0x7a,%al
  801464:	7f 12                	jg     801478 <strtol+0x118>
			dig = *s - 'a' + 10;
  801466:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80146a:	0f b6 00             	movzbl (%rax),%eax
  80146d:	0f be c0             	movsbl %al,%eax
  801470:	83 e8 57             	sub    $0x57,%eax
  801473:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801476:	eb 26                	jmp    80149e <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801478:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147c:	0f b6 00             	movzbl (%rax),%eax
  80147f:	3c 40                	cmp    $0x40,%al
  801481:	7e 48                	jle    8014cb <strtol+0x16b>
  801483:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801487:	0f b6 00             	movzbl (%rax),%eax
  80148a:	3c 5a                	cmp    $0x5a,%al
  80148c:	7f 3d                	jg     8014cb <strtol+0x16b>
			dig = *s - 'A' + 10;
  80148e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801492:	0f b6 00             	movzbl (%rax),%eax
  801495:	0f be c0             	movsbl %al,%eax
  801498:	83 e8 37             	sub    $0x37,%eax
  80149b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80149e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014a1:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8014a4:	7c 02                	jl     8014a8 <strtol+0x148>
			break;
  8014a6:	eb 23                	jmp    8014cb <strtol+0x16b>
		s++, val = (val * base) + dig;
  8014a8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014ad:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8014b0:	48 98                	cltq   
  8014b2:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8014b7:	48 89 c2             	mov    %rax,%rdx
  8014ba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014bd:	48 98                	cltq   
  8014bf:	48 01 d0             	add    %rdx,%rax
  8014c2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8014c6:	e9 5d ff ff ff       	jmpq   801428 <strtol+0xc8>

	if (endptr)
  8014cb:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8014d0:	74 0b                	je     8014dd <strtol+0x17d>
		*endptr = (char *) s;
  8014d2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014d6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8014da:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8014dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014e1:	74 09                	je     8014ec <strtol+0x18c>
  8014e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014e7:	48 f7 d8             	neg    %rax
  8014ea:	eb 04                	jmp    8014f0 <strtol+0x190>
  8014ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014f0:	c9                   	leaveq 
  8014f1:	c3                   	retq   

00000000008014f2 <strstr>:

char * strstr(const char *in, const char *str)
{
  8014f2:	55                   	push   %rbp
  8014f3:	48 89 e5             	mov    %rsp,%rbp
  8014f6:	48 83 ec 30          	sub    $0x30,%rsp
  8014fa:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014fe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801502:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801506:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80150a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80150e:	0f b6 00             	movzbl (%rax),%eax
  801511:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  801514:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801518:	75 06                	jne    801520 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  80151a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80151e:	eb 6b                	jmp    80158b <strstr+0x99>

    len = strlen(str);
  801520:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801524:	48 89 c7             	mov    %rax,%rdi
  801527:	48 b8 c8 0d 80 00 00 	movabs $0x800dc8,%rax
  80152e:	00 00 00 
  801531:	ff d0                	callq  *%rax
  801533:	48 98                	cltq   
  801535:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801539:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801541:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801545:	0f b6 00             	movzbl (%rax),%eax
  801548:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  80154b:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80154f:	75 07                	jne    801558 <strstr+0x66>
                return (char *) 0;
  801551:	b8 00 00 00 00       	mov    $0x0,%eax
  801556:	eb 33                	jmp    80158b <strstr+0x99>
        } while (sc != c);
  801558:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80155c:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80155f:	75 d8                	jne    801539 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801561:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801565:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801569:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156d:	48 89 ce             	mov    %rcx,%rsi
  801570:	48 89 c7             	mov    %rax,%rdi
  801573:	48 b8 e9 0f 80 00 00 	movabs $0x800fe9,%rax
  80157a:	00 00 00 
  80157d:	ff d0                	callq  *%rax
  80157f:	85 c0                	test   %eax,%eax
  801581:	75 b6                	jne    801539 <strstr+0x47>

    return (char *) (in - 1);
  801583:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801587:	48 83 e8 01          	sub    $0x1,%rax
}
  80158b:	c9                   	leaveq 
  80158c:	c3                   	retq   

000000000080158d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80158d:	55                   	push   %rbp
  80158e:	48 89 e5             	mov    %rsp,%rbp
  801591:	53                   	push   %rbx
  801592:	48 83 ec 48          	sub    $0x48,%rsp
  801596:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801599:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80159c:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015a0:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8015a4:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8015a8:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015ac:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015af:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8015b3:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8015b7:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8015bb:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8015bf:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8015c3:	4c 89 c3             	mov    %r8,%rbx
  8015c6:	cd 30                	int    $0x30
  8015c8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8015cc:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8015d0:	74 3e                	je     801610 <syscall+0x83>
  8015d2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015d7:	7e 37                	jle    801610 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015dd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015e0:	49 89 d0             	mov    %rdx,%r8
  8015e3:	89 c1                	mov    %eax,%ecx
  8015e5:	48 ba a8 1e 80 00 00 	movabs $0x801ea8,%rdx
  8015ec:	00 00 00 
  8015ef:	be 23 00 00 00       	mov    $0x23,%esi
  8015f4:	48 bf c5 1e 80 00 00 	movabs $0x801ec5,%rdi
  8015fb:	00 00 00 
  8015fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801603:	49 b9 86 19 80 00 00 	movabs $0x801986,%r9
  80160a:	00 00 00 
  80160d:	41 ff d1             	callq  *%r9

	return ret;
  801610:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801614:	48 83 c4 48          	add    $0x48,%rsp
  801618:	5b                   	pop    %rbx
  801619:	5d                   	pop    %rbp
  80161a:	c3                   	retq   

000000000080161b <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80161b:	55                   	push   %rbp
  80161c:	48 89 e5             	mov    %rsp,%rbp
  80161f:	48 83 ec 20          	sub    $0x20,%rsp
  801623:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801627:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80162b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80162f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801633:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80163a:	00 
  80163b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801641:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801647:	48 89 d1             	mov    %rdx,%rcx
  80164a:	48 89 c2             	mov    %rax,%rdx
  80164d:	be 00 00 00 00       	mov    $0x0,%esi
  801652:	bf 00 00 00 00       	mov    $0x0,%edi
  801657:	48 b8 8d 15 80 00 00 	movabs $0x80158d,%rax
  80165e:	00 00 00 
  801661:	ff d0                	callq  *%rax
}
  801663:	c9                   	leaveq 
  801664:	c3                   	retq   

0000000000801665 <sys_cgetc>:

int
sys_cgetc(void)
{
  801665:	55                   	push   %rbp
  801666:	48 89 e5             	mov    %rsp,%rbp
  801669:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80166d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801674:	00 
  801675:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80167b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801681:	b9 00 00 00 00       	mov    $0x0,%ecx
  801686:	ba 00 00 00 00       	mov    $0x0,%edx
  80168b:	be 00 00 00 00       	mov    $0x0,%esi
  801690:	bf 01 00 00 00       	mov    $0x1,%edi
  801695:	48 b8 8d 15 80 00 00 	movabs $0x80158d,%rax
  80169c:	00 00 00 
  80169f:	ff d0                	callq  *%rax
}
  8016a1:	c9                   	leaveq 
  8016a2:	c3                   	retq   

00000000008016a3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8016a3:	55                   	push   %rbp
  8016a4:	48 89 e5             	mov    %rsp,%rbp
  8016a7:	48 83 ec 10          	sub    $0x10,%rsp
  8016ab:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8016ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016b1:	48 98                	cltq   
  8016b3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016ba:	00 
  8016bb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016c1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016c7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016cc:	48 89 c2             	mov    %rax,%rdx
  8016cf:	be 01 00 00 00       	mov    $0x1,%esi
  8016d4:	bf 03 00 00 00       	mov    $0x3,%edi
  8016d9:	48 b8 8d 15 80 00 00 	movabs $0x80158d,%rax
  8016e0:	00 00 00 
  8016e3:	ff d0                	callq  *%rax
}
  8016e5:	c9                   	leaveq 
  8016e6:	c3                   	retq   

00000000008016e7 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8016e7:	55                   	push   %rbp
  8016e8:	48 89 e5             	mov    %rsp,%rbp
  8016eb:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8016ef:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016f6:	00 
  8016f7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016fd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801703:	b9 00 00 00 00       	mov    $0x0,%ecx
  801708:	ba 00 00 00 00       	mov    $0x0,%edx
  80170d:	be 00 00 00 00       	mov    $0x0,%esi
  801712:	bf 02 00 00 00       	mov    $0x2,%edi
  801717:	48 b8 8d 15 80 00 00 	movabs $0x80158d,%rax
  80171e:	00 00 00 
  801721:	ff d0                	callq  *%rax
}
  801723:	c9                   	leaveq 
  801724:	c3                   	retq   

0000000000801725 <sys_yield>:

void
sys_yield(void)
{
  801725:	55                   	push   %rbp
  801726:	48 89 e5             	mov    %rsp,%rbp
  801729:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80172d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801734:	00 
  801735:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80173b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801741:	b9 00 00 00 00       	mov    $0x0,%ecx
  801746:	ba 00 00 00 00       	mov    $0x0,%edx
  80174b:	be 00 00 00 00       	mov    $0x0,%esi
  801750:	bf 0a 00 00 00       	mov    $0xa,%edi
  801755:	48 b8 8d 15 80 00 00 	movabs $0x80158d,%rax
  80175c:	00 00 00 
  80175f:	ff d0                	callq  *%rax
}
  801761:	c9                   	leaveq 
  801762:	c3                   	retq   

0000000000801763 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801763:	55                   	push   %rbp
  801764:	48 89 e5             	mov    %rsp,%rbp
  801767:	48 83 ec 20          	sub    $0x20,%rsp
  80176b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80176e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801772:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801775:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801778:	48 63 c8             	movslq %eax,%rcx
  80177b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80177f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801782:	48 98                	cltq   
  801784:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80178b:	00 
  80178c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801792:	49 89 c8             	mov    %rcx,%r8
  801795:	48 89 d1             	mov    %rdx,%rcx
  801798:	48 89 c2             	mov    %rax,%rdx
  80179b:	be 01 00 00 00       	mov    $0x1,%esi
  8017a0:	bf 04 00 00 00       	mov    $0x4,%edi
  8017a5:	48 b8 8d 15 80 00 00 	movabs $0x80158d,%rax
  8017ac:	00 00 00 
  8017af:	ff d0                	callq  *%rax
}
  8017b1:	c9                   	leaveq 
  8017b2:	c3                   	retq   

00000000008017b3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8017b3:	55                   	push   %rbp
  8017b4:	48 89 e5             	mov    %rsp,%rbp
  8017b7:	48 83 ec 30          	sub    $0x30,%rsp
  8017bb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017be:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017c2:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8017c5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8017c9:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8017cd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8017d0:	48 63 c8             	movslq %eax,%rcx
  8017d3:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8017d7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017da:	48 63 f0             	movslq %eax,%rsi
  8017dd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017e4:	48 98                	cltq   
  8017e6:	48 89 0c 24          	mov    %rcx,(%rsp)
  8017ea:	49 89 f9             	mov    %rdi,%r9
  8017ed:	49 89 f0             	mov    %rsi,%r8
  8017f0:	48 89 d1             	mov    %rdx,%rcx
  8017f3:	48 89 c2             	mov    %rax,%rdx
  8017f6:	be 01 00 00 00       	mov    $0x1,%esi
  8017fb:	bf 05 00 00 00       	mov    $0x5,%edi
  801800:	48 b8 8d 15 80 00 00 	movabs $0x80158d,%rax
  801807:	00 00 00 
  80180a:	ff d0                	callq  *%rax
}
  80180c:	c9                   	leaveq 
  80180d:	c3                   	retq   

000000000080180e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80180e:	55                   	push   %rbp
  80180f:	48 89 e5             	mov    %rsp,%rbp
  801812:	48 83 ec 20          	sub    $0x20,%rsp
  801816:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801819:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80181d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801821:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801824:	48 98                	cltq   
  801826:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80182d:	00 
  80182e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801834:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80183a:	48 89 d1             	mov    %rdx,%rcx
  80183d:	48 89 c2             	mov    %rax,%rdx
  801840:	be 01 00 00 00       	mov    $0x1,%esi
  801845:	bf 06 00 00 00       	mov    $0x6,%edi
  80184a:	48 b8 8d 15 80 00 00 	movabs $0x80158d,%rax
  801851:	00 00 00 
  801854:	ff d0                	callq  *%rax
}
  801856:	c9                   	leaveq 
  801857:	c3                   	retq   

0000000000801858 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801858:	55                   	push   %rbp
  801859:	48 89 e5             	mov    %rsp,%rbp
  80185c:	48 83 ec 10          	sub    $0x10,%rsp
  801860:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801863:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801866:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801869:	48 63 d0             	movslq %eax,%rdx
  80186c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80186f:	48 98                	cltq   
  801871:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801878:	00 
  801879:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80187f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801885:	48 89 d1             	mov    %rdx,%rcx
  801888:	48 89 c2             	mov    %rax,%rdx
  80188b:	be 01 00 00 00       	mov    $0x1,%esi
  801890:	bf 08 00 00 00       	mov    $0x8,%edi
  801895:	48 b8 8d 15 80 00 00 	movabs $0x80158d,%rax
  80189c:	00 00 00 
  80189f:	ff d0                	callq  *%rax
}
  8018a1:	c9                   	leaveq 
  8018a2:	c3                   	retq   

00000000008018a3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8018a3:	55                   	push   %rbp
  8018a4:	48 89 e5             	mov    %rsp,%rbp
  8018a7:	48 83 ec 20          	sub    $0x20,%rsp
  8018ab:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018ae:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8018b2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018b9:	48 98                	cltq   
  8018bb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018c2:	00 
  8018c3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018c9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018cf:	48 89 d1             	mov    %rdx,%rcx
  8018d2:	48 89 c2             	mov    %rax,%rdx
  8018d5:	be 01 00 00 00       	mov    $0x1,%esi
  8018da:	bf 09 00 00 00       	mov    $0x9,%edi
  8018df:	48 b8 8d 15 80 00 00 	movabs $0x80158d,%rax
  8018e6:	00 00 00 
  8018e9:	ff d0                	callq  *%rax
}
  8018eb:	c9                   	leaveq 
  8018ec:	c3                   	retq   

00000000008018ed <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8018ed:	55                   	push   %rbp
  8018ee:	48 89 e5             	mov    %rsp,%rbp
  8018f1:	48 83 ec 20          	sub    $0x20,%rsp
  8018f5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018f8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018fc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801900:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801903:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801906:	48 63 f0             	movslq %eax,%rsi
  801909:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80190d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801910:	48 98                	cltq   
  801912:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801916:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80191d:	00 
  80191e:	49 89 f1             	mov    %rsi,%r9
  801921:	49 89 c8             	mov    %rcx,%r8
  801924:	48 89 d1             	mov    %rdx,%rcx
  801927:	48 89 c2             	mov    %rax,%rdx
  80192a:	be 00 00 00 00       	mov    $0x0,%esi
  80192f:	bf 0b 00 00 00       	mov    $0xb,%edi
  801934:	48 b8 8d 15 80 00 00 	movabs $0x80158d,%rax
  80193b:	00 00 00 
  80193e:	ff d0                	callq  *%rax
}
  801940:	c9                   	leaveq 
  801941:	c3                   	retq   

0000000000801942 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801942:	55                   	push   %rbp
  801943:	48 89 e5             	mov    %rsp,%rbp
  801946:	48 83 ec 10          	sub    $0x10,%rsp
  80194a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80194e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801952:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801959:	00 
  80195a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801960:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801966:	b9 00 00 00 00       	mov    $0x0,%ecx
  80196b:	48 89 c2             	mov    %rax,%rdx
  80196e:	be 01 00 00 00       	mov    $0x1,%esi
  801973:	bf 0c 00 00 00       	mov    $0xc,%edi
  801978:	48 b8 8d 15 80 00 00 	movabs $0x80158d,%rax
  80197f:	00 00 00 
  801982:	ff d0                	callq  *%rax
}
  801984:	c9                   	leaveq 
  801985:	c3                   	retq   

0000000000801986 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801986:	55                   	push   %rbp
  801987:	48 89 e5             	mov    %rsp,%rbp
  80198a:	53                   	push   %rbx
  80198b:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801992:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801999:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80199f:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8019a6:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8019ad:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8019b4:	84 c0                	test   %al,%al
  8019b6:	74 23                	je     8019db <_panic+0x55>
  8019b8:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8019bf:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8019c3:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8019c7:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8019cb:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8019cf:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8019d3:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8019d7:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8019db:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8019e2:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8019e9:	00 00 00 
  8019ec:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8019f3:	00 00 00 
  8019f6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8019fa:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801a01:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801a08:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801a0f:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  801a16:	00 00 00 
  801a19:	48 8b 18             	mov    (%rax),%rbx
  801a1c:	48 b8 e7 16 80 00 00 	movabs $0x8016e7,%rax
  801a23:	00 00 00 
  801a26:	ff d0                	callq  *%rax
  801a28:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  801a2e:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801a35:	41 89 c8             	mov    %ecx,%r8d
  801a38:	48 89 d1             	mov    %rdx,%rcx
  801a3b:	48 89 da             	mov    %rbx,%rdx
  801a3e:	89 c6                	mov    %eax,%esi
  801a40:	48 bf d8 1e 80 00 00 	movabs $0x801ed8,%rdi
  801a47:	00 00 00 
  801a4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801a4f:	49 b9 7f 02 80 00 00 	movabs $0x80027f,%r9
  801a56:	00 00 00 
  801a59:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801a5c:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801a63:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801a6a:	48 89 d6             	mov    %rdx,%rsi
  801a6d:	48 89 c7             	mov    %rax,%rdi
  801a70:	48 b8 d3 01 80 00 00 	movabs $0x8001d3,%rax
  801a77:	00 00 00 
  801a7a:	ff d0                	callq  *%rax
	cprintf("\n");
  801a7c:	48 bf fb 1e 80 00 00 	movabs $0x801efb,%rdi
  801a83:	00 00 00 
  801a86:	b8 00 00 00 00       	mov    $0x0,%eax
  801a8b:	48 ba 7f 02 80 00 00 	movabs $0x80027f,%rdx
  801a92:	00 00 00 
  801a95:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801a97:	cc                   	int3   
  801a98:	eb fd                	jmp    801a97 <_panic+0x111>
