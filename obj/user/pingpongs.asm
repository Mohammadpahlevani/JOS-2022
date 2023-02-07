
obj/user/pingpongs:     file format elf64-x86-64


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
  80003c:	e8 b6 01 00 00       	callq  8001f7 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

uint32_t val;

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	41 56                	push   %r14
  800049:	41 55                	push   %r13
  80004b:	41 54                	push   %r12
  80004d:	53                   	push   %rbx
  80004e:	48 83 ec 20          	sub    $0x20,%rsp
  800052:	89 7d cc             	mov    %edi,-0x34(%rbp)
  800055:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	envid_t who;
	uint32_t i;

	i = 0;
  800059:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
	if ((who = sfork()) != 0) {
  800060:	48 b8 cd 20 80 00 00 	movabs $0x8020cd,%rax
  800067:	00 00 00 
  80006a:	ff d0                	callq  *%rax
  80006c:	89 45 d8             	mov    %eax,-0x28(%rbp)
  80006f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800072:	85 c0                	test   %eax,%eax
  800074:	0f 84 87 00 00 00    	je     800101 <umain+0xbe>
		cprintf("i am %08x; thisenv is %p\n", sys_getenvid(), thisenv);
  80007a:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  800081:	00 00 00 
  800084:	48 8b 18             	mov    (%rax),%rbx
  800087:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
  80008e:	00 00 00 
  800091:	ff d0                	callq  *%rax
  800093:	48 89 da             	mov    %rbx,%rdx
  800096:	89 c6                	mov    %eax,%esi
  800098:	48 bf 40 25 80 00 00 	movabs $0x802540,%rdi
  80009f:	00 00 00 
  8000a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a7:	48 b9 d7 03 80 00 00 	movabs $0x8003d7,%rcx
  8000ae:	00 00 00 
  8000b1:	ff d1                	callq  *%rcx
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  8000b3:	8b 5d d8             	mov    -0x28(%rbp),%ebx
  8000b6:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
  8000bd:	00 00 00 
  8000c0:	ff d0                	callq  *%rax
  8000c2:	89 da                	mov    %ebx,%edx
  8000c4:	89 c6                	mov    %eax,%esi
  8000c6:	48 bf 5a 25 80 00 00 	movabs $0x80255a,%rdi
  8000cd:	00 00 00 
  8000d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d5:	48 b9 d7 03 80 00 00 	movabs $0x8003d7,%rcx
  8000dc:	00 00 00 
  8000df:	ff d1                	callq  *%rcx
		ipc_send(who, 0, 0, 0);
  8000e1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8000e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ee:	be 00 00 00 00       	mov    $0x0,%esi
  8000f3:	89 c7                	mov    %eax,%edi
  8000f5:	48 b8 bc 21 80 00 00 	movabs $0x8021bc,%rax
  8000fc:	00 00 00 
  8000ff:	ff d0                	callq  *%rax
	}

	while (1) {
		ipc_recv(&who, 0, 0);
  800101:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  800105:	ba 00 00 00 00       	mov    $0x0,%edx
  80010a:	be 00 00 00 00       	mov    $0x0,%esi
  80010f:	48 89 c7             	mov    %rax,%rdi
  800112:	48 b8 fb 20 80 00 00 	movabs $0x8020fb,%rax
  800119:	00 00 00 
  80011c:	ff d0                	callq  *%rax
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  80011e:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  800125:	00 00 00 
  800128:	48 8b 00             	mov    (%rax),%rax
  80012b:	44 8b b0 c8 00 00 00 	mov    0xc8(%rax),%r14d
  800132:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  800139:	00 00 00 
  80013c:	4c 8b 28             	mov    (%rax),%r13
  80013f:	44 8b 65 d8          	mov    -0x28(%rbp),%r12d
  800143:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  80014a:	00 00 00 
  80014d:	8b 18                	mov    (%rax),%ebx
  80014f:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
  800156:	00 00 00 
  800159:	ff d0                	callq  *%rax
  80015b:	45 89 f1             	mov    %r14d,%r9d
  80015e:	4d 89 e8             	mov    %r13,%r8
  800161:	44 89 e1             	mov    %r12d,%ecx
  800164:	89 da                	mov    %ebx,%edx
  800166:	89 c6                	mov    %eax,%esi
  800168:	48 bf 70 25 80 00 00 	movabs $0x802570,%rdi
  80016f:	00 00 00 
  800172:	b8 00 00 00 00       	mov    $0x0,%eax
  800177:	49 ba d7 03 80 00 00 	movabs $0x8003d7,%r10
  80017e:	00 00 00 
  800181:	41 ff d2             	callq  *%r10
		if (val == 10)
  800184:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  80018b:	00 00 00 
  80018e:	8b 00                	mov    (%rax),%eax
  800190:	83 f8 0a             	cmp    $0xa,%eax
  800193:	75 02                	jne    800197 <umain+0x154>
			return;
  800195:	eb 53                	jmp    8001ea <umain+0x1a7>
		++val;
  800197:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  80019e:	00 00 00 
  8001a1:	8b 00                	mov    (%rax),%eax
  8001a3:	8d 50 01             	lea    0x1(%rax),%edx
  8001a6:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  8001ad:	00 00 00 
  8001b0:	89 10                	mov    %edx,(%rax)
		ipc_send(who, 0, 0, 0);
  8001b2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8001b5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8001bf:	be 00 00 00 00       	mov    $0x0,%esi
  8001c4:	89 c7                	mov    %eax,%edi
  8001c6:	48 b8 bc 21 80 00 00 	movabs $0x8021bc,%rax
  8001cd:	00 00 00 
  8001d0:	ff d0                	callq  *%rax
		if (val == 10)
  8001d2:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  8001d9:	00 00 00 
  8001dc:	8b 00                	mov    (%rax),%eax
  8001de:	83 f8 0a             	cmp    $0xa,%eax
  8001e1:	75 02                	jne    8001e5 <umain+0x1a2>
			return;
  8001e3:	eb 05                	jmp    8001ea <umain+0x1a7>
	}
  8001e5:	e9 17 ff ff ff       	jmpq   800101 <umain+0xbe>

}
  8001ea:	48 83 c4 20          	add    $0x20,%rsp
  8001ee:	5b                   	pop    %rbx
  8001ef:	41 5c                	pop    %r12
  8001f1:	41 5d                	pop    %r13
  8001f3:	41 5e                	pop    %r14
  8001f5:	5d                   	pop    %rbp
  8001f6:	c3                   	retq   

00000000008001f7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001f7:	55                   	push   %rbp
  8001f8:	48 89 e5             	mov    %rsp,%rbp
  8001fb:	48 83 ec 20          	sub    $0x20,%rsp
  8001ff:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800202:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800206:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  80020d:	00 00 00 
  800210:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	envid_t id = sys_getenvid();
  800217:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
  80021e:	00 00 00 
  800221:	ff d0                	callq  *%rax
  800223:	89 45 fc             	mov    %eax,-0x4(%rbp)
        id = ENVX(id);
  800226:	81 65 fc ff 03 00 00 	andl   $0x3ff,-0x4(%rbp)
	thisenv = &envs[id];
  80022d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800230:	48 63 d0             	movslq %eax,%rdx
  800233:	48 89 d0             	mov    %rdx,%rax
  800236:	48 c1 e0 03          	shl    $0x3,%rax
  80023a:	48 01 d0             	add    %rdx,%rax
  80023d:	48 c1 e0 05          	shl    $0x5,%rax
  800241:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800248:	00 00 00 
  80024b:	48 01 c2             	add    %rax,%rdx
  80024e:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  800255:	00 00 00 
  800258:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80025b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80025f:	7e 14                	jle    800275 <libmain+0x7e>
		binaryname = argv[0];
  800261:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800265:	48 8b 10             	mov    (%rax),%rdx
  800268:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  80026f:	00 00 00 
  800272:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800275:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800279:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80027c:	48 89 d6             	mov    %rdx,%rsi
  80027f:	89 c7                	mov    %eax,%edi
  800281:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800288:	00 00 00 
  80028b:	ff d0                	callq  *%rax
	
	//cprintf("\noutside\n");
	// exit gracefully
	exit();
  80028d:	48 b8 9b 02 80 00 00 	movabs $0x80029b,%rax
  800294:	00 00 00 
  800297:	ff d0                	callq  *%rax
}
  800299:	c9                   	leaveq 
  80029a:	c3                   	retq   

000000000080029b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80029b:	55                   	push   %rbp
  80029c:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  80029f:	bf 00 00 00 00       	mov    $0x0,%edi
  8002a4:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  8002ab:	00 00 00 
  8002ae:	ff d0                	callq  *%rax
}
  8002b0:	5d                   	pop    %rbp
  8002b1:	c3                   	retq   

00000000008002b2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002b2:	55                   	push   %rbp
  8002b3:	48 89 e5             	mov    %rsp,%rbp
  8002b6:	48 83 ec 10          	sub    $0x10,%rsp
  8002ba:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002bd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  8002c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002c5:	8b 00                	mov    (%rax),%eax
  8002c7:	8d 48 01             	lea    0x1(%rax),%ecx
  8002ca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002ce:	89 0a                	mov    %ecx,(%rdx)
  8002d0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8002d3:	89 d1                	mov    %edx,%ecx
  8002d5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002d9:	48 98                	cltq   
  8002db:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  8002df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002e3:	8b 00                	mov    (%rax),%eax
  8002e5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002ea:	75 2c                	jne    800318 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  8002ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002f0:	8b 00                	mov    (%rax),%eax
  8002f2:	48 98                	cltq   
  8002f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002f8:	48 83 c2 08          	add    $0x8,%rdx
  8002fc:	48 89 c6             	mov    %rax,%rsi
  8002ff:	48 89 d7             	mov    %rdx,%rdi
  800302:	48 b8 73 17 80 00 00 	movabs $0x801773,%rax
  800309:	00 00 00 
  80030c:	ff d0                	callq  *%rax
		b->idx = 0;
  80030e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800312:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800318:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80031c:	8b 40 04             	mov    0x4(%rax),%eax
  80031f:	8d 50 01             	lea    0x1(%rax),%edx
  800322:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800326:	89 50 04             	mov    %edx,0x4(%rax)
}
  800329:	c9                   	leaveq 
  80032a:	c3                   	retq   

000000000080032b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80032b:	55                   	push   %rbp
  80032c:	48 89 e5             	mov    %rsp,%rbp
  80032f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800336:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80033d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800344:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80034b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800352:	48 8b 0a             	mov    (%rdx),%rcx
  800355:	48 89 08             	mov    %rcx,(%rax)
  800358:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80035c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800360:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800364:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800368:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80036f:	00 00 00 
	b.cnt = 0;
  800372:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800379:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  80037c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800383:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80038a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800391:	48 89 c6             	mov    %rax,%rsi
  800394:	48 bf b2 02 80 00 00 	movabs $0x8002b2,%rdi
  80039b:	00 00 00 
  80039e:	48 b8 8a 07 80 00 00 	movabs $0x80078a,%rax
  8003a5:	00 00 00 
  8003a8:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8003aa:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8003b0:	48 98                	cltq   
  8003b2:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8003b9:	48 83 c2 08          	add    $0x8,%rdx
  8003bd:	48 89 c6             	mov    %rax,%rsi
  8003c0:	48 89 d7             	mov    %rdx,%rdi
  8003c3:	48 b8 73 17 80 00 00 	movabs $0x801773,%rax
  8003ca:	00 00 00 
  8003cd:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  8003cf:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8003d5:	c9                   	leaveq 
  8003d6:	c3                   	retq   

00000000008003d7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003d7:	55                   	push   %rbp
  8003d8:	48 89 e5             	mov    %rsp,%rbp
  8003db:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8003e2:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8003e9:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8003f0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8003f7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8003fe:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800405:	84 c0                	test   %al,%al
  800407:	74 20                	je     800429 <cprintf+0x52>
  800409:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80040d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800411:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800415:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800419:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80041d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800421:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800425:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800429:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800430:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800437:	00 00 00 
  80043a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800441:	00 00 00 
  800444:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800448:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80044f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800456:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80045d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800464:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80046b:	48 8b 0a             	mov    (%rdx),%rcx
  80046e:	48 89 08             	mov    %rcx,(%rax)
  800471:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800475:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800479:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80047d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800481:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800488:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80048f:	48 89 d6             	mov    %rdx,%rsi
  800492:	48 89 c7             	mov    %rax,%rdi
  800495:	48 b8 2b 03 80 00 00 	movabs $0x80032b,%rax
  80049c:	00 00 00 
  80049f:	ff d0                	callq  *%rax
  8004a1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8004a7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8004ad:	c9                   	leaveq 
  8004ae:	c3                   	retq   

00000000008004af <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004af:	55                   	push   %rbp
  8004b0:	48 89 e5             	mov    %rsp,%rbp
  8004b3:	53                   	push   %rbx
  8004b4:	48 83 ec 38          	sub    $0x38,%rsp
  8004b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004bc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004c0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8004c4:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8004c7:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8004cb:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004cf:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8004d2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8004d6:	77 3b                	ja     800513 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004d8:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8004db:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8004df:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8004e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8004eb:	48 f7 f3             	div    %rbx
  8004ee:	48 89 c2             	mov    %rax,%rdx
  8004f1:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8004f4:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8004f7:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8004fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ff:	41 89 f9             	mov    %edi,%r9d
  800502:	48 89 c7             	mov    %rax,%rdi
  800505:	48 b8 af 04 80 00 00 	movabs $0x8004af,%rax
  80050c:	00 00 00 
  80050f:	ff d0                	callq  *%rax
  800511:	eb 1e                	jmp    800531 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800513:	eb 12                	jmp    800527 <printnum+0x78>
			putch(padc, putdat);
  800515:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800519:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80051c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800520:	48 89 ce             	mov    %rcx,%rsi
  800523:	89 d7                	mov    %edx,%edi
  800525:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800527:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80052b:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80052f:	7f e4                	jg     800515 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800531:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800534:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800538:	ba 00 00 00 00       	mov    $0x0,%edx
  80053d:	48 f7 f1             	div    %rcx
  800540:	48 89 d0             	mov    %rdx,%rax
  800543:	48 ba 90 26 80 00 00 	movabs $0x802690,%rdx
  80054a:	00 00 00 
  80054d:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800551:	0f be d0             	movsbl %al,%edx
  800554:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800558:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80055c:	48 89 ce             	mov    %rcx,%rsi
  80055f:	89 d7                	mov    %edx,%edi
  800561:	ff d0                	callq  *%rax
}
  800563:	48 83 c4 38          	add    $0x38,%rsp
  800567:	5b                   	pop    %rbx
  800568:	5d                   	pop    %rbp
  800569:	c3                   	retq   

000000000080056a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80056a:	55                   	push   %rbp
  80056b:	48 89 e5             	mov    %rsp,%rbp
  80056e:	48 83 ec 1c          	sub    $0x1c,%rsp
  800572:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800576:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800579:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80057d:	7e 52                	jle    8005d1 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80057f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800583:	8b 00                	mov    (%rax),%eax
  800585:	83 f8 30             	cmp    $0x30,%eax
  800588:	73 24                	jae    8005ae <getuint+0x44>
  80058a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800592:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800596:	8b 00                	mov    (%rax),%eax
  800598:	89 c0                	mov    %eax,%eax
  80059a:	48 01 d0             	add    %rdx,%rax
  80059d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a1:	8b 12                	mov    (%rdx),%edx
  8005a3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005aa:	89 0a                	mov    %ecx,(%rdx)
  8005ac:	eb 17                	jmp    8005c5 <getuint+0x5b>
  8005ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005b6:	48 89 d0             	mov    %rdx,%rax
  8005b9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005c1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005c5:	48 8b 00             	mov    (%rax),%rax
  8005c8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005cc:	e9 a3 00 00 00       	jmpq   800674 <getuint+0x10a>
	else if (lflag)
  8005d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005d5:	74 4f                	je     800626 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8005d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005db:	8b 00                	mov    (%rax),%eax
  8005dd:	83 f8 30             	cmp    $0x30,%eax
  8005e0:	73 24                	jae    800606 <getuint+0x9c>
  8005e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ee:	8b 00                	mov    (%rax),%eax
  8005f0:	89 c0                	mov    %eax,%eax
  8005f2:	48 01 d0             	add    %rdx,%rax
  8005f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f9:	8b 12                	mov    (%rdx),%edx
  8005fb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800602:	89 0a                	mov    %ecx,(%rdx)
  800604:	eb 17                	jmp    80061d <getuint+0xb3>
  800606:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80060a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80060e:	48 89 d0             	mov    %rdx,%rax
  800611:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800615:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800619:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80061d:	48 8b 00             	mov    (%rax),%rax
  800620:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800624:	eb 4e                	jmp    800674 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800626:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80062a:	8b 00                	mov    (%rax),%eax
  80062c:	83 f8 30             	cmp    $0x30,%eax
  80062f:	73 24                	jae    800655 <getuint+0xeb>
  800631:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800635:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800639:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063d:	8b 00                	mov    (%rax),%eax
  80063f:	89 c0                	mov    %eax,%eax
  800641:	48 01 d0             	add    %rdx,%rax
  800644:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800648:	8b 12                	mov    (%rdx),%edx
  80064a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80064d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800651:	89 0a                	mov    %ecx,(%rdx)
  800653:	eb 17                	jmp    80066c <getuint+0x102>
  800655:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800659:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80065d:	48 89 d0             	mov    %rdx,%rax
  800660:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800664:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800668:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80066c:	8b 00                	mov    (%rax),%eax
  80066e:	89 c0                	mov    %eax,%eax
  800670:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800674:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800678:	c9                   	leaveq 
  800679:	c3                   	retq   

000000000080067a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80067a:	55                   	push   %rbp
  80067b:	48 89 e5             	mov    %rsp,%rbp
  80067e:	48 83 ec 1c          	sub    $0x1c,%rsp
  800682:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800686:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800689:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80068d:	7e 52                	jle    8006e1 <getint+0x67>
		x=va_arg(*ap, long long);
  80068f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800693:	8b 00                	mov    (%rax),%eax
  800695:	83 f8 30             	cmp    $0x30,%eax
  800698:	73 24                	jae    8006be <getint+0x44>
  80069a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a6:	8b 00                	mov    (%rax),%eax
  8006a8:	89 c0                	mov    %eax,%eax
  8006aa:	48 01 d0             	add    %rdx,%rax
  8006ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b1:	8b 12                	mov    (%rdx),%edx
  8006b3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ba:	89 0a                	mov    %ecx,(%rdx)
  8006bc:	eb 17                	jmp    8006d5 <getint+0x5b>
  8006be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006c6:	48 89 d0             	mov    %rdx,%rax
  8006c9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006d5:	48 8b 00             	mov    (%rax),%rax
  8006d8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006dc:	e9 a3 00 00 00       	jmpq   800784 <getint+0x10a>
	else if (lflag)
  8006e1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006e5:	74 4f                	je     800736 <getint+0xbc>
		x=va_arg(*ap, long);
  8006e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006eb:	8b 00                	mov    (%rax),%eax
  8006ed:	83 f8 30             	cmp    $0x30,%eax
  8006f0:	73 24                	jae    800716 <getint+0x9c>
  8006f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fe:	8b 00                	mov    (%rax),%eax
  800700:	89 c0                	mov    %eax,%eax
  800702:	48 01 d0             	add    %rdx,%rax
  800705:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800709:	8b 12                	mov    (%rdx),%edx
  80070b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80070e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800712:	89 0a                	mov    %ecx,(%rdx)
  800714:	eb 17                	jmp    80072d <getint+0xb3>
  800716:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80071a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80071e:	48 89 d0             	mov    %rdx,%rax
  800721:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800725:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800729:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80072d:	48 8b 00             	mov    (%rax),%rax
  800730:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800734:	eb 4e                	jmp    800784 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800736:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073a:	8b 00                	mov    (%rax),%eax
  80073c:	83 f8 30             	cmp    $0x30,%eax
  80073f:	73 24                	jae    800765 <getint+0xeb>
  800741:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800745:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800749:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074d:	8b 00                	mov    (%rax),%eax
  80074f:	89 c0                	mov    %eax,%eax
  800751:	48 01 d0             	add    %rdx,%rax
  800754:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800758:	8b 12                	mov    (%rdx),%edx
  80075a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80075d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800761:	89 0a                	mov    %ecx,(%rdx)
  800763:	eb 17                	jmp    80077c <getint+0x102>
  800765:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800769:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80076d:	48 89 d0             	mov    %rdx,%rax
  800770:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800774:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800778:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80077c:	8b 00                	mov    (%rax),%eax
  80077e:	48 98                	cltq   
  800780:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800784:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800788:	c9                   	leaveq 
  800789:	c3                   	retq   

000000000080078a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80078a:	55                   	push   %rbp
  80078b:	48 89 e5             	mov    %rsp,%rbp
  80078e:	41 54                	push   %r12
  800790:	53                   	push   %rbx
  800791:	48 83 ec 60          	sub    $0x60,%rsp
  800795:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800799:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80079d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007a1:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8007a5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8007a9:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8007ad:	48 8b 0a             	mov    (%rdx),%rcx
  8007b0:	48 89 08             	mov    %rcx,(%rax)
  8007b3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007b7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007bb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007bf:	48 89 50 10          	mov    %rdx,0x10(%rax)
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007c3:	eb 17                	jmp    8007dc <vprintfmt+0x52>
			if (ch == '\0')
  8007c5:	85 db                	test   %ebx,%ebx
  8007c7:	0f 84 cc 04 00 00    	je     800c99 <vprintfmt+0x50f>
                }
#endif

			  return;
			}
			putch(ch, putdat);
  8007cd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8007d1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007d5:	48 89 d6             	mov    %rdx,%rsi
  8007d8:	89 df                	mov    %ebx,%edi
  8007da:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007dc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007e0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8007e4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007e8:	0f b6 00             	movzbl (%rax),%eax
  8007eb:	0f b6 d8             	movzbl %al,%ebx
  8007ee:	83 fb 25             	cmp    $0x25,%ebx
  8007f1:	75 d2                	jne    8007c5 <vprintfmt+0x3b>
			  return;
			}
			putch(ch, putdat);
		}
		// Process a %-escape sequence
		padc = ' ';
  8007f3:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8007f7:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8007fe:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800805:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80080c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800813:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800817:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80081b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80081f:	0f b6 00             	movzbl (%rax),%eax
  800822:	0f b6 d8             	movzbl %al,%ebx
  800825:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800828:	83 f8 55             	cmp    $0x55,%eax
  80082b:	0f 87 34 04 00 00    	ja     800c65 <vprintfmt+0x4db>
  800831:	89 c0                	mov    %eax,%eax
  800833:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80083a:	00 
  80083b:	48 b8 b8 26 80 00 00 	movabs $0x8026b8,%rax
  800842:	00 00 00 
  800845:	48 01 d0             	add    %rdx,%rax
  800848:	48 8b 00             	mov    (%rax),%rax
  80084b:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  80084d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800851:	eb c0                	jmp    800813 <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800853:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800857:	eb ba                	jmp    800813 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800859:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800860:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800863:	89 d0                	mov    %edx,%eax
  800865:	c1 e0 02             	shl    $0x2,%eax
  800868:	01 d0                	add    %edx,%eax
  80086a:	01 c0                	add    %eax,%eax
  80086c:	01 d8                	add    %ebx,%eax
  80086e:	83 e8 30             	sub    $0x30,%eax
  800871:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800874:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800878:	0f b6 00             	movzbl (%rax),%eax
  80087b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80087e:	83 fb 2f             	cmp    $0x2f,%ebx
  800881:	7e 0c                	jle    80088f <vprintfmt+0x105>
  800883:	83 fb 39             	cmp    $0x39,%ebx
  800886:	7f 07                	jg     80088f <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800888:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80088d:	eb d1                	jmp    800860 <vprintfmt+0xd6>
			goto process_precision;
  80088f:	eb 58                	jmp    8008e9 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800891:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800894:	83 f8 30             	cmp    $0x30,%eax
  800897:	73 17                	jae    8008b0 <vprintfmt+0x126>
  800899:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80089d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008a0:	89 c0                	mov    %eax,%eax
  8008a2:	48 01 d0             	add    %rdx,%rax
  8008a5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008a8:	83 c2 08             	add    $0x8,%edx
  8008ab:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008ae:	eb 0f                	jmp    8008bf <vprintfmt+0x135>
  8008b0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008b4:	48 89 d0             	mov    %rdx,%rax
  8008b7:	48 83 c2 08          	add    $0x8,%rdx
  8008bb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008bf:	8b 00                	mov    (%rax),%eax
  8008c1:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8008c4:	eb 23                	jmp    8008e9 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8008c6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008ca:	79 0c                	jns    8008d8 <vprintfmt+0x14e>
				width = 0;
  8008cc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8008d3:	e9 3b ff ff ff       	jmpq   800813 <vprintfmt+0x89>
  8008d8:	e9 36 ff ff ff       	jmpq   800813 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8008dd:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8008e4:	e9 2a ff ff ff       	jmpq   800813 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8008e9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008ed:	79 12                	jns    800901 <vprintfmt+0x177>
				width = precision, precision = -1;
  8008ef:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008f2:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8008f5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8008fc:	e9 12 ff ff ff       	jmpq   800813 <vprintfmt+0x89>
  800901:	e9 0d ff ff ff       	jmpq   800813 <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800906:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80090a:	e9 04 ff ff ff       	jmpq   800813 <vprintfmt+0x89>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			putch(va_arg(aq, int), putdat);
  80090f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800912:	83 f8 30             	cmp    $0x30,%eax
  800915:	73 17                	jae    80092e <vprintfmt+0x1a4>
  800917:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80091b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80091e:	89 c0                	mov    %eax,%eax
  800920:	48 01 d0             	add    %rdx,%rax
  800923:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800926:	83 c2 08             	add    $0x8,%edx
  800929:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80092c:	eb 0f                	jmp    80093d <vprintfmt+0x1b3>
  80092e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800932:	48 89 d0             	mov    %rdx,%rax
  800935:	48 83 c2 08          	add    $0x8,%rdx
  800939:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80093d:	8b 10                	mov    (%rax),%edx
  80093f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800943:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800947:	48 89 ce             	mov    %rcx,%rsi
  80094a:	89 d7                	mov    %edx,%edi
  80094c:	ff d0                	callq  *%rax
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  80094e:	e9 40 03 00 00       	jmpq   800c93 <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800953:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800956:	83 f8 30             	cmp    $0x30,%eax
  800959:	73 17                	jae    800972 <vprintfmt+0x1e8>
  80095b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80095f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800962:	89 c0                	mov    %eax,%eax
  800964:	48 01 d0             	add    %rdx,%rax
  800967:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80096a:	83 c2 08             	add    $0x8,%edx
  80096d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800970:	eb 0f                	jmp    800981 <vprintfmt+0x1f7>
  800972:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800976:	48 89 d0             	mov    %rdx,%rax
  800979:	48 83 c2 08          	add    $0x8,%rdx
  80097d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800981:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800983:	85 db                	test   %ebx,%ebx
  800985:	79 02                	jns    800989 <vprintfmt+0x1ff>
				err = -err;
  800987:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800989:	83 fb 09             	cmp    $0x9,%ebx
  80098c:	7f 16                	jg     8009a4 <vprintfmt+0x21a>
  80098e:	48 b8 40 26 80 00 00 	movabs $0x802640,%rax
  800995:	00 00 00 
  800998:	48 63 d3             	movslq %ebx,%rdx
  80099b:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80099f:	4d 85 e4             	test   %r12,%r12
  8009a2:	75 2e                	jne    8009d2 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8009a4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8009a8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009ac:	89 d9                	mov    %ebx,%ecx
  8009ae:	48 ba a1 26 80 00 00 	movabs $0x8026a1,%rdx
  8009b5:	00 00 00 
  8009b8:	48 89 c7             	mov    %rax,%rdi
  8009bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c0:	49 b8 a2 0c 80 00 00 	movabs $0x800ca2,%r8
  8009c7:	00 00 00 
  8009ca:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009cd:	e9 c1 02 00 00       	jmpq   800c93 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009d2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8009d6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009da:	4c 89 e1             	mov    %r12,%rcx
  8009dd:	48 ba aa 26 80 00 00 	movabs $0x8026aa,%rdx
  8009e4:	00 00 00 
  8009e7:	48 89 c7             	mov    %rax,%rdi
  8009ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ef:	49 b8 a2 0c 80 00 00 	movabs $0x800ca2,%r8
  8009f6:	00 00 00 
  8009f9:	41 ff d0             	callq  *%r8
			break;
  8009fc:	e9 92 02 00 00       	jmpq   800c93 <vprintfmt+0x509>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
  800a01:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a04:	83 f8 30             	cmp    $0x30,%eax
  800a07:	73 17                	jae    800a20 <vprintfmt+0x296>
  800a09:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a0d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a10:	89 c0                	mov    %eax,%eax
  800a12:	48 01 d0             	add    %rdx,%rax
  800a15:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a18:	83 c2 08             	add    $0x8,%edx
  800a1b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a1e:	eb 0f                	jmp    800a2f <vprintfmt+0x2a5>
  800a20:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a24:	48 89 d0             	mov    %rdx,%rax
  800a27:	48 83 c2 08          	add    $0x8,%rdx
  800a2b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a2f:	4c 8b 20             	mov    (%rax),%r12
  800a32:	4d 85 e4             	test   %r12,%r12
  800a35:	75 0a                	jne    800a41 <vprintfmt+0x2b7>
				p = "(null)";
  800a37:	49 bc ad 26 80 00 00 	movabs $0x8026ad,%r12
  800a3e:	00 00 00 
			if (width > 0 && padc != '-')
  800a41:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a45:	7e 3f                	jle    800a86 <vprintfmt+0x2fc>
  800a47:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800a4b:	74 39                	je     800a86 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a4d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a50:	48 98                	cltq   
  800a52:	48 89 c6             	mov    %rax,%rsi
  800a55:	4c 89 e7             	mov    %r12,%rdi
  800a58:	48 b8 4e 0f 80 00 00 	movabs $0x800f4e,%rax
  800a5f:	00 00 00 
  800a62:	ff d0                	callq  *%rax
  800a64:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800a67:	eb 17                	jmp    800a80 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800a69:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800a6d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a71:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a75:	48 89 ce             	mov    %rcx,%rsi
  800a78:	89 d7                	mov    %edx,%edi
  800a7a:	ff d0                	callq  *%rax
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a7c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a80:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a84:	7f e3                	jg     800a69 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a86:	eb 37                	jmp    800abf <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800a88:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800a8c:	74 1e                	je     800aac <vprintfmt+0x322>
  800a8e:	83 fb 1f             	cmp    $0x1f,%ebx
  800a91:	7e 05                	jle    800a98 <vprintfmt+0x30e>
  800a93:	83 fb 7e             	cmp    $0x7e,%ebx
  800a96:	7e 14                	jle    800aac <vprintfmt+0x322>
					putch('?', putdat);
  800a98:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a9c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aa0:	48 89 d6             	mov    %rdx,%rsi
  800aa3:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800aa8:	ff d0                	callq  *%rax
  800aaa:	eb 0f                	jmp    800abb <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800aac:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ab0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ab4:	48 89 d6             	mov    %rdx,%rsi
  800ab7:	89 df                	mov    %ebx,%edi
  800ab9:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800abb:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800abf:	4c 89 e0             	mov    %r12,%rax
  800ac2:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800ac6:	0f b6 00             	movzbl (%rax),%eax
  800ac9:	0f be d8             	movsbl %al,%ebx
  800acc:	85 db                	test   %ebx,%ebx
  800ace:	74 10                	je     800ae0 <vprintfmt+0x356>
  800ad0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ad4:	78 b2                	js     800a88 <vprintfmt+0x2fe>
  800ad6:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800ada:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ade:	79 a8                	jns    800a88 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ae0:	eb 16                	jmp    800af8 <vprintfmt+0x36e>
				putch(' ', putdat);
  800ae2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ae6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aea:	48 89 d6             	mov    %rdx,%rsi
  800aed:	bf 20 00 00 00       	mov    $0x20,%edi
  800af2:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800af4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800af8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800afc:	7f e4                	jg     800ae2 <vprintfmt+0x358>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  800afe:	e9 90 01 00 00       	jmpq   800c93 <vprintfmt+0x509>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getint(&aq, 3);
  800b03:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b07:	be 03 00 00 00       	mov    $0x3,%esi
  800b0c:	48 89 c7             	mov    %rax,%rdi
  800b0f:	48 b8 7a 06 80 00 00 	movabs $0x80067a,%rax
  800b16:	00 00 00 
  800b19:	ff d0                	callq  *%rax
  800b1b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800b1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b23:	48 85 c0             	test   %rax,%rax
  800b26:	79 1d                	jns    800b45 <vprintfmt+0x3bb>
				putch('-', putdat);
  800b28:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b2c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b30:	48 89 d6             	mov    %rdx,%rsi
  800b33:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800b38:	ff d0                	callq  *%rax
				num = -(long long) num;
  800b3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b3e:	48 f7 d8             	neg    %rax
  800b41:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800b45:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b4c:	e9 d5 00 00 00       	jmpq   800c26 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			
			num = getuint(&aq, 3);
  800b51:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b55:	be 03 00 00 00       	mov    $0x3,%esi
  800b5a:	48 89 c7             	mov    %rax,%rdi
  800b5d:	48 b8 6a 05 80 00 00 	movabs $0x80056a,%rax
  800b64:	00 00 00 
  800b67:	ff d0                	callq  *%rax
  800b69:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800b6d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b74:	e9 ad 00 00 00       	jmpq   800c26 <vprintfmt+0x49c>
                  ch = *(unsigned char *) color;
                }
#endif

			// Replace this with your code.
		        num = getuint(&aq, 3);
  800b79:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b7d:	be 03 00 00 00       	mov    $0x3,%esi
  800b82:	48 89 c7             	mov    %rax,%rdi
  800b85:	48 b8 6a 05 80 00 00 	movabs $0x80056a,%rax
  800b8c:	00 00 00 
  800b8f:	ff d0                	callq  *%rax
  800b91:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800b95:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800b9c:	e9 85 00 00 00       	jmpq   800c26 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			putch('0', putdat);
  800ba1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ba5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba9:	48 89 d6             	mov    %rdx,%rsi
  800bac:	bf 30 00 00 00       	mov    $0x30,%edi
  800bb1:	ff d0                	callq  *%rax
			putch('x', putdat);
  800bb3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bb7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bbb:	48 89 d6             	mov    %rdx,%rsi
  800bbe:	bf 78 00 00 00       	mov    $0x78,%edi
  800bc3:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800bc5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc8:	83 f8 30             	cmp    $0x30,%eax
  800bcb:	73 17                	jae    800be4 <vprintfmt+0x45a>
  800bcd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bd1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bd4:	89 c0                	mov    %eax,%eax
  800bd6:	48 01 d0             	add    %rdx,%rax
  800bd9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bdc:	83 c2 08             	add    $0x8,%edx
  800bdf:	89 55 b8             	mov    %edx,-0x48(%rbp)
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800be2:	eb 0f                	jmp    800bf3 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800be4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800be8:	48 89 d0             	mov    %rdx,%rax
  800beb:	48 83 c2 08          	add    $0x8,%rdx
  800bef:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bf3:	48 8b 00             	mov    (%rax),%rax
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bf6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800bfa:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800c01:	eb 23                	jmp    800c26 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getuint(&aq, 3);
  800c03:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c07:	be 03 00 00 00       	mov    $0x3,%esi
  800c0c:	48 89 c7             	mov    %rax,%rdi
  800c0f:	48 b8 6a 05 80 00 00 	movabs $0x80056a,%rax
  800c16:	00 00 00 
  800c19:	ff d0                	callq  *%rax
  800c1b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800c1f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:

			printnum(putch, putdat, num, base, width, padc);
  800c26:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800c2b:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800c2e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800c31:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c35:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c39:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c3d:	45 89 c1             	mov    %r8d,%r9d
  800c40:	41 89 f8             	mov    %edi,%r8d
  800c43:	48 89 c7             	mov    %rax,%rdi
  800c46:	48 b8 af 04 80 00 00 	movabs $0x8004af,%rax
  800c4d:	00 00 00 
  800c50:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			break;
  800c52:	eb 3f                	jmp    800c93 <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c54:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c58:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c5c:	48 89 d6             	mov    %rdx,%rsi
  800c5f:	89 df                	mov    %ebx,%edi
  800c61:	ff d0                	callq  *%rax
			break;
  800c63:	eb 2e                	jmp    800c93 <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c65:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c69:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c6d:	48 89 d6             	mov    %rdx,%rsi
  800c70:	bf 25 00 00 00       	mov    $0x25,%edi
  800c75:	ff d0                	callq  *%rax

			for (fmt--; fmt[-1] != '%'; fmt--)
  800c77:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c7c:	eb 05                	jmp    800c83 <vprintfmt+0x4f9>
  800c7e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c83:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c87:	48 83 e8 01          	sub    $0x1,%rax
  800c8b:	0f b6 00             	movzbl (%rax),%eax
  800c8e:	3c 25                	cmp    $0x25,%al
  800c90:	75 ec                	jne    800c7e <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800c92:	90                   	nop
		}
	}
  800c93:	90                   	nop
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c94:	e9 43 fb ff ff       	jmpq   8007dc <vprintfmt+0x52>
			break;
		}
	}
    
va_end(aq);
}
  800c99:	48 83 c4 60          	add    $0x60,%rsp
  800c9d:	5b                   	pop    %rbx
  800c9e:	41 5c                	pop    %r12
  800ca0:	5d                   	pop    %rbp
  800ca1:	c3                   	retq   

0000000000800ca2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ca2:	55                   	push   %rbp
  800ca3:	48 89 e5             	mov    %rsp,%rbp
  800ca6:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800cad:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800cb4:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800cbb:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cc2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800cc9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800cd0:	84 c0                	test   %al,%al
  800cd2:	74 20                	je     800cf4 <printfmt+0x52>
  800cd4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800cd8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800cdc:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ce0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ce4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ce8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800cec:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800cf0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800cf4:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800cfb:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800d02:	00 00 00 
  800d05:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800d0c:	00 00 00 
  800d0f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d13:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800d1a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d21:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800d28:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800d2f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800d36:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800d3d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800d44:	48 89 c7             	mov    %rax,%rdi
  800d47:	48 b8 8a 07 80 00 00 	movabs $0x80078a,%rax
  800d4e:	00 00 00 
  800d51:	ff d0                	callq  *%rax
	va_end(ap);
}
  800d53:	c9                   	leaveq 
  800d54:	c3                   	retq   

0000000000800d55 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d55:	55                   	push   %rbp
  800d56:	48 89 e5             	mov    %rsp,%rbp
  800d59:	48 83 ec 10          	sub    $0x10,%rsp
  800d5d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d60:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800d64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d68:	8b 40 10             	mov    0x10(%rax),%eax
  800d6b:	8d 50 01             	lea    0x1(%rax),%edx
  800d6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d72:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800d75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d79:	48 8b 10             	mov    (%rax),%rdx
  800d7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d80:	48 8b 40 08          	mov    0x8(%rax),%rax
  800d84:	48 39 c2             	cmp    %rax,%rdx
  800d87:	73 17                	jae    800da0 <sprintputch+0x4b>
		*b->buf++ = ch;
  800d89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d8d:	48 8b 00             	mov    (%rax),%rax
  800d90:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800d94:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d98:	48 89 0a             	mov    %rcx,(%rdx)
  800d9b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d9e:	88 10                	mov    %dl,(%rax)
}
  800da0:	c9                   	leaveq 
  800da1:	c3                   	retq   

0000000000800da2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800da2:	55                   	push   %rbp
  800da3:	48 89 e5             	mov    %rsp,%rbp
  800da6:	48 83 ec 50          	sub    $0x50,%rsp
  800daa:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800dae:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800db1:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800db5:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800db9:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800dbd:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800dc1:	48 8b 0a             	mov    (%rdx),%rcx
  800dc4:	48 89 08             	mov    %rcx,(%rax)
  800dc7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800dcb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800dcf:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dd3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dd7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ddb:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ddf:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800de2:	48 98                	cltq   
  800de4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800de8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800dec:	48 01 d0             	add    %rdx,%rax
  800def:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800df3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800dfa:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800dff:	74 06                	je     800e07 <vsnprintf+0x65>
  800e01:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800e05:	7f 07                	jg     800e0e <vsnprintf+0x6c>
		return -E_INVAL;
  800e07:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e0c:	eb 2f                	jmp    800e3d <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800e0e:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800e12:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800e16:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e1a:	48 89 c6             	mov    %rax,%rsi
  800e1d:	48 bf 55 0d 80 00 00 	movabs $0x800d55,%rdi
  800e24:	00 00 00 
  800e27:	48 b8 8a 07 80 00 00 	movabs $0x80078a,%rax
  800e2e:	00 00 00 
  800e31:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800e33:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e37:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800e3a:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800e3d:	c9                   	leaveq 
  800e3e:	c3                   	retq   

0000000000800e3f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e3f:	55                   	push   %rbp
  800e40:	48 89 e5             	mov    %rsp,%rbp
  800e43:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800e4a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800e51:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800e57:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e5e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e65:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e6c:	84 c0                	test   %al,%al
  800e6e:	74 20                	je     800e90 <snprintf+0x51>
  800e70:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e74:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e78:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e7c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e80:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e84:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e88:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e8c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e90:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800e97:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800e9e:	00 00 00 
  800ea1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800ea8:	00 00 00 
  800eab:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800eaf:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800eb6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ebd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800ec4:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800ecb:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800ed2:	48 8b 0a             	mov    (%rdx),%rcx
  800ed5:	48 89 08             	mov    %rcx,(%rax)
  800ed8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800edc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ee0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ee4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800ee8:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800eef:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800ef6:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800efc:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800f03:	48 89 c7             	mov    %rax,%rdi
  800f06:	48 b8 a2 0d 80 00 00 	movabs $0x800da2,%rax
  800f0d:	00 00 00 
  800f10:	ff d0                	callq  *%rax
  800f12:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800f18:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800f1e:	c9                   	leaveq 
  800f1f:	c3                   	retq   

0000000000800f20 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f20:	55                   	push   %rbp
  800f21:	48 89 e5             	mov    %rsp,%rbp
  800f24:	48 83 ec 18          	sub    $0x18,%rsp
  800f28:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800f2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f33:	eb 09                	jmp    800f3e <strlen+0x1e>
		n++;
  800f35:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f39:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f42:	0f b6 00             	movzbl (%rax),%eax
  800f45:	84 c0                	test   %al,%al
  800f47:	75 ec                	jne    800f35 <strlen+0x15>
		n++;
	return n;
  800f49:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f4c:	c9                   	leaveq 
  800f4d:	c3                   	retq   

0000000000800f4e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800f4e:	55                   	push   %rbp
  800f4f:	48 89 e5             	mov    %rsp,%rbp
  800f52:	48 83 ec 20          	sub    $0x20,%rsp
  800f56:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f5a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f65:	eb 0e                	jmp    800f75 <strnlen+0x27>
		n++;
  800f67:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f6b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f70:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800f75:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800f7a:	74 0b                	je     800f87 <strnlen+0x39>
  800f7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f80:	0f b6 00             	movzbl (%rax),%eax
  800f83:	84 c0                	test   %al,%al
  800f85:	75 e0                	jne    800f67 <strnlen+0x19>
		n++;
	return n;
  800f87:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f8a:	c9                   	leaveq 
  800f8b:	c3                   	retq   

0000000000800f8c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f8c:	55                   	push   %rbp
  800f8d:	48 89 e5             	mov    %rsp,%rbp
  800f90:	48 83 ec 20          	sub    $0x20,%rsp
  800f94:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f98:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800f9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800fa4:	90                   	nop
  800fa5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fad:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fb1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fb5:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800fb9:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800fbd:	0f b6 12             	movzbl (%rdx),%edx
  800fc0:	88 10                	mov    %dl,(%rax)
  800fc2:	0f b6 00             	movzbl (%rax),%eax
  800fc5:	84 c0                	test   %al,%al
  800fc7:	75 dc                	jne    800fa5 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800fc9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800fcd:	c9                   	leaveq 
  800fce:	c3                   	retq   

0000000000800fcf <strcat>:

char *
strcat(char *dst, const char *src)
{
  800fcf:	55                   	push   %rbp
  800fd0:	48 89 e5             	mov    %rsp,%rbp
  800fd3:	48 83 ec 20          	sub    $0x20,%rsp
  800fd7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fdb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800fdf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fe3:	48 89 c7             	mov    %rax,%rdi
  800fe6:	48 b8 20 0f 80 00 00 	movabs $0x800f20,%rax
  800fed:	00 00 00 
  800ff0:	ff d0                	callq  *%rax
  800ff2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800ff5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ff8:	48 63 d0             	movslq %eax,%rdx
  800ffb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fff:	48 01 c2             	add    %rax,%rdx
  801002:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801006:	48 89 c6             	mov    %rax,%rsi
  801009:	48 89 d7             	mov    %rdx,%rdi
  80100c:	48 b8 8c 0f 80 00 00 	movabs $0x800f8c,%rax
  801013:	00 00 00 
  801016:	ff d0                	callq  *%rax
	return dst;
  801018:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80101c:	c9                   	leaveq 
  80101d:	c3                   	retq   

000000000080101e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80101e:	55                   	push   %rbp
  80101f:	48 89 e5             	mov    %rsp,%rbp
  801022:	48 83 ec 28          	sub    $0x28,%rsp
  801026:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80102a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80102e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801032:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801036:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80103a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801041:	00 
  801042:	eb 2a                	jmp    80106e <strncpy+0x50>
		*dst++ = *src;
  801044:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801048:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80104c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801050:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801054:	0f b6 12             	movzbl (%rdx),%edx
  801057:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801059:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80105d:	0f b6 00             	movzbl (%rax),%eax
  801060:	84 c0                	test   %al,%al
  801062:	74 05                	je     801069 <strncpy+0x4b>
			src++;
  801064:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801069:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80106e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801072:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801076:	72 cc                	jb     801044 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801078:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80107c:	c9                   	leaveq 
  80107d:	c3                   	retq   

000000000080107e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80107e:	55                   	push   %rbp
  80107f:	48 89 e5             	mov    %rsp,%rbp
  801082:	48 83 ec 28          	sub    $0x28,%rsp
  801086:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80108a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80108e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801092:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801096:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80109a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80109f:	74 3d                	je     8010de <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8010a1:	eb 1d                	jmp    8010c0 <strlcpy+0x42>
			*dst++ = *src++;
  8010a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010ab:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010af:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010b3:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010b7:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010bb:	0f b6 12             	movzbl (%rdx),%edx
  8010be:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010c0:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8010c5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8010ca:	74 0b                	je     8010d7 <strlcpy+0x59>
  8010cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010d0:	0f b6 00             	movzbl (%rax),%eax
  8010d3:	84 c0                	test   %al,%al
  8010d5:	75 cc                	jne    8010a3 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8010d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010db:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8010de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e6:	48 29 c2             	sub    %rax,%rdx
  8010e9:	48 89 d0             	mov    %rdx,%rax
}
  8010ec:	c9                   	leaveq 
  8010ed:	c3                   	retq   

00000000008010ee <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010ee:	55                   	push   %rbp
  8010ef:	48 89 e5             	mov    %rsp,%rbp
  8010f2:	48 83 ec 10          	sub    $0x10,%rsp
  8010f6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010fa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8010fe:	eb 0a                	jmp    80110a <strcmp+0x1c>
		p++, q++;
  801100:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801105:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80110a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80110e:	0f b6 00             	movzbl (%rax),%eax
  801111:	84 c0                	test   %al,%al
  801113:	74 12                	je     801127 <strcmp+0x39>
  801115:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801119:	0f b6 10             	movzbl (%rax),%edx
  80111c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801120:	0f b6 00             	movzbl (%rax),%eax
  801123:	38 c2                	cmp    %al,%dl
  801125:	74 d9                	je     801100 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801127:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80112b:	0f b6 00             	movzbl (%rax),%eax
  80112e:	0f b6 d0             	movzbl %al,%edx
  801131:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801135:	0f b6 00             	movzbl (%rax),%eax
  801138:	0f b6 c0             	movzbl %al,%eax
  80113b:	29 c2                	sub    %eax,%edx
  80113d:	89 d0                	mov    %edx,%eax
}
  80113f:	c9                   	leaveq 
  801140:	c3                   	retq   

0000000000801141 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801141:	55                   	push   %rbp
  801142:	48 89 e5             	mov    %rsp,%rbp
  801145:	48 83 ec 18          	sub    $0x18,%rsp
  801149:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80114d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801151:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801155:	eb 0f                	jmp    801166 <strncmp+0x25>
		n--, p++, q++;
  801157:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80115c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801161:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801166:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80116b:	74 1d                	je     80118a <strncmp+0x49>
  80116d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801171:	0f b6 00             	movzbl (%rax),%eax
  801174:	84 c0                	test   %al,%al
  801176:	74 12                	je     80118a <strncmp+0x49>
  801178:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80117c:	0f b6 10             	movzbl (%rax),%edx
  80117f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801183:	0f b6 00             	movzbl (%rax),%eax
  801186:	38 c2                	cmp    %al,%dl
  801188:	74 cd                	je     801157 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80118a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80118f:	75 07                	jne    801198 <strncmp+0x57>
		return 0;
  801191:	b8 00 00 00 00       	mov    $0x0,%eax
  801196:	eb 18                	jmp    8011b0 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801198:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80119c:	0f b6 00             	movzbl (%rax),%eax
  80119f:	0f b6 d0             	movzbl %al,%edx
  8011a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011a6:	0f b6 00             	movzbl (%rax),%eax
  8011a9:	0f b6 c0             	movzbl %al,%eax
  8011ac:	29 c2                	sub    %eax,%edx
  8011ae:	89 d0                	mov    %edx,%eax
}
  8011b0:	c9                   	leaveq 
  8011b1:	c3                   	retq   

00000000008011b2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011b2:	55                   	push   %rbp
  8011b3:	48 89 e5             	mov    %rsp,%rbp
  8011b6:	48 83 ec 0c          	sub    $0xc,%rsp
  8011ba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011be:	89 f0                	mov    %esi,%eax
  8011c0:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011c3:	eb 17                	jmp    8011dc <strchr+0x2a>
		if (*s == c)
  8011c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c9:	0f b6 00             	movzbl (%rax),%eax
  8011cc:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8011cf:	75 06                	jne    8011d7 <strchr+0x25>
			return (char *) s;
  8011d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d5:	eb 15                	jmp    8011ec <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011d7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e0:	0f b6 00             	movzbl (%rax),%eax
  8011e3:	84 c0                	test   %al,%al
  8011e5:	75 de                	jne    8011c5 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8011e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011ec:	c9                   	leaveq 
  8011ed:	c3                   	retq   

00000000008011ee <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011ee:	55                   	push   %rbp
  8011ef:	48 89 e5             	mov    %rsp,%rbp
  8011f2:	48 83 ec 0c          	sub    $0xc,%rsp
  8011f6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011fa:	89 f0                	mov    %esi,%eax
  8011fc:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011ff:	eb 13                	jmp    801214 <strfind+0x26>
		if (*s == c)
  801201:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801205:	0f b6 00             	movzbl (%rax),%eax
  801208:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80120b:	75 02                	jne    80120f <strfind+0x21>
			break;
  80120d:	eb 10                	jmp    80121f <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80120f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801214:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801218:	0f b6 00             	movzbl (%rax),%eax
  80121b:	84 c0                	test   %al,%al
  80121d:	75 e2                	jne    801201 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80121f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801223:	c9                   	leaveq 
  801224:	c3                   	retq   

0000000000801225 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801225:	55                   	push   %rbp
  801226:	48 89 e5             	mov    %rsp,%rbp
  801229:	48 83 ec 18          	sub    $0x18,%rsp
  80122d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801231:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801234:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801238:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80123d:	75 06                	jne    801245 <memset+0x20>
		return v;
  80123f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801243:	eb 69                	jmp    8012ae <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801245:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801249:	83 e0 03             	and    $0x3,%eax
  80124c:	48 85 c0             	test   %rax,%rax
  80124f:	75 48                	jne    801299 <memset+0x74>
  801251:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801255:	83 e0 03             	and    $0x3,%eax
  801258:	48 85 c0             	test   %rax,%rax
  80125b:	75 3c                	jne    801299 <memset+0x74>
		c &= 0xFF;
  80125d:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801264:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801267:	c1 e0 18             	shl    $0x18,%eax
  80126a:	89 c2                	mov    %eax,%edx
  80126c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80126f:	c1 e0 10             	shl    $0x10,%eax
  801272:	09 c2                	or     %eax,%edx
  801274:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801277:	c1 e0 08             	shl    $0x8,%eax
  80127a:	09 d0                	or     %edx,%eax
  80127c:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80127f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801283:	48 c1 e8 02          	shr    $0x2,%rax
  801287:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80128a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80128e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801291:	48 89 d7             	mov    %rdx,%rdi
  801294:	fc                   	cld    
  801295:	f3 ab                	rep stos %eax,%es:(%rdi)
  801297:	eb 11                	jmp    8012aa <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801299:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80129d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012a0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8012a4:	48 89 d7             	mov    %rdx,%rdi
  8012a7:	fc                   	cld    
  8012a8:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8012aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012ae:	c9                   	leaveq 
  8012af:	c3                   	retq   

00000000008012b0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8012b0:	55                   	push   %rbp
  8012b1:	48 89 e5             	mov    %rsp,%rbp
  8012b4:	48 83 ec 28          	sub    $0x28,%rsp
  8012b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012bc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012c0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8012c4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012c8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8012cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8012d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d8:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012dc:	0f 83 88 00 00 00    	jae    80136a <memmove+0xba>
  8012e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012e6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012ea:	48 01 d0             	add    %rdx,%rax
  8012ed:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012f1:	76 77                	jbe    80136a <memmove+0xba>
		s += n;
  8012f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012f7:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8012fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012ff:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801303:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801307:	83 e0 03             	and    $0x3,%eax
  80130a:	48 85 c0             	test   %rax,%rax
  80130d:	75 3b                	jne    80134a <memmove+0x9a>
  80130f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801313:	83 e0 03             	and    $0x3,%eax
  801316:	48 85 c0             	test   %rax,%rax
  801319:	75 2f                	jne    80134a <memmove+0x9a>
  80131b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80131f:	83 e0 03             	and    $0x3,%eax
  801322:	48 85 c0             	test   %rax,%rax
  801325:	75 23                	jne    80134a <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801327:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80132b:	48 83 e8 04          	sub    $0x4,%rax
  80132f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801333:	48 83 ea 04          	sub    $0x4,%rdx
  801337:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80133b:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80133f:	48 89 c7             	mov    %rax,%rdi
  801342:	48 89 d6             	mov    %rdx,%rsi
  801345:	fd                   	std    
  801346:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801348:	eb 1d                	jmp    801367 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80134a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80134e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801352:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801356:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80135a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80135e:	48 89 d7             	mov    %rdx,%rdi
  801361:	48 89 c1             	mov    %rax,%rcx
  801364:	fd                   	std    
  801365:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801367:	fc                   	cld    
  801368:	eb 57                	jmp    8013c1 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80136a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136e:	83 e0 03             	and    $0x3,%eax
  801371:	48 85 c0             	test   %rax,%rax
  801374:	75 36                	jne    8013ac <memmove+0xfc>
  801376:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80137a:	83 e0 03             	and    $0x3,%eax
  80137d:	48 85 c0             	test   %rax,%rax
  801380:	75 2a                	jne    8013ac <memmove+0xfc>
  801382:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801386:	83 e0 03             	and    $0x3,%eax
  801389:	48 85 c0             	test   %rax,%rax
  80138c:	75 1e                	jne    8013ac <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80138e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801392:	48 c1 e8 02          	shr    $0x2,%rax
  801396:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801399:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80139d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013a1:	48 89 c7             	mov    %rax,%rdi
  8013a4:	48 89 d6             	mov    %rdx,%rsi
  8013a7:	fc                   	cld    
  8013a8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013aa:	eb 15                	jmp    8013c1 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8013ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013b0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013b4:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013b8:	48 89 c7             	mov    %rax,%rdi
  8013bb:	48 89 d6             	mov    %rdx,%rsi
  8013be:	fc                   	cld    
  8013bf:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8013c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013c5:	c9                   	leaveq 
  8013c6:	c3                   	retq   

00000000008013c7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8013c7:	55                   	push   %rbp
  8013c8:	48 89 e5             	mov    %rsp,%rbp
  8013cb:	48 83 ec 18          	sub    $0x18,%rsp
  8013cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013d3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013d7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8013db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013df:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8013e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e7:	48 89 ce             	mov    %rcx,%rsi
  8013ea:	48 89 c7             	mov    %rax,%rdi
  8013ed:	48 b8 b0 12 80 00 00 	movabs $0x8012b0,%rax
  8013f4:	00 00 00 
  8013f7:	ff d0                	callq  *%rax
}
  8013f9:	c9                   	leaveq 
  8013fa:	c3                   	retq   

00000000008013fb <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8013fb:	55                   	push   %rbp
  8013fc:	48 89 e5             	mov    %rsp,%rbp
  8013ff:	48 83 ec 28          	sub    $0x28,%rsp
  801403:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801407:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80140b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80140f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801413:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801417:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80141b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80141f:	eb 36                	jmp    801457 <memcmp+0x5c>
		if (*s1 != *s2)
  801421:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801425:	0f b6 10             	movzbl (%rax),%edx
  801428:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80142c:	0f b6 00             	movzbl (%rax),%eax
  80142f:	38 c2                	cmp    %al,%dl
  801431:	74 1a                	je     80144d <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801433:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801437:	0f b6 00             	movzbl (%rax),%eax
  80143a:	0f b6 d0             	movzbl %al,%edx
  80143d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801441:	0f b6 00             	movzbl (%rax),%eax
  801444:	0f b6 c0             	movzbl %al,%eax
  801447:	29 c2                	sub    %eax,%edx
  801449:	89 d0                	mov    %edx,%eax
  80144b:	eb 20                	jmp    80146d <memcmp+0x72>
		s1++, s2++;
  80144d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801452:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801457:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80145f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801463:	48 85 c0             	test   %rax,%rax
  801466:	75 b9                	jne    801421 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801468:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80146d:	c9                   	leaveq 
  80146e:	c3                   	retq   

000000000080146f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80146f:	55                   	push   %rbp
  801470:	48 89 e5             	mov    %rsp,%rbp
  801473:	48 83 ec 28          	sub    $0x28,%rsp
  801477:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80147b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80147e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801482:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801486:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80148a:	48 01 d0             	add    %rdx,%rax
  80148d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801491:	eb 15                	jmp    8014a8 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801493:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801497:	0f b6 10             	movzbl (%rax),%edx
  80149a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80149d:	38 c2                	cmp    %al,%dl
  80149f:	75 02                	jne    8014a3 <memfind+0x34>
			break;
  8014a1:	eb 0f                	jmp    8014b2 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8014a3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8014a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ac:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8014b0:	72 e1                	jb     801493 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8014b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014b6:	c9                   	leaveq 
  8014b7:	c3                   	retq   

00000000008014b8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014b8:	55                   	push   %rbp
  8014b9:	48 89 e5             	mov    %rsp,%rbp
  8014bc:	48 83 ec 34          	sub    $0x34,%rsp
  8014c0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014c4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8014c8:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8014cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8014d2:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8014d9:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014da:	eb 05                	jmp    8014e1 <strtol+0x29>
		s++;
  8014dc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e5:	0f b6 00             	movzbl (%rax),%eax
  8014e8:	3c 20                	cmp    $0x20,%al
  8014ea:	74 f0                	je     8014dc <strtol+0x24>
  8014ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f0:	0f b6 00             	movzbl (%rax),%eax
  8014f3:	3c 09                	cmp    $0x9,%al
  8014f5:	74 e5                	je     8014dc <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fb:	0f b6 00             	movzbl (%rax),%eax
  8014fe:	3c 2b                	cmp    $0x2b,%al
  801500:	75 07                	jne    801509 <strtol+0x51>
		s++;
  801502:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801507:	eb 17                	jmp    801520 <strtol+0x68>
	else if (*s == '-')
  801509:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150d:	0f b6 00             	movzbl (%rax),%eax
  801510:	3c 2d                	cmp    $0x2d,%al
  801512:	75 0c                	jne    801520 <strtol+0x68>
		s++, neg = 1;
  801514:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801519:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801520:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801524:	74 06                	je     80152c <strtol+0x74>
  801526:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80152a:	75 28                	jne    801554 <strtol+0x9c>
  80152c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801530:	0f b6 00             	movzbl (%rax),%eax
  801533:	3c 30                	cmp    $0x30,%al
  801535:	75 1d                	jne    801554 <strtol+0x9c>
  801537:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153b:	48 83 c0 01          	add    $0x1,%rax
  80153f:	0f b6 00             	movzbl (%rax),%eax
  801542:	3c 78                	cmp    $0x78,%al
  801544:	75 0e                	jne    801554 <strtol+0x9c>
		s += 2, base = 16;
  801546:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80154b:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801552:	eb 2c                	jmp    801580 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801554:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801558:	75 19                	jne    801573 <strtol+0xbb>
  80155a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80155e:	0f b6 00             	movzbl (%rax),%eax
  801561:	3c 30                	cmp    $0x30,%al
  801563:	75 0e                	jne    801573 <strtol+0xbb>
		s++, base = 8;
  801565:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80156a:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801571:	eb 0d                	jmp    801580 <strtol+0xc8>
	else if (base == 0)
  801573:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801577:	75 07                	jne    801580 <strtol+0xc8>
		base = 10;
  801579:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801580:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801584:	0f b6 00             	movzbl (%rax),%eax
  801587:	3c 2f                	cmp    $0x2f,%al
  801589:	7e 1d                	jle    8015a8 <strtol+0xf0>
  80158b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158f:	0f b6 00             	movzbl (%rax),%eax
  801592:	3c 39                	cmp    $0x39,%al
  801594:	7f 12                	jg     8015a8 <strtol+0xf0>
			dig = *s - '0';
  801596:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159a:	0f b6 00             	movzbl (%rax),%eax
  80159d:	0f be c0             	movsbl %al,%eax
  8015a0:	83 e8 30             	sub    $0x30,%eax
  8015a3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015a6:	eb 4e                	jmp    8015f6 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8015a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ac:	0f b6 00             	movzbl (%rax),%eax
  8015af:	3c 60                	cmp    $0x60,%al
  8015b1:	7e 1d                	jle    8015d0 <strtol+0x118>
  8015b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b7:	0f b6 00             	movzbl (%rax),%eax
  8015ba:	3c 7a                	cmp    $0x7a,%al
  8015bc:	7f 12                	jg     8015d0 <strtol+0x118>
			dig = *s - 'a' + 10;
  8015be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c2:	0f b6 00             	movzbl (%rax),%eax
  8015c5:	0f be c0             	movsbl %al,%eax
  8015c8:	83 e8 57             	sub    $0x57,%eax
  8015cb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015ce:	eb 26                	jmp    8015f6 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8015d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d4:	0f b6 00             	movzbl (%rax),%eax
  8015d7:	3c 40                	cmp    $0x40,%al
  8015d9:	7e 48                	jle    801623 <strtol+0x16b>
  8015db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015df:	0f b6 00             	movzbl (%rax),%eax
  8015e2:	3c 5a                	cmp    $0x5a,%al
  8015e4:	7f 3d                	jg     801623 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8015e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ea:	0f b6 00             	movzbl (%rax),%eax
  8015ed:	0f be c0             	movsbl %al,%eax
  8015f0:	83 e8 37             	sub    $0x37,%eax
  8015f3:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8015f6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015f9:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8015fc:	7c 02                	jl     801600 <strtol+0x148>
			break;
  8015fe:	eb 23                	jmp    801623 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801600:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801605:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801608:	48 98                	cltq   
  80160a:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80160f:	48 89 c2             	mov    %rax,%rdx
  801612:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801615:	48 98                	cltq   
  801617:	48 01 d0             	add    %rdx,%rax
  80161a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80161e:	e9 5d ff ff ff       	jmpq   801580 <strtol+0xc8>

	if (endptr)
  801623:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801628:	74 0b                	je     801635 <strtol+0x17d>
		*endptr = (char *) s;
  80162a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80162e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801632:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801635:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801639:	74 09                	je     801644 <strtol+0x18c>
  80163b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80163f:	48 f7 d8             	neg    %rax
  801642:	eb 04                	jmp    801648 <strtol+0x190>
  801644:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801648:	c9                   	leaveq 
  801649:	c3                   	retq   

000000000080164a <strstr>:

char * strstr(const char *in, const char *str)
{
  80164a:	55                   	push   %rbp
  80164b:	48 89 e5             	mov    %rsp,%rbp
  80164e:	48 83 ec 30          	sub    $0x30,%rsp
  801652:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801656:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  80165a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80165e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801662:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801666:	0f b6 00             	movzbl (%rax),%eax
  801669:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  80166c:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801670:	75 06                	jne    801678 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  801672:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801676:	eb 6b                	jmp    8016e3 <strstr+0x99>

    len = strlen(str);
  801678:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80167c:	48 89 c7             	mov    %rax,%rdi
  80167f:	48 b8 20 0f 80 00 00 	movabs $0x800f20,%rax
  801686:	00 00 00 
  801689:	ff d0                	callq  *%rax
  80168b:	48 98                	cltq   
  80168d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801691:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801695:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801699:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80169d:	0f b6 00             	movzbl (%rax),%eax
  8016a0:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  8016a3:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8016a7:	75 07                	jne    8016b0 <strstr+0x66>
                return (char *) 0;
  8016a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ae:	eb 33                	jmp    8016e3 <strstr+0x99>
        } while (sc != c);
  8016b0:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8016b4:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8016b7:	75 d8                	jne    801691 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  8016b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016bd:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8016c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c5:	48 89 ce             	mov    %rcx,%rsi
  8016c8:	48 89 c7             	mov    %rax,%rdi
  8016cb:	48 b8 41 11 80 00 00 	movabs $0x801141,%rax
  8016d2:	00 00 00 
  8016d5:	ff d0                	callq  *%rax
  8016d7:	85 c0                	test   %eax,%eax
  8016d9:	75 b6                	jne    801691 <strstr+0x47>

    return (char *) (in - 1);
  8016db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016df:	48 83 e8 01          	sub    $0x1,%rax
}
  8016e3:	c9                   	leaveq 
  8016e4:	c3                   	retq   

00000000008016e5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8016e5:	55                   	push   %rbp
  8016e6:	48 89 e5             	mov    %rsp,%rbp
  8016e9:	53                   	push   %rbx
  8016ea:	48 83 ec 48          	sub    $0x48,%rsp
  8016ee:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8016f1:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8016f4:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016f8:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8016fc:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801700:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801704:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801707:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80170b:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80170f:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801713:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801717:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80171b:	4c 89 c3             	mov    %r8,%rbx
  80171e:	cd 30                	int    $0x30
  801720:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801724:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801728:	74 3e                	je     801768 <syscall+0x83>
  80172a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80172f:	7e 37                	jle    801768 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801731:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801735:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801738:	49 89 d0             	mov    %rdx,%r8
  80173b:	89 c1                	mov    %eax,%ecx
  80173d:	48 ba 68 29 80 00 00 	movabs $0x802968,%rdx
  801744:	00 00 00 
  801747:	be 23 00 00 00       	mov    $0x23,%esi
  80174c:	48 bf 85 29 80 00 00 	movabs $0x802985,%rdi
  801753:	00 00 00 
  801756:	b8 00 00 00 00       	mov    $0x0,%eax
  80175b:	49 b9 9f 22 80 00 00 	movabs $0x80229f,%r9
  801762:	00 00 00 
  801765:	41 ff d1             	callq  *%r9

	return ret;
  801768:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80176c:	48 83 c4 48          	add    $0x48,%rsp
  801770:	5b                   	pop    %rbx
  801771:	5d                   	pop    %rbp
  801772:	c3                   	retq   

0000000000801773 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801773:	55                   	push   %rbp
  801774:	48 89 e5             	mov    %rsp,%rbp
  801777:	48 83 ec 20          	sub    $0x20,%rsp
  80177b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80177f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801783:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801787:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80178b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801792:	00 
  801793:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801799:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80179f:	48 89 d1             	mov    %rdx,%rcx
  8017a2:	48 89 c2             	mov    %rax,%rdx
  8017a5:	be 00 00 00 00       	mov    $0x0,%esi
  8017aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8017af:	48 b8 e5 16 80 00 00 	movabs $0x8016e5,%rax
  8017b6:	00 00 00 
  8017b9:	ff d0                	callq  *%rax
}
  8017bb:	c9                   	leaveq 
  8017bc:	c3                   	retq   

00000000008017bd <sys_cgetc>:

int
sys_cgetc(void)
{
  8017bd:	55                   	push   %rbp
  8017be:	48 89 e5             	mov    %rsp,%rbp
  8017c1:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8017c5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017cc:	00 
  8017cd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017d3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017d9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017de:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e3:	be 00 00 00 00       	mov    $0x0,%esi
  8017e8:	bf 01 00 00 00       	mov    $0x1,%edi
  8017ed:	48 b8 e5 16 80 00 00 	movabs $0x8016e5,%rax
  8017f4:	00 00 00 
  8017f7:	ff d0                	callq  *%rax
}
  8017f9:	c9                   	leaveq 
  8017fa:	c3                   	retq   

00000000008017fb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8017fb:	55                   	push   %rbp
  8017fc:	48 89 e5             	mov    %rsp,%rbp
  8017ff:	48 83 ec 10          	sub    $0x10,%rsp
  801803:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801806:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801809:	48 98                	cltq   
  80180b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801812:	00 
  801813:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801819:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80181f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801824:	48 89 c2             	mov    %rax,%rdx
  801827:	be 01 00 00 00       	mov    $0x1,%esi
  80182c:	bf 03 00 00 00       	mov    $0x3,%edi
  801831:	48 b8 e5 16 80 00 00 	movabs $0x8016e5,%rax
  801838:	00 00 00 
  80183b:	ff d0                	callq  *%rax
}
  80183d:	c9                   	leaveq 
  80183e:	c3                   	retq   

000000000080183f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80183f:	55                   	push   %rbp
  801840:	48 89 e5             	mov    %rsp,%rbp
  801843:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801847:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80184e:	00 
  80184f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801855:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80185b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801860:	ba 00 00 00 00       	mov    $0x0,%edx
  801865:	be 00 00 00 00       	mov    $0x0,%esi
  80186a:	bf 02 00 00 00       	mov    $0x2,%edi
  80186f:	48 b8 e5 16 80 00 00 	movabs $0x8016e5,%rax
  801876:	00 00 00 
  801879:	ff d0                	callq  *%rax
}
  80187b:	c9                   	leaveq 
  80187c:	c3                   	retq   

000000000080187d <sys_yield>:

void
sys_yield(void)
{
  80187d:	55                   	push   %rbp
  80187e:	48 89 e5             	mov    %rsp,%rbp
  801881:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801885:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80188c:	00 
  80188d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801893:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801899:	b9 00 00 00 00       	mov    $0x0,%ecx
  80189e:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a3:	be 00 00 00 00       	mov    $0x0,%esi
  8018a8:	bf 0a 00 00 00       	mov    $0xa,%edi
  8018ad:	48 b8 e5 16 80 00 00 	movabs $0x8016e5,%rax
  8018b4:	00 00 00 
  8018b7:	ff d0                	callq  *%rax
}
  8018b9:	c9                   	leaveq 
  8018ba:	c3                   	retq   

00000000008018bb <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8018bb:	55                   	push   %rbp
  8018bc:	48 89 e5             	mov    %rsp,%rbp
  8018bf:	48 83 ec 20          	sub    $0x20,%rsp
  8018c3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018c6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018ca:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8018cd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018d0:	48 63 c8             	movslq %eax,%rcx
  8018d3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018da:	48 98                	cltq   
  8018dc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018e3:	00 
  8018e4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ea:	49 89 c8             	mov    %rcx,%r8
  8018ed:	48 89 d1             	mov    %rdx,%rcx
  8018f0:	48 89 c2             	mov    %rax,%rdx
  8018f3:	be 01 00 00 00       	mov    $0x1,%esi
  8018f8:	bf 04 00 00 00       	mov    $0x4,%edi
  8018fd:	48 b8 e5 16 80 00 00 	movabs $0x8016e5,%rax
  801904:	00 00 00 
  801907:	ff d0                	callq  *%rax
}
  801909:	c9                   	leaveq 
  80190a:	c3                   	retq   

000000000080190b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80190b:	55                   	push   %rbp
  80190c:	48 89 e5             	mov    %rsp,%rbp
  80190f:	48 83 ec 30          	sub    $0x30,%rsp
  801913:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801916:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80191a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80191d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801921:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801925:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801928:	48 63 c8             	movslq %eax,%rcx
  80192b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80192f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801932:	48 63 f0             	movslq %eax,%rsi
  801935:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801939:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80193c:	48 98                	cltq   
  80193e:	48 89 0c 24          	mov    %rcx,(%rsp)
  801942:	49 89 f9             	mov    %rdi,%r9
  801945:	49 89 f0             	mov    %rsi,%r8
  801948:	48 89 d1             	mov    %rdx,%rcx
  80194b:	48 89 c2             	mov    %rax,%rdx
  80194e:	be 01 00 00 00       	mov    $0x1,%esi
  801953:	bf 05 00 00 00       	mov    $0x5,%edi
  801958:	48 b8 e5 16 80 00 00 	movabs $0x8016e5,%rax
  80195f:	00 00 00 
  801962:	ff d0                	callq  *%rax
}
  801964:	c9                   	leaveq 
  801965:	c3                   	retq   

0000000000801966 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801966:	55                   	push   %rbp
  801967:	48 89 e5             	mov    %rsp,%rbp
  80196a:	48 83 ec 20          	sub    $0x20,%rsp
  80196e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801971:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801975:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801979:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80197c:	48 98                	cltq   
  80197e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801985:	00 
  801986:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80198c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801992:	48 89 d1             	mov    %rdx,%rcx
  801995:	48 89 c2             	mov    %rax,%rdx
  801998:	be 01 00 00 00       	mov    $0x1,%esi
  80199d:	bf 06 00 00 00       	mov    $0x6,%edi
  8019a2:	48 b8 e5 16 80 00 00 	movabs $0x8016e5,%rax
  8019a9:	00 00 00 
  8019ac:	ff d0                	callq  *%rax
}
  8019ae:	c9                   	leaveq 
  8019af:	c3                   	retq   

00000000008019b0 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8019b0:	55                   	push   %rbp
  8019b1:	48 89 e5             	mov    %rsp,%rbp
  8019b4:	48 83 ec 10          	sub    $0x10,%rsp
  8019b8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019bb:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8019be:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019c1:	48 63 d0             	movslq %eax,%rdx
  8019c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019c7:	48 98                	cltq   
  8019c9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019d0:	00 
  8019d1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019d7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019dd:	48 89 d1             	mov    %rdx,%rcx
  8019e0:	48 89 c2             	mov    %rax,%rdx
  8019e3:	be 01 00 00 00       	mov    $0x1,%esi
  8019e8:	bf 08 00 00 00       	mov    $0x8,%edi
  8019ed:	48 b8 e5 16 80 00 00 	movabs $0x8016e5,%rax
  8019f4:	00 00 00 
  8019f7:	ff d0                	callq  *%rax
}
  8019f9:	c9                   	leaveq 
  8019fa:	c3                   	retq   

00000000008019fb <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8019fb:	55                   	push   %rbp
  8019fc:	48 89 e5             	mov    %rsp,%rbp
  8019ff:	48 83 ec 20          	sub    $0x20,%rsp
  801a03:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a06:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
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
  801a32:	bf 09 00 00 00       	mov    $0x9,%edi
  801a37:	48 b8 e5 16 80 00 00 	movabs $0x8016e5,%rax
  801a3e:	00 00 00 
  801a41:	ff d0                	callq  *%rax
}
  801a43:	c9                   	leaveq 
  801a44:	c3                   	retq   

0000000000801a45 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801a45:	55                   	push   %rbp
  801a46:	48 89 e5             	mov    %rsp,%rbp
  801a49:	48 83 ec 20          	sub    $0x20,%rsp
  801a4d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a50:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a54:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a58:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801a5b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a5e:	48 63 f0             	movslq %eax,%rsi
  801a61:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a68:	48 98                	cltq   
  801a6a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a6e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a75:	00 
  801a76:	49 89 f1             	mov    %rsi,%r9
  801a79:	49 89 c8             	mov    %rcx,%r8
  801a7c:	48 89 d1             	mov    %rdx,%rcx
  801a7f:	48 89 c2             	mov    %rax,%rdx
  801a82:	be 00 00 00 00       	mov    $0x0,%esi
  801a87:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a8c:	48 b8 e5 16 80 00 00 	movabs $0x8016e5,%rax
  801a93:	00 00 00 
  801a96:	ff d0                	callq  *%rax
}
  801a98:	c9                   	leaveq 
  801a99:	c3                   	retq   

0000000000801a9a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a9a:	55                   	push   %rbp
  801a9b:	48 89 e5             	mov    %rsp,%rbp
  801a9e:	48 83 ec 10          	sub    $0x10,%rsp
  801aa2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801aa6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aaa:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ab1:	00 
  801ab2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ab8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801abe:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ac3:	48 89 c2             	mov    %rax,%rdx
  801ac6:	be 01 00 00 00       	mov    $0x1,%esi
  801acb:	bf 0c 00 00 00       	mov    $0xc,%edi
  801ad0:	48 b8 e5 16 80 00 00 	movabs $0x8016e5,%rax
  801ad7:	00 00 00 
  801ada:	ff d0                	callq  *%rax
}
  801adc:	c9                   	leaveq 
  801add:	c3                   	retq   

0000000000801ade <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801ade:	55                   	push   %rbp
  801adf:	48 89 e5             	mov    %rsp,%rbp
  801ae2:	48 83 ec 30          	sub    $0x30,%rsp
  801ae6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801aea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aee:	48 8b 00             	mov    (%rax),%rax
  801af1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  801af5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801af9:	48 8b 40 08          	mov    0x8(%rax),%rax
  801afd:	89 45 fc             	mov    %eax,-0x4(%rbp)


	if (debug)
		cprintf("fault %08x %08x %d from %08x\n", addr, &uvpt[PGNUM(addr)], err & 7, (&addr)[4]);

	if (!(err & FEC_WR))
  801b00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b03:	83 e0 02             	and    $0x2,%eax
  801b06:	85 c0                	test   %eax,%eax
  801b08:	75 40                	jne    801b4a <pgfault+0x6c>
		panic("read fault at %x, rip %x", addr, utf->utf_rip);
  801b0a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b0e:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  801b15:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b19:	49 89 d0             	mov    %rdx,%r8
  801b1c:	48 89 c1             	mov    %rax,%rcx
  801b1f:	48 ba 98 29 80 00 00 	movabs $0x802998,%rdx
  801b26:	00 00 00 
  801b29:	be 1a 00 00 00       	mov    $0x1a,%esi
  801b2e:	48 bf b1 29 80 00 00 	movabs $0x8029b1,%rdi
  801b35:	00 00 00 
  801b38:	b8 00 00 00 00       	mov    $0x0,%eax
  801b3d:	49 b9 9f 22 80 00 00 	movabs $0x80229f,%r9
  801b44:	00 00 00 
  801b47:	41 ff d1             	callq  *%r9
	if ((uvpt[PGNUM(addr)] & (PTE_P|PTE_U|PTE_W|PTE_COW)) != (PTE_P|PTE_U|PTE_COW))
  801b4a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b4e:	48 c1 e8 0c          	shr    $0xc,%rax
  801b52:	48 89 c2             	mov    %rax,%rdx
  801b55:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801b5c:	01 00 00 
  801b5f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b63:	25 07 08 00 00       	and    $0x807,%eax
  801b68:	48 3d 05 08 00 00    	cmp    $0x805,%rax
  801b6e:	74 4e                	je     801bbe <pgfault+0xe0>
		panic("fault at %x with pte %x, not copy-on-write",
  801b70:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b74:	48 c1 e8 0c          	shr    $0xc,%rax
  801b78:	48 89 c2             	mov    %rax,%rdx
  801b7b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801b82:	01 00 00 
  801b85:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801b89:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b8d:	49 89 d0             	mov    %rdx,%r8
  801b90:	48 89 c1             	mov    %rax,%rcx
  801b93:	48 ba c0 29 80 00 00 	movabs $0x8029c0,%rdx
  801b9a:	00 00 00 
  801b9d:	be 1d 00 00 00       	mov    $0x1d,%esi
  801ba2:	48 bf b1 29 80 00 00 	movabs $0x8029b1,%rdi
  801ba9:	00 00 00 
  801bac:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb1:	49 b9 9f 22 80 00 00 	movabs $0x80229f,%r9
  801bb8:	00 00 00 
  801bbb:	41 ff d1             	callq  *%r9
		      addr, uvpt[PGNUM(addr)]);



	// copy page
	if ((r = sys_page_alloc(0, (void*) PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801bbe:	ba 07 00 00 00       	mov    $0x7,%edx
  801bc3:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801bc8:	bf 00 00 00 00       	mov    $0x0,%edi
  801bcd:	48 b8 bb 18 80 00 00 	movabs $0x8018bb,%rax
  801bd4:	00 00 00 
  801bd7:	ff d0                	callq  *%rax
  801bd9:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801bdc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801be0:	79 30                	jns    801c12 <pgfault+0x134>
		panic("sys_page_alloc: %e", r);
  801be2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801be5:	89 c1                	mov    %eax,%ecx
  801be7:	48 ba eb 29 80 00 00 	movabs $0x8029eb,%rdx
  801bee:	00 00 00 
  801bf1:	be 23 00 00 00       	mov    $0x23,%esi
  801bf6:	48 bf b1 29 80 00 00 	movabs $0x8029b1,%rdi
  801bfd:	00 00 00 
  801c00:	b8 00 00 00 00       	mov    $0x0,%eax
  801c05:	49 b8 9f 22 80 00 00 	movabs $0x80229f,%r8
  801c0c:	00 00 00 
  801c0f:	41 ff d0             	callq  *%r8
	memmove((void*) PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  801c12:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c16:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  801c1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c1e:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801c24:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c29:	48 89 c6             	mov    %rax,%rsi
  801c2c:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801c31:	48 b8 b0 12 80 00 00 	movabs $0x8012b0,%rax
  801c38:	00 00 00 
  801c3b:	ff d0                	callq  *%rax

	// remap over faulting page
	if ((r = sys_page_map(0, (void*) PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  801c3d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c41:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801c45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c49:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801c4f:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801c55:	48 89 c1             	mov    %rax,%rcx
  801c58:	ba 00 00 00 00       	mov    $0x0,%edx
  801c5d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c62:	bf 00 00 00 00       	mov    $0x0,%edi
  801c67:	48 b8 0b 19 80 00 00 	movabs $0x80190b,%rax
  801c6e:	00 00 00 
  801c71:	ff d0                	callq  *%rax
  801c73:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801c76:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801c7a:	79 30                	jns    801cac <pgfault+0x1ce>
		panic("sys_page_map: %e", r);
  801c7c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c7f:	89 c1                	mov    %eax,%ecx
  801c81:	48 ba fe 29 80 00 00 	movabs $0x8029fe,%rdx
  801c88:	00 00 00 
  801c8b:	be 28 00 00 00       	mov    $0x28,%esi
  801c90:	48 bf b1 29 80 00 00 	movabs $0x8029b1,%rdi
  801c97:	00 00 00 
  801c9a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c9f:	49 b8 9f 22 80 00 00 	movabs $0x80229f,%r8
  801ca6:	00 00 00 
  801ca9:	41 ff d0             	callq  *%r8

	// unmap our work space
	if ((r = sys_page_unmap(0, (void*) PFTEMP)) < 0)
  801cac:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801cb1:	bf 00 00 00 00       	mov    $0x0,%edi
  801cb6:	48 b8 66 19 80 00 00 	movabs $0x801966,%rax
  801cbd:	00 00 00 
  801cc0:	ff d0                	callq  *%rax
  801cc2:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801cc5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801cc9:	79 30                	jns    801cfb <pgfault+0x21d>
		panic("sys_page_unmap: %e", r);
  801ccb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cce:	89 c1                	mov    %eax,%ecx
  801cd0:	48 ba 0f 2a 80 00 00 	movabs $0x802a0f,%rdx
  801cd7:	00 00 00 
  801cda:	be 2c 00 00 00       	mov    $0x2c,%esi
  801cdf:	48 bf b1 29 80 00 00 	movabs $0x8029b1,%rdi
  801ce6:	00 00 00 
  801ce9:	b8 00 00 00 00       	mov    $0x0,%eax
  801cee:	49 b8 9f 22 80 00 00 	movabs $0x80229f,%r8
  801cf5:	00 00 00 
  801cf8:	41 ff d0             	callq  *%r8

}
  801cfb:	c9                   	leaveq 
  801cfc:	c3                   	retq   

0000000000801cfd <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801cfd:	55                   	push   %rbp
  801cfe:	48 89 e5             	mov    %rsp,%rbp
  801d01:	48 83 ec 30          	sub    $0x30,%rsp
  801d05:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801d08:	89 75 d8             	mov    %esi,-0x28(%rbp)


	void *addr;
	pte_t pte;

	addr = (void*) (uint64_t)(pn << PGSHIFT);
  801d0b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801d0e:	c1 e0 0c             	shl    $0xc,%eax
  801d11:	89 c0                	mov    %eax,%eax
  801d13:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	pte = uvpt[pn];
  801d17:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d1e:	01 00 00 
  801d21:	8b 55 d8             	mov    -0x28(%rbp),%edx
  801d24:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d28:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	

	// if the page is just read-only or is library-shared, map it directly.
	if (!(pte & (PTE_W|PTE_COW)) || (pte & PTE_SHARE)) {
  801d2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d30:	25 02 08 00 00       	and    $0x802,%eax
  801d35:	48 85 c0             	test   %rax,%rax
  801d38:	74 0e                	je     801d48 <duppage+0x4b>
  801d3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d3e:	25 00 04 00 00       	and    $0x400,%eax
  801d43:	48 85 c0             	test   %rax,%rax
  801d46:	74 70                	je     801db8 <duppage+0xbb>
		if ((r = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  801d48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d4c:	25 07 0e 00 00       	and    $0xe07,%eax
  801d51:	89 c6                	mov    %eax,%esi
  801d53:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  801d57:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801d5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d5e:	41 89 f0             	mov    %esi,%r8d
  801d61:	48 89 c6             	mov    %rax,%rsi
  801d64:	bf 00 00 00 00       	mov    $0x0,%edi
  801d69:	48 b8 0b 19 80 00 00 	movabs $0x80190b,%rax
  801d70:	00 00 00 
  801d73:	ff d0                	callq  *%rax
  801d75:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d78:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801d7c:	79 30                	jns    801dae <duppage+0xb1>
			panic("sys_page_map: %e", r);
  801d7e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d81:	89 c1                	mov    %eax,%ecx
  801d83:	48 ba fe 29 80 00 00 	movabs $0x8029fe,%rdx
  801d8a:	00 00 00 
  801d8d:	be 4b 00 00 00       	mov    $0x4b,%esi
  801d92:	48 bf b1 29 80 00 00 	movabs $0x8029b1,%rdi
  801d99:	00 00 00 
  801d9c:	b8 00 00 00 00       	mov    $0x0,%eax
  801da1:	49 b8 9f 22 80 00 00 	movabs $0x80229f,%r8
  801da8:	00 00 00 
  801dab:	41 ff d0             	callq  *%r8
		return 0;
  801dae:	b8 00 00 00 00       	mov    $0x0,%eax
  801db3:	e9 c4 00 00 00       	jmpq   801e7c <duppage+0x17f>
	// Even if we think the page is already copy-on-write in our
	// address space, we need to mark it copy-on-write again after
	// the first sys_page_map, just in case a page fault has caused
	// us to copy the page in the interim.

	if ((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  801db8:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  801dbc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801dbf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dc3:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  801dc9:	48 89 c6             	mov    %rax,%rsi
  801dcc:	bf 00 00 00 00       	mov    $0x0,%edi
  801dd1:	48 b8 0b 19 80 00 00 	movabs $0x80190b,%rax
  801dd8:	00 00 00 
  801ddb:	ff d0                	callq  *%rax
  801ddd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801de0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801de4:	79 30                	jns    801e16 <duppage+0x119>
		panic("sys_page_map: %e", r);
  801de6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801de9:	89 c1                	mov    %eax,%ecx
  801deb:	48 ba fe 29 80 00 00 	movabs $0x8029fe,%rdx
  801df2:	00 00 00 
  801df5:	be 5f 00 00 00       	mov    $0x5f,%esi
  801dfa:	48 bf b1 29 80 00 00 	movabs $0x8029b1,%rdi
  801e01:	00 00 00 
  801e04:	b8 00 00 00 00       	mov    $0x0,%eax
  801e09:	49 b8 9f 22 80 00 00 	movabs $0x80229f,%r8
  801e10:	00 00 00 
  801e13:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  801e16:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e1e:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  801e24:	48 89 d1             	mov    %rdx,%rcx
  801e27:	ba 00 00 00 00       	mov    $0x0,%edx
  801e2c:	48 89 c6             	mov    %rax,%rsi
  801e2f:	bf 00 00 00 00       	mov    $0x0,%edi
  801e34:	48 b8 0b 19 80 00 00 	movabs $0x80190b,%rax
  801e3b:	00 00 00 
  801e3e:	ff d0                	callq  *%rax
  801e40:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801e43:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e47:	79 30                	jns    801e79 <duppage+0x17c>
		panic("sys_page_map: %e", r);
  801e49:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e4c:	89 c1                	mov    %eax,%ecx
  801e4e:	48 ba fe 29 80 00 00 	movabs $0x8029fe,%rdx
  801e55:	00 00 00 
  801e58:	be 61 00 00 00       	mov    $0x61,%esi
  801e5d:	48 bf b1 29 80 00 00 	movabs $0x8029b1,%rdi
  801e64:	00 00 00 
  801e67:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6c:	49 b8 9f 22 80 00 00 	movabs $0x80229f,%r8
  801e73:	00 00 00 
  801e76:	41 ff d0             	callq  *%r8
	return r;
  801e79:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  801e7c:	c9                   	leaveq 
  801e7d:	c3                   	retq   

0000000000801e7e <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801e7e:	55                   	push   %rbp
  801e7f:	48 89 e5             	mov    %rsp,%rbp
  801e82:	48 83 ec 20          	sub    $0x20,%rsp
	envid_t envid;
	int pn, end_pn, r;

	set_pgfault_handler(pgfault);
  801e86:	48 bf de 1a 80 00 00 	movabs $0x801ade,%rdi
  801e8d:	00 00 00 
  801e90:	48 b8 b3 23 80 00 00 	movabs $0x8023b3,%rax
  801e97:	00 00 00 
  801e9a:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801e9c:	b8 07 00 00 00       	mov    $0x7,%eax
  801ea1:	cd 30                	int    $0x30
  801ea3:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801ea6:	8b 45 ec             	mov    -0x14(%rbp),%eax

	// Create a child.
	envid = sys_exofork();
  801ea9:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (envid < 0)
  801eac:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801eb0:	79 08                	jns    801eba <fork+0x3c>
		return envid;
  801eb2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801eb5:	e9 11 02 00 00       	jmpq   8020cb <fork+0x24d>
	if (envid == 0) {
  801eba:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801ebe:	75 46                	jne    801f06 <fork+0x88>
		thisenv = &envs[ENVX(sys_getenvid())];
  801ec0:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
  801ec7:	00 00 00 
  801eca:	ff d0                	callq  *%rax
  801ecc:	25 ff 03 00 00       	and    $0x3ff,%eax
  801ed1:	48 63 d0             	movslq %eax,%rdx
  801ed4:	48 89 d0             	mov    %rdx,%rax
  801ed7:	48 c1 e0 03          	shl    $0x3,%rax
  801edb:	48 01 d0             	add    %rdx,%rax
  801ede:	48 c1 e0 05          	shl    $0x5,%rax
  801ee2:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801ee9:	00 00 00 
  801eec:	48 01 c2             	add    %rax,%rdx
  801eef:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  801ef6:	00 00 00 
  801ef9:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801efc:	b8 00 00 00 00       	mov    $0x0,%eax
  801f01:	e9 c5 01 00 00       	jmpq   8020cb <fork+0x24d>
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  801f06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f0d:	e9 a4 00 00 00       	jmpq   801fb6 <fork+0x138>
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
  801f12:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f15:	c1 f8 12             	sar    $0x12,%eax
  801f18:	89 c2                	mov    %eax,%edx
  801f1a:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801f21:	01 00 00 
  801f24:	48 63 d2             	movslq %edx,%rdx
  801f27:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f2b:	83 e0 01             	and    $0x1,%eax
  801f2e:	48 85 c0             	test   %rax,%rax
  801f31:	74 21                	je     801f54 <fork+0xd6>
  801f33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f36:	c1 f8 09             	sar    $0x9,%eax
  801f39:	89 c2                	mov    %eax,%edx
  801f3b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f42:	01 00 00 
  801f45:	48 63 d2             	movslq %edx,%rdx
  801f48:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f4c:	83 e0 01             	and    $0x1,%eax
  801f4f:	48 85 c0             	test   %rax,%rax
  801f52:	75 09                	jne    801f5d <fork+0xdf>
			pn += NPTENTRIES;
  801f54:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%rbp)
			continue;
  801f5b:	eb 59                	jmp    801fb6 <fork+0x138>
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  801f5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f60:	05 00 02 00 00       	add    $0x200,%eax
  801f65:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801f68:	eb 44                	jmp    801fae <fork+0x130>
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
  801f6a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f71:	01 00 00 
  801f74:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f77:	48 63 d2             	movslq %edx,%rdx
  801f7a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f7e:	83 e0 05             	and    $0x5,%eax
  801f81:	48 83 f8 05          	cmp    $0x5,%rax
  801f85:	74 02                	je     801f89 <fork+0x10b>
				continue;
  801f87:	eb 21                	jmp    801faa <fork+0x12c>
			if (pn == PPN(UXSTACKTOP - 1))
  801f89:	81 7d fc ff f7 0e 00 	cmpl   $0xef7ff,-0x4(%rbp)
  801f90:	75 02                	jne    801f94 <fork+0x116>
				continue;
  801f92:	eb 16                	jmp    801faa <fork+0x12c>
			duppage(envid, pn);
  801f94:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f97:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f9a:	89 d6                	mov    %edx,%esi
  801f9c:	89 c7                	mov    %eax,%edi
  801f9e:	48 b8 fd 1c 80 00 00 	movabs $0x801cfd,%rax
  801fa5:	00 00 00 
  801fa8:	ff d0                	callq  *%rax
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  801faa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801fae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fb1:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  801fb4:	7c b4                	jl     801f6a <fork+0xec>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  801fb6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fb9:	3d ff 07 00 08       	cmp    $0x80007ff,%eax
  801fbe:	0f 86 4e ff ff ff    	jbe    801f12 <fork+0x94>
			duppage(envid, pn);
		}
	}

	// The child needs to start out with a valid exception stack.
	if ((r = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  801fc4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801fc7:	ba 07 00 00 00       	mov    $0x7,%edx
  801fcc:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801fd1:	89 c7                	mov    %eax,%edi
  801fd3:	48 b8 bb 18 80 00 00 	movabs $0x8018bb,%rax
  801fda:	00 00 00 
  801fdd:	ff d0                	callq  *%rax
  801fdf:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801fe2:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801fe6:	79 30                	jns    802018 <fork+0x19a>
		panic("allocating exception stack: %e", r);
  801fe8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801feb:	89 c1                	mov    %eax,%ecx
  801fed:	48 ba 28 2a 80 00 00 	movabs $0x802a28,%rdx
  801ff4:	00 00 00 
  801ff7:	be 98 00 00 00       	mov    $0x98,%esi
  801ffc:	48 bf b1 29 80 00 00 	movabs $0x8029b1,%rdi
  802003:	00 00 00 
  802006:	b8 00 00 00 00       	mov    $0x0,%eax
  80200b:	49 b8 9f 22 80 00 00 	movabs $0x80229f,%r8
  802012:	00 00 00 
  802015:	41 ff d0             	callq  *%r8

	// Copy the user-mode exception entrypoint.
	if ((r = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall)) < 0)
  802018:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  80201f:	00 00 00 
  802022:	48 8b 00             	mov    (%rax),%rax
  802025:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  80202c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80202f:	48 89 d6             	mov    %rdx,%rsi
  802032:	89 c7                	mov    %eax,%edi
  802034:	48 b8 fb 19 80 00 00 	movabs $0x8019fb,%rax
  80203b:	00 00 00 
  80203e:	ff d0                	callq  *%rax
  802040:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802043:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802047:	79 30                	jns    802079 <fork+0x1fb>
		panic("sys_env_set_pgfault_upcall: %e", r);
  802049:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80204c:	89 c1                	mov    %eax,%ecx
  80204e:	48 ba 48 2a 80 00 00 	movabs $0x802a48,%rdx
  802055:	00 00 00 
  802058:	be 9c 00 00 00       	mov    $0x9c,%esi
  80205d:	48 bf b1 29 80 00 00 	movabs $0x8029b1,%rdi
  802064:	00 00 00 
  802067:	b8 00 00 00 00       	mov    $0x0,%eax
  80206c:	49 b8 9f 22 80 00 00 	movabs $0x80229f,%r8
  802073:	00 00 00 
  802076:	41 ff d0             	callq  *%r8


	// Okay, the child is ready for life on its own.
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  802079:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80207c:	be 02 00 00 00       	mov    $0x2,%esi
  802081:	89 c7                	mov    %eax,%edi
  802083:	48 b8 b0 19 80 00 00 	movabs $0x8019b0,%rax
  80208a:	00 00 00 
  80208d:	ff d0                	callq  *%rax
  80208f:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802092:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802096:	79 30                	jns    8020c8 <fork+0x24a>
		panic("sys_env_set_status: %e", r);
  802098:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80209b:	89 c1                	mov    %eax,%ecx
  80209d:	48 ba 67 2a 80 00 00 	movabs $0x802a67,%rdx
  8020a4:	00 00 00 
  8020a7:	be a1 00 00 00       	mov    $0xa1,%esi
  8020ac:	48 bf b1 29 80 00 00 	movabs $0x8029b1,%rdi
  8020b3:	00 00 00 
  8020b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8020bb:	49 b8 9f 22 80 00 00 	movabs $0x80229f,%r8
  8020c2:	00 00 00 
  8020c5:	41 ff d0             	callq  *%r8

	return envid;
  8020c8:	8b 45 f8             	mov    -0x8(%rbp),%eax


}
  8020cb:	c9                   	leaveq 
  8020cc:	c3                   	retq   

00000000008020cd <sfork>:

// Challenge!
int
sfork(void)
{
  8020cd:	55                   	push   %rbp
  8020ce:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8020d1:	48 ba 7e 2a 80 00 00 	movabs $0x802a7e,%rdx
  8020d8:	00 00 00 
  8020db:	be ac 00 00 00       	mov    $0xac,%esi
  8020e0:	48 bf b1 29 80 00 00 	movabs $0x8029b1,%rdi
  8020e7:	00 00 00 
  8020ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ef:	48 b9 9f 22 80 00 00 	movabs $0x80229f,%rcx
  8020f6:	00 00 00 
  8020f9:	ff d1                	callq  *%rcx

00000000008020fb <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8020fb:	55                   	push   %rbp
  8020fc:	48 89 e5             	mov    %rsp,%rbp
  8020ff:	48 83 ec 30          	sub    $0x30,%rsp
  802103:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802107:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80210b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	
	if(pg == NULL)
  80210f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802114:	75 0e                	jne    802124 <ipc_recv+0x29>
	  pg = (void *)(UTOP); // We always check above and below UTOP
  802116:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80211d:	00 00 00 
  802120:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	 int retval = sys_ipc_recv(pg);
  802124:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802128:	48 89 c7             	mov    %rax,%rdi
  80212b:	48 b8 9a 1a 80 00 00 	movabs $0x801a9a,%rax
  802132:	00 00 00 
  802135:	ff d0                	callq  *%rax
  802137:	89 45 fc             	mov    %eax,-0x4(%rbp)

	 if(retval == 0)
  80213a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80213e:	75 55                	jne    802195 <ipc_recv+0x9a>
	 {	
	    if(from_env_store != NULL)
  802140:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802145:	74 19                	je     802160 <ipc_recv+0x65>
               *from_env_store = thisenv->env_ipc_from;
  802147:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  80214e:	00 00 00 
  802151:	48 8b 00             	mov    (%rax),%rax
  802154:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80215a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80215e:	89 10                	mov    %edx,(%rax)

	    if(perm_store != NULL)
  802160:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802165:	74 19                	je     802180 <ipc_recv+0x85>
               *perm_store = thisenv->env_ipc_perm;
  802167:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  80216e:	00 00 00 
  802171:	48 8b 00             	mov    (%rax),%rax
  802174:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80217a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80217e:	89 10                	mov    %edx,(%rax)

	   return thisenv->env_ipc_value;
  802180:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  802187:	00 00 00 
  80218a:	48 8b 00             	mov    (%rax),%rax
  80218d:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  802193:	eb 25                	jmp    8021ba <ipc_recv+0xbf>

	 }
	 else
	 {
	      if(from_env_store)
  802195:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80219a:	74 0a                	je     8021a6 <ipc_recv+0xab>
	         *from_env_store = 0;
  80219c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	      
	      if(perm_store)
  8021a6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8021ab:	74 0a                	je     8021b7 <ipc_recv+0xbc>
	       *perm_store = 0;
  8021ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021b1:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	       
	       return retval;
  8021b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
	 }
	
	panic("problem in ipc_recv lib/ipc.c");
	//return 0;
}
  8021ba:	c9                   	leaveq 
  8021bb:	c3                   	retq   

00000000008021bc <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8021bc:	55                   	push   %rbp
  8021bd:	48 89 e5             	mov    %rsp,%rbp
  8021c0:	48 83 ec 30          	sub    $0x30,%rsp
  8021c4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021c7:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8021ca:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8021ce:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.

	if(pg == NULL)
  8021d1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8021d6:	75 0e                	jne    8021e6 <ipc_send+0x2a>
	   pg = (void *)(UTOP);
  8021d8:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8021df:	00 00 00 
  8021e2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	int retval;
	while(1)
	{
	   retval = sys_ipc_try_send(to_env, val, pg, perm);
  8021e6:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8021e9:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8021ec:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8021f0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021f3:	89 c7                	mov    %eax,%edi
  8021f5:	48 b8 45 1a 80 00 00 	movabs $0x801a45,%rax
  8021fc:	00 00 00 
  8021ff:	ff d0                	callq  *%rax
  802201:	89 45 fc             	mov    %eax,-0x4(%rbp)
	   if(retval == 0)
  802204:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802208:	75 02                	jne    80220c <ipc_send+0x50>
	      break;
  80220a:	eb 0e                	jmp    80221a <ipc_send+0x5e>
	   
	   //if(retval < 0 && retval != -E_IPC_NOT_RECV)
	     //panic("receiver error other than NOT_RECV");

	   sys_yield(); 
  80220c:	48 b8 7d 18 80 00 00 	movabs $0x80187d,%rax
  802213:	00 00 00 
  802216:	ff d0                	callq  *%rax
	 
	}
  802218:	eb cc                	jmp    8021e6 <ipc_send+0x2a>
	return;
  80221a:	90                   	nop
	//panic("ipc_send not implemented");
}
  80221b:	c9                   	leaveq 
  80221c:	c3                   	retq   

000000000080221d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80221d:	55                   	push   %rbp
  80221e:	48 89 e5             	mov    %rsp,%rbp
  802221:	48 83 ec 14          	sub    $0x14,%rsp
  802225:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  802228:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80222f:	eb 5e                	jmp    80228f <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  802231:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802238:	00 00 00 
  80223b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80223e:	48 63 d0             	movslq %eax,%rdx
  802241:	48 89 d0             	mov    %rdx,%rax
  802244:	48 c1 e0 03          	shl    $0x3,%rax
  802248:	48 01 d0             	add    %rdx,%rax
  80224b:	48 c1 e0 05          	shl    $0x5,%rax
  80224f:	48 01 c8             	add    %rcx,%rax
  802252:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802258:	8b 00                	mov    (%rax),%eax
  80225a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80225d:	75 2c                	jne    80228b <ipc_find_env+0x6e>
			return envs[i].env_id;
  80225f:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802266:	00 00 00 
  802269:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80226c:	48 63 d0             	movslq %eax,%rdx
  80226f:	48 89 d0             	mov    %rdx,%rax
  802272:	48 c1 e0 03          	shl    $0x3,%rax
  802276:	48 01 d0             	add    %rdx,%rax
  802279:	48 c1 e0 05          	shl    $0x5,%rax
  80227d:	48 01 c8             	add    %rcx,%rax
  802280:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802286:	8b 40 08             	mov    0x8(%rax),%eax
  802289:	eb 12                	jmp    80229d <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80228b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80228f:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802296:	7e 99                	jle    802231 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802298:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80229d:	c9                   	leaveq 
  80229e:	c3                   	retq   

000000000080229f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80229f:	55                   	push   %rbp
  8022a0:	48 89 e5             	mov    %rsp,%rbp
  8022a3:	53                   	push   %rbx
  8022a4:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8022ab:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8022b2:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8022b8:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8022bf:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8022c6:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8022cd:	84 c0                	test   %al,%al
  8022cf:	74 23                	je     8022f4 <_panic+0x55>
  8022d1:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8022d8:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8022dc:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8022e0:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8022e4:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8022e8:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8022ec:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8022f0:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8022f4:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8022fb:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  802302:	00 00 00 
  802305:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80230c:	00 00 00 
  80230f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802313:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80231a:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  802321:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802328:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  80232f:	00 00 00 
  802332:	48 8b 18             	mov    (%rax),%rbx
  802335:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
  80233c:	00 00 00 
  80233f:	ff d0                	callq  *%rax
  802341:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  802347:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80234e:	41 89 c8             	mov    %ecx,%r8d
  802351:	48 89 d1             	mov    %rdx,%rcx
  802354:	48 89 da             	mov    %rbx,%rdx
  802357:	89 c6                	mov    %eax,%esi
  802359:	48 bf 98 2a 80 00 00 	movabs $0x802a98,%rdi
  802360:	00 00 00 
  802363:	b8 00 00 00 00       	mov    $0x0,%eax
  802368:	49 b9 d7 03 80 00 00 	movabs $0x8003d7,%r9
  80236f:	00 00 00 
  802372:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802375:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80237c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802383:	48 89 d6             	mov    %rdx,%rsi
  802386:	48 89 c7             	mov    %rax,%rdi
  802389:	48 b8 2b 03 80 00 00 	movabs $0x80032b,%rax
  802390:	00 00 00 
  802393:	ff d0                	callq  *%rax
	cprintf("\n");
  802395:	48 bf bb 2a 80 00 00 	movabs $0x802abb,%rdi
  80239c:	00 00 00 
  80239f:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a4:	48 ba d7 03 80 00 00 	movabs $0x8003d7,%rdx
  8023ab:	00 00 00 
  8023ae:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8023b0:	cc                   	int3   
  8023b1:	eb fd                	jmp    8023b0 <_panic+0x111>

00000000008023b3 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8023b3:	55                   	push   %rbp
  8023b4:	48 89 e5             	mov    %rsp,%rbp
  8023b7:	48 83 ec 10          	sub    $0x10,%rsp
  8023bb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;
	
	if (_pgfault_handler == 0) {
  8023bf:	48 b8 18 40 80 00 00 	movabs $0x804018,%rax
  8023c6:	00 00 00 
  8023c9:	48 8b 00             	mov    (%rax),%rax
  8023cc:	48 85 c0             	test   %rax,%rax
  8023cf:	0f 85 b2 00 00 00    	jne    802487 <set_pgfault_handler+0xd4>
		// First time through!
		// LAB 4: Your code here.
		
		if(sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP-PGSIZE), PTE_P|PTE_U|PTE_W) != 0)
  8023d5:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  8023dc:	00 00 00 
  8023df:	48 8b 00             	mov    (%rax),%rax
  8023e2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023e8:	ba 07 00 00 00       	mov    $0x7,%edx
  8023ed:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8023f2:	89 c7                	mov    %eax,%edi
  8023f4:	48 b8 bb 18 80 00 00 	movabs $0x8018bb,%rax
  8023fb:	00 00 00 
  8023fe:	ff d0                	callq  *%rax
  802400:	85 c0                	test   %eax,%eax
  802402:	74 2a                	je     80242e <set_pgfault_handler+0x7b>
		  panic("\nproblem in page allocation lib/pgfault.c\n");
  802404:	48 ba c0 2a 80 00 00 	movabs $0x802ac0,%rdx
  80240b:	00 00 00 
  80240e:	be 22 00 00 00       	mov    $0x22,%esi
  802413:	48 bf eb 2a 80 00 00 	movabs $0x802aeb,%rdi
  80241a:	00 00 00 
  80241d:	b8 00 00 00 00       	mov    $0x0,%eax
  802422:	48 b9 9f 22 80 00 00 	movabs $0x80229f,%rcx
  802429:	00 00 00 
  80242c:	ff d1                	callq  *%rcx
		
	         if(sys_env_set_pgfault_upcall(thisenv->env_id, (void *)_pgfault_upcall) != 0)
  80242e:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  802435:	00 00 00 
  802438:	48 8b 00             	mov    (%rax),%rax
  80243b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802441:	48 be 9a 24 80 00 00 	movabs $0x80249a,%rsi
  802448:	00 00 00 
  80244b:	89 c7                	mov    %eax,%edi
  80244d:	48 b8 fb 19 80 00 00 	movabs $0x8019fb,%rax
  802454:	00 00 00 
  802457:	ff d0                	callq  *%rax
  802459:	85 c0                	test   %eax,%eax
  80245b:	74 2a                	je     802487 <set_pgfault_handler+0xd4>
		   panic("set_pgfault_handler implemented but problems lib/pgfault.c");
  80245d:	48 ba 00 2b 80 00 00 	movabs $0x802b00,%rdx
  802464:	00 00 00 
  802467:	be 25 00 00 00       	mov    $0x25,%esi
  80246c:	48 bf eb 2a 80 00 00 	movabs $0x802aeb,%rdi
  802473:	00 00 00 
  802476:	b8 00 00 00 00       	mov    $0x0,%eax
  80247b:	48 b9 9f 22 80 00 00 	movabs $0x80229f,%rcx
  802482:	00 00 00 
  802485:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802487:	48 b8 18 40 80 00 00 	movabs $0x804018,%rax
  80248e:	00 00 00 
  802491:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802495:	48 89 10             	mov    %rdx,(%rax)
}
  802498:	c9                   	leaveq 
  802499:	c3                   	retq   

000000000080249a <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  80249a:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  80249d:	48 a1 18 40 80 00 00 	movabs 0x804018,%rax
  8024a4:	00 00 00 
	call *%rax
  8024a7:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.                
	movq %rsp, %rdi;	
  8024a9:	48 89 e7             	mov    %rsp,%rdi
	movq 136(%rsp), %rbx;
  8024ac:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8024b3:	00 
	movq 152(%rsp), %rsp;// Going to another stack for storing rip	
  8024b4:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  8024bb:	00 
	pushq %rbx;
  8024bc:	53                   	push   %rbx
	movq %rsp, %rbx;	
  8024bd:	48 89 e3             	mov    %rsp,%rbx
	movq %rdi, %rsp;	
  8024c0:	48 89 fc             	mov    %rdi,%rsp
	movq %rbx, 152(%rsp)	
  8024c3:	48 89 9c 24 98 00 00 	mov    %rbx,0x98(%rsp)
  8024ca:	00 
   
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16, %rsp;	
  8024cb:	48 83 c4 10          	add    $0x10,%rsp
	POPA_;  // getting all register values back
  8024cf:	4c 8b 3c 24          	mov    (%rsp),%r15
  8024d3:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8024d8:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8024dd:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8024e2:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8024e7:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8024ec:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8024f1:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8024f6:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8024fb:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  802500:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  802505:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80250a:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  80250f:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  802514:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  802519:	48 83 c4 78          	add    $0x78,%rsp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	add $8, %rsp; //Jump rip field  
  80251d:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  802521:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp   //USTACK
  802522:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret   
  802523:	c3                   	retq   
