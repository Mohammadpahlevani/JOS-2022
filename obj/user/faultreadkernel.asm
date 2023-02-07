
obj/user/faultreadkernel:     file format elf64-x86-64


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
  80003c:	e8 3c 00 00 00       	callq  80007d <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	cprintf("I read %08x from location 0x8004000000!\n", *(unsigned*)0x8004000000);
  800052:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  800059:	00 00 00 
  80005c:	8b 00                	mov    (%rax),%eax
  80005e:	89 c6                	mov    %eax,%esi
  800060:	48 bf 80 1a 80 00 00 	movabs $0x801a80,%rdi
  800067:	00 00 00 
  80006a:	b8 00 00 00 00       	mov    $0x0,%eax
  80006f:	48 ba 5d 02 80 00 00 	movabs $0x80025d,%rdx
  800076:	00 00 00 
  800079:	ff d2                	callq  *%rdx
}
  80007b:	c9                   	leaveq 
  80007c:	c3                   	retq   

000000000080007d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80007d:	55                   	push   %rbp
  80007e:	48 89 e5             	mov    %rsp,%rbp
  800081:	48 83 ec 20          	sub    $0x20,%rsp
  800085:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800088:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80008c:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  800093:	00 00 00 
  800096:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	envid_t id = sys_getenvid();
  80009d:	48 b8 c5 16 80 00 00 	movabs $0x8016c5,%rax
  8000a4:	00 00 00 
  8000a7:	ff d0                	callq  *%rax
  8000a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
        id = ENVX(id);
  8000ac:	81 65 fc ff 03 00 00 	andl   $0x3ff,-0x4(%rbp)
	thisenv = &envs[id];
  8000b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000b6:	48 63 d0             	movslq %eax,%rdx
  8000b9:	48 89 d0             	mov    %rdx,%rax
  8000bc:	48 c1 e0 03          	shl    $0x3,%rax
  8000c0:	48 01 d0             	add    %rdx,%rax
  8000c3:	48 c1 e0 05          	shl    $0x5,%rax
  8000c7:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000ce:	00 00 00 
  8000d1:	48 01 c2             	add    %rax,%rdx
  8000d4:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000db:	00 00 00 
  8000de:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000e5:	7e 14                	jle    8000fb <libmain+0x7e>
		binaryname = argv[0];
  8000e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000eb:	48 8b 10             	mov    (%rax),%rdx
  8000ee:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000f5:	00 00 00 
  8000f8:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000fb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8000ff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800102:	48 89 d6             	mov    %rdx,%rsi
  800105:	89 c7                	mov    %eax,%edi
  800107:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80010e:	00 00 00 
  800111:	ff d0                	callq  *%rax
	
	//cprintf("\noutside\n");
	// exit gracefully
	exit();
  800113:	48 b8 21 01 80 00 00 	movabs $0x800121,%rax
  80011a:	00 00 00 
  80011d:	ff d0                	callq  *%rax
}
  80011f:	c9                   	leaveq 
  800120:	c3                   	retq   

0000000000800121 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800121:	55                   	push   %rbp
  800122:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  800125:	bf 00 00 00 00       	mov    $0x0,%edi
  80012a:	48 b8 81 16 80 00 00 	movabs $0x801681,%rax
  800131:	00 00 00 
  800134:	ff d0                	callq  *%rax
}
  800136:	5d                   	pop    %rbp
  800137:	c3                   	retq   

0000000000800138 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800138:	55                   	push   %rbp
  800139:	48 89 e5             	mov    %rsp,%rbp
  80013c:	48 83 ec 10          	sub    $0x10,%rsp
  800140:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800143:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800147:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80014b:	8b 00                	mov    (%rax),%eax
  80014d:	8d 48 01             	lea    0x1(%rax),%ecx
  800150:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800154:	89 0a                	mov    %ecx,(%rdx)
  800156:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800159:	89 d1                	mov    %edx,%ecx
  80015b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80015f:	48 98                	cltq   
  800161:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  800165:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800169:	8b 00                	mov    (%rax),%eax
  80016b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800170:	75 2c                	jne    80019e <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800172:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800176:	8b 00                	mov    (%rax),%eax
  800178:	48 98                	cltq   
  80017a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80017e:	48 83 c2 08          	add    $0x8,%rdx
  800182:	48 89 c6             	mov    %rax,%rsi
  800185:	48 89 d7             	mov    %rdx,%rdi
  800188:	48 b8 f9 15 80 00 00 	movabs $0x8015f9,%rax
  80018f:	00 00 00 
  800192:	ff d0                	callq  *%rax
		b->idx = 0;
  800194:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800198:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  80019e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001a2:	8b 40 04             	mov    0x4(%rax),%eax
  8001a5:	8d 50 01             	lea    0x1(%rax),%edx
  8001a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001ac:	89 50 04             	mov    %edx,0x4(%rax)
}
  8001af:	c9                   	leaveq 
  8001b0:	c3                   	retq   

00000000008001b1 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001b1:	55                   	push   %rbp
  8001b2:	48 89 e5             	mov    %rsp,%rbp
  8001b5:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8001bc:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8001c3:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8001ca:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8001d1:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8001d8:	48 8b 0a             	mov    (%rdx),%rcx
  8001db:	48 89 08             	mov    %rcx,(%rax)
  8001de:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8001e2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8001e6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8001ea:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8001ee:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8001f5:	00 00 00 
	b.cnt = 0;
  8001f8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8001ff:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800202:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800209:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800210:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800217:	48 89 c6             	mov    %rax,%rsi
  80021a:	48 bf 38 01 80 00 00 	movabs $0x800138,%rdi
  800221:	00 00 00 
  800224:	48 b8 10 06 80 00 00 	movabs $0x800610,%rax
  80022b:	00 00 00 
  80022e:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800230:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800236:	48 98                	cltq   
  800238:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80023f:	48 83 c2 08          	add    $0x8,%rdx
  800243:	48 89 c6             	mov    %rax,%rsi
  800246:	48 89 d7             	mov    %rdx,%rdi
  800249:	48 b8 f9 15 80 00 00 	movabs $0x8015f9,%rax
  800250:	00 00 00 
  800253:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800255:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80025b:	c9                   	leaveq 
  80025c:	c3                   	retq   

000000000080025d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80025d:	55                   	push   %rbp
  80025e:	48 89 e5             	mov    %rsp,%rbp
  800261:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800268:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80026f:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800276:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80027d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800284:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80028b:	84 c0                	test   %al,%al
  80028d:	74 20                	je     8002af <cprintf+0x52>
  80028f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800293:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800297:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80029b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80029f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8002a3:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8002a7:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8002ab:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8002af:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8002b6:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8002bd:	00 00 00 
  8002c0:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8002c7:	00 00 00 
  8002ca:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002ce:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8002d5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8002dc:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8002e3:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8002ea:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8002f1:	48 8b 0a             	mov    (%rdx),%rcx
  8002f4:	48 89 08             	mov    %rcx,(%rax)
  8002f7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002fb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002ff:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800303:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800307:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80030e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800315:	48 89 d6             	mov    %rdx,%rsi
  800318:	48 89 c7             	mov    %rax,%rdi
  80031b:	48 b8 b1 01 80 00 00 	movabs $0x8001b1,%rax
  800322:	00 00 00 
  800325:	ff d0                	callq  *%rax
  800327:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  80032d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800333:	c9                   	leaveq 
  800334:	c3                   	retq   

0000000000800335 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800335:	55                   	push   %rbp
  800336:	48 89 e5             	mov    %rsp,%rbp
  800339:	53                   	push   %rbx
  80033a:	48 83 ec 38          	sub    $0x38,%rsp
  80033e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800342:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800346:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80034a:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80034d:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800351:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800355:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800358:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80035c:	77 3b                	ja     800399 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80035e:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800361:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800365:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800368:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80036c:	ba 00 00 00 00       	mov    $0x0,%edx
  800371:	48 f7 f3             	div    %rbx
  800374:	48 89 c2             	mov    %rax,%rdx
  800377:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80037a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80037d:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800381:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800385:	41 89 f9             	mov    %edi,%r9d
  800388:	48 89 c7             	mov    %rax,%rdi
  80038b:	48 b8 35 03 80 00 00 	movabs $0x800335,%rax
  800392:	00 00 00 
  800395:	ff d0                	callq  *%rax
  800397:	eb 1e                	jmp    8003b7 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800399:	eb 12                	jmp    8003ad <printnum+0x78>
			putch(padc, putdat);
  80039b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80039f:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8003a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003a6:	48 89 ce             	mov    %rcx,%rsi
  8003a9:	89 d7                	mov    %edx,%edi
  8003ab:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003ad:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8003b1:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8003b5:	7f e4                	jg     80039b <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003b7:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8003ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003be:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c3:	48 f7 f1             	div    %rcx
  8003c6:	48 89 d0             	mov    %rdx,%rax
  8003c9:	48 ba b0 1b 80 00 00 	movabs $0x801bb0,%rdx
  8003d0:	00 00 00 
  8003d3:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8003d7:	0f be d0             	movsbl %al,%edx
  8003da:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003e2:	48 89 ce             	mov    %rcx,%rsi
  8003e5:	89 d7                	mov    %edx,%edi
  8003e7:	ff d0                	callq  *%rax
}
  8003e9:	48 83 c4 38          	add    $0x38,%rsp
  8003ed:	5b                   	pop    %rbx
  8003ee:	5d                   	pop    %rbp
  8003ef:	c3                   	retq   

00000000008003f0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003f0:	55                   	push   %rbp
  8003f1:	48 89 e5             	mov    %rsp,%rbp
  8003f4:	48 83 ec 1c          	sub    $0x1c,%rsp
  8003f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8003fc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8003ff:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800403:	7e 52                	jle    800457 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800405:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800409:	8b 00                	mov    (%rax),%eax
  80040b:	83 f8 30             	cmp    $0x30,%eax
  80040e:	73 24                	jae    800434 <getuint+0x44>
  800410:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800414:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800418:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80041c:	8b 00                	mov    (%rax),%eax
  80041e:	89 c0                	mov    %eax,%eax
  800420:	48 01 d0             	add    %rdx,%rax
  800423:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800427:	8b 12                	mov    (%rdx),%edx
  800429:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80042c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800430:	89 0a                	mov    %ecx,(%rdx)
  800432:	eb 17                	jmp    80044b <getuint+0x5b>
  800434:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800438:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80043c:	48 89 d0             	mov    %rdx,%rax
  80043f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800443:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800447:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80044b:	48 8b 00             	mov    (%rax),%rax
  80044e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800452:	e9 a3 00 00 00       	jmpq   8004fa <getuint+0x10a>
	else if (lflag)
  800457:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80045b:	74 4f                	je     8004ac <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80045d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800461:	8b 00                	mov    (%rax),%eax
  800463:	83 f8 30             	cmp    $0x30,%eax
  800466:	73 24                	jae    80048c <getuint+0x9c>
  800468:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80046c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800470:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800474:	8b 00                	mov    (%rax),%eax
  800476:	89 c0                	mov    %eax,%eax
  800478:	48 01 d0             	add    %rdx,%rax
  80047b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80047f:	8b 12                	mov    (%rdx),%edx
  800481:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800484:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800488:	89 0a                	mov    %ecx,(%rdx)
  80048a:	eb 17                	jmp    8004a3 <getuint+0xb3>
  80048c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800490:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800494:	48 89 d0             	mov    %rdx,%rax
  800497:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80049b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80049f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004a3:	48 8b 00             	mov    (%rax),%rax
  8004a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004aa:	eb 4e                	jmp    8004fa <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8004ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b0:	8b 00                	mov    (%rax),%eax
  8004b2:	83 f8 30             	cmp    $0x30,%eax
  8004b5:	73 24                	jae    8004db <getuint+0xeb>
  8004b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004bb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c3:	8b 00                	mov    (%rax),%eax
  8004c5:	89 c0                	mov    %eax,%eax
  8004c7:	48 01 d0             	add    %rdx,%rax
  8004ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004ce:	8b 12                	mov    (%rdx),%edx
  8004d0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004d7:	89 0a                	mov    %ecx,(%rdx)
  8004d9:	eb 17                	jmp    8004f2 <getuint+0x102>
  8004db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004df:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004e3:	48 89 d0             	mov    %rdx,%rax
  8004e6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004ee:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004f2:	8b 00                	mov    (%rax),%eax
  8004f4:	89 c0                	mov    %eax,%eax
  8004f6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8004fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004fe:	c9                   	leaveq 
  8004ff:	c3                   	retq   

0000000000800500 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800500:	55                   	push   %rbp
  800501:	48 89 e5             	mov    %rsp,%rbp
  800504:	48 83 ec 1c          	sub    $0x1c,%rsp
  800508:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80050c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80050f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800513:	7e 52                	jle    800567 <getint+0x67>
		x=va_arg(*ap, long long);
  800515:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800519:	8b 00                	mov    (%rax),%eax
  80051b:	83 f8 30             	cmp    $0x30,%eax
  80051e:	73 24                	jae    800544 <getint+0x44>
  800520:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800524:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800528:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80052c:	8b 00                	mov    (%rax),%eax
  80052e:	89 c0                	mov    %eax,%eax
  800530:	48 01 d0             	add    %rdx,%rax
  800533:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800537:	8b 12                	mov    (%rdx),%edx
  800539:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80053c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800540:	89 0a                	mov    %ecx,(%rdx)
  800542:	eb 17                	jmp    80055b <getint+0x5b>
  800544:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800548:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80054c:	48 89 d0             	mov    %rdx,%rax
  80054f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800553:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800557:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80055b:	48 8b 00             	mov    (%rax),%rax
  80055e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800562:	e9 a3 00 00 00       	jmpq   80060a <getint+0x10a>
	else if (lflag)
  800567:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80056b:	74 4f                	je     8005bc <getint+0xbc>
		x=va_arg(*ap, long);
  80056d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800571:	8b 00                	mov    (%rax),%eax
  800573:	83 f8 30             	cmp    $0x30,%eax
  800576:	73 24                	jae    80059c <getint+0x9c>
  800578:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800580:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800584:	8b 00                	mov    (%rax),%eax
  800586:	89 c0                	mov    %eax,%eax
  800588:	48 01 d0             	add    %rdx,%rax
  80058b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80058f:	8b 12                	mov    (%rdx),%edx
  800591:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800594:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800598:	89 0a                	mov    %ecx,(%rdx)
  80059a:	eb 17                	jmp    8005b3 <getint+0xb3>
  80059c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005a4:	48 89 d0             	mov    %rdx,%rax
  8005a7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005af:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005b3:	48 8b 00             	mov    (%rax),%rax
  8005b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005ba:	eb 4e                	jmp    80060a <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8005bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c0:	8b 00                	mov    (%rax),%eax
  8005c2:	83 f8 30             	cmp    $0x30,%eax
  8005c5:	73 24                	jae    8005eb <getint+0xeb>
  8005c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005cb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d3:	8b 00                	mov    (%rax),%eax
  8005d5:	89 c0                	mov    %eax,%eax
  8005d7:	48 01 d0             	add    %rdx,%rax
  8005da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005de:	8b 12                	mov    (%rdx),%edx
  8005e0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005e7:	89 0a                	mov    %ecx,(%rdx)
  8005e9:	eb 17                	jmp    800602 <getint+0x102>
  8005eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ef:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005f3:	48 89 d0             	mov    %rdx,%rax
  8005f6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005fe:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800602:	8b 00                	mov    (%rax),%eax
  800604:	48 98                	cltq   
  800606:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80060a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80060e:	c9                   	leaveq 
  80060f:	c3                   	retq   

0000000000800610 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800610:	55                   	push   %rbp
  800611:	48 89 e5             	mov    %rsp,%rbp
  800614:	41 54                	push   %r12
  800616:	53                   	push   %rbx
  800617:	48 83 ec 60          	sub    $0x60,%rsp
  80061b:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80061f:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800623:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800627:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80062b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80062f:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800633:	48 8b 0a             	mov    (%rdx),%rcx
  800636:	48 89 08             	mov    %rcx,(%rax)
  800639:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80063d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800641:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800645:	48 89 50 10          	mov    %rdx,0x10(%rax)
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800649:	eb 17                	jmp    800662 <vprintfmt+0x52>
			if (ch == '\0')
  80064b:	85 db                	test   %ebx,%ebx
  80064d:	0f 84 cc 04 00 00    	je     800b1f <vprintfmt+0x50f>
                }
#endif

			  return;
			}
			putch(ch, putdat);
  800653:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800657:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80065b:	48 89 d6             	mov    %rdx,%rsi
  80065e:	89 df                	mov    %ebx,%edi
  800660:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800662:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800666:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80066a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80066e:	0f b6 00             	movzbl (%rax),%eax
  800671:	0f b6 d8             	movzbl %al,%ebx
  800674:	83 fb 25             	cmp    $0x25,%ebx
  800677:	75 d2                	jne    80064b <vprintfmt+0x3b>
			  return;
			}
			putch(ch, putdat);
		}
		// Process a %-escape sequence
		padc = ' ';
  800679:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80067d:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800684:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80068b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800692:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800699:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80069d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006a1:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006a5:	0f b6 00             	movzbl (%rax),%eax
  8006a8:	0f b6 d8             	movzbl %al,%ebx
  8006ab:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8006ae:	83 f8 55             	cmp    $0x55,%eax
  8006b1:	0f 87 34 04 00 00    	ja     800aeb <vprintfmt+0x4db>
  8006b7:	89 c0                	mov    %eax,%eax
  8006b9:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8006c0:	00 
  8006c1:	48 b8 d8 1b 80 00 00 	movabs $0x801bd8,%rax
  8006c8:	00 00 00 
  8006cb:	48 01 d0             	add    %rdx,%rax
  8006ce:	48 8b 00             	mov    (%rax),%rax
  8006d1:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006d3:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8006d7:	eb c0                	jmp    800699 <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006d9:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8006dd:	eb ba                	jmp    800699 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006df:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8006e6:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8006e9:	89 d0                	mov    %edx,%eax
  8006eb:	c1 e0 02             	shl    $0x2,%eax
  8006ee:	01 d0                	add    %edx,%eax
  8006f0:	01 c0                	add    %eax,%eax
  8006f2:	01 d8                	add    %ebx,%eax
  8006f4:	83 e8 30             	sub    $0x30,%eax
  8006f7:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8006fa:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006fe:	0f b6 00             	movzbl (%rax),%eax
  800701:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800704:	83 fb 2f             	cmp    $0x2f,%ebx
  800707:	7e 0c                	jle    800715 <vprintfmt+0x105>
  800709:	83 fb 39             	cmp    $0x39,%ebx
  80070c:	7f 07                	jg     800715 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80070e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800713:	eb d1                	jmp    8006e6 <vprintfmt+0xd6>
			goto process_precision;
  800715:	eb 58                	jmp    80076f <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800717:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80071a:	83 f8 30             	cmp    $0x30,%eax
  80071d:	73 17                	jae    800736 <vprintfmt+0x126>
  80071f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800723:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800726:	89 c0                	mov    %eax,%eax
  800728:	48 01 d0             	add    %rdx,%rax
  80072b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80072e:	83 c2 08             	add    $0x8,%edx
  800731:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800734:	eb 0f                	jmp    800745 <vprintfmt+0x135>
  800736:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80073a:	48 89 d0             	mov    %rdx,%rax
  80073d:	48 83 c2 08          	add    $0x8,%rdx
  800741:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800745:	8b 00                	mov    (%rax),%eax
  800747:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80074a:	eb 23                	jmp    80076f <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80074c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800750:	79 0c                	jns    80075e <vprintfmt+0x14e>
				width = 0;
  800752:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800759:	e9 3b ff ff ff       	jmpq   800699 <vprintfmt+0x89>
  80075e:	e9 36 ff ff ff       	jmpq   800699 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800763:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80076a:	e9 2a ff ff ff       	jmpq   800699 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80076f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800773:	79 12                	jns    800787 <vprintfmt+0x177>
				width = precision, precision = -1;
  800775:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800778:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80077b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800782:	e9 12 ff ff ff       	jmpq   800699 <vprintfmt+0x89>
  800787:	e9 0d ff ff ff       	jmpq   800699 <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80078c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800790:	e9 04 ff ff ff       	jmpq   800699 <vprintfmt+0x89>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			putch(va_arg(aq, int), putdat);
  800795:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800798:	83 f8 30             	cmp    $0x30,%eax
  80079b:	73 17                	jae    8007b4 <vprintfmt+0x1a4>
  80079d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007a1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007a4:	89 c0                	mov    %eax,%eax
  8007a6:	48 01 d0             	add    %rdx,%rax
  8007a9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007ac:	83 c2 08             	add    $0x8,%edx
  8007af:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007b2:	eb 0f                	jmp    8007c3 <vprintfmt+0x1b3>
  8007b4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007b8:	48 89 d0             	mov    %rdx,%rax
  8007bb:	48 83 c2 08          	add    $0x8,%rdx
  8007bf:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007c3:	8b 10                	mov    (%rax),%edx
  8007c5:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8007c9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007cd:	48 89 ce             	mov    %rcx,%rsi
  8007d0:	89 d7                	mov    %edx,%edi
  8007d2:	ff d0                	callq  *%rax
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  8007d4:	e9 40 03 00 00       	jmpq   800b19 <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  8007d9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007dc:	83 f8 30             	cmp    $0x30,%eax
  8007df:	73 17                	jae    8007f8 <vprintfmt+0x1e8>
  8007e1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007e5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007e8:	89 c0                	mov    %eax,%eax
  8007ea:	48 01 d0             	add    %rdx,%rax
  8007ed:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007f0:	83 c2 08             	add    $0x8,%edx
  8007f3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007f6:	eb 0f                	jmp    800807 <vprintfmt+0x1f7>
  8007f8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007fc:	48 89 d0             	mov    %rdx,%rax
  8007ff:	48 83 c2 08          	add    $0x8,%rdx
  800803:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800807:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800809:	85 db                	test   %ebx,%ebx
  80080b:	79 02                	jns    80080f <vprintfmt+0x1ff>
				err = -err;
  80080d:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80080f:	83 fb 09             	cmp    $0x9,%ebx
  800812:	7f 16                	jg     80082a <vprintfmt+0x21a>
  800814:	48 b8 60 1b 80 00 00 	movabs $0x801b60,%rax
  80081b:	00 00 00 
  80081e:	48 63 d3             	movslq %ebx,%rdx
  800821:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800825:	4d 85 e4             	test   %r12,%r12
  800828:	75 2e                	jne    800858 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  80082a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80082e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800832:	89 d9                	mov    %ebx,%ecx
  800834:	48 ba c1 1b 80 00 00 	movabs $0x801bc1,%rdx
  80083b:	00 00 00 
  80083e:	48 89 c7             	mov    %rax,%rdi
  800841:	b8 00 00 00 00       	mov    $0x0,%eax
  800846:	49 b8 28 0b 80 00 00 	movabs $0x800b28,%r8
  80084d:	00 00 00 
  800850:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800853:	e9 c1 02 00 00       	jmpq   800b19 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800858:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80085c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800860:	4c 89 e1             	mov    %r12,%rcx
  800863:	48 ba ca 1b 80 00 00 	movabs $0x801bca,%rdx
  80086a:	00 00 00 
  80086d:	48 89 c7             	mov    %rax,%rdi
  800870:	b8 00 00 00 00       	mov    $0x0,%eax
  800875:	49 b8 28 0b 80 00 00 	movabs $0x800b28,%r8
  80087c:	00 00 00 
  80087f:	41 ff d0             	callq  *%r8
			break;
  800882:	e9 92 02 00 00       	jmpq   800b19 <vprintfmt+0x509>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
  800887:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80088a:	83 f8 30             	cmp    $0x30,%eax
  80088d:	73 17                	jae    8008a6 <vprintfmt+0x296>
  80088f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800893:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800896:	89 c0                	mov    %eax,%eax
  800898:	48 01 d0             	add    %rdx,%rax
  80089b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80089e:	83 c2 08             	add    $0x8,%edx
  8008a1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008a4:	eb 0f                	jmp    8008b5 <vprintfmt+0x2a5>
  8008a6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008aa:	48 89 d0             	mov    %rdx,%rax
  8008ad:	48 83 c2 08          	add    $0x8,%rdx
  8008b1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008b5:	4c 8b 20             	mov    (%rax),%r12
  8008b8:	4d 85 e4             	test   %r12,%r12
  8008bb:	75 0a                	jne    8008c7 <vprintfmt+0x2b7>
				p = "(null)";
  8008bd:	49 bc cd 1b 80 00 00 	movabs $0x801bcd,%r12
  8008c4:	00 00 00 
			if (width > 0 && padc != '-')
  8008c7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008cb:	7e 3f                	jle    80090c <vprintfmt+0x2fc>
  8008cd:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8008d1:	74 39                	je     80090c <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d3:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008d6:	48 98                	cltq   
  8008d8:	48 89 c6             	mov    %rax,%rsi
  8008db:	4c 89 e7             	mov    %r12,%rdi
  8008de:	48 b8 d4 0d 80 00 00 	movabs $0x800dd4,%rax
  8008e5:	00 00 00 
  8008e8:	ff d0                	callq  *%rax
  8008ea:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8008ed:	eb 17                	jmp    800906 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8008ef:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8008f3:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8008f7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008fb:	48 89 ce             	mov    %rcx,%rsi
  8008fe:	89 d7                	mov    %edx,%edi
  800900:	ff d0                	callq  *%rax
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800902:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800906:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80090a:	7f e3                	jg     8008ef <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80090c:	eb 37                	jmp    800945 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  80090e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800912:	74 1e                	je     800932 <vprintfmt+0x322>
  800914:	83 fb 1f             	cmp    $0x1f,%ebx
  800917:	7e 05                	jle    80091e <vprintfmt+0x30e>
  800919:	83 fb 7e             	cmp    $0x7e,%ebx
  80091c:	7e 14                	jle    800932 <vprintfmt+0x322>
					putch('?', putdat);
  80091e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800922:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800926:	48 89 d6             	mov    %rdx,%rsi
  800929:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80092e:	ff d0                	callq  *%rax
  800930:	eb 0f                	jmp    800941 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800932:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800936:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80093a:	48 89 d6             	mov    %rdx,%rsi
  80093d:	89 df                	mov    %ebx,%edi
  80093f:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800941:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800945:	4c 89 e0             	mov    %r12,%rax
  800948:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80094c:	0f b6 00             	movzbl (%rax),%eax
  80094f:	0f be d8             	movsbl %al,%ebx
  800952:	85 db                	test   %ebx,%ebx
  800954:	74 10                	je     800966 <vprintfmt+0x356>
  800956:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80095a:	78 b2                	js     80090e <vprintfmt+0x2fe>
  80095c:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800960:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800964:	79 a8                	jns    80090e <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800966:	eb 16                	jmp    80097e <vprintfmt+0x36e>
				putch(' ', putdat);
  800968:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80096c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800970:	48 89 d6             	mov    %rdx,%rsi
  800973:	bf 20 00 00 00       	mov    $0x20,%edi
  800978:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80097a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80097e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800982:	7f e4                	jg     800968 <vprintfmt+0x358>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  800984:	e9 90 01 00 00       	jmpq   800b19 <vprintfmt+0x509>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getint(&aq, 3);
  800989:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80098d:	be 03 00 00 00       	mov    $0x3,%esi
  800992:	48 89 c7             	mov    %rax,%rdi
  800995:	48 b8 00 05 80 00 00 	movabs $0x800500,%rax
  80099c:	00 00 00 
  80099f:	ff d0                	callq  *%rax
  8009a1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8009a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a9:	48 85 c0             	test   %rax,%rax
  8009ac:	79 1d                	jns    8009cb <vprintfmt+0x3bb>
				putch('-', putdat);
  8009ae:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009b2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009b6:	48 89 d6             	mov    %rdx,%rsi
  8009b9:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8009be:	ff d0                	callq  *%rax
				num = -(long long) num;
  8009c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c4:	48 f7 d8             	neg    %rax
  8009c7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8009cb:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009d2:	e9 d5 00 00 00       	jmpq   800aac <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			
			num = getuint(&aq, 3);
  8009d7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009db:	be 03 00 00 00       	mov    $0x3,%esi
  8009e0:	48 89 c7             	mov    %rax,%rdi
  8009e3:	48 b8 f0 03 80 00 00 	movabs $0x8003f0,%rax
  8009ea:	00 00 00 
  8009ed:	ff d0                	callq  *%rax
  8009ef:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8009f3:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009fa:	e9 ad 00 00 00       	jmpq   800aac <vprintfmt+0x49c>
                  ch = *(unsigned char *) color;
                }
#endif

			// Replace this with your code.
		        num = getuint(&aq, 3);
  8009ff:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a03:	be 03 00 00 00       	mov    $0x3,%esi
  800a08:	48 89 c7             	mov    %rax,%rdi
  800a0b:	48 b8 f0 03 80 00 00 	movabs $0x8003f0,%rax
  800a12:	00 00 00 
  800a15:	ff d0                	callq  *%rax
  800a17:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800a1b:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800a22:	e9 85 00 00 00       	jmpq   800aac <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			putch('0', putdat);
  800a27:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a2b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a2f:	48 89 d6             	mov    %rdx,%rsi
  800a32:	bf 30 00 00 00       	mov    $0x30,%edi
  800a37:	ff d0                	callq  *%rax
			putch('x', putdat);
  800a39:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a3d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a41:	48 89 d6             	mov    %rdx,%rsi
  800a44:	bf 78 00 00 00       	mov    $0x78,%edi
  800a49:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a4b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a4e:	83 f8 30             	cmp    $0x30,%eax
  800a51:	73 17                	jae    800a6a <vprintfmt+0x45a>
  800a53:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a57:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a5a:	89 c0                	mov    %eax,%eax
  800a5c:	48 01 d0             	add    %rdx,%rax
  800a5f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a62:	83 c2 08             	add    $0x8,%edx
  800a65:	89 55 b8             	mov    %edx,-0x48(%rbp)
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a68:	eb 0f                	jmp    800a79 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800a6a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a6e:	48 89 d0             	mov    %rdx,%rax
  800a71:	48 83 c2 08          	add    $0x8,%rdx
  800a75:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a79:	48 8b 00             	mov    (%rax),%rax
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a7c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800a80:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800a87:	eb 23                	jmp    800aac <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getuint(&aq, 3);
  800a89:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a8d:	be 03 00 00 00       	mov    $0x3,%esi
  800a92:	48 89 c7             	mov    %rax,%rdi
  800a95:	48 b8 f0 03 80 00 00 	movabs $0x8003f0,%rax
  800a9c:	00 00 00 
  800a9f:	ff d0                	callq  *%rax
  800aa1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800aa5:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:

			printnum(putch, putdat, num, base, width, padc);
  800aac:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ab1:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ab4:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ab7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800abb:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800abf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ac3:	45 89 c1             	mov    %r8d,%r9d
  800ac6:	41 89 f8             	mov    %edi,%r8d
  800ac9:	48 89 c7             	mov    %rax,%rdi
  800acc:	48 b8 35 03 80 00 00 	movabs $0x800335,%rax
  800ad3:	00 00 00 
  800ad6:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			break;
  800ad8:	eb 3f                	jmp    800b19 <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ada:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ade:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae2:	48 89 d6             	mov    %rdx,%rsi
  800ae5:	89 df                	mov    %ebx,%edi
  800ae7:	ff d0                	callq  *%rax
			break;
  800ae9:	eb 2e                	jmp    800b19 <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aeb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aef:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800af3:	48 89 d6             	mov    %rdx,%rsi
  800af6:	bf 25 00 00 00       	mov    $0x25,%edi
  800afb:	ff d0                	callq  *%rax

			for (fmt--; fmt[-1] != '%'; fmt--)
  800afd:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b02:	eb 05                	jmp    800b09 <vprintfmt+0x4f9>
  800b04:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b09:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b0d:	48 83 e8 01          	sub    $0x1,%rax
  800b11:	0f b6 00             	movzbl (%rax),%eax
  800b14:	3c 25                	cmp    $0x25,%al
  800b16:	75 ec                	jne    800b04 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800b18:	90                   	nop
		}
	}
  800b19:	90                   	nop
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b1a:	e9 43 fb ff ff       	jmpq   800662 <vprintfmt+0x52>
			break;
		}
	}
    
va_end(aq);
}
  800b1f:	48 83 c4 60          	add    $0x60,%rsp
  800b23:	5b                   	pop    %rbx
  800b24:	41 5c                	pop    %r12
  800b26:	5d                   	pop    %rbp
  800b27:	c3                   	retq   

0000000000800b28 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b28:	55                   	push   %rbp
  800b29:	48 89 e5             	mov    %rsp,%rbp
  800b2c:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b33:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b3a:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b41:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b48:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b4f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b56:	84 c0                	test   %al,%al
  800b58:	74 20                	je     800b7a <printfmt+0x52>
  800b5a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b5e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b62:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b66:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b6a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b6e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b72:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b76:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800b7a:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b81:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800b88:	00 00 00 
  800b8b:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800b92:	00 00 00 
  800b95:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b99:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800ba0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ba7:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800bae:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800bb5:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800bbc:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800bc3:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800bca:	48 89 c7             	mov    %rax,%rdi
  800bcd:	48 b8 10 06 80 00 00 	movabs $0x800610,%rax
  800bd4:	00 00 00 
  800bd7:	ff d0                	callq  *%rax
	va_end(ap);
}
  800bd9:	c9                   	leaveq 
  800bda:	c3                   	retq   

0000000000800bdb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bdb:	55                   	push   %rbp
  800bdc:	48 89 e5             	mov    %rsp,%rbp
  800bdf:	48 83 ec 10          	sub    $0x10,%rsp
  800be3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800be6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800bea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bee:	8b 40 10             	mov    0x10(%rax),%eax
  800bf1:	8d 50 01             	lea    0x1(%rax),%edx
  800bf4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bf8:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800bfb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bff:	48 8b 10             	mov    (%rax),%rdx
  800c02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c06:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c0a:	48 39 c2             	cmp    %rax,%rdx
  800c0d:	73 17                	jae    800c26 <sprintputch+0x4b>
		*b->buf++ = ch;
  800c0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c13:	48 8b 00             	mov    (%rax),%rax
  800c16:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c1a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c1e:	48 89 0a             	mov    %rcx,(%rdx)
  800c21:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c24:	88 10                	mov    %dl,(%rax)
}
  800c26:	c9                   	leaveq 
  800c27:	c3                   	retq   

0000000000800c28 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c28:	55                   	push   %rbp
  800c29:	48 89 e5             	mov    %rsp,%rbp
  800c2c:	48 83 ec 50          	sub    $0x50,%rsp
  800c30:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c34:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c37:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c3b:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c3f:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c43:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c47:	48 8b 0a             	mov    (%rdx),%rcx
  800c4a:	48 89 08             	mov    %rcx,(%rax)
  800c4d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c51:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c55:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c59:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c5d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c61:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800c65:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800c68:	48 98                	cltq   
  800c6a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800c6e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c72:	48 01 d0             	add    %rdx,%rax
  800c75:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800c79:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800c80:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800c85:	74 06                	je     800c8d <vsnprintf+0x65>
  800c87:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800c8b:	7f 07                	jg     800c94 <vsnprintf+0x6c>
		return -E_INVAL;
  800c8d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c92:	eb 2f                	jmp    800cc3 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800c94:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800c98:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800c9c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ca0:	48 89 c6             	mov    %rax,%rsi
  800ca3:	48 bf db 0b 80 00 00 	movabs $0x800bdb,%rdi
  800caa:	00 00 00 
  800cad:	48 b8 10 06 80 00 00 	movabs $0x800610,%rax
  800cb4:	00 00 00 
  800cb7:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800cb9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800cbd:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800cc0:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800cc3:	c9                   	leaveq 
  800cc4:	c3                   	retq   

0000000000800cc5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cc5:	55                   	push   %rbp
  800cc6:	48 89 e5             	mov    %rsp,%rbp
  800cc9:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800cd0:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800cd7:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800cdd:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ce4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ceb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800cf2:	84 c0                	test   %al,%al
  800cf4:	74 20                	je     800d16 <snprintf+0x51>
  800cf6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800cfa:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800cfe:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d02:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d06:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d0a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d0e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d12:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d16:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d1d:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d24:	00 00 00 
  800d27:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d2e:	00 00 00 
  800d31:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d35:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d3c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d43:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d4a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800d51:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800d58:	48 8b 0a             	mov    (%rdx),%rcx
  800d5b:	48 89 08             	mov    %rcx,(%rax)
  800d5e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d62:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d66:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d6a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800d6e:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800d75:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800d7c:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800d82:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800d89:	48 89 c7             	mov    %rax,%rdi
  800d8c:	48 b8 28 0c 80 00 00 	movabs $0x800c28,%rax
  800d93:	00 00 00 
  800d96:	ff d0                	callq  *%rax
  800d98:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800d9e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800da4:	c9                   	leaveq 
  800da5:	c3                   	retq   

0000000000800da6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800da6:	55                   	push   %rbp
  800da7:	48 89 e5             	mov    %rsp,%rbp
  800daa:	48 83 ec 18          	sub    $0x18,%rsp
  800dae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800db2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800db9:	eb 09                	jmp    800dc4 <strlen+0x1e>
		n++;
  800dbb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dbf:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800dc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dc8:	0f b6 00             	movzbl (%rax),%eax
  800dcb:	84 c0                	test   %al,%al
  800dcd:	75 ec                	jne    800dbb <strlen+0x15>
		n++;
	return n;
  800dcf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800dd2:	c9                   	leaveq 
  800dd3:	c3                   	retq   

0000000000800dd4 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800dd4:	55                   	push   %rbp
  800dd5:	48 89 e5             	mov    %rsp,%rbp
  800dd8:	48 83 ec 20          	sub    $0x20,%rsp
  800ddc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800de0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800de4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800deb:	eb 0e                	jmp    800dfb <strnlen+0x27>
		n++;
  800ded:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800df1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800df6:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800dfb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e00:	74 0b                	je     800e0d <strnlen+0x39>
  800e02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e06:	0f b6 00             	movzbl (%rax),%eax
  800e09:	84 c0                	test   %al,%al
  800e0b:	75 e0                	jne    800ded <strnlen+0x19>
		n++;
	return n;
  800e0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e10:	c9                   	leaveq 
  800e11:	c3                   	retq   

0000000000800e12 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e12:	55                   	push   %rbp
  800e13:	48 89 e5             	mov    %rsp,%rbp
  800e16:	48 83 ec 20          	sub    $0x20,%rsp
  800e1a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e1e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e26:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800e2a:	90                   	nop
  800e2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e2f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e33:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e37:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e3b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e3f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800e43:	0f b6 12             	movzbl (%rdx),%edx
  800e46:	88 10                	mov    %dl,(%rax)
  800e48:	0f b6 00             	movzbl (%rax),%eax
  800e4b:	84 c0                	test   %al,%al
  800e4d:	75 dc                	jne    800e2b <strcpy+0x19>
		/* do nothing */;
	return ret;
  800e4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e53:	c9                   	leaveq 
  800e54:	c3                   	retq   

0000000000800e55 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e55:	55                   	push   %rbp
  800e56:	48 89 e5             	mov    %rsp,%rbp
  800e59:	48 83 ec 20          	sub    $0x20,%rsp
  800e5d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e61:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800e65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e69:	48 89 c7             	mov    %rax,%rdi
  800e6c:	48 b8 a6 0d 80 00 00 	movabs $0x800da6,%rax
  800e73:	00 00 00 
  800e76:	ff d0                	callq  *%rax
  800e78:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800e7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e7e:	48 63 d0             	movslq %eax,%rdx
  800e81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e85:	48 01 c2             	add    %rax,%rdx
  800e88:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800e8c:	48 89 c6             	mov    %rax,%rsi
  800e8f:	48 89 d7             	mov    %rdx,%rdi
  800e92:	48 b8 12 0e 80 00 00 	movabs $0x800e12,%rax
  800e99:	00 00 00 
  800e9c:	ff d0                	callq  *%rax
	return dst;
  800e9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800ea2:	c9                   	leaveq 
  800ea3:	c3                   	retq   

0000000000800ea4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ea4:	55                   	push   %rbp
  800ea5:	48 89 e5             	mov    %rsp,%rbp
  800ea8:	48 83 ec 28          	sub    $0x28,%rsp
  800eac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800eb0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800eb4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800eb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ebc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800ec0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800ec7:	00 
  800ec8:	eb 2a                	jmp    800ef4 <strncpy+0x50>
		*dst++ = *src;
  800eca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ece:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ed2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ed6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800eda:	0f b6 12             	movzbl (%rdx),%edx
  800edd:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800edf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ee3:	0f b6 00             	movzbl (%rax),%eax
  800ee6:	84 c0                	test   %al,%al
  800ee8:	74 05                	je     800eef <strncpy+0x4b>
			src++;
  800eea:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800eef:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800ef4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ef8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800efc:	72 cc                	jb     800eca <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800efe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f02:	c9                   	leaveq 
  800f03:	c3                   	retq   

0000000000800f04 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f04:	55                   	push   %rbp
  800f05:	48 89 e5             	mov    %rsp,%rbp
  800f08:	48 83 ec 28          	sub    $0x28,%rsp
  800f0c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f10:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f14:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f1c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f20:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f25:	74 3d                	je     800f64 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800f27:	eb 1d                	jmp    800f46 <strlcpy+0x42>
			*dst++ = *src++;
  800f29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f2d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f31:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f35:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f39:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f3d:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f41:	0f b6 12             	movzbl (%rdx),%edx
  800f44:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f46:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f4b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f50:	74 0b                	je     800f5d <strlcpy+0x59>
  800f52:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f56:	0f b6 00             	movzbl (%rax),%eax
  800f59:	84 c0                	test   %al,%al
  800f5b:	75 cc                	jne    800f29 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800f5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f61:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800f64:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f6c:	48 29 c2             	sub    %rax,%rdx
  800f6f:	48 89 d0             	mov    %rdx,%rax
}
  800f72:	c9                   	leaveq 
  800f73:	c3                   	retq   

0000000000800f74 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f74:	55                   	push   %rbp
  800f75:	48 89 e5             	mov    %rsp,%rbp
  800f78:	48 83 ec 10          	sub    $0x10,%rsp
  800f7c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800f80:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800f84:	eb 0a                	jmp    800f90 <strcmp+0x1c>
		p++, q++;
  800f86:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f8b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f94:	0f b6 00             	movzbl (%rax),%eax
  800f97:	84 c0                	test   %al,%al
  800f99:	74 12                	je     800fad <strcmp+0x39>
  800f9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f9f:	0f b6 10             	movzbl (%rax),%edx
  800fa2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fa6:	0f b6 00             	movzbl (%rax),%eax
  800fa9:	38 c2                	cmp    %al,%dl
  800fab:	74 d9                	je     800f86 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fb1:	0f b6 00             	movzbl (%rax),%eax
  800fb4:	0f b6 d0             	movzbl %al,%edx
  800fb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fbb:	0f b6 00             	movzbl (%rax),%eax
  800fbe:	0f b6 c0             	movzbl %al,%eax
  800fc1:	29 c2                	sub    %eax,%edx
  800fc3:	89 d0                	mov    %edx,%eax
}
  800fc5:	c9                   	leaveq 
  800fc6:	c3                   	retq   

0000000000800fc7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800fc7:	55                   	push   %rbp
  800fc8:	48 89 e5             	mov    %rsp,%rbp
  800fcb:	48 83 ec 18          	sub    $0x18,%rsp
  800fcf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fd3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800fd7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  800fdb:	eb 0f                	jmp    800fec <strncmp+0x25>
		n--, p++, q++;
  800fdd:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  800fe2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fe7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800fec:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800ff1:	74 1d                	je     801010 <strncmp+0x49>
  800ff3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ff7:	0f b6 00             	movzbl (%rax),%eax
  800ffa:	84 c0                	test   %al,%al
  800ffc:	74 12                	je     801010 <strncmp+0x49>
  800ffe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801002:	0f b6 10             	movzbl (%rax),%edx
  801005:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801009:	0f b6 00             	movzbl (%rax),%eax
  80100c:	38 c2                	cmp    %al,%dl
  80100e:	74 cd                	je     800fdd <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801010:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801015:	75 07                	jne    80101e <strncmp+0x57>
		return 0;
  801017:	b8 00 00 00 00       	mov    $0x0,%eax
  80101c:	eb 18                	jmp    801036 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80101e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801022:	0f b6 00             	movzbl (%rax),%eax
  801025:	0f b6 d0             	movzbl %al,%edx
  801028:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80102c:	0f b6 00             	movzbl (%rax),%eax
  80102f:	0f b6 c0             	movzbl %al,%eax
  801032:	29 c2                	sub    %eax,%edx
  801034:	89 d0                	mov    %edx,%eax
}
  801036:	c9                   	leaveq 
  801037:	c3                   	retq   

0000000000801038 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801038:	55                   	push   %rbp
  801039:	48 89 e5             	mov    %rsp,%rbp
  80103c:	48 83 ec 0c          	sub    $0xc,%rsp
  801040:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801044:	89 f0                	mov    %esi,%eax
  801046:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801049:	eb 17                	jmp    801062 <strchr+0x2a>
		if (*s == c)
  80104b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80104f:	0f b6 00             	movzbl (%rax),%eax
  801052:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801055:	75 06                	jne    80105d <strchr+0x25>
			return (char *) s;
  801057:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80105b:	eb 15                	jmp    801072 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80105d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801062:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801066:	0f b6 00             	movzbl (%rax),%eax
  801069:	84 c0                	test   %al,%al
  80106b:	75 de                	jne    80104b <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80106d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801072:	c9                   	leaveq 
  801073:	c3                   	retq   

0000000000801074 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801074:	55                   	push   %rbp
  801075:	48 89 e5             	mov    %rsp,%rbp
  801078:	48 83 ec 0c          	sub    $0xc,%rsp
  80107c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801080:	89 f0                	mov    %esi,%eax
  801082:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801085:	eb 13                	jmp    80109a <strfind+0x26>
		if (*s == c)
  801087:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80108b:	0f b6 00             	movzbl (%rax),%eax
  80108e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801091:	75 02                	jne    801095 <strfind+0x21>
			break;
  801093:	eb 10                	jmp    8010a5 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801095:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80109a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80109e:	0f b6 00             	movzbl (%rax),%eax
  8010a1:	84 c0                	test   %al,%al
  8010a3:	75 e2                	jne    801087 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8010a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010a9:	c9                   	leaveq 
  8010aa:	c3                   	retq   

00000000008010ab <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8010ab:	55                   	push   %rbp
  8010ac:	48 89 e5             	mov    %rsp,%rbp
  8010af:	48 83 ec 18          	sub    $0x18,%rsp
  8010b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010b7:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8010ba:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8010be:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010c3:	75 06                	jne    8010cb <memset+0x20>
		return v;
  8010c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010c9:	eb 69                	jmp    801134 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8010cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010cf:	83 e0 03             	and    $0x3,%eax
  8010d2:	48 85 c0             	test   %rax,%rax
  8010d5:	75 48                	jne    80111f <memset+0x74>
  8010d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010db:	83 e0 03             	and    $0x3,%eax
  8010de:	48 85 c0             	test   %rax,%rax
  8010e1:	75 3c                	jne    80111f <memset+0x74>
		c &= 0xFF;
  8010e3:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8010ea:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010ed:	c1 e0 18             	shl    $0x18,%eax
  8010f0:	89 c2                	mov    %eax,%edx
  8010f2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010f5:	c1 e0 10             	shl    $0x10,%eax
  8010f8:	09 c2                	or     %eax,%edx
  8010fa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010fd:	c1 e0 08             	shl    $0x8,%eax
  801100:	09 d0                	or     %edx,%eax
  801102:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801105:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801109:	48 c1 e8 02          	shr    $0x2,%rax
  80110d:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801110:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801114:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801117:	48 89 d7             	mov    %rdx,%rdi
  80111a:	fc                   	cld    
  80111b:	f3 ab                	rep stos %eax,%es:(%rdi)
  80111d:	eb 11                	jmp    801130 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80111f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801123:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801126:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80112a:	48 89 d7             	mov    %rdx,%rdi
  80112d:	fc                   	cld    
  80112e:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801130:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801134:	c9                   	leaveq 
  801135:	c3                   	retq   

0000000000801136 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801136:	55                   	push   %rbp
  801137:	48 89 e5             	mov    %rsp,%rbp
  80113a:	48 83 ec 28          	sub    $0x28,%rsp
  80113e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801142:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801146:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80114a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80114e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801152:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801156:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80115a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80115e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801162:	0f 83 88 00 00 00    	jae    8011f0 <memmove+0xba>
  801168:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80116c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801170:	48 01 d0             	add    %rdx,%rax
  801173:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801177:	76 77                	jbe    8011f0 <memmove+0xba>
		s += n;
  801179:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80117d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801181:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801185:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801189:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80118d:	83 e0 03             	and    $0x3,%eax
  801190:	48 85 c0             	test   %rax,%rax
  801193:	75 3b                	jne    8011d0 <memmove+0x9a>
  801195:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801199:	83 e0 03             	and    $0x3,%eax
  80119c:	48 85 c0             	test   %rax,%rax
  80119f:	75 2f                	jne    8011d0 <memmove+0x9a>
  8011a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011a5:	83 e0 03             	and    $0x3,%eax
  8011a8:	48 85 c0             	test   %rax,%rax
  8011ab:	75 23                	jne    8011d0 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8011ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011b1:	48 83 e8 04          	sub    $0x4,%rax
  8011b5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011b9:	48 83 ea 04          	sub    $0x4,%rdx
  8011bd:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8011c1:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8011c5:	48 89 c7             	mov    %rax,%rdi
  8011c8:	48 89 d6             	mov    %rdx,%rsi
  8011cb:	fd                   	std    
  8011cc:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8011ce:	eb 1d                	jmp    8011ed <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8011d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011d4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8011d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011dc:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8011e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011e4:	48 89 d7             	mov    %rdx,%rdi
  8011e7:	48 89 c1             	mov    %rax,%rcx
  8011ea:	fd                   	std    
  8011eb:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8011ed:	fc                   	cld    
  8011ee:	eb 57                	jmp    801247 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f4:	83 e0 03             	and    $0x3,%eax
  8011f7:	48 85 c0             	test   %rax,%rax
  8011fa:	75 36                	jne    801232 <memmove+0xfc>
  8011fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801200:	83 e0 03             	and    $0x3,%eax
  801203:	48 85 c0             	test   %rax,%rax
  801206:	75 2a                	jne    801232 <memmove+0xfc>
  801208:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80120c:	83 e0 03             	and    $0x3,%eax
  80120f:	48 85 c0             	test   %rax,%rax
  801212:	75 1e                	jne    801232 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801214:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801218:	48 c1 e8 02          	shr    $0x2,%rax
  80121c:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80121f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801223:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801227:	48 89 c7             	mov    %rax,%rdi
  80122a:	48 89 d6             	mov    %rdx,%rsi
  80122d:	fc                   	cld    
  80122e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801230:	eb 15                	jmp    801247 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801232:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801236:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80123a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80123e:	48 89 c7             	mov    %rax,%rdi
  801241:	48 89 d6             	mov    %rdx,%rsi
  801244:	fc                   	cld    
  801245:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801247:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80124b:	c9                   	leaveq 
  80124c:	c3                   	retq   

000000000080124d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80124d:	55                   	push   %rbp
  80124e:	48 89 e5             	mov    %rsp,%rbp
  801251:	48 83 ec 18          	sub    $0x18,%rsp
  801255:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801259:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80125d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801261:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801265:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801269:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80126d:	48 89 ce             	mov    %rcx,%rsi
  801270:	48 89 c7             	mov    %rax,%rdi
  801273:	48 b8 36 11 80 00 00 	movabs $0x801136,%rax
  80127a:	00 00 00 
  80127d:	ff d0                	callq  *%rax
}
  80127f:	c9                   	leaveq 
  801280:	c3                   	retq   

0000000000801281 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801281:	55                   	push   %rbp
  801282:	48 89 e5             	mov    %rsp,%rbp
  801285:	48 83 ec 28          	sub    $0x28,%rsp
  801289:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80128d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801291:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801295:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801299:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80129d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012a1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8012a5:	eb 36                	jmp    8012dd <memcmp+0x5c>
		if (*s1 != *s2)
  8012a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ab:	0f b6 10             	movzbl (%rax),%edx
  8012ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012b2:	0f b6 00             	movzbl (%rax),%eax
  8012b5:	38 c2                	cmp    %al,%dl
  8012b7:	74 1a                	je     8012d3 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8012b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012bd:	0f b6 00             	movzbl (%rax),%eax
  8012c0:	0f b6 d0             	movzbl %al,%edx
  8012c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012c7:	0f b6 00             	movzbl (%rax),%eax
  8012ca:	0f b6 c0             	movzbl %al,%eax
  8012cd:	29 c2                	sub    %eax,%edx
  8012cf:	89 d0                	mov    %edx,%eax
  8012d1:	eb 20                	jmp    8012f3 <memcmp+0x72>
		s1++, s2++;
  8012d3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012d8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8012dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012e1:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012e5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8012e9:	48 85 c0             	test   %rax,%rax
  8012ec:	75 b9                	jne    8012a7 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8012ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012f3:	c9                   	leaveq 
  8012f4:	c3                   	retq   

00000000008012f5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8012f5:	55                   	push   %rbp
  8012f6:	48 89 e5             	mov    %rsp,%rbp
  8012f9:	48 83 ec 28          	sub    $0x28,%rsp
  8012fd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801301:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801304:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801308:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80130c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801310:	48 01 d0             	add    %rdx,%rax
  801313:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801317:	eb 15                	jmp    80132e <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801319:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80131d:	0f b6 10             	movzbl (%rax),%edx
  801320:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801323:	38 c2                	cmp    %al,%dl
  801325:	75 02                	jne    801329 <memfind+0x34>
			break;
  801327:	eb 0f                	jmp    801338 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801329:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80132e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801332:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801336:	72 e1                	jb     801319 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801338:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80133c:	c9                   	leaveq 
  80133d:	c3                   	retq   

000000000080133e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80133e:	55                   	push   %rbp
  80133f:	48 89 e5             	mov    %rsp,%rbp
  801342:	48 83 ec 34          	sub    $0x34,%rsp
  801346:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80134a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80134e:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801351:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801358:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80135f:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801360:	eb 05                	jmp    801367 <strtol+0x29>
		s++;
  801362:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801367:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80136b:	0f b6 00             	movzbl (%rax),%eax
  80136e:	3c 20                	cmp    $0x20,%al
  801370:	74 f0                	je     801362 <strtol+0x24>
  801372:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801376:	0f b6 00             	movzbl (%rax),%eax
  801379:	3c 09                	cmp    $0x9,%al
  80137b:	74 e5                	je     801362 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80137d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801381:	0f b6 00             	movzbl (%rax),%eax
  801384:	3c 2b                	cmp    $0x2b,%al
  801386:	75 07                	jne    80138f <strtol+0x51>
		s++;
  801388:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80138d:	eb 17                	jmp    8013a6 <strtol+0x68>
	else if (*s == '-')
  80138f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801393:	0f b6 00             	movzbl (%rax),%eax
  801396:	3c 2d                	cmp    $0x2d,%al
  801398:	75 0c                	jne    8013a6 <strtol+0x68>
		s++, neg = 1;
  80139a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80139f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013a6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013aa:	74 06                	je     8013b2 <strtol+0x74>
  8013ac:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8013b0:	75 28                	jne    8013da <strtol+0x9c>
  8013b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b6:	0f b6 00             	movzbl (%rax),%eax
  8013b9:	3c 30                	cmp    $0x30,%al
  8013bb:	75 1d                	jne    8013da <strtol+0x9c>
  8013bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c1:	48 83 c0 01          	add    $0x1,%rax
  8013c5:	0f b6 00             	movzbl (%rax),%eax
  8013c8:	3c 78                	cmp    $0x78,%al
  8013ca:	75 0e                	jne    8013da <strtol+0x9c>
		s += 2, base = 16;
  8013cc:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8013d1:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8013d8:	eb 2c                	jmp    801406 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8013da:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013de:	75 19                	jne    8013f9 <strtol+0xbb>
  8013e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e4:	0f b6 00             	movzbl (%rax),%eax
  8013e7:	3c 30                	cmp    $0x30,%al
  8013e9:	75 0e                	jne    8013f9 <strtol+0xbb>
		s++, base = 8;
  8013eb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013f0:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8013f7:	eb 0d                	jmp    801406 <strtol+0xc8>
	else if (base == 0)
  8013f9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013fd:	75 07                	jne    801406 <strtol+0xc8>
		base = 10;
  8013ff:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801406:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140a:	0f b6 00             	movzbl (%rax),%eax
  80140d:	3c 2f                	cmp    $0x2f,%al
  80140f:	7e 1d                	jle    80142e <strtol+0xf0>
  801411:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801415:	0f b6 00             	movzbl (%rax),%eax
  801418:	3c 39                	cmp    $0x39,%al
  80141a:	7f 12                	jg     80142e <strtol+0xf0>
			dig = *s - '0';
  80141c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801420:	0f b6 00             	movzbl (%rax),%eax
  801423:	0f be c0             	movsbl %al,%eax
  801426:	83 e8 30             	sub    $0x30,%eax
  801429:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80142c:	eb 4e                	jmp    80147c <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80142e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801432:	0f b6 00             	movzbl (%rax),%eax
  801435:	3c 60                	cmp    $0x60,%al
  801437:	7e 1d                	jle    801456 <strtol+0x118>
  801439:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143d:	0f b6 00             	movzbl (%rax),%eax
  801440:	3c 7a                	cmp    $0x7a,%al
  801442:	7f 12                	jg     801456 <strtol+0x118>
			dig = *s - 'a' + 10;
  801444:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801448:	0f b6 00             	movzbl (%rax),%eax
  80144b:	0f be c0             	movsbl %al,%eax
  80144e:	83 e8 57             	sub    $0x57,%eax
  801451:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801454:	eb 26                	jmp    80147c <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801456:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145a:	0f b6 00             	movzbl (%rax),%eax
  80145d:	3c 40                	cmp    $0x40,%al
  80145f:	7e 48                	jle    8014a9 <strtol+0x16b>
  801461:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801465:	0f b6 00             	movzbl (%rax),%eax
  801468:	3c 5a                	cmp    $0x5a,%al
  80146a:	7f 3d                	jg     8014a9 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80146c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801470:	0f b6 00             	movzbl (%rax),%eax
  801473:	0f be c0             	movsbl %al,%eax
  801476:	83 e8 37             	sub    $0x37,%eax
  801479:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80147c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80147f:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801482:	7c 02                	jl     801486 <strtol+0x148>
			break;
  801484:	eb 23                	jmp    8014a9 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801486:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80148b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80148e:	48 98                	cltq   
  801490:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801495:	48 89 c2             	mov    %rax,%rdx
  801498:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80149b:	48 98                	cltq   
  80149d:	48 01 d0             	add    %rdx,%rax
  8014a0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8014a4:	e9 5d ff ff ff       	jmpq   801406 <strtol+0xc8>

	if (endptr)
  8014a9:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8014ae:	74 0b                	je     8014bb <strtol+0x17d>
		*endptr = (char *) s;
  8014b0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014b4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8014b8:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8014bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014bf:	74 09                	je     8014ca <strtol+0x18c>
  8014c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c5:	48 f7 d8             	neg    %rax
  8014c8:	eb 04                	jmp    8014ce <strtol+0x190>
  8014ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014ce:	c9                   	leaveq 
  8014cf:	c3                   	retq   

00000000008014d0 <strstr>:

char * strstr(const char *in, const char *str)
{
  8014d0:	55                   	push   %rbp
  8014d1:	48 89 e5             	mov    %rsp,%rbp
  8014d4:	48 83 ec 30          	sub    $0x30,%rsp
  8014d8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014dc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8014e0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014e4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014e8:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8014ec:	0f b6 00             	movzbl (%rax),%eax
  8014ef:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8014f2:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8014f6:	75 06                	jne    8014fe <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  8014f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fc:	eb 6b                	jmp    801569 <strstr+0x99>

    len = strlen(str);
  8014fe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801502:	48 89 c7             	mov    %rax,%rdi
  801505:	48 b8 a6 0d 80 00 00 	movabs $0x800da6,%rax
  80150c:	00 00 00 
  80150f:	ff d0                	callq  *%rax
  801511:	48 98                	cltq   
  801513:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801517:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80151b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80151f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801523:	0f b6 00             	movzbl (%rax),%eax
  801526:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801529:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80152d:	75 07                	jne    801536 <strstr+0x66>
                return (char *) 0;
  80152f:	b8 00 00 00 00       	mov    $0x0,%eax
  801534:	eb 33                	jmp    801569 <strstr+0x99>
        } while (sc != c);
  801536:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80153a:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80153d:	75 d8                	jne    801517 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  80153f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801543:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801547:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154b:	48 89 ce             	mov    %rcx,%rsi
  80154e:	48 89 c7             	mov    %rax,%rdi
  801551:	48 b8 c7 0f 80 00 00 	movabs $0x800fc7,%rax
  801558:	00 00 00 
  80155b:	ff d0                	callq  *%rax
  80155d:	85 c0                	test   %eax,%eax
  80155f:	75 b6                	jne    801517 <strstr+0x47>

    return (char *) (in - 1);
  801561:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801565:	48 83 e8 01          	sub    $0x1,%rax
}
  801569:	c9                   	leaveq 
  80156a:	c3                   	retq   

000000000080156b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80156b:	55                   	push   %rbp
  80156c:	48 89 e5             	mov    %rsp,%rbp
  80156f:	53                   	push   %rbx
  801570:	48 83 ec 48          	sub    $0x48,%rsp
  801574:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801577:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80157a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80157e:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801582:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801586:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80158a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80158d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801591:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801595:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801599:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80159d:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8015a1:	4c 89 c3             	mov    %r8,%rbx
  8015a4:	cd 30                	int    $0x30
  8015a6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8015aa:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8015ae:	74 3e                	je     8015ee <syscall+0x83>
  8015b0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015b5:	7e 37                	jle    8015ee <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015bb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015be:	49 89 d0             	mov    %rdx,%r8
  8015c1:	89 c1                	mov    %eax,%ecx
  8015c3:	48 ba 88 1e 80 00 00 	movabs $0x801e88,%rdx
  8015ca:	00 00 00 
  8015cd:	be 23 00 00 00       	mov    $0x23,%esi
  8015d2:	48 bf a5 1e 80 00 00 	movabs $0x801ea5,%rdi
  8015d9:	00 00 00 
  8015dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e1:	49 b9 64 19 80 00 00 	movabs $0x801964,%r9
  8015e8:	00 00 00 
  8015eb:	41 ff d1             	callq  *%r9

	return ret;
  8015ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015f2:	48 83 c4 48          	add    $0x48,%rsp
  8015f6:	5b                   	pop    %rbx
  8015f7:	5d                   	pop    %rbp
  8015f8:	c3                   	retq   

00000000008015f9 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8015f9:	55                   	push   %rbp
  8015fa:	48 89 e5             	mov    %rsp,%rbp
  8015fd:	48 83 ec 20          	sub    $0x20,%rsp
  801601:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801605:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801609:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80160d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801611:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801618:	00 
  801619:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80161f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801625:	48 89 d1             	mov    %rdx,%rcx
  801628:	48 89 c2             	mov    %rax,%rdx
  80162b:	be 00 00 00 00       	mov    $0x0,%esi
  801630:	bf 00 00 00 00       	mov    $0x0,%edi
  801635:	48 b8 6b 15 80 00 00 	movabs $0x80156b,%rax
  80163c:	00 00 00 
  80163f:	ff d0                	callq  *%rax
}
  801641:	c9                   	leaveq 
  801642:	c3                   	retq   

0000000000801643 <sys_cgetc>:

int
sys_cgetc(void)
{
  801643:	55                   	push   %rbp
  801644:	48 89 e5             	mov    %rsp,%rbp
  801647:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80164b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801652:	00 
  801653:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801659:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80165f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801664:	ba 00 00 00 00       	mov    $0x0,%edx
  801669:	be 00 00 00 00       	mov    $0x0,%esi
  80166e:	bf 01 00 00 00       	mov    $0x1,%edi
  801673:	48 b8 6b 15 80 00 00 	movabs $0x80156b,%rax
  80167a:	00 00 00 
  80167d:	ff d0                	callq  *%rax
}
  80167f:	c9                   	leaveq 
  801680:	c3                   	retq   

0000000000801681 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801681:	55                   	push   %rbp
  801682:	48 89 e5             	mov    %rsp,%rbp
  801685:	48 83 ec 10          	sub    $0x10,%rsp
  801689:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80168c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80168f:	48 98                	cltq   
  801691:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801698:	00 
  801699:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80169f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016a5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016aa:	48 89 c2             	mov    %rax,%rdx
  8016ad:	be 01 00 00 00       	mov    $0x1,%esi
  8016b2:	bf 03 00 00 00       	mov    $0x3,%edi
  8016b7:	48 b8 6b 15 80 00 00 	movabs $0x80156b,%rax
  8016be:	00 00 00 
  8016c1:	ff d0                	callq  *%rax
}
  8016c3:	c9                   	leaveq 
  8016c4:	c3                   	retq   

00000000008016c5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8016c5:	55                   	push   %rbp
  8016c6:	48 89 e5             	mov    %rsp,%rbp
  8016c9:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8016cd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016d4:	00 
  8016d5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016db:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016e1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8016eb:	be 00 00 00 00       	mov    $0x0,%esi
  8016f0:	bf 02 00 00 00       	mov    $0x2,%edi
  8016f5:	48 b8 6b 15 80 00 00 	movabs $0x80156b,%rax
  8016fc:	00 00 00 
  8016ff:	ff d0                	callq  *%rax
}
  801701:	c9                   	leaveq 
  801702:	c3                   	retq   

0000000000801703 <sys_yield>:

void
sys_yield(void)
{
  801703:	55                   	push   %rbp
  801704:	48 89 e5             	mov    %rsp,%rbp
  801707:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80170b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801712:	00 
  801713:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801719:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80171f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801724:	ba 00 00 00 00       	mov    $0x0,%edx
  801729:	be 00 00 00 00       	mov    $0x0,%esi
  80172e:	bf 0a 00 00 00       	mov    $0xa,%edi
  801733:	48 b8 6b 15 80 00 00 	movabs $0x80156b,%rax
  80173a:	00 00 00 
  80173d:	ff d0                	callq  *%rax
}
  80173f:	c9                   	leaveq 
  801740:	c3                   	retq   

0000000000801741 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801741:	55                   	push   %rbp
  801742:	48 89 e5             	mov    %rsp,%rbp
  801745:	48 83 ec 20          	sub    $0x20,%rsp
  801749:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80174c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801750:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801753:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801756:	48 63 c8             	movslq %eax,%rcx
  801759:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80175d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801760:	48 98                	cltq   
  801762:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801769:	00 
  80176a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801770:	49 89 c8             	mov    %rcx,%r8
  801773:	48 89 d1             	mov    %rdx,%rcx
  801776:	48 89 c2             	mov    %rax,%rdx
  801779:	be 01 00 00 00       	mov    $0x1,%esi
  80177e:	bf 04 00 00 00       	mov    $0x4,%edi
  801783:	48 b8 6b 15 80 00 00 	movabs $0x80156b,%rax
  80178a:	00 00 00 
  80178d:	ff d0                	callq  *%rax
}
  80178f:	c9                   	leaveq 
  801790:	c3                   	retq   

0000000000801791 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801791:	55                   	push   %rbp
  801792:	48 89 e5             	mov    %rsp,%rbp
  801795:	48 83 ec 30          	sub    $0x30,%rsp
  801799:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80179c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017a0:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8017a3:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8017a7:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8017ab:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8017ae:	48 63 c8             	movslq %eax,%rcx
  8017b1:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8017b5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017b8:	48 63 f0             	movslq %eax,%rsi
  8017bb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017c2:	48 98                	cltq   
  8017c4:	48 89 0c 24          	mov    %rcx,(%rsp)
  8017c8:	49 89 f9             	mov    %rdi,%r9
  8017cb:	49 89 f0             	mov    %rsi,%r8
  8017ce:	48 89 d1             	mov    %rdx,%rcx
  8017d1:	48 89 c2             	mov    %rax,%rdx
  8017d4:	be 01 00 00 00       	mov    $0x1,%esi
  8017d9:	bf 05 00 00 00       	mov    $0x5,%edi
  8017de:	48 b8 6b 15 80 00 00 	movabs $0x80156b,%rax
  8017e5:	00 00 00 
  8017e8:	ff d0                	callq  *%rax
}
  8017ea:	c9                   	leaveq 
  8017eb:	c3                   	retq   

00000000008017ec <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8017ec:	55                   	push   %rbp
  8017ed:	48 89 e5             	mov    %rsp,%rbp
  8017f0:	48 83 ec 20          	sub    $0x20,%rsp
  8017f4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017f7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8017fb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801802:	48 98                	cltq   
  801804:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80180b:	00 
  80180c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801812:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801818:	48 89 d1             	mov    %rdx,%rcx
  80181b:	48 89 c2             	mov    %rax,%rdx
  80181e:	be 01 00 00 00       	mov    $0x1,%esi
  801823:	bf 06 00 00 00       	mov    $0x6,%edi
  801828:	48 b8 6b 15 80 00 00 	movabs $0x80156b,%rax
  80182f:	00 00 00 
  801832:	ff d0                	callq  *%rax
}
  801834:	c9                   	leaveq 
  801835:	c3                   	retq   

0000000000801836 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801836:	55                   	push   %rbp
  801837:	48 89 e5             	mov    %rsp,%rbp
  80183a:	48 83 ec 10          	sub    $0x10,%rsp
  80183e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801841:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801844:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801847:	48 63 d0             	movslq %eax,%rdx
  80184a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80184d:	48 98                	cltq   
  80184f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801856:	00 
  801857:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80185d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801863:	48 89 d1             	mov    %rdx,%rcx
  801866:	48 89 c2             	mov    %rax,%rdx
  801869:	be 01 00 00 00       	mov    $0x1,%esi
  80186e:	bf 08 00 00 00       	mov    $0x8,%edi
  801873:	48 b8 6b 15 80 00 00 	movabs $0x80156b,%rax
  80187a:	00 00 00 
  80187d:	ff d0                	callq  *%rax
}
  80187f:	c9                   	leaveq 
  801880:	c3                   	retq   

0000000000801881 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801881:	55                   	push   %rbp
  801882:	48 89 e5             	mov    %rsp,%rbp
  801885:	48 83 ec 20          	sub    $0x20,%rsp
  801889:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80188c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801890:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801894:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801897:	48 98                	cltq   
  801899:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018a0:	00 
  8018a1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018a7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018ad:	48 89 d1             	mov    %rdx,%rcx
  8018b0:	48 89 c2             	mov    %rax,%rdx
  8018b3:	be 01 00 00 00       	mov    $0x1,%esi
  8018b8:	bf 09 00 00 00       	mov    $0x9,%edi
  8018bd:	48 b8 6b 15 80 00 00 	movabs $0x80156b,%rax
  8018c4:	00 00 00 
  8018c7:	ff d0                	callq  *%rax
}
  8018c9:	c9                   	leaveq 
  8018ca:	c3                   	retq   

00000000008018cb <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8018cb:	55                   	push   %rbp
  8018cc:	48 89 e5             	mov    %rsp,%rbp
  8018cf:	48 83 ec 20          	sub    $0x20,%rsp
  8018d3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018d6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018da:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8018de:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8018e1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018e4:	48 63 f0             	movslq %eax,%rsi
  8018e7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8018eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ee:	48 98                	cltq   
  8018f0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018f4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018fb:	00 
  8018fc:	49 89 f1             	mov    %rsi,%r9
  8018ff:	49 89 c8             	mov    %rcx,%r8
  801902:	48 89 d1             	mov    %rdx,%rcx
  801905:	48 89 c2             	mov    %rax,%rdx
  801908:	be 00 00 00 00       	mov    $0x0,%esi
  80190d:	bf 0b 00 00 00       	mov    $0xb,%edi
  801912:	48 b8 6b 15 80 00 00 	movabs $0x80156b,%rax
  801919:	00 00 00 
  80191c:	ff d0                	callq  *%rax
}
  80191e:	c9                   	leaveq 
  80191f:	c3                   	retq   

0000000000801920 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801920:	55                   	push   %rbp
  801921:	48 89 e5             	mov    %rsp,%rbp
  801924:	48 83 ec 10          	sub    $0x10,%rsp
  801928:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80192c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801930:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801937:	00 
  801938:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80193e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801944:	b9 00 00 00 00       	mov    $0x0,%ecx
  801949:	48 89 c2             	mov    %rax,%rdx
  80194c:	be 01 00 00 00       	mov    $0x1,%esi
  801951:	bf 0c 00 00 00       	mov    $0xc,%edi
  801956:	48 b8 6b 15 80 00 00 	movabs $0x80156b,%rax
  80195d:	00 00 00 
  801960:	ff d0                	callq  *%rax
}
  801962:	c9                   	leaveq 
  801963:	c3                   	retq   

0000000000801964 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801964:	55                   	push   %rbp
  801965:	48 89 e5             	mov    %rsp,%rbp
  801968:	53                   	push   %rbx
  801969:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801970:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801977:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80197d:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801984:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80198b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801992:	84 c0                	test   %al,%al
  801994:	74 23                	je     8019b9 <_panic+0x55>
  801996:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80199d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8019a1:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8019a5:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8019a9:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8019ad:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8019b1:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8019b5:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8019b9:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8019c0:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8019c7:	00 00 00 
  8019ca:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8019d1:	00 00 00 
  8019d4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8019d8:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8019df:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8019e6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8019ed:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8019f4:	00 00 00 
  8019f7:	48 8b 18             	mov    (%rax),%rbx
  8019fa:	48 b8 c5 16 80 00 00 	movabs $0x8016c5,%rax
  801a01:	00 00 00 
  801a04:	ff d0                	callq  *%rax
  801a06:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  801a0c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801a13:	41 89 c8             	mov    %ecx,%r8d
  801a16:	48 89 d1             	mov    %rdx,%rcx
  801a19:	48 89 da             	mov    %rbx,%rdx
  801a1c:	89 c6                	mov    %eax,%esi
  801a1e:	48 bf b8 1e 80 00 00 	movabs $0x801eb8,%rdi
  801a25:	00 00 00 
  801a28:	b8 00 00 00 00       	mov    $0x0,%eax
  801a2d:	49 b9 5d 02 80 00 00 	movabs $0x80025d,%r9
  801a34:	00 00 00 
  801a37:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801a3a:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801a41:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801a48:	48 89 d6             	mov    %rdx,%rsi
  801a4b:	48 89 c7             	mov    %rax,%rdi
  801a4e:	48 b8 b1 01 80 00 00 	movabs $0x8001b1,%rax
  801a55:	00 00 00 
  801a58:	ff d0                	callq  *%rax
	cprintf("\n");
  801a5a:	48 bf db 1e 80 00 00 	movabs $0x801edb,%rdi
  801a61:	00 00 00 
  801a64:	b8 00 00 00 00       	mov    $0x0,%eax
  801a69:	48 ba 5d 02 80 00 00 	movabs $0x80025d,%rdx
  801a70:	00 00 00 
  801a73:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801a75:	cc                   	int3   
  801a76:	eb fd                	jmp    801a75 <_panic+0x111>
