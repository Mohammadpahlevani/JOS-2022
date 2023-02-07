
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
  80005c:	48 b8 e6 21 80 00 00 	movabs $0x8021e6,%rax
  800063:	00 00 00 
  800066:	ff d0                	callq  *%rax
  800068:	89 45 fc             	mov    %eax,-0x4(%rbp)
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  80006b:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  800072:	00 00 00 
  800075:	48 8b 00             	mov    (%rax),%rax
  800078:	8b 80 dc 00 00 00    	mov    0xdc(%rax),%eax
  80007e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800081:	89 c6                	mov    %eax,%esi
  800083:	48 bf 00 25 80 00 00 	movabs $0x802500,%rdi
  80008a:	00 00 00 
  80008d:	b8 00 00 00 00       	mov    $0x0,%eax
  800092:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  800099:	00 00 00 
  80009c:	ff d1                	callq  *%rcx

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  80009e:	48 b8 69 1f 80 00 00 	movabs $0x801f69,%rax
  8000a5:	00 00 00 
  8000a8:	ff d0                	callq  *%rax
  8000aa:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000ad:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000b1:	79 30                	jns    8000e3 <primeproc+0xa0>
		panic("fork: %e", id);
  8000b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000b6:	89 c1                	mov    %eax,%ecx
  8000b8:	48 ba 0c 25 80 00 00 	movabs $0x80250c,%rdx
  8000bf:	00 00 00 
  8000c2:	be 1a 00 00 00       	mov    $0x1a,%esi
  8000c7:	48 bf 15 25 80 00 00 	movabs $0x802515,%rdi
  8000ce:	00 00 00 
  8000d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d6:	49 b8 89 02 80 00 00 	movabs $0x800289,%r8
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
  8000ff:	48 b8 e6 21 80 00 00 	movabs $0x8021e6,%rax
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
  80012d:	48 b8 a7 22 80 00 00 	movabs $0x8022a7,%rax
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
  80014c:	48 b8 69 1f 80 00 00 	movabs $0x801f69,%rax
  800153:	00 00 00 
  800156:	ff d0                	callq  *%rax
  800158:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80015b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80015f:	79 30                	jns    800191 <umain+0x54>
		panic("fork: %e", id);
  800161:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800164:	89 c1                	mov    %eax,%ecx
  800166:	48 ba 0c 25 80 00 00 	movabs $0x80250c,%rdx
  80016d:	00 00 00 
  800170:	be 2d 00 00 00       	mov    $0x2d,%esi
  800175:	48 bf 15 25 80 00 00 	movabs $0x802515,%rdi
  80017c:	00 00 00 
  80017f:	b8 00 00 00 00       	mov    $0x0,%eax
  800184:	49 b8 89 02 80 00 00 	movabs $0x800289,%r8
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
  8001bc:	48 b8 a7 22 80 00 00 	movabs $0x8022a7,%rax
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
  8001d2:	48 83 ec 20          	sub    $0x20,%rsp
  8001d6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8001d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8001dd:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  8001e4:	00 00 00 
  8001e7:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	envid_t id = sys_getenvid();
  8001ee:	48 b8 2a 19 80 00 00 	movabs $0x80192a,%rax
  8001f5:	00 00 00 
  8001f8:	ff d0                	callq  *%rax
  8001fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
        id = ENVX(id);
  8001fd:	81 65 fc ff 03 00 00 	andl   $0x3ff,-0x4(%rbp)
	thisenv = &envs[id];
  800204:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800207:	48 63 d0             	movslq %eax,%rdx
  80020a:	48 89 d0             	mov    %rdx,%rax
  80020d:	48 c1 e0 03          	shl    $0x3,%rax
  800211:	48 01 d0             	add    %rdx,%rax
  800214:	48 c1 e0 05          	shl    $0x5,%rax
  800218:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80021f:	00 00 00 
  800222:	48 01 c2             	add    %rax,%rdx
  800225:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  80022c:	00 00 00 
  80022f:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800232:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800236:	7e 14                	jle    80024c <libmain+0x7e>
		binaryname = argv[0];
  800238:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80023c:	48 8b 10             	mov    (%rax),%rdx
  80023f:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  800246:	00 00 00 
  800249:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80024c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800250:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800253:	48 89 d6             	mov    %rdx,%rsi
  800256:	89 c7                	mov    %eax,%edi
  800258:	48 b8 3d 01 80 00 00 	movabs $0x80013d,%rax
  80025f:	00 00 00 
  800262:	ff d0                	callq  *%rax
	
	//cprintf("\noutside\n");
	// exit gracefully
	exit();
  800264:	48 b8 72 02 80 00 00 	movabs $0x800272,%rax
  80026b:	00 00 00 
  80026e:	ff d0                	callq  *%rax
}
  800270:	c9                   	leaveq 
  800271:	c3                   	retq   

0000000000800272 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800272:	55                   	push   %rbp
  800273:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  800276:	bf 00 00 00 00       	mov    $0x0,%edi
  80027b:	48 b8 e6 18 80 00 00 	movabs $0x8018e6,%rax
  800282:	00 00 00 
  800285:	ff d0                	callq  *%rax
}
  800287:	5d                   	pop    %rbp
  800288:	c3                   	retq   

0000000000800289 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800289:	55                   	push   %rbp
  80028a:	48 89 e5             	mov    %rsp,%rbp
  80028d:	53                   	push   %rbx
  80028e:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800295:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80029c:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8002a2:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8002a9:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8002b0:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8002b7:	84 c0                	test   %al,%al
  8002b9:	74 23                	je     8002de <_panic+0x55>
  8002bb:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8002c2:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002c6:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002ca:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002ce:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002d2:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002d6:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002da:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002de:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002e5:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002ec:	00 00 00 
  8002ef:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002f6:	00 00 00 
  8002f9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002fd:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800304:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80030b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800312:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  800319:	00 00 00 
  80031c:	48 8b 18             	mov    (%rax),%rbx
  80031f:	48 b8 2a 19 80 00 00 	movabs $0x80192a,%rax
  800326:	00 00 00 
  800329:	ff d0                	callq  *%rax
  80032b:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800331:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800338:	41 89 c8             	mov    %ecx,%r8d
  80033b:	48 89 d1             	mov    %rdx,%rcx
  80033e:	48 89 da             	mov    %rbx,%rdx
  800341:	89 c6                	mov    %eax,%esi
  800343:	48 bf 30 25 80 00 00 	movabs $0x802530,%rdi
  80034a:	00 00 00 
  80034d:	b8 00 00 00 00       	mov    $0x0,%eax
  800352:	49 b9 c2 04 80 00 00 	movabs $0x8004c2,%r9
  800359:	00 00 00 
  80035c:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80035f:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800366:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80036d:	48 89 d6             	mov    %rdx,%rsi
  800370:	48 89 c7             	mov    %rax,%rdi
  800373:	48 b8 16 04 80 00 00 	movabs $0x800416,%rax
  80037a:	00 00 00 
  80037d:	ff d0                	callq  *%rax
	cprintf("\n");
  80037f:	48 bf 53 25 80 00 00 	movabs $0x802553,%rdi
  800386:	00 00 00 
  800389:	b8 00 00 00 00       	mov    $0x0,%eax
  80038e:	48 ba c2 04 80 00 00 	movabs $0x8004c2,%rdx
  800395:	00 00 00 
  800398:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80039a:	cc                   	int3   
  80039b:	eb fd                	jmp    80039a <_panic+0x111>

000000000080039d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80039d:	55                   	push   %rbp
  80039e:	48 89 e5             	mov    %rsp,%rbp
  8003a1:	48 83 ec 10          	sub    $0x10,%rsp
  8003a5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003a8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  8003ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003b0:	8b 00                	mov    (%rax),%eax
  8003b2:	8d 48 01             	lea    0x1(%rax),%ecx
  8003b5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003b9:	89 0a                	mov    %ecx,(%rdx)
  8003bb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003be:	89 d1                	mov    %edx,%ecx
  8003c0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003c4:	48 98                	cltq   
  8003c6:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  8003ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ce:	8b 00                	mov    (%rax),%eax
  8003d0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003d5:	75 2c                	jne    800403 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  8003d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003db:	8b 00                	mov    (%rax),%eax
  8003dd:	48 98                	cltq   
  8003df:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003e3:	48 83 c2 08          	add    $0x8,%rdx
  8003e7:	48 89 c6             	mov    %rax,%rsi
  8003ea:	48 89 d7             	mov    %rdx,%rdi
  8003ed:	48 b8 5e 18 80 00 00 	movabs $0x80185e,%rax
  8003f4:	00 00 00 
  8003f7:	ff d0                	callq  *%rax
		b->idx = 0;
  8003f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003fd:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800403:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800407:	8b 40 04             	mov    0x4(%rax),%eax
  80040a:	8d 50 01             	lea    0x1(%rax),%edx
  80040d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800411:	89 50 04             	mov    %edx,0x4(%rax)
}
  800414:	c9                   	leaveq 
  800415:	c3                   	retq   

0000000000800416 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800416:	55                   	push   %rbp
  800417:	48 89 e5             	mov    %rsp,%rbp
  80041a:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800421:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800428:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  80042f:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800436:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80043d:	48 8b 0a             	mov    (%rdx),%rcx
  800440:	48 89 08             	mov    %rcx,(%rax)
  800443:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800447:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80044b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80044f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800453:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80045a:	00 00 00 
	b.cnt = 0;
  80045d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800464:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800467:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80046e:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800475:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80047c:	48 89 c6             	mov    %rax,%rsi
  80047f:	48 bf 9d 03 80 00 00 	movabs $0x80039d,%rdi
  800486:	00 00 00 
  800489:	48 b8 75 08 80 00 00 	movabs $0x800875,%rax
  800490:	00 00 00 
  800493:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800495:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80049b:	48 98                	cltq   
  80049d:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8004a4:	48 83 c2 08          	add    $0x8,%rdx
  8004a8:	48 89 c6             	mov    %rax,%rsi
  8004ab:	48 89 d7             	mov    %rdx,%rdi
  8004ae:	48 b8 5e 18 80 00 00 	movabs $0x80185e,%rax
  8004b5:	00 00 00 
  8004b8:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  8004ba:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004c0:	c9                   	leaveq 
  8004c1:	c3                   	retq   

00000000008004c2 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004c2:	55                   	push   %rbp
  8004c3:	48 89 e5             	mov    %rsp,%rbp
  8004c6:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004cd:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004d4:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004db:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004e2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004e9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004f0:	84 c0                	test   %al,%al
  8004f2:	74 20                	je     800514 <cprintf+0x52>
  8004f4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004f8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004fc:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800500:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800504:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800508:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80050c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800510:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800514:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  80051b:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800522:	00 00 00 
  800525:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80052c:	00 00 00 
  80052f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800533:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80053a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800541:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800548:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80054f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800556:	48 8b 0a             	mov    (%rdx),%rcx
  800559:	48 89 08             	mov    %rcx,(%rax)
  80055c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800560:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800564:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800568:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  80056c:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800573:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80057a:	48 89 d6             	mov    %rdx,%rsi
  80057d:	48 89 c7             	mov    %rax,%rdi
  800580:	48 b8 16 04 80 00 00 	movabs $0x800416,%rax
  800587:	00 00 00 
  80058a:	ff d0                	callq  *%rax
  80058c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800592:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800598:	c9                   	leaveq 
  800599:	c3                   	retq   

000000000080059a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80059a:	55                   	push   %rbp
  80059b:	48 89 e5             	mov    %rsp,%rbp
  80059e:	53                   	push   %rbx
  80059f:	48 83 ec 38          	sub    $0x38,%rsp
  8005a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005a7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8005ab:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8005af:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8005b2:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8005b6:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005ba:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8005bd:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8005c1:	77 3b                	ja     8005fe <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005c3:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8005c6:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005ca:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8005cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d6:	48 f7 f3             	div    %rbx
  8005d9:	48 89 c2             	mov    %rax,%rdx
  8005dc:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005df:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005e2:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ea:	41 89 f9             	mov    %edi,%r9d
  8005ed:	48 89 c7             	mov    %rax,%rdi
  8005f0:	48 b8 9a 05 80 00 00 	movabs $0x80059a,%rax
  8005f7:	00 00 00 
  8005fa:	ff d0                	callq  *%rax
  8005fc:	eb 1e                	jmp    80061c <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005fe:	eb 12                	jmp    800612 <printnum+0x78>
			putch(padc, putdat);
  800600:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800604:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800607:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80060b:	48 89 ce             	mov    %rcx,%rsi
  80060e:	89 d7                	mov    %edx,%edi
  800610:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800612:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800616:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80061a:	7f e4                	jg     800600 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80061c:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80061f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800623:	ba 00 00 00 00       	mov    $0x0,%edx
  800628:	48 f7 f1             	div    %rcx
  80062b:	48 89 d0             	mov    %rdx,%rax
  80062e:	48 ba 50 26 80 00 00 	movabs $0x802650,%rdx
  800635:	00 00 00 
  800638:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80063c:	0f be d0             	movsbl %al,%edx
  80063f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800643:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800647:	48 89 ce             	mov    %rcx,%rsi
  80064a:	89 d7                	mov    %edx,%edi
  80064c:	ff d0                	callq  *%rax
}
  80064e:	48 83 c4 38          	add    $0x38,%rsp
  800652:	5b                   	pop    %rbx
  800653:	5d                   	pop    %rbp
  800654:	c3                   	retq   

0000000000800655 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800655:	55                   	push   %rbp
  800656:	48 89 e5             	mov    %rsp,%rbp
  800659:	48 83 ec 1c          	sub    $0x1c,%rsp
  80065d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800661:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800664:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800668:	7e 52                	jle    8006bc <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80066a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066e:	8b 00                	mov    (%rax),%eax
  800670:	83 f8 30             	cmp    $0x30,%eax
  800673:	73 24                	jae    800699 <getuint+0x44>
  800675:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800679:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80067d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800681:	8b 00                	mov    (%rax),%eax
  800683:	89 c0                	mov    %eax,%eax
  800685:	48 01 d0             	add    %rdx,%rax
  800688:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068c:	8b 12                	mov    (%rdx),%edx
  80068e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800691:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800695:	89 0a                	mov    %ecx,(%rdx)
  800697:	eb 17                	jmp    8006b0 <getuint+0x5b>
  800699:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006a1:	48 89 d0             	mov    %rdx,%rax
  8006a4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ac:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006b0:	48 8b 00             	mov    (%rax),%rax
  8006b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006b7:	e9 a3 00 00 00       	jmpq   80075f <getuint+0x10a>
	else if (lflag)
  8006bc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006c0:	74 4f                	je     800711 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8006c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c6:	8b 00                	mov    (%rax),%eax
  8006c8:	83 f8 30             	cmp    $0x30,%eax
  8006cb:	73 24                	jae    8006f1 <getuint+0x9c>
  8006cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d9:	8b 00                	mov    (%rax),%eax
  8006db:	89 c0                	mov    %eax,%eax
  8006dd:	48 01 d0             	add    %rdx,%rax
  8006e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e4:	8b 12                	mov    (%rdx),%edx
  8006e6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006e9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ed:	89 0a                	mov    %ecx,(%rdx)
  8006ef:	eb 17                	jmp    800708 <getuint+0xb3>
  8006f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006f9:	48 89 d0             	mov    %rdx,%rax
  8006fc:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800700:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800704:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800708:	48 8b 00             	mov    (%rax),%rax
  80070b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80070f:	eb 4e                	jmp    80075f <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800711:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800715:	8b 00                	mov    (%rax),%eax
  800717:	83 f8 30             	cmp    $0x30,%eax
  80071a:	73 24                	jae    800740 <getuint+0xeb>
  80071c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800720:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800724:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800728:	8b 00                	mov    (%rax),%eax
  80072a:	89 c0                	mov    %eax,%eax
  80072c:	48 01 d0             	add    %rdx,%rax
  80072f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800733:	8b 12                	mov    (%rdx),%edx
  800735:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800738:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80073c:	89 0a                	mov    %ecx,(%rdx)
  80073e:	eb 17                	jmp    800757 <getuint+0x102>
  800740:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800744:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800748:	48 89 d0             	mov    %rdx,%rax
  80074b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80074f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800753:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800757:	8b 00                	mov    (%rax),%eax
  800759:	89 c0                	mov    %eax,%eax
  80075b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80075f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800763:	c9                   	leaveq 
  800764:	c3                   	retq   

0000000000800765 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800765:	55                   	push   %rbp
  800766:	48 89 e5             	mov    %rsp,%rbp
  800769:	48 83 ec 1c          	sub    $0x1c,%rsp
  80076d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800771:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800774:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800778:	7e 52                	jle    8007cc <getint+0x67>
		x=va_arg(*ap, long long);
  80077a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077e:	8b 00                	mov    (%rax),%eax
  800780:	83 f8 30             	cmp    $0x30,%eax
  800783:	73 24                	jae    8007a9 <getint+0x44>
  800785:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800789:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80078d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800791:	8b 00                	mov    (%rax),%eax
  800793:	89 c0                	mov    %eax,%eax
  800795:	48 01 d0             	add    %rdx,%rax
  800798:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80079c:	8b 12                	mov    (%rdx),%edx
  80079e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007a1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a5:	89 0a                	mov    %ecx,(%rdx)
  8007a7:	eb 17                	jmp    8007c0 <getint+0x5b>
  8007a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ad:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007b1:	48 89 d0             	mov    %rdx,%rax
  8007b4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007b8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007bc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007c0:	48 8b 00             	mov    (%rax),%rax
  8007c3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007c7:	e9 a3 00 00 00       	jmpq   80086f <getint+0x10a>
	else if (lflag)
  8007cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007d0:	74 4f                	je     800821 <getint+0xbc>
		x=va_arg(*ap, long);
  8007d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d6:	8b 00                	mov    (%rax),%eax
  8007d8:	83 f8 30             	cmp    $0x30,%eax
  8007db:	73 24                	jae    800801 <getint+0x9c>
  8007dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e9:	8b 00                	mov    (%rax),%eax
  8007eb:	89 c0                	mov    %eax,%eax
  8007ed:	48 01 d0             	add    %rdx,%rax
  8007f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f4:	8b 12                	mov    (%rdx),%edx
  8007f6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007f9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007fd:	89 0a                	mov    %ecx,(%rdx)
  8007ff:	eb 17                	jmp    800818 <getint+0xb3>
  800801:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800805:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800809:	48 89 d0             	mov    %rdx,%rax
  80080c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800810:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800814:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800818:	48 8b 00             	mov    (%rax),%rax
  80081b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80081f:	eb 4e                	jmp    80086f <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800821:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800825:	8b 00                	mov    (%rax),%eax
  800827:	83 f8 30             	cmp    $0x30,%eax
  80082a:	73 24                	jae    800850 <getint+0xeb>
  80082c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800830:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800834:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800838:	8b 00                	mov    (%rax),%eax
  80083a:	89 c0                	mov    %eax,%eax
  80083c:	48 01 d0             	add    %rdx,%rax
  80083f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800843:	8b 12                	mov    (%rdx),%edx
  800845:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800848:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80084c:	89 0a                	mov    %ecx,(%rdx)
  80084e:	eb 17                	jmp    800867 <getint+0x102>
  800850:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800854:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800858:	48 89 d0             	mov    %rdx,%rax
  80085b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80085f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800863:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800867:	8b 00                	mov    (%rax),%eax
  800869:	48 98                	cltq   
  80086b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80086f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800873:	c9                   	leaveq 
  800874:	c3                   	retq   

0000000000800875 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800875:	55                   	push   %rbp
  800876:	48 89 e5             	mov    %rsp,%rbp
  800879:	41 54                	push   %r12
  80087b:	53                   	push   %rbx
  80087c:	48 83 ec 60          	sub    $0x60,%rsp
  800880:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800884:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800888:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80088c:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800890:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800894:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800898:	48 8b 0a             	mov    (%rdx),%rcx
  80089b:	48 89 08             	mov    %rcx,(%rax)
  80089e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008a2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008a6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008aa:	48 89 50 10          	mov    %rdx,0x10(%rax)
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008ae:	eb 17                	jmp    8008c7 <vprintfmt+0x52>
			if (ch == '\0')
  8008b0:	85 db                	test   %ebx,%ebx
  8008b2:	0f 84 cc 04 00 00    	je     800d84 <vprintfmt+0x50f>
                }
#endif

			  return;
			}
			putch(ch, putdat);
  8008b8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008bc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008c0:	48 89 d6             	mov    %rdx,%rsi
  8008c3:	89 df                	mov    %ebx,%edi
  8008c5:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008c7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008cb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008cf:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008d3:	0f b6 00             	movzbl (%rax),%eax
  8008d6:	0f b6 d8             	movzbl %al,%ebx
  8008d9:	83 fb 25             	cmp    $0x25,%ebx
  8008dc:	75 d2                	jne    8008b0 <vprintfmt+0x3b>
			  return;
			}
			putch(ch, putdat);
		}
		// Process a %-escape sequence
		padc = ' ';
  8008de:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008e2:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008e9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008f0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008f7:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008fe:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800902:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800906:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80090a:	0f b6 00             	movzbl (%rax),%eax
  80090d:	0f b6 d8             	movzbl %al,%ebx
  800910:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800913:	83 f8 55             	cmp    $0x55,%eax
  800916:	0f 87 34 04 00 00    	ja     800d50 <vprintfmt+0x4db>
  80091c:	89 c0                	mov    %eax,%eax
  80091e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800925:	00 
  800926:	48 b8 78 26 80 00 00 	movabs $0x802678,%rax
  80092d:	00 00 00 
  800930:	48 01 d0             	add    %rdx,%rax
  800933:	48 8b 00             	mov    (%rax),%rax
  800936:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800938:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80093c:	eb c0                	jmp    8008fe <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80093e:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800942:	eb ba                	jmp    8008fe <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800944:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80094b:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80094e:	89 d0                	mov    %edx,%eax
  800950:	c1 e0 02             	shl    $0x2,%eax
  800953:	01 d0                	add    %edx,%eax
  800955:	01 c0                	add    %eax,%eax
  800957:	01 d8                	add    %ebx,%eax
  800959:	83 e8 30             	sub    $0x30,%eax
  80095c:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80095f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800963:	0f b6 00             	movzbl (%rax),%eax
  800966:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800969:	83 fb 2f             	cmp    $0x2f,%ebx
  80096c:	7e 0c                	jle    80097a <vprintfmt+0x105>
  80096e:	83 fb 39             	cmp    $0x39,%ebx
  800971:	7f 07                	jg     80097a <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800973:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800978:	eb d1                	jmp    80094b <vprintfmt+0xd6>
			goto process_precision;
  80097a:	eb 58                	jmp    8009d4 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80097c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80097f:	83 f8 30             	cmp    $0x30,%eax
  800982:	73 17                	jae    80099b <vprintfmt+0x126>
  800984:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800988:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80098b:	89 c0                	mov    %eax,%eax
  80098d:	48 01 d0             	add    %rdx,%rax
  800990:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800993:	83 c2 08             	add    $0x8,%edx
  800996:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800999:	eb 0f                	jmp    8009aa <vprintfmt+0x135>
  80099b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80099f:	48 89 d0             	mov    %rdx,%rax
  8009a2:	48 83 c2 08          	add    $0x8,%rdx
  8009a6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009aa:	8b 00                	mov    (%rax),%eax
  8009ac:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8009af:	eb 23                	jmp    8009d4 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8009b1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009b5:	79 0c                	jns    8009c3 <vprintfmt+0x14e>
				width = 0;
  8009b7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009be:	e9 3b ff ff ff       	jmpq   8008fe <vprintfmt+0x89>
  8009c3:	e9 36 ff ff ff       	jmpq   8008fe <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009c8:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009cf:	e9 2a ff ff ff       	jmpq   8008fe <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009d4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009d8:	79 12                	jns    8009ec <vprintfmt+0x177>
				width = precision, precision = -1;
  8009da:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009dd:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009e0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009e7:	e9 12 ff ff ff       	jmpq   8008fe <vprintfmt+0x89>
  8009ec:	e9 0d ff ff ff       	jmpq   8008fe <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009f1:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009f5:	e9 04 ff ff ff       	jmpq   8008fe <vprintfmt+0x89>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			putch(va_arg(aq, int), putdat);
  8009fa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009fd:	83 f8 30             	cmp    $0x30,%eax
  800a00:	73 17                	jae    800a19 <vprintfmt+0x1a4>
  800a02:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a06:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a09:	89 c0                	mov    %eax,%eax
  800a0b:	48 01 d0             	add    %rdx,%rax
  800a0e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a11:	83 c2 08             	add    $0x8,%edx
  800a14:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a17:	eb 0f                	jmp    800a28 <vprintfmt+0x1b3>
  800a19:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a1d:	48 89 d0             	mov    %rdx,%rax
  800a20:	48 83 c2 08          	add    $0x8,%rdx
  800a24:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a28:	8b 10                	mov    (%rax),%edx
  800a2a:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a2e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a32:	48 89 ce             	mov    %rcx,%rsi
  800a35:	89 d7                	mov    %edx,%edi
  800a37:	ff d0                	callq  *%rax
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  800a39:	e9 40 03 00 00       	jmpq   800d7e <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800a3e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a41:	83 f8 30             	cmp    $0x30,%eax
  800a44:	73 17                	jae    800a5d <vprintfmt+0x1e8>
  800a46:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a4a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a4d:	89 c0                	mov    %eax,%eax
  800a4f:	48 01 d0             	add    %rdx,%rax
  800a52:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a55:	83 c2 08             	add    $0x8,%edx
  800a58:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a5b:	eb 0f                	jmp    800a6c <vprintfmt+0x1f7>
  800a5d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a61:	48 89 d0             	mov    %rdx,%rax
  800a64:	48 83 c2 08          	add    $0x8,%rdx
  800a68:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a6c:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a6e:	85 db                	test   %ebx,%ebx
  800a70:	79 02                	jns    800a74 <vprintfmt+0x1ff>
				err = -err;
  800a72:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a74:	83 fb 09             	cmp    $0x9,%ebx
  800a77:	7f 16                	jg     800a8f <vprintfmt+0x21a>
  800a79:	48 b8 00 26 80 00 00 	movabs $0x802600,%rax
  800a80:	00 00 00 
  800a83:	48 63 d3             	movslq %ebx,%rdx
  800a86:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a8a:	4d 85 e4             	test   %r12,%r12
  800a8d:	75 2e                	jne    800abd <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a8f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a93:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a97:	89 d9                	mov    %ebx,%ecx
  800a99:	48 ba 61 26 80 00 00 	movabs $0x802661,%rdx
  800aa0:	00 00 00 
  800aa3:	48 89 c7             	mov    %rax,%rdi
  800aa6:	b8 00 00 00 00       	mov    $0x0,%eax
  800aab:	49 b8 8d 0d 80 00 00 	movabs $0x800d8d,%r8
  800ab2:	00 00 00 
  800ab5:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ab8:	e9 c1 02 00 00       	jmpq   800d7e <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800abd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ac1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ac5:	4c 89 e1             	mov    %r12,%rcx
  800ac8:	48 ba 6a 26 80 00 00 	movabs $0x80266a,%rdx
  800acf:	00 00 00 
  800ad2:	48 89 c7             	mov    %rax,%rdi
  800ad5:	b8 00 00 00 00       	mov    $0x0,%eax
  800ada:	49 b8 8d 0d 80 00 00 	movabs $0x800d8d,%r8
  800ae1:	00 00 00 
  800ae4:	41 ff d0             	callq  *%r8
			break;
  800ae7:	e9 92 02 00 00       	jmpq   800d7e <vprintfmt+0x509>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
  800aec:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aef:	83 f8 30             	cmp    $0x30,%eax
  800af2:	73 17                	jae    800b0b <vprintfmt+0x296>
  800af4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800af8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800afb:	89 c0                	mov    %eax,%eax
  800afd:	48 01 d0             	add    %rdx,%rax
  800b00:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b03:	83 c2 08             	add    $0x8,%edx
  800b06:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b09:	eb 0f                	jmp    800b1a <vprintfmt+0x2a5>
  800b0b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b0f:	48 89 d0             	mov    %rdx,%rax
  800b12:	48 83 c2 08          	add    $0x8,%rdx
  800b16:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b1a:	4c 8b 20             	mov    (%rax),%r12
  800b1d:	4d 85 e4             	test   %r12,%r12
  800b20:	75 0a                	jne    800b2c <vprintfmt+0x2b7>
				p = "(null)";
  800b22:	49 bc 6d 26 80 00 00 	movabs $0x80266d,%r12
  800b29:	00 00 00 
			if (width > 0 && padc != '-')
  800b2c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b30:	7e 3f                	jle    800b71 <vprintfmt+0x2fc>
  800b32:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b36:	74 39                	je     800b71 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b38:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b3b:	48 98                	cltq   
  800b3d:	48 89 c6             	mov    %rax,%rsi
  800b40:	4c 89 e7             	mov    %r12,%rdi
  800b43:	48 b8 39 10 80 00 00 	movabs $0x801039,%rax
  800b4a:	00 00 00 
  800b4d:	ff d0                	callq  *%rax
  800b4f:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b52:	eb 17                	jmp    800b6b <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b54:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b58:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b5c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b60:	48 89 ce             	mov    %rcx,%rsi
  800b63:	89 d7                	mov    %edx,%edi
  800b65:	ff d0                	callq  *%rax
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b67:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b6b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b6f:	7f e3                	jg     800b54 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b71:	eb 37                	jmp    800baa <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b73:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b77:	74 1e                	je     800b97 <vprintfmt+0x322>
  800b79:	83 fb 1f             	cmp    $0x1f,%ebx
  800b7c:	7e 05                	jle    800b83 <vprintfmt+0x30e>
  800b7e:	83 fb 7e             	cmp    $0x7e,%ebx
  800b81:	7e 14                	jle    800b97 <vprintfmt+0x322>
					putch('?', putdat);
  800b83:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b87:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b8b:	48 89 d6             	mov    %rdx,%rsi
  800b8e:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b93:	ff d0                	callq  *%rax
  800b95:	eb 0f                	jmp    800ba6 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b97:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b9b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b9f:	48 89 d6             	mov    %rdx,%rsi
  800ba2:	89 df                	mov    %ebx,%edi
  800ba4:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ba6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800baa:	4c 89 e0             	mov    %r12,%rax
  800bad:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800bb1:	0f b6 00             	movzbl (%rax),%eax
  800bb4:	0f be d8             	movsbl %al,%ebx
  800bb7:	85 db                	test   %ebx,%ebx
  800bb9:	74 10                	je     800bcb <vprintfmt+0x356>
  800bbb:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bbf:	78 b2                	js     800b73 <vprintfmt+0x2fe>
  800bc1:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800bc5:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bc9:	79 a8                	jns    800b73 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bcb:	eb 16                	jmp    800be3 <vprintfmt+0x36e>
				putch(' ', putdat);
  800bcd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bd1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bd5:	48 89 d6             	mov    %rdx,%rsi
  800bd8:	bf 20 00 00 00       	mov    $0x20,%edi
  800bdd:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bdf:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800be3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800be7:	7f e4                	jg     800bcd <vprintfmt+0x358>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  800be9:	e9 90 01 00 00       	jmpq   800d7e <vprintfmt+0x509>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getint(&aq, 3);
  800bee:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bf2:	be 03 00 00 00       	mov    $0x3,%esi
  800bf7:	48 89 c7             	mov    %rax,%rdi
  800bfa:	48 b8 65 07 80 00 00 	movabs $0x800765,%rax
  800c01:	00 00 00 
  800c04:	ff d0                	callq  *%rax
  800c06:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c0e:	48 85 c0             	test   %rax,%rax
  800c11:	79 1d                	jns    800c30 <vprintfmt+0x3bb>
				putch('-', putdat);
  800c13:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c17:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c1b:	48 89 d6             	mov    %rdx,%rsi
  800c1e:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c23:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c29:	48 f7 d8             	neg    %rax
  800c2c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c30:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c37:	e9 d5 00 00 00       	jmpq   800d11 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			
			num = getuint(&aq, 3);
  800c3c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c40:	be 03 00 00 00       	mov    $0x3,%esi
  800c45:	48 89 c7             	mov    %rax,%rdi
  800c48:	48 b8 55 06 80 00 00 	movabs $0x800655,%rax
  800c4f:	00 00 00 
  800c52:	ff d0                	callq  *%rax
  800c54:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c58:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c5f:	e9 ad 00 00 00       	jmpq   800d11 <vprintfmt+0x49c>
                  ch = *(unsigned char *) color;
                }
#endif

			// Replace this with your code.
		        num = getuint(&aq, 3);
  800c64:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c68:	be 03 00 00 00       	mov    $0x3,%esi
  800c6d:	48 89 c7             	mov    %rax,%rdi
  800c70:	48 b8 55 06 80 00 00 	movabs $0x800655,%rax
  800c77:	00 00 00 
  800c7a:	ff d0                	callq  *%rax
  800c7c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800c80:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800c87:	e9 85 00 00 00       	jmpq   800d11 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			putch('0', putdat);
  800c8c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c90:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c94:	48 89 d6             	mov    %rdx,%rsi
  800c97:	bf 30 00 00 00       	mov    $0x30,%edi
  800c9c:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c9e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ca2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ca6:	48 89 d6             	mov    %rdx,%rsi
  800ca9:	bf 78 00 00 00       	mov    $0x78,%edi
  800cae:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800cb0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cb3:	83 f8 30             	cmp    $0x30,%eax
  800cb6:	73 17                	jae    800ccf <vprintfmt+0x45a>
  800cb8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cbc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cbf:	89 c0                	mov    %eax,%eax
  800cc1:	48 01 d0             	add    %rdx,%rax
  800cc4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cc7:	83 c2 08             	add    $0x8,%edx
  800cca:	89 55 b8             	mov    %edx,-0x48(%rbp)
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ccd:	eb 0f                	jmp    800cde <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800ccf:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cd3:	48 89 d0             	mov    %rdx,%rax
  800cd6:	48 83 c2 08          	add    $0x8,%rdx
  800cda:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cde:	48 8b 00             	mov    (%rax),%rax
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ce1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800ce5:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800cec:	eb 23                	jmp    800d11 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getuint(&aq, 3);
  800cee:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cf2:	be 03 00 00 00       	mov    $0x3,%esi
  800cf7:	48 89 c7             	mov    %rax,%rdi
  800cfa:	48 b8 55 06 80 00 00 	movabs $0x800655,%rax
  800d01:	00 00 00 
  800d04:	ff d0                	callq  *%rax
  800d06:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d0a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:

			printnum(putch, putdat, num, base, width, padc);
  800d11:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d16:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d19:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d1c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d20:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d24:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d28:	45 89 c1             	mov    %r8d,%r9d
  800d2b:	41 89 f8             	mov    %edi,%r8d
  800d2e:	48 89 c7             	mov    %rax,%rdi
  800d31:	48 b8 9a 05 80 00 00 	movabs $0x80059a,%rax
  800d38:	00 00 00 
  800d3b:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			break;
  800d3d:	eb 3f                	jmp    800d7e <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d3f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d43:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d47:	48 89 d6             	mov    %rdx,%rsi
  800d4a:	89 df                	mov    %ebx,%edi
  800d4c:	ff d0                	callq  *%rax
			break;
  800d4e:	eb 2e                	jmp    800d7e <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d50:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d54:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d58:	48 89 d6             	mov    %rdx,%rsi
  800d5b:	bf 25 00 00 00       	mov    $0x25,%edi
  800d60:	ff d0                	callq  *%rax

			for (fmt--; fmt[-1] != '%'; fmt--)
  800d62:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d67:	eb 05                	jmp    800d6e <vprintfmt+0x4f9>
  800d69:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d6e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d72:	48 83 e8 01          	sub    $0x1,%rax
  800d76:	0f b6 00             	movzbl (%rax),%eax
  800d79:	3c 25                	cmp    $0x25,%al
  800d7b:	75 ec                	jne    800d69 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800d7d:	90                   	nop
		}
	}
  800d7e:	90                   	nop
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d7f:	e9 43 fb ff ff       	jmpq   8008c7 <vprintfmt+0x52>
			break;
		}
	}
    
va_end(aq);
}
  800d84:	48 83 c4 60          	add    $0x60,%rsp
  800d88:	5b                   	pop    %rbx
  800d89:	41 5c                	pop    %r12
  800d8b:	5d                   	pop    %rbp
  800d8c:	c3                   	retq   

0000000000800d8d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d8d:	55                   	push   %rbp
  800d8e:	48 89 e5             	mov    %rsp,%rbp
  800d91:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d98:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d9f:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800da6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800dad:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800db4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800dbb:	84 c0                	test   %al,%al
  800dbd:	74 20                	je     800ddf <printfmt+0x52>
  800dbf:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dc3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dc7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dcb:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dcf:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dd3:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dd7:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ddb:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ddf:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800de6:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800ded:	00 00 00 
  800df0:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800df7:	00 00 00 
  800dfa:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dfe:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e05:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e0c:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e13:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e1a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e21:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e28:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e2f:	48 89 c7             	mov    %rax,%rdi
  800e32:	48 b8 75 08 80 00 00 	movabs $0x800875,%rax
  800e39:	00 00 00 
  800e3c:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e3e:	c9                   	leaveq 
  800e3f:	c3                   	retq   

0000000000800e40 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e40:	55                   	push   %rbp
  800e41:	48 89 e5             	mov    %rsp,%rbp
  800e44:	48 83 ec 10          	sub    $0x10,%rsp
  800e48:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e4b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e53:	8b 40 10             	mov    0x10(%rax),%eax
  800e56:	8d 50 01             	lea    0x1(%rax),%edx
  800e59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e5d:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e64:	48 8b 10             	mov    (%rax),%rdx
  800e67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e6b:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e6f:	48 39 c2             	cmp    %rax,%rdx
  800e72:	73 17                	jae    800e8b <sprintputch+0x4b>
		*b->buf++ = ch;
  800e74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e78:	48 8b 00             	mov    (%rax),%rax
  800e7b:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e7f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e83:	48 89 0a             	mov    %rcx,(%rdx)
  800e86:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e89:	88 10                	mov    %dl,(%rax)
}
  800e8b:	c9                   	leaveq 
  800e8c:	c3                   	retq   

0000000000800e8d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e8d:	55                   	push   %rbp
  800e8e:	48 89 e5             	mov    %rsp,%rbp
  800e91:	48 83 ec 50          	sub    $0x50,%rsp
  800e95:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e99:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e9c:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ea0:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ea4:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ea8:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800eac:	48 8b 0a             	mov    (%rdx),%rcx
  800eaf:	48 89 08             	mov    %rcx,(%rax)
  800eb2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800eb6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800eba:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ebe:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ec2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ec6:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800eca:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800ecd:	48 98                	cltq   
  800ecf:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800ed3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ed7:	48 01 d0             	add    %rdx,%rax
  800eda:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ede:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ee5:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800eea:	74 06                	je     800ef2 <vsnprintf+0x65>
  800eec:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ef0:	7f 07                	jg     800ef9 <vsnprintf+0x6c>
		return -E_INVAL;
  800ef2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ef7:	eb 2f                	jmp    800f28 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ef9:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800efd:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f01:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f05:	48 89 c6             	mov    %rax,%rsi
  800f08:	48 bf 40 0e 80 00 00 	movabs $0x800e40,%rdi
  800f0f:	00 00 00 
  800f12:	48 b8 75 08 80 00 00 	movabs $0x800875,%rax
  800f19:	00 00 00 
  800f1c:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f1e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f22:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f25:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f28:	c9                   	leaveq 
  800f29:	c3                   	retq   

0000000000800f2a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f2a:	55                   	push   %rbp
  800f2b:	48 89 e5             	mov    %rsp,%rbp
  800f2e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f35:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f3c:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f42:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f49:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f50:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f57:	84 c0                	test   %al,%al
  800f59:	74 20                	je     800f7b <snprintf+0x51>
  800f5b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f5f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f63:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f67:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f6b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f6f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f73:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f77:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f7b:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f82:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f89:	00 00 00 
  800f8c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f93:	00 00 00 
  800f96:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f9a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fa1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fa8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800faf:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fb6:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fbd:	48 8b 0a             	mov    (%rdx),%rcx
  800fc0:	48 89 08             	mov    %rcx,(%rax)
  800fc3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fc7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fcb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fcf:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800fd3:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fda:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fe1:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fe7:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fee:	48 89 c7             	mov    %rax,%rdi
  800ff1:	48 b8 8d 0e 80 00 00 	movabs $0x800e8d,%rax
  800ff8:	00 00 00 
  800ffb:	ff d0                	callq  *%rax
  800ffd:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801003:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801009:	c9                   	leaveq 
  80100a:	c3                   	retq   

000000000080100b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80100b:	55                   	push   %rbp
  80100c:	48 89 e5             	mov    %rsp,%rbp
  80100f:	48 83 ec 18          	sub    $0x18,%rsp
  801013:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801017:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80101e:	eb 09                	jmp    801029 <strlen+0x1e>
		n++;
  801020:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801024:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801029:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80102d:	0f b6 00             	movzbl (%rax),%eax
  801030:	84 c0                	test   %al,%al
  801032:	75 ec                	jne    801020 <strlen+0x15>
		n++;
	return n;
  801034:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801037:	c9                   	leaveq 
  801038:	c3                   	retq   

0000000000801039 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801039:	55                   	push   %rbp
  80103a:	48 89 e5             	mov    %rsp,%rbp
  80103d:	48 83 ec 20          	sub    $0x20,%rsp
  801041:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801045:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801049:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801050:	eb 0e                	jmp    801060 <strnlen+0x27>
		n++;
  801052:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801056:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80105b:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801060:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801065:	74 0b                	je     801072 <strnlen+0x39>
  801067:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80106b:	0f b6 00             	movzbl (%rax),%eax
  80106e:	84 c0                	test   %al,%al
  801070:	75 e0                	jne    801052 <strnlen+0x19>
		n++;
	return n;
  801072:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801075:	c9                   	leaveq 
  801076:	c3                   	retq   

0000000000801077 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801077:	55                   	push   %rbp
  801078:	48 89 e5             	mov    %rsp,%rbp
  80107b:	48 83 ec 20          	sub    $0x20,%rsp
  80107f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801083:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801087:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80108f:	90                   	nop
  801090:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801094:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801098:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80109c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010a0:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010a4:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010a8:	0f b6 12             	movzbl (%rdx),%edx
  8010ab:	88 10                	mov    %dl,(%rax)
  8010ad:	0f b6 00             	movzbl (%rax),%eax
  8010b0:	84 c0                	test   %al,%al
  8010b2:	75 dc                	jne    801090 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010b8:	c9                   	leaveq 
  8010b9:	c3                   	retq   

00000000008010ba <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010ba:	55                   	push   %rbp
  8010bb:	48 89 e5             	mov    %rsp,%rbp
  8010be:	48 83 ec 20          	sub    $0x20,%rsp
  8010c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ce:	48 89 c7             	mov    %rax,%rdi
  8010d1:	48 b8 0b 10 80 00 00 	movabs $0x80100b,%rax
  8010d8:	00 00 00 
  8010db:	ff d0                	callq  *%rax
  8010dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010e3:	48 63 d0             	movslq %eax,%rdx
  8010e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ea:	48 01 c2             	add    %rax,%rdx
  8010ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010f1:	48 89 c6             	mov    %rax,%rsi
  8010f4:	48 89 d7             	mov    %rdx,%rdi
  8010f7:	48 b8 77 10 80 00 00 	movabs $0x801077,%rax
  8010fe:	00 00 00 
  801101:	ff d0                	callq  *%rax
	return dst;
  801103:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801107:	c9                   	leaveq 
  801108:	c3                   	retq   

0000000000801109 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801109:	55                   	push   %rbp
  80110a:	48 89 e5             	mov    %rsp,%rbp
  80110d:	48 83 ec 28          	sub    $0x28,%rsp
  801111:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801115:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801119:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80111d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801121:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801125:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80112c:	00 
  80112d:	eb 2a                	jmp    801159 <strncpy+0x50>
		*dst++ = *src;
  80112f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801133:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801137:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80113b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80113f:	0f b6 12             	movzbl (%rdx),%edx
  801142:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801144:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801148:	0f b6 00             	movzbl (%rax),%eax
  80114b:	84 c0                	test   %al,%al
  80114d:	74 05                	je     801154 <strncpy+0x4b>
			src++;
  80114f:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801154:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801159:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80115d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801161:	72 cc                	jb     80112f <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801163:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801167:	c9                   	leaveq 
  801168:	c3                   	retq   

0000000000801169 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801169:	55                   	push   %rbp
  80116a:	48 89 e5             	mov    %rsp,%rbp
  80116d:	48 83 ec 28          	sub    $0x28,%rsp
  801171:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801175:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801179:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80117d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801181:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801185:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80118a:	74 3d                	je     8011c9 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80118c:	eb 1d                	jmp    8011ab <strlcpy+0x42>
			*dst++ = *src++;
  80118e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801192:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801196:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80119a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80119e:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011a2:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011a6:	0f b6 12             	movzbl (%rdx),%edx
  8011a9:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011ab:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011b0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011b5:	74 0b                	je     8011c2 <strlcpy+0x59>
  8011b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011bb:	0f b6 00             	movzbl (%rax),%eax
  8011be:	84 c0                	test   %al,%al
  8011c0:	75 cc                	jne    80118e <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c6:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d1:	48 29 c2             	sub    %rax,%rdx
  8011d4:	48 89 d0             	mov    %rdx,%rax
}
  8011d7:	c9                   	leaveq 
  8011d8:	c3                   	retq   

00000000008011d9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011d9:	55                   	push   %rbp
  8011da:	48 89 e5             	mov    %rsp,%rbp
  8011dd:	48 83 ec 10          	sub    $0x10,%rsp
  8011e1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011e5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011e9:	eb 0a                	jmp    8011f5 <strcmp+0x1c>
		p++, q++;
  8011eb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011f0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f9:	0f b6 00             	movzbl (%rax),%eax
  8011fc:	84 c0                	test   %al,%al
  8011fe:	74 12                	je     801212 <strcmp+0x39>
  801200:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801204:	0f b6 10             	movzbl (%rax),%edx
  801207:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80120b:	0f b6 00             	movzbl (%rax),%eax
  80120e:	38 c2                	cmp    %al,%dl
  801210:	74 d9                	je     8011eb <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801212:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801216:	0f b6 00             	movzbl (%rax),%eax
  801219:	0f b6 d0             	movzbl %al,%edx
  80121c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801220:	0f b6 00             	movzbl (%rax),%eax
  801223:	0f b6 c0             	movzbl %al,%eax
  801226:	29 c2                	sub    %eax,%edx
  801228:	89 d0                	mov    %edx,%eax
}
  80122a:	c9                   	leaveq 
  80122b:	c3                   	retq   

000000000080122c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80122c:	55                   	push   %rbp
  80122d:	48 89 e5             	mov    %rsp,%rbp
  801230:	48 83 ec 18          	sub    $0x18,%rsp
  801234:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801238:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80123c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801240:	eb 0f                	jmp    801251 <strncmp+0x25>
		n--, p++, q++;
  801242:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801247:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80124c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801251:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801256:	74 1d                	je     801275 <strncmp+0x49>
  801258:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125c:	0f b6 00             	movzbl (%rax),%eax
  80125f:	84 c0                	test   %al,%al
  801261:	74 12                	je     801275 <strncmp+0x49>
  801263:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801267:	0f b6 10             	movzbl (%rax),%edx
  80126a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80126e:	0f b6 00             	movzbl (%rax),%eax
  801271:	38 c2                	cmp    %al,%dl
  801273:	74 cd                	je     801242 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801275:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80127a:	75 07                	jne    801283 <strncmp+0x57>
		return 0;
  80127c:	b8 00 00 00 00       	mov    $0x0,%eax
  801281:	eb 18                	jmp    80129b <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801283:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801287:	0f b6 00             	movzbl (%rax),%eax
  80128a:	0f b6 d0             	movzbl %al,%edx
  80128d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801291:	0f b6 00             	movzbl (%rax),%eax
  801294:	0f b6 c0             	movzbl %al,%eax
  801297:	29 c2                	sub    %eax,%edx
  801299:	89 d0                	mov    %edx,%eax
}
  80129b:	c9                   	leaveq 
  80129c:	c3                   	retq   

000000000080129d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80129d:	55                   	push   %rbp
  80129e:	48 89 e5             	mov    %rsp,%rbp
  8012a1:	48 83 ec 0c          	sub    $0xc,%rsp
  8012a5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012a9:	89 f0                	mov    %esi,%eax
  8012ab:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012ae:	eb 17                	jmp    8012c7 <strchr+0x2a>
		if (*s == c)
  8012b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b4:	0f b6 00             	movzbl (%rax),%eax
  8012b7:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012ba:	75 06                	jne    8012c2 <strchr+0x25>
			return (char *) s;
  8012bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c0:	eb 15                	jmp    8012d7 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012c2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012cb:	0f b6 00             	movzbl (%rax),%eax
  8012ce:	84 c0                	test   %al,%al
  8012d0:	75 de                	jne    8012b0 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012d7:	c9                   	leaveq 
  8012d8:	c3                   	retq   

00000000008012d9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012d9:	55                   	push   %rbp
  8012da:	48 89 e5             	mov    %rsp,%rbp
  8012dd:	48 83 ec 0c          	sub    $0xc,%rsp
  8012e1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012e5:	89 f0                	mov    %esi,%eax
  8012e7:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012ea:	eb 13                	jmp    8012ff <strfind+0x26>
		if (*s == c)
  8012ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f0:	0f b6 00             	movzbl (%rax),%eax
  8012f3:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012f6:	75 02                	jne    8012fa <strfind+0x21>
			break;
  8012f8:	eb 10                	jmp    80130a <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012fa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801303:	0f b6 00             	movzbl (%rax),%eax
  801306:	84 c0                	test   %al,%al
  801308:	75 e2                	jne    8012ec <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80130a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80130e:	c9                   	leaveq 
  80130f:	c3                   	retq   

0000000000801310 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801310:	55                   	push   %rbp
  801311:	48 89 e5             	mov    %rsp,%rbp
  801314:	48 83 ec 18          	sub    $0x18,%rsp
  801318:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80131c:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80131f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801323:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801328:	75 06                	jne    801330 <memset+0x20>
		return v;
  80132a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132e:	eb 69                	jmp    801399 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801330:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801334:	83 e0 03             	and    $0x3,%eax
  801337:	48 85 c0             	test   %rax,%rax
  80133a:	75 48                	jne    801384 <memset+0x74>
  80133c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801340:	83 e0 03             	and    $0x3,%eax
  801343:	48 85 c0             	test   %rax,%rax
  801346:	75 3c                	jne    801384 <memset+0x74>
		c &= 0xFF;
  801348:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80134f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801352:	c1 e0 18             	shl    $0x18,%eax
  801355:	89 c2                	mov    %eax,%edx
  801357:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80135a:	c1 e0 10             	shl    $0x10,%eax
  80135d:	09 c2                	or     %eax,%edx
  80135f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801362:	c1 e0 08             	shl    $0x8,%eax
  801365:	09 d0                	or     %edx,%eax
  801367:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80136a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80136e:	48 c1 e8 02          	shr    $0x2,%rax
  801372:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801375:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801379:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80137c:	48 89 d7             	mov    %rdx,%rdi
  80137f:	fc                   	cld    
  801380:	f3 ab                	rep stos %eax,%es:(%rdi)
  801382:	eb 11                	jmp    801395 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801384:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801388:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80138b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80138f:	48 89 d7             	mov    %rdx,%rdi
  801392:	fc                   	cld    
  801393:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801395:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801399:	c9                   	leaveq 
  80139a:	c3                   	retq   

000000000080139b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80139b:	55                   	push   %rbp
  80139c:	48 89 e5             	mov    %rsp,%rbp
  80139f:	48 83 ec 28          	sub    $0x28,%rsp
  8013a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013a7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013ab:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013bb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c3:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013c7:	0f 83 88 00 00 00    	jae    801455 <memmove+0xba>
  8013cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013d5:	48 01 d0             	add    %rdx,%rax
  8013d8:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013dc:	76 77                	jbe    801455 <memmove+0xba>
		s += n;
  8013de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e2:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ea:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f2:	83 e0 03             	and    $0x3,%eax
  8013f5:	48 85 c0             	test   %rax,%rax
  8013f8:	75 3b                	jne    801435 <memmove+0x9a>
  8013fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013fe:	83 e0 03             	and    $0x3,%eax
  801401:	48 85 c0             	test   %rax,%rax
  801404:	75 2f                	jne    801435 <memmove+0x9a>
  801406:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140a:	83 e0 03             	and    $0x3,%eax
  80140d:	48 85 c0             	test   %rax,%rax
  801410:	75 23                	jne    801435 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801412:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801416:	48 83 e8 04          	sub    $0x4,%rax
  80141a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80141e:	48 83 ea 04          	sub    $0x4,%rdx
  801422:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801426:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80142a:	48 89 c7             	mov    %rax,%rdi
  80142d:	48 89 d6             	mov    %rdx,%rsi
  801430:	fd                   	std    
  801431:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801433:	eb 1d                	jmp    801452 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801435:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801439:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80143d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801441:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801445:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801449:	48 89 d7             	mov    %rdx,%rdi
  80144c:	48 89 c1             	mov    %rax,%rcx
  80144f:	fd                   	std    
  801450:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801452:	fc                   	cld    
  801453:	eb 57                	jmp    8014ac <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801455:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801459:	83 e0 03             	and    $0x3,%eax
  80145c:	48 85 c0             	test   %rax,%rax
  80145f:	75 36                	jne    801497 <memmove+0xfc>
  801461:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801465:	83 e0 03             	and    $0x3,%eax
  801468:	48 85 c0             	test   %rax,%rax
  80146b:	75 2a                	jne    801497 <memmove+0xfc>
  80146d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801471:	83 e0 03             	and    $0x3,%eax
  801474:	48 85 c0             	test   %rax,%rax
  801477:	75 1e                	jne    801497 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801479:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147d:	48 c1 e8 02          	shr    $0x2,%rax
  801481:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801484:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801488:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80148c:	48 89 c7             	mov    %rax,%rdi
  80148f:	48 89 d6             	mov    %rdx,%rsi
  801492:	fc                   	cld    
  801493:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801495:	eb 15                	jmp    8014ac <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801497:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80149b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80149f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014a3:	48 89 c7             	mov    %rax,%rdi
  8014a6:	48 89 d6             	mov    %rdx,%rsi
  8014a9:	fc                   	cld    
  8014aa:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014b0:	c9                   	leaveq 
  8014b1:	c3                   	retq   

00000000008014b2 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014b2:	55                   	push   %rbp
  8014b3:	48 89 e5             	mov    %rsp,%rbp
  8014b6:	48 83 ec 18          	sub    $0x18,%rsp
  8014ba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014be:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014c2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014ca:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d2:	48 89 ce             	mov    %rcx,%rsi
  8014d5:	48 89 c7             	mov    %rax,%rdi
  8014d8:	48 b8 9b 13 80 00 00 	movabs $0x80139b,%rax
  8014df:	00 00 00 
  8014e2:	ff d0                	callq  *%rax
}
  8014e4:	c9                   	leaveq 
  8014e5:	c3                   	retq   

00000000008014e6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014e6:	55                   	push   %rbp
  8014e7:	48 89 e5             	mov    %rsp,%rbp
  8014ea:	48 83 ec 28          	sub    $0x28,%rsp
  8014ee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014f2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014f6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014fe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801502:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801506:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80150a:	eb 36                	jmp    801542 <memcmp+0x5c>
		if (*s1 != *s2)
  80150c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801510:	0f b6 10             	movzbl (%rax),%edx
  801513:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801517:	0f b6 00             	movzbl (%rax),%eax
  80151a:	38 c2                	cmp    %al,%dl
  80151c:	74 1a                	je     801538 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80151e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801522:	0f b6 00             	movzbl (%rax),%eax
  801525:	0f b6 d0             	movzbl %al,%edx
  801528:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80152c:	0f b6 00             	movzbl (%rax),%eax
  80152f:	0f b6 c0             	movzbl %al,%eax
  801532:	29 c2                	sub    %eax,%edx
  801534:	89 d0                	mov    %edx,%eax
  801536:	eb 20                	jmp    801558 <memcmp+0x72>
		s1++, s2++;
  801538:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80153d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801542:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801546:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80154a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80154e:	48 85 c0             	test   %rax,%rax
  801551:	75 b9                	jne    80150c <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801553:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801558:	c9                   	leaveq 
  801559:	c3                   	retq   

000000000080155a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80155a:	55                   	push   %rbp
  80155b:	48 89 e5             	mov    %rsp,%rbp
  80155e:	48 83 ec 28          	sub    $0x28,%rsp
  801562:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801566:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801569:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80156d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801571:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801575:	48 01 d0             	add    %rdx,%rax
  801578:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80157c:	eb 15                	jmp    801593 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80157e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801582:	0f b6 10             	movzbl (%rax),%edx
  801585:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801588:	38 c2                	cmp    %al,%dl
  80158a:	75 02                	jne    80158e <memfind+0x34>
			break;
  80158c:	eb 0f                	jmp    80159d <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80158e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801593:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801597:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80159b:	72 e1                	jb     80157e <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80159d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015a1:	c9                   	leaveq 
  8015a2:	c3                   	retq   

00000000008015a3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015a3:	55                   	push   %rbp
  8015a4:	48 89 e5             	mov    %rsp,%rbp
  8015a7:	48 83 ec 34          	sub    $0x34,%rsp
  8015ab:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015af:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015b3:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015bd:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015c4:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015c5:	eb 05                	jmp    8015cc <strtol+0x29>
		s++;
  8015c7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d0:	0f b6 00             	movzbl (%rax),%eax
  8015d3:	3c 20                	cmp    $0x20,%al
  8015d5:	74 f0                	je     8015c7 <strtol+0x24>
  8015d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015db:	0f b6 00             	movzbl (%rax),%eax
  8015de:	3c 09                	cmp    $0x9,%al
  8015e0:	74 e5                	je     8015c7 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e6:	0f b6 00             	movzbl (%rax),%eax
  8015e9:	3c 2b                	cmp    $0x2b,%al
  8015eb:	75 07                	jne    8015f4 <strtol+0x51>
		s++;
  8015ed:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015f2:	eb 17                	jmp    80160b <strtol+0x68>
	else if (*s == '-')
  8015f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f8:	0f b6 00             	movzbl (%rax),%eax
  8015fb:	3c 2d                	cmp    $0x2d,%al
  8015fd:	75 0c                	jne    80160b <strtol+0x68>
		s++, neg = 1;
  8015ff:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801604:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80160b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80160f:	74 06                	je     801617 <strtol+0x74>
  801611:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801615:	75 28                	jne    80163f <strtol+0x9c>
  801617:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161b:	0f b6 00             	movzbl (%rax),%eax
  80161e:	3c 30                	cmp    $0x30,%al
  801620:	75 1d                	jne    80163f <strtol+0x9c>
  801622:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801626:	48 83 c0 01          	add    $0x1,%rax
  80162a:	0f b6 00             	movzbl (%rax),%eax
  80162d:	3c 78                	cmp    $0x78,%al
  80162f:	75 0e                	jne    80163f <strtol+0x9c>
		s += 2, base = 16;
  801631:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801636:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80163d:	eb 2c                	jmp    80166b <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80163f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801643:	75 19                	jne    80165e <strtol+0xbb>
  801645:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801649:	0f b6 00             	movzbl (%rax),%eax
  80164c:	3c 30                	cmp    $0x30,%al
  80164e:	75 0e                	jne    80165e <strtol+0xbb>
		s++, base = 8;
  801650:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801655:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80165c:	eb 0d                	jmp    80166b <strtol+0xc8>
	else if (base == 0)
  80165e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801662:	75 07                	jne    80166b <strtol+0xc8>
		base = 10;
  801664:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80166b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166f:	0f b6 00             	movzbl (%rax),%eax
  801672:	3c 2f                	cmp    $0x2f,%al
  801674:	7e 1d                	jle    801693 <strtol+0xf0>
  801676:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167a:	0f b6 00             	movzbl (%rax),%eax
  80167d:	3c 39                	cmp    $0x39,%al
  80167f:	7f 12                	jg     801693 <strtol+0xf0>
			dig = *s - '0';
  801681:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801685:	0f b6 00             	movzbl (%rax),%eax
  801688:	0f be c0             	movsbl %al,%eax
  80168b:	83 e8 30             	sub    $0x30,%eax
  80168e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801691:	eb 4e                	jmp    8016e1 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801693:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801697:	0f b6 00             	movzbl (%rax),%eax
  80169a:	3c 60                	cmp    $0x60,%al
  80169c:	7e 1d                	jle    8016bb <strtol+0x118>
  80169e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a2:	0f b6 00             	movzbl (%rax),%eax
  8016a5:	3c 7a                	cmp    $0x7a,%al
  8016a7:	7f 12                	jg     8016bb <strtol+0x118>
			dig = *s - 'a' + 10;
  8016a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ad:	0f b6 00             	movzbl (%rax),%eax
  8016b0:	0f be c0             	movsbl %al,%eax
  8016b3:	83 e8 57             	sub    $0x57,%eax
  8016b6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016b9:	eb 26                	jmp    8016e1 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016bf:	0f b6 00             	movzbl (%rax),%eax
  8016c2:	3c 40                	cmp    $0x40,%al
  8016c4:	7e 48                	jle    80170e <strtol+0x16b>
  8016c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ca:	0f b6 00             	movzbl (%rax),%eax
  8016cd:	3c 5a                	cmp    $0x5a,%al
  8016cf:	7f 3d                	jg     80170e <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d5:	0f b6 00             	movzbl (%rax),%eax
  8016d8:	0f be c0             	movsbl %al,%eax
  8016db:	83 e8 37             	sub    $0x37,%eax
  8016de:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016e1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016e4:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016e7:	7c 02                	jl     8016eb <strtol+0x148>
			break;
  8016e9:	eb 23                	jmp    80170e <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016eb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016f0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016f3:	48 98                	cltq   
  8016f5:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016fa:	48 89 c2             	mov    %rax,%rdx
  8016fd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801700:	48 98                	cltq   
  801702:	48 01 d0             	add    %rdx,%rax
  801705:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801709:	e9 5d ff ff ff       	jmpq   80166b <strtol+0xc8>

	if (endptr)
  80170e:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801713:	74 0b                	je     801720 <strtol+0x17d>
		*endptr = (char *) s;
  801715:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801719:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80171d:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801720:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801724:	74 09                	je     80172f <strtol+0x18c>
  801726:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80172a:	48 f7 d8             	neg    %rax
  80172d:	eb 04                	jmp    801733 <strtol+0x190>
  80172f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801733:	c9                   	leaveq 
  801734:	c3                   	retq   

0000000000801735 <strstr>:

char * strstr(const char *in, const char *str)
{
  801735:	55                   	push   %rbp
  801736:	48 89 e5             	mov    %rsp,%rbp
  801739:	48 83 ec 30          	sub    $0x30,%rsp
  80173d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801741:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801745:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801749:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80174d:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801751:	0f b6 00             	movzbl (%rax),%eax
  801754:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  801757:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80175b:	75 06                	jne    801763 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  80175d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801761:	eb 6b                	jmp    8017ce <strstr+0x99>

    len = strlen(str);
  801763:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801767:	48 89 c7             	mov    %rax,%rdi
  80176a:	48 b8 0b 10 80 00 00 	movabs $0x80100b,%rax
  801771:	00 00 00 
  801774:	ff d0                	callq  *%rax
  801776:	48 98                	cltq   
  801778:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  80177c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801780:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801784:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801788:	0f b6 00             	movzbl (%rax),%eax
  80178b:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  80178e:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801792:	75 07                	jne    80179b <strstr+0x66>
                return (char *) 0;
  801794:	b8 00 00 00 00       	mov    $0x0,%eax
  801799:	eb 33                	jmp    8017ce <strstr+0x99>
        } while (sc != c);
  80179b:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80179f:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8017a2:	75 d8                	jne    80177c <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  8017a4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017a8:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b0:	48 89 ce             	mov    %rcx,%rsi
  8017b3:	48 89 c7             	mov    %rax,%rdi
  8017b6:	48 b8 2c 12 80 00 00 	movabs $0x80122c,%rax
  8017bd:	00 00 00 
  8017c0:	ff d0                	callq  *%rax
  8017c2:	85 c0                	test   %eax,%eax
  8017c4:	75 b6                	jne    80177c <strstr+0x47>

    return (char *) (in - 1);
  8017c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ca:	48 83 e8 01          	sub    $0x1,%rax
}
  8017ce:	c9                   	leaveq 
  8017cf:	c3                   	retq   

00000000008017d0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8017d0:	55                   	push   %rbp
  8017d1:	48 89 e5             	mov    %rsp,%rbp
  8017d4:	53                   	push   %rbx
  8017d5:	48 83 ec 48          	sub    $0x48,%rsp
  8017d9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017dc:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8017df:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017e3:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017e7:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017eb:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017ef:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017f2:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017f6:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017fa:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017fe:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801802:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801806:	4c 89 c3             	mov    %r8,%rbx
  801809:	cd 30                	int    $0x30
  80180b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80180f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801813:	74 3e                	je     801853 <syscall+0x83>
  801815:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80181a:	7e 37                	jle    801853 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80181c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801820:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801823:	49 89 d0             	mov    %rdx,%r8
  801826:	89 c1                	mov    %eax,%ecx
  801828:	48 ba 28 29 80 00 00 	movabs $0x802928,%rdx
  80182f:	00 00 00 
  801832:	be 23 00 00 00       	mov    $0x23,%esi
  801837:	48 bf 45 29 80 00 00 	movabs $0x802945,%rdi
  80183e:	00 00 00 
  801841:	b8 00 00 00 00       	mov    $0x0,%eax
  801846:	49 b9 89 02 80 00 00 	movabs $0x800289,%r9
  80184d:	00 00 00 
  801850:	41 ff d1             	callq  *%r9

	return ret;
  801853:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801857:	48 83 c4 48          	add    $0x48,%rsp
  80185b:	5b                   	pop    %rbx
  80185c:	5d                   	pop    %rbp
  80185d:	c3                   	retq   

000000000080185e <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80185e:	55                   	push   %rbp
  80185f:	48 89 e5             	mov    %rsp,%rbp
  801862:	48 83 ec 20          	sub    $0x20,%rsp
  801866:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80186a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80186e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801872:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801876:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80187d:	00 
  80187e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801884:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80188a:	48 89 d1             	mov    %rdx,%rcx
  80188d:	48 89 c2             	mov    %rax,%rdx
  801890:	be 00 00 00 00       	mov    $0x0,%esi
  801895:	bf 00 00 00 00       	mov    $0x0,%edi
  80189a:	48 b8 d0 17 80 00 00 	movabs $0x8017d0,%rax
  8018a1:	00 00 00 
  8018a4:	ff d0                	callq  *%rax
}
  8018a6:	c9                   	leaveq 
  8018a7:	c3                   	retq   

00000000008018a8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018a8:	55                   	push   %rbp
  8018a9:	48 89 e5             	mov    %rsp,%rbp
  8018ac:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8018b0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018b7:	00 
  8018b8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018be:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018c4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ce:	be 00 00 00 00       	mov    $0x0,%esi
  8018d3:	bf 01 00 00 00       	mov    $0x1,%edi
  8018d8:	48 b8 d0 17 80 00 00 	movabs $0x8017d0,%rax
  8018df:	00 00 00 
  8018e2:	ff d0                	callq  *%rax
}
  8018e4:	c9                   	leaveq 
  8018e5:	c3                   	retq   

00000000008018e6 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018e6:	55                   	push   %rbp
  8018e7:	48 89 e5             	mov    %rsp,%rbp
  8018ea:	48 83 ec 10          	sub    $0x10,%rsp
  8018ee:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018f4:	48 98                	cltq   
  8018f6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018fd:	00 
  8018fe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801904:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80190a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80190f:	48 89 c2             	mov    %rax,%rdx
  801912:	be 01 00 00 00       	mov    $0x1,%esi
  801917:	bf 03 00 00 00       	mov    $0x3,%edi
  80191c:	48 b8 d0 17 80 00 00 	movabs $0x8017d0,%rax
  801923:	00 00 00 
  801926:	ff d0                	callq  *%rax
}
  801928:	c9                   	leaveq 
  801929:	c3                   	retq   

000000000080192a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80192a:	55                   	push   %rbp
  80192b:	48 89 e5             	mov    %rsp,%rbp
  80192e:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801932:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801939:	00 
  80193a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801940:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801946:	b9 00 00 00 00       	mov    $0x0,%ecx
  80194b:	ba 00 00 00 00       	mov    $0x0,%edx
  801950:	be 00 00 00 00       	mov    $0x0,%esi
  801955:	bf 02 00 00 00       	mov    $0x2,%edi
  80195a:	48 b8 d0 17 80 00 00 	movabs $0x8017d0,%rax
  801961:	00 00 00 
  801964:	ff d0                	callq  *%rax
}
  801966:	c9                   	leaveq 
  801967:	c3                   	retq   

0000000000801968 <sys_yield>:

void
sys_yield(void)
{
  801968:	55                   	push   %rbp
  801969:	48 89 e5             	mov    %rsp,%rbp
  80196c:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801970:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801977:	00 
  801978:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80197e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801984:	b9 00 00 00 00       	mov    $0x0,%ecx
  801989:	ba 00 00 00 00       	mov    $0x0,%edx
  80198e:	be 00 00 00 00       	mov    $0x0,%esi
  801993:	bf 0a 00 00 00       	mov    $0xa,%edi
  801998:	48 b8 d0 17 80 00 00 	movabs $0x8017d0,%rax
  80199f:	00 00 00 
  8019a2:	ff d0                	callq  *%rax
}
  8019a4:	c9                   	leaveq 
  8019a5:	c3                   	retq   

00000000008019a6 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8019a6:	55                   	push   %rbp
  8019a7:	48 89 e5             	mov    %rsp,%rbp
  8019aa:	48 83 ec 20          	sub    $0x20,%rsp
  8019ae:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019b5:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8019b8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019bb:	48 63 c8             	movslq %eax,%rcx
  8019be:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019c5:	48 98                	cltq   
  8019c7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019ce:	00 
  8019cf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019d5:	49 89 c8             	mov    %rcx,%r8
  8019d8:	48 89 d1             	mov    %rdx,%rcx
  8019db:	48 89 c2             	mov    %rax,%rdx
  8019de:	be 01 00 00 00       	mov    $0x1,%esi
  8019e3:	bf 04 00 00 00       	mov    $0x4,%edi
  8019e8:	48 b8 d0 17 80 00 00 	movabs $0x8017d0,%rax
  8019ef:	00 00 00 
  8019f2:	ff d0                	callq  *%rax
}
  8019f4:	c9                   	leaveq 
  8019f5:	c3                   	retq   

00000000008019f6 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019f6:	55                   	push   %rbp
  8019f7:	48 89 e5             	mov    %rsp,%rbp
  8019fa:	48 83 ec 30          	sub    $0x30,%rsp
  8019fe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a01:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a05:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a08:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a0c:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a10:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a13:	48 63 c8             	movslq %eax,%rcx
  801a16:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a1a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a1d:	48 63 f0             	movslq %eax,%rsi
  801a20:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a27:	48 98                	cltq   
  801a29:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a2d:	49 89 f9             	mov    %rdi,%r9
  801a30:	49 89 f0             	mov    %rsi,%r8
  801a33:	48 89 d1             	mov    %rdx,%rcx
  801a36:	48 89 c2             	mov    %rax,%rdx
  801a39:	be 01 00 00 00       	mov    $0x1,%esi
  801a3e:	bf 05 00 00 00       	mov    $0x5,%edi
  801a43:	48 b8 d0 17 80 00 00 	movabs $0x8017d0,%rax
  801a4a:	00 00 00 
  801a4d:	ff d0                	callq  *%rax
}
  801a4f:	c9                   	leaveq 
  801a50:	c3                   	retq   

0000000000801a51 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a51:	55                   	push   %rbp
  801a52:	48 89 e5             	mov    %rsp,%rbp
  801a55:	48 83 ec 20          	sub    $0x20,%rsp
  801a59:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a5c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a60:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a67:	48 98                	cltq   
  801a69:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a70:	00 
  801a71:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a77:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a7d:	48 89 d1             	mov    %rdx,%rcx
  801a80:	48 89 c2             	mov    %rax,%rdx
  801a83:	be 01 00 00 00       	mov    $0x1,%esi
  801a88:	bf 06 00 00 00       	mov    $0x6,%edi
  801a8d:	48 b8 d0 17 80 00 00 	movabs $0x8017d0,%rax
  801a94:	00 00 00 
  801a97:	ff d0                	callq  *%rax
}
  801a99:	c9                   	leaveq 
  801a9a:	c3                   	retq   

0000000000801a9b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a9b:	55                   	push   %rbp
  801a9c:	48 89 e5             	mov    %rsp,%rbp
  801a9f:	48 83 ec 10          	sub    $0x10,%rsp
  801aa3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aa6:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801aa9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801aac:	48 63 d0             	movslq %eax,%rdx
  801aaf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ab2:	48 98                	cltq   
  801ab4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801abb:	00 
  801abc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ac2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ac8:	48 89 d1             	mov    %rdx,%rcx
  801acb:	48 89 c2             	mov    %rax,%rdx
  801ace:	be 01 00 00 00       	mov    $0x1,%esi
  801ad3:	bf 08 00 00 00       	mov    $0x8,%edi
  801ad8:	48 b8 d0 17 80 00 00 	movabs $0x8017d0,%rax
  801adf:	00 00 00 
  801ae2:	ff d0                	callq  *%rax
}
  801ae4:	c9                   	leaveq 
  801ae5:	c3                   	retq   

0000000000801ae6 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ae6:	55                   	push   %rbp
  801ae7:	48 89 e5             	mov    %rsp,%rbp
  801aea:	48 83 ec 20          	sub    $0x20,%rsp
  801aee:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801af1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801af5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801af9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801afc:	48 98                	cltq   
  801afe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b05:	00 
  801b06:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b0c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b12:	48 89 d1             	mov    %rdx,%rcx
  801b15:	48 89 c2             	mov    %rax,%rdx
  801b18:	be 01 00 00 00       	mov    $0x1,%esi
  801b1d:	bf 09 00 00 00       	mov    $0x9,%edi
  801b22:	48 b8 d0 17 80 00 00 	movabs $0x8017d0,%rax
  801b29:	00 00 00 
  801b2c:	ff d0                	callq  *%rax
}
  801b2e:	c9                   	leaveq 
  801b2f:	c3                   	retq   

0000000000801b30 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b30:	55                   	push   %rbp
  801b31:	48 89 e5             	mov    %rsp,%rbp
  801b34:	48 83 ec 20          	sub    $0x20,%rsp
  801b38:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b3b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b3f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b43:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b46:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b49:	48 63 f0             	movslq %eax,%rsi
  801b4c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b53:	48 98                	cltq   
  801b55:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b59:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b60:	00 
  801b61:	49 89 f1             	mov    %rsi,%r9
  801b64:	49 89 c8             	mov    %rcx,%r8
  801b67:	48 89 d1             	mov    %rdx,%rcx
  801b6a:	48 89 c2             	mov    %rax,%rdx
  801b6d:	be 00 00 00 00       	mov    $0x0,%esi
  801b72:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b77:	48 b8 d0 17 80 00 00 	movabs $0x8017d0,%rax
  801b7e:	00 00 00 
  801b81:	ff d0                	callq  *%rax
}
  801b83:	c9                   	leaveq 
  801b84:	c3                   	retq   

0000000000801b85 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b85:	55                   	push   %rbp
  801b86:	48 89 e5             	mov    %rsp,%rbp
  801b89:	48 83 ec 10          	sub    $0x10,%rsp
  801b8d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b95:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b9c:	00 
  801b9d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ba3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ba9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bae:	48 89 c2             	mov    %rax,%rdx
  801bb1:	be 01 00 00 00       	mov    $0x1,%esi
  801bb6:	bf 0c 00 00 00       	mov    $0xc,%edi
  801bbb:	48 b8 d0 17 80 00 00 	movabs $0x8017d0,%rax
  801bc2:	00 00 00 
  801bc5:	ff d0                	callq  *%rax
}
  801bc7:	c9                   	leaveq 
  801bc8:	c3                   	retq   

0000000000801bc9 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801bc9:	55                   	push   %rbp
  801bca:	48 89 e5             	mov    %rsp,%rbp
  801bcd:	48 83 ec 30          	sub    $0x30,%rsp
  801bd1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801bd5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bd9:	48 8b 00             	mov    (%rax),%rax
  801bdc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  801be0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801be4:	48 8b 40 08          	mov    0x8(%rax),%rax
  801be8:	89 45 fc             	mov    %eax,-0x4(%rbp)


	if (debug)
		cprintf("fault %08x %08x %d from %08x\n", addr, &uvpt[PGNUM(addr)], err & 7, (&addr)[4]);

	if (!(err & FEC_WR))
  801beb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bee:	83 e0 02             	and    $0x2,%eax
  801bf1:	85 c0                	test   %eax,%eax
  801bf3:	75 40                	jne    801c35 <pgfault+0x6c>
		panic("read fault at %x, rip %x", addr, utf->utf_rip);
  801bf5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bf9:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  801c00:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c04:	49 89 d0             	mov    %rdx,%r8
  801c07:	48 89 c1             	mov    %rax,%rcx
  801c0a:	48 ba 58 29 80 00 00 	movabs $0x802958,%rdx
  801c11:	00 00 00 
  801c14:	be 1a 00 00 00       	mov    $0x1a,%esi
  801c19:	48 bf 71 29 80 00 00 	movabs $0x802971,%rdi
  801c20:	00 00 00 
  801c23:	b8 00 00 00 00       	mov    $0x0,%eax
  801c28:	49 b9 89 02 80 00 00 	movabs $0x800289,%r9
  801c2f:	00 00 00 
  801c32:	41 ff d1             	callq  *%r9
	if ((uvpt[PGNUM(addr)] & (PTE_P|PTE_U|PTE_W|PTE_COW)) != (PTE_P|PTE_U|PTE_COW))
  801c35:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c39:	48 c1 e8 0c          	shr    $0xc,%rax
  801c3d:	48 89 c2             	mov    %rax,%rdx
  801c40:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c47:	01 00 00 
  801c4a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c4e:	25 07 08 00 00       	and    $0x807,%eax
  801c53:	48 3d 05 08 00 00    	cmp    $0x805,%rax
  801c59:	74 4e                	je     801ca9 <pgfault+0xe0>
		panic("fault at %x with pte %x, not copy-on-write",
  801c5b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c5f:	48 c1 e8 0c          	shr    $0xc,%rax
  801c63:	48 89 c2             	mov    %rax,%rdx
  801c66:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c6d:	01 00 00 
  801c70:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801c74:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c78:	49 89 d0             	mov    %rdx,%r8
  801c7b:	48 89 c1             	mov    %rax,%rcx
  801c7e:	48 ba 80 29 80 00 00 	movabs $0x802980,%rdx
  801c85:	00 00 00 
  801c88:	be 1d 00 00 00       	mov    $0x1d,%esi
  801c8d:	48 bf 71 29 80 00 00 	movabs $0x802971,%rdi
  801c94:	00 00 00 
  801c97:	b8 00 00 00 00       	mov    $0x0,%eax
  801c9c:	49 b9 89 02 80 00 00 	movabs $0x800289,%r9
  801ca3:	00 00 00 
  801ca6:	41 ff d1             	callq  *%r9
		      addr, uvpt[PGNUM(addr)]);



	// copy page
	if ((r = sys_page_alloc(0, (void*) PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801ca9:	ba 07 00 00 00       	mov    $0x7,%edx
  801cae:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801cb3:	bf 00 00 00 00       	mov    $0x0,%edi
  801cb8:	48 b8 a6 19 80 00 00 	movabs $0x8019a6,%rax
  801cbf:	00 00 00 
  801cc2:	ff d0                	callq  *%rax
  801cc4:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801cc7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801ccb:	79 30                	jns    801cfd <pgfault+0x134>
		panic("sys_page_alloc: %e", r);
  801ccd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cd0:	89 c1                	mov    %eax,%ecx
  801cd2:	48 ba ab 29 80 00 00 	movabs $0x8029ab,%rdx
  801cd9:	00 00 00 
  801cdc:	be 23 00 00 00       	mov    $0x23,%esi
  801ce1:	48 bf 71 29 80 00 00 	movabs $0x802971,%rdi
  801ce8:	00 00 00 
  801ceb:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf0:	49 b8 89 02 80 00 00 	movabs $0x800289,%r8
  801cf7:	00 00 00 
  801cfa:	41 ff d0             	callq  *%r8
	memmove((void*) PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  801cfd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d01:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  801d05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d09:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801d0f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d14:	48 89 c6             	mov    %rax,%rsi
  801d17:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801d1c:	48 b8 9b 13 80 00 00 	movabs $0x80139b,%rax
  801d23:	00 00 00 
  801d26:	ff d0                	callq  *%rax

	// remap over faulting page
	if ((r = sys_page_map(0, (void*) PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  801d28:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d2c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801d30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d34:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801d3a:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801d40:	48 89 c1             	mov    %rax,%rcx
  801d43:	ba 00 00 00 00       	mov    $0x0,%edx
  801d48:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d4d:	bf 00 00 00 00       	mov    $0x0,%edi
  801d52:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  801d59:	00 00 00 
  801d5c:	ff d0                	callq  *%rax
  801d5e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801d61:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801d65:	79 30                	jns    801d97 <pgfault+0x1ce>
		panic("sys_page_map: %e", r);
  801d67:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d6a:	89 c1                	mov    %eax,%ecx
  801d6c:	48 ba be 29 80 00 00 	movabs $0x8029be,%rdx
  801d73:	00 00 00 
  801d76:	be 28 00 00 00       	mov    $0x28,%esi
  801d7b:	48 bf 71 29 80 00 00 	movabs $0x802971,%rdi
  801d82:	00 00 00 
  801d85:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8a:	49 b8 89 02 80 00 00 	movabs $0x800289,%r8
  801d91:	00 00 00 
  801d94:	41 ff d0             	callq  *%r8

	// unmap our work space
	if ((r = sys_page_unmap(0, (void*) PFTEMP)) < 0)
  801d97:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d9c:	bf 00 00 00 00       	mov    $0x0,%edi
  801da1:	48 b8 51 1a 80 00 00 	movabs $0x801a51,%rax
  801da8:	00 00 00 
  801dab:	ff d0                	callq  *%rax
  801dad:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801db0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801db4:	79 30                	jns    801de6 <pgfault+0x21d>
		panic("sys_page_unmap: %e", r);
  801db6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801db9:	89 c1                	mov    %eax,%ecx
  801dbb:	48 ba cf 29 80 00 00 	movabs $0x8029cf,%rdx
  801dc2:	00 00 00 
  801dc5:	be 2c 00 00 00       	mov    $0x2c,%esi
  801dca:	48 bf 71 29 80 00 00 	movabs $0x802971,%rdi
  801dd1:	00 00 00 
  801dd4:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd9:	49 b8 89 02 80 00 00 	movabs $0x800289,%r8
  801de0:	00 00 00 
  801de3:	41 ff d0             	callq  *%r8

}
  801de6:	c9                   	leaveq 
  801de7:	c3                   	retq   

0000000000801de8 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801de8:	55                   	push   %rbp
  801de9:	48 89 e5             	mov    %rsp,%rbp
  801dec:	48 83 ec 30          	sub    $0x30,%rsp
  801df0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801df3:	89 75 d8             	mov    %esi,-0x28(%rbp)


	void *addr;
	pte_t pte;

	addr = (void*) (uint64_t)(pn << PGSHIFT);
  801df6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801df9:	c1 e0 0c             	shl    $0xc,%eax
  801dfc:	89 c0                	mov    %eax,%eax
  801dfe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	pte = uvpt[pn];
  801e02:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e09:	01 00 00 
  801e0c:	8b 55 d8             	mov    -0x28(%rbp),%edx
  801e0f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e13:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	

	// if the page is just read-only or is library-shared, map it directly.
	if (!(pte & (PTE_W|PTE_COW)) || (pte & PTE_SHARE)) {
  801e17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e1b:	25 02 08 00 00       	and    $0x802,%eax
  801e20:	48 85 c0             	test   %rax,%rax
  801e23:	74 0e                	je     801e33 <duppage+0x4b>
  801e25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e29:	25 00 04 00 00       	and    $0x400,%eax
  801e2e:	48 85 c0             	test   %rax,%rax
  801e31:	74 70                	je     801ea3 <duppage+0xbb>
		if ((r = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  801e33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e37:	25 07 0e 00 00       	and    $0xe07,%eax
  801e3c:	89 c6                	mov    %eax,%esi
  801e3e:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  801e42:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801e45:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e49:	41 89 f0             	mov    %esi,%r8d
  801e4c:	48 89 c6             	mov    %rax,%rsi
  801e4f:	bf 00 00 00 00       	mov    $0x0,%edi
  801e54:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  801e5b:	00 00 00 
  801e5e:	ff d0                	callq  *%rax
  801e60:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801e63:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e67:	79 30                	jns    801e99 <duppage+0xb1>
			panic("sys_page_map: %e", r);
  801e69:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e6c:	89 c1                	mov    %eax,%ecx
  801e6e:	48 ba be 29 80 00 00 	movabs $0x8029be,%rdx
  801e75:	00 00 00 
  801e78:	be 4b 00 00 00       	mov    $0x4b,%esi
  801e7d:	48 bf 71 29 80 00 00 	movabs $0x802971,%rdi
  801e84:	00 00 00 
  801e87:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8c:	49 b8 89 02 80 00 00 	movabs $0x800289,%r8
  801e93:	00 00 00 
  801e96:	41 ff d0             	callq  *%r8
		return 0;
  801e99:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9e:	e9 c4 00 00 00       	jmpq   801f67 <duppage+0x17f>
	// Even if we think the page is already copy-on-write in our
	// address space, we need to mark it copy-on-write again after
	// the first sys_page_map, just in case a page fault has caused
	// us to copy the page in the interim.

	if ((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  801ea3:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  801ea7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801eaa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eae:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  801eb4:	48 89 c6             	mov    %rax,%rsi
  801eb7:	bf 00 00 00 00       	mov    $0x0,%edi
  801ebc:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  801ec3:	00 00 00 
  801ec6:	ff d0                	callq  *%rax
  801ec8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801ecb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ecf:	79 30                	jns    801f01 <duppage+0x119>
		panic("sys_page_map: %e", r);
  801ed1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ed4:	89 c1                	mov    %eax,%ecx
  801ed6:	48 ba be 29 80 00 00 	movabs $0x8029be,%rdx
  801edd:	00 00 00 
  801ee0:	be 5f 00 00 00       	mov    $0x5f,%esi
  801ee5:	48 bf 71 29 80 00 00 	movabs $0x802971,%rdi
  801eec:	00 00 00 
  801eef:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef4:	49 b8 89 02 80 00 00 	movabs $0x800289,%r8
  801efb:	00 00 00 
  801efe:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  801f01:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f09:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  801f0f:	48 89 d1             	mov    %rdx,%rcx
  801f12:	ba 00 00 00 00       	mov    $0x0,%edx
  801f17:	48 89 c6             	mov    %rax,%rsi
  801f1a:	bf 00 00 00 00       	mov    $0x0,%edi
  801f1f:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  801f26:	00 00 00 
  801f29:	ff d0                	callq  *%rax
  801f2b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f2e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f32:	79 30                	jns    801f64 <duppage+0x17c>
		panic("sys_page_map: %e", r);
  801f34:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f37:	89 c1                	mov    %eax,%ecx
  801f39:	48 ba be 29 80 00 00 	movabs $0x8029be,%rdx
  801f40:	00 00 00 
  801f43:	be 61 00 00 00       	mov    $0x61,%esi
  801f48:	48 bf 71 29 80 00 00 	movabs $0x802971,%rdi
  801f4f:	00 00 00 
  801f52:	b8 00 00 00 00       	mov    $0x0,%eax
  801f57:	49 b8 89 02 80 00 00 	movabs $0x800289,%r8
  801f5e:	00 00 00 
  801f61:	41 ff d0             	callq  *%r8
	return r;
  801f64:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  801f67:	c9                   	leaveq 
  801f68:	c3                   	retq   

0000000000801f69 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801f69:	55                   	push   %rbp
  801f6a:	48 89 e5             	mov    %rsp,%rbp
  801f6d:	48 83 ec 20          	sub    $0x20,%rsp
	envid_t envid;
	int pn, end_pn, r;

	set_pgfault_handler(pgfault);
  801f71:	48 bf c9 1b 80 00 00 	movabs $0x801bc9,%rdi
  801f78:	00 00 00 
  801f7b:	48 b8 8a 23 80 00 00 	movabs $0x80238a,%rax
  801f82:	00 00 00 
  801f85:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801f87:	b8 07 00 00 00       	mov    $0x7,%eax
  801f8c:	cd 30                	int    $0x30
  801f8e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801f91:	8b 45 ec             	mov    -0x14(%rbp),%eax

	// Create a child.
	envid = sys_exofork();
  801f94:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (envid < 0)
  801f97:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801f9b:	79 08                	jns    801fa5 <fork+0x3c>
		return envid;
  801f9d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801fa0:	e9 11 02 00 00       	jmpq   8021b6 <fork+0x24d>
	if (envid == 0) {
  801fa5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801fa9:	75 46                	jne    801ff1 <fork+0x88>
		thisenv = &envs[ENVX(sys_getenvid())];
  801fab:	48 b8 2a 19 80 00 00 	movabs $0x80192a,%rax
  801fb2:	00 00 00 
  801fb5:	ff d0                	callq  *%rax
  801fb7:	25 ff 03 00 00       	and    $0x3ff,%eax
  801fbc:	48 63 d0             	movslq %eax,%rdx
  801fbf:	48 89 d0             	mov    %rdx,%rax
  801fc2:	48 c1 e0 03          	shl    $0x3,%rax
  801fc6:	48 01 d0             	add    %rdx,%rax
  801fc9:	48 c1 e0 05          	shl    $0x5,%rax
  801fcd:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801fd4:	00 00 00 
  801fd7:	48 01 c2             	add    %rax,%rdx
  801fda:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  801fe1:	00 00 00 
  801fe4:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801fe7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fec:	e9 c5 01 00 00       	jmpq   8021b6 <fork+0x24d>
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  801ff1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ff8:	e9 a4 00 00 00       	jmpq   8020a1 <fork+0x138>
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
  801ffd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802000:	c1 f8 12             	sar    $0x12,%eax
  802003:	89 c2                	mov    %eax,%edx
  802005:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80200c:	01 00 00 
  80200f:	48 63 d2             	movslq %edx,%rdx
  802012:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802016:	83 e0 01             	and    $0x1,%eax
  802019:	48 85 c0             	test   %rax,%rax
  80201c:	74 21                	je     80203f <fork+0xd6>
  80201e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802021:	c1 f8 09             	sar    $0x9,%eax
  802024:	89 c2                	mov    %eax,%edx
  802026:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80202d:	01 00 00 
  802030:	48 63 d2             	movslq %edx,%rdx
  802033:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802037:	83 e0 01             	and    $0x1,%eax
  80203a:	48 85 c0             	test   %rax,%rax
  80203d:	75 09                	jne    802048 <fork+0xdf>
			pn += NPTENTRIES;
  80203f:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%rbp)
			continue;
  802046:	eb 59                	jmp    8020a1 <fork+0x138>
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  802048:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80204b:	05 00 02 00 00       	add    $0x200,%eax
  802050:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802053:	eb 44                	jmp    802099 <fork+0x130>
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
  802055:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80205c:	01 00 00 
  80205f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802062:	48 63 d2             	movslq %edx,%rdx
  802065:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802069:	83 e0 05             	and    $0x5,%eax
  80206c:	48 83 f8 05          	cmp    $0x5,%rax
  802070:	74 02                	je     802074 <fork+0x10b>
				continue;
  802072:	eb 21                	jmp    802095 <fork+0x12c>
			if (pn == PPN(UXSTACKTOP - 1))
  802074:	81 7d fc ff f7 0e 00 	cmpl   $0xef7ff,-0x4(%rbp)
  80207b:	75 02                	jne    80207f <fork+0x116>
				continue;
  80207d:	eb 16                	jmp    802095 <fork+0x12c>
			duppage(envid, pn);
  80207f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802082:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802085:	89 d6                	mov    %edx,%esi
  802087:	89 c7                	mov    %eax,%edi
  802089:	48 b8 e8 1d 80 00 00 	movabs $0x801de8,%rax
  802090:	00 00 00 
  802093:	ff d0                	callq  *%rax
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  802095:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802099:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80209c:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80209f:	7c b4                	jl     802055 <fork+0xec>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  8020a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020a4:	3d ff 07 00 08       	cmp    $0x80007ff,%eax
  8020a9:	0f 86 4e ff ff ff    	jbe    801ffd <fork+0x94>
			duppage(envid, pn);
		}
	}

	// The child needs to start out with a valid exception stack.
	if ((r = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  8020af:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020b2:	ba 07 00 00 00       	mov    $0x7,%edx
  8020b7:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8020bc:	89 c7                	mov    %eax,%edi
  8020be:	48 b8 a6 19 80 00 00 	movabs $0x8019a6,%rax
  8020c5:	00 00 00 
  8020c8:	ff d0                	callq  *%rax
  8020ca:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8020cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8020d1:	79 30                	jns    802103 <fork+0x19a>
		panic("allocating exception stack: %e", r);
  8020d3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8020d6:	89 c1                	mov    %eax,%ecx
  8020d8:	48 ba e8 29 80 00 00 	movabs $0x8029e8,%rdx
  8020df:	00 00 00 
  8020e2:	be 98 00 00 00       	mov    $0x98,%esi
  8020e7:	48 bf 71 29 80 00 00 	movabs $0x802971,%rdi
  8020ee:	00 00 00 
  8020f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f6:	49 b8 89 02 80 00 00 	movabs $0x800289,%r8
  8020fd:	00 00 00 
  802100:	41 ff d0             	callq  *%r8

	// Copy the user-mode exception entrypoint.
	if ((r = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall)) < 0)
  802103:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  80210a:	00 00 00 
  80210d:	48 8b 00             	mov    (%rax),%rax
  802110:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802117:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80211a:	48 89 d6             	mov    %rdx,%rsi
  80211d:	89 c7                	mov    %eax,%edi
  80211f:	48 b8 e6 1a 80 00 00 	movabs $0x801ae6,%rax
  802126:	00 00 00 
  802129:	ff d0                	callq  *%rax
  80212b:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80212e:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802132:	79 30                	jns    802164 <fork+0x1fb>
		panic("sys_env_set_pgfault_upcall: %e", r);
  802134:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802137:	89 c1                	mov    %eax,%ecx
  802139:	48 ba 08 2a 80 00 00 	movabs $0x802a08,%rdx
  802140:	00 00 00 
  802143:	be 9c 00 00 00       	mov    $0x9c,%esi
  802148:	48 bf 71 29 80 00 00 	movabs $0x802971,%rdi
  80214f:	00 00 00 
  802152:	b8 00 00 00 00       	mov    $0x0,%eax
  802157:	49 b8 89 02 80 00 00 	movabs $0x800289,%r8
  80215e:	00 00 00 
  802161:	41 ff d0             	callq  *%r8


	// Okay, the child is ready for life on its own.
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  802164:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802167:	be 02 00 00 00       	mov    $0x2,%esi
  80216c:	89 c7                	mov    %eax,%edi
  80216e:	48 b8 9b 1a 80 00 00 	movabs $0x801a9b,%rax
  802175:	00 00 00 
  802178:	ff d0                	callq  *%rax
  80217a:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80217d:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802181:	79 30                	jns    8021b3 <fork+0x24a>
		panic("sys_env_set_status: %e", r);
  802183:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802186:	89 c1                	mov    %eax,%ecx
  802188:	48 ba 27 2a 80 00 00 	movabs $0x802a27,%rdx
  80218f:	00 00 00 
  802192:	be a1 00 00 00       	mov    $0xa1,%esi
  802197:	48 bf 71 29 80 00 00 	movabs $0x802971,%rdi
  80219e:	00 00 00 
  8021a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a6:	49 b8 89 02 80 00 00 	movabs $0x800289,%r8
  8021ad:	00 00 00 
  8021b0:	41 ff d0             	callq  *%r8

	return envid;
  8021b3:	8b 45 f8             	mov    -0x8(%rbp),%eax


}
  8021b6:	c9                   	leaveq 
  8021b7:	c3                   	retq   

00000000008021b8 <sfork>:

// Challenge!
int
sfork(void)
{
  8021b8:	55                   	push   %rbp
  8021b9:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8021bc:	48 ba 3e 2a 80 00 00 	movabs $0x802a3e,%rdx
  8021c3:	00 00 00 
  8021c6:	be ac 00 00 00       	mov    $0xac,%esi
  8021cb:	48 bf 71 29 80 00 00 	movabs $0x802971,%rdi
  8021d2:	00 00 00 
  8021d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8021da:	48 b9 89 02 80 00 00 	movabs $0x800289,%rcx
  8021e1:	00 00 00 
  8021e4:	ff d1                	callq  *%rcx

00000000008021e6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021e6:	55                   	push   %rbp
  8021e7:	48 89 e5             	mov    %rsp,%rbp
  8021ea:	48 83 ec 30          	sub    $0x30,%rsp
  8021ee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8021f2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8021f6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	
	if(pg == NULL)
  8021fa:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8021ff:	75 0e                	jne    80220f <ipc_recv+0x29>
	  pg = (void *)(UTOP); // We always check above and below UTOP
  802201:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802208:	00 00 00 
  80220b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	 int retval = sys_ipc_recv(pg);
  80220f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802213:	48 89 c7             	mov    %rax,%rdi
  802216:	48 b8 85 1b 80 00 00 	movabs $0x801b85,%rax
  80221d:	00 00 00 
  802220:	ff d0                	callq  *%rax
  802222:	89 45 fc             	mov    %eax,-0x4(%rbp)

	 if(retval == 0)
  802225:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802229:	75 55                	jne    802280 <ipc_recv+0x9a>
	 {	
	    if(from_env_store != NULL)
  80222b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802230:	74 19                	je     80224b <ipc_recv+0x65>
               *from_env_store = thisenv->env_ipc_from;
  802232:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  802239:	00 00 00 
  80223c:	48 8b 00             	mov    (%rax),%rax
  80223f:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802245:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802249:	89 10                	mov    %edx,(%rax)

	    if(perm_store != NULL)
  80224b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802250:	74 19                	je     80226b <ipc_recv+0x85>
               *perm_store = thisenv->env_ipc_perm;
  802252:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  802259:	00 00 00 
  80225c:	48 8b 00             	mov    (%rax),%rax
  80225f:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802265:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802269:	89 10                	mov    %edx,(%rax)

	   return thisenv->env_ipc_value;
  80226b:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  802272:	00 00 00 
  802275:	48 8b 00             	mov    (%rax),%rax
  802278:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  80227e:	eb 25                	jmp    8022a5 <ipc_recv+0xbf>

	 }
	 else
	 {
	      if(from_env_store)
  802280:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802285:	74 0a                	je     802291 <ipc_recv+0xab>
	         *from_env_store = 0;
  802287:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80228b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	      
	      if(perm_store)
  802291:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802296:	74 0a                	je     8022a2 <ipc_recv+0xbc>
	       *perm_store = 0;
  802298:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80229c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	       
	       return retval;
  8022a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
	 }
	
	panic("problem in ipc_recv lib/ipc.c");
	//return 0;
}
  8022a5:	c9                   	leaveq 
  8022a6:	c3                   	retq   

00000000008022a7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8022a7:	55                   	push   %rbp
  8022a8:	48 89 e5             	mov    %rsp,%rbp
  8022ab:	48 83 ec 30          	sub    $0x30,%rsp
  8022af:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022b2:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8022b5:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8022b9:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.

	if(pg == NULL)
  8022bc:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8022c1:	75 0e                	jne    8022d1 <ipc_send+0x2a>
	   pg = (void *)(UTOP);
  8022c3:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8022ca:	00 00 00 
  8022cd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	int retval;
	while(1)
	{
	   retval = sys_ipc_try_send(to_env, val, pg, perm);
  8022d1:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8022d4:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8022d7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8022db:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022de:	89 c7                	mov    %eax,%edi
  8022e0:	48 b8 30 1b 80 00 00 	movabs $0x801b30,%rax
  8022e7:	00 00 00 
  8022ea:	ff d0                	callq  *%rax
  8022ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
	   if(retval == 0)
  8022ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022f3:	75 02                	jne    8022f7 <ipc_send+0x50>
	      break;
  8022f5:	eb 0e                	jmp    802305 <ipc_send+0x5e>
	   
	   //if(retval < 0 && retval != -E_IPC_NOT_RECV)
	     //panic("receiver error other than NOT_RECV");

	   sys_yield(); 
  8022f7:	48 b8 68 19 80 00 00 	movabs $0x801968,%rax
  8022fe:	00 00 00 
  802301:	ff d0                	callq  *%rax
	 
	}
  802303:	eb cc                	jmp    8022d1 <ipc_send+0x2a>
	return;
  802305:	90                   	nop
	//panic("ipc_send not implemented");
}
  802306:	c9                   	leaveq 
  802307:	c3                   	retq   

0000000000802308 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802308:	55                   	push   %rbp
  802309:	48 89 e5             	mov    %rsp,%rbp
  80230c:	48 83 ec 14          	sub    $0x14,%rsp
  802310:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  802313:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80231a:	eb 5e                	jmp    80237a <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80231c:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802323:	00 00 00 
  802326:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802329:	48 63 d0             	movslq %eax,%rdx
  80232c:	48 89 d0             	mov    %rdx,%rax
  80232f:	48 c1 e0 03          	shl    $0x3,%rax
  802333:	48 01 d0             	add    %rdx,%rax
  802336:	48 c1 e0 05          	shl    $0x5,%rax
  80233a:	48 01 c8             	add    %rcx,%rax
  80233d:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802343:	8b 00                	mov    (%rax),%eax
  802345:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802348:	75 2c                	jne    802376 <ipc_find_env+0x6e>
			return envs[i].env_id;
  80234a:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802351:	00 00 00 
  802354:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802357:	48 63 d0             	movslq %eax,%rdx
  80235a:	48 89 d0             	mov    %rdx,%rax
  80235d:	48 c1 e0 03          	shl    $0x3,%rax
  802361:	48 01 d0             	add    %rdx,%rax
  802364:	48 c1 e0 05          	shl    $0x5,%rax
  802368:	48 01 c8             	add    %rcx,%rax
  80236b:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802371:	8b 40 08             	mov    0x8(%rax),%eax
  802374:	eb 12                	jmp    802388 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802376:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80237a:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802381:	7e 99                	jle    80231c <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802383:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802388:	c9                   	leaveq 
  802389:	c3                   	retq   

000000000080238a <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80238a:	55                   	push   %rbp
  80238b:	48 89 e5             	mov    %rsp,%rbp
  80238e:	48 83 ec 10          	sub    $0x10,%rsp
  802392:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;
	
	if (_pgfault_handler == 0) {
  802396:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  80239d:	00 00 00 
  8023a0:	48 8b 00             	mov    (%rax),%rax
  8023a3:	48 85 c0             	test   %rax,%rax
  8023a6:	0f 85 b2 00 00 00    	jne    80245e <set_pgfault_handler+0xd4>
		// First time through!
		// LAB 4: Your code here.
		
		if(sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP-PGSIZE), PTE_P|PTE_U|PTE_W) != 0)
  8023ac:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  8023b3:	00 00 00 
  8023b6:	48 8b 00             	mov    (%rax),%rax
  8023b9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023bf:	ba 07 00 00 00       	mov    $0x7,%edx
  8023c4:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8023c9:	89 c7                	mov    %eax,%edi
  8023cb:	48 b8 a6 19 80 00 00 	movabs $0x8019a6,%rax
  8023d2:	00 00 00 
  8023d5:	ff d0                	callq  *%rax
  8023d7:	85 c0                	test   %eax,%eax
  8023d9:	74 2a                	je     802405 <set_pgfault_handler+0x7b>
		  panic("\nproblem in page allocation lib/pgfault.c\n");
  8023db:	48 ba 58 2a 80 00 00 	movabs $0x802a58,%rdx
  8023e2:	00 00 00 
  8023e5:	be 22 00 00 00       	mov    $0x22,%esi
  8023ea:	48 bf 83 2a 80 00 00 	movabs $0x802a83,%rdi
  8023f1:	00 00 00 
  8023f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f9:	48 b9 89 02 80 00 00 	movabs $0x800289,%rcx
  802400:	00 00 00 
  802403:	ff d1                	callq  *%rcx
		
	         if(sys_env_set_pgfault_upcall(thisenv->env_id, (void *)_pgfault_upcall) != 0)
  802405:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  80240c:	00 00 00 
  80240f:	48 8b 00             	mov    (%rax),%rax
  802412:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802418:	48 be 71 24 80 00 00 	movabs $0x802471,%rsi
  80241f:	00 00 00 
  802422:	89 c7                	mov    %eax,%edi
  802424:	48 b8 e6 1a 80 00 00 	movabs $0x801ae6,%rax
  80242b:	00 00 00 
  80242e:	ff d0                	callq  *%rax
  802430:	85 c0                	test   %eax,%eax
  802432:	74 2a                	je     80245e <set_pgfault_handler+0xd4>
		   panic("set_pgfault_handler implemented but problems lib/pgfault.c");
  802434:	48 ba 98 2a 80 00 00 	movabs $0x802a98,%rdx
  80243b:	00 00 00 
  80243e:	be 25 00 00 00       	mov    $0x25,%esi
  802443:	48 bf 83 2a 80 00 00 	movabs $0x802a83,%rdi
  80244a:	00 00 00 
  80244d:	b8 00 00 00 00       	mov    $0x0,%eax
  802452:	48 b9 89 02 80 00 00 	movabs $0x800289,%rcx
  802459:	00 00 00 
  80245c:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80245e:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  802465:	00 00 00 
  802468:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80246c:	48 89 10             	mov    %rdx,(%rax)
}
  80246f:	c9                   	leaveq 
  802470:	c3                   	retq   

0000000000802471 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  802471:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  802474:	48 a1 10 40 80 00 00 	movabs 0x804010,%rax
  80247b:	00 00 00 
	call *%rax
  80247e:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.                
	movq %rsp, %rdi;	
  802480:	48 89 e7             	mov    %rsp,%rdi
	movq 136(%rsp), %rbx;
  802483:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  80248a:	00 
	movq 152(%rsp), %rsp;// Going to another stack for storing rip	
  80248b:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  802492:	00 
	pushq %rbx;
  802493:	53                   	push   %rbx
	movq %rsp, %rbx;	
  802494:	48 89 e3             	mov    %rsp,%rbx
	movq %rdi, %rsp;	
  802497:	48 89 fc             	mov    %rdi,%rsp
	movq %rbx, 152(%rsp)	
  80249a:	48 89 9c 24 98 00 00 	mov    %rbx,0x98(%rsp)
  8024a1:	00 
   
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16, %rsp;	
  8024a2:	48 83 c4 10          	add    $0x10,%rsp
	POPA_;  // getting all register values back
  8024a6:	4c 8b 3c 24          	mov    (%rsp),%r15
  8024aa:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8024af:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8024b4:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8024b9:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8024be:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8024c3:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8024c8:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8024cd:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8024d2:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8024d7:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8024dc:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8024e1:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8024e6:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8024eb:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8024f0:	48 83 c4 78          	add    $0x78,%rsp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	add $8, %rsp; //Jump rip field  
  8024f4:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  8024f8:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp   //USTACK
  8024f9:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret   
  8024fa:	c3                   	retq   
