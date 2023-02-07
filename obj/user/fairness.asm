
obj/user/fairness:     file format elf64-x86-64


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
  80003c:	e8 dd 00 00 00       	callq  80011e <libmain>
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
	envid_t who, id;

	id = sys_getenvid();
  800052:	48 b8 66 17 80 00 00 	movabs $0x801766,%rax
  800059:	00 00 00 
  80005c:	ff d0                	callq  *%rax
  80005e:	89 45 fc             	mov    %eax,-0x4(%rbp)

	if (thisenv == &envs[1]) {
  800061:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  800068:	00 00 00 
  80006b:	48 8b 10             	mov    (%rax),%rdx
  80006e:	48 b8 20 01 80 00 80 	movabs $0x8000800120,%rax
  800075:	00 00 00 
  800078:	48 39 c2             	cmp    %rax,%rdx
  80007b:	75 42                	jne    8000bf <umain+0x7c>
		while (1) {
			ipc_recv(&who, 0, 0);
  80007d:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
  800081:	ba 00 00 00 00       	mov    $0x0,%edx
  800086:	be 00 00 00 00       	mov    $0x0,%esi
  80008b:	48 89 c7             	mov    %rax,%rdi
  80008e:	48 b8 05 1a 80 00 00 	movabs $0x801a05,%rax
  800095:	00 00 00 
  800098:	ff d0                	callq  *%rax
			cprintf("%x recv from %x\n", id, who);
  80009a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80009d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000a0:	89 c6                	mov    %eax,%esi
  8000a2:	48 bf c0 1c 80 00 00 	movabs $0x801cc0,%rdi
  8000a9:	00 00 00 
  8000ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b1:	48 b9 fe 02 80 00 00 	movabs $0x8002fe,%rcx
  8000b8:	00 00 00 
  8000bb:	ff d1                	callq  *%rcx
		}
  8000bd:	eb be                	jmp    80007d <umain+0x3a>
	} else {
		cprintf("%x loop sending to %x\n", id, envs[1].env_id);
  8000bf:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000c6:	00 00 00 
  8000c9:	8b 90 e8 01 00 00    	mov    0x1e8(%rax),%edx
  8000cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d2:	89 c6                	mov    %eax,%esi
  8000d4:	48 bf d1 1c 80 00 00 	movabs $0x801cd1,%rdi
  8000db:	00 00 00 
  8000de:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e3:	48 b9 fe 02 80 00 00 	movabs $0x8002fe,%rcx
  8000ea:	00 00 00 
  8000ed:	ff d1                	callq  *%rcx
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  8000ef:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000f6:	00 00 00 
  8000f9:	8b 80 e8 01 00 00    	mov    0x1e8(%rax),%eax
  8000ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  800104:	ba 00 00 00 00       	mov    $0x0,%edx
  800109:	be 00 00 00 00       	mov    $0x0,%esi
  80010e:	89 c7                	mov    %eax,%edi
  800110:	48 b8 c6 1a 80 00 00 	movabs $0x801ac6,%rax
  800117:	00 00 00 
  80011a:	ff d0                	callq  *%rax
  80011c:	eb d1                	jmp    8000ef <umain+0xac>

000000000080011e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80011e:	55                   	push   %rbp
  80011f:	48 89 e5             	mov    %rsp,%rbp
  800122:	48 83 ec 20          	sub    $0x20,%rsp
  800126:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800129:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80012d:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  800134:	00 00 00 
  800137:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	envid_t id = sys_getenvid();
  80013e:	48 b8 66 17 80 00 00 	movabs $0x801766,%rax
  800145:	00 00 00 
  800148:	ff d0                	callq  *%rax
  80014a:	89 45 fc             	mov    %eax,-0x4(%rbp)
        id = ENVX(id);
  80014d:	81 65 fc ff 03 00 00 	andl   $0x3ff,-0x4(%rbp)
	thisenv = &envs[id];
  800154:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800157:	48 63 d0             	movslq %eax,%rdx
  80015a:	48 89 d0             	mov    %rdx,%rax
  80015d:	48 c1 e0 03          	shl    $0x3,%rax
  800161:	48 01 d0             	add    %rdx,%rax
  800164:	48 c1 e0 05          	shl    $0x5,%rax
  800168:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80016f:	00 00 00 
  800172:	48 01 c2             	add    %rax,%rdx
  800175:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  80017c:	00 00 00 
  80017f:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800182:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800186:	7e 14                	jle    80019c <libmain+0x7e>
		binaryname = argv[0];
  800188:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80018c:	48 8b 10             	mov    (%rax),%rdx
  80018f:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  800196:	00 00 00 
  800199:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80019c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8001a0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001a3:	48 89 d6             	mov    %rdx,%rsi
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001af:	00 00 00 
  8001b2:	ff d0                	callq  *%rax
	
	//cprintf("\noutside\n");
	// exit gracefully
	exit();
  8001b4:	48 b8 c2 01 80 00 00 	movabs $0x8001c2,%rax
  8001bb:	00 00 00 
  8001be:	ff d0                	callq  *%rax
}
  8001c0:	c9                   	leaveq 
  8001c1:	c3                   	retq   

00000000008001c2 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001c2:	55                   	push   %rbp
  8001c3:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8001c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8001cb:	48 b8 22 17 80 00 00 	movabs $0x801722,%rax
  8001d2:	00 00 00 
  8001d5:	ff d0                	callq  *%rax
}
  8001d7:	5d                   	pop    %rbp
  8001d8:	c3                   	retq   

00000000008001d9 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001d9:	55                   	push   %rbp
  8001da:	48 89 e5             	mov    %rsp,%rbp
  8001dd:	48 83 ec 10          	sub    $0x10,%rsp
  8001e1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001e4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  8001e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001ec:	8b 00                	mov    (%rax),%eax
  8001ee:	8d 48 01             	lea    0x1(%rax),%ecx
  8001f1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001f5:	89 0a                	mov    %ecx,(%rdx)
  8001f7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8001fa:	89 d1                	mov    %edx,%ecx
  8001fc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800200:	48 98                	cltq   
  800202:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  800206:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80020a:	8b 00                	mov    (%rax),%eax
  80020c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800211:	75 2c                	jne    80023f <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800213:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800217:	8b 00                	mov    (%rax),%eax
  800219:	48 98                	cltq   
  80021b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80021f:	48 83 c2 08          	add    $0x8,%rdx
  800223:	48 89 c6             	mov    %rax,%rsi
  800226:	48 89 d7             	mov    %rdx,%rdi
  800229:	48 b8 9a 16 80 00 00 	movabs $0x80169a,%rax
  800230:	00 00 00 
  800233:	ff d0                	callq  *%rax
		b->idx = 0;
  800235:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800239:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  80023f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800243:	8b 40 04             	mov    0x4(%rax),%eax
  800246:	8d 50 01             	lea    0x1(%rax),%edx
  800249:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80024d:	89 50 04             	mov    %edx,0x4(%rax)
}
  800250:	c9                   	leaveq 
  800251:	c3                   	retq   

0000000000800252 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800252:	55                   	push   %rbp
  800253:	48 89 e5             	mov    %rsp,%rbp
  800256:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80025d:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800264:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  80026b:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800272:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800279:	48 8b 0a             	mov    (%rdx),%rcx
  80027c:	48 89 08             	mov    %rcx,(%rax)
  80027f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800283:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800287:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80028b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  80028f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800296:	00 00 00 
	b.cnt = 0;
  800299:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8002a0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8002a3:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8002aa:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002b1:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002b8:	48 89 c6             	mov    %rax,%rsi
  8002bb:	48 bf d9 01 80 00 00 	movabs $0x8001d9,%rdi
  8002c2:	00 00 00 
  8002c5:	48 b8 b1 06 80 00 00 	movabs $0x8006b1,%rax
  8002cc:	00 00 00 
  8002cf:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8002d1:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8002d7:	48 98                	cltq   
  8002d9:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8002e0:	48 83 c2 08          	add    $0x8,%rdx
  8002e4:	48 89 c6             	mov    %rax,%rsi
  8002e7:	48 89 d7             	mov    %rdx,%rdi
  8002ea:	48 b8 9a 16 80 00 00 	movabs $0x80169a,%rax
  8002f1:	00 00 00 
  8002f4:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  8002f6:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8002fc:	c9                   	leaveq 
  8002fd:	c3                   	retq   

00000000008002fe <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002fe:	55                   	push   %rbp
  8002ff:	48 89 e5             	mov    %rsp,%rbp
  800302:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800309:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800310:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800317:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80031e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800325:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80032c:	84 c0                	test   %al,%al
  80032e:	74 20                	je     800350 <cprintf+0x52>
  800330:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800334:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800338:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80033c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800340:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800344:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800348:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80034c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800350:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800357:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80035e:	00 00 00 
  800361:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800368:	00 00 00 
  80036b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80036f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800376:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80037d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800384:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80038b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800392:	48 8b 0a             	mov    (%rdx),%rcx
  800395:	48 89 08             	mov    %rcx,(%rax)
  800398:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80039c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003a0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003a4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8003a8:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003af:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003b6:	48 89 d6             	mov    %rdx,%rsi
  8003b9:	48 89 c7             	mov    %rax,%rdi
  8003bc:	48 b8 52 02 80 00 00 	movabs $0x800252,%rax
  8003c3:	00 00 00 
  8003c6:	ff d0                	callq  *%rax
  8003c8:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8003ce:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8003d4:	c9                   	leaveq 
  8003d5:	c3                   	retq   

00000000008003d6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003d6:	55                   	push   %rbp
  8003d7:	48 89 e5             	mov    %rsp,%rbp
  8003da:	53                   	push   %rbx
  8003db:	48 83 ec 38          	sub    $0x38,%rsp
  8003df:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8003e3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8003e7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8003eb:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8003ee:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8003f2:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003f6:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8003f9:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8003fd:	77 3b                	ja     80043a <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003ff:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800402:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800406:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800409:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80040d:	ba 00 00 00 00       	mov    $0x0,%edx
  800412:	48 f7 f3             	div    %rbx
  800415:	48 89 c2             	mov    %rax,%rdx
  800418:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80041b:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80041e:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800422:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800426:	41 89 f9             	mov    %edi,%r9d
  800429:	48 89 c7             	mov    %rax,%rdi
  80042c:	48 b8 d6 03 80 00 00 	movabs $0x8003d6,%rax
  800433:	00 00 00 
  800436:	ff d0                	callq  *%rax
  800438:	eb 1e                	jmp    800458 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80043a:	eb 12                	jmp    80044e <printnum+0x78>
			putch(padc, putdat);
  80043c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800440:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800443:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800447:	48 89 ce             	mov    %rcx,%rsi
  80044a:	89 d7                	mov    %edx,%edi
  80044c:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80044e:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800452:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800456:	7f e4                	jg     80043c <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800458:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80045b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80045f:	ba 00 00 00 00       	mov    $0x0,%edx
  800464:	48 f7 f1             	div    %rcx
  800467:	48 89 d0             	mov    %rdx,%rax
  80046a:	48 ba f0 1d 80 00 00 	movabs $0x801df0,%rdx
  800471:	00 00 00 
  800474:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800478:	0f be d0             	movsbl %al,%edx
  80047b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80047f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800483:	48 89 ce             	mov    %rcx,%rsi
  800486:	89 d7                	mov    %edx,%edi
  800488:	ff d0                	callq  *%rax
}
  80048a:	48 83 c4 38          	add    $0x38,%rsp
  80048e:	5b                   	pop    %rbx
  80048f:	5d                   	pop    %rbp
  800490:	c3                   	retq   

0000000000800491 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800491:	55                   	push   %rbp
  800492:	48 89 e5             	mov    %rsp,%rbp
  800495:	48 83 ec 1c          	sub    $0x1c,%rsp
  800499:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80049d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8004a0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004a4:	7e 52                	jle    8004f8 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8004a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004aa:	8b 00                	mov    (%rax),%eax
  8004ac:	83 f8 30             	cmp    $0x30,%eax
  8004af:	73 24                	jae    8004d5 <getuint+0x44>
  8004b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004bd:	8b 00                	mov    (%rax),%eax
  8004bf:	89 c0                	mov    %eax,%eax
  8004c1:	48 01 d0             	add    %rdx,%rax
  8004c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004c8:	8b 12                	mov    (%rdx),%edx
  8004ca:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004d1:	89 0a                	mov    %ecx,(%rdx)
  8004d3:	eb 17                	jmp    8004ec <getuint+0x5b>
  8004d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004dd:	48 89 d0             	mov    %rdx,%rax
  8004e0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004e8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004ec:	48 8b 00             	mov    (%rax),%rax
  8004ef:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004f3:	e9 a3 00 00 00       	jmpq   80059b <getuint+0x10a>
	else if (lflag)
  8004f8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004fc:	74 4f                	je     80054d <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8004fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800502:	8b 00                	mov    (%rax),%eax
  800504:	83 f8 30             	cmp    $0x30,%eax
  800507:	73 24                	jae    80052d <getuint+0x9c>
  800509:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80050d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800511:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800515:	8b 00                	mov    (%rax),%eax
  800517:	89 c0                	mov    %eax,%eax
  800519:	48 01 d0             	add    %rdx,%rax
  80051c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800520:	8b 12                	mov    (%rdx),%edx
  800522:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800525:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800529:	89 0a                	mov    %ecx,(%rdx)
  80052b:	eb 17                	jmp    800544 <getuint+0xb3>
  80052d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800531:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800535:	48 89 d0             	mov    %rdx,%rax
  800538:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80053c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800540:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800544:	48 8b 00             	mov    (%rax),%rax
  800547:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80054b:	eb 4e                	jmp    80059b <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80054d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800551:	8b 00                	mov    (%rax),%eax
  800553:	83 f8 30             	cmp    $0x30,%eax
  800556:	73 24                	jae    80057c <getuint+0xeb>
  800558:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80055c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800560:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800564:	8b 00                	mov    (%rax),%eax
  800566:	89 c0                	mov    %eax,%eax
  800568:	48 01 d0             	add    %rdx,%rax
  80056b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80056f:	8b 12                	mov    (%rdx),%edx
  800571:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800574:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800578:	89 0a                	mov    %ecx,(%rdx)
  80057a:	eb 17                	jmp    800593 <getuint+0x102>
  80057c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800580:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800584:	48 89 d0             	mov    %rdx,%rax
  800587:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80058b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80058f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800593:	8b 00                	mov    (%rax),%eax
  800595:	89 c0                	mov    %eax,%eax
  800597:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80059b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80059f:	c9                   	leaveq 
  8005a0:	c3                   	retq   

00000000008005a1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005a1:	55                   	push   %rbp
  8005a2:	48 89 e5             	mov    %rsp,%rbp
  8005a5:	48 83 ec 1c          	sub    $0x1c,%rsp
  8005a9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005ad:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005b0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005b4:	7e 52                	jle    800608 <getint+0x67>
		x=va_arg(*ap, long long);
  8005b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ba:	8b 00                	mov    (%rax),%eax
  8005bc:	83 f8 30             	cmp    $0x30,%eax
  8005bf:	73 24                	jae    8005e5 <getint+0x44>
  8005c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005cd:	8b 00                	mov    (%rax),%eax
  8005cf:	89 c0                	mov    %eax,%eax
  8005d1:	48 01 d0             	add    %rdx,%rax
  8005d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d8:	8b 12                	mov    (%rdx),%edx
  8005da:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005e1:	89 0a                	mov    %ecx,(%rdx)
  8005e3:	eb 17                	jmp    8005fc <getint+0x5b>
  8005e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005ed:	48 89 d0             	mov    %rdx,%rax
  8005f0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005f4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005fc:	48 8b 00             	mov    (%rax),%rax
  8005ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800603:	e9 a3 00 00 00       	jmpq   8006ab <getint+0x10a>
	else if (lflag)
  800608:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80060c:	74 4f                	je     80065d <getint+0xbc>
		x=va_arg(*ap, long);
  80060e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800612:	8b 00                	mov    (%rax),%eax
  800614:	83 f8 30             	cmp    $0x30,%eax
  800617:	73 24                	jae    80063d <getint+0x9c>
  800619:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800621:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800625:	8b 00                	mov    (%rax),%eax
  800627:	89 c0                	mov    %eax,%eax
  800629:	48 01 d0             	add    %rdx,%rax
  80062c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800630:	8b 12                	mov    (%rdx),%edx
  800632:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800635:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800639:	89 0a                	mov    %ecx,(%rdx)
  80063b:	eb 17                	jmp    800654 <getint+0xb3>
  80063d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800641:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800645:	48 89 d0             	mov    %rdx,%rax
  800648:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80064c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800650:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800654:	48 8b 00             	mov    (%rax),%rax
  800657:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80065b:	eb 4e                	jmp    8006ab <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80065d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800661:	8b 00                	mov    (%rax),%eax
  800663:	83 f8 30             	cmp    $0x30,%eax
  800666:	73 24                	jae    80068c <getint+0xeb>
  800668:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800670:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800674:	8b 00                	mov    (%rax),%eax
  800676:	89 c0                	mov    %eax,%eax
  800678:	48 01 d0             	add    %rdx,%rax
  80067b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80067f:	8b 12                	mov    (%rdx),%edx
  800681:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800684:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800688:	89 0a                	mov    %ecx,(%rdx)
  80068a:	eb 17                	jmp    8006a3 <getint+0x102>
  80068c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800690:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800694:	48 89 d0             	mov    %rdx,%rax
  800697:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80069b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80069f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006a3:	8b 00                	mov    (%rax),%eax
  8006a5:	48 98                	cltq   
  8006a7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006af:	c9                   	leaveq 
  8006b0:	c3                   	retq   

00000000008006b1 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006b1:	55                   	push   %rbp
  8006b2:	48 89 e5             	mov    %rsp,%rbp
  8006b5:	41 54                	push   %r12
  8006b7:	53                   	push   %rbx
  8006b8:	48 83 ec 60          	sub    $0x60,%rsp
  8006bc:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006c0:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006c4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006c8:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006cc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8006d0:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006d4:	48 8b 0a             	mov    (%rdx),%rcx
  8006d7:	48 89 08             	mov    %rcx,(%rax)
  8006da:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006de:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006e2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006e6:	48 89 50 10          	mov    %rdx,0x10(%rax)
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006ea:	eb 17                	jmp    800703 <vprintfmt+0x52>
			if (ch == '\0')
  8006ec:	85 db                	test   %ebx,%ebx
  8006ee:	0f 84 cc 04 00 00    	je     800bc0 <vprintfmt+0x50f>
                }
#endif

			  return;
			}
			putch(ch, putdat);
  8006f4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8006f8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8006fc:	48 89 d6             	mov    %rdx,%rsi
  8006ff:	89 df                	mov    %ebx,%edi
  800701:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800703:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800707:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80070b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80070f:	0f b6 00             	movzbl (%rax),%eax
  800712:	0f b6 d8             	movzbl %al,%ebx
  800715:	83 fb 25             	cmp    $0x25,%ebx
  800718:	75 d2                	jne    8006ec <vprintfmt+0x3b>
			  return;
			}
			putch(ch, putdat);
		}
		// Process a %-escape sequence
		padc = ' ';
  80071a:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80071e:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800725:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80072c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800733:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80073a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80073e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800742:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800746:	0f b6 00             	movzbl (%rax),%eax
  800749:	0f b6 d8             	movzbl %al,%ebx
  80074c:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80074f:	83 f8 55             	cmp    $0x55,%eax
  800752:	0f 87 34 04 00 00    	ja     800b8c <vprintfmt+0x4db>
  800758:	89 c0                	mov    %eax,%eax
  80075a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800761:	00 
  800762:	48 b8 18 1e 80 00 00 	movabs $0x801e18,%rax
  800769:	00 00 00 
  80076c:	48 01 d0             	add    %rdx,%rax
  80076f:	48 8b 00             	mov    (%rax),%rax
  800772:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800774:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800778:	eb c0                	jmp    80073a <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80077a:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80077e:	eb ba                	jmp    80073a <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800780:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800787:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80078a:	89 d0                	mov    %edx,%eax
  80078c:	c1 e0 02             	shl    $0x2,%eax
  80078f:	01 d0                	add    %edx,%eax
  800791:	01 c0                	add    %eax,%eax
  800793:	01 d8                	add    %ebx,%eax
  800795:	83 e8 30             	sub    $0x30,%eax
  800798:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80079b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80079f:	0f b6 00             	movzbl (%rax),%eax
  8007a2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007a5:	83 fb 2f             	cmp    $0x2f,%ebx
  8007a8:	7e 0c                	jle    8007b6 <vprintfmt+0x105>
  8007aa:	83 fb 39             	cmp    $0x39,%ebx
  8007ad:	7f 07                	jg     8007b6 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007af:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007b4:	eb d1                	jmp    800787 <vprintfmt+0xd6>
			goto process_precision;
  8007b6:	eb 58                	jmp    800810 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8007b8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007bb:	83 f8 30             	cmp    $0x30,%eax
  8007be:	73 17                	jae    8007d7 <vprintfmt+0x126>
  8007c0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007c4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007c7:	89 c0                	mov    %eax,%eax
  8007c9:	48 01 d0             	add    %rdx,%rax
  8007cc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007cf:	83 c2 08             	add    $0x8,%edx
  8007d2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007d5:	eb 0f                	jmp    8007e6 <vprintfmt+0x135>
  8007d7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007db:	48 89 d0             	mov    %rdx,%rax
  8007de:	48 83 c2 08          	add    $0x8,%rdx
  8007e2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007e6:	8b 00                	mov    (%rax),%eax
  8007e8:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8007eb:	eb 23                	jmp    800810 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8007ed:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007f1:	79 0c                	jns    8007ff <vprintfmt+0x14e>
				width = 0;
  8007f3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8007fa:	e9 3b ff ff ff       	jmpq   80073a <vprintfmt+0x89>
  8007ff:	e9 36 ff ff ff       	jmpq   80073a <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800804:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80080b:	e9 2a ff ff ff       	jmpq   80073a <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800810:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800814:	79 12                	jns    800828 <vprintfmt+0x177>
				width = precision, precision = -1;
  800816:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800819:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80081c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800823:	e9 12 ff ff ff       	jmpq   80073a <vprintfmt+0x89>
  800828:	e9 0d ff ff ff       	jmpq   80073a <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80082d:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800831:	e9 04 ff ff ff       	jmpq   80073a <vprintfmt+0x89>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			putch(va_arg(aq, int), putdat);
  800836:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800839:	83 f8 30             	cmp    $0x30,%eax
  80083c:	73 17                	jae    800855 <vprintfmt+0x1a4>
  80083e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800842:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800845:	89 c0                	mov    %eax,%eax
  800847:	48 01 d0             	add    %rdx,%rax
  80084a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80084d:	83 c2 08             	add    $0x8,%edx
  800850:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800853:	eb 0f                	jmp    800864 <vprintfmt+0x1b3>
  800855:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800859:	48 89 d0             	mov    %rdx,%rax
  80085c:	48 83 c2 08          	add    $0x8,%rdx
  800860:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800864:	8b 10                	mov    (%rax),%edx
  800866:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80086a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80086e:	48 89 ce             	mov    %rcx,%rsi
  800871:	89 d7                	mov    %edx,%edi
  800873:	ff d0                	callq  *%rax
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  800875:	e9 40 03 00 00       	jmpq   800bba <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  80087a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80087d:	83 f8 30             	cmp    $0x30,%eax
  800880:	73 17                	jae    800899 <vprintfmt+0x1e8>
  800882:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800886:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800889:	89 c0                	mov    %eax,%eax
  80088b:	48 01 d0             	add    %rdx,%rax
  80088e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800891:	83 c2 08             	add    $0x8,%edx
  800894:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800897:	eb 0f                	jmp    8008a8 <vprintfmt+0x1f7>
  800899:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80089d:	48 89 d0             	mov    %rdx,%rax
  8008a0:	48 83 c2 08          	add    $0x8,%rdx
  8008a4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008a8:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8008aa:	85 db                	test   %ebx,%ebx
  8008ac:	79 02                	jns    8008b0 <vprintfmt+0x1ff>
				err = -err;
  8008ae:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008b0:	83 fb 09             	cmp    $0x9,%ebx
  8008b3:	7f 16                	jg     8008cb <vprintfmt+0x21a>
  8008b5:	48 b8 a0 1d 80 00 00 	movabs $0x801da0,%rax
  8008bc:	00 00 00 
  8008bf:	48 63 d3             	movslq %ebx,%rdx
  8008c2:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8008c6:	4d 85 e4             	test   %r12,%r12
  8008c9:	75 2e                	jne    8008f9 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8008cb:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008cf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008d3:	89 d9                	mov    %ebx,%ecx
  8008d5:	48 ba 01 1e 80 00 00 	movabs $0x801e01,%rdx
  8008dc:	00 00 00 
  8008df:	48 89 c7             	mov    %rax,%rdi
  8008e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e7:	49 b8 c9 0b 80 00 00 	movabs $0x800bc9,%r8
  8008ee:	00 00 00 
  8008f1:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008f4:	e9 c1 02 00 00       	jmpq   800bba <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008f9:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008fd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800901:	4c 89 e1             	mov    %r12,%rcx
  800904:	48 ba 0a 1e 80 00 00 	movabs $0x801e0a,%rdx
  80090b:	00 00 00 
  80090e:	48 89 c7             	mov    %rax,%rdi
  800911:	b8 00 00 00 00       	mov    $0x0,%eax
  800916:	49 b8 c9 0b 80 00 00 	movabs $0x800bc9,%r8
  80091d:	00 00 00 
  800920:	41 ff d0             	callq  *%r8
			break;
  800923:	e9 92 02 00 00       	jmpq   800bba <vprintfmt+0x509>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
  800928:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80092b:	83 f8 30             	cmp    $0x30,%eax
  80092e:	73 17                	jae    800947 <vprintfmt+0x296>
  800930:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800934:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800937:	89 c0                	mov    %eax,%eax
  800939:	48 01 d0             	add    %rdx,%rax
  80093c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80093f:	83 c2 08             	add    $0x8,%edx
  800942:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800945:	eb 0f                	jmp    800956 <vprintfmt+0x2a5>
  800947:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80094b:	48 89 d0             	mov    %rdx,%rax
  80094e:	48 83 c2 08          	add    $0x8,%rdx
  800952:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800956:	4c 8b 20             	mov    (%rax),%r12
  800959:	4d 85 e4             	test   %r12,%r12
  80095c:	75 0a                	jne    800968 <vprintfmt+0x2b7>
				p = "(null)";
  80095e:	49 bc 0d 1e 80 00 00 	movabs $0x801e0d,%r12
  800965:	00 00 00 
			if (width > 0 && padc != '-')
  800968:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80096c:	7e 3f                	jle    8009ad <vprintfmt+0x2fc>
  80096e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800972:	74 39                	je     8009ad <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800974:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800977:	48 98                	cltq   
  800979:	48 89 c6             	mov    %rax,%rsi
  80097c:	4c 89 e7             	mov    %r12,%rdi
  80097f:	48 b8 75 0e 80 00 00 	movabs $0x800e75,%rax
  800986:	00 00 00 
  800989:	ff d0                	callq  *%rax
  80098b:	29 45 dc             	sub    %eax,-0x24(%rbp)
  80098e:	eb 17                	jmp    8009a7 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800990:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800994:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800998:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80099c:	48 89 ce             	mov    %rcx,%rsi
  80099f:	89 d7                	mov    %edx,%edi
  8009a1:	ff d0                	callq  *%rax
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009a3:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009a7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009ab:	7f e3                	jg     800990 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ad:	eb 37                	jmp    8009e6 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8009af:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8009b3:	74 1e                	je     8009d3 <vprintfmt+0x322>
  8009b5:	83 fb 1f             	cmp    $0x1f,%ebx
  8009b8:	7e 05                	jle    8009bf <vprintfmt+0x30e>
  8009ba:	83 fb 7e             	cmp    $0x7e,%ebx
  8009bd:	7e 14                	jle    8009d3 <vprintfmt+0x322>
					putch('?', putdat);
  8009bf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009c3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009c7:	48 89 d6             	mov    %rdx,%rsi
  8009ca:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009cf:	ff d0                	callq  *%rax
  8009d1:	eb 0f                	jmp    8009e2 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8009d3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009d7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009db:	48 89 d6             	mov    %rdx,%rsi
  8009de:	89 df                	mov    %ebx,%edi
  8009e0:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009e2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009e6:	4c 89 e0             	mov    %r12,%rax
  8009e9:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8009ed:	0f b6 00             	movzbl (%rax),%eax
  8009f0:	0f be d8             	movsbl %al,%ebx
  8009f3:	85 db                	test   %ebx,%ebx
  8009f5:	74 10                	je     800a07 <vprintfmt+0x356>
  8009f7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009fb:	78 b2                	js     8009af <vprintfmt+0x2fe>
  8009fd:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a01:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a05:	79 a8                	jns    8009af <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a07:	eb 16                	jmp    800a1f <vprintfmt+0x36e>
				putch(' ', putdat);
  800a09:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a0d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a11:	48 89 d6             	mov    %rdx,%rsi
  800a14:	bf 20 00 00 00       	mov    $0x20,%edi
  800a19:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a1b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a1f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a23:	7f e4                	jg     800a09 <vprintfmt+0x358>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  800a25:	e9 90 01 00 00       	jmpq   800bba <vprintfmt+0x509>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getint(&aq, 3);
  800a2a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a2e:	be 03 00 00 00       	mov    $0x3,%esi
  800a33:	48 89 c7             	mov    %rax,%rdi
  800a36:	48 b8 a1 05 80 00 00 	movabs $0x8005a1,%rax
  800a3d:	00 00 00 
  800a40:	ff d0                	callq  *%rax
  800a42:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a4a:	48 85 c0             	test   %rax,%rax
  800a4d:	79 1d                	jns    800a6c <vprintfmt+0x3bb>
				putch('-', putdat);
  800a4f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a53:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a57:	48 89 d6             	mov    %rdx,%rsi
  800a5a:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a5f:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a65:	48 f7 d8             	neg    %rax
  800a68:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a6c:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a73:	e9 d5 00 00 00       	jmpq   800b4d <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			
			num = getuint(&aq, 3);
  800a78:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a7c:	be 03 00 00 00       	mov    $0x3,%esi
  800a81:	48 89 c7             	mov    %rax,%rdi
  800a84:	48 b8 91 04 80 00 00 	movabs $0x800491,%rax
  800a8b:	00 00 00 
  800a8e:	ff d0                	callq  *%rax
  800a90:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a94:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a9b:	e9 ad 00 00 00       	jmpq   800b4d <vprintfmt+0x49c>
                  ch = *(unsigned char *) color;
                }
#endif

			// Replace this with your code.
		        num = getuint(&aq, 3);
  800aa0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800aa4:	be 03 00 00 00       	mov    $0x3,%esi
  800aa9:	48 89 c7             	mov    %rax,%rdi
  800aac:	48 b8 91 04 80 00 00 	movabs $0x800491,%rax
  800ab3:	00 00 00 
  800ab6:	ff d0                	callq  *%rax
  800ab8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800abc:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800ac3:	e9 85 00 00 00       	jmpq   800b4d <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			putch('0', putdat);
  800ac8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800acc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ad0:	48 89 d6             	mov    %rdx,%rsi
  800ad3:	bf 30 00 00 00       	mov    $0x30,%edi
  800ad8:	ff d0                	callq  *%rax
			putch('x', putdat);
  800ada:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ade:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae2:	48 89 d6             	mov    %rdx,%rsi
  800ae5:	bf 78 00 00 00       	mov    $0x78,%edi
  800aea:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800aec:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aef:	83 f8 30             	cmp    $0x30,%eax
  800af2:	73 17                	jae    800b0b <vprintfmt+0x45a>
  800af4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800af8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800afb:	89 c0                	mov    %eax,%eax
  800afd:	48 01 d0             	add    %rdx,%rax
  800b00:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b03:	83 c2 08             	add    $0x8,%edx
  800b06:	89 55 b8             	mov    %edx,-0x48(%rbp)
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b09:	eb 0f                	jmp    800b1a <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800b0b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b0f:	48 89 d0             	mov    %rdx,%rax
  800b12:	48 83 c2 08          	add    $0x8,%rdx
  800b16:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b1a:	48 8b 00             	mov    (%rax),%rax
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b1d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b21:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b28:	eb 23                	jmp    800b4d <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getuint(&aq, 3);
  800b2a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b2e:	be 03 00 00 00       	mov    $0x3,%esi
  800b33:	48 89 c7             	mov    %rax,%rdi
  800b36:	48 b8 91 04 80 00 00 	movabs $0x800491,%rax
  800b3d:	00 00 00 
  800b40:	ff d0                	callq  *%rax
  800b42:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b46:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:

			printnum(putch, putdat, num, base, width, padc);
  800b4d:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b52:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b55:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b58:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b5c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b60:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b64:	45 89 c1             	mov    %r8d,%r9d
  800b67:	41 89 f8             	mov    %edi,%r8d
  800b6a:	48 89 c7             	mov    %rax,%rdi
  800b6d:	48 b8 d6 03 80 00 00 	movabs $0x8003d6,%rax
  800b74:	00 00 00 
  800b77:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			break;
  800b79:	eb 3f                	jmp    800bba <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b7b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b7f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b83:	48 89 d6             	mov    %rdx,%rsi
  800b86:	89 df                	mov    %ebx,%edi
  800b88:	ff d0                	callq  *%rax
			break;
  800b8a:	eb 2e                	jmp    800bba <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b8c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b90:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b94:	48 89 d6             	mov    %rdx,%rsi
  800b97:	bf 25 00 00 00       	mov    $0x25,%edi
  800b9c:	ff d0                	callq  *%rax

			for (fmt--; fmt[-1] != '%'; fmt--)
  800b9e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ba3:	eb 05                	jmp    800baa <vprintfmt+0x4f9>
  800ba5:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800baa:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bae:	48 83 e8 01          	sub    $0x1,%rax
  800bb2:	0f b6 00             	movzbl (%rax),%eax
  800bb5:	3c 25                	cmp    $0x25,%al
  800bb7:	75 ec                	jne    800ba5 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800bb9:	90                   	nop
		}
	}
  800bba:	90                   	nop
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bbb:	e9 43 fb ff ff       	jmpq   800703 <vprintfmt+0x52>
			break;
		}
	}
    
va_end(aq);
}
  800bc0:	48 83 c4 60          	add    $0x60,%rsp
  800bc4:	5b                   	pop    %rbx
  800bc5:	41 5c                	pop    %r12
  800bc7:	5d                   	pop    %rbp
  800bc8:	c3                   	retq   

0000000000800bc9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bc9:	55                   	push   %rbp
  800bca:	48 89 e5             	mov    %rsp,%rbp
  800bcd:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800bd4:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800bdb:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800be2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800be9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800bf0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800bf7:	84 c0                	test   %al,%al
  800bf9:	74 20                	je     800c1b <printfmt+0x52>
  800bfb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800bff:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c03:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c07:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c0b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c0f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c13:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c17:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c1b:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c22:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c29:	00 00 00 
  800c2c:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c33:	00 00 00 
  800c36:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c3a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c41:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c48:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c4f:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c56:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c5d:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c64:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c6b:	48 89 c7             	mov    %rax,%rdi
  800c6e:	48 b8 b1 06 80 00 00 	movabs $0x8006b1,%rax
  800c75:	00 00 00 
  800c78:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c7a:	c9                   	leaveq 
  800c7b:	c3                   	retq   

0000000000800c7c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c7c:	55                   	push   %rbp
  800c7d:	48 89 e5             	mov    %rsp,%rbp
  800c80:	48 83 ec 10          	sub    $0x10,%rsp
  800c84:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c87:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800c8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c8f:	8b 40 10             	mov    0x10(%rax),%eax
  800c92:	8d 50 01             	lea    0x1(%rax),%edx
  800c95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c99:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ca0:	48 8b 10             	mov    (%rax),%rdx
  800ca3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ca7:	48 8b 40 08          	mov    0x8(%rax),%rax
  800cab:	48 39 c2             	cmp    %rax,%rdx
  800cae:	73 17                	jae    800cc7 <sprintputch+0x4b>
		*b->buf++ = ch;
  800cb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cb4:	48 8b 00             	mov    (%rax),%rax
  800cb7:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800cbb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cbf:	48 89 0a             	mov    %rcx,(%rdx)
  800cc2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800cc5:	88 10                	mov    %dl,(%rax)
}
  800cc7:	c9                   	leaveq 
  800cc8:	c3                   	retq   

0000000000800cc9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cc9:	55                   	push   %rbp
  800cca:	48 89 e5             	mov    %rsp,%rbp
  800ccd:	48 83 ec 50          	sub    $0x50,%rsp
  800cd1:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800cd5:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800cd8:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800cdc:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ce0:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ce4:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800ce8:	48 8b 0a             	mov    (%rdx),%rcx
  800ceb:	48 89 08             	mov    %rcx,(%rax)
  800cee:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800cf2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800cf6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800cfa:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cfe:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d02:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800d06:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d09:	48 98                	cltq   
  800d0b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800d0f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d13:	48 01 d0             	add    %rdx,%rax
  800d16:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d1a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d21:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d26:	74 06                	je     800d2e <vsnprintf+0x65>
  800d28:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d2c:	7f 07                	jg     800d35 <vsnprintf+0x6c>
		return -E_INVAL;
  800d2e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d33:	eb 2f                	jmp    800d64 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d35:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d39:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d3d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d41:	48 89 c6             	mov    %rax,%rsi
  800d44:	48 bf 7c 0c 80 00 00 	movabs $0x800c7c,%rdi
  800d4b:	00 00 00 
  800d4e:	48 b8 b1 06 80 00 00 	movabs $0x8006b1,%rax
  800d55:	00 00 00 
  800d58:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d5a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d5e:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d61:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d64:	c9                   	leaveq 
  800d65:	c3                   	retq   

0000000000800d66 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d66:	55                   	push   %rbp
  800d67:	48 89 e5             	mov    %rsp,%rbp
  800d6a:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d71:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d78:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d7e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d85:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d8c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d93:	84 c0                	test   %al,%al
  800d95:	74 20                	je     800db7 <snprintf+0x51>
  800d97:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d9b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d9f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800da3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800da7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dab:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800daf:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800db3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800db7:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800dbe:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800dc5:	00 00 00 
  800dc8:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800dcf:	00 00 00 
  800dd2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dd6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800ddd:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800de4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800deb:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800df2:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800df9:	48 8b 0a             	mov    (%rdx),%rcx
  800dfc:	48 89 08             	mov    %rcx,(%rax)
  800dff:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e03:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e07:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e0b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e0f:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e16:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e1d:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e23:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e2a:	48 89 c7             	mov    %rax,%rdi
  800e2d:	48 b8 c9 0c 80 00 00 	movabs $0x800cc9,%rax
  800e34:	00 00 00 
  800e37:	ff d0                	callq  *%rax
  800e39:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e3f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e45:	c9                   	leaveq 
  800e46:	c3                   	retq   

0000000000800e47 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e47:	55                   	push   %rbp
  800e48:	48 89 e5             	mov    %rsp,%rbp
  800e4b:	48 83 ec 18          	sub    $0x18,%rsp
  800e4f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e5a:	eb 09                	jmp    800e65 <strlen+0x1e>
		n++;
  800e5c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e60:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e69:	0f b6 00             	movzbl (%rax),%eax
  800e6c:	84 c0                	test   %al,%al
  800e6e:	75 ec                	jne    800e5c <strlen+0x15>
		n++;
	return n;
  800e70:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e73:	c9                   	leaveq 
  800e74:	c3                   	retq   

0000000000800e75 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e75:	55                   	push   %rbp
  800e76:	48 89 e5             	mov    %rsp,%rbp
  800e79:	48 83 ec 20          	sub    $0x20,%rsp
  800e7d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e81:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e8c:	eb 0e                	jmp    800e9c <strnlen+0x27>
		n++;
  800e8e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e92:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e97:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e9c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800ea1:	74 0b                	je     800eae <strnlen+0x39>
  800ea3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea7:	0f b6 00             	movzbl (%rax),%eax
  800eaa:	84 c0                	test   %al,%al
  800eac:	75 e0                	jne    800e8e <strnlen+0x19>
		n++;
	return n;
  800eae:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800eb1:	c9                   	leaveq 
  800eb2:	c3                   	retq   

0000000000800eb3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800eb3:	55                   	push   %rbp
  800eb4:	48 89 e5             	mov    %rsp,%rbp
  800eb7:	48 83 ec 20          	sub    $0x20,%rsp
  800ebb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ebf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800ec3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800ecb:	90                   	nop
  800ecc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ed4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ed8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800edc:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800ee0:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800ee4:	0f b6 12             	movzbl (%rdx),%edx
  800ee7:	88 10                	mov    %dl,(%rax)
  800ee9:	0f b6 00             	movzbl (%rax),%eax
  800eec:	84 c0                	test   %al,%al
  800eee:	75 dc                	jne    800ecc <strcpy+0x19>
		/* do nothing */;
	return ret;
  800ef0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ef4:	c9                   	leaveq 
  800ef5:	c3                   	retq   

0000000000800ef6 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ef6:	55                   	push   %rbp
  800ef7:	48 89 e5             	mov    %rsp,%rbp
  800efa:	48 83 ec 20          	sub    $0x20,%rsp
  800efe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f02:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800f06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f0a:	48 89 c7             	mov    %rax,%rdi
  800f0d:	48 b8 47 0e 80 00 00 	movabs $0x800e47,%rax
  800f14:	00 00 00 
  800f17:	ff d0                	callq  *%rax
  800f19:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f1f:	48 63 d0             	movslq %eax,%rdx
  800f22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f26:	48 01 c2             	add    %rax,%rdx
  800f29:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f2d:	48 89 c6             	mov    %rax,%rsi
  800f30:	48 89 d7             	mov    %rdx,%rdi
  800f33:	48 b8 b3 0e 80 00 00 	movabs $0x800eb3,%rax
  800f3a:	00 00 00 
  800f3d:	ff d0                	callq  *%rax
	return dst;
  800f3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f43:	c9                   	leaveq 
  800f44:	c3                   	retq   

0000000000800f45 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f45:	55                   	push   %rbp
  800f46:	48 89 e5             	mov    %rsp,%rbp
  800f49:	48 83 ec 28          	sub    $0x28,%rsp
  800f4d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f51:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f55:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f5d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f61:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f68:	00 
  800f69:	eb 2a                	jmp    800f95 <strncpy+0x50>
		*dst++ = *src;
  800f6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f6f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f73:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f77:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f7b:	0f b6 12             	movzbl (%rdx),%edx
  800f7e:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f80:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f84:	0f b6 00             	movzbl (%rax),%eax
  800f87:	84 c0                	test   %al,%al
  800f89:	74 05                	je     800f90 <strncpy+0x4b>
			src++;
  800f8b:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f90:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f99:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f9d:	72 cc                	jb     800f6b <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800fa3:	c9                   	leaveq 
  800fa4:	c3                   	retq   

0000000000800fa5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800fa5:	55                   	push   %rbp
  800fa6:	48 89 e5             	mov    %rsp,%rbp
  800fa9:	48 83 ec 28          	sub    $0x28,%rsp
  800fad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fb1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fb5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800fb9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fbd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800fc1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fc6:	74 3d                	je     801005 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800fc8:	eb 1d                	jmp    800fe7 <strlcpy+0x42>
			*dst++ = *src++;
  800fca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fce:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fd2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fd6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fda:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800fde:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800fe2:	0f b6 12             	movzbl (%rdx),%edx
  800fe5:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fe7:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800fec:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800ff1:	74 0b                	je     800ffe <strlcpy+0x59>
  800ff3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ff7:	0f b6 00             	movzbl (%rax),%eax
  800ffa:	84 c0                	test   %al,%al
  800ffc:	75 cc                	jne    800fca <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800ffe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801002:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801005:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801009:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80100d:	48 29 c2             	sub    %rax,%rdx
  801010:	48 89 d0             	mov    %rdx,%rax
}
  801013:	c9                   	leaveq 
  801014:	c3                   	retq   

0000000000801015 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801015:	55                   	push   %rbp
  801016:	48 89 e5             	mov    %rsp,%rbp
  801019:	48 83 ec 10          	sub    $0x10,%rsp
  80101d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801021:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801025:	eb 0a                	jmp    801031 <strcmp+0x1c>
		p++, q++;
  801027:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80102c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801031:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801035:	0f b6 00             	movzbl (%rax),%eax
  801038:	84 c0                	test   %al,%al
  80103a:	74 12                	je     80104e <strcmp+0x39>
  80103c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801040:	0f b6 10             	movzbl (%rax),%edx
  801043:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801047:	0f b6 00             	movzbl (%rax),%eax
  80104a:	38 c2                	cmp    %al,%dl
  80104c:	74 d9                	je     801027 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80104e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801052:	0f b6 00             	movzbl (%rax),%eax
  801055:	0f b6 d0             	movzbl %al,%edx
  801058:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80105c:	0f b6 00             	movzbl (%rax),%eax
  80105f:	0f b6 c0             	movzbl %al,%eax
  801062:	29 c2                	sub    %eax,%edx
  801064:	89 d0                	mov    %edx,%eax
}
  801066:	c9                   	leaveq 
  801067:	c3                   	retq   

0000000000801068 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801068:	55                   	push   %rbp
  801069:	48 89 e5             	mov    %rsp,%rbp
  80106c:	48 83 ec 18          	sub    $0x18,%rsp
  801070:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801074:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801078:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80107c:	eb 0f                	jmp    80108d <strncmp+0x25>
		n--, p++, q++;
  80107e:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801083:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801088:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80108d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801092:	74 1d                	je     8010b1 <strncmp+0x49>
  801094:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801098:	0f b6 00             	movzbl (%rax),%eax
  80109b:	84 c0                	test   %al,%al
  80109d:	74 12                	je     8010b1 <strncmp+0x49>
  80109f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010a3:	0f b6 10             	movzbl (%rax),%edx
  8010a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010aa:	0f b6 00             	movzbl (%rax),%eax
  8010ad:	38 c2                	cmp    %al,%dl
  8010af:	74 cd                	je     80107e <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8010b1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010b6:	75 07                	jne    8010bf <strncmp+0x57>
		return 0;
  8010b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8010bd:	eb 18                	jmp    8010d7 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010c3:	0f b6 00             	movzbl (%rax),%eax
  8010c6:	0f b6 d0             	movzbl %al,%edx
  8010c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010cd:	0f b6 00             	movzbl (%rax),%eax
  8010d0:	0f b6 c0             	movzbl %al,%eax
  8010d3:	29 c2                	sub    %eax,%edx
  8010d5:	89 d0                	mov    %edx,%eax
}
  8010d7:	c9                   	leaveq 
  8010d8:	c3                   	retq   

00000000008010d9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010d9:	55                   	push   %rbp
  8010da:	48 89 e5             	mov    %rsp,%rbp
  8010dd:	48 83 ec 0c          	sub    $0xc,%rsp
  8010e1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010e5:	89 f0                	mov    %esi,%eax
  8010e7:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010ea:	eb 17                	jmp    801103 <strchr+0x2a>
		if (*s == c)
  8010ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010f0:	0f b6 00             	movzbl (%rax),%eax
  8010f3:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010f6:	75 06                	jne    8010fe <strchr+0x25>
			return (char *) s;
  8010f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010fc:	eb 15                	jmp    801113 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010fe:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801103:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801107:	0f b6 00             	movzbl (%rax),%eax
  80110a:	84 c0                	test   %al,%al
  80110c:	75 de                	jne    8010ec <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80110e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801113:	c9                   	leaveq 
  801114:	c3                   	retq   

0000000000801115 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801115:	55                   	push   %rbp
  801116:	48 89 e5             	mov    %rsp,%rbp
  801119:	48 83 ec 0c          	sub    $0xc,%rsp
  80111d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801121:	89 f0                	mov    %esi,%eax
  801123:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801126:	eb 13                	jmp    80113b <strfind+0x26>
		if (*s == c)
  801128:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80112c:	0f b6 00             	movzbl (%rax),%eax
  80112f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801132:	75 02                	jne    801136 <strfind+0x21>
			break;
  801134:	eb 10                	jmp    801146 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801136:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80113b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80113f:	0f b6 00             	movzbl (%rax),%eax
  801142:	84 c0                	test   %al,%al
  801144:	75 e2                	jne    801128 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801146:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80114a:	c9                   	leaveq 
  80114b:	c3                   	retq   

000000000080114c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80114c:	55                   	push   %rbp
  80114d:	48 89 e5             	mov    %rsp,%rbp
  801150:	48 83 ec 18          	sub    $0x18,%rsp
  801154:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801158:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80115b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80115f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801164:	75 06                	jne    80116c <memset+0x20>
		return v;
  801166:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80116a:	eb 69                	jmp    8011d5 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80116c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801170:	83 e0 03             	and    $0x3,%eax
  801173:	48 85 c0             	test   %rax,%rax
  801176:	75 48                	jne    8011c0 <memset+0x74>
  801178:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80117c:	83 e0 03             	and    $0x3,%eax
  80117f:	48 85 c0             	test   %rax,%rax
  801182:	75 3c                	jne    8011c0 <memset+0x74>
		c &= 0xFF;
  801184:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80118b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80118e:	c1 e0 18             	shl    $0x18,%eax
  801191:	89 c2                	mov    %eax,%edx
  801193:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801196:	c1 e0 10             	shl    $0x10,%eax
  801199:	09 c2                	or     %eax,%edx
  80119b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80119e:	c1 e0 08             	shl    $0x8,%eax
  8011a1:	09 d0                	or     %edx,%eax
  8011a3:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8011a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011aa:	48 c1 e8 02          	shr    $0x2,%rax
  8011ae:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8011b1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011b5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011b8:	48 89 d7             	mov    %rdx,%rdi
  8011bb:	fc                   	cld    
  8011bc:	f3 ab                	rep stos %eax,%es:(%rdi)
  8011be:	eb 11                	jmp    8011d1 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8011c0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011c4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011c7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8011cb:	48 89 d7             	mov    %rdx,%rdi
  8011ce:	fc                   	cld    
  8011cf:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8011d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011d5:	c9                   	leaveq 
  8011d6:	c3                   	retq   

00000000008011d7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8011d7:	55                   	push   %rbp
  8011d8:	48 89 e5             	mov    %rsp,%rbp
  8011db:	48 83 ec 28          	sub    $0x28,%rsp
  8011df:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011e3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011e7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8011eb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011ef:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8011f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8011fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ff:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801203:	0f 83 88 00 00 00    	jae    801291 <memmove+0xba>
  801209:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80120d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801211:	48 01 d0             	add    %rdx,%rax
  801214:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801218:	76 77                	jbe    801291 <memmove+0xba>
		s += n;
  80121a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80121e:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801222:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801226:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80122a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122e:	83 e0 03             	and    $0x3,%eax
  801231:	48 85 c0             	test   %rax,%rax
  801234:	75 3b                	jne    801271 <memmove+0x9a>
  801236:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80123a:	83 e0 03             	and    $0x3,%eax
  80123d:	48 85 c0             	test   %rax,%rax
  801240:	75 2f                	jne    801271 <memmove+0x9a>
  801242:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801246:	83 e0 03             	and    $0x3,%eax
  801249:	48 85 c0             	test   %rax,%rax
  80124c:	75 23                	jne    801271 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80124e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801252:	48 83 e8 04          	sub    $0x4,%rax
  801256:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80125a:	48 83 ea 04          	sub    $0x4,%rdx
  80125e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801262:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801266:	48 89 c7             	mov    %rax,%rdi
  801269:	48 89 d6             	mov    %rdx,%rsi
  80126c:	fd                   	std    
  80126d:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80126f:	eb 1d                	jmp    80128e <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801271:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801275:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801279:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127d:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801281:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801285:	48 89 d7             	mov    %rdx,%rdi
  801288:	48 89 c1             	mov    %rax,%rcx
  80128b:	fd                   	std    
  80128c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80128e:	fc                   	cld    
  80128f:	eb 57                	jmp    8012e8 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801291:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801295:	83 e0 03             	and    $0x3,%eax
  801298:	48 85 c0             	test   %rax,%rax
  80129b:	75 36                	jne    8012d3 <memmove+0xfc>
  80129d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012a1:	83 e0 03             	and    $0x3,%eax
  8012a4:	48 85 c0             	test   %rax,%rax
  8012a7:	75 2a                	jne    8012d3 <memmove+0xfc>
  8012a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012ad:	83 e0 03             	and    $0x3,%eax
  8012b0:	48 85 c0             	test   %rax,%rax
  8012b3:	75 1e                	jne    8012d3 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012b9:	48 c1 e8 02          	shr    $0x2,%rax
  8012bd:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8012c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012c4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012c8:	48 89 c7             	mov    %rax,%rdi
  8012cb:	48 89 d6             	mov    %rdx,%rsi
  8012ce:	fc                   	cld    
  8012cf:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012d1:	eb 15                	jmp    8012e8 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8012d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012d7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012db:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012df:	48 89 c7             	mov    %rax,%rdi
  8012e2:	48 89 d6             	mov    %rdx,%rsi
  8012e5:	fc                   	cld    
  8012e6:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8012e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012ec:	c9                   	leaveq 
  8012ed:	c3                   	retq   

00000000008012ee <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8012ee:	55                   	push   %rbp
  8012ef:	48 89 e5             	mov    %rsp,%rbp
  8012f2:	48 83 ec 18          	sub    $0x18,%rsp
  8012f6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012fa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012fe:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801302:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801306:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80130a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130e:	48 89 ce             	mov    %rcx,%rsi
  801311:	48 89 c7             	mov    %rax,%rdi
  801314:	48 b8 d7 11 80 00 00 	movabs $0x8011d7,%rax
  80131b:	00 00 00 
  80131e:	ff d0                	callq  *%rax
}
  801320:	c9                   	leaveq 
  801321:	c3                   	retq   

0000000000801322 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801322:	55                   	push   %rbp
  801323:	48 89 e5             	mov    %rsp,%rbp
  801326:	48 83 ec 28          	sub    $0x28,%rsp
  80132a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80132e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801332:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801336:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80133a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80133e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801342:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801346:	eb 36                	jmp    80137e <memcmp+0x5c>
		if (*s1 != *s2)
  801348:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134c:	0f b6 10             	movzbl (%rax),%edx
  80134f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801353:	0f b6 00             	movzbl (%rax),%eax
  801356:	38 c2                	cmp    %al,%dl
  801358:	74 1a                	je     801374 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80135a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80135e:	0f b6 00             	movzbl (%rax),%eax
  801361:	0f b6 d0             	movzbl %al,%edx
  801364:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801368:	0f b6 00             	movzbl (%rax),%eax
  80136b:	0f b6 c0             	movzbl %al,%eax
  80136e:	29 c2                	sub    %eax,%edx
  801370:	89 d0                	mov    %edx,%eax
  801372:	eb 20                	jmp    801394 <memcmp+0x72>
		s1++, s2++;
  801374:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801379:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80137e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801382:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801386:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80138a:	48 85 c0             	test   %rax,%rax
  80138d:	75 b9                	jne    801348 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80138f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801394:	c9                   	leaveq 
  801395:	c3                   	retq   

0000000000801396 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801396:	55                   	push   %rbp
  801397:	48 89 e5             	mov    %rsp,%rbp
  80139a:	48 83 ec 28          	sub    $0x28,%rsp
  80139e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013a2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8013a5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8013a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013b1:	48 01 d0             	add    %rdx,%rax
  8013b4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8013b8:	eb 15                	jmp    8013cf <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013be:	0f b6 10             	movzbl (%rax),%edx
  8013c1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8013c4:	38 c2                	cmp    %al,%dl
  8013c6:	75 02                	jne    8013ca <memfind+0x34>
			break;
  8013c8:	eb 0f                	jmp    8013d9 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013ca:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d3:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8013d7:	72 e1                	jb     8013ba <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8013d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013dd:	c9                   	leaveq 
  8013de:	c3                   	retq   

00000000008013df <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013df:	55                   	push   %rbp
  8013e0:	48 89 e5             	mov    %rsp,%rbp
  8013e3:	48 83 ec 34          	sub    $0x34,%rsp
  8013e7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8013eb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8013ef:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8013f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8013f9:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801400:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801401:	eb 05                	jmp    801408 <strtol+0x29>
		s++;
  801403:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801408:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140c:	0f b6 00             	movzbl (%rax),%eax
  80140f:	3c 20                	cmp    $0x20,%al
  801411:	74 f0                	je     801403 <strtol+0x24>
  801413:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801417:	0f b6 00             	movzbl (%rax),%eax
  80141a:	3c 09                	cmp    $0x9,%al
  80141c:	74 e5                	je     801403 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80141e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801422:	0f b6 00             	movzbl (%rax),%eax
  801425:	3c 2b                	cmp    $0x2b,%al
  801427:	75 07                	jne    801430 <strtol+0x51>
		s++;
  801429:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80142e:	eb 17                	jmp    801447 <strtol+0x68>
	else if (*s == '-')
  801430:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801434:	0f b6 00             	movzbl (%rax),%eax
  801437:	3c 2d                	cmp    $0x2d,%al
  801439:	75 0c                	jne    801447 <strtol+0x68>
		s++, neg = 1;
  80143b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801440:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801447:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80144b:	74 06                	je     801453 <strtol+0x74>
  80144d:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801451:	75 28                	jne    80147b <strtol+0x9c>
  801453:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801457:	0f b6 00             	movzbl (%rax),%eax
  80145a:	3c 30                	cmp    $0x30,%al
  80145c:	75 1d                	jne    80147b <strtol+0x9c>
  80145e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801462:	48 83 c0 01          	add    $0x1,%rax
  801466:	0f b6 00             	movzbl (%rax),%eax
  801469:	3c 78                	cmp    $0x78,%al
  80146b:	75 0e                	jne    80147b <strtol+0x9c>
		s += 2, base = 16;
  80146d:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801472:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801479:	eb 2c                	jmp    8014a7 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80147b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80147f:	75 19                	jne    80149a <strtol+0xbb>
  801481:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801485:	0f b6 00             	movzbl (%rax),%eax
  801488:	3c 30                	cmp    $0x30,%al
  80148a:	75 0e                	jne    80149a <strtol+0xbb>
		s++, base = 8;
  80148c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801491:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801498:	eb 0d                	jmp    8014a7 <strtol+0xc8>
	else if (base == 0)
  80149a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80149e:	75 07                	jne    8014a7 <strtol+0xc8>
		base = 10;
  8014a0:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ab:	0f b6 00             	movzbl (%rax),%eax
  8014ae:	3c 2f                	cmp    $0x2f,%al
  8014b0:	7e 1d                	jle    8014cf <strtol+0xf0>
  8014b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b6:	0f b6 00             	movzbl (%rax),%eax
  8014b9:	3c 39                	cmp    $0x39,%al
  8014bb:	7f 12                	jg     8014cf <strtol+0xf0>
			dig = *s - '0';
  8014bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c1:	0f b6 00             	movzbl (%rax),%eax
  8014c4:	0f be c0             	movsbl %al,%eax
  8014c7:	83 e8 30             	sub    $0x30,%eax
  8014ca:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014cd:	eb 4e                	jmp    80151d <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8014cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d3:	0f b6 00             	movzbl (%rax),%eax
  8014d6:	3c 60                	cmp    $0x60,%al
  8014d8:	7e 1d                	jle    8014f7 <strtol+0x118>
  8014da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014de:	0f b6 00             	movzbl (%rax),%eax
  8014e1:	3c 7a                	cmp    $0x7a,%al
  8014e3:	7f 12                	jg     8014f7 <strtol+0x118>
			dig = *s - 'a' + 10;
  8014e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e9:	0f b6 00             	movzbl (%rax),%eax
  8014ec:	0f be c0             	movsbl %al,%eax
  8014ef:	83 e8 57             	sub    $0x57,%eax
  8014f2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014f5:	eb 26                	jmp    80151d <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8014f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fb:	0f b6 00             	movzbl (%rax),%eax
  8014fe:	3c 40                	cmp    $0x40,%al
  801500:	7e 48                	jle    80154a <strtol+0x16b>
  801502:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801506:	0f b6 00             	movzbl (%rax),%eax
  801509:	3c 5a                	cmp    $0x5a,%al
  80150b:	7f 3d                	jg     80154a <strtol+0x16b>
			dig = *s - 'A' + 10;
  80150d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801511:	0f b6 00             	movzbl (%rax),%eax
  801514:	0f be c0             	movsbl %al,%eax
  801517:	83 e8 37             	sub    $0x37,%eax
  80151a:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80151d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801520:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801523:	7c 02                	jl     801527 <strtol+0x148>
			break;
  801525:	eb 23                	jmp    80154a <strtol+0x16b>
		s++, val = (val * base) + dig;
  801527:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80152c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80152f:	48 98                	cltq   
  801531:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801536:	48 89 c2             	mov    %rax,%rdx
  801539:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80153c:	48 98                	cltq   
  80153e:	48 01 d0             	add    %rdx,%rax
  801541:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801545:	e9 5d ff ff ff       	jmpq   8014a7 <strtol+0xc8>

	if (endptr)
  80154a:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80154f:	74 0b                	je     80155c <strtol+0x17d>
		*endptr = (char *) s;
  801551:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801555:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801559:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80155c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801560:	74 09                	je     80156b <strtol+0x18c>
  801562:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801566:	48 f7 d8             	neg    %rax
  801569:	eb 04                	jmp    80156f <strtol+0x190>
  80156b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80156f:	c9                   	leaveq 
  801570:	c3                   	retq   

0000000000801571 <strstr>:

char * strstr(const char *in, const char *str)
{
  801571:	55                   	push   %rbp
  801572:	48 89 e5             	mov    %rsp,%rbp
  801575:	48 83 ec 30          	sub    $0x30,%rsp
  801579:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80157d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801581:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801585:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801589:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80158d:	0f b6 00             	movzbl (%rax),%eax
  801590:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  801593:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801597:	75 06                	jne    80159f <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  801599:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159d:	eb 6b                	jmp    80160a <strstr+0x99>

    len = strlen(str);
  80159f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015a3:	48 89 c7             	mov    %rax,%rdi
  8015a6:	48 b8 47 0e 80 00 00 	movabs $0x800e47,%rax
  8015ad:	00 00 00 
  8015b0:	ff d0                	callq  *%rax
  8015b2:	48 98                	cltq   
  8015b4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8015b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015bc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015c0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015c4:	0f b6 00             	movzbl (%rax),%eax
  8015c7:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  8015ca:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8015ce:	75 07                	jne    8015d7 <strstr+0x66>
                return (char *) 0;
  8015d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d5:	eb 33                	jmp    80160a <strstr+0x99>
        } while (sc != c);
  8015d7:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8015db:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8015de:	75 d8                	jne    8015b8 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  8015e0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8015e4:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8015e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ec:	48 89 ce             	mov    %rcx,%rsi
  8015ef:	48 89 c7             	mov    %rax,%rdi
  8015f2:	48 b8 68 10 80 00 00 	movabs $0x801068,%rax
  8015f9:	00 00 00 
  8015fc:	ff d0                	callq  *%rax
  8015fe:	85 c0                	test   %eax,%eax
  801600:	75 b6                	jne    8015b8 <strstr+0x47>

    return (char *) (in - 1);
  801602:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801606:	48 83 e8 01          	sub    $0x1,%rax
}
  80160a:	c9                   	leaveq 
  80160b:	c3                   	retq   

000000000080160c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80160c:	55                   	push   %rbp
  80160d:	48 89 e5             	mov    %rsp,%rbp
  801610:	53                   	push   %rbx
  801611:	48 83 ec 48          	sub    $0x48,%rsp
  801615:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801618:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80161b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80161f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801623:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801627:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80162b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80162e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801632:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801636:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80163a:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80163e:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801642:	4c 89 c3             	mov    %r8,%rbx
  801645:	cd 30                	int    $0x30
  801647:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80164b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80164f:	74 3e                	je     80168f <syscall+0x83>
  801651:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801656:	7e 37                	jle    80168f <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801658:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80165c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80165f:	49 89 d0             	mov    %rdx,%r8
  801662:	89 c1                	mov    %eax,%ecx
  801664:	48 ba c8 20 80 00 00 	movabs $0x8020c8,%rdx
  80166b:	00 00 00 
  80166e:	be 23 00 00 00       	mov    $0x23,%esi
  801673:	48 bf e5 20 80 00 00 	movabs $0x8020e5,%rdi
  80167a:	00 00 00 
  80167d:	b8 00 00 00 00       	mov    $0x0,%eax
  801682:	49 b9 a9 1b 80 00 00 	movabs $0x801ba9,%r9
  801689:	00 00 00 
  80168c:	41 ff d1             	callq  *%r9

	return ret;
  80168f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801693:	48 83 c4 48          	add    $0x48,%rsp
  801697:	5b                   	pop    %rbx
  801698:	5d                   	pop    %rbp
  801699:	c3                   	retq   

000000000080169a <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80169a:	55                   	push   %rbp
  80169b:	48 89 e5             	mov    %rsp,%rbp
  80169e:	48 83 ec 20          	sub    $0x20,%rsp
  8016a2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016a6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8016aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016b2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016b9:	00 
  8016ba:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016c0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016c6:	48 89 d1             	mov    %rdx,%rcx
  8016c9:	48 89 c2             	mov    %rax,%rdx
  8016cc:	be 00 00 00 00       	mov    $0x0,%esi
  8016d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8016d6:	48 b8 0c 16 80 00 00 	movabs $0x80160c,%rax
  8016dd:	00 00 00 
  8016e0:	ff d0                	callq  *%rax
}
  8016e2:	c9                   	leaveq 
  8016e3:	c3                   	retq   

00000000008016e4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016e4:	55                   	push   %rbp
  8016e5:	48 89 e5             	mov    %rsp,%rbp
  8016e8:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8016ec:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016f3:	00 
  8016f4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016fa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801700:	b9 00 00 00 00       	mov    $0x0,%ecx
  801705:	ba 00 00 00 00       	mov    $0x0,%edx
  80170a:	be 00 00 00 00       	mov    $0x0,%esi
  80170f:	bf 01 00 00 00       	mov    $0x1,%edi
  801714:	48 b8 0c 16 80 00 00 	movabs $0x80160c,%rax
  80171b:	00 00 00 
  80171e:	ff d0                	callq  *%rax
}
  801720:	c9                   	leaveq 
  801721:	c3                   	retq   

0000000000801722 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801722:	55                   	push   %rbp
  801723:	48 89 e5             	mov    %rsp,%rbp
  801726:	48 83 ec 10          	sub    $0x10,%rsp
  80172a:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80172d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801730:	48 98                	cltq   
  801732:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801739:	00 
  80173a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801740:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801746:	b9 00 00 00 00       	mov    $0x0,%ecx
  80174b:	48 89 c2             	mov    %rax,%rdx
  80174e:	be 01 00 00 00       	mov    $0x1,%esi
  801753:	bf 03 00 00 00       	mov    $0x3,%edi
  801758:	48 b8 0c 16 80 00 00 	movabs $0x80160c,%rax
  80175f:	00 00 00 
  801762:	ff d0                	callq  *%rax
}
  801764:	c9                   	leaveq 
  801765:	c3                   	retq   

0000000000801766 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801766:	55                   	push   %rbp
  801767:	48 89 e5             	mov    %rsp,%rbp
  80176a:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80176e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801775:	00 
  801776:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80177c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801782:	b9 00 00 00 00       	mov    $0x0,%ecx
  801787:	ba 00 00 00 00       	mov    $0x0,%edx
  80178c:	be 00 00 00 00       	mov    $0x0,%esi
  801791:	bf 02 00 00 00       	mov    $0x2,%edi
  801796:	48 b8 0c 16 80 00 00 	movabs $0x80160c,%rax
  80179d:	00 00 00 
  8017a0:	ff d0                	callq  *%rax
}
  8017a2:	c9                   	leaveq 
  8017a3:	c3                   	retq   

00000000008017a4 <sys_yield>:

void
sys_yield(void)
{
  8017a4:	55                   	push   %rbp
  8017a5:	48 89 e5             	mov    %rsp,%rbp
  8017a8:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8017ac:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017b3:	00 
  8017b4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017ba:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017c0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ca:	be 00 00 00 00       	mov    $0x0,%esi
  8017cf:	bf 0a 00 00 00       	mov    $0xa,%edi
  8017d4:	48 b8 0c 16 80 00 00 	movabs $0x80160c,%rax
  8017db:	00 00 00 
  8017de:	ff d0                	callq  *%rax
}
  8017e0:	c9                   	leaveq 
  8017e1:	c3                   	retq   

00000000008017e2 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8017e2:	55                   	push   %rbp
  8017e3:	48 89 e5             	mov    %rsp,%rbp
  8017e6:	48 83 ec 20          	sub    $0x20,%rsp
  8017ea:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017ed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017f1:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8017f4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017f7:	48 63 c8             	movslq %eax,%rcx
  8017fa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801801:	48 98                	cltq   
  801803:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80180a:	00 
  80180b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801811:	49 89 c8             	mov    %rcx,%r8
  801814:	48 89 d1             	mov    %rdx,%rcx
  801817:	48 89 c2             	mov    %rax,%rdx
  80181a:	be 01 00 00 00       	mov    $0x1,%esi
  80181f:	bf 04 00 00 00       	mov    $0x4,%edi
  801824:	48 b8 0c 16 80 00 00 	movabs $0x80160c,%rax
  80182b:	00 00 00 
  80182e:	ff d0                	callq  *%rax
}
  801830:	c9                   	leaveq 
  801831:	c3                   	retq   

0000000000801832 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801832:	55                   	push   %rbp
  801833:	48 89 e5             	mov    %rsp,%rbp
  801836:	48 83 ec 30          	sub    $0x30,%rsp
  80183a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80183d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801841:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801844:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801848:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80184c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80184f:	48 63 c8             	movslq %eax,%rcx
  801852:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801856:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801859:	48 63 f0             	movslq %eax,%rsi
  80185c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801860:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801863:	48 98                	cltq   
  801865:	48 89 0c 24          	mov    %rcx,(%rsp)
  801869:	49 89 f9             	mov    %rdi,%r9
  80186c:	49 89 f0             	mov    %rsi,%r8
  80186f:	48 89 d1             	mov    %rdx,%rcx
  801872:	48 89 c2             	mov    %rax,%rdx
  801875:	be 01 00 00 00       	mov    $0x1,%esi
  80187a:	bf 05 00 00 00       	mov    $0x5,%edi
  80187f:	48 b8 0c 16 80 00 00 	movabs $0x80160c,%rax
  801886:	00 00 00 
  801889:	ff d0                	callq  *%rax
}
  80188b:	c9                   	leaveq 
  80188c:	c3                   	retq   

000000000080188d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80188d:	55                   	push   %rbp
  80188e:	48 89 e5             	mov    %rsp,%rbp
  801891:	48 83 ec 20          	sub    $0x20,%rsp
  801895:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801898:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80189c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018a3:	48 98                	cltq   
  8018a5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018ac:	00 
  8018ad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018b3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018b9:	48 89 d1             	mov    %rdx,%rcx
  8018bc:	48 89 c2             	mov    %rax,%rdx
  8018bf:	be 01 00 00 00       	mov    $0x1,%esi
  8018c4:	bf 06 00 00 00       	mov    $0x6,%edi
  8018c9:	48 b8 0c 16 80 00 00 	movabs $0x80160c,%rax
  8018d0:	00 00 00 
  8018d3:	ff d0                	callq  *%rax
}
  8018d5:	c9                   	leaveq 
  8018d6:	c3                   	retq   

00000000008018d7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8018d7:	55                   	push   %rbp
  8018d8:	48 89 e5             	mov    %rsp,%rbp
  8018db:	48 83 ec 10          	sub    $0x10,%rsp
  8018df:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018e2:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8018e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018e8:	48 63 d0             	movslq %eax,%rdx
  8018eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ee:	48 98                	cltq   
  8018f0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018f7:	00 
  8018f8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018fe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801904:	48 89 d1             	mov    %rdx,%rcx
  801907:	48 89 c2             	mov    %rax,%rdx
  80190a:	be 01 00 00 00       	mov    $0x1,%esi
  80190f:	bf 08 00 00 00       	mov    $0x8,%edi
  801914:	48 b8 0c 16 80 00 00 	movabs $0x80160c,%rax
  80191b:	00 00 00 
  80191e:	ff d0                	callq  *%rax
}
  801920:	c9                   	leaveq 
  801921:	c3                   	retq   

0000000000801922 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801922:	55                   	push   %rbp
  801923:	48 89 e5             	mov    %rsp,%rbp
  801926:	48 83 ec 20          	sub    $0x20,%rsp
  80192a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80192d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801931:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801935:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801938:	48 98                	cltq   
  80193a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801941:	00 
  801942:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801948:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80194e:	48 89 d1             	mov    %rdx,%rcx
  801951:	48 89 c2             	mov    %rax,%rdx
  801954:	be 01 00 00 00       	mov    $0x1,%esi
  801959:	bf 09 00 00 00       	mov    $0x9,%edi
  80195e:	48 b8 0c 16 80 00 00 	movabs $0x80160c,%rax
  801965:	00 00 00 
  801968:	ff d0                	callq  *%rax
}
  80196a:	c9                   	leaveq 
  80196b:	c3                   	retq   

000000000080196c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  80196c:	55                   	push   %rbp
  80196d:	48 89 e5             	mov    %rsp,%rbp
  801970:	48 83 ec 20          	sub    $0x20,%rsp
  801974:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801977:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80197b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80197f:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801982:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801985:	48 63 f0             	movslq %eax,%rsi
  801988:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80198c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80198f:	48 98                	cltq   
  801991:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801995:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80199c:	00 
  80199d:	49 89 f1             	mov    %rsi,%r9
  8019a0:	49 89 c8             	mov    %rcx,%r8
  8019a3:	48 89 d1             	mov    %rdx,%rcx
  8019a6:	48 89 c2             	mov    %rax,%rdx
  8019a9:	be 00 00 00 00       	mov    $0x0,%esi
  8019ae:	bf 0b 00 00 00       	mov    $0xb,%edi
  8019b3:	48 b8 0c 16 80 00 00 	movabs $0x80160c,%rax
  8019ba:	00 00 00 
  8019bd:	ff d0                	callq  *%rax
}
  8019bf:	c9                   	leaveq 
  8019c0:	c3                   	retq   

00000000008019c1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8019c1:	55                   	push   %rbp
  8019c2:	48 89 e5             	mov    %rsp,%rbp
  8019c5:	48 83 ec 10          	sub    $0x10,%rsp
  8019c9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8019cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019d1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019d8:	00 
  8019d9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019df:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019e5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019ea:	48 89 c2             	mov    %rax,%rdx
  8019ed:	be 01 00 00 00       	mov    $0x1,%esi
  8019f2:	bf 0c 00 00 00       	mov    $0xc,%edi
  8019f7:	48 b8 0c 16 80 00 00 	movabs $0x80160c,%rax
  8019fe:	00 00 00 
  801a01:	ff d0                	callq  *%rax
}
  801a03:	c9                   	leaveq 
  801a04:	c3                   	retq   

0000000000801a05 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801a05:	55                   	push   %rbp
  801a06:	48 89 e5             	mov    %rsp,%rbp
  801a09:	48 83 ec 30          	sub    $0x30,%rsp
  801a0d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a11:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a15:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	
	if(pg == NULL)
  801a19:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801a1e:	75 0e                	jne    801a2e <ipc_recv+0x29>
	  pg = (void *)(UTOP); // We always check above and below UTOP
  801a20:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  801a27:	00 00 00 
  801a2a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	 int retval = sys_ipc_recv(pg);
  801a2e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a32:	48 89 c7             	mov    %rax,%rdi
  801a35:	48 b8 c1 19 80 00 00 	movabs $0x8019c1,%rax
  801a3c:	00 00 00 
  801a3f:	ff d0                	callq  *%rax
  801a41:	89 45 fc             	mov    %eax,-0x4(%rbp)

	 if(retval == 0)
  801a44:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a48:	75 55                	jne    801a9f <ipc_recv+0x9a>
	 {	
	    if(from_env_store != NULL)
  801a4a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801a4f:	74 19                	je     801a6a <ipc_recv+0x65>
               *from_env_store = thisenv->env_ipc_from;
  801a51:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  801a58:	00 00 00 
  801a5b:	48 8b 00             	mov    (%rax),%rax
  801a5e:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  801a64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a68:	89 10                	mov    %edx,(%rax)

	    if(perm_store != NULL)
  801a6a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801a6f:	74 19                	je     801a8a <ipc_recv+0x85>
               *perm_store = thisenv->env_ipc_perm;
  801a71:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  801a78:	00 00 00 
  801a7b:	48 8b 00             	mov    (%rax),%rax
  801a7e:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  801a84:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a88:	89 10                	mov    %edx,(%rax)

	   return thisenv->env_ipc_value;
  801a8a:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  801a91:	00 00 00 
  801a94:	48 8b 00             	mov    (%rax),%rax
  801a97:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  801a9d:	eb 25                	jmp    801ac4 <ipc_recv+0xbf>

	 }
	 else
	 {
	      if(from_env_store)
  801a9f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801aa4:	74 0a                	je     801ab0 <ipc_recv+0xab>
	         *from_env_store = 0;
  801aa6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801aaa:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	      
	      if(perm_store)
  801ab0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801ab5:	74 0a                	je     801ac1 <ipc_recv+0xbc>
	       *perm_store = 0;
  801ab7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801abb:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	       
	       return retval;
  801ac1:	8b 45 fc             	mov    -0x4(%rbp),%eax
	 }
	
	panic("problem in ipc_recv lib/ipc.c");
	//return 0;
}
  801ac4:	c9                   	leaveq 
  801ac5:	c3                   	retq   

0000000000801ac6 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ac6:	55                   	push   %rbp
  801ac7:	48 89 e5             	mov    %rsp,%rbp
  801aca:	48 83 ec 30          	sub    $0x30,%rsp
  801ace:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ad1:	89 75 e8             	mov    %esi,-0x18(%rbp)
  801ad4:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  801ad8:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.

	if(pg == NULL)
  801adb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801ae0:	75 0e                	jne    801af0 <ipc_send+0x2a>
	   pg = (void *)(UTOP);
  801ae2:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  801ae9:	00 00 00 
  801aec:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	int retval;
	while(1)
	{
	   retval = sys_ipc_try_send(to_env, val, pg, perm);
  801af0:	8b 75 e8             	mov    -0x18(%rbp),%esi
  801af3:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  801af6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801afa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801afd:	89 c7                	mov    %eax,%edi
  801aff:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  801b06:	00 00 00 
  801b09:	ff d0                	callq  *%rax
  801b0b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	   if(retval == 0)
  801b0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b12:	75 02                	jne    801b16 <ipc_send+0x50>
	      break;
  801b14:	eb 0e                	jmp    801b24 <ipc_send+0x5e>
	   
	   //if(retval < 0 && retval != -E_IPC_NOT_RECV)
	     //panic("receiver error other than NOT_RECV");

	   sys_yield(); 
  801b16:	48 b8 a4 17 80 00 00 	movabs $0x8017a4,%rax
  801b1d:	00 00 00 
  801b20:	ff d0                	callq  *%rax
	 
	}
  801b22:	eb cc                	jmp    801af0 <ipc_send+0x2a>
	return;
  801b24:	90                   	nop
	//panic("ipc_send not implemented");
}
  801b25:	c9                   	leaveq 
  801b26:	c3                   	retq   

0000000000801b27 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801b27:	55                   	push   %rbp
  801b28:	48 89 e5             	mov    %rsp,%rbp
  801b2b:	48 83 ec 14          	sub    $0x14,%rsp
  801b2f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  801b32:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801b39:	eb 5e                	jmp    801b99 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  801b3b:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  801b42:	00 00 00 
  801b45:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b48:	48 63 d0             	movslq %eax,%rdx
  801b4b:	48 89 d0             	mov    %rdx,%rax
  801b4e:	48 c1 e0 03          	shl    $0x3,%rax
  801b52:	48 01 d0             	add    %rdx,%rax
  801b55:	48 c1 e0 05          	shl    $0x5,%rax
  801b59:	48 01 c8             	add    %rcx,%rax
  801b5c:	48 05 d0 00 00 00    	add    $0xd0,%rax
  801b62:	8b 00                	mov    (%rax),%eax
  801b64:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801b67:	75 2c                	jne    801b95 <ipc_find_env+0x6e>
			return envs[i].env_id;
  801b69:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  801b70:	00 00 00 
  801b73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b76:	48 63 d0             	movslq %eax,%rdx
  801b79:	48 89 d0             	mov    %rdx,%rax
  801b7c:	48 c1 e0 03          	shl    $0x3,%rax
  801b80:	48 01 d0             	add    %rdx,%rax
  801b83:	48 c1 e0 05          	shl    $0x5,%rax
  801b87:	48 01 c8             	add    %rcx,%rax
  801b8a:	48 05 c0 00 00 00    	add    $0xc0,%rax
  801b90:	8b 40 08             	mov    0x8(%rax),%eax
  801b93:	eb 12                	jmp    801ba7 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801b95:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801b99:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  801ba0:	7e 99                	jle    801b3b <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801ba2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ba7:	c9                   	leaveq 
  801ba8:	c3                   	retq   

0000000000801ba9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801ba9:	55                   	push   %rbp
  801baa:	48 89 e5             	mov    %rsp,%rbp
  801bad:	53                   	push   %rbx
  801bae:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801bb5:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801bbc:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801bc2:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801bc9:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801bd0:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801bd7:	84 c0                	test   %al,%al
  801bd9:	74 23                	je     801bfe <_panic+0x55>
  801bdb:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801be2:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801be6:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801bea:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801bee:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801bf2:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801bf6:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801bfa:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801bfe:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801c05:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801c0c:	00 00 00 
  801c0f:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801c16:	00 00 00 
  801c19:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801c1d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801c24:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801c2b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801c32:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  801c39:	00 00 00 
  801c3c:	48 8b 18             	mov    (%rax),%rbx
  801c3f:	48 b8 66 17 80 00 00 	movabs $0x801766,%rax
  801c46:	00 00 00 
  801c49:	ff d0                	callq  *%rax
  801c4b:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  801c51:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801c58:	41 89 c8             	mov    %ecx,%r8d
  801c5b:	48 89 d1             	mov    %rdx,%rcx
  801c5e:	48 89 da             	mov    %rbx,%rdx
  801c61:	89 c6                	mov    %eax,%esi
  801c63:	48 bf f8 20 80 00 00 	movabs $0x8020f8,%rdi
  801c6a:	00 00 00 
  801c6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c72:	49 b9 fe 02 80 00 00 	movabs $0x8002fe,%r9
  801c79:	00 00 00 
  801c7c:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801c7f:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801c86:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801c8d:	48 89 d6             	mov    %rdx,%rsi
  801c90:	48 89 c7             	mov    %rax,%rdi
  801c93:	48 b8 52 02 80 00 00 	movabs $0x800252,%rax
  801c9a:	00 00 00 
  801c9d:	ff d0                	callq  *%rax
	cprintf("\n");
  801c9f:	48 bf 1b 21 80 00 00 	movabs $0x80211b,%rdi
  801ca6:	00 00 00 
  801ca9:	b8 00 00 00 00       	mov    $0x0,%eax
  801cae:	48 ba fe 02 80 00 00 	movabs $0x8002fe,%rdx
  801cb5:	00 00 00 
  801cb8:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801cba:	cc                   	int3   
  801cbb:	eb fd                	jmp    801cba <_panic+0x111>
