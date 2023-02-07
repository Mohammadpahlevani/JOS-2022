
obj/user/testpiperace:     file format elf64-x86-64


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
  80003c:	e8 4c 03 00 00       	callq  80038d <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 50          	sub    $0x50,%rsp
  80004b:	89 7d bc             	mov    %edi,-0x44(%rbp)
  80004e:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  800052:	48 bf 80 3e 80 00 00 	movabs $0x803e80,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 79 06 80 00 00 	movabs $0x800679,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	if ((r = pipe(p)) < 0)
  80006d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800071:	48 89 c7             	mov    %rax,%rdi
  800074:	48 b8 d4 34 80 00 00 	movabs $0x8034d4,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
  800080:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800083:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800087:	79 30                	jns    8000b9 <umain+0x76>
		panic("pipe: %e", r);
  800089:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80008c:	89 c1                	mov    %eax,%ecx
  80008e:	48 ba 99 3e 80 00 00 	movabs $0x803e99,%rdx
  800095:	00 00 00 
  800098:	be 0d 00 00 00       	mov    $0xd,%esi
  80009d:	48 bf a2 3e 80 00 00 	movabs $0x803ea2,%rdi
  8000a4:	00 00 00 
  8000a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ac:	49 b8 40 04 80 00 00 	movabs $0x800440,%r8
  8000b3:	00 00 00 
  8000b6:	41 ff d0             	callq  *%r8
	max = 200;
  8000b9:	c7 45 f4 c8 00 00 00 	movl   $0xc8,-0xc(%rbp)
	if ((r = fork()) < 0)
  8000c0:	48 b8 1d 20 80 00 00 	movabs $0x80201d,%rax
  8000c7:	00 00 00 
  8000ca:	ff d0                	callq  *%rax
  8000cc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000cf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000d3:	79 30                	jns    800105 <umain+0xc2>
		panic("fork: %e", r);
  8000d5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d8:	89 c1                	mov    %eax,%ecx
  8000da:	48 ba b6 3e 80 00 00 	movabs $0x803eb6,%rdx
  8000e1:	00 00 00 
  8000e4:	be 10 00 00 00       	mov    $0x10,%esi
  8000e9:	48 bf a2 3e 80 00 00 	movabs $0x803ea2,%rdi
  8000f0:	00 00 00 
  8000f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f8:	49 b8 40 04 80 00 00 	movabs $0x800440,%r8
  8000ff:	00 00 00 
  800102:	41 ff d0             	callq  *%r8
	if (r == 0) {
  800105:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800109:	0f 85 89 00 00 00    	jne    800198 <umain+0x155>
		close(p[1]);
  80010f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800112:	89 c7                	mov    %eax,%edi
  800114:	48 b8 f0 27 80 00 00 	movabs $0x8027f0,%rax
  80011b:	00 00 00 
  80011e:	ff d0                	callq  *%rax
		//
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
  800120:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800127:	eb 4c                	jmp    800175 <umain+0x132>
			if(pipeisclosed(p[0])){
  800129:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80012c:	89 c7                	mov    %eax,%edi
  80012e:	48 b8 9d 37 80 00 00 	movabs $0x80379d,%rax
  800135:	00 00 00 
  800138:	ff d0                	callq  *%rax
  80013a:	85 c0                	test   %eax,%eax
  80013c:	74 27                	je     800165 <umain+0x122>
				cprintf("RACE: pipe appears closed\n");
  80013e:	48 bf bf 3e 80 00 00 	movabs $0x803ebf,%rdi
  800145:	00 00 00 
  800148:	b8 00 00 00 00       	mov    $0x0,%eax
  80014d:	48 ba 79 06 80 00 00 	movabs $0x800679,%rdx
  800154:	00 00 00 
  800157:	ff d2                	callq  *%rdx
				exit();
  800159:	48 b8 1d 04 80 00 00 	movabs $0x80041d,%rax
  800160:	00 00 00 
  800163:	ff d0                	callq  *%rax
			}
			sys_yield();
  800165:	48 b8 1f 1b 80 00 00 	movabs $0x801b1f,%rax
  80016c:	00 00 00 
  80016f:	ff d0                	callq  *%rax
		//
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
  800171:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800175:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800178:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80017b:	7c ac                	jl     800129 <umain+0xe6>
				exit();
			}
			sys_yield();
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
  80017d:	ba 00 00 00 00       	mov    $0x0,%edx
  800182:	be 00 00 00 00       	mov    $0x0,%esi
  800187:	bf 00 00 00 00       	mov    $0x0,%edi
  80018c:	48 b8 15 23 80 00 00 	movabs $0x802315,%rax
  800193:	00 00 00 
  800196:	ff d0                	callq  *%rax
	}
	pid = r;
  800198:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80019b:	89 45 f0             	mov    %eax,-0x10(%rbp)
	cprintf("pid is %d\n", pid);
  80019e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001a1:	89 c6                	mov    %eax,%esi
  8001a3:	48 bf da 3e 80 00 00 	movabs $0x803eda,%rdi
  8001aa:	00 00 00 
  8001ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b2:	48 ba 79 06 80 00 00 	movabs $0x800679,%rdx
  8001b9:	00 00 00 
  8001bc:	ff d2                	callq  *%rdx
	va = 0;
  8001be:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8001c5:	00 
	kid = &envs[ENVX(pid)];
  8001c6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001c9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001ce:	48 63 d0             	movslq %eax,%rdx
  8001d1:	48 89 d0             	mov    %rdx,%rax
  8001d4:	48 c1 e0 03          	shl    $0x3,%rax
  8001d8:	48 01 d0             	add    %rdx,%rax
  8001db:	48 c1 e0 05          	shl    $0x5,%rax
  8001df:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8001e6:	00 00 00 
  8001e9:	48 01 d0             	add    %rdx,%rax
  8001ec:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	cprintf("kid is %d\n", kid-envs);
  8001f0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8001f4:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001fb:	00 00 00 
  8001fe:	48 29 c2             	sub    %rax,%rdx
  800201:	48 89 d0             	mov    %rdx,%rax
  800204:	48 c1 f8 05          	sar    $0x5,%rax
  800208:	48 89 c2             	mov    %rax,%rdx
  80020b:	48 b8 39 8e e3 38 8e 	movabs $0x8e38e38e38e38e39,%rax
  800212:	e3 38 8e 
  800215:	48 0f af c2          	imul   %rdx,%rax
  800219:	48 89 c6             	mov    %rax,%rsi
  80021c:	48 bf e5 3e 80 00 00 	movabs $0x803ee5,%rdi
  800223:	00 00 00 
  800226:	b8 00 00 00 00       	mov    $0x0,%eax
  80022b:	48 ba 79 06 80 00 00 	movabs $0x800679,%rdx
  800232:	00 00 00 
  800235:	ff d2                	callq  *%rdx
	dup(p[0], 10);
  800237:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80023a:	be 0a 00 00 00       	mov    $0xa,%esi
  80023f:	89 c7                	mov    %eax,%edi
  800241:	48 b8 69 28 80 00 00 	movabs $0x802869,%rax
  800248:	00 00 00 
  80024b:	ff d0                	callq  *%rax
	while (kid->env_status == ENV_RUNNABLE)
  80024d:	eb 16                	jmp    800265 <umain+0x222>
		dup(p[0], 10);
  80024f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800252:	be 0a 00 00 00       	mov    $0xa,%esi
  800257:	89 c7                	mov    %eax,%edi
  800259:	48 b8 69 28 80 00 00 	movabs $0x802869,%rax
  800260:	00 00 00 
  800263:	ff d0                	callq  *%rax
	cprintf("pid is %d\n", pid);
	va = 0;
	kid = &envs[ENVX(pid)];
	cprintf("kid is %d\n", kid-envs);
	dup(p[0], 10);
	while (kid->env_status == ENV_RUNNABLE)
  800265:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800269:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80026f:	83 f8 02             	cmp    $0x2,%eax
  800272:	74 db                	je     80024f <umain+0x20c>
		dup(p[0], 10);

	cprintf("child done with loop\n");
  800274:	48 bf f0 3e 80 00 00 	movabs $0x803ef0,%rdi
  80027b:	00 00 00 
  80027e:	b8 00 00 00 00       	mov    $0x0,%eax
  800283:	48 ba 79 06 80 00 00 	movabs $0x800679,%rdx
  80028a:	00 00 00 
  80028d:	ff d2                	callq  *%rdx
	if (pipeisclosed(p[0]))
  80028f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800292:	89 c7                	mov    %eax,%edi
  800294:	48 b8 9d 37 80 00 00 	movabs $0x80379d,%rax
  80029b:	00 00 00 
  80029e:	ff d0                	callq  *%rax
  8002a0:	85 c0                	test   %eax,%eax
  8002a2:	74 2a                	je     8002ce <umain+0x28b>
		panic("somehow the other end of p[0] got closed!");
  8002a4:	48 ba 08 3f 80 00 00 	movabs $0x803f08,%rdx
  8002ab:	00 00 00 
  8002ae:	be 3a 00 00 00       	mov    $0x3a,%esi
  8002b3:	48 bf a2 3e 80 00 00 	movabs $0x803ea2,%rdi
  8002ba:	00 00 00 
  8002bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c2:	48 b9 40 04 80 00 00 	movabs $0x800440,%rcx
  8002c9:	00 00 00 
  8002cc:	ff d1                	callq  *%rcx
	if ((r = fd_lookup(p[0], &fd)) < 0)
  8002ce:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8002d1:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  8002d5:	48 89 d6             	mov    %rdx,%rsi
  8002d8:	89 c7                	mov    %eax,%edi
  8002da:	48 b8 e0 25 80 00 00 	movabs $0x8025e0,%rax
  8002e1:	00 00 00 
  8002e4:	ff d0                	callq  *%rax
  8002e6:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8002e9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002ed:	79 30                	jns    80031f <umain+0x2dc>
		panic("cannot look up p[0]: %e", r);
  8002ef:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002f2:	89 c1                	mov    %eax,%ecx
  8002f4:	48 ba 32 3f 80 00 00 	movabs $0x803f32,%rdx
  8002fb:	00 00 00 
  8002fe:	be 3c 00 00 00       	mov    $0x3c,%esi
  800303:	48 bf a2 3e 80 00 00 	movabs $0x803ea2,%rdi
  80030a:	00 00 00 
  80030d:	b8 00 00 00 00       	mov    $0x0,%eax
  800312:	49 b8 40 04 80 00 00 	movabs $0x800440,%r8
  800319:	00 00 00 
  80031c:	41 ff d0             	callq  *%r8
	va = fd2data(fd);
  80031f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800323:	48 89 c7             	mov    %rax,%rdi
  800326:	48 b8 1d 25 80 00 00 	movabs $0x80251d,%rax
  80032d:	00 00 00 
  800330:	ff d0                	callq  *%rax
  800332:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	if (pageref(va) != 3+1)
  800336:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80033a:	48 89 c7             	mov    %rax,%rdi
  80033d:	48 b8 4b 34 80 00 00 	movabs $0x80344b,%rax
  800344:	00 00 00 
  800347:	ff d0                	callq  *%rax
  800349:	83 f8 04             	cmp    $0x4,%eax
  80034c:	74 1d                	je     80036b <umain+0x328>
		cprintf("\nchild detected race\n");
  80034e:	48 bf 4a 3f 80 00 00 	movabs $0x803f4a,%rdi
  800355:	00 00 00 
  800358:	b8 00 00 00 00       	mov    $0x0,%eax
  80035d:	48 ba 79 06 80 00 00 	movabs $0x800679,%rdx
  800364:	00 00 00 
  800367:	ff d2                	callq  *%rdx
  800369:	eb 20                	jmp    80038b <umain+0x348>
	else
		cprintf("\nrace didn't happen\n", max);
  80036b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80036e:	89 c6                	mov    %eax,%esi
  800370:	48 bf 60 3f 80 00 00 	movabs $0x803f60,%rdi
  800377:	00 00 00 
  80037a:	b8 00 00 00 00       	mov    $0x0,%eax
  80037f:	48 ba 79 06 80 00 00 	movabs $0x800679,%rdx
  800386:	00 00 00 
  800389:	ff d2                	callq  *%rdx
}
  80038b:	c9                   	leaveq 
  80038c:	c3                   	retq   

000000000080038d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80038d:	55                   	push   %rbp
  80038e:	48 89 e5             	mov    %rsp,%rbp
  800391:	48 83 ec 10          	sub    $0x10,%rsp
  800395:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800398:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  80039c:	48 b8 e1 1a 80 00 00 	movabs $0x801ae1,%rax
  8003a3:	00 00 00 
  8003a6:	ff d0                	callq  *%rax
  8003a8:	48 98                	cltq   
  8003aa:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003af:	48 89 c2             	mov    %rax,%rdx
  8003b2:	48 89 d0             	mov    %rdx,%rax
  8003b5:	48 c1 e0 03          	shl    $0x3,%rax
  8003b9:	48 01 d0             	add    %rdx,%rax
  8003bc:	48 c1 e0 05          	shl    $0x5,%rax
  8003c0:	48 89 c2             	mov    %rax,%rdx
  8003c3:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8003ca:	00 00 00 
  8003cd:	48 01 c2             	add    %rax,%rdx
  8003d0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8003d7:	00 00 00 
  8003da:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003e1:	7e 14                	jle    8003f7 <libmain+0x6a>
		binaryname = argv[0];
  8003e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003e7:	48 8b 10             	mov    (%rax),%rdx
  8003ea:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8003f1:	00 00 00 
  8003f4:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003fe:	48 89 d6             	mov    %rdx,%rsi
  800401:	89 c7                	mov    %eax,%edi
  800403:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80040a:	00 00 00 
  80040d:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80040f:	48 b8 1d 04 80 00 00 	movabs $0x80041d,%rax
  800416:	00 00 00 
  800419:	ff d0                	callq  *%rax
}
  80041b:	c9                   	leaveq 
  80041c:	c3                   	retq   

000000000080041d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80041d:	55                   	push   %rbp
  80041e:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800421:	48 b8 3b 28 80 00 00 	movabs $0x80283b,%rax
  800428:	00 00 00 
  80042b:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80042d:	bf 00 00 00 00       	mov    $0x0,%edi
  800432:	48 b8 9d 1a 80 00 00 	movabs $0x801a9d,%rax
  800439:	00 00 00 
  80043c:	ff d0                	callq  *%rax
}
  80043e:	5d                   	pop    %rbp
  80043f:	c3                   	retq   

0000000000800440 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800440:	55                   	push   %rbp
  800441:	48 89 e5             	mov    %rsp,%rbp
  800444:	53                   	push   %rbx
  800445:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80044c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800453:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800459:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800460:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800467:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80046e:	84 c0                	test   %al,%al
  800470:	74 23                	je     800495 <_panic+0x55>
  800472:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800479:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80047d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800481:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800485:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800489:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80048d:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800491:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800495:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80049c:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8004a3:	00 00 00 
  8004a6:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8004ad:	00 00 00 
  8004b0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004b4:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8004bb:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8004c2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8004c9:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8004d0:	00 00 00 
  8004d3:	48 8b 18             	mov    (%rax),%rbx
  8004d6:	48 b8 e1 1a 80 00 00 	movabs $0x801ae1,%rax
  8004dd:	00 00 00 
  8004e0:	ff d0                	callq  *%rax
  8004e2:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8004e8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8004ef:	41 89 c8             	mov    %ecx,%r8d
  8004f2:	48 89 d1             	mov    %rdx,%rcx
  8004f5:	48 89 da             	mov    %rbx,%rdx
  8004f8:	89 c6                	mov    %eax,%esi
  8004fa:	48 bf 80 3f 80 00 00 	movabs $0x803f80,%rdi
  800501:	00 00 00 
  800504:	b8 00 00 00 00       	mov    $0x0,%eax
  800509:	49 b9 79 06 80 00 00 	movabs $0x800679,%r9
  800510:	00 00 00 
  800513:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800516:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80051d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800524:	48 89 d6             	mov    %rdx,%rsi
  800527:	48 89 c7             	mov    %rax,%rdi
  80052a:	48 b8 cd 05 80 00 00 	movabs $0x8005cd,%rax
  800531:	00 00 00 
  800534:	ff d0                	callq  *%rax
	cprintf("\n");
  800536:	48 bf a3 3f 80 00 00 	movabs $0x803fa3,%rdi
  80053d:	00 00 00 
  800540:	b8 00 00 00 00       	mov    $0x0,%eax
  800545:	48 ba 79 06 80 00 00 	movabs $0x800679,%rdx
  80054c:	00 00 00 
  80054f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800551:	cc                   	int3   
  800552:	eb fd                	jmp    800551 <_panic+0x111>

0000000000800554 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800554:	55                   	push   %rbp
  800555:	48 89 e5             	mov    %rsp,%rbp
  800558:	48 83 ec 10          	sub    $0x10,%rsp
  80055c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80055f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800563:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800567:	8b 00                	mov    (%rax),%eax
  800569:	8d 48 01             	lea    0x1(%rax),%ecx
  80056c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800570:	89 0a                	mov    %ecx,(%rdx)
  800572:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800575:	89 d1                	mov    %edx,%ecx
  800577:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80057b:	48 98                	cltq   
  80057d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800581:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800585:	8b 00                	mov    (%rax),%eax
  800587:	3d ff 00 00 00       	cmp    $0xff,%eax
  80058c:	75 2c                	jne    8005ba <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80058e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800592:	8b 00                	mov    (%rax),%eax
  800594:	48 98                	cltq   
  800596:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80059a:	48 83 c2 08          	add    $0x8,%rdx
  80059e:	48 89 c6             	mov    %rax,%rsi
  8005a1:	48 89 d7             	mov    %rdx,%rdi
  8005a4:	48 b8 15 1a 80 00 00 	movabs $0x801a15,%rax
  8005ab:	00 00 00 
  8005ae:	ff d0                	callq  *%rax
        b->idx = 0;
  8005b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005b4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8005ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005be:	8b 40 04             	mov    0x4(%rax),%eax
  8005c1:	8d 50 01             	lea    0x1(%rax),%edx
  8005c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005c8:	89 50 04             	mov    %edx,0x4(%rax)
}
  8005cb:	c9                   	leaveq 
  8005cc:	c3                   	retq   

00000000008005cd <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8005cd:	55                   	push   %rbp
  8005ce:	48 89 e5             	mov    %rsp,%rbp
  8005d1:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8005d8:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8005df:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8005e6:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8005ed:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005f4:	48 8b 0a             	mov    (%rdx),%rcx
  8005f7:	48 89 08             	mov    %rcx,(%rax)
  8005fa:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005fe:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800602:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800606:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80060a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800611:	00 00 00 
    b.cnt = 0;
  800614:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80061b:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80061e:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800625:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80062c:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800633:	48 89 c6             	mov    %rax,%rsi
  800636:	48 bf 54 05 80 00 00 	movabs $0x800554,%rdi
  80063d:	00 00 00 
  800640:	48 b8 2c 0a 80 00 00 	movabs $0x800a2c,%rax
  800647:	00 00 00 
  80064a:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80064c:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800652:	48 98                	cltq   
  800654:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80065b:	48 83 c2 08          	add    $0x8,%rdx
  80065f:	48 89 c6             	mov    %rax,%rsi
  800662:	48 89 d7             	mov    %rdx,%rdi
  800665:	48 b8 15 1a 80 00 00 	movabs $0x801a15,%rax
  80066c:	00 00 00 
  80066f:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800671:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800677:	c9                   	leaveq 
  800678:	c3                   	retq   

0000000000800679 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800679:	55                   	push   %rbp
  80067a:	48 89 e5             	mov    %rsp,%rbp
  80067d:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800684:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80068b:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800692:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800699:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8006a0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8006a7:	84 c0                	test   %al,%al
  8006a9:	74 20                	je     8006cb <cprintf+0x52>
  8006ab:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8006af:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8006b3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8006b7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8006bb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8006bf:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8006c3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8006c7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8006cb:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8006d2:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8006d9:	00 00 00 
  8006dc:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8006e3:	00 00 00 
  8006e6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006ea:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8006f1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006f8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8006ff:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800706:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80070d:	48 8b 0a             	mov    (%rdx),%rcx
  800710:	48 89 08             	mov    %rcx,(%rax)
  800713:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800717:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80071b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80071f:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800723:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80072a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800731:	48 89 d6             	mov    %rdx,%rsi
  800734:	48 89 c7             	mov    %rax,%rdi
  800737:	48 b8 cd 05 80 00 00 	movabs $0x8005cd,%rax
  80073e:	00 00 00 
  800741:	ff d0                	callq  *%rax
  800743:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800749:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80074f:	c9                   	leaveq 
  800750:	c3                   	retq   

0000000000800751 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800751:	55                   	push   %rbp
  800752:	48 89 e5             	mov    %rsp,%rbp
  800755:	53                   	push   %rbx
  800756:	48 83 ec 38          	sub    $0x38,%rsp
  80075a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80075e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800762:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800766:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800769:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80076d:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800771:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800774:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800778:	77 3b                	ja     8007b5 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80077a:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80077d:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800781:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800784:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800788:	ba 00 00 00 00       	mov    $0x0,%edx
  80078d:	48 f7 f3             	div    %rbx
  800790:	48 89 c2             	mov    %rax,%rdx
  800793:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800796:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800799:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80079d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a1:	41 89 f9             	mov    %edi,%r9d
  8007a4:	48 89 c7             	mov    %rax,%rdi
  8007a7:	48 b8 51 07 80 00 00 	movabs $0x800751,%rax
  8007ae:	00 00 00 
  8007b1:	ff d0                	callq  *%rax
  8007b3:	eb 1e                	jmp    8007d3 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007b5:	eb 12                	jmp    8007c9 <printnum+0x78>
			putch(padc, putdat);
  8007b7:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007bb:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8007be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c2:	48 89 ce             	mov    %rcx,%rsi
  8007c5:	89 d7                	mov    %edx,%edi
  8007c7:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007c9:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8007cd:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8007d1:	7f e4                	jg     8007b7 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007d3:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8007d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007da:	ba 00 00 00 00       	mov    $0x0,%edx
  8007df:	48 f7 f1             	div    %rcx
  8007e2:	48 89 d0             	mov    %rdx,%rax
  8007e5:	48 ba b0 41 80 00 00 	movabs $0x8041b0,%rdx
  8007ec:	00 00 00 
  8007ef:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8007f3:	0f be d0             	movsbl %al,%edx
  8007f6:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fe:	48 89 ce             	mov    %rcx,%rsi
  800801:	89 d7                	mov    %edx,%edi
  800803:	ff d0                	callq  *%rax
}
  800805:	48 83 c4 38          	add    $0x38,%rsp
  800809:	5b                   	pop    %rbx
  80080a:	5d                   	pop    %rbp
  80080b:	c3                   	retq   

000000000080080c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80080c:	55                   	push   %rbp
  80080d:	48 89 e5             	mov    %rsp,%rbp
  800810:	48 83 ec 1c          	sub    $0x1c,%rsp
  800814:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800818:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80081b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80081f:	7e 52                	jle    800873 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800821:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800825:	8b 00                	mov    (%rax),%eax
  800827:	83 f8 30             	cmp    $0x30,%eax
  80082a:	73 24                	jae    800850 <getuint+0x44>
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
  80084e:	eb 17                	jmp    800867 <getuint+0x5b>
  800850:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800854:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800858:	48 89 d0             	mov    %rdx,%rax
  80085b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80085f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800863:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800867:	48 8b 00             	mov    (%rax),%rax
  80086a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80086e:	e9 a3 00 00 00       	jmpq   800916 <getuint+0x10a>
	else if (lflag)
  800873:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800877:	74 4f                	je     8008c8 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800879:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087d:	8b 00                	mov    (%rax),%eax
  80087f:	83 f8 30             	cmp    $0x30,%eax
  800882:	73 24                	jae    8008a8 <getuint+0x9c>
  800884:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800888:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80088c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800890:	8b 00                	mov    (%rax),%eax
  800892:	89 c0                	mov    %eax,%eax
  800894:	48 01 d0             	add    %rdx,%rax
  800897:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80089b:	8b 12                	mov    (%rdx),%edx
  80089d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a4:	89 0a                	mov    %ecx,(%rdx)
  8008a6:	eb 17                	jmp    8008bf <getuint+0xb3>
  8008a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ac:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008b0:	48 89 d0             	mov    %rdx,%rax
  8008b3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008bb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008bf:	48 8b 00             	mov    (%rax),%rax
  8008c2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008c6:	eb 4e                	jmp    800916 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8008c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008cc:	8b 00                	mov    (%rax),%eax
  8008ce:	83 f8 30             	cmp    $0x30,%eax
  8008d1:	73 24                	jae    8008f7 <getuint+0xeb>
  8008d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008df:	8b 00                	mov    (%rax),%eax
  8008e1:	89 c0                	mov    %eax,%eax
  8008e3:	48 01 d0             	add    %rdx,%rax
  8008e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ea:	8b 12                	mov    (%rdx),%edx
  8008ec:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f3:	89 0a                	mov    %ecx,(%rdx)
  8008f5:	eb 17                	jmp    80090e <getuint+0x102>
  8008f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008fb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008ff:	48 89 d0             	mov    %rdx,%rax
  800902:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800906:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80090a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80090e:	8b 00                	mov    (%rax),%eax
  800910:	89 c0                	mov    %eax,%eax
  800912:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800916:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80091a:	c9                   	leaveq 
  80091b:	c3                   	retq   

000000000080091c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80091c:	55                   	push   %rbp
  80091d:	48 89 e5             	mov    %rsp,%rbp
  800920:	48 83 ec 1c          	sub    $0x1c,%rsp
  800924:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800928:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80092b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80092f:	7e 52                	jle    800983 <getint+0x67>
		x=va_arg(*ap, long long);
  800931:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800935:	8b 00                	mov    (%rax),%eax
  800937:	83 f8 30             	cmp    $0x30,%eax
  80093a:	73 24                	jae    800960 <getint+0x44>
  80093c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800940:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800944:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800948:	8b 00                	mov    (%rax),%eax
  80094a:	89 c0                	mov    %eax,%eax
  80094c:	48 01 d0             	add    %rdx,%rax
  80094f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800953:	8b 12                	mov    (%rdx),%edx
  800955:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800958:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80095c:	89 0a                	mov    %ecx,(%rdx)
  80095e:	eb 17                	jmp    800977 <getint+0x5b>
  800960:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800964:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800968:	48 89 d0             	mov    %rdx,%rax
  80096b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80096f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800973:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800977:	48 8b 00             	mov    (%rax),%rax
  80097a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80097e:	e9 a3 00 00 00       	jmpq   800a26 <getint+0x10a>
	else if (lflag)
  800983:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800987:	74 4f                	je     8009d8 <getint+0xbc>
		x=va_arg(*ap, long);
  800989:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098d:	8b 00                	mov    (%rax),%eax
  80098f:	83 f8 30             	cmp    $0x30,%eax
  800992:	73 24                	jae    8009b8 <getint+0x9c>
  800994:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800998:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80099c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a0:	8b 00                	mov    (%rax),%eax
  8009a2:	89 c0                	mov    %eax,%eax
  8009a4:	48 01 d0             	add    %rdx,%rax
  8009a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ab:	8b 12                	mov    (%rdx),%edx
  8009ad:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b4:	89 0a                	mov    %ecx,(%rdx)
  8009b6:	eb 17                	jmp    8009cf <getint+0xb3>
  8009b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009bc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009c0:	48 89 d0             	mov    %rdx,%rax
  8009c3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009cb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009cf:	48 8b 00             	mov    (%rax),%rax
  8009d2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009d6:	eb 4e                	jmp    800a26 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8009d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009dc:	8b 00                	mov    (%rax),%eax
  8009de:	83 f8 30             	cmp    $0x30,%eax
  8009e1:	73 24                	jae    800a07 <getint+0xeb>
  8009e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ef:	8b 00                	mov    (%rax),%eax
  8009f1:	89 c0                	mov    %eax,%eax
  8009f3:	48 01 d0             	add    %rdx,%rax
  8009f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009fa:	8b 12                	mov    (%rdx),%edx
  8009fc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a03:	89 0a                	mov    %ecx,(%rdx)
  800a05:	eb 17                	jmp    800a1e <getint+0x102>
  800a07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a0b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a0f:	48 89 d0             	mov    %rdx,%rax
  800a12:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a16:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a1a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a1e:	8b 00                	mov    (%rax),%eax
  800a20:	48 98                	cltq   
  800a22:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a2a:	c9                   	leaveq 
  800a2b:	c3                   	retq   

0000000000800a2c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a2c:	55                   	push   %rbp
  800a2d:	48 89 e5             	mov    %rsp,%rbp
  800a30:	41 54                	push   %r12
  800a32:	53                   	push   %rbx
  800a33:	48 83 ec 60          	sub    $0x60,%rsp
  800a37:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800a3b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800a3f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a43:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800a47:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a4b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800a4f:	48 8b 0a             	mov    (%rdx),%rcx
  800a52:	48 89 08             	mov    %rcx,(%rax)
  800a55:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a59:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a5d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a61:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a65:	eb 17                	jmp    800a7e <vprintfmt+0x52>
			if (ch == '\0')
  800a67:	85 db                	test   %ebx,%ebx
  800a69:	0f 84 cc 04 00 00    	je     800f3b <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800a6f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a73:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a77:	48 89 d6             	mov    %rdx,%rsi
  800a7a:	89 df                	mov    %ebx,%edi
  800a7c:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a7e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a82:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a86:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a8a:	0f b6 00             	movzbl (%rax),%eax
  800a8d:	0f b6 d8             	movzbl %al,%ebx
  800a90:	83 fb 25             	cmp    $0x25,%ebx
  800a93:	75 d2                	jne    800a67 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a95:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a99:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800aa0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800aa7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800aae:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ab5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ab9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800abd:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800ac1:	0f b6 00             	movzbl (%rax),%eax
  800ac4:	0f b6 d8             	movzbl %al,%ebx
  800ac7:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800aca:	83 f8 55             	cmp    $0x55,%eax
  800acd:	0f 87 34 04 00 00    	ja     800f07 <vprintfmt+0x4db>
  800ad3:	89 c0                	mov    %eax,%eax
  800ad5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800adc:	00 
  800add:	48 b8 d8 41 80 00 00 	movabs $0x8041d8,%rax
  800ae4:	00 00 00 
  800ae7:	48 01 d0             	add    %rdx,%rax
  800aea:	48 8b 00             	mov    (%rax),%rax
  800aed:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800aef:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800af3:	eb c0                	jmp    800ab5 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800af5:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800af9:	eb ba                	jmp    800ab5 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800afb:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800b02:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800b05:	89 d0                	mov    %edx,%eax
  800b07:	c1 e0 02             	shl    $0x2,%eax
  800b0a:	01 d0                	add    %edx,%eax
  800b0c:	01 c0                	add    %eax,%eax
  800b0e:	01 d8                	add    %ebx,%eax
  800b10:	83 e8 30             	sub    $0x30,%eax
  800b13:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800b16:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b1a:	0f b6 00             	movzbl (%rax),%eax
  800b1d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b20:	83 fb 2f             	cmp    $0x2f,%ebx
  800b23:	7e 0c                	jle    800b31 <vprintfmt+0x105>
  800b25:	83 fb 39             	cmp    $0x39,%ebx
  800b28:	7f 07                	jg     800b31 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b2a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b2f:	eb d1                	jmp    800b02 <vprintfmt+0xd6>
			goto process_precision;
  800b31:	eb 58                	jmp    800b8b <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800b33:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b36:	83 f8 30             	cmp    $0x30,%eax
  800b39:	73 17                	jae    800b52 <vprintfmt+0x126>
  800b3b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b3f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b42:	89 c0                	mov    %eax,%eax
  800b44:	48 01 d0             	add    %rdx,%rax
  800b47:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b4a:	83 c2 08             	add    $0x8,%edx
  800b4d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b50:	eb 0f                	jmp    800b61 <vprintfmt+0x135>
  800b52:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b56:	48 89 d0             	mov    %rdx,%rax
  800b59:	48 83 c2 08          	add    $0x8,%rdx
  800b5d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b61:	8b 00                	mov    (%rax),%eax
  800b63:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b66:	eb 23                	jmp    800b8b <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800b68:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b6c:	79 0c                	jns    800b7a <vprintfmt+0x14e>
				width = 0;
  800b6e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b75:	e9 3b ff ff ff       	jmpq   800ab5 <vprintfmt+0x89>
  800b7a:	e9 36 ff ff ff       	jmpq   800ab5 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800b7f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b86:	e9 2a ff ff ff       	jmpq   800ab5 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800b8b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b8f:	79 12                	jns    800ba3 <vprintfmt+0x177>
				width = precision, precision = -1;
  800b91:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b94:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b97:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b9e:	e9 12 ff ff ff       	jmpq   800ab5 <vprintfmt+0x89>
  800ba3:	e9 0d ff ff ff       	jmpq   800ab5 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ba8:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800bac:	e9 04 ff ff ff       	jmpq   800ab5 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800bb1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bb4:	83 f8 30             	cmp    $0x30,%eax
  800bb7:	73 17                	jae    800bd0 <vprintfmt+0x1a4>
  800bb9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bbd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc0:	89 c0                	mov    %eax,%eax
  800bc2:	48 01 d0             	add    %rdx,%rax
  800bc5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bc8:	83 c2 08             	add    $0x8,%edx
  800bcb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bce:	eb 0f                	jmp    800bdf <vprintfmt+0x1b3>
  800bd0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bd4:	48 89 d0             	mov    %rdx,%rax
  800bd7:	48 83 c2 08          	add    $0x8,%rdx
  800bdb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bdf:	8b 10                	mov    (%rax),%edx
  800be1:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800be5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800be9:	48 89 ce             	mov    %rcx,%rsi
  800bec:	89 d7                	mov    %edx,%edi
  800bee:	ff d0                	callq  *%rax
			break;
  800bf0:	e9 40 03 00 00       	jmpq   800f35 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800bf5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bf8:	83 f8 30             	cmp    $0x30,%eax
  800bfb:	73 17                	jae    800c14 <vprintfmt+0x1e8>
  800bfd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c01:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c04:	89 c0                	mov    %eax,%eax
  800c06:	48 01 d0             	add    %rdx,%rax
  800c09:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c0c:	83 c2 08             	add    $0x8,%edx
  800c0f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c12:	eb 0f                	jmp    800c23 <vprintfmt+0x1f7>
  800c14:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c18:	48 89 d0             	mov    %rdx,%rax
  800c1b:	48 83 c2 08          	add    $0x8,%rdx
  800c1f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c23:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800c25:	85 db                	test   %ebx,%ebx
  800c27:	79 02                	jns    800c2b <vprintfmt+0x1ff>
				err = -err;
  800c29:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800c2b:	83 fb 15             	cmp    $0x15,%ebx
  800c2e:	7f 16                	jg     800c46 <vprintfmt+0x21a>
  800c30:	48 b8 00 41 80 00 00 	movabs $0x804100,%rax
  800c37:	00 00 00 
  800c3a:	48 63 d3             	movslq %ebx,%rdx
  800c3d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c41:	4d 85 e4             	test   %r12,%r12
  800c44:	75 2e                	jne    800c74 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800c46:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c4a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c4e:	89 d9                	mov    %ebx,%ecx
  800c50:	48 ba c1 41 80 00 00 	movabs $0x8041c1,%rdx
  800c57:	00 00 00 
  800c5a:	48 89 c7             	mov    %rax,%rdi
  800c5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c62:	49 b8 44 0f 80 00 00 	movabs $0x800f44,%r8
  800c69:	00 00 00 
  800c6c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c6f:	e9 c1 02 00 00       	jmpq   800f35 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c74:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c78:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c7c:	4c 89 e1             	mov    %r12,%rcx
  800c7f:	48 ba ca 41 80 00 00 	movabs $0x8041ca,%rdx
  800c86:	00 00 00 
  800c89:	48 89 c7             	mov    %rax,%rdi
  800c8c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c91:	49 b8 44 0f 80 00 00 	movabs $0x800f44,%r8
  800c98:	00 00 00 
  800c9b:	41 ff d0             	callq  *%r8
			break;
  800c9e:	e9 92 02 00 00       	jmpq   800f35 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800ca3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca6:	83 f8 30             	cmp    $0x30,%eax
  800ca9:	73 17                	jae    800cc2 <vprintfmt+0x296>
  800cab:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800caf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cb2:	89 c0                	mov    %eax,%eax
  800cb4:	48 01 d0             	add    %rdx,%rax
  800cb7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cba:	83 c2 08             	add    $0x8,%edx
  800cbd:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cc0:	eb 0f                	jmp    800cd1 <vprintfmt+0x2a5>
  800cc2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cc6:	48 89 d0             	mov    %rdx,%rax
  800cc9:	48 83 c2 08          	add    $0x8,%rdx
  800ccd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cd1:	4c 8b 20             	mov    (%rax),%r12
  800cd4:	4d 85 e4             	test   %r12,%r12
  800cd7:	75 0a                	jne    800ce3 <vprintfmt+0x2b7>
				p = "(null)";
  800cd9:	49 bc cd 41 80 00 00 	movabs $0x8041cd,%r12
  800ce0:	00 00 00 
			if (width > 0 && padc != '-')
  800ce3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ce7:	7e 3f                	jle    800d28 <vprintfmt+0x2fc>
  800ce9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ced:	74 39                	je     800d28 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cef:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800cf2:	48 98                	cltq   
  800cf4:	48 89 c6             	mov    %rax,%rsi
  800cf7:	4c 89 e7             	mov    %r12,%rdi
  800cfa:	48 b8 f0 11 80 00 00 	movabs $0x8011f0,%rax
  800d01:	00 00 00 
  800d04:	ff d0                	callq  *%rax
  800d06:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800d09:	eb 17                	jmp    800d22 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800d0b:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800d0f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d13:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d17:	48 89 ce             	mov    %rcx,%rsi
  800d1a:	89 d7                	mov    %edx,%edi
  800d1c:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d1e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d22:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d26:	7f e3                	jg     800d0b <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d28:	eb 37                	jmp    800d61 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800d2a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800d2e:	74 1e                	je     800d4e <vprintfmt+0x322>
  800d30:	83 fb 1f             	cmp    $0x1f,%ebx
  800d33:	7e 05                	jle    800d3a <vprintfmt+0x30e>
  800d35:	83 fb 7e             	cmp    $0x7e,%ebx
  800d38:	7e 14                	jle    800d4e <vprintfmt+0x322>
					putch('?', putdat);
  800d3a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d3e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d42:	48 89 d6             	mov    %rdx,%rsi
  800d45:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d4a:	ff d0                	callq  *%rax
  800d4c:	eb 0f                	jmp    800d5d <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800d4e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d52:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d56:	48 89 d6             	mov    %rdx,%rsi
  800d59:	89 df                	mov    %ebx,%edi
  800d5b:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d5d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d61:	4c 89 e0             	mov    %r12,%rax
  800d64:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d68:	0f b6 00             	movzbl (%rax),%eax
  800d6b:	0f be d8             	movsbl %al,%ebx
  800d6e:	85 db                	test   %ebx,%ebx
  800d70:	74 10                	je     800d82 <vprintfmt+0x356>
  800d72:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d76:	78 b2                	js     800d2a <vprintfmt+0x2fe>
  800d78:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d7c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d80:	79 a8                	jns    800d2a <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d82:	eb 16                	jmp    800d9a <vprintfmt+0x36e>
				putch(' ', putdat);
  800d84:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d88:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d8c:	48 89 d6             	mov    %rdx,%rsi
  800d8f:	bf 20 00 00 00       	mov    $0x20,%edi
  800d94:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d96:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d9a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d9e:	7f e4                	jg     800d84 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800da0:	e9 90 01 00 00       	jmpq   800f35 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800da5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800da9:	be 03 00 00 00       	mov    $0x3,%esi
  800dae:	48 89 c7             	mov    %rax,%rdi
  800db1:	48 b8 1c 09 80 00 00 	movabs $0x80091c,%rax
  800db8:	00 00 00 
  800dbb:	ff d0                	callq  *%rax
  800dbd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800dc1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dc5:	48 85 c0             	test   %rax,%rax
  800dc8:	79 1d                	jns    800de7 <vprintfmt+0x3bb>
				putch('-', putdat);
  800dca:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dce:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dd2:	48 89 d6             	mov    %rdx,%rsi
  800dd5:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800dda:	ff d0                	callq  *%rax
				num = -(long long) num;
  800ddc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800de0:	48 f7 d8             	neg    %rax
  800de3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800de7:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800dee:	e9 d5 00 00 00       	jmpq   800ec8 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800df3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800df7:	be 03 00 00 00       	mov    $0x3,%esi
  800dfc:	48 89 c7             	mov    %rax,%rdi
  800dff:	48 b8 0c 08 80 00 00 	movabs $0x80080c,%rax
  800e06:	00 00 00 
  800e09:	ff d0                	callq  *%rax
  800e0b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800e0f:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e16:	e9 ad 00 00 00       	jmpq   800ec8 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  800e1b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e1f:	be 03 00 00 00       	mov    $0x3,%esi
  800e24:	48 89 c7             	mov    %rax,%rdi
  800e27:	48 b8 0c 08 80 00 00 	movabs $0x80080c,%rax
  800e2e:	00 00 00 
  800e31:	ff d0                	callq  *%rax
  800e33:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  800e37:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  800e3e:	e9 85 00 00 00       	jmpq   800ec8 <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  800e43:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e47:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e4b:	48 89 d6             	mov    %rdx,%rsi
  800e4e:	bf 30 00 00 00       	mov    $0x30,%edi
  800e53:	ff d0                	callq  *%rax
			putch('x', putdat);
  800e55:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e59:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e5d:	48 89 d6             	mov    %rdx,%rsi
  800e60:	bf 78 00 00 00       	mov    $0x78,%edi
  800e65:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e67:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e6a:	83 f8 30             	cmp    $0x30,%eax
  800e6d:	73 17                	jae    800e86 <vprintfmt+0x45a>
  800e6f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e73:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e76:	89 c0                	mov    %eax,%eax
  800e78:	48 01 d0             	add    %rdx,%rax
  800e7b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e7e:	83 c2 08             	add    $0x8,%edx
  800e81:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e84:	eb 0f                	jmp    800e95 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800e86:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e8a:	48 89 d0             	mov    %rdx,%rax
  800e8d:	48 83 c2 08          	add    $0x8,%rdx
  800e91:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e95:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e98:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e9c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800ea3:	eb 23                	jmp    800ec8 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800ea5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ea9:	be 03 00 00 00       	mov    $0x3,%esi
  800eae:	48 89 c7             	mov    %rax,%rdi
  800eb1:	48 b8 0c 08 80 00 00 	movabs $0x80080c,%rax
  800eb8:	00 00 00 
  800ebb:	ff d0                	callq  *%rax
  800ebd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ec1:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ec8:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ecd:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ed0:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ed3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ed7:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800edb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800edf:	45 89 c1             	mov    %r8d,%r9d
  800ee2:	41 89 f8             	mov    %edi,%r8d
  800ee5:	48 89 c7             	mov    %rax,%rdi
  800ee8:	48 b8 51 07 80 00 00 	movabs $0x800751,%rax
  800eef:	00 00 00 
  800ef2:	ff d0                	callq  *%rax
			break;
  800ef4:	eb 3f                	jmp    800f35 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ef6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800efa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800efe:	48 89 d6             	mov    %rdx,%rsi
  800f01:	89 df                	mov    %ebx,%edi
  800f03:	ff d0                	callq  *%rax
			break;
  800f05:	eb 2e                	jmp    800f35 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f07:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f0b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f0f:	48 89 d6             	mov    %rdx,%rsi
  800f12:	bf 25 00 00 00       	mov    $0x25,%edi
  800f17:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f19:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f1e:	eb 05                	jmp    800f25 <vprintfmt+0x4f9>
  800f20:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f25:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f29:	48 83 e8 01          	sub    $0x1,%rax
  800f2d:	0f b6 00             	movzbl (%rax),%eax
  800f30:	3c 25                	cmp    $0x25,%al
  800f32:	75 ec                	jne    800f20 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800f34:	90                   	nop
		}
	}
  800f35:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f36:	e9 43 fb ff ff       	jmpq   800a7e <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800f3b:	48 83 c4 60          	add    $0x60,%rsp
  800f3f:	5b                   	pop    %rbx
  800f40:	41 5c                	pop    %r12
  800f42:	5d                   	pop    %rbp
  800f43:	c3                   	retq   

0000000000800f44 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f44:	55                   	push   %rbp
  800f45:	48 89 e5             	mov    %rsp,%rbp
  800f48:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f4f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f56:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f5d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f64:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f6b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f72:	84 c0                	test   %al,%al
  800f74:	74 20                	je     800f96 <printfmt+0x52>
  800f76:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f7a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f7e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f82:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f86:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f8a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f8e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f92:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f96:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f9d:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800fa4:	00 00 00 
  800fa7:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800fae:	00 00 00 
  800fb1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fb5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800fbc:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fc3:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800fca:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800fd1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800fd8:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800fdf:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800fe6:	48 89 c7             	mov    %rax,%rdi
  800fe9:	48 b8 2c 0a 80 00 00 	movabs $0x800a2c,%rax
  800ff0:	00 00 00 
  800ff3:	ff d0                	callq  *%rax
	va_end(ap);
}
  800ff5:	c9                   	leaveq 
  800ff6:	c3                   	retq   

0000000000800ff7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ff7:	55                   	push   %rbp
  800ff8:	48 89 e5             	mov    %rsp,%rbp
  800ffb:	48 83 ec 10          	sub    $0x10,%rsp
  800fff:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801002:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801006:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80100a:	8b 40 10             	mov    0x10(%rax),%eax
  80100d:	8d 50 01             	lea    0x1(%rax),%edx
  801010:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801014:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801017:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80101b:	48 8b 10             	mov    (%rax),%rdx
  80101e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801022:	48 8b 40 08          	mov    0x8(%rax),%rax
  801026:	48 39 c2             	cmp    %rax,%rdx
  801029:	73 17                	jae    801042 <sprintputch+0x4b>
		*b->buf++ = ch;
  80102b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80102f:	48 8b 00             	mov    (%rax),%rax
  801032:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801036:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80103a:	48 89 0a             	mov    %rcx,(%rdx)
  80103d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801040:	88 10                	mov    %dl,(%rax)
}
  801042:	c9                   	leaveq 
  801043:	c3                   	retq   

0000000000801044 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801044:	55                   	push   %rbp
  801045:	48 89 e5             	mov    %rsp,%rbp
  801048:	48 83 ec 50          	sub    $0x50,%rsp
  80104c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801050:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801053:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801057:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80105b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80105f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801063:	48 8b 0a             	mov    (%rdx),%rcx
  801066:	48 89 08             	mov    %rcx,(%rax)
  801069:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80106d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801071:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801075:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801079:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80107d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801081:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801084:	48 98                	cltq   
  801086:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80108a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80108e:	48 01 d0             	add    %rdx,%rax
  801091:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801095:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80109c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8010a1:	74 06                	je     8010a9 <vsnprintf+0x65>
  8010a3:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8010a7:	7f 07                	jg     8010b0 <vsnprintf+0x6c>
		return -E_INVAL;
  8010a9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010ae:	eb 2f                	jmp    8010df <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8010b0:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8010b4:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8010b8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8010bc:	48 89 c6             	mov    %rax,%rsi
  8010bf:	48 bf f7 0f 80 00 00 	movabs $0x800ff7,%rdi
  8010c6:	00 00 00 
  8010c9:	48 b8 2c 0a 80 00 00 	movabs $0x800a2c,%rax
  8010d0:	00 00 00 
  8010d3:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8010d5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8010d9:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8010dc:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8010df:	c9                   	leaveq 
  8010e0:	c3                   	retq   

00000000008010e1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010e1:	55                   	push   %rbp
  8010e2:	48 89 e5             	mov    %rsp,%rbp
  8010e5:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8010ec:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8010f3:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8010f9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801100:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801107:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80110e:	84 c0                	test   %al,%al
  801110:	74 20                	je     801132 <snprintf+0x51>
  801112:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801116:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80111a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80111e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801122:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801126:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80112a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80112e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801132:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801139:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801140:	00 00 00 
  801143:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80114a:	00 00 00 
  80114d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801151:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801158:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80115f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801166:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80116d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801174:	48 8b 0a             	mov    (%rdx),%rcx
  801177:	48 89 08             	mov    %rcx,(%rax)
  80117a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80117e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801182:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801186:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80118a:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801191:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801198:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80119e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8011a5:	48 89 c7             	mov    %rax,%rdi
  8011a8:	48 b8 44 10 80 00 00 	movabs $0x801044,%rax
  8011af:	00 00 00 
  8011b2:	ff d0                	callq  *%rax
  8011b4:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8011ba:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8011c0:	c9                   	leaveq 
  8011c1:	c3                   	retq   

00000000008011c2 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8011c2:	55                   	push   %rbp
  8011c3:	48 89 e5             	mov    %rsp,%rbp
  8011c6:	48 83 ec 18          	sub    $0x18,%rsp
  8011ca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8011ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011d5:	eb 09                	jmp    8011e0 <strlen+0x1e>
		n++;
  8011d7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011db:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e4:	0f b6 00             	movzbl (%rax),%eax
  8011e7:	84 c0                	test   %al,%al
  8011e9:	75 ec                	jne    8011d7 <strlen+0x15>
		n++;
	return n;
  8011eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011ee:	c9                   	leaveq 
  8011ef:	c3                   	retq   

00000000008011f0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8011f0:	55                   	push   %rbp
  8011f1:	48 89 e5             	mov    %rsp,%rbp
  8011f4:	48 83 ec 20          	sub    $0x20,%rsp
  8011f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801200:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801207:	eb 0e                	jmp    801217 <strnlen+0x27>
		n++;
  801209:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80120d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801212:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801217:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80121c:	74 0b                	je     801229 <strnlen+0x39>
  80121e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801222:	0f b6 00             	movzbl (%rax),%eax
  801225:	84 c0                	test   %al,%al
  801227:	75 e0                	jne    801209 <strnlen+0x19>
		n++;
	return n;
  801229:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80122c:	c9                   	leaveq 
  80122d:	c3                   	retq   

000000000080122e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80122e:	55                   	push   %rbp
  80122f:	48 89 e5             	mov    %rsp,%rbp
  801232:	48 83 ec 20          	sub    $0x20,%rsp
  801236:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80123a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80123e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801242:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801246:	90                   	nop
  801247:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80124b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80124f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801253:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801257:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80125b:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80125f:	0f b6 12             	movzbl (%rdx),%edx
  801262:	88 10                	mov    %dl,(%rax)
  801264:	0f b6 00             	movzbl (%rax),%eax
  801267:	84 c0                	test   %al,%al
  801269:	75 dc                	jne    801247 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80126b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80126f:	c9                   	leaveq 
  801270:	c3                   	retq   

0000000000801271 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801271:	55                   	push   %rbp
  801272:	48 89 e5             	mov    %rsp,%rbp
  801275:	48 83 ec 20          	sub    $0x20,%rsp
  801279:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80127d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801281:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801285:	48 89 c7             	mov    %rax,%rdi
  801288:	48 b8 c2 11 80 00 00 	movabs $0x8011c2,%rax
  80128f:	00 00 00 
  801292:	ff d0                	callq  *%rax
  801294:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801297:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80129a:	48 63 d0             	movslq %eax,%rdx
  80129d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a1:	48 01 c2             	add    %rax,%rdx
  8012a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012a8:	48 89 c6             	mov    %rax,%rsi
  8012ab:	48 89 d7             	mov    %rdx,%rdi
  8012ae:	48 b8 2e 12 80 00 00 	movabs $0x80122e,%rax
  8012b5:	00 00 00 
  8012b8:	ff d0                	callq  *%rax
	return dst;
  8012ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012be:	c9                   	leaveq 
  8012bf:	c3                   	retq   

00000000008012c0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8012c0:	55                   	push   %rbp
  8012c1:	48 89 e5             	mov    %rsp,%rbp
  8012c4:	48 83 ec 28          	sub    $0x28,%rsp
  8012c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012cc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012d0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8012d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8012dc:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8012e3:	00 
  8012e4:	eb 2a                	jmp    801310 <strncpy+0x50>
		*dst++ = *src;
  8012e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ea:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012ee:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012f2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012f6:	0f b6 12             	movzbl (%rdx),%edx
  8012f9:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012ff:	0f b6 00             	movzbl (%rax),%eax
  801302:	84 c0                	test   %al,%al
  801304:	74 05                	je     80130b <strncpy+0x4b>
			src++;
  801306:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80130b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801310:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801314:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801318:	72 cc                	jb     8012e6 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80131a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80131e:	c9                   	leaveq 
  80131f:	c3                   	retq   

0000000000801320 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801320:	55                   	push   %rbp
  801321:	48 89 e5             	mov    %rsp,%rbp
  801324:	48 83 ec 28          	sub    $0x28,%rsp
  801328:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80132c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801330:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801334:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801338:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80133c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801341:	74 3d                	je     801380 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801343:	eb 1d                	jmp    801362 <strlcpy+0x42>
			*dst++ = *src++;
  801345:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801349:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80134d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801351:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801355:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801359:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80135d:	0f b6 12             	movzbl (%rdx),%edx
  801360:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801362:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801367:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80136c:	74 0b                	je     801379 <strlcpy+0x59>
  80136e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801372:	0f b6 00             	movzbl (%rax),%eax
  801375:	84 c0                	test   %al,%al
  801377:	75 cc                	jne    801345 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801379:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80137d:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801380:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801384:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801388:	48 29 c2             	sub    %rax,%rdx
  80138b:	48 89 d0             	mov    %rdx,%rax
}
  80138e:	c9                   	leaveq 
  80138f:	c3                   	retq   

0000000000801390 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801390:	55                   	push   %rbp
  801391:	48 89 e5             	mov    %rsp,%rbp
  801394:	48 83 ec 10          	sub    $0x10,%rsp
  801398:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80139c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8013a0:	eb 0a                	jmp    8013ac <strcmp+0x1c>
		p++, q++;
  8013a2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013a7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b0:	0f b6 00             	movzbl (%rax),%eax
  8013b3:	84 c0                	test   %al,%al
  8013b5:	74 12                	je     8013c9 <strcmp+0x39>
  8013b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013bb:	0f b6 10             	movzbl (%rax),%edx
  8013be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c2:	0f b6 00             	movzbl (%rax),%eax
  8013c5:	38 c2                	cmp    %al,%dl
  8013c7:	74 d9                	je     8013a2 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013cd:	0f b6 00             	movzbl (%rax),%eax
  8013d0:	0f b6 d0             	movzbl %al,%edx
  8013d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013d7:	0f b6 00             	movzbl (%rax),%eax
  8013da:	0f b6 c0             	movzbl %al,%eax
  8013dd:	29 c2                	sub    %eax,%edx
  8013df:	89 d0                	mov    %edx,%eax
}
  8013e1:	c9                   	leaveq 
  8013e2:	c3                   	retq   

00000000008013e3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8013e3:	55                   	push   %rbp
  8013e4:	48 89 e5             	mov    %rsp,%rbp
  8013e7:	48 83 ec 18          	sub    $0x18,%rsp
  8013eb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013ef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013f3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8013f7:	eb 0f                	jmp    801408 <strncmp+0x25>
		n--, p++, q++;
  8013f9:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8013fe:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801403:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801408:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80140d:	74 1d                	je     80142c <strncmp+0x49>
  80140f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801413:	0f b6 00             	movzbl (%rax),%eax
  801416:	84 c0                	test   %al,%al
  801418:	74 12                	je     80142c <strncmp+0x49>
  80141a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80141e:	0f b6 10             	movzbl (%rax),%edx
  801421:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801425:	0f b6 00             	movzbl (%rax),%eax
  801428:	38 c2                	cmp    %al,%dl
  80142a:	74 cd                	je     8013f9 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80142c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801431:	75 07                	jne    80143a <strncmp+0x57>
		return 0;
  801433:	b8 00 00 00 00       	mov    $0x0,%eax
  801438:	eb 18                	jmp    801452 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80143a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80143e:	0f b6 00             	movzbl (%rax),%eax
  801441:	0f b6 d0             	movzbl %al,%edx
  801444:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801448:	0f b6 00             	movzbl (%rax),%eax
  80144b:	0f b6 c0             	movzbl %al,%eax
  80144e:	29 c2                	sub    %eax,%edx
  801450:	89 d0                	mov    %edx,%eax
}
  801452:	c9                   	leaveq 
  801453:	c3                   	retq   

0000000000801454 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801454:	55                   	push   %rbp
  801455:	48 89 e5             	mov    %rsp,%rbp
  801458:	48 83 ec 0c          	sub    $0xc,%rsp
  80145c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801460:	89 f0                	mov    %esi,%eax
  801462:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801465:	eb 17                	jmp    80147e <strchr+0x2a>
		if (*s == c)
  801467:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80146b:	0f b6 00             	movzbl (%rax),%eax
  80146e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801471:	75 06                	jne    801479 <strchr+0x25>
			return (char *) s;
  801473:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801477:	eb 15                	jmp    80148e <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801479:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80147e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801482:	0f b6 00             	movzbl (%rax),%eax
  801485:	84 c0                	test   %al,%al
  801487:	75 de                	jne    801467 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801489:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80148e:	c9                   	leaveq 
  80148f:	c3                   	retq   

0000000000801490 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801490:	55                   	push   %rbp
  801491:	48 89 e5             	mov    %rsp,%rbp
  801494:	48 83 ec 0c          	sub    $0xc,%rsp
  801498:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80149c:	89 f0                	mov    %esi,%eax
  80149e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8014a1:	eb 13                	jmp    8014b6 <strfind+0x26>
		if (*s == c)
  8014a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a7:	0f b6 00             	movzbl (%rax),%eax
  8014aa:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8014ad:	75 02                	jne    8014b1 <strfind+0x21>
			break;
  8014af:	eb 10                	jmp    8014c1 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014b1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ba:	0f b6 00             	movzbl (%rax),%eax
  8014bd:	84 c0                	test   %al,%al
  8014bf:	75 e2                	jne    8014a3 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8014c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014c5:	c9                   	leaveq 
  8014c6:	c3                   	retq   

00000000008014c7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8014c7:	55                   	push   %rbp
  8014c8:	48 89 e5             	mov    %rsp,%rbp
  8014cb:	48 83 ec 18          	sub    $0x18,%rsp
  8014cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014d3:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8014d6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8014da:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014df:	75 06                	jne    8014e7 <memset+0x20>
		return v;
  8014e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e5:	eb 69                	jmp    801550 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8014e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014eb:	83 e0 03             	and    $0x3,%eax
  8014ee:	48 85 c0             	test   %rax,%rax
  8014f1:	75 48                	jne    80153b <memset+0x74>
  8014f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014f7:	83 e0 03             	and    $0x3,%eax
  8014fa:	48 85 c0             	test   %rax,%rax
  8014fd:	75 3c                	jne    80153b <memset+0x74>
		c &= 0xFF;
  8014ff:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801506:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801509:	c1 e0 18             	shl    $0x18,%eax
  80150c:	89 c2                	mov    %eax,%edx
  80150e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801511:	c1 e0 10             	shl    $0x10,%eax
  801514:	09 c2                	or     %eax,%edx
  801516:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801519:	c1 e0 08             	shl    $0x8,%eax
  80151c:	09 d0                	or     %edx,%eax
  80151e:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801521:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801525:	48 c1 e8 02          	shr    $0x2,%rax
  801529:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80152c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801530:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801533:	48 89 d7             	mov    %rdx,%rdi
  801536:	fc                   	cld    
  801537:	f3 ab                	rep stos %eax,%es:(%rdi)
  801539:	eb 11                	jmp    80154c <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80153b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80153f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801542:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801546:	48 89 d7             	mov    %rdx,%rdi
  801549:	fc                   	cld    
  80154a:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80154c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801550:	c9                   	leaveq 
  801551:	c3                   	retq   

0000000000801552 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801552:	55                   	push   %rbp
  801553:	48 89 e5             	mov    %rsp,%rbp
  801556:	48 83 ec 28          	sub    $0x28,%rsp
  80155a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80155e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801562:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801566:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80156a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80156e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801572:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801576:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80157a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80157e:	0f 83 88 00 00 00    	jae    80160c <memmove+0xba>
  801584:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801588:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80158c:	48 01 d0             	add    %rdx,%rax
  80158f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801593:	76 77                	jbe    80160c <memmove+0xba>
		s += n;
  801595:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801599:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80159d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a1:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a9:	83 e0 03             	and    $0x3,%eax
  8015ac:	48 85 c0             	test   %rax,%rax
  8015af:	75 3b                	jne    8015ec <memmove+0x9a>
  8015b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b5:	83 e0 03             	and    $0x3,%eax
  8015b8:	48 85 c0             	test   %rax,%rax
  8015bb:	75 2f                	jne    8015ec <memmove+0x9a>
  8015bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c1:	83 e0 03             	and    $0x3,%eax
  8015c4:	48 85 c0             	test   %rax,%rax
  8015c7:	75 23                	jne    8015ec <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8015c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015cd:	48 83 e8 04          	sub    $0x4,%rax
  8015d1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015d5:	48 83 ea 04          	sub    $0x4,%rdx
  8015d9:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015dd:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8015e1:	48 89 c7             	mov    %rax,%rdi
  8015e4:	48 89 d6             	mov    %rdx,%rsi
  8015e7:	fd                   	std    
  8015e8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015ea:	eb 1d                	jmp    801609 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8015ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015f0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f8:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8015fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801600:	48 89 d7             	mov    %rdx,%rdi
  801603:	48 89 c1             	mov    %rax,%rcx
  801606:	fd                   	std    
  801607:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801609:	fc                   	cld    
  80160a:	eb 57                	jmp    801663 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80160c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801610:	83 e0 03             	and    $0x3,%eax
  801613:	48 85 c0             	test   %rax,%rax
  801616:	75 36                	jne    80164e <memmove+0xfc>
  801618:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80161c:	83 e0 03             	and    $0x3,%eax
  80161f:	48 85 c0             	test   %rax,%rax
  801622:	75 2a                	jne    80164e <memmove+0xfc>
  801624:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801628:	83 e0 03             	and    $0x3,%eax
  80162b:	48 85 c0             	test   %rax,%rax
  80162e:	75 1e                	jne    80164e <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801630:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801634:	48 c1 e8 02          	shr    $0x2,%rax
  801638:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80163b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80163f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801643:	48 89 c7             	mov    %rax,%rdi
  801646:	48 89 d6             	mov    %rdx,%rsi
  801649:	fc                   	cld    
  80164a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80164c:	eb 15                	jmp    801663 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80164e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801652:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801656:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80165a:	48 89 c7             	mov    %rax,%rdi
  80165d:	48 89 d6             	mov    %rdx,%rsi
  801660:	fc                   	cld    
  801661:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801663:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801667:	c9                   	leaveq 
  801668:	c3                   	retq   

0000000000801669 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801669:	55                   	push   %rbp
  80166a:	48 89 e5             	mov    %rsp,%rbp
  80166d:	48 83 ec 18          	sub    $0x18,%rsp
  801671:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801675:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801679:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80167d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801681:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801685:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801689:	48 89 ce             	mov    %rcx,%rsi
  80168c:	48 89 c7             	mov    %rax,%rdi
  80168f:	48 b8 52 15 80 00 00 	movabs $0x801552,%rax
  801696:	00 00 00 
  801699:	ff d0                	callq  *%rax
}
  80169b:	c9                   	leaveq 
  80169c:	c3                   	retq   

000000000080169d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80169d:	55                   	push   %rbp
  80169e:	48 89 e5             	mov    %rsp,%rbp
  8016a1:	48 83 ec 28          	sub    $0x28,%rsp
  8016a5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016a9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8016ad:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8016b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8016b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016bd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8016c1:	eb 36                	jmp    8016f9 <memcmp+0x5c>
		if (*s1 != *s2)
  8016c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016c7:	0f b6 10             	movzbl (%rax),%edx
  8016ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ce:	0f b6 00             	movzbl (%rax),%eax
  8016d1:	38 c2                	cmp    %al,%dl
  8016d3:	74 1a                	je     8016ef <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8016d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016d9:	0f b6 00             	movzbl (%rax),%eax
  8016dc:	0f b6 d0             	movzbl %al,%edx
  8016df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016e3:	0f b6 00             	movzbl (%rax),%eax
  8016e6:	0f b6 c0             	movzbl %al,%eax
  8016e9:	29 c2                	sub    %eax,%edx
  8016eb:	89 d0                	mov    %edx,%eax
  8016ed:	eb 20                	jmp    80170f <memcmp+0x72>
		s1++, s2++;
  8016ef:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016f4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8016f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016fd:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801701:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801705:	48 85 c0             	test   %rax,%rax
  801708:	75 b9                	jne    8016c3 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80170a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80170f:	c9                   	leaveq 
  801710:	c3                   	retq   

0000000000801711 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801711:	55                   	push   %rbp
  801712:	48 89 e5             	mov    %rsp,%rbp
  801715:	48 83 ec 28          	sub    $0x28,%rsp
  801719:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80171d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801720:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801724:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801728:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80172c:	48 01 d0             	add    %rdx,%rax
  80172f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801733:	eb 15                	jmp    80174a <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801735:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801739:	0f b6 10             	movzbl (%rax),%edx
  80173c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80173f:	38 c2                	cmp    %al,%dl
  801741:	75 02                	jne    801745 <memfind+0x34>
			break;
  801743:	eb 0f                	jmp    801754 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801745:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80174a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80174e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801752:	72 e1                	jb     801735 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801754:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801758:	c9                   	leaveq 
  801759:	c3                   	retq   

000000000080175a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80175a:	55                   	push   %rbp
  80175b:	48 89 e5             	mov    %rsp,%rbp
  80175e:	48 83 ec 34          	sub    $0x34,%rsp
  801762:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801766:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80176a:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80176d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801774:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80177b:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80177c:	eb 05                	jmp    801783 <strtol+0x29>
		s++;
  80177e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801783:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801787:	0f b6 00             	movzbl (%rax),%eax
  80178a:	3c 20                	cmp    $0x20,%al
  80178c:	74 f0                	je     80177e <strtol+0x24>
  80178e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801792:	0f b6 00             	movzbl (%rax),%eax
  801795:	3c 09                	cmp    $0x9,%al
  801797:	74 e5                	je     80177e <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801799:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179d:	0f b6 00             	movzbl (%rax),%eax
  8017a0:	3c 2b                	cmp    $0x2b,%al
  8017a2:	75 07                	jne    8017ab <strtol+0x51>
		s++;
  8017a4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017a9:	eb 17                	jmp    8017c2 <strtol+0x68>
	else if (*s == '-')
  8017ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017af:	0f b6 00             	movzbl (%rax),%eax
  8017b2:	3c 2d                	cmp    $0x2d,%al
  8017b4:	75 0c                	jne    8017c2 <strtol+0x68>
		s++, neg = 1;
  8017b6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017bb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017c2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017c6:	74 06                	je     8017ce <strtol+0x74>
  8017c8:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8017cc:	75 28                	jne    8017f6 <strtol+0x9c>
  8017ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d2:	0f b6 00             	movzbl (%rax),%eax
  8017d5:	3c 30                	cmp    $0x30,%al
  8017d7:	75 1d                	jne    8017f6 <strtol+0x9c>
  8017d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017dd:	48 83 c0 01          	add    $0x1,%rax
  8017e1:	0f b6 00             	movzbl (%rax),%eax
  8017e4:	3c 78                	cmp    $0x78,%al
  8017e6:	75 0e                	jne    8017f6 <strtol+0x9c>
		s += 2, base = 16;
  8017e8:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8017ed:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8017f4:	eb 2c                	jmp    801822 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8017f6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017fa:	75 19                	jne    801815 <strtol+0xbb>
  8017fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801800:	0f b6 00             	movzbl (%rax),%eax
  801803:	3c 30                	cmp    $0x30,%al
  801805:	75 0e                	jne    801815 <strtol+0xbb>
		s++, base = 8;
  801807:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80180c:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801813:	eb 0d                	jmp    801822 <strtol+0xc8>
	else if (base == 0)
  801815:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801819:	75 07                	jne    801822 <strtol+0xc8>
		base = 10;
  80181b:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801822:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801826:	0f b6 00             	movzbl (%rax),%eax
  801829:	3c 2f                	cmp    $0x2f,%al
  80182b:	7e 1d                	jle    80184a <strtol+0xf0>
  80182d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801831:	0f b6 00             	movzbl (%rax),%eax
  801834:	3c 39                	cmp    $0x39,%al
  801836:	7f 12                	jg     80184a <strtol+0xf0>
			dig = *s - '0';
  801838:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80183c:	0f b6 00             	movzbl (%rax),%eax
  80183f:	0f be c0             	movsbl %al,%eax
  801842:	83 e8 30             	sub    $0x30,%eax
  801845:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801848:	eb 4e                	jmp    801898 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80184a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80184e:	0f b6 00             	movzbl (%rax),%eax
  801851:	3c 60                	cmp    $0x60,%al
  801853:	7e 1d                	jle    801872 <strtol+0x118>
  801855:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801859:	0f b6 00             	movzbl (%rax),%eax
  80185c:	3c 7a                	cmp    $0x7a,%al
  80185e:	7f 12                	jg     801872 <strtol+0x118>
			dig = *s - 'a' + 10;
  801860:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801864:	0f b6 00             	movzbl (%rax),%eax
  801867:	0f be c0             	movsbl %al,%eax
  80186a:	83 e8 57             	sub    $0x57,%eax
  80186d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801870:	eb 26                	jmp    801898 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801872:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801876:	0f b6 00             	movzbl (%rax),%eax
  801879:	3c 40                	cmp    $0x40,%al
  80187b:	7e 48                	jle    8018c5 <strtol+0x16b>
  80187d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801881:	0f b6 00             	movzbl (%rax),%eax
  801884:	3c 5a                	cmp    $0x5a,%al
  801886:	7f 3d                	jg     8018c5 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801888:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80188c:	0f b6 00             	movzbl (%rax),%eax
  80188f:	0f be c0             	movsbl %al,%eax
  801892:	83 e8 37             	sub    $0x37,%eax
  801895:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801898:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80189b:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80189e:	7c 02                	jl     8018a2 <strtol+0x148>
			break;
  8018a0:	eb 23                	jmp    8018c5 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8018a2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018a7:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8018aa:	48 98                	cltq   
  8018ac:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8018b1:	48 89 c2             	mov    %rax,%rdx
  8018b4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018b7:	48 98                	cltq   
  8018b9:	48 01 d0             	add    %rdx,%rax
  8018bc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8018c0:	e9 5d ff ff ff       	jmpq   801822 <strtol+0xc8>

	if (endptr)
  8018c5:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8018ca:	74 0b                	je     8018d7 <strtol+0x17d>
		*endptr = (char *) s;
  8018cc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018d0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8018d4:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8018d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018db:	74 09                	je     8018e6 <strtol+0x18c>
  8018dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018e1:	48 f7 d8             	neg    %rax
  8018e4:	eb 04                	jmp    8018ea <strtol+0x190>
  8018e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8018ea:	c9                   	leaveq 
  8018eb:	c3                   	retq   

00000000008018ec <strstr>:

char * strstr(const char *in, const char *str)
{
  8018ec:	55                   	push   %rbp
  8018ed:	48 89 e5             	mov    %rsp,%rbp
  8018f0:	48 83 ec 30          	sub    $0x30,%rsp
  8018f4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018f8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8018fc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801900:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801904:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801908:	0f b6 00             	movzbl (%rax),%eax
  80190b:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80190e:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801912:	75 06                	jne    80191a <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801914:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801918:	eb 6b                	jmp    801985 <strstr+0x99>

	len = strlen(str);
  80191a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80191e:	48 89 c7             	mov    %rax,%rdi
  801921:	48 b8 c2 11 80 00 00 	movabs $0x8011c2,%rax
  801928:	00 00 00 
  80192b:	ff d0                	callq  *%rax
  80192d:	48 98                	cltq   
  80192f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801933:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801937:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80193b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80193f:	0f b6 00             	movzbl (%rax),%eax
  801942:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801945:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801949:	75 07                	jne    801952 <strstr+0x66>
				return (char *) 0;
  80194b:	b8 00 00 00 00       	mov    $0x0,%eax
  801950:	eb 33                	jmp    801985 <strstr+0x99>
		} while (sc != c);
  801952:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801956:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801959:	75 d8                	jne    801933 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80195b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80195f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801963:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801967:	48 89 ce             	mov    %rcx,%rsi
  80196a:	48 89 c7             	mov    %rax,%rdi
  80196d:	48 b8 e3 13 80 00 00 	movabs $0x8013e3,%rax
  801974:	00 00 00 
  801977:	ff d0                	callq  *%rax
  801979:	85 c0                	test   %eax,%eax
  80197b:	75 b6                	jne    801933 <strstr+0x47>

	return (char *) (in - 1);
  80197d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801981:	48 83 e8 01          	sub    $0x1,%rax
}
  801985:	c9                   	leaveq 
  801986:	c3                   	retq   

0000000000801987 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801987:	55                   	push   %rbp
  801988:	48 89 e5             	mov    %rsp,%rbp
  80198b:	53                   	push   %rbx
  80198c:	48 83 ec 48          	sub    $0x48,%rsp
  801990:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801993:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801996:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80199a:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80199e:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8019a2:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  8019a6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019a9:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8019ad:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8019b1:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8019b5:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8019b9:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8019bd:	4c 89 c3             	mov    %r8,%rbx
  8019c0:	cd 30                	int    $0x30
  8019c2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  8019c6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8019ca:	74 3e                	je     801a0a <syscall+0x83>
  8019cc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019d1:	7e 37                	jle    801a0a <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019d7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019da:	49 89 d0             	mov    %rdx,%r8
  8019dd:	89 c1                	mov    %eax,%ecx
  8019df:	48 ba 88 44 80 00 00 	movabs $0x804488,%rdx
  8019e6:	00 00 00 
  8019e9:	be 4a 00 00 00       	mov    $0x4a,%esi
  8019ee:	48 bf a5 44 80 00 00 	movabs $0x8044a5,%rdi
  8019f5:	00 00 00 
  8019f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8019fd:	49 b9 40 04 80 00 00 	movabs $0x800440,%r9
  801a04:	00 00 00 
  801a07:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  801a0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a0e:	48 83 c4 48          	add    $0x48,%rsp
  801a12:	5b                   	pop    %rbx
  801a13:	5d                   	pop    %rbp
  801a14:	c3                   	retq   

0000000000801a15 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801a15:	55                   	push   %rbp
  801a16:	48 89 e5             	mov    %rsp,%rbp
  801a19:	48 83 ec 20          	sub    $0x20,%rsp
  801a1d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a21:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801a25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a29:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a2d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a34:	00 
  801a35:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a3b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a41:	48 89 d1             	mov    %rdx,%rcx
  801a44:	48 89 c2             	mov    %rax,%rdx
  801a47:	be 00 00 00 00       	mov    $0x0,%esi
  801a4c:	bf 00 00 00 00       	mov    $0x0,%edi
  801a51:	48 b8 87 19 80 00 00 	movabs $0x801987,%rax
  801a58:	00 00 00 
  801a5b:	ff d0                	callq  *%rax
}
  801a5d:	c9                   	leaveq 
  801a5e:	c3                   	retq   

0000000000801a5f <sys_cgetc>:

int
sys_cgetc(void)
{
  801a5f:	55                   	push   %rbp
  801a60:	48 89 e5             	mov    %rsp,%rbp
  801a63:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a67:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a6e:	00 
  801a6f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a75:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a7b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a80:	ba 00 00 00 00       	mov    $0x0,%edx
  801a85:	be 00 00 00 00       	mov    $0x0,%esi
  801a8a:	bf 01 00 00 00       	mov    $0x1,%edi
  801a8f:	48 b8 87 19 80 00 00 	movabs $0x801987,%rax
  801a96:	00 00 00 
  801a99:	ff d0                	callq  *%rax
}
  801a9b:	c9                   	leaveq 
  801a9c:	c3                   	retq   

0000000000801a9d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a9d:	55                   	push   %rbp
  801a9e:	48 89 e5             	mov    %rsp,%rbp
  801aa1:	48 83 ec 10          	sub    $0x10,%rsp
  801aa5:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801aa8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aab:	48 98                	cltq   
  801aad:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ab4:	00 
  801ab5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801abb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ac1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ac6:	48 89 c2             	mov    %rax,%rdx
  801ac9:	be 01 00 00 00       	mov    $0x1,%esi
  801ace:	bf 03 00 00 00       	mov    $0x3,%edi
  801ad3:	48 b8 87 19 80 00 00 	movabs $0x801987,%rax
  801ada:	00 00 00 
  801add:	ff d0                	callq  *%rax
}
  801adf:	c9                   	leaveq 
  801ae0:	c3                   	retq   

0000000000801ae1 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801ae1:	55                   	push   %rbp
  801ae2:	48 89 e5             	mov    %rsp,%rbp
  801ae5:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801ae9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801af0:	00 
  801af1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801af7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801afd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b02:	ba 00 00 00 00       	mov    $0x0,%edx
  801b07:	be 00 00 00 00       	mov    $0x0,%esi
  801b0c:	bf 02 00 00 00       	mov    $0x2,%edi
  801b11:	48 b8 87 19 80 00 00 	movabs $0x801987,%rax
  801b18:	00 00 00 
  801b1b:	ff d0                	callq  *%rax
}
  801b1d:	c9                   	leaveq 
  801b1e:	c3                   	retq   

0000000000801b1f <sys_yield>:

void
sys_yield(void)
{
  801b1f:	55                   	push   %rbp
  801b20:	48 89 e5             	mov    %rsp,%rbp
  801b23:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801b27:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b2e:	00 
  801b2f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b35:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b3b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b40:	ba 00 00 00 00       	mov    $0x0,%edx
  801b45:	be 00 00 00 00       	mov    $0x0,%esi
  801b4a:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b4f:	48 b8 87 19 80 00 00 	movabs $0x801987,%rax
  801b56:	00 00 00 
  801b59:	ff d0                	callq  *%rax
}
  801b5b:	c9                   	leaveq 
  801b5c:	c3                   	retq   

0000000000801b5d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b5d:	55                   	push   %rbp
  801b5e:	48 89 e5             	mov    %rsp,%rbp
  801b61:	48 83 ec 20          	sub    $0x20,%rsp
  801b65:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b68:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b6c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b6f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b72:	48 63 c8             	movslq %eax,%rcx
  801b75:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b7c:	48 98                	cltq   
  801b7e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b85:	00 
  801b86:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b8c:	49 89 c8             	mov    %rcx,%r8
  801b8f:	48 89 d1             	mov    %rdx,%rcx
  801b92:	48 89 c2             	mov    %rax,%rdx
  801b95:	be 01 00 00 00       	mov    $0x1,%esi
  801b9a:	bf 04 00 00 00       	mov    $0x4,%edi
  801b9f:	48 b8 87 19 80 00 00 	movabs $0x801987,%rax
  801ba6:	00 00 00 
  801ba9:	ff d0                	callq  *%rax
}
  801bab:	c9                   	leaveq 
  801bac:	c3                   	retq   

0000000000801bad <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801bad:	55                   	push   %rbp
  801bae:	48 89 e5             	mov    %rsp,%rbp
  801bb1:	48 83 ec 30          	sub    $0x30,%rsp
  801bb5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bb8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bbc:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801bbf:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801bc3:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801bc7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801bca:	48 63 c8             	movslq %eax,%rcx
  801bcd:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801bd1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bd4:	48 63 f0             	movslq %eax,%rsi
  801bd7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bdb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bde:	48 98                	cltq   
  801be0:	48 89 0c 24          	mov    %rcx,(%rsp)
  801be4:	49 89 f9             	mov    %rdi,%r9
  801be7:	49 89 f0             	mov    %rsi,%r8
  801bea:	48 89 d1             	mov    %rdx,%rcx
  801bed:	48 89 c2             	mov    %rax,%rdx
  801bf0:	be 01 00 00 00       	mov    $0x1,%esi
  801bf5:	bf 05 00 00 00       	mov    $0x5,%edi
  801bfa:	48 b8 87 19 80 00 00 	movabs $0x801987,%rax
  801c01:	00 00 00 
  801c04:	ff d0                	callq  *%rax
}
  801c06:	c9                   	leaveq 
  801c07:	c3                   	retq   

0000000000801c08 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801c08:	55                   	push   %rbp
  801c09:	48 89 e5             	mov    %rsp,%rbp
  801c0c:	48 83 ec 20          	sub    $0x20,%rsp
  801c10:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c13:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801c17:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c1e:	48 98                	cltq   
  801c20:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c27:	00 
  801c28:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c2e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c34:	48 89 d1             	mov    %rdx,%rcx
  801c37:	48 89 c2             	mov    %rax,%rdx
  801c3a:	be 01 00 00 00       	mov    $0x1,%esi
  801c3f:	bf 06 00 00 00       	mov    $0x6,%edi
  801c44:	48 b8 87 19 80 00 00 	movabs $0x801987,%rax
  801c4b:	00 00 00 
  801c4e:	ff d0                	callq  *%rax
}
  801c50:	c9                   	leaveq 
  801c51:	c3                   	retq   

0000000000801c52 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c52:	55                   	push   %rbp
  801c53:	48 89 e5             	mov    %rsp,%rbp
  801c56:	48 83 ec 10          	sub    $0x10,%rsp
  801c5a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c5d:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c60:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c63:	48 63 d0             	movslq %eax,%rdx
  801c66:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c69:	48 98                	cltq   
  801c6b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c72:	00 
  801c73:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c79:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c7f:	48 89 d1             	mov    %rdx,%rcx
  801c82:	48 89 c2             	mov    %rax,%rdx
  801c85:	be 01 00 00 00       	mov    $0x1,%esi
  801c8a:	bf 08 00 00 00       	mov    $0x8,%edi
  801c8f:	48 b8 87 19 80 00 00 	movabs $0x801987,%rax
  801c96:	00 00 00 
  801c99:	ff d0                	callq  *%rax
}
  801c9b:	c9                   	leaveq 
  801c9c:	c3                   	retq   

0000000000801c9d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c9d:	55                   	push   %rbp
  801c9e:	48 89 e5             	mov    %rsp,%rbp
  801ca1:	48 83 ec 20          	sub    $0x20,%rsp
  801ca5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ca8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801cac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cb3:	48 98                	cltq   
  801cb5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cbc:	00 
  801cbd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cc3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cc9:	48 89 d1             	mov    %rdx,%rcx
  801ccc:	48 89 c2             	mov    %rax,%rdx
  801ccf:	be 01 00 00 00       	mov    $0x1,%esi
  801cd4:	bf 09 00 00 00       	mov    $0x9,%edi
  801cd9:	48 b8 87 19 80 00 00 	movabs $0x801987,%rax
  801ce0:	00 00 00 
  801ce3:	ff d0                	callq  *%rax
}
  801ce5:	c9                   	leaveq 
  801ce6:	c3                   	retq   

0000000000801ce7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ce7:	55                   	push   %rbp
  801ce8:	48 89 e5             	mov    %rsp,%rbp
  801ceb:	48 83 ec 20          	sub    $0x20,%rsp
  801cef:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cf2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801cf6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cfa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cfd:	48 98                	cltq   
  801cff:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d06:	00 
  801d07:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d0d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d13:	48 89 d1             	mov    %rdx,%rcx
  801d16:	48 89 c2             	mov    %rax,%rdx
  801d19:	be 01 00 00 00       	mov    $0x1,%esi
  801d1e:	bf 0a 00 00 00       	mov    $0xa,%edi
  801d23:	48 b8 87 19 80 00 00 	movabs $0x801987,%rax
  801d2a:	00 00 00 
  801d2d:	ff d0                	callq  *%rax
}
  801d2f:	c9                   	leaveq 
  801d30:	c3                   	retq   

0000000000801d31 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801d31:	55                   	push   %rbp
  801d32:	48 89 e5             	mov    %rsp,%rbp
  801d35:	48 83 ec 20          	sub    $0x20,%rsp
  801d39:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d3c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d40:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d44:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d47:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d4a:	48 63 f0             	movslq %eax,%rsi
  801d4d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d54:	48 98                	cltq   
  801d56:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d5a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d61:	00 
  801d62:	49 89 f1             	mov    %rsi,%r9
  801d65:	49 89 c8             	mov    %rcx,%r8
  801d68:	48 89 d1             	mov    %rdx,%rcx
  801d6b:	48 89 c2             	mov    %rax,%rdx
  801d6e:	be 00 00 00 00       	mov    $0x0,%esi
  801d73:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d78:	48 b8 87 19 80 00 00 	movabs $0x801987,%rax
  801d7f:	00 00 00 
  801d82:	ff d0                	callq  *%rax
}
  801d84:	c9                   	leaveq 
  801d85:	c3                   	retq   

0000000000801d86 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d86:	55                   	push   %rbp
  801d87:	48 89 e5             	mov    %rsp,%rbp
  801d8a:	48 83 ec 10          	sub    $0x10,%rsp
  801d8e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d96:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d9d:	00 
  801d9e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801da4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801daa:	b9 00 00 00 00       	mov    $0x0,%ecx
  801daf:	48 89 c2             	mov    %rax,%rdx
  801db2:	be 01 00 00 00       	mov    $0x1,%esi
  801db7:	bf 0d 00 00 00       	mov    $0xd,%edi
  801dbc:	48 b8 87 19 80 00 00 	movabs $0x801987,%rax
  801dc3:	00 00 00 
  801dc6:	ff d0                	callq  *%rax
}
  801dc8:	c9                   	leaveq 
  801dc9:	c3                   	retq   

0000000000801dca <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801dca:	55                   	push   %rbp
  801dcb:	48 89 e5             	mov    %rsp,%rbp
  801dce:	53                   	push   %rbx
  801dcf:	48 83 ec 48          	sub    $0x48,%rsp
  801dd3:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801dd7:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801ddb:	48 8b 00             	mov    (%rax),%rax
  801dde:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	uint32_t err = utf->utf_err;
  801de2:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801de6:	48 8b 40 08          	mov    0x8(%rax),%rax
  801dea:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	pte_t pte = uvpt[VPN(addr)];
  801ded:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801df1:	48 c1 e8 0c          	shr    $0xc,%rax
  801df5:	48 89 c2             	mov    %rax,%rdx
  801df8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801dff:	01 00 00 
  801e02:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e06:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	envid_t pid = sys_getenvid();
  801e0a:	48 b8 e1 1a 80 00 00 	movabs $0x801ae1,%rax
  801e11:	00 00 00 
  801e14:	ff d0                	callq  *%rax
  801e16:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	void* va = ROUNDDOWN(addr, PGSIZE);
  801e19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e1d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  801e21:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801e25:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801e2b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	if((err & FEC_WR) && (pte & PTE_COW)){
  801e2f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801e32:	83 e0 02             	and    $0x2,%eax
  801e35:	85 c0                	test   %eax,%eax
  801e37:	0f 84 8d 00 00 00    	je     801eca <pgfault+0x100>
  801e3d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e41:	25 00 08 00 00       	and    $0x800,%eax
  801e46:	48 85 c0             	test   %rax,%rax
  801e49:	74 7f                	je     801eca <pgfault+0x100>
		if(!sys_page_alloc(pid, (void*)PFTEMP, PTE_P | PTE_W | PTE_U)){
  801e4b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801e4e:	ba 07 00 00 00       	mov    $0x7,%edx
  801e53:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e58:	89 c7                	mov    %eax,%edi
  801e5a:	48 b8 5d 1b 80 00 00 	movabs $0x801b5d,%rax
  801e61:	00 00 00 
  801e64:	ff d0                	callq  *%rax
  801e66:	85 c0                	test   %eax,%eax
  801e68:	75 60                	jne    801eca <pgfault+0x100>
			memmove(PFTEMP, va, PGSIZE);
  801e6a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801e6e:	ba 00 10 00 00       	mov    $0x1000,%edx
  801e73:	48 89 c6             	mov    %rax,%rsi
  801e76:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801e7b:	48 b8 52 15 80 00 00 	movabs $0x801552,%rax
  801e82:	00 00 00 
  801e85:	ff d0                	callq  *%rax
			if(!(sys_page_map(pid, (void*)PFTEMP, pid, va, PTE_P | PTE_W | PTE_U) | 
  801e87:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  801e8b:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  801e8e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801e91:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801e97:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e9c:	89 c7                	mov    %eax,%edi
  801e9e:	48 b8 ad 1b 80 00 00 	movabs $0x801bad,%rax
  801ea5:	00 00 00 
  801ea8:	ff d0                	callq  *%rax
  801eaa:	89 c3                	mov    %eax,%ebx
					 sys_page_unmap(pid, (void*) PFTEMP)))
  801eac:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801eaf:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801eb4:	89 c7                	mov    %eax,%edi
  801eb6:	48 b8 08 1c 80 00 00 	movabs $0x801c08,%rax
  801ebd:	00 00 00 
  801ec0:	ff d0                	callq  *%rax
	envid_t pid = sys_getenvid();
	void* va = ROUNDDOWN(addr, PGSIZE);
	if((err & FEC_WR) && (pte & PTE_COW)){
		if(!sys_page_alloc(pid, (void*)PFTEMP, PTE_P | PTE_W | PTE_U)){
			memmove(PFTEMP, va, PGSIZE);
			if(!(sys_page_map(pid, (void*)PFTEMP, pid, va, PTE_P | PTE_W | PTE_U) | 
  801ec2:	09 d8                	or     %ebx,%eax
  801ec4:	85 c0                	test   %eax,%eax
  801ec6:	75 02                	jne    801eca <pgfault+0x100>
					 sys_page_unmap(pid, (void*) PFTEMP)))
					return;
  801ec8:	eb 2a                	jmp    801ef4 <pgfault+0x12a>
		}
	}
	panic("Page fault handler failure\n");
  801eca:	48 ba b3 44 80 00 00 	movabs $0x8044b3,%rdx
  801ed1:	00 00 00 
  801ed4:	be 26 00 00 00       	mov    $0x26,%esi
  801ed9:	48 bf cf 44 80 00 00 	movabs $0x8044cf,%rdi
  801ee0:	00 00 00 
  801ee3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee8:	48 b9 40 04 80 00 00 	movabs $0x800440,%rcx
  801eef:	00 00 00 
  801ef2:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	//panic("pgfault not implemented");
}
  801ef4:	48 83 c4 48          	add    $0x48,%rsp
  801ef8:	5b                   	pop    %rbx
  801ef9:	5d                   	pop    %rbp
  801efa:	c3                   	retq   

0000000000801efb <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801efb:	55                   	push   %rbp
  801efc:	48 89 e5             	mov    %rsp,%rbp
  801eff:	53                   	push   %rbx
  801f00:	48 83 ec 38          	sub    $0x38,%rsp
  801f04:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801f07:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	//struct Env *env;
	pte_t pte = uvpt[pn];
  801f0a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f11:	01 00 00 
  801f14:	8b 55 c8             	mov    -0x38(%rbp),%edx
  801f17:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f1b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int perm = pte & PTE_SYSCALL;
  801f1f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f23:	25 07 0e 00 00       	and    $0xe07,%eax
  801f28:	89 45 dc             	mov    %eax,-0x24(%rbp)
	void *va = (void*)((uintptr_t)pn * PGSIZE);
  801f2b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801f2e:	48 c1 e0 0c          	shl    $0xc,%rax
  801f32:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	if(perm & PTE_SHARE){
  801f36:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801f39:	25 00 04 00 00       	and    $0x400,%eax
  801f3e:	85 c0                	test   %eax,%eax
  801f40:	74 30                	je     801f72 <duppage+0x77>
		r = sys_page_map(0, va, envid, va, perm);
  801f42:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801f45:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801f49:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801f4c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f50:	41 89 f0             	mov    %esi,%r8d
  801f53:	48 89 c6             	mov    %rax,%rsi
  801f56:	bf 00 00 00 00       	mov    $0x0,%edi
  801f5b:	48 b8 ad 1b 80 00 00 	movabs $0x801bad,%rax
  801f62:	00 00 00 
  801f65:	ff d0                	callq  *%rax
  801f67:	89 45 ec             	mov    %eax,-0x14(%rbp)
		return r;
  801f6a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f6d:	e9 a4 00 00 00       	jmpq   802016 <duppage+0x11b>
	}
	//envid_t pid = sys_getenvid();
	if((perm & PTE_W) || (perm & PTE_COW)){
  801f72:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801f75:	83 e0 02             	and    $0x2,%eax
  801f78:	85 c0                	test   %eax,%eax
  801f7a:	75 0c                	jne    801f88 <duppage+0x8d>
  801f7c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801f7f:	25 00 08 00 00       	and    $0x800,%eax
  801f84:	85 c0                	test   %eax,%eax
  801f86:	74 63                	je     801feb <duppage+0xf0>
		perm &= ~PTE_W;
  801f88:	83 65 dc fd          	andl   $0xfffffffd,-0x24(%rbp)
		perm |= PTE_COW;
  801f8c:	81 4d dc 00 08 00 00 	orl    $0x800,-0x24(%rbp)
		r = sys_page_map(0, va, envid, va, perm) | sys_page_map(0, va, 0, va, perm);
  801f93:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801f96:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801f9a:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801f9d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fa1:	41 89 f0             	mov    %esi,%r8d
  801fa4:	48 89 c6             	mov    %rax,%rsi
  801fa7:	bf 00 00 00 00       	mov    $0x0,%edi
  801fac:	48 b8 ad 1b 80 00 00 	movabs $0x801bad,%rax
  801fb3:	00 00 00 
  801fb6:	ff d0                	callq  *%rax
  801fb8:	89 c3                	mov    %eax,%ebx
  801fba:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  801fbd:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801fc1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fc5:	41 89 c8             	mov    %ecx,%r8d
  801fc8:	48 89 d1             	mov    %rdx,%rcx
  801fcb:	ba 00 00 00 00       	mov    $0x0,%edx
  801fd0:	48 89 c6             	mov    %rax,%rsi
  801fd3:	bf 00 00 00 00       	mov    $0x0,%edi
  801fd8:	48 b8 ad 1b 80 00 00 	movabs $0x801bad,%rax
  801fdf:	00 00 00 
  801fe2:	ff d0                	callq  *%rax
  801fe4:	09 d8                	or     %ebx,%eax
  801fe6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801fe9:	eb 28                	jmp    802013 <duppage+0x118>
	}
	else{
		r = sys_page_map(0, va, envid, va, perm);
  801feb:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801fee:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801ff2:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801ff5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ff9:	41 89 f0             	mov    %esi,%r8d
  801ffc:	48 89 c6             	mov    %rax,%rsi
  801fff:	bf 00 00 00 00       	mov    $0x0,%edi
  802004:	48 b8 ad 1b 80 00 00 	movabs $0x801bad,%rax
  80200b:	00 00 00 
  80200e:	ff d0                	callq  *%rax
  802010:	89 45 ec             	mov    %eax,-0x14(%rbp)
	}

	// LAB 4: Your code here.
	//panic("duppage not implemented");
	//if(r != 0) panic("Duplicating page failed: %e\n", r);
	return r;
  802013:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802016:	48 83 c4 38          	add    $0x38,%rsp
  80201a:	5b                   	pop    %rbx
  80201b:	5d                   	pop    %rbp
  80201c:	c3                   	retq   

000000000080201d <fork>:
//   so you must allocate a new page for the child's user exception stack.
//

envid_t
fork(void)
{
  80201d:	55                   	push   %rbp
  80201e:	48 89 e5             	mov    %rsp,%rbp
  802021:	53                   	push   %rbx
  802022:	48 83 ec 58          	sub    $0x58,%rsp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  802026:	48 bf ca 1d 80 00 00 	movabs $0x801dca,%rdi
  80202d:	00 00 00 
  802030:	48 b8 50 3d 80 00 00 	movabs $0x803d50,%rax
  802037:	00 00 00 
  80203a:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80203c:	b8 07 00 00 00       	mov    $0x7,%eax
  802041:	cd 30                	int    $0x30
  802043:	89 45 a4             	mov    %eax,-0x5c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802046:	8b 45 a4             	mov    -0x5c(%rbp),%eax
	envid_t cid = sys_exofork();
  802049:	89 45 cc             	mov    %eax,-0x34(%rbp)
	if(cid < 0) panic("fork failed: %e\n", cid);
  80204c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802050:	79 30                	jns    802082 <fork+0x65>
  802052:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802055:	89 c1                	mov    %eax,%ecx
  802057:	48 ba da 44 80 00 00 	movabs $0x8044da,%rdx
  80205e:	00 00 00 
  802061:	be 72 00 00 00       	mov    $0x72,%esi
  802066:	48 bf cf 44 80 00 00 	movabs $0x8044cf,%rdi
  80206d:	00 00 00 
  802070:	b8 00 00 00 00       	mov    $0x0,%eax
  802075:	49 b8 40 04 80 00 00 	movabs $0x800440,%r8
  80207c:	00 00 00 
  80207f:	41 ff d0             	callq  *%r8
	if(cid == 0){
  802082:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802086:	75 46                	jne    8020ce <fork+0xb1>
		thisenv = &envs[ENVX(sys_getenvid())];
  802088:	48 b8 e1 1a 80 00 00 	movabs $0x801ae1,%rax
  80208f:	00 00 00 
  802092:	ff d0                	callq  *%rax
  802094:	25 ff 03 00 00       	and    $0x3ff,%eax
  802099:	48 63 d0             	movslq %eax,%rdx
  80209c:	48 89 d0             	mov    %rdx,%rax
  80209f:	48 c1 e0 03          	shl    $0x3,%rax
  8020a3:	48 01 d0             	add    %rdx,%rax
  8020a6:	48 c1 e0 05          	shl    $0x5,%rax
  8020aa:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8020b1:	00 00 00 
  8020b4:	48 01 c2             	add    %rax,%rdx
  8020b7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8020be:	00 00 00 
  8020c1:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8020c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c9:	e9 12 02 00 00       	jmpq   8022e0 <fork+0x2c3>
	}
	int result;
	if((result = sys_page_alloc(cid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8020ce:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8020d1:	ba 07 00 00 00       	mov    $0x7,%edx
  8020d6:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8020db:	89 c7                	mov    %eax,%edi
  8020dd:	48 b8 5d 1b 80 00 00 	movabs $0x801b5d,%rax
  8020e4:	00 00 00 
  8020e7:	ff d0                	callq  *%rax
  8020e9:	89 45 c8             	mov    %eax,-0x38(%rbp)
  8020ec:	83 7d c8 00          	cmpl   $0x0,-0x38(%rbp)
  8020f0:	79 30                	jns    802122 <fork+0x105>
		panic("fork failed: %e\n", result);
  8020f2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020f5:	89 c1                	mov    %eax,%ecx
  8020f7:	48 ba da 44 80 00 00 	movabs $0x8044da,%rdx
  8020fe:	00 00 00 
  802101:	be 79 00 00 00       	mov    $0x79,%esi
  802106:	48 bf cf 44 80 00 00 	movabs $0x8044cf,%rdi
  80210d:	00 00 00 
  802110:	b8 00 00 00 00       	mov    $0x0,%eax
  802115:	49 b8 40 04 80 00 00 	movabs $0x800440,%r8
  80211c:	00 00 00 
  80211f:	41 ff d0             	callq  *%r8
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  802122:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802129:	00 
  80212a:	e9 40 01 00 00       	jmpq   80226f <fork+0x252>
		if(uvpml4e[pml4e] & PTE_P){
  80212f:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802136:	01 00 00 
  802139:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80213d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802141:	83 e0 01             	and    $0x1,%eax
  802144:	48 85 c0             	test   %rax,%rax
  802147:	0f 84 1d 01 00 00    	je     80226a <fork+0x24d>
			base_pml4e = pml4e * NPDPENTRIES;
  80214d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802151:	48 c1 e0 09          	shl    $0x9,%rax
  802155:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  802159:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  802160:	00 
  802161:	e9 f6 00 00 00       	jmpq   80225c <fork+0x23f>
				if(uvpde[base_pml4e + pdpe] & PTE_P){
  802166:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80216a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80216e:	48 01 c2             	add    %rax,%rdx
  802171:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802178:	01 00 00 
  80217b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80217f:	83 e0 01             	and    $0x1,%eax
  802182:	48 85 c0             	test   %rax,%rax
  802185:	0f 84 cc 00 00 00    	je     802257 <fork+0x23a>
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
  80218b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80218f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802193:	48 01 d0             	add    %rdx,%rax
  802196:	48 c1 e0 09          	shl    $0x9,%rax
  80219a:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
					for(pde = 0; pde < NPDENTRIES; pde++){
  80219e:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  8021a5:	00 
  8021a6:	e9 9e 00 00 00       	jmpq   802249 <fork+0x22c>
						if(uvpd[base_pdpe + pde] & PTE_P){
  8021ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021af:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8021b3:	48 01 c2             	add    %rax,%rdx
  8021b6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021bd:	01 00 00 
  8021c0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021c4:	83 e0 01             	and    $0x1,%eax
  8021c7:	48 85 c0             	test   %rax,%rax
  8021ca:	74 78                	je     802244 <fork+0x227>
							base_pde = (base_pdpe + pde) * NPTENTRIES;
  8021cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021d0:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8021d4:	48 01 d0             	add    %rdx,%rax
  8021d7:	48 c1 e0 09          	shl    $0x9,%rax
  8021db:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
							for(pte = 0; pte < NPTENTRIES; pte++){
  8021df:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  8021e6:	00 
  8021e7:	eb 51                	jmp    80223a <fork+0x21d>
								entry = base_pde + pte;
  8021e9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8021ed:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8021f1:	48 01 d0             	add    %rdx,%rax
  8021f4:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
								if((uvpt[entry] & PTE_P) && (entry != VPN(UXSTACKTOP - PGSIZE))){
  8021f8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021ff:	01 00 00 
  802202:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802206:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80220a:	83 e0 01             	and    $0x1,%eax
  80220d:	48 85 c0             	test   %rax,%rax
  802210:	74 23                	je     802235 <fork+0x218>
  802212:	48 81 7d a8 ff f7 0e 	cmpq   $0xef7ff,-0x58(%rbp)
  802219:	00 
  80221a:	74 19                	je     802235 <fork+0x218>
									duppage(cid, entry);
  80221c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802220:	89 c2                	mov    %eax,%edx
  802222:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802225:	89 d6                	mov    %edx,%esi
  802227:	89 c7                	mov    %eax,%edi
  802229:	48 b8 fb 1e 80 00 00 	movabs $0x801efb,%rax
  802230:	00 00 00 
  802233:	ff d0                	callq  *%rax
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
						if(uvpd[base_pdpe + pde] & PTE_P){
							base_pde = (base_pdpe + pde) * NPTENTRIES;
							for(pte = 0; pte < NPTENTRIES; pte++){
  802235:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  80223a:	48 81 7d d0 ff 01 00 	cmpq   $0x1ff,-0x30(%rbp)
  802241:	00 
  802242:	76 a5                	jbe    8021e9 <fork+0x1cc>
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
  802244:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802249:	48 81 7d d8 ff 01 00 	cmpq   $0x1ff,-0x28(%rbp)
  802250:	00 
  802251:	0f 86 54 ff ff ff    	jbe    8021ab <fork+0x18e>
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  802257:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  80225c:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  802263:	00 
  802264:	0f 86 fc fe ff ff    	jbe    802166 <fork+0x149>
	int result;
	if((result = sys_page_alloc(cid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		panic("fork failed: %e\n", result);
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  80226a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80226f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802274:	0f 84 b5 fe ff ff    	je     80212f <fork+0x112>
					}
				}
			}
		}
	}
	if(sys_env_set_pgfault_upcall(cid, _pgfault_upcall) | sys_env_set_status(cid, ENV_RUNNABLE))
  80227a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80227d:	48 be e5 3d 80 00 00 	movabs $0x803de5,%rsi
  802284:	00 00 00 
  802287:	89 c7                	mov    %eax,%edi
  802289:	48 b8 e7 1c 80 00 00 	movabs $0x801ce7,%rax
  802290:	00 00 00 
  802293:	ff d0                	callq  *%rax
  802295:	89 c3                	mov    %eax,%ebx
  802297:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80229a:	be 02 00 00 00       	mov    $0x2,%esi
  80229f:	89 c7                	mov    %eax,%edi
  8022a1:	48 b8 52 1c 80 00 00 	movabs $0x801c52,%rax
  8022a8:	00 00 00 
  8022ab:	ff d0                	callq  *%rax
  8022ad:	09 d8                	or     %ebx,%eax
  8022af:	85 c0                	test   %eax,%eax
  8022b1:	74 2a                	je     8022dd <fork+0x2c0>
		panic("fork failed\n");
  8022b3:	48 ba eb 44 80 00 00 	movabs $0x8044eb,%rdx
  8022ba:	00 00 00 
  8022bd:	be 92 00 00 00       	mov    $0x92,%esi
  8022c2:	48 bf cf 44 80 00 00 	movabs $0x8044cf,%rdi
  8022c9:	00 00 00 
  8022cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d1:	48 b9 40 04 80 00 00 	movabs $0x800440,%rcx
  8022d8:	00 00 00 
  8022db:	ff d1                	callq  *%rcx
	return cid;
  8022dd:	8b 45 cc             	mov    -0x34(%rbp),%eax
	//panic("fork not implemented");
}
  8022e0:	48 83 c4 58          	add    $0x58,%rsp
  8022e4:	5b                   	pop    %rbx
  8022e5:	5d                   	pop    %rbp
  8022e6:	c3                   	retq   

00000000008022e7 <sfork>:


// Challenge!
int
sfork(void)
{
  8022e7:	55                   	push   %rbp
  8022e8:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8022eb:	48 ba f8 44 80 00 00 	movabs $0x8044f8,%rdx
  8022f2:	00 00 00 
  8022f5:	be 9c 00 00 00       	mov    $0x9c,%esi
  8022fa:	48 bf cf 44 80 00 00 	movabs $0x8044cf,%rdi
  802301:	00 00 00 
  802304:	b8 00 00 00 00       	mov    $0x0,%eax
  802309:	48 b9 40 04 80 00 00 	movabs $0x800440,%rcx
  802310:	00 00 00 
  802313:	ff d1                	callq  *%rcx

0000000000802315 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802315:	55                   	push   %rbp
  802316:	48 89 e5             	mov    %rsp,%rbp
  802319:	48 83 ec 30          	sub    $0x30,%rsp
  80231d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802321:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802325:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  802329:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80232e:	74 18                	je     802348 <ipc_recv+0x33>
  802330:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802334:	48 89 c7             	mov    %rax,%rdi
  802337:	48 b8 86 1d 80 00 00 	movabs $0x801d86,%rax
  80233e:	00 00 00 
  802341:	ff d0                	callq  *%rax
  802343:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802346:	eb 19                	jmp    802361 <ipc_recv+0x4c>
  802348:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  80234f:	00 00 00 
  802352:	48 b8 86 1d 80 00 00 	movabs $0x801d86,%rax
  802359:	00 00 00 
  80235c:	ff d0                	callq  *%rax
  80235e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  802361:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802366:	74 26                	je     80238e <ipc_recv+0x79>
  802368:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80236c:	75 15                	jne    802383 <ipc_recv+0x6e>
  80236e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802375:	00 00 00 
  802378:	48 8b 00             	mov    (%rax),%rax
  80237b:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  802381:	eb 05                	jmp    802388 <ipc_recv+0x73>
  802383:	b8 00 00 00 00       	mov    $0x0,%eax
  802388:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80238c:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  80238e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802393:	74 26                	je     8023bb <ipc_recv+0xa6>
  802395:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802399:	75 15                	jne    8023b0 <ipc_recv+0x9b>
  80239b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8023a2:	00 00 00 
  8023a5:	48 8b 00             	mov    (%rax),%rax
  8023a8:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  8023ae:	eb 05                	jmp    8023b5 <ipc_recv+0xa0>
  8023b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023b9:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  8023bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023bf:	75 15                	jne    8023d6 <ipc_recv+0xc1>
  8023c1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8023c8:	00 00 00 
  8023cb:	48 8b 00             	mov    (%rax),%rax
  8023ce:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  8023d4:	eb 03                	jmp    8023d9 <ipc_recv+0xc4>
  8023d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023d9:	c9                   	leaveq 
  8023da:	c3                   	retq   

00000000008023db <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8023db:	55                   	push   %rbp
  8023dc:	48 89 e5             	mov    %rsp,%rbp
  8023df:	48 83 ec 30          	sub    $0x30,%rsp
  8023e3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023e6:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8023e9:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8023ed:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  8023f0:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  8023f7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8023fc:	75 10                	jne    80240e <ipc_send+0x33>
  8023fe:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802405:	00 00 00 
  802408:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  80240c:	eb 62                	jmp    802470 <ipc_send+0x95>
  80240e:	eb 60                	jmp    802470 <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  802410:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802414:	74 30                	je     802446 <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  802416:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802419:	89 c1                	mov    %eax,%ecx
  80241b:	48 ba 0e 45 80 00 00 	movabs $0x80450e,%rdx
  802422:	00 00 00 
  802425:	be 33 00 00 00       	mov    $0x33,%esi
  80242a:	48 bf 2a 45 80 00 00 	movabs $0x80452a,%rdi
  802431:	00 00 00 
  802434:	b8 00 00 00 00       	mov    $0x0,%eax
  802439:	49 b8 40 04 80 00 00 	movabs $0x800440,%r8
  802440:	00 00 00 
  802443:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  802446:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802449:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80244c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802450:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802453:	89 c7                	mov    %eax,%edi
  802455:	48 b8 31 1d 80 00 00 	movabs $0x801d31,%rax
  80245c:	00 00 00 
  80245f:	ff d0                	callq  *%rax
  802461:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  802464:	48 b8 1f 1b 80 00 00 	movabs $0x801b1f,%rax
  80246b:	00 00 00 
  80246e:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  802470:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802474:	75 9a                	jne    802410 <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  802476:	c9                   	leaveq 
  802477:	c3                   	retq   

0000000000802478 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802478:	55                   	push   %rbp
  802479:	48 89 e5             	mov    %rsp,%rbp
  80247c:	48 83 ec 14          	sub    $0x14,%rsp
  802480:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  802483:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80248a:	eb 5e                	jmp    8024ea <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80248c:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802493:	00 00 00 
  802496:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802499:	48 63 d0             	movslq %eax,%rdx
  80249c:	48 89 d0             	mov    %rdx,%rax
  80249f:	48 c1 e0 03          	shl    $0x3,%rax
  8024a3:	48 01 d0             	add    %rdx,%rax
  8024a6:	48 c1 e0 05          	shl    $0x5,%rax
  8024aa:	48 01 c8             	add    %rcx,%rax
  8024ad:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8024b3:	8b 00                	mov    (%rax),%eax
  8024b5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8024b8:	75 2c                	jne    8024e6 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8024ba:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8024c1:	00 00 00 
  8024c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024c7:	48 63 d0             	movslq %eax,%rdx
  8024ca:	48 89 d0             	mov    %rdx,%rax
  8024cd:	48 c1 e0 03          	shl    $0x3,%rax
  8024d1:	48 01 d0             	add    %rdx,%rax
  8024d4:	48 c1 e0 05          	shl    $0x5,%rax
  8024d8:	48 01 c8             	add    %rcx,%rax
  8024db:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8024e1:	8b 40 08             	mov    0x8(%rax),%eax
  8024e4:	eb 12                	jmp    8024f8 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8024e6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8024ea:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8024f1:	7e 99                	jle    80248c <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8024f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024f8:	c9                   	leaveq 
  8024f9:	c3                   	retq   

00000000008024fa <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8024fa:	55                   	push   %rbp
  8024fb:	48 89 e5             	mov    %rsp,%rbp
  8024fe:	48 83 ec 08          	sub    $0x8,%rsp
  802502:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802506:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80250a:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802511:	ff ff ff 
  802514:	48 01 d0             	add    %rdx,%rax
  802517:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80251b:	c9                   	leaveq 
  80251c:	c3                   	retq   

000000000080251d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80251d:	55                   	push   %rbp
  80251e:	48 89 e5             	mov    %rsp,%rbp
  802521:	48 83 ec 08          	sub    $0x8,%rsp
  802525:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802529:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80252d:	48 89 c7             	mov    %rax,%rdi
  802530:	48 b8 fa 24 80 00 00 	movabs $0x8024fa,%rax
  802537:	00 00 00 
  80253a:	ff d0                	callq  *%rax
  80253c:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802542:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802546:	c9                   	leaveq 
  802547:	c3                   	retq   

0000000000802548 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802548:	55                   	push   %rbp
  802549:	48 89 e5             	mov    %rsp,%rbp
  80254c:	48 83 ec 18          	sub    $0x18,%rsp
  802550:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802554:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80255b:	eb 6b                	jmp    8025c8 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80255d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802560:	48 98                	cltq   
  802562:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802568:	48 c1 e0 0c          	shl    $0xc,%rax
  80256c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802570:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802574:	48 c1 e8 15          	shr    $0x15,%rax
  802578:	48 89 c2             	mov    %rax,%rdx
  80257b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802582:	01 00 00 
  802585:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802589:	83 e0 01             	and    $0x1,%eax
  80258c:	48 85 c0             	test   %rax,%rax
  80258f:	74 21                	je     8025b2 <fd_alloc+0x6a>
  802591:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802595:	48 c1 e8 0c          	shr    $0xc,%rax
  802599:	48 89 c2             	mov    %rax,%rdx
  80259c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025a3:	01 00 00 
  8025a6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025aa:	83 e0 01             	and    $0x1,%eax
  8025ad:	48 85 c0             	test   %rax,%rax
  8025b0:	75 12                	jne    8025c4 <fd_alloc+0x7c>
			*fd_store = fd;
  8025b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025b6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025ba:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8025bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c2:	eb 1a                	jmp    8025de <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8025c4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025c8:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8025cc:	7e 8f                	jle    80255d <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8025ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025d2:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8025d9:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8025de:	c9                   	leaveq 
  8025df:	c3                   	retq   

00000000008025e0 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8025e0:	55                   	push   %rbp
  8025e1:	48 89 e5             	mov    %rsp,%rbp
  8025e4:	48 83 ec 20          	sub    $0x20,%rsp
  8025e8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025eb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8025ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8025f3:	78 06                	js     8025fb <fd_lookup+0x1b>
  8025f5:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8025f9:	7e 07                	jle    802602 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8025fb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802600:	eb 6c                	jmp    80266e <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802602:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802605:	48 98                	cltq   
  802607:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80260d:	48 c1 e0 0c          	shl    $0xc,%rax
  802611:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802615:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802619:	48 c1 e8 15          	shr    $0x15,%rax
  80261d:	48 89 c2             	mov    %rax,%rdx
  802620:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802627:	01 00 00 
  80262a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80262e:	83 e0 01             	and    $0x1,%eax
  802631:	48 85 c0             	test   %rax,%rax
  802634:	74 21                	je     802657 <fd_lookup+0x77>
  802636:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80263a:	48 c1 e8 0c          	shr    $0xc,%rax
  80263e:	48 89 c2             	mov    %rax,%rdx
  802641:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802648:	01 00 00 
  80264b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80264f:	83 e0 01             	and    $0x1,%eax
  802652:	48 85 c0             	test   %rax,%rax
  802655:	75 07                	jne    80265e <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802657:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80265c:	eb 10                	jmp    80266e <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80265e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802662:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802666:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802669:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80266e:	c9                   	leaveq 
  80266f:	c3                   	retq   

0000000000802670 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802670:	55                   	push   %rbp
  802671:	48 89 e5             	mov    %rsp,%rbp
  802674:	48 83 ec 30          	sub    $0x30,%rsp
  802678:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80267c:	89 f0                	mov    %esi,%eax
  80267e:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802681:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802685:	48 89 c7             	mov    %rax,%rdi
  802688:	48 b8 fa 24 80 00 00 	movabs $0x8024fa,%rax
  80268f:	00 00 00 
  802692:	ff d0                	callq  *%rax
  802694:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802698:	48 89 d6             	mov    %rdx,%rsi
  80269b:	89 c7                	mov    %eax,%edi
  80269d:	48 b8 e0 25 80 00 00 	movabs $0x8025e0,%rax
  8026a4:	00 00 00 
  8026a7:	ff d0                	callq  *%rax
  8026a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026b0:	78 0a                	js     8026bc <fd_close+0x4c>
	    || fd != fd2)
  8026b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026b6:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8026ba:	74 12                	je     8026ce <fd_close+0x5e>
		return (must_exist ? r : 0);
  8026bc:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8026c0:	74 05                	je     8026c7 <fd_close+0x57>
  8026c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026c5:	eb 05                	jmp    8026cc <fd_close+0x5c>
  8026c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8026cc:	eb 69                	jmp    802737 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8026ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026d2:	8b 00                	mov    (%rax),%eax
  8026d4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026d8:	48 89 d6             	mov    %rdx,%rsi
  8026db:	89 c7                	mov    %eax,%edi
  8026dd:	48 b8 39 27 80 00 00 	movabs $0x802739,%rax
  8026e4:	00 00 00 
  8026e7:	ff d0                	callq  *%rax
  8026e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026f0:	78 2a                	js     80271c <fd_close+0xac>
		if (dev->dev_close)
  8026f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026f6:	48 8b 40 20          	mov    0x20(%rax),%rax
  8026fa:	48 85 c0             	test   %rax,%rax
  8026fd:	74 16                	je     802715 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8026ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802703:	48 8b 40 20          	mov    0x20(%rax),%rax
  802707:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80270b:	48 89 d7             	mov    %rdx,%rdi
  80270e:	ff d0                	callq  *%rax
  802710:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802713:	eb 07                	jmp    80271c <fd_close+0xac>
		else
			r = 0;
  802715:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80271c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802720:	48 89 c6             	mov    %rax,%rsi
  802723:	bf 00 00 00 00       	mov    $0x0,%edi
  802728:	48 b8 08 1c 80 00 00 	movabs $0x801c08,%rax
  80272f:	00 00 00 
  802732:	ff d0                	callq  *%rax
	return r;
  802734:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802737:	c9                   	leaveq 
  802738:	c3                   	retq   

0000000000802739 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802739:	55                   	push   %rbp
  80273a:	48 89 e5             	mov    %rsp,%rbp
  80273d:	48 83 ec 20          	sub    $0x20,%rsp
  802741:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802744:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802748:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80274f:	eb 41                	jmp    802792 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802751:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802758:	00 00 00 
  80275b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80275e:	48 63 d2             	movslq %edx,%rdx
  802761:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802765:	8b 00                	mov    (%rax),%eax
  802767:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80276a:	75 22                	jne    80278e <dev_lookup+0x55>
			*dev = devtab[i];
  80276c:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802773:	00 00 00 
  802776:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802779:	48 63 d2             	movslq %edx,%rdx
  80277c:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802780:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802784:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802787:	b8 00 00 00 00       	mov    $0x0,%eax
  80278c:	eb 60                	jmp    8027ee <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80278e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802792:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802799:	00 00 00 
  80279c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80279f:	48 63 d2             	movslq %edx,%rdx
  8027a2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027a6:	48 85 c0             	test   %rax,%rax
  8027a9:	75 a6                	jne    802751 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8027ab:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8027b2:	00 00 00 
  8027b5:	48 8b 00             	mov    (%rax),%rax
  8027b8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027be:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8027c1:	89 c6                	mov    %eax,%esi
  8027c3:	48 bf 38 45 80 00 00 	movabs $0x804538,%rdi
  8027ca:	00 00 00 
  8027cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d2:	48 b9 79 06 80 00 00 	movabs $0x800679,%rcx
  8027d9:	00 00 00 
  8027dc:	ff d1                	callq  *%rcx
	*dev = 0;
  8027de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027e2:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8027e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8027ee:	c9                   	leaveq 
  8027ef:	c3                   	retq   

00000000008027f0 <close>:

int
close(int fdnum)
{
  8027f0:	55                   	push   %rbp
  8027f1:	48 89 e5             	mov    %rsp,%rbp
  8027f4:	48 83 ec 20          	sub    $0x20,%rsp
  8027f8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027fb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027ff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802802:	48 89 d6             	mov    %rdx,%rsi
  802805:	89 c7                	mov    %eax,%edi
  802807:	48 b8 e0 25 80 00 00 	movabs $0x8025e0,%rax
  80280e:	00 00 00 
  802811:	ff d0                	callq  *%rax
  802813:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802816:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80281a:	79 05                	jns    802821 <close+0x31>
		return r;
  80281c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80281f:	eb 18                	jmp    802839 <close+0x49>
	else
		return fd_close(fd, 1);
  802821:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802825:	be 01 00 00 00       	mov    $0x1,%esi
  80282a:	48 89 c7             	mov    %rax,%rdi
  80282d:	48 b8 70 26 80 00 00 	movabs $0x802670,%rax
  802834:	00 00 00 
  802837:	ff d0                	callq  *%rax
}
  802839:	c9                   	leaveq 
  80283a:	c3                   	retq   

000000000080283b <close_all>:

void
close_all(void)
{
  80283b:	55                   	push   %rbp
  80283c:	48 89 e5             	mov    %rsp,%rbp
  80283f:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802843:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80284a:	eb 15                	jmp    802861 <close_all+0x26>
		close(i);
  80284c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80284f:	89 c7                	mov    %eax,%edi
  802851:	48 b8 f0 27 80 00 00 	movabs $0x8027f0,%rax
  802858:	00 00 00 
  80285b:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80285d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802861:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802865:	7e e5                	jle    80284c <close_all+0x11>
		close(i);
}
  802867:	c9                   	leaveq 
  802868:	c3                   	retq   

0000000000802869 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802869:	55                   	push   %rbp
  80286a:	48 89 e5             	mov    %rsp,%rbp
  80286d:	48 83 ec 40          	sub    $0x40,%rsp
  802871:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802874:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802877:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80287b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80287e:	48 89 d6             	mov    %rdx,%rsi
  802881:	89 c7                	mov    %eax,%edi
  802883:	48 b8 e0 25 80 00 00 	movabs $0x8025e0,%rax
  80288a:	00 00 00 
  80288d:	ff d0                	callq  *%rax
  80288f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802892:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802896:	79 08                	jns    8028a0 <dup+0x37>
		return r;
  802898:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80289b:	e9 70 01 00 00       	jmpq   802a10 <dup+0x1a7>
	close(newfdnum);
  8028a0:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8028a3:	89 c7                	mov    %eax,%edi
  8028a5:	48 b8 f0 27 80 00 00 	movabs $0x8027f0,%rax
  8028ac:	00 00 00 
  8028af:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8028b1:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8028b4:	48 98                	cltq   
  8028b6:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8028bc:	48 c1 e0 0c          	shl    $0xc,%rax
  8028c0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8028c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028c8:	48 89 c7             	mov    %rax,%rdi
  8028cb:	48 b8 1d 25 80 00 00 	movabs $0x80251d,%rax
  8028d2:	00 00 00 
  8028d5:	ff d0                	callq  *%rax
  8028d7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8028db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028df:	48 89 c7             	mov    %rax,%rdi
  8028e2:	48 b8 1d 25 80 00 00 	movabs $0x80251d,%rax
  8028e9:	00 00 00 
  8028ec:	ff d0                	callq  *%rax
  8028ee:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8028f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028f6:	48 c1 e8 15          	shr    $0x15,%rax
  8028fa:	48 89 c2             	mov    %rax,%rdx
  8028fd:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802904:	01 00 00 
  802907:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80290b:	83 e0 01             	and    $0x1,%eax
  80290e:	48 85 c0             	test   %rax,%rax
  802911:	74 73                	je     802986 <dup+0x11d>
  802913:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802917:	48 c1 e8 0c          	shr    $0xc,%rax
  80291b:	48 89 c2             	mov    %rax,%rdx
  80291e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802925:	01 00 00 
  802928:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80292c:	83 e0 01             	and    $0x1,%eax
  80292f:	48 85 c0             	test   %rax,%rax
  802932:	74 52                	je     802986 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802934:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802938:	48 c1 e8 0c          	shr    $0xc,%rax
  80293c:	48 89 c2             	mov    %rax,%rdx
  80293f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802946:	01 00 00 
  802949:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80294d:	25 07 0e 00 00       	and    $0xe07,%eax
  802952:	89 c1                	mov    %eax,%ecx
  802954:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802958:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80295c:	41 89 c8             	mov    %ecx,%r8d
  80295f:	48 89 d1             	mov    %rdx,%rcx
  802962:	ba 00 00 00 00       	mov    $0x0,%edx
  802967:	48 89 c6             	mov    %rax,%rsi
  80296a:	bf 00 00 00 00       	mov    $0x0,%edi
  80296f:	48 b8 ad 1b 80 00 00 	movabs $0x801bad,%rax
  802976:	00 00 00 
  802979:	ff d0                	callq  *%rax
  80297b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80297e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802982:	79 02                	jns    802986 <dup+0x11d>
			goto err;
  802984:	eb 57                	jmp    8029dd <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802986:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80298a:	48 c1 e8 0c          	shr    $0xc,%rax
  80298e:	48 89 c2             	mov    %rax,%rdx
  802991:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802998:	01 00 00 
  80299b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80299f:	25 07 0e 00 00       	and    $0xe07,%eax
  8029a4:	89 c1                	mov    %eax,%ecx
  8029a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029aa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8029ae:	41 89 c8             	mov    %ecx,%r8d
  8029b1:	48 89 d1             	mov    %rdx,%rcx
  8029b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8029b9:	48 89 c6             	mov    %rax,%rsi
  8029bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8029c1:	48 b8 ad 1b 80 00 00 	movabs $0x801bad,%rax
  8029c8:	00 00 00 
  8029cb:	ff d0                	callq  *%rax
  8029cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029d4:	79 02                	jns    8029d8 <dup+0x16f>
		goto err;
  8029d6:	eb 05                	jmp    8029dd <dup+0x174>

	return newfdnum;
  8029d8:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8029db:	eb 33                	jmp    802a10 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8029dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029e1:	48 89 c6             	mov    %rax,%rsi
  8029e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8029e9:	48 b8 08 1c 80 00 00 	movabs $0x801c08,%rax
  8029f0:	00 00 00 
  8029f3:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8029f5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029f9:	48 89 c6             	mov    %rax,%rsi
  8029fc:	bf 00 00 00 00       	mov    $0x0,%edi
  802a01:	48 b8 08 1c 80 00 00 	movabs $0x801c08,%rax
  802a08:	00 00 00 
  802a0b:	ff d0                	callq  *%rax
	return r;
  802a0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a10:	c9                   	leaveq 
  802a11:	c3                   	retq   

0000000000802a12 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802a12:	55                   	push   %rbp
  802a13:	48 89 e5             	mov    %rsp,%rbp
  802a16:	48 83 ec 40          	sub    $0x40,%rsp
  802a1a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a1d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a21:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a25:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a29:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a2c:	48 89 d6             	mov    %rdx,%rsi
  802a2f:	89 c7                	mov    %eax,%edi
  802a31:	48 b8 e0 25 80 00 00 	movabs $0x8025e0,%rax
  802a38:	00 00 00 
  802a3b:	ff d0                	callq  *%rax
  802a3d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a40:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a44:	78 24                	js     802a6a <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a4a:	8b 00                	mov    (%rax),%eax
  802a4c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a50:	48 89 d6             	mov    %rdx,%rsi
  802a53:	89 c7                	mov    %eax,%edi
  802a55:	48 b8 39 27 80 00 00 	movabs $0x802739,%rax
  802a5c:	00 00 00 
  802a5f:	ff d0                	callq  *%rax
  802a61:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a64:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a68:	79 05                	jns    802a6f <read+0x5d>
		return r;
  802a6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a6d:	eb 76                	jmp    802ae5 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802a6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a73:	8b 40 08             	mov    0x8(%rax),%eax
  802a76:	83 e0 03             	and    $0x3,%eax
  802a79:	83 f8 01             	cmp    $0x1,%eax
  802a7c:	75 3a                	jne    802ab8 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802a7e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802a85:	00 00 00 
  802a88:	48 8b 00             	mov    (%rax),%rax
  802a8b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a91:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a94:	89 c6                	mov    %eax,%esi
  802a96:	48 bf 57 45 80 00 00 	movabs $0x804557,%rdi
  802a9d:	00 00 00 
  802aa0:	b8 00 00 00 00       	mov    $0x0,%eax
  802aa5:	48 b9 79 06 80 00 00 	movabs $0x800679,%rcx
  802aac:	00 00 00 
  802aaf:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802ab1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ab6:	eb 2d                	jmp    802ae5 <read+0xd3>
	}
	if (!dev->dev_read)
  802ab8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802abc:	48 8b 40 10          	mov    0x10(%rax),%rax
  802ac0:	48 85 c0             	test   %rax,%rax
  802ac3:	75 07                	jne    802acc <read+0xba>
		return -E_NOT_SUPP;
  802ac5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802aca:	eb 19                	jmp    802ae5 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802acc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ad0:	48 8b 40 10          	mov    0x10(%rax),%rax
  802ad4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802ad8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802adc:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802ae0:	48 89 cf             	mov    %rcx,%rdi
  802ae3:	ff d0                	callq  *%rax
}
  802ae5:	c9                   	leaveq 
  802ae6:	c3                   	retq   

0000000000802ae7 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802ae7:	55                   	push   %rbp
  802ae8:	48 89 e5             	mov    %rsp,%rbp
  802aeb:	48 83 ec 30          	sub    $0x30,%rsp
  802aef:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802af2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802af6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802afa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b01:	eb 49                	jmp    802b4c <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802b03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b06:	48 98                	cltq   
  802b08:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b0c:	48 29 c2             	sub    %rax,%rdx
  802b0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b12:	48 63 c8             	movslq %eax,%rcx
  802b15:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b19:	48 01 c1             	add    %rax,%rcx
  802b1c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b1f:	48 89 ce             	mov    %rcx,%rsi
  802b22:	89 c7                	mov    %eax,%edi
  802b24:	48 b8 12 2a 80 00 00 	movabs $0x802a12,%rax
  802b2b:	00 00 00 
  802b2e:	ff d0                	callq  *%rax
  802b30:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802b33:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b37:	79 05                	jns    802b3e <readn+0x57>
			return m;
  802b39:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b3c:	eb 1c                	jmp    802b5a <readn+0x73>
		if (m == 0)
  802b3e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b42:	75 02                	jne    802b46 <readn+0x5f>
			break;
  802b44:	eb 11                	jmp    802b57 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802b46:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b49:	01 45 fc             	add    %eax,-0x4(%rbp)
  802b4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b4f:	48 98                	cltq   
  802b51:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802b55:	72 ac                	jb     802b03 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802b57:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b5a:	c9                   	leaveq 
  802b5b:	c3                   	retq   

0000000000802b5c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802b5c:	55                   	push   %rbp
  802b5d:	48 89 e5             	mov    %rsp,%rbp
  802b60:	48 83 ec 40          	sub    $0x40,%rsp
  802b64:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b67:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b6b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b6f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b73:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b76:	48 89 d6             	mov    %rdx,%rsi
  802b79:	89 c7                	mov    %eax,%edi
  802b7b:	48 b8 e0 25 80 00 00 	movabs $0x8025e0,%rax
  802b82:	00 00 00 
  802b85:	ff d0                	callq  *%rax
  802b87:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b8a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b8e:	78 24                	js     802bb4 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b94:	8b 00                	mov    (%rax),%eax
  802b96:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b9a:	48 89 d6             	mov    %rdx,%rsi
  802b9d:	89 c7                	mov    %eax,%edi
  802b9f:	48 b8 39 27 80 00 00 	movabs $0x802739,%rax
  802ba6:	00 00 00 
  802ba9:	ff d0                	callq  *%rax
  802bab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bb2:	79 05                	jns    802bb9 <write+0x5d>
		return r;
  802bb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bb7:	eb 75                	jmp    802c2e <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802bb9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bbd:	8b 40 08             	mov    0x8(%rax),%eax
  802bc0:	83 e0 03             	and    $0x3,%eax
  802bc3:	85 c0                	test   %eax,%eax
  802bc5:	75 3a                	jne    802c01 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802bc7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802bce:	00 00 00 
  802bd1:	48 8b 00             	mov    (%rax),%rax
  802bd4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802bda:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802bdd:	89 c6                	mov    %eax,%esi
  802bdf:	48 bf 73 45 80 00 00 	movabs $0x804573,%rdi
  802be6:	00 00 00 
  802be9:	b8 00 00 00 00       	mov    $0x0,%eax
  802bee:	48 b9 79 06 80 00 00 	movabs $0x800679,%rcx
  802bf5:	00 00 00 
  802bf8:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802bfa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bff:	eb 2d                	jmp    802c2e <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802c01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c05:	48 8b 40 18          	mov    0x18(%rax),%rax
  802c09:	48 85 c0             	test   %rax,%rax
  802c0c:	75 07                	jne    802c15 <write+0xb9>
		return -E_NOT_SUPP;
  802c0e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c13:	eb 19                	jmp    802c2e <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802c15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c19:	48 8b 40 18          	mov    0x18(%rax),%rax
  802c1d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802c21:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c25:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802c29:	48 89 cf             	mov    %rcx,%rdi
  802c2c:	ff d0                	callq  *%rax
}
  802c2e:	c9                   	leaveq 
  802c2f:	c3                   	retq   

0000000000802c30 <seek>:

int
seek(int fdnum, off_t offset)
{
  802c30:	55                   	push   %rbp
  802c31:	48 89 e5             	mov    %rsp,%rbp
  802c34:	48 83 ec 18          	sub    $0x18,%rsp
  802c38:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c3b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c3e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c42:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c45:	48 89 d6             	mov    %rdx,%rsi
  802c48:	89 c7                	mov    %eax,%edi
  802c4a:	48 b8 e0 25 80 00 00 	movabs $0x8025e0,%rax
  802c51:	00 00 00 
  802c54:	ff d0                	callq  *%rax
  802c56:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c59:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c5d:	79 05                	jns    802c64 <seek+0x34>
		return r;
  802c5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c62:	eb 0f                	jmp    802c73 <seek+0x43>
	fd->fd_offset = offset;
  802c64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c68:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c6b:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802c6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c73:	c9                   	leaveq 
  802c74:	c3                   	retq   

0000000000802c75 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802c75:	55                   	push   %rbp
  802c76:	48 89 e5             	mov    %rsp,%rbp
  802c79:	48 83 ec 30          	sub    $0x30,%rsp
  802c7d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c80:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c83:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c87:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c8a:	48 89 d6             	mov    %rdx,%rsi
  802c8d:	89 c7                	mov    %eax,%edi
  802c8f:	48 b8 e0 25 80 00 00 	movabs $0x8025e0,%rax
  802c96:	00 00 00 
  802c99:	ff d0                	callq  *%rax
  802c9b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c9e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ca2:	78 24                	js     802cc8 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ca4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ca8:	8b 00                	mov    (%rax),%eax
  802caa:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cae:	48 89 d6             	mov    %rdx,%rsi
  802cb1:	89 c7                	mov    %eax,%edi
  802cb3:	48 b8 39 27 80 00 00 	movabs $0x802739,%rax
  802cba:	00 00 00 
  802cbd:	ff d0                	callq  *%rax
  802cbf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cc2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cc6:	79 05                	jns    802ccd <ftruncate+0x58>
		return r;
  802cc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ccb:	eb 72                	jmp    802d3f <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802ccd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cd1:	8b 40 08             	mov    0x8(%rax),%eax
  802cd4:	83 e0 03             	and    $0x3,%eax
  802cd7:	85 c0                	test   %eax,%eax
  802cd9:	75 3a                	jne    802d15 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802cdb:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802ce2:	00 00 00 
  802ce5:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802ce8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802cee:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802cf1:	89 c6                	mov    %eax,%esi
  802cf3:	48 bf 90 45 80 00 00 	movabs $0x804590,%rdi
  802cfa:	00 00 00 
  802cfd:	b8 00 00 00 00       	mov    $0x0,%eax
  802d02:	48 b9 79 06 80 00 00 	movabs $0x800679,%rcx
  802d09:	00 00 00 
  802d0c:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802d0e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d13:	eb 2a                	jmp    802d3f <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802d15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d19:	48 8b 40 30          	mov    0x30(%rax),%rax
  802d1d:	48 85 c0             	test   %rax,%rax
  802d20:	75 07                	jne    802d29 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802d22:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d27:	eb 16                	jmp    802d3f <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802d29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d2d:	48 8b 40 30          	mov    0x30(%rax),%rax
  802d31:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d35:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802d38:	89 ce                	mov    %ecx,%esi
  802d3a:	48 89 d7             	mov    %rdx,%rdi
  802d3d:	ff d0                	callq  *%rax
}
  802d3f:	c9                   	leaveq 
  802d40:	c3                   	retq   

0000000000802d41 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802d41:	55                   	push   %rbp
  802d42:	48 89 e5             	mov    %rsp,%rbp
  802d45:	48 83 ec 30          	sub    $0x30,%rsp
  802d49:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d4c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d50:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d54:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d57:	48 89 d6             	mov    %rdx,%rsi
  802d5a:	89 c7                	mov    %eax,%edi
  802d5c:	48 b8 e0 25 80 00 00 	movabs $0x8025e0,%rax
  802d63:	00 00 00 
  802d66:	ff d0                	callq  *%rax
  802d68:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d6f:	78 24                	js     802d95 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d75:	8b 00                	mov    (%rax),%eax
  802d77:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d7b:	48 89 d6             	mov    %rdx,%rsi
  802d7e:	89 c7                	mov    %eax,%edi
  802d80:	48 b8 39 27 80 00 00 	movabs $0x802739,%rax
  802d87:	00 00 00 
  802d8a:	ff d0                	callq  *%rax
  802d8c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d8f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d93:	79 05                	jns    802d9a <fstat+0x59>
		return r;
  802d95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d98:	eb 5e                	jmp    802df8 <fstat+0xb7>
	if (!dev->dev_stat)
  802d9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d9e:	48 8b 40 28          	mov    0x28(%rax),%rax
  802da2:	48 85 c0             	test   %rax,%rax
  802da5:	75 07                	jne    802dae <fstat+0x6d>
		return -E_NOT_SUPP;
  802da7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802dac:	eb 4a                	jmp    802df8 <fstat+0xb7>
	stat->st_name[0] = 0;
  802dae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802db2:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802db5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802db9:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802dc0:	00 00 00 
	stat->st_isdir = 0;
  802dc3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dc7:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802dce:	00 00 00 
	stat->st_dev = dev;
  802dd1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802dd5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dd9:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802de0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de4:	48 8b 40 28          	mov    0x28(%rax),%rax
  802de8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802dec:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802df0:	48 89 ce             	mov    %rcx,%rsi
  802df3:	48 89 d7             	mov    %rdx,%rdi
  802df6:	ff d0                	callq  *%rax
}
  802df8:	c9                   	leaveq 
  802df9:	c3                   	retq   

0000000000802dfa <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802dfa:	55                   	push   %rbp
  802dfb:	48 89 e5             	mov    %rsp,%rbp
  802dfe:	48 83 ec 20          	sub    $0x20,%rsp
  802e02:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e06:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802e0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e0e:	be 00 00 00 00       	mov    $0x0,%esi
  802e13:	48 89 c7             	mov    %rax,%rdi
  802e16:	48 b8 e8 2e 80 00 00 	movabs $0x802ee8,%rax
  802e1d:	00 00 00 
  802e20:	ff d0                	callq  *%rax
  802e22:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e25:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e29:	79 05                	jns    802e30 <stat+0x36>
		return fd;
  802e2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e2e:	eb 2f                	jmp    802e5f <stat+0x65>
	r = fstat(fd, stat);
  802e30:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802e34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e37:	48 89 d6             	mov    %rdx,%rsi
  802e3a:	89 c7                	mov    %eax,%edi
  802e3c:	48 b8 41 2d 80 00 00 	movabs $0x802d41,%rax
  802e43:	00 00 00 
  802e46:	ff d0                	callq  *%rax
  802e48:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802e4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e4e:	89 c7                	mov    %eax,%edi
  802e50:	48 b8 f0 27 80 00 00 	movabs $0x8027f0,%rax
  802e57:	00 00 00 
  802e5a:	ff d0                	callq  *%rax
	return r;
  802e5c:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802e5f:	c9                   	leaveq 
  802e60:	c3                   	retq   

0000000000802e61 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802e61:	55                   	push   %rbp
  802e62:	48 89 e5             	mov    %rsp,%rbp
  802e65:	48 83 ec 10          	sub    $0x10,%rsp
  802e69:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802e6c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802e70:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e77:	00 00 00 
  802e7a:	8b 00                	mov    (%rax),%eax
  802e7c:	85 c0                	test   %eax,%eax
  802e7e:	75 1d                	jne    802e9d <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802e80:	bf 01 00 00 00       	mov    $0x1,%edi
  802e85:	48 b8 78 24 80 00 00 	movabs $0x802478,%rax
  802e8c:	00 00 00 
  802e8f:	ff d0                	callq  *%rax
  802e91:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802e98:	00 00 00 
  802e9b:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802e9d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802ea4:	00 00 00 
  802ea7:	8b 00                	mov    (%rax),%eax
  802ea9:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802eac:	b9 07 00 00 00       	mov    $0x7,%ecx
  802eb1:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802eb8:	00 00 00 
  802ebb:	89 c7                	mov    %eax,%edi
  802ebd:	48 b8 db 23 80 00 00 	movabs $0x8023db,%rax
  802ec4:	00 00 00 
  802ec7:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802ec9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ecd:	ba 00 00 00 00       	mov    $0x0,%edx
  802ed2:	48 89 c6             	mov    %rax,%rsi
  802ed5:	bf 00 00 00 00       	mov    $0x0,%edi
  802eda:	48 b8 15 23 80 00 00 	movabs $0x802315,%rax
  802ee1:	00 00 00 
  802ee4:	ff d0                	callq  *%rax
}
  802ee6:	c9                   	leaveq 
  802ee7:	c3                   	retq   

0000000000802ee8 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802ee8:	55                   	push   %rbp
  802ee9:	48 89 e5             	mov    %rsp,%rbp
  802eec:	48 83 ec 20          	sub    $0x20,%rsp
  802ef0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ef4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  802ef7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802efb:	48 89 c7             	mov    %rax,%rdi
  802efe:	48 b8 c2 11 80 00 00 	movabs $0x8011c2,%rax
  802f05:	00 00 00 
  802f08:	ff d0                	callq  *%rax
  802f0a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802f0f:	7e 0a                	jle    802f1b <open+0x33>
  802f11:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802f16:	e9 a5 00 00 00       	jmpq   802fc0 <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  802f1b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802f1f:	48 89 c7             	mov    %rax,%rdi
  802f22:	48 b8 48 25 80 00 00 	movabs $0x802548,%rax
  802f29:	00 00 00 
  802f2c:	ff d0                	callq  *%rax
  802f2e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f31:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f35:	79 08                	jns    802f3f <open+0x57>
		return r;
  802f37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f3a:	e9 81 00 00 00       	jmpq   802fc0 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  802f3f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f46:	00 00 00 
  802f49:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802f4c:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  802f52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f56:	48 89 c6             	mov    %rax,%rsi
  802f59:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802f60:	00 00 00 
  802f63:	48 b8 2e 12 80 00 00 	movabs $0x80122e,%rax
  802f6a:	00 00 00 
  802f6d:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  802f6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f73:	48 89 c6             	mov    %rax,%rsi
  802f76:	bf 01 00 00 00       	mov    $0x1,%edi
  802f7b:	48 b8 61 2e 80 00 00 	movabs $0x802e61,%rax
  802f82:	00 00 00 
  802f85:	ff d0                	callq  *%rax
  802f87:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f8a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f8e:	79 1d                	jns    802fad <open+0xc5>
		fd_close(fd, 0);
  802f90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f94:	be 00 00 00 00       	mov    $0x0,%esi
  802f99:	48 89 c7             	mov    %rax,%rdi
  802f9c:	48 b8 70 26 80 00 00 	movabs $0x802670,%rax
  802fa3:	00 00 00 
  802fa6:	ff d0                	callq  *%rax
		return r;
  802fa8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fab:	eb 13                	jmp    802fc0 <open+0xd8>
	}
	return fd2num(fd);
  802fad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fb1:	48 89 c7             	mov    %rax,%rdi
  802fb4:	48 b8 fa 24 80 00 00 	movabs $0x8024fa,%rax
  802fbb:	00 00 00 
  802fbe:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  802fc0:	c9                   	leaveq 
  802fc1:	c3                   	retq   

0000000000802fc2 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802fc2:	55                   	push   %rbp
  802fc3:	48 89 e5             	mov    %rsp,%rbp
  802fc6:	48 83 ec 10          	sub    $0x10,%rsp
  802fca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802fce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fd2:	8b 50 0c             	mov    0xc(%rax),%edx
  802fd5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fdc:	00 00 00 
  802fdf:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802fe1:	be 00 00 00 00       	mov    $0x0,%esi
  802fe6:	bf 06 00 00 00       	mov    $0x6,%edi
  802feb:	48 b8 61 2e 80 00 00 	movabs $0x802e61,%rax
  802ff2:	00 00 00 
  802ff5:	ff d0                	callq  *%rax
}
  802ff7:	c9                   	leaveq 
  802ff8:	c3                   	retq   

0000000000802ff9 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802ff9:	55                   	push   %rbp
  802ffa:	48 89 e5             	mov    %rsp,%rbp
  802ffd:	48 83 ec 30          	sub    $0x30,%rsp
  803001:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803005:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803009:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80300d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803011:	8b 50 0c             	mov    0xc(%rax),%edx
  803014:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80301b:	00 00 00 
  80301e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803020:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803027:	00 00 00 
  80302a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80302e:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  803032:	be 00 00 00 00       	mov    $0x0,%esi
  803037:	bf 03 00 00 00       	mov    $0x3,%edi
  80303c:	48 b8 61 2e 80 00 00 	movabs $0x802e61,%rax
  803043:	00 00 00 
  803046:	ff d0                	callq  *%rax
  803048:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80304b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80304f:	79 05                	jns    803056 <devfile_read+0x5d>
		return r;
  803051:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803054:	eb 26                	jmp    80307c <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  803056:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803059:	48 63 d0             	movslq %eax,%rdx
  80305c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803060:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803067:	00 00 00 
  80306a:	48 89 c7             	mov    %rax,%rdi
  80306d:	48 b8 69 16 80 00 00 	movabs $0x801669,%rax
  803074:	00 00 00 
  803077:	ff d0                	callq  *%rax
	return r;
  803079:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80307c:	c9                   	leaveq 
  80307d:	c3                   	retq   

000000000080307e <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80307e:	55                   	push   %rbp
  80307f:	48 89 e5             	mov    %rsp,%rbp
  803082:	48 83 ec 30          	sub    $0x30,%rsp
  803086:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80308a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80308e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  803092:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  803099:	00 
	n = n > max ? max : n;
  80309a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80309e:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8030a2:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  8030a7:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8030ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030af:	8b 50 0c             	mov    0xc(%rax),%edx
  8030b2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030b9:	00 00 00 
  8030bc:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8030be:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030c5:	00 00 00 
  8030c8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030cc:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8030d0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030d8:	48 89 c6             	mov    %rax,%rsi
  8030db:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8030e2:	00 00 00 
  8030e5:	48 b8 69 16 80 00 00 	movabs $0x801669,%rax
  8030ec:	00 00 00 
  8030ef:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  8030f1:	be 00 00 00 00       	mov    $0x0,%esi
  8030f6:	bf 04 00 00 00       	mov    $0x4,%edi
  8030fb:	48 b8 61 2e 80 00 00 	movabs $0x802e61,%rax
  803102:	00 00 00 
  803105:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  803107:	c9                   	leaveq 
  803108:	c3                   	retq   

0000000000803109 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803109:	55                   	push   %rbp
  80310a:	48 89 e5             	mov    %rsp,%rbp
  80310d:	48 83 ec 20          	sub    $0x20,%rsp
  803111:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803115:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803119:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80311d:	8b 50 0c             	mov    0xc(%rax),%edx
  803120:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803127:	00 00 00 
  80312a:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80312c:	be 00 00 00 00       	mov    $0x0,%esi
  803131:	bf 05 00 00 00       	mov    $0x5,%edi
  803136:	48 b8 61 2e 80 00 00 	movabs $0x802e61,%rax
  80313d:	00 00 00 
  803140:	ff d0                	callq  *%rax
  803142:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803145:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803149:	79 05                	jns    803150 <devfile_stat+0x47>
		return r;
  80314b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80314e:	eb 56                	jmp    8031a6 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803150:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803154:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80315b:	00 00 00 
  80315e:	48 89 c7             	mov    %rax,%rdi
  803161:	48 b8 2e 12 80 00 00 	movabs $0x80122e,%rax
  803168:	00 00 00 
  80316b:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80316d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803174:	00 00 00 
  803177:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80317d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803181:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803187:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80318e:	00 00 00 
  803191:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803197:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80319b:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8031a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031a6:	c9                   	leaveq 
  8031a7:	c3                   	retq   

00000000008031a8 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8031a8:	55                   	push   %rbp
  8031a9:	48 89 e5             	mov    %rsp,%rbp
  8031ac:	48 83 ec 10          	sub    $0x10,%rsp
  8031b0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031b4:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8031b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031bb:	8b 50 0c             	mov    0xc(%rax),%edx
  8031be:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031c5:	00 00 00 
  8031c8:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8031ca:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031d1:	00 00 00 
  8031d4:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8031d7:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8031da:	be 00 00 00 00       	mov    $0x0,%esi
  8031df:	bf 02 00 00 00       	mov    $0x2,%edi
  8031e4:	48 b8 61 2e 80 00 00 	movabs $0x802e61,%rax
  8031eb:	00 00 00 
  8031ee:	ff d0                	callq  *%rax
}
  8031f0:	c9                   	leaveq 
  8031f1:	c3                   	retq   

00000000008031f2 <remove>:

// Delete a file
int
remove(const char *path)
{
  8031f2:	55                   	push   %rbp
  8031f3:	48 89 e5             	mov    %rsp,%rbp
  8031f6:	48 83 ec 10          	sub    $0x10,%rsp
  8031fa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8031fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803202:	48 89 c7             	mov    %rax,%rdi
  803205:	48 b8 c2 11 80 00 00 	movabs $0x8011c2,%rax
  80320c:	00 00 00 
  80320f:	ff d0                	callq  *%rax
  803211:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803216:	7e 07                	jle    80321f <remove+0x2d>
		return -E_BAD_PATH;
  803218:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80321d:	eb 33                	jmp    803252 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80321f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803223:	48 89 c6             	mov    %rax,%rsi
  803226:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80322d:	00 00 00 
  803230:	48 b8 2e 12 80 00 00 	movabs $0x80122e,%rax
  803237:	00 00 00 
  80323a:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80323c:	be 00 00 00 00       	mov    $0x0,%esi
  803241:	bf 07 00 00 00       	mov    $0x7,%edi
  803246:	48 b8 61 2e 80 00 00 	movabs $0x802e61,%rax
  80324d:	00 00 00 
  803250:	ff d0                	callq  *%rax
}
  803252:	c9                   	leaveq 
  803253:	c3                   	retq   

0000000000803254 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803254:	55                   	push   %rbp
  803255:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803258:	be 00 00 00 00       	mov    $0x0,%esi
  80325d:	bf 08 00 00 00       	mov    $0x8,%edi
  803262:	48 b8 61 2e 80 00 00 	movabs $0x802e61,%rax
  803269:	00 00 00 
  80326c:	ff d0                	callq  *%rax
}
  80326e:	5d                   	pop    %rbp
  80326f:	c3                   	retq   

0000000000803270 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803270:	55                   	push   %rbp
  803271:	48 89 e5             	mov    %rsp,%rbp
  803274:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80327b:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803282:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803289:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803290:	be 00 00 00 00       	mov    $0x0,%esi
  803295:	48 89 c7             	mov    %rax,%rdi
  803298:	48 b8 e8 2e 80 00 00 	movabs $0x802ee8,%rax
  80329f:	00 00 00 
  8032a2:	ff d0                	callq  *%rax
  8032a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8032a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032ab:	79 28                	jns    8032d5 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8032ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032b0:	89 c6                	mov    %eax,%esi
  8032b2:	48 bf b6 45 80 00 00 	movabs $0x8045b6,%rdi
  8032b9:	00 00 00 
  8032bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8032c1:	48 ba 79 06 80 00 00 	movabs $0x800679,%rdx
  8032c8:	00 00 00 
  8032cb:	ff d2                	callq  *%rdx
		return fd_src;
  8032cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032d0:	e9 74 01 00 00       	jmpq   803449 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8032d5:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8032dc:	be 01 01 00 00       	mov    $0x101,%esi
  8032e1:	48 89 c7             	mov    %rax,%rdi
  8032e4:	48 b8 e8 2e 80 00 00 	movabs $0x802ee8,%rax
  8032eb:	00 00 00 
  8032ee:	ff d0                	callq  *%rax
  8032f0:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8032f3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8032f7:	79 39                	jns    803332 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8032f9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032fc:	89 c6                	mov    %eax,%esi
  8032fe:	48 bf cc 45 80 00 00 	movabs $0x8045cc,%rdi
  803305:	00 00 00 
  803308:	b8 00 00 00 00       	mov    $0x0,%eax
  80330d:	48 ba 79 06 80 00 00 	movabs $0x800679,%rdx
  803314:	00 00 00 
  803317:	ff d2                	callq  *%rdx
		close(fd_src);
  803319:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80331c:	89 c7                	mov    %eax,%edi
  80331e:	48 b8 f0 27 80 00 00 	movabs $0x8027f0,%rax
  803325:	00 00 00 
  803328:	ff d0                	callq  *%rax
		return fd_dest;
  80332a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80332d:	e9 17 01 00 00       	jmpq   803449 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803332:	eb 74                	jmp    8033a8 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803334:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803337:	48 63 d0             	movslq %eax,%rdx
  80333a:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803341:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803344:	48 89 ce             	mov    %rcx,%rsi
  803347:	89 c7                	mov    %eax,%edi
  803349:	48 b8 5c 2b 80 00 00 	movabs $0x802b5c,%rax
  803350:	00 00 00 
  803353:	ff d0                	callq  *%rax
  803355:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803358:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80335c:	79 4a                	jns    8033a8 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  80335e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803361:	89 c6                	mov    %eax,%esi
  803363:	48 bf e6 45 80 00 00 	movabs $0x8045e6,%rdi
  80336a:	00 00 00 
  80336d:	b8 00 00 00 00       	mov    $0x0,%eax
  803372:	48 ba 79 06 80 00 00 	movabs $0x800679,%rdx
  803379:	00 00 00 
  80337c:	ff d2                	callq  *%rdx
			close(fd_src);
  80337e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803381:	89 c7                	mov    %eax,%edi
  803383:	48 b8 f0 27 80 00 00 	movabs $0x8027f0,%rax
  80338a:	00 00 00 
  80338d:	ff d0                	callq  *%rax
			close(fd_dest);
  80338f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803392:	89 c7                	mov    %eax,%edi
  803394:	48 b8 f0 27 80 00 00 	movabs $0x8027f0,%rax
  80339b:	00 00 00 
  80339e:	ff d0                	callq  *%rax
			return write_size;
  8033a0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8033a3:	e9 a1 00 00 00       	jmpq   803449 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8033a8:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8033af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033b2:	ba 00 02 00 00       	mov    $0x200,%edx
  8033b7:	48 89 ce             	mov    %rcx,%rsi
  8033ba:	89 c7                	mov    %eax,%edi
  8033bc:	48 b8 12 2a 80 00 00 	movabs $0x802a12,%rax
  8033c3:	00 00 00 
  8033c6:	ff d0                	callq  *%rax
  8033c8:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8033cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8033cf:	0f 8f 5f ff ff ff    	jg     803334 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8033d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8033d9:	79 47                	jns    803422 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8033db:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8033de:	89 c6                	mov    %eax,%esi
  8033e0:	48 bf f9 45 80 00 00 	movabs $0x8045f9,%rdi
  8033e7:	00 00 00 
  8033ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8033ef:	48 ba 79 06 80 00 00 	movabs $0x800679,%rdx
  8033f6:	00 00 00 
  8033f9:	ff d2                	callq  *%rdx
		close(fd_src);
  8033fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033fe:	89 c7                	mov    %eax,%edi
  803400:	48 b8 f0 27 80 00 00 	movabs $0x8027f0,%rax
  803407:	00 00 00 
  80340a:	ff d0                	callq  *%rax
		close(fd_dest);
  80340c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80340f:	89 c7                	mov    %eax,%edi
  803411:	48 b8 f0 27 80 00 00 	movabs $0x8027f0,%rax
  803418:	00 00 00 
  80341b:	ff d0                	callq  *%rax
		return read_size;
  80341d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803420:	eb 27                	jmp    803449 <copy+0x1d9>
	}
	close(fd_src);
  803422:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803425:	89 c7                	mov    %eax,%edi
  803427:	48 b8 f0 27 80 00 00 	movabs $0x8027f0,%rax
  80342e:	00 00 00 
  803431:	ff d0                	callq  *%rax
	close(fd_dest);
  803433:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803436:	89 c7                	mov    %eax,%edi
  803438:	48 b8 f0 27 80 00 00 	movabs $0x8027f0,%rax
  80343f:	00 00 00 
  803442:	ff d0                	callq  *%rax
	return 0;
  803444:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803449:	c9                   	leaveq 
  80344a:	c3                   	retq   

000000000080344b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80344b:	55                   	push   %rbp
  80344c:	48 89 e5             	mov    %rsp,%rbp
  80344f:	48 83 ec 18          	sub    $0x18,%rsp
  803453:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803457:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80345b:	48 c1 e8 15          	shr    $0x15,%rax
  80345f:	48 89 c2             	mov    %rax,%rdx
  803462:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803469:	01 00 00 
  80346c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803470:	83 e0 01             	and    $0x1,%eax
  803473:	48 85 c0             	test   %rax,%rax
  803476:	75 07                	jne    80347f <pageref+0x34>
		return 0;
  803478:	b8 00 00 00 00       	mov    $0x0,%eax
  80347d:	eb 53                	jmp    8034d2 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80347f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803483:	48 c1 e8 0c          	shr    $0xc,%rax
  803487:	48 89 c2             	mov    %rax,%rdx
  80348a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803491:	01 00 00 
  803494:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803498:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80349c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034a0:	83 e0 01             	and    $0x1,%eax
  8034a3:	48 85 c0             	test   %rax,%rax
  8034a6:	75 07                	jne    8034af <pageref+0x64>
		return 0;
  8034a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ad:	eb 23                	jmp    8034d2 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8034af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034b3:	48 c1 e8 0c          	shr    $0xc,%rax
  8034b7:	48 89 c2             	mov    %rax,%rdx
  8034ba:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8034c1:	00 00 00 
  8034c4:	48 c1 e2 04          	shl    $0x4,%rdx
  8034c8:	48 01 d0             	add    %rdx,%rax
  8034cb:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8034cf:	0f b7 c0             	movzwl %ax,%eax
}
  8034d2:	c9                   	leaveq 
  8034d3:	c3                   	retq   

00000000008034d4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8034d4:	55                   	push   %rbp
  8034d5:	48 89 e5             	mov    %rsp,%rbp
  8034d8:	53                   	push   %rbx
  8034d9:	48 83 ec 38          	sub    $0x38,%rsp
  8034dd:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8034e1:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8034e5:	48 89 c7             	mov    %rax,%rdi
  8034e8:	48 b8 48 25 80 00 00 	movabs $0x802548,%rax
  8034ef:	00 00 00 
  8034f2:	ff d0                	callq  *%rax
  8034f4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034fb:	0f 88 bf 01 00 00    	js     8036c0 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803501:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803505:	ba 07 04 00 00       	mov    $0x407,%edx
  80350a:	48 89 c6             	mov    %rax,%rsi
  80350d:	bf 00 00 00 00       	mov    $0x0,%edi
  803512:	48 b8 5d 1b 80 00 00 	movabs $0x801b5d,%rax
  803519:	00 00 00 
  80351c:	ff d0                	callq  *%rax
  80351e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803521:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803525:	0f 88 95 01 00 00    	js     8036c0 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80352b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80352f:	48 89 c7             	mov    %rax,%rdi
  803532:	48 b8 48 25 80 00 00 	movabs $0x802548,%rax
  803539:	00 00 00 
  80353c:	ff d0                	callq  *%rax
  80353e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803541:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803545:	0f 88 5d 01 00 00    	js     8036a8 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80354b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80354f:	ba 07 04 00 00       	mov    $0x407,%edx
  803554:	48 89 c6             	mov    %rax,%rsi
  803557:	bf 00 00 00 00       	mov    $0x0,%edi
  80355c:	48 b8 5d 1b 80 00 00 	movabs $0x801b5d,%rax
  803563:	00 00 00 
  803566:	ff d0                	callq  *%rax
  803568:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80356b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80356f:	0f 88 33 01 00 00    	js     8036a8 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803575:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803579:	48 89 c7             	mov    %rax,%rdi
  80357c:	48 b8 1d 25 80 00 00 	movabs $0x80251d,%rax
  803583:	00 00 00 
  803586:	ff d0                	callq  *%rax
  803588:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80358c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803590:	ba 07 04 00 00       	mov    $0x407,%edx
  803595:	48 89 c6             	mov    %rax,%rsi
  803598:	bf 00 00 00 00       	mov    $0x0,%edi
  80359d:	48 b8 5d 1b 80 00 00 	movabs $0x801b5d,%rax
  8035a4:	00 00 00 
  8035a7:	ff d0                	callq  *%rax
  8035a9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035b0:	79 05                	jns    8035b7 <pipe+0xe3>
		goto err2;
  8035b2:	e9 d9 00 00 00       	jmpq   803690 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035b7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035bb:	48 89 c7             	mov    %rax,%rdi
  8035be:	48 b8 1d 25 80 00 00 	movabs $0x80251d,%rax
  8035c5:	00 00 00 
  8035c8:	ff d0                	callq  *%rax
  8035ca:	48 89 c2             	mov    %rax,%rdx
  8035cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035d1:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8035d7:	48 89 d1             	mov    %rdx,%rcx
  8035da:	ba 00 00 00 00       	mov    $0x0,%edx
  8035df:	48 89 c6             	mov    %rax,%rsi
  8035e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8035e7:	48 b8 ad 1b 80 00 00 	movabs $0x801bad,%rax
  8035ee:	00 00 00 
  8035f1:	ff d0                	callq  *%rax
  8035f3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035f6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035fa:	79 1b                	jns    803617 <pipe+0x143>
		goto err3;
  8035fc:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8035fd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803601:	48 89 c6             	mov    %rax,%rsi
  803604:	bf 00 00 00 00       	mov    $0x0,%edi
  803609:	48 b8 08 1c 80 00 00 	movabs $0x801c08,%rax
  803610:	00 00 00 
  803613:	ff d0                	callq  *%rax
  803615:	eb 79                	jmp    803690 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803617:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80361b:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803622:	00 00 00 
  803625:	8b 12                	mov    (%rdx),%edx
  803627:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803629:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80362d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803634:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803638:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  80363f:	00 00 00 
  803642:	8b 12                	mov    (%rdx),%edx
  803644:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803646:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80364a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803651:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803655:	48 89 c7             	mov    %rax,%rdi
  803658:	48 b8 fa 24 80 00 00 	movabs $0x8024fa,%rax
  80365f:	00 00 00 
  803662:	ff d0                	callq  *%rax
  803664:	89 c2                	mov    %eax,%edx
  803666:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80366a:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80366c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803670:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803674:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803678:	48 89 c7             	mov    %rax,%rdi
  80367b:	48 b8 fa 24 80 00 00 	movabs $0x8024fa,%rax
  803682:	00 00 00 
  803685:	ff d0                	callq  *%rax
  803687:	89 03                	mov    %eax,(%rbx)
	return 0;
  803689:	b8 00 00 00 00       	mov    $0x0,%eax
  80368e:	eb 33                	jmp    8036c3 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803690:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803694:	48 89 c6             	mov    %rax,%rsi
  803697:	bf 00 00 00 00       	mov    $0x0,%edi
  80369c:	48 b8 08 1c 80 00 00 	movabs $0x801c08,%rax
  8036a3:	00 00 00 
  8036a6:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8036a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036ac:	48 89 c6             	mov    %rax,%rsi
  8036af:	bf 00 00 00 00       	mov    $0x0,%edi
  8036b4:	48 b8 08 1c 80 00 00 	movabs $0x801c08,%rax
  8036bb:	00 00 00 
  8036be:	ff d0                	callq  *%rax
err:
	return r;
  8036c0:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8036c3:	48 83 c4 38          	add    $0x38,%rsp
  8036c7:	5b                   	pop    %rbx
  8036c8:	5d                   	pop    %rbp
  8036c9:	c3                   	retq   

00000000008036ca <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8036ca:	55                   	push   %rbp
  8036cb:	48 89 e5             	mov    %rsp,%rbp
  8036ce:	53                   	push   %rbx
  8036cf:	48 83 ec 28          	sub    $0x28,%rsp
  8036d3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8036d7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8036db:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8036e2:	00 00 00 
  8036e5:	48 8b 00             	mov    (%rax),%rax
  8036e8:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8036ee:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8036f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036f5:	48 89 c7             	mov    %rax,%rdi
  8036f8:	48 b8 4b 34 80 00 00 	movabs $0x80344b,%rax
  8036ff:	00 00 00 
  803702:	ff d0                	callq  *%rax
  803704:	89 c3                	mov    %eax,%ebx
  803706:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80370a:	48 89 c7             	mov    %rax,%rdi
  80370d:	48 b8 4b 34 80 00 00 	movabs $0x80344b,%rax
  803714:	00 00 00 
  803717:	ff d0                	callq  *%rax
  803719:	39 c3                	cmp    %eax,%ebx
  80371b:	0f 94 c0             	sete   %al
  80371e:	0f b6 c0             	movzbl %al,%eax
  803721:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803724:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80372b:	00 00 00 
  80372e:	48 8b 00             	mov    (%rax),%rax
  803731:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803737:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80373a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80373d:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803740:	75 05                	jne    803747 <_pipeisclosed+0x7d>
			return ret;
  803742:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803745:	eb 4f                	jmp    803796 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803747:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80374a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80374d:	74 42                	je     803791 <_pipeisclosed+0xc7>
  80374f:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803753:	75 3c                	jne    803791 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803755:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80375c:	00 00 00 
  80375f:	48 8b 00             	mov    (%rax),%rax
  803762:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803768:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80376b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80376e:	89 c6                	mov    %eax,%esi
  803770:	48 bf 14 46 80 00 00 	movabs $0x804614,%rdi
  803777:	00 00 00 
  80377a:	b8 00 00 00 00       	mov    $0x0,%eax
  80377f:	49 b8 79 06 80 00 00 	movabs $0x800679,%r8
  803786:	00 00 00 
  803789:	41 ff d0             	callq  *%r8
	}
  80378c:	e9 4a ff ff ff       	jmpq   8036db <_pipeisclosed+0x11>
  803791:	e9 45 ff ff ff       	jmpq   8036db <_pipeisclosed+0x11>
}
  803796:	48 83 c4 28          	add    $0x28,%rsp
  80379a:	5b                   	pop    %rbx
  80379b:	5d                   	pop    %rbp
  80379c:	c3                   	retq   

000000000080379d <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80379d:	55                   	push   %rbp
  80379e:	48 89 e5             	mov    %rsp,%rbp
  8037a1:	48 83 ec 30          	sub    $0x30,%rsp
  8037a5:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8037a8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8037ac:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8037af:	48 89 d6             	mov    %rdx,%rsi
  8037b2:	89 c7                	mov    %eax,%edi
  8037b4:	48 b8 e0 25 80 00 00 	movabs $0x8025e0,%rax
  8037bb:	00 00 00 
  8037be:	ff d0                	callq  *%rax
  8037c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037c7:	79 05                	jns    8037ce <pipeisclosed+0x31>
		return r;
  8037c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037cc:	eb 31                	jmp    8037ff <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8037ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037d2:	48 89 c7             	mov    %rax,%rdi
  8037d5:	48 b8 1d 25 80 00 00 	movabs $0x80251d,%rax
  8037dc:	00 00 00 
  8037df:	ff d0                	callq  *%rax
  8037e1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8037e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037e9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037ed:	48 89 d6             	mov    %rdx,%rsi
  8037f0:	48 89 c7             	mov    %rax,%rdi
  8037f3:	48 b8 ca 36 80 00 00 	movabs $0x8036ca,%rax
  8037fa:	00 00 00 
  8037fd:	ff d0                	callq  *%rax
}
  8037ff:	c9                   	leaveq 
  803800:	c3                   	retq   

0000000000803801 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803801:	55                   	push   %rbp
  803802:	48 89 e5             	mov    %rsp,%rbp
  803805:	48 83 ec 40          	sub    $0x40,%rsp
  803809:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80380d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803811:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803815:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803819:	48 89 c7             	mov    %rax,%rdi
  80381c:	48 b8 1d 25 80 00 00 	movabs $0x80251d,%rax
  803823:	00 00 00 
  803826:	ff d0                	callq  *%rax
  803828:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80382c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803830:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803834:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80383b:	00 
  80383c:	e9 92 00 00 00       	jmpq   8038d3 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803841:	eb 41                	jmp    803884 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803843:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803848:	74 09                	je     803853 <devpipe_read+0x52>
				return i;
  80384a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80384e:	e9 92 00 00 00       	jmpq   8038e5 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803853:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803857:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80385b:	48 89 d6             	mov    %rdx,%rsi
  80385e:	48 89 c7             	mov    %rax,%rdi
  803861:	48 b8 ca 36 80 00 00 	movabs $0x8036ca,%rax
  803868:	00 00 00 
  80386b:	ff d0                	callq  *%rax
  80386d:	85 c0                	test   %eax,%eax
  80386f:	74 07                	je     803878 <devpipe_read+0x77>
				return 0;
  803871:	b8 00 00 00 00       	mov    $0x0,%eax
  803876:	eb 6d                	jmp    8038e5 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803878:	48 b8 1f 1b 80 00 00 	movabs $0x801b1f,%rax
  80387f:	00 00 00 
  803882:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803884:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803888:	8b 10                	mov    (%rax),%edx
  80388a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80388e:	8b 40 04             	mov    0x4(%rax),%eax
  803891:	39 c2                	cmp    %eax,%edx
  803893:	74 ae                	je     803843 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803895:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803899:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80389d:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8038a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038a5:	8b 00                	mov    (%rax),%eax
  8038a7:	99                   	cltd   
  8038a8:	c1 ea 1b             	shr    $0x1b,%edx
  8038ab:	01 d0                	add    %edx,%eax
  8038ad:	83 e0 1f             	and    $0x1f,%eax
  8038b0:	29 d0                	sub    %edx,%eax
  8038b2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038b6:	48 98                	cltq   
  8038b8:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8038bd:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8038bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038c3:	8b 00                	mov    (%rax),%eax
  8038c5:	8d 50 01             	lea    0x1(%rax),%edx
  8038c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038cc:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8038ce:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8038d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038d7:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8038db:	0f 82 60 ff ff ff    	jb     803841 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8038e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8038e5:	c9                   	leaveq 
  8038e6:	c3                   	retq   

00000000008038e7 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8038e7:	55                   	push   %rbp
  8038e8:	48 89 e5             	mov    %rsp,%rbp
  8038eb:	48 83 ec 40          	sub    $0x40,%rsp
  8038ef:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8038f3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8038f7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8038fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038ff:	48 89 c7             	mov    %rax,%rdi
  803902:	48 b8 1d 25 80 00 00 	movabs $0x80251d,%rax
  803909:	00 00 00 
  80390c:	ff d0                	callq  *%rax
  80390e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803912:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803916:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80391a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803921:	00 
  803922:	e9 8e 00 00 00       	jmpq   8039b5 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803927:	eb 31                	jmp    80395a <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803929:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80392d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803931:	48 89 d6             	mov    %rdx,%rsi
  803934:	48 89 c7             	mov    %rax,%rdi
  803937:	48 b8 ca 36 80 00 00 	movabs $0x8036ca,%rax
  80393e:	00 00 00 
  803941:	ff d0                	callq  *%rax
  803943:	85 c0                	test   %eax,%eax
  803945:	74 07                	je     80394e <devpipe_write+0x67>
				return 0;
  803947:	b8 00 00 00 00       	mov    $0x0,%eax
  80394c:	eb 79                	jmp    8039c7 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80394e:	48 b8 1f 1b 80 00 00 	movabs $0x801b1f,%rax
  803955:	00 00 00 
  803958:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80395a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80395e:	8b 40 04             	mov    0x4(%rax),%eax
  803961:	48 63 d0             	movslq %eax,%rdx
  803964:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803968:	8b 00                	mov    (%rax),%eax
  80396a:	48 98                	cltq   
  80396c:	48 83 c0 20          	add    $0x20,%rax
  803970:	48 39 c2             	cmp    %rax,%rdx
  803973:	73 b4                	jae    803929 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803975:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803979:	8b 40 04             	mov    0x4(%rax),%eax
  80397c:	99                   	cltd   
  80397d:	c1 ea 1b             	shr    $0x1b,%edx
  803980:	01 d0                	add    %edx,%eax
  803982:	83 e0 1f             	and    $0x1f,%eax
  803985:	29 d0                	sub    %edx,%eax
  803987:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80398b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80398f:	48 01 ca             	add    %rcx,%rdx
  803992:	0f b6 0a             	movzbl (%rdx),%ecx
  803995:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803999:	48 98                	cltq   
  80399b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80399f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039a3:	8b 40 04             	mov    0x4(%rax),%eax
  8039a6:	8d 50 01             	lea    0x1(%rax),%edx
  8039a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039ad:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8039b0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8039b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039b9:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8039bd:	0f 82 64 ff ff ff    	jb     803927 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8039c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8039c7:	c9                   	leaveq 
  8039c8:	c3                   	retq   

00000000008039c9 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8039c9:	55                   	push   %rbp
  8039ca:	48 89 e5             	mov    %rsp,%rbp
  8039cd:	48 83 ec 20          	sub    $0x20,%rsp
  8039d1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039d5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8039d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039dd:	48 89 c7             	mov    %rax,%rdi
  8039e0:	48 b8 1d 25 80 00 00 	movabs $0x80251d,%rax
  8039e7:	00 00 00 
  8039ea:	ff d0                	callq  *%rax
  8039ec:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8039f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039f4:	48 be 27 46 80 00 00 	movabs $0x804627,%rsi
  8039fb:	00 00 00 
  8039fe:	48 89 c7             	mov    %rax,%rdi
  803a01:	48 b8 2e 12 80 00 00 	movabs $0x80122e,%rax
  803a08:	00 00 00 
  803a0b:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803a0d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a11:	8b 50 04             	mov    0x4(%rax),%edx
  803a14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a18:	8b 00                	mov    (%rax),%eax
  803a1a:	29 c2                	sub    %eax,%edx
  803a1c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a20:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803a26:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a2a:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803a31:	00 00 00 
	stat->st_dev = &devpipe;
  803a34:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a38:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803a3f:	00 00 00 
  803a42:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803a49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a4e:	c9                   	leaveq 
  803a4f:	c3                   	retq   

0000000000803a50 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803a50:	55                   	push   %rbp
  803a51:	48 89 e5             	mov    %rsp,%rbp
  803a54:	48 83 ec 10          	sub    $0x10,%rsp
  803a58:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803a5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a60:	48 89 c6             	mov    %rax,%rsi
  803a63:	bf 00 00 00 00       	mov    $0x0,%edi
  803a68:	48 b8 08 1c 80 00 00 	movabs $0x801c08,%rax
  803a6f:	00 00 00 
  803a72:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803a74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a78:	48 89 c7             	mov    %rax,%rdi
  803a7b:	48 b8 1d 25 80 00 00 	movabs $0x80251d,%rax
  803a82:	00 00 00 
  803a85:	ff d0                	callq  *%rax
  803a87:	48 89 c6             	mov    %rax,%rsi
  803a8a:	bf 00 00 00 00       	mov    $0x0,%edi
  803a8f:	48 b8 08 1c 80 00 00 	movabs $0x801c08,%rax
  803a96:	00 00 00 
  803a99:	ff d0                	callq  *%rax
}
  803a9b:	c9                   	leaveq 
  803a9c:	c3                   	retq   

0000000000803a9d <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803a9d:	55                   	push   %rbp
  803a9e:	48 89 e5             	mov    %rsp,%rbp
  803aa1:	48 83 ec 20          	sub    $0x20,%rsp
  803aa5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803aa8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803aab:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803aae:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803ab2:	be 01 00 00 00       	mov    $0x1,%esi
  803ab7:	48 89 c7             	mov    %rax,%rdi
  803aba:	48 b8 15 1a 80 00 00 	movabs $0x801a15,%rax
  803ac1:	00 00 00 
  803ac4:	ff d0                	callq  *%rax
}
  803ac6:	c9                   	leaveq 
  803ac7:	c3                   	retq   

0000000000803ac8 <getchar>:

int
getchar(void)
{
  803ac8:	55                   	push   %rbp
  803ac9:	48 89 e5             	mov    %rsp,%rbp
  803acc:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803ad0:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803ad4:	ba 01 00 00 00       	mov    $0x1,%edx
  803ad9:	48 89 c6             	mov    %rax,%rsi
  803adc:	bf 00 00 00 00       	mov    $0x0,%edi
  803ae1:	48 b8 12 2a 80 00 00 	movabs $0x802a12,%rax
  803ae8:	00 00 00 
  803aeb:	ff d0                	callq  *%rax
  803aed:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803af0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803af4:	79 05                	jns    803afb <getchar+0x33>
		return r;
  803af6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803af9:	eb 14                	jmp    803b0f <getchar+0x47>
	if (r < 1)
  803afb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803aff:	7f 07                	jg     803b08 <getchar+0x40>
		return -E_EOF;
  803b01:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803b06:	eb 07                	jmp    803b0f <getchar+0x47>
	return c;
  803b08:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803b0c:	0f b6 c0             	movzbl %al,%eax
}
  803b0f:	c9                   	leaveq 
  803b10:	c3                   	retq   

0000000000803b11 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803b11:	55                   	push   %rbp
  803b12:	48 89 e5             	mov    %rsp,%rbp
  803b15:	48 83 ec 20          	sub    $0x20,%rsp
  803b19:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803b1c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803b20:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b23:	48 89 d6             	mov    %rdx,%rsi
  803b26:	89 c7                	mov    %eax,%edi
  803b28:	48 b8 e0 25 80 00 00 	movabs $0x8025e0,%rax
  803b2f:	00 00 00 
  803b32:	ff d0                	callq  *%rax
  803b34:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b37:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b3b:	79 05                	jns    803b42 <iscons+0x31>
		return r;
  803b3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b40:	eb 1a                	jmp    803b5c <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803b42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b46:	8b 10                	mov    (%rax),%edx
  803b48:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803b4f:	00 00 00 
  803b52:	8b 00                	mov    (%rax),%eax
  803b54:	39 c2                	cmp    %eax,%edx
  803b56:	0f 94 c0             	sete   %al
  803b59:	0f b6 c0             	movzbl %al,%eax
}
  803b5c:	c9                   	leaveq 
  803b5d:	c3                   	retq   

0000000000803b5e <opencons>:

int
opencons(void)
{
  803b5e:	55                   	push   %rbp
  803b5f:	48 89 e5             	mov    %rsp,%rbp
  803b62:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803b66:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803b6a:	48 89 c7             	mov    %rax,%rdi
  803b6d:	48 b8 48 25 80 00 00 	movabs $0x802548,%rax
  803b74:	00 00 00 
  803b77:	ff d0                	callq  *%rax
  803b79:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b80:	79 05                	jns    803b87 <opencons+0x29>
		return r;
  803b82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b85:	eb 5b                	jmp    803be2 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803b87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b8b:	ba 07 04 00 00       	mov    $0x407,%edx
  803b90:	48 89 c6             	mov    %rax,%rsi
  803b93:	bf 00 00 00 00       	mov    $0x0,%edi
  803b98:	48 b8 5d 1b 80 00 00 	movabs $0x801b5d,%rax
  803b9f:	00 00 00 
  803ba2:	ff d0                	callq  *%rax
  803ba4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ba7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bab:	79 05                	jns    803bb2 <opencons+0x54>
		return r;
  803bad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bb0:	eb 30                	jmp    803be2 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803bb2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bb6:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803bbd:	00 00 00 
  803bc0:	8b 12                	mov    (%rdx),%edx
  803bc2:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803bc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bc8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803bcf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bd3:	48 89 c7             	mov    %rax,%rdi
  803bd6:	48 b8 fa 24 80 00 00 	movabs $0x8024fa,%rax
  803bdd:	00 00 00 
  803be0:	ff d0                	callq  *%rax
}
  803be2:	c9                   	leaveq 
  803be3:	c3                   	retq   

0000000000803be4 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803be4:	55                   	push   %rbp
  803be5:	48 89 e5             	mov    %rsp,%rbp
  803be8:	48 83 ec 30          	sub    $0x30,%rsp
  803bec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803bf0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803bf4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803bf8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803bfd:	75 07                	jne    803c06 <devcons_read+0x22>
		return 0;
  803bff:	b8 00 00 00 00       	mov    $0x0,%eax
  803c04:	eb 4b                	jmp    803c51 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803c06:	eb 0c                	jmp    803c14 <devcons_read+0x30>
		sys_yield();
  803c08:	48 b8 1f 1b 80 00 00 	movabs $0x801b1f,%rax
  803c0f:	00 00 00 
  803c12:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803c14:	48 b8 5f 1a 80 00 00 	movabs $0x801a5f,%rax
  803c1b:	00 00 00 
  803c1e:	ff d0                	callq  *%rax
  803c20:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c23:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c27:	74 df                	je     803c08 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803c29:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c2d:	79 05                	jns    803c34 <devcons_read+0x50>
		return c;
  803c2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c32:	eb 1d                	jmp    803c51 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803c34:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803c38:	75 07                	jne    803c41 <devcons_read+0x5d>
		return 0;
  803c3a:	b8 00 00 00 00       	mov    $0x0,%eax
  803c3f:	eb 10                	jmp    803c51 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803c41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c44:	89 c2                	mov    %eax,%edx
  803c46:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c4a:	88 10                	mov    %dl,(%rax)
	return 1;
  803c4c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803c51:	c9                   	leaveq 
  803c52:	c3                   	retq   

0000000000803c53 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803c53:	55                   	push   %rbp
  803c54:	48 89 e5             	mov    %rsp,%rbp
  803c57:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803c5e:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803c65:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803c6c:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803c73:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803c7a:	eb 76                	jmp    803cf2 <devcons_write+0x9f>
		m = n - tot;
  803c7c:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803c83:	89 c2                	mov    %eax,%edx
  803c85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c88:	29 c2                	sub    %eax,%edx
  803c8a:	89 d0                	mov    %edx,%eax
  803c8c:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803c8f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c92:	83 f8 7f             	cmp    $0x7f,%eax
  803c95:	76 07                	jbe    803c9e <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803c97:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803c9e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ca1:	48 63 d0             	movslq %eax,%rdx
  803ca4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ca7:	48 63 c8             	movslq %eax,%rcx
  803caa:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803cb1:	48 01 c1             	add    %rax,%rcx
  803cb4:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803cbb:	48 89 ce             	mov    %rcx,%rsi
  803cbe:	48 89 c7             	mov    %rax,%rdi
  803cc1:	48 b8 52 15 80 00 00 	movabs $0x801552,%rax
  803cc8:	00 00 00 
  803ccb:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803ccd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cd0:	48 63 d0             	movslq %eax,%rdx
  803cd3:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803cda:	48 89 d6             	mov    %rdx,%rsi
  803cdd:	48 89 c7             	mov    %rax,%rdi
  803ce0:	48 b8 15 1a 80 00 00 	movabs $0x801a15,%rax
  803ce7:	00 00 00 
  803cea:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803cec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cef:	01 45 fc             	add    %eax,-0x4(%rbp)
  803cf2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cf5:	48 98                	cltq   
  803cf7:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803cfe:	0f 82 78 ff ff ff    	jb     803c7c <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803d04:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803d07:	c9                   	leaveq 
  803d08:	c3                   	retq   

0000000000803d09 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803d09:	55                   	push   %rbp
  803d0a:	48 89 e5             	mov    %rsp,%rbp
  803d0d:	48 83 ec 08          	sub    $0x8,%rsp
  803d11:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803d15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d1a:	c9                   	leaveq 
  803d1b:	c3                   	retq   

0000000000803d1c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803d1c:	55                   	push   %rbp
  803d1d:	48 89 e5             	mov    %rsp,%rbp
  803d20:	48 83 ec 10          	sub    $0x10,%rsp
  803d24:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803d28:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803d2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d30:	48 be 33 46 80 00 00 	movabs $0x804633,%rsi
  803d37:	00 00 00 
  803d3a:	48 89 c7             	mov    %rax,%rdi
  803d3d:	48 b8 2e 12 80 00 00 	movabs $0x80122e,%rax
  803d44:	00 00 00 
  803d47:	ff d0                	callq  *%rax
	return 0;
  803d49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d4e:	c9                   	leaveq 
  803d4f:	c3                   	retq   

0000000000803d50 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803d50:	55                   	push   %rbp
  803d51:	48 89 e5             	mov    %rsp,%rbp
  803d54:	48 83 ec 10          	sub    $0x10,%rsp
  803d58:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  803d5c:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803d63:	00 00 00 
  803d66:	48 8b 00             	mov    (%rax),%rax
  803d69:	48 85 c0             	test   %rax,%rax
  803d6c:	75 64                	jne    803dd2 <set_pgfault_handler+0x82>
		// First time through!
		// LAB 4: Your code here.
		//envid_t eid = sys_getenvid();
		if(sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) 
  803d6e:	ba 07 00 00 00       	mov    $0x7,%edx
  803d73:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803d78:	bf 00 00 00 00       	mov    $0x0,%edi
  803d7d:	48 b8 5d 1b 80 00 00 	movabs $0x801b5d,%rax
  803d84:	00 00 00 
  803d87:	ff d0                	callq  *%rax
  803d89:	85 c0                	test   %eax,%eax
  803d8b:	74 2a                	je     803db7 <set_pgfault_handler+0x67>
			panic("Allocation of space for UXSTACK failed\n");
  803d8d:	48 ba 40 46 80 00 00 	movabs $0x804640,%rdx
  803d94:	00 00 00 
  803d97:	be 22 00 00 00       	mov    $0x22,%esi
  803d9c:	48 bf 68 46 80 00 00 	movabs $0x804668,%rdi
  803da3:	00 00 00 
  803da6:	b8 00 00 00 00       	mov    $0x0,%eax
  803dab:	48 b9 40 04 80 00 00 	movabs $0x800440,%rcx
  803db2:	00 00 00 
  803db5:	ff d1                	callq  *%rcx
		else
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  803db7:	48 be e5 3d 80 00 00 	movabs $0x803de5,%rsi
  803dbe:	00 00 00 
  803dc1:	bf 00 00 00 00       	mov    $0x0,%edi
  803dc6:	48 b8 e7 1c 80 00 00 	movabs $0x801ce7,%rax
  803dcd:	00 00 00 
  803dd0:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803dd2:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803dd9:	00 00 00 
  803ddc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803de0:	48 89 10             	mov    %rdx,(%rax)
}
  803de3:	c9                   	leaveq 
  803de4:	c3                   	retq   

0000000000803de5 <_pgfault_upcall>:
// Call the C page fault handler.
// function argument: pointer to UTF



movq  %rsp,%rdi                // passing the function argument in rdi
  803de5:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  803de8:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803def:	00 00 00 
call *%rax
  803df2:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
mov 152(%rsp), %r8
  803df4:	4c 8b 84 24 98 00 00 	mov    0x98(%rsp),%r8
  803dfb:	00 
mov 136(%rsp), %r9
  803dfc:	4c 8b 8c 24 88 00 00 	mov    0x88(%rsp),%r9
  803e03:	00 
sub $8, %r8
  803e04:	49 83 e8 08          	sub    $0x8,%r8
mov %r9, (%r8)
  803e08:	4d 89 08             	mov    %r9,(%r8)
mov %r8, 152(%rsp)
  803e0b:	4c 89 84 24 98 00 00 	mov    %r8,0x98(%rsp)
  803e12:	00 
add $16, %rsp
  803e13:	48 83 c4 10          	add    $0x10,%rsp

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
POPA_
  803e17:	4c 8b 3c 24          	mov    (%rsp),%r15
  803e1b:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803e20:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803e25:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803e2a:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803e2f:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803e34:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803e39:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803e3e:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803e43:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803e48:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803e4d:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803e52:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803e57:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803e5c:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803e61:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
		// LAB 4: Your code here.
add $8, %rsp
  803e65:	48 83 c4 08          	add    $0x8,%rsp
popf
  803e69:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
mov (%rsp), %rsp
  803e6a:	48 8b 24 24          	mov    (%rsp),%rsp
    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
ret
  803e6e:	c3                   	retq   
