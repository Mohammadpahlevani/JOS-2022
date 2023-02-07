
obj/user/testpiperace2:     file format elf64-x86-64


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
  80003c:	e8 ea 02 00 00       	callq  80032b <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 40          	sub    $0x40,%rsp
  80004b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80004e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	int p[2], r, i;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  800052:	48 bf 20 3e 80 00 00 	movabs $0x803e20,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 17 06 80 00 00 	movabs $0x800617,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	if ((r = pipe(p)) < 0)
  80006d:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800071:	48 89 c7             	mov    %rax,%rdi
  800074:	48 b8 04 32 80 00 00 	movabs $0x803204,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
  800080:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800083:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800087:	79 30                	jns    8000b9 <umain+0x76>
		panic("pipe: %e", r);
  800089:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80008c:	89 c1                	mov    %eax,%ecx
  80008e:	48 ba 42 3e 80 00 00 	movabs $0x803e42,%rdx
  800095:	00 00 00 
  800098:	be 0d 00 00 00       	mov    $0xd,%esi
  80009d:	48 bf 4b 3e 80 00 00 	movabs $0x803e4b,%rdi
  8000a4:	00 00 00 
  8000a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ac:	49 b8 de 03 80 00 00 	movabs $0x8003de,%r8
  8000b3:	00 00 00 
  8000b6:	41 ff d0             	callq  *%r8
	if ((r = fork()) < 0)
  8000b9:	48 b8 bb 1f 80 00 00 	movabs $0x801fbb,%rax
  8000c0:	00 00 00 
  8000c3:	ff d0                	callq  *%rax
  8000c5:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000c8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000cc:	79 30                	jns    8000fe <umain+0xbb>
		panic("fork: %e", r);
  8000ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d1:	89 c1                	mov    %eax,%ecx
  8000d3:	48 ba 60 3e 80 00 00 	movabs $0x803e60,%rdx
  8000da:	00 00 00 
  8000dd:	be 0f 00 00 00       	mov    $0xf,%esi
  8000e2:	48 bf 4b 3e 80 00 00 	movabs $0x803e4b,%rdi
  8000e9:	00 00 00 
  8000ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f1:	49 b8 de 03 80 00 00 	movabs $0x8003de,%r8
  8000f8:	00 00 00 
  8000fb:	41 ff d0             	callq  *%r8
	if (r == 0) {
  8000fe:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800102:	0f 85 c0 00 00 00    	jne    8001c8 <umain+0x185>
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
  800108:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80010b:	89 c7                	mov    %eax,%edi
  80010d:	48 b8 a9 25 80 00 00 	movabs $0x8025a9,%rax
  800114:	00 00 00 
  800117:	ff d0                	callq  *%rax
		for (i = 0; i < 200; i++) {
  800119:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800120:	e9 8a 00 00 00       	jmpq   8001af <umain+0x16c>
			if (i % 10 == 0)
  800125:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  800128:	ba 67 66 66 66       	mov    $0x66666667,%edx
  80012d:	89 c8                	mov    %ecx,%eax
  80012f:	f7 ea                	imul   %edx
  800131:	c1 fa 02             	sar    $0x2,%edx
  800134:	89 c8                	mov    %ecx,%eax
  800136:	c1 f8 1f             	sar    $0x1f,%eax
  800139:	29 c2                	sub    %eax,%edx
  80013b:	89 d0                	mov    %edx,%eax
  80013d:	c1 e0 02             	shl    $0x2,%eax
  800140:	01 d0                	add    %edx,%eax
  800142:	01 c0                	add    %eax,%eax
  800144:	29 c1                	sub    %eax,%ecx
  800146:	89 ca                	mov    %ecx,%edx
  800148:	85 d2                	test   %edx,%edx
  80014a:	75 20                	jne    80016c <umain+0x129>
				cprintf("%d.", i);
  80014c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80014f:	89 c6                	mov    %eax,%esi
  800151:	48 bf 69 3e 80 00 00 	movabs $0x803e69,%rdi
  800158:	00 00 00 
  80015b:	b8 00 00 00 00       	mov    $0x0,%eax
  800160:	48 ba 17 06 80 00 00 	movabs $0x800617,%rdx
  800167:	00 00 00 
  80016a:	ff d2                	callq  *%rdx
			// dup, then close.  yield so that other guy will
			// see us while we're between them.
			dup(p[0], 10);
  80016c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80016f:	be 0a 00 00 00       	mov    $0xa,%esi
  800174:	89 c7                	mov    %eax,%edi
  800176:	48 b8 22 26 80 00 00 	movabs $0x802622,%rax
  80017d:	00 00 00 
  800180:	ff d0                	callq  *%rax
			sys_yield();
  800182:	48 b8 bd 1a 80 00 00 	movabs $0x801abd,%rax
  800189:	00 00 00 
  80018c:	ff d0                	callq  *%rax
			close(10);
  80018e:	bf 0a 00 00 00       	mov    $0xa,%edi
  800193:	48 b8 a9 25 80 00 00 	movabs $0x8025a9,%rax
  80019a:	00 00 00 
  80019d:	ff d0                	callq  *%rax
			sys_yield();
  80019f:	48 b8 bd 1a 80 00 00 	movabs $0x801abd,%rax
  8001a6:	00 00 00 
  8001a9:	ff d0                	callq  *%rax
	if (r == 0) {
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
		for (i = 0; i < 200; i++) {
  8001ab:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8001af:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%rbp)
  8001b6:	0f 8e 69 ff ff ff    	jle    800125 <umain+0xe2>
			dup(p[0], 10);
			sys_yield();
			close(10);
			sys_yield();
		}
		exit();
  8001bc:	48 b8 bb 03 80 00 00 	movabs $0x8003bb,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  8001c8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001cb:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001d0:	48 63 d0             	movslq %eax,%rdx
  8001d3:	48 89 d0             	mov    %rdx,%rax
  8001d6:	48 c1 e0 03          	shl    $0x3,%rax
  8001da:	48 01 d0             	add    %rdx,%rax
  8001dd:	48 c1 e0 05          	shl    $0x5,%rax
  8001e1:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8001e8:	00 00 00 
  8001eb:	48 01 d0             	add    %rdx,%rax
  8001ee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	while (kid->env_status == ENV_RUNNABLE)
  8001f2:	eb 4d                	jmp    800241 <umain+0x1fe>
		if (pipeisclosed(p[0]) != 0) {
  8001f4:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8001f7:	89 c7                	mov    %eax,%edi
  8001f9:	48 b8 cd 34 80 00 00 	movabs $0x8034cd,%rax
  800200:	00 00 00 
  800203:	ff d0                	callq  *%rax
  800205:	85 c0                	test   %eax,%eax
  800207:	74 38                	je     800241 <umain+0x1fe>
			cprintf("\nRACE: pipe appears closed\n");
  800209:	48 bf 6d 3e 80 00 00 	movabs $0x803e6d,%rdi
  800210:	00 00 00 
  800213:	b8 00 00 00 00       	mov    $0x0,%eax
  800218:	48 ba 17 06 80 00 00 	movabs $0x800617,%rdx
  80021f:	00 00 00 
  800222:	ff d2                	callq  *%rdx
			sys_env_destroy(r);
  800224:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800227:	89 c7                	mov    %eax,%edi
  800229:	48 b8 3b 1a 80 00 00 	movabs $0x801a3b,%rax
  800230:	00 00 00 
  800233:	ff d0                	callq  *%rax
			exit();
  800235:	48 b8 bb 03 80 00 00 	movabs $0x8003bb,%rax
  80023c:	00 00 00 
  80023f:	ff d0                	callq  *%rax
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
	while (kid->env_status == ENV_RUNNABLE)
  800241:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800245:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80024b:	83 f8 02             	cmp    $0x2,%eax
  80024e:	74 a4                	je     8001f4 <umain+0x1b1>
		if (pipeisclosed(p[0]) != 0) {
			cprintf("\nRACE: pipe appears closed\n");
			sys_env_destroy(r);
			exit();
		}
	cprintf("child done with loop\n");
  800250:	48 bf 89 3e 80 00 00 	movabs $0x803e89,%rdi
  800257:	00 00 00 
  80025a:	b8 00 00 00 00       	mov    $0x0,%eax
  80025f:	48 ba 17 06 80 00 00 	movabs $0x800617,%rdx
  800266:	00 00 00 
  800269:	ff d2                	callq  *%rdx
	if (pipeisclosed(p[0]))
  80026b:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80026e:	89 c7                	mov    %eax,%edi
  800270:	48 b8 cd 34 80 00 00 	movabs $0x8034cd,%rax
  800277:	00 00 00 
  80027a:	ff d0                	callq  *%rax
  80027c:	85 c0                	test   %eax,%eax
  80027e:	74 2a                	je     8002aa <umain+0x267>
		panic("somehow the other end of p[0] got closed!");
  800280:	48 ba a0 3e 80 00 00 	movabs $0x803ea0,%rdx
  800287:	00 00 00 
  80028a:	be 40 00 00 00       	mov    $0x40,%esi
  80028f:	48 bf 4b 3e 80 00 00 	movabs $0x803e4b,%rdi
  800296:	00 00 00 
  800299:	b8 00 00 00 00       	mov    $0x0,%eax
  80029e:	48 b9 de 03 80 00 00 	movabs $0x8003de,%rcx
  8002a5:	00 00 00 
  8002a8:	ff d1                	callq  *%rcx
	if ((r = fd_lookup(p[0], &fd)) < 0)
  8002aa:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8002ad:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8002b1:	48 89 d6             	mov    %rdx,%rsi
  8002b4:	89 c7                	mov    %eax,%edi
  8002b6:	48 b8 99 23 80 00 00 	movabs $0x802399,%rax
  8002bd:	00 00 00 
  8002c0:	ff d0                	callq  *%rax
  8002c2:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8002c5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002c9:	79 30                	jns    8002fb <umain+0x2b8>
		panic("cannot look up p[0]: %e", r);
  8002cb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002ce:	89 c1                	mov    %eax,%ecx
  8002d0:	48 ba ca 3e 80 00 00 	movabs $0x803eca,%rdx
  8002d7:	00 00 00 
  8002da:	be 42 00 00 00       	mov    $0x42,%esi
  8002df:	48 bf 4b 3e 80 00 00 	movabs $0x803e4b,%rdi
  8002e6:	00 00 00 
  8002e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ee:	49 b8 de 03 80 00 00 	movabs $0x8003de,%r8
  8002f5:	00 00 00 
  8002f8:	41 ff d0             	callq  *%r8
	(void) fd2data(fd);
  8002fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8002ff:	48 89 c7             	mov    %rax,%rdi
  800302:	48 b8 d6 22 80 00 00 	movabs $0x8022d6,%rax
  800309:	00 00 00 
  80030c:	ff d0                	callq  *%rax
	cprintf("race didn't happen\n");
  80030e:	48 bf e2 3e 80 00 00 	movabs $0x803ee2,%rdi
  800315:	00 00 00 
  800318:	b8 00 00 00 00       	mov    $0x0,%eax
  80031d:	48 ba 17 06 80 00 00 	movabs $0x800617,%rdx
  800324:	00 00 00 
  800327:	ff d2                	callq  *%rdx
}
  800329:	c9                   	leaveq 
  80032a:	c3                   	retq   

000000000080032b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80032b:	55                   	push   %rbp
  80032c:	48 89 e5             	mov    %rsp,%rbp
  80032f:	48 83 ec 10          	sub    $0x10,%rsp
  800333:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800336:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  80033a:	48 b8 7f 1a 80 00 00 	movabs $0x801a7f,%rax
  800341:	00 00 00 
  800344:	ff d0                	callq  *%rax
  800346:	48 98                	cltq   
  800348:	25 ff 03 00 00       	and    $0x3ff,%eax
  80034d:	48 89 c2             	mov    %rax,%rdx
  800350:	48 89 d0             	mov    %rdx,%rax
  800353:	48 c1 e0 03          	shl    $0x3,%rax
  800357:	48 01 d0             	add    %rdx,%rax
  80035a:	48 c1 e0 05          	shl    $0x5,%rax
  80035e:	48 89 c2             	mov    %rax,%rdx
  800361:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800368:	00 00 00 
  80036b:	48 01 c2             	add    %rax,%rdx
  80036e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800375:	00 00 00 
  800378:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80037b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80037f:	7e 14                	jle    800395 <libmain+0x6a>
		binaryname = argv[0];
  800381:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800385:	48 8b 10             	mov    (%rax),%rdx
  800388:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80038f:	00 00 00 
  800392:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800395:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800399:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80039c:	48 89 d6             	mov    %rdx,%rsi
  80039f:	89 c7                	mov    %eax,%edi
  8003a1:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8003a8:	00 00 00 
  8003ab:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8003ad:	48 b8 bb 03 80 00 00 	movabs $0x8003bb,%rax
  8003b4:	00 00 00 
  8003b7:	ff d0                	callq  *%rax
}
  8003b9:	c9                   	leaveq 
  8003ba:	c3                   	retq   

00000000008003bb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003bb:	55                   	push   %rbp
  8003bc:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8003bf:	48 b8 f4 25 80 00 00 	movabs $0x8025f4,%rax
  8003c6:	00 00 00 
  8003c9:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8003cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8003d0:	48 b8 3b 1a 80 00 00 	movabs $0x801a3b,%rax
  8003d7:	00 00 00 
  8003da:	ff d0                	callq  *%rax
}
  8003dc:	5d                   	pop    %rbp
  8003dd:	c3                   	retq   

00000000008003de <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003de:	55                   	push   %rbp
  8003df:	48 89 e5             	mov    %rsp,%rbp
  8003e2:	53                   	push   %rbx
  8003e3:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8003ea:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8003f1:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8003f7:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8003fe:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800405:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80040c:	84 c0                	test   %al,%al
  80040e:	74 23                	je     800433 <_panic+0x55>
  800410:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800417:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80041b:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80041f:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800423:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800427:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80042b:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80042f:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800433:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80043a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800441:	00 00 00 
  800444:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80044b:	00 00 00 
  80044e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800452:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800459:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800460:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800467:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80046e:	00 00 00 
  800471:	48 8b 18             	mov    (%rax),%rbx
  800474:	48 b8 7f 1a 80 00 00 	movabs $0x801a7f,%rax
  80047b:	00 00 00 
  80047e:	ff d0                	callq  *%rax
  800480:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800486:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80048d:	41 89 c8             	mov    %ecx,%r8d
  800490:	48 89 d1             	mov    %rdx,%rcx
  800493:	48 89 da             	mov    %rbx,%rdx
  800496:	89 c6                	mov    %eax,%esi
  800498:	48 bf 00 3f 80 00 00 	movabs $0x803f00,%rdi
  80049f:	00 00 00 
  8004a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a7:	49 b9 17 06 80 00 00 	movabs $0x800617,%r9
  8004ae:	00 00 00 
  8004b1:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004b4:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8004bb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004c2:	48 89 d6             	mov    %rdx,%rsi
  8004c5:	48 89 c7             	mov    %rax,%rdi
  8004c8:	48 b8 6b 05 80 00 00 	movabs $0x80056b,%rax
  8004cf:	00 00 00 
  8004d2:	ff d0                	callq  *%rax
	cprintf("\n");
  8004d4:	48 bf 23 3f 80 00 00 	movabs $0x803f23,%rdi
  8004db:	00 00 00 
  8004de:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e3:	48 ba 17 06 80 00 00 	movabs $0x800617,%rdx
  8004ea:	00 00 00 
  8004ed:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8004ef:	cc                   	int3   
  8004f0:	eb fd                	jmp    8004ef <_panic+0x111>

00000000008004f2 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8004f2:	55                   	push   %rbp
  8004f3:	48 89 e5             	mov    %rsp,%rbp
  8004f6:	48 83 ec 10          	sub    $0x10,%rsp
  8004fa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004fd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800501:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800505:	8b 00                	mov    (%rax),%eax
  800507:	8d 48 01             	lea    0x1(%rax),%ecx
  80050a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80050e:	89 0a                	mov    %ecx,(%rdx)
  800510:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800513:	89 d1                	mov    %edx,%ecx
  800515:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800519:	48 98                	cltq   
  80051b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80051f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800523:	8b 00                	mov    (%rax),%eax
  800525:	3d ff 00 00 00       	cmp    $0xff,%eax
  80052a:	75 2c                	jne    800558 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80052c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800530:	8b 00                	mov    (%rax),%eax
  800532:	48 98                	cltq   
  800534:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800538:	48 83 c2 08          	add    $0x8,%rdx
  80053c:	48 89 c6             	mov    %rax,%rsi
  80053f:	48 89 d7             	mov    %rdx,%rdi
  800542:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  800549:	00 00 00 
  80054c:	ff d0                	callq  *%rax
        b->idx = 0;
  80054e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800552:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800558:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80055c:	8b 40 04             	mov    0x4(%rax),%eax
  80055f:	8d 50 01             	lea    0x1(%rax),%edx
  800562:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800566:	89 50 04             	mov    %edx,0x4(%rax)
}
  800569:	c9                   	leaveq 
  80056a:	c3                   	retq   

000000000080056b <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80056b:	55                   	push   %rbp
  80056c:	48 89 e5             	mov    %rsp,%rbp
  80056f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800576:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80057d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800584:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80058b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800592:	48 8b 0a             	mov    (%rdx),%rcx
  800595:	48 89 08             	mov    %rcx,(%rax)
  800598:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80059c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005a0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005a4:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8005a8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005af:	00 00 00 
    b.cnt = 0;
  8005b2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8005b9:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8005bc:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8005c3:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8005ca:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8005d1:	48 89 c6             	mov    %rax,%rsi
  8005d4:	48 bf f2 04 80 00 00 	movabs $0x8004f2,%rdi
  8005db:	00 00 00 
  8005de:	48 b8 ca 09 80 00 00 	movabs $0x8009ca,%rax
  8005e5:	00 00 00 
  8005e8:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8005ea:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8005f0:	48 98                	cltq   
  8005f2:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8005f9:	48 83 c2 08          	add    $0x8,%rdx
  8005fd:	48 89 c6             	mov    %rax,%rsi
  800600:	48 89 d7             	mov    %rdx,%rdi
  800603:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  80060a:	00 00 00 
  80060d:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80060f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800615:	c9                   	leaveq 
  800616:	c3                   	retq   

0000000000800617 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800617:	55                   	push   %rbp
  800618:	48 89 e5             	mov    %rsp,%rbp
  80061b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800622:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800629:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800630:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800637:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80063e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800645:	84 c0                	test   %al,%al
  800647:	74 20                	je     800669 <cprintf+0x52>
  800649:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80064d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800651:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800655:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800659:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80065d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800661:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800665:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800669:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800670:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800677:	00 00 00 
  80067a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800681:	00 00 00 
  800684:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800688:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80068f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800696:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80069d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006a4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006ab:	48 8b 0a             	mov    (%rdx),%rcx
  8006ae:	48 89 08             	mov    %rcx,(%rax)
  8006b1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006b5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006b9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006bd:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8006c1:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8006c8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006cf:	48 89 d6             	mov    %rdx,%rsi
  8006d2:	48 89 c7             	mov    %rax,%rdi
  8006d5:	48 b8 6b 05 80 00 00 	movabs $0x80056b,%rax
  8006dc:	00 00 00 
  8006df:	ff d0                	callq  *%rax
  8006e1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8006e7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8006ed:	c9                   	leaveq 
  8006ee:	c3                   	retq   

00000000008006ef <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006ef:	55                   	push   %rbp
  8006f0:	48 89 e5             	mov    %rsp,%rbp
  8006f3:	53                   	push   %rbx
  8006f4:	48 83 ec 38          	sub    $0x38,%rsp
  8006f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800700:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800704:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800707:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80070b:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80070f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800712:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800716:	77 3b                	ja     800753 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800718:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80071b:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80071f:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800722:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800726:	ba 00 00 00 00       	mov    $0x0,%edx
  80072b:	48 f7 f3             	div    %rbx
  80072e:	48 89 c2             	mov    %rax,%rdx
  800731:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800734:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800737:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80073b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073f:	41 89 f9             	mov    %edi,%r9d
  800742:	48 89 c7             	mov    %rax,%rdi
  800745:	48 b8 ef 06 80 00 00 	movabs $0x8006ef,%rax
  80074c:	00 00 00 
  80074f:	ff d0                	callq  *%rax
  800751:	eb 1e                	jmp    800771 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800753:	eb 12                	jmp    800767 <printnum+0x78>
			putch(padc, putdat);
  800755:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800759:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80075c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800760:	48 89 ce             	mov    %rcx,%rsi
  800763:	89 d7                	mov    %edx,%edi
  800765:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800767:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80076b:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80076f:	7f e4                	jg     800755 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800771:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800774:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800778:	ba 00 00 00 00       	mov    $0x0,%edx
  80077d:	48 f7 f1             	div    %rcx
  800780:	48 89 d0             	mov    %rdx,%rax
  800783:	48 ba 30 41 80 00 00 	movabs $0x804130,%rdx
  80078a:	00 00 00 
  80078d:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800791:	0f be d0             	movsbl %al,%edx
  800794:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800798:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079c:	48 89 ce             	mov    %rcx,%rsi
  80079f:	89 d7                	mov    %edx,%edi
  8007a1:	ff d0                	callq  *%rax
}
  8007a3:	48 83 c4 38          	add    $0x38,%rsp
  8007a7:	5b                   	pop    %rbx
  8007a8:	5d                   	pop    %rbp
  8007a9:	c3                   	retq   

00000000008007aa <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007aa:	55                   	push   %rbp
  8007ab:	48 89 e5             	mov    %rsp,%rbp
  8007ae:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007b2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007b6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8007b9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007bd:	7e 52                	jle    800811 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8007bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c3:	8b 00                	mov    (%rax),%eax
  8007c5:	83 f8 30             	cmp    $0x30,%eax
  8007c8:	73 24                	jae    8007ee <getuint+0x44>
  8007ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ce:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d6:	8b 00                	mov    (%rax),%eax
  8007d8:	89 c0                	mov    %eax,%eax
  8007da:	48 01 d0             	add    %rdx,%rax
  8007dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e1:	8b 12                	mov    (%rdx),%edx
  8007e3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ea:	89 0a                	mov    %ecx,(%rdx)
  8007ec:	eb 17                	jmp    800805 <getuint+0x5b>
  8007ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007f6:	48 89 d0             	mov    %rdx,%rax
  8007f9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800801:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800805:	48 8b 00             	mov    (%rax),%rax
  800808:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80080c:	e9 a3 00 00 00       	jmpq   8008b4 <getuint+0x10a>
	else if (lflag)
  800811:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800815:	74 4f                	je     800866 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800817:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081b:	8b 00                	mov    (%rax),%eax
  80081d:	83 f8 30             	cmp    $0x30,%eax
  800820:	73 24                	jae    800846 <getuint+0x9c>
  800822:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800826:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80082a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082e:	8b 00                	mov    (%rax),%eax
  800830:	89 c0                	mov    %eax,%eax
  800832:	48 01 d0             	add    %rdx,%rax
  800835:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800839:	8b 12                	mov    (%rdx),%edx
  80083b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80083e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800842:	89 0a                	mov    %ecx,(%rdx)
  800844:	eb 17                	jmp    80085d <getuint+0xb3>
  800846:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80084e:	48 89 d0             	mov    %rdx,%rax
  800851:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800855:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800859:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80085d:	48 8b 00             	mov    (%rax),%rax
  800860:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800864:	eb 4e                	jmp    8008b4 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800866:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086a:	8b 00                	mov    (%rax),%eax
  80086c:	83 f8 30             	cmp    $0x30,%eax
  80086f:	73 24                	jae    800895 <getuint+0xeb>
  800871:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800875:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800879:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087d:	8b 00                	mov    (%rax),%eax
  80087f:	89 c0                	mov    %eax,%eax
  800881:	48 01 d0             	add    %rdx,%rax
  800884:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800888:	8b 12                	mov    (%rdx),%edx
  80088a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80088d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800891:	89 0a                	mov    %ecx,(%rdx)
  800893:	eb 17                	jmp    8008ac <getuint+0x102>
  800895:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800899:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80089d:	48 89 d0             	mov    %rdx,%rax
  8008a0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008ac:	8b 00                	mov    (%rax),%eax
  8008ae:	89 c0                	mov    %eax,%eax
  8008b0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008b8:	c9                   	leaveq 
  8008b9:	c3                   	retq   

00000000008008ba <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008ba:	55                   	push   %rbp
  8008bb:	48 89 e5             	mov    %rsp,%rbp
  8008be:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008c6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8008c9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008cd:	7e 52                	jle    800921 <getint+0x67>
		x=va_arg(*ap, long long);
  8008cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d3:	8b 00                	mov    (%rax),%eax
  8008d5:	83 f8 30             	cmp    $0x30,%eax
  8008d8:	73 24                	jae    8008fe <getint+0x44>
  8008da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008de:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e6:	8b 00                	mov    (%rax),%eax
  8008e8:	89 c0                	mov    %eax,%eax
  8008ea:	48 01 d0             	add    %rdx,%rax
  8008ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f1:	8b 12                	mov    (%rdx),%edx
  8008f3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008fa:	89 0a                	mov    %ecx,(%rdx)
  8008fc:	eb 17                	jmp    800915 <getint+0x5b>
  8008fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800902:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800906:	48 89 d0             	mov    %rdx,%rax
  800909:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80090d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800911:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800915:	48 8b 00             	mov    (%rax),%rax
  800918:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80091c:	e9 a3 00 00 00       	jmpq   8009c4 <getint+0x10a>
	else if (lflag)
  800921:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800925:	74 4f                	je     800976 <getint+0xbc>
		x=va_arg(*ap, long);
  800927:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092b:	8b 00                	mov    (%rax),%eax
  80092d:	83 f8 30             	cmp    $0x30,%eax
  800930:	73 24                	jae    800956 <getint+0x9c>
  800932:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800936:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80093a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80093e:	8b 00                	mov    (%rax),%eax
  800940:	89 c0                	mov    %eax,%eax
  800942:	48 01 d0             	add    %rdx,%rax
  800945:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800949:	8b 12                	mov    (%rdx),%edx
  80094b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80094e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800952:	89 0a                	mov    %ecx,(%rdx)
  800954:	eb 17                	jmp    80096d <getint+0xb3>
  800956:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80095e:	48 89 d0             	mov    %rdx,%rax
  800961:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800965:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800969:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80096d:	48 8b 00             	mov    (%rax),%rax
  800970:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800974:	eb 4e                	jmp    8009c4 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800976:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80097a:	8b 00                	mov    (%rax),%eax
  80097c:	83 f8 30             	cmp    $0x30,%eax
  80097f:	73 24                	jae    8009a5 <getint+0xeb>
  800981:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800985:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800989:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098d:	8b 00                	mov    (%rax),%eax
  80098f:	89 c0                	mov    %eax,%eax
  800991:	48 01 d0             	add    %rdx,%rax
  800994:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800998:	8b 12                	mov    (%rdx),%edx
  80099a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80099d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009a1:	89 0a                	mov    %ecx,(%rdx)
  8009a3:	eb 17                	jmp    8009bc <getint+0x102>
  8009a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009ad:	48 89 d0             	mov    %rdx,%rax
  8009b0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009bc:	8b 00                	mov    (%rax),%eax
  8009be:	48 98                	cltq   
  8009c0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009c8:	c9                   	leaveq 
  8009c9:	c3                   	retq   

00000000008009ca <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009ca:	55                   	push   %rbp
  8009cb:	48 89 e5             	mov    %rsp,%rbp
  8009ce:	41 54                	push   %r12
  8009d0:	53                   	push   %rbx
  8009d1:	48 83 ec 60          	sub    $0x60,%rsp
  8009d5:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8009d9:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8009dd:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009e1:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8009e5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009e9:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8009ed:	48 8b 0a             	mov    (%rdx),%rcx
  8009f0:	48 89 08             	mov    %rcx,(%rax)
  8009f3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8009f7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8009fb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8009ff:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a03:	eb 17                	jmp    800a1c <vprintfmt+0x52>
			if (ch == '\0')
  800a05:	85 db                	test   %ebx,%ebx
  800a07:	0f 84 cc 04 00 00    	je     800ed9 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800a0d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a11:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a15:	48 89 d6             	mov    %rdx,%rsi
  800a18:	89 df                	mov    %ebx,%edi
  800a1a:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a1c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a20:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a24:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a28:	0f b6 00             	movzbl (%rax),%eax
  800a2b:	0f b6 d8             	movzbl %al,%ebx
  800a2e:	83 fb 25             	cmp    $0x25,%ebx
  800a31:	75 d2                	jne    800a05 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a33:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a37:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a3e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a45:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a4c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a53:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a57:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a5b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a5f:	0f b6 00             	movzbl (%rax),%eax
  800a62:	0f b6 d8             	movzbl %al,%ebx
  800a65:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a68:	83 f8 55             	cmp    $0x55,%eax
  800a6b:	0f 87 34 04 00 00    	ja     800ea5 <vprintfmt+0x4db>
  800a71:	89 c0                	mov    %eax,%eax
  800a73:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a7a:	00 
  800a7b:	48 b8 58 41 80 00 00 	movabs $0x804158,%rax
  800a82:	00 00 00 
  800a85:	48 01 d0             	add    %rdx,%rax
  800a88:	48 8b 00             	mov    (%rax),%rax
  800a8b:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800a8d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a91:	eb c0                	jmp    800a53 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a93:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800a97:	eb ba                	jmp    800a53 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a99:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800aa0:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800aa3:	89 d0                	mov    %edx,%eax
  800aa5:	c1 e0 02             	shl    $0x2,%eax
  800aa8:	01 d0                	add    %edx,%eax
  800aaa:	01 c0                	add    %eax,%eax
  800aac:	01 d8                	add    %ebx,%eax
  800aae:	83 e8 30             	sub    $0x30,%eax
  800ab1:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800ab4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ab8:	0f b6 00             	movzbl (%rax),%eax
  800abb:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800abe:	83 fb 2f             	cmp    $0x2f,%ebx
  800ac1:	7e 0c                	jle    800acf <vprintfmt+0x105>
  800ac3:	83 fb 39             	cmp    $0x39,%ebx
  800ac6:	7f 07                	jg     800acf <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ac8:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800acd:	eb d1                	jmp    800aa0 <vprintfmt+0xd6>
			goto process_precision;
  800acf:	eb 58                	jmp    800b29 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800ad1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad4:	83 f8 30             	cmp    $0x30,%eax
  800ad7:	73 17                	jae    800af0 <vprintfmt+0x126>
  800ad9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800add:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae0:	89 c0                	mov    %eax,%eax
  800ae2:	48 01 d0             	add    %rdx,%rax
  800ae5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ae8:	83 c2 08             	add    $0x8,%edx
  800aeb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800aee:	eb 0f                	jmp    800aff <vprintfmt+0x135>
  800af0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800af4:	48 89 d0             	mov    %rdx,%rax
  800af7:	48 83 c2 08          	add    $0x8,%rdx
  800afb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800aff:	8b 00                	mov    (%rax),%eax
  800b01:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b04:	eb 23                	jmp    800b29 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800b06:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b0a:	79 0c                	jns    800b18 <vprintfmt+0x14e>
				width = 0;
  800b0c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b13:	e9 3b ff ff ff       	jmpq   800a53 <vprintfmt+0x89>
  800b18:	e9 36 ff ff ff       	jmpq   800a53 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800b1d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b24:	e9 2a ff ff ff       	jmpq   800a53 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800b29:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b2d:	79 12                	jns    800b41 <vprintfmt+0x177>
				width = precision, precision = -1;
  800b2f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b32:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b35:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b3c:	e9 12 ff ff ff       	jmpq   800a53 <vprintfmt+0x89>
  800b41:	e9 0d ff ff ff       	jmpq   800a53 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b46:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b4a:	e9 04 ff ff ff       	jmpq   800a53 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b4f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b52:	83 f8 30             	cmp    $0x30,%eax
  800b55:	73 17                	jae    800b6e <vprintfmt+0x1a4>
  800b57:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b5b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b5e:	89 c0                	mov    %eax,%eax
  800b60:	48 01 d0             	add    %rdx,%rax
  800b63:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b66:	83 c2 08             	add    $0x8,%edx
  800b69:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b6c:	eb 0f                	jmp    800b7d <vprintfmt+0x1b3>
  800b6e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b72:	48 89 d0             	mov    %rdx,%rax
  800b75:	48 83 c2 08          	add    $0x8,%rdx
  800b79:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b7d:	8b 10                	mov    (%rax),%edx
  800b7f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b83:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b87:	48 89 ce             	mov    %rcx,%rsi
  800b8a:	89 d7                	mov    %edx,%edi
  800b8c:	ff d0                	callq  *%rax
			break;
  800b8e:	e9 40 03 00 00       	jmpq   800ed3 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800b93:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b96:	83 f8 30             	cmp    $0x30,%eax
  800b99:	73 17                	jae    800bb2 <vprintfmt+0x1e8>
  800b9b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b9f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ba2:	89 c0                	mov    %eax,%eax
  800ba4:	48 01 d0             	add    %rdx,%rax
  800ba7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800baa:	83 c2 08             	add    $0x8,%edx
  800bad:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bb0:	eb 0f                	jmp    800bc1 <vprintfmt+0x1f7>
  800bb2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bb6:	48 89 d0             	mov    %rdx,%rax
  800bb9:	48 83 c2 08          	add    $0x8,%rdx
  800bbd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bc1:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800bc3:	85 db                	test   %ebx,%ebx
  800bc5:	79 02                	jns    800bc9 <vprintfmt+0x1ff>
				err = -err;
  800bc7:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800bc9:	83 fb 15             	cmp    $0x15,%ebx
  800bcc:	7f 16                	jg     800be4 <vprintfmt+0x21a>
  800bce:	48 b8 80 40 80 00 00 	movabs $0x804080,%rax
  800bd5:	00 00 00 
  800bd8:	48 63 d3             	movslq %ebx,%rdx
  800bdb:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800bdf:	4d 85 e4             	test   %r12,%r12
  800be2:	75 2e                	jne    800c12 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800be4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800be8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bec:	89 d9                	mov    %ebx,%ecx
  800bee:	48 ba 41 41 80 00 00 	movabs $0x804141,%rdx
  800bf5:	00 00 00 
  800bf8:	48 89 c7             	mov    %rax,%rdi
  800bfb:	b8 00 00 00 00       	mov    $0x0,%eax
  800c00:	49 b8 e2 0e 80 00 00 	movabs $0x800ee2,%r8
  800c07:	00 00 00 
  800c0a:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c0d:	e9 c1 02 00 00       	jmpq   800ed3 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c12:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c16:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c1a:	4c 89 e1             	mov    %r12,%rcx
  800c1d:	48 ba 4a 41 80 00 00 	movabs $0x80414a,%rdx
  800c24:	00 00 00 
  800c27:	48 89 c7             	mov    %rax,%rdi
  800c2a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c2f:	49 b8 e2 0e 80 00 00 	movabs $0x800ee2,%r8
  800c36:	00 00 00 
  800c39:	41 ff d0             	callq  *%r8
			break;
  800c3c:	e9 92 02 00 00       	jmpq   800ed3 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c41:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c44:	83 f8 30             	cmp    $0x30,%eax
  800c47:	73 17                	jae    800c60 <vprintfmt+0x296>
  800c49:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c4d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c50:	89 c0                	mov    %eax,%eax
  800c52:	48 01 d0             	add    %rdx,%rax
  800c55:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c58:	83 c2 08             	add    $0x8,%edx
  800c5b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c5e:	eb 0f                	jmp    800c6f <vprintfmt+0x2a5>
  800c60:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c64:	48 89 d0             	mov    %rdx,%rax
  800c67:	48 83 c2 08          	add    $0x8,%rdx
  800c6b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c6f:	4c 8b 20             	mov    (%rax),%r12
  800c72:	4d 85 e4             	test   %r12,%r12
  800c75:	75 0a                	jne    800c81 <vprintfmt+0x2b7>
				p = "(null)";
  800c77:	49 bc 4d 41 80 00 00 	movabs $0x80414d,%r12
  800c7e:	00 00 00 
			if (width > 0 && padc != '-')
  800c81:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c85:	7e 3f                	jle    800cc6 <vprintfmt+0x2fc>
  800c87:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c8b:	74 39                	je     800cc6 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c8d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c90:	48 98                	cltq   
  800c92:	48 89 c6             	mov    %rax,%rsi
  800c95:	4c 89 e7             	mov    %r12,%rdi
  800c98:	48 b8 8e 11 80 00 00 	movabs $0x80118e,%rax
  800c9f:	00 00 00 
  800ca2:	ff d0                	callq  *%rax
  800ca4:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800ca7:	eb 17                	jmp    800cc0 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800ca9:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800cad:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cb1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cb5:	48 89 ce             	mov    %rcx,%rsi
  800cb8:	89 d7                	mov    %edx,%edi
  800cba:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800cbc:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cc0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cc4:	7f e3                	jg     800ca9 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cc6:	eb 37                	jmp    800cff <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800cc8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800ccc:	74 1e                	je     800cec <vprintfmt+0x322>
  800cce:	83 fb 1f             	cmp    $0x1f,%ebx
  800cd1:	7e 05                	jle    800cd8 <vprintfmt+0x30e>
  800cd3:	83 fb 7e             	cmp    $0x7e,%ebx
  800cd6:	7e 14                	jle    800cec <vprintfmt+0x322>
					putch('?', putdat);
  800cd8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cdc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ce0:	48 89 d6             	mov    %rdx,%rsi
  800ce3:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800ce8:	ff d0                	callq  *%rax
  800cea:	eb 0f                	jmp    800cfb <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800cec:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cf0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cf4:	48 89 d6             	mov    %rdx,%rsi
  800cf7:	89 df                	mov    %ebx,%edi
  800cf9:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cfb:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cff:	4c 89 e0             	mov    %r12,%rax
  800d02:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d06:	0f b6 00             	movzbl (%rax),%eax
  800d09:	0f be d8             	movsbl %al,%ebx
  800d0c:	85 db                	test   %ebx,%ebx
  800d0e:	74 10                	je     800d20 <vprintfmt+0x356>
  800d10:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d14:	78 b2                	js     800cc8 <vprintfmt+0x2fe>
  800d16:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d1a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d1e:	79 a8                	jns    800cc8 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d20:	eb 16                	jmp    800d38 <vprintfmt+0x36e>
				putch(' ', putdat);
  800d22:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d26:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d2a:	48 89 d6             	mov    %rdx,%rsi
  800d2d:	bf 20 00 00 00       	mov    $0x20,%edi
  800d32:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d34:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d38:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d3c:	7f e4                	jg     800d22 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800d3e:	e9 90 01 00 00       	jmpq   800ed3 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d43:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d47:	be 03 00 00 00       	mov    $0x3,%esi
  800d4c:	48 89 c7             	mov    %rax,%rdi
  800d4f:	48 b8 ba 08 80 00 00 	movabs $0x8008ba,%rax
  800d56:	00 00 00 
  800d59:	ff d0                	callq  *%rax
  800d5b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d63:	48 85 c0             	test   %rax,%rax
  800d66:	79 1d                	jns    800d85 <vprintfmt+0x3bb>
				putch('-', putdat);
  800d68:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d6c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d70:	48 89 d6             	mov    %rdx,%rsi
  800d73:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d78:	ff d0                	callq  *%rax
				num = -(long long) num;
  800d7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d7e:	48 f7 d8             	neg    %rax
  800d81:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d85:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d8c:	e9 d5 00 00 00       	jmpq   800e66 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d91:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d95:	be 03 00 00 00       	mov    $0x3,%esi
  800d9a:	48 89 c7             	mov    %rax,%rdi
  800d9d:	48 b8 aa 07 80 00 00 	movabs $0x8007aa,%rax
  800da4:	00 00 00 
  800da7:	ff d0                	callq  *%rax
  800da9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800dad:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800db4:	e9 ad 00 00 00       	jmpq   800e66 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  800db9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dbd:	be 03 00 00 00       	mov    $0x3,%esi
  800dc2:	48 89 c7             	mov    %rax,%rdi
  800dc5:	48 b8 aa 07 80 00 00 	movabs $0x8007aa,%rax
  800dcc:	00 00 00 
  800dcf:	ff d0                	callq  *%rax
  800dd1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  800dd5:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  800ddc:	e9 85 00 00 00       	jmpq   800e66 <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  800de1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800de5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de9:	48 89 d6             	mov    %rdx,%rsi
  800dec:	bf 30 00 00 00       	mov    $0x30,%edi
  800df1:	ff d0                	callq  *%rax
			putch('x', putdat);
  800df3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800df7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dfb:	48 89 d6             	mov    %rdx,%rsi
  800dfe:	bf 78 00 00 00       	mov    $0x78,%edi
  800e03:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e05:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e08:	83 f8 30             	cmp    $0x30,%eax
  800e0b:	73 17                	jae    800e24 <vprintfmt+0x45a>
  800e0d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e11:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e14:	89 c0                	mov    %eax,%eax
  800e16:	48 01 d0             	add    %rdx,%rax
  800e19:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e1c:	83 c2 08             	add    $0x8,%edx
  800e1f:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e22:	eb 0f                	jmp    800e33 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800e24:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e28:	48 89 d0             	mov    %rdx,%rax
  800e2b:	48 83 c2 08          	add    $0x8,%rdx
  800e2f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e33:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e36:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e3a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e41:	eb 23                	jmp    800e66 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e43:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e47:	be 03 00 00 00       	mov    $0x3,%esi
  800e4c:	48 89 c7             	mov    %rax,%rdi
  800e4f:	48 b8 aa 07 80 00 00 	movabs $0x8007aa,%rax
  800e56:	00 00 00 
  800e59:	ff d0                	callq  *%rax
  800e5b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e5f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e66:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e6b:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e6e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e71:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e75:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e79:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e7d:	45 89 c1             	mov    %r8d,%r9d
  800e80:	41 89 f8             	mov    %edi,%r8d
  800e83:	48 89 c7             	mov    %rax,%rdi
  800e86:	48 b8 ef 06 80 00 00 	movabs $0x8006ef,%rax
  800e8d:	00 00 00 
  800e90:	ff d0                	callq  *%rax
			break;
  800e92:	eb 3f                	jmp    800ed3 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e94:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e98:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e9c:	48 89 d6             	mov    %rdx,%rsi
  800e9f:	89 df                	mov    %ebx,%edi
  800ea1:	ff d0                	callq  *%rax
			break;
  800ea3:	eb 2e                	jmp    800ed3 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ea5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ea9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ead:	48 89 d6             	mov    %rdx,%rsi
  800eb0:	bf 25 00 00 00       	mov    $0x25,%edi
  800eb5:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800eb7:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ebc:	eb 05                	jmp    800ec3 <vprintfmt+0x4f9>
  800ebe:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ec3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ec7:	48 83 e8 01          	sub    $0x1,%rax
  800ecb:	0f b6 00             	movzbl (%rax),%eax
  800ece:	3c 25                	cmp    $0x25,%al
  800ed0:	75 ec                	jne    800ebe <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800ed2:	90                   	nop
		}
	}
  800ed3:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ed4:	e9 43 fb ff ff       	jmpq   800a1c <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800ed9:	48 83 c4 60          	add    $0x60,%rsp
  800edd:	5b                   	pop    %rbx
  800ede:	41 5c                	pop    %r12
  800ee0:	5d                   	pop    %rbp
  800ee1:	c3                   	retq   

0000000000800ee2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ee2:	55                   	push   %rbp
  800ee3:	48 89 e5             	mov    %rsp,%rbp
  800ee6:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800eed:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800ef4:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800efb:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f02:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f09:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f10:	84 c0                	test   %al,%al
  800f12:	74 20                	je     800f34 <printfmt+0x52>
  800f14:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f18:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f1c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f20:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f24:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f28:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f2c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f30:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f34:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f3b:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f42:	00 00 00 
  800f45:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f4c:	00 00 00 
  800f4f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f53:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f5a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f61:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f68:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f6f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800f76:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800f7d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800f84:	48 89 c7             	mov    %rax,%rdi
  800f87:	48 b8 ca 09 80 00 00 	movabs $0x8009ca,%rax
  800f8e:	00 00 00 
  800f91:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f93:	c9                   	leaveq 
  800f94:	c3                   	retq   

0000000000800f95 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f95:	55                   	push   %rbp
  800f96:	48 89 e5             	mov    %rsp,%rbp
  800f99:	48 83 ec 10          	sub    $0x10,%rsp
  800f9d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fa0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800fa4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fa8:	8b 40 10             	mov    0x10(%rax),%eax
  800fab:	8d 50 01             	lea    0x1(%rax),%edx
  800fae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fb2:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800fb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fb9:	48 8b 10             	mov    (%rax),%rdx
  800fbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fc0:	48 8b 40 08          	mov    0x8(%rax),%rax
  800fc4:	48 39 c2             	cmp    %rax,%rdx
  800fc7:	73 17                	jae    800fe0 <sprintputch+0x4b>
		*b->buf++ = ch;
  800fc9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fcd:	48 8b 00             	mov    (%rax),%rax
  800fd0:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800fd4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800fd8:	48 89 0a             	mov    %rcx,(%rdx)
  800fdb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800fde:	88 10                	mov    %dl,(%rax)
}
  800fe0:	c9                   	leaveq 
  800fe1:	c3                   	retq   

0000000000800fe2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fe2:	55                   	push   %rbp
  800fe3:	48 89 e5             	mov    %rsp,%rbp
  800fe6:	48 83 ec 50          	sub    $0x50,%rsp
  800fea:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800fee:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800ff1:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ff5:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ff9:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ffd:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801001:	48 8b 0a             	mov    (%rdx),%rcx
  801004:	48 89 08             	mov    %rcx,(%rax)
  801007:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80100b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80100f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801013:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801017:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80101b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80101f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801022:	48 98                	cltq   
  801024:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801028:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80102c:	48 01 d0             	add    %rdx,%rax
  80102f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801033:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80103a:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80103f:	74 06                	je     801047 <vsnprintf+0x65>
  801041:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801045:	7f 07                	jg     80104e <vsnprintf+0x6c>
		return -E_INVAL;
  801047:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80104c:	eb 2f                	jmp    80107d <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80104e:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801052:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801056:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80105a:	48 89 c6             	mov    %rax,%rsi
  80105d:	48 bf 95 0f 80 00 00 	movabs $0x800f95,%rdi
  801064:	00 00 00 
  801067:	48 b8 ca 09 80 00 00 	movabs $0x8009ca,%rax
  80106e:	00 00 00 
  801071:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801073:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801077:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80107a:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80107d:	c9                   	leaveq 
  80107e:	c3                   	retq   

000000000080107f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80107f:	55                   	push   %rbp
  801080:	48 89 e5             	mov    %rsp,%rbp
  801083:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80108a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801091:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801097:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80109e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010a5:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010ac:	84 c0                	test   %al,%al
  8010ae:	74 20                	je     8010d0 <snprintf+0x51>
  8010b0:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010b4:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010b8:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010bc:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010c0:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010c4:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8010c8:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010cc:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8010d0:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8010d7:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8010de:	00 00 00 
  8010e1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8010e8:	00 00 00 
  8010eb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8010ef:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8010f6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010fd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801104:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80110b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801112:	48 8b 0a             	mov    (%rdx),%rcx
  801115:	48 89 08             	mov    %rcx,(%rax)
  801118:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80111c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801120:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801124:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801128:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80112f:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801136:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80113c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801143:	48 89 c7             	mov    %rax,%rdi
  801146:	48 b8 e2 0f 80 00 00 	movabs $0x800fe2,%rax
  80114d:	00 00 00 
  801150:	ff d0                	callq  *%rax
  801152:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801158:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80115e:	c9                   	leaveq 
  80115f:	c3                   	retq   

0000000000801160 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801160:	55                   	push   %rbp
  801161:	48 89 e5             	mov    %rsp,%rbp
  801164:	48 83 ec 18          	sub    $0x18,%rsp
  801168:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80116c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801173:	eb 09                	jmp    80117e <strlen+0x1e>
		n++;
  801175:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801179:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80117e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801182:	0f b6 00             	movzbl (%rax),%eax
  801185:	84 c0                	test   %al,%al
  801187:	75 ec                	jne    801175 <strlen+0x15>
		n++;
	return n;
  801189:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80118c:	c9                   	leaveq 
  80118d:	c3                   	retq   

000000000080118e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80118e:	55                   	push   %rbp
  80118f:	48 89 e5             	mov    %rsp,%rbp
  801192:	48 83 ec 20          	sub    $0x20,%rsp
  801196:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80119a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80119e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011a5:	eb 0e                	jmp    8011b5 <strnlen+0x27>
		n++;
  8011a7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011ab:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011b0:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8011b5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8011ba:	74 0b                	je     8011c7 <strnlen+0x39>
  8011bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c0:	0f b6 00             	movzbl (%rax),%eax
  8011c3:	84 c0                	test   %al,%al
  8011c5:	75 e0                	jne    8011a7 <strnlen+0x19>
		n++;
	return n;
  8011c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011ca:	c9                   	leaveq 
  8011cb:	c3                   	retq   

00000000008011cc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011cc:	55                   	push   %rbp
  8011cd:	48 89 e5             	mov    %rsp,%rbp
  8011d0:	48 83 ec 20          	sub    $0x20,%rsp
  8011d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011d8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8011dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8011e4:	90                   	nop
  8011e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011ed:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011f1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011f5:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011f9:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011fd:	0f b6 12             	movzbl (%rdx),%edx
  801200:	88 10                	mov    %dl,(%rax)
  801202:	0f b6 00             	movzbl (%rax),%eax
  801205:	84 c0                	test   %al,%al
  801207:	75 dc                	jne    8011e5 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801209:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80120d:	c9                   	leaveq 
  80120e:	c3                   	retq   

000000000080120f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80120f:	55                   	push   %rbp
  801210:	48 89 e5             	mov    %rsp,%rbp
  801213:	48 83 ec 20          	sub    $0x20,%rsp
  801217:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80121b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80121f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801223:	48 89 c7             	mov    %rax,%rdi
  801226:	48 b8 60 11 80 00 00 	movabs $0x801160,%rax
  80122d:	00 00 00 
  801230:	ff d0                	callq  *%rax
  801232:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801235:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801238:	48 63 d0             	movslq %eax,%rdx
  80123b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80123f:	48 01 c2             	add    %rax,%rdx
  801242:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801246:	48 89 c6             	mov    %rax,%rsi
  801249:	48 89 d7             	mov    %rdx,%rdi
  80124c:	48 b8 cc 11 80 00 00 	movabs $0x8011cc,%rax
  801253:	00 00 00 
  801256:	ff d0                	callq  *%rax
	return dst;
  801258:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80125c:	c9                   	leaveq 
  80125d:	c3                   	retq   

000000000080125e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80125e:	55                   	push   %rbp
  80125f:	48 89 e5             	mov    %rsp,%rbp
  801262:	48 83 ec 28          	sub    $0x28,%rsp
  801266:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80126a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80126e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801272:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801276:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80127a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801281:	00 
  801282:	eb 2a                	jmp    8012ae <strncpy+0x50>
		*dst++ = *src;
  801284:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801288:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80128c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801290:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801294:	0f b6 12             	movzbl (%rdx),%edx
  801297:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801299:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80129d:	0f b6 00             	movzbl (%rax),%eax
  8012a0:	84 c0                	test   %al,%al
  8012a2:	74 05                	je     8012a9 <strncpy+0x4b>
			src++;
  8012a4:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012a9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8012b6:	72 cc                	jb     801284 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8012bc:	c9                   	leaveq 
  8012bd:	c3                   	retq   

00000000008012be <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8012be:	55                   	push   %rbp
  8012bf:	48 89 e5             	mov    %rsp,%rbp
  8012c2:	48 83 ec 28          	sub    $0x28,%rsp
  8012c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012ca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012ce:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8012d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8012da:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012df:	74 3d                	je     80131e <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8012e1:	eb 1d                	jmp    801300 <strlcpy+0x42>
			*dst++ = *src++;
  8012e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012eb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012ef:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012f3:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8012f7:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8012fb:	0f b6 12             	movzbl (%rdx),%edx
  8012fe:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801300:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801305:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80130a:	74 0b                	je     801317 <strlcpy+0x59>
  80130c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801310:	0f b6 00             	movzbl (%rax),%eax
  801313:	84 c0                	test   %al,%al
  801315:	75 cc                	jne    8012e3 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801317:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80131b:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80131e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801322:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801326:	48 29 c2             	sub    %rax,%rdx
  801329:	48 89 d0             	mov    %rdx,%rax
}
  80132c:	c9                   	leaveq 
  80132d:	c3                   	retq   

000000000080132e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80132e:	55                   	push   %rbp
  80132f:	48 89 e5             	mov    %rsp,%rbp
  801332:	48 83 ec 10          	sub    $0x10,%rsp
  801336:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80133a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80133e:	eb 0a                	jmp    80134a <strcmp+0x1c>
		p++, q++;
  801340:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801345:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80134a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134e:	0f b6 00             	movzbl (%rax),%eax
  801351:	84 c0                	test   %al,%al
  801353:	74 12                	je     801367 <strcmp+0x39>
  801355:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801359:	0f b6 10             	movzbl (%rax),%edx
  80135c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801360:	0f b6 00             	movzbl (%rax),%eax
  801363:	38 c2                	cmp    %al,%dl
  801365:	74 d9                	je     801340 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801367:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136b:	0f b6 00             	movzbl (%rax),%eax
  80136e:	0f b6 d0             	movzbl %al,%edx
  801371:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801375:	0f b6 00             	movzbl (%rax),%eax
  801378:	0f b6 c0             	movzbl %al,%eax
  80137b:	29 c2                	sub    %eax,%edx
  80137d:	89 d0                	mov    %edx,%eax
}
  80137f:	c9                   	leaveq 
  801380:	c3                   	retq   

0000000000801381 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801381:	55                   	push   %rbp
  801382:	48 89 e5             	mov    %rsp,%rbp
  801385:	48 83 ec 18          	sub    $0x18,%rsp
  801389:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80138d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801391:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801395:	eb 0f                	jmp    8013a6 <strncmp+0x25>
		n--, p++, q++;
  801397:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80139c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013a1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8013a6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013ab:	74 1d                	je     8013ca <strncmp+0x49>
  8013ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b1:	0f b6 00             	movzbl (%rax),%eax
  8013b4:	84 c0                	test   %al,%al
  8013b6:	74 12                	je     8013ca <strncmp+0x49>
  8013b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013bc:	0f b6 10             	movzbl (%rax),%edx
  8013bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c3:	0f b6 00             	movzbl (%rax),%eax
  8013c6:	38 c2                	cmp    %al,%dl
  8013c8:	74 cd                	je     801397 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8013ca:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013cf:	75 07                	jne    8013d8 <strncmp+0x57>
		return 0;
  8013d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d6:	eb 18                	jmp    8013f0 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013dc:	0f b6 00             	movzbl (%rax),%eax
  8013df:	0f b6 d0             	movzbl %al,%edx
  8013e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e6:	0f b6 00             	movzbl (%rax),%eax
  8013e9:	0f b6 c0             	movzbl %al,%eax
  8013ec:	29 c2                	sub    %eax,%edx
  8013ee:	89 d0                	mov    %edx,%eax
}
  8013f0:	c9                   	leaveq 
  8013f1:	c3                   	retq   

00000000008013f2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013f2:	55                   	push   %rbp
  8013f3:	48 89 e5             	mov    %rsp,%rbp
  8013f6:	48 83 ec 0c          	sub    $0xc,%rsp
  8013fa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013fe:	89 f0                	mov    %esi,%eax
  801400:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801403:	eb 17                	jmp    80141c <strchr+0x2a>
		if (*s == c)
  801405:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801409:	0f b6 00             	movzbl (%rax),%eax
  80140c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80140f:	75 06                	jne    801417 <strchr+0x25>
			return (char *) s;
  801411:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801415:	eb 15                	jmp    80142c <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801417:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80141c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801420:	0f b6 00             	movzbl (%rax),%eax
  801423:	84 c0                	test   %al,%al
  801425:	75 de                	jne    801405 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801427:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80142c:	c9                   	leaveq 
  80142d:	c3                   	retq   

000000000080142e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80142e:	55                   	push   %rbp
  80142f:	48 89 e5             	mov    %rsp,%rbp
  801432:	48 83 ec 0c          	sub    $0xc,%rsp
  801436:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80143a:	89 f0                	mov    %esi,%eax
  80143c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80143f:	eb 13                	jmp    801454 <strfind+0x26>
		if (*s == c)
  801441:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801445:	0f b6 00             	movzbl (%rax),%eax
  801448:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80144b:	75 02                	jne    80144f <strfind+0x21>
			break;
  80144d:	eb 10                	jmp    80145f <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80144f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801454:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801458:	0f b6 00             	movzbl (%rax),%eax
  80145b:	84 c0                	test   %al,%al
  80145d:	75 e2                	jne    801441 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80145f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801463:	c9                   	leaveq 
  801464:	c3                   	retq   

0000000000801465 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801465:	55                   	push   %rbp
  801466:	48 89 e5             	mov    %rsp,%rbp
  801469:	48 83 ec 18          	sub    $0x18,%rsp
  80146d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801471:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801474:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801478:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80147d:	75 06                	jne    801485 <memset+0x20>
		return v;
  80147f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801483:	eb 69                	jmp    8014ee <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801485:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801489:	83 e0 03             	and    $0x3,%eax
  80148c:	48 85 c0             	test   %rax,%rax
  80148f:	75 48                	jne    8014d9 <memset+0x74>
  801491:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801495:	83 e0 03             	and    $0x3,%eax
  801498:	48 85 c0             	test   %rax,%rax
  80149b:	75 3c                	jne    8014d9 <memset+0x74>
		c &= 0xFF;
  80149d:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014a4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014a7:	c1 e0 18             	shl    $0x18,%eax
  8014aa:	89 c2                	mov    %eax,%edx
  8014ac:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014af:	c1 e0 10             	shl    $0x10,%eax
  8014b2:	09 c2                	or     %eax,%edx
  8014b4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014b7:	c1 e0 08             	shl    $0x8,%eax
  8014ba:	09 d0                	or     %edx,%eax
  8014bc:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8014bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c3:	48 c1 e8 02          	shr    $0x2,%rax
  8014c7:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8014ca:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014ce:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014d1:	48 89 d7             	mov    %rdx,%rdi
  8014d4:	fc                   	cld    
  8014d5:	f3 ab                	rep stos %eax,%es:(%rdi)
  8014d7:	eb 11                	jmp    8014ea <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8014d9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014dd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014e0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8014e4:	48 89 d7             	mov    %rdx,%rdi
  8014e7:	fc                   	cld    
  8014e8:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8014ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014ee:	c9                   	leaveq 
  8014ef:	c3                   	retq   

00000000008014f0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8014f0:	55                   	push   %rbp
  8014f1:	48 89 e5             	mov    %rsp,%rbp
  8014f4:	48 83 ec 28          	sub    $0x28,%rsp
  8014f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801500:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801504:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801508:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80150c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801510:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801514:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801518:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80151c:	0f 83 88 00 00 00    	jae    8015aa <memmove+0xba>
  801522:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801526:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80152a:	48 01 d0             	add    %rdx,%rax
  80152d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801531:	76 77                	jbe    8015aa <memmove+0xba>
		s += n;
  801533:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801537:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80153b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153f:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801543:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801547:	83 e0 03             	and    $0x3,%eax
  80154a:	48 85 c0             	test   %rax,%rax
  80154d:	75 3b                	jne    80158a <memmove+0x9a>
  80154f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801553:	83 e0 03             	and    $0x3,%eax
  801556:	48 85 c0             	test   %rax,%rax
  801559:	75 2f                	jne    80158a <memmove+0x9a>
  80155b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80155f:	83 e0 03             	and    $0x3,%eax
  801562:	48 85 c0             	test   %rax,%rax
  801565:	75 23                	jne    80158a <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801567:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80156b:	48 83 e8 04          	sub    $0x4,%rax
  80156f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801573:	48 83 ea 04          	sub    $0x4,%rdx
  801577:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80157b:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80157f:	48 89 c7             	mov    %rax,%rdi
  801582:	48 89 d6             	mov    %rdx,%rsi
  801585:	fd                   	std    
  801586:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801588:	eb 1d                	jmp    8015a7 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80158a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80158e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801592:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801596:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80159a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159e:	48 89 d7             	mov    %rdx,%rdi
  8015a1:	48 89 c1             	mov    %rax,%rcx
  8015a4:	fd                   	std    
  8015a5:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015a7:	fc                   	cld    
  8015a8:	eb 57                	jmp    801601 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ae:	83 e0 03             	and    $0x3,%eax
  8015b1:	48 85 c0             	test   %rax,%rax
  8015b4:	75 36                	jne    8015ec <memmove+0xfc>
  8015b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015ba:	83 e0 03             	and    $0x3,%eax
  8015bd:	48 85 c0             	test   %rax,%rax
  8015c0:	75 2a                	jne    8015ec <memmove+0xfc>
  8015c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c6:	83 e0 03             	and    $0x3,%eax
  8015c9:	48 85 c0             	test   %rax,%rax
  8015cc:	75 1e                	jne    8015ec <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8015ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d2:	48 c1 e8 02          	shr    $0x2,%rax
  8015d6:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8015d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015dd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015e1:	48 89 c7             	mov    %rax,%rdi
  8015e4:	48 89 d6             	mov    %rdx,%rsi
  8015e7:	fc                   	cld    
  8015e8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015ea:	eb 15                	jmp    801601 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8015ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015f0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015f4:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015f8:	48 89 c7             	mov    %rax,%rdi
  8015fb:	48 89 d6             	mov    %rdx,%rsi
  8015fe:	fc                   	cld    
  8015ff:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801601:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801605:	c9                   	leaveq 
  801606:	c3                   	retq   

0000000000801607 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801607:	55                   	push   %rbp
  801608:	48 89 e5             	mov    %rsp,%rbp
  80160b:	48 83 ec 18          	sub    $0x18,%rsp
  80160f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801613:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801617:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80161b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80161f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801623:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801627:	48 89 ce             	mov    %rcx,%rsi
  80162a:	48 89 c7             	mov    %rax,%rdi
  80162d:	48 b8 f0 14 80 00 00 	movabs $0x8014f0,%rax
  801634:	00 00 00 
  801637:	ff d0                	callq  *%rax
}
  801639:	c9                   	leaveq 
  80163a:	c3                   	retq   

000000000080163b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80163b:	55                   	push   %rbp
  80163c:	48 89 e5             	mov    %rsp,%rbp
  80163f:	48 83 ec 28          	sub    $0x28,%rsp
  801643:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801647:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80164b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80164f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801653:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801657:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80165b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80165f:	eb 36                	jmp    801697 <memcmp+0x5c>
		if (*s1 != *s2)
  801661:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801665:	0f b6 10             	movzbl (%rax),%edx
  801668:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80166c:	0f b6 00             	movzbl (%rax),%eax
  80166f:	38 c2                	cmp    %al,%dl
  801671:	74 1a                	je     80168d <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801673:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801677:	0f b6 00             	movzbl (%rax),%eax
  80167a:	0f b6 d0             	movzbl %al,%edx
  80167d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801681:	0f b6 00             	movzbl (%rax),%eax
  801684:	0f b6 c0             	movzbl %al,%eax
  801687:	29 c2                	sub    %eax,%edx
  801689:	89 d0                	mov    %edx,%eax
  80168b:	eb 20                	jmp    8016ad <memcmp+0x72>
		s1++, s2++;
  80168d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801692:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801697:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80169f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8016a3:	48 85 c0             	test   %rax,%rax
  8016a6:	75 b9                	jne    801661 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ad:	c9                   	leaveq 
  8016ae:	c3                   	retq   

00000000008016af <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016af:	55                   	push   %rbp
  8016b0:	48 89 e5             	mov    %rsp,%rbp
  8016b3:	48 83 ec 28          	sub    $0x28,%rsp
  8016b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016bb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8016be:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8016c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016ca:	48 01 d0             	add    %rdx,%rax
  8016cd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8016d1:	eb 15                	jmp    8016e8 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016d7:	0f b6 10             	movzbl (%rax),%edx
  8016da:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8016dd:	38 c2                	cmp    %al,%dl
  8016df:	75 02                	jne    8016e3 <memfind+0x34>
			break;
  8016e1:	eb 0f                	jmp    8016f2 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016e3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8016e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016ec:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8016f0:	72 e1                	jb     8016d3 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8016f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016f6:	c9                   	leaveq 
  8016f7:	c3                   	retq   

00000000008016f8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016f8:	55                   	push   %rbp
  8016f9:	48 89 e5             	mov    %rsp,%rbp
  8016fc:	48 83 ec 34          	sub    $0x34,%rsp
  801700:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801704:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801708:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80170b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801712:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801719:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80171a:	eb 05                	jmp    801721 <strtol+0x29>
		s++;
  80171c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801721:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801725:	0f b6 00             	movzbl (%rax),%eax
  801728:	3c 20                	cmp    $0x20,%al
  80172a:	74 f0                	je     80171c <strtol+0x24>
  80172c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801730:	0f b6 00             	movzbl (%rax),%eax
  801733:	3c 09                	cmp    $0x9,%al
  801735:	74 e5                	je     80171c <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801737:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173b:	0f b6 00             	movzbl (%rax),%eax
  80173e:	3c 2b                	cmp    $0x2b,%al
  801740:	75 07                	jne    801749 <strtol+0x51>
		s++;
  801742:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801747:	eb 17                	jmp    801760 <strtol+0x68>
	else if (*s == '-')
  801749:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174d:	0f b6 00             	movzbl (%rax),%eax
  801750:	3c 2d                	cmp    $0x2d,%al
  801752:	75 0c                	jne    801760 <strtol+0x68>
		s++, neg = 1;
  801754:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801759:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801760:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801764:	74 06                	je     80176c <strtol+0x74>
  801766:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80176a:	75 28                	jne    801794 <strtol+0x9c>
  80176c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801770:	0f b6 00             	movzbl (%rax),%eax
  801773:	3c 30                	cmp    $0x30,%al
  801775:	75 1d                	jne    801794 <strtol+0x9c>
  801777:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177b:	48 83 c0 01          	add    $0x1,%rax
  80177f:	0f b6 00             	movzbl (%rax),%eax
  801782:	3c 78                	cmp    $0x78,%al
  801784:	75 0e                	jne    801794 <strtol+0x9c>
		s += 2, base = 16;
  801786:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80178b:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801792:	eb 2c                	jmp    8017c0 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801794:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801798:	75 19                	jne    8017b3 <strtol+0xbb>
  80179a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179e:	0f b6 00             	movzbl (%rax),%eax
  8017a1:	3c 30                	cmp    $0x30,%al
  8017a3:	75 0e                	jne    8017b3 <strtol+0xbb>
		s++, base = 8;
  8017a5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017aa:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8017b1:	eb 0d                	jmp    8017c0 <strtol+0xc8>
	else if (base == 0)
  8017b3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017b7:	75 07                	jne    8017c0 <strtol+0xc8>
		base = 10;
  8017b9:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c4:	0f b6 00             	movzbl (%rax),%eax
  8017c7:	3c 2f                	cmp    $0x2f,%al
  8017c9:	7e 1d                	jle    8017e8 <strtol+0xf0>
  8017cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cf:	0f b6 00             	movzbl (%rax),%eax
  8017d2:	3c 39                	cmp    $0x39,%al
  8017d4:	7f 12                	jg     8017e8 <strtol+0xf0>
			dig = *s - '0';
  8017d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017da:	0f b6 00             	movzbl (%rax),%eax
  8017dd:	0f be c0             	movsbl %al,%eax
  8017e0:	83 e8 30             	sub    $0x30,%eax
  8017e3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017e6:	eb 4e                	jmp    801836 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8017e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ec:	0f b6 00             	movzbl (%rax),%eax
  8017ef:	3c 60                	cmp    $0x60,%al
  8017f1:	7e 1d                	jle    801810 <strtol+0x118>
  8017f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f7:	0f b6 00             	movzbl (%rax),%eax
  8017fa:	3c 7a                	cmp    $0x7a,%al
  8017fc:	7f 12                	jg     801810 <strtol+0x118>
			dig = *s - 'a' + 10;
  8017fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801802:	0f b6 00             	movzbl (%rax),%eax
  801805:	0f be c0             	movsbl %al,%eax
  801808:	83 e8 57             	sub    $0x57,%eax
  80180b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80180e:	eb 26                	jmp    801836 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801810:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801814:	0f b6 00             	movzbl (%rax),%eax
  801817:	3c 40                	cmp    $0x40,%al
  801819:	7e 48                	jle    801863 <strtol+0x16b>
  80181b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181f:	0f b6 00             	movzbl (%rax),%eax
  801822:	3c 5a                	cmp    $0x5a,%al
  801824:	7f 3d                	jg     801863 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801826:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182a:	0f b6 00             	movzbl (%rax),%eax
  80182d:	0f be c0             	movsbl %al,%eax
  801830:	83 e8 37             	sub    $0x37,%eax
  801833:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801836:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801839:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80183c:	7c 02                	jl     801840 <strtol+0x148>
			break;
  80183e:	eb 23                	jmp    801863 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801840:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801845:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801848:	48 98                	cltq   
  80184a:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80184f:	48 89 c2             	mov    %rax,%rdx
  801852:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801855:	48 98                	cltq   
  801857:	48 01 d0             	add    %rdx,%rax
  80185a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80185e:	e9 5d ff ff ff       	jmpq   8017c0 <strtol+0xc8>

	if (endptr)
  801863:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801868:	74 0b                	je     801875 <strtol+0x17d>
		*endptr = (char *) s;
  80186a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80186e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801872:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801875:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801879:	74 09                	je     801884 <strtol+0x18c>
  80187b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80187f:	48 f7 d8             	neg    %rax
  801882:	eb 04                	jmp    801888 <strtol+0x190>
  801884:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801888:	c9                   	leaveq 
  801889:	c3                   	retq   

000000000080188a <strstr>:

char * strstr(const char *in, const char *str)
{
  80188a:	55                   	push   %rbp
  80188b:	48 89 e5             	mov    %rsp,%rbp
  80188e:	48 83 ec 30          	sub    $0x30,%rsp
  801892:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801896:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80189a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80189e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018a2:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018a6:	0f b6 00             	movzbl (%rax),%eax
  8018a9:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8018ac:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8018b0:	75 06                	jne    8018b8 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8018b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b6:	eb 6b                	jmp    801923 <strstr+0x99>

	len = strlen(str);
  8018b8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018bc:	48 89 c7             	mov    %rax,%rdi
  8018bf:	48 b8 60 11 80 00 00 	movabs $0x801160,%rax
  8018c6:	00 00 00 
  8018c9:	ff d0                	callq  *%rax
  8018cb:	48 98                	cltq   
  8018cd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8018d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018d9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8018dd:	0f b6 00             	movzbl (%rax),%eax
  8018e0:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8018e3:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8018e7:	75 07                	jne    8018f0 <strstr+0x66>
				return (char *) 0;
  8018e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ee:	eb 33                	jmp    801923 <strstr+0x99>
		} while (sc != c);
  8018f0:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8018f4:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8018f7:	75 d8                	jne    8018d1 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8018f9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018fd:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801901:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801905:	48 89 ce             	mov    %rcx,%rsi
  801908:	48 89 c7             	mov    %rax,%rdi
  80190b:	48 b8 81 13 80 00 00 	movabs $0x801381,%rax
  801912:	00 00 00 
  801915:	ff d0                	callq  *%rax
  801917:	85 c0                	test   %eax,%eax
  801919:	75 b6                	jne    8018d1 <strstr+0x47>

	return (char *) (in - 1);
  80191b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191f:	48 83 e8 01          	sub    $0x1,%rax
}
  801923:	c9                   	leaveq 
  801924:	c3                   	retq   

0000000000801925 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801925:	55                   	push   %rbp
  801926:	48 89 e5             	mov    %rsp,%rbp
  801929:	53                   	push   %rbx
  80192a:	48 83 ec 48          	sub    $0x48,%rsp
  80192e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801931:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801934:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801938:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80193c:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801940:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  801944:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801947:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80194b:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80194f:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801953:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801957:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80195b:	4c 89 c3             	mov    %r8,%rbx
  80195e:	cd 30                	int    $0x30
  801960:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  801964:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801968:	74 3e                	je     8019a8 <syscall+0x83>
  80196a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80196f:	7e 37                	jle    8019a8 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801971:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801975:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801978:	49 89 d0             	mov    %rdx,%r8
  80197b:	89 c1                	mov    %eax,%ecx
  80197d:	48 ba 08 44 80 00 00 	movabs $0x804408,%rdx
  801984:	00 00 00 
  801987:	be 4a 00 00 00       	mov    $0x4a,%esi
  80198c:	48 bf 25 44 80 00 00 	movabs $0x804425,%rdi
  801993:	00 00 00 
  801996:	b8 00 00 00 00       	mov    $0x0,%eax
  80199b:	49 b9 de 03 80 00 00 	movabs $0x8003de,%r9
  8019a2:	00 00 00 
  8019a5:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  8019a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019ac:	48 83 c4 48          	add    $0x48,%rsp
  8019b0:	5b                   	pop    %rbx
  8019b1:	5d                   	pop    %rbp
  8019b2:	c3                   	retq   

00000000008019b3 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8019b3:	55                   	push   %rbp
  8019b4:	48 89 e5             	mov    %rsp,%rbp
  8019b7:	48 83 ec 20          	sub    $0x20,%rsp
  8019bb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019bf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8019c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019c7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019cb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019d2:	00 
  8019d3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019d9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019df:	48 89 d1             	mov    %rdx,%rcx
  8019e2:	48 89 c2             	mov    %rax,%rdx
  8019e5:	be 00 00 00 00       	mov    $0x0,%esi
  8019ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8019ef:	48 b8 25 19 80 00 00 	movabs $0x801925,%rax
  8019f6:	00 00 00 
  8019f9:	ff d0                	callq  *%rax
}
  8019fb:	c9                   	leaveq 
  8019fc:	c3                   	retq   

00000000008019fd <sys_cgetc>:

int
sys_cgetc(void)
{
  8019fd:	55                   	push   %rbp
  8019fe:	48 89 e5             	mov    %rsp,%rbp
  801a01:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a05:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a0c:	00 
  801a0d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a13:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a19:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a1e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a23:	be 00 00 00 00       	mov    $0x0,%esi
  801a28:	bf 01 00 00 00       	mov    $0x1,%edi
  801a2d:	48 b8 25 19 80 00 00 	movabs $0x801925,%rax
  801a34:	00 00 00 
  801a37:	ff d0                	callq  *%rax
}
  801a39:	c9                   	leaveq 
  801a3a:	c3                   	retq   

0000000000801a3b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a3b:	55                   	push   %rbp
  801a3c:	48 89 e5             	mov    %rsp,%rbp
  801a3f:	48 83 ec 10          	sub    $0x10,%rsp
  801a43:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a49:	48 98                	cltq   
  801a4b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a52:	00 
  801a53:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a59:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a5f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a64:	48 89 c2             	mov    %rax,%rdx
  801a67:	be 01 00 00 00       	mov    $0x1,%esi
  801a6c:	bf 03 00 00 00       	mov    $0x3,%edi
  801a71:	48 b8 25 19 80 00 00 	movabs $0x801925,%rax
  801a78:	00 00 00 
  801a7b:	ff d0                	callq  *%rax
}
  801a7d:	c9                   	leaveq 
  801a7e:	c3                   	retq   

0000000000801a7f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801a7f:	55                   	push   %rbp
  801a80:	48 89 e5             	mov    %rsp,%rbp
  801a83:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801a87:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a8e:	00 
  801a8f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a95:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a9b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aa0:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa5:	be 00 00 00 00       	mov    $0x0,%esi
  801aaa:	bf 02 00 00 00       	mov    $0x2,%edi
  801aaf:	48 b8 25 19 80 00 00 	movabs $0x801925,%rax
  801ab6:	00 00 00 
  801ab9:	ff d0                	callq  *%rax
}
  801abb:	c9                   	leaveq 
  801abc:	c3                   	retq   

0000000000801abd <sys_yield>:

void
sys_yield(void)
{
  801abd:	55                   	push   %rbp
  801abe:	48 89 e5             	mov    %rsp,%rbp
  801ac1:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801ac5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801acc:	00 
  801acd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ad9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ade:	ba 00 00 00 00       	mov    $0x0,%edx
  801ae3:	be 00 00 00 00       	mov    $0x0,%esi
  801ae8:	bf 0b 00 00 00       	mov    $0xb,%edi
  801aed:	48 b8 25 19 80 00 00 	movabs $0x801925,%rax
  801af4:	00 00 00 
  801af7:	ff d0                	callq  *%rax
}
  801af9:	c9                   	leaveq 
  801afa:	c3                   	retq   

0000000000801afb <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801afb:	55                   	push   %rbp
  801afc:	48 89 e5             	mov    %rsp,%rbp
  801aff:	48 83 ec 20          	sub    $0x20,%rsp
  801b03:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b06:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b0a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b0d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b10:	48 63 c8             	movslq %eax,%rcx
  801b13:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b1a:	48 98                	cltq   
  801b1c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b23:	00 
  801b24:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b2a:	49 89 c8             	mov    %rcx,%r8
  801b2d:	48 89 d1             	mov    %rdx,%rcx
  801b30:	48 89 c2             	mov    %rax,%rdx
  801b33:	be 01 00 00 00       	mov    $0x1,%esi
  801b38:	bf 04 00 00 00       	mov    $0x4,%edi
  801b3d:	48 b8 25 19 80 00 00 	movabs $0x801925,%rax
  801b44:	00 00 00 
  801b47:	ff d0                	callq  *%rax
}
  801b49:	c9                   	leaveq 
  801b4a:	c3                   	retq   

0000000000801b4b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b4b:	55                   	push   %rbp
  801b4c:	48 89 e5             	mov    %rsp,%rbp
  801b4f:	48 83 ec 30          	sub    $0x30,%rsp
  801b53:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b56:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b5a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b5d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b61:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b65:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b68:	48 63 c8             	movslq %eax,%rcx
  801b6b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b6f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b72:	48 63 f0             	movslq %eax,%rsi
  801b75:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b7c:	48 98                	cltq   
  801b7e:	48 89 0c 24          	mov    %rcx,(%rsp)
  801b82:	49 89 f9             	mov    %rdi,%r9
  801b85:	49 89 f0             	mov    %rsi,%r8
  801b88:	48 89 d1             	mov    %rdx,%rcx
  801b8b:	48 89 c2             	mov    %rax,%rdx
  801b8e:	be 01 00 00 00       	mov    $0x1,%esi
  801b93:	bf 05 00 00 00       	mov    $0x5,%edi
  801b98:	48 b8 25 19 80 00 00 	movabs $0x801925,%rax
  801b9f:	00 00 00 
  801ba2:	ff d0                	callq  *%rax
}
  801ba4:	c9                   	leaveq 
  801ba5:	c3                   	retq   

0000000000801ba6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801ba6:	55                   	push   %rbp
  801ba7:	48 89 e5             	mov    %rsp,%rbp
  801baa:	48 83 ec 20          	sub    $0x20,%rsp
  801bae:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bb1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801bb5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bbc:	48 98                	cltq   
  801bbe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bc5:	00 
  801bc6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bcc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bd2:	48 89 d1             	mov    %rdx,%rcx
  801bd5:	48 89 c2             	mov    %rax,%rdx
  801bd8:	be 01 00 00 00       	mov    $0x1,%esi
  801bdd:	bf 06 00 00 00       	mov    $0x6,%edi
  801be2:	48 b8 25 19 80 00 00 	movabs $0x801925,%rax
  801be9:	00 00 00 
  801bec:	ff d0                	callq  *%rax
}
  801bee:	c9                   	leaveq 
  801bef:	c3                   	retq   

0000000000801bf0 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801bf0:	55                   	push   %rbp
  801bf1:	48 89 e5             	mov    %rsp,%rbp
  801bf4:	48 83 ec 10          	sub    $0x10,%rsp
  801bf8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bfb:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801bfe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c01:	48 63 d0             	movslq %eax,%rdx
  801c04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c07:	48 98                	cltq   
  801c09:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c10:	00 
  801c11:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c17:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c1d:	48 89 d1             	mov    %rdx,%rcx
  801c20:	48 89 c2             	mov    %rax,%rdx
  801c23:	be 01 00 00 00       	mov    $0x1,%esi
  801c28:	bf 08 00 00 00       	mov    $0x8,%edi
  801c2d:	48 b8 25 19 80 00 00 	movabs $0x801925,%rax
  801c34:	00 00 00 
  801c37:	ff d0                	callq  *%rax
}
  801c39:	c9                   	leaveq 
  801c3a:	c3                   	retq   

0000000000801c3b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c3b:	55                   	push   %rbp
  801c3c:	48 89 e5             	mov    %rsp,%rbp
  801c3f:	48 83 ec 20          	sub    $0x20,%rsp
  801c43:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c46:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c4a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c51:	48 98                	cltq   
  801c53:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c5a:	00 
  801c5b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c61:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c67:	48 89 d1             	mov    %rdx,%rcx
  801c6a:	48 89 c2             	mov    %rax,%rdx
  801c6d:	be 01 00 00 00       	mov    $0x1,%esi
  801c72:	bf 09 00 00 00       	mov    $0x9,%edi
  801c77:	48 b8 25 19 80 00 00 	movabs $0x801925,%rax
  801c7e:	00 00 00 
  801c81:	ff d0                	callq  *%rax
}
  801c83:	c9                   	leaveq 
  801c84:	c3                   	retq   

0000000000801c85 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801c85:	55                   	push   %rbp
  801c86:	48 89 e5             	mov    %rsp,%rbp
  801c89:	48 83 ec 20          	sub    $0x20,%rsp
  801c8d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c90:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c94:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c9b:	48 98                	cltq   
  801c9d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ca4:	00 
  801ca5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cab:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cb1:	48 89 d1             	mov    %rdx,%rcx
  801cb4:	48 89 c2             	mov    %rax,%rdx
  801cb7:	be 01 00 00 00       	mov    $0x1,%esi
  801cbc:	bf 0a 00 00 00       	mov    $0xa,%edi
  801cc1:	48 b8 25 19 80 00 00 	movabs $0x801925,%rax
  801cc8:	00 00 00 
  801ccb:	ff d0                	callq  *%rax
}
  801ccd:	c9                   	leaveq 
  801cce:	c3                   	retq   

0000000000801ccf <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801ccf:	55                   	push   %rbp
  801cd0:	48 89 e5             	mov    %rsp,%rbp
  801cd3:	48 83 ec 20          	sub    $0x20,%rsp
  801cd7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cda:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cde:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801ce2:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801ce5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ce8:	48 63 f0             	movslq %eax,%rsi
  801ceb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801cef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cf2:	48 98                	cltq   
  801cf4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cf8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cff:	00 
  801d00:	49 89 f1             	mov    %rsi,%r9
  801d03:	49 89 c8             	mov    %rcx,%r8
  801d06:	48 89 d1             	mov    %rdx,%rcx
  801d09:	48 89 c2             	mov    %rax,%rdx
  801d0c:	be 00 00 00 00       	mov    $0x0,%esi
  801d11:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d16:	48 b8 25 19 80 00 00 	movabs $0x801925,%rax
  801d1d:	00 00 00 
  801d20:	ff d0                	callq  *%rax
}
  801d22:	c9                   	leaveq 
  801d23:	c3                   	retq   

0000000000801d24 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d24:	55                   	push   %rbp
  801d25:	48 89 e5             	mov    %rsp,%rbp
  801d28:	48 83 ec 10          	sub    $0x10,%rsp
  801d2c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d34:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d3b:	00 
  801d3c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d42:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d48:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d4d:	48 89 c2             	mov    %rax,%rdx
  801d50:	be 01 00 00 00       	mov    $0x1,%esi
  801d55:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d5a:	48 b8 25 19 80 00 00 	movabs $0x801925,%rax
  801d61:	00 00 00 
  801d64:	ff d0                	callq  *%rax
}
  801d66:	c9                   	leaveq 
  801d67:	c3                   	retq   

0000000000801d68 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801d68:	55                   	push   %rbp
  801d69:	48 89 e5             	mov    %rsp,%rbp
  801d6c:	53                   	push   %rbx
  801d6d:	48 83 ec 48          	sub    $0x48,%rsp
  801d71:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801d75:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801d79:	48 8b 00             	mov    (%rax),%rax
  801d7c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	uint32_t err = utf->utf_err;
  801d80:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801d84:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d88:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	pte_t pte = uvpt[VPN(addr)];
  801d8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d8f:	48 c1 e8 0c          	shr    $0xc,%rax
  801d93:	48 89 c2             	mov    %rax,%rdx
  801d96:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d9d:	01 00 00 
  801da0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801da4:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	envid_t pid = sys_getenvid();
  801da8:	48 b8 7f 1a 80 00 00 	movabs $0x801a7f,%rax
  801daf:	00 00 00 
  801db2:	ff d0                	callq  *%rax
  801db4:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	void* va = ROUNDDOWN(addr, PGSIZE);
  801db7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dbb:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  801dbf:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801dc3:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801dc9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	if((err & FEC_WR) && (pte & PTE_COW)){
  801dcd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801dd0:	83 e0 02             	and    $0x2,%eax
  801dd3:	85 c0                	test   %eax,%eax
  801dd5:	0f 84 8d 00 00 00    	je     801e68 <pgfault+0x100>
  801ddb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ddf:	25 00 08 00 00       	and    $0x800,%eax
  801de4:	48 85 c0             	test   %rax,%rax
  801de7:	74 7f                	je     801e68 <pgfault+0x100>
		if(!sys_page_alloc(pid, (void*)PFTEMP, PTE_P | PTE_W | PTE_U)){
  801de9:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801dec:	ba 07 00 00 00       	mov    $0x7,%edx
  801df1:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801df6:	89 c7                	mov    %eax,%edi
  801df8:	48 b8 fb 1a 80 00 00 	movabs $0x801afb,%rax
  801dff:	00 00 00 
  801e02:	ff d0                	callq  *%rax
  801e04:	85 c0                	test   %eax,%eax
  801e06:	75 60                	jne    801e68 <pgfault+0x100>
			memmove(PFTEMP, va, PGSIZE);
  801e08:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801e0c:	ba 00 10 00 00       	mov    $0x1000,%edx
  801e11:	48 89 c6             	mov    %rax,%rsi
  801e14:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801e19:	48 b8 f0 14 80 00 00 	movabs $0x8014f0,%rax
  801e20:	00 00 00 
  801e23:	ff d0                	callq  *%rax
			if(!(sys_page_map(pid, (void*)PFTEMP, pid, va, PTE_P | PTE_W | PTE_U) | 
  801e25:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  801e29:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  801e2c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801e2f:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801e35:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e3a:	89 c7                	mov    %eax,%edi
  801e3c:	48 b8 4b 1b 80 00 00 	movabs $0x801b4b,%rax
  801e43:	00 00 00 
  801e46:	ff d0                	callq  *%rax
  801e48:	89 c3                	mov    %eax,%ebx
					 sys_page_unmap(pid, (void*) PFTEMP)))
  801e4a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801e4d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e52:	89 c7                	mov    %eax,%edi
  801e54:	48 b8 a6 1b 80 00 00 	movabs $0x801ba6,%rax
  801e5b:	00 00 00 
  801e5e:	ff d0                	callq  *%rax
	envid_t pid = sys_getenvid();
	void* va = ROUNDDOWN(addr, PGSIZE);
	if((err & FEC_WR) && (pte & PTE_COW)){
		if(!sys_page_alloc(pid, (void*)PFTEMP, PTE_P | PTE_W | PTE_U)){
			memmove(PFTEMP, va, PGSIZE);
			if(!(sys_page_map(pid, (void*)PFTEMP, pid, va, PTE_P | PTE_W | PTE_U) | 
  801e60:	09 d8                	or     %ebx,%eax
  801e62:	85 c0                	test   %eax,%eax
  801e64:	75 02                	jne    801e68 <pgfault+0x100>
					 sys_page_unmap(pid, (void*) PFTEMP)))
					return;
  801e66:	eb 2a                	jmp    801e92 <pgfault+0x12a>
		}
	}
	panic("Page fault handler failure\n");
  801e68:	48 ba 33 44 80 00 00 	movabs $0x804433,%rdx
  801e6f:	00 00 00 
  801e72:	be 26 00 00 00       	mov    $0x26,%esi
  801e77:	48 bf 4f 44 80 00 00 	movabs $0x80444f,%rdi
  801e7e:	00 00 00 
  801e81:	b8 00 00 00 00       	mov    $0x0,%eax
  801e86:	48 b9 de 03 80 00 00 	movabs $0x8003de,%rcx
  801e8d:	00 00 00 
  801e90:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	//panic("pgfault not implemented");
}
  801e92:	48 83 c4 48          	add    $0x48,%rsp
  801e96:	5b                   	pop    %rbx
  801e97:	5d                   	pop    %rbp
  801e98:	c3                   	retq   

0000000000801e99 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801e99:	55                   	push   %rbp
  801e9a:	48 89 e5             	mov    %rsp,%rbp
  801e9d:	53                   	push   %rbx
  801e9e:	48 83 ec 38          	sub    $0x38,%rsp
  801ea2:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801ea5:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	//struct Env *env;
	pte_t pte = uvpt[pn];
  801ea8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801eaf:	01 00 00 
  801eb2:	8b 55 c8             	mov    -0x38(%rbp),%edx
  801eb5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eb9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int perm = pte & PTE_SYSCALL;
  801ebd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ec1:	25 07 0e 00 00       	and    $0xe07,%eax
  801ec6:	89 45 dc             	mov    %eax,-0x24(%rbp)
	void *va = (void*)((uintptr_t)pn * PGSIZE);
  801ec9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801ecc:	48 c1 e0 0c          	shl    $0xc,%rax
  801ed0:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	if(perm & PTE_SHARE){
  801ed4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801ed7:	25 00 04 00 00       	and    $0x400,%eax
  801edc:	85 c0                	test   %eax,%eax
  801ede:	74 30                	je     801f10 <duppage+0x77>
		r = sys_page_map(0, va, envid, va, perm);
  801ee0:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801ee3:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801ee7:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801eea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801eee:	41 89 f0             	mov    %esi,%r8d
  801ef1:	48 89 c6             	mov    %rax,%rsi
  801ef4:	bf 00 00 00 00       	mov    $0x0,%edi
  801ef9:	48 b8 4b 1b 80 00 00 	movabs $0x801b4b,%rax
  801f00:	00 00 00 
  801f03:	ff d0                	callq  *%rax
  801f05:	89 45 ec             	mov    %eax,-0x14(%rbp)
		return r;
  801f08:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f0b:	e9 a4 00 00 00       	jmpq   801fb4 <duppage+0x11b>
	}
	//envid_t pid = sys_getenvid();
	if((perm & PTE_W) || (perm & PTE_COW)){
  801f10:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801f13:	83 e0 02             	and    $0x2,%eax
  801f16:	85 c0                	test   %eax,%eax
  801f18:	75 0c                	jne    801f26 <duppage+0x8d>
  801f1a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801f1d:	25 00 08 00 00       	and    $0x800,%eax
  801f22:	85 c0                	test   %eax,%eax
  801f24:	74 63                	je     801f89 <duppage+0xf0>
		perm &= ~PTE_W;
  801f26:	83 65 dc fd          	andl   $0xfffffffd,-0x24(%rbp)
		perm |= PTE_COW;
  801f2a:	81 4d dc 00 08 00 00 	orl    $0x800,-0x24(%rbp)
		r = sys_page_map(0, va, envid, va, perm) | sys_page_map(0, va, 0, va, perm);
  801f31:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801f34:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801f38:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801f3b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f3f:	41 89 f0             	mov    %esi,%r8d
  801f42:	48 89 c6             	mov    %rax,%rsi
  801f45:	bf 00 00 00 00       	mov    $0x0,%edi
  801f4a:	48 b8 4b 1b 80 00 00 	movabs $0x801b4b,%rax
  801f51:	00 00 00 
  801f54:	ff d0                	callq  *%rax
  801f56:	89 c3                	mov    %eax,%ebx
  801f58:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  801f5b:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801f5f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f63:	41 89 c8             	mov    %ecx,%r8d
  801f66:	48 89 d1             	mov    %rdx,%rcx
  801f69:	ba 00 00 00 00       	mov    $0x0,%edx
  801f6e:	48 89 c6             	mov    %rax,%rsi
  801f71:	bf 00 00 00 00       	mov    $0x0,%edi
  801f76:	48 b8 4b 1b 80 00 00 	movabs $0x801b4b,%rax
  801f7d:	00 00 00 
  801f80:	ff d0                	callq  *%rax
  801f82:	09 d8                	or     %ebx,%eax
  801f84:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f87:	eb 28                	jmp    801fb1 <duppage+0x118>
	}
	else{
		r = sys_page_map(0, va, envid, va, perm);
  801f89:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801f8c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801f90:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801f93:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f97:	41 89 f0             	mov    %esi,%r8d
  801f9a:	48 89 c6             	mov    %rax,%rsi
  801f9d:	bf 00 00 00 00       	mov    $0x0,%edi
  801fa2:	48 b8 4b 1b 80 00 00 	movabs $0x801b4b,%rax
  801fa9:	00 00 00 
  801fac:	ff d0                	callq  *%rax
  801fae:	89 45 ec             	mov    %eax,-0x14(%rbp)
	}

	// LAB 4: Your code here.
	//panic("duppage not implemented");
	//if(r != 0) panic("Duplicating page failed: %e\n", r);
	return r;
  801fb1:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  801fb4:	48 83 c4 38          	add    $0x38,%rsp
  801fb8:	5b                   	pop    %rbx
  801fb9:	5d                   	pop    %rbp
  801fba:	c3                   	retq   

0000000000801fbb <fork>:
//   so you must allocate a new page for the child's user exception stack.
//

envid_t
fork(void)
{
  801fbb:	55                   	push   %rbp
  801fbc:	48 89 e5             	mov    %rsp,%rbp
  801fbf:	53                   	push   %rbx
  801fc0:	48 83 ec 58          	sub    $0x58,%rsp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  801fc4:	48 bf 68 1d 80 00 00 	movabs $0x801d68,%rdi
  801fcb:	00 00 00 
  801fce:	48 b8 80 3a 80 00 00 	movabs $0x803a80,%rax
  801fd5:	00 00 00 
  801fd8:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801fda:	b8 07 00 00 00       	mov    $0x7,%eax
  801fdf:	cd 30                	int    $0x30
  801fe1:	89 45 a4             	mov    %eax,-0x5c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801fe4:	8b 45 a4             	mov    -0x5c(%rbp),%eax
	envid_t cid = sys_exofork();
  801fe7:	89 45 cc             	mov    %eax,-0x34(%rbp)
	if(cid < 0) panic("fork failed: %e\n", cid);
  801fea:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801fee:	79 30                	jns    802020 <fork+0x65>
  801ff0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801ff3:	89 c1                	mov    %eax,%ecx
  801ff5:	48 ba 5a 44 80 00 00 	movabs $0x80445a,%rdx
  801ffc:	00 00 00 
  801fff:	be 72 00 00 00       	mov    $0x72,%esi
  802004:	48 bf 4f 44 80 00 00 	movabs $0x80444f,%rdi
  80200b:	00 00 00 
  80200e:	b8 00 00 00 00       	mov    $0x0,%eax
  802013:	49 b8 de 03 80 00 00 	movabs $0x8003de,%r8
  80201a:	00 00 00 
  80201d:	41 ff d0             	callq  *%r8
	if(cid == 0){
  802020:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802024:	75 46                	jne    80206c <fork+0xb1>
		thisenv = &envs[ENVX(sys_getenvid())];
  802026:	48 b8 7f 1a 80 00 00 	movabs $0x801a7f,%rax
  80202d:	00 00 00 
  802030:	ff d0                	callq  *%rax
  802032:	25 ff 03 00 00       	and    $0x3ff,%eax
  802037:	48 63 d0             	movslq %eax,%rdx
  80203a:	48 89 d0             	mov    %rdx,%rax
  80203d:	48 c1 e0 03          	shl    $0x3,%rax
  802041:	48 01 d0             	add    %rdx,%rax
  802044:	48 c1 e0 05          	shl    $0x5,%rax
  802048:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80204f:	00 00 00 
  802052:	48 01 c2             	add    %rax,%rdx
  802055:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80205c:	00 00 00 
  80205f:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802062:	b8 00 00 00 00       	mov    $0x0,%eax
  802067:	e9 12 02 00 00       	jmpq   80227e <fork+0x2c3>
	}
	int result;
	if((result = sys_page_alloc(cid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80206c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80206f:	ba 07 00 00 00       	mov    $0x7,%edx
  802074:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802079:	89 c7                	mov    %eax,%edi
  80207b:	48 b8 fb 1a 80 00 00 	movabs $0x801afb,%rax
  802082:	00 00 00 
  802085:	ff d0                	callq  *%rax
  802087:	89 45 c8             	mov    %eax,-0x38(%rbp)
  80208a:	83 7d c8 00          	cmpl   $0x0,-0x38(%rbp)
  80208e:	79 30                	jns    8020c0 <fork+0x105>
		panic("fork failed: %e\n", result);
  802090:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802093:	89 c1                	mov    %eax,%ecx
  802095:	48 ba 5a 44 80 00 00 	movabs $0x80445a,%rdx
  80209c:	00 00 00 
  80209f:	be 79 00 00 00       	mov    $0x79,%esi
  8020a4:	48 bf 4f 44 80 00 00 	movabs $0x80444f,%rdi
  8020ab:	00 00 00 
  8020ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b3:	49 b8 de 03 80 00 00 	movabs $0x8003de,%r8
  8020ba:	00 00 00 
  8020bd:	41 ff d0             	callq  *%r8
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  8020c0:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8020c7:	00 
  8020c8:	e9 40 01 00 00       	jmpq   80220d <fork+0x252>
		if(uvpml4e[pml4e] & PTE_P){
  8020cd:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8020d4:	01 00 00 
  8020d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8020db:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020df:	83 e0 01             	and    $0x1,%eax
  8020e2:	48 85 c0             	test   %rax,%rax
  8020e5:	0f 84 1d 01 00 00    	je     802208 <fork+0x24d>
			base_pml4e = pml4e * NPDPENTRIES;
  8020eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020ef:	48 c1 e0 09          	shl    $0x9,%rax
  8020f3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  8020f7:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  8020fe:	00 
  8020ff:	e9 f6 00 00 00       	jmpq   8021fa <fork+0x23f>
				if(uvpde[base_pml4e + pdpe] & PTE_P){
  802104:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802108:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80210c:	48 01 c2             	add    %rax,%rdx
  80210f:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802116:	01 00 00 
  802119:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80211d:	83 e0 01             	and    $0x1,%eax
  802120:	48 85 c0             	test   %rax,%rax
  802123:	0f 84 cc 00 00 00    	je     8021f5 <fork+0x23a>
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
  802129:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80212d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802131:	48 01 d0             	add    %rdx,%rax
  802134:	48 c1 e0 09          	shl    $0x9,%rax
  802138:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
					for(pde = 0; pde < NPDENTRIES; pde++){
  80213c:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  802143:	00 
  802144:	e9 9e 00 00 00       	jmpq   8021e7 <fork+0x22c>
						if(uvpd[base_pdpe + pde] & PTE_P){
  802149:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80214d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802151:	48 01 c2             	add    %rax,%rdx
  802154:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80215b:	01 00 00 
  80215e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802162:	83 e0 01             	and    $0x1,%eax
  802165:	48 85 c0             	test   %rax,%rax
  802168:	74 78                	je     8021e2 <fork+0x227>
							base_pde = (base_pdpe + pde) * NPTENTRIES;
  80216a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80216e:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802172:	48 01 d0             	add    %rdx,%rax
  802175:	48 c1 e0 09          	shl    $0x9,%rax
  802179:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
							for(pte = 0; pte < NPTENTRIES; pte++){
  80217d:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  802184:	00 
  802185:	eb 51                	jmp    8021d8 <fork+0x21d>
								entry = base_pde + pte;
  802187:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80218b:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80218f:	48 01 d0             	add    %rdx,%rax
  802192:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
								if((uvpt[entry] & PTE_P) && (entry != VPN(UXSTACKTOP - PGSIZE))){
  802196:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80219d:	01 00 00 
  8021a0:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8021a4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021a8:	83 e0 01             	and    $0x1,%eax
  8021ab:	48 85 c0             	test   %rax,%rax
  8021ae:	74 23                	je     8021d3 <fork+0x218>
  8021b0:	48 81 7d a8 ff f7 0e 	cmpq   $0xef7ff,-0x58(%rbp)
  8021b7:	00 
  8021b8:	74 19                	je     8021d3 <fork+0x218>
									duppage(cid, entry);
  8021ba:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8021be:	89 c2                	mov    %eax,%edx
  8021c0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8021c3:	89 d6                	mov    %edx,%esi
  8021c5:	89 c7                	mov    %eax,%edi
  8021c7:	48 b8 99 1e 80 00 00 	movabs $0x801e99,%rax
  8021ce:	00 00 00 
  8021d1:	ff d0                	callq  *%rax
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
						if(uvpd[base_pdpe + pde] & PTE_P){
							base_pde = (base_pdpe + pde) * NPTENTRIES;
							for(pte = 0; pte < NPTENTRIES; pte++){
  8021d3:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  8021d8:	48 81 7d d0 ff 01 00 	cmpq   $0x1ff,-0x30(%rbp)
  8021df:	00 
  8021e0:	76 a5                	jbe    802187 <fork+0x1cc>
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
  8021e2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8021e7:	48 81 7d d8 ff 01 00 	cmpq   $0x1ff,-0x28(%rbp)
  8021ee:	00 
  8021ef:	0f 86 54 ff ff ff    	jbe    802149 <fork+0x18e>
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  8021f5:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  8021fa:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  802201:	00 
  802202:	0f 86 fc fe ff ff    	jbe    802104 <fork+0x149>
	int result;
	if((result = sys_page_alloc(cid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		panic("fork failed: %e\n", result);
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  802208:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80220d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802212:	0f 84 b5 fe ff ff    	je     8020cd <fork+0x112>
					}
				}
			}
		}
	}
	if(sys_env_set_pgfault_upcall(cid, _pgfault_upcall) | sys_env_set_status(cid, ENV_RUNNABLE))
  802218:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80221b:	48 be 15 3b 80 00 00 	movabs $0x803b15,%rsi
  802222:	00 00 00 
  802225:	89 c7                	mov    %eax,%edi
  802227:	48 b8 85 1c 80 00 00 	movabs $0x801c85,%rax
  80222e:	00 00 00 
  802231:	ff d0                	callq  *%rax
  802233:	89 c3                	mov    %eax,%ebx
  802235:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802238:	be 02 00 00 00       	mov    $0x2,%esi
  80223d:	89 c7                	mov    %eax,%edi
  80223f:	48 b8 f0 1b 80 00 00 	movabs $0x801bf0,%rax
  802246:	00 00 00 
  802249:	ff d0                	callq  *%rax
  80224b:	09 d8                	or     %ebx,%eax
  80224d:	85 c0                	test   %eax,%eax
  80224f:	74 2a                	je     80227b <fork+0x2c0>
		panic("fork failed\n");
  802251:	48 ba 6b 44 80 00 00 	movabs $0x80446b,%rdx
  802258:	00 00 00 
  80225b:	be 92 00 00 00       	mov    $0x92,%esi
  802260:	48 bf 4f 44 80 00 00 	movabs $0x80444f,%rdi
  802267:	00 00 00 
  80226a:	b8 00 00 00 00       	mov    $0x0,%eax
  80226f:	48 b9 de 03 80 00 00 	movabs $0x8003de,%rcx
  802276:	00 00 00 
  802279:	ff d1                	callq  *%rcx
	return cid;
  80227b:	8b 45 cc             	mov    -0x34(%rbp),%eax
	//panic("fork not implemented");
}
  80227e:	48 83 c4 58          	add    $0x58,%rsp
  802282:	5b                   	pop    %rbx
  802283:	5d                   	pop    %rbp
  802284:	c3                   	retq   

0000000000802285 <sfork>:


// Challenge!
int
sfork(void)
{
  802285:	55                   	push   %rbp
  802286:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802289:	48 ba 78 44 80 00 00 	movabs $0x804478,%rdx
  802290:	00 00 00 
  802293:	be 9c 00 00 00       	mov    $0x9c,%esi
  802298:	48 bf 4f 44 80 00 00 	movabs $0x80444f,%rdi
  80229f:	00 00 00 
  8022a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a7:	48 b9 de 03 80 00 00 	movabs $0x8003de,%rcx
  8022ae:	00 00 00 
  8022b1:	ff d1                	callq  *%rcx

00000000008022b3 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8022b3:	55                   	push   %rbp
  8022b4:	48 89 e5             	mov    %rsp,%rbp
  8022b7:	48 83 ec 08          	sub    $0x8,%rsp
  8022bb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8022bf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8022c3:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8022ca:	ff ff ff 
  8022cd:	48 01 d0             	add    %rdx,%rax
  8022d0:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8022d4:	c9                   	leaveq 
  8022d5:	c3                   	retq   

00000000008022d6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8022d6:	55                   	push   %rbp
  8022d7:	48 89 e5             	mov    %rsp,%rbp
  8022da:	48 83 ec 08          	sub    $0x8,%rsp
  8022de:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8022e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022e6:	48 89 c7             	mov    %rax,%rdi
  8022e9:	48 b8 b3 22 80 00 00 	movabs $0x8022b3,%rax
  8022f0:	00 00 00 
  8022f3:	ff d0                	callq  *%rax
  8022f5:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8022fb:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8022ff:	c9                   	leaveq 
  802300:	c3                   	retq   

0000000000802301 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802301:	55                   	push   %rbp
  802302:	48 89 e5             	mov    %rsp,%rbp
  802305:	48 83 ec 18          	sub    $0x18,%rsp
  802309:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80230d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802314:	eb 6b                	jmp    802381 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802316:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802319:	48 98                	cltq   
  80231b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802321:	48 c1 e0 0c          	shl    $0xc,%rax
  802325:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802329:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80232d:	48 c1 e8 15          	shr    $0x15,%rax
  802331:	48 89 c2             	mov    %rax,%rdx
  802334:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80233b:	01 00 00 
  80233e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802342:	83 e0 01             	and    $0x1,%eax
  802345:	48 85 c0             	test   %rax,%rax
  802348:	74 21                	je     80236b <fd_alloc+0x6a>
  80234a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80234e:	48 c1 e8 0c          	shr    $0xc,%rax
  802352:	48 89 c2             	mov    %rax,%rdx
  802355:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80235c:	01 00 00 
  80235f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802363:	83 e0 01             	and    $0x1,%eax
  802366:	48 85 c0             	test   %rax,%rax
  802369:	75 12                	jne    80237d <fd_alloc+0x7c>
			*fd_store = fd;
  80236b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80236f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802373:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802376:	b8 00 00 00 00       	mov    $0x0,%eax
  80237b:	eb 1a                	jmp    802397 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80237d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802381:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802385:	7e 8f                	jle    802316 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802387:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80238b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802392:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802397:	c9                   	leaveq 
  802398:	c3                   	retq   

0000000000802399 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802399:	55                   	push   %rbp
  80239a:	48 89 e5             	mov    %rsp,%rbp
  80239d:	48 83 ec 20          	sub    $0x20,%rsp
  8023a1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023a4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8023a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8023ac:	78 06                	js     8023b4 <fd_lookup+0x1b>
  8023ae:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8023b2:	7e 07                	jle    8023bb <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8023b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023b9:	eb 6c                	jmp    802427 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8023bb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023be:	48 98                	cltq   
  8023c0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8023c6:	48 c1 e0 0c          	shl    $0xc,%rax
  8023ca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8023ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023d2:	48 c1 e8 15          	shr    $0x15,%rax
  8023d6:	48 89 c2             	mov    %rax,%rdx
  8023d9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8023e0:	01 00 00 
  8023e3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023e7:	83 e0 01             	and    $0x1,%eax
  8023ea:	48 85 c0             	test   %rax,%rax
  8023ed:	74 21                	je     802410 <fd_lookup+0x77>
  8023ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023f3:	48 c1 e8 0c          	shr    $0xc,%rax
  8023f7:	48 89 c2             	mov    %rax,%rdx
  8023fa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802401:	01 00 00 
  802404:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802408:	83 e0 01             	and    $0x1,%eax
  80240b:	48 85 c0             	test   %rax,%rax
  80240e:	75 07                	jne    802417 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802410:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802415:	eb 10                	jmp    802427 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802417:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80241b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80241f:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802422:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802427:	c9                   	leaveq 
  802428:	c3                   	retq   

0000000000802429 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802429:	55                   	push   %rbp
  80242a:	48 89 e5             	mov    %rsp,%rbp
  80242d:	48 83 ec 30          	sub    $0x30,%rsp
  802431:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802435:	89 f0                	mov    %esi,%eax
  802437:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80243a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80243e:	48 89 c7             	mov    %rax,%rdi
  802441:	48 b8 b3 22 80 00 00 	movabs $0x8022b3,%rax
  802448:	00 00 00 
  80244b:	ff d0                	callq  *%rax
  80244d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802451:	48 89 d6             	mov    %rdx,%rsi
  802454:	89 c7                	mov    %eax,%edi
  802456:	48 b8 99 23 80 00 00 	movabs $0x802399,%rax
  80245d:	00 00 00 
  802460:	ff d0                	callq  *%rax
  802462:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802465:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802469:	78 0a                	js     802475 <fd_close+0x4c>
	    || fd != fd2)
  80246b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80246f:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802473:	74 12                	je     802487 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802475:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802479:	74 05                	je     802480 <fd_close+0x57>
  80247b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80247e:	eb 05                	jmp    802485 <fd_close+0x5c>
  802480:	b8 00 00 00 00       	mov    $0x0,%eax
  802485:	eb 69                	jmp    8024f0 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802487:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80248b:	8b 00                	mov    (%rax),%eax
  80248d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802491:	48 89 d6             	mov    %rdx,%rsi
  802494:	89 c7                	mov    %eax,%edi
  802496:	48 b8 f2 24 80 00 00 	movabs $0x8024f2,%rax
  80249d:	00 00 00 
  8024a0:	ff d0                	callq  *%rax
  8024a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024a9:	78 2a                	js     8024d5 <fd_close+0xac>
		if (dev->dev_close)
  8024ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024af:	48 8b 40 20          	mov    0x20(%rax),%rax
  8024b3:	48 85 c0             	test   %rax,%rax
  8024b6:	74 16                	je     8024ce <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8024b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024bc:	48 8b 40 20          	mov    0x20(%rax),%rax
  8024c0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8024c4:	48 89 d7             	mov    %rdx,%rdi
  8024c7:	ff d0                	callq  *%rax
  8024c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024cc:	eb 07                	jmp    8024d5 <fd_close+0xac>
		else
			r = 0;
  8024ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8024d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024d9:	48 89 c6             	mov    %rax,%rsi
  8024dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8024e1:	48 b8 a6 1b 80 00 00 	movabs $0x801ba6,%rax
  8024e8:	00 00 00 
  8024eb:	ff d0                	callq  *%rax
	return r;
  8024ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8024f0:	c9                   	leaveq 
  8024f1:	c3                   	retq   

00000000008024f2 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8024f2:	55                   	push   %rbp
  8024f3:	48 89 e5             	mov    %rsp,%rbp
  8024f6:	48 83 ec 20          	sub    $0x20,%rsp
  8024fa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024fd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802501:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802508:	eb 41                	jmp    80254b <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80250a:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802511:	00 00 00 
  802514:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802517:	48 63 d2             	movslq %edx,%rdx
  80251a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80251e:	8b 00                	mov    (%rax),%eax
  802520:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802523:	75 22                	jne    802547 <dev_lookup+0x55>
			*dev = devtab[i];
  802525:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80252c:	00 00 00 
  80252f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802532:	48 63 d2             	movslq %edx,%rdx
  802535:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802539:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80253d:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802540:	b8 00 00 00 00       	mov    $0x0,%eax
  802545:	eb 60                	jmp    8025a7 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802547:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80254b:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802552:	00 00 00 
  802555:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802558:	48 63 d2             	movslq %edx,%rdx
  80255b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80255f:	48 85 c0             	test   %rax,%rax
  802562:	75 a6                	jne    80250a <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802564:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80256b:	00 00 00 
  80256e:	48 8b 00             	mov    (%rax),%rax
  802571:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802577:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80257a:	89 c6                	mov    %eax,%esi
  80257c:	48 bf 90 44 80 00 00 	movabs $0x804490,%rdi
  802583:	00 00 00 
  802586:	b8 00 00 00 00       	mov    $0x0,%eax
  80258b:	48 b9 17 06 80 00 00 	movabs $0x800617,%rcx
  802592:	00 00 00 
  802595:	ff d1                	callq  *%rcx
	*dev = 0;
  802597:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80259b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8025a2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8025a7:	c9                   	leaveq 
  8025a8:	c3                   	retq   

00000000008025a9 <close>:

int
close(int fdnum)
{
  8025a9:	55                   	push   %rbp
  8025aa:	48 89 e5             	mov    %rsp,%rbp
  8025ad:	48 83 ec 20          	sub    $0x20,%rsp
  8025b1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025b4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025b8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025bb:	48 89 d6             	mov    %rdx,%rsi
  8025be:	89 c7                	mov    %eax,%edi
  8025c0:	48 b8 99 23 80 00 00 	movabs $0x802399,%rax
  8025c7:	00 00 00 
  8025ca:	ff d0                	callq  *%rax
  8025cc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025d3:	79 05                	jns    8025da <close+0x31>
		return r;
  8025d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025d8:	eb 18                	jmp    8025f2 <close+0x49>
	else
		return fd_close(fd, 1);
  8025da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025de:	be 01 00 00 00       	mov    $0x1,%esi
  8025e3:	48 89 c7             	mov    %rax,%rdi
  8025e6:	48 b8 29 24 80 00 00 	movabs $0x802429,%rax
  8025ed:	00 00 00 
  8025f0:	ff d0                	callq  *%rax
}
  8025f2:	c9                   	leaveq 
  8025f3:	c3                   	retq   

00000000008025f4 <close_all>:

void
close_all(void)
{
  8025f4:	55                   	push   %rbp
  8025f5:	48 89 e5             	mov    %rsp,%rbp
  8025f8:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8025fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802603:	eb 15                	jmp    80261a <close_all+0x26>
		close(i);
  802605:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802608:	89 c7                	mov    %eax,%edi
  80260a:	48 b8 a9 25 80 00 00 	movabs $0x8025a9,%rax
  802611:	00 00 00 
  802614:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802616:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80261a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80261e:	7e e5                	jle    802605 <close_all+0x11>
		close(i);
}
  802620:	c9                   	leaveq 
  802621:	c3                   	retq   

0000000000802622 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802622:	55                   	push   %rbp
  802623:	48 89 e5             	mov    %rsp,%rbp
  802626:	48 83 ec 40          	sub    $0x40,%rsp
  80262a:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80262d:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802630:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802634:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802637:	48 89 d6             	mov    %rdx,%rsi
  80263a:	89 c7                	mov    %eax,%edi
  80263c:	48 b8 99 23 80 00 00 	movabs $0x802399,%rax
  802643:	00 00 00 
  802646:	ff d0                	callq  *%rax
  802648:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80264b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80264f:	79 08                	jns    802659 <dup+0x37>
		return r;
  802651:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802654:	e9 70 01 00 00       	jmpq   8027c9 <dup+0x1a7>
	close(newfdnum);
  802659:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80265c:	89 c7                	mov    %eax,%edi
  80265e:	48 b8 a9 25 80 00 00 	movabs $0x8025a9,%rax
  802665:	00 00 00 
  802668:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80266a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80266d:	48 98                	cltq   
  80266f:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802675:	48 c1 e0 0c          	shl    $0xc,%rax
  802679:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80267d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802681:	48 89 c7             	mov    %rax,%rdi
  802684:	48 b8 d6 22 80 00 00 	movabs $0x8022d6,%rax
  80268b:	00 00 00 
  80268e:	ff d0                	callq  *%rax
  802690:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802694:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802698:	48 89 c7             	mov    %rax,%rdi
  80269b:	48 b8 d6 22 80 00 00 	movabs $0x8022d6,%rax
  8026a2:	00 00 00 
  8026a5:	ff d0                	callq  *%rax
  8026a7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8026ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026af:	48 c1 e8 15          	shr    $0x15,%rax
  8026b3:	48 89 c2             	mov    %rax,%rdx
  8026b6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8026bd:	01 00 00 
  8026c0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026c4:	83 e0 01             	and    $0x1,%eax
  8026c7:	48 85 c0             	test   %rax,%rax
  8026ca:	74 73                	je     80273f <dup+0x11d>
  8026cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026d0:	48 c1 e8 0c          	shr    $0xc,%rax
  8026d4:	48 89 c2             	mov    %rax,%rdx
  8026d7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026de:	01 00 00 
  8026e1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026e5:	83 e0 01             	and    $0x1,%eax
  8026e8:	48 85 c0             	test   %rax,%rax
  8026eb:	74 52                	je     80273f <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8026ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026f1:	48 c1 e8 0c          	shr    $0xc,%rax
  8026f5:	48 89 c2             	mov    %rax,%rdx
  8026f8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026ff:	01 00 00 
  802702:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802706:	25 07 0e 00 00       	and    $0xe07,%eax
  80270b:	89 c1                	mov    %eax,%ecx
  80270d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802711:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802715:	41 89 c8             	mov    %ecx,%r8d
  802718:	48 89 d1             	mov    %rdx,%rcx
  80271b:	ba 00 00 00 00       	mov    $0x0,%edx
  802720:	48 89 c6             	mov    %rax,%rsi
  802723:	bf 00 00 00 00       	mov    $0x0,%edi
  802728:	48 b8 4b 1b 80 00 00 	movabs $0x801b4b,%rax
  80272f:	00 00 00 
  802732:	ff d0                	callq  *%rax
  802734:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802737:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80273b:	79 02                	jns    80273f <dup+0x11d>
			goto err;
  80273d:	eb 57                	jmp    802796 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80273f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802743:	48 c1 e8 0c          	shr    $0xc,%rax
  802747:	48 89 c2             	mov    %rax,%rdx
  80274a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802751:	01 00 00 
  802754:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802758:	25 07 0e 00 00       	and    $0xe07,%eax
  80275d:	89 c1                	mov    %eax,%ecx
  80275f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802763:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802767:	41 89 c8             	mov    %ecx,%r8d
  80276a:	48 89 d1             	mov    %rdx,%rcx
  80276d:	ba 00 00 00 00       	mov    $0x0,%edx
  802772:	48 89 c6             	mov    %rax,%rsi
  802775:	bf 00 00 00 00       	mov    $0x0,%edi
  80277a:	48 b8 4b 1b 80 00 00 	movabs $0x801b4b,%rax
  802781:	00 00 00 
  802784:	ff d0                	callq  *%rax
  802786:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802789:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80278d:	79 02                	jns    802791 <dup+0x16f>
		goto err;
  80278f:	eb 05                	jmp    802796 <dup+0x174>

	return newfdnum;
  802791:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802794:	eb 33                	jmp    8027c9 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802796:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80279a:	48 89 c6             	mov    %rax,%rsi
  80279d:	bf 00 00 00 00       	mov    $0x0,%edi
  8027a2:	48 b8 a6 1b 80 00 00 	movabs $0x801ba6,%rax
  8027a9:	00 00 00 
  8027ac:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8027ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027b2:	48 89 c6             	mov    %rax,%rsi
  8027b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8027ba:	48 b8 a6 1b 80 00 00 	movabs $0x801ba6,%rax
  8027c1:	00 00 00 
  8027c4:	ff d0                	callq  *%rax
	return r;
  8027c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8027c9:	c9                   	leaveq 
  8027ca:	c3                   	retq   

00000000008027cb <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8027cb:	55                   	push   %rbp
  8027cc:	48 89 e5             	mov    %rsp,%rbp
  8027cf:	48 83 ec 40          	sub    $0x40,%rsp
  8027d3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8027d6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8027da:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8027de:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027e2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8027e5:	48 89 d6             	mov    %rdx,%rsi
  8027e8:	89 c7                	mov    %eax,%edi
  8027ea:	48 b8 99 23 80 00 00 	movabs $0x802399,%rax
  8027f1:	00 00 00 
  8027f4:	ff d0                	callq  *%rax
  8027f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027fd:	78 24                	js     802823 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8027ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802803:	8b 00                	mov    (%rax),%eax
  802805:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802809:	48 89 d6             	mov    %rdx,%rsi
  80280c:	89 c7                	mov    %eax,%edi
  80280e:	48 b8 f2 24 80 00 00 	movabs $0x8024f2,%rax
  802815:	00 00 00 
  802818:	ff d0                	callq  *%rax
  80281a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80281d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802821:	79 05                	jns    802828 <read+0x5d>
		return r;
  802823:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802826:	eb 76                	jmp    80289e <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802828:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80282c:	8b 40 08             	mov    0x8(%rax),%eax
  80282f:	83 e0 03             	and    $0x3,%eax
  802832:	83 f8 01             	cmp    $0x1,%eax
  802835:	75 3a                	jne    802871 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802837:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80283e:	00 00 00 
  802841:	48 8b 00             	mov    (%rax),%rax
  802844:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80284a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80284d:	89 c6                	mov    %eax,%esi
  80284f:	48 bf af 44 80 00 00 	movabs $0x8044af,%rdi
  802856:	00 00 00 
  802859:	b8 00 00 00 00       	mov    $0x0,%eax
  80285e:	48 b9 17 06 80 00 00 	movabs $0x800617,%rcx
  802865:	00 00 00 
  802868:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80286a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80286f:	eb 2d                	jmp    80289e <read+0xd3>
	}
	if (!dev->dev_read)
  802871:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802875:	48 8b 40 10          	mov    0x10(%rax),%rax
  802879:	48 85 c0             	test   %rax,%rax
  80287c:	75 07                	jne    802885 <read+0xba>
		return -E_NOT_SUPP;
  80287e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802883:	eb 19                	jmp    80289e <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802885:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802889:	48 8b 40 10          	mov    0x10(%rax),%rax
  80288d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802891:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802895:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802899:	48 89 cf             	mov    %rcx,%rdi
  80289c:	ff d0                	callq  *%rax
}
  80289e:	c9                   	leaveq 
  80289f:	c3                   	retq   

00000000008028a0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8028a0:	55                   	push   %rbp
  8028a1:	48 89 e5             	mov    %rsp,%rbp
  8028a4:	48 83 ec 30          	sub    $0x30,%rsp
  8028a8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028ab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028af:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8028b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8028ba:	eb 49                	jmp    802905 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8028bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028bf:	48 98                	cltq   
  8028c1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028c5:	48 29 c2             	sub    %rax,%rdx
  8028c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028cb:	48 63 c8             	movslq %eax,%rcx
  8028ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028d2:	48 01 c1             	add    %rax,%rcx
  8028d5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028d8:	48 89 ce             	mov    %rcx,%rsi
  8028db:	89 c7                	mov    %eax,%edi
  8028dd:	48 b8 cb 27 80 00 00 	movabs $0x8027cb,%rax
  8028e4:	00 00 00 
  8028e7:	ff d0                	callq  *%rax
  8028e9:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8028ec:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8028f0:	79 05                	jns    8028f7 <readn+0x57>
			return m;
  8028f2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028f5:	eb 1c                	jmp    802913 <readn+0x73>
		if (m == 0)
  8028f7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8028fb:	75 02                	jne    8028ff <readn+0x5f>
			break;
  8028fd:	eb 11                	jmp    802910 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8028ff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802902:	01 45 fc             	add    %eax,-0x4(%rbp)
  802905:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802908:	48 98                	cltq   
  80290a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80290e:	72 ac                	jb     8028bc <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802910:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802913:	c9                   	leaveq 
  802914:	c3                   	retq   

0000000000802915 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802915:	55                   	push   %rbp
  802916:	48 89 e5             	mov    %rsp,%rbp
  802919:	48 83 ec 40          	sub    $0x40,%rsp
  80291d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802920:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802924:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802928:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80292c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80292f:	48 89 d6             	mov    %rdx,%rsi
  802932:	89 c7                	mov    %eax,%edi
  802934:	48 b8 99 23 80 00 00 	movabs $0x802399,%rax
  80293b:	00 00 00 
  80293e:	ff d0                	callq  *%rax
  802940:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802943:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802947:	78 24                	js     80296d <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802949:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80294d:	8b 00                	mov    (%rax),%eax
  80294f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802953:	48 89 d6             	mov    %rdx,%rsi
  802956:	89 c7                	mov    %eax,%edi
  802958:	48 b8 f2 24 80 00 00 	movabs $0x8024f2,%rax
  80295f:	00 00 00 
  802962:	ff d0                	callq  *%rax
  802964:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802967:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80296b:	79 05                	jns    802972 <write+0x5d>
		return r;
  80296d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802970:	eb 75                	jmp    8029e7 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802972:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802976:	8b 40 08             	mov    0x8(%rax),%eax
  802979:	83 e0 03             	and    $0x3,%eax
  80297c:	85 c0                	test   %eax,%eax
  80297e:	75 3a                	jne    8029ba <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802980:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802987:	00 00 00 
  80298a:	48 8b 00             	mov    (%rax),%rax
  80298d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802993:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802996:	89 c6                	mov    %eax,%esi
  802998:	48 bf cb 44 80 00 00 	movabs $0x8044cb,%rdi
  80299f:	00 00 00 
  8029a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a7:	48 b9 17 06 80 00 00 	movabs $0x800617,%rcx
  8029ae:	00 00 00 
  8029b1:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8029b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029b8:	eb 2d                	jmp    8029e7 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8029ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029be:	48 8b 40 18          	mov    0x18(%rax),%rax
  8029c2:	48 85 c0             	test   %rax,%rax
  8029c5:	75 07                	jne    8029ce <write+0xb9>
		return -E_NOT_SUPP;
  8029c7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029cc:	eb 19                	jmp    8029e7 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8029ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029d2:	48 8b 40 18          	mov    0x18(%rax),%rax
  8029d6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8029da:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8029de:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8029e2:	48 89 cf             	mov    %rcx,%rdi
  8029e5:	ff d0                	callq  *%rax
}
  8029e7:	c9                   	leaveq 
  8029e8:	c3                   	retq   

00000000008029e9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8029e9:	55                   	push   %rbp
  8029ea:	48 89 e5             	mov    %rsp,%rbp
  8029ed:	48 83 ec 18          	sub    $0x18,%rsp
  8029f1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8029f4:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029f7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029fb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029fe:	48 89 d6             	mov    %rdx,%rsi
  802a01:	89 c7                	mov    %eax,%edi
  802a03:	48 b8 99 23 80 00 00 	movabs $0x802399,%rax
  802a0a:	00 00 00 
  802a0d:	ff d0                	callq  *%rax
  802a0f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a12:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a16:	79 05                	jns    802a1d <seek+0x34>
		return r;
  802a18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a1b:	eb 0f                	jmp    802a2c <seek+0x43>
	fd->fd_offset = offset;
  802a1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a21:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802a24:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802a27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a2c:	c9                   	leaveq 
  802a2d:	c3                   	retq   

0000000000802a2e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802a2e:	55                   	push   %rbp
  802a2f:	48 89 e5             	mov    %rsp,%rbp
  802a32:	48 83 ec 30          	sub    $0x30,%rsp
  802a36:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a39:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a3c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a40:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a43:	48 89 d6             	mov    %rdx,%rsi
  802a46:	89 c7                	mov    %eax,%edi
  802a48:	48 b8 99 23 80 00 00 	movabs $0x802399,%rax
  802a4f:	00 00 00 
  802a52:	ff d0                	callq  *%rax
  802a54:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a5b:	78 24                	js     802a81 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a61:	8b 00                	mov    (%rax),%eax
  802a63:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a67:	48 89 d6             	mov    %rdx,%rsi
  802a6a:	89 c7                	mov    %eax,%edi
  802a6c:	48 b8 f2 24 80 00 00 	movabs $0x8024f2,%rax
  802a73:	00 00 00 
  802a76:	ff d0                	callq  *%rax
  802a78:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a7b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a7f:	79 05                	jns    802a86 <ftruncate+0x58>
		return r;
  802a81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a84:	eb 72                	jmp    802af8 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a8a:	8b 40 08             	mov    0x8(%rax),%eax
  802a8d:	83 e0 03             	and    $0x3,%eax
  802a90:	85 c0                	test   %eax,%eax
  802a92:	75 3a                	jne    802ace <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802a94:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802a9b:	00 00 00 
  802a9e:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802aa1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802aa7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802aaa:	89 c6                	mov    %eax,%esi
  802aac:	48 bf e8 44 80 00 00 	movabs $0x8044e8,%rdi
  802ab3:	00 00 00 
  802ab6:	b8 00 00 00 00       	mov    $0x0,%eax
  802abb:	48 b9 17 06 80 00 00 	movabs $0x800617,%rcx
  802ac2:	00 00 00 
  802ac5:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802ac7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802acc:	eb 2a                	jmp    802af8 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802ace:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ad2:	48 8b 40 30          	mov    0x30(%rax),%rax
  802ad6:	48 85 c0             	test   %rax,%rax
  802ad9:	75 07                	jne    802ae2 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802adb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ae0:	eb 16                	jmp    802af8 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802ae2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ae6:	48 8b 40 30          	mov    0x30(%rax),%rax
  802aea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802aee:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802af1:	89 ce                	mov    %ecx,%esi
  802af3:	48 89 d7             	mov    %rdx,%rdi
  802af6:	ff d0                	callq  *%rax
}
  802af8:	c9                   	leaveq 
  802af9:	c3                   	retq   

0000000000802afa <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802afa:	55                   	push   %rbp
  802afb:	48 89 e5             	mov    %rsp,%rbp
  802afe:	48 83 ec 30          	sub    $0x30,%rsp
  802b02:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b05:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b09:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b0d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b10:	48 89 d6             	mov    %rdx,%rsi
  802b13:	89 c7                	mov    %eax,%edi
  802b15:	48 b8 99 23 80 00 00 	movabs $0x802399,%rax
  802b1c:	00 00 00 
  802b1f:	ff d0                	callq  *%rax
  802b21:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b24:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b28:	78 24                	js     802b4e <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b2e:	8b 00                	mov    (%rax),%eax
  802b30:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b34:	48 89 d6             	mov    %rdx,%rsi
  802b37:	89 c7                	mov    %eax,%edi
  802b39:	48 b8 f2 24 80 00 00 	movabs $0x8024f2,%rax
  802b40:	00 00 00 
  802b43:	ff d0                	callq  *%rax
  802b45:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b48:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b4c:	79 05                	jns    802b53 <fstat+0x59>
		return r;
  802b4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b51:	eb 5e                	jmp    802bb1 <fstat+0xb7>
	if (!dev->dev_stat)
  802b53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b57:	48 8b 40 28          	mov    0x28(%rax),%rax
  802b5b:	48 85 c0             	test   %rax,%rax
  802b5e:	75 07                	jne    802b67 <fstat+0x6d>
		return -E_NOT_SUPP;
  802b60:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b65:	eb 4a                	jmp    802bb1 <fstat+0xb7>
	stat->st_name[0] = 0;
  802b67:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b6b:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802b6e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b72:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802b79:	00 00 00 
	stat->st_isdir = 0;
  802b7c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b80:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802b87:	00 00 00 
	stat->st_dev = dev;
  802b8a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b8e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b92:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802b99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b9d:	48 8b 40 28          	mov    0x28(%rax),%rax
  802ba1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ba5:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802ba9:	48 89 ce             	mov    %rcx,%rsi
  802bac:	48 89 d7             	mov    %rdx,%rdi
  802baf:	ff d0                	callq  *%rax
}
  802bb1:	c9                   	leaveq 
  802bb2:	c3                   	retq   

0000000000802bb3 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802bb3:	55                   	push   %rbp
  802bb4:	48 89 e5             	mov    %rsp,%rbp
  802bb7:	48 83 ec 20          	sub    $0x20,%rsp
  802bbb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802bbf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802bc3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bc7:	be 00 00 00 00       	mov    $0x0,%esi
  802bcc:	48 89 c7             	mov    %rax,%rdi
  802bcf:	48 b8 a1 2c 80 00 00 	movabs $0x802ca1,%rax
  802bd6:	00 00 00 
  802bd9:	ff d0                	callq  *%rax
  802bdb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bde:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802be2:	79 05                	jns    802be9 <stat+0x36>
		return fd;
  802be4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802be7:	eb 2f                	jmp    802c18 <stat+0x65>
	r = fstat(fd, stat);
  802be9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802bed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bf0:	48 89 d6             	mov    %rdx,%rsi
  802bf3:	89 c7                	mov    %eax,%edi
  802bf5:	48 b8 fa 2a 80 00 00 	movabs $0x802afa,%rax
  802bfc:	00 00 00 
  802bff:	ff d0                	callq  *%rax
  802c01:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802c04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c07:	89 c7                	mov    %eax,%edi
  802c09:	48 b8 a9 25 80 00 00 	movabs $0x8025a9,%rax
  802c10:	00 00 00 
  802c13:	ff d0                	callq  *%rax
	return r;
  802c15:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802c18:	c9                   	leaveq 
  802c19:	c3                   	retq   

0000000000802c1a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802c1a:	55                   	push   %rbp
  802c1b:	48 89 e5             	mov    %rsp,%rbp
  802c1e:	48 83 ec 10          	sub    $0x10,%rsp
  802c22:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c25:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802c29:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c30:	00 00 00 
  802c33:	8b 00                	mov    (%rax),%eax
  802c35:	85 c0                	test   %eax,%eax
  802c37:	75 1d                	jne    802c56 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802c39:	bf 01 00 00 00       	mov    $0x1,%edi
  802c3e:	48 b8 02 3d 80 00 00 	movabs $0x803d02,%rax
  802c45:	00 00 00 
  802c48:	ff d0                	callq  *%rax
  802c4a:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802c51:	00 00 00 
  802c54:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802c56:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c5d:	00 00 00 
  802c60:	8b 00                	mov    (%rax),%eax
  802c62:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802c65:	b9 07 00 00 00       	mov    $0x7,%ecx
  802c6a:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802c71:	00 00 00 
  802c74:	89 c7                	mov    %eax,%edi
  802c76:	48 b8 65 3c 80 00 00 	movabs $0x803c65,%rax
  802c7d:	00 00 00 
  802c80:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802c82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c86:	ba 00 00 00 00       	mov    $0x0,%edx
  802c8b:	48 89 c6             	mov    %rax,%rsi
  802c8e:	bf 00 00 00 00       	mov    $0x0,%edi
  802c93:	48 b8 9f 3b 80 00 00 	movabs $0x803b9f,%rax
  802c9a:	00 00 00 
  802c9d:	ff d0                	callq  *%rax
}
  802c9f:	c9                   	leaveq 
  802ca0:	c3                   	retq   

0000000000802ca1 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802ca1:	55                   	push   %rbp
  802ca2:	48 89 e5             	mov    %rsp,%rbp
  802ca5:	48 83 ec 20          	sub    $0x20,%rsp
  802ca9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802cad:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  802cb0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cb4:	48 89 c7             	mov    %rax,%rdi
  802cb7:	48 b8 60 11 80 00 00 	movabs $0x801160,%rax
  802cbe:	00 00 00 
  802cc1:	ff d0                	callq  *%rax
  802cc3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802cc8:	7e 0a                	jle    802cd4 <open+0x33>
  802cca:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ccf:	e9 a5 00 00 00       	jmpq   802d79 <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  802cd4:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802cd8:	48 89 c7             	mov    %rax,%rdi
  802cdb:	48 b8 01 23 80 00 00 	movabs $0x802301,%rax
  802ce2:	00 00 00 
  802ce5:	ff d0                	callq  *%rax
  802ce7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cee:	79 08                	jns    802cf8 <open+0x57>
		return r;
  802cf0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cf3:	e9 81 00 00 00       	jmpq   802d79 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  802cf8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cff:	00 00 00 
  802d02:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802d05:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  802d0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d0f:	48 89 c6             	mov    %rax,%rsi
  802d12:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802d19:	00 00 00 
  802d1c:	48 b8 cc 11 80 00 00 	movabs $0x8011cc,%rax
  802d23:	00 00 00 
  802d26:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  802d28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d2c:	48 89 c6             	mov    %rax,%rsi
  802d2f:	bf 01 00 00 00       	mov    $0x1,%edi
  802d34:	48 b8 1a 2c 80 00 00 	movabs $0x802c1a,%rax
  802d3b:	00 00 00 
  802d3e:	ff d0                	callq  *%rax
  802d40:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d47:	79 1d                	jns    802d66 <open+0xc5>
		fd_close(fd, 0);
  802d49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d4d:	be 00 00 00 00       	mov    $0x0,%esi
  802d52:	48 89 c7             	mov    %rax,%rdi
  802d55:	48 b8 29 24 80 00 00 	movabs $0x802429,%rax
  802d5c:	00 00 00 
  802d5f:	ff d0                	callq  *%rax
		return r;
  802d61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d64:	eb 13                	jmp    802d79 <open+0xd8>
	}
	return fd2num(fd);
  802d66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d6a:	48 89 c7             	mov    %rax,%rdi
  802d6d:	48 b8 b3 22 80 00 00 	movabs $0x8022b3,%rax
  802d74:	00 00 00 
  802d77:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  802d79:	c9                   	leaveq 
  802d7a:	c3                   	retq   

0000000000802d7b <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802d7b:	55                   	push   %rbp
  802d7c:	48 89 e5             	mov    %rsp,%rbp
  802d7f:	48 83 ec 10          	sub    $0x10,%rsp
  802d83:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802d87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d8b:	8b 50 0c             	mov    0xc(%rax),%edx
  802d8e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d95:	00 00 00 
  802d98:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802d9a:	be 00 00 00 00       	mov    $0x0,%esi
  802d9f:	bf 06 00 00 00       	mov    $0x6,%edi
  802da4:	48 b8 1a 2c 80 00 00 	movabs $0x802c1a,%rax
  802dab:	00 00 00 
  802dae:	ff d0                	callq  *%rax
}
  802db0:	c9                   	leaveq 
  802db1:	c3                   	retq   

0000000000802db2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802db2:	55                   	push   %rbp
  802db3:	48 89 e5             	mov    %rsp,%rbp
  802db6:	48 83 ec 30          	sub    $0x30,%rsp
  802dba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802dbe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802dc2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802dc6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dca:	8b 50 0c             	mov    0xc(%rax),%edx
  802dcd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802dd4:	00 00 00 
  802dd7:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802dd9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802de0:	00 00 00 
  802de3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802de7:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  802deb:	be 00 00 00 00       	mov    $0x0,%esi
  802df0:	bf 03 00 00 00       	mov    $0x3,%edi
  802df5:	48 b8 1a 2c 80 00 00 	movabs $0x802c1a,%rax
  802dfc:	00 00 00 
  802dff:	ff d0                	callq  *%rax
  802e01:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e04:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e08:	79 05                	jns    802e0f <devfile_read+0x5d>
		return r;
  802e0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e0d:	eb 26                	jmp    802e35 <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  802e0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e12:	48 63 d0             	movslq %eax,%rdx
  802e15:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e19:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802e20:	00 00 00 
  802e23:	48 89 c7             	mov    %rax,%rdi
  802e26:	48 b8 07 16 80 00 00 	movabs $0x801607,%rax
  802e2d:	00 00 00 
  802e30:	ff d0                	callq  *%rax
	return r;
  802e32:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802e35:	c9                   	leaveq 
  802e36:	c3                   	retq   

0000000000802e37 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802e37:	55                   	push   %rbp
  802e38:	48 89 e5             	mov    %rsp,%rbp
  802e3b:	48 83 ec 30          	sub    $0x30,%rsp
  802e3f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e43:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e47:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  802e4b:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  802e52:	00 
	n = n > max ? max : n;
  802e53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e57:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802e5b:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  802e60:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802e64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e68:	8b 50 0c             	mov    0xc(%rax),%edx
  802e6b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e72:	00 00 00 
  802e75:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802e77:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e7e:	00 00 00 
  802e81:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e85:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802e89:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e8d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e91:	48 89 c6             	mov    %rax,%rsi
  802e94:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802e9b:	00 00 00 
  802e9e:	48 b8 07 16 80 00 00 	movabs $0x801607,%rax
  802ea5:	00 00 00 
  802ea8:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  802eaa:	be 00 00 00 00       	mov    $0x0,%esi
  802eaf:	bf 04 00 00 00       	mov    $0x4,%edi
  802eb4:	48 b8 1a 2c 80 00 00 	movabs $0x802c1a,%rax
  802ebb:	00 00 00 
  802ebe:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  802ec0:	c9                   	leaveq 
  802ec1:	c3                   	retq   

0000000000802ec2 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802ec2:	55                   	push   %rbp
  802ec3:	48 89 e5             	mov    %rsp,%rbp
  802ec6:	48 83 ec 20          	sub    $0x20,%rsp
  802eca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ece:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802ed2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ed6:	8b 50 0c             	mov    0xc(%rax),%edx
  802ed9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ee0:	00 00 00 
  802ee3:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802ee5:	be 00 00 00 00       	mov    $0x0,%esi
  802eea:	bf 05 00 00 00       	mov    $0x5,%edi
  802eef:	48 b8 1a 2c 80 00 00 	movabs $0x802c1a,%rax
  802ef6:	00 00 00 
  802ef9:	ff d0                	callq  *%rax
  802efb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802efe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f02:	79 05                	jns    802f09 <devfile_stat+0x47>
		return r;
  802f04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f07:	eb 56                	jmp    802f5f <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802f09:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f0d:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802f14:	00 00 00 
  802f17:	48 89 c7             	mov    %rax,%rdi
  802f1a:	48 b8 cc 11 80 00 00 	movabs $0x8011cc,%rax
  802f21:	00 00 00 
  802f24:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802f26:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f2d:	00 00 00 
  802f30:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802f36:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f3a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802f40:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f47:	00 00 00 
  802f4a:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802f50:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f54:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802f5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f5f:	c9                   	leaveq 
  802f60:	c3                   	retq   

0000000000802f61 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802f61:	55                   	push   %rbp
  802f62:	48 89 e5             	mov    %rsp,%rbp
  802f65:	48 83 ec 10          	sub    $0x10,%rsp
  802f69:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f6d:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802f70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f74:	8b 50 0c             	mov    0xc(%rax),%edx
  802f77:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f7e:	00 00 00 
  802f81:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802f83:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f8a:	00 00 00 
  802f8d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802f90:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802f93:	be 00 00 00 00       	mov    $0x0,%esi
  802f98:	bf 02 00 00 00       	mov    $0x2,%edi
  802f9d:	48 b8 1a 2c 80 00 00 	movabs $0x802c1a,%rax
  802fa4:	00 00 00 
  802fa7:	ff d0                	callq  *%rax
}
  802fa9:	c9                   	leaveq 
  802faa:	c3                   	retq   

0000000000802fab <remove>:

// Delete a file
int
remove(const char *path)
{
  802fab:	55                   	push   %rbp
  802fac:	48 89 e5             	mov    %rsp,%rbp
  802faf:	48 83 ec 10          	sub    $0x10,%rsp
  802fb3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802fb7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fbb:	48 89 c7             	mov    %rax,%rdi
  802fbe:	48 b8 60 11 80 00 00 	movabs $0x801160,%rax
  802fc5:	00 00 00 
  802fc8:	ff d0                	callq  *%rax
  802fca:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802fcf:	7e 07                	jle    802fd8 <remove+0x2d>
		return -E_BAD_PATH;
  802fd1:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802fd6:	eb 33                	jmp    80300b <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802fd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fdc:	48 89 c6             	mov    %rax,%rsi
  802fdf:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802fe6:	00 00 00 
  802fe9:	48 b8 cc 11 80 00 00 	movabs $0x8011cc,%rax
  802ff0:	00 00 00 
  802ff3:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802ff5:	be 00 00 00 00       	mov    $0x0,%esi
  802ffa:	bf 07 00 00 00       	mov    $0x7,%edi
  802fff:	48 b8 1a 2c 80 00 00 	movabs $0x802c1a,%rax
  803006:	00 00 00 
  803009:	ff d0                	callq  *%rax
}
  80300b:	c9                   	leaveq 
  80300c:	c3                   	retq   

000000000080300d <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80300d:	55                   	push   %rbp
  80300e:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803011:	be 00 00 00 00       	mov    $0x0,%esi
  803016:	bf 08 00 00 00       	mov    $0x8,%edi
  80301b:	48 b8 1a 2c 80 00 00 	movabs $0x802c1a,%rax
  803022:	00 00 00 
  803025:	ff d0                	callq  *%rax
}
  803027:	5d                   	pop    %rbp
  803028:	c3                   	retq   

0000000000803029 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803029:	55                   	push   %rbp
  80302a:	48 89 e5             	mov    %rsp,%rbp
  80302d:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803034:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80303b:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803042:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803049:	be 00 00 00 00       	mov    $0x0,%esi
  80304e:	48 89 c7             	mov    %rax,%rdi
  803051:	48 b8 a1 2c 80 00 00 	movabs $0x802ca1,%rax
  803058:	00 00 00 
  80305b:	ff d0                	callq  *%rax
  80305d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803060:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803064:	79 28                	jns    80308e <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803066:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803069:	89 c6                	mov    %eax,%esi
  80306b:	48 bf 0e 45 80 00 00 	movabs $0x80450e,%rdi
  803072:	00 00 00 
  803075:	b8 00 00 00 00       	mov    $0x0,%eax
  80307a:	48 ba 17 06 80 00 00 	movabs $0x800617,%rdx
  803081:	00 00 00 
  803084:	ff d2                	callq  *%rdx
		return fd_src;
  803086:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803089:	e9 74 01 00 00       	jmpq   803202 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80308e:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803095:	be 01 01 00 00       	mov    $0x101,%esi
  80309a:	48 89 c7             	mov    %rax,%rdi
  80309d:	48 b8 a1 2c 80 00 00 	movabs $0x802ca1,%rax
  8030a4:	00 00 00 
  8030a7:	ff d0                	callq  *%rax
  8030a9:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8030ac:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8030b0:	79 39                	jns    8030eb <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8030b2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030b5:	89 c6                	mov    %eax,%esi
  8030b7:	48 bf 24 45 80 00 00 	movabs $0x804524,%rdi
  8030be:	00 00 00 
  8030c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8030c6:	48 ba 17 06 80 00 00 	movabs $0x800617,%rdx
  8030cd:	00 00 00 
  8030d0:	ff d2                	callq  *%rdx
		close(fd_src);
  8030d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030d5:	89 c7                	mov    %eax,%edi
  8030d7:	48 b8 a9 25 80 00 00 	movabs $0x8025a9,%rax
  8030de:	00 00 00 
  8030e1:	ff d0                	callq  *%rax
		return fd_dest;
  8030e3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030e6:	e9 17 01 00 00       	jmpq   803202 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8030eb:	eb 74                	jmp    803161 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8030ed:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8030f0:	48 63 d0             	movslq %eax,%rdx
  8030f3:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8030fa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030fd:	48 89 ce             	mov    %rcx,%rsi
  803100:	89 c7                	mov    %eax,%edi
  803102:	48 b8 15 29 80 00 00 	movabs $0x802915,%rax
  803109:	00 00 00 
  80310c:	ff d0                	callq  *%rax
  80310e:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803111:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803115:	79 4a                	jns    803161 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803117:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80311a:	89 c6                	mov    %eax,%esi
  80311c:	48 bf 3e 45 80 00 00 	movabs $0x80453e,%rdi
  803123:	00 00 00 
  803126:	b8 00 00 00 00       	mov    $0x0,%eax
  80312b:	48 ba 17 06 80 00 00 	movabs $0x800617,%rdx
  803132:	00 00 00 
  803135:	ff d2                	callq  *%rdx
			close(fd_src);
  803137:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80313a:	89 c7                	mov    %eax,%edi
  80313c:	48 b8 a9 25 80 00 00 	movabs $0x8025a9,%rax
  803143:	00 00 00 
  803146:	ff d0                	callq  *%rax
			close(fd_dest);
  803148:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80314b:	89 c7                	mov    %eax,%edi
  80314d:	48 b8 a9 25 80 00 00 	movabs $0x8025a9,%rax
  803154:	00 00 00 
  803157:	ff d0                	callq  *%rax
			return write_size;
  803159:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80315c:	e9 a1 00 00 00       	jmpq   803202 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803161:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803168:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80316b:	ba 00 02 00 00       	mov    $0x200,%edx
  803170:	48 89 ce             	mov    %rcx,%rsi
  803173:	89 c7                	mov    %eax,%edi
  803175:	48 b8 cb 27 80 00 00 	movabs $0x8027cb,%rax
  80317c:	00 00 00 
  80317f:	ff d0                	callq  *%rax
  803181:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803184:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803188:	0f 8f 5f ff ff ff    	jg     8030ed <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80318e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803192:	79 47                	jns    8031db <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803194:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803197:	89 c6                	mov    %eax,%esi
  803199:	48 bf 51 45 80 00 00 	movabs $0x804551,%rdi
  8031a0:	00 00 00 
  8031a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a8:	48 ba 17 06 80 00 00 	movabs $0x800617,%rdx
  8031af:	00 00 00 
  8031b2:	ff d2                	callq  *%rdx
		close(fd_src);
  8031b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031b7:	89 c7                	mov    %eax,%edi
  8031b9:	48 b8 a9 25 80 00 00 	movabs $0x8025a9,%rax
  8031c0:	00 00 00 
  8031c3:	ff d0                	callq  *%rax
		close(fd_dest);
  8031c5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031c8:	89 c7                	mov    %eax,%edi
  8031ca:	48 b8 a9 25 80 00 00 	movabs $0x8025a9,%rax
  8031d1:	00 00 00 
  8031d4:	ff d0                	callq  *%rax
		return read_size;
  8031d6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8031d9:	eb 27                	jmp    803202 <copy+0x1d9>
	}
	close(fd_src);
  8031db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031de:	89 c7                	mov    %eax,%edi
  8031e0:	48 b8 a9 25 80 00 00 	movabs $0x8025a9,%rax
  8031e7:	00 00 00 
  8031ea:	ff d0                	callq  *%rax
	close(fd_dest);
  8031ec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031ef:	89 c7                	mov    %eax,%edi
  8031f1:	48 b8 a9 25 80 00 00 	movabs $0x8025a9,%rax
  8031f8:	00 00 00 
  8031fb:	ff d0                	callq  *%rax
	return 0;
  8031fd:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803202:	c9                   	leaveq 
  803203:	c3                   	retq   

0000000000803204 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803204:	55                   	push   %rbp
  803205:	48 89 e5             	mov    %rsp,%rbp
  803208:	53                   	push   %rbx
  803209:	48 83 ec 38          	sub    $0x38,%rsp
  80320d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803211:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803215:	48 89 c7             	mov    %rax,%rdi
  803218:	48 b8 01 23 80 00 00 	movabs $0x802301,%rax
  80321f:	00 00 00 
  803222:	ff d0                	callq  *%rax
  803224:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803227:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80322b:	0f 88 bf 01 00 00    	js     8033f0 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803231:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803235:	ba 07 04 00 00       	mov    $0x407,%edx
  80323a:	48 89 c6             	mov    %rax,%rsi
  80323d:	bf 00 00 00 00       	mov    $0x0,%edi
  803242:	48 b8 fb 1a 80 00 00 	movabs $0x801afb,%rax
  803249:	00 00 00 
  80324c:	ff d0                	callq  *%rax
  80324e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803251:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803255:	0f 88 95 01 00 00    	js     8033f0 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80325b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80325f:	48 89 c7             	mov    %rax,%rdi
  803262:	48 b8 01 23 80 00 00 	movabs $0x802301,%rax
  803269:	00 00 00 
  80326c:	ff d0                	callq  *%rax
  80326e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803271:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803275:	0f 88 5d 01 00 00    	js     8033d8 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80327b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80327f:	ba 07 04 00 00       	mov    $0x407,%edx
  803284:	48 89 c6             	mov    %rax,%rsi
  803287:	bf 00 00 00 00       	mov    $0x0,%edi
  80328c:	48 b8 fb 1a 80 00 00 	movabs $0x801afb,%rax
  803293:	00 00 00 
  803296:	ff d0                	callq  *%rax
  803298:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80329b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80329f:	0f 88 33 01 00 00    	js     8033d8 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8032a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032a9:	48 89 c7             	mov    %rax,%rdi
  8032ac:	48 b8 d6 22 80 00 00 	movabs $0x8022d6,%rax
  8032b3:	00 00 00 
  8032b6:	ff d0                	callq  *%rax
  8032b8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032bc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032c0:	ba 07 04 00 00       	mov    $0x407,%edx
  8032c5:	48 89 c6             	mov    %rax,%rsi
  8032c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8032cd:	48 b8 fb 1a 80 00 00 	movabs $0x801afb,%rax
  8032d4:	00 00 00 
  8032d7:	ff d0                	callq  *%rax
  8032d9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032e0:	79 05                	jns    8032e7 <pipe+0xe3>
		goto err2;
  8032e2:	e9 d9 00 00 00       	jmpq   8033c0 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032eb:	48 89 c7             	mov    %rax,%rdi
  8032ee:	48 b8 d6 22 80 00 00 	movabs $0x8022d6,%rax
  8032f5:	00 00 00 
  8032f8:	ff d0                	callq  *%rax
  8032fa:	48 89 c2             	mov    %rax,%rdx
  8032fd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803301:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803307:	48 89 d1             	mov    %rdx,%rcx
  80330a:	ba 00 00 00 00       	mov    $0x0,%edx
  80330f:	48 89 c6             	mov    %rax,%rsi
  803312:	bf 00 00 00 00       	mov    $0x0,%edi
  803317:	48 b8 4b 1b 80 00 00 	movabs $0x801b4b,%rax
  80331e:	00 00 00 
  803321:	ff d0                	callq  *%rax
  803323:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803326:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80332a:	79 1b                	jns    803347 <pipe+0x143>
		goto err3;
  80332c:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80332d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803331:	48 89 c6             	mov    %rax,%rsi
  803334:	bf 00 00 00 00       	mov    $0x0,%edi
  803339:	48 b8 a6 1b 80 00 00 	movabs $0x801ba6,%rax
  803340:	00 00 00 
  803343:	ff d0                	callq  *%rax
  803345:	eb 79                	jmp    8033c0 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803347:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80334b:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803352:	00 00 00 
  803355:	8b 12                	mov    (%rdx),%edx
  803357:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803359:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80335d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803364:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803368:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  80336f:	00 00 00 
  803372:	8b 12                	mov    (%rdx),%edx
  803374:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803376:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80337a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803381:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803385:	48 89 c7             	mov    %rax,%rdi
  803388:	48 b8 b3 22 80 00 00 	movabs $0x8022b3,%rax
  80338f:	00 00 00 
  803392:	ff d0                	callq  *%rax
  803394:	89 c2                	mov    %eax,%edx
  803396:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80339a:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80339c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8033a0:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8033a4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033a8:	48 89 c7             	mov    %rax,%rdi
  8033ab:	48 b8 b3 22 80 00 00 	movabs $0x8022b3,%rax
  8033b2:	00 00 00 
  8033b5:	ff d0                	callq  *%rax
  8033b7:	89 03                	mov    %eax,(%rbx)
	return 0;
  8033b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8033be:	eb 33                	jmp    8033f3 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8033c0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033c4:	48 89 c6             	mov    %rax,%rsi
  8033c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8033cc:	48 b8 a6 1b 80 00 00 	movabs $0x801ba6,%rax
  8033d3:	00 00 00 
  8033d6:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8033d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033dc:	48 89 c6             	mov    %rax,%rsi
  8033df:	bf 00 00 00 00       	mov    $0x0,%edi
  8033e4:	48 b8 a6 1b 80 00 00 	movabs $0x801ba6,%rax
  8033eb:	00 00 00 
  8033ee:	ff d0                	callq  *%rax
err:
	return r;
  8033f0:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8033f3:	48 83 c4 38          	add    $0x38,%rsp
  8033f7:	5b                   	pop    %rbx
  8033f8:	5d                   	pop    %rbp
  8033f9:	c3                   	retq   

00000000008033fa <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8033fa:	55                   	push   %rbp
  8033fb:	48 89 e5             	mov    %rsp,%rbp
  8033fe:	53                   	push   %rbx
  8033ff:	48 83 ec 28          	sub    $0x28,%rsp
  803403:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803407:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80340b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803412:	00 00 00 
  803415:	48 8b 00             	mov    (%rax),%rax
  803418:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80341e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803421:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803425:	48 89 c7             	mov    %rax,%rdi
  803428:	48 b8 84 3d 80 00 00 	movabs $0x803d84,%rax
  80342f:	00 00 00 
  803432:	ff d0                	callq  *%rax
  803434:	89 c3                	mov    %eax,%ebx
  803436:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80343a:	48 89 c7             	mov    %rax,%rdi
  80343d:	48 b8 84 3d 80 00 00 	movabs $0x803d84,%rax
  803444:	00 00 00 
  803447:	ff d0                	callq  *%rax
  803449:	39 c3                	cmp    %eax,%ebx
  80344b:	0f 94 c0             	sete   %al
  80344e:	0f b6 c0             	movzbl %al,%eax
  803451:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803454:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80345b:	00 00 00 
  80345e:	48 8b 00             	mov    (%rax),%rax
  803461:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803467:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80346a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80346d:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803470:	75 05                	jne    803477 <_pipeisclosed+0x7d>
			return ret;
  803472:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803475:	eb 4f                	jmp    8034c6 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803477:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80347a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80347d:	74 42                	je     8034c1 <_pipeisclosed+0xc7>
  80347f:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803483:	75 3c                	jne    8034c1 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803485:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80348c:	00 00 00 
  80348f:	48 8b 00             	mov    (%rax),%rax
  803492:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803498:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80349b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80349e:	89 c6                	mov    %eax,%esi
  8034a0:	48 bf 6c 45 80 00 00 	movabs $0x80456c,%rdi
  8034a7:	00 00 00 
  8034aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8034af:	49 b8 17 06 80 00 00 	movabs $0x800617,%r8
  8034b6:	00 00 00 
  8034b9:	41 ff d0             	callq  *%r8
	}
  8034bc:	e9 4a ff ff ff       	jmpq   80340b <_pipeisclosed+0x11>
  8034c1:	e9 45 ff ff ff       	jmpq   80340b <_pipeisclosed+0x11>
}
  8034c6:	48 83 c4 28          	add    $0x28,%rsp
  8034ca:	5b                   	pop    %rbx
  8034cb:	5d                   	pop    %rbp
  8034cc:	c3                   	retq   

00000000008034cd <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8034cd:	55                   	push   %rbp
  8034ce:	48 89 e5             	mov    %rsp,%rbp
  8034d1:	48 83 ec 30          	sub    $0x30,%rsp
  8034d5:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8034d8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8034dc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8034df:	48 89 d6             	mov    %rdx,%rsi
  8034e2:	89 c7                	mov    %eax,%edi
  8034e4:	48 b8 99 23 80 00 00 	movabs $0x802399,%rax
  8034eb:	00 00 00 
  8034ee:	ff d0                	callq  *%rax
  8034f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034f7:	79 05                	jns    8034fe <pipeisclosed+0x31>
		return r;
  8034f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034fc:	eb 31                	jmp    80352f <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8034fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803502:	48 89 c7             	mov    %rax,%rdi
  803505:	48 b8 d6 22 80 00 00 	movabs $0x8022d6,%rax
  80350c:	00 00 00 
  80350f:	ff d0                	callq  *%rax
  803511:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803515:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803519:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80351d:	48 89 d6             	mov    %rdx,%rsi
  803520:	48 89 c7             	mov    %rax,%rdi
  803523:	48 b8 fa 33 80 00 00 	movabs $0x8033fa,%rax
  80352a:	00 00 00 
  80352d:	ff d0                	callq  *%rax
}
  80352f:	c9                   	leaveq 
  803530:	c3                   	retq   

0000000000803531 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803531:	55                   	push   %rbp
  803532:	48 89 e5             	mov    %rsp,%rbp
  803535:	48 83 ec 40          	sub    $0x40,%rsp
  803539:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80353d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803541:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803545:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803549:	48 89 c7             	mov    %rax,%rdi
  80354c:	48 b8 d6 22 80 00 00 	movabs $0x8022d6,%rax
  803553:	00 00 00 
  803556:	ff d0                	callq  *%rax
  803558:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80355c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803560:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803564:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80356b:	00 
  80356c:	e9 92 00 00 00       	jmpq   803603 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803571:	eb 41                	jmp    8035b4 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803573:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803578:	74 09                	je     803583 <devpipe_read+0x52>
				return i;
  80357a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80357e:	e9 92 00 00 00       	jmpq   803615 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803583:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803587:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80358b:	48 89 d6             	mov    %rdx,%rsi
  80358e:	48 89 c7             	mov    %rax,%rdi
  803591:	48 b8 fa 33 80 00 00 	movabs $0x8033fa,%rax
  803598:	00 00 00 
  80359b:	ff d0                	callq  *%rax
  80359d:	85 c0                	test   %eax,%eax
  80359f:	74 07                	je     8035a8 <devpipe_read+0x77>
				return 0;
  8035a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8035a6:	eb 6d                	jmp    803615 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8035a8:	48 b8 bd 1a 80 00 00 	movabs $0x801abd,%rax
  8035af:	00 00 00 
  8035b2:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8035b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035b8:	8b 10                	mov    (%rax),%edx
  8035ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035be:	8b 40 04             	mov    0x4(%rax),%eax
  8035c1:	39 c2                	cmp    %eax,%edx
  8035c3:	74 ae                	je     803573 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8035c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8035cd:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8035d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035d5:	8b 00                	mov    (%rax),%eax
  8035d7:	99                   	cltd   
  8035d8:	c1 ea 1b             	shr    $0x1b,%edx
  8035db:	01 d0                	add    %edx,%eax
  8035dd:	83 e0 1f             	and    $0x1f,%eax
  8035e0:	29 d0                	sub    %edx,%eax
  8035e2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035e6:	48 98                	cltq   
  8035e8:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8035ed:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8035ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035f3:	8b 00                	mov    (%rax),%eax
  8035f5:	8d 50 01             	lea    0x1(%rax),%edx
  8035f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035fc:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8035fe:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803603:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803607:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80360b:	0f 82 60 ff ff ff    	jb     803571 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803611:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803615:	c9                   	leaveq 
  803616:	c3                   	retq   

0000000000803617 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803617:	55                   	push   %rbp
  803618:	48 89 e5             	mov    %rsp,%rbp
  80361b:	48 83 ec 40          	sub    $0x40,%rsp
  80361f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803623:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803627:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80362b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80362f:	48 89 c7             	mov    %rax,%rdi
  803632:	48 b8 d6 22 80 00 00 	movabs $0x8022d6,%rax
  803639:	00 00 00 
  80363c:	ff d0                	callq  *%rax
  80363e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803642:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803646:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80364a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803651:	00 
  803652:	e9 8e 00 00 00       	jmpq   8036e5 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803657:	eb 31                	jmp    80368a <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803659:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80365d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803661:	48 89 d6             	mov    %rdx,%rsi
  803664:	48 89 c7             	mov    %rax,%rdi
  803667:	48 b8 fa 33 80 00 00 	movabs $0x8033fa,%rax
  80366e:	00 00 00 
  803671:	ff d0                	callq  *%rax
  803673:	85 c0                	test   %eax,%eax
  803675:	74 07                	je     80367e <devpipe_write+0x67>
				return 0;
  803677:	b8 00 00 00 00       	mov    $0x0,%eax
  80367c:	eb 79                	jmp    8036f7 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80367e:	48 b8 bd 1a 80 00 00 	movabs $0x801abd,%rax
  803685:	00 00 00 
  803688:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80368a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80368e:	8b 40 04             	mov    0x4(%rax),%eax
  803691:	48 63 d0             	movslq %eax,%rdx
  803694:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803698:	8b 00                	mov    (%rax),%eax
  80369a:	48 98                	cltq   
  80369c:	48 83 c0 20          	add    $0x20,%rax
  8036a0:	48 39 c2             	cmp    %rax,%rdx
  8036a3:	73 b4                	jae    803659 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8036a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036a9:	8b 40 04             	mov    0x4(%rax),%eax
  8036ac:	99                   	cltd   
  8036ad:	c1 ea 1b             	shr    $0x1b,%edx
  8036b0:	01 d0                	add    %edx,%eax
  8036b2:	83 e0 1f             	and    $0x1f,%eax
  8036b5:	29 d0                	sub    %edx,%eax
  8036b7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8036bb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8036bf:	48 01 ca             	add    %rcx,%rdx
  8036c2:	0f b6 0a             	movzbl (%rdx),%ecx
  8036c5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036c9:	48 98                	cltq   
  8036cb:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8036cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036d3:	8b 40 04             	mov    0x4(%rax),%eax
  8036d6:	8d 50 01             	lea    0x1(%rax),%edx
  8036d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036dd:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8036e0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8036e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036e9:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8036ed:	0f 82 64 ff ff ff    	jb     803657 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8036f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8036f7:	c9                   	leaveq 
  8036f8:	c3                   	retq   

00000000008036f9 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8036f9:	55                   	push   %rbp
  8036fa:	48 89 e5             	mov    %rsp,%rbp
  8036fd:	48 83 ec 20          	sub    $0x20,%rsp
  803701:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803705:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803709:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80370d:	48 89 c7             	mov    %rax,%rdi
  803710:	48 b8 d6 22 80 00 00 	movabs $0x8022d6,%rax
  803717:	00 00 00 
  80371a:	ff d0                	callq  *%rax
  80371c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803720:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803724:	48 be 7f 45 80 00 00 	movabs $0x80457f,%rsi
  80372b:	00 00 00 
  80372e:	48 89 c7             	mov    %rax,%rdi
  803731:	48 b8 cc 11 80 00 00 	movabs $0x8011cc,%rax
  803738:	00 00 00 
  80373b:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80373d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803741:	8b 50 04             	mov    0x4(%rax),%edx
  803744:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803748:	8b 00                	mov    (%rax),%eax
  80374a:	29 c2                	sub    %eax,%edx
  80374c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803750:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803756:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80375a:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803761:	00 00 00 
	stat->st_dev = &devpipe;
  803764:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803768:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  80376f:	00 00 00 
  803772:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803779:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80377e:	c9                   	leaveq 
  80377f:	c3                   	retq   

0000000000803780 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803780:	55                   	push   %rbp
  803781:	48 89 e5             	mov    %rsp,%rbp
  803784:	48 83 ec 10          	sub    $0x10,%rsp
  803788:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80378c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803790:	48 89 c6             	mov    %rax,%rsi
  803793:	bf 00 00 00 00       	mov    $0x0,%edi
  803798:	48 b8 a6 1b 80 00 00 	movabs $0x801ba6,%rax
  80379f:	00 00 00 
  8037a2:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8037a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037a8:	48 89 c7             	mov    %rax,%rdi
  8037ab:	48 b8 d6 22 80 00 00 	movabs $0x8022d6,%rax
  8037b2:	00 00 00 
  8037b5:	ff d0                	callq  *%rax
  8037b7:	48 89 c6             	mov    %rax,%rsi
  8037ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8037bf:	48 b8 a6 1b 80 00 00 	movabs $0x801ba6,%rax
  8037c6:	00 00 00 
  8037c9:	ff d0                	callq  *%rax
}
  8037cb:	c9                   	leaveq 
  8037cc:	c3                   	retq   

00000000008037cd <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8037cd:	55                   	push   %rbp
  8037ce:	48 89 e5             	mov    %rsp,%rbp
  8037d1:	48 83 ec 20          	sub    $0x20,%rsp
  8037d5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8037d8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037db:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8037de:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8037e2:	be 01 00 00 00       	mov    $0x1,%esi
  8037e7:	48 89 c7             	mov    %rax,%rdi
  8037ea:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  8037f1:	00 00 00 
  8037f4:	ff d0                	callq  *%rax
}
  8037f6:	c9                   	leaveq 
  8037f7:	c3                   	retq   

00000000008037f8 <getchar>:

int
getchar(void)
{
  8037f8:	55                   	push   %rbp
  8037f9:	48 89 e5             	mov    %rsp,%rbp
  8037fc:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803800:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803804:	ba 01 00 00 00       	mov    $0x1,%edx
  803809:	48 89 c6             	mov    %rax,%rsi
  80380c:	bf 00 00 00 00       	mov    $0x0,%edi
  803811:	48 b8 cb 27 80 00 00 	movabs $0x8027cb,%rax
  803818:	00 00 00 
  80381b:	ff d0                	callq  *%rax
  80381d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803820:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803824:	79 05                	jns    80382b <getchar+0x33>
		return r;
  803826:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803829:	eb 14                	jmp    80383f <getchar+0x47>
	if (r < 1)
  80382b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80382f:	7f 07                	jg     803838 <getchar+0x40>
		return -E_EOF;
  803831:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803836:	eb 07                	jmp    80383f <getchar+0x47>
	return c;
  803838:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80383c:	0f b6 c0             	movzbl %al,%eax
}
  80383f:	c9                   	leaveq 
  803840:	c3                   	retq   

0000000000803841 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803841:	55                   	push   %rbp
  803842:	48 89 e5             	mov    %rsp,%rbp
  803845:	48 83 ec 20          	sub    $0x20,%rsp
  803849:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80384c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803850:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803853:	48 89 d6             	mov    %rdx,%rsi
  803856:	89 c7                	mov    %eax,%edi
  803858:	48 b8 99 23 80 00 00 	movabs $0x802399,%rax
  80385f:	00 00 00 
  803862:	ff d0                	callq  *%rax
  803864:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803867:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80386b:	79 05                	jns    803872 <iscons+0x31>
		return r;
  80386d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803870:	eb 1a                	jmp    80388c <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803872:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803876:	8b 10                	mov    (%rax),%edx
  803878:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  80387f:	00 00 00 
  803882:	8b 00                	mov    (%rax),%eax
  803884:	39 c2                	cmp    %eax,%edx
  803886:	0f 94 c0             	sete   %al
  803889:	0f b6 c0             	movzbl %al,%eax
}
  80388c:	c9                   	leaveq 
  80388d:	c3                   	retq   

000000000080388e <opencons>:

int
opencons(void)
{
  80388e:	55                   	push   %rbp
  80388f:	48 89 e5             	mov    %rsp,%rbp
  803892:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803896:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80389a:	48 89 c7             	mov    %rax,%rdi
  80389d:	48 b8 01 23 80 00 00 	movabs $0x802301,%rax
  8038a4:	00 00 00 
  8038a7:	ff d0                	callq  *%rax
  8038a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038b0:	79 05                	jns    8038b7 <opencons+0x29>
		return r;
  8038b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038b5:	eb 5b                	jmp    803912 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8038b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038bb:	ba 07 04 00 00       	mov    $0x407,%edx
  8038c0:	48 89 c6             	mov    %rax,%rsi
  8038c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8038c8:	48 b8 fb 1a 80 00 00 	movabs $0x801afb,%rax
  8038cf:	00 00 00 
  8038d2:	ff d0                	callq  *%rax
  8038d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038db:	79 05                	jns    8038e2 <opencons+0x54>
		return r;
  8038dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e0:	eb 30                	jmp    803912 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8038e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038e6:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  8038ed:	00 00 00 
  8038f0:	8b 12                	mov    (%rdx),%edx
  8038f2:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8038f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038f8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8038ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803903:	48 89 c7             	mov    %rax,%rdi
  803906:	48 b8 b3 22 80 00 00 	movabs $0x8022b3,%rax
  80390d:	00 00 00 
  803910:	ff d0                	callq  *%rax
}
  803912:	c9                   	leaveq 
  803913:	c3                   	retq   

0000000000803914 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803914:	55                   	push   %rbp
  803915:	48 89 e5             	mov    %rsp,%rbp
  803918:	48 83 ec 30          	sub    $0x30,%rsp
  80391c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803920:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803924:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803928:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80392d:	75 07                	jne    803936 <devcons_read+0x22>
		return 0;
  80392f:	b8 00 00 00 00       	mov    $0x0,%eax
  803934:	eb 4b                	jmp    803981 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803936:	eb 0c                	jmp    803944 <devcons_read+0x30>
		sys_yield();
  803938:	48 b8 bd 1a 80 00 00 	movabs $0x801abd,%rax
  80393f:	00 00 00 
  803942:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803944:	48 b8 fd 19 80 00 00 	movabs $0x8019fd,%rax
  80394b:	00 00 00 
  80394e:	ff d0                	callq  *%rax
  803950:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803953:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803957:	74 df                	je     803938 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803959:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80395d:	79 05                	jns    803964 <devcons_read+0x50>
		return c;
  80395f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803962:	eb 1d                	jmp    803981 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803964:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803968:	75 07                	jne    803971 <devcons_read+0x5d>
		return 0;
  80396a:	b8 00 00 00 00       	mov    $0x0,%eax
  80396f:	eb 10                	jmp    803981 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803971:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803974:	89 c2                	mov    %eax,%edx
  803976:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80397a:	88 10                	mov    %dl,(%rax)
	return 1;
  80397c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803981:	c9                   	leaveq 
  803982:	c3                   	retq   

0000000000803983 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803983:	55                   	push   %rbp
  803984:	48 89 e5             	mov    %rsp,%rbp
  803987:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80398e:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803995:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80399c:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8039a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8039aa:	eb 76                	jmp    803a22 <devcons_write+0x9f>
		m = n - tot;
  8039ac:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8039b3:	89 c2                	mov    %eax,%edx
  8039b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039b8:	29 c2                	sub    %eax,%edx
  8039ba:	89 d0                	mov    %edx,%eax
  8039bc:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8039bf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039c2:	83 f8 7f             	cmp    $0x7f,%eax
  8039c5:	76 07                	jbe    8039ce <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8039c7:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8039ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039d1:	48 63 d0             	movslq %eax,%rdx
  8039d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039d7:	48 63 c8             	movslq %eax,%rcx
  8039da:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8039e1:	48 01 c1             	add    %rax,%rcx
  8039e4:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8039eb:	48 89 ce             	mov    %rcx,%rsi
  8039ee:	48 89 c7             	mov    %rax,%rdi
  8039f1:	48 b8 f0 14 80 00 00 	movabs $0x8014f0,%rax
  8039f8:	00 00 00 
  8039fb:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8039fd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a00:	48 63 d0             	movslq %eax,%rdx
  803a03:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803a0a:	48 89 d6             	mov    %rdx,%rsi
  803a0d:	48 89 c7             	mov    %rax,%rdi
  803a10:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  803a17:	00 00 00 
  803a1a:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803a1c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a1f:	01 45 fc             	add    %eax,-0x4(%rbp)
  803a22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a25:	48 98                	cltq   
  803a27:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803a2e:	0f 82 78 ff ff ff    	jb     8039ac <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803a34:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803a37:	c9                   	leaveq 
  803a38:	c3                   	retq   

0000000000803a39 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803a39:	55                   	push   %rbp
  803a3a:	48 89 e5             	mov    %rsp,%rbp
  803a3d:	48 83 ec 08          	sub    $0x8,%rsp
  803a41:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803a45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a4a:	c9                   	leaveq 
  803a4b:	c3                   	retq   

0000000000803a4c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803a4c:	55                   	push   %rbp
  803a4d:	48 89 e5             	mov    %rsp,%rbp
  803a50:	48 83 ec 10          	sub    $0x10,%rsp
  803a54:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a58:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803a5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a60:	48 be 8b 45 80 00 00 	movabs $0x80458b,%rsi
  803a67:	00 00 00 
  803a6a:	48 89 c7             	mov    %rax,%rdi
  803a6d:	48 b8 cc 11 80 00 00 	movabs $0x8011cc,%rax
  803a74:	00 00 00 
  803a77:	ff d0                	callq  *%rax
	return 0;
  803a79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a7e:	c9                   	leaveq 
  803a7f:	c3                   	retq   

0000000000803a80 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803a80:	55                   	push   %rbp
  803a81:	48 89 e5             	mov    %rsp,%rbp
  803a84:	48 83 ec 10          	sub    $0x10,%rsp
  803a88:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  803a8c:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803a93:	00 00 00 
  803a96:	48 8b 00             	mov    (%rax),%rax
  803a99:	48 85 c0             	test   %rax,%rax
  803a9c:	75 64                	jne    803b02 <set_pgfault_handler+0x82>
		// First time through!
		// LAB 4: Your code here.
		//envid_t eid = sys_getenvid();
		if(sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) 
  803a9e:	ba 07 00 00 00       	mov    $0x7,%edx
  803aa3:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803aa8:	bf 00 00 00 00       	mov    $0x0,%edi
  803aad:	48 b8 fb 1a 80 00 00 	movabs $0x801afb,%rax
  803ab4:	00 00 00 
  803ab7:	ff d0                	callq  *%rax
  803ab9:	85 c0                	test   %eax,%eax
  803abb:	74 2a                	je     803ae7 <set_pgfault_handler+0x67>
			panic("Allocation of space for UXSTACK failed\n");
  803abd:	48 ba 98 45 80 00 00 	movabs $0x804598,%rdx
  803ac4:	00 00 00 
  803ac7:	be 22 00 00 00       	mov    $0x22,%esi
  803acc:	48 bf c0 45 80 00 00 	movabs $0x8045c0,%rdi
  803ad3:	00 00 00 
  803ad6:	b8 00 00 00 00       	mov    $0x0,%eax
  803adb:	48 b9 de 03 80 00 00 	movabs $0x8003de,%rcx
  803ae2:	00 00 00 
  803ae5:	ff d1                	callq  *%rcx
		else
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  803ae7:	48 be 15 3b 80 00 00 	movabs $0x803b15,%rsi
  803aee:	00 00 00 
  803af1:	bf 00 00 00 00       	mov    $0x0,%edi
  803af6:	48 b8 85 1c 80 00 00 	movabs $0x801c85,%rax
  803afd:	00 00 00 
  803b00:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803b02:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803b09:	00 00 00 
  803b0c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803b10:	48 89 10             	mov    %rdx,(%rax)
}
  803b13:	c9                   	leaveq 
  803b14:	c3                   	retq   

0000000000803b15 <_pgfault_upcall>:
// Call the C page fault handler.
// function argument: pointer to UTF



movq  %rsp,%rdi                // passing the function argument in rdi
  803b15:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  803b18:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803b1f:	00 00 00 
call *%rax
  803b22:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
mov 152(%rsp), %r8
  803b24:	4c 8b 84 24 98 00 00 	mov    0x98(%rsp),%r8
  803b2b:	00 
mov 136(%rsp), %r9
  803b2c:	4c 8b 8c 24 88 00 00 	mov    0x88(%rsp),%r9
  803b33:	00 
sub $8, %r8
  803b34:	49 83 e8 08          	sub    $0x8,%r8
mov %r9, (%r8)
  803b38:	4d 89 08             	mov    %r9,(%r8)
mov %r8, 152(%rsp)
  803b3b:	4c 89 84 24 98 00 00 	mov    %r8,0x98(%rsp)
  803b42:	00 
add $16, %rsp
  803b43:	48 83 c4 10          	add    $0x10,%rsp

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
POPA_
  803b47:	4c 8b 3c 24          	mov    (%rsp),%r15
  803b4b:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803b50:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803b55:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803b5a:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803b5f:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803b64:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803b69:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803b6e:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803b73:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803b78:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803b7d:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803b82:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803b87:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803b8c:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803b91:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
		// LAB 4: Your code here.
add $8, %rsp
  803b95:	48 83 c4 08          	add    $0x8,%rsp
popf
  803b99:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
mov (%rsp), %rsp
  803b9a:	48 8b 24 24          	mov    (%rsp),%rsp
    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
ret
  803b9e:	c3                   	retq   

0000000000803b9f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803b9f:	55                   	push   %rbp
  803ba0:	48 89 e5             	mov    %rsp,%rbp
  803ba3:	48 83 ec 30          	sub    $0x30,%rsp
  803ba7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803bab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803baf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  803bb3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803bb8:	74 18                	je     803bd2 <ipc_recv+0x33>
  803bba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bbe:	48 89 c7             	mov    %rax,%rdi
  803bc1:	48 b8 24 1d 80 00 00 	movabs $0x801d24,%rax
  803bc8:	00 00 00 
  803bcb:	ff d0                	callq  *%rax
  803bcd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bd0:	eb 19                	jmp    803beb <ipc_recv+0x4c>
  803bd2:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  803bd9:	00 00 00 
  803bdc:	48 b8 24 1d 80 00 00 	movabs $0x801d24,%rax
  803be3:	00 00 00 
  803be6:	ff d0                	callq  *%rax
  803be8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  803beb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803bf0:	74 26                	je     803c18 <ipc_recv+0x79>
  803bf2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bf6:	75 15                	jne    803c0d <ipc_recv+0x6e>
  803bf8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803bff:	00 00 00 
  803c02:	48 8b 00             	mov    (%rax),%rax
  803c05:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  803c0b:	eb 05                	jmp    803c12 <ipc_recv+0x73>
  803c0d:	b8 00 00 00 00       	mov    $0x0,%eax
  803c12:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803c16:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  803c18:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803c1d:	74 26                	je     803c45 <ipc_recv+0xa6>
  803c1f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c23:	75 15                	jne    803c3a <ipc_recv+0x9b>
  803c25:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c2c:	00 00 00 
  803c2f:	48 8b 00             	mov    (%rax),%rax
  803c32:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  803c38:	eb 05                	jmp    803c3f <ipc_recv+0xa0>
  803c3a:	b8 00 00 00 00       	mov    $0x0,%eax
  803c3f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803c43:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  803c45:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c49:	75 15                	jne    803c60 <ipc_recv+0xc1>
  803c4b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c52:	00 00 00 
  803c55:	48 8b 00             	mov    (%rax),%rax
  803c58:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  803c5e:	eb 03                	jmp    803c63 <ipc_recv+0xc4>
  803c60:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803c63:	c9                   	leaveq 
  803c64:	c3                   	retq   

0000000000803c65 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803c65:	55                   	push   %rbp
  803c66:	48 89 e5             	mov    %rsp,%rbp
  803c69:	48 83 ec 30          	sub    $0x30,%rsp
  803c6d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c70:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803c73:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803c77:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  803c7a:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  803c81:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803c86:	75 10                	jne    803c98 <ipc_send+0x33>
  803c88:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803c8f:	00 00 00 
  803c92:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  803c96:	eb 62                	jmp    803cfa <ipc_send+0x95>
  803c98:	eb 60                	jmp    803cfa <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  803c9a:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803c9e:	74 30                	je     803cd0 <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  803ca0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ca3:	89 c1                	mov    %eax,%ecx
  803ca5:	48 ba ce 45 80 00 00 	movabs $0x8045ce,%rdx
  803cac:	00 00 00 
  803caf:	be 33 00 00 00       	mov    $0x33,%esi
  803cb4:	48 bf ea 45 80 00 00 	movabs $0x8045ea,%rdi
  803cbb:	00 00 00 
  803cbe:	b8 00 00 00 00       	mov    $0x0,%eax
  803cc3:	49 b8 de 03 80 00 00 	movabs $0x8003de,%r8
  803cca:	00 00 00 
  803ccd:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  803cd0:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803cd3:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803cd6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803cda:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cdd:	89 c7                	mov    %eax,%edi
  803cdf:	48 b8 cf 1c 80 00 00 	movabs $0x801ccf,%rax
  803ce6:	00 00 00 
  803ce9:	ff d0                	callq  *%rax
  803ceb:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  803cee:	48 b8 bd 1a 80 00 00 	movabs $0x801abd,%rax
  803cf5:	00 00 00 
  803cf8:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  803cfa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cfe:	75 9a                	jne    803c9a <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  803d00:	c9                   	leaveq 
  803d01:	c3                   	retq   

0000000000803d02 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803d02:	55                   	push   %rbp
  803d03:	48 89 e5             	mov    %rsp,%rbp
  803d06:	48 83 ec 14          	sub    $0x14,%rsp
  803d0a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803d0d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d14:	eb 5e                	jmp    803d74 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803d16:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803d1d:	00 00 00 
  803d20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d23:	48 63 d0             	movslq %eax,%rdx
  803d26:	48 89 d0             	mov    %rdx,%rax
  803d29:	48 c1 e0 03          	shl    $0x3,%rax
  803d2d:	48 01 d0             	add    %rdx,%rax
  803d30:	48 c1 e0 05          	shl    $0x5,%rax
  803d34:	48 01 c8             	add    %rcx,%rax
  803d37:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803d3d:	8b 00                	mov    (%rax),%eax
  803d3f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803d42:	75 2c                	jne    803d70 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803d44:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803d4b:	00 00 00 
  803d4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d51:	48 63 d0             	movslq %eax,%rdx
  803d54:	48 89 d0             	mov    %rdx,%rax
  803d57:	48 c1 e0 03          	shl    $0x3,%rax
  803d5b:	48 01 d0             	add    %rdx,%rax
  803d5e:	48 c1 e0 05          	shl    $0x5,%rax
  803d62:	48 01 c8             	add    %rcx,%rax
  803d65:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803d6b:	8b 40 08             	mov    0x8(%rax),%eax
  803d6e:	eb 12                	jmp    803d82 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803d70:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803d74:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803d7b:	7e 99                	jle    803d16 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803d7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d82:	c9                   	leaveq 
  803d83:	c3                   	retq   

0000000000803d84 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803d84:	55                   	push   %rbp
  803d85:	48 89 e5             	mov    %rsp,%rbp
  803d88:	48 83 ec 18          	sub    $0x18,%rsp
  803d8c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803d90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d94:	48 c1 e8 15          	shr    $0x15,%rax
  803d98:	48 89 c2             	mov    %rax,%rdx
  803d9b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803da2:	01 00 00 
  803da5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803da9:	83 e0 01             	and    $0x1,%eax
  803dac:	48 85 c0             	test   %rax,%rax
  803daf:	75 07                	jne    803db8 <pageref+0x34>
		return 0;
  803db1:	b8 00 00 00 00       	mov    $0x0,%eax
  803db6:	eb 53                	jmp    803e0b <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803db8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803dbc:	48 c1 e8 0c          	shr    $0xc,%rax
  803dc0:	48 89 c2             	mov    %rax,%rdx
  803dc3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803dca:	01 00 00 
  803dcd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803dd1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803dd5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dd9:	83 e0 01             	and    $0x1,%eax
  803ddc:	48 85 c0             	test   %rax,%rax
  803ddf:	75 07                	jne    803de8 <pageref+0x64>
		return 0;
  803de1:	b8 00 00 00 00       	mov    $0x0,%eax
  803de6:	eb 23                	jmp    803e0b <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803de8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dec:	48 c1 e8 0c          	shr    $0xc,%rax
  803df0:	48 89 c2             	mov    %rax,%rdx
  803df3:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803dfa:	00 00 00 
  803dfd:	48 c1 e2 04          	shl    $0x4,%rdx
  803e01:	48 01 d0             	add    %rdx,%rax
  803e04:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803e08:	0f b7 c0             	movzwl %ax,%eax
}
  803e0b:	c9                   	leaveq 
  803e0c:	c3                   	retq   
