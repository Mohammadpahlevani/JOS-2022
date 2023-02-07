
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
  800060:	48 b8 3d 20 80 00 00 	movabs $0x80203d,%rax
  800067:	00 00 00 
  80006a:	ff d0                	callq  *%rax
  80006c:	89 45 d8             	mov    %eax,-0x28(%rbp)
  80006f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800072:	85 c0                	test   %eax,%eax
  800074:	0f 84 87 00 00 00    	je     800101 <umain+0xbe>
		cprintf("i am %08x; thisenv is %p\n", sys_getenvid(), thisenv);
  80007a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800081:	00 00 00 
  800084:	48 8b 18             	mov    (%rax),%rbx
  800087:	48 b8 37 18 80 00 00 	movabs $0x801837,%rax
  80008e:	00 00 00 
  800091:	ff d0                	callq  *%rax
  800093:	48 89 da             	mov    %rbx,%rdx
  800096:	89 c6                	mov    %eax,%esi
  800098:	48 bf e0 3c 80 00 00 	movabs $0x803ce0,%rdi
  80009f:	00 00 00 
  8000a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a7:	48 b9 cf 03 80 00 00 	movabs $0x8003cf,%rcx
  8000ae:	00 00 00 
  8000b1:	ff d1                	callq  *%rcx
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  8000b3:	8b 5d d8             	mov    -0x28(%rbp),%ebx
  8000b6:	48 b8 37 18 80 00 00 	movabs $0x801837,%rax
  8000bd:	00 00 00 
  8000c0:	ff d0                	callq  *%rax
  8000c2:	89 da                	mov    %ebx,%edx
  8000c4:	89 c6                	mov    %eax,%esi
  8000c6:	48 bf fa 3c 80 00 00 	movabs $0x803cfa,%rdi
  8000cd:	00 00 00 
  8000d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d5:	48 b9 cf 03 80 00 00 	movabs $0x8003cf,%rcx
  8000dc:	00 00 00 
  8000df:	ff d1                	callq  *%rcx
		ipc_send(who, 0, 0, 0);
  8000e1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8000e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ee:	be 00 00 00 00       	mov    $0x0,%esi
  8000f3:	89 c7                	mov    %eax,%edi
  8000f5:	48 b8 31 21 80 00 00 	movabs $0x802131,%rax
  8000fc:	00 00 00 
  8000ff:	ff d0                	callq  *%rax
	}

	while (1) {
		ipc_recv(&who, 0, 0);
  800101:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  800105:	ba 00 00 00 00       	mov    $0x0,%edx
  80010a:	be 00 00 00 00       	mov    $0x0,%esi
  80010f:	48 89 c7             	mov    %rax,%rdi
  800112:	48 b8 6b 20 80 00 00 	movabs $0x80206b,%rax
  800119:	00 00 00 
  80011c:	ff d0                	callq  *%rax
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  80011e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800125:	00 00 00 
  800128:	48 8b 00             	mov    (%rax),%rax
  80012b:	44 8b b0 c8 00 00 00 	mov    0xc8(%rax),%r14d
  800132:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800139:	00 00 00 
  80013c:	4c 8b 28             	mov    (%rax),%r13
  80013f:	44 8b 65 d8          	mov    -0x28(%rbp),%r12d
  800143:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80014a:	00 00 00 
  80014d:	8b 18                	mov    (%rax),%ebx
  80014f:	48 b8 37 18 80 00 00 	movabs $0x801837,%rax
  800156:	00 00 00 
  800159:	ff d0                	callq  *%rax
  80015b:	45 89 f1             	mov    %r14d,%r9d
  80015e:	4d 89 e8             	mov    %r13,%r8
  800161:	44 89 e1             	mov    %r12d,%ecx
  800164:	89 da                	mov    %ebx,%edx
  800166:	89 c6                	mov    %eax,%esi
  800168:	48 bf 10 3d 80 00 00 	movabs $0x803d10,%rdi
  80016f:	00 00 00 
  800172:	b8 00 00 00 00       	mov    $0x0,%eax
  800177:	49 ba cf 03 80 00 00 	movabs $0x8003cf,%r10
  80017e:	00 00 00 
  800181:	41 ff d2             	callq  *%r10
		if (val == 10)
  800184:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80018b:	00 00 00 
  80018e:	8b 00                	mov    (%rax),%eax
  800190:	83 f8 0a             	cmp    $0xa,%eax
  800193:	75 02                	jne    800197 <umain+0x154>
			return;
  800195:	eb 53                	jmp    8001ea <umain+0x1a7>
		++val;
  800197:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80019e:	00 00 00 
  8001a1:	8b 00                	mov    (%rax),%eax
  8001a3:	8d 50 01             	lea    0x1(%rax),%edx
  8001a6:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8001ad:	00 00 00 
  8001b0:	89 10                	mov    %edx,(%rax)
		ipc_send(who, 0, 0, 0);
  8001b2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8001b5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8001bf:	be 00 00 00 00       	mov    $0x0,%esi
  8001c4:	89 c7                	mov    %eax,%edi
  8001c6:	48 b8 31 21 80 00 00 	movabs $0x802131,%rax
  8001cd:	00 00 00 
  8001d0:	ff d0                	callq  *%rax
		if (val == 10)
  8001d2:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
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
  8001fb:	48 83 ec 10          	sub    $0x10,%rsp
  8001ff:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800202:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  800206:	48 b8 37 18 80 00 00 	movabs $0x801837,%rax
  80020d:	00 00 00 
  800210:	ff d0                	callq  *%rax
  800212:	48 98                	cltq   
  800214:	25 ff 03 00 00       	and    $0x3ff,%eax
  800219:	48 89 c2             	mov    %rax,%rdx
  80021c:	48 89 d0             	mov    %rdx,%rax
  80021f:	48 c1 e0 03          	shl    $0x3,%rax
  800223:	48 01 d0             	add    %rdx,%rax
  800226:	48 c1 e0 05          	shl    $0x5,%rax
  80022a:	48 89 c2             	mov    %rax,%rdx
  80022d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800234:	00 00 00 
  800237:	48 01 c2             	add    %rax,%rdx
  80023a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800241:	00 00 00 
  800244:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800247:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80024b:	7e 14                	jle    800261 <libmain+0x6a>
		binaryname = argv[0];
  80024d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800251:	48 8b 10             	mov    (%rax),%rdx
  800254:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80025b:	00 00 00 
  80025e:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800261:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800265:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800268:	48 89 d6             	mov    %rdx,%rsi
  80026b:	89 c7                	mov    %eax,%edi
  80026d:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800274:	00 00 00 
  800277:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800279:	48 b8 87 02 80 00 00 	movabs $0x800287,%rax
  800280:	00 00 00 
  800283:	ff d0                	callq  *%rax
}
  800285:	c9                   	leaveq 
  800286:	c3                   	retq   

0000000000800287 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800287:	55                   	push   %rbp
  800288:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80028b:	48 b8 91 25 80 00 00 	movabs $0x802591,%rax
  800292:	00 00 00 
  800295:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800297:	bf 00 00 00 00       	mov    $0x0,%edi
  80029c:	48 b8 f3 17 80 00 00 	movabs $0x8017f3,%rax
  8002a3:	00 00 00 
  8002a6:	ff d0                	callq  *%rax
}
  8002a8:	5d                   	pop    %rbp
  8002a9:	c3                   	retq   

00000000008002aa <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8002aa:	55                   	push   %rbp
  8002ab:	48 89 e5             	mov    %rsp,%rbp
  8002ae:	48 83 ec 10          	sub    $0x10,%rsp
  8002b2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002b5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8002b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002bd:	8b 00                	mov    (%rax),%eax
  8002bf:	8d 48 01             	lea    0x1(%rax),%ecx
  8002c2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002c6:	89 0a                	mov    %ecx,(%rdx)
  8002c8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8002cb:	89 d1                	mov    %edx,%ecx
  8002cd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002d1:	48 98                	cltq   
  8002d3:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8002d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002db:	8b 00                	mov    (%rax),%eax
  8002dd:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002e2:	75 2c                	jne    800310 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8002e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002e8:	8b 00                	mov    (%rax),%eax
  8002ea:	48 98                	cltq   
  8002ec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002f0:	48 83 c2 08          	add    $0x8,%rdx
  8002f4:	48 89 c6             	mov    %rax,%rsi
  8002f7:	48 89 d7             	mov    %rdx,%rdi
  8002fa:	48 b8 6b 17 80 00 00 	movabs $0x80176b,%rax
  800301:	00 00 00 
  800304:	ff d0                	callq  *%rax
        b->idx = 0;
  800306:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80030a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800310:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800314:	8b 40 04             	mov    0x4(%rax),%eax
  800317:	8d 50 01             	lea    0x1(%rax),%edx
  80031a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80031e:	89 50 04             	mov    %edx,0x4(%rax)
}
  800321:	c9                   	leaveq 
  800322:	c3                   	retq   

0000000000800323 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800323:	55                   	push   %rbp
  800324:	48 89 e5             	mov    %rsp,%rbp
  800327:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80032e:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800335:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80033c:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800343:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80034a:	48 8b 0a             	mov    (%rdx),%rcx
  80034d:	48 89 08             	mov    %rcx,(%rax)
  800350:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800354:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800358:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80035c:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800360:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800367:	00 00 00 
    b.cnt = 0;
  80036a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800371:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800374:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80037b:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800382:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800389:	48 89 c6             	mov    %rax,%rsi
  80038c:	48 bf aa 02 80 00 00 	movabs $0x8002aa,%rdi
  800393:	00 00 00 
  800396:	48 b8 82 07 80 00 00 	movabs $0x800782,%rax
  80039d:	00 00 00 
  8003a0:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8003a2:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8003a8:	48 98                	cltq   
  8003aa:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8003b1:	48 83 c2 08          	add    $0x8,%rdx
  8003b5:	48 89 c6             	mov    %rax,%rsi
  8003b8:	48 89 d7             	mov    %rdx,%rdi
  8003bb:	48 b8 6b 17 80 00 00 	movabs $0x80176b,%rax
  8003c2:	00 00 00 
  8003c5:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8003c7:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8003cd:	c9                   	leaveq 
  8003ce:	c3                   	retq   

00000000008003cf <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8003cf:	55                   	push   %rbp
  8003d0:	48 89 e5             	mov    %rsp,%rbp
  8003d3:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8003da:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8003e1:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8003e8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8003ef:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8003f6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8003fd:	84 c0                	test   %al,%al
  8003ff:	74 20                	je     800421 <cprintf+0x52>
  800401:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800405:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800409:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80040d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800411:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800415:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800419:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80041d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800421:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800428:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80042f:	00 00 00 
  800432:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800439:	00 00 00 
  80043c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800440:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800447:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80044e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800455:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80045c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800463:	48 8b 0a             	mov    (%rdx),%rcx
  800466:	48 89 08             	mov    %rcx,(%rax)
  800469:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80046d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800471:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800475:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800479:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800480:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800487:	48 89 d6             	mov    %rdx,%rsi
  80048a:	48 89 c7             	mov    %rax,%rdi
  80048d:	48 b8 23 03 80 00 00 	movabs $0x800323,%rax
  800494:	00 00 00 
  800497:	ff d0                	callq  *%rax
  800499:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80049f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8004a5:	c9                   	leaveq 
  8004a6:	c3                   	retq   

00000000008004a7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004a7:	55                   	push   %rbp
  8004a8:	48 89 e5             	mov    %rsp,%rbp
  8004ab:	53                   	push   %rbx
  8004ac:	48 83 ec 38          	sub    $0x38,%rsp
  8004b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004b4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004b8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8004bc:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8004bf:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8004c3:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004c7:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8004ca:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8004ce:	77 3b                	ja     80050b <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004d0:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8004d3:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8004d7:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8004da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004de:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e3:	48 f7 f3             	div    %rbx
  8004e6:	48 89 c2             	mov    %rax,%rdx
  8004e9:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8004ec:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8004ef:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8004f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f7:	41 89 f9             	mov    %edi,%r9d
  8004fa:	48 89 c7             	mov    %rax,%rdi
  8004fd:	48 b8 a7 04 80 00 00 	movabs $0x8004a7,%rax
  800504:	00 00 00 
  800507:	ff d0                	callq  *%rax
  800509:	eb 1e                	jmp    800529 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80050b:	eb 12                	jmp    80051f <printnum+0x78>
			putch(padc, putdat);
  80050d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800511:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800514:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800518:	48 89 ce             	mov    %rcx,%rsi
  80051b:	89 d7                	mov    %edx,%edi
  80051d:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80051f:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800523:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800527:	7f e4                	jg     80050d <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800529:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80052c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800530:	ba 00 00 00 00       	mov    $0x0,%edx
  800535:	48 f7 f1             	div    %rcx
  800538:	48 89 d0             	mov    %rdx,%rax
  80053b:	48 ba 30 3f 80 00 00 	movabs $0x803f30,%rdx
  800542:	00 00 00 
  800545:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800549:	0f be d0             	movsbl %al,%edx
  80054c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800550:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800554:	48 89 ce             	mov    %rcx,%rsi
  800557:	89 d7                	mov    %edx,%edi
  800559:	ff d0                	callq  *%rax
}
  80055b:	48 83 c4 38          	add    $0x38,%rsp
  80055f:	5b                   	pop    %rbx
  800560:	5d                   	pop    %rbp
  800561:	c3                   	retq   

0000000000800562 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800562:	55                   	push   %rbp
  800563:	48 89 e5             	mov    %rsp,%rbp
  800566:	48 83 ec 1c          	sub    $0x1c,%rsp
  80056a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80056e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800571:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800575:	7e 52                	jle    8005c9 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800577:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057b:	8b 00                	mov    (%rax),%eax
  80057d:	83 f8 30             	cmp    $0x30,%eax
  800580:	73 24                	jae    8005a6 <getuint+0x44>
  800582:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800586:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80058a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058e:	8b 00                	mov    (%rax),%eax
  800590:	89 c0                	mov    %eax,%eax
  800592:	48 01 d0             	add    %rdx,%rax
  800595:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800599:	8b 12                	mov    (%rdx),%edx
  80059b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80059e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a2:	89 0a                	mov    %ecx,(%rdx)
  8005a4:	eb 17                	jmp    8005bd <getuint+0x5b>
  8005a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005aa:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005ae:	48 89 d0             	mov    %rdx,%rax
  8005b1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005bd:	48 8b 00             	mov    (%rax),%rax
  8005c0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005c4:	e9 a3 00 00 00       	jmpq   80066c <getuint+0x10a>
	else if (lflag)
  8005c9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005cd:	74 4f                	je     80061e <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8005cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d3:	8b 00                	mov    (%rax),%eax
  8005d5:	83 f8 30             	cmp    $0x30,%eax
  8005d8:	73 24                	jae    8005fe <getuint+0x9c>
  8005da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005de:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e6:	8b 00                	mov    (%rax),%eax
  8005e8:	89 c0                	mov    %eax,%eax
  8005ea:	48 01 d0             	add    %rdx,%rax
  8005ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f1:	8b 12                	mov    (%rdx),%edx
  8005f3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005fa:	89 0a                	mov    %ecx,(%rdx)
  8005fc:	eb 17                	jmp    800615 <getuint+0xb3>
  8005fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800602:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800606:	48 89 d0             	mov    %rdx,%rax
  800609:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80060d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800611:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800615:	48 8b 00             	mov    (%rax),%rax
  800618:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80061c:	eb 4e                	jmp    80066c <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80061e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800622:	8b 00                	mov    (%rax),%eax
  800624:	83 f8 30             	cmp    $0x30,%eax
  800627:	73 24                	jae    80064d <getuint+0xeb>
  800629:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80062d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800631:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800635:	8b 00                	mov    (%rax),%eax
  800637:	89 c0                	mov    %eax,%eax
  800639:	48 01 d0             	add    %rdx,%rax
  80063c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800640:	8b 12                	mov    (%rdx),%edx
  800642:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800645:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800649:	89 0a                	mov    %ecx,(%rdx)
  80064b:	eb 17                	jmp    800664 <getuint+0x102>
  80064d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800651:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800655:	48 89 d0             	mov    %rdx,%rax
  800658:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80065c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800660:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800664:	8b 00                	mov    (%rax),%eax
  800666:	89 c0                	mov    %eax,%eax
  800668:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80066c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800670:	c9                   	leaveq 
  800671:	c3                   	retq   

0000000000800672 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800672:	55                   	push   %rbp
  800673:	48 89 e5             	mov    %rsp,%rbp
  800676:	48 83 ec 1c          	sub    $0x1c,%rsp
  80067a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80067e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800681:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800685:	7e 52                	jle    8006d9 <getint+0x67>
		x=va_arg(*ap, long long);
  800687:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068b:	8b 00                	mov    (%rax),%eax
  80068d:	83 f8 30             	cmp    $0x30,%eax
  800690:	73 24                	jae    8006b6 <getint+0x44>
  800692:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800696:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80069a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069e:	8b 00                	mov    (%rax),%eax
  8006a0:	89 c0                	mov    %eax,%eax
  8006a2:	48 01 d0             	add    %rdx,%rax
  8006a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a9:	8b 12                	mov    (%rdx),%edx
  8006ab:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b2:	89 0a                	mov    %ecx,(%rdx)
  8006b4:	eb 17                	jmp    8006cd <getint+0x5b>
  8006b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ba:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006be:	48 89 d0             	mov    %rdx,%rax
  8006c1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006cd:	48 8b 00             	mov    (%rax),%rax
  8006d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006d4:	e9 a3 00 00 00       	jmpq   80077c <getint+0x10a>
	else if (lflag)
  8006d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006dd:	74 4f                	je     80072e <getint+0xbc>
		x=va_arg(*ap, long);
  8006df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e3:	8b 00                	mov    (%rax),%eax
  8006e5:	83 f8 30             	cmp    $0x30,%eax
  8006e8:	73 24                	jae    80070e <getint+0x9c>
  8006ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ee:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f6:	8b 00                	mov    (%rax),%eax
  8006f8:	89 c0                	mov    %eax,%eax
  8006fa:	48 01 d0             	add    %rdx,%rax
  8006fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800701:	8b 12                	mov    (%rdx),%edx
  800703:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800706:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070a:	89 0a                	mov    %ecx,(%rdx)
  80070c:	eb 17                	jmp    800725 <getint+0xb3>
  80070e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800712:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800716:	48 89 d0             	mov    %rdx,%rax
  800719:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80071d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800721:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800725:	48 8b 00             	mov    (%rax),%rax
  800728:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80072c:	eb 4e                	jmp    80077c <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80072e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800732:	8b 00                	mov    (%rax),%eax
  800734:	83 f8 30             	cmp    $0x30,%eax
  800737:	73 24                	jae    80075d <getint+0xeb>
  800739:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800741:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800745:	8b 00                	mov    (%rax),%eax
  800747:	89 c0                	mov    %eax,%eax
  800749:	48 01 d0             	add    %rdx,%rax
  80074c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800750:	8b 12                	mov    (%rdx),%edx
  800752:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800755:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800759:	89 0a                	mov    %ecx,(%rdx)
  80075b:	eb 17                	jmp    800774 <getint+0x102>
  80075d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800761:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800765:	48 89 d0             	mov    %rdx,%rax
  800768:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80076c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800770:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800774:	8b 00                	mov    (%rax),%eax
  800776:	48 98                	cltq   
  800778:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80077c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800780:	c9                   	leaveq 
  800781:	c3                   	retq   

0000000000800782 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800782:	55                   	push   %rbp
  800783:	48 89 e5             	mov    %rsp,%rbp
  800786:	41 54                	push   %r12
  800788:	53                   	push   %rbx
  800789:	48 83 ec 60          	sub    $0x60,%rsp
  80078d:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800791:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800795:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800799:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80079d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8007a1:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8007a5:	48 8b 0a             	mov    (%rdx),%rcx
  8007a8:	48 89 08             	mov    %rcx,(%rax)
  8007ab:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007af:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007b3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007b7:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007bb:	eb 17                	jmp    8007d4 <vprintfmt+0x52>
			if (ch == '\0')
  8007bd:	85 db                	test   %ebx,%ebx
  8007bf:	0f 84 cc 04 00 00    	je     800c91 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8007c5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8007c9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007cd:	48 89 d6             	mov    %rdx,%rsi
  8007d0:	89 df                	mov    %ebx,%edi
  8007d2:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007d8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8007dc:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007e0:	0f b6 00             	movzbl (%rax),%eax
  8007e3:	0f b6 d8             	movzbl %al,%ebx
  8007e6:	83 fb 25             	cmp    $0x25,%ebx
  8007e9:	75 d2                	jne    8007bd <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007eb:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8007ef:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8007f6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8007fd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800804:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80080b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80080f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800813:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800817:	0f b6 00             	movzbl (%rax),%eax
  80081a:	0f b6 d8             	movzbl %al,%ebx
  80081d:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800820:	83 f8 55             	cmp    $0x55,%eax
  800823:	0f 87 34 04 00 00    	ja     800c5d <vprintfmt+0x4db>
  800829:	89 c0                	mov    %eax,%eax
  80082b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800832:	00 
  800833:	48 b8 58 3f 80 00 00 	movabs $0x803f58,%rax
  80083a:	00 00 00 
  80083d:	48 01 d0             	add    %rdx,%rax
  800840:	48 8b 00             	mov    (%rax),%rax
  800843:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800845:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800849:	eb c0                	jmp    80080b <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80084b:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80084f:	eb ba                	jmp    80080b <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800851:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800858:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80085b:	89 d0                	mov    %edx,%eax
  80085d:	c1 e0 02             	shl    $0x2,%eax
  800860:	01 d0                	add    %edx,%eax
  800862:	01 c0                	add    %eax,%eax
  800864:	01 d8                	add    %ebx,%eax
  800866:	83 e8 30             	sub    $0x30,%eax
  800869:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80086c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800870:	0f b6 00             	movzbl (%rax),%eax
  800873:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800876:	83 fb 2f             	cmp    $0x2f,%ebx
  800879:	7e 0c                	jle    800887 <vprintfmt+0x105>
  80087b:	83 fb 39             	cmp    $0x39,%ebx
  80087e:	7f 07                	jg     800887 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800880:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800885:	eb d1                	jmp    800858 <vprintfmt+0xd6>
			goto process_precision;
  800887:	eb 58                	jmp    8008e1 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800889:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80088c:	83 f8 30             	cmp    $0x30,%eax
  80088f:	73 17                	jae    8008a8 <vprintfmt+0x126>
  800891:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800895:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800898:	89 c0                	mov    %eax,%eax
  80089a:	48 01 d0             	add    %rdx,%rax
  80089d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008a0:	83 c2 08             	add    $0x8,%edx
  8008a3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008a6:	eb 0f                	jmp    8008b7 <vprintfmt+0x135>
  8008a8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008ac:	48 89 d0             	mov    %rdx,%rax
  8008af:	48 83 c2 08          	add    $0x8,%rdx
  8008b3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008b7:	8b 00                	mov    (%rax),%eax
  8008b9:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8008bc:	eb 23                	jmp    8008e1 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8008be:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008c2:	79 0c                	jns    8008d0 <vprintfmt+0x14e>
				width = 0;
  8008c4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8008cb:	e9 3b ff ff ff       	jmpq   80080b <vprintfmt+0x89>
  8008d0:	e9 36 ff ff ff       	jmpq   80080b <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8008d5:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8008dc:	e9 2a ff ff ff       	jmpq   80080b <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8008e1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008e5:	79 12                	jns    8008f9 <vprintfmt+0x177>
				width = precision, precision = -1;
  8008e7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008ea:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8008ed:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8008f4:	e9 12 ff ff ff       	jmpq   80080b <vprintfmt+0x89>
  8008f9:	e9 0d ff ff ff       	jmpq   80080b <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008fe:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800902:	e9 04 ff ff ff       	jmpq   80080b <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800907:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80090a:	83 f8 30             	cmp    $0x30,%eax
  80090d:	73 17                	jae    800926 <vprintfmt+0x1a4>
  80090f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800913:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800916:	89 c0                	mov    %eax,%eax
  800918:	48 01 d0             	add    %rdx,%rax
  80091b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80091e:	83 c2 08             	add    $0x8,%edx
  800921:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800924:	eb 0f                	jmp    800935 <vprintfmt+0x1b3>
  800926:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80092a:	48 89 d0             	mov    %rdx,%rax
  80092d:	48 83 c2 08          	add    $0x8,%rdx
  800931:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800935:	8b 10                	mov    (%rax),%edx
  800937:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80093b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80093f:	48 89 ce             	mov    %rcx,%rsi
  800942:	89 d7                	mov    %edx,%edi
  800944:	ff d0                	callq  *%rax
			break;
  800946:	e9 40 03 00 00       	jmpq   800c8b <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80094b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80094e:	83 f8 30             	cmp    $0x30,%eax
  800951:	73 17                	jae    80096a <vprintfmt+0x1e8>
  800953:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800957:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80095a:	89 c0                	mov    %eax,%eax
  80095c:	48 01 d0             	add    %rdx,%rax
  80095f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800962:	83 c2 08             	add    $0x8,%edx
  800965:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800968:	eb 0f                	jmp    800979 <vprintfmt+0x1f7>
  80096a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80096e:	48 89 d0             	mov    %rdx,%rax
  800971:	48 83 c2 08          	add    $0x8,%rdx
  800975:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800979:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80097b:	85 db                	test   %ebx,%ebx
  80097d:	79 02                	jns    800981 <vprintfmt+0x1ff>
				err = -err;
  80097f:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800981:	83 fb 15             	cmp    $0x15,%ebx
  800984:	7f 16                	jg     80099c <vprintfmt+0x21a>
  800986:	48 b8 80 3e 80 00 00 	movabs $0x803e80,%rax
  80098d:	00 00 00 
  800990:	48 63 d3             	movslq %ebx,%rdx
  800993:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800997:	4d 85 e4             	test   %r12,%r12
  80099a:	75 2e                	jne    8009ca <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  80099c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8009a0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009a4:	89 d9                	mov    %ebx,%ecx
  8009a6:	48 ba 41 3f 80 00 00 	movabs $0x803f41,%rdx
  8009ad:	00 00 00 
  8009b0:	48 89 c7             	mov    %rax,%rdi
  8009b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b8:	49 b8 9a 0c 80 00 00 	movabs $0x800c9a,%r8
  8009bf:	00 00 00 
  8009c2:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009c5:	e9 c1 02 00 00       	jmpq   800c8b <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009ca:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8009ce:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009d2:	4c 89 e1             	mov    %r12,%rcx
  8009d5:	48 ba 4a 3f 80 00 00 	movabs $0x803f4a,%rdx
  8009dc:	00 00 00 
  8009df:	48 89 c7             	mov    %rax,%rdi
  8009e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e7:	49 b8 9a 0c 80 00 00 	movabs $0x800c9a,%r8
  8009ee:	00 00 00 
  8009f1:	41 ff d0             	callq  *%r8
			break;
  8009f4:	e9 92 02 00 00       	jmpq   800c8b <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8009f9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009fc:	83 f8 30             	cmp    $0x30,%eax
  8009ff:	73 17                	jae    800a18 <vprintfmt+0x296>
  800a01:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a05:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a08:	89 c0                	mov    %eax,%eax
  800a0a:	48 01 d0             	add    %rdx,%rax
  800a0d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a10:	83 c2 08             	add    $0x8,%edx
  800a13:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a16:	eb 0f                	jmp    800a27 <vprintfmt+0x2a5>
  800a18:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a1c:	48 89 d0             	mov    %rdx,%rax
  800a1f:	48 83 c2 08          	add    $0x8,%rdx
  800a23:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a27:	4c 8b 20             	mov    (%rax),%r12
  800a2a:	4d 85 e4             	test   %r12,%r12
  800a2d:	75 0a                	jne    800a39 <vprintfmt+0x2b7>
				p = "(null)";
  800a2f:	49 bc 4d 3f 80 00 00 	movabs $0x803f4d,%r12
  800a36:	00 00 00 
			if (width > 0 && padc != '-')
  800a39:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a3d:	7e 3f                	jle    800a7e <vprintfmt+0x2fc>
  800a3f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800a43:	74 39                	je     800a7e <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a45:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a48:	48 98                	cltq   
  800a4a:	48 89 c6             	mov    %rax,%rsi
  800a4d:	4c 89 e7             	mov    %r12,%rdi
  800a50:	48 b8 46 0f 80 00 00 	movabs $0x800f46,%rax
  800a57:	00 00 00 
  800a5a:	ff d0                	callq  *%rax
  800a5c:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800a5f:	eb 17                	jmp    800a78 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800a61:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800a65:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a69:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a6d:	48 89 ce             	mov    %rcx,%rsi
  800a70:	89 d7                	mov    %edx,%edi
  800a72:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a74:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a78:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a7c:	7f e3                	jg     800a61 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a7e:	eb 37                	jmp    800ab7 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800a80:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800a84:	74 1e                	je     800aa4 <vprintfmt+0x322>
  800a86:	83 fb 1f             	cmp    $0x1f,%ebx
  800a89:	7e 05                	jle    800a90 <vprintfmt+0x30e>
  800a8b:	83 fb 7e             	cmp    $0x7e,%ebx
  800a8e:	7e 14                	jle    800aa4 <vprintfmt+0x322>
					putch('?', putdat);
  800a90:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a94:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a98:	48 89 d6             	mov    %rdx,%rsi
  800a9b:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800aa0:	ff d0                	callq  *%rax
  800aa2:	eb 0f                	jmp    800ab3 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800aa4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aa8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aac:	48 89 d6             	mov    %rdx,%rsi
  800aaf:	89 df                	mov    %ebx,%edi
  800ab1:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ab3:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ab7:	4c 89 e0             	mov    %r12,%rax
  800aba:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800abe:	0f b6 00             	movzbl (%rax),%eax
  800ac1:	0f be d8             	movsbl %al,%ebx
  800ac4:	85 db                	test   %ebx,%ebx
  800ac6:	74 10                	je     800ad8 <vprintfmt+0x356>
  800ac8:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800acc:	78 b2                	js     800a80 <vprintfmt+0x2fe>
  800ace:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800ad2:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ad6:	79 a8                	jns    800a80 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ad8:	eb 16                	jmp    800af0 <vprintfmt+0x36e>
				putch(' ', putdat);
  800ada:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ade:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae2:	48 89 d6             	mov    %rdx,%rsi
  800ae5:	bf 20 00 00 00       	mov    $0x20,%edi
  800aea:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aec:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800af0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800af4:	7f e4                	jg     800ada <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800af6:	e9 90 01 00 00       	jmpq   800c8b <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800afb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800aff:	be 03 00 00 00       	mov    $0x3,%esi
  800b04:	48 89 c7             	mov    %rax,%rdi
  800b07:	48 b8 72 06 80 00 00 	movabs $0x800672,%rax
  800b0e:	00 00 00 
  800b11:	ff d0                	callq  *%rax
  800b13:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800b17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b1b:	48 85 c0             	test   %rax,%rax
  800b1e:	79 1d                	jns    800b3d <vprintfmt+0x3bb>
				putch('-', putdat);
  800b20:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b24:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b28:	48 89 d6             	mov    %rdx,%rsi
  800b2b:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800b30:	ff d0                	callq  *%rax
				num = -(long long) num;
  800b32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b36:	48 f7 d8             	neg    %rax
  800b39:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800b3d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b44:	e9 d5 00 00 00       	jmpq   800c1e <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800b49:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b4d:	be 03 00 00 00       	mov    $0x3,%esi
  800b52:	48 89 c7             	mov    %rax,%rdi
  800b55:	48 b8 62 05 80 00 00 	movabs $0x800562,%rax
  800b5c:	00 00 00 
  800b5f:	ff d0                	callq  *%rax
  800b61:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800b65:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b6c:	e9 ad 00 00 00       	jmpq   800c1e <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  800b71:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b75:	be 03 00 00 00       	mov    $0x3,%esi
  800b7a:	48 89 c7             	mov    %rax,%rdi
  800b7d:	48 b8 62 05 80 00 00 	movabs $0x800562,%rax
  800b84:	00 00 00 
  800b87:	ff d0                	callq  *%rax
  800b89:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  800b8d:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  800b94:	e9 85 00 00 00       	jmpq   800c1e <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  800b99:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b9d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba1:	48 89 d6             	mov    %rdx,%rsi
  800ba4:	bf 30 00 00 00       	mov    $0x30,%edi
  800ba9:	ff d0                	callq  *%rax
			putch('x', putdat);
  800bab:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800baf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb3:	48 89 d6             	mov    %rdx,%rsi
  800bb6:	bf 78 00 00 00       	mov    $0x78,%edi
  800bbb:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800bbd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc0:	83 f8 30             	cmp    $0x30,%eax
  800bc3:	73 17                	jae    800bdc <vprintfmt+0x45a>
  800bc5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bc9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bcc:	89 c0                	mov    %eax,%eax
  800bce:	48 01 d0             	add    %rdx,%rax
  800bd1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bd4:	83 c2 08             	add    $0x8,%edx
  800bd7:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bda:	eb 0f                	jmp    800beb <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800bdc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800be0:	48 89 d0             	mov    %rdx,%rax
  800be3:	48 83 c2 08          	add    $0x8,%rdx
  800be7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800beb:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bee:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800bf2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800bf9:	eb 23                	jmp    800c1e <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800bfb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bff:	be 03 00 00 00       	mov    $0x3,%esi
  800c04:	48 89 c7             	mov    %rax,%rdi
  800c07:	48 b8 62 05 80 00 00 	movabs $0x800562,%rax
  800c0e:	00 00 00 
  800c11:	ff d0                	callq  *%rax
  800c13:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800c17:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c1e:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800c23:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800c26:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800c29:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c2d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c31:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c35:	45 89 c1             	mov    %r8d,%r9d
  800c38:	41 89 f8             	mov    %edi,%r8d
  800c3b:	48 89 c7             	mov    %rax,%rdi
  800c3e:	48 b8 a7 04 80 00 00 	movabs $0x8004a7,%rax
  800c45:	00 00 00 
  800c48:	ff d0                	callq  *%rax
			break;
  800c4a:	eb 3f                	jmp    800c8b <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c4c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c50:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c54:	48 89 d6             	mov    %rdx,%rsi
  800c57:	89 df                	mov    %ebx,%edi
  800c59:	ff d0                	callq  *%rax
			break;
  800c5b:	eb 2e                	jmp    800c8b <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c5d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c61:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c65:	48 89 d6             	mov    %rdx,%rsi
  800c68:	bf 25 00 00 00       	mov    $0x25,%edi
  800c6d:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c6f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c74:	eb 05                	jmp    800c7b <vprintfmt+0x4f9>
  800c76:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c7b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c7f:	48 83 e8 01          	sub    $0x1,%rax
  800c83:	0f b6 00             	movzbl (%rax),%eax
  800c86:	3c 25                	cmp    $0x25,%al
  800c88:	75 ec                	jne    800c76 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800c8a:	90                   	nop
		}
	}
  800c8b:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c8c:	e9 43 fb ff ff       	jmpq   8007d4 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800c91:	48 83 c4 60          	add    $0x60,%rsp
  800c95:	5b                   	pop    %rbx
  800c96:	41 5c                	pop    %r12
  800c98:	5d                   	pop    %rbp
  800c99:	c3                   	retq   

0000000000800c9a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c9a:	55                   	push   %rbp
  800c9b:	48 89 e5             	mov    %rsp,%rbp
  800c9e:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800ca5:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800cac:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800cb3:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cba:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800cc1:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800cc8:	84 c0                	test   %al,%al
  800cca:	74 20                	je     800cec <printfmt+0x52>
  800ccc:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800cd0:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800cd4:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800cd8:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800cdc:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ce0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ce4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ce8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800cec:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800cf3:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800cfa:	00 00 00 
  800cfd:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800d04:	00 00 00 
  800d07:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d0b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800d12:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d19:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800d20:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800d27:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800d2e:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800d35:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800d3c:	48 89 c7             	mov    %rax,%rdi
  800d3f:	48 b8 82 07 80 00 00 	movabs $0x800782,%rax
  800d46:	00 00 00 
  800d49:	ff d0                	callq  *%rax
	va_end(ap);
}
  800d4b:	c9                   	leaveq 
  800d4c:	c3                   	retq   

0000000000800d4d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d4d:	55                   	push   %rbp
  800d4e:	48 89 e5             	mov    %rsp,%rbp
  800d51:	48 83 ec 10          	sub    $0x10,%rsp
  800d55:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d58:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800d5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d60:	8b 40 10             	mov    0x10(%rax),%eax
  800d63:	8d 50 01             	lea    0x1(%rax),%edx
  800d66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d6a:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800d6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d71:	48 8b 10             	mov    (%rax),%rdx
  800d74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d78:	48 8b 40 08          	mov    0x8(%rax),%rax
  800d7c:	48 39 c2             	cmp    %rax,%rdx
  800d7f:	73 17                	jae    800d98 <sprintputch+0x4b>
		*b->buf++ = ch;
  800d81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d85:	48 8b 00             	mov    (%rax),%rax
  800d88:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800d8c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d90:	48 89 0a             	mov    %rcx,(%rdx)
  800d93:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d96:	88 10                	mov    %dl,(%rax)
}
  800d98:	c9                   	leaveq 
  800d99:	c3                   	retq   

0000000000800d9a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d9a:	55                   	push   %rbp
  800d9b:	48 89 e5             	mov    %rsp,%rbp
  800d9e:	48 83 ec 50          	sub    $0x50,%rsp
  800da2:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800da6:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800da9:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800dad:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800db1:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800db5:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800db9:	48 8b 0a             	mov    (%rdx),%rcx
  800dbc:	48 89 08             	mov    %rcx,(%rax)
  800dbf:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800dc3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800dc7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dcb:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dcf:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800dd3:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800dd7:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800dda:	48 98                	cltq   
  800ddc:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800de0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800de4:	48 01 d0             	add    %rdx,%rax
  800de7:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800deb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800df2:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800df7:	74 06                	je     800dff <vsnprintf+0x65>
  800df9:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800dfd:	7f 07                	jg     800e06 <vsnprintf+0x6c>
		return -E_INVAL;
  800dff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e04:	eb 2f                	jmp    800e35 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800e06:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800e0a:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800e0e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e12:	48 89 c6             	mov    %rax,%rsi
  800e15:	48 bf 4d 0d 80 00 00 	movabs $0x800d4d,%rdi
  800e1c:	00 00 00 
  800e1f:	48 b8 82 07 80 00 00 	movabs $0x800782,%rax
  800e26:	00 00 00 
  800e29:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800e2b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e2f:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800e32:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800e35:	c9                   	leaveq 
  800e36:	c3                   	retq   

0000000000800e37 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e37:	55                   	push   %rbp
  800e38:	48 89 e5             	mov    %rsp,%rbp
  800e3b:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800e42:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800e49:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800e4f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e56:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e5d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e64:	84 c0                	test   %al,%al
  800e66:	74 20                	je     800e88 <snprintf+0x51>
  800e68:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e6c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e70:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e74:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e78:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e7c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e80:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e84:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e88:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800e8f:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800e96:	00 00 00 
  800e99:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800ea0:	00 00 00 
  800ea3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ea7:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800eae:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800eb5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800ebc:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800ec3:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800eca:	48 8b 0a             	mov    (%rdx),%rcx
  800ecd:	48 89 08             	mov    %rcx,(%rax)
  800ed0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ed4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ed8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800edc:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800ee0:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800ee7:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800eee:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800ef4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800efb:	48 89 c7             	mov    %rax,%rdi
  800efe:	48 b8 9a 0d 80 00 00 	movabs $0x800d9a,%rax
  800f05:	00 00 00 
  800f08:	ff d0                	callq  *%rax
  800f0a:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800f10:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800f16:	c9                   	leaveq 
  800f17:	c3                   	retq   

0000000000800f18 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f18:	55                   	push   %rbp
  800f19:	48 89 e5             	mov    %rsp,%rbp
  800f1c:	48 83 ec 18          	sub    $0x18,%rsp
  800f20:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800f24:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f2b:	eb 09                	jmp    800f36 <strlen+0x1e>
		n++;
  800f2d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f31:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f3a:	0f b6 00             	movzbl (%rax),%eax
  800f3d:	84 c0                	test   %al,%al
  800f3f:	75 ec                	jne    800f2d <strlen+0x15>
		n++;
	return n;
  800f41:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f44:	c9                   	leaveq 
  800f45:	c3                   	retq   

0000000000800f46 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800f46:	55                   	push   %rbp
  800f47:	48 89 e5             	mov    %rsp,%rbp
  800f4a:	48 83 ec 20          	sub    $0x20,%rsp
  800f4e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f52:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f56:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f5d:	eb 0e                	jmp    800f6d <strnlen+0x27>
		n++;
  800f5f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f63:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f68:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800f6d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800f72:	74 0b                	je     800f7f <strnlen+0x39>
  800f74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f78:	0f b6 00             	movzbl (%rax),%eax
  800f7b:	84 c0                	test   %al,%al
  800f7d:	75 e0                	jne    800f5f <strnlen+0x19>
		n++;
	return n;
  800f7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f82:	c9                   	leaveq 
  800f83:	c3                   	retq   

0000000000800f84 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f84:	55                   	push   %rbp
  800f85:	48 89 e5             	mov    %rsp,%rbp
  800f88:	48 83 ec 20          	sub    $0x20,%rsp
  800f8c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f90:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800f94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f98:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800f9c:	90                   	nop
  800f9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fa5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fa9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fad:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800fb1:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800fb5:	0f b6 12             	movzbl (%rdx),%edx
  800fb8:	88 10                	mov    %dl,(%rax)
  800fba:	0f b6 00             	movzbl (%rax),%eax
  800fbd:	84 c0                	test   %al,%al
  800fbf:	75 dc                	jne    800f9d <strcpy+0x19>
		/* do nothing */;
	return ret;
  800fc1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800fc5:	c9                   	leaveq 
  800fc6:	c3                   	retq   

0000000000800fc7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800fc7:	55                   	push   %rbp
  800fc8:	48 89 e5             	mov    %rsp,%rbp
  800fcb:	48 83 ec 20          	sub    $0x20,%rsp
  800fcf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fd3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800fd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fdb:	48 89 c7             	mov    %rax,%rdi
  800fde:	48 b8 18 0f 80 00 00 	movabs $0x800f18,%rax
  800fe5:	00 00 00 
  800fe8:	ff d0                	callq  *%rax
  800fea:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800fed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ff0:	48 63 d0             	movslq %eax,%rdx
  800ff3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff7:	48 01 c2             	add    %rax,%rdx
  800ffa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ffe:	48 89 c6             	mov    %rax,%rsi
  801001:	48 89 d7             	mov    %rdx,%rdi
  801004:	48 b8 84 0f 80 00 00 	movabs $0x800f84,%rax
  80100b:	00 00 00 
  80100e:	ff d0                	callq  *%rax
	return dst;
  801010:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801014:	c9                   	leaveq 
  801015:	c3                   	retq   

0000000000801016 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801016:	55                   	push   %rbp
  801017:	48 89 e5             	mov    %rsp,%rbp
  80101a:	48 83 ec 28          	sub    $0x28,%rsp
  80101e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801022:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801026:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80102a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80102e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801032:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801039:	00 
  80103a:	eb 2a                	jmp    801066 <strncpy+0x50>
		*dst++ = *src;
  80103c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801040:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801044:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801048:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80104c:	0f b6 12             	movzbl (%rdx),%edx
  80104f:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801051:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801055:	0f b6 00             	movzbl (%rax),%eax
  801058:	84 c0                	test   %al,%al
  80105a:	74 05                	je     801061 <strncpy+0x4b>
			src++;
  80105c:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801061:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801066:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80106a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80106e:	72 cc                	jb     80103c <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801070:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801074:	c9                   	leaveq 
  801075:	c3                   	retq   

0000000000801076 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801076:	55                   	push   %rbp
  801077:	48 89 e5             	mov    %rsp,%rbp
  80107a:	48 83 ec 28          	sub    $0x28,%rsp
  80107e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801082:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801086:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80108a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801092:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801097:	74 3d                	je     8010d6 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801099:	eb 1d                	jmp    8010b8 <strlcpy+0x42>
			*dst++ = *src++;
  80109b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80109f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010a3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010a7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010ab:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010af:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010b3:	0f b6 12             	movzbl (%rdx),%edx
  8010b6:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010b8:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8010bd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8010c2:	74 0b                	je     8010cf <strlcpy+0x59>
  8010c4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010c8:	0f b6 00             	movzbl (%rax),%eax
  8010cb:	84 c0                	test   %al,%al
  8010cd:	75 cc                	jne    80109b <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8010cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d3:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8010d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010de:	48 29 c2             	sub    %rax,%rdx
  8010e1:	48 89 d0             	mov    %rdx,%rax
}
  8010e4:	c9                   	leaveq 
  8010e5:	c3                   	retq   

00000000008010e6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010e6:	55                   	push   %rbp
  8010e7:	48 89 e5             	mov    %rsp,%rbp
  8010ea:	48 83 ec 10          	sub    $0x10,%rsp
  8010ee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010f2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8010f6:	eb 0a                	jmp    801102 <strcmp+0x1c>
		p++, q++;
  8010f8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010fd:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801102:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801106:	0f b6 00             	movzbl (%rax),%eax
  801109:	84 c0                	test   %al,%al
  80110b:	74 12                	je     80111f <strcmp+0x39>
  80110d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801111:	0f b6 10             	movzbl (%rax),%edx
  801114:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801118:	0f b6 00             	movzbl (%rax),%eax
  80111b:	38 c2                	cmp    %al,%dl
  80111d:	74 d9                	je     8010f8 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80111f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801123:	0f b6 00             	movzbl (%rax),%eax
  801126:	0f b6 d0             	movzbl %al,%edx
  801129:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80112d:	0f b6 00             	movzbl (%rax),%eax
  801130:	0f b6 c0             	movzbl %al,%eax
  801133:	29 c2                	sub    %eax,%edx
  801135:	89 d0                	mov    %edx,%eax
}
  801137:	c9                   	leaveq 
  801138:	c3                   	retq   

0000000000801139 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801139:	55                   	push   %rbp
  80113a:	48 89 e5             	mov    %rsp,%rbp
  80113d:	48 83 ec 18          	sub    $0x18,%rsp
  801141:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801145:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801149:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80114d:	eb 0f                	jmp    80115e <strncmp+0x25>
		n--, p++, q++;
  80114f:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801154:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801159:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80115e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801163:	74 1d                	je     801182 <strncmp+0x49>
  801165:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801169:	0f b6 00             	movzbl (%rax),%eax
  80116c:	84 c0                	test   %al,%al
  80116e:	74 12                	je     801182 <strncmp+0x49>
  801170:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801174:	0f b6 10             	movzbl (%rax),%edx
  801177:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80117b:	0f b6 00             	movzbl (%rax),%eax
  80117e:	38 c2                	cmp    %al,%dl
  801180:	74 cd                	je     80114f <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801182:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801187:	75 07                	jne    801190 <strncmp+0x57>
		return 0;
  801189:	b8 00 00 00 00       	mov    $0x0,%eax
  80118e:	eb 18                	jmp    8011a8 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801190:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801194:	0f b6 00             	movzbl (%rax),%eax
  801197:	0f b6 d0             	movzbl %al,%edx
  80119a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80119e:	0f b6 00             	movzbl (%rax),%eax
  8011a1:	0f b6 c0             	movzbl %al,%eax
  8011a4:	29 c2                	sub    %eax,%edx
  8011a6:	89 d0                	mov    %edx,%eax
}
  8011a8:	c9                   	leaveq 
  8011a9:	c3                   	retq   

00000000008011aa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011aa:	55                   	push   %rbp
  8011ab:	48 89 e5             	mov    %rsp,%rbp
  8011ae:	48 83 ec 0c          	sub    $0xc,%rsp
  8011b2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011b6:	89 f0                	mov    %esi,%eax
  8011b8:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011bb:	eb 17                	jmp    8011d4 <strchr+0x2a>
		if (*s == c)
  8011bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c1:	0f b6 00             	movzbl (%rax),%eax
  8011c4:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8011c7:	75 06                	jne    8011cf <strchr+0x25>
			return (char *) s;
  8011c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011cd:	eb 15                	jmp    8011e4 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011cf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d8:	0f b6 00             	movzbl (%rax),%eax
  8011db:	84 c0                	test   %al,%al
  8011dd:	75 de                	jne    8011bd <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8011df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011e4:	c9                   	leaveq 
  8011e5:	c3                   	retq   

00000000008011e6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011e6:	55                   	push   %rbp
  8011e7:	48 89 e5             	mov    %rsp,%rbp
  8011ea:	48 83 ec 0c          	sub    $0xc,%rsp
  8011ee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011f2:	89 f0                	mov    %esi,%eax
  8011f4:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011f7:	eb 13                	jmp    80120c <strfind+0x26>
		if (*s == c)
  8011f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011fd:	0f b6 00             	movzbl (%rax),%eax
  801200:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801203:	75 02                	jne    801207 <strfind+0x21>
			break;
  801205:	eb 10                	jmp    801217 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801207:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80120c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801210:	0f b6 00             	movzbl (%rax),%eax
  801213:	84 c0                	test   %al,%al
  801215:	75 e2                	jne    8011f9 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801217:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80121b:	c9                   	leaveq 
  80121c:	c3                   	retq   

000000000080121d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80121d:	55                   	push   %rbp
  80121e:	48 89 e5             	mov    %rsp,%rbp
  801221:	48 83 ec 18          	sub    $0x18,%rsp
  801225:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801229:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80122c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801230:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801235:	75 06                	jne    80123d <memset+0x20>
		return v;
  801237:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80123b:	eb 69                	jmp    8012a6 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80123d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801241:	83 e0 03             	and    $0x3,%eax
  801244:	48 85 c0             	test   %rax,%rax
  801247:	75 48                	jne    801291 <memset+0x74>
  801249:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80124d:	83 e0 03             	and    $0x3,%eax
  801250:	48 85 c0             	test   %rax,%rax
  801253:	75 3c                	jne    801291 <memset+0x74>
		c &= 0xFF;
  801255:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80125c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80125f:	c1 e0 18             	shl    $0x18,%eax
  801262:	89 c2                	mov    %eax,%edx
  801264:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801267:	c1 e0 10             	shl    $0x10,%eax
  80126a:	09 c2                	or     %eax,%edx
  80126c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80126f:	c1 e0 08             	shl    $0x8,%eax
  801272:	09 d0                	or     %edx,%eax
  801274:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801277:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80127b:	48 c1 e8 02          	shr    $0x2,%rax
  80127f:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801282:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801286:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801289:	48 89 d7             	mov    %rdx,%rdi
  80128c:	fc                   	cld    
  80128d:	f3 ab                	rep stos %eax,%es:(%rdi)
  80128f:	eb 11                	jmp    8012a2 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801291:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801295:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801298:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80129c:	48 89 d7             	mov    %rdx,%rdi
  80129f:	fc                   	cld    
  8012a0:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8012a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012a6:	c9                   	leaveq 
  8012a7:	c3                   	retq   

00000000008012a8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8012a8:	55                   	push   %rbp
  8012a9:	48 89 e5             	mov    %rsp,%rbp
  8012ac:	48 83 ec 28          	sub    $0x28,%rsp
  8012b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012b4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012b8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8012bc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012c0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8012c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8012cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d0:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012d4:	0f 83 88 00 00 00    	jae    801362 <memmove+0xba>
  8012da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012de:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012e2:	48 01 d0             	add    %rdx,%rax
  8012e5:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012e9:	76 77                	jbe    801362 <memmove+0xba>
		s += n;
  8012eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012ef:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8012f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012f7:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ff:	83 e0 03             	and    $0x3,%eax
  801302:	48 85 c0             	test   %rax,%rax
  801305:	75 3b                	jne    801342 <memmove+0x9a>
  801307:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80130b:	83 e0 03             	and    $0x3,%eax
  80130e:	48 85 c0             	test   %rax,%rax
  801311:	75 2f                	jne    801342 <memmove+0x9a>
  801313:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801317:	83 e0 03             	and    $0x3,%eax
  80131a:	48 85 c0             	test   %rax,%rax
  80131d:	75 23                	jne    801342 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80131f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801323:	48 83 e8 04          	sub    $0x4,%rax
  801327:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80132b:	48 83 ea 04          	sub    $0x4,%rdx
  80132f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801333:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801337:	48 89 c7             	mov    %rax,%rdi
  80133a:	48 89 d6             	mov    %rdx,%rsi
  80133d:	fd                   	std    
  80133e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801340:	eb 1d                	jmp    80135f <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801342:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801346:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80134a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134e:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801352:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801356:	48 89 d7             	mov    %rdx,%rdi
  801359:	48 89 c1             	mov    %rax,%rcx
  80135c:	fd                   	std    
  80135d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80135f:	fc                   	cld    
  801360:	eb 57                	jmp    8013b9 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801362:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801366:	83 e0 03             	and    $0x3,%eax
  801369:	48 85 c0             	test   %rax,%rax
  80136c:	75 36                	jne    8013a4 <memmove+0xfc>
  80136e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801372:	83 e0 03             	and    $0x3,%eax
  801375:	48 85 c0             	test   %rax,%rax
  801378:	75 2a                	jne    8013a4 <memmove+0xfc>
  80137a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80137e:	83 e0 03             	and    $0x3,%eax
  801381:	48 85 c0             	test   %rax,%rax
  801384:	75 1e                	jne    8013a4 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801386:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80138a:	48 c1 e8 02          	shr    $0x2,%rax
  80138e:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801391:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801395:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801399:	48 89 c7             	mov    %rax,%rdi
  80139c:	48 89 d6             	mov    %rdx,%rsi
  80139f:	fc                   	cld    
  8013a0:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013a2:	eb 15                	jmp    8013b9 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8013a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013ac:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013b0:	48 89 c7             	mov    %rax,%rdi
  8013b3:	48 89 d6             	mov    %rdx,%rsi
  8013b6:	fc                   	cld    
  8013b7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8013b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013bd:	c9                   	leaveq 
  8013be:	c3                   	retq   

00000000008013bf <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8013bf:	55                   	push   %rbp
  8013c0:	48 89 e5             	mov    %rsp,%rbp
  8013c3:	48 83 ec 18          	sub    $0x18,%rsp
  8013c7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013cb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013cf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8013d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013d7:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8013db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013df:	48 89 ce             	mov    %rcx,%rsi
  8013e2:	48 89 c7             	mov    %rax,%rdi
  8013e5:	48 b8 a8 12 80 00 00 	movabs $0x8012a8,%rax
  8013ec:	00 00 00 
  8013ef:	ff d0                	callq  *%rax
}
  8013f1:	c9                   	leaveq 
  8013f2:	c3                   	retq   

00000000008013f3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8013f3:	55                   	push   %rbp
  8013f4:	48 89 e5             	mov    %rsp,%rbp
  8013f7:	48 83 ec 28          	sub    $0x28,%rsp
  8013fb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013ff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801403:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801407:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80140b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80140f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801413:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801417:	eb 36                	jmp    80144f <memcmp+0x5c>
		if (*s1 != *s2)
  801419:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80141d:	0f b6 10             	movzbl (%rax),%edx
  801420:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801424:	0f b6 00             	movzbl (%rax),%eax
  801427:	38 c2                	cmp    %al,%dl
  801429:	74 1a                	je     801445 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80142b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80142f:	0f b6 00             	movzbl (%rax),%eax
  801432:	0f b6 d0             	movzbl %al,%edx
  801435:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801439:	0f b6 00             	movzbl (%rax),%eax
  80143c:	0f b6 c0             	movzbl %al,%eax
  80143f:	29 c2                	sub    %eax,%edx
  801441:	89 d0                	mov    %edx,%eax
  801443:	eb 20                	jmp    801465 <memcmp+0x72>
		s1++, s2++;
  801445:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80144a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80144f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801453:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801457:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80145b:	48 85 c0             	test   %rax,%rax
  80145e:	75 b9                	jne    801419 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801460:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801465:	c9                   	leaveq 
  801466:	c3                   	retq   

0000000000801467 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801467:	55                   	push   %rbp
  801468:	48 89 e5             	mov    %rsp,%rbp
  80146b:	48 83 ec 28          	sub    $0x28,%rsp
  80146f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801473:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801476:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80147a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801482:	48 01 d0             	add    %rdx,%rax
  801485:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801489:	eb 15                	jmp    8014a0 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80148b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80148f:	0f b6 10             	movzbl (%rax),%edx
  801492:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801495:	38 c2                	cmp    %al,%dl
  801497:	75 02                	jne    80149b <memfind+0x34>
			break;
  801499:	eb 0f                	jmp    8014aa <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80149b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8014a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a4:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8014a8:	72 e1                	jb     80148b <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8014aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014ae:	c9                   	leaveq 
  8014af:	c3                   	retq   

00000000008014b0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014b0:	55                   	push   %rbp
  8014b1:	48 89 e5             	mov    %rsp,%rbp
  8014b4:	48 83 ec 34          	sub    $0x34,%rsp
  8014b8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014bc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8014c0:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8014c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8014ca:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8014d1:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014d2:	eb 05                	jmp    8014d9 <strtol+0x29>
		s++;
  8014d4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014dd:	0f b6 00             	movzbl (%rax),%eax
  8014e0:	3c 20                	cmp    $0x20,%al
  8014e2:	74 f0                	je     8014d4 <strtol+0x24>
  8014e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e8:	0f b6 00             	movzbl (%rax),%eax
  8014eb:	3c 09                	cmp    $0x9,%al
  8014ed:	74 e5                	je     8014d4 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f3:	0f b6 00             	movzbl (%rax),%eax
  8014f6:	3c 2b                	cmp    $0x2b,%al
  8014f8:	75 07                	jne    801501 <strtol+0x51>
		s++;
  8014fa:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014ff:	eb 17                	jmp    801518 <strtol+0x68>
	else if (*s == '-')
  801501:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801505:	0f b6 00             	movzbl (%rax),%eax
  801508:	3c 2d                	cmp    $0x2d,%al
  80150a:	75 0c                	jne    801518 <strtol+0x68>
		s++, neg = 1;
  80150c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801511:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801518:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80151c:	74 06                	je     801524 <strtol+0x74>
  80151e:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801522:	75 28                	jne    80154c <strtol+0x9c>
  801524:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801528:	0f b6 00             	movzbl (%rax),%eax
  80152b:	3c 30                	cmp    $0x30,%al
  80152d:	75 1d                	jne    80154c <strtol+0x9c>
  80152f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801533:	48 83 c0 01          	add    $0x1,%rax
  801537:	0f b6 00             	movzbl (%rax),%eax
  80153a:	3c 78                	cmp    $0x78,%al
  80153c:	75 0e                	jne    80154c <strtol+0x9c>
		s += 2, base = 16;
  80153e:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801543:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80154a:	eb 2c                	jmp    801578 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80154c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801550:	75 19                	jne    80156b <strtol+0xbb>
  801552:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801556:	0f b6 00             	movzbl (%rax),%eax
  801559:	3c 30                	cmp    $0x30,%al
  80155b:	75 0e                	jne    80156b <strtol+0xbb>
		s++, base = 8;
  80155d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801562:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801569:	eb 0d                	jmp    801578 <strtol+0xc8>
	else if (base == 0)
  80156b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80156f:	75 07                	jne    801578 <strtol+0xc8>
		base = 10;
  801571:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801578:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157c:	0f b6 00             	movzbl (%rax),%eax
  80157f:	3c 2f                	cmp    $0x2f,%al
  801581:	7e 1d                	jle    8015a0 <strtol+0xf0>
  801583:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801587:	0f b6 00             	movzbl (%rax),%eax
  80158a:	3c 39                	cmp    $0x39,%al
  80158c:	7f 12                	jg     8015a0 <strtol+0xf0>
			dig = *s - '0';
  80158e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801592:	0f b6 00             	movzbl (%rax),%eax
  801595:	0f be c0             	movsbl %al,%eax
  801598:	83 e8 30             	sub    $0x30,%eax
  80159b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80159e:	eb 4e                	jmp    8015ee <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8015a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a4:	0f b6 00             	movzbl (%rax),%eax
  8015a7:	3c 60                	cmp    $0x60,%al
  8015a9:	7e 1d                	jle    8015c8 <strtol+0x118>
  8015ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015af:	0f b6 00             	movzbl (%rax),%eax
  8015b2:	3c 7a                	cmp    $0x7a,%al
  8015b4:	7f 12                	jg     8015c8 <strtol+0x118>
			dig = *s - 'a' + 10;
  8015b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ba:	0f b6 00             	movzbl (%rax),%eax
  8015bd:	0f be c0             	movsbl %al,%eax
  8015c0:	83 e8 57             	sub    $0x57,%eax
  8015c3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015c6:	eb 26                	jmp    8015ee <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8015c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015cc:	0f b6 00             	movzbl (%rax),%eax
  8015cf:	3c 40                	cmp    $0x40,%al
  8015d1:	7e 48                	jle    80161b <strtol+0x16b>
  8015d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d7:	0f b6 00             	movzbl (%rax),%eax
  8015da:	3c 5a                	cmp    $0x5a,%al
  8015dc:	7f 3d                	jg     80161b <strtol+0x16b>
			dig = *s - 'A' + 10;
  8015de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e2:	0f b6 00             	movzbl (%rax),%eax
  8015e5:	0f be c0             	movsbl %al,%eax
  8015e8:	83 e8 37             	sub    $0x37,%eax
  8015eb:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8015ee:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015f1:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8015f4:	7c 02                	jl     8015f8 <strtol+0x148>
			break;
  8015f6:	eb 23                	jmp    80161b <strtol+0x16b>
		s++, val = (val * base) + dig;
  8015f8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015fd:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801600:	48 98                	cltq   
  801602:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801607:	48 89 c2             	mov    %rax,%rdx
  80160a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80160d:	48 98                	cltq   
  80160f:	48 01 d0             	add    %rdx,%rax
  801612:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801616:	e9 5d ff ff ff       	jmpq   801578 <strtol+0xc8>

	if (endptr)
  80161b:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801620:	74 0b                	je     80162d <strtol+0x17d>
		*endptr = (char *) s;
  801622:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801626:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80162a:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80162d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801631:	74 09                	je     80163c <strtol+0x18c>
  801633:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801637:	48 f7 d8             	neg    %rax
  80163a:	eb 04                	jmp    801640 <strtol+0x190>
  80163c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801640:	c9                   	leaveq 
  801641:	c3                   	retq   

0000000000801642 <strstr>:

char * strstr(const char *in, const char *str)
{
  801642:	55                   	push   %rbp
  801643:	48 89 e5             	mov    %rsp,%rbp
  801646:	48 83 ec 30          	sub    $0x30,%rsp
  80164a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80164e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801652:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801656:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80165a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80165e:	0f b6 00             	movzbl (%rax),%eax
  801661:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801664:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801668:	75 06                	jne    801670 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80166a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166e:	eb 6b                	jmp    8016db <strstr+0x99>

	len = strlen(str);
  801670:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801674:	48 89 c7             	mov    %rax,%rdi
  801677:	48 b8 18 0f 80 00 00 	movabs $0x800f18,%rax
  80167e:	00 00 00 
  801681:	ff d0                	callq  *%rax
  801683:	48 98                	cltq   
  801685:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801689:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801691:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801695:	0f b6 00             	movzbl (%rax),%eax
  801698:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80169b:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80169f:	75 07                	jne    8016a8 <strstr+0x66>
				return (char *) 0;
  8016a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a6:	eb 33                	jmp    8016db <strstr+0x99>
		} while (sc != c);
  8016a8:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8016ac:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8016af:	75 d8                	jne    801689 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8016b1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016b5:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8016b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016bd:	48 89 ce             	mov    %rcx,%rsi
  8016c0:	48 89 c7             	mov    %rax,%rdi
  8016c3:	48 b8 39 11 80 00 00 	movabs $0x801139,%rax
  8016ca:	00 00 00 
  8016cd:	ff d0                	callq  *%rax
  8016cf:	85 c0                	test   %eax,%eax
  8016d1:	75 b6                	jne    801689 <strstr+0x47>

	return (char *) (in - 1);
  8016d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d7:	48 83 e8 01          	sub    $0x1,%rax
}
  8016db:	c9                   	leaveq 
  8016dc:	c3                   	retq   

00000000008016dd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8016dd:	55                   	push   %rbp
  8016de:	48 89 e5             	mov    %rsp,%rbp
  8016e1:	53                   	push   %rbx
  8016e2:	48 83 ec 48          	sub    $0x48,%rsp
  8016e6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8016e9:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8016ec:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016f0:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8016f4:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8016f8:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  8016fc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016ff:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801703:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801707:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80170b:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80170f:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801713:	4c 89 c3             	mov    %r8,%rbx
  801716:	cd 30                	int    $0x30
  801718:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  80171c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801720:	74 3e                	je     801760 <syscall+0x83>
  801722:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801727:	7e 37                	jle    801760 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801729:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80172d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801730:	49 89 d0             	mov    %rdx,%r8
  801733:	89 c1                	mov    %eax,%ecx
  801735:	48 ba 08 42 80 00 00 	movabs $0x804208,%rdx
  80173c:	00 00 00 
  80173f:	be 4a 00 00 00       	mov    $0x4a,%esi
  801744:	48 bf 25 42 80 00 00 	movabs $0x804225,%rdi
  80174b:	00 00 00 
  80174e:	b8 00 00 00 00       	mov    $0x0,%eax
  801753:	49 b9 1d 3a 80 00 00 	movabs $0x803a1d,%r9
  80175a:	00 00 00 
  80175d:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  801760:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801764:	48 83 c4 48          	add    $0x48,%rsp
  801768:	5b                   	pop    %rbx
  801769:	5d                   	pop    %rbp
  80176a:	c3                   	retq   

000000000080176b <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80176b:	55                   	push   %rbp
  80176c:	48 89 e5             	mov    %rsp,%rbp
  80176f:	48 83 ec 20          	sub    $0x20,%rsp
  801773:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801777:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80177b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80177f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801783:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80178a:	00 
  80178b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801791:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801797:	48 89 d1             	mov    %rdx,%rcx
  80179a:	48 89 c2             	mov    %rax,%rdx
  80179d:	be 00 00 00 00       	mov    $0x0,%esi
  8017a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8017a7:	48 b8 dd 16 80 00 00 	movabs $0x8016dd,%rax
  8017ae:	00 00 00 
  8017b1:	ff d0                	callq  *%rax
}
  8017b3:	c9                   	leaveq 
  8017b4:	c3                   	retq   

00000000008017b5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017b5:	55                   	push   %rbp
  8017b6:	48 89 e5             	mov    %rsp,%rbp
  8017b9:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8017bd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017c4:	00 
  8017c5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017cb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017d1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8017db:	be 00 00 00 00       	mov    $0x0,%esi
  8017e0:	bf 01 00 00 00       	mov    $0x1,%edi
  8017e5:	48 b8 dd 16 80 00 00 	movabs $0x8016dd,%rax
  8017ec:	00 00 00 
  8017ef:	ff d0                	callq  *%rax
}
  8017f1:	c9                   	leaveq 
  8017f2:	c3                   	retq   

00000000008017f3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8017f3:	55                   	push   %rbp
  8017f4:	48 89 e5             	mov    %rsp,%rbp
  8017f7:	48 83 ec 10          	sub    $0x10,%rsp
  8017fb:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8017fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801801:	48 98                	cltq   
  801803:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80180a:	00 
  80180b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801811:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801817:	b9 00 00 00 00       	mov    $0x0,%ecx
  80181c:	48 89 c2             	mov    %rax,%rdx
  80181f:	be 01 00 00 00       	mov    $0x1,%esi
  801824:	bf 03 00 00 00       	mov    $0x3,%edi
  801829:	48 b8 dd 16 80 00 00 	movabs $0x8016dd,%rax
  801830:	00 00 00 
  801833:	ff d0                	callq  *%rax
}
  801835:	c9                   	leaveq 
  801836:	c3                   	retq   

0000000000801837 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801837:	55                   	push   %rbp
  801838:	48 89 e5             	mov    %rsp,%rbp
  80183b:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80183f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801846:	00 
  801847:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80184d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801853:	b9 00 00 00 00       	mov    $0x0,%ecx
  801858:	ba 00 00 00 00       	mov    $0x0,%edx
  80185d:	be 00 00 00 00       	mov    $0x0,%esi
  801862:	bf 02 00 00 00       	mov    $0x2,%edi
  801867:	48 b8 dd 16 80 00 00 	movabs $0x8016dd,%rax
  80186e:	00 00 00 
  801871:	ff d0                	callq  *%rax
}
  801873:	c9                   	leaveq 
  801874:	c3                   	retq   

0000000000801875 <sys_yield>:

void
sys_yield(void)
{
  801875:	55                   	push   %rbp
  801876:	48 89 e5             	mov    %rsp,%rbp
  801879:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80187d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801884:	00 
  801885:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80188b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801891:	b9 00 00 00 00       	mov    $0x0,%ecx
  801896:	ba 00 00 00 00       	mov    $0x0,%edx
  80189b:	be 00 00 00 00       	mov    $0x0,%esi
  8018a0:	bf 0b 00 00 00       	mov    $0xb,%edi
  8018a5:	48 b8 dd 16 80 00 00 	movabs $0x8016dd,%rax
  8018ac:	00 00 00 
  8018af:	ff d0                	callq  *%rax
}
  8018b1:	c9                   	leaveq 
  8018b2:	c3                   	retq   

00000000008018b3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8018b3:	55                   	push   %rbp
  8018b4:	48 89 e5             	mov    %rsp,%rbp
  8018b7:	48 83 ec 20          	sub    $0x20,%rsp
  8018bb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018be:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018c2:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8018c5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018c8:	48 63 c8             	movslq %eax,%rcx
  8018cb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018d2:	48 98                	cltq   
  8018d4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018db:	00 
  8018dc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018e2:	49 89 c8             	mov    %rcx,%r8
  8018e5:	48 89 d1             	mov    %rdx,%rcx
  8018e8:	48 89 c2             	mov    %rax,%rdx
  8018eb:	be 01 00 00 00       	mov    $0x1,%esi
  8018f0:	bf 04 00 00 00       	mov    $0x4,%edi
  8018f5:	48 b8 dd 16 80 00 00 	movabs $0x8016dd,%rax
  8018fc:	00 00 00 
  8018ff:	ff d0                	callq  *%rax
}
  801901:	c9                   	leaveq 
  801902:	c3                   	retq   

0000000000801903 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801903:	55                   	push   %rbp
  801904:	48 89 e5             	mov    %rsp,%rbp
  801907:	48 83 ec 30          	sub    $0x30,%rsp
  80190b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80190e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801912:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801915:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801919:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80191d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801920:	48 63 c8             	movslq %eax,%rcx
  801923:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801927:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80192a:	48 63 f0             	movslq %eax,%rsi
  80192d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801931:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801934:	48 98                	cltq   
  801936:	48 89 0c 24          	mov    %rcx,(%rsp)
  80193a:	49 89 f9             	mov    %rdi,%r9
  80193d:	49 89 f0             	mov    %rsi,%r8
  801940:	48 89 d1             	mov    %rdx,%rcx
  801943:	48 89 c2             	mov    %rax,%rdx
  801946:	be 01 00 00 00       	mov    $0x1,%esi
  80194b:	bf 05 00 00 00       	mov    $0x5,%edi
  801950:	48 b8 dd 16 80 00 00 	movabs $0x8016dd,%rax
  801957:	00 00 00 
  80195a:	ff d0                	callq  *%rax
}
  80195c:	c9                   	leaveq 
  80195d:	c3                   	retq   

000000000080195e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80195e:	55                   	push   %rbp
  80195f:	48 89 e5             	mov    %rsp,%rbp
  801962:	48 83 ec 20          	sub    $0x20,%rsp
  801966:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801969:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80196d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801971:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801974:	48 98                	cltq   
  801976:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80197d:	00 
  80197e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801984:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80198a:	48 89 d1             	mov    %rdx,%rcx
  80198d:	48 89 c2             	mov    %rax,%rdx
  801990:	be 01 00 00 00       	mov    $0x1,%esi
  801995:	bf 06 00 00 00       	mov    $0x6,%edi
  80199a:	48 b8 dd 16 80 00 00 	movabs $0x8016dd,%rax
  8019a1:	00 00 00 
  8019a4:	ff d0                	callq  *%rax
}
  8019a6:	c9                   	leaveq 
  8019a7:	c3                   	retq   

00000000008019a8 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8019a8:	55                   	push   %rbp
  8019a9:	48 89 e5             	mov    %rsp,%rbp
  8019ac:	48 83 ec 10          	sub    $0x10,%rsp
  8019b0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019b3:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8019b6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019b9:	48 63 d0             	movslq %eax,%rdx
  8019bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019bf:	48 98                	cltq   
  8019c1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019c8:	00 
  8019c9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019cf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019d5:	48 89 d1             	mov    %rdx,%rcx
  8019d8:	48 89 c2             	mov    %rax,%rdx
  8019db:	be 01 00 00 00       	mov    $0x1,%esi
  8019e0:	bf 08 00 00 00       	mov    $0x8,%edi
  8019e5:	48 b8 dd 16 80 00 00 	movabs $0x8016dd,%rax
  8019ec:	00 00 00 
  8019ef:	ff d0                	callq  *%rax
}
  8019f1:	c9                   	leaveq 
  8019f2:	c3                   	retq   

00000000008019f3 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8019f3:	55                   	push   %rbp
  8019f4:	48 89 e5             	mov    %rsp,%rbp
  8019f7:	48 83 ec 20          	sub    $0x20,%rsp
  8019fb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019fe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801a02:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a09:	48 98                	cltq   
  801a0b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a12:	00 
  801a13:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a19:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a1f:	48 89 d1             	mov    %rdx,%rcx
  801a22:	48 89 c2             	mov    %rax,%rdx
  801a25:	be 01 00 00 00       	mov    $0x1,%esi
  801a2a:	bf 09 00 00 00       	mov    $0x9,%edi
  801a2f:	48 b8 dd 16 80 00 00 	movabs $0x8016dd,%rax
  801a36:	00 00 00 
  801a39:	ff d0                	callq  *%rax
}
  801a3b:	c9                   	leaveq 
  801a3c:	c3                   	retq   

0000000000801a3d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801a3d:	55                   	push   %rbp
  801a3e:	48 89 e5             	mov    %rsp,%rbp
  801a41:	48 83 ec 20          	sub    $0x20,%rsp
  801a45:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a48:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801a4c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a53:	48 98                	cltq   
  801a55:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a5c:	00 
  801a5d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a63:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a69:	48 89 d1             	mov    %rdx,%rcx
  801a6c:	48 89 c2             	mov    %rax,%rdx
  801a6f:	be 01 00 00 00       	mov    $0x1,%esi
  801a74:	bf 0a 00 00 00       	mov    $0xa,%edi
  801a79:	48 b8 dd 16 80 00 00 	movabs $0x8016dd,%rax
  801a80:	00 00 00 
  801a83:	ff d0                	callq  *%rax
}
  801a85:	c9                   	leaveq 
  801a86:	c3                   	retq   

0000000000801a87 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801a87:	55                   	push   %rbp
  801a88:	48 89 e5             	mov    %rsp,%rbp
  801a8b:	48 83 ec 20          	sub    $0x20,%rsp
  801a8f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a92:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a96:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a9a:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801a9d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801aa0:	48 63 f0             	movslq %eax,%rsi
  801aa3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801aa7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aaa:	48 98                	cltq   
  801aac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ab0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ab7:	00 
  801ab8:	49 89 f1             	mov    %rsi,%r9
  801abb:	49 89 c8             	mov    %rcx,%r8
  801abe:	48 89 d1             	mov    %rdx,%rcx
  801ac1:	48 89 c2             	mov    %rax,%rdx
  801ac4:	be 00 00 00 00       	mov    $0x0,%esi
  801ac9:	bf 0c 00 00 00       	mov    $0xc,%edi
  801ace:	48 b8 dd 16 80 00 00 	movabs $0x8016dd,%rax
  801ad5:	00 00 00 
  801ad8:	ff d0                	callq  *%rax
}
  801ada:	c9                   	leaveq 
  801adb:	c3                   	retq   

0000000000801adc <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801adc:	55                   	push   %rbp
  801add:	48 89 e5             	mov    %rsp,%rbp
  801ae0:	48 83 ec 10          	sub    $0x10,%rsp
  801ae4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801ae8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aec:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801af3:	00 
  801af4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801afa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b00:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b05:	48 89 c2             	mov    %rax,%rdx
  801b08:	be 01 00 00 00       	mov    $0x1,%esi
  801b0d:	bf 0d 00 00 00       	mov    $0xd,%edi
  801b12:	48 b8 dd 16 80 00 00 	movabs $0x8016dd,%rax
  801b19:	00 00 00 
  801b1c:	ff d0                	callq  *%rax
}
  801b1e:	c9                   	leaveq 
  801b1f:	c3                   	retq   

0000000000801b20 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801b20:	55                   	push   %rbp
  801b21:	48 89 e5             	mov    %rsp,%rbp
  801b24:	53                   	push   %rbx
  801b25:	48 83 ec 48          	sub    $0x48,%rsp
  801b29:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801b2d:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801b31:	48 8b 00             	mov    (%rax),%rax
  801b34:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	uint32_t err = utf->utf_err;
  801b38:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801b3c:	48 8b 40 08          	mov    0x8(%rax),%rax
  801b40:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	pte_t pte = uvpt[VPN(addr)];
  801b43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b47:	48 c1 e8 0c          	shr    $0xc,%rax
  801b4b:	48 89 c2             	mov    %rax,%rdx
  801b4e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801b55:	01 00 00 
  801b58:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b5c:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	envid_t pid = sys_getenvid();
  801b60:	48 b8 37 18 80 00 00 	movabs $0x801837,%rax
  801b67:	00 00 00 
  801b6a:	ff d0                	callq  *%rax
  801b6c:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	void* va = ROUNDDOWN(addr, PGSIZE);
  801b6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b73:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  801b77:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b7b:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801b81:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	if((err & FEC_WR) && (pte & PTE_COW)){
  801b85:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b88:	83 e0 02             	and    $0x2,%eax
  801b8b:	85 c0                	test   %eax,%eax
  801b8d:	0f 84 8d 00 00 00    	je     801c20 <pgfault+0x100>
  801b93:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b97:	25 00 08 00 00       	and    $0x800,%eax
  801b9c:	48 85 c0             	test   %rax,%rax
  801b9f:	74 7f                	je     801c20 <pgfault+0x100>
		if(!sys_page_alloc(pid, (void*)PFTEMP, PTE_P | PTE_W | PTE_U)){
  801ba1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801ba4:	ba 07 00 00 00       	mov    $0x7,%edx
  801ba9:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801bae:	89 c7                	mov    %eax,%edi
  801bb0:	48 b8 b3 18 80 00 00 	movabs $0x8018b3,%rax
  801bb7:	00 00 00 
  801bba:	ff d0                	callq  *%rax
  801bbc:	85 c0                	test   %eax,%eax
  801bbe:	75 60                	jne    801c20 <pgfault+0x100>
			memmove(PFTEMP, va, PGSIZE);
  801bc0:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801bc4:	ba 00 10 00 00       	mov    $0x1000,%edx
  801bc9:	48 89 c6             	mov    %rax,%rsi
  801bcc:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801bd1:	48 b8 a8 12 80 00 00 	movabs $0x8012a8,%rax
  801bd8:	00 00 00 
  801bdb:	ff d0                	callq  *%rax
			if(!(sys_page_map(pid, (void*)PFTEMP, pid, va, PTE_P | PTE_W | PTE_U) | 
  801bdd:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  801be1:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  801be4:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801be7:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801bed:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801bf2:	89 c7                	mov    %eax,%edi
  801bf4:	48 b8 03 19 80 00 00 	movabs $0x801903,%rax
  801bfb:	00 00 00 
  801bfe:	ff d0                	callq  *%rax
  801c00:	89 c3                	mov    %eax,%ebx
					 sys_page_unmap(pid, (void*) PFTEMP)))
  801c02:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801c05:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c0a:	89 c7                	mov    %eax,%edi
  801c0c:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  801c13:	00 00 00 
  801c16:	ff d0                	callq  *%rax
	envid_t pid = sys_getenvid();
	void* va = ROUNDDOWN(addr, PGSIZE);
	if((err & FEC_WR) && (pte & PTE_COW)){
		if(!sys_page_alloc(pid, (void*)PFTEMP, PTE_P | PTE_W | PTE_U)){
			memmove(PFTEMP, va, PGSIZE);
			if(!(sys_page_map(pid, (void*)PFTEMP, pid, va, PTE_P | PTE_W | PTE_U) | 
  801c18:	09 d8                	or     %ebx,%eax
  801c1a:	85 c0                	test   %eax,%eax
  801c1c:	75 02                	jne    801c20 <pgfault+0x100>
					 sys_page_unmap(pid, (void*) PFTEMP)))
					return;
  801c1e:	eb 2a                	jmp    801c4a <pgfault+0x12a>
		}
	}
	panic("Page fault handler failure\n");
  801c20:	48 ba 33 42 80 00 00 	movabs $0x804233,%rdx
  801c27:	00 00 00 
  801c2a:	be 26 00 00 00       	mov    $0x26,%esi
  801c2f:	48 bf 4f 42 80 00 00 	movabs $0x80424f,%rdi
  801c36:	00 00 00 
  801c39:	b8 00 00 00 00       	mov    $0x0,%eax
  801c3e:	48 b9 1d 3a 80 00 00 	movabs $0x803a1d,%rcx
  801c45:	00 00 00 
  801c48:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	//panic("pgfault not implemented");
}
  801c4a:	48 83 c4 48          	add    $0x48,%rsp
  801c4e:	5b                   	pop    %rbx
  801c4f:	5d                   	pop    %rbp
  801c50:	c3                   	retq   

0000000000801c51 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801c51:	55                   	push   %rbp
  801c52:	48 89 e5             	mov    %rsp,%rbp
  801c55:	53                   	push   %rbx
  801c56:	48 83 ec 38          	sub    $0x38,%rsp
  801c5a:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801c5d:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	//struct Env *env;
	pte_t pte = uvpt[pn];
  801c60:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c67:	01 00 00 
  801c6a:	8b 55 c8             	mov    -0x38(%rbp),%edx
  801c6d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c71:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int perm = pte & PTE_SYSCALL;
  801c75:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c79:	25 07 0e 00 00       	and    $0xe07,%eax
  801c7e:	89 45 dc             	mov    %eax,-0x24(%rbp)
	void *va = (void*)((uintptr_t)pn * PGSIZE);
  801c81:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801c84:	48 c1 e0 0c          	shl    $0xc,%rax
  801c88:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	if(perm & PTE_SHARE){
  801c8c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801c8f:	25 00 04 00 00       	and    $0x400,%eax
  801c94:	85 c0                	test   %eax,%eax
  801c96:	74 30                	je     801cc8 <duppage+0x77>
		r = sys_page_map(0, va, envid, va, perm);
  801c98:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801c9b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801c9f:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801ca2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ca6:	41 89 f0             	mov    %esi,%r8d
  801ca9:	48 89 c6             	mov    %rax,%rsi
  801cac:	bf 00 00 00 00       	mov    $0x0,%edi
  801cb1:	48 b8 03 19 80 00 00 	movabs $0x801903,%rax
  801cb8:	00 00 00 
  801cbb:	ff d0                	callq  *%rax
  801cbd:	89 45 ec             	mov    %eax,-0x14(%rbp)
		return r;
  801cc0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801cc3:	e9 a4 00 00 00       	jmpq   801d6c <duppage+0x11b>
	}
	//envid_t pid = sys_getenvid();
	if((perm & PTE_W) || (perm & PTE_COW)){
  801cc8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801ccb:	83 e0 02             	and    $0x2,%eax
  801cce:	85 c0                	test   %eax,%eax
  801cd0:	75 0c                	jne    801cde <duppage+0x8d>
  801cd2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801cd5:	25 00 08 00 00       	and    $0x800,%eax
  801cda:	85 c0                	test   %eax,%eax
  801cdc:	74 63                	je     801d41 <duppage+0xf0>
		perm &= ~PTE_W;
  801cde:	83 65 dc fd          	andl   $0xfffffffd,-0x24(%rbp)
		perm |= PTE_COW;
  801ce2:	81 4d dc 00 08 00 00 	orl    $0x800,-0x24(%rbp)
		r = sys_page_map(0, va, envid, va, perm) | sys_page_map(0, va, 0, va, perm);
  801ce9:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801cec:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801cf0:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801cf3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801cf7:	41 89 f0             	mov    %esi,%r8d
  801cfa:	48 89 c6             	mov    %rax,%rsi
  801cfd:	bf 00 00 00 00       	mov    $0x0,%edi
  801d02:	48 b8 03 19 80 00 00 	movabs $0x801903,%rax
  801d09:	00 00 00 
  801d0c:	ff d0                	callq  *%rax
  801d0e:	89 c3                	mov    %eax,%ebx
  801d10:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  801d13:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801d17:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d1b:	41 89 c8             	mov    %ecx,%r8d
  801d1e:	48 89 d1             	mov    %rdx,%rcx
  801d21:	ba 00 00 00 00       	mov    $0x0,%edx
  801d26:	48 89 c6             	mov    %rax,%rsi
  801d29:	bf 00 00 00 00       	mov    $0x0,%edi
  801d2e:	48 b8 03 19 80 00 00 	movabs $0x801903,%rax
  801d35:	00 00 00 
  801d38:	ff d0                	callq  *%rax
  801d3a:	09 d8                	or     %ebx,%eax
  801d3c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d3f:	eb 28                	jmp    801d69 <duppage+0x118>
	}
	else{
		r = sys_page_map(0, va, envid, va, perm);
  801d41:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801d44:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801d48:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801d4b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d4f:	41 89 f0             	mov    %esi,%r8d
  801d52:	48 89 c6             	mov    %rax,%rsi
  801d55:	bf 00 00 00 00       	mov    $0x0,%edi
  801d5a:	48 b8 03 19 80 00 00 	movabs $0x801903,%rax
  801d61:	00 00 00 
  801d64:	ff d0                	callq  *%rax
  801d66:	89 45 ec             	mov    %eax,-0x14(%rbp)
	}

	// LAB 4: Your code here.
	//panic("duppage not implemented");
	//if(r != 0) panic("Duplicating page failed: %e\n", r);
	return r;
  801d69:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  801d6c:	48 83 c4 38          	add    $0x38,%rsp
  801d70:	5b                   	pop    %rbx
  801d71:	5d                   	pop    %rbp
  801d72:	c3                   	retq   

0000000000801d73 <fork>:
//   so you must allocate a new page for the child's user exception stack.
//

envid_t
fork(void)
{
  801d73:	55                   	push   %rbp
  801d74:	48 89 e5             	mov    %rsp,%rbp
  801d77:	53                   	push   %rbx
  801d78:	48 83 ec 58          	sub    $0x58,%rsp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  801d7c:	48 bf 20 1b 80 00 00 	movabs $0x801b20,%rdi
  801d83:	00 00 00 
  801d86:	48 b8 31 3b 80 00 00 	movabs $0x803b31,%rax
  801d8d:	00 00 00 
  801d90:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801d92:	b8 07 00 00 00       	mov    $0x7,%eax
  801d97:	cd 30                	int    $0x30
  801d99:	89 45 a4             	mov    %eax,-0x5c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801d9c:	8b 45 a4             	mov    -0x5c(%rbp),%eax
	envid_t cid = sys_exofork();
  801d9f:	89 45 cc             	mov    %eax,-0x34(%rbp)
	if(cid < 0) panic("fork failed: %e\n", cid);
  801da2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801da6:	79 30                	jns    801dd8 <fork+0x65>
  801da8:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801dab:	89 c1                	mov    %eax,%ecx
  801dad:	48 ba 5a 42 80 00 00 	movabs $0x80425a,%rdx
  801db4:	00 00 00 
  801db7:	be 72 00 00 00       	mov    $0x72,%esi
  801dbc:	48 bf 4f 42 80 00 00 	movabs $0x80424f,%rdi
  801dc3:	00 00 00 
  801dc6:	b8 00 00 00 00       	mov    $0x0,%eax
  801dcb:	49 b8 1d 3a 80 00 00 	movabs $0x803a1d,%r8
  801dd2:	00 00 00 
  801dd5:	41 ff d0             	callq  *%r8
	if(cid == 0){
  801dd8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801ddc:	75 46                	jne    801e24 <fork+0xb1>
		thisenv = &envs[ENVX(sys_getenvid())];
  801dde:	48 b8 37 18 80 00 00 	movabs $0x801837,%rax
  801de5:	00 00 00 
  801de8:	ff d0                	callq  *%rax
  801dea:	25 ff 03 00 00       	and    $0x3ff,%eax
  801def:	48 63 d0             	movslq %eax,%rdx
  801df2:	48 89 d0             	mov    %rdx,%rax
  801df5:	48 c1 e0 03          	shl    $0x3,%rax
  801df9:	48 01 d0             	add    %rdx,%rax
  801dfc:	48 c1 e0 05          	shl    $0x5,%rax
  801e00:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801e07:	00 00 00 
  801e0a:	48 01 c2             	add    %rax,%rdx
  801e0d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801e14:	00 00 00 
  801e17:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801e1a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e1f:	e9 12 02 00 00       	jmpq   802036 <fork+0x2c3>
	}
	int result;
	if((result = sys_page_alloc(cid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801e24:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801e27:	ba 07 00 00 00       	mov    $0x7,%edx
  801e2c:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801e31:	89 c7                	mov    %eax,%edi
  801e33:	48 b8 b3 18 80 00 00 	movabs $0x8018b3,%rax
  801e3a:	00 00 00 
  801e3d:	ff d0                	callq  *%rax
  801e3f:	89 45 c8             	mov    %eax,-0x38(%rbp)
  801e42:	83 7d c8 00          	cmpl   $0x0,-0x38(%rbp)
  801e46:	79 30                	jns    801e78 <fork+0x105>
		panic("fork failed: %e\n", result);
  801e48:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801e4b:	89 c1                	mov    %eax,%ecx
  801e4d:	48 ba 5a 42 80 00 00 	movabs $0x80425a,%rdx
  801e54:	00 00 00 
  801e57:	be 79 00 00 00       	mov    $0x79,%esi
  801e5c:	48 bf 4f 42 80 00 00 	movabs $0x80424f,%rdi
  801e63:	00 00 00 
  801e66:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6b:	49 b8 1d 3a 80 00 00 	movabs $0x803a1d,%r8
  801e72:	00 00 00 
  801e75:	41 ff d0             	callq  *%r8
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  801e78:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801e7f:	00 
  801e80:	e9 40 01 00 00       	jmpq   801fc5 <fork+0x252>
		if(uvpml4e[pml4e] & PTE_P){
  801e85:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801e8c:	01 00 00 
  801e8f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801e93:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e97:	83 e0 01             	and    $0x1,%eax
  801e9a:	48 85 c0             	test   %rax,%rax
  801e9d:	0f 84 1d 01 00 00    	je     801fc0 <fork+0x24d>
			base_pml4e = pml4e * NPDPENTRIES;
  801ea3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ea7:	48 c1 e0 09          	shl    $0x9,%rax
  801eab:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  801eaf:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  801eb6:	00 
  801eb7:	e9 f6 00 00 00       	jmpq   801fb2 <fork+0x23f>
				if(uvpde[base_pml4e + pdpe] & PTE_P){
  801ebc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ec0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801ec4:	48 01 c2             	add    %rax,%rdx
  801ec7:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801ece:	01 00 00 
  801ed1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ed5:	83 e0 01             	and    $0x1,%eax
  801ed8:	48 85 c0             	test   %rax,%rax
  801edb:	0f 84 cc 00 00 00    	je     801fad <fork+0x23a>
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
  801ee1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ee5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801ee9:	48 01 d0             	add    %rdx,%rax
  801eec:	48 c1 e0 09          	shl    $0x9,%rax
  801ef0:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
					for(pde = 0; pde < NPDENTRIES; pde++){
  801ef4:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  801efb:	00 
  801efc:	e9 9e 00 00 00       	jmpq   801f9f <fork+0x22c>
						if(uvpd[base_pdpe + pde] & PTE_P){
  801f01:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f05:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801f09:	48 01 c2             	add    %rax,%rdx
  801f0c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f13:	01 00 00 
  801f16:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f1a:	83 e0 01             	and    $0x1,%eax
  801f1d:	48 85 c0             	test   %rax,%rax
  801f20:	74 78                	je     801f9a <fork+0x227>
							base_pde = (base_pdpe + pde) * NPTENTRIES;
  801f22:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f26:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801f2a:	48 01 d0             	add    %rdx,%rax
  801f2d:	48 c1 e0 09          	shl    $0x9,%rax
  801f31:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
							for(pte = 0; pte < NPTENTRIES; pte++){
  801f35:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  801f3c:	00 
  801f3d:	eb 51                	jmp    801f90 <fork+0x21d>
								entry = base_pde + pte;
  801f3f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f43:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801f47:	48 01 d0             	add    %rdx,%rax
  801f4a:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
								if((uvpt[entry] & PTE_P) && (entry != VPN(UXSTACKTOP - PGSIZE))){
  801f4e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f55:	01 00 00 
  801f58:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801f5c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f60:	83 e0 01             	and    $0x1,%eax
  801f63:	48 85 c0             	test   %rax,%rax
  801f66:	74 23                	je     801f8b <fork+0x218>
  801f68:	48 81 7d a8 ff f7 0e 	cmpq   $0xef7ff,-0x58(%rbp)
  801f6f:	00 
  801f70:	74 19                	je     801f8b <fork+0x218>
									duppage(cid, entry);
  801f72:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801f76:	89 c2                	mov    %eax,%edx
  801f78:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801f7b:	89 d6                	mov    %edx,%esi
  801f7d:	89 c7                	mov    %eax,%edi
  801f7f:	48 b8 51 1c 80 00 00 	movabs $0x801c51,%rax
  801f86:	00 00 00 
  801f89:	ff d0                	callq  *%rax
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
						if(uvpd[base_pdpe + pde] & PTE_P){
							base_pde = (base_pdpe + pde) * NPTENTRIES;
							for(pte = 0; pte < NPTENTRIES; pte++){
  801f8b:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  801f90:	48 81 7d d0 ff 01 00 	cmpq   $0x1ff,-0x30(%rbp)
  801f97:	00 
  801f98:	76 a5                	jbe    801f3f <fork+0x1cc>
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
  801f9a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801f9f:	48 81 7d d8 ff 01 00 	cmpq   $0x1ff,-0x28(%rbp)
  801fa6:	00 
  801fa7:	0f 86 54 ff ff ff    	jbe    801f01 <fork+0x18e>
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  801fad:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  801fb2:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  801fb9:	00 
  801fba:	0f 86 fc fe ff ff    	jbe    801ebc <fork+0x149>
	int result;
	if((result = sys_page_alloc(cid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		panic("fork failed: %e\n", result);
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  801fc0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801fc5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801fca:	0f 84 b5 fe ff ff    	je     801e85 <fork+0x112>
					}
				}
			}
		}
	}
	if(sys_env_set_pgfault_upcall(cid, _pgfault_upcall) | sys_env_set_status(cid, ENV_RUNNABLE))
  801fd0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801fd3:	48 be c6 3b 80 00 00 	movabs $0x803bc6,%rsi
  801fda:	00 00 00 
  801fdd:	89 c7                	mov    %eax,%edi
  801fdf:	48 b8 3d 1a 80 00 00 	movabs $0x801a3d,%rax
  801fe6:	00 00 00 
  801fe9:	ff d0                	callq  *%rax
  801feb:	89 c3                	mov    %eax,%ebx
  801fed:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801ff0:	be 02 00 00 00       	mov    $0x2,%esi
  801ff5:	89 c7                	mov    %eax,%edi
  801ff7:	48 b8 a8 19 80 00 00 	movabs $0x8019a8,%rax
  801ffe:	00 00 00 
  802001:	ff d0                	callq  *%rax
  802003:	09 d8                	or     %ebx,%eax
  802005:	85 c0                	test   %eax,%eax
  802007:	74 2a                	je     802033 <fork+0x2c0>
		panic("fork failed\n");
  802009:	48 ba 6b 42 80 00 00 	movabs $0x80426b,%rdx
  802010:	00 00 00 
  802013:	be 92 00 00 00       	mov    $0x92,%esi
  802018:	48 bf 4f 42 80 00 00 	movabs $0x80424f,%rdi
  80201f:	00 00 00 
  802022:	b8 00 00 00 00       	mov    $0x0,%eax
  802027:	48 b9 1d 3a 80 00 00 	movabs $0x803a1d,%rcx
  80202e:	00 00 00 
  802031:	ff d1                	callq  *%rcx
	return cid;
  802033:	8b 45 cc             	mov    -0x34(%rbp),%eax
	//panic("fork not implemented");
}
  802036:	48 83 c4 58          	add    $0x58,%rsp
  80203a:	5b                   	pop    %rbx
  80203b:	5d                   	pop    %rbp
  80203c:	c3                   	retq   

000000000080203d <sfork>:


// Challenge!
int
sfork(void)
{
  80203d:	55                   	push   %rbp
  80203e:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802041:	48 ba 78 42 80 00 00 	movabs $0x804278,%rdx
  802048:	00 00 00 
  80204b:	be 9c 00 00 00       	mov    $0x9c,%esi
  802050:	48 bf 4f 42 80 00 00 	movabs $0x80424f,%rdi
  802057:	00 00 00 
  80205a:	b8 00 00 00 00       	mov    $0x0,%eax
  80205f:	48 b9 1d 3a 80 00 00 	movabs $0x803a1d,%rcx
  802066:	00 00 00 
  802069:	ff d1                	callq  *%rcx

000000000080206b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80206b:	55                   	push   %rbp
  80206c:	48 89 e5             	mov    %rsp,%rbp
  80206f:	48 83 ec 30          	sub    $0x30,%rsp
  802073:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802077:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80207b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  80207f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802084:	74 18                	je     80209e <ipc_recv+0x33>
  802086:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80208a:	48 89 c7             	mov    %rax,%rdi
  80208d:	48 b8 dc 1a 80 00 00 	movabs $0x801adc,%rax
  802094:	00 00 00 
  802097:	ff d0                	callq  *%rax
  802099:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80209c:	eb 19                	jmp    8020b7 <ipc_recv+0x4c>
  80209e:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  8020a5:	00 00 00 
  8020a8:	48 b8 dc 1a 80 00 00 	movabs $0x801adc,%rax
  8020af:	00 00 00 
  8020b2:	ff d0                	callq  *%rax
  8020b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  8020b7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8020bc:	74 26                	je     8020e4 <ipc_recv+0x79>
  8020be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020c2:	75 15                	jne    8020d9 <ipc_recv+0x6e>
  8020c4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8020cb:	00 00 00 
  8020ce:	48 8b 00             	mov    (%rax),%rax
  8020d1:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  8020d7:	eb 05                	jmp    8020de <ipc_recv+0x73>
  8020d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8020e2:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  8020e4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8020e9:	74 26                	je     802111 <ipc_recv+0xa6>
  8020eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020ef:	75 15                	jne    802106 <ipc_recv+0x9b>
  8020f1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8020f8:	00 00 00 
  8020fb:	48 8b 00             	mov    (%rax),%rax
  8020fe:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  802104:	eb 05                	jmp    80210b <ipc_recv+0xa0>
  802106:	b8 00 00 00 00       	mov    $0x0,%eax
  80210b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80210f:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  802111:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802115:	75 15                	jne    80212c <ipc_recv+0xc1>
  802117:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80211e:	00 00 00 
  802121:	48 8b 00             	mov    (%rax),%rax
  802124:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  80212a:	eb 03                	jmp    80212f <ipc_recv+0xc4>
  80212c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80212f:	c9                   	leaveq 
  802130:	c3                   	retq   

0000000000802131 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802131:	55                   	push   %rbp
  802132:	48 89 e5             	mov    %rsp,%rbp
  802135:	48 83 ec 30          	sub    $0x30,%rsp
  802139:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80213c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80213f:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802143:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  802146:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  80214d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802152:	75 10                	jne    802164 <ipc_send+0x33>
  802154:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80215b:	00 00 00 
  80215e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  802162:	eb 62                	jmp    8021c6 <ipc_send+0x95>
  802164:	eb 60                	jmp    8021c6 <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  802166:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80216a:	74 30                	je     80219c <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  80216c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80216f:	89 c1                	mov    %eax,%ecx
  802171:	48 ba 8e 42 80 00 00 	movabs $0x80428e,%rdx
  802178:	00 00 00 
  80217b:	be 33 00 00 00       	mov    $0x33,%esi
  802180:	48 bf aa 42 80 00 00 	movabs $0x8042aa,%rdi
  802187:	00 00 00 
  80218a:	b8 00 00 00 00       	mov    $0x0,%eax
  80218f:	49 b8 1d 3a 80 00 00 	movabs $0x803a1d,%r8
  802196:	00 00 00 
  802199:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  80219c:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80219f:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8021a2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8021a6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021a9:	89 c7                	mov    %eax,%edi
  8021ab:	48 b8 87 1a 80 00 00 	movabs $0x801a87,%rax
  8021b2:	00 00 00 
  8021b5:	ff d0                	callq  *%rax
  8021b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  8021ba:	48 b8 75 18 80 00 00 	movabs $0x801875,%rax
  8021c1:	00 00 00 
  8021c4:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  8021c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021ca:	75 9a                	jne    802166 <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  8021cc:	c9                   	leaveq 
  8021cd:	c3                   	retq   

00000000008021ce <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8021ce:	55                   	push   %rbp
  8021cf:	48 89 e5             	mov    %rsp,%rbp
  8021d2:	48 83 ec 14          	sub    $0x14,%rsp
  8021d6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8021d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021e0:	eb 5e                	jmp    802240 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8021e2:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8021e9:	00 00 00 
  8021ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021ef:	48 63 d0             	movslq %eax,%rdx
  8021f2:	48 89 d0             	mov    %rdx,%rax
  8021f5:	48 c1 e0 03          	shl    $0x3,%rax
  8021f9:	48 01 d0             	add    %rdx,%rax
  8021fc:	48 c1 e0 05          	shl    $0x5,%rax
  802200:	48 01 c8             	add    %rcx,%rax
  802203:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802209:	8b 00                	mov    (%rax),%eax
  80220b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80220e:	75 2c                	jne    80223c <ipc_find_env+0x6e>
			return envs[i].env_id;
  802210:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802217:	00 00 00 
  80221a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80221d:	48 63 d0             	movslq %eax,%rdx
  802220:	48 89 d0             	mov    %rdx,%rax
  802223:	48 c1 e0 03          	shl    $0x3,%rax
  802227:	48 01 d0             	add    %rdx,%rax
  80222a:	48 c1 e0 05          	shl    $0x5,%rax
  80222e:	48 01 c8             	add    %rcx,%rax
  802231:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802237:	8b 40 08             	mov    0x8(%rax),%eax
  80223a:	eb 12                	jmp    80224e <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80223c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802240:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802247:	7e 99                	jle    8021e2 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802249:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80224e:	c9                   	leaveq 
  80224f:	c3                   	retq   

0000000000802250 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802250:	55                   	push   %rbp
  802251:	48 89 e5             	mov    %rsp,%rbp
  802254:	48 83 ec 08          	sub    $0x8,%rsp
  802258:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80225c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802260:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802267:	ff ff ff 
  80226a:	48 01 d0             	add    %rdx,%rax
  80226d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802271:	c9                   	leaveq 
  802272:	c3                   	retq   

0000000000802273 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802273:	55                   	push   %rbp
  802274:	48 89 e5             	mov    %rsp,%rbp
  802277:	48 83 ec 08          	sub    $0x8,%rsp
  80227b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80227f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802283:	48 89 c7             	mov    %rax,%rdi
  802286:	48 b8 50 22 80 00 00 	movabs $0x802250,%rax
  80228d:	00 00 00 
  802290:	ff d0                	callq  *%rax
  802292:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802298:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80229c:	c9                   	leaveq 
  80229d:	c3                   	retq   

000000000080229e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80229e:	55                   	push   %rbp
  80229f:	48 89 e5             	mov    %rsp,%rbp
  8022a2:	48 83 ec 18          	sub    $0x18,%rsp
  8022a6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8022aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022b1:	eb 6b                	jmp    80231e <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8022b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022b6:	48 98                	cltq   
  8022b8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8022be:	48 c1 e0 0c          	shl    $0xc,%rax
  8022c2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8022c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ca:	48 c1 e8 15          	shr    $0x15,%rax
  8022ce:	48 89 c2             	mov    %rax,%rdx
  8022d1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022d8:	01 00 00 
  8022db:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022df:	83 e0 01             	and    $0x1,%eax
  8022e2:	48 85 c0             	test   %rax,%rax
  8022e5:	74 21                	je     802308 <fd_alloc+0x6a>
  8022e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022eb:	48 c1 e8 0c          	shr    $0xc,%rax
  8022ef:	48 89 c2             	mov    %rax,%rdx
  8022f2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022f9:	01 00 00 
  8022fc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802300:	83 e0 01             	and    $0x1,%eax
  802303:	48 85 c0             	test   %rax,%rax
  802306:	75 12                	jne    80231a <fd_alloc+0x7c>
			*fd_store = fd;
  802308:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80230c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802310:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802313:	b8 00 00 00 00       	mov    $0x0,%eax
  802318:	eb 1a                	jmp    802334 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80231a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80231e:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802322:	7e 8f                	jle    8022b3 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802324:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802328:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80232f:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802334:	c9                   	leaveq 
  802335:	c3                   	retq   

0000000000802336 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802336:	55                   	push   %rbp
  802337:	48 89 e5             	mov    %rsp,%rbp
  80233a:	48 83 ec 20          	sub    $0x20,%rsp
  80233e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802341:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802345:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802349:	78 06                	js     802351 <fd_lookup+0x1b>
  80234b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80234f:	7e 07                	jle    802358 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802351:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802356:	eb 6c                	jmp    8023c4 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802358:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80235b:	48 98                	cltq   
  80235d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802363:	48 c1 e0 0c          	shl    $0xc,%rax
  802367:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80236b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80236f:	48 c1 e8 15          	shr    $0x15,%rax
  802373:	48 89 c2             	mov    %rax,%rdx
  802376:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80237d:	01 00 00 
  802380:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802384:	83 e0 01             	and    $0x1,%eax
  802387:	48 85 c0             	test   %rax,%rax
  80238a:	74 21                	je     8023ad <fd_lookup+0x77>
  80238c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802390:	48 c1 e8 0c          	shr    $0xc,%rax
  802394:	48 89 c2             	mov    %rax,%rdx
  802397:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80239e:	01 00 00 
  8023a1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023a5:	83 e0 01             	and    $0x1,%eax
  8023a8:	48 85 c0             	test   %rax,%rax
  8023ab:	75 07                	jne    8023b4 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8023ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023b2:	eb 10                	jmp    8023c4 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8023b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023b8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8023bc:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8023bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023c4:	c9                   	leaveq 
  8023c5:	c3                   	retq   

00000000008023c6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8023c6:	55                   	push   %rbp
  8023c7:	48 89 e5             	mov    %rsp,%rbp
  8023ca:	48 83 ec 30          	sub    $0x30,%rsp
  8023ce:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8023d2:	89 f0                	mov    %esi,%eax
  8023d4:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8023d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023db:	48 89 c7             	mov    %rax,%rdi
  8023de:	48 b8 50 22 80 00 00 	movabs $0x802250,%rax
  8023e5:	00 00 00 
  8023e8:	ff d0                	callq  *%rax
  8023ea:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023ee:	48 89 d6             	mov    %rdx,%rsi
  8023f1:	89 c7                	mov    %eax,%edi
  8023f3:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  8023fa:	00 00 00 
  8023fd:	ff d0                	callq  *%rax
  8023ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802402:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802406:	78 0a                	js     802412 <fd_close+0x4c>
	    || fd != fd2)
  802408:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80240c:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802410:	74 12                	je     802424 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802412:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802416:	74 05                	je     80241d <fd_close+0x57>
  802418:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80241b:	eb 05                	jmp    802422 <fd_close+0x5c>
  80241d:	b8 00 00 00 00       	mov    $0x0,%eax
  802422:	eb 69                	jmp    80248d <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802424:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802428:	8b 00                	mov    (%rax),%eax
  80242a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80242e:	48 89 d6             	mov    %rdx,%rsi
  802431:	89 c7                	mov    %eax,%edi
  802433:	48 b8 8f 24 80 00 00 	movabs $0x80248f,%rax
  80243a:	00 00 00 
  80243d:	ff d0                	callq  *%rax
  80243f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802442:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802446:	78 2a                	js     802472 <fd_close+0xac>
		if (dev->dev_close)
  802448:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80244c:	48 8b 40 20          	mov    0x20(%rax),%rax
  802450:	48 85 c0             	test   %rax,%rax
  802453:	74 16                	je     80246b <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802455:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802459:	48 8b 40 20          	mov    0x20(%rax),%rax
  80245d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802461:	48 89 d7             	mov    %rdx,%rdi
  802464:	ff d0                	callq  *%rax
  802466:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802469:	eb 07                	jmp    802472 <fd_close+0xac>
		else
			r = 0;
  80246b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802472:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802476:	48 89 c6             	mov    %rax,%rsi
  802479:	bf 00 00 00 00       	mov    $0x0,%edi
  80247e:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  802485:	00 00 00 
  802488:	ff d0                	callq  *%rax
	return r;
  80248a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80248d:	c9                   	leaveq 
  80248e:	c3                   	retq   

000000000080248f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80248f:	55                   	push   %rbp
  802490:	48 89 e5             	mov    %rsp,%rbp
  802493:	48 83 ec 20          	sub    $0x20,%rsp
  802497:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80249a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80249e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024a5:	eb 41                	jmp    8024e8 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8024a7:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8024ae:	00 00 00 
  8024b1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024b4:	48 63 d2             	movslq %edx,%rdx
  8024b7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024bb:	8b 00                	mov    (%rax),%eax
  8024bd:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8024c0:	75 22                	jne    8024e4 <dev_lookup+0x55>
			*dev = devtab[i];
  8024c2:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8024c9:	00 00 00 
  8024cc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024cf:	48 63 d2             	movslq %edx,%rdx
  8024d2:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8024d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024da:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8024dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e2:	eb 60                	jmp    802544 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8024e4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8024e8:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8024ef:	00 00 00 
  8024f2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024f5:	48 63 d2             	movslq %edx,%rdx
  8024f8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024fc:	48 85 c0             	test   %rax,%rax
  8024ff:	75 a6                	jne    8024a7 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802501:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802508:	00 00 00 
  80250b:	48 8b 00             	mov    (%rax),%rax
  80250e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802514:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802517:	89 c6                	mov    %eax,%esi
  802519:	48 bf b8 42 80 00 00 	movabs $0x8042b8,%rdi
  802520:	00 00 00 
  802523:	b8 00 00 00 00       	mov    $0x0,%eax
  802528:	48 b9 cf 03 80 00 00 	movabs $0x8003cf,%rcx
  80252f:	00 00 00 
  802532:	ff d1                	callq  *%rcx
	*dev = 0;
  802534:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802538:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80253f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802544:	c9                   	leaveq 
  802545:	c3                   	retq   

0000000000802546 <close>:

int
close(int fdnum)
{
  802546:	55                   	push   %rbp
  802547:	48 89 e5             	mov    %rsp,%rbp
  80254a:	48 83 ec 20          	sub    $0x20,%rsp
  80254e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802551:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802555:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802558:	48 89 d6             	mov    %rdx,%rsi
  80255b:	89 c7                	mov    %eax,%edi
  80255d:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  802564:	00 00 00 
  802567:	ff d0                	callq  *%rax
  802569:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80256c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802570:	79 05                	jns    802577 <close+0x31>
		return r;
  802572:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802575:	eb 18                	jmp    80258f <close+0x49>
	else
		return fd_close(fd, 1);
  802577:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80257b:	be 01 00 00 00       	mov    $0x1,%esi
  802580:	48 89 c7             	mov    %rax,%rdi
  802583:	48 b8 c6 23 80 00 00 	movabs $0x8023c6,%rax
  80258a:	00 00 00 
  80258d:	ff d0                	callq  *%rax
}
  80258f:	c9                   	leaveq 
  802590:	c3                   	retq   

0000000000802591 <close_all>:

void
close_all(void)
{
  802591:	55                   	push   %rbp
  802592:	48 89 e5             	mov    %rsp,%rbp
  802595:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802599:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025a0:	eb 15                	jmp    8025b7 <close_all+0x26>
		close(i);
  8025a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025a5:	89 c7                	mov    %eax,%edi
  8025a7:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  8025ae:	00 00 00 
  8025b1:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8025b3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025b7:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8025bb:	7e e5                	jle    8025a2 <close_all+0x11>
		close(i);
}
  8025bd:	c9                   	leaveq 
  8025be:	c3                   	retq   

00000000008025bf <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8025bf:	55                   	push   %rbp
  8025c0:	48 89 e5             	mov    %rsp,%rbp
  8025c3:	48 83 ec 40          	sub    $0x40,%rsp
  8025c7:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8025ca:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8025cd:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8025d1:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8025d4:	48 89 d6             	mov    %rdx,%rsi
  8025d7:	89 c7                	mov    %eax,%edi
  8025d9:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  8025e0:	00 00 00 
  8025e3:	ff d0                	callq  *%rax
  8025e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025ec:	79 08                	jns    8025f6 <dup+0x37>
		return r;
  8025ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025f1:	e9 70 01 00 00       	jmpq   802766 <dup+0x1a7>
	close(newfdnum);
  8025f6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8025f9:	89 c7                	mov    %eax,%edi
  8025fb:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  802602:	00 00 00 
  802605:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802607:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80260a:	48 98                	cltq   
  80260c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802612:	48 c1 e0 0c          	shl    $0xc,%rax
  802616:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80261a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80261e:	48 89 c7             	mov    %rax,%rdi
  802621:	48 b8 73 22 80 00 00 	movabs $0x802273,%rax
  802628:	00 00 00 
  80262b:	ff d0                	callq  *%rax
  80262d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802631:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802635:	48 89 c7             	mov    %rax,%rdi
  802638:	48 b8 73 22 80 00 00 	movabs $0x802273,%rax
  80263f:	00 00 00 
  802642:	ff d0                	callq  *%rax
  802644:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802648:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80264c:	48 c1 e8 15          	shr    $0x15,%rax
  802650:	48 89 c2             	mov    %rax,%rdx
  802653:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80265a:	01 00 00 
  80265d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802661:	83 e0 01             	and    $0x1,%eax
  802664:	48 85 c0             	test   %rax,%rax
  802667:	74 73                	je     8026dc <dup+0x11d>
  802669:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80266d:	48 c1 e8 0c          	shr    $0xc,%rax
  802671:	48 89 c2             	mov    %rax,%rdx
  802674:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80267b:	01 00 00 
  80267e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802682:	83 e0 01             	and    $0x1,%eax
  802685:	48 85 c0             	test   %rax,%rax
  802688:	74 52                	je     8026dc <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80268a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80268e:	48 c1 e8 0c          	shr    $0xc,%rax
  802692:	48 89 c2             	mov    %rax,%rdx
  802695:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80269c:	01 00 00 
  80269f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026a3:	25 07 0e 00 00       	and    $0xe07,%eax
  8026a8:	89 c1                	mov    %eax,%ecx
  8026aa:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8026ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026b2:	41 89 c8             	mov    %ecx,%r8d
  8026b5:	48 89 d1             	mov    %rdx,%rcx
  8026b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8026bd:	48 89 c6             	mov    %rax,%rsi
  8026c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8026c5:	48 b8 03 19 80 00 00 	movabs $0x801903,%rax
  8026cc:	00 00 00 
  8026cf:	ff d0                	callq  *%rax
  8026d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026d8:	79 02                	jns    8026dc <dup+0x11d>
			goto err;
  8026da:	eb 57                	jmp    802733 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8026dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026e0:	48 c1 e8 0c          	shr    $0xc,%rax
  8026e4:	48 89 c2             	mov    %rax,%rdx
  8026e7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026ee:	01 00 00 
  8026f1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026f5:	25 07 0e 00 00       	and    $0xe07,%eax
  8026fa:	89 c1                	mov    %eax,%ecx
  8026fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802700:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802704:	41 89 c8             	mov    %ecx,%r8d
  802707:	48 89 d1             	mov    %rdx,%rcx
  80270a:	ba 00 00 00 00       	mov    $0x0,%edx
  80270f:	48 89 c6             	mov    %rax,%rsi
  802712:	bf 00 00 00 00       	mov    $0x0,%edi
  802717:	48 b8 03 19 80 00 00 	movabs $0x801903,%rax
  80271e:	00 00 00 
  802721:	ff d0                	callq  *%rax
  802723:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802726:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80272a:	79 02                	jns    80272e <dup+0x16f>
		goto err;
  80272c:	eb 05                	jmp    802733 <dup+0x174>

	return newfdnum;
  80272e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802731:	eb 33                	jmp    802766 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802733:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802737:	48 89 c6             	mov    %rax,%rsi
  80273a:	bf 00 00 00 00       	mov    $0x0,%edi
  80273f:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  802746:	00 00 00 
  802749:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80274b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80274f:	48 89 c6             	mov    %rax,%rsi
  802752:	bf 00 00 00 00       	mov    $0x0,%edi
  802757:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  80275e:	00 00 00 
  802761:	ff d0                	callq  *%rax
	return r;
  802763:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802766:	c9                   	leaveq 
  802767:	c3                   	retq   

0000000000802768 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802768:	55                   	push   %rbp
  802769:	48 89 e5             	mov    %rsp,%rbp
  80276c:	48 83 ec 40          	sub    $0x40,%rsp
  802770:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802773:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802777:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80277b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80277f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802782:	48 89 d6             	mov    %rdx,%rsi
  802785:	89 c7                	mov    %eax,%edi
  802787:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  80278e:	00 00 00 
  802791:	ff d0                	callq  *%rax
  802793:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802796:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80279a:	78 24                	js     8027c0 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80279c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027a0:	8b 00                	mov    (%rax),%eax
  8027a2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027a6:	48 89 d6             	mov    %rdx,%rsi
  8027a9:	89 c7                	mov    %eax,%edi
  8027ab:	48 b8 8f 24 80 00 00 	movabs $0x80248f,%rax
  8027b2:	00 00 00 
  8027b5:	ff d0                	callq  *%rax
  8027b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027be:	79 05                	jns    8027c5 <read+0x5d>
		return r;
  8027c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027c3:	eb 76                	jmp    80283b <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8027c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027c9:	8b 40 08             	mov    0x8(%rax),%eax
  8027cc:	83 e0 03             	and    $0x3,%eax
  8027cf:	83 f8 01             	cmp    $0x1,%eax
  8027d2:	75 3a                	jne    80280e <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8027d4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8027db:	00 00 00 
  8027de:	48 8b 00             	mov    (%rax),%rax
  8027e1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027e7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8027ea:	89 c6                	mov    %eax,%esi
  8027ec:	48 bf d7 42 80 00 00 	movabs $0x8042d7,%rdi
  8027f3:	00 00 00 
  8027f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027fb:	48 b9 cf 03 80 00 00 	movabs $0x8003cf,%rcx
  802802:	00 00 00 
  802805:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802807:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80280c:	eb 2d                	jmp    80283b <read+0xd3>
	}
	if (!dev->dev_read)
  80280e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802812:	48 8b 40 10          	mov    0x10(%rax),%rax
  802816:	48 85 c0             	test   %rax,%rax
  802819:	75 07                	jne    802822 <read+0xba>
		return -E_NOT_SUPP;
  80281b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802820:	eb 19                	jmp    80283b <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802822:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802826:	48 8b 40 10          	mov    0x10(%rax),%rax
  80282a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80282e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802832:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802836:	48 89 cf             	mov    %rcx,%rdi
  802839:	ff d0                	callq  *%rax
}
  80283b:	c9                   	leaveq 
  80283c:	c3                   	retq   

000000000080283d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80283d:	55                   	push   %rbp
  80283e:	48 89 e5             	mov    %rsp,%rbp
  802841:	48 83 ec 30          	sub    $0x30,%rsp
  802845:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802848:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80284c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802850:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802857:	eb 49                	jmp    8028a2 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802859:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80285c:	48 98                	cltq   
  80285e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802862:	48 29 c2             	sub    %rax,%rdx
  802865:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802868:	48 63 c8             	movslq %eax,%rcx
  80286b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80286f:	48 01 c1             	add    %rax,%rcx
  802872:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802875:	48 89 ce             	mov    %rcx,%rsi
  802878:	89 c7                	mov    %eax,%edi
  80287a:	48 b8 68 27 80 00 00 	movabs $0x802768,%rax
  802881:	00 00 00 
  802884:	ff d0                	callq  *%rax
  802886:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802889:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80288d:	79 05                	jns    802894 <readn+0x57>
			return m;
  80288f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802892:	eb 1c                	jmp    8028b0 <readn+0x73>
		if (m == 0)
  802894:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802898:	75 02                	jne    80289c <readn+0x5f>
			break;
  80289a:	eb 11                	jmp    8028ad <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80289c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80289f:	01 45 fc             	add    %eax,-0x4(%rbp)
  8028a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028a5:	48 98                	cltq   
  8028a7:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8028ab:	72 ac                	jb     802859 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8028ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8028b0:	c9                   	leaveq 
  8028b1:	c3                   	retq   

00000000008028b2 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8028b2:	55                   	push   %rbp
  8028b3:	48 89 e5             	mov    %rsp,%rbp
  8028b6:	48 83 ec 40          	sub    $0x40,%rsp
  8028ba:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028bd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8028c1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8028c5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028c9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028cc:	48 89 d6             	mov    %rdx,%rsi
  8028cf:	89 c7                	mov    %eax,%edi
  8028d1:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  8028d8:	00 00 00 
  8028db:	ff d0                	callq  *%rax
  8028dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028e4:	78 24                	js     80290a <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8028e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ea:	8b 00                	mov    (%rax),%eax
  8028ec:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028f0:	48 89 d6             	mov    %rdx,%rsi
  8028f3:	89 c7                	mov    %eax,%edi
  8028f5:	48 b8 8f 24 80 00 00 	movabs $0x80248f,%rax
  8028fc:	00 00 00 
  8028ff:	ff d0                	callq  *%rax
  802901:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802904:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802908:	79 05                	jns    80290f <write+0x5d>
		return r;
  80290a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80290d:	eb 75                	jmp    802984 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80290f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802913:	8b 40 08             	mov    0x8(%rax),%eax
  802916:	83 e0 03             	and    $0x3,%eax
  802919:	85 c0                	test   %eax,%eax
  80291b:	75 3a                	jne    802957 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80291d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802924:	00 00 00 
  802927:	48 8b 00             	mov    (%rax),%rax
  80292a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802930:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802933:	89 c6                	mov    %eax,%esi
  802935:	48 bf f3 42 80 00 00 	movabs $0x8042f3,%rdi
  80293c:	00 00 00 
  80293f:	b8 00 00 00 00       	mov    $0x0,%eax
  802944:	48 b9 cf 03 80 00 00 	movabs $0x8003cf,%rcx
  80294b:	00 00 00 
  80294e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802950:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802955:	eb 2d                	jmp    802984 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802957:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80295b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80295f:	48 85 c0             	test   %rax,%rax
  802962:	75 07                	jne    80296b <write+0xb9>
		return -E_NOT_SUPP;
  802964:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802969:	eb 19                	jmp    802984 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80296b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80296f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802973:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802977:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80297b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80297f:	48 89 cf             	mov    %rcx,%rdi
  802982:	ff d0                	callq  *%rax
}
  802984:	c9                   	leaveq 
  802985:	c3                   	retq   

0000000000802986 <seek>:

int
seek(int fdnum, off_t offset)
{
  802986:	55                   	push   %rbp
  802987:	48 89 e5             	mov    %rsp,%rbp
  80298a:	48 83 ec 18          	sub    $0x18,%rsp
  80298e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802991:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802994:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802998:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80299b:	48 89 d6             	mov    %rdx,%rsi
  80299e:	89 c7                	mov    %eax,%edi
  8029a0:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  8029a7:	00 00 00 
  8029aa:	ff d0                	callq  *%rax
  8029ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029b3:	79 05                	jns    8029ba <seek+0x34>
		return r;
  8029b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029b8:	eb 0f                	jmp    8029c9 <seek+0x43>
	fd->fd_offset = offset;
  8029ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029be:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8029c1:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8029c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029c9:	c9                   	leaveq 
  8029ca:	c3                   	retq   

00000000008029cb <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8029cb:	55                   	push   %rbp
  8029cc:	48 89 e5             	mov    %rsp,%rbp
  8029cf:	48 83 ec 30          	sub    $0x30,%rsp
  8029d3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029d6:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029d9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029dd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029e0:	48 89 d6             	mov    %rdx,%rsi
  8029e3:	89 c7                	mov    %eax,%edi
  8029e5:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  8029ec:	00 00 00 
  8029ef:	ff d0                	callq  *%rax
  8029f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029f8:	78 24                	js     802a1e <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029fe:	8b 00                	mov    (%rax),%eax
  802a00:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a04:	48 89 d6             	mov    %rdx,%rsi
  802a07:	89 c7                	mov    %eax,%edi
  802a09:	48 b8 8f 24 80 00 00 	movabs $0x80248f,%rax
  802a10:	00 00 00 
  802a13:	ff d0                	callq  *%rax
  802a15:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a18:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a1c:	79 05                	jns    802a23 <ftruncate+0x58>
		return r;
  802a1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a21:	eb 72                	jmp    802a95 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a27:	8b 40 08             	mov    0x8(%rax),%eax
  802a2a:	83 e0 03             	and    $0x3,%eax
  802a2d:	85 c0                	test   %eax,%eax
  802a2f:	75 3a                	jne    802a6b <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802a31:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802a38:	00 00 00 
  802a3b:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802a3e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a44:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a47:	89 c6                	mov    %eax,%esi
  802a49:	48 bf 10 43 80 00 00 	movabs $0x804310,%rdi
  802a50:	00 00 00 
  802a53:	b8 00 00 00 00       	mov    $0x0,%eax
  802a58:	48 b9 cf 03 80 00 00 	movabs $0x8003cf,%rcx
  802a5f:	00 00 00 
  802a62:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802a64:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a69:	eb 2a                	jmp    802a95 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802a6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a6f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802a73:	48 85 c0             	test   %rax,%rax
  802a76:	75 07                	jne    802a7f <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802a78:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a7d:	eb 16                	jmp    802a95 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802a7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a83:	48 8b 40 30          	mov    0x30(%rax),%rax
  802a87:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a8b:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802a8e:	89 ce                	mov    %ecx,%esi
  802a90:	48 89 d7             	mov    %rdx,%rdi
  802a93:	ff d0                	callq  *%rax
}
  802a95:	c9                   	leaveq 
  802a96:	c3                   	retq   

0000000000802a97 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802a97:	55                   	push   %rbp
  802a98:	48 89 e5             	mov    %rsp,%rbp
  802a9b:	48 83 ec 30          	sub    $0x30,%rsp
  802a9f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802aa2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802aa6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802aaa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802aad:	48 89 d6             	mov    %rdx,%rsi
  802ab0:	89 c7                	mov    %eax,%edi
  802ab2:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  802ab9:	00 00 00 
  802abc:	ff d0                	callq  *%rax
  802abe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ac1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ac5:	78 24                	js     802aeb <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ac7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802acb:	8b 00                	mov    (%rax),%eax
  802acd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ad1:	48 89 d6             	mov    %rdx,%rsi
  802ad4:	89 c7                	mov    %eax,%edi
  802ad6:	48 b8 8f 24 80 00 00 	movabs $0x80248f,%rax
  802add:	00 00 00 
  802ae0:	ff d0                	callq  *%rax
  802ae2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ae5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ae9:	79 05                	jns    802af0 <fstat+0x59>
		return r;
  802aeb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aee:	eb 5e                	jmp    802b4e <fstat+0xb7>
	if (!dev->dev_stat)
  802af0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802af4:	48 8b 40 28          	mov    0x28(%rax),%rax
  802af8:	48 85 c0             	test   %rax,%rax
  802afb:	75 07                	jne    802b04 <fstat+0x6d>
		return -E_NOT_SUPP;
  802afd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b02:	eb 4a                	jmp    802b4e <fstat+0xb7>
	stat->st_name[0] = 0;
  802b04:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b08:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802b0b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b0f:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802b16:	00 00 00 
	stat->st_isdir = 0;
  802b19:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b1d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802b24:	00 00 00 
	stat->st_dev = dev;
  802b27:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b2b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b2f:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802b36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b3a:	48 8b 40 28          	mov    0x28(%rax),%rax
  802b3e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b42:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802b46:	48 89 ce             	mov    %rcx,%rsi
  802b49:	48 89 d7             	mov    %rdx,%rdi
  802b4c:	ff d0                	callq  *%rax
}
  802b4e:	c9                   	leaveq 
  802b4f:	c3                   	retq   

0000000000802b50 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802b50:	55                   	push   %rbp
  802b51:	48 89 e5             	mov    %rsp,%rbp
  802b54:	48 83 ec 20          	sub    $0x20,%rsp
  802b58:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b5c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802b60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b64:	be 00 00 00 00       	mov    $0x0,%esi
  802b69:	48 89 c7             	mov    %rax,%rdi
  802b6c:	48 b8 3e 2c 80 00 00 	movabs $0x802c3e,%rax
  802b73:	00 00 00 
  802b76:	ff d0                	callq  *%rax
  802b78:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b7b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b7f:	79 05                	jns    802b86 <stat+0x36>
		return fd;
  802b81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b84:	eb 2f                	jmp    802bb5 <stat+0x65>
	r = fstat(fd, stat);
  802b86:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b8d:	48 89 d6             	mov    %rdx,%rsi
  802b90:	89 c7                	mov    %eax,%edi
  802b92:	48 b8 97 2a 80 00 00 	movabs $0x802a97,%rax
  802b99:	00 00 00 
  802b9c:	ff d0                	callq  *%rax
  802b9e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802ba1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba4:	89 c7                	mov    %eax,%edi
  802ba6:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  802bad:	00 00 00 
  802bb0:	ff d0                	callq  *%rax
	return r;
  802bb2:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802bb5:	c9                   	leaveq 
  802bb6:	c3                   	retq   

0000000000802bb7 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802bb7:	55                   	push   %rbp
  802bb8:	48 89 e5             	mov    %rsp,%rbp
  802bbb:	48 83 ec 10          	sub    $0x10,%rsp
  802bbf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802bc2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802bc6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802bcd:	00 00 00 
  802bd0:	8b 00                	mov    (%rax),%eax
  802bd2:	85 c0                	test   %eax,%eax
  802bd4:	75 1d                	jne    802bf3 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802bd6:	bf 01 00 00 00       	mov    $0x1,%edi
  802bdb:	48 b8 ce 21 80 00 00 	movabs $0x8021ce,%rax
  802be2:	00 00 00 
  802be5:	ff d0                	callq  *%rax
  802be7:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802bee:	00 00 00 
  802bf1:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802bf3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802bfa:	00 00 00 
  802bfd:	8b 00                	mov    (%rax),%eax
  802bff:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802c02:	b9 07 00 00 00       	mov    $0x7,%ecx
  802c07:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802c0e:	00 00 00 
  802c11:	89 c7                	mov    %eax,%edi
  802c13:	48 b8 31 21 80 00 00 	movabs $0x802131,%rax
  802c1a:	00 00 00 
  802c1d:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802c1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c23:	ba 00 00 00 00       	mov    $0x0,%edx
  802c28:	48 89 c6             	mov    %rax,%rsi
  802c2b:	bf 00 00 00 00       	mov    $0x0,%edi
  802c30:	48 b8 6b 20 80 00 00 	movabs $0x80206b,%rax
  802c37:	00 00 00 
  802c3a:	ff d0                	callq  *%rax
}
  802c3c:	c9                   	leaveq 
  802c3d:	c3                   	retq   

0000000000802c3e <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802c3e:	55                   	push   %rbp
  802c3f:	48 89 e5             	mov    %rsp,%rbp
  802c42:	48 83 ec 20          	sub    $0x20,%rsp
  802c46:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c4a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  802c4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c51:	48 89 c7             	mov    %rax,%rdi
  802c54:	48 b8 18 0f 80 00 00 	movabs $0x800f18,%rax
  802c5b:	00 00 00 
  802c5e:	ff d0                	callq  *%rax
  802c60:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802c65:	7e 0a                	jle    802c71 <open+0x33>
  802c67:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c6c:	e9 a5 00 00 00       	jmpq   802d16 <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  802c71:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802c75:	48 89 c7             	mov    %rax,%rdi
  802c78:	48 b8 9e 22 80 00 00 	movabs $0x80229e,%rax
  802c7f:	00 00 00 
  802c82:	ff d0                	callq  *%rax
  802c84:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c87:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c8b:	79 08                	jns    802c95 <open+0x57>
		return r;
  802c8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c90:	e9 81 00 00 00       	jmpq   802d16 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  802c95:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c9c:	00 00 00 
  802c9f:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802ca2:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  802ca8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cac:	48 89 c6             	mov    %rax,%rsi
  802caf:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802cb6:	00 00 00 
  802cb9:	48 b8 84 0f 80 00 00 	movabs $0x800f84,%rax
  802cc0:	00 00 00 
  802cc3:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  802cc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cc9:	48 89 c6             	mov    %rax,%rsi
  802ccc:	bf 01 00 00 00       	mov    $0x1,%edi
  802cd1:	48 b8 b7 2b 80 00 00 	movabs $0x802bb7,%rax
  802cd8:	00 00 00 
  802cdb:	ff d0                	callq  *%rax
  802cdd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ce0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ce4:	79 1d                	jns    802d03 <open+0xc5>
		fd_close(fd, 0);
  802ce6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cea:	be 00 00 00 00       	mov    $0x0,%esi
  802cef:	48 89 c7             	mov    %rax,%rdi
  802cf2:	48 b8 c6 23 80 00 00 	movabs $0x8023c6,%rax
  802cf9:	00 00 00 
  802cfc:	ff d0                	callq  *%rax
		return r;
  802cfe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d01:	eb 13                	jmp    802d16 <open+0xd8>
	}
	return fd2num(fd);
  802d03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d07:	48 89 c7             	mov    %rax,%rdi
  802d0a:	48 b8 50 22 80 00 00 	movabs $0x802250,%rax
  802d11:	00 00 00 
  802d14:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  802d16:	c9                   	leaveq 
  802d17:	c3                   	retq   

0000000000802d18 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802d18:	55                   	push   %rbp
  802d19:	48 89 e5             	mov    %rsp,%rbp
  802d1c:	48 83 ec 10          	sub    $0x10,%rsp
  802d20:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802d24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d28:	8b 50 0c             	mov    0xc(%rax),%edx
  802d2b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d32:	00 00 00 
  802d35:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802d37:	be 00 00 00 00       	mov    $0x0,%esi
  802d3c:	bf 06 00 00 00       	mov    $0x6,%edi
  802d41:	48 b8 b7 2b 80 00 00 	movabs $0x802bb7,%rax
  802d48:	00 00 00 
  802d4b:	ff d0                	callq  *%rax
}
  802d4d:	c9                   	leaveq 
  802d4e:	c3                   	retq   

0000000000802d4f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802d4f:	55                   	push   %rbp
  802d50:	48 89 e5             	mov    %rsp,%rbp
  802d53:	48 83 ec 30          	sub    $0x30,%rsp
  802d57:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d5b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d5f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802d63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d67:	8b 50 0c             	mov    0xc(%rax),%edx
  802d6a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d71:	00 00 00 
  802d74:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802d76:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d7d:	00 00 00 
  802d80:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d84:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  802d88:	be 00 00 00 00       	mov    $0x0,%esi
  802d8d:	bf 03 00 00 00       	mov    $0x3,%edi
  802d92:	48 b8 b7 2b 80 00 00 	movabs $0x802bb7,%rax
  802d99:	00 00 00 
  802d9c:	ff d0                	callq  *%rax
  802d9e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802da1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802da5:	79 05                	jns    802dac <devfile_read+0x5d>
		return r;
  802da7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802daa:	eb 26                	jmp    802dd2 <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  802dac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802daf:	48 63 d0             	movslq %eax,%rdx
  802db2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802db6:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802dbd:	00 00 00 
  802dc0:	48 89 c7             	mov    %rax,%rdi
  802dc3:	48 b8 bf 13 80 00 00 	movabs $0x8013bf,%rax
  802dca:	00 00 00 
  802dcd:	ff d0                	callq  *%rax
	return r;
  802dcf:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802dd2:	c9                   	leaveq 
  802dd3:	c3                   	retq   

0000000000802dd4 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802dd4:	55                   	push   %rbp
  802dd5:	48 89 e5             	mov    %rsp,%rbp
  802dd8:	48 83 ec 30          	sub    $0x30,%rsp
  802ddc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802de0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802de4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  802de8:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  802def:	00 
	n = n > max ? max : n;
  802df0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802df4:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802df8:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  802dfd:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802e01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e05:	8b 50 0c             	mov    0xc(%rax),%edx
  802e08:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e0f:	00 00 00 
  802e12:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802e14:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e1b:	00 00 00 
  802e1e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e22:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802e26:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e2a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e2e:	48 89 c6             	mov    %rax,%rsi
  802e31:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802e38:	00 00 00 
  802e3b:	48 b8 bf 13 80 00 00 	movabs $0x8013bf,%rax
  802e42:	00 00 00 
  802e45:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  802e47:	be 00 00 00 00       	mov    $0x0,%esi
  802e4c:	bf 04 00 00 00       	mov    $0x4,%edi
  802e51:	48 b8 b7 2b 80 00 00 	movabs $0x802bb7,%rax
  802e58:	00 00 00 
  802e5b:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  802e5d:	c9                   	leaveq 
  802e5e:	c3                   	retq   

0000000000802e5f <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802e5f:	55                   	push   %rbp
  802e60:	48 89 e5             	mov    %rsp,%rbp
  802e63:	48 83 ec 20          	sub    $0x20,%rsp
  802e67:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e6b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802e6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e73:	8b 50 0c             	mov    0xc(%rax),%edx
  802e76:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e7d:	00 00 00 
  802e80:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802e82:	be 00 00 00 00       	mov    $0x0,%esi
  802e87:	bf 05 00 00 00       	mov    $0x5,%edi
  802e8c:	48 b8 b7 2b 80 00 00 	movabs $0x802bb7,%rax
  802e93:	00 00 00 
  802e96:	ff d0                	callq  *%rax
  802e98:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e9b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e9f:	79 05                	jns    802ea6 <devfile_stat+0x47>
		return r;
  802ea1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ea4:	eb 56                	jmp    802efc <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802ea6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802eaa:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802eb1:	00 00 00 
  802eb4:	48 89 c7             	mov    %rax,%rdi
  802eb7:	48 b8 84 0f 80 00 00 	movabs $0x800f84,%rax
  802ebe:	00 00 00 
  802ec1:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802ec3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802eca:	00 00 00 
  802ecd:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802ed3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ed7:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802edd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ee4:	00 00 00 
  802ee7:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802eed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ef1:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802ef7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802efc:	c9                   	leaveq 
  802efd:	c3                   	retq   

0000000000802efe <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802efe:	55                   	push   %rbp
  802eff:	48 89 e5             	mov    %rsp,%rbp
  802f02:	48 83 ec 10          	sub    $0x10,%rsp
  802f06:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f0a:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802f0d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f11:	8b 50 0c             	mov    0xc(%rax),%edx
  802f14:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f1b:	00 00 00 
  802f1e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802f20:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f27:	00 00 00 
  802f2a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802f2d:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802f30:	be 00 00 00 00       	mov    $0x0,%esi
  802f35:	bf 02 00 00 00       	mov    $0x2,%edi
  802f3a:	48 b8 b7 2b 80 00 00 	movabs $0x802bb7,%rax
  802f41:	00 00 00 
  802f44:	ff d0                	callq  *%rax
}
  802f46:	c9                   	leaveq 
  802f47:	c3                   	retq   

0000000000802f48 <remove>:

// Delete a file
int
remove(const char *path)
{
  802f48:	55                   	push   %rbp
  802f49:	48 89 e5             	mov    %rsp,%rbp
  802f4c:	48 83 ec 10          	sub    $0x10,%rsp
  802f50:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802f54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f58:	48 89 c7             	mov    %rax,%rdi
  802f5b:	48 b8 18 0f 80 00 00 	movabs $0x800f18,%rax
  802f62:	00 00 00 
  802f65:	ff d0                	callq  *%rax
  802f67:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802f6c:	7e 07                	jle    802f75 <remove+0x2d>
		return -E_BAD_PATH;
  802f6e:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802f73:	eb 33                	jmp    802fa8 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802f75:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f79:	48 89 c6             	mov    %rax,%rsi
  802f7c:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802f83:	00 00 00 
  802f86:	48 b8 84 0f 80 00 00 	movabs $0x800f84,%rax
  802f8d:	00 00 00 
  802f90:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802f92:	be 00 00 00 00       	mov    $0x0,%esi
  802f97:	bf 07 00 00 00       	mov    $0x7,%edi
  802f9c:	48 b8 b7 2b 80 00 00 	movabs $0x802bb7,%rax
  802fa3:	00 00 00 
  802fa6:	ff d0                	callq  *%rax
}
  802fa8:	c9                   	leaveq 
  802fa9:	c3                   	retq   

0000000000802faa <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802faa:	55                   	push   %rbp
  802fab:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802fae:	be 00 00 00 00       	mov    $0x0,%esi
  802fb3:	bf 08 00 00 00       	mov    $0x8,%edi
  802fb8:	48 b8 b7 2b 80 00 00 	movabs $0x802bb7,%rax
  802fbf:	00 00 00 
  802fc2:	ff d0                	callq  *%rax
}
  802fc4:	5d                   	pop    %rbp
  802fc5:	c3                   	retq   

0000000000802fc6 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802fc6:	55                   	push   %rbp
  802fc7:	48 89 e5             	mov    %rsp,%rbp
  802fca:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802fd1:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802fd8:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802fdf:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802fe6:	be 00 00 00 00       	mov    $0x0,%esi
  802feb:	48 89 c7             	mov    %rax,%rdi
  802fee:	48 b8 3e 2c 80 00 00 	movabs $0x802c3e,%rax
  802ff5:	00 00 00 
  802ff8:	ff d0                	callq  *%rax
  802ffa:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802ffd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803001:	79 28                	jns    80302b <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803003:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803006:	89 c6                	mov    %eax,%esi
  803008:	48 bf 36 43 80 00 00 	movabs $0x804336,%rdi
  80300f:	00 00 00 
  803012:	b8 00 00 00 00       	mov    $0x0,%eax
  803017:	48 ba cf 03 80 00 00 	movabs $0x8003cf,%rdx
  80301e:	00 00 00 
  803021:	ff d2                	callq  *%rdx
		return fd_src;
  803023:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803026:	e9 74 01 00 00       	jmpq   80319f <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80302b:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803032:	be 01 01 00 00       	mov    $0x101,%esi
  803037:	48 89 c7             	mov    %rax,%rdi
  80303a:	48 b8 3e 2c 80 00 00 	movabs $0x802c3e,%rax
  803041:	00 00 00 
  803044:	ff d0                	callq  *%rax
  803046:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803049:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80304d:	79 39                	jns    803088 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80304f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803052:	89 c6                	mov    %eax,%esi
  803054:	48 bf 4c 43 80 00 00 	movabs $0x80434c,%rdi
  80305b:	00 00 00 
  80305e:	b8 00 00 00 00       	mov    $0x0,%eax
  803063:	48 ba cf 03 80 00 00 	movabs $0x8003cf,%rdx
  80306a:	00 00 00 
  80306d:	ff d2                	callq  *%rdx
		close(fd_src);
  80306f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803072:	89 c7                	mov    %eax,%edi
  803074:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  80307b:	00 00 00 
  80307e:	ff d0                	callq  *%rax
		return fd_dest;
  803080:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803083:	e9 17 01 00 00       	jmpq   80319f <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803088:	eb 74                	jmp    8030fe <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80308a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80308d:	48 63 d0             	movslq %eax,%rdx
  803090:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803097:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80309a:	48 89 ce             	mov    %rcx,%rsi
  80309d:	89 c7                	mov    %eax,%edi
  80309f:	48 b8 b2 28 80 00 00 	movabs $0x8028b2,%rax
  8030a6:	00 00 00 
  8030a9:	ff d0                	callq  *%rax
  8030ab:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8030ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8030b2:	79 4a                	jns    8030fe <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8030b4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8030b7:	89 c6                	mov    %eax,%esi
  8030b9:	48 bf 66 43 80 00 00 	movabs $0x804366,%rdi
  8030c0:	00 00 00 
  8030c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8030c8:	48 ba cf 03 80 00 00 	movabs $0x8003cf,%rdx
  8030cf:	00 00 00 
  8030d2:	ff d2                	callq  *%rdx
			close(fd_src);
  8030d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030d7:	89 c7                	mov    %eax,%edi
  8030d9:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  8030e0:	00 00 00 
  8030e3:	ff d0                	callq  *%rax
			close(fd_dest);
  8030e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030e8:	89 c7                	mov    %eax,%edi
  8030ea:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  8030f1:	00 00 00 
  8030f4:	ff d0                	callq  *%rax
			return write_size;
  8030f6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8030f9:	e9 a1 00 00 00       	jmpq   80319f <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8030fe:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803105:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803108:	ba 00 02 00 00       	mov    $0x200,%edx
  80310d:	48 89 ce             	mov    %rcx,%rsi
  803110:	89 c7                	mov    %eax,%edi
  803112:	48 b8 68 27 80 00 00 	movabs $0x802768,%rax
  803119:	00 00 00 
  80311c:	ff d0                	callq  *%rax
  80311e:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803121:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803125:	0f 8f 5f ff ff ff    	jg     80308a <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80312b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80312f:	79 47                	jns    803178 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803131:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803134:	89 c6                	mov    %eax,%esi
  803136:	48 bf 79 43 80 00 00 	movabs $0x804379,%rdi
  80313d:	00 00 00 
  803140:	b8 00 00 00 00       	mov    $0x0,%eax
  803145:	48 ba cf 03 80 00 00 	movabs $0x8003cf,%rdx
  80314c:	00 00 00 
  80314f:	ff d2                	callq  *%rdx
		close(fd_src);
  803151:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803154:	89 c7                	mov    %eax,%edi
  803156:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  80315d:	00 00 00 
  803160:	ff d0                	callq  *%rax
		close(fd_dest);
  803162:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803165:	89 c7                	mov    %eax,%edi
  803167:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  80316e:	00 00 00 
  803171:	ff d0                	callq  *%rax
		return read_size;
  803173:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803176:	eb 27                	jmp    80319f <copy+0x1d9>
	}
	close(fd_src);
  803178:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80317b:	89 c7                	mov    %eax,%edi
  80317d:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  803184:	00 00 00 
  803187:	ff d0                	callq  *%rax
	close(fd_dest);
  803189:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80318c:	89 c7                	mov    %eax,%edi
  80318e:	48 b8 46 25 80 00 00 	movabs $0x802546,%rax
  803195:	00 00 00 
  803198:	ff d0                	callq  *%rax
	return 0;
  80319a:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80319f:	c9                   	leaveq 
  8031a0:	c3                   	retq   

00000000008031a1 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8031a1:	55                   	push   %rbp
  8031a2:	48 89 e5             	mov    %rsp,%rbp
  8031a5:	53                   	push   %rbx
  8031a6:	48 83 ec 38          	sub    $0x38,%rsp
  8031aa:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8031ae:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8031b2:	48 89 c7             	mov    %rax,%rdi
  8031b5:	48 b8 9e 22 80 00 00 	movabs $0x80229e,%rax
  8031bc:	00 00 00 
  8031bf:	ff d0                	callq  *%rax
  8031c1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031c8:	0f 88 bf 01 00 00    	js     80338d <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031d2:	ba 07 04 00 00       	mov    $0x407,%edx
  8031d7:	48 89 c6             	mov    %rax,%rsi
  8031da:	bf 00 00 00 00       	mov    $0x0,%edi
  8031df:	48 b8 b3 18 80 00 00 	movabs $0x8018b3,%rax
  8031e6:	00 00 00 
  8031e9:	ff d0                	callq  *%rax
  8031eb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031f2:	0f 88 95 01 00 00    	js     80338d <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8031f8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8031fc:	48 89 c7             	mov    %rax,%rdi
  8031ff:	48 b8 9e 22 80 00 00 	movabs $0x80229e,%rax
  803206:	00 00 00 
  803209:	ff d0                	callq  *%rax
  80320b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80320e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803212:	0f 88 5d 01 00 00    	js     803375 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803218:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80321c:	ba 07 04 00 00       	mov    $0x407,%edx
  803221:	48 89 c6             	mov    %rax,%rsi
  803224:	bf 00 00 00 00       	mov    $0x0,%edi
  803229:	48 b8 b3 18 80 00 00 	movabs $0x8018b3,%rax
  803230:	00 00 00 
  803233:	ff d0                	callq  *%rax
  803235:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803238:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80323c:	0f 88 33 01 00 00    	js     803375 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803242:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803246:	48 89 c7             	mov    %rax,%rdi
  803249:	48 b8 73 22 80 00 00 	movabs $0x802273,%rax
  803250:	00 00 00 
  803253:	ff d0                	callq  *%rax
  803255:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803259:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80325d:	ba 07 04 00 00       	mov    $0x407,%edx
  803262:	48 89 c6             	mov    %rax,%rsi
  803265:	bf 00 00 00 00       	mov    $0x0,%edi
  80326a:	48 b8 b3 18 80 00 00 	movabs $0x8018b3,%rax
  803271:	00 00 00 
  803274:	ff d0                	callq  *%rax
  803276:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803279:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80327d:	79 05                	jns    803284 <pipe+0xe3>
		goto err2;
  80327f:	e9 d9 00 00 00       	jmpq   80335d <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803284:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803288:	48 89 c7             	mov    %rax,%rdi
  80328b:	48 b8 73 22 80 00 00 	movabs $0x802273,%rax
  803292:	00 00 00 
  803295:	ff d0                	callq  *%rax
  803297:	48 89 c2             	mov    %rax,%rdx
  80329a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80329e:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8032a4:	48 89 d1             	mov    %rdx,%rcx
  8032a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8032ac:	48 89 c6             	mov    %rax,%rsi
  8032af:	bf 00 00 00 00       	mov    $0x0,%edi
  8032b4:	48 b8 03 19 80 00 00 	movabs $0x801903,%rax
  8032bb:	00 00 00 
  8032be:	ff d0                	callq  *%rax
  8032c0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032c7:	79 1b                	jns    8032e4 <pipe+0x143>
		goto err3;
  8032c9:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8032ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032ce:	48 89 c6             	mov    %rax,%rsi
  8032d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8032d6:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  8032dd:	00 00 00 
  8032e0:	ff d0                	callq  *%rax
  8032e2:	eb 79                	jmp    80335d <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8032e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032e8:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  8032ef:	00 00 00 
  8032f2:	8b 12                	mov    (%rdx),%edx
  8032f4:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8032f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032fa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803301:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803305:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  80330c:	00 00 00 
  80330f:	8b 12                	mov    (%rdx),%edx
  803311:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803313:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803317:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80331e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803322:	48 89 c7             	mov    %rax,%rdi
  803325:	48 b8 50 22 80 00 00 	movabs $0x802250,%rax
  80332c:	00 00 00 
  80332f:	ff d0                	callq  *%rax
  803331:	89 c2                	mov    %eax,%edx
  803333:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803337:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803339:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80333d:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803341:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803345:	48 89 c7             	mov    %rax,%rdi
  803348:	48 b8 50 22 80 00 00 	movabs $0x802250,%rax
  80334f:	00 00 00 
  803352:	ff d0                	callq  *%rax
  803354:	89 03                	mov    %eax,(%rbx)
	return 0;
  803356:	b8 00 00 00 00       	mov    $0x0,%eax
  80335b:	eb 33                	jmp    803390 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80335d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803361:	48 89 c6             	mov    %rax,%rsi
  803364:	bf 00 00 00 00       	mov    $0x0,%edi
  803369:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  803370:	00 00 00 
  803373:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803375:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803379:	48 89 c6             	mov    %rax,%rsi
  80337c:	bf 00 00 00 00       	mov    $0x0,%edi
  803381:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  803388:	00 00 00 
  80338b:	ff d0                	callq  *%rax
err:
	return r;
  80338d:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803390:	48 83 c4 38          	add    $0x38,%rsp
  803394:	5b                   	pop    %rbx
  803395:	5d                   	pop    %rbp
  803396:	c3                   	retq   

0000000000803397 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803397:	55                   	push   %rbp
  803398:	48 89 e5             	mov    %rsp,%rbp
  80339b:	53                   	push   %rbx
  80339c:	48 83 ec 28          	sub    $0x28,%rsp
  8033a0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8033a4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8033a8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8033af:	00 00 00 
  8033b2:	48 8b 00             	mov    (%rax),%rax
  8033b5:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8033bb:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8033be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033c2:	48 89 c7             	mov    %rax,%rdi
  8033c5:	48 b8 50 3c 80 00 00 	movabs $0x803c50,%rax
  8033cc:	00 00 00 
  8033cf:	ff d0                	callq  *%rax
  8033d1:	89 c3                	mov    %eax,%ebx
  8033d3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033d7:	48 89 c7             	mov    %rax,%rdi
  8033da:	48 b8 50 3c 80 00 00 	movabs $0x803c50,%rax
  8033e1:	00 00 00 
  8033e4:	ff d0                	callq  *%rax
  8033e6:	39 c3                	cmp    %eax,%ebx
  8033e8:	0f 94 c0             	sete   %al
  8033eb:	0f b6 c0             	movzbl %al,%eax
  8033ee:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8033f1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8033f8:	00 00 00 
  8033fb:	48 8b 00             	mov    (%rax),%rax
  8033fe:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803404:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803407:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80340a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80340d:	75 05                	jne    803414 <_pipeisclosed+0x7d>
			return ret;
  80340f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803412:	eb 4f                	jmp    803463 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803414:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803417:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80341a:	74 42                	je     80345e <_pipeisclosed+0xc7>
  80341c:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803420:	75 3c                	jne    80345e <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803422:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803429:	00 00 00 
  80342c:	48 8b 00             	mov    (%rax),%rax
  80342f:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803435:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803438:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80343b:	89 c6                	mov    %eax,%esi
  80343d:	48 bf 94 43 80 00 00 	movabs $0x804394,%rdi
  803444:	00 00 00 
  803447:	b8 00 00 00 00       	mov    $0x0,%eax
  80344c:	49 b8 cf 03 80 00 00 	movabs $0x8003cf,%r8
  803453:	00 00 00 
  803456:	41 ff d0             	callq  *%r8
	}
  803459:	e9 4a ff ff ff       	jmpq   8033a8 <_pipeisclosed+0x11>
  80345e:	e9 45 ff ff ff       	jmpq   8033a8 <_pipeisclosed+0x11>
}
  803463:	48 83 c4 28          	add    $0x28,%rsp
  803467:	5b                   	pop    %rbx
  803468:	5d                   	pop    %rbp
  803469:	c3                   	retq   

000000000080346a <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80346a:	55                   	push   %rbp
  80346b:	48 89 e5             	mov    %rsp,%rbp
  80346e:	48 83 ec 30          	sub    $0x30,%rsp
  803472:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803475:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803479:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80347c:	48 89 d6             	mov    %rdx,%rsi
  80347f:	89 c7                	mov    %eax,%edi
  803481:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  803488:	00 00 00 
  80348b:	ff d0                	callq  *%rax
  80348d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803490:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803494:	79 05                	jns    80349b <pipeisclosed+0x31>
		return r;
  803496:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803499:	eb 31                	jmp    8034cc <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80349b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80349f:	48 89 c7             	mov    %rax,%rdi
  8034a2:	48 b8 73 22 80 00 00 	movabs $0x802273,%rax
  8034a9:	00 00 00 
  8034ac:	ff d0                	callq  *%rax
  8034ae:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8034b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034b6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8034ba:	48 89 d6             	mov    %rdx,%rsi
  8034bd:	48 89 c7             	mov    %rax,%rdi
  8034c0:	48 b8 97 33 80 00 00 	movabs $0x803397,%rax
  8034c7:	00 00 00 
  8034ca:	ff d0                	callq  *%rax
}
  8034cc:	c9                   	leaveq 
  8034cd:	c3                   	retq   

00000000008034ce <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8034ce:	55                   	push   %rbp
  8034cf:	48 89 e5             	mov    %rsp,%rbp
  8034d2:	48 83 ec 40          	sub    $0x40,%rsp
  8034d6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8034da:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8034de:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8034e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034e6:	48 89 c7             	mov    %rax,%rdi
  8034e9:	48 b8 73 22 80 00 00 	movabs $0x802273,%rax
  8034f0:	00 00 00 
  8034f3:	ff d0                	callq  *%rax
  8034f5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8034f9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034fd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803501:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803508:	00 
  803509:	e9 92 00 00 00       	jmpq   8035a0 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80350e:	eb 41                	jmp    803551 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803510:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803515:	74 09                	je     803520 <devpipe_read+0x52>
				return i;
  803517:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80351b:	e9 92 00 00 00       	jmpq   8035b2 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803520:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803524:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803528:	48 89 d6             	mov    %rdx,%rsi
  80352b:	48 89 c7             	mov    %rax,%rdi
  80352e:	48 b8 97 33 80 00 00 	movabs $0x803397,%rax
  803535:	00 00 00 
  803538:	ff d0                	callq  *%rax
  80353a:	85 c0                	test   %eax,%eax
  80353c:	74 07                	je     803545 <devpipe_read+0x77>
				return 0;
  80353e:	b8 00 00 00 00       	mov    $0x0,%eax
  803543:	eb 6d                	jmp    8035b2 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803545:	48 b8 75 18 80 00 00 	movabs $0x801875,%rax
  80354c:	00 00 00 
  80354f:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803551:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803555:	8b 10                	mov    (%rax),%edx
  803557:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80355b:	8b 40 04             	mov    0x4(%rax),%eax
  80355e:	39 c2                	cmp    %eax,%edx
  803560:	74 ae                	je     803510 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803562:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803566:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80356a:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80356e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803572:	8b 00                	mov    (%rax),%eax
  803574:	99                   	cltd   
  803575:	c1 ea 1b             	shr    $0x1b,%edx
  803578:	01 d0                	add    %edx,%eax
  80357a:	83 e0 1f             	and    $0x1f,%eax
  80357d:	29 d0                	sub    %edx,%eax
  80357f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803583:	48 98                	cltq   
  803585:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80358a:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80358c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803590:	8b 00                	mov    (%rax),%eax
  803592:	8d 50 01             	lea    0x1(%rax),%edx
  803595:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803599:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80359b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8035a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035a4:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8035a8:	0f 82 60 ff ff ff    	jb     80350e <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8035ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8035b2:	c9                   	leaveq 
  8035b3:	c3                   	retq   

00000000008035b4 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8035b4:	55                   	push   %rbp
  8035b5:	48 89 e5             	mov    %rsp,%rbp
  8035b8:	48 83 ec 40          	sub    $0x40,%rsp
  8035bc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8035c0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8035c4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8035c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035cc:	48 89 c7             	mov    %rax,%rdi
  8035cf:	48 b8 73 22 80 00 00 	movabs $0x802273,%rax
  8035d6:	00 00 00 
  8035d9:	ff d0                	callq  *%rax
  8035db:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8035df:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035e3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8035e7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8035ee:	00 
  8035ef:	e9 8e 00 00 00       	jmpq   803682 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8035f4:	eb 31                	jmp    803627 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8035f6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035fe:	48 89 d6             	mov    %rdx,%rsi
  803601:	48 89 c7             	mov    %rax,%rdi
  803604:	48 b8 97 33 80 00 00 	movabs $0x803397,%rax
  80360b:	00 00 00 
  80360e:	ff d0                	callq  *%rax
  803610:	85 c0                	test   %eax,%eax
  803612:	74 07                	je     80361b <devpipe_write+0x67>
				return 0;
  803614:	b8 00 00 00 00       	mov    $0x0,%eax
  803619:	eb 79                	jmp    803694 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80361b:	48 b8 75 18 80 00 00 	movabs $0x801875,%rax
  803622:	00 00 00 
  803625:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803627:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80362b:	8b 40 04             	mov    0x4(%rax),%eax
  80362e:	48 63 d0             	movslq %eax,%rdx
  803631:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803635:	8b 00                	mov    (%rax),%eax
  803637:	48 98                	cltq   
  803639:	48 83 c0 20          	add    $0x20,%rax
  80363d:	48 39 c2             	cmp    %rax,%rdx
  803640:	73 b4                	jae    8035f6 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803642:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803646:	8b 40 04             	mov    0x4(%rax),%eax
  803649:	99                   	cltd   
  80364a:	c1 ea 1b             	shr    $0x1b,%edx
  80364d:	01 d0                	add    %edx,%eax
  80364f:	83 e0 1f             	and    $0x1f,%eax
  803652:	29 d0                	sub    %edx,%eax
  803654:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803658:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80365c:	48 01 ca             	add    %rcx,%rdx
  80365f:	0f b6 0a             	movzbl (%rdx),%ecx
  803662:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803666:	48 98                	cltq   
  803668:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80366c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803670:	8b 40 04             	mov    0x4(%rax),%eax
  803673:	8d 50 01             	lea    0x1(%rax),%edx
  803676:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80367a:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80367d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803682:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803686:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80368a:	0f 82 64 ff ff ff    	jb     8035f4 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803690:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803694:	c9                   	leaveq 
  803695:	c3                   	retq   

0000000000803696 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803696:	55                   	push   %rbp
  803697:	48 89 e5             	mov    %rsp,%rbp
  80369a:	48 83 ec 20          	sub    $0x20,%rsp
  80369e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8036a2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8036a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036aa:	48 89 c7             	mov    %rax,%rdi
  8036ad:	48 b8 73 22 80 00 00 	movabs $0x802273,%rax
  8036b4:	00 00 00 
  8036b7:	ff d0                	callq  *%rax
  8036b9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8036bd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036c1:	48 be a7 43 80 00 00 	movabs $0x8043a7,%rsi
  8036c8:	00 00 00 
  8036cb:	48 89 c7             	mov    %rax,%rdi
  8036ce:	48 b8 84 0f 80 00 00 	movabs $0x800f84,%rax
  8036d5:	00 00 00 
  8036d8:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8036da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036de:	8b 50 04             	mov    0x4(%rax),%edx
  8036e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036e5:	8b 00                	mov    (%rax),%eax
  8036e7:	29 c2                	sub    %eax,%edx
  8036e9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036ed:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8036f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036f7:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8036fe:	00 00 00 
	stat->st_dev = &devpipe;
  803701:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803705:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  80370c:	00 00 00 
  80370f:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803716:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80371b:	c9                   	leaveq 
  80371c:	c3                   	retq   

000000000080371d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80371d:	55                   	push   %rbp
  80371e:	48 89 e5             	mov    %rsp,%rbp
  803721:	48 83 ec 10          	sub    $0x10,%rsp
  803725:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803729:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80372d:	48 89 c6             	mov    %rax,%rsi
  803730:	bf 00 00 00 00       	mov    $0x0,%edi
  803735:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  80373c:	00 00 00 
  80373f:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803741:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803745:	48 89 c7             	mov    %rax,%rdi
  803748:	48 b8 73 22 80 00 00 	movabs $0x802273,%rax
  80374f:	00 00 00 
  803752:	ff d0                	callq  *%rax
  803754:	48 89 c6             	mov    %rax,%rsi
  803757:	bf 00 00 00 00       	mov    $0x0,%edi
  80375c:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  803763:	00 00 00 
  803766:	ff d0                	callq  *%rax
}
  803768:	c9                   	leaveq 
  803769:	c3                   	retq   

000000000080376a <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80376a:	55                   	push   %rbp
  80376b:	48 89 e5             	mov    %rsp,%rbp
  80376e:	48 83 ec 20          	sub    $0x20,%rsp
  803772:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803775:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803778:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80377b:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80377f:	be 01 00 00 00       	mov    $0x1,%esi
  803784:	48 89 c7             	mov    %rax,%rdi
  803787:	48 b8 6b 17 80 00 00 	movabs $0x80176b,%rax
  80378e:	00 00 00 
  803791:	ff d0                	callq  *%rax
}
  803793:	c9                   	leaveq 
  803794:	c3                   	retq   

0000000000803795 <getchar>:

int
getchar(void)
{
  803795:	55                   	push   %rbp
  803796:	48 89 e5             	mov    %rsp,%rbp
  803799:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80379d:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8037a1:	ba 01 00 00 00       	mov    $0x1,%edx
  8037a6:	48 89 c6             	mov    %rax,%rsi
  8037a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8037ae:	48 b8 68 27 80 00 00 	movabs $0x802768,%rax
  8037b5:	00 00 00 
  8037b8:	ff d0                	callq  *%rax
  8037ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8037bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037c1:	79 05                	jns    8037c8 <getchar+0x33>
		return r;
  8037c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037c6:	eb 14                	jmp    8037dc <getchar+0x47>
	if (r < 1)
  8037c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037cc:	7f 07                	jg     8037d5 <getchar+0x40>
		return -E_EOF;
  8037ce:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8037d3:	eb 07                	jmp    8037dc <getchar+0x47>
	return c;
  8037d5:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8037d9:	0f b6 c0             	movzbl %al,%eax
}
  8037dc:	c9                   	leaveq 
  8037dd:	c3                   	retq   

00000000008037de <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8037de:	55                   	push   %rbp
  8037df:	48 89 e5             	mov    %rsp,%rbp
  8037e2:	48 83 ec 20          	sub    $0x20,%rsp
  8037e6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8037e9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8037ed:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037f0:	48 89 d6             	mov    %rdx,%rsi
  8037f3:	89 c7                	mov    %eax,%edi
  8037f5:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  8037fc:	00 00 00 
  8037ff:	ff d0                	callq  *%rax
  803801:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803804:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803808:	79 05                	jns    80380f <iscons+0x31>
		return r;
  80380a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80380d:	eb 1a                	jmp    803829 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80380f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803813:	8b 10                	mov    (%rax),%edx
  803815:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  80381c:	00 00 00 
  80381f:	8b 00                	mov    (%rax),%eax
  803821:	39 c2                	cmp    %eax,%edx
  803823:	0f 94 c0             	sete   %al
  803826:	0f b6 c0             	movzbl %al,%eax
}
  803829:	c9                   	leaveq 
  80382a:	c3                   	retq   

000000000080382b <opencons>:

int
opencons(void)
{
  80382b:	55                   	push   %rbp
  80382c:	48 89 e5             	mov    %rsp,%rbp
  80382f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803833:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803837:	48 89 c7             	mov    %rax,%rdi
  80383a:	48 b8 9e 22 80 00 00 	movabs $0x80229e,%rax
  803841:	00 00 00 
  803844:	ff d0                	callq  *%rax
  803846:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803849:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80384d:	79 05                	jns    803854 <opencons+0x29>
		return r;
  80384f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803852:	eb 5b                	jmp    8038af <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803854:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803858:	ba 07 04 00 00       	mov    $0x407,%edx
  80385d:	48 89 c6             	mov    %rax,%rsi
  803860:	bf 00 00 00 00       	mov    $0x0,%edi
  803865:	48 b8 b3 18 80 00 00 	movabs $0x8018b3,%rax
  80386c:	00 00 00 
  80386f:	ff d0                	callq  *%rax
  803871:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803874:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803878:	79 05                	jns    80387f <opencons+0x54>
		return r;
  80387a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80387d:	eb 30                	jmp    8038af <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80387f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803883:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  80388a:	00 00 00 
  80388d:	8b 12                	mov    (%rdx),%edx
  80388f:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803891:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803895:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80389c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038a0:	48 89 c7             	mov    %rax,%rdi
  8038a3:	48 b8 50 22 80 00 00 	movabs $0x802250,%rax
  8038aa:	00 00 00 
  8038ad:	ff d0                	callq  *%rax
}
  8038af:	c9                   	leaveq 
  8038b0:	c3                   	retq   

00000000008038b1 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8038b1:	55                   	push   %rbp
  8038b2:	48 89 e5             	mov    %rsp,%rbp
  8038b5:	48 83 ec 30          	sub    $0x30,%rsp
  8038b9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8038bd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038c1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8038c5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8038ca:	75 07                	jne    8038d3 <devcons_read+0x22>
		return 0;
  8038cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8038d1:	eb 4b                	jmp    80391e <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8038d3:	eb 0c                	jmp    8038e1 <devcons_read+0x30>
		sys_yield();
  8038d5:	48 b8 75 18 80 00 00 	movabs $0x801875,%rax
  8038dc:	00 00 00 
  8038df:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8038e1:	48 b8 b5 17 80 00 00 	movabs $0x8017b5,%rax
  8038e8:	00 00 00 
  8038eb:	ff d0                	callq  *%rax
  8038ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038f4:	74 df                	je     8038d5 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8038f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038fa:	79 05                	jns    803901 <devcons_read+0x50>
		return c;
  8038fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038ff:	eb 1d                	jmp    80391e <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803901:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803905:	75 07                	jne    80390e <devcons_read+0x5d>
		return 0;
  803907:	b8 00 00 00 00       	mov    $0x0,%eax
  80390c:	eb 10                	jmp    80391e <devcons_read+0x6d>
	*(char*)vbuf = c;
  80390e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803911:	89 c2                	mov    %eax,%edx
  803913:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803917:	88 10                	mov    %dl,(%rax)
	return 1;
  803919:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80391e:	c9                   	leaveq 
  80391f:	c3                   	retq   

0000000000803920 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803920:	55                   	push   %rbp
  803921:	48 89 e5             	mov    %rsp,%rbp
  803924:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80392b:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803932:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803939:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803940:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803947:	eb 76                	jmp    8039bf <devcons_write+0x9f>
		m = n - tot;
  803949:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803950:	89 c2                	mov    %eax,%edx
  803952:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803955:	29 c2                	sub    %eax,%edx
  803957:	89 d0                	mov    %edx,%eax
  803959:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80395c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80395f:	83 f8 7f             	cmp    $0x7f,%eax
  803962:	76 07                	jbe    80396b <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803964:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80396b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80396e:	48 63 d0             	movslq %eax,%rdx
  803971:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803974:	48 63 c8             	movslq %eax,%rcx
  803977:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80397e:	48 01 c1             	add    %rax,%rcx
  803981:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803988:	48 89 ce             	mov    %rcx,%rsi
  80398b:	48 89 c7             	mov    %rax,%rdi
  80398e:	48 b8 a8 12 80 00 00 	movabs $0x8012a8,%rax
  803995:	00 00 00 
  803998:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80399a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80399d:	48 63 d0             	movslq %eax,%rdx
  8039a0:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8039a7:	48 89 d6             	mov    %rdx,%rsi
  8039aa:	48 89 c7             	mov    %rax,%rdi
  8039ad:	48 b8 6b 17 80 00 00 	movabs $0x80176b,%rax
  8039b4:	00 00 00 
  8039b7:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8039b9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039bc:	01 45 fc             	add    %eax,-0x4(%rbp)
  8039bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039c2:	48 98                	cltq   
  8039c4:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8039cb:	0f 82 78 ff ff ff    	jb     803949 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8039d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8039d4:	c9                   	leaveq 
  8039d5:	c3                   	retq   

00000000008039d6 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8039d6:	55                   	push   %rbp
  8039d7:	48 89 e5             	mov    %rsp,%rbp
  8039da:	48 83 ec 08          	sub    $0x8,%rsp
  8039de:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8039e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039e7:	c9                   	leaveq 
  8039e8:	c3                   	retq   

00000000008039e9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8039e9:	55                   	push   %rbp
  8039ea:	48 89 e5             	mov    %rsp,%rbp
  8039ed:	48 83 ec 10          	sub    $0x10,%rsp
  8039f1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8039f5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8039f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039fd:	48 be b3 43 80 00 00 	movabs $0x8043b3,%rsi
  803a04:	00 00 00 
  803a07:	48 89 c7             	mov    %rax,%rdi
  803a0a:	48 b8 84 0f 80 00 00 	movabs $0x800f84,%rax
  803a11:	00 00 00 
  803a14:	ff d0                	callq  *%rax
	return 0;
  803a16:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a1b:	c9                   	leaveq 
  803a1c:	c3                   	retq   

0000000000803a1d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803a1d:	55                   	push   %rbp
  803a1e:	48 89 e5             	mov    %rsp,%rbp
  803a21:	53                   	push   %rbx
  803a22:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803a29:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803a30:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803a36:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803a3d:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803a44:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803a4b:	84 c0                	test   %al,%al
  803a4d:	74 23                	je     803a72 <_panic+0x55>
  803a4f:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803a56:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803a5a:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803a5e:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803a62:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803a66:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803a6a:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803a6e:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803a72:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803a79:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803a80:	00 00 00 
  803a83:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803a8a:	00 00 00 
  803a8d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803a91:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803a98:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803a9f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803aa6:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  803aad:	00 00 00 
  803ab0:	48 8b 18             	mov    (%rax),%rbx
  803ab3:	48 b8 37 18 80 00 00 	movabs $0x801837,%rax
  803aba:	00 00 00 
  803abd:	ff d0                	callq  *%rax
  803abf:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803ac5:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803acc:	41 89 c8             	mov    %ecx,%r8d
  803acf:	48 89 d1             	mov    %rdx,%rcx
  803ad2:	48 89 da             	mov    %rbx,%rdx
  803ad5:	89 c6                	mov    %eax,%esi
  803ad7:	48 bf c0 43 80 00 00 	movabs $0x8043c0,%rdi
  803ade:	00 00 00 
  803ae1:	b8 00 00 00 00       	mov    $0x0,%eax
  803ae6:	49 b9 cf 03 80 00 00 	movabs $0x8003cf,%r9
  803aed:	00 00 00 
  803af0:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803af3:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803afa:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803b01:	48 89 d6             	mov    %rdx,%rsi
  803b04:	48 89 c7             	mov    %rax,%rdi
  803b07:	48 b8 23 03 80 00 00 	movabs $0x800323,%rax
  803b0e:	00 00 00 
  803b11:	ff d0                	callq  *%rax
	cprintf("\n");
  803b13:	48 bf e3 43 80 00 00 	movabs $0x8043e3,%rdi
  803b1a:	00 00 00 
  803b1d:	b8 00 00 00 00       	mov    $0x0,%eax
  803b22:	48 ba cf 03 80 00 00 	movabs $0x8003cf,%rdx
  803b29:	00 00 00 
  803b2c:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803b2e:	cc                   	int3   
  803b2f:	eb fd                	jmp    803b2e <_panic+0x111>

0000000000803b31 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803b31:	55                   	push   %rbp
  803b32:	48 89 e5             	mov    %rsp,%rbp
  803b35:	48 83 ec 10          	sub    $0x10,%rsp
  803b39:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  803b3d:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803b44:	00 00 00 
  803b47:	48 8b 00             	mov    (%rax),%rax
  803b4a:	48 85 c0             	test   %rax,%rax
  803b4d:	75 64                	jne    803bb3 <set_pgfault_handler+0x82>
		// First time through!
		// LAB 4: Your code here.
		//envid_t eid = sys_getenvid();
		if(sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) 
  803b4f:	ba 07 00 00 00       	mov    $0x7,%edx
  803b54:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803b59:	bf 00 00 00 00       	mov    $0x0,%edi
  803b5e:	48 b8 b3 18 80 00 00 	movabs $0x8018b3,%rax
  803b65:	00 00 00 
  803b68:	ff d0                	callq  *%rax
  803b6a:	85 c0                	test   %eax,%eax
  803b6c:	74 2a                	je     803b98 <set_pgfault_handler+0x67>
			panic("Allocation of space for UXSTACK failed\n");
  803b6e:	48 ba e8 43 80 00 00 	movabs $0x8043e8,%rdx
  803b75:	00 00 00 
  803b78:	be 22 00 00 00       	mov    $0x22,%esi
  803b7d:	48 bf 10 44 80 00 00 	movabs $0x804410,%rdi
  803b84:	00 00 00 
  803b87:	b8 00 00 00 00       	mov    $0x0,%eax
  803b8c:	48 b9 1d 3a 80 00 00 	movabs $0x803a1d,%rcx
  803b93:	00 00 00 
  803b96:	ff d1                	callq  *%rcx
		else
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  803b98:	48 be c6 3b 80 00 00 	movabs $0x803bc6,%rsi
  803b9f:	00 00 00 
  803ba2:	bf 00 00 00 00       	mov    $0x0,%edi
  803ba7:	48 b8 3d 1a 80 00 00 	movabs $0x801a3d,%rax
  803bae:	00 00 00 
  803bb1:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803bb3:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803bba:	00 00 00 
  803bbd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803bc1:	48 89 10             	mov    %rdx,(%rax)
}
  803bc4:	c9                   	leaveq 
  803bc5:	c3                   	retq   

0000000000803bc6 <_pgfault_upcall>:
// Call the C page fault handler.
// function argument: pointer to UTF



movq  %rsp,%rdi                // passing the function argument in rdi
  803bc6:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  803bc9:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803bd0:	00 00 00 
call *%rax
  803bd3:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
mov 152(%rsp), %r8
  803bd5:	4c 8b 84 24 98 00 00 	mov    0x98(%rsp),%r8
  803bdc:	00 
mov 136(%rsp), %r9
  803bdd:	4c 8b 8c 24 88 00 00 	mov    0x88(%rsp),%r9
  803be4:	00 
sub $8, %r8
  803be5:	49 83 e8 08          	sub    $0x8,%r8
mov %r9, (%r8)
  803be9:	4d 89 08             	mov    %r9,(%r8)
mov %r8, 152(%rsp)
  803bec:	4c 89 84 24 98 00 00 	mov    %r8,0x98(%rsp)
  803bf3:	00 
add $16, %rsp
  803bf4:	48 83 c4 10          	add    $0x10,%rsp

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
POPA_
  803bf8:	4c 8b 3c 24          	mov    (%rsp),%r15
  803bfc:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803c01:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803c06:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803c0b:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803c10:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803c15:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803c1a:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803c1f:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803c24:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803c29:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803c2e:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803c33:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803c38:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803c3d:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803c42:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
		// LAB 4: Your code here.
add $8, %rsp
  803c46:	48 83 c4 08          	add    $0x8,%rsp
popf
  803c4a:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
mov (%rsp), %rsp
  803c4b:	48 8b 24 24          	mov    (%rsp),%rsp
    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
ret
  803c4f:	c3                   	retq   

0000000000803c50 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803c50:	55                   	push   %rbp
  803c51:	48 89 e5             	mov    %rsp,%rbp
  803c54:	48 83 ec 18          	sub    $0x18,%rsp
  803c58:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803c5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c60:	48 c1 e8 15          	shr    $0x15,%rax
  803c64:	48 89 c2             	mov    %rax,%rdx
  803c67:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803c6e:	01 00 00 
  803c71:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c75:	83 e0 01             	and    $0x1,%eax
  803c78:	48 85 c0             	test   %rax,%rax
  803c7b:	75 07                	jne    803c84 <pageref+0x34>
		return 0;
  803c7d:	b8 00 00 00 00       	mov    $0x0,%eax
  803c82:	eb 53                	jmp    803cd7 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803c84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c88:	48 c1 e8 0c          	shr    $0xc,%rax
  803c8c:	48 89 c2             	mov    %rax,%rdx
  803c8f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803c96:	01 00 00 
  803c99:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c9d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803ca1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ca5:	83 e0 01             	and    $0x1,%eax
  803ca8:	48 85 c0             	test   %rax,%rax
  803cab:	75 07                	jne    803cb4 <pageref+0x64>
		return 0;
  803cad:	b8 00 00 00 00       	mov    $0x0,%eax
  803cb2:	eb 23                	jmp    803cd7 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803cb4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cb8:	48 c1 e8 0c          	shr    $0xc,%rax
  803cbc:	48 89 c2             	mov    %rax,%rdx
  803cbf:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803cc6:	00 00 00 
  803cc9:	48 c1 e2 04          	shl    $0x4,%rdx
  803ccd:	48 01 d0             	add    %rdx,%rax
  803cd0:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803cd4:	0f b7 c0             	movzwl %ax,%eax
}
  803cd7:	c9                   	leaveq 
  803cd8:	c3                   	retq   
