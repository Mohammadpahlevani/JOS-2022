
obj/user/primes:     file format elf64-x86-64


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
  80003c:	e8 8d 01 00 00       	callq  8001ce <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80004b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80004f:	ba 00 00 00 00       	mov    $0x0,%edx
  800054:	be 00 00 00 00       	mov    $0x0,%esi
  800059:	48 89 c7             	mov    %rax,%rdi
  80005c:	48 b8 56 21 80 00 00 	movabs $0x802156,%rax
  800063:	00 00 00 
  800066:	ff d0                	callq  *%rax
  800068:	89 45 fc             	mov    %eax,-0x4(%rbp)
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  80006b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800072:	00 00 00 
  800075:	48 8b 00             	mov    (%rax),%rax
  800078:	8b 80 dc 00 00 00    	mov    0xdc(%rax),%eax
  80007e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800081:	89 c6                	mov    %eax,%esi
  800083:	48 bf c0 3c 80 00 00 	movabs $0x803cc0,%rdi
  80008a:	00 00 00 
  80008d:	b8 00 00 00 00       	mov    $0x0,%eax
  800092:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  800099:	00 00 00 
  80009c:	ff d1                	callq  *%rcx

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  80009e:	48 b8 5e 1e 80 00 00 	movabs $0x801e5e,%rax
  8000a5:	00 00 00 
  8000a8:	ff d0                	callq  *%rax
  8000aa:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000ad:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000b1:	79 30                	jns    8000e3 <primeproc+0xa0>
		panic("fork: %e", id);
  8000b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000b6:	89 c1                	mov    %eax,%ecx
  8000b8:	48 ba cc 3c 80 00 00 	movabs $0x803ccc,%rdx
  8000bf:	00 00 00 
  8000c2:	be 1a 00 00 00       	mov    $0x1a,%esi
  8000c7:	48 bf d5 3c 80 00 00 	movabs $0x803cd5,%rdi
  8000ce:	00 00 00 
  8000d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d6:	49 b8 81 02 80 00 00 	movabs $0x800281,%r8
  8000dd:	00 00 00 
  8000e0:	41 ff d0             	callq  *%r8
	if (id == 0)
  8000e3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000e7:	75 05                	jne    8000ee <primeproc+0xab>
		goto top;
  8000e9:	e9 5d ff ff ff       	jmpq   80004b <primeproc+0x8>

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  8000ee:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8000f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8000f7:	be 00 00 00 00       	mov    $0x0,%esi
  8000fc:	48 89 c7             	mov    %rax,%rdi
  8000ff:	48 b8 56 21 80 00 00 	movabs $0x802156,%rax
  800106:	00 00 00 
  800109:	ff d0                	callq  *%rax
  80010b:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (i % p)
  80010e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800111:	99                   	cltd   
  800112:	f7 7d fc             	idivl  -0x4(%rbp)
  800115:	89 d0                	mov    %edx,%eax
  800117:	85 c0                	test   %eax,%eax
  800119:	74 20                	je     80013b <primeproc+0xf8>
			ipc_send(id, i, 0, 0);
  80011b:	8b 75 f4             	mov    -0xc(%rbp),%esi
  80011e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800121:	b9 00 00 00 00       	mov    $0x0,%ecx
  800126:	ba 00 00 00 00       	mov    $0x0,%edx
  80012b:	89 c7                	mov    %eax,%edi
  80012d:	48 b8 1c 22 80 00 00 	movabs $0x80221c,%rax
  800134:	00 00 00 
  800137:	ff d0                	callq  *%rax
	}
  800139:	eb b3                	jmp    8000ee <primeproc+0xab>
  80013b:	eb b1                	jmp    8000ee <primeproc+0xab>

000000000080013d <umain>:
}

void
umain(int argc, char **argv)
{
  80013d:	55                   	push   %rbp
  80013e:	48 89 e5             	mov    %rsp,%rbp
  800141:	48 83 ec 20          	sub    $0x20,%rsp
  800145:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800148:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  80014c:	48 b8 5e 1e 80 00 00 	movabs $0x801e5e,%rax
  800153:	00 00 00 
  800156:	ff d0                	callq  *%rax
  800158:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80015b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80015f:	79 30                	jns    800191 <umain+0x54>
		panic("fork: %e", id);
  800161:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800164:	89 c1                	mov    %eax,%ecx
  800166:	48 ba cc 3c 80 00 00 	movabs $0x803ccc,%rdx
  80016d:	00 00 00 
  800170:	be 2d 00 00 00       	mov    $0x2d,%esi
  800175:	48 bf d5 3c 80 00 00 	movabs $0x803cd5,%rdi
  80017c:	00 00 00 
  80017f:	b8 00 00 00 00       	mov    $0x0,%eax
  800184:	49 b8 81 02 80 00 00 	movabs $0x800281,%r8
  80018b:	00 00 00 
  80018e:	41 ff d0             	callq  *%r8
	if (id == 0)
  800191:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800195:	75 0c                	jne    8001a3 <umain+0x66>
		primeproc();
  800197:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80019e:	00 00 00 
  8001a1:	ff d0                	callq  *%rax

	// feed all the integers through
	for (i = 2; ; i++)
  8001a3:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%rbp)
		ipc_send(id, i, 0, 0);
  8001aa:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8001ad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001b0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8001ba:	89 c7                	mov    %eax,%edi
  8001bc:	48 b8 1c 22 80 00 00 	movabs $0x80221c,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  8001c8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
		ipc_send(id, i, 0, 0);
  8001cc:	eb dc                	jmp    8001aa <umain+0x6d>

00000000008001ce <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001ce:	55                   	push   %rbp
  8001cf:	48 89 e5             	mov    %rsp,%rbp
  8001d2:	48 83 ec 10          	sub    $0x10,%rsp
  8001d6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001d9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  8001dd:	48 b8 22 19 80 00 00 	movabs $0x801922,%rax
  8001e4:	00 00 00 
  8001e7:	ff d0                	callq  *%rax
  8001e9:	48 98                	cltq   
  8001eb:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001f0:	48 89 c2             	mov    %rax,%rdx
  8001f3:	48 89 d0             	mov    %rdx,%rax
  8001f6:	48 c1 e0 03          	shl    $0x3,%rax
  8001fa:	48 01 d0             	add    %rdx,%rax
  8001fd:	48 c1 e0 05          	shl    $0x5,%rax
  800201:	48 89 c2             	mov    %rax,%rdx
  800204:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80020b:	00 00 00 
  80020e:	48 01 c2             	add    %rax,%rdx
  800211:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800218:	00 00 00 
  80021b:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80021e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800222:	7e 14                	jle    800238 <libmain+0x6a>
		binaryname = argv[0];
  800224:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800228:	48 8b 10             	mov    (%rax),%rdx
  80022b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800232:	00 00 00 
  800235:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800238:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80023c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80023f:	48 89 d6             	mov    %rdx,%rsi
  800242:	89 c7                	mov    %eax,%edi
  800244:	48 b8 3d 01 80 00 00 	movabs $0x80013d,%rax
  80024b:	00 00 00 
  80024e:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800250:	48 b8 5e 02 80 00 00 	movabs $0x80025e,%rax
  800257:	00 00 00 
  80025a:	ff d0                	callq  *%rax
}
  80025c:	c9                   	leaveq 
  80025d:	c3                   	retq   

000000000080025e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80025e:	55                   	push   %rbp
  80025f:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800262:	48 b8 7c 26 80 00 00 	movabs $0x80267c,%rax
  800269:	00 00 00 
  80026c:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80026e:	bf 00 00 00 00       	mov    $0x0,%edi
  800273:	48 b8 de 18 80 00 00 	movabs $0x8018de,%rax
  80027a:	00 00 00 
  80027d:	ff d0                	callq  *%rax
}
  80027f:	5d                   	pop    %rbp
  800280:	c3                   	retq   

0000000000800281 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800281:	55                   	push   %rbp
  800282:	48 89 e5             	mov    %rsp,%rbp
  800285:	53                   	push   %rbx
  800286:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80028d:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800294:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80029a:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8002a1:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8002a8:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8002af:	84 c0                	test   %al,%al
  8002b1:	74 23                	je     8002d6 <_panic+0x55>
  8002b3:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8002ba:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002be:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002c2:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002c6:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002ca:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002ce:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002d2:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002d6:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002dd:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002e4:	00 00 00 
  8002e7:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002ee:	00 00 00 
  8002f1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002f5:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002fc:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800303:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80030a:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800311:	00 00 00 
  800314:	48 8b 18             	mov    (%rax),%rbx
  800317:	48 b8 22 19 80 00 00 	movabs $0x801922,%rax
  80031e:	00 00 00 
  800321:	ff d0                	callq  *%rax
  800323:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800329:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800330:	41 89 c8             	mov    %ecx,%r8d
  800333:	48 89 d1             	mov    %rdx,%rcx
  800336:	48 89 da             	mov    %rbx,%rdx
  800339:	89 c6                	mov    %eax,%esi
  80033b:	48 bf f0 3c 80 00 00 	movabs $0x803cf0,%rdi
  800342:	00 00 00 
  800345:	b8 00 00 00 00       	mov    $0x0,%eax
  80034a:	49 b9 ba 04 80 00 00 	movabs $0x8004ba,%r9
  800351:	00 00 00 
  800354:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800357:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80035e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800365:	48 89 d6             	mov    %rdx,%rsi
  800368:	48 89 c7             	mov    %rax,%rdi
  80036b:	48 b8 0e 04 80 00 00 	movabs $0x80040e,%rax
  800372:	00 00 00 
  800375:	ff d0                	callq  *%rax
	cprintf("\n");
  800377:	48 bf 13 3d 80 00 00 	movabs $0x803d13,%rdi
  80037e:	00 00 00 
  800381:	b8 00 00 00 00       	mov    $0x0,%eax
  800386:	48 ba ba 04 80 00 00 	movabs $0x8004ba,%rdx
  80038d:	00 00 00 
  800390:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800392:	cc                   	int3   
  800393:	eb fd                	jmp    800392 <_panic+0x111>

0000000000800395 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800395:	55                   	push   %rbp
  800396:	48 89 e5             	mov    %rsp,%rbp
  800399:	48 83 ec 10          	sub    $0x10,%rsp
  80039d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003a0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8003a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a8:	8b 00                	mov    (%rax),%eax
  8003aa:	8d 48 01             	lea    0x1(%rax),%ecx
  8003ad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003b1:	89 0a                	mov    %ecx,(%rdx)
  8003b3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003b6:	89 d1                	mov    %edx,%ecx
  8003b8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003bc:	48 98                	cltq   
  8003be:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8003c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c6:	8b 00                	mov    (%rax),%eax
  8003c8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003cd:	75 2c                	jne    8003fb <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d3:	8b 00                	mov    (%rax),%eax
  8003d5:	48 98                	cltq   
  8003d7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003db:	48 83 c2 08          	add    $0x8,%rdx
  8003df:	48 89 c6             	mov    %rax,%rsi
  8003e2:	48 89 d7             	mov    %rdx,%rdi
  8003e5:	48 b8 56 18 80 00 00 	movabs $0x801856,%rax
  8003ec:	00 00 00 
  8003ef:	ff d0                	callq  *%rax
        b->idx = 0;
  8003f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003f5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ff:	8b 40 04             	mov    0x4(%rax),%eax
  800402:	8d 50 01             	lea    0x1(%rax),%edx
  800405:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800409:	89 50 04             	mov    %edx,0x4(%rax)
}
  80040c:	c9                   	leaveq 
  80040d:	c3                   	retq   

000000000080040e <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80040e:	55                   	push   %rbp
  80040f:	48 89 e5             	mov    %rsp,%rbp
  800412:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800419:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800420:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800427:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80042e:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800435:	48 8b 0a             	mov    (%rdx),%rcx
  800438:	48 89 08             	mov    %rcx,(%rax)
  80043b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80043f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800443:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800447:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80044b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800452:	00 00 00 
    b.cnt = 0;
  800455:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80045c:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80045f:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800466:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80046d:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800474:	48 89 c6             	mov    %rax,%rsi
  800477:	48 bf 95 03 80 00 00 	movabs $0x800395,%rdi
  80047e:	00 00 00 
  800481:	48 b8 6d 08 80 00 00 	movabs $0x80086d,%rax
  800488:	00 00 00 
  80048b:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80048d:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800493:	48 98                	cltq   
  800495:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80049c:	48 83 c2 08          	add    $0x8,%rdx
  8004a0:	48 89 c6             	mov    %rax,%rsi
  8004a3:	48 89 d7             	mov    %rdx,%rdi
  8004a6:	48 b8 56 18 80 00 00 	movabs $0x801856,%rax
  8004ad:	00 00 00 
  8004b0:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8004b2:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004b8:	c9                   	leaveq 
  8004b9:	c3                   	retq   

00000000008004ba <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8004ba:	55                   	push   %rbp
  8004bb:	48 89 e5             	mov    %rsp,%rbp
  8004be:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004c5:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004cc:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004d3:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004da:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004e1:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004e8:	84 c0                	test   %al,%al
  8004ea:	74 20                	je     80050c <cprintf+0x52>
  8004ec:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004f0:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004f4:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004f8:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004fc:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800500:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800504:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800508:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80050c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800513:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80051a:	00 00 00 
  80051d:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800524:	00 00 00 
  800527:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80052b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800532:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800539:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800540:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800547:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80054e:	48 8b 0a             	mov    (%rdx),%rcx
  800551:	48 89 08             	mov    %rcx,(%rax)
  800554:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800558:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80055c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800560:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800564:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80056b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800572:	48 89 d6             	mov    %rdx,%rsi
  800575:	48 89 c7             	mov    %rax,%rdi
  800578:	48 b8 0e 04 80 00 00 	movabs $0x80040e,%rax
  80057f:	00 00 00 
  800582:	ff d0                	callq  *%rax
  800584:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80058a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800590:	c9                   	leaveq 
  800591:	c3                   	retq   

0000000000800592 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800592:	55                   	push   %rbp
  800593:	48 89 e5             	mov    %rsp,%rbp
  800596:	53                   	push   %rbx
  800597:	48 83 ec 38          	sub    $0x38,%rsp
  80059b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80059f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8005a3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8005a7:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8005aa:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8005ae:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005b2:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8005b5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8005b9:	77 3b                	ja     8005f6 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005bb:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8005be:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005c2:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8005c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ce:	48 f7 f3             	div    %rbx
  8005d1:	48 89 c2             	mov    %rax,%rdx
  8005d4:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005d7:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005da:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e2:	41 89 f9             	mov    %edi,%r9d
  8005e5:	48 89 c7             	mov    %rax,%rdi
  8005e8:	48 b8 92 05 80 00 00 	movabs $0x800592,%rax
  8005ef:	00 00 00 
  8005f2:	ff d0                	callq  *%rax
  8005f4:	eb 1e                	jmp    800614 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005f6:	eb 12                	jmp    80060a <printnum+0x78>
			putch(padc, putdat);
  8005f8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005fc:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800603:	48 89 ce             	mov    %rcx,%rsi
  800606:	89 d7                	mov    %edx,%edi
  800608:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80060a:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80060e:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800612:	7f e4                	jg     8005f8 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800614:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800617:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80061b:	ba 00 00 00 00       	mov    $0x0,%edx
  800620:	48 f7 f1             	div    %rcx
  800623:	48 89 d0             	mov    %rdx,%rax
  800626:	48 ba 10 3f 80 00 00 	movabs $0x803f10,%rdx
  80062d:	00 00 00 
  800630:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800634:	0f be d0             	movsbl %al,%edx
  800637:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80063b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063f:	48 89 ce             	mov    %rcx,%rsi
  800642:	89 d7                	mov    %edx,%edi
  800644:	ff d0                	callq  *%rax
}
  800646:	48 83 c4 38          	add    $0x38,%rsp
  80064a:	5b                   	pop    %rbx
  80064b:	5d                   	pop    %rbp
  80064c:	c3                   	retq   

000000000080064d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80064d:	55                   	push   %rbp
  80064e:	48 89 e5             	mov    %rsp,%rbp
  800651:	48 83 ec 1c          	sub    $0x1c,%rsp
  800655:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800659:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80065c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800660:	7e 52                	jle    8006b4 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800662:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800666:	8b 00                	mov    (%rax),%eax
  800668:	83 f8 30             	cmp    $0x30,%eax
  80066b:	73 24                	jae    800691 <getuint+0x44>
  80066d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800671:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800675:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800679:	8b 00                	mov    (%rax),%eax
  80067b:	89 c0                	mov    %eax,%eax
  80067d:	48 01 d0             	add    %rdx,%rax
  800680:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800684:	8b 12                	mov    (%rdx),%edx
  800686:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800689:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068d:	89 0a                	mov    %ecx,(%rdx)
  80068f:	eb 17                	jmp    8006a8 <getuint+0x5b>
  800691:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800695:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800699:	48 89 d0             	mov    %rdx,%rax
  80069c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006a8:	48 8b 00             	mov    (%rax),%rax
  8006ab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006af:	e9 a3 00 00 00       	jmpq   800757 <getuint+0x10a>
	else if (lflag)
  8006b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006b8:	74 4f                	je     800709 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8006ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006be:	8b 00                	mov    (%rax),%eax
  8006c0:	83 f8 30             	cmp    $0x30,%eax
  8006c3:	73 24                	jae    8006e9 <getuint+0x9c>
  8006c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d1:	8b 00                	mov    (%rax),%eax
  8006d3:	89 c0                	mov    %eax,%eax
  8006d5:	48 01 d0             	add    %rdx,%rax
  8006d8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006dc:	8b 12                	mov    (%rdx),%edx
  8006de:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e5:	89 0a                	mov    %ecx,(%rdx)
  8006e7:	eb 17                	jmp    800700 <getuint+0xb3>
  8006e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ed:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006f1:	48 89 d0             	mov    %rdx,%rax
  8006f4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006fc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800700:	48 8b 00             	mov    (%rax),%rax
  800703:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800707:	eb 4e                	jmp    800757 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800709:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070d:	8b 00                	mov    (%rax),%eax
  80070f:	83 f8 30             	cmp    $0x30,%eax
  800712:	73 24                	jae    800738 <getuint+0xeb>
  800714:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800718:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80071c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800720:	8b 00                	mov    (%rax),%eax
  800722:	89 c0                	mov    %eax,%eax
  800724:	48 01 d0             	add    %rdx,%rax
  800727:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80072b:	8b 12                	mov    (%rdx),%edx
  80072d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800730:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800734:	89 0a                	mov    %ecx,(%rdx)
  800736:	eb 17                	jmp    80074f <getuint+0x102>
  800738:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800740:	48 89 d0             	mov    %rdx,%rax
  800743:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800747:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80074b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80074f:	8b 00                	mov    (%rax),%eax
  800751:	89 c0                	mov    %eax,%eax
  800753:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800757:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80075b:	c9                   	leaveq 
  80075c:	c3                   	retq   

000000000080075d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80075d:	55                   	push   %rbp
  80075e:	48 89 e5             	mov    %rsp,%rbp
  800761:	48 83 ec 1c          	sub    $0x1c,%rsp
  800765:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800769:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80076c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800770:	7e 52                	jle    8007c4 <getint+0x67>
		x=va_arg(*ap, long long);
  800772:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800776:	8b 00                	mov    (%rax),%eax
  800778:	83 f8 30             	cmp    $0x30,%eax
  80077b:	73 24                	jae    8007a1 <getint+0x44>
  80077d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800781:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800785:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800789:	8b 00                	mov    (%rax),%eax
  80078b:	89 c0                	mov    %eax,%eax
  80078d:	48 01 d0             	add    %rdx,%rax
  800790:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800794:	8b 12                	mov    (%rdx),%edx
  800796:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800799:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80079d:	89 0a                	mov    %ecx,(%rdx)
  80079f:	eb 17                	jmp    8007b8 <getint+0x5b>
  8007a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007a9:	48 89 d0             	mov    %rdx,%rax
  8007ac:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007b8:	48 8b 00             	mov    (%rax),%rax
  8007bb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007bf:	e9 a3 00 00 00       	jmpq   800867 <getint+0x10a>
	else if (lflag)
  8007c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007c8:	74 4f                	je     800819 <getint+0xbc>
		x=va_arg(*ap, long);
  8007ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ce:	8b 00                	mov    (%rax),%eax
  8007d0:	83 f8 30             	cmp    $0x30,%eax
  8007d3:	73 24                	jae    8007f9 <getint+0x9c>
  8007d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e1:	8b 00                	mov    (%rax),%eax
  8007e3:	89 c0                	mov    %eax,%eax
  8007e5:	48 01 d0             	add    %rdx,%rax
  8007e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ec:	8b 12                	mov    (%rdx),%edx
  8007ee:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f5:	89 0a                	mov    %ecx,(%rdx)
  8007f7:	eb 17                	jmp    800810 <getint+0xb3>
  8007f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fd:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800801:	48 89 d0             	mov    %rdx,%rax
  800804:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800808:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800810:	48 8b 00             	mov    (%rax),%rax
  800813:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800817:	eb 4e                	jmp    800867 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800819:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081d:	8b 00                	mov    (%rax),%eax
  80081f:	83 f8 30             	cmp    $0x30,%eax
  800822:	73 24                	jae    800848 <getint+0xeb>
  800824:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800828:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80082c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800830:	8b 00                	mov    (%rax),%eax
  800832:	89 c0                	mov    %eax,%eax
  800834:	48 01 d0             	add    %rdx,%rax
  800837:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083b:	8b 12                	mov    (%rdx),%edx
  80083d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800840:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800844:	89 0a                	mov    %ecx,(%rdx)
  800846:	eb 17                	jmp    80085f <getint+0x102>
  800848:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800850:	48 89 d0             	mov    %rdx,%rax
  800853:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800857:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80085b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80085f:	8b 00                	mov    (%rax),%eax
  800861:	48 98                	cltq   
  800863:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800867:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80086b:	c9                   	leaveq 
  80086c:	c3                   	retq   

000000000080086d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80086d:	55                   	push   %rbp
  80086e:	48 89 e5             	mov    %rsp,%rbp
  800871:	41 54                	push   %r12
  800873:	53                   	push   %rbx
  800874:	48 83 ec 60          	sub    $0x60,%rsp
  800878:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80087c:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800880:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800884:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800888:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80088c:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800890:	48 8b 0a             	mov    (%rdx),%rcx
  800893:	48 89 08             	mov    %rcx,(%rax)
  800896:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80089a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80089e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008a2:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a6:	eb 17                	jmp    8008bf <vprintfmt+0x52>
			if (ch == '\0')
  8008a8:	85 db                	test   %ebx,%ebx
  8008aa:	0f 84 cc 04 00 00    	je     800d7c <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8008b0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008b4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008b8:	48 89 d6             	mov    %rdx,%rsi
  8008bb:	89 df                	mov    %ebx,%edi
  8008bd:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008bf:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008c3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008c7:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008cb:	0f b6 00             	movzbl (%rax),%eax
  8008ce:	0f b6 d8             	movzbl %al,%ebx
  8008d1:	83 fb 25             	cmp    $0x25,%ebx
  8008d4:	75 d2                	jne    8008a8 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008d6:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008da:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008e1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008e8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008ef:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008f6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008fa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008fe:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800902:	0f b6 00             	movzbl (%rax),%eax
  800905:	0f b6 d8             	movzbl %al,%ebx
  800908:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80090b:	83 f8 55             	cmp    $0x55,%eax
  80090e:	0f 87 34 04 00 00    	ja     800d48 <vprintfmt+0x4db>
  800914:	89 c0                	mov    %eax,%eax
  800916:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80091d:	00 
  80091e:	48 b8 38 3f 80 00 00 	movabs $0x803f38,%rax
  800925:	00 00 00 
  800928:	48 01 d0             	add    %rdx,%rax
  80092b:	48 8b 00             	mov    (%rax),%rax
  80092e:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800930:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800934:	eb c0                	jmp    8008f6 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800936:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80093a:	eb ba                	jmp    8008f6 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80093c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800943:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800946:	89 d0                	mov    %edx,%eax
  800948:	c1 e0 02             	shl    $0x2,%eax
  80094b:	01 d0                	add    %edx,%eax
  80094d:	01 c0                	add    %eax,%eax
  80094f:	01 d8                	add    %ebx,%eax
  800951:	83 e8 30             	sub    $0x30,%eax
  800954:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800957:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80095b:	0f b6 00             	movzbl (%rax),%eax
  80095e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800961:	83 fb 2f             	cmp    $0x2f,%ebx
  800964:	7e 0c                	jle    800972 <vprintfmt+0x105>
  800966:	83 fb 39             	cmp    $0x39,%ebx
  800969:	7f 07                	jg     800972 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80096b:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800970:	eb d1                	jmp    800943 <vprintfmt+0xd6>
			goto process_precision;
  800972:	eb 58                	jmp    8009cc <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800974:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800977:	83 f8 30             	cmp    $0x30,%eax
  80097a:	73 17                	jae    800993 <vprintfmt+0x126>
  80097c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800980:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800983:	89 c0                	mov    %eax,%eax
  800985:	48 01 d0             	add    %rdx,%rax
  800988:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80098b:	83 c2 08             	add    $0x8,%edx
  80098e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800991:	eb 0f                	jmp    8009a2 <vprintfmt+0x135>
  800993:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800997:	48 89 d0             	mov    %rdx,%rax
  80099a:	48 83 c2 08          	add    $0x8,%rdx
  80099e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009a2:	8b 00                	mov    (%rax),%eax
  8009a4:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8009a7:	eb 23                	jmp    8009cc <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8009a9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009ad:	79 0c                	jns    8009bb <vprintfmt+0x14e>
				width = 0;
  8009af:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009b6:	e9 3b ff ff ff       	jmpq   8008f6 <vprintfmt+0x89>
  8009bb:	e9 36 ff ff ff       	jmpq   8008f6 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009c0:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009c7:	e9 2a ff ff ff       	jmpq   8008f6 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009cc:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009d0:	79 12                	jns    8009e4 <vprintfmt+0x177>
				width = precision, precision = -1;
  8009d2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009d5:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009d8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009df:	e9 12 ff ff ff       	jmpq   8008f6 <vprintfmt+0x89>
  8009e4:	e9 0d ff ff ff       	jmpq   8008f6 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009e9:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009ed:	e9 04 ff ff ff       	jmpq   8008f6 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009f2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f5:	83 f8 30             	cmp    $0x30,%eax
  8009f8:	73 17                	jae    800a11 <vprintfmt+0x1a4>
  8009fa:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009fe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a01:	89 c0                	mov    %eax,%eax
  800a03:	48 01 d0             	add    %rdx,%rax
  800a06:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a09:	83 c2 08             	add    $0x8,%edx
  800a0c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a0f:	eb 0f                	jmp    800a20 <vprintfmt+0x1b3>
  800a11:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a15:	48 89 d0             	mov    %rdx,%rax
  800a18:	48 83 c2 08          	add    $0x8,%rdx
  800a1c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a20:	8b 10                	mov    (%rax),%edx
  800a22:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a26:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a2a:	48 89 ce             	mov    %rcx,%rsi
  800a2d:	89 d7                	mov    %edx,%edi
  800a2f:	ff d0                	callq  *%rax
			break;
  800a31:	e9 40 03 00 00       	jmpq   800d76 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a36:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a39:	83 f8 30             	cmp    $0x30,%eax
  800a3c:	73 17                	jae    800a55 <vprintfmt+0x1e8>
  800a3e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a42:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a45:	89 c0                	mov    %eax,%eax
  800a47:	48 01 d0             	add    %rdx,%rax
  800a4a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a4d:	83 c2 08             	add    $0x8,%edx
  800a50:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a53:	eb 0f                	jmp    800a64 <vprintfmt+0x1f7>
  800a55:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a59:	48 89 d0             	mov    %rdx,%rax
  800a5c:	48 83 c2 08          	add    $0x8,%rdx
  800a60:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a64:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a66:	85 db                	test   %ebx,%ebx
  800a68:	79 02                	jns    800a6c <vprintfmt+0x1ff>
				err = -err;
  800a6a:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a6c:	83 fb 15             	cmp    $0x15,%ebx
  800a6f:	7f 16                	jg     800a87 <vprintfmt+0x21a>
  800a71:	48 b8 60 3e 80 00 00 	movabs $0x803e60,%rax
  800a78:	00 00 00 
  800a7b:	48 63 d3             	movslq %ebx,%rdx
  800a7e:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a82:	4d 85 e4             	test   %r12,%r12
  800a85:	75 2e                	jne    800ab5 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a87:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a8b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a8f:	89 d9                	mov    %ebx,%ecx
  800a91:	48 ba 21 3f 80 00 00 	movabs $0x803f21,%rdx
  800a98:	00 00 00 
  800a9b:	48 89 c7             	mov    %rax,%rdi
  800a9e:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa3:	49 b8 85 0d 80 00 00 	movabs $0x800d85,%r8
  800aaa:	00 00 00 
  800aad:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ab0:	e9 c1 02 00 00       	jmpq   800d76 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ab5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ab9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800abd:	4c 89 e1             	mov    %r12,%rcx
  800ac0:	48 ba 2a 3f 80 00 00 	movabs $0x803f2a,%rdx
  800ac7:	00 00 00 
  800aca:	48 89 c7             	mov    %rax,%rdi
  800acd:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad2:	49 b8 85 0d 80 00 00 	movabs $0x800d85,%r8
  800ad9:	00 00 00 
  800adc:	41 ff d0             	callq  *%r8
			break;
  800adf:	e9 92 02 00 00       	jmpq   800d76 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800ae4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae7:	83 f8 30             	cmp    $0x30,%eax
  800aea:	73 17                	jae    800b03 <vprintfmt+0x296>
  800aec:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800af0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800af3:	89 c0                	mov    %eax,%eax
  800af5:	48 01 d0             	add    %rdx,%rax
  800af8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800afb:	83 c2 08             	add    $0x8,%edx
  800afe:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b01:	eb 0f                	jmp    800b12 <vprintfmt+0x2a5>
  800b03:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b07:	48 89 d0             	mov    %rdx,%rax
  800b0a:	48 83 c2 08          	add    $0x8,%rdx
  800b0e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b12:	4c 8b 20             	mov    (%rax),%r12
  800b15:	4d 85 e4             	test   %r12,%r12
  800b18:	75 0a                	jne    800b24 <vprintfmt+0x2b7>
				p = "(null)";
  800b1a:	49 bc 2d 3f 80 00 00 	movabs $0x803f2d,%r12
  800b21:	00 00 00 
			if (width > 0 && padc != '-')
  800b24:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b28:	7e 3f                	jle    800b69 <vprintfmt+0x2fc>
  800b2a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b2e:	74 39                	je     800b69 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b30:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b33:	48 98                	cltq   
  800b35:	48 89 c6             	mov    %rax,%rsi
  800b38:	4c 89 e7             	mov    %r12,%rdi
  800b3b:	48 b8 31 10 80 00 00 	movabs $0x801031,%rax
  800b42:	00 00 00 
  800b45:	ff d0                	callq  *%rax
  800b47:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b4a:	eb 17                	jmp    800b63 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b4c:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b50:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b54:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b58:	48 89 ce             	mov    %rcx,%rsi
  800b5b:	89 d7                	mov    %edx,%edi
  800b5d:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b5f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b63:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b67:	7f e3                	jg     800b4c <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b69:	eb 37                	jmp    800ba2 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b6b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b6f:	74 1e                	je     800b8f <vprintfmt+0x322>
  800b71:	83 fb 1f             	cmp    $0x1f,%ebx
  800b74:	7e 05                	jle    800b7b <vprintfmt+0x30e>
  800b76:	83 fb 7e             	cmp    $0x7e,%ebx
  800b79:	7e 14                	jle    800b8f <vprintfmt+0x322>
					putch('?', putdat);
  800b7b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b7f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b83:	48 89 d6             	mov    %rdx,%rsi
  800b86:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b8b:	ff d0                	callq  *%rax
  800b8d:	eb 0f                	jmp    800b9e <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b8f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b93:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b97:	48 89 d6             	mov    %rdx,%rsi
  800b9a:	89 df                	mov    %ebx,%edi
  800b9c:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b9e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ba2:	4c 89 e0             	mov    %r12,%rax
  800ba5:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800ba9:	0f b6 00             	movzbl (%rax),%eax
  800bac:	0f be d8             	movsbl %al,%ebx
  800baf:	85 db                	test   %ebx,%ebx
  800bb1:	74 10                	je     800bc3 <vprintfmt+0x356>
  800bb3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bb7:	78 b2                	js     800b6b <vprintfmt+0x2fe>
  800bb9:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800bbd:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bc1:	79 a8                	jns    800b6b <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc3:	eb 16                	jmp    800bdb <vprintfmt+0x36e>
				putch(' ', putdat);
  800bc5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bc9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bcd:	48 89 d6             	mov    %rdx,%rsi
  800bd0:	bf 20 00 00 00       	mov    $0x20,%edi
  800bd5:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bd7:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bdb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bdf:	7f e4                	jg     800bc5 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800be1:	e9 90 01 00 00       	jmpq   800d76 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800be6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bea:	be 03 00 00 00       	mov    $0x3,%esi
  800bef:	48 89 c7             	mov    %rax,%rdi
  800bf2:	48 b8 5d 07 80 00 00 	movabs $0x80075d,%rax
  800bf9:	00 00 00 
  800bfc:	ff d0                	callq  *%rax
  800bfe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c06:	48 85 c0             	test   %rax,%rax
  800c09:	79 1d                	jns    800c28 <vprintfmt+0x3bb>
				putch('-', putdat);
  800c0b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c0f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c13:	48 89 d6             	mov    %rdx,%rsi
  800c16:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c1b:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c21:	48 f7 d8             	neg    %rax
  800c24:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c28:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c2f:	e9 d5 00 00 00       	jmpq   800d09 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c34:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c38:	be 03 00 00 00       	mov    $0x3,%esi
  800c3d:	48 89 c7             	mov    %rax,%rdi
  800c40:	48 b8 4d 06 80 00 00 	movabs $0x80064d,%rax
  800c47:	00 00 00 
  800c4a:	ff d0                	callq  *%rax
  800c4c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c50:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c57:	e9 ad 00 00 00       	jmpq   800d09 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  800c5c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c60:	be 03 00 00 00       	mov    $0x3,%esi
  800c65:	48 89 c7             	mov    %rax,%rdi
  800c68:	48 b8 4d 06 80 00 00 	movabs $0x80064d,%rax
  800c6f:	00 00 00 
  800c72:	ff d0                	callq  *%rax
  800c74:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  800c78:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  800c7f:	e9 85 00 00 00       	jmpq   800d09 <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  800c84:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c88:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c8c:	48 89 d6             	mov    %rdx,%rsi
  800c8f:	bf 30 00 00 00       	mov    $0x30,%edi
  800c94:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c96:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c9a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c9e:	48 89 d6             	mov    %rdx,%rsi
  800ca1:	bf 78 00 00 00       	mov    $0x78,%edi
  800ca6:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800ca8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cab:	83 f8 30             	cmp    $0x30,%eax
  800cae:	73 17                	jae    800cc7 <vprintfmt+0x45a>
  800cb0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cb4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cb7:	89 c0                	mov    %eax,%eax
  800cb9:	48 01 d0             	add    %rdx,%rax
  800cbc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cbf:	83 c2 08             	add    $0x8,%edx
  800cc2:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cc5:	eb 0f                	jmp    800cd6 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800cc7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ccb:	48 89 d0             	mov    %rdx,%rax
  800cce:	48 83 c2 08          	add    $0x8,%rdx
  800cd2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cd6:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cd9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800cdd:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800ce4:	eb 23                	jmp    800d09 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800ce6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cea:	be 03 00 00 00       	mov    $0x3,%esi
  800cef:	48 89 c7             	mov    %rax,%rdi
  800cf2:	48 b8 4d 06 80 00 00 	movabs $0x80064d,%rax
  800cf9:	00 00 00 
  800cfc:	ff d0                	callq  *%rax
  800cfe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d02:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d09:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d0e:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d11:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d14:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d18:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d1c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d20:	45 89 c1             	mov    %r8d,%r9d
  800d23:	41 89 f8             	mov    %edi,%r8d
  800d26:	48 89 c7             	mov    %rax,%rdi
  800d29:	48 b8 92 05 80 00 00 	movabs $0x800592,%rax
  800d30:	00 00 00 
  800d33:	ff d0                	callq  *%rax
			break;
  800d35:	eb 3f                	jmp    800d76 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d37:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d3b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d3f:	48 89 d6             	mov    %rdx,%rsi
  800d42:	89 df                	mov    %ebx,%edi
  800d44:	ff d0                	callq  *%rax
			break;
  800d46:	eb 2e                	jmp    800d76 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d48:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d4c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d50:	48 89 d6             	mov    %rdx,%rsi
  800d53:	bf 25 00 00 00       	mov    $0x25,%edi
  800d58:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d5a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d5f:	eb 05                	jmp    800d66 <vprintfmt+0x4f9>
  800d61:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d66:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d6a:	48 83 e8 01          	sub    $0x1,%rax
  800d6e:	0f b6 00             	movzbl (%rax),%eax
  800d71:	3c 25                	cmp    $0x25,%al
  800d73:	75 ec                	jne    800d61 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800d75:	90                   	nop
		}
	}
  800d76:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d77:	e9 43 fb ff ff       	jmpq   8008bf <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d7c:	48 83 c4 60          	add    $0x60,%rsp
  800d80:	5b                   	pop    %rbx
  800d81:	41 5c                	pop    %r12
  800d83:	5d                   	pop    %rbp
  800d84:	c3                   	retq   

0000000000800d85 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d85:	55                   	push   %rbp
  800d86:	48 89 e5             	mov    %rsp,%rbp
  800d89:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d90:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d97:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d9e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800da5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800dac:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800db3:	84 c0                	test   %al,%al
  800db5:	74 20                	je     800dd7 <printfmt+0x52>
  800db7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dbb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dbf:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dc3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dc7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dcb:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dcf:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dd3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800dd7:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800dde:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800de5:	00 00 00 
  800de8:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800def:	00 00 00 
  800df2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800df6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800dfd:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e04:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e0b:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e12:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e19:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e20:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e27:	48 89 c7             	mov    %rax,%rdi
  800e2a:	48 b8 6d 08 80 00 00 	movabs $0x80086d,%rax
  800e31:	00 00 00 
  800e34:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e36:	c9                   	leaveq 
  800e37:	c3                   	retq   

0000000000800e38 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e38:	55                   	push   %rbp
  800e39:	48 89 e5             	mov    %rsp,%rbp
  800e3c:	48 83 ec 10          	sub    $0x10,%rsp
  800e40:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e43:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e4b:	8b 40 10             	mov    0x10(%rax),%eax
  800e4e:	8d 50 01             	lea    0x1(%rax),%edx
  800e51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e55:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e5c:	48 8b 10             	mov    (%rax),%rdx
  800e5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e63:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e67:	48 39 c2             	cmp    %rax,%rdx
  800e6a:	73 17                	jae    800e83 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e70:	48 8b 00             	mov    (%rax),%rax
  800e73:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e77:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e7b:	48 89 0a             	mov    %rcx,(%rdx)
  800e7e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e81:	88 10                	mov    %dl,(%rax)
}
  800e83:	c9                   	leaveq 
  800e84:	c3                   	retq   

0000000000800e85 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e85:	55                   	push   %rbp
  800e86:	48 89 e5             	mov    %rsp,%rbp
  800e89:	48 83 ec 50          	sub    $0x50,%rsp
  800e8d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e91:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e94:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e98:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e9c:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ea0:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800ea4:	48 8b 0a             	mov    (%rdx),%rcx
  800ea7:	48 89 08             	mov    %rcx,(%rax)
  800eaa:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800eae:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800eb2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800eb6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800eba:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ebe:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ec2:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800ec5:	48 98                	cltq   
  800ec7:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800ecb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ecf:	48 01 d0             	add    %rdx,%rax
  800ed2:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ed6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800edd:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ee2:	74 06                	je     800eea <vsnprintf+0x65>
  800ee4:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ee8:	7f 07                	jg     800ef1 <vsnprintf+0x6c>
		return -E_INVAL;
  800eea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eef:	eb 2f                	jmp    800f20 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ef1:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ef5:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ef9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800efd:	48 89 c6             	mov    %rax,%rsi
  800f00:	48 bf 38 0e 80 00 00 	movabs $0x800e38,%rdi
  800f07:	00 00 00 
  800f0a:	48 b8 6d 08 80 00 00 	movabs $0x80086d,%rax
  800f11:	00 00 00 
  800f14:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f16:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f1a:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f1d:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f20:	c9                   	leaveq 
  800f21:	c3                   	retq   

0000000000800f22 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f22:	55                   	push   %rbp
  800f23:	48 89 e5             	mov    %rsp,%rbp
  800f26:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f2d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f34:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f3a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f41:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f48:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f4f:	84 c0                	test   %al,%al
  800f51:	74 20                	je     800f73 <snprintf+0x51>
  800f53:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f57:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f5b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f5f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f63:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f67:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f6b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f6f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f73:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f7a:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f81:	00 00 00 
  800f84:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f8b:	00 00 00 
  800f8e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f92:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f99:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fa0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fa7:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fae:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fb5:	48 8b 0a             	mov    (%rdx),%rcx
  800fb8:	48 89 08             	mov    %rcx,(%rax)
  800fbb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fbf:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fc3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fc7:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800fcb:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fd2:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fd9:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fdf:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fe6:	48 89 c7             	mov    %rax,%rdi
  800fe9:	48 b8 85 0e 80 00 00 	movabs $0x800e85,%rax
  800ff0:	00 00 00 
  800ff3:	ff d0                	callq  *%rax
  800ff5:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800ffb:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801001:	c9                   	leaveq 
  801002:	c3                   	retq   

0000000000801003 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801003:	55                   	push   %rbp
  801004:	48 89 e5             	mov    %rsp,%rbp
  801007:	48 83 ec 18          	sub    $0x18,%rsp
  80100b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80100f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801016:	eb 09                	jmp    801021 <strlen+0x1e>
		n++;
  801018:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80101c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801021:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801025:	0f b6 00             	movzbl (%rax),%eax
  801028:	84 c0                	test   %al,%al
  80102a:	75 ec                	jne    801018 <strlen+0x15>
		n++;
	return n;
  80102c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80102f:	c9                   	leaveq 
  801030:	c3                   	retq   

0000000000801031 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801031:	55                   	push   %rbp
  801032:	48 89 e5             	mov    %rsp,%rbp
  801035:	48 83 ec 20          	sub    $0x20,%rsp
  801039:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80103d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801041:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801048:	eb 0e                	jmp    801058 <strnlen+0x27>
		n++;
  80104a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80104e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801053:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801058:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80105d:	74 0b                	je     80106a <strnlen+0x39>
  80105f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801063:	0f b6 00             	movzbl (%rax),%eax
  801066:	84 c0                	test   %al,%al
  801068:	75 e0                	jne    80104a <strnlen+0x19>
		n++;
	return n;
  80106a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80106d:	c9                   	leaveq 
  80106e:	c3                   	retq   

000000000080106f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80106f:	55                   	push   %rbp
  801070:	48 89 e5             	mov    %rsp,%rbp
  801073:	48 83 ec 20          	sub    $0x20,%rsp
  801077:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80107b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80107f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801083:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801087:	90                   	nop
  801088:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801090:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801094:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801098:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80109c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010a0:	0f b6 12             	movzbl (%rdx),%edx
  8010a3:	88 10                	mov    %dl,(%rax)
  8010a5:	0f b6 00             	movzbl (%rax),%eax
  8010a8:	84 c0                	test   %al,%al
  8010aa:	75 dc                	jne    801088 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010b0:	c9                   	leaveq 
  8010b1:	c3                   	retq   

00000000008010b2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010b2:	55                   	push   %rbp
  8010b3:	48 89 e5             	mov    %rsp,%rbp
  8010b6:	48 83 ec 20          	sub    $0x20,%rsp
  8010ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c6:	48 89 c7             	mov    %rax,%rdi
  8010c9:	48 b8 03 10 80 00 00 	movabs $0x801003,%rax
  8010d0:	00 00 00 
  8010d3:	ff d0                	callq  *%rax
  8010d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010db:	48 63 d0             	movslq %eax,%rdx
  8010de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e2:	48 01 c2             	add    %rax,%rdx
  8010e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010e9:	48 89 c6             	mov    %rax,%rsi
  8010ec:	48 89 d7             	mov    %rdx,%rdi
  8010ef:	48 b8 6f 10 80 00 00 	movabs $0x80106f,%rax
  8010f6:	00 00 00 
  8010f9:	ff d0                	callq  *%rax
	return dst;
  8010fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010ff:	c9                   	leaveq 
  801100:	c3                   	retq   

0000000000801101 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801101:	55                   	push   %rbp
  801102:	48 89 e5             	mov    %rsp,%rbp
  801105:	48 83 ec 28          	sub    $0x28,%rsp
  801109:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80110d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801111:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801115:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801119:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80111d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801124:	00 
  801125:	eb 2a                	jmp    801151 <strncpy+0x50>
		*dst++ = *src;
  801127:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80112b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80112f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801133:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801137:	0f b6 12             	movzbl (%rdx),%edx
  80113a:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80113c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801140:	0f b6 00             	movzbl (%rax),%eax
  801143:	84 c0                	test   %al,%al
  801145:	74 05                	je     80114c <strncpy+0x4b>
			src++;
  801147:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80114c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801151:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801155:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801159:	72 cc                	jb     801127 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80115b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80115f:	c9                   	leaveq 
  801160:	c3                   	retq   

0000000000801161 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801161:	55                   	push   %rbp
  801162:	48 89 e5             	mov    %rsp,%rbp
  801165:	48 83 ec 28          	sub    $0x28,%rsp
  801169:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80116d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801171:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801175:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801179:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80117d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801182:	74 3d                	je     8011c1 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801184:	eb 1d                	jmp    8011a3 <strlcpy+0x42>
			*dst++ = *src++;
  801186:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80118e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801192:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801196:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80119a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80119e:	0f b6 12             	movzbl (%rdx),%edx
  8011a1:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011a3:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011a8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011ad:	74 0b                	je     8011ba <strlcpy+0x59>
  8011af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011b3:	0f b6 00             	movzbl (%rax),%eax
  8011b6:	84 c0                	test   %al,%al
  8011b8:	75 cc                	jne    801186 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011be:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011c1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c9:	48 29 c2             	sub    %rax,%rdx
  8011cc:	48 89 d0             	mov    %rdx,%rax
}
  8011cf:	c9                   	leaveq 
  8011d0:	c3                   	retq   

00000000008011d1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011d1:	55                   	push   %rbp
  8011d2:	48 89 e5             	mov    %rsp,%rbp
  8011d5:	48 83 ec 10          	sub    $0x10,%rsp
  8011d9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011dd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011e1:	eb 0a                	jmp    8011ed <strcmp+0x1c>
		p++, q++;
  8011e3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011e8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f1:	0f b6 00             	movzbl (%rax),%eax
  8011f4:	84 c0                	test   %al,%al
  8011f6:	74 12                	je     80120a <strcmp+0x39>
  8011f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011fc:	0f b6 10             	movzbl (%rax),%edx
  8011ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801203:	0f b6 00             	movzbl (%rax),%eax
  801206:	38 c2                	cmp    %al,%dl
  801208:	74 d9                	je     8011e3 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80120a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80120e:	0f b6 00             	movzbl (%rax),%eax
  801211:	0f b6 d0             	movzbl %al,%edx
  801214:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801218:	0f b6 00             	movzbl (%rax),%eax
  80121b:	0f b6 c0             	movzbl %al,%eax
  80121e:	29 c2                	sub    %eax,%edx
  801220:	89 d0                	mov    %edx,%eax
}
  801222:	c9                   	leaveq 
  801223:	c3                   	retq   

0000000000801224 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801224:	55                   	push   %rbp
  801225:	48 89 e5             	mov    %rsp,%rbp
  801228:	48 83 ec 18          	sub    $0x18,%rsp
  80122c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801230:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801234:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801238:	eb 0f                	jmp    801249 <strncmp+0x25>
		n--, p++, q++;
  80123a:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80123f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801244:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801249:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80124e:	74 1d                	je     80126d <strncmp+0x49>
  801250:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801254:	0f b6 00             	movzbl (%rax),%eax
  801257:	84 c0                	test   %al,%al
  801259:	74 12                	je     80126d <strncmp+0x49>
  80125b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125f:	0f b6 10             	movzbl (%rax),%edx
  801262:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801266:	0f b6 00             	movzbl (%rax),%eax
  801269:	38 c2                	cmp    %al,%dl
  80126b:	74 cd                	je     80123a <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80126d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801272:	75 07                	jne    80127b <strncmp+0x57>
		return 0;
  801274:	b8 00 00 00 00       	mov    $0x0,%eax
  801279:	eb 18                	jmp    801293 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80127b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127f:	0f b6 00             	movzbl (%rax),%eax
  801282:	0f b6 d0             	movzbl %al,%edx
  801285:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801289:	0f b6 00             	movzbl (%rax),%eax
  80128c:	0f b6 c0             	movzbl %al,%eax
  80128f:	29 c2                	sub    %eax,%edx
  801291:	89 d0                	mov    %edx,%eax
}
  801293:	c9                   	leaveq 
  801294:	c3                   	retq   

0000000000801295 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801295:	55                   	push   %rbp
  801296:	48 89 e5             	mov    %rsp,%rbp
  801299:	48 83 ec 0c          	sub    $0xc,%rsp
  80129d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012a1:	89 f0                	mov    %esi,%eax
  8012a3:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012a6:	eb 17                	jmp    8012bf <strchr+0x2a>
		if (*s == c)
  8012a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ac:	0f b6 00             	movzbl (%rax),%eax
  8012af:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012b2:	75 06                	jne    8012ba <strchr+0x25>
			return (char *) s;
  8012b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b8:	eb 15                	jmp    8012cf <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012ba:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c3:	0f b6 00             	movzbl (%rax),%eax
  8012c6:	84 c0                	test   %al,%al
  8012c8:	75 de                	jne    8012a8 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012cf:	c9                   	leaveq 
  8012d0:	c3                   	retq   

00000000008012d1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012d1:	55                   	push   %rbp
  8012d2:	48 89 e5             	mov    %rsp,%rbp
  8012d5:	48 83 ec 0c          	sub    $0xc,%rsp
  8012d9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012dd:	89 f0                	mov    %esi,%eax
  8012df:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012e2:	eb 13                	jmp    8012f7 <strfind+0x26>
		if (*s == c)
  8012e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e8:	0f b6 00             	movzbl (%rax),%eax
  8012eb:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012ee:	75 02                	jne    8012f2 <strfind+0x21>
			break;
  8012f0:	eb 10                	jmp    801302 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012f2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012fb:	0f b6 00             	movzbl (%rax),%eax
  8012fe:	84 c0                	test   %al,%al
  801300:	75 e2                	jne    8012e4 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801302:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801306:	c9                   	leaveq 
  801307:	c3                   	retq   

0000000000801308 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801308:	55                   	push   %rbp
  801309:	48 89 e5             	mov    %rsp,%rbp
  80130c:	48 83 ec 18          	sub    $0x18,%rsp
  801310:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801314:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801317:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80131b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801320:	75 06                	jne    801328 <memset+0x20>
		return v;
  801322:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801326:	eb 69                	jmp    801391 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801328:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132c:	83 e0 03             	and    $0x3,%eax
  80132f:	48 85 c0             	test   %rax,%rax
  801332:	75 48                	jne    80137c <memset+0x74>
  801334:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801338:	83 e0 03             	and    $0x3,%eax
  80133b:	48 85 c0             	test   %rax,%rax
  80133e:	75 3c                	jne    80137c <memset+0x74>
		c &= 0xFF;
  801340:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801347:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80134a:	c1 e0 18             	shl    $0x18,%eax
  80134d:	89 c2                	mov    %eax,%edx
  80134f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801352:	c1 e0 10             	shl    $0x10,%eax
  801355:	09 c2                	or     %eax,%edx
  801357:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80135a:	c1 e0 08             	shl    $0x8,%eax
  80135d:	09 d0                	or     %edx,%eax
  80135f:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801362:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801366:	48 c1 e8 02          	shr    $0x2,%rax
  80136a:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80136d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801371:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801374:	48 89 d7             	mov    %rdx,%rdi
  801377:	fc                   	cld    
  801378:	f3 ab                	rep stos %eax,%es:(%rdi)
  80137a:	eb 11                	jmp    80138d <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80137c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801380:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801383:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801387:	48 89 d7             	mov    %rdx,%rdi
  80138a:	fc                   	cld    
  80138b:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80138d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801391:	c9                   	leaveq 
  801392:	c3                   	retq   

0000000000801393 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801393:	55                   	push   %rbp
  801394:	48 89 e5             	mov    %rsp,%rbp
  801397:	48 83 ec 28          	sub    $0x28,%rsp
  80139b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80139f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013a3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013a7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013ab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013b3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013bb:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013bf:	0f 83 88 00 00 00    	jae    80144d <memmove+0xba>
  8013c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013cd:	48 01 d0             	add    %rdx,%rax
  8013d0:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013d4:	76 77                	jbe    80144d <memmove+0xba>
		s += n;
  8013d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013da:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e2:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ea:	83 e0 03             	and    $0x3,%eax
  8013ed:	48 85 c0             	test   %rax,%rax
  8013f0:	75 3b                	jne    80142d <memmove+0x9a>
  8013f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013f6:	83 e0 03             	and    $0x3,%eax
  8013f9:	48 85 c0             	test   %rax,%rax
  8013fc:	75 2f                	jne    80142d <memmove+0x9a>
  8013fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801402:	83 e0 03             	and    $0x3,%eax
  801405:	48 85 c0             	test   %rax,%rax
  801408:	75 23                	jne    80142d <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80140a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80140e:	48 83 e8 04          	sub    $0x4,%rax
  801412:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801416:	48 83 ea 04          	sub    $0x4,%rdx
  80141a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80141e:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801422:	48 89 c7             	mov    %rax,%rdi
  801425:	48 89 d6             	mov    %rdx,%rsi
  801428:	fd                   	std    
  801429:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80142b:	eb 1d                	jmp    80144a <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80142d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801431:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801435:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801439:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80143d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801441:	48 89 d7             	mov    %rdx,%rdi
  801444:	48 89 c1             	mov    %rax,%rcx
  801447:	fd                   	std    
  801448:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80144a:	fc                   	cld    
  80144b:	eb 57                	jmp    8014a4 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80144d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801451:	83 e0 03             	and    $0x3,%eax
  801454:	48 85 c0             	test   %rax,%rax
  801457:	75 36                	jne    80148f <memmove+0xfc>
  801459:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80145d:	83 e0 03             	and    $0x3,%eax
  801460:	48 85 c0             	test   %rax,%rax
  801463:	75 2a                	jne    80148f <memmove+0xfc>
  801465:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801469:	83 e0 03             	and    $0x3,%eax
  80146c:	48 85 c0             	test   %rax,%rax
  80146f:	75 1e                	jne    80148f <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801471:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801475:	48 c1 e8 02          	shr    $0x2,%rax
  801479:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80147c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801480:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801484:	48 89 c7             	mov    %rax,%rdi
  801487:	48 89 d6             	mov    %rdx,%rsi
  80148a:	fc                   	cld    
  80148b:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80148d:	eb 15                	jmp    8014a4 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80148f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801493:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801497:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80149b:	48 89 c7             	mov    %rax,%rdi
  80149e:	48 89 d6             	mov    %rdx,%rsi
  8014a1:	fc                   	cld    
  8014a2:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014a8:	c9                   	leaveq 
  8014a9:	c3                   	retq   

00000000008014aa <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014aa:	55                   	push   %rbp
  8014ab:	48 89 e5             	mov    %rsp,%rbp
  8014ae:	48 83 ec 18          	sub    $0x18,%rsp
  8014b2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014b6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014ba:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014c2:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ca:	48 89 ce             	mov    %rcx,%rsi
  8014cd:	48 89 c7             	mov    %rax,%rdi
  8014d0:	48 b8 93 13 80 00 00 	movabs $0x801393,%rax
  8014d7:	00 00 00 
  8014da:	ff d0                	callq  *%rax
}
  8014dc:	c9                   	leaveq 
  8014dd:	c3                   	retq   

00000000008014de <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014de:	55                   	push   %rbp
  8014df:	48 89 e5             	mov    %rsp,%rbp
  8014e2:	48 83 ec 28          	sub    $0x28,%rsp
  8014e6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014ea:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014ee:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014f6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014fe:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801502:	eb 36                	jmp    80153a <memcmp+0x5c>
		if (*s1 != *s2)
  801504:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801508:	0f b6 10             	movzbl (%rax),%edx
  80150b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80150f:	0f b6 00             	movzbl (%rax),%eax
  801512:	38 c2                	cmp    %al,%dl
  801514:	74 1a                	je     801530 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801516:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80151a:	0f b6 00             	movzbl (%rax),%eax
  80151d:	0f b6 d0             	movzbl %al,%edx
  801520:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801524:	0f b6 00             	movzbl (%rax),%eax
  801527:	0f b6 c0             	movzbl %al,%eax
  80152a:	29 c2                	sub    %eax,%edx
  80152c:	89 d0                	mov    %edx,%eax
  80152e:	eb 20                	jmp    801550 <memcmp+0x72>
		s1++, s2++;
  801530:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801535:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80153a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801542:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801546:	48 85 c0             	test   %rax,%rax
  801549:	75 b9                	jne    801504 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80154b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801550:	c9                   	leaveq 
  801551:	c3                   	retq   

0000000000801552 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801552:	55                   	push   %rbp
  801553:	48 89 e5             	mov    %rsp,%rbp
  801556:	48 83 ec 28          	sub    $0x28,%rsp
  80155a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80155e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801561:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801565:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801569:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80156d:	48 01 d0             	add    %rdx,%rax
  801570:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801574:	eb 15                	jmp    80158b <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801576:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80157a:	0f b6 10             	movzbl (%rax),%edx
  80157d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801580:	38 c2                	cmp    %al,%dl
  801582:	75 02                	jne    801586 <memfind+0x34>
			break;
  801584:	eb 0f                	jmp    801595 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801586:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80158b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80158f:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801593:	72 e1                	jb     801576 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801595:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801599:	c9                   	leaveq 
  80159a:	c3                   	retq   

000000000080159b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80159b:	55                   	push   %rbp
  80159c:	48 89 e5             	mov    %rsp,%rbp
  80159f:	48 83 ec 34          	sub    $0x34,%rsp
  8015a3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015a7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015ab:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015b5:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015bc:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015bd:	eb 05                	jmp    8015c4 <strtol+0x29>
		s++;
  8015bf:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c8:	0f b6 00             	movzbl (%rax),%eax
  8015cb:	3c 20                	cmp    $0x20,%al
  8015cd:	74 f0                	je     8015bf <strtol+0x24>
  8015cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d3:	0f b6 00             	movzbl (%rax),%eax
  8015d6:	3c 09                	cmp    $0x9,%al
  8015d8:	74 e5                	je     8015bf <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015de:	0f b6 00             	movzbl (%rax),%eax
  8015e1:	3c 2b                	cmp    $0x2b,%al
  8015e3:	75 07                	jne    8015ec <strtol+0x51>
		s++;
  8015e5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015ea:	eb 17                	jmp    801603 <strtol+0x68>
	else if (*s == '-')
  8015ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f0:	0f b6 00             	movzbl (%rax),%eax
  8015f3:	3c 2d                	cmp    $0x2d,%al
  8015f5:	75 0c                	jne    801603 <strtol+0x68>
		s++, neg = 1;
  8015f7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015fc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801603:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801607:	74 06                	je     80160f <strtol+0x74>
  801609:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80160d:	75 28                	jne    801637 <strtol+0x9c>
  80160f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801613:	0f b6 00             	movzbl (%rax),%eax
  801616:	3c 30                	cmp    $0x30,%al
  801618:	75 1d                	jne    801637 <strtol+0x9c>
  80161a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161e:	48 83 c0 01          	add    $0x1,%rax
  801622:	0f b6 00             	movzbl (%rax),%eax
  801625:	3c 78                	cmp    $0x78,%al
  801627:	75 0e                	jne    801637 <strtol+0x9c>
		s += 2, base = 16;
  801629:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80162e:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801635:	eb 2c                	jmp    801663 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801637:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80163b:	75 19                	jne    801656 <strtol+0xbb>
  80163d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801641:	0f b6 00             	movzbl (%rax),%eax
  801644:	3c 30                	cmp    $0x30,%al
  801646:	75 0e                	jne    801656 <strtol+0xbb>
		s++, base = 8;
  801648:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80164d:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801654:	eb 0d                	jmp    801663 <strtol+0xc8>
	else if (base == 0)
  801656:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80165a:	75 07                	jne    801663 <strtol+0xc8>
		base = 10;
  80165c:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801663:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801667:	0f b6 00             	movzbl (%rax),%eax
  80166a:	3c 2f                	cmp    $0x2f,%al
  80166c:	7e 1d                	jle    80168b <strtol+0xf0>
  80166e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801672:	0f b6 00             	movzbl (%rax),%eax
  801675:	3c 39                	cmp    $0x39,%al
  801677:	7f 12                	jg     80168b <strtol+0xf0>
			dig = *s - '0';
  801679:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167d:	0f b6 00             	movzbl (%rax),%eax
  801680:	0f be c0             	movsbl %al,%eax
  801683:	83 e8 30             	sub    $0x30,%eax
  801686:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801689:	eb 4e                	jmp    8016d9 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80168b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168f:	0f b6 00             	movzbl (%rax),%eax
  801692:	3c 60                	cmp    $0x60,%al
  801694:	7e 1d                	jle    8016b3 <strtol+0x118>
  801696:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169a:	0f b6 00             	movzbl (%rax),%eax
  80169d:	3c 7a                	cmp    $0x7a,%al
  80169f:	7f 12                	jg     8016b3 <strtol+0x118>
			dig = *s - 'a' + 10;
  8016a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a5:	0f b6 00             	movzbl (%rax),%eax
  8016a8:	0f be c0             	movsbl %al,%eax
  8016ab:	83 e8 57             	sub    $0x57,%eax
  8016ae:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016b1:	eb 26                	jmp    8016d9 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b7:	0f b6 00             	movzbl (%rax),%eax
  8016ba:	3c 40                	cmp    $0x40,%al
  8016bc:	7e 48                	jle    801706 <strtol+0x16b>
  8016be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c2:	0f b6 00             	movzbl (%rax),%eax
  8016c5:	3c 5a                	cmp    $0x5a,%al
  8016c7:	7f 3d                	jg     801706 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cd:	0f b6 00             	movzbl (%rax),%eax
  8016d0:	0f be c0             	movsbl %al,%eax
  8016d3:	83 e8 37             	sub    $0x37,%eax
  8016d6:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016dc:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016df:	7c 02                	jl     8016e3 <strtol+0x148>
			break;
  8016e1:	eb 23                	jmp    801706 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016e3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016e8:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016eb:	48 98                	cltq   
  8016ed:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016f2:	48 89 c2             	mov    %rax,%rdx
  8016f5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016f8:	48 98                	cltq   
  8016fa:	48 01 d0             	add    %rdx,%rax
  8016fd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801701:	e9 5d ff ff ff       	jmpq   801663 <strtol+0xc8>

	if (endptr)
  801706:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80170b:	74 0b                	je     801718 <strtol+0x17d>
		*endptr = (char *) s;
  80170d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801711:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801715:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801718:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80171c:	74 09                	je     801727 <strtol+0x18c>
  80171e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801722:	48 f7 d8             	neg    %rax
  801725:	eb 04                	jmp    80172b <strtol+0x190>
  801727:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80172b:	c9                   	leaveq 
  80172c:	c3                   	retq   

000000000080172d <strstr>:

char * strstr(const char *in, const char *str)
{
  80172d:	55                   	push   %rbp
  80172e:	48 89 e5             	mov    %rsp,%rbp
  801731:	48 83 ec 30          	sub    $0x30,%rsp
  801735:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801739:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80173d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801741:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801745:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801749:	0f b6 00             	movzbl (%rax),%eax
  80174c:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80174f:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801753:	75 06                	jne    80175b <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801755:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801759:	eb 6b                	jmp    8017c6 <strstr+0x99>

	len = strlen(str);
  80175b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80175f:	48 89 c7             	mov    %rax,%rdi
  801762:	48 b8 03 10 80 00 00 	movabs $0x801003,%rax
  801769:	00 00 00 
  80176c:	ff d0                	callq  *%rax
  80176e:	48 98                	cltq   
  801770:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801774:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801778:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80177c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801780:	0f b6 00             	movzbl (%rax),%eax
  801783:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801786:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80178a:	75 07                	jne    801793 <strstr+0x66>
				return (char *) 0;
  80178c:	b8 00 00 00 00       	mov    $0x0,%eax
  801791:	eb 33                	jmp    8017c6 <strstr+0x99>
		} while (sc != c);
  801793:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801797:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80179a:	75 d8                	jne    801774 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80179c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017a0:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a8:	48 89 ce             	mov    %rcx,%rsi
  8017ab:	48 89 c7             	mov    %rax,%rdi
  8017ae:	48 b8 24 12 80 00 00 	movabs $0x801224,%rax
  8017b5:	00 00 00 
  8017b8:	ff d0                	callq  *%rax
  8017ba:	85 c0                	test   %eax,%eax
  8017bc:	75 b6                	jne    801774 <strstr+0x47>

	return (char *) (in - 1);
  8017be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c2:	48 83 e8 01          	sub    $0x1,%rax
}
  8017c6:	c9                   	leaveq 
  8017c7:	c3                   	retq   

00000000008017c8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8017c8:	55                   	push   %rbp
  8017c9:	48 89 e5             	mov    %rsp,%rbp
  8017cc:	53                   	push   %rbx
  8017cd:	48 83 ec 48          	sub    $0x48,%rsp
  8017d1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017d4:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8017d7:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017db:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017df:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017e3:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  8017e7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017ea:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017ee:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017f2:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017f6:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017fa:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017fe:	4c 89 c3             	mov    %r8,%rbx
  801801:	cd 30                	int    $0x30
  801803:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  801807:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80180b:	74 3e                	je     80184b <syscall+0x83>
  80180d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801812:	7e 37                	jle    80184b <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801814:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801818:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80181b:	49 89 d0             	mov    %rdx,%r8
  80181e:	89 c1                	mov    %eax,%ecx
  801820:	48 ba e8 41 80 00 00 	movabs $0x8041e8,%rdx
  801827:	00 00 00 
  80182a:	be 4a 00 00 00       	mov    $0x4a,%esi
  80182f:	48 bf 05 42 80 00 00 	movabs $0x804205,%rdi
  801836:	00 00 00 
  801839:	b8 00 00 00 00       	mov    $0x0,%eax
  80183e:	49 b9 81 02 80 00 00 	movabs $0x800281,%r9
  801845:	00 00 00 
  801848:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  80184b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80184f:	48 83 c4 48          	add    $0x48,%rsp
  801853:	5b                   	pop    %rbx
  801854:	5d                   	pop    %rbp
  801855:	c3                   	retq   

0000000000801856 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801856:	55                   	push   %rbp
  801857:	48 89 e5             	mov    %rsp,%rbp
  80185a:	48 83 ec 20          	sub    $0x20,%rsp
  80185e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801862:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801866:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80186a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80186e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801875:	00 
  801876:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80187c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801882:	48 89 d1             	mov    %rdx,%rcx
  801885:	48 89 c2             	mov    %rax,%rdx
  801888:	be 00 00 00 00       	mov    $0x0,%esi
  80188d:	bf 00 00 00 00       	mov    $0x0,%edi
  801892:	48 b8 c8 17 80 00 00 	movabs $0x8017c8,%rax
  801899:	00 00 00 
  80189c:	ff d0                	callq  *%rax
}
  80189e:	c9                   	leaveq 
  80189f:	c3                   	retq   

00000000008018a0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018a0:	55                   	push   %rbp
  8018a1:	48 89 e5             	mov    %rsp,%rbp
  8018a4:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8018a8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018af:	00 
  8018b0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018b6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018bc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c6:	be 00 00 00 00       	mov    $0x0,%esi
  8018cb:	bf 01 00 00 00       	mov    $0x1,%edi
  8018d0:	48 b8 c8 17 80 00 00 	movabs $0x8017c8,%rax
  8018d7:	00 00 00 
  8018da:	ff d0                	callq  *%rax
}
  8018dc:	c9                   	leaveq 
  8018dd:	c3                   	retq   

00000000008018de <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018de:	55                   	push   %rbp
  8018df:	48 89 e5             	mov    %rsp,%rbp
  8018e2:	48 83 ec 10          	sub    $0x10,%rsp
  8018e6:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ec:	48 98                	cltq   
  8018ee:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018f5:	00 
  8018f6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018fc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801902:	b9 00 00 00 00       	mov    $0x0,%ecx
  801907:	48 89 c2             	mov    %rax,%rdx
  80190a:	be 01 00 00 00       	mov    $0x1,%esi
  80190f:	bf 03 00 00 00       	mov    $0x3,%edi
  801914:	48 b8 c8 17 80 00 00 	movabs $0x8017c8,%rax
  80191b:	00 00 00 
  80191e:	ff d0                	callq  *%rax
}
  801920:	c9                   	leaveq 
  801921:	c3                   	retq   

0000000000801922 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801922:	55                   	push   %rbp
  801923:	48 89 e5             	mov    %rsp,%rbp
  801926:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80192a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801931:	00 
  801932:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801938:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80193e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801943:	ba 00 00 00 00       	mov    $0x0,%edx
  801948:	be 00 00 00 00       	mov    $0x0,%esi
  80194d:	bf 02 00 00 00       	mov    $0x2,%edi
  801952:	48 b8 c8 17 80 00 00 	movabs $0x8017c8,%rax
  801959:	00 00 00 
  80195c:	ff d0                	callq  *%rax
}
  80195e:	c9                   	leaveq 
  80195f:	c3                   	retq   

0000000000801960 <sys_yield>:

void
sys_yield(void)
{
  801960:	55                   	push   %rbp
  801961:	48 89 e5             	mov    %rsp,%rbp
  801964:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801968:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80196f:	00 
  801970:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801976:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80197c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801981:	ba 00 00 00 00       	mov    $0x0,%edx
  801986:	be 00 00 00 00       	mov    $0x0,%esi
  80198b:	bf 0b 00 00 00       	mov    $0xb,%edi
  801990:	48 b8 c8 17 80 00 00 	movabs $0x8017c8,%rax
  801997:	00 00 00 
  80199a:	ff d0                	callq  *%rax
}
  80199c:	c9                   	leaveq 
  80199d:	c3                   	retq   

000000000080199e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80199e:	55                   	push   %rbp
  80199f:	48 89 e5             	mov    %rsp,%rbp
  8019a2:	48 83 ec 20          	sub    $0x20,%rsp
  8019a6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019a9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019ad:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8019b0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019b3:	48 63 c8             	movslq %eax,%rcx
  8019b6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019bd:	48 98                	cltq   
  8019bf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019c6:	00 
  8019c7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019cd:	49 89 c8             	mov    %rcx,%r8
  8019d0:	48 89 d1             	mov    %rdx,%rcx
  8019d3:	48 89 c2             	mov    %rax,%rdx
  8019d6:	be 01 00 00 00       	mov    $0x1,%esi
  8019db:	bf 04 00 00 00       	mov    $0x4,%edi
  8019e0:	48 b8 c8 17 80 00 00 	movabs $0x8017c8,%rax
  8019e7:	00 00 00 
  8019ea:	ff d0                	callq  *%rax
}
  8019ec:	c9                   	leaveq 
  8019ed:	c3                   	retq   

00000000008019ee <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019ee:	55                   	push   %rbp
  8019ef:	48 89 e5             	mov    %rsp,%rbp
  8019f2:	48 83 ec 30          	sub    $0x30,%rsp
  8019f6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019f9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019fd:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a00:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a04:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a08:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a0b:	48 63 c8             	movslq %eax,%rcx
  801a0e:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a12:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a15:	48 63 f0             	movslq %eax,%rsi
  801a18:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a1f:	48 98                	cltq   
  801a21:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a25:	49 89 f9             	mov    %rdi,%r9
  801a28:	49 89 f0             	mov    %rsi,%r8
  801a2b:	48 89 d1             	mov    %rdx,%rcx
  801a2e:	48 89 c2             	mov    %rax,%rdx
  801a31:	be 01 00 00 00       	mov    $0x1,%esi
  801a36:	bf 05 00 00 00       	mov    $0x5,%edi
  801a3b:	48 b8 c8 17 80 00 00 	movabs $0x8017c8,%rax
  801a42:	00 00 00 
  801a45:	ff d0                	callq  *%rax
}
  801a47:	c9                   	leaveq 
  801a48:	c3                   	retq   

0000000000801a49 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a49:	55                   	push   %rbp
  801a4a:	48 89 e5             	mov    %rsp,%rbp
  801a4d:	48 83 ec 20          	sub    $0x20,%rsp
  801a51:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a54:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a58:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a5f:	48 98                	cltq   
  801a61:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a68:	00 
  801a69:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a6f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a75:	48 89 d1             	mov    %rdx,%rcx
  801a78:	48 89 c2             	mov    %rax,%rdx
  801a7b:	be 01 00 00 00       	mov    $0x1,%esi
  801a80:	bf 06 00 00 00       	mov    $0x6,%edi
  801a85:	48 b8 c8 17 80 00 00 	movabs $0x8017c8,%rax
  801a8c:	00 00 00 
  801a8f:	ff d0                	callq  *%rax
}
  801a91:	c9                   	leaveq 
  801a92:	c3                   	retq   

0000000000801a93 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a93:	55                   	push   %rbp
  801a94:	48 89 e5             	mov    %rsp,%rbp
  801a97:	48 83 ec 10          	sub    $0x10,%rsp
  801a9b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a9e:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801aa1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801aa4:	48 63 d0             	movslq %eax,%rdx
  801aa7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aaa:	48 98                	cltq   
  801aac:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ab3:	00 
  801ab4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aba:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ac0:	48 89 d1             	mov    %rdx,%rcx
  801ac3:	48 89 c2             	mov    %rax,%rdx
  801ac6:	be 01 00 00 00       	mov    $0x1,%esi
  801acb:	bf 08 00 00 00       	mov    $0x8,%edi
  801ad0:	48 b8 c8 17 80 00 00 	movabs $0x8017c8,%rax
  801ad7:	00 00 00 
  801ada:	ff d0                	callq  *%rax
}
  801adc:	c9                   	leaveq 
  801add:	c3                   	retq   

0000000000801ade <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801ade:	55                   	push   %rbp
  801adf:	48 89 e5             	mov    %rsp,%rbp
  801ae2:	48 83 ec 20          	sub    $0x20,%rsp
  801ae6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ae9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801aed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801af1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801af4:	48 98                	cltq   
  801af6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801afd:	00 
  801afe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b04:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b0a:	48 89 d1             	mov    %rdx,%rcx
  801b0d:	48 89 c2             	mov    %rax,%rdx
  801b10:	be 01 00 00 00       	mov    $0x1,%esi
  801b15:	bf 09 00 00 00       	mov    $0x9,%edi
  801b1a:	48 b8 c8 17 80 00 00 	movabs $0x8017c8,%rax
  801b21:	00 00 00 
  801b24:	ff d0                	callq  *%rax
}
  801b26:	c9                   	leaveq 
  801b27:	c3                   	retq   

0000000000801b28 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b28:	55                   	push   %rbp
  801b29:	48 89 e5             	mov    %rsp,%rbp
  801b2c:	48 83 ec 20          	sub    $0x20,%rsp
  801b30:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b33:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b37:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b3e:	48 98                	cltq   
  801b40:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b47:	00 
  801b48:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b4e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b54:	48 89 d1             	mov    %rdx,%rcx
  801b57:	48 89 c2             	mov    %rax,%rdx
  801b5a:	be 01 00 00 00       	mov    $0x1,%esi
  801b5f:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b64:	48 b8 c8 17 80 00 00 	movabs $0x8017c8,%rax
  801b6b:	00 00 00 
  801b6e:	ff d0                	callq  *%rax
}
  801b70:	c9                   	leaveq 
  801b71:	c3                   	retq   

0000000000801b72 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b72:	55                   	push   %rbp
  801b73:	48 89 e5             	mov    %rsp,%rbp
  801b76:	48 83 ec 20          	sub    $0x20,%rsp
  801b7a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b7d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b81:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b85:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b88:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b8b:	48 63 f0             	movslq %eax,%rsi
  801b8e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b95:	48 98                	cltq   
  801b97:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b9b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ba2:	00 
  801ba3:	49 89 f1             	mov    %rsi,%r9
  801ba6:	49 89 c8             	mov    %rcx,%r8
  801ba9:	48 89 d1             	mov    %rdx,%rcx
  801bac:	48 89 c2             	mov    %rax,%rdx
  801baf:	be 00 00 00 00       	mov    $0x0,%esi
  801bb4:	bf 0c 00 00 00       	mov    $0xc,%edi
  801bb9:	48 b8 c8 17 80 00 00 	movabs $0x8017c8,%rax
  801bc0:	00 00 00 
  801bc3:	ff d0                	callq  *%rax
}
  801bc5:	c9                   	leaveq 
  801bc6:	c3                   	retq   

0000000000801bc7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801bc7:	55                   	push   %rbp
  801bc8:	48 89 e5             	mov    %rsp,%rbp
  801bcb:	48 83 ec 10          	sub    $0x10,%rsp
  801bcf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801bd3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bd7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bde:	00 
  801bdf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801be5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801beb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bf0:	48 89 c2             	mov    %rax,%rdx
  801bf3:	be 01 00 00 00       	mov    $0x1,%esi
  801bf8:	bf 0d 00 00 00       	mov    $0xd,%edi
  801bfd:	48 b8 c8 17 80 00 00 	movabs $0x8017c8,%rax
  801c04:	00 00 00 
  801c07:	ff d0                	callq  *%rax
}
  801c09:	c9                   	leaveq 
  801c0a:	c3                   	retq   

0000000000801c0b <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801c0b:	55                   	push   %rbp
  801c0c:	48 89 e5             	mov    %rsp,%rbp
  801c0f:	53                   	push   %rbx
  801c10:	48 83 ec 48          	sub    $0x48,%rsp
  801c14:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801c18:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801c1c:	48 8b 00             	mov    (%rax),%rax
  801c1f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	uint32_t err = utf->utf_err;
  801c23:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801c27:	48 8b 40 08          	mov    0x8(%rax),%rax
  801c2b:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	pte_t pte = uvpt[VPN(addr)];
  801c2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c32:	48 c1 e8 0c          	shr    $0xc,%rax
  801c36:	48 89 c2             	mov    %rax,%rdx
  801c39:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c40:	01 00 00 
  801c43:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c47:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	envid_t pid = sys_getenvid();
  801c4b:	48 b8 22 19 80 00 00 	movabs $0x801922,%rax
  801c52:	00 00 00 
  801c55:	ff d0                	callq  *%rax
  801c57:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	void* va = ROUNDDOWN(addr, PGSIZE);
  801c5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c5e:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  801c62:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801c66:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801c6c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	if((err & FEC_WR) && (pte & PTE_COW)){
  801c70:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c73:	83 e0 02             	and    $0x2,%eax
  801c76:	85 c0                	test   %eax,%eax
  801c78:	0f 84 8d 00 00 00    	je     801d0b <pgfault+0x100>
  801c7e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c82:	25 00 08 00 00       	and    $0x800,%eax
  801c87:	48 85 c0             	test   %rax,%rax
  801c8a:	74 7f                	je     801d0b <pgfault+0x100>
		if(!sys_page_alloc(pid, (void*)PFTEMP, PTE_P | PTE_W | PTE_U)){
  801c8c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801c8f:	ba 07 00 00 00       	mov    $0x7,%edx
  801c94:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c99:	89 c7                	mov    %eax,%edi
  801c9b:	48 b8 9e 19 80 00 00 	movabs $0x80199e,%rax
  801ca2:	00 00 00 
  801ca5:	ff d0                	callq  *%rax
  801ca7:	85 c0                	test   %eax,%eax
  801ca9:	75 60                	jne    801d0b <pgfault+0x100>
			memmove(PFTEMP, va, PGSIZE);
  801cab:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801caf:	ba 00 10 00 00       	mov    $0x1000,%edx
  801cb4:	48 89 c6             	mov    %rax,%rsi
  801cb7:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801cbc:	48 b8 93 13 80 00 00 	movabs $0x801393,%rax
  801cc3:	00 00 00 
  801cc6:	ff d0                	callq  *%rax
			if(!(sys_page_map(pid, (void*)PFTEMP, pid, va, PTE_P | PTE_W | PTE_U) | 
  801cc8:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  801ccc:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  801ccf:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801cd2:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801cd8:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801cdd:	89 c7                	mov    %eax,%edi
  801cdf:	48 b8 ee 19 80 00 00 	movabs $0x8019ee,%rax
  801ce6:	00 00 00 
  801ce9:	ff d0                	callq  *%rax
  801ceb:	89 c3                	mov    %eax,%ebx
					 sys_page_unmap(pid, (void*) PFTEMP)))
  801ced:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801cf0:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801cf5:	89 c7                	mov    %eax,%edi
  801cf7:	48 b8 49 1a 80 00 00 	movabs $0x801a49,%rax
  801cfe:	00 00 00 
  801d01:	ff d0                	callq  *%rax
	envid_t pid = sys_getenvid();
	void* va = ROUNDDOWN(addr, PGSIZE);
	if((err & FEC_WR) && (pte & PTE_COW)){
		if(!sys_page_alloc(pid, (void*)PFTEMP, PTE_P | PTE_W | PTE_U)){
			memmove(PFTEMP, va, PGSIZE);
			if(!(sys_page_map(pid, (void*)PFTEMP, pid, va, PTE_P | PTE_W | PTE_U) | 
  801d03:	09 d8                	or     %ebx,%eax
  801d05:	85 c0                	test   %eax,%eax
  801d07:	75 02                	jne    801d0b <pgfault+0x100>
					 sys_page_unmap(pid, (void*) PFTEMP)))
					return;
  801d09:	eb 2a                	jmp    801d35 <pgfault+0x12a>
		}
	}
	panic("Page fault handler failure\n");
  801d0b:	48 ba 13 42 80 00 00 	movabs $0x804213,%rdx
  801d12:	00 00 00 
  801d15:	be 26 00 00 00       	mov    $0x26,%esi
  801d1a:	48 bf 2f 42 80 00 00 	movabs $0x80422f,%rdi
  801d21:	00 00 00 
  801d24:	b8 00 00 00 00       	mov    $0x0,%eax
  801d29:	48 b9 81 02 80 00 00 	movabs $0x800281,%rcx
  801d30:	00 00 00 
  801d33:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	//panic("pgfault not implemented");
}
  801d35:	48 83 c4 48          	add    $0x48,%rsp
  801d39:	5b                   	pop    %rbx
  801d3a:	5d                   	pop    %rbp
  801d3b:	c3                   	retq   

0000000000801d3c <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801d3c:	55                   	push   %rbp
  801d3d:	48 89 e5             	mov    %rsp,%rbp
  801d40:	53                   	push   %rbx
  801d41:	48 83 ec 38          	sub    $0x38,%rsp
  801d45:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801d48:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	//struct Env *env;
	pte_t pte = uvpt[pn];
  801d4b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d52:	01 00 00 
  801d55:	8b 55 c8             	mov    -0x38(%rbp),%edx
  801d58:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d5c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int perm = pte & PTE_SYSCALL;
  801d60:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d64:	25 07 0e 00 00       	and    $0xe07,%eax
  801d69:	89 45 dc             	mov    %eax,-0x24(%rbp)
	void *va = (void*)((uintptr_t)pn * PGSIZE);
  801d6c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801d6f:	48 c1 e0 0c          	shl    $0xc,%rax
  801d73:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	if(perm & PTE_SHARE){
  801d77:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801d7a:	25 00 04 00 00       	and    $0x400,%eax
  801d7f:	85 c0                	test   %eax,%eax
  801d81:	74 30                	je     801db3 <duppage+0x77>
		r = sys_page_map(0, va, envid, va, perm);
  801d83:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801d86:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801d8a:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801d8d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d91:	41 89 f0             	mov    %esi,%r8d
  801d94:	48 89 c6             	mov    %rax,%rsi
  801d97:	bf 00 00 00 00       	mov    $0x0,%edi
  801d9c:	48 b8 ee 19 80 00 00 	movabs $0x8019ee,%rax
  801da3:	00 00 00 
  801da6:	ff d0                	callq  *%rax
  801da8:	89 45 ec             	mov    %eax,-0x14(%rbp)
		return r;
  801dab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801dae:	e9 a4 00 00 00       	jmpq   801e57 <duppage+0x11b>
	}
	//envid_t pid = sys_getenvid();
	if((perm & PTE_W) || (perm & PTE_COW)){
  801db3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801db6:	83 e0 02             	and    $0x2,%eax
  801db9:	85 c0                	test   %eax,%eax
  801dbb:	75 0c                	jne    801dc9 <duppage+0x8d>
  801dbd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801dc0:	25 00 08 00 00       	and    $0x800,%eax
  801dc5:	85 c0                	test   %eax,%eax
  801dc7:	74 63                	je     801e2c <duppage+0xf0>
		perm &= ~PTE_W;
  801dc9:	83 65 dc fd          	andl   $0xfffffffd,-0x24(%rbp)
		perm |= PTE_COW;
  801dcd:	81 4d dc 00 08 00 00 	orl    $0x800,-0x24(%rbp)
		r = sys_page_map(0, va, envid, va, perm) | sys_page_map(0, va, 0, va, perm);
  801dd4:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801dd7:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801ddb:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801dde:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801de2:	41 89 f0             	mov    %esi,%r8d
  801de5:	48 89 c6             	mov    %rax,%rsi
  801de8:	bf 00 00 00 00       	mov    $0x0,%edi
  801ded:	48 b8 ee 19 80 00 00 	movabs $0x8019ee,%rax
  801df4:	00 00 00 
  801df7:	ff d0                	callq  *%rax
  801df9:	89 c3                	mov    %eax,%ebx
  801dfb:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  801dfe:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801e02:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e06:	41 89 c8             	mov    %ecx,%r8d
  801e09:	48 89 d1             	mov    %rdx,%rcx
  801e0c:	ba 00 00 00 00       	mov    $0x0,%edx
  801e11:	48 89 c6             	mov    %rax,%rsi
  801e14:	bf 00 00 00 00       	mov    $0x0,%edi
  801e19:	48 b8 ee 19 80 00 00 	movabs $0x8019ee,%rax
  801e20:	00 00 00 
  801e23:	ff d0                	callq  *%rax
  801e25:	09 d8                	or     %ebx,%eax
  801e27:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801e2a:	eb 28                	jmp    801e54 <duppage+0x118>
	}
	else{
		r = sys_page_map(0, va, envid, va, perm);
  801e2c:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801e2f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801e33:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801e36:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e3a:	41 89 f0             	mov    %esi,%r8d
  801e3d:	48 89 c6             	mov    %rax,%rsi
  801e40:	bf 00 00 00 00       	mov    $0x0,%edi
  801e45:	48 b8 ee 19 80 00 00 	movabs $0x8019ee,%rax
  801e4c:	00 00 00 
  801e4f:	ff d0                	callq  *%rax
  801e51:	89 45 ec             	mov    %eax,-0x14(%rbp)
	}

	// LAB 4: Your code here.
	//panic("duppage not implemented");
	//if(r != 0) panic("Duplicating page failed: %e\n", r);
	return r;
  801e54:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  801e57:	48 83 c4 38          	add    $0x38,%rsp
  801e5b:	5b                   	pop    %rbx
  801e5c:	5d                   	pop    %rbp
  801e5d:	c3                   	retq   

0000000000801e5e <fork>:
//   so you must allocate a new page for the child's user exception stack.
//

envid_t
fork(void)
{
  801e5e:	55                   	push   %rbp
  801e5f:	48 89 e5             	mov    %rsp,%rbp
  801e62:	53                   	push   %rbx
  801e63:	48 83 ec 58          	sub    $0x58,%rsp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  801e67:	48 bf 0b 1c 80 00 00 	movabs $0x801c0b,%rdi
  801e6e:	00 00 00 
  801e71:	48 b8 08 3b 80 00 00 	movabs $0x803b08,%rax
  801e78:	00 00 00 
  801e7b:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801e7d:	b8 07 00 00 00       	mov    $0x7,%eax
  801e82:	cd 30                	int    $0x30
  801e84:	89 45 a4             	mov    %eax,-0x5c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801e87:	8b 45 a4             	mov    -0x5c(%rbp),%eax
	envid_t cid = sys_exofork();
  801e8a:	89 45 cc             	mov    %eax,-0x34(%rbp)
	if(cid < 0) panic("fork failed: %e\n", cid);
  801e8d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801e91:	79 30                	jns    801ec3 <fork+0x65>
  801e93:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801e96:	89 c1                	mov    %eax,%ecx
  801e98:	48 ba 3a 42 80 00 00 	movabs $0x80423a,%rdx
  801e9f:	00 00 00 
  801ea2:	be 72 00 00 00       	mov    $0x72,%esi
  801ea7:	48 bf 2f 42 80 00 00 	movabs $0x80422f,%rdi
  801eae:	00 00 00 
  801eb1:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb6:	49 b8 81 02 80 00 00 	movabs $0x800281,%r8
  801ebd:	00 00 00 
  801ec0:	41 ff d0             	callq  *%r8
	if(cid == 0){
  801ec3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801ec7:	75 46                	jne    801f0f <fork+0xb1>
		thisenv = &envs[ENVX(sys_getenvid())];
  801ec9:	48 b8 22 19 80 00 00 	movabs $0x801922,%rax
  801ed0:	00 00 00 
  801ed3:	ff d0                	callq  *%rax
  801ed5:	25 ff 03 00 00       	and    $0x3ff,%eax
  801eda:	48 63 d0             	movslq %eax,%rdx
  801edd:	48 89 d0             	mov    %rdx,%rax
  801ee0:	48 c1 e0 03          	shl    $0x3,%rax
  801ee4:	48 01 d0             	add    %rdx,%rax
  801ee7:	48 c1 e0 05          	shl    $0x5,%rax
  801eeb:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801ef2:	00 00 00 
  801ef5:	48 01 c2             	add    %rax,%rdx
  801ef8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801eff:	00 00 00 
  801f02:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801f05:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0a:	e9 12 02 00 00       	jmpq   802121 <fork+0x2c3>
	}
	int result;
	if((result = sys_page_alloc(cid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801f0f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801f12:	ba 07 00 00 00       	mov    $0x7,%edx
  801f17:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801f1c:	89 c7                	mov    %eax,%edi
  801f1e:	48 b8 9e 19 80 00 00 	movabs $0x80199e,%rax
  801f25:	00 00 00 
  801f28:	ff d0                	callq  *%rax
  801f2a:	89 45 c8             	mov    %eax,-0x38(%rbp)
  801f2d:	83 7d c8 00          	cmpl   $0x0,-0x38(%rbp)
  801f31:	79 30                	jns    801f63 <fork+0x105>
		panic("fork failed: %e\n", result);
  801f33:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801f36:	89 c1                	mov    %eax,%ecx
  801f38:	48 ba 3a 42 80 00 00 	movabs $0x80423a,%rdx
  801f3f:	00 00 00 
  801f42:	be 79 00 00 00       	mov    $0x79,%esi
  801f47:	48 bf 2f 42 80 00 00 	movabs $0x80422f,%rdi
  801f4e:	00 00 00 
  801f51:	b8 00 00 00 00       	mov    $0x0,%eax
  801f56:	49 b8 81 02 80 00 00 	movabs $0x800281,%r8
  801f5d:	00 00 00 
  801f60:	41 ff d0             	callq  *%r8
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  801f63:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801f6a:	00 
  801f6b:	e9 40 01 00 00       	jmpq   8020b0 <fork+0x252>
		if(uvpml4e[pml4e] & PTE_P){
  801f70:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801f77:	01 00 00 
  801f7a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801f7e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f82:	83 e0 01             	and    $0x1,%eax
  801f85:	48 85 c0             	test   %rax,%rax
  801f88:	0f 84 1d 01 00 00    	je     8020ab <fork+0x24d>
			base_pml4e = pml4e * NPDPENTRIES;
  801f8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f92:	48 c1 e0 09          	shl    $0x9,%rax
  801f96:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  801f9a:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  801fa1:	00 
  801fa2:	e9 f6 00 00 00       	jmpq   80209d <fork+0x23f>
				if(uvpde[base_pml4e + pdpe] & PTE_P){
  801fa7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fab:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801faf:	48 01 c2             	add    %rax,%rdx
  801fb2:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801fb9:	01 00 00 
  801fbc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fc0:	83 e0 01             	and    $0x1,%eax
  801fc3:	48 85 c0             	test   %rax,%rax
  801fc6:	0f 84 cc 00 00 00    	je     802098 <fork+0x23a>
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
  801fcc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fd0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801fd4:	48 01 d0             	add    %rdx,%rax
  801fd7:	48 c1 e0 09          	shl    $0x9,%rax
  801fdb:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
					for(pde = 0; pde < NPDENTRIES; pde++){
  801fdf:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  801fe6:	00 
  801fe7:	e9 9e 00 00 00       	jmpq   80208a <fork+0x22c>
						if(uvpd[base_pdpe + pde] & PTE_P){
  801fec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ff0:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801ff4:	48 01 c2             	add    %rax,%rdx
  801ff7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ffe:	01 00 00 
  802001:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802005:	83 e0 01             	and    $0x1,%eax
  802008:	48 85 c0             	test   %rax,%rax
  80200b:	74 78                	je     802085 <fork+0x227>
							base_pde = (base_pdpe + pde) * NPTENTRIES;
  80200d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802011:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802015:	48 01 d0             	add    %rdx,%rax
  802018:	48 c1 e0 09          	shl    $0x9,%rax
  80201c:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
							for(pte = 0; pte < NPTENTRIES; pte++){
  802020:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  802027:	00 
  802028:	eb 51                	jmp    80207b <fork+0x21d>
								entry = base_pde + pte;
  80202a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80202e:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  802032:	48 01 d0             	add    %rdx,%rax
  802035:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
								if((uvpt[entry] & PTE_P) && (entry != VPN(UXSTACKTOP - PGSIZE))){
  802039:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802040:	01 00 00 
  802043:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802047:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80204b:	83 e0 01             	and    $0x1,%eax
  80204e:	48 85 c0             	test   %rax,%rax
  802051:	74 23                	je     802076 <fork+0x218>
  802053:	48 81 7d a8 ff f7 0e 	cmpq   $0xef7ff,-0x58(%rbp)
  80205a:	00 
  80205b:	74 19                	je     802076 <fork+0x218>
									duppage(cid, entry);
  80205d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802061:	89 c2                	mov    %eax,%edx
  802063:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802066:	89 d6                	mov    %edx,%esi
  802068:	89 c7                	mov    %eax,%edi
  80206a:	48 b8 3c 1d 80 00 00 	movabs $0x801d3c,%rax
  802071:	00 00 00 
  802074:	ff d0                	callq  *%rax
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
						if(uvpd[base_pdpe + pde] & PTE_P){
							base_pde = (base_pdpe + pde) * NPTENTRIES;
							for(pte = 0; pte < NPTENTRIES; pte++){
  802076:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  80207b:	48 81 7d d0 ff 01 00 	cmpq   $0x1ff,-0x30(%rbp)
  802082:	00 
  802083:	76 a5                	jbe    80202a <fork+0x1cc>
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
  802085:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80208a:	48 81 7d d8 ff 01 00 	cmpq   $0x1ff,-0x28(%rbp)
  802091:	00 
  802092:	0f 86 54 ff ff ff    	jbe    801fec <fork+0x18e>
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  802098:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  80209d:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  8020a4:	00 
  8020a5:	0f 86 fc fe ff ff    	jbe    801fa7 <fork+0x149>
	int result;
	if((result = sys_page_alloc(cid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		panic("fork failed: %e\n", result);
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  8020ab:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8020b0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8020b5:	0f 84 b5 fe ff ff    	je     801f70 <fork+0x112>
					}
				}
			}
		}
	}
	if(sys_env_set_pgfault_upcall(cid, _pgfault_upcall) | sys_env_set_status(cid, ENV_RUNNABLE))
  8020bb:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8020be:	48 be 9d 3b 80 00 00 	movabs $0x803b9d,%rsi
  8020c5:	00 00 00 
  8020c8:	89 c7                	mov    %eax,%edi
  8020ca:	48 b8 28 1b 80 00 00 	movabs $0x801b28,%rax
  8020d1:	00 00 00 
  8020d4:	ff d0                	callq  *%rax
  8020d6:	89 c3                	mov    %eax,%ebx
  8020d8:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8020db:	be 02 00 00 00       	mov    $0x2,%esi
  8020e0:	89 c7                	mov    %eax,%edi
  8020e2:	48 b8 93 1a 80 00 00 	movabs $0x801a93,%rax
  8020e9:	00 00 00 
  8020ec:	ff d0                	callq  *%rax
  8020ee:	09 d8                	or     %ebx,%eax
  8020f0:	85 c0                	test   %eax,%eax
  8020f2:	74 2a                	je     80211e <fork+0x2c0>
		panic("fork failed\n");
  8020f4:	48 ba 4b 42 80 00 00 	movabs $0x80424b,%rdx
  8020fb:	00 00 00 
  8020fe:	be 92 00 00 00       	mov    $0x92,%esi
  802103:	48 bf 2f 42 80 00 00 	movabs $0x80422f,%rdi
  80210a:	00 00 00 
  80210d:	b8 00 00 00 00       	mov    $0x0,%eax
  802112:	48 b9 81 02 80 00 00 	movabs $0x800281,%rcx
  802119:	00 00 00 
  80211c:	ff d1                	callq  *%rcx
	return cid;
  80211e:	8b 45 cc             	mov    -0x34(%rbp),%eax
	//panic("fork not implemented");
}
  802121:	48 83 c4 58          	add    $0x58,%rsp
  802125:	5b                   	pop    %rbx
  802126:	5d                   	pop    %rbp
  802127:	c3                   	retq   

0000000000802128 <sfork>:


// Challenge!
int
sfork(void)
{
  802128:	55                   	push   %rbp
  802129:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80212c:	48 ba 58 42 80 00 00 	movabs $0x804258,%rdx
  802133:	00 00 00 
  802136:	be 9c 00 00 00       	mov    $0x9c,%esi
  80213b:	48 bf 2f 42 80 00 00 	movabs $0x80422f,%rdi
  802142:	00 00 00 
  802145:	b8 00 00 00 00       	mov    $0x0,%eax
  80214a:	48 b9 81 02 80 00 00 	movabs $0x800281,%rcx
  802151:	00 00 00 
  802154:	ff d1                	callq  *%rcx

0000000000802156 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802156:	55                   	push   %rbp
  802157:	48 89 e5             	mov    %rsp,%rbp
  80215a:	48 83 ec 30          	sub    $0x30,%rsp
  80215e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802162:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802166:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  80216a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80216f:	74 18                	je     802189 <ipc_recv+0x33>
  802171:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802175:	48 89 c7             	mov    %rax,%rdi
  802178:	48 b8 c7 1b 80 00 00 	movabs $0x801bc7,%rax
  80217f:	00 00 00 
  802182:	ff d0                	callq  *%rax
  802184:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802187:	eb 19                	jmp    8021a2 <ipc_recv+0x4c>
  802189:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  802190:	00 00 00 
  802193:	48 b8 c7 1b 80 00 00 	movabs $0x801bc7,%rax
  80219a:	00 00 00 
  80219d:	ff d0                	callq  *%rax
  80219f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  8021a2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8021a7:	74 26                	je     8021cf <ipc_recv+0x79>
  8021a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021ad:	75 15                	jne    8021c4 <ipc_recv+0x6e>
  8021af:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8021b6:	00 00 00 
  8021b9:	48 8b 00             	mov    (%rax),%rax
  8021bc:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  8021c2:	eb 05                	jmp    8021c9 <ipc_recv+0x73>
  8021c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8021cd:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  8021cf:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8021d4:	74 26                	je     8021fc <ipc_recv+0xa6>
  8021d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021da:	75 15                	jne    8021f1 <ipc_recv+0x9b>
  8021dc:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8021e3:	00 00 00 
  8021e6:	48 8b 00             	mov    (%rax),%rax
  8021e9:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  8021ef:	eb 05                	jmp    8021f6 <ipc_recv+0xa0>
  8021f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8021fa:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  8021fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802200:	75 15                	jne    802217 <ipc_recv+0xc1>
  802202:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802209:	00 00 00 
  80220c:	48 8b 00             	mov    (%rax),%rax
  80220f:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  802215:	eb 03                	jmp    80221a <ipc_recv+0xc4>
  802217:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80221a:	c9                   	leaveq 
  80221b:	c3                   	retq   

000000000080221c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80221c:	55                   	push   %rbp
  80221d:	48 89 e5             	mov    %rsp,%rbp
  802220:	48 83 ec 30          	sub    $0x30,%rsp
  802224:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802227:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80222a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80222e:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  802231:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  802238:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80223d:	75 10                	jne    80224f <ipc_send+0x33>
  80223f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802246:	00 00 00 
  802249:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  80224d:	eb 62                	jmp    8022b1 <ipc_send+0x95>
  80224f:	eb 60                	jmp    8022b1 <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  802251:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802255:	74 30                	je     802287 <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  802257:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80225a:	89 c1                	mov    %eax,%ecx
  80225c:	48 ba 6e 42 80 00 00 	movabs $0x80426e,%rdx
  802263:	00 00 00 
  802266:	be 33 00 00 00       	mov    $0x33,%esi
  80226b:	48 bf 8a 42 80 00 00 	movabs $0x80428a,%rdi
  802272:	00 00 00 
  802275:	b8 00 00 00 00       	mov    $0x0,%eax
  80227a:	49 b8 81 02 80 00 00 	movabs $0x800281,%r8
  802281:	00 00 00 
  802284:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  802287:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80228a:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80228d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802291:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802294:	89 c7                	mov    %eax,%edi
  802296:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  80229d:	00 00 00 
  8022a0:	ff d0                	callq  *%rax
  8022a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  8022a5:	48 b8 60 19 80 00 00 	movabs $0x801960,%rax
  8022ac:	00 00 00 
  8022af:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  8022b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022b5:	75 9a                	jne    802251 <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  8022b7:	c9                   	leaveq 
  8022b8:	c3                   	retq   

00000000008022b9 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022b9:	55                   	push   %rbp
  8022ba:	48 89 e5             	mov    %rsp,%rbp
  8022bd:	48 83 ec 14          	sub    $0x14,%rsp
  8022c1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8022c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022cb:	eb 5e                	jmp    80232b <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8022cd:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8022d4:	00 00 00 
  8022d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022da:	48 63 d0             	movslq %eax,%rdx
  8022dd:	48 89 d0             	mov    %rdx,%rax
  8022e0:	48 c1 e0 03          	shl    $0x3,%rax
  8022e4:	48 01 d0             	add    %rdx,%rax
  8022e7:	48 c1 e0 05          	shl    $0x5,%rax
  8022eb:	48 01 c8             	add    %rcx,%rax
  8022ee:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8022f4:	8b 00                	mov    (%rax),%eax
  8022f6:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8022f9:	75 2c                	jne    802327 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8022fb:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802302:	00 00 00 
  802305:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802308:	48 63 d0             	movslq %eax,%rdx
  80230b:	48 89 d0             	mov    %rdx,%rax
  80230e:	48 c1 e0 03          	shl    $0x3,%rax
  802312:	48 01 d0             	add    %rdx,%rax
  802315:	48 c1 e0 05          	shl    $0x5,%rax
  802319:	48 01 c8             	add    %rcx,%rax
  80231c:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802322:	8b 40 08             	mov    0x8(%rax),%eax
  802325:	eb 12                	jmp    802339 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  802327:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80232b:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802332:	7e 99                	jle    8022cd <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802334:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802339:	c9                   	leaveq 
  80233a:	c3                   	retq   

000000000080233b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80233b:	55                   	push   %rbp
  80233c:	48 89 e5             	mov    %rsp,%rbp
  80233f:	48 83 ec 08          	sub    $0x8,%rsp
  802343:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802347:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80234b:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802352:	ff ff ff 
  802355:	48 01 d0             	add    %rdx,%rax
  802358:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80235c:	c9                   	leaveq 
  80235d:	c3                   	retq   

000000000080235e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80235e:	55                   	push   %rbp
  80235f:	48 89 e5             	mov    %rsp,%rbp
  802362:	48 83 ec 08          	sub    $0x8,%rsp
  802366:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80236a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80236e:	48 89 c7             	mov    %rax,%rdi
  802371:	48 b8 3b 23 80 00 00 	movabs $0x80233b,%rax
  802378:	00 00 00 
  80237b:	ff d0                	callq  *%rax
  80237d:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802383:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802387:	c9                   	leaveq 
  802388:	c3                   	retq   

0000000000802389 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802389:	55                   	push   %rbp
  80238a:	48 89 e5             	mov    %rsp,%rbp
  80238d:	48 83 ec 18          	sub    $0x18,%rsp
  802391:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802395:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80239c:	eb 6b                	jmp    802409 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80239e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023a1:	48 98                	cltq   
  8023a3:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8023a9:	48 c1 e0 0c          	shl    $0xc,%rax
  8023ad:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8023b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023b5:	48 c1 e8 15          	shr    $0x15,%rax
  8023b9:	48 89 c2             	mov    %rax,%rdx
  8023bc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8023c3:	01 00 00 
  8023c6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023ca:	83 e0 01             	and    $0x1,%eax
  8023cd:	48 85 c0             	test   %rax,%rax
  8023d0:	74 21                	je     8023f3 <fd_alloc+0x6a>
  8023d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023d6:	48 c1 e8 0c          	shr    $0xc,%rax
  8023da:	48 89 c2             	mov    %rax,%rdx
  8023dd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023e4:	01 00 00 
  8023e7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023eb:	83 e0 01             	and    $0x1,%eax
  8023ee:	48 85 c0             	test   %rax,%rax
  8023f1:	75 12                	jne    802405 <fd_alloc+0x7c>
			*fd_store = fd;
  8023f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023fb:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8023fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802403:	eb 1a                	jmp    80241f <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802405:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802409:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80240d:	7e 8f                	jle    80239e <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80240f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802413:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80241a:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80241f:	c9                   	leaveq 
  802420:	c3                   	retq   

0000000000802421 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802421:	55                   	push   %rbp
  802422:	48 89 e5             	mov    %rsp,%rbp
  802425:	48 83 ec 20          	sub    $0x20,%rsp
  802429:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80242c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802430:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802434:	78 06                	js     80243c <fd_lookup+0x1b>
  802436:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80243a:	7e 07                	jle    802443 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80243c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802441:	eb 6c                	jmp    8024af <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802443:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802446:	48 98                	cltq   
  802448:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80244e:	48 c1 e0 0c          	shl    $0xc,%rax
  802452:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802456:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80245a:	48 c1 e8 15          	shr    $0x15,%rax
  80245e:	48 89 c2             	mov    %rax,%rdx
  802461:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802468:	01 00 00 
  80246b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80246f:	83 e0 01             	and    $0x1,%eax
  802472:	48 85 c0             	test   %rax,%rax
  802475:	74 21                	je     802498 <fd_lookup+0x77>
  802477:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80247b:	48 c1 e8 0c          	shr    $0xc,%rax
  80247f:	48 89 c2             	mov    %rax,%rdx
  802482:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802489:	01 00 00 
  80248c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802490:	83 e0 01             	and    $0x1,%eax
  802493:	48 85 c0             	test   %rax,%rax
  802496:	75 07                	jne    80249f <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802498:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80249d:	eb 10                	jmp    8024af <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80249f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024a3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024a7:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8024aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024af:	c9                   	leaveq 
  8024b0:	c3                   	retq   

00000000008024b1 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8024b1:	55                   	push   %rbp
  8024b2:	48 89 e5             	mov    %rsp,%rbp
  8024b5:	48 83 ec 30          	sub    $0x30,%rsp
  8024b9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8024bd:	89 f0                	mov    %esi,%eax
  8024bf:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8024c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024c6:	48 89 c7             	mov    %rax,%rdi
  8024c9:	48 b8 3b 23 80 00 00 	movabs $0x80233b,%rax
  8024d0:	00 00 00 
  8024d3:	ff d0                	callq  *%rax
  8024d5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024d9:	48 89 d6             	mov    %rdx,%rsi
  8024dc:	89 c7                	mov    %eax,%edi
  8024de:	48 b8 21 24 80 00 00 	movabs $0x802421,%rax
  8024e5:	00 00 00 
  8024e8:	ff d0                	callq  *%rax
  8024ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f1:	78 0a                	js     8024fd <fd_close+0x4c>
	    || fd != fd2)
  8024f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024f7:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8024fb:	74 12                	je     80250f <fd_close+0x5e>
		return (must_exist ? r : 0);
  8024fd:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802501:	74 05                	je     802508 <fd_close+0x57>
  802503:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802506:	eb 05                	jmp    80250d <fd_close+0x5c>
  802508:	b8 00 00 00 00       	mov    $0x0,%eax
  80250d:	eb 69                	jmp    802578 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80250f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802513:	8b 00                	mov    (%rax),%eax
  802515:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802519:	48 89 d6             	mov    %rdx,%rsi
  80251c:	89 c7                	mov    %eax,%edi
  80251e:	48 b8 7a 25 80 00 00 	movabs $0x80257a,%rax
  802525:	00 00 00 
  802528:	ff d0                	callq  *%rax
  80252a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80252d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802531:	78 2a                	js     80255d <fd_close+0xac>
		if (dev->dev_close)
  802533:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802537:	48 8b 40 20          	mov    0x20(%rax),%rax
  80253b:	48 85 c0             	test   %rax,%rax
  80253e:	74 16                	je     802556 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802540:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802544:	48 8b 40 20          	mov    0x20(%rax),%rax
  802548:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80254c:	48 89 d7             	mov    %rdx,%rdi
  80254f:	ff d0                	callq  *%rax
  802551:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802554:	eb 07                	jmp    80255d <fd_close+0xac>
		else
			r = 0;
  802556:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80255d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802561:	48 89 c6             	mov    %rax,%rsi
  802564:	bf 00 00 00 00       	mov    $0x0,%edi
  802569:	48 b8 49 1a 80 00 00 	movabs $0x801a49,%rax
  802570:	00 00 00 
  802573:	ff d0                	callq  *%rax
	return r;
  802575:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802578:	c9                   	leaveq 
  802579:	c3                   	retq   

000000000080257a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80257a:	55                   	push   %rbp
  80257b:	48 89 e5             	mov    %rsp,%rbp
  80257e:	48 83 ec 20          	sub    $0x20,%rsp
  802582:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802585:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802589:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802590:	eb 41                	jmp    8025d3 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802592:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802599:	00 00 00 
  80259c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80259f:	48 63 d2             	movslq %edx,%rdx
  8025a2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025a6:	8b 00                	mov    (%rax),%eax
  8025a8:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8025ab:	75 22                	jne    8025cf <dev_lookup+0x55>
			*dev = devtab[i];
  8025ad:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8025b4:	00 00 00 
  8025b7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025ba:	48 63 d2             	movslq %edx,%rdx
  8025bd:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8025c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025c5:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8025c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025cd:	eb 60                	jmp    80262f <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8025cf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025d3:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8025da:	00 00 00 
  8025dd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025e0:	48 63 d2             	movslq %edx,%rdx
  8025e3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025e7:	48 85 c0             	test   %rax,%rax
  8025ea:	75 a6                	jne    802592 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8025ec:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8025f3:	00 00 00 
  8025f6:	48 8b 00             	mov    (%rax),%rax
  8025f9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025ff:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802602:	89 c6                	mov    %eax,%esi
  802604:	48 bf 98 42 80 00 00 	movabs $0x804298,%rdi
  80260b:	00 00 00 
  80260e:	b8 00 00 00 00       	mov    $0x0,%eax
  802613:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  80261a:	00 00 00 
  80261d:	ff d1                	callq  *%rcx
	*dev = 0;
  80261f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802623:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80262a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80262f:	c9                   	leaveq 
  802630:	c3                   	retq   

0000000000802631 <close>:

int
close(int fdnum)
{
  802631:	55                   	push   %rbp
  802632:	48 89 e5             	mov    %rsp,%rbp
  802635:	48 83 ec 20          	sub    $0x20,%rsp
  802639:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80263c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802640:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802643:	48 89 d6             	mov    %rdx,%rsi
  802646:	89 c7                	mov    %eax,%edi
  802648:	48 b8 21 24 80 00 00 	movabs $0x802421,%rax
  80264f:	00 00 00 
  802652:	ff d0                	callq  *%rax
  802654:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802657:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80265b:	79 05                	jns    802662 <close+0x31>
		return r;
  80265d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802660:	eb 18                	jmp    80267a <close+0x49>
	else
		return fd_close(fd, 1);
  802662:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802666:	be 01 00 00 00       	mov    $0x1,%esi
  80266b:	48 89 c7             	mov    %rax,%rdi
  80266e:	48 b8 b1 24 80 00 00 	movabs $0x8024b1,%rax
  802675:	00 00 00 
  802678:	ff d0                	callq  *%rax
}
  80267a:	c9                   	leaveq 
  80267b:	c3                   	retq   

000000000080267c <close_all>:

void
close_all(void)
{
  80267c:	55                   	push   %rbp
  80267d:	48 89 e5             	mov    %rsp,%rbp
  802680:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802684:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80268b:	eb 15                	jmp    8026a2 <close_all+0x26>
		close(i);
  80268d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802690:	89 c7                	mov    %eax,%edi
  802692:	48 b8 31 26 80 00 00 	movabs $0x802631,%rax
  802699:	00 00 00 
  80269c:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80269e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8026a2:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8026a6:	7e e5                	jle    80268d <close_all+0x11>
		close(i);
}
  8026a8:	c9                   	leaveq 
  8026a9:	c3                   	retq   

00000000008026aa <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8026aa:	55                   	push   %rbp
  8026ab:	48 89 e5             	mov    %rsp,%rbp
  8026ae:	48 83 ec 40          	sub    $0x40,%rsp
  8026b2:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8026b5:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8026b8:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8026bc:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8026bf:	48 89 d6             	mov    %rdx,%rsi
  8026c2:	89 c7                	mov    %eax,%edi
  8026c4:	48 b8 21 24 80 00 00 	movabs $0x802421,%rax
  8026cb:	00 00 00 
  8026ce:	ff d0                	callq  *%rax
  8026d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026d7:	79 08                	jns    8026e1 <dup+0x37>
		return r;
  8026d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026dc:	e9 70 01 00 00       	jmpq   802851 <dup+0x1a7>
	close(newfdnum);
  8026e1:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026e4:	89 c7                	mov    %eax,%edi
  8026e6:	48 b8 31 26 80 00 00 	movabs $0x802631,%rax
  8026ed:	00 00 00 
  8026f0:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8026f2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026f5:	48 98                	cltq   
  8026f7:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026fd:	48 c1 e0 0c          	shl    $0xc,%rax
  802701:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802705:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802709:	48 89 c7             	mov    %rax,%rdi
  80270c:	48 b8 5e 23 80 00 00 	movabs $0x80235e,%rax
  802713:	00 00 00 
  802716:	ff d0                	callq  *%rax
  802718:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80271c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802720:	48 89 c7             	mov    %rax,%rdi
  802723:	48 b8 5e 23 80 00 00 	movabs $0x80235e,%rax
  80272a:	00 00 00 
  80272d:	ff d0                	callq  *%rax
  80272f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802733:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802737:	48 c1 e8 15          	shr    $0x15,%rax
  80273b:	48 89 c2             	mov    %rax,%rdx
  80273e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802745:	01 00 00 
  802748:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80274c:	83 e0 01             	and    $0x1,%eax
  80274f:	48 85 c0             	test   %rax,%rax
  802752:	74 73                	je     8027c7 <dup+0x11d>
  802754:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802758:	48 c1 e8 0c          	shr    $0xc,%rax
  80275c:	48 89 c2             	mov    %rax,%rdx
  80275f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802766:	01 00 00 
  802769:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80276d:	83 e0 01             	and    $0x1,%eax
  802770:	48 85 c0             	test   %rax,%rax
  802773:	74 52                	je     8027c7 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802775:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802779:	48 c1 e8 0c          	shr    $0xc,%rax
  80277d:	48 89 c2             	mov    %rax,%rdx
  802780:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802787:	01 00 00 
  80278a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80278e:	25 07 0e 00 00       	and    $0xe07,%eax
  802793:	89 c1                	mov    %eax,%ecx
  802795:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802799:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80279d:	41 89 c8             	mov    %ecx,%r8d
  8027a0:	48 89 d1             	mov    %rdx,%rcx
  8027a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8027a8:	48 89 c6             	mov    %rax,%rsi
  8027ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8027b0:	48 b8 ee 19 80 00 00 	movabs $0x8019ee,%rax
  8027b7:	00 00 00 
  8027ba:	ff d0                	callq  *%rax
  8027bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027c3:	79 02                	jns    8027c7 <dup+0x11d>
			goto err;
  8027c5:	eb 57                	jmp    80281e <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8027c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027cb:	48 c1 e8 0c          	shr    $0xc,%rax
  8027cf:	48 89 c2             	mov    %rax,%rdx
  8027d2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027d9:	01 00 00 
  8027dc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027e0:	25 07 0e 00 00       	and    $0xe07,%eax
  8027e5:	89 c1                	mov    %eax,%ecx
  8027e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027eb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027ef:	41 89 c8             	mov    %ecx,%r8d
  8027f2:	48 89 d1             	mov    %rdx,%rcx
  8027f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8027fa:	48 89 c6             	mov    %rax,%rsi
  8027fd:	bf 00 00 00 00       	mov    $0x0,%edi
  802802:	48 b8 ee 19 80 00 00 	movabs $0x8019ee,%rax
  802809:	00 00 00 
  80280c:	ff d0                	callq  *%rax
  80280e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802811:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802815:	79 02                	jns    802819 <dup+0x16f>
		goto err;
  802817:	eb 05                	jmp    80281e <dup+0x174>

	return newfdnum;
  802819:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80281c:	eb 33                	jmp    802851 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80281e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802822:	48 89 c6             	mov    %rax,%rsi
  802825:	bf 00 00 00 00       	mov    $0x0,%edi
  80282a:	48 b8 49 1a 80 00 00 	movabs $0x801a49,%rax
  802831:	00 00 00 
  802834:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802836:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80283a:	48 89 c6             	mov    %rax,%rsi
  80283d:	bf 00 00 00 00       	mov    $0x0,%edi
  802842:	48 b8 49 1a 80 00 00 	movabs $0x801a49,%rax
  802849:	00 00 00 
  80284c:	ff d0                	callq  *%rax
	return r;
  80284e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802851:	c9                   	leaveq 
  802852:	c3                   	retq   

0000000000802853 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802853:	55                   	push   %rbp
  802854:	48 89 e5             	mov    %rsp,%rbp
  802857:	48 83 ec 40          	sub    $0x40,%rsp
  80285b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80285e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802862:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802866:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80286a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80286d:	48 89 d6             	mov    %rdx,%rsi
  802870:	89 c7                	mov    %eax,%edi
  802872:	48 b8 21 24 80 00 00 	movabs $0x802421,%rax
  802879:	00 00 00 
  80287c:	ff d0                	callq  *%rax
  80287e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802881:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802885:	78 24                	js     8028ab <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802887:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80288b:	8b 00                	mov    (%rax),%eax
  80288d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802891:	48 89 d6             	mov    %rdx,%rsi
  802894:	89 c7                	mov    %eax,%edi
  802896:	48 b8 7a 25 80 00 00 	movabs $0x80257a,%rax
  80289d:	00 00 00 
  8028a0:	ff d0                	callq  *%rax
  8028a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028a9:	79 05                	jns    8028b0 <read+0x5d>
		return r;
  8028ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028ae:	eb 76                	jmp    802926 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8028b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028b4:	8b 40 08             	mov    0x8(%rax),%eax
  8028b7:	83 e0 03             	and    $0x3,%eax
  8028ba:	83 f8 01             	cmp    $0x1,%eax
  8028bd:	75 3a                	jne    8028f9 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8028bf:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8028c6:	00 00 00 
  8028c9:	48 8b 00             	mov    (%rax),%rax
  8028cc:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028d2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8028d5:	89 c6                	mov    %eax,%esi
  8028d7:	48 bf b7 42 80 00 00 	movabs $0x8042b7,%rdi
  8028de:	00 00 00 
  8028e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e6:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  8028ed:	00 00 00 
  8028f0:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8028f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028f7:	eb 2d                	jmp    802926 <read+0xd3>
	}
	if (!dev->dev_read)
  8028f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028fd:	48 8b 40 10          	mov    0x10(%rax),%rax
  802901:	48 85 c0             	test   %rax,%rax
  802904:	75 07                	jne    80290d <read+0xba>
		return -E_NOT_SUPP;
  802906:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80290b:	eb 19                	jmp    802926 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80290d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802911:	48 8b 40 10          	mov    0x10(%rax),%rax
  802915:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802919:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80291d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802921:	48 89 cf             	mov    %rcx,%rdi
  802924:	ff d0                	callq  *%rax
}
  802926:	c9                   	leaveq 
  802927:	c3                   	retq   

0000000000802928 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802928:	55                   	push   %rbp
  802929:	48 89 e5             	mov    %rsp,%rbp
  80292c:	48 83 ec 30          	sub    $0x30,%rsp
  802930:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802933:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802937:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80293b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802942:	eb 49                	jmp    80298d <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802944:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802947:	48 98                	cltq   
  802949:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80294d:	48 29 c2             	sub    %rax,%rdx
  802950:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802953:	48 63 c8             	movslq %eax,%rcx
  802956:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80295a:	48 01 c1             	add    %rax,%rcx
  80295d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802960:	48 89 ce             	mov    %rcx,%rsi
  802963:	89 c7                	mov    %eax,%edi
  802965:	48 b8 53 28 80 00 00 	movabs $0x802853,%rax
  80296c:	00 00 00 
  80296f:	ff d0                	callq  *%rax
  802971:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802974:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802978:	79 05                	jns    80297f <readn+0x57>
			return m;
  80297a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80297d:	eb 1c                	jmp    80299b <readn+0x73>
		if (m == 0)
  80297f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802983:	75 02                	jne    802987 <readn+0x5f>
			break;
  802985:	eb 11                	jmp    802998 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802987:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80298a:	01 45 fc             	add    %eax,-0x4(%rbp)
  80298d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802990:	48 98                	cltq   
  802992:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802996:	72 ac                	jb     802944 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802998:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80299b:	c9                   	leaveq 
  80299c:	c3                   	retq   

000000000080299d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80299d:	55                   	push   %rbp
  80299e:	48 89 e5             	mov    %rsp,%rbp
  8029a1:	48 83 ec 40          	sub    $0x40,%rsp
  8029a5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029a8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8029ac:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029b0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029b4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029b7:	48 89 d6             	mov    %rdx,%rsi
  8029ba:	89 c7                	mov    %eax,%edi
  8029bc:	48 b8 21 24 80 00 00 	movabs $0x802421,%rax
  8029c3:	00 00 00 
  8029c6:	ff d0                	callq  *%rax
  8029c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029cf:	78 24                	js     8029f5 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029d5:	8b 00                	mov    (%rax),%eax
  8029d7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029db:	48 89 d6             	mov    %rdx,%rsi
  8029de:	89 c7                	mov    %eax,%edi
  8029e0:	48 b8 7a 25 80 00 00 	movabs $0x80257a,%rax
  8029e7:	00 00 00 
  8029ea:	ff d0                	callq  *%rax
  8029ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029f3:	79 05                	jns    8029fa <write+0x5d>
		return r;
  8029f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029f8:	eb 75                	jmp    802a6f <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8029fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029fe:	8b 40 08             	mov    0x8(%rax),%eax
  802a01:	83 e0 03             	and    $0x3,%eax
  802a04:	85 c0                	test   %eax,%eax
  802a06:	75 3a                	jne    802a42 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802a08:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802a0f:	00 00 00 
  802a12:	48 8b 00             	mov    (%rax),%rax
  802a15:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a1b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a1e:	89 c6                	mov    %eax,%esi
  802a20:	48 bf d3 42 80 00 00 	movabs $0x8042d3,%rdi
  802a27:	00 00 00 
  802a2a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a2f:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  802a36:	00 00 00 
  802a39:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a3b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a40:	eb 2d                	jmp    802a6f <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802a42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a46:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a4a:	48 85 c0             	test   %rax,%rax
  802a4d:	75 07                	jne    802a56 <write+0xb9>
		return -E_NOT_SUPP;
  802a4f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a54:	eb 19                	jmp    802a6f <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802a56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a5a:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a5e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802a62:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a66:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802a6a:	48 89 cf             	mov    %rcx,%rdi
  802a6d:	ff d0                	callq  *%rax
}
  802a6f:	c9                   	leaveq 
  802a70:	c3                   	retq   

0000000000802a71 <seek>:

int
seek(int fdnum, off_t offset)
{
  802a71:	55                   	push   %rbp
  802a72:	48 89 e5             	mov    %rsp,%rbp
  802a75:	48 83 ec 18          	sub    $0x18,%rsp
  802a79:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a7c:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a7f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a83:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a86:	48 89 d6             	mov    %rdx,%rsi
  802a89:	89 c7                	mov    %eax,%edi
  802a8b:	48 b8 21 24 80 00 00 	movabs $0x802421,%rax
  802a92:	00 00 00 
  802a95:	ff d0                	callq  *%rax
  802a97:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a9a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a9e:	79 05                	jns    802aa5 <seek+0x34>
		return r;
  802aa0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aa3:	eb 0f                	jmp    802ab4 <seek+0x43>
	fd->fd_offset = offset;
  802aa5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aa9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802aac:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802aaf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ab4:	c9                   	leaveq 
  802ab5:	c3                   	retq   

0000000000802ab6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802ab6:	55                   	push   %rbp
  802ab7:	48 89 e5             	mov    %rsp,%rbp
  802aba:	48 83 ec 30          	sub    $0x30,%rsp
  802abe:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ac1:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ac4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ac8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802acb:	48 89 d6             	mov    %rdx,%rsi
  802ace:	89 c7                	mov    %eax,%edi
  802ad0:	48 b8 21 24 80 00 00 	movabs $0x802421,%rax
  802ad7:	00 00 00 
  802ada:	ff d0                	callq  *%rax
  802adc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802adf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ae3:	78 24                	js     802b09 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ae5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ae9:	8b 00                	mov    (%rax),%eax
  802aeb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802aef:	48 89 d6             	mov    %rdx,%rsi
  802af2:	89 c7                	mov    %eax,%edi
  802af4:	48 b8 7a 25 80 00 00 	movabs $0x80257a,%rax
  802afb:	00 00 00 
  802afe:	ff d0                	callq  *%rax
  802b00:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b03:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b07:	79 05                	jns    802b0e <ftruncate+0x58>
		return r;
  802b09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b0c:	eb 72                	jmp    802b80 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b12:	8b 40 08             	mov    0x8(%rax),%eax
  802b15:	83 e0 03             	and    $0x3,%eax
  802b18:	85 c0                	test   %eax,%eax
  802b1a:	75 3a                	jne    802b56 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802b1c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802b23:	00 00 00 
  802b26:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802b29:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b2f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b32:	89 c6                	mov    %eax,%esi
  802b34:	48 bf f0 42 80 00 00 	movabs $0x8042f0,%rdi
  802b3b:	00 00 00 
  802b3e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b43:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  802b4a:	00 00 00 
  802b4d:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802b4f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b54:	eb 2a                	jmp    802b80 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802b56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b5a:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b5e:	48 85 c0             	test   %rax,%rax
  802b61:	75 07                	jne    802b6a <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802b63:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b68:	eb 16                	jmp    802b80 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802b6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b6e:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b72:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b76:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802b79:	89 ce                	mov    %ecx,%esi
  802b7b:	48 89 d7             	mov    %rdx,%rdi
  802b7e:	ff d0                	callq  *%rax
}
  802b80:	c9                   	leaveq 
  802b81:	c3                   	retq   

0000000000802b82 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802b82:	55                   	push   %rbp
  802b83:	48 89 e5             	mov    %rsp,%rbp
  802b86:	48 83 ec 30          	sub    $0x30,%rsp
  802b8a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b8d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b91:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b95:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b98:	48 89 d6             	mov    %rdx,%rsi
  802b9b:	89 c7                	mov    %eax,%edi
  802b9d:	48 b8 21 24 80 00 00 	movabs $0x802421,%rax
  802ba4:	00 00 00 
  802ba7:	ff d0                	callq  *%rax
  802ba9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bb0:	78 24                	js     802bd6 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802bb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bb6:	8b 00                	mov    (%rax),%eax
  802bb8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bbc:	48 89 d6             	mov    %rdx,%rsi
  802bbf:	89 c7                	mov    %eax,%edi
  802bc1:	48 b8 7a 25 80 00 00 	movabs $0x80257a,%rax
  802bc8:	00 00 00 
  802bcb:	ff d0                	callq  *%rax
  802bcd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bd0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bd4:	79 05                	jns    802bdb <fstat+0x59>
		return r;
  802bd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bd9:	eb 5e                	jmp    802c39 <fstat+0xb7>
	if (!dev->dev_stat)
  802bdb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bdf:	48 8b 40 28          	mov    0x28(%rax),%rax
  802be3:	48 85 c0             	test   %rax,%rax
  802be6:	75 07                	jne    802bef <fstat+0x6d>
		return -E_NOT_SUPP;
  802be8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802bed:	eb 4a                	jmp    802c39 <fstat+0xb7>
	stat->st_name[0] = 0;
  802bef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bf3:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802bf6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bfa:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802c01:	00 00 00 
	stat->st_isdir = 0;
  802c04:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c08:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802c0f:	00 00 00 
	stat->st_dev = dev;
  802c12:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c16:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c1a:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802c21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c25:	48 8b 40 28          	mov    0x28(%rax),%rax
  802c29:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c2d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802c31:	48 89 ce             	mov    %rcx,%rsi
  802c34:	48 89 d7             	mov    %rdx,%rdi
  802c37:	ff d0                	callq  *%rax
}
  802c39:	c9                   	leaveq 
  802c3a:	c3                   	retq   

0000000000802c3b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802c3b:	55                   	push   %rbp
  802c3c:	48 89 e5             	mov    %rsp,%rbp
  802c3f:	48 83 ec 20          	sub    $0x20,%rsp
  802c43:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c47:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802c4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c4f:	be 00 00 00 00       	mov    $0x0,%esi
  802c54:	48 89 c7             	mov    %rax,%rdi
  802c57:	48 b8 29 2d 80 00 00 	movabs $0x802d29,%rax
  802c5e:	00 00 00 
  802c61:	ff d0                	callq  *%rax
  802c63:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c66:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c6a:	79 05                	jns    802c71 <stat+0x36>
		return fd;
  802c6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c6f:	eb 2f                	jmp    802ca0 <stat+0x65>
	r = fstat(fd, stat);
  802c71:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c78:	48 89 d6             	mov    %rdx,%rsi
  802c7b:	89 c7                	mov    %eax,%edi
  802c7d:	48 b8 82 2b 80 00 00 	movabs $0x802b82,%rax
  802c84:	00 00 00 
  802c87:	ff d0                	callq  *%rax
  802c89:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802c8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c8f:	89 c7                	mov    %eax,%edi
  802c91:	48 b8 31 26 80 00 00 	movabs $0x802631,%rax
  802c98:	00 00 00 
  802c9b:	ff d0                	callq  *%rax
	return r;
  802c9d:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802ca0:	c9                   	leaveq 
  802ca1:	c3                   	retq   

0000000000802ca2 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802ca2:	55                   	push   %rbp
  802ca3:	48 89 e5             	mov    %rsp,%rbp
  802ca6:	48 83 ec 10          	sub    $0x10,%rsp
  802caa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802cad:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802cb1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802cb8:	00 00 00 
  802cbb:	8b 00                	mov    (%rax),%eax
  802cbd:	85 c0                	test   %eax,%eax
  802cbf:	75 1d                	jne    802cde <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802cc1:	bf 01 00 00 00       	mov    $0x1,%edi
  802cc6:	48 b8 b9 22 80 00 00 	movabs $0x8022b9,%rax
  802ccd:	00 00 00 
  802cd0:	ff d0                	callq  *%rax
  802cd2:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802cd9:	00 00 00 
  802cdc:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802cde:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802ce5:	00 00 00 
  802ce8:	8b 00                	mov    (%rax),%eax
  802cea:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802ced:	b9 07 00 00 00       	mov    $0x7,%ecx
  802cf2:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802cf9:	00 00 00 
  802cfc:	89 c7                	mov    %eax,%edi
  802cfe:	48 b8 1c 22 80 00 00 	movabs $0x80221c,%rax
  802d05:	00 00 00 
  802d08:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802d0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d0e:	ba 00 00 00 00       	mov    $0x0,%edx
  802d13:	48 89 c6             	mov    %rax,%rsi
  802d16:	bf 00 00 00 00       	mov    $0x0,%edi
  802d1b:	48 b8 56 21 80 00 00 	movabs $0x802156,%rax
  802d22:	00 00 00 
  802d25:	ff d0                	callq  *%rax
}
  802d27:	c9                   	leaveq 
  802d28:	c3                   	retq   

0000000000802d29 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802d29:	55                   	push   %rbp
  802d2a:	48 89 e5             	mov    %rsp,%rbp
  802d2d:	48 83 ec 20          	sub    $0x20,%rsp
  802d31:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d35:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  802d38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d3c:	48 89 c7             	mov    %rax,%rdi
  802d3f:	48 b8 03 10 80 00 00 	movabs $0x801003,%rax
  802d46:	00 00 00 
  802d49:	ff d0                	callq  *%rax
  802d4b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802d50:	7e 0a                	jle    802d5c <open+0x33>
  802d52:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802d57:	e9 a5 00 00 00       	jmpq   802e01 <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  802d5c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802d60:	48 89 c7             	mov    %rax,%rdi
  802d63:	48 b8 89 23 80 00 00 	movabs $0x802389,%rax
  802d6a:	00 00 00 
  802d6d:	ff d0                	callq  *%rax
  802d6f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d72:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d76:	79 08                	jns    802d80 <open+0x57>
		return r;
  802d78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d7b:	e9 81 00 00 00       	jmpq   802e01 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  802d80:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d87:	00 00 00 
  802d8a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802d8d:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  802d93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d97:	48 89 c6             	mov    %rax,%rsi
  802d9a:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802da1:	00 00 00 
  802da4:	48 b8 6f 10 80 00 00 	movabs $0x80106f,%rax
  802dab:	00 00 00 
  802dae:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  802db0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802db4:	48 89 c6             	mov    %rax,%rsi
  802db7:	bf 01 00 00 00       	mov    $0x1,%edi
  802dbc:	48 b8 a2 2c 80 00 00 	movabs $0x802ca2,%rax
  802dc3:	00 00 00 
  802dc6:	ff d0                	callq  *%rax
  802dc8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dcb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dcf:	79 1d                	jns    802dee <open+0xc5>
		fd_close(fd, 0);
  802dd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dd5:	be 00 00 00 00       	mov    $0x0,%esi
  802dda:	48 89 c7             	mov    %rax,%rdi
  802ddd:	48 b8 b1 24 80 00 00 	movabs $0x8024b1,%rax
  802de4:	00 00 00 
  802de7:	ff d0                	callq  *%rax
		return r;
  802de9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dec:	eb 13                	jmp    802e01 <open+0xd8>
	}
	return fd2num(fd);
  802dee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802df2:	48 89 c7             	mov    %rax,%rdi
  802df5:	48 b8 3b 23 80 00 00 	movabs $0x80233b,%rax
  802dfc:	00 00 00 
  802dff:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  802e01:	c9                   	leaveq 
  802e02:	c3                   	retq   

0000000000802e03 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802e03:	55                   	push   %rbp
  802e04:	48 89 e5             	mov    %rsp,%rbp
  802e07:	48 83 ec 10          	sub    $0x10,%rsp
  802e0b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802e0f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e13:	8b 50 0c             	mov    0xc(%rax),%edx
  802e16:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e1d:	00 00 00 
  802e20:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802e22:	be 00 00 00 00       	mov    $0x0,%esi
  802e27:	bf 06 00 00 00       	mov    $0x6,%edi
  802e2c:	48 b8 a2 2c 80 00 00 	movabs $0x802ca2,%rax
  802e33:	00 00 00 
  802e36:	ff d0                	callq  *%rax
}
  802e38:	c9                   	leaveq 
  802e39:	c3                   	retq   

0000000000802e3a <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802e3a:	55                   	push   %rbp
  802e3b:	48 89 e5             	mov    %rsp,%rbp
  802e3e:	48 83 ec 30          	sub    $0x30,%rsp
  802e42:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e46:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e4a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802e4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e52:	8b 50 0c             	mov    0xc(%rax),%edx
  802e55:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e5c:	00 00 00 
  802e5f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802e61:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e68:	00 00 00 
  802e6b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e6f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  802e73:	be 00 00 00 00       	mov    $0x0,%esi
  802e78:	bf 03 00 00 00       	mov    $0x3,%edi
  802e7d:	48 b8 a2 2c 80 00 00 	movabs $0x802ca2,%rax
  802e84:	00 00 00 
  802e87:	ff d0                	callq  *%rax
  802e89:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e90:	79 05                	jns    802e97 <devfile_read+0x5d>
		return r;
  802e92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e95:	eb 26                	jmp    802ebd <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  802e97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e9a:	48 63 d0             	movslq %eax,%rdx
  802e9d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ea1:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802ea8:	00 00 00 
  802eab:	48 89 c7             	mov    %rax,%rdi
  802eae:	48 b8 aa 14 80 00 00 	movabs $0x8014aa,%rax
  802eb5:	00 00 00 
  802eb8:	ff d0                	callq  *%rax
	return r;
  802eba:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802ebd:	c9                   	leaveq 
  802ebe:	c3                   	retq   

0000000000802ebf <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802ebf:	55                   	push   %rbp
  802ec0:	48 89 e5             	mov    %rsp,%rbp
  802ec3:	48 83 ec 30          	sub    $0x30,%rsp
  802ec7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ecb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ecf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  802ed3:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  802eda:	00 
	n = n > max ? max : n;
  802edb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802edf:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802ee3:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  802ee8:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802eec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ef0:	8b 50 0c             	mov    0xc(%rax),%edx
  802ef3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802efa:	00 00 00 
  802efd:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802eff:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f06:	00 00 00 
  802f09:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f0d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802f11:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f15:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f19:	48 89 c6             	mov    %rax,%rsi
  802f1c:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802f23:	00 00 00 
  802f26:	48 b8 aa 14 80 00 00 	movabs $0x8014aa,%rax
  802f2d:	00 00 00 
  802f30:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  802f32:	be 00 00 00 00       	mov    $0x0,%esi
  802f37:	bf 04 00 00 00       	mov    $0x4,%edi
  802f3c:	48 b8 a2 2c 80 00 00 	movabs $0x802ca2,%rax
  802f43:	00 00 00 
  802f46:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  802f48:	c9                   	leaveq 
  802f49:	c3                   	retq   

0000000000802f4a <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802f4a:	55                   	push   %rbp
  802f4b:	48 89 e5             	mov    %rsp,%rbp
  802f4e:	48 83 ec 20          	sub    $0x20,%rsp
  802f52:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f56:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802f5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f5e:	8b 50 0c             	mov    0xc(%rax),%edx
  802f61:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f68:	00 00 00 
  802f6b:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802f6d:	be 00 00 00 00       	mov    $0x0,%esi
  802f72:	bf 05 00 00 00       	mov    $0x5,%edi
  802f77:	48 b8 a2 2c 80 00 00 	movabs $0x802ca2,%rax
  802f7e:	00 00 00 
  802f81:	ff d0                	callq  *%rax
  802f83:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f86:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f8a:	79 05                	jns    802f91 <devfile_stat+0x47>
		return r;
  802f8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f8f:	eb 56                	jmp    802fe7 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802f91:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f95:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802f9c:	00 00 00 
  802f9f:	48 89 c7             	mov    %rax,%rdi
  802fa2:	48 b8 6f 10 80 00 00 	movabs $0x80106f,%rax
  802fa9:	00 00 00 
  802fac:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802fae:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fb5:	00 00 00 
  802fb8:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802fbe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fc2:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802fc8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fcf:	00 00 00 
  802fd2:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802fd8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fdc:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802fe2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fe7:	c9                   	leaveq 
  802fe8:	c3                   	retq   

0000000000802fe9 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802fe9:	55                   	push   %rbp
  802fea:	48 89 e5             	mov    %rsp,%rbp
  802fed:	48 83 ec 10          	sub    $0x10,%rsp
  802ff1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ff5:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802ff8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ffc:	8b 50 0c             	mov    0xc(%rax),%edx
  802fff:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803006:	00 00 00 
  803009:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80300b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803012:	00 00 00 
  803015:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803018:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80301b:	be 00 00 00 00       	mov    $0x0,%esi
  803020:	bf 02 00 00 00       	mov    $0x2,%edi
  803025:	48 b8 a2 2c 80 00 00 	movabs $0x802ca2,%rax
  80302c:	00 00 00 
  80302f:	ff d0                	callq  *%rax
}
  803031:	c9                   	leaveq 
  803032:	c3                   	retq   

0000000000803033 <remove>:

// Delete a file
int
remove(const char *path)
{
  803033:	55                   	push   %rbp
  803034:	48 89 e5             	mov    %rsp,%rbp
  803037:	48 83 ec 10          	sub    $0x10,%rsp
  80303b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80303f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803043:	48 89 c7             	mov    %rax,%rdi
  803046:	48 b8 03 10 80 00 00 	movabs $0x801003,%rax
  80304d:	00 00 00 
  803050:	ff d0                	callq  *%rax
  803052:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803057:	7e 07                	jle    803060 <remove+0x2d>
		return -E_BAD_PATH;
  803059:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80305e:	eb 33                	jmp    803093 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803060:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803064:	48 89 c6             	mov    %rax,%rsi
  803067:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80306e:	00 00 00 
  803071:	48 b8 6f 10 80 00 00 	movabs $0x80106f,%rax
  803078:	00 00 00 
  80307b:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80307d:	be 00 00 00 00       	mov    $0x0,%esi
  803082:	bf 07 00 00 00       	mov    $0x7,%edi
  803087:	48 b8 a2 2c 80 00 00 	movabs $0x802ca2,%rax
  80308e:	00 00 00 
  803091:	ff d0                	callq  *%rax
}
  803093:	c9                   	leaveq 
  803094:	c3                   	retq   

0000000000803095 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803095:	55                   	push   %rbp
  803096:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803099:	be 00 00 00 00       	mov    $0x0,%esi
  80309e:	bf 08 00 00 00       	mov    $0x8,%edi
  8030a3:	48 b8 a2 2c 80 00 00 	movabs $0x802ca2,%rax
  8030aa:	00 00 00 
  8030ad:	ff d0                	callq  *%rax
}
  8030af:	5d                   	pop    %rbp
  8030b0:	c3                   	retq   

00000000008030b1 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8030b1:	55                   	push   %rbp
  8030b2:	48 89 e5             	mov    %rsp,%rbp
  8030b5:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8030bc:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8030c3:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8030ca:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8030d1:	be 00 00 00 00       	mov    $0x0,%esi
  8030d6:	48 89 c7             	mov    %rax,%rdi
  8030d9:	48 b8 29 2d 80 00 00 	movabs $0x802d29,%rax
  8030e0:	00 00 00 
  8030e3:	ff d0                	callq  *%rax
  8030e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8030e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030ec:	79 28                	jns    803116 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8030ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030f1:	89 c6                	mov    %eax,%esi
  8030f3:	48 bf 16 43 80 00 00 	movabs $0x804316,%rdi
  8030fa:	00 00 00 
  8030fd:	b8 00 00 00 00       	mov    $0x0,%eax
  803102:	48 ba ba 04 80 00 00 	movabs $0x8004ba,%rdx
  803109:	00 00 00 
  80310c:	ff d2                	callq  *%rdx
		return fd_src;
  80310e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803111:	e9 74 01 00 00       	jmpq   80328a <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803116:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80311d:	be 01 01 00 00       	mov    $0x101,%esi
  803122:	48 89 c7             	mov    %rax,%rdi
  803125:	48 b8 29 2d 80 00 00 	movabs $0x802d29,%rax
  80312c:	00 00 00 
  80312f:	ff d0                	callq  *%rax
  803131:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803134:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803138:	79 39                	jns    803173 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80313a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80313d:	89 c6                	mov    %eax,%esi
  80313f:	48 bf 2c 43 80 00 00 	movabs $0x80432c,%rdi
  803146:	00 00 00 
  803149:	b8 00 00 00 00       	mov    $0x0,%eax
  80314e:	48 ba ba 04 80 00 00 	movabs $0x8004ba,%rdx
  803155:	00 00 00 
  803158:	ff d2                	callq  *%rdx
		close(fd_src);
  80315a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80315d:	89 c7                	mov    %eax,%edi
  80315f:	48 b8 31 26 80 00 00 	movabs $0x802631,%rax
  803166:	00 00 00 
  803169:	ff d0                	callq  *%rax
		return fd_dest;
  80316b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80316e:	e9 17 01 00 00       	jmpq   80328a <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803173:	eb 74                	jmp    8031e9 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803175:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803178:	48 63 d0             	movslq %eax,%rdx
  80317b:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803182:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803185:	48 89 ce             	mov    %rcx,%rsi
  803188:	89 c7                	mov    %eax,%edi
  80318a:	48 b8 9d 29 80 00 00 	movabs $0x80299d,%rax
  803191:	00 00 00 
  803194:	ff d0                	callq  *%rax
  803196:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803199:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80319d:	79 4a                	jns    8031e9 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  80319f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8031a2:	89 c6                	mov    %eax,%esi
  8031a4:	48 bf 46 43 80 00 00 	movabs $0x804346,%rdi
  8031ab:	00 00 00 
  8031ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8031b3:	48 ba ba 04 80 00 00 	movabs $0x8004ba,%rdx
  8031ba:	00 00 00 
  8031bd:	ff d2                	callq  *%rdx
			close(fd_src);
  8031bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031c2:	89 c7                	mov    %eax,%edi
  8031c4:	48 b8 31 26 80 00 00 	movabs $0x802631,%rax
  8031cb:	00 00 00 
  8031ce:	ff d0                	callq  *%rax
			close(fd_dest);
  8031d0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031d3:	89 c7                	mov    %eax,%edi
  8031d5:	48 b8 31 26 80 00 00 	movabs $0x802631,%rax
  8031dc:	00 00 00 
  8031df:	ff d0                	callq  *%rax
			return write_size;
  8031e1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8031e4:	e9 a1 00 00 00       	jmpq   80328a <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8031e9:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8031f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031f3:	ba 00 02 00 00       	mov    $0x200,%edx
  8031f8:	48 89 ce             	mov    %rcx,%rsi
  8031fb:	89 c7                	mov    %eax,%edi
  8031fd:	48 b8 53 28 80 00 00 	movabs $0x802853,%rax
  803204:	00 00 00 
  803207:	ff d0                	callq  *%rax
  803209:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80320c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803210:	0f 8f 5f ff ff ff    	jg     803175 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803216:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80321a:	79 47                	jns    803263 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80321c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80321f:	89 c6                	mov    %eax,%esi
  803221:	48 bf 59 43 80 00 00 	movabs $0x804359,%rdi
  803228:	00 00 00 
  80322b:	b8 00 00 00 00       	mov    $0x0,%eax
  803230:	48 ba ba 04 80 00 00 	movabs $0x8004ba,%rdx
  803237:	00 00 00 
  80323a:	ff d2                	callq  *%rdx
		close(fd_src);
  80323c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80323f:	89 c7                	mov    %eax,%edi
  803241:	48 b8 31 26 80 00 00 	movabs $0x802631,%rax
  803248:	00 00 00 
  80324b:	ff d0                	callq  *%rax
		close(fd_dest);
  80324d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803250:	89 c7                	mov    %eax,%edi
  803252:	48 b8 31 26 80 00 00 	movabs $0x802631,%rax
  803259:	00 00 00 
  80325c:	ff d0                	callq  *%rax
		return read_size;
  80325e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803261:	eb 27                	jmp    80328a <copy+0x1d9>
	}
	close(fd_src);
  803263:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803266:	89 c7                	mov    %eax,%edi
  803268:	48 b8 31 26 80 00 00 	movabs $0x802631,%rax
  80326f:	00 00 00 
  803272:	ff d0                	callq  *%rax
	close(fd_dest);
  803274:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803277:	89 c7                	mov    %eax,%edi
  803279:	48 b8 31 26 80 00 00 	movabs $0x802631,%rax
  803280:	00 00 00 
  803283:	ff d0                	callq  *%rax
	return 0;
  803285:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80328a:	c9                   	leaveq 
  80328b:	c3                   	retq   

000000000080328c <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80328c:	55                   	push   %rbp
  80328d:	48 89 e5             	mov    %rsp,%rbp
  803290:	53                   	push   %rbx
  803291:	48 83 ec 38          	sub    $0x38,%rsp
  803295:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803299:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80329d:	48 89 c7             	mov    %rax,%rdi
  8032a0:	48 b8 89 23 80 00 00 	movabs $0x802389,%rax
  8032a7:	00 00 00 
  8032aa:	ff d0                	callq  *%rax
  8032ac:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032af:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032b3:	0f 88 bf 01 00 00    	js     803478 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032bd:	ba 07 04 00 00       	mov    $0x407,%edx
  8032c2:	48 89 c6             	mov    %rax,%rsi
  8032c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8032ca:	48 b8 9e 19 80 00 00 	movabs $0x80199e,%rax
  8032d1:	00 00 00 
  8032d4:	ff d0                	callq  *%rax
  8032d6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032dd:	0f 88 95 01 00 00    	js     803478 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8032e3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8032e7:	48 89 c7             	mov    %rax,%rdi
  8032ea:	48 b8 89 23 80 00 00 	movabs $0x802389,%rax
  8032f1:	00 00 00 
  8032f4:	ff d0                	callq  *%rax
  8032f6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032fd:	0f 88 5d 01 00 00    	js     803460 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803303:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803307:	ba 07 04 00 00       	mov    $0x407,%edx
  80330c:	48 89 c6             	mov    %rax,%rsi
  80330f:	bf 00 00 00 00       	mov    $0x0,%edi
  803314:	48 b8 9e 19 80 00 00 	movabs $0x80199e,%rax
  80331b:	00 00 00 
  80331e:	ff d0                	callq  *%rax
  803320:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803323:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803327:	0f 88 33 01 00 00    	js     803460 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80332d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803331:	48 89 c7             	mov    %rax,%rdi
  803334:	48 b8 5e 23 80 00 00 	movabs $0x80235e,%rax
  80333b:	00 00 00 
  80333e:	ff d0                	callq  *%rax
  803340:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803344:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803348:	ba 07 04 00 00       	mov    $0x407,%edx
  80334d:	48 89 c6             	mov    %rax,%rsi
  803350:	bf 00 00 00 00       	mov    $0x0,%edi
  803355:	48 b8 9e 19 80 00 00 	movabs $0x80199e,%rax
  80335c:	00 00 00 
  80335f:	ff d0                	callq  *%rax
  803361:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803364:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803368:	79 05                	jns    80336f <pipe+0xe3>
		goto err2;
  80336a:	e9 d9 00 00 00       	jmpq   803448 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80336f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803373:	48 89 c7             	mov    %rax,%rdi
  803376:	48 b8 5e 23 80 00 00 	movabs $0x80235e,%rax
  80337d:	00 00 00 
  803380:	ff d0                	callq  *%rax
  803382:	48 89 c2             	mov    %rax,%rdx
  803385:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803389:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80338f:	48 89 d1             	mov    %rdx,%rcx
  803392:	ba 00 00 00 00       	mov    $0x0,%edx
  803397:	48 89 c6             	mov    %rax,%rsi
  80339a:	bf 00 00 00 00       	mov    $0x0,%edi
  80339f:	48 b8 ee 19 80 00 00 	movabs $0x8019ee,%rax
  8033a6:	00 00 00 
  8033a9:	ff d0                	callq  *%rax
  8033ab:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033b2:	79 1b                	jns    8033cf <pipe+0x143>
		goto err3;
  8033b4:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8033b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033b9:	48 89 c6             	mov    %rax,%rsi
  8033bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8033c1:	48 b8 49 1a 80 00 00 	movabs $0x801a49,%rax
  8033c8:	00 00 00 
  8033cb:	ff d0                	callq  *%rax
  8033cd:	eb 79                	jmp    803448 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8033cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033d3:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  8033da:	00 00 00 
  8033dd:	8b 12                	mov    (%rdx),%edx
  8033df:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8033e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033e5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8033ec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033f0:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  8033f7:	00 00 00 
  8033fa:	8b 12                	mov    (%rdx),%edx
  8033fc:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8033fe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803402:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803409:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80340d:	48 89 c7             	mov    %rax,%rdi
  803410:	48 b8 3b 23 80 00 00 	movabs $0x80233b,%rax
  803417:	00 00 00 
  80341a:	ff d0                	callq  *%rax
  80341c:	89 c2                	mov    %eax,%edx
  80341e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803422:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803424:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803428:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80342c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803430:	48 89 c7             	mov    %rax,%rdi
  803433:	48 b8 3b 23 80 00 00 	movabs $0x80233b,%rax
  80343a:	00 00 00 
  80343d:	ff d0                	callq  *%rax
  80343f:	89 03                	mov    %eax,(%rbx)
	return 0;
  803441:	b8 00 00 00 00       	mov    $0x0,%eax
  803446:	eb 33                	jmp    80347b <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803448:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80344c:	48 89 c6             	mov    %rax,%rsi
  80344f:	bf 00 00 00 00       	mov    $0x0,%edi
  803454:	48 b8 49 1a 80 00 00 	movabs $0x801a49,%rax
  80345b:	00 00 00 
  80345e:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803460:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803464:	48 89 c6             	mov    %rax,%rsi
  803467:	bf 00 00 00 00       	mov    $0x0,%edi
  80346c:	48 b8 49 1a 80 00 00 	movabs $0x801a49,%rax
  803473:	00 00 00 
  803476:	ff d0                	callq  *%rax
err:
	return r;
  803478:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80347b:	48 83 c4 38          	add    $0x38,%rsp
  80347f:	5b                   	pop    %rbx
  803480:	5d                   	pop    %rbp
  803481:	c3                   	retq   

0000000000803482 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803482:	55                   	push   %rbp
  803483:	48 89 e5             	mov    %rsp,%rbp
  803486:	53                   	push   %rbx
  803487:	48 83 ec 28          	sub    $0x28,%rsp
  80348b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80348f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803493:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80349a:	00 00 00 
  80349d:	48 8b 00             	mov    (%rax),%rax
  8034a0:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8034a6:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8034a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034ad:	48 89 c7             	mov    %rax,%rdi
  8034b0:	48 b8 27 3c 80 00 00 	movabs $0x803c27,%rax
  8034b7:	00 00 00 
  8034ba:	ff d0                	callq  *%rax
  8034bc:	89 c3                	mov    %eax,%ebx
  8034be:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034c2:	48 89 c7             	mov    %rax,%rdi
  8034c5:	48 b8 27 3c 80 00 00 	movabs $0x803c27,%rax
  8034cc:	00 00 00 
  8034cf:	ff d0                	callq  *%rax
  8034d1:	39 c3                	cmp    %eax,%ebx
  8034d3:	0f 94 c0             	sete   %al
  8034d6:	0f b6 c0             	movzbl %al,%eax
  8034d9:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8034dc:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8034e3:	00 00 00 
  8034e6:	48 8b 00             	mov    (%rax),%rax
  8034e9:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8034ef:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8034f2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034f5:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8034f8:	75 05                	jne    8034ff <_pipeisclosed+0x7d>
			return ret;
  8034fa:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8034fd:	eb 4f                	jmp    80354e <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8034ff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803502:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803505:	74 42                	je     803549 <_pipeisclosed+0xc7>
  803507:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80350b:	75 3c                	jne    803549 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80350d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803514:	00 00 00 
  803517:	48 8b 00             	mov    (%rax),%rax
  80351a:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803520:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803523:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803526:	89 c6                	mov    %eax,%esi
  803528:	48 bf 74 43 80 00 00 	movabs $0x804374,%rdi
  80352f:	00 00 00 
  803532:	b8 00 00 00 00       	mov    $0x0,%eax
  803537:	49 b8 ba 04 80 00 00 	movabs $0x8004ba,%r8
  80353e:	00 00 00 
  803541:	41 ff d0             	callq  *%r8
	}
  803544:	e9 4a ff ff ff       	jmpq   803493 <_pipeisclosed+0x11>
  803549:	e9 45 ff ff ff       	jmpq   803493 <_pipeisclosed+0x11>
}
  80354e:	48 83 c4 28          	add    $0x28,%rsp
  803552:	5b                   	pop    %rbx
  803553:	5d                   	pop    %rbp
  803554:	c3                   	retq   

0000000000803555 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803555:	55                   	push   %rbp
  803556:	48 89 e5             	mov    %rsp,%rbp
  803559:	48 83 ec 30          	sub    $0x30,%rsp
  80355d:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803560:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803564:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803567:	48 89 d6             	mov    %rdx,%rsi
  80356a:	89 c7                	mov    %eax,%edi
  80356c:	48 b8 21 24 80 00 00 	movabs $0x802421,%rax
  803573:	00 00 00 
  803576:	ff d0                	callq  *%rax
  803578:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80357b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80357f:	79 05                	jns    803586 <pipeisclosed+0x31>
		return r;
  803581:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803584:	eb 31                	jmp    8035b7 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803586:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80358a:	48 89 c7             	mov    %rax,%rdi
  80358d:	48 b8 5e 23 80 00 00 	movabs $0x80235e,%rax
  803594:	00 00 00 
  803597:	ff d0                	callq  *%rax
  803599:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80359d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035a1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035a5:	48 89 d6             	mov    %rdx,%rsi
  8035a8:	48 89 c7             	mov    %rax,%rdi
  8035ab:	48 b8 82 34 80 00 00 	movabs $0x803482,%rax
  8035b2:	00 00 00 
  8035b5:	ff d0                	callq  *%rax
}
  8035b7:	c9                   	leaveq 
  8035b8:	c3                   	retq   

00000000008035b9 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8035b9:	55                   	push   %rbp
  8035ba:	48 89 e5             	mov    %rsp,%rbp
  8035bd:	48 83 ec 40          	sub    $0x40,%rsp
  8035c1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8035c5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8035c9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8035cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035d1:	48 89 c7             	mov    %rax,%rdi
  8035d4:	48 b8 5e 23 80 00 00 	movabs $0x80235e,%rax
  8035db:	00 00 00 
  8035de:	ff d0                	callq  *%rax
  8035e0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8035e4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035e8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8035ec:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8035f3:	00 
  8035f4:	e9 92 00 00 00       	jmpq   80368b <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8035f9:	eb 41                	jmp    80363c <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8035fb:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803600:	74 09                	je     80360b <devpipe_read+0x52>
				return i;
  803602:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803606:	e9 92 00 00 00       	jmpq   80369d <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80360b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80360f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803613:	48 89 d6             	mov    %rdx,%rsi
  803616:	48 89 c7             	mov    %rax,%rdi
  803619:	48 b8 82 34 80 00 00 	movabs $0x803482,%rax
  803620:	00 00 00 
  803623:	ff d0                	callq  *%rax
  803625:	85 c0                	test   %eax,%eax
  803627:	74 07                	je     803630 <devpipe_read+0x77>
				return 0;
  803629:	b8 00 00 00 00       	mov    $0x0,%eax
  80362e:	eb 6d                	jmp    80369d <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803630:	48 b8 60 19 80 00 00 	movabs $0x801960,%rax
  803637:	00 00 00 
  80363a:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80363c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803640:	8b 10                	mov    (%rax),%edx
  803642:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803646:	8b 40 04             	mov    0x4(%rax),%eax
  803649:	39 c2                	cmp    %eax,%edx
  80364b:	74 ae                	je     8035fb <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80364d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803651:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803655:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803659:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80365d:	8b 00                	mov    (%rax),%eax
  80365f:	99                   	cltd   
  803660:	c1 ea 1b             	shr    $0x1b,%edx
  803663:	01 d0                	add    %edx,%eax
  803665:	83 e0 1f             	and    $0x1f,%eax
  803668:	29 d0                	sub    %edx,%eax
  80366a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80366e:	48 98                	cltq   
  803670:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803675:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803677:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80367b:	8b 00                	mov    (%rax),%eax
  80367d:	8d 50 01             	lea    0x1(%rax),%edx
  803680:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803684:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803686:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80368b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80368f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803693:	0f 82 60 ff ff ff    	jb     8035f9 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803699:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80369d:	c9                   	leaveq 
  80369e:	c3                   	retq   

000000000080369f <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80369f:	55                   	push   %rbp
  8036a0:	48 89 e5             	mov    %rsp,%rbp
  8036a3:	48 83 ec 40          	sub    $0x40,%rsp
  8036a7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8036ab:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8036af:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8036b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036b7:	48 89 c7             	mov    %rax,%rdi
  8036ba:	48 b8 5e 23 80 00 00 	movabs $0x80235e,%rax
  8036c1:	00 00 00 
  8036c4:	ff d0                	callq  *%rax
  8036c6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8036ca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036ce:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8036d2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8036d9:	00 
  8036da:	e9 8e 00 00 00       	jmpq   80376d <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8036df:	eb 31                	jmp    803712 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8036e1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036e9:	48 89 d6             	mov    %rdx,%rsi
  8036ec:	48 89 c7             	mov    %rax,%rdi
  8036ef:	48 b8 82 34 80 00 00 	movabs $0x803482,%rax
  8036f6:	00 00 00 
  8036f9:	ff d0                	callq  *%rax
  8036fb:	85 c0                	test   %eax,%eax
  8036fd:	74 07                	je     803706 <devpipe_write+0x67>
				return 0;
  8036ff:	b8 00 00 00 00       	mov    $0x0,%eax
  803704:	eb 79                	jmp    80377f <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803706:	48 b8 60 19 80 00 00 	movabs $0x801960,%rax
  80370d:	00 00 00 
  803710:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803712:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803716:	8b 40 04             	mov    0x4(%rax),%eax
  803719:	48 63 d0             	movslq %eax,%rdx
  80371c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803720:	8b 00                	mov    (%rax),%eax
  803722:	48 98                	cltq   
  803724:	48 83 c0 20          	add    $0x20,%rax
  803728:	48 39 c2             	cmp    %rax,%rdx
  80372b:	73 b4                	jae    8036e1 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80372d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803731:	8b 40 04             	mov    0x4(%rax),%eax
  803734:	99                   	cltd   
  803735:	c1 ea 1b             	shr    $0x1b,%edx
  803738:	01 d0                	add    %edx,%eax
  80373a:	83 e0 1f             	and    $0x1f,%eax
  80373d:	29 d0                	sub    %edx,%eax
  80373f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803743:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803747:	48 01 ca             	add    %rcx,%rdx
  80374a:	0f b6 0a             	movzbl (%rdx),%ecx
  80374d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803751:	48 98                	cltq   
  803753:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803757:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80375b:	8b 40 04             	mov    0x4(%rax),%eax
  80375e:	8d 50 01             	lea    0x1(%rax),%edx
  803761:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803765:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803768:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80376d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803771:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803775:	0f 82 64 ff ff ff    	jb     8036df <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80377b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80377f:	c9                   	leaveq 
  803780:	c3                   	retq   

0000000000803781 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803781:	55                   	push   %rbp
  803782:	48 89 e5             	mov    %rsp,%rbp
  803785:	48 83 ec 20          	sub    $0x20,%rsp
  803789:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80378d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803791:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803795:	48 89 c7             	mov    %rax,%rdi
  803798:	48 b8 5e 23 80 00 00 	movabs $0x80235e,%rax
  80379f:	00 00 00 
  8037a2:	ff d0                	callq  *%rax
  8037a4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8037a8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037ac:	48 be 87 43 80 00 00 	movabs $0x804387,%rsi
  8037b3:	00 00 00 
  8037b6:	48 89 c7             	mov    %rax,%rdi
  8037b9:	48 b8 6f 10 80 00 00 	movabs $0x80106f,%rax
  8037c0:	00 00 00 
  8037c3:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8037c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037c9:	8b 50 04             	mov    0x4(%rax),%edx
  8037cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037d0:	8b 00                	mov    (%rax),%eax
  8037d2:	29 c2                	sub    %eax,%edx
  8037d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037d8:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8037de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037e2:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8037e9:	00 00 00 
	stat->st_dev = &devpipe;
  8037ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037f0:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  8037f7:	00 00 00 
  8037fa:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803801:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803806:	c9                   	leaveq 
  803807:	c3                   	retq   

0000000000803808 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803808:	55                   	push   %rbp
  803809:	48 89 e5             	mov    %rsp,%rbp
  80380c:	48 83 ec 10          	sub    $0x10,%rsp
  803810:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803814:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803818:	48 89 c6             	mov    %rax,%rsi
  80381b:	bf 00 00 00 00       	mov    $0x0,%edi
  803820:	48 b8 49 1a 80 00 00 	movabs $0x801a49,%rax
  803827:	00 00 00 
  80382a:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80382c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803830:	48 89 c7             	mov    %rax,%rdi
  803833:	48 b8 5e 23 80 00 00 	movabs $0x80235e,%rax
  80383a:	00 00 00 
  80383d:	ff d0                	callq  *%rax
  80383f:	48 89 c6             	mov    %rax,%rsi
  803842:	bf 00 00 00 00       	mov    $0x0,%edi
  803847:	48 b8 49 1a 80 00 00 	movabs $0x801a49,%rax
  80384e:	00 00 00 
  803851:	ff d0                	callq  *%rax
}
  803853:	c9                   	leaveq 
  803854:	c3                   	retq   

0000000000803855 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803855:	55                   	push   %rbp
  803856:	48 89 e5             	mov    %rsp,%rbp
  803859:	48 83 ec 20          	sub    $0x20,%rsp
  80385d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803860:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803863:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803866:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80386a:	be 01 00 00 00       	mov    $0x1,%esi
  80386f:	48 89 c7             	mov    %rax,%rdi
  803872:	48 b8 56 18 80 00 00 	movabs $0x801856,%rax
  803879:	00 00 00 
  80387c:	ff d0                	callq  *%rax
}
  80387e:	c9                   	leaveq 
  80387f:	c3                   	retq   

0000000000803880 <getchar>:

int
getchar(void)
{
  803880:	55                   	push   %rbp
  803881:	48 89 e5             	mov    %rsp,%rbp
  803884:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803888:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80388c:	ba 01 00 00 00       	mov    $0x1,%edx
  803891:	48 89 c6             	mov    %rax,%rsi
  803894:	bf 00 00 00 00       	mov    $0x0,%edi
  803899:	48 b8 53 28 80 00 00 	movabs $0x802853,%rax
  8038a0:	00 00 00 
  8038a3:	ff d0                	callq  *%rax
  8038a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8038a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038ac:	79 05                	jns    8038b3 <getchar+0x33>
		return r;
  8038ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038b1:	eb 14                	jmp    8038c7 <getchar+0x47>
	if (r < 1)
  8038b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038b7:	7f 07                	jg     8038c0 <getchar+0x40>
		return -E_EOF;
  8038b9:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8038be:	eb 07                	jmp    8038c7 <getchar+0x47>
	return c;
  8038c0:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8038c4:	0f b6 c0             	movzbl %al,%eax
}
  8038c7:	c9                   	leaveq 
  8038c8:	c3                   	retq   

00000000008038c9 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8038c9:	55                   	push   %rbp
  8038ca:	48 89 e5             	mov    %rsp,%rbp
  8038cd:	48 83 ec 20          	sub    $0x20,%rsp
  8038d1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8038d4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8038d8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038db:	48 89 d6             	mov    %rdx,%rsi
  8038de:	89 c7                	mov    %eax,%edi
  8038e0:	48 b8 21 24 80 00 00 	movabs $0x802421,%rax
  8038e7:	00 00 00 
  8038ea:	ff d0                	callq  *%rax
  8038ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038f3:	79 05                	jns    8038fa <iscons+0x31>
		return r;
  8038f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038f8:	eb 1a                	jmp    803914 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8038fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038fe:	8b 10                	mov    (%rax),%edx
  803900:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803907:	00 00 00 
  80390a:	8b 00                	mov    (%rax),%eax
  80390c:	39 c2                	cmp    %eax,%edx
  80390e:	0f 94 c0             	sete   %al
  803911:	0f b6 c0             	movzbl %al,%eax
}
  803914:	c9                   	leaveq 
  803915:	c3                   	retq   

0000000000803916 <opencons>:

int
opencons(void)
{
  803916:	55                   	push   %rbp
  803917:	48 89 e5             	mov    %rsp,%rbp
  80391a:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80391e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803922:	48 89 c7             	mov    %rax,%rdi
  803925:	48 b8 89 23 80 00 00 	movabs $0x802389,%rax
  80392c:	00 00 00 
  80392f:	ff d0                	callq  *%rax
  803931:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803934:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803938:	79 05                	jns    80393f <opencons+0x29>
		return r;
  80393a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80393d:	eb 5b                	jmp    80399a <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80393f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803943:	ba 07 04 00 00       	mov    $0x407,%edx
  803948:	48 89 c6             	mov    %rax,%rsi
  80394b:	bf 00 00 00 00       	mov    $0x0,%edi
  803950:	48 b8 9e 19 80 00 00 	movabs $0x80199e,%rax
  803957:	00 00 00 
  80395a:	ff d0                	callq  *%rax
  80395c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80395f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803963:	79 05                	jns    80396a <opencons+0x54>
		return r;
  803965:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803968:	eb 30                	jmp    80399a <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80396a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80396e:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803975:	00 00 00 
  803978:	8b 12                	mov    (%rdx),%edx
  80397a:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80397c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803980:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803987:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80398b:	48 89 c7             	mov    %rax,%rdi
  80398e:	48 b8 3b 23 80 00 00 	movabs $0x80233b,%rax
  803995:	00 00 00 
  803998:	ff d0                	callq  *%rax
}
  80399a:	c9                   	leaveq 
  80399b:	c3                   	retq   

000000000080399c <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80399c:	55                   	push   %rbp
  80399d:	48 89 e5             	mov    %rsp,%rbp
  8039a0:	48 83 ec 30          	sub    $0x30,%rsp
  8039a4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039a8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8039ac:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8039b0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8039b5:	75 07                	jne    8039be <devcons_read+0x22>
		return 0;
  8039b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8039bc:	eb 4b                	jmp    803a09 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8039be:	eb 0c                	jmp    8039cc <devcons_read+0x30>
		sys_yield();
  8039c0:	48 b8 60 19 80 00 00 	movabs $0x801960,%rax
  8039c7:	00 00 00 
  8039ca:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8039cc:	48 b8 a0 18 80 00 00 	movabs $0x8018a0,%rax
  8039d3:	00 00 00 
  8039d6:	ff d0                	callq  *%rax
  8039d8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039df:	74 df                	je     8039c0 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8039e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039e5:	79 05                	jns    8039ec <devcons_read+0x50>
		return c;
  8039e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039ea:	eb 1d                	jmp    803a09 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8039ec:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8039f0:	75 07                	jne    8039f9 <devcons_read+0x5d>
		return 0;
  8039f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8039f7:	eb 10                	jmp    803a09 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8039f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039fc:	89 c2                	mov    %eax,%edx
  8039fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a02:	88 10                	mov    %dl,(%rax)
	return 1;
  803a04:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803a09:	c9                   	leaveq 
  803a0a:	c3                   	retq   

0000000000803a0b <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a0b:	55                   	push   %rbp
  803a0c:	48 89 e5             	mov    %rsp,%rbp
  803a0f:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803a16:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803a1d:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803a24:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803a2b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803a32:	eb 76                	jmp    803aaa <devcons_write+0x9f>
		m = n - tot;
  803a34:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803a3b:	89 c2                	mov    %eax,%edx
  803a3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a40:	29 c2                	sub    %eax,%edx
  803a42:	89 d0                	mov    %edx,%eax
  803a44:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803a47:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a4a:	83 f8 7f             	cmp    $0x7f,%eax
  803a4d:	76 07                	jbe    803a56 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803a4f:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803a56:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a59:	48 63 d0             	movslq %eax,%rdx
  803a5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a5f:	48 63 c8             	movslq %eax,%rcx
  803a62:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803a69:	48 01 c1             	add    %rax,%rcx
  803a6c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803a73:	48 89 ce             	mov    %rcx,%rsi
  803a76:	48 89 c7             	mov    %rax,%rdi
  803a79:	48 b8 93 13 80 00 00 	movabs $0x801393,%rax
  803a80:	00 00 00 
  803a83:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803a85:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a88:	48 63 d0             	movslq %eax,%rdx
  803a8b:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803a92:	48 89 d6             	mov    %rdx,%rsi
  803a95:	48 89 c7             	mov    %rax,%rdi
  803a98:	48 b8 56 18 80 00 00 	movabs $0x801856,%rax
  803a9f:	00 00 00 
  803aa2:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803aa4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803aa7:	01 45 fc             	add    %eax,-0x4(%rbp)
  803aaa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aad:	48 98                	cltq   
  803aaf:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803ab6:	0f 82 78 ff ff ff    	jb     803a34 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803abc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803abf:	c9                   	leaveq 
  803ac0:	c3                   	retq   

0000000000803ac1 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803ac1:	55                   	push   %rbp
  803ac2:	48 89 e5             	mov    %rsp,%rbp
  803ac5:	48 83 ec 08          	sub    $0x8,%rsp
  803ac9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803acd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ad2:	c9                   	leaveq 
  803ad3:	c3                   	retq   

0000000000803ad4 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803ad4:	55                   	push   %rbp
  803ad5:	48 89 e5             	mov    %rsp,%rbp
  803ad8:	48 83 ec 10          	sub    $0x10,%rsp
  803adc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803ae0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803ae4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ae8:	48 be 93 43 80 00 00 	movabs $0x804393,%rsi
  803aef:	00 00 00 
  803af2:	48 89 c7             	mov    %rax,%rdi
  803af5:	48 b8 6f 10 80 00 00 	movabs $0x80106f,%rax
  803afc:	00 00 00 
  803aff:	ff d0                	callq  *%rax
	return 0;
  803b01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b06:	c9                   	leaveq 
  803b07:	c3                   	retq   

0000000000803b08 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803b08:	55                   	push   %rbp
  803b09:	48 89 e5             	mov    %rsp,%rbp
  803b0c:	48 83 ec 10          	sub    $0x10,%rsp
  803b10:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  803b14:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803b1b:	00 00 00 
  803b1e:	48 8b 00             	mov    (%rax),%rax
  803b21:	48 85 c0             	test   %rax,%rax
  803b24:	75 64                	jne    803b8a <set_pgfault_handler+0x82>
		// First time through!
		// LAB 4: Your code here.
		//envid_t eid = sys_getenvid();
		if(sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) 
  803b26:	ba 07 00 00 00       	mov    $0x7,%edx
  803b2b:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803b30:	bf 00 00 00 00       	mov    $0x0,%edi
  803b35:	48 b8 9e 19 80 00 00 	movabs $0x80199e,%rax
  803b3c:	00 00 00 
  803b3f:	ff d0                	callq  *%rax
  803b41:	85 c0                	test   %eax,%eax
  803b43:	74 2a                	je     803b6f <set_pgfault_handler+0x67>
			panic("Allocation of space for UXSTACK failed\n");
  803b45:	48 ba a0 43 80 00 00 	movabs $0x8043a0,%rdx
  803b4c:	00 00 00 
  803b4f:	be 22 00 00 00       	mov    $0x22,%esi
  803b54:	48 bf c8 43 80 00 00 	movabs $0x8043c8,%rdi
  803b5b:	00 00 00 
  803b5e:	b8 00 00 00 00       	mov    $0x0,%eax
  803b63:	48 b9 81 02 80 00 00 	movabs $0x800281,%rcx
  803b6a:	00 00 00 
  803b6d:	ff d1                	callq  *%rcx
		else
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  803b6f:	48 be 9d 3b 80 00 00 	movabs $0x803b9d,%rsi
  803b76:	00 00 00 
  803b79:	bf 00 00 00 00       	mov    $0x0,%edi
  803b7e:	48 b8 28 1b 80 00 00 	movabs $0x801b28,%rax
  803b85:	00 00 00 
  803b88:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803b8a:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803b91:	00 00 00 
  803b94:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803b98:	48 89 10             	mov    %rdx,(%rax)
}
  803b9b:	c9                   	leaveq 
  803b9c:	c3                   	retq   

0000000000803b9d <_pgfault_upcall>:
// Call the C page fault handler.
// function argument: pointer to UTF



movq  %rsp,%rdi                // passing the function argument in rdi
  803b9d:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  803ba0:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803ba7:	00 00 00 
call *%rax
  803baa:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
mov 152(%rsp), %r8
  803bac:	4c 8b 84 24 98 00 00 	mov    0x98(%rsp),%r8
  803bb3:	00 
mov 136(%rsp), %r9
  803bb4:	4c 8b 8c 24 88 00 00 	mov    0x88(%rsp),%r9
  803bbb:	00 
sub $8, %r8
  803bbc:	49 83 e8 08          	sub    $0x8,%r8
mov %r9, (%r8)
  803bc0:	4d 89 08             	mov    %r9,(%r8)
mov %r8, 152(%rsp)
  803bc3:	4c 89 84 24 98 00 00 	mov    %r8,0x98(%rsp)
  803bca:	00 
add $16, %rsp
  803bcb:	48 83 c4 10          	add    $0x10,%rsp

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
POPA_
  803bcf:	4c 8b 3c 24          	mov    (%rsp),%r15
  803bd3:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803bd8:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803bdd:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803be2:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803be7:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803bec:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803bf1:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803bf6:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803bfb:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803c00:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803c05:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803c0a:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803c0f:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803c14:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803c19:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
		// LAB 4: Your code here.
add $8, %rsp
  803c1d:	48 83 c4 08          	add    $0x8,%rsp
popf
  803c21:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
mov (%rsp), %rsp
  803c22:	48 8b 24 24          	mov    (%rsp),%rsp
    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
ret
  803c26:	c3                   	retq   

0000000000803c27 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803c27:	55                   	push   %rbp
  803c28:	48 89 e5             	mov    %rsp,%rbp
  803c2b:	48 83 ec 18          	sub    $0x18,%rsp
  803c2f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803c33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c37:	48 c1 e8 15          	shr    $0x15,%rax
  803c3b:	48 89 c2             	mov    %rax,%rdx
  803c3e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803c45:	01 00 00 
  803c48:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c4c:	83 e0 01             	and    $0x1,%eax
  803c4f:	48 85 c0             	test   %rax,%rax
  803c52:	75 07                	jne    803c5b <pageref+0x34>
		return 0;
  803c54:	b8 00 00 00 00       	mov    $0x0,%eax
  803c59:	eb 53                	jmp    803cae <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803c5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c5f:	48 c1 e8 0c          	shr    $0xc,%rax
  803c63:	48 89 c2             	mov    %rax,%rdx
  803c66:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803c6d:	01 00 00 
  803c70:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c74:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803c78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c7c:	83 e0 01             	and    $0x1,%eax
  803c7f:	48 85 c0             	test   %rax,%rax
  803c82:	75 07                	jne    803c8b <pageref+0x64>
		return 0;
  803c84:	b8 00 00 00 00       	mov    $0x0,%eax
  803c89:	eb 23                	jmp    803cae <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803c8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c8f:	48 c1 e8 0c          	shr    $0xc,%rax
  803c93:	48 89 c2             	mov    %rax,%rdx
  803c96:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803c9d:	00 00 00 
  803ca0:	48 c1 e2 04          	shl    $0x4,%rdx
  803ca4:	48 01 d0             	add    %rdx,%rax
  803ca7:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803cab:	0f b7 c0             	movzwl %ax,%eax
}
  803cae:	c9                   	leaveq 
  803caf:	c3                   	retq   
