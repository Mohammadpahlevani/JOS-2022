
obj/user/icode:     file format elf64-x86-64


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
  80003c:	e8 21 02 00 00       	callq  800262 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#define MOTD "/motd"

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	53                   	push   %rbx
  800048:	48 81 ec 28 02 00 00 	sub    $0x228,%rsp
  80004f:	89 bd dc fd ff ff    	mov    %edi,-0x224(%rbp)
  800055:	48 89 b5 d0 fd ff ff 	mov    %rsi,-0x230(%rbp)
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  80005c:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800063:	00 00 00 
  800066:	48 bb e0 42 80 00 00 	movabs $0x8042e0,%rbx
  80006d:	00 00 00 
  800070:	48 89 18             	mov    %rbx,(%rax)

	cprintf("icode startup\n");
  800073:	48 bf e6 42 80 00 00 	movabs $0x8042e6,%rdi
  80007a:	00 00 00 
  80007d:	b8 00 00 00 00       	mov    $0x0,%eax
  800082:	48 ba 4e 05 80 00 00 	movabs $0x80054e,%rdx
  800089:	00 00 00 
  80008c:	ff d2                	callq  *%rdx

	cprintf("icode: open /motd\n");
  80008e:	48 bf f5 42 80 00 00 	movabs $0x8042f5,%rdi
  800095:	00 00 00 
  800098:	b8 00 00 00 00       	mov    $0x0,%eax
  80009d:	48 ba 4e 05 80 00 00 	movabs $0x80054e,%rdx
  8000a4:	00 00 00 
  8000a7:	ff d2                	callq  *%rdx
	if ((fd = open(MOTD, O_RDONLY)) < 0)
  8000a9:	be 00 00 00 00       	mov    $0x0,%esi
  8000ae:	48 bf 08 43 80 00 00 	movabs $0x804308,%rdi
  8000b5:	00 00 00 
  8000b8:	48 b8 8d 26 80 00 00 	movabs $0x80268d,%rax
  8000bf:	00 00 00 
  8000c2:	ff d0                	callq  *%rax
  8000c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8000c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000cb:	79 30                	jns    8000fd <umain+0xba>
		panic("icode: open /motd: %e", fd);
  8000cd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000d0:	89 c1                	mov    %eax,%ecx
  8000d2:	48 ba 0e 43 80 00 00 	movabs $0x80430e,%rdx
  8000d9:	00 00 00 
  8000dc:	be 11 00 00 00       	mov    $0x11,%esi
  8000e1:	48 bf 24 43 80 00 00 	movabs $0x804324,%rdi
  8000e8:	00 00 00 
  8000eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f0:	49 b8 15 03 80 00 00 	movabs $0x800315,%r8
  8000f7:	00 00 00 
  8000fa:	41 ff d0             	callq  *%r8

	cprintf("icode: read /motd\n");
  8000fd:	48 bf 31 43 80 00 00 	movabs $0x804331,%rdi
  800104:	00 00 00 
  800107:	b8 00 00 00 00       	mov    $0x0,%eax
  80010c:	48 ba 4e 05 80 00 00 	movabs $0x80054e,%rdx
  800113:	00 00 00 
  800116:	ff d2                	callq  *%rdx
	while ((n = read(fd, buf, sizeof buf-1)) > 0) {
  800118:	eb 3a                	jmp    800154 <umain+0x111>
		cprintf("Writing MOTD\n");
  80011a:	48 bf 44 43 80 00 00 	movabs $0x804344,%rdi
  800121:	00 00 00 
  800124:	b8 00 00 00 00       	mov    $0x0,%eax
  800129:	48 ba 4e 05 80 00 00 	movabs $0x80054e,%rdx
  800130:	00 00 00 
  800133:	ff d2                	callq  *%rdx
		sys_cputs(buf, n);
  800135:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800138:	48 63 d0             	movslq %eax,%rdx
  80013b:	48 8d 85 e0 fd ff ff 	lea    -0x220(%rbp),%rax
  800142:	48 89 d6             	mov    %rdx,%rsi
  800145:	48 89 c7             	mov    %rax,%rdi
  800148:	48 b8 ea 18 80 00 00 	movabs $0x8018ea,%rax
  80014f:	00 00 00 
  800152:	ff d0                	callq  *%rax
	cprintf("icode: open /motd\n");
	if ((fd = open(MOTD, O_RDONLY)) < 0)
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
	while ((n = read(fd, buf, sizeof buf-1)) > 0) {
  800154:	48 8d 8d e0 fd ff ff 	lea    -0x220(%rbp),%rcx
  80015b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80015e:	ba 00 02 00 00       	mov    $0x200,%edx
  800163:	48 89 ce             	mov    %rcx,%rsi
  800166:	89 c7                	mov    %eax,%edi
  800168:	48 b8 b7 21 80 00 00 	movabs $0x8021b7,%rax
  80016f:	00 00 00 
  800172:	ff d0                	callq  *%rax
  800174:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800177:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80017b:	7f 9d                	jg     80011a <umain+0xd7>
		cprintf("Writing MOTD\n");
		sys_cputs(buf, n);
	}

	cprintf("icode: close /motd\n");
  80017d:	48 bf 52 43 80 00 00 	movabs $0x804352,%rdi
  800184:	00 00 00 
  800187:	b8 00 00 00 00       	mov    $0x0,%eax
  80018c:	48 ba 4e 05 80 00 00 	movabs $0x80054e,%rdx
  800193:	00 00 00 
  800196:	ff d2                	callq  *%rdx
	close(fd);
  800198:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80019b:	89 c7                	mov    %eax,%edi
  80019d:	48 b8 95 1f 80 00 00 	movabs $0x801f95,%rax
  8001a4:	00 00 00 
  8001a7:	ff d0                	callq  *%rax

	cprintf("icode: spawn /sbin/init\n");
  8001a9:	48 bf 66 43 80 00 00 	movabs $0x804366,%rdi
  8001b0:	00 00 00 
  8001b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b8:	48 ba 4e 05 80 00 00 	movabs $0x80054e,%rdx
  8001bf:	00 00 00 
  8001c2:	ff d2                	callq  *%rdx
	if ((r = spawnl("/sbin/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8001c4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001ca:	48 b9 7f 43 80 00 00 	movabs $0x80437f,%rcx
  8001d1:	00 00 00 
  8001d4:	48 ba 88 43 80 00 00 	movabs $0x804388,%rdx
  8001db:	00 00 00 
  8001de:	48 be 91 43 80 00 00 	movabs $0x804391,%rsi
  8001e5:	00 00 00 
  8001e8:	48 bf 96 43 80 00 00 	movabs $0x804396,%rdi
  8001ef:	00 00 00 
  8001f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8001f7:	49 b9 4b 2f 80 00 00 	movabs $0x802f4b,%r9
  8001fe:	00 00 00 
  800201:	41 ff d1             	callq  *%r9
  800204:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  800207:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80020b:	79 30                	jns    80023d <umain+0x1fa>
		panic("icode: spawn /sbin/init: %e", r);
  80020d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800210:	89 c1                	mov    %eax,%ecx
  800212:	48 ba a1 43 80 00 00 	movabs $0x8043a1,%rdx
  800219:	00 00 00 
  80021c:	be 1e 00 00 00       	mov    $0x1e,%esi
  800221:	48 bf 24 43 80 00 00 	movabs $0x804324,%rdi
  800228:	00 00 00 
  80022b:	b8 00 00 00 00       	mov    $0x0,%eax
  800230:	49 b8 15 03 80 00 00 	movabs $0x800315,%r8
  800237:	00 00 00 
  80023a:	41 ff d0             	callq  *%r8
	cprintf("icode: exiting\n");
  80023d:	48 bf bd 43 80 00 00 	movabs $0x8043bd,%rdi
  800244:	00 00 00 
  800247:	b8 00 00 00 00       	mov    $0x0,%eax
  80024c:	48 ba 4e 05 80 00 00 	movabs $0x80054e,%rdx
  800253:	00 00 00 
  800256:	ff d2                	callq  *%rdx
}
  800258:	48 81 c4 28 02 00 00 	add    $0x228,%rsp
  80025f:	5b                   	pop    %rbx
  800260:	5d                   	pop    %rbp
  800261:	c3                   	retq   

0000000000800262 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800262:	55                   	push   %rbp
  800263:	48 89 e5             	mov    %rsp,%rbp
  800266:	48 83 ec 10          	sub    $0x10,%rsp
  80026a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80026d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  800271:	48 b8 b6 19 80 00 00 	movabs $0x8019b6,%rax
  800278:	00 00 00 
  80027b:	ff d0                	callq  *%rax
  80027d:	48 98                	cltq   
  80027f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800284:	48 89 c2             	mov    %rax,%rdx
  800287:	48 89 d0             	mov    %rdx,%rax
  80028a:	48 c1 e0 03          	shl    $0x3,%rax
  80028e:	48 01 d0             	add    %rdx,%rax
  800291:	48 c1 e0 05          	shl    $0x5,%rax
  800295:	48 89 c2             	mov    %rax,%rdx
  800298:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80029f:	00 00 00 
  8002a2:	48 01 c2             	add    %rax,%rdx
  8002a5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8002ac:	00 00 00 
  8002af:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002b6:	7e 14                	jle    8002cc <libmain+0x6a>
		binaryname = argv[0];
  8002b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002bc:	48 8b 10             	mov    (%rax),%rdx
  8002bf:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002c6:	00 00 00 
  8002c9:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8002cc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002d3:	48 89 d6             	mov    %rdx,%rsi
  8002d6:	89 c7                	mov    %eax,%edi
  8002d8:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8002df:	00 00 00 
  8002e2:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8002e4:	48 b8 f2 02 80 00 00 	movabs $0x8002f2,%rax
  8002eb:	00 00 00 
  8002ee:	ff d0                	callq  *%rax
}
  8002f0:	c9                   	leaveq 
  8002f1:	c3                   	retq   

00000000008002f2 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002f2:	55                   	push   %rbp
  8002f3:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8002f6:	48 b8 e0 1f 80 00 00 	movabs $0x801fe0,%rax
  8002fd:	00 00 00 
  800300:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800302:	bf 00 00 00 00       	mov    $0x0,%edi
  800307:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  80030e:	00 00 00 
  800311:	ff d0                	callq  *%rax
}
  800313:	5d                   	pop    %rbp
  800314:	c3                   	retq   

0000000000800315 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800315:	55                   	push   %rbp
  800316:	48 89 e5             	mov    %rsp,%rbp
  800319:	53                   	push   %rbx
  80031a:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800321:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800328:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80032e:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800335:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80033c:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800343:	84 c0                	test   %al,%al
  800345:	74 23                	je     80036a <_panic+0x55>
  800347:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80034e:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800352:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800356:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80035a:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80035e:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800362:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800366:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80036a:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800371:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800378:	00 00 00 
  80037b:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800382:	00 00 00 
  800385:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800389:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800390:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800397:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80039e:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8003a5:	00 00 00 
  8003a8:	48 8b 18             	mov    (%rax),%rbx
  8003ab:	48 b8 b6 19 80 00 00 	movabs $0x8019b6,%rax
  8003b2:	00 00 00 
  8003b5:	ff d0                	callq  *%rax
  8003b7:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8003bd:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8003c4:	41 89 c8             	mov    %ecx,%r8d
  8003c7:	48 89 d1             	mov    %rdx,%rcx
  8003ca:	48 89 da             	mov    %rbx,%rdx
  8003cd:	89 c6                	mov    %eax,%esi
  8003cf:	48 bf d8 43 80 00 00 	movabs $0x8043d8,%rdi
  8003d6:	00 00 00 
  8003d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8003de:	49 b9 4e 05 80 00 00 	movabs $0x80054e,%r9
  8003e5:	00 00 00 
  8003e8:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003eb:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8003f2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003f9:	48 89 d6             	mov    %rdx,%rsi
  8003fc:	48 89 c7             	mov    %rax,%rdi
  8003ff:	48 b8 a2 04 80 00 00 	movabs $0x8004a2,%rax
  800406:	00 00 00 
  800409:	ff d0                	callq  *%rax
	cprintf("\n");
  80040b:	48 bf fb 43 80 00 00 	movabs $0x8043fb,%rdi
  800412:	00 00 00 
  800415:	b8 00 00 00 00       	mov    $0x0,%eax
  80041a:	48 ba 4e 05 80 00 00 	movabs $0x80054e,%rdx
  800421:	00 00 00 
  800424:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800426:	cc                   	int3   
  800427:	eb fd                	jmp    800426 <_panic+0x111>

0000000000800429 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800429:	55                   	push   %rbp
  80042a:	48 89 e5             	mov    %rsp,%rbp
  80042d:	48 83 ec 10          	sub    $0x10,%rsp
  800431:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800434:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800438:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80043c:	8b 00                	mov    (%rax),%eax
  80043e:	8d 48 01             	lea    0x1(%rax),%ecx
  800441:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800445:	89 0a                	mov    %ecx,(%rdx)
  800447:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80044a:	89 d1                	mov    %edx,%ecx
  80044c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800450:	48 98                	cltq   
  800452:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800456:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80045a:	8b 00                	mov    (%rax),%eax
  80045c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800461:	75 2c                	jne    80048f <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800463:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800467:	8b 00                	mov    (%rax),%eax
  800469:	48 98                	cltq   
  80046b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80046f:	48 83 c2 08          	add    $0x8,%rdx
  800473:	48 89 c6             	mov    %rax,%rsi
  800476:	48 89 d7             	mov    %rdx,%rdi
  800479:	48 b8 ea 18 80 00 00 	movabs $0x8018ea,%rax
  800480:	00 00 00 
  800483:	ff d0                	callq  *%rax
        b->idx = 0;
  800485:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800489:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80048f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800493:	8b 40 04             	mov    0x4(%rax),%eax
  800496:	8d 50 01             	lea    0x1(%rax),%edx
  800499:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80049d:	89 50 04             	mov    %edx,0x4(%rax)
}
  8004a0:	c9                   	leaveq 
  8004a1:	c3                   	retq   

00000000008004a2 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8004a2:	55                   	push   %rbp
  8004a3:	48 89 e5             	mov    %rsp,%rbp
  8004a6:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8004ad:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8004b4:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8004bb:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8004c2:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8004c9:	48 8b 0a             	mov    (%rdx),%rcx
  8004cc:	48 89 08             	mov    %rcx,(%rax)
  8004cf:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004d3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004d7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004db:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8004df:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8004e6:	00 00 00 
    b.cnt = 0;
  8004e9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8004f0:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8004f3:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8004fa:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800501:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800508:	48 89 c6             	mov    %rax,%rsi
  80050b:	48 bf 29 04 80 00 00 	movabs $0x800429,%rdi
  800512:	00 00 00 
  800515:	48 b8 01 09 80 00 00 	movabs $0x800901,%rax
  80051c:	00 00 00 
  80051f:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800521:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800527:	48 98                	cltq   
  800529:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800530:	48 83 c2 08          	add    $0x8,%rdx
  800534:	48 89 c6             	mov    %rax,%rsi
  800537:	48 89 d7             	mov    %rdx,%rdi
  80053a:	48 b8 ea 18 80 00 00 	movabs $0x8018ea,%rax
  800541:	00 00 00 
  800544:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800546:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80054c:	c9                   	leaveq 
  80054d:	c3                   	retq   

000000000080054e <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80054e:	55                   	push   %rbp
  80054f:	48 89 e5             	mov    %rsp,%rbp
  800552:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800559:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800560:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800567:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80056e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800575:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80057c:	84 c0                	test   %al,%al
  80057e:	74 20                	je     8005a0 <cprintf+0x52>
  800580:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800584:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800588:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80058c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800590:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800594:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800598:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80059c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8005a0:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8005a7:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8005ae:	00 00 00 
  8005b1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8005b8:	00 00 00 
  8005bb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005bf:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8005c6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8005cd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8005d4:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8005db:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8005e2:	48 8b 0a             	mov    (%rdx),%rcx
  8005e5:	48 89 08             	mov    %rcx,(%rax)
  8005e8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005ec:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005f0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005f4:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8005f8:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8005ff:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800606:	48 89 d6             	mov    %rdx,%rsi
  800609:	48 89 c7             	mov    %rax,%rdi
  80060c:	48 b8 a2 04 80 00 00 	movabs $0x8004a2,%rax
  800613:	00 00 00 
  800616:	ff d0                	callq  *%rax
  800618:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80061e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800624:	c9                   	leaveq 
  800625:	c3                   	retq   

0000000000800626 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800626:	55                   	push   %rbp
  800627:	48 89 e5             	mov    %rsp,%rbp
  80062a:	53                   	push   %rbx
  80062b:	48 83 ec 38          	sub    $0x38,%rsp
  80062f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800633:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800637:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80063b:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80063e:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800642:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800646:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800649:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80064d:	77 3b                	ja     80068a <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80064f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800652:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800656:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800659:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80065d:	ba 00 00 00 00       	mov    $0x0,%edx
  800662:	48 f7 f3             	div    %rbx
  800665:	48 89 c2             	mov    %rax,%rdx
  800668:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80066b:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80066e:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800672:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800676:	41 89 f9             	mov    %edi,%r9d
  800679:	48 89 c7             	mov    %rax,%rdi
  80067c:	48 b8 26 06 80 00 00 	movabs $0x800626,%rax
  800683:	00 00 00 
  800686:	ff d0                	callq  *%rax
  800688:	eb 1e                	jmp    8006a8 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80068a:	eb 12                	jmp    80069e <printnum+0x78>
			putch(padc, putdat);
  80068c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800690:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800693:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800697:	48 89 ce             	mov    %rcx,%rsi
  80069a:	89 d7                	mov    %edx,%edi
  80069c:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80069e:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8006a2:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8006a6:	7f e4                	jg     80068c <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006a8:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8006ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006af:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b4:	48 f7 f1             	div    %rcx
  8006b7:	48 89 d0             	mov    %rdx,%rax
  8006ba:	48 ba f0 45 80 00 00 	movabs $0x8045f0,%rdx
  8006c1:	00 00 00 
  8006c4:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8006c8:	0f be d0             	movsbl %al,%edx
  8006cb:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8006cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d3:	48 89 ce             	mov    %rcx,%rsi
  8006d6:	89 d7                	mov    %edx,%edi
  8006d8:	ff d0                	callq  *%rax
}
  8006da:	48 83 c4 38          	add    $0x38,%rsp
  8006de:	5b                   	pop    %rbx
  8006df:	5d                   	pop    %rbp
  8006e0:	c3                   	retq   

00000000008006e1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006e1:	55                   	push   %rbp
  8006e2:	48 89 e5             	mov    %rsp,%rbp
  8006e5:	48 83 ec 1c          	sub    $0x1c,%rsp
  8006e9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006ed:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8006f0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006f4:	7e 52                	jle    800748 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8006f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fa:	8b 00                	mov    (%rax),%eax
  8006fc:	83 f8 30             	cmp    $0x30,%eax
  8006ff:	73 24                	jae    800725 <getuint+0x44>
  800701:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800705:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800709:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070d:	8b 00                	mov    (%rax),%eax
  80070f:	89 c0                	mov    %eax,%eax
  800711:	48 01 d0             	add    %rdx,%rax
  800714:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800718:	8b 12                	mov    (%rdx),%edx
  80071a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80071d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800721:	89 0a                	mov    %ecx,(%rdx)
  800723:	eb 17                	jmp    80073c <getuint+0x5b>
  800725:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800729:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80072d:	48 89 d0             	mov    %rdx,%rax
  800730:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800734:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800738:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80073c:	48 8b 00             	mov    (%rax),%rax
  80073f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800743:	e9 a3 00 00 00       	jmpq   8007eb <getuint+0x10a>
	else if (lflag)
  800748:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80074c:	74 4f                	je     80079d <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80074e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800752:	8b 00                	mov    (%rax),%eax
  800754:	83 f8 30             	cmp    $0x30,%eax
  800757:	73 24                	jae    80077d <getuint+0x9c>
  800759:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800761:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800765:	8b 00                	mov    (%rax),%eax
  800767:	89 c0                	mov    %eax,%eax
  800769:	48 01 d0             	add    %rdx,%rax
  80076c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800770:	8b 12                	mov    (%rdx),%edx
  800772:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800775:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800779:	89 0a                	mov    %ecx,(%rdx)
  80077b:	eb 17                	jmp    800794 <getuint+0xb3>
  80077d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800781:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800785:	48 89 d0             	mov    %rdx,%rax
  800788:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80078c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800790:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800794:	48 8b 00             	mov    (%rax),%rax
  800797:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80079b:	eb 4e                	jmp    8007eb <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80079d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a1:	8b 00                	mov    (%rax),%eax
  8007a3:	83 f8 30             	cmp    $0x30,%eax
  8007a6:	73 24                	jae    8007cc <getuint+0xeb>
  8007a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ac:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b4:	8b 00                	mov    (%rax),%eax
  8007b6:	89 c0                	mov    %eax,%eax
  8007b8:	48 01 d0             	add    %rdx,%rax
  8007bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007bf:	8b 12                	mov    (%rdx),%edx
  8007c1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c8:	89 0a                	mov    %ecx,(%rdx)
  8007ca:	eb 17                	jmp    8007e3 <getuint+0x102>
  8007cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007d4:	48 89 d0             	mov    %rdx,%rax
  8007d7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007df:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007e3:	8b 00                	mov    (%rax),%eax
  8007e5:	89 c0                	mov    %eax,%eax
  8007e7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007ef:	c9                   	leaveq 
  8007f0:	c3                   	retq   

00000000008007f1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007f1:	55                   	push   %rbp
  8007f2:	48 89 e5             	mov    %rsp,%rbp
  8007f5:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007f9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007fd:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800800:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800804:	7e 52                	jle    800858 <getint+0x67>
		x=va_arg(*ap, long long);
  800806:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080a:	8b 00                	mov    (%rax),%eax
  80080c:	83 f8 30             	cmp    $0x30,%eax
  80080f:	73 24                	jae    800835 <getint+0x44>
  800811:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800815:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800819:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081d:	8b 00                	mov    (%rax),%eax
  80081f:	89 c0                	mov    %eax,%eax
  800821:	48 01 d0             	add    %rdx,%rax
  800824:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800828:	8b 12                	mov    (%rdx),%edx
  80082a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80082d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800831:	89 0a                	mov    %ecx,(%rdx)
  800833:	eb 17                	jmp    80084c <getint+0x5b>
  800835:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800839:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80083d:	48 89 d0             	mov    %rdx,%rax
  800840:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800844:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800848:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80084c:	48 8b 00             	mov    (%rax),%rax
  80084f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800853:	e9 a3 00 00 00       	jmpq   8008fb <getint+0x10a>
	else if (lflag)
  800858:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80085c:	74 4f                	je     8008ad <getint+0xbc>
		x=va_arg(*ap, long);
  80085e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800862:	8b 00                	mov    (%rax),%eax
  800864:	83 f8 30             	cmp    $0x30,%eax
  800867:	73 24                	jae    80088d <getint+0x9c>
  800869:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800871:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800875:	8b 00                	mov    (%rax),%eax
  800877:	89 c0                	mov    %eax,%eax
  800879:	48 01 d0             	add    %rdx,%rax
  80087c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800880:	8b 12                	mov    (%rdx),%edx
  800882:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800885:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800889:	89 0a                	mov    %ecx,(%rdx)
  80088b:	eb 17                	jmp    8008a4 <getint+0xb3>
  80088d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800891:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800895:	48 89 d0             	mov    %rdx,%rax
  800898:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80089c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008a4:	48 8b 00             	mov    (%rax),%rax
  8008a7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008ab:	eb 4e                	jmp    8008fb <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8008ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b1:	8b 00                	mov    (%rax),%eax
  8008b3:	83 f8 30             	cmp    $0x30,%eax
  8008b6:	73 24                	jae    8008dc <getint+0xeb>
  8008b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008bc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c4:	8b 00                	mov    (%rax),%eax
  8008c6:	89 c0                	mov    %eax,%eax
  8008c8:	48 01 d0             	add    %rdx,%rax
  8008cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008cf:	8b 12                	mov    (%rdx),%edx
  8008d1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d8:	89 0a                	mov    %ecx,(%rdx)
  8008da:	eb 17                	jmp    8008f3 <getint+0x102>
  8008dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008e4:	48 89 d0             	mov    %rdx,%rax
  8008e7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ef:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008f3:	8b 00                	mov    (%rax),%eax
  8008f5:	48 98                	cltq   
  8008f7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008ff:	c9                   	leaveq 
  800900:	c3                   	retq   

0000000000800901 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800901:	55                   	push   %rbp
  800902:	48 89 e5             	mov    %rsp,%rbp
  800905:	41 54                	push   %r12
  800907:	53                   	push   %rbx
  800908:	48 83 ec 60          	sub    $0x60,%rsp
  80090c:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800910:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800914:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800918:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80091c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800920:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800924:	48 8b 0a             	mov    (%rdx),%rcx
  800927:	48 89 08             	mov    %rcx,(%rax)
  80092a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80092e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800932:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800936:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80093a:	eb 17                	jmp    800953 <vprintfmt+0x52>
			if (ch == '\0')
  80093c:	85 db                	test   %ebx,%ebx
  80093e:	0f 84 cc 04 00 00    	je     800e10 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800944:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800948:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80094c:	48 89 d6             	mov    %rdx,%rsi
  80094f:	89 df                	mov    %ebx,%edi
  800951:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800953:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800957:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80095b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80095f:	0f b6 00             	movzbl (%rax),%eax
  800962:	0f b6 d8             	movzbl %al,%ebx
  800965:	83 fb 25             	cmp    $0x25,%ebx
  800968:	75 d2                	jne    80093c <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80096a:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80096e:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800975:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80097c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800983:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80098a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80098e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800992:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800996:	0f b6 00             	movzbl (%rax),%eax
  800999:	0f b6 d8             	movzbl %al,%ebx
  80099c:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80099f:	83 f8 55             	cmp    $0x55,%eax
  8009a2:	0f 87 34 04 00 00    	ja     800ddc <vprintfmt+0x4db>
  8009a8:	89 c0                	mov    %eax,%eax
  8009aa:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8009b1:	00 
  8009b2:	48 b8 18 46 80 00 00 	movabs $0x804618,%rax
  8009b9:	00 00 00 
  8009bc:	48 01 d0             	add    %rdx,%rax
  8009bf:	48 8b 00             	mov    (%rax),%rax
  8009c2:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8009c4:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8009c8:	eb c0                	jmp    80098a <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009ca:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8009ce:	eb ba                	jmp    80098a <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009d0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8009d7:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8009da:	89 d0                	mov    %edx,%eax
  8009dc:	c1 e0 02             	shl    $0x2,%eax
  8009df:	01 d0                	add    %edx,%eax
  8009e1:	01 c0                	add    %eax,%eax
  8009e3:	01 d8                	add    %ebx,%eax
  8009e5:	83 e8 30             	sub    $0x30,%eax
  8009e8:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8009eb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009ef:	0f b6 00             	movzbl (%rax),%eax
  8009f2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009f5:	83 fb 2f             	cmp    $0x2f,%ebx
  8009f8:	7e 0c                	jle    800a06 <vprintfmt+0x105>
  8009fa:	83 fb 39             	cmp    $0x39,%ebx
  8009fd:	7f 07                	jg     800a06 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009ff:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a04:	eb d1                	jmp    8009d7 <vprintfmt+0xd6>
			goto process_precision;
  800a06:	eb 58                	jmp    800a60 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800a08:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a0b:	83 f8 30             	cmp    $0x30,%eax
  800a0e:	73 17                	jae    800a27 <vprintfmt+0x126>
  800a10:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a14:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a17:	89 c0                	mov    %eax,%eax
  800a19:	48 01 d0             	add    %rdx,%rax
  800a1c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a1f:	83 c2 08             	add    $0x8,%edx
  800a22:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a25:	eb 0f                	jmp    800a36 <vprintfmt+0x135>
  800a27:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a2b:	48 89 d0             	mov    %rdx,%rax
  800a2e:	48 83 c2 08          	add    $0x8,%rdx
  800a32:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a36:	8b 00                	mov    (%rax),%eax
  800a38:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a3b:	eb 23                	jmp    800a60 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800a3d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a41:	79 0c                	jns    800a4f <vprintfmt+0x14e>
				width = 0;
  800a43:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a4a:	e9 3b ff ff ff       	jmpq   80098a <vprintfmt+0x89>
  800a4f:	e9 36 ff ff ff       	jmpq   80098a <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800a54:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a5b:	e9 2a ff ff ff       	jmpq   80098a <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800a60:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a64:	79 12                	jns    800a78 <vprintfmt+0x177>
				width = precision, precision = -1;
  800a66:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a69:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a6c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a73:	e9 12 ff ff ff       	jmpq   80098a <vprintfmt+0x89>
  800a78:	e9 0d ff ff ff       	jmpq   80098a <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a7d:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a81:	e9 04 ff ff ff       	jmpq   80098a <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a86:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a89:	83 f8 30             	cmp    $0x30,%eax
  800a8c:	73 17                	jae    800aa5 <vprintfmt+0x1a4>
  800a8e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a92:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a95:	89 c0                	mov    %eax,%eax
  800a97:	48 01 d0             	add    %rdx,%rax
  800a9a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a9d:	83 c2 08             	add    $0x8,%edx
  800aa0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800aa3:	eb 0f                	jmp    800ab4 <vprintfmt+0x1b3>
  800aa5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aa9:	48 89 d0             	mov    %rdx,%rax
  800aac:	48 83 c2 08          	add    $0x8,%rdx
  800ab0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ab4:	8b 10                	mov    (%rax),%edx
  800ab6:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800aba:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800abe:	48 89 ce             	mov    %rcx,%rsi
  800ac1:	89 d7                	mov    %edx,%edi
  800ac3:	ff d0                	callq  *%rax
			break;
  800ac5:	e9 40 03 00 00       	jmpq   800e0a <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800aca:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800acd:	83 f8 30             	cmp    $0x30,%eax
  800ad0:	73 17                	jae    800ae9 <vprintfmt+0x1e8>
  800ad2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ad6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad9:	89 c0                	mov    %eax,%eax
  800adb:	48 01 d0             	add    %rdx,%rax
  800ade:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ae1:	83 c2 08             	add    $0x8,%edx
  800ae4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ae7:	eb 0f                	jmp    800af8 <vprintfmt+0x1f7>
  800ae9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aed:	48 89 d0             	mov    %rdx,%rax
  800af0:	48 83 c2 08          	add    $0x8,%rdx
  800af4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800af8:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800afa:	85 db                	test   %ebx,%ebx
  800afc:	79 02                	jns    800b00 <vprintfmt+0x1ff>
				err = -err;
  800afe:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b00:	83 fb 15             	cmp    $0x15,%ebx
  800b03:	7f 16                	jg     800b1b <vprintfmt+0x21a>
  800b05:	48 b8 40 45 80 00 00 	movabs $0x804540,%rax
  800b0c:	00 00 00 
  800b0f:	48 63 d3             	movslq %ebx,%rdx
  800b12:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b16:	4d 85 e4             	test   %r12,%r12
  800b19:	75 2e                	jne    800b49 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800b1b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b1f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b23:	89 d9                	mov    %ebx,%ecx
  800b25:	48 ba 01 46 80 00 00 	movabs $0x804601,%rdx
  800b2c:	00 00 00 
  800b2f:	48 89 c7             	mov    %rax,%rdi
  800b32:	b8 00 00 00 00       	mov    $0x0,%eax
  800b37:	49 b8 19 0e 80 00 00 	movabs $0x800e19,%r8
  800b3e:	00 00 00 
  800b41:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b44:	e9 c1 02 00 00       	jmpq   800e0a <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b49:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b4d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b51:	4c 89 e1             	mov    %r12,%rcx
  800b54:	48 ba 0a 46 80 00 00 	movabs $0x80460a,%rdx
  800b5b:	00 00 00 
  800b5e:	48 89 c7             	mov    %rax,%rdi
  800b61:	b8 00 00 00 00       	mov    $0x0,%eax
  800b66:	49 b8 19 0e 80 00 00 	movabs $0x800e19,%r8
  800b6d:	00 00 00 
  800b70:	41 ff d0             	callq  *%r8
			break;
  800b73:	e9 92 02 00 00       	jmpq   800e0a <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b78:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b7b:	83 f8 30             	cmp    $0x30,%eax
  800b7e:	73 17                	jae    800b97 <vprintfmt+0x296>
  800b80:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b84:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b87:	89 c0                	mov    %eax,%eax
  800b89:	48 01 d0             	add    %rdx,%rax
  800b8c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b8f:	83 c2 08             	add    $0x8,%edx
  800b92:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b95:	eb 0f                	jmp    800ba6 <vprintfmt+0x2a5>
  800b97:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b9b:	48 89 d0             	mov    %rdx,%rax
  800b9e:	48 83 c2 08          	add    $0x8,%rdx
  800ba2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ba6:	4c 8b 20             	mov    (%rax),%r12
  800ba9:	4d 85 e4             	test   %r12,%r12
  800bac:	75 0a                	jne    800bb8 <vprintfmt+0x2b7>
				p = "(null)";
  800bae:	49 bc 0d 46 80 00 00 	movabs $0x80460d,%r12
  800bb5:	00 00 00 
			if (width > 0 && padc != '-')
  800bb8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bbc:	7e 3f                	jle    800bfd <vprintfmt+0x2fc>
  800bbe:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800bc2:	74 39                	je     800bfd <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bc4:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800bc7:	48 98                	cltq   
  800bc9:	48 89 c6             	mov    %rax,%rsi
  800bcc:	4c 89 e7             	mov    %r12,%rdi
  800bcf:	48 b8 c5 10 80 00 00 	movabs $0x8010c5,%rax
  800bd6:	00 00 00 
  800bd9:	ff d0                	callq  *%rax
  800bdb:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800bde:	eb 17                	jmp    800bf7 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800be0:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800be4:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800be8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bec:	48 89 ce             	mov    %rcx,%rsi
  800bef:	89 d7                	mov    %edx,%edi
  800bf1:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bf3:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bf7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bfb:	7f e3                	jg     800be0 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bfd:	eb 37                	jmp    800c36 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800bff:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800c03:	74 1e                	je     800c23 <vprintfmt+0x322>
  800c05:	83 fb 1f             	cmp    $0x1f,%ebx
  800c08:	7e 05                	jle    800c0f <vprintfmt+0x30e>
  800c0a:	83 fb 7e             	cmp    $0x7e,%ebx
  800c0d:	7e 14                	jle    800c23 <vprintfmt+0x322>
					putch('?', putdat);
  800c0f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c13:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c17:	48 89 d6             	mov    %rdx,%rsi
  800c1a:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c1f:	ff d0                	callq  *%rax
  800c21:	eb 0f                	jmp    800c32 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800c23:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c27:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c2b:	48 89 d6             	mov    %rdx,%rsi
  800c2e:	89 df                	mov    %ebx,%edi
  800c30:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c32:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c36:	4c 89 e0             	mov    %r12,%rax
  800c39:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800c3d:	0f b6 00             	movzbl (%rax),%eax
  800c40:	0f be d8             	movsbl %al,%ebx
  800c43:	85 db                	test   %ebx,%ebx
  800c45:	74 10                	je     800c57 <vprintfmt+0x356>
  800c47:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c4b:	78 b2                	js     800bff <vprintfmt+0x2fe>
  800c4d:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c51:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c55:	79 a8                	jns    800bff <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c57:	eb 16                	jmp    800c6f <vprintfmt+0x36e>
				putch(' ', putdat);
  800c59:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c5d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c61:	48 89 d6             	mov    %rdx,%rsi
  800c64:	bf 20 00 00 00       	mov    $0x20,%edi
  800c69:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c6b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c6f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c73:	7f e4                	jg     800c59 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800c75:	e9 90 01 00 00       	jmpq   800e0a <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c7a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c7e:	be 03 00 00 00       	mov    $0x3,%esi
  800c83:	48 89 c7             	mov    %rax,%rdi
  800c86:	48 b8 f1 07 80 00 00 	movabs $0x8007f1,%rax
  800c8d:	00 00 00 
  800c90:	ff d0                	callq  *%rax
  800c92:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c9a:	48 85 c0             	test   %rax,%rax
  800c9d:	79 1d                	jns    800cbc <vprintfmt+0x3bb>
				putch('-', putdat);
  800c9f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ca3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ca7:	48 89 d6             	mov    %rdx,%rsi
  800caa:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800caf:	ff d0                	callq  *%rax
				num = -(long long) num;
  800cb1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cb5:	48 f7 d8             	neg    %rax
  800cb8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800cbc:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800cc3:	e9 d5 00 00 00       	jmpq   800d9d <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800cc8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ccc:	be 03 00 00 00       	mov    $0x3,%esi
  800cd1:	48 89 c7             	mov    %rax,%rdi
  800cd4:	48 b8 e1 06 80 00 00 	movabs $0x8006e1,%rax
  800cdb:	00 00 00 
  800cde:	ff d0                	callq  *%rax
  800ce0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ce4:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ceb:	e9 ad 00 00 00       	jmpq   800d9d <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  800cf0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cf4:	be 03 00 00 00       	mov    $0x3,%esi
  800cf9:	48 89 c7             	mov    %rax,%rdi
  800cfc:	48 b8 e1 06 80 00 00 	movabs $0x8006e1,%rax
  800d03:	00 00 00 
  800d06:	ff d0                	callq  *%rax
  800d08:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  800d0c:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  800d13:	e9 85 00 00 00       	jmpq   800d9d <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  800d18:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d1c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d20:	48 89 d6             	mov    %rdx,%rsi
  800d23:	bf 30 00 00 00       	mov    $0x30,%edi
  800d28:	ff d0                	callq  *%rax
			putch('x', putdat);
  800d2a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d2e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d32:	48 89 d6             	mov    %rdx,%rsi
  800d35:	bf 78 00 00 00       	mov    $0x78,%edi
  800d3a:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d3c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d3f:	83 f8 30             	cmp    $0x30,%eax
  800d42:	73 17                	jae    800d5b <vprintfmt+0x45a>
  800d44:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d48:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d4b:	89 c0                	mov    %eax,%eax
  800d4d:	48 01 d0             	add    %rdx,%rax
  800d50:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d53:	83 c2 08             	add    $0x8,%edx
  800d56:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d59:	eb 0f                	jmp    800d6a <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800d5b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d5f:	48 89 d0             	mov    %rdx,%rax
  800d62:	48 83 c2 08          	add    $0x8,%rdx
  800d66:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d6a:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d6d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d71:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d78:	eb 23                	jmp    800d9d <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d7a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d7e:	be 03 00 00 00       	mov    $0x3,%esi
  800d83:	48 89 c7             	mov    %rax,%rdi
  800d86:	48 b8 e1 06 80 00 00 	movabs $0x8006e1,%rax
  800d8d:	00 00 00 
  800d90:	ff d0                	callq  *%rax
  800d92:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d96:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d9d:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800da2:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800da5:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800da8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800dac:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800db0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800db4:	45 89 c1             	mov    %r8d,%r9d
  800db7:	41 89 f8             	mov    %edi,%r8d
  800dba:	48 89 c7             	mov    %rax,%rdi
  800dbd:	48 b8 26 06 80 00 00 	movabs $0x800626,%rax
  800dc4:	00 00 00 
  800dc7:	ff d0                	callq  *%rax
			break;
  800dc9:	eb 3f                	jmp    800e0a <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800dcb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dcf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dd3:	48 89 d6             	mov    %rdx,%rsi
  800dd6:	89 df                	mov    %ebx,%edi
  800dd8:	ff d0                	callq  *%rax
			break;
  800dda:	eb 2e                	jmp    800e0a <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ddc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800de0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de4:	48 89 d6             	mov    %rdx,%rsi
  800de7:	bf 25 00 00 00       	mov    $0x25,%edi
  800dec:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800dee:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800df3:	eb 05                	jmp    800dfa <vprintfmt+0x4f9>
  800df5:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800dfa:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800dfe:	48 83 e8 01          	sub    $0x1,%rax
  800e02:	0f b6 00             	movzbl (%rax),%eax
  800e05:	3c 25                	cmp    $0x25,%al
  800e07:	75 ec                	jne    800df5 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800e09:	90                   	nop
		}
	}
  800e0a:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e0b:	e9 43 fb ff ff       	jmpq   800953 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800e10:	48 83 c4 60          	add    $0x60,%rsp
  800e14:	5b                   	pop    %rbx
  800e15:	41 5c                	pop    %r12
  800e17:	5d                   	pop    %rbp
  800e18:	c3                   	retq   

0000000000800e19 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e19:	55                   	push   %rbp
  800e1a:	48 89 e5             	mov    %rsp,%rbp
  800e1d:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e24:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e2b:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e32:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e39:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e40:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e47:	84 c0                	test   %al,%al
  800e49:	74 20                	je     800e6b <printfmt+0x52>
  800e4b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e4f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e53:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e57:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e5b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e5f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e63:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e67:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e6b:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e72:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e79:	00 00 00 
  800e7c:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e83:	00 00 00 
  800e86:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e8a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e91:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e98:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e9f:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800ea6:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800ead:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800eb4:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800ebb:	48 89 c7             	mov    %rax,%rdi
  800ebe:	48 b8 01 09 80 00 00 	movabs $0x800901,%rax
  800ec5:	00 00 00 
  800ec8:	ff d0                	callq  *%rax
	va_end(ap);
}
  800eca:	c9                   	leaveq 
  800ecb:	c3                   	retq   

0000000000800ecc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ecc:	55                   	push   %rbp
  800ecd:	48 89 e5             	mov    %rsp,%rbp
  800ed0:	48 83 ec 10          	sub    $0x10,%rsp
  800ed4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ed7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800edb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800edf:	8b 40 10             	mov    0x10(%rax),%eax
  800ee2:	8d 50 01             	lea    0x1(%rax),%edx
  800ee5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ee9:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800eec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ef0:	48 8b 10             	mov    (%rax),%rdx
  800ef3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ef7:	48 8b 40 08          	mov    0x8(%rax),%rax
  800efb:	48 39 c2             	cmp    %rax,%rdx
  800efe:	73 17                	jae    800f17 <sprintputch+0x4b>
		*b->buf++ = ch;
  800f00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f04:	48 8b 00             	mov    (%rax),%rax
  800f07:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800f0b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f0f:	48 89 0a             	mov    %rcx,(%rdx)
  800f12:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f15:	88 10                	mov    %dl,(%rax)
}
  800f17:	c9                   	leaveq 
  800f18:	c3                   	retq   

0000000000800f19 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f19:	55                   	push   %rbp
  800f1a:	48 89 e5             	mov    %rsp,%rbp
  800f1d:	48 83 ec 50          	sub    $0x50,%rsp
  800f21:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f25:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f28:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f2c:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f30:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f34:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800f38:	48 8b 0a             	mov    (%rdx),%rcx
  800f3b:	48 89 08             	mov    %rcx,(%rax)
  800f3e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f42:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f46:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f4a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f4e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f52:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f56:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f59:	48 98                	cltq   
  800f5b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800f5f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f63:	48 01 d0             	add    %rdx,%rax
  800f66:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f6a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f71:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f76:	74 06                	je     800f7e <vsnprintf+0x65>
  800f78:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f7c:	7f 07                	jg     800f85 <vsnprintf+0x6c>
		return -E_INVAL;
  800f7e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f83:	eb 2f                	jmp    800fb4 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f85:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f89:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f8d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f91:	48 89 c6             	mov    %rax,%rsi
  800f94:	48 bf cc 0e 80 00 00 	movabs $0x800ecc,%rdi
  800f9b:	00 00 00 
  800f9e:	48 b8 01 09 80 00 00 	movabs $0x800901,%rax
  800fa5:	00 00 00 
  800fa8:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800faa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800fae:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800fb1:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800fb4:	c9                   	leaveq 
  800fb5:	c3                   	retq   

0000000000800fb6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fb6:	55                   	push   %rbp
  800fb7:	48 89 e5             	mov    %rsp,%rbp
  800fba:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800fc1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800fc8:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800fce:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800fd5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800fdc:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800fe3:	84 c0                	test   %al,%al
  800fe5:	74 20                	je     801007 <snprintf+0x51>
  800fe7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800feb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800fef:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ff3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ff7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ffb:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fff:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801003:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801007:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80100e:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801015:	00 00 00 
  801018:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80101f:	00 00 00 
  801022:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801026:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80102d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801034:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80103b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801042:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801049:	48 8b 0a             	mov    (%rdx),%rcx
  80104c:	48 89 08             	mov    %rcx,(%rax)
  80104f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801053:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801057:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80105b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80105f:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801066:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80106d:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801073:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80107a:	48 89 c7             	mov    %rax,%rdi
  80107d:	48 b8 19 0f 80 00 00 	movabs $0x800f19,%rax
  801084:	00 00 00 
  801087:	ff d0                	callq  *%rax
  801089:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80108f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801095:	c9                   	leaveq 
  801096:	c3                   	retq   

0000000000801097 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801097:	55                   	push   %rbp
  801098:	48 89 e5             	mov    %rsp,%rbp
  80109b:	48 83 ec 18          	sub    $0x18,%rsp
  80109f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8010a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010aa:	eb 09                	jmp    8010b5 <strlen+0x1e>
		n++;
  8010ac:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010b0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b9:	0f b6 00             	movzbl (%rax),%eax
  8010bc:	84 c0                	test   %al,%al
  8010be:	75 ec                	jne    8010ac <strlen+0x15>
		n++;
	return n;
  8010c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010c3:	c9                   	leaveq 
  8010c4:	c3                   	retq   

00000000008010c5 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8010c5:	55                   	push   %rbp
  8010c6:	48 89 e5             	mov    %rsp,%rbp
  8010c9:	48 83 ec 20          	sub    $0x20,%rsp
  8010cd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010d1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010dc:	eb 0e                	jmp    8010ec <strnlen+0x27>
		n++;
  8010de:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010e2:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010e7:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8010ec:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8010f1:	74 0b                	je     8010fe <strnlen+0x39>
  8010f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f7:	0f b6 00             	movzbl (%rax),%eax
  8010fa:	84 c0                	test   %al,%al
  8010fc:	75 e0                	jne    8010de <strnlen+0x19>
		n++;
	return n;
  8010fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801101:	c9                   	leaveq 
  801102:	c3                   	retq   

0000000000801103 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801103:	55                   	push   %rbp
  801104:	48 89 e5             	mov    %rsp,%rbp
  801107:	48 83 ec 20          	sub    $0x20,%rsp
  80110b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80110f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801113:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801117:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80111b:	90                   	nop
  80111c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801120:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801124:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801128:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80112c:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801130:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801134:	0f b6 12             	movzbl (%rdx),%edx
  801137:	88 10                	mov    %dl,(%rax)
  801139:	0f b6 00             	movzbl (%rax),%eax
  80113c:	84 c0                	test   %al,%al
  80113e:	75 dc                	jne    80111c <strcpy+0x19>
		/* do nothing */;
	return ret;
  801140:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801144:	c9                   	leaveq 
  801145:	c3                   	retq   

0000000000801146 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801146:	55                   	push   %rbp
  801147:	48 89 e5             	mov    %rsp,%rbp
  80114a:	48 83 ec 20          	sub    $0x20,%rsp
  80114e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801152:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801156:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80115a:	48 89 c7             	mov    %rax,%rdi
  80115d:	48 b8 97 10 80 00 00 	movabs $0x801097,%rax
  801164:	00 00 00 
  801167:	ff d0                	callq  *%rax
  801169:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80116c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80116f:	48 63 d0             	movslq %eax,%rdx
  801172:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801176:	48 01 c2             	add    %rax,%rdx
  801179:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80117d:	48 89 c6             	mov    %rax,%rsi
  801180:	48 89 d7             	mov    %rdx,%rdi
  801183:	48 b8 03 11 80 00 00 	movabs $0x801103,%rax
  80118a:	00 00 00 
  80118d:	ff d0                	callq  *%rax
	return dst;
  80118f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801193:	c9                   	leaveq 
  801194:	c3                   	retq   

0000000000801195 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801195:	55                   	push   %rbp
  801196:	48 89 e5             	mov    %rsp,%rbp
  801199:	48 83 ec 28          	sub    $0x28,%rsp
  80119d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011a1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011a5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8011a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ad:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8011b1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8011b8:	00 
  8011b9:	eb 2a                	jmp    8011e5 <strncpy+0x50>
		*dst++ = *src;
  8011bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011bf:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011c3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011c7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011cb:	0f b6 12             	movzbl (%rdx),%edx
  8011ce:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011d0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011d4:	0f b6 00             	movzbl (%rax),%eax
  8011d7:	84 c0                	test   %al,%al
  8011d9:	74 05                	je     8011e0 <strncpy+0x4b>
			src++;
  8011db:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011e0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e9:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8011ed:	72 cc                	jb     8011bb <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8011f3:	c9                   	leaveq 
  8011f4:	c3                   	retq   

00000000008011f5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8011f5:	55                   	push   %rbp
  8011f6:	48 89 e5             	mov    %rsp,%rbp
  8011f9:	48 83 ec 28          	sub    $0x28,%rsp
  8011fd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801201:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801205:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801209:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80120d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801211:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801216:	74 3d                	je     801255 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801218:	eb 1d                	jmp    801237 <strlcpy+0x42>
			*dst++ = *src++;
  80121a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80121e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801222:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801226:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80122a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80122e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801232:	0f b6 12             	movzbl (%rdx),%edx
  801235:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801237:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80123c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801241:	74 0b                	je     80124e <strlcpy+0x59>
  801243:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801247:	0f b6 00             	movzbl (%rax),%eax
  80124a:	84 c0                	test   %al,%al
  80124c:	75 cc                	jne    80121a <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80124e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801252:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801255:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801259:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125d:	48 29 c2             	sub    %rax,%rdx
  801260:	48 89 d0             	mov    %rdx,%rax
}
  801263:	c9                   	leaveq 
  801264:	c3                   	retq   

0000000000801265 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801265:	55                   	push   %rbp
  801266:	48 89 e5             	mov    %rsp,%rbp
  801269:	48 83 ec 10          	sub    $0x10,%rsp
  80126d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801271:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801275:	eb 0a                	jmp    801281 <strcmp+0x1c>
		p++, q++;
  801277:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80127c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801281:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801285:	0f b6 00             	movzbl (%rax),%eax
  801288:	84 c0                	test   %al,%al
  80128a:	74 12                	je     80129e <strcmp+0x39>
  80128c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801290:	0f b6 10             	movzbl (%rax),%edx
  801293:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801297:	0f b6 00             	movzbl (%rax),%eax
  80129a:	38 c2                	cmp    %al,%dl
  80129c:	74 d9                	je     801277 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80129e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a2:	0f b6 00             	movzbl (%rax),%eax
  8012a5:	0f b6 d0             	movzbl %al,%edx
  8012a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ac:	0f b6 00             	movzbl (%rax),%eax
  8012af:	0f b6 c0             	movzbl %al,%eax
  8012b2:	29 c2                	sub    %eax,%edx
  8012b4:	89 d0                	mov    %edx,%eax
}
  8012b6:	c9                   	leaveq 
  8012b7:	c3                   	retq   

00000000008012b8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8012b8:	55                   	push   %rbp
  8012b9:	48 89 e5             	mov    %rsp,%rbp
  8012bc:	48 83 ec 18          	sub    $0x18,%rsp
  8012c0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012c4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012c8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8012cc:	eb 0f                	jmp    8012dd <strncmp+0x25>
		n--, p++, q++;
  8012ce:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8012d3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012d8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8012dd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012e2:	74 1d                	je     801301 <strncmp+0x49>
  8012e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e8:	0f b6 00             	movzbl (%rax),%eax
  8012eb:	84 c0                	test   %al,%al
  8012ed:	74 12                	je     801301 <strncmp+0x49>
  8012ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f3:	0f b6 10             	movzbl (%rax),%edx
  8012f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012fa:	0f b6 00             	movzbl (%rax),%eax
  8012fd:	38 c2                	cmp    %al,%dl
  8012ff:	74 cd                	je     8012ce <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801301:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801306:	75 07                	jne    80130f <strncmp+0x57>
		return 0;
  801308:	b8 00 00 00 00       	mov    $0x0,%eax
  80130d:	eb 18                	jmp    801327 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80130f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801313:	0f b6 00             	movzbl (%rax),%eax
  801316:	0f b6 d0             	movzbl %al,%edx
  801319:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80131d:	0f b6 00             	movzbl (%rax),%eax
  801320:	0f b6 c0             	movzbl %al,%eax
  801323:	29 c2                	sub    %eax,%edx
  801325:	89 d0                	mov    %edx,%eax
}
  801327:	c9                   	leaveq 
  801328:	c3                   	retq   

0000000000801329 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801329:	55                   	push   %rbp
  80132a:	48 89 e5             	mov    %rsp,%rbp
  80132d:	48 83 ec 0c          	sub    $0xc,%rsp
  801331:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801335:	89 f0                	mov    %esi,%eax
  801337:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80133a:	eb 17                	jmp    801353 <strchr+0x2a>
		if (*s == c)
  80133c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801340:	0f b6 00             	movzbl (%rax),%eax
  801343:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801346:	75 06                	jne    80134e <strchr+0x25>
			return (char *) s;
  801348:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134c:	eb 15                	jmp    801363 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80134e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801353:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801357:	0f b6 00             	movzbl (%rax),%eax
  80135a:	84 c0                	test   %al,%al
  80135c:	75 de                	jne    80133c <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80135e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801363:	c9                   	leaveq 
  801364:	c3                   	retq   

0000000000801365 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801365:	55                   	push   %rbp
  801366:	48 89 e5             	mov    %rsp,%rbp
  801369:	48 83 ec 0c          	sub    $0xc,%rsp
  80136d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801371:	89 f0                	mov    %esi,%eax
  801373:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801376:	eb 13                	jmp    80138b <strfind+0x26>
		if (*s == c)
  801378:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137c:	0f b6 00             	movzbl (%rax),%eax
  80137f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801382:	75 02                	jne    801386 <strfind+0x21>
			break;
  801384:	eb 10                	jmp    801396 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801386:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80138b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80138f:	0f b6 00             	movzbl (%rax),%eax
  801392:	84 c0                	test   %al,%al
  801394:	75 e2                	jne    801378 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801396:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80139a:	c9                   	leaveq 
  80139b:	c3                   	retq   

000000000080139c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80139c:	55                   	push   %rbp
  80139d:	48 89 e5             	mov    %rsp,%rbp
  8013a0:	48 83 ec 18          	sub    $0x18,%rsp
  8013a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013a8:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8013ab:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8013af:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013b4:	75 06                	jne    8013bc <memset+0x20>
		return v;
  8013b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ba:	eb 69                	jmp    801425 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8013bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c0:	83 e0 03             	and    $0x3,%eax
  8013c3:	48 85 c0             	test   %rax,%rax
  8013c6:	75 48                	jne    801410 <memset+0x74>
  8013c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013cc:	83 e0 03             	and    $0x3,%eax
  8013cf:	48 85 c0             	test   %rax,%rax
  8013d2:	75 3c                	jne    801410 <memset+0x74>
		c &= 0xFF;
  8013d4:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8013db:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013de:	c1 e0 18             	shl    $0x18,%eax
  8013e1:	89 c2                	mov    %eax,%edx
  8013e3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013e6:	c1 e0 10             	shl    $0x10,%eax
  8013e9:	09 c2                	or     %eax,%edx
  8013eb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013ee:	c1 e0 08             	shl    $0x8,%eax
  8013f1:	09 d0                	or     %edx,%eax
  8013f3:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8013f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013fa:	48 c1 e8 02          	shr    $0x2,%rax
  8013fe:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801401:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801405:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801408:	48 89 d7             	mov    %rdx,%rdi
  80140b:	fc                   	cld    
  80140c:	f3 ab                	rep stos %eax,%es:(%rdi)
  80140e:	eb 11                	jmp    801421 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801410:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801414:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801417:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80141b:	48 89 d7             	mov    %rdx,%rdi
  80141e:	fc                   	cld    
  80141f:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801421:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801425:	c9                   	leaveq 
  801426:	c3                   	retq   

0000000000801427 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801427:	55                   	push   %rbp
  801428:	48 89 e5             	mov    %rsp,%rbp
  80142b:	48 83 ec 28          	sub    $0x28,%rsp
  80142f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801433:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801437:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80143b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80143f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801443:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801447:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80144b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80144f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801453:	0f 83 88 00 00 00    	jae    8014e1 <memmove+0xba>
  801459:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801461:	48 01 d0             	add    %rdx,%rax
  801464:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801468:	76 77                	jbe    8014e1 <memmove+0xba>
		s += n;
  80146a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80146e:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801472:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801476:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80147a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80147e:	83 e0 03             	and    $0x3,%eax
  801481:	48 85 c0             	test   %rax,%rax
  801484:	75 3b                	jne    8014c1 <memmove+0x9a>
  801486:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80148a:	83 e0 03             	and    $0x3,%eax
  80148d:	48 85 c0             	test   %rax,%rax
  801490:	75 2f                	jne    8014c1 <memmove+0x9a>
  801492:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801496:	83 e0 03             	and    $0x3,%eax
  801499:	48 85 c0             	test   %rax,%rax
  80149c:	75 23                	jne    8014c1 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80149e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a2:	48 83 e8 04          	sub    $0x4,%rax
  8014a6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014aa:	48 83 ea 04          	sub    $0x4,%rdx
  8014ae:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014b2:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8014b6:	48 89 c7             	mov    %rax,%rdi
  8014b9:	48 89 d6             	mov    %rdx,%rsi
  8014bc:	fd                   	std    
  8014bd:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014bf:	eb 1d                	jmp    8014de <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8014c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c5:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014cd:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8014d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d5:	48 89 d7             	mov    %rdx,%rdi
  8014d8:	48 89 c1             	mov    %rax,%rcx
  8014db:	fd                   	std    
  8014dc:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8014de:	fc                   	cld    
  8014df:	eb 57                	jmp    801538 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e5:	83 e0 03             	and    $0x3,%eax
  8014e8:	48 85 c0             	test   %rax,%rax
  8014eb:	75 36                	jne    801523 <memmove+0xfc>
  8014ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f1:	83 e0 03             	and    $0x3,%eax
  8014f4:	48 85 c0             	test   %rax,%rax
  8014f7:	75 2a                	jne    801523 <memmove+0xfc>
  8014f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fd:	83 e0 03             	and    $0x3,%eax
  801500:	48 85 c0             	test   %rax,%rax
  801503:	75 1e                	jne    801523 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801505:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801509:	48 c1 e8 02          	shr    $0x2,%rax
  80150d:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801510:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801514:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801518:	48 89 c7             	mov    %rax,%rdi
  80151b:	48 89 d6             	mov    %rdx,%rsi
  80151e:	fc                   	cld    
  80151f:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801521:	eb 15                	jmp    801538 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801523:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801527:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80152b:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80152f:	48 89 c7             	mov    %rax,%rdi
  801532:	48 89 d6             	mov    %rdx,%rsi
  801535:	fc                   	cld    
  801536:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801538:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80153c:	c9                   	leaveq 
  80153d:	c3                   	retq   

000000000080153e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80153e:	55                   	push   %rbp
  80153f:	48 89 e5             	mov    %rsp,%rbp
  801542:	48 83 ec 18          	sub    $0x18,%rsp
  801546:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80154a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80154e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801552:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801556:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80155a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155e:	48 89 ce             	mov    %rcx,%rsi
  801561:	48 89 c7             	mov    %rax,%rdi
  801564:	48 b8 27 14 80 00 00 	movabs $0x801427,%rax
  80156b:	00 00 00 
  80156e:	ff d0                	callq  *%rax
}
  801570:	c9                   	leaveq 
  801571:	c3                   	retq   

0000000000801572 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801572:	55                   	push   %rbp
  801573:	48 89 e5             	mov    %rsp,%rbp
  801576:	48 83 ec 28          	sub    $0x28,%rsp
  80157a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80157e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801582:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801586:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80158a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80158e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801592:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801596:	eb 36                	jmp    8015ce <memcmp+0x5c>
		if (*s1 != *s2)
  801598:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80159c:	0f b6 10             	movzbl (%rax),%edx
  80159f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015a3:	0f b6 00             	movzbl (%rax),%eax
  8015a6:	38 c2                	cmp    %al,%dl
  8015a8:	74 1a                	je     8015c4 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8015aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ae:	0f b6 00             	movzbl (%rax),%eax
  8015b1:	0f b6 d0             	movzbl %al,%edx
  8015b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b8:	0f b6 00             	movzbl (%rax),%eax
  8015bb:	0f b6 c0             	movzbl %al,%eax
  8015be:	29 c2                	sub    %eax,%edx
  8015c0:	89 d0                	mov    %edx,%eax
  8015c2:	eb 20                	jmp    8015e4 <memcmp+0x72>
		s1++, s2++;
  8015c4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015c9:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8015ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015d6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015da:	48 85 c0             	test   %rax,%rax
  8015dd:	75 b9                	jne    801598 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015e4:	c9                   	leaveq 
  8015e5:	c3                   	retq   

00000000008015e6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8015e6:	55                   	push   %rbp
  8015e7:	48 89 e5             	mov    %rsp,%rbp
  8015ea:	48 83 ec 28          	sub    $0x28,%rsp
  8015ee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015f2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8015f5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8015f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801601:	48 01 d0             	add    %rdx,%rax
  801604:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801608:	eb 15                	jmp    80161f <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80160a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80160e:	0f b6 10             	movzbl (%rax),%edx
  801611:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801614:	38 c2                	cmp    %al,%dl
  801616:	75 02                	jne    80161a <memfind+0x34>
			break;
  801618:	eb 0f                	jmp    801629 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80161a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80161f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801623:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801627:	72 e1                	jb     80160a <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801629:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80162d:	c9                   	leaveq 
  80162e:	c3                   	retq   

000000000080162f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80162f:	55                   	push   %rbp
  801630:	48 89 e5             	mov    %rsp,%rbp
  801633:	48 83 ec 34          	sub    $0x34,%rsp
  801637:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80163b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80163f:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801642:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801649:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801650:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801651:	eb 05                	jmp    801658 <strtol+0x29>
		s++;
  801653:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801658:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165c:	0f b6 00             	movzbl (%rax),%eax
  80165f:	3c 20                	cmp    $0x20,%al
  801661:	74 f0                	je     801653 <strtol+0x24>
  801663:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801667:	0f b6 00             	movzbl (%rax),%eax
  80166a:	3c 09                	cmp    $0x9,%al
  80166c:	74 e5                	je     801653 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80166e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801672:	0f b6 00             	movzbl (%rax),%eax
  801675:	3c 2b                	cmp    $0x2b,%al
  801677:	75 07                	jne    801680 <strtol+0x51>
		s++;
  801679:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80167e:	eb 17                	jmp    801697 <strtol+0x68>
	else if (*s == '-')
  801680:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801684:	0f b6 00             	movzbl (%rax),%eax
  801687:	3c 2d                	cmp    $0x2d,%al
  801689:	75 0c                	jne    801697 <strtol+0x68>
		s++, neg = 1;
  80168b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801690:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801697:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80169b:	74 06                	je     8016a3 <strtol+0x74>
  80169d:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8016a1:	75 28                	jne    8016cb <strtol+0x9c>
  8016a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a7:	0f b6 00             	movzbl (%rax),%eax
  8016aa:	3c 30                	cmp    $0x30,%al
  8016ac:	75 1d                	jne    8016cb <strtol+0x9c>
  8016ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b2:	48 83 c0 01          	add    $0x1,%rax
  8016b6:	0f b6 00             	movzbl (%rax),%eax
  8016b9:	3c 78                	cmp    $0x78,%al
  8016bb:	75 0e                	jne    8016cb <strtol+0x9c>
		s += 2, base = 16;
  8016bd:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8016c2:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8016c9:	eb 2c                	jmp    8016f7 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8016cb:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016cf:	75 19                	jne    8016ea <strtol+0xbb>
  8016d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d5:	0f b6 00             	movzbl (%rax),%eax
  8016d8:	3c 30                	cmp    $0x30,%al
  8016da:	75 0e                	jne    8016ea <strtol+0xbb>
		s++, base = 8;
  8016dc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016e1:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8016e8:	eb 0d                	jmp    8016f7 <strtol+0xc8>
	else if (base == 0)
  8016ea:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016ee:	75 07                	jne    8016f7 <strtol+0xc8>
		base = 10;
  8016f0:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016fb:	0f b6 00             	movzbl (%rax),%eax
  8016fe:	3c 2f                	cmp    $0x2f,%al
  801700:	7e 1d                	jle    80171f <strtol+0xf0>
  801702:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801706:	0f b6 00             	movzbl (%rax),%eax
  801709:	3c 39                	cmp    $0x39,%al
  80170b:	7f 12                	jg     80171f <strtol+0xf0>
			dig = *s - '0';
  80170d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801711:	0f b6 00             	movzbl (%rax),%eax
  801714:	0f be c0             	movsbl %al,%eax
  801717:	83 e8 30             	sub    $0x30,%eax
  80171a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80171d:	eb 4e                	jmp    80176d <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80171f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801723:	0f b6 00             	movzbl (%rax),%eax
  801726:	3c 60                	cmp    $0x60,%al
  801728:	7e 1d                	jle    801747 <strtol+0x118>
  80172a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172e:	0f b6 00             	movzbl (%rax),%eax
  801731:	3c 7a                	cmp    $0x7a,%al
  801733:	7f 12                	jg     801747 <strtol+0x118>
			dig = *s - 'a' + 10;
  801735:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801739:	0f b6 00             	movzbl (%rax),%eax
  80173c:	0f be c0             	movsbl %al,%eax
  80173f:	83 e8 57             	sub    $0x57,%eax
  801742:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801745:	eb 26                	jmp    80176d <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801747:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174b:	0f b6 00             	movzbl (%rax),%eax
  80174e:	3c 40                	cmp    $0x40,%al
  801750:	7e 48                	jle    80179a <strtol+0x16b>
  801752:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801756:	0f b6 00             	movzbl (%rax),%eax
  801759:	3c 5a                	cmp    $0x5a,%al
  80175b:	7f 3d                	jg     80179a <strtol+0x16b>
			dig = *s - 'A' + 10;
  80175d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801761:	0f b6 00             	movzbl (%rax),%eax
  801764:	0f be c0             	movsbl %al,%eax
  801767:	83 e8 37             	sub    $0x37,%eax
  80176a:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80176d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801770:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801773:	7c 02                	jl     801777 <strtol+0x148>
			break;
  801775:	eb 23                	jmp    80179a <strtol+0x16b>
		s++, val = (val * base) + dig;
  801777:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80177c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80177f:	48 98                	cltq   
  801781:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801786:	48 89 c2             	mov    %rax,%rdx
  801789:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80178c:	48 98                	cltq   
  80178e:	48 01 d0             	add    %rdx,%rax
  801791:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801795:	e9 5d ff ff ff       	jmpq   8016f7 <strtol+0xc8>

	if (endptr)
  80179a:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80179f:	74 0b                	je     8017ac <strtol+0x17d>
		*endptr = (char *) s;
  8017a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017a5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8017a9:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8017ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017b0:	74 09                	je     8017bb <strtol+0x18c>
  8017b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017b6:	48 f7 d8             	neg    %rax
  8017b9:	eb 04                	jmp    8017bf <strtol+0x190>
  8017bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8017bf:	c9                   	leaveq 
  8017c0:	c3                   	retq   

00000000008017c1 <strstr>:

char * strstr(const char *in, const char *str)
{
  8017c1:	55                   	push   %rbp
  8017c2:	48 89 e5             	mov    %rsp,%rbp
  8017c5:	48 83 ec 30          	sub    $0x30,%rsp
  8017c9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017cd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8017d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017d5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017d9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017dd:	0f b6 00             	movzbl (%rax),%eax
  8017e0:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8017e3:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8017e7:	75 06                	jne    8017ef <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8017e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ed:	eb 6b                	jmp    80185a <strstr+0x99>

	len = strlen(str);
  8017ef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017f3:	48 89 c7             	mov    %rax,%rdi
  8017f6:	48 b8 97 10 80 00 00 	movabs $0x801097,%rax
  8017fd:	00 00 00 
  801800:	ff d0                	callq  *%rax
  801802:	48 98                	cltq   
  801804:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801808:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801810:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801814:	0f b6 00             	movzbl (%rax),%eax
  801817:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80181a:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80181e:	75 07                	jne    801827 <strstr+0x66>
				return (char *) 0;
  801820:	b8 00 00 00 00       	mov    $0x0,%eax
  801825:	eb 33                	jmp    80185a <strstr+0x99>
		} while (sc != c);
  801827:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80182b:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80182e:	75 d8                	jne    801808 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801830:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801834:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801838:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80183c:	48 89 ce             	mov    %rcx,%rsi
  80183f:	48 89 c7             	mov    %rax,%rdi
  801842:	48 b8 b8 12 80 00 00 	movabs $0x8012b8,%rax
  801849:	00 00 00 
  80184c:	ff d0                	callq  *%rax
  80184e:	85 c0                	test   %eax,%eax
  801850:	75 b6                	jne    801808 <strstr+0x47>

	return (char *) (in - 1);
  801852:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801856:	48 83 e8 01          	sub    $0x1,%rax
}
  80185a:	c9                   	leaveq 
  80185b:	c3                   	retq   

000000000080185c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80185c:	55                   	push   %rbp
  80185d:	48 89 e5             	mov    %rsp,%rbp
  801860:	53                   	push   %rbx
  801861:	48 83 ec 48          	sub    $0x48,%rsp
  801865:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801868:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80186b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80186f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801873:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801877:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  80187b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80187e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801882:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801886:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80188a:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80188e:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801892:	4c 89 c3             	mov    %r8,%rbx
  801895:	cd 30                	int    $0x30
  801897:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  80189b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80189f:	74 3e                	je     8018df <syscall+0x83>
  8018a1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018a6:	7e 37                	jle    8018df <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8018a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018ac:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018af:	49 89 d0             	mov    %rdx,%r8
  8018b2:	89 c1                	mov    %eax,%ecx
  8018b4:	48 ba c8 48 80 00 00 	movabs $0x8048c8,%rdx
  8018bb:	00 00 00 
  8018be:	be 4a 00 00 00       	mov    $0x4a,%esi
  8018c3:	48 bf e5 48 80 00 00 	movabs $0x8048e5,%rdi
  8018ca:	00 00 00 
  8018cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d2:	49 b9 15 03 80 00 00 	movabs $0x800315,%r9
  8018d9:	00 00 00 
  8018dc:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  8018df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018e3:	48 83 c4 48          	add    $0x48,%rsp
  8018e7:	5b                   	pop    %rbx
  8018e8:	5d                   	pop    %rbp
  8018e9:	c3                   	retq   

00000000008018ea <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8018ea:	55                   	push   %rbp
  8018eb:	48 89 e5             	mov    %rsp,%rbp
  8018ee:	48 83 ec 20          	sub    $0x20,%rsp
  8018f2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018f6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8018fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018fe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801902:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801909:	00 
  80190a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801910:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801916:	48 89 d1             	mov    %rdx,%rcx
  801919:	48 89 c2             	mov    %rax,%rdx
  80191c:	be 00 00 00 00       	mov    $0x0,%esi
  801921:	bf 00 00 00 00       	mov    $0x0,%edi
  801926:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  80192d:	00 00 00 
  801930:	ff d0                	callq  *%rax
}
  801932:	c9                   	leaveq 
  801933:	c3                   	retq   

0000000000801934 <sys_cgetc>:

int
sys_cgetc(void)
{
  801934:	55                   	push   %rbp
  801935:	48 89 e5             	mov    %rsp,%rbp
  801938:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80193c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801943:	00 
  801944:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80194a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801950:	b9 00 00 00 00       	mov    $0x0,%ecx
  801955:	ba 00 00 00 00       	mov    $0x0,%edx
  80195a:	be 00 00 00 00       	mov    $0x0,%esi
  80195f:	bf 01 00 00 00       	mov    $0x1,%edi
  801964:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  80196b:	00 00 00 
  80196e:	ff d0                	callq  *%rax
}
  801970:	c9                   	leaveq 
  801971:	c3                   	retq   

0000000000801972 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801972:	55                   	push   %rbp
  801973:	48 89 e5             	mov    %rsp,%rbp
  801976:	48 83 ec 10          	sub    $0x10,%rsp
  80197a:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80197d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801980:	48 98                	cltq   
  801982:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801989:	00 
  80198a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801990:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801996:	b9 00 00 00 00       	mov    $0x0,%ecx
  80199b:	48 89 c2             	mov    %rax,%rdx
  80199e:	be 01 00 00 00       	mov    $0x1,%esi
  8019a3:	bf 03 00 00 00       	mov    $0x3,%edi
  8019a8:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  8019af:	00 00 00 
  8019b2:	ff d0                	callq  *%rax
}
  8019b4:	c9                   	leaveq 
  8019b5:	c3                   	retq   

00000000008019b6 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8019b6:	55                   	push   %rbp
  8019b7:	48 89 e5             	mov    %rsp,%rbp
  8019ba:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8019be:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019c5:	00 
  8019c6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019cc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8019dc:	be 00 00 00 00       	mov    $0x0,%esi
  8019e1:	bf 02 00 00 00       	mov    $0x2,%edi
  8019e6:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  8019ed:	00 00 00 
  8019f0:	ff d0                	callq  *%rax
}
  8019f2:	c9                   	leaveq 
  8019f3:	c3                   	retq   

00000000008019f4 <sys_yield>:

void
sys_yield(void)
{
  8019f4:	55                   	push   %rbp
  8019f5:	48 89 e5             	mov    %rsp,%rbp
  8019f8:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8019fc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a03:	00 
  801a04:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a0a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a10:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a15:	ba 00 00 00 00       	mov    $0x0,%edx
  801a1a:	be 00 00 00 00       	mov    $0x0,%esi
  801a1f:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a24:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  801a2b:	00 00 00 
  801a2e:	ff d0                	callq  *%rax
}
  801a30:	c9                   	leaveq 
  801a31:	c3                   	retq   

0000000000801a32 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a32:	55                   	push   %rbp
  801a33:	48 89 e5             	mov    %rsp,%rbp
  801a36:	48 83 ec 20          	sub    $0x20,%rsp
  801a3a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a3d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a41:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a44:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a47:	48 63 c8             	movslq %eax,%rcx
  801a4a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a51:	48 98                	cltq   
  801a53:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a5a:	00 
  801a5b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a61:	49 89 c8             	mov    %rcx,%r8
  801a64:	48 89 d1             	mov    %rdx,%rcx
  801a67:	48 89 c2             	mov    %rax,%rdx
  801a6a:	be 01 00 00 00       	mov    $0x1,%esi
  801a6f:	bf 04 00 00 00       	mov    $0x4,%edi
  801a74:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  801a7b:	00 00 00 
  801a7e:	ff d0                	callq  *%rax
}
  801a80:	c9                   	leaveq 
  801a81:	c3                   	retq   

0000000000801a82 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a82:	55                   	push   %rbp
  801a83:	48 89 e5             	mov    %rsp,%rbp
  801a86:	48 83 ec 30          	sub    $0x30,%rsp
  801a8a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a8d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a91:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a94:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a98:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a9c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a9f:	48 63 c8             	movslq %eax,%rcx
  801aa2:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801aa6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801aa9:	48 63 f0             	movslq %eax,%rsi
  801aac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ab0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ab3:	48 98                	cltq   
  801ab5:	48 89 0c 24          	mov    %rcx,(%rsp)
  801ab9:	49 89 f9             	mov    %rdi,%r9
  801abc:	49 89 f0             	mov    %rsi,%r8
  801abf:	48 89 d1             	mov    %rdx,%rcx
  801ac2:	48 89 c2             	mov    %rax,%rdx
  801ac5:	be 01 00 00 00       	mov    $0x1,%esi
  801aca:	bf 05 00 00 00       	mov    $0x5,%edi
  801acf:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  801ad6:	00 00 00 
  801ad9:	ff d0                	callq  *%rax
}
  801adb:	c9                   	leaveq 
  801adc:	c3                   	retq   

0000000000801add <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801add:	55                   	push   %rbp
  801ade:	48 89 e5             	mov    %rsp,%rbp
  801ae1:	48 83 ec 20          	sub    $0x20,%rsp
  801ae5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ae8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801aec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801af0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801af3:	48 98                	cltq   
  801af5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801afc:	00 
  801afd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b03:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b09:	48 89 d1             	mov    %rdx,%rcx
  801b0c:	48 89 c2             	mov    %rax,%rdx
  801b0f:	be 01 00 00 00       	mov    $0x1,%esi
  801b14:	bf 06 00 00 00       	mov    $0x6,%edi
  801b19:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  801b20:	00 00 00 
  801b23:	ff d0                	callq  *%rax
}
  801b25:	c9                   	leaveq 
  801b26:	c3                   	retq   

0000000000801b27 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b27:	55                   	push   %rbp
  801b28:	48 89 e5             	mov    %rsp,%rbp
  801b2b:	48 83 ec 10          	sub    $0x10,%rsp
  801b2f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b32:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b35:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b38:	48 63 d0             	movslq %eax,%rdx
  801b3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b3e:	48 98                	cltq   
  801b40:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b47:	00 
  801b48:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b4e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b54:	48 89 d1             	mov    %rdx,%rcx
  801b57:	48 89 c2             	mov    %rax,%rdx
  801b5a:	be 01 00 00 00       	mov    $0x1,%esi
  801b5f:	bf 08 00 00 00       	mov    $0x8,%edi
  801b64:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  801b6b:	00 00 00 
  801b6e:	ff d0                	callq  *%rax
}
  801b70:	c9                   	leaveq 
  801b71:	c3                   	retq   

0000000000801b72 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b72:	55                   	push   %rbp
  801b73:	48 89 e5             	mov    %rsp,%rbp
  801b76:	48 83 ec 20          	sub    $0x20,%rsp
  801b7a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b7d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b81:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b88:	48 98                	cltq   
  801b8a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b91:	00 
  801b92:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b98:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b9e:	48 89 d1             	mov    %rdx,%rcx
  801ba1:	48 89 c2             	mov    %rax,%rdx
  801ba4:	be 01 00 00 00       	mov    $0x1,%esi
  801ba9:	bf 09 00 00 00       	mov    $0x9,%edi
  801bae:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  801bb5:	00 00 00 
  801bb8:	ff d0                	callq  *%rax
}
  801bba:	c9                   	leaveq 
  801bbb:	c3                   	retq   

0000000000801bbc <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801bbc:	55                   	push   %rbp
  801bbd:	48 89 e5             	mov    %rsp,%rbp
  801bc0:	48 83 ec 20          	sub    $0x20,%rsp
  801bc4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bc7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801bcb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bcf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bd2:	48 98                	cltq   
  801bd4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bdb:	00 
  801bdc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801be2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801be8:	48 89 d1             	mov    %rdx,%rcx
  801beb:	48 89 c2             	mov    %rax,%rdx
  801bee:	be 01 00 00 00       	mov    $0x1,%esi
  801bf3:	bf 0a 00 00 00       	mov    $0xa,%edi
  801bf8:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  801bff:	00 00 00 
  801c02:	ff d0                	callq  *%rax
}
  801c04:	c9                   	leaveq 
  801c05:	c3                   	retq   

0000000000801c06 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801c06:	55                   	push   %rbp
  801c07:	48 89 e5             	mov    %rsp,%rbp
  801c0a:	48 83 ec 20          	sub    $0x20,%rsp
  801c0e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c11:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c15:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c19:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c1c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c1f:	48 63 f0             	movslq %eax,%rsi
  801c22:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c29:	48 98                	cltq   
  801c2b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c2f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c36:	00 
  801c37:	49 89 f1             	mov    %rsi,%r9
  801c3a:	49 89 c8             	mov    %rcx,%r8
  801c3d:	48 89 d1             	mov    %rdx,%rcx
  801c40:	48 89 c2             	mov    %rax,%rdx
  801c43:	be 00 00 00 00       	mov    $0x0,%esi
  801c48:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c4d:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  801c54:	00 00 00 
  801c57:	ff d0                	callq  *%rax
}
  801c59:	c9                   	leaveq 
  801c5a:	c3                   	retq   

0000000000801c5b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c5b:	55                   	push   %rbp
  801c5c:	48 89 e5             	mov    %rsp,%rbp
  801c5f:	48 83 ec 10          	sub    $0x10,%rsp
  801c63:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c6b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c72:	00 
  801c73:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c79:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c7f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c84:	48 89 c2             	mov    %rax,%rdx
  801c87:	be 01 00 00 00       	mov    $0x1,%esi
  801c8c:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c91:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  801c98:	00 00 00 
  801c9b:	ff d0                	callq  *%rax
}
  801c9d:	c9                   	leaveq 
  801c9e:	c3                   	retq   

0000000000801c9f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801c9f:	55                   	push   %rbp
  801ca0:	48 89 e5             	mov    %rsp,%rbp
  801ca3:	48 83 ec 08          	sub    $0x8,%rsp
  801ca7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801cab:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801caf:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801cb6:	ff ff ff 
  801cb9:	48 01 d0             	add    %rdx,%rax
  801cbc:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801cc0:	c9                   	leaveq 
  801cc1:	c3                   	retq   

0000000000801cc2 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801cc2:	55                   	push   %rbp
  801cc3:	48 89 e5             	mov    %rsp,%rbp
  801cc6:	48 83 ec 08          	sub    $0x8,%rsp
  801cca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801cce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cd2:	48 89 c7             	mov    %rax,%rdi
  801cd5:	48 b8 9f 1c 80 00 00 	movabs $0x801c9f,%rax
  801cdc:	00 00 00 
  801cdf:	ff d0                	callq  *%rax
  801ce1:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801ce7:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801ceb:	c9                   	leaveq 
  801cec:	c3                   	retq   

0000000000801ced <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801ced:	55                   	push   %rbp
  801cee:	48 89 e5             	mov    %rsp,%rbp
  801cf1:	48 83 ec 18          	sub    $0x18,%rsp
  801cf5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801cf9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d00:	eb 6b                	jmp    801d6d <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801d02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d05:	48 98                	cltq   
  801d07:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d0d:	48 c1 e0 0c          	shl    $0xc,%rax
  801d11:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d19:	48 c1 e8 15          	shr    $0x15,%rax
  801d1d:	48 89 c2             	mov    %rax,%rdx
  801d20:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d27:	01 00 00 
  801d2a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d2e:	83 e0 01             	and    $0x1,%eax
  801d31:	48 85 c0             	test   %rax,%rax
  801d34:	74 21                	je     801d57 <fd_alloc+0x6a>
  801d36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d3a:	48 c1 e8 0c          	shr    $0xc,%rax
  801d3e:	48 89 c2             	mov    %rax,%rdx
  801d41:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d48:	01 00 00 
  801d4b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d4f:	83 e0 01             	and    $0x1,%eax
  801d52:	48 85 c0             	test   %rax,%rax
  801d55:	75 12                	jne    801d69 <fd_alloc+0x7c>
			*fd_store = fd;
  801d57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d5b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d5f:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801d62:	b8 00 00 00 00       	mov    $0x0,%eax
  801d67:	eb 1a                	jmp    801d83 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d69:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d6d:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801d71:	7e 8f                	jle    801d02 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801d73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d77:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801d7e:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801d83:	c9                   	leaveq 
  801d84:	c3                   	retq   

0000000000801d85 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801d85:	55                   	push   %rbp
  801d86:	48 89 e5             	mov    %rsp,%rbp
  801d89:	48 83 ec 20          	sub    $0x20,%rsp
  801d8d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d90:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801d94:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801d98:	78 06                	js     801da0 <fd_lookup+0x1b>
  801d9a:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801d9e:	7e 07                	jle    801da7 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801da0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801da5:	eb 6c                	jmp    801e13 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801da7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801daa:	48 98                	cltq   
  801dac:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801db2:	48 c1 e0 0c          	shl    $0xc,%rax
  801db6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801dba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dbe:	48 c1 e8 15          	shr    $0x15,%rax
  801dc2:	48 89 c2             	mov    %rax,%rdx
  801dc5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801dcc:	01 00 00 
  801dcf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dd3:	83 e0 01             	and    $0x1,%eax
  801dd6:	48 85 c0             	test   %rax,%rax
  801dd9:	74 21                	je     801dfc <fd_lookup+0x77>
  801ddb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ddf:	48 c1 e8 0c          	shr    $0xc,%rax
  801de3:	48 89 c2             	mov    %rax,%rdx
  801de6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ded:	01 00 00 
  801df0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801df4:	83 e0 01             	and    $0x1,%eax
  801df7:	48 85 c0             	test   %rax,%rax
  801dfa:	75 07                	jne    801e03 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801dfc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e01:	eb 10                	jmp    801e13 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801e03:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e07:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e0b:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801e0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e13:	c9                   	leaveq 
  801e14:	c3                   	retq   

0000000000801e15 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801e15:	55                   	push   %rbp
  801e16:	48 89 e5             	mov    %rsp,%rbp
  801e19:	48 83 ec 30          	sub    $0x30,%rsp
  801e1d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e21:	89 f0                	mov    %esi,%eax
  801e23:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e26:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e2a:	48 89 c7             	mov    %rax,%rdi
  801e2d:	48 b8 9f 1c 80 00 00 	movabs $0x801c9f,%rax
  801e34:	00 00 00 
  801e37:	ff d0                	callq  *%rax
  801e39:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e3d:	48 89 d6             	mov    %rdx,%rsi
  801e40:	89 c7                	mov    %eax,%edi
  801e42:	48 b8 85 1d 80 00 00 	movabs $0x801d85,%rax
  801e49:	00 00 00 
  801e4c:	ff d0                	callq  *%rax
  801e4e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e51:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e55:	78 0a                	js     801e61 <fd_close+0x4c>
	    || fd != fd2)
  801e57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e5b:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801e5f:	74 12                	je     801e73 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801e61:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801e65:	74 05                	je     801e6c <fd_close+0x57>
  801e67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e6a:	eb 05                	jmp    801e71 <fd_close+0x5c>
  801e6c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e71:	eb 69                	jmp    801edc <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801e73:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e77:	8b 00                	mov    (%rax),%eax
  801e79:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801e7d:	48 89 d6             	mov    %rdx,%rsi
  801e80:	89 c7                	mov    %eax,%edi
  801e82:	48 b8 de 1e 80 00 00 	movabs $0x801ede,%rax
  801e89:	00 00 00 
  801e8c:	ff d0                	callq  *%rax
  801e8e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e91:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e95:	78 2a                	js     801ec1 <fd_close+0xac>
		if (dev->dev_close)
  801e97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e9b:	48 8b 40 20          	mov    0x20(%rax),%rax
  801e9f:	48 85 c0             	test   %rax,%rax
  801ea2:	74 16                	je     801eba <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801ea4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ea8:	48 8b 40 20          	mov    0x20(%rax),%rax
  801eac:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801eb0:	48 89 d7             	mov    %rdx,%rdi
  801eb3:	ff d0                	callq  *%rax
  801eb5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801eb8:	eb 07                	jmp    801ec1 <fd_close+0xac>
		else
			r = 0;
  801eba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801ec1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ec5:	48 89 c6             	mov    %rax,%rsi
  801ec8:	bf 00 00 00 00       	mov    $0x0,%edi
  801ecd:	48 b8 dd 1a 80 00 00 	movabs $0x801add,%rax
  801ed4:	00 00 00 
  801ed7:	ff d0                	callq  *%rax
	return r;
  801ed9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801edc:	c9                   	leaveq 
  801edd:	c3                   	retq   

0000000000801ede <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801ede:	55                   	push   %rbp
  801edf:	48 89 e5             	mov    %rsp,%rbp
  801ee2:	48 83 ec 20          	sub    $0x20,%rsp
  801ee6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ee9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801eed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ef4:	eb 41                	jmp    801f37 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801ef6:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801efd:	00 00 00 
  801f00:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f03:	48 63 d2             	movslq %edx,%rdx
  801f06:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f0a:	8b 00                	mov    (%rax),%eax
  801f0c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801f0f:	75 22                	jne    801f33 <dev_lookup+0x55>
			*dev = devtab[i];
  801f11:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f18:	00 00 00 
  801f1b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f1e:	48 63 d2             	movslq %edx,%rdx
  801f21:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801f25:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f29:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f2c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f31:	eb 60                	jmp    801f93 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801f33:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f37:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f3e:	00 00 00 
  801f41:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f44:	48 63 d2             	movslq %edx,%rdx
  801f47:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f4b:	48 85 c0             	test   %rax,%rax
  801f4e:	75 a6                	jne    801ef6 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801f50:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801f57:	00 00 00 
  801f5a:	48 8b 00             	mov    (%rax),%rax
  801f5d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801f63:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f66:	89 c6                	mov    %eax,%esi
  801f68:	48 bf f8 48 80 00 00 	movabs $0x8048f8,%rdi
  801f6f:	00 00 00 
  801f72:	b8 00 00 00 00       	mov    $0x0,%eax
  801f77:	48 b9 4e 05 80 00 00 	movabs $0x80054e,%rcx
  801f7e:	00 00 00 
  801f81:	ff d1                	callq  *%rcx
	*dev = 0;
  801f83:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f87:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801f8e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801f93:	c9                   	leaveq 
  801f94:	c3                   	retq   

0000000000801f95 <close>:

int
close(int fdnum)
{
  801f95:	55                   	push   %rbp
  801f96:	48 89 e5             	mov    %rsp,%rbp
  801f99:	48 83 ec 20          	sub    $0x20,%rsp
  801f9d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fa0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801fa4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801fa7:	48 89 d6             	mov    %rdx,%rsi
  801faa:	89 c7                	mov    %eax,%edi
  801fac:	48 b8 85 1d 80 00 00 	movabs $0x801d85,%rax
  801fb3:	00 00 00 
  801fb6:	ff d0                	callq  *%rax
  801fb8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fbb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fbf:	79 05                	jns    801fc6 <close+0x31>
		return r;
  801fc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fc4:	eb 18                	jmp    801fde <close+0x49>
	else
		return fd_close(fd, 1);
  801fc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fca:	be 01 00 00 00       	mov    $0x1,%esi
  801fcf:	48 89 c7             	mov    %rax,%rdi
  801fd2:	48 b8 15 1e 80 00 00 	movabs $0x801e15,%rax
  801fd9:	00 00 00 
  801fdc:	ff d0                	callq  *%rax
}
  801fde:	c9                   	leaveq 
  801fdf:	c3                   	retq   

0000000000801fe0 <close_all>:

void
close_all(void)
{
  801fe0:	55                   	push   %rbp
  801fe1:	48 89 e5             	mov    %rsp,%rbp
  801fe4:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801fe8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fef:	eb 15                	jmp    802006 <close_all+0x26>
		close(i);
  801ff1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ff4:	89 c7                	mov    %eax,%edi
  801ff6:	48 b8 95 1f 80 00 00 	movabs $0x801f95,%rax
  801ffd:	00 00 00 
  802000:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802002:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802006:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80200a:	7e e5                	jle    801ff1 <close_all+0x11>
		close(i);
}
  80200c:	c9                   	leaveq 
  80200d:	c3                   	retq   

000000000080200e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80200e:	55                   	push   %rbp
  80200f:	48 89 e5             	mov    %rsp,%rbp
  802012:	48 83 ec 40          	sub    $0x40,%rsp
  802016:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802019:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80201c:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802020:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802023:	48 89 d6             	mov    %rdx,%rsi
  802026:	89 c7                	mov    %eax,%edi
  802028:	48 b8 85 1d 80 00 00 	movabs $0x801d85,%rax
  80202f:	00 00 00 
  802032:	ff d0                	callq  *%rax
  802034:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802037:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80203b:	79 08                	jns    802045 <dup+0x37>
		return r;
  80203d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802040:	e9 70 01 00 00       	jmpq   8021b5 <dup+0x1a7>
	close(newfdnum);
  802045:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802048:	89 c7                	mov    %eax,%edi
  80204a:	48 b8 95 1f 80 00 00 	movabs $0x801f95,%rax
  802051:	00 00 00 
  802054:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802056:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802059:	48 98                	cltq   
  80205b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802061:	48 c1 e0 0c          	shl    $0xc,%rax
  802065:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802069:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80206d:	48 89 c7             	mov    %rax,%rdi
  802070:	48 b8 c2 1c 80 00 00 	movabs $0x801cc2,%rax
  802077:	00 00 00 
  80207a:	ff d0                	callq  *%rax
  80207c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802080:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802084:	48 89 c7             	mov    %rax,%rdi
  802087:	48 b8 c2 1c 80 00 00 	movabs $0x801cc2,%rax
  80208e:	00 00 00 
  802091:	ff d0                	callq  *%rax
  802093:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802097:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80209b:	48 c1 e8 15          	shr    $0x15,%rax
  80209f:	48 89 c2             	mov    %rax,%rdx
  8020a2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8020a9:	01 00 00 
  8020ac:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020b0:	83 e0 01             	and    $0x1,%eax
  8020b3:	48 85 c0             	test   %rax,%rax
  8020b6:	74 73                	je     80212b <dup+0x11d>
  8020b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020bc:	48 c1 e8 0c          	shr    $0xc,%rax
  8020c0:	48 89 c2             	mov    %rax,%rdx
  8020c3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020ca:	01 00 00 
  8020cd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020d1:	83 e0 01             	and    $0x1,%eax
  8020d4:	48 85 c0             	test   %rax,%rax
  8020d7:	74 52                	je     80212b <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8020d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020dd:	48 c1 e8 0c          	shr    $0xc,%rax
  8020e1:	48 89 c2             	mov    %rax,%rdx
  8020e4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020eb:	01 00 00 
  8020ee:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020f2:	25 07 0e 00 00       	and    $0xe07,%eax
  8020f7:	89 c1                	mov    %eax,%ecx
  8020f9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8020fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802101:	41 89 c8             	mov    %ecx,%r8d
  802104:	48 89 d1             	mov    %rdx,%rcx
  802107:	ba 00 00 00 00       	mov    $0x0,%edx
  80210c:	48 89 c6             	mov    %rax,%rsi
  80210f:	bf 00 00 00 00       	mov    $0x0,%edi
  802114:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  80211b:	00 00 00 
  80211e:	ff d0                	callq  *%rax
  802120:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802123:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802127:	79 02                	jns    80212b <dup+0x11d>
			goto err;
  802129:	eb 57                	jmp    802182 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80212b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80212f:	48 c1 e8 0c          	shr    $0xc,%rax
  802133:	48 89 c2             	mov    %rax,%rdx
  802136:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80213d:	01 00 00 
  802140:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802144:	25 07 0e 00 00       	and    $0xe07,%eax
  802149:	89 c1                	mov    %eax,%ecx
  80214b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80214f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802153:	41 89 c8             	mov    %ecx,%r8d
  802156:	48 89 d1             	mov    %rdx,%rcx
  802159:	ba 00 00 00 00       	mov    $0x0,%edx
  80215e:	48 89 c6             	mov    %rax,%rsi
  802161:	bf 00 00 00 00       	mov    $0x0,%edi
  802166:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  80216d:	00 00 00 
  802170:	ff d0                	callq  *%rax
  802172:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802175:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802179:	79 02                	jns    80217d <dup+0x16f>
		goto err;
  80217b:	eb 05                	jmp    802182 <dup+0x174>

	return newfdnum;
  80217d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802180:	eb 33                	jmp    8021b5 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802182:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802186:	48 89 c6             	mov    %rax,%rsi
  802189:	bf 00 00 00 00       	mov    $0x0,%edi
  80218e:	48 b8 dd 1a 80 00 00 	movabs $0x801add,%rax
  802195:	00 00 00 
  802198:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80219a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80219e:	48 89 c6             	mov    %rax,%rsi
  8021a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8021a6:	48 b8 dd 1a 80 00 00 	movabs $0x801add,%rax
  8021ad:	00 00 00 
  8021b0:	ff d0                	callq  *%rax
	return r;
  8021b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8021b5:	c9                   	leaveq 
  8021b6:	c3                   	retq   

00000000008021b7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8021b7:	55                   	push   %rbp
  8021b8:	48 89 e5             	mov    %rsp,%rbp
  8021bb:	48 83 ec 40          	sub    $0x40,%rsp
  8021bf:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8021c2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8021c6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021ca:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021ce:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8021d1:	48 89 d6             	mov    %rdx,%rsi
  8021d4:	89 c7                	mov    %eax,%edi
  8021d6:	48 b8 85 1d 80 00 00 	movabs $0x801d85,%rax
  8021dd:	00 00 00 
  8021e0:	ff d0                	callq  *%rax
  8021e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021e9:	78 24                	js     80220f <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ef:	8b 00                	mov    (%rax),%eax
  8021f1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021f5:	48 89 d6             	mov    %rdx,%rsi
  8021f8:	89 c7                	mov    %eax,%edi
  8021fa:	48 b8 de 1e 80 00 00 	movabs $0x801ede,%rax
  802201:	00 00 00 
  802204:	ff d0                	callq  *%rax
  802206:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802209:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80220d:	79 05                	jns    802214 <read+0x5d>
		return r;
  80220f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802212:	eb 76                	jmp    80228a <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802214:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802218:	8b 40 08             	mov    0x8(%rax),%eax
  80221b:	83 e0 03             	and    $0x3,%eax
  80221e:	83 f8 01             	cmp    $0x1,%eax
  802221:	75 3a                	jne    80225d <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802223:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80222a:	00 00 00 
  80222d:	48 8b 00             	mov    (%rax),%rax
  802230:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802236:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802239:	89 c6                	mov    %eax,%esi
  80223b:	48 bf 17 49 80 00 00 	movabs $0x804917,%rdi
  802242:	00 00 00 
  802245:	b8 00 00 00 00       	mov    $0x0,%eax
  80224a:	48 b9 4e 05 80 00 00 	movabs $0x80054e,%rcx
  802251:	00 00 00 
  802254:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802256:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80225b:	eb 2d                	jmp    80228a <read+0xd3>
	}
	if (!dev->dev_read)
  80225d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802261:	48 8b 40 10          	mov    0x10(%rax),%rax
  802265:	48 85 c0             	test   %rax,%rax
  802268:	75 07                	jne    802271 <read+0xba>
		return -E_NOT_SUPP;
  80226a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80226f:	eb 19                	jmp    80228a <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802271:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802275:	48 8b 40 10          	mov    0x10(%rax),%rax
  802279:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80227d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802281:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802285:	48 89 cf             	mov    %rcx,%rdi
  802288:	ff d0                	callq  *%rax
}
  80228a:	c9                   	leaveq 
  80228b:	c3                   	retq   

000000000080228c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80228c:	55                   	push   %rbp
  80228d:	48 89 e5             	mov    %rsp,%rbp
  802290:	48 83 ec 30          	sub    $0x30,%rsp
  802294:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802297:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80229b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80229f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022a6:	eb 49                	jmp    8022f1 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8022a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022ab:	48 98                	cltq   
  8022ad:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8022b1:	48 29 c2             	sub    %rax,%rdx
  8022b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022b7:	48 63 c8             	movslq %eax,%rcx
  8022ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022be:	48 01 c1             	add    %rax,%rcx
  8022c1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022c4:	48 89 ce             	mov    %rcx,%rsi
  8022c7:	89 c7                	mov    %eax,%edi
  8022c9:	48 b8 b7 21 80 00 00 	movabs $0x8021b7,%rax
  8022d0:	00 00 00 
  8022d3:	ff d0                	callq  *%rax
  8022d5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8022d8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8022dc:	79 05                	jns    8022e3 <readn+0x57>
			return m;
  8022de:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022e1:	eb 1c                	jmp    8022ff <readn+0x73>
		if (m == 0)
  8022e3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8022e7:	75 02                	jne    8022eb <readn+0x5f>
			break;
  8022e9:	eb 11                	jmp    8022fc <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8022eb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022ee:	01 45 fc             	add    %eax,-0x4(%rbp)
  8022f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022f4:	48 98                	cltq   
  8022f6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8022fa:	72 ac                	jb     8022a8 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8022fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022ff:	c9                   	leaveq 
  802300:	c3                   	retq   

0000000000802301 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802301:	55                   	push   %rbp
  802302:	48 89 e5             	mov    %rsp,%rbp
  802305:	48 83 ec 40          	sub    $0x40,%rsp
  802309:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80230c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802310:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802314:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802318:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80231b:	48 89 d6             	mov    %rdx,%rsi
  80231e:	89 c7                	mov    %eax,%edi
  802320:	48 b8 85 1d 80 00 00 	movabs $0x801d85,%rax
  802327:	00 00 00 
  80232a:	ff d0                	callq  *%rax
  80232c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80232f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802333:	78 24                	js     802359 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802335:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802339:	8b 00                	mov    (%rax),%eax
  80233b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80233f:	48 89 d6             	mov    %rdx,%rsi
  802342:	89 c7                	mov    %eax,%edi
  802344:	48 b8 de 1e 80 00 00 	movabs $0x801ede,%rax
  80234b:	00 00 00 
  80234e:	ff d0                	callq  *%rax
  802350:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802353:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802357:	79 05                	jns    80235e <write+0x5d>
		return r;
  802359:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80235c:	eb 75                	jmp    8023d3 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80235e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802362:	8b 40 08             	mov    0x8(%rax),%eax
  802365:	83 e0 03             	and    $0x3,%eax
  802368:	85 c0                	test   %eax,%eax
  80236a:	75 3a                	jne    8023a6 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80236c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802373:	00 00 00 
  802376:	48 8b 00             	mov    (%rax),%rax
  802379:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80237f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802382:	89 c6                	mov    %eax,%esi
  802384:	48 bf 33 49 80 00 00 	movabs $0x804933,%rdi
  80238b:	00 00 00 
  80238e:	b8 00 00 00 00       	mov    $0x0,%eax
  802393:	48 b9 4e 05 80 00 00 	movabs $0x80054e,%rcx
  80239a:	00 00 00 
  80239d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80239f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023a4:	eb 2d                	jmp    8023d3 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8023a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023aa:	48 8b 40 18          	mov    0x18(%rax),%rax
  8023ae:	48 85 c0             	test   %rax,%rax
  8023b1:	75 07                	jne    8023ba <write+0xb9>
		return -E_NOT_SUPP;
  8023b3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8023b8:	eb 19                	jmp    8023d3 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8023ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023be:	48 8b 40 18          	mov    0x18(%rax),%rax
  8023c2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023c6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023ca:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023ce:	48 89 cf             	mov    %rcx,%rdi
  8023d1:	ff d0                	callq  *%rax
}
  8023d3:	c9                   	leaveq 
  8023d4:	c3                   	retq   

00000000008023d5 <seek>:

int
seek(int fdnum, off_t offset)
{
  8023d5:	55                   	push   %rbp
  8023d6:	48 89 e5             	mov    %rsp,%rbp
  8023d9:	48 83 ec 18          	sub    $0x18,%rsp
  8023dd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023e0:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023e3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023ea:	48 89 d6             	mov    %rdx,%rsi
  8023ed:	89 c7                	mov    %eax,%edi
  8023ef:	48 b8 85 1d 80 00 00 	movabs $0x801d85,%rax
  8023f6:	00 00 00 
  8023f9:	ff d0                	callq  *%rax
  8023fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802402:	79 05                	jns    802409 <seek+0x34>
		return r;
  802404:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802407:	eb 0f                	jmp    802418 <seek+0x43>
	fd->fd_offset = offset;
  802409:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80240d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802410:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802413:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802418:	c9                   	leaveq 
  802419:	c3                   	retq   

000000000080241a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80241a:	55                   	push   %rbp
  80241b:	48 89 e5             	mov    %rsp,%rbp
  80241e:	48 83 ec 30          	sub    $0x30,%rsp
  802422:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802425:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802428:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80242c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80242f:	48 89 d6             	mov    %rdx,%rsi
  802432:	89 c7                	mov    %eax,%edi
  802434:	48 b8 85 1d 80 00 00 	movabs $0x801d85,%rax
  80243b:	00 00 00 
  80243e:	ff d0                	callq  *%rax
  802440:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802443:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802447:	78 24                	js     80246d <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802449:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80244d:	8b 00                	mov    (%rax),%eax
  80244f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802453:	48 89 d6             	mov    %rdx,%rsi
  802456:	89 c7                	mov    %eax,%edi
  802458:	48 b8 de 1e 80 00 00 	movabs $0x801ede,%rax
  80245f:	00 00 00 
  802462:	ff d0                	callq  *%rax
  802464:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802467:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80246b:	79 05                	jns    802472 <ftruncate+0x58>
		return r;
  80246d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802470:	eb 72                	jmp    8024e4 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802472:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802476:	8b 40 08             	mov    0x8(%rax),%eax
  802479:	83 e0 03             	and    $0x3,%eax
  80247c:	85 c0                	test   %eax,%eax
  80247e:	75 3a                	jne    8024ba <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802480:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802487:	00 00 00 
  80248a:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80248d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802493:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802496:	89 c6                	mov    %eax,%esi
  802498:	48 bf 50 49 80 00 00 	movabs $0x804950,%rdi
  80249f:	00 00 00 
  8024a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a7:	48 b9 4e 05 80 00 00 	movabs $0x80054e,%rcx
  8024ae:	00 00 00 
  8024b1:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8024b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024b8:	eb 2a                	jmp    8024e4 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8024ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024be:	48 8b 40 30          	mov    0x30(%rax),%rax
  8024c2:	48 85 c0             	test   %rax,%rax
  8024c5:	75 07                	jne    8024ce <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8024c7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024cc:	eb 16                	jmp    8024e4 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8024ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024d2:	48 8b 40 30          	mov    0x30(%rax),%rax
  8024d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8024da:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8024dd:	89 ce                	mov    %ecx,%esi
  8024df:	48 89 d7             	mov    %rdx,%rdi
  8024e2:	ff d0                	callq  *%rax
}
  8024e4:	c9                   	leaveq 
  8024e5:	c3                   	retq   

00000000008024e6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8024e6:	55                   	push   %rbp
  8024e7:	48 89 e5             	mov    %rsp,%rbp
  8024ea:	48 83 ec 30          	sub    $0x30,%rsp
  8024ee:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024f1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024f5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024f9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024fc:	48 89 d6             	mov    %rdx,%rsi
  8024ff:	89 c7                	mov    %eax,%edi
  802501:	48 b8 85 1d 80 00 00 	movabs $0x801d85,%rax
  802508:	00 00 00 
  80250b:	ff d0                	callq  *%rax
  80250d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802510:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802514:	78 24                	js     80253a <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802516:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80251a:	8b 00                	mov    (%rax),%eax
  80251c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802520:	48 89 d6             	mov    %rdx,%rsi
  802523:	89 c7                	mov    %eax,%edi
  802525:	48 b8 de 1e 80 00 00 	movabs $0x801ede,%rax
  80252c:	00 00 00 
  80252f:	ff d0                	callq  *%rax
  802531:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802534:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802538:	79 05                	jns    80253f <fstat+0x59>
		return r;
  80253a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80253d:	eb 5e                	jmp    80259d <fstat+0xb7>
	if (!dev->dev_stat)
  80253f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802543:	48 8b 40 28          	mov    0x28(%rax),%rax
  802547:	48 85 c0             	test   %rax,%rax
  80254a:	75 07                	jne    802553 <fstat+0x6d>
		return -E_NOT_SUPP;
  80254c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802551:	eb 4a                	jmp    80259d <fstat+0xb7>
	stat->st_name[0] = 0;
  802553:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802557:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80255a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80255e:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802565:	00 00 00 
	stat->st_isdir = 0;
  802568:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80256c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802573:	00 00 00 
	stat->st_dev = dev;
  802576:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80257a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80257e:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802585:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802589:	48 8b 40 28          	mov    0x28(%rax),%rax
  80258d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802591:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802595:	48 89 ce             	mov    %rcx,%rsi
  802598:	48 89 d7             	mov    %rdx,%rdi
  80259b:	ff d0                	callq  *%rax
}
  80259d:	c9                   	leaveq 
  80259e:	c3                   	retq   

000000000080259f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80259f:	55                   	push   %rbp
  8025a0:	48 89 e5             	mov    %rsp,%rbp
  8025a3:	48 83 ec 20          	sub    $0x20,%rsp
  8025a7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025ab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8025af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025b3:	be 00 00 00 00       	mov    $0x0,%esi
  8025b8:	48 89 c7             	mov    %rax,%rdi
  8025bb:	48 b8 8d 26 80 00 00 	movabs $0x80268d,%rax
  8025c2:	00 00 00 
  8025c5:	ff d0                	callq  *%rax
  8025c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025ce:	79 05                	jns    8025d5 <stat+0x36>
		return fd;
  8025d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025d3:	eb 2f                	jmp    802604 <stat+0x65>
	r = fstat(fd, stat);
  8025d5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8025d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025dc:	48 89 d6             	mov    %rdx,%rsi
  8025df:	89 c7                	mov    %eax,%edi
  8025e1:	48 b8 e6 24 80 00 00 	movabs $0x8024e6,%rax
  8025e8:	00 00 00 
  8025eb:	ff d0                	callq  *%rax
  8025ed:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8025f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025f3:	89 c7                	mov    %eax,%edi
  8025f5:	48 b8 95 1f 80 00 00 	movabs $0x801f95,%rax
  8025fc:	00 00 00 
  8025ff:	ff d0                	callq  *%rax
	return r;
  802601:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802604:	c9                   	leaveq 
  802605:	c3                   	retq   

0000000000802606 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802606:	55                   	push   %rbp
  802607:	48 89 e5             	mov    %rsp,%rbp
  80260a:	48 83 ec 10          	sub    $0x10,%rsp
  80260e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802611:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802615:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80261c:	00 00 00 
  80261f:	8b 00                	mov    (%rax),%eax
  802621:	85 c0                	test   %eax,%eax
  802623:	75 1d                	jne    802642 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802625:	bf 01 00 00 00       	mov    $0x1,%edi
  80262a:	48 b8 c1 41 80 00 00 	movabs $0x8041c1,%rax
  802631:	00 00 00 
  802634:	ff d0                	callq  *%rax
  802636:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80263d:	00 00 00 
  802640:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802642:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802649:	00 00 00 
  80264c:	8b 00                	mov    (%rax),%eax
  80264e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802651:	b9 07 00 00 00       	mov    $0x7,%ecx
  802656:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80265d:	00 00 00 
  802660:	89 c7                	mov    %eax,%edi
  802662:	48 b8 24 41 80 00 00 	movabs $0x804124,%rax
  802669:	00 00 00 
  80266c:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80266e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802672:	ba 00 00 00 00       	mov    $0x0,%edx
  802677:	48 89 c6             	mov    %rax,%rsi
  80267a:	bf 00 00 00 00       	mov    $0x0,%edi
  80267f:	48 b8 5e 40 80 00 00 	movabs $0x80405e,%rax
  802686:	00 00 00 
  802689:	ff d0                	callq  *%rax
}
  80268b:	c9                   	leaveq 
  80268c:	c3                   	retq   

000000000080268d <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80268d:	55                   	push   %rbp
  80268e:	48 89 e5             	mov    %rsp,%rbp
  802691:	48 83 ec 20          	sub    $0x20,%rsp
  802695:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802699:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  80269c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026a0:	48 89 c7             	mov    %rax,%rdi
  8026a3:	48 b8 97 10 80 00 00 	movabs $0x801097,%rax
  8026aa:	00 00 00 
  8026ad:	ff d0                	callq  *%rax
  8026af:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8026b4:	7e 0a                	jle    8026c0 <open+0x33>
  8026b6:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8026bb:	e9 a5 00 00 00       	jmpq   802765 <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  8026c0:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8026c4:	48 89 c7             	mov    %rax,%rdi
  8026c7:	48 b8 ed 1c 80 00 00 	movabs $0x801ced,%rax
  8026ce:	00 00 00 
  8026d1:	ff d0                	callq  *%rax
  8026d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026da:	79 08                	jns    8026e4 <open+0x57>
		return r;
  8026dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026df:	e9 81 00 00 00       	jmpq   802765 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  8026e4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8026eb:	00 00 00 
  8026ee:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8026f1:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  8026f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026fb:	48 89 c6             	mov    %rax,%rsi
  8026fe:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802705:	00 00 00 
  802708:	48 b8 03 11 80 00 00 	movabs $0x801103,%rax
  80270f:	00 00 00 
  802712:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  802714:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802718:	48 89 c6             	mov    %rax,%rsi
  80271b:	bf 01 00 00 00       	mov    $0x1,%edi
  802720:	48 b8 06 26 80 00 00 	movabs $0x802606,%rax
  802727:	00 00 00 
  80272a:	ff d0                	callq  *%rax
  80272c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80272f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802733:	79 1d                	jns    802752 <open+0xc5>
		fd_close(fd, 0);
  802735:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802739:	be 00 00 00 00       	mov    $0x0,%esi
  80273e:	48 89 c7             	mov    %rax,%rdi
  802741:	48 b8 15 1e 80 00 00 	movabs $0x801e15,%rax
  802748:	00 00 00 
  80274b:	ff d0                	callq  *%rax
		return r;
  80274d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802750:	eb 13                	jmp    802765 <open+0xd8>
	}
	return fd2num(fd);
  802752:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802756:	48 89 c7             	mov    %rax,%rdi
  802759:	48 b8 9f 1c 80 00 00 	movabs $0x801c9f,%rax
  802760:	00 00 00 
  802763:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  802765:	c9                   	leaveq 
  802766:	c3                   	retq   

0000000000802767 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802767:	55                   	push   %rbp
  802768:	48 89 e5             	mov    %rsp,%rbp
  80276b:	48 83 ec 10          	sub    $0x10,%rsp
  80276f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802773:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802777:	8b 50 0c             	mov    0xc(%rax),%edx
  80277a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802781:	00 00 00 
  802784:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802786:	be 00 00 00 00       	mov    $0x0,%esi
  80278b:	bf 06 00 00 00       	mov    $0x6,%edi
  802790:	48 b8 06 26 80 00 00 	movabs $0x802606,%rax
  802797:	00 00 00 
  80279a:	ff d0                	callq  *%rax
}
  80279c:	c9                   	leaveq 
  80279d:	c3                   	retq   

000000000080279e <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80279e:	55                   	push   %rbp
  80279f:	48 89 e5             	mov    %rsp,%rbp
  8027a2:	48 83 ec 30          	sub    $0x30,%rsp
  8027a6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027aa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8027ae:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8027b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b6:	8b 50 0c             	mov    0xc(%rax),%edx
  8027b9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027c0:	00 00 00 
  8027c3:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8027c5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027cc:	00 00 00 
  8027cf:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027d3:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  8027d7:	be 00 00 00 00       	mov    $0x0,%esi
  8027dc:	bf 03 00 00 00       	mov    $0x3,%edi
  8027e1:	48 b8 06 26 80 00 00 	movabs $0x802606,%rax
  8027e8:	00 00 00 
  8027eb:	ff d0                	callq  *%rax
  8027ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027f4:	79 05                	jns    8027fb <devfile_read+0x5d>
		return r;
  8027f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027f9:	eb 26                	jmp    802821 <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  8027fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027fe:	48 63 d0             	movslq %eax,%rdx
  802801:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802805:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80280c:	00 00 00 
  80280f:	48 89 c7             	mov    %rax,%rdi
  802812:	48 b8 3e 15 80 00 00 	movabs $0x80153e,%rax
  802819:	00 00 00 
  80281c:	ff d0                	callq  *%rax
	return r;
  80281e:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802821:	c9                   	leaveq 
  802822:	c3                   	retq   

0000000000802823 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802823:	55                   	push   %rbp
  802824:	48 89 e5             	mov    %rsp,%rbp
  802827:	48 83 ec 30          	sub    $0x30,%rsp
  80282b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80282f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802833:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  802837:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  80283e:	00 
	n = n > max ? max : n;
  80283f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802843:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802847:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  80284c:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802850:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802854:	8b 50 0c             	mov    0xc(%rax),%edx
  802857:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80285e:	00 00 00 
  802861:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802863:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80286a:	00 00 00 
  80286d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802871:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802875:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802879:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80287d:	48 89 c6             	mov    %rax,%rsi
  802880:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802887:	00 00 00 
  80288a:	48 b8 3e 15 80 00 00 	movabs $0x80153e,%rax
  802891:	00 00 00 
  802894:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  802896:	be 00 00 00 00       	mov    $0x0,%esi
  80289b:	bf 04 00 00 00       	mov    $0x4,%edi
  8028a0:	48 b8 06 26 80 00 00 	movabs $0x802606,%rax
  8028a7:	00 00 00 
  8028aa:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  8028ac:	c9                   	leaveq 
  8028ad:	c3                   	retq   

00000000008028ae <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8028ae:	55                   	push   %rbp
  8028af:	48 89 e5             	mov    %rsp,%rbp
  8028b2:	48 83 ec 20          	sub    $0x20,%rsp
  8028b6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028ba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8028be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c2:	8b 50 0c             	mov    0xc(%rax),%edx
  8028c5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028cc:	00 00 00 
  8028cf:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8028d1:	be 00 00 00 00       	mov    $0x0,%esi
  8028d6:	bf 05 00 00 00       	mov    $0x5,%edi
  8028db:	48 b8 06 26 80 00 00 	movabs $0x802606,%rax
  8028e2:	00 00 00 
  8028e5:	ff d0                	callq  *%rax
  8028e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028ee:	79 05                	jns    8028f5 <devfile_stat+0x47>
		return r;
  8028f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028f3:	eb 56                	jmp    80294b <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8028f5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028f9:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802900:	00 00 00 
  802903:	48 89 c7             	mov    %rax,%rdi
  802906:	48 b8 03 11 80 00 00 	movabs $0x801103,%rax
  80290d:	00 00 00 
  802910:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802912:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802919:	00 00 00 
  80291c:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802922:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802926:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80292c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802933:	00 00 00 
  802936:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80293c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802940:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802946:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80294b:	c9                   	leaveq 
  80294c:	c3                   	retq   

000000000080294d <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80294d:	55                   	push   %rbp
  80294e:	48 89 e5             	mov    %rsp,%rbp
  802951:	48 83 ec 10          	sub    $0x10,%rsp
  802955:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802959:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80295c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802960:	8b 50 0c             	mov    0xc(%rax),%edx
  802963:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80296a:	00 00 00 
  80296d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80296f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802976:	00 00 00 
  802979:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80297c:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80297f:	be 00 00 00 00       	mov    $0x0,%esi
  802984:	bf 02 00 00 00       	mov    $0x2,%edi
  802989:	48 b8 06 26 80 00 00 	movabs $0x802606,%rax
  802990:	00 00 00 
  802993:	ff d0                	callq  *%rax
}
  802995:	c9                   	leaveq 
  802996:	c3                   	retq   

0000000000802997 <remove>:

// Delete a file
int
remove(const char *path)
{
  802997:	55                   	push   %rbp
  802998:	48 89 e5             	mov    %rsp,%rbp
  80299b:	48 83 ec 10          	sub    $0x10,%rsp
  80299f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8029a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029a7:	48 89 c7             	mov    %rax,%rdi
  8029aa:	48 b8 97 10 80 00 00 	movabs $0x801097,%rax
  8029b1:	00 00 00 
  8029b4:	ff d0                	callq  *%rax
  8029b6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8029bb:	7e 07                	jle    8029c4 <remove+0x2d>
		return -E_BAD_PATH;
  8029bd:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8029c2:	eb 33                	jmp    8029f7 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8029c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029c8:	48 89 c6             	mov    %rax,%rsi
  8029cb:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8029d2:	00 00 00 
  8029d5:	48 b8 03 11 80 00 00 	movabs $0x801103,%rax
  8029dc:	00 00 00 
  8029df:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8029e1:	be 00 00 00 00       	mov    $0x0,%esi
  8029e6:	bf 07 00 00 00       	mov    $0x7,%edi
  8029eb:	48 b8 06 26 80 00 00 	movabs $0x802606,%rax
  8029f2:	00 00 00 
  8029f5:	ff d0                	callq  *%rax
}
  8029f7:	c9                   	leaveq 
  8029f8:	c3                   	retq   

00000000008029f9 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8029f9:	55                   	push   %rbp
  8029fa:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8029fd:	be 00 00 00 00       	mov    $0x0,%esi
  802a02:	bf 08 00 00 00       	mov    $0x8,%edi
  802a07:	48 b8 06 26 80 00 00 	movabs $0x802606,%rax
  802a0e:	00 00 00 
  802a11:	ff d0                	callq  *%rax
}
  802a13:	5d                   	pop    %rbp
  802a14:	c3                   	retq   

0000000000802a15 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802a15:	55                   	push   %rbp
  802a16:	48 89 e5             	mov    %rsp,%rbp
  802a19:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802a20:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802a27:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802a2e:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802a35:	be 00 00 00 00       	mov    $0x0,%esi
  802a3a:	48 89 c7             	mov    %rax,%rdi
  802a3d:	48 b8 8d 26 80 00 00 	movabs $0x80268d,%rax
  802a44:	00 00 00 
  802a47:	ff d0                	callq  *%rax
  802a49:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802a4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a50:	79 28                	jns    802a7a <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802a52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a55:	89 c6                	mov    %eax,%esi
  802a57:	48 bf 76 49 80 00 00 	movabs $0x804976,%rdi
  802a5e:	00 00 00 
  802a61:	b8 00 00 00 00       	mov    $0x0,%eax
  802a66:	48 ba 4e 05 80 00 00 	movabs $0x80054e,%rdx
  802a6d:	00 00 00 
  802a70:	ff d2                	callq  *%rdx
		return fd_src;
  802a72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a75:	e9 74 01 00 00       	jmpq   802bee <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802a7a:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802a81:	be 01 01 00 00       	mov    $0x101,%esi
  802a86:	48 89 c7             	mov    %rax,%rdi
  802a89:	48 b8 8d 26 80 00 00 	movabs $0x80268d,%rax
  802a90:	00 00 00 
  802a93:	ff d0                	callq  *%rax
  802a95:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802a98:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a9c:	79 39                	jns    802ad7 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802a9e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802aa1:	89 c6                	mov    %eax,%esi
  802aa3:	48 bf 8c 49 80 00 00 	movabs $0x80498c,%rdi
  802aaa:	00 00 00 
  802aad:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab2:	48 ba 4e 05 80 00 00 	movabs $0x80054e,%rdx
  802ab9:	00 00 00 
  802abc:	ff d2                	callq  *%rdx
		close(fd_src);
  802abe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ac1:	89 c7                	mov    %eax,%edi
  802ac3:	48 b8 95 1f 80 00 00 	movabs $0x801f95,%rax
  802aca:	00 00 00 
  802acd:	ff d0                	callq  *%rax
		return fd_dest;
  802acf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ad2:	e9 17 01 00 00       	jmpq   802bee <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802ad7:	eb 74                	jmp    802b4d <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802ad9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802adc:	48 63 d0             	movslq %eax,%rdx
  802adf:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802ae6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ae9:	48 89 ce             	mov    %rcx,%rsi
  802aec:	89 c7                	mov    %eax,%edi
  802aee:	48 b8 01 23 80 00 00 	movabs $0x802301,%rax
  802af5:	00 00 00 
  802af8:	ff d0                	callq  *%rax
  802afa:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802afd:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802b01:	79 4a                	jns    802b4d <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802b03:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802b06:	89 c6                	mov    %eax,%esi
  802b08:	48 bf a6 49 80 00 00 	movabs $0x8049a6,%rdi
  802b0f:	00 00 00 
  802b12:	b8 00 00 00 00       	mov    $0x0,%eax
  802b17:	48 ba 4e 05 80 00 00 	movabs $0x80054e,%rdx
  802b1e:	00 00 00 
  802b21:	ff d2                	callq  *%rdx
			close(fd_src);
  802b23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b26:	89 c7                	mov    %eax,%edi
  802b28:	48 b8 95 1f 80 00 00 	movabs $0x801f95,%rax
  802b2f:	00 00 00 
  802b32:	ff d0                	callq  *%rax
			close(fd_dest);
  802b34:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b37:	89 c7                	mov    %eax,%edi
  802b39:	48 b8 95 1f 80 00 00 	movabs $0x801f95,%rax
  802b40:	00 00 00 
  802b43:	ff d0                	callq  *%rax
			return write_size;
  802b45:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802b48:	e9 a1 00 00 00       	jmpq   802bee <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802b4d:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802b54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b57:	ba 00 02 00 00       	mov    $0x200,%edx
  802b5c:	48 89 ce             	mov    %rcx,%rsi
  802b5f:	89 c7                	mov    %eax,%edi
  802b61:	48 b8 b7 21 80 00 00 	movabs $0x8021b7,%rax
  802b68:	00 00 00 
  802b6b:	ff d0                	callq  *%rax
  802b6d:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802b70:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802b74:	0f 8f 5f ff ff ff    	jg     802ad9 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802b7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802b7e:	79 47                	jns    802bc7 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802b80:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802b83:	89 c6                	mov    %eax,%esi
  802b85:	48 bf b9 49 80 00 00 	movabs $0x8049b9,%rdi
  802b8c:	00 00 00 
  802b8f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b94:	48 ba 4e 05 80 00 00 	movabs $0x80054e,%rdx
  802b9b:	00 00 00 
  802b9e:	ff d2                	callq  *%rdx
		close(fd_src);
  802ba0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba3:	89 c7                	mov    %eax,%edi
  802ba5:	48 b8 95 1f 80 00 00 	movabs $0x801f95,%rax
  802bac:	00 00 00 
  802baf:	ff d0                	callq  *%rax
		close(fd_dest);
  802bb1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bb4:	89 c7                	mov    %eax,%edi
  802bb6:	48 b8 95 1f 80 00 00 	movabs $0x801f95,%rax
  802bbd:	00 00 00 
  802bc0:	ff d0                	callq  *%rax
		return read_size;
  802bc2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802bc5:	eb 27                	jmp    802bee <copy+0x1d9>
	}
	close(fd_src);
  802bc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bca:	89 c7                	mov    %eax,%edi
  802bcc:	48 b8 95 1f 80 00 00 	movabs $0x801f95,%rax
  802bd3:	00 00 00 
  802bd6:	ff d0                	callq  *%rax
	close(fd_dest);
  802bd8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bdb:	89 c7                	mov    %eax,%edi
  802bdd:	48 b8 95 1f 80 00 00 	movabs $0x801f95,%rax
  802be4:	00 00 00 
  802be7:	ff d0                	callq  *%rax
	return 0;
  802be9:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802bee:	c9                   	leaveq 
  802bef:	c3                   	retq   

0000000000802bf0 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802bf0:	55                   	push   %rbp
  802bf1:	48 89 e5             	mov    %rsp,%rbp
  802bf4:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  802bfb:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  802c02:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802c09:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  802c10:	be 00 00 00 00       	mov    $0x0,%esi
  802c15:	48 89 c7             	mov    %rax,%rdi
  802c18:	48 b8 8d 26 80 00 00 	movabs $0x80268d,%rax
  802c1f:	00 00 00 
  802c22:	ff d0                	callq  *%rax
  802c24:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802c27:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802c2b:	79 08                	jns    802c35 <spawn+0x45>
		return r;
  802c2d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802c30:	e9 14 03 00 00       	jmpq   802f49 <spawn+0x359>
	fd = r;
  802c35:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802c38:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  802c3b:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  802c42:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802c46:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  802c4d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802c50:	ba 00 02 00 00       	mov    $0x200,%edx
  802c55:	48 89 ce             	mov    %rcx,%rsi
  802c58:	89 c7                	mov    %eax,%edi
  802c5a:	48 b8 8c 22 80 00 00 	movabs $0x80228c,%rax
  802c61:	00 00 00 
  802c64:	ff d0                	callq  *%rax
  802c66:	3d 00 02 00 00       	cmp    $0x200,%eax
  802c6b:	75 0d                	jne    802c7a <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  802c6d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c71:	8b 00                	mov    (%rax),%eax
  802c73:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  802c78:	74 43                	je     802cbd <spawn+0xcd>
		close(fd);
  802c7a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802c7d:	89 c7                	mov    %eax,%edi
  802c7f:	48 b8 95 1f 80 00 00 	movabs $0x801f95,%rax
  802c86:	00 00 00 
  802c89:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802c8b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c8f:	8b 00                	mov    (%rax),%eax
  802c91:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802c96:	89 c6                	mov    %eax,%esi
  802c98:	48 bf d0 49 80 00 00 	movabs $0x8049d0,%rdi
  802c9f:	00 00 00 
  802ca2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca7:	48 b9 4e 05 80 00 00 	movabs $0x80054e,%rcx
  802cae:	00 00 00 
  802cb1:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  802cb3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802cb8:	e9 8c 02 00 00       	jmpq   802f49 <spawn+0x359>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802cbd:	b8 07 00 00 00       	mov    $0x7,%eax
  802cc2:	cd 30                	int    $0x30
  802cc4:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802cc7:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802cca:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802ccd:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802cd1:	79 08                	jns    802cdb <spawn+0xeb>
		return r;
  802cd3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802cd6:	e9 6e 02 00 00       	jmpq   802f49 <spawn+0x359>
	child = r;
  802cdb:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802cde:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802ce1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802ce4:	25 ff 03 00 00       	and    $0x3ff,%eax
  802ce9:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802cf0:	00 00 00 
  802cf3:	48 63 d0             	movslq %eax,%rdx
  802cf6:	48 89 d0             	mov    %rdx,%rax
  802cf9:	48 c1 e0 03          	shl    $0x3,%rax
  802cfd:	48 01 d0             	add    %rdx,%rax
  802d00:	48 c1 e0 05          	shl    $0x5,%rax
  802d04:	48 01 c8             	add    %rcx,%rax
  802d07:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  802d0e:	48 89 c6             	mov    %rax,%rsi
  802d11:	b8 18 00 00 00       	mov    $0x18,%eax
  802d16:	48 89 d7             	mov    %rdx,%rdi
  802d19:	48 89 c1             	mov    %rax,%rcx
  802d1c:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  802d1f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d23:	48 8b 40 18          	mov    0x18(%rax),%rax
  802d27:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  802d2e:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  802d35:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  802d3c:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  802d43:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802d46:	48 89 ce             	mov    %rcx,%rsi
  802d49:	89 c7                	mov    %eax,%edi
  802d4b:	48 b8 b3 31 80 00 00 	movabs $0x8031b3,%rax
  802d52:	00 00 00 
  802d55:	ff d0                	callq  *%rax
  802d57:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802d5a:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802d5e:	79 08                	jns    802d68 <spawn+0x178>
		return r;
  802d60:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802d63:	e9 e1 01 00 00       	jmpq   802f49 <spawn+0x359>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802d68:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d6c:	48 8b 40 20          	mov    0x20(%rax),%rax
  802d70:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  802d77:	48 01 d0             	add    %rdx,%rax
  802d7a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802d7e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802d85:	e9 a3 00 00 00       	jmpq   802e2d <spawn+0x23d>
		if (ph->p_type != ELF_PROG_LOAD)
  802d8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d8e:	8b 00                	mov    (%rax),%eax
  802d90:	83 f8 01             	cmp    $0x1,%eax
  802d93:	74 05                	je     802d9a <spawn+0x1aa>
			continue;
  802d95:	e9 8a 00 00 00       	jmpq   802e24 <spawn+0x234>
		perm = PTE_P | PTE_U;
  802d9a:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802da1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802da5:	8b 40 04             	mov    0x4(%rax),%eax
  802da8:	83 e0 02             	and    $0x2,%eax
  802dab:	85 c0                	test   %eax,%eax
  802dad:	74 04                	je     802db3 <spawn+0x1c3>
			perm |= PTE_W;
  802daf:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  802db3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802db7:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802dbb:	41 89 c1             	mov    %eax,%r9d
  802dbe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dc2:	4c 8b 40 20          	mov    0x20(%rax),%r8
  802dc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dca:	48 8b 50 28          	mov    0x28(%rax),%rdx
  802dce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dd2:	48 8b 70 10          	mov    0x10(%rax),%rsi
  802dd6:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802dd9:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802ddc:	8b 7d ec             	mov    -0x14(%rbp),%edi
  802ddf:	89 3c 24             	mov    %edi,(%rsp)
  802de2:	89 c7                	mov    %eax,%edi
  802de4:	48 b8 5c 34 80 00 00 	movabs $0x80345c,%rax
  802deb:	00 00 00 
  802dee:	ff d0                	callq  *%rax
  802df0:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802df3:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802df7:	79 2b                	jns    802e24 <spawn+0x234>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  802df9:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  802dfa:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802dfd:	89 c7                	mov    %eax,%edi
  802dff:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  802e06:	00 00 00 
  802e09:	ff d0                	callq  *%rax
	close(fd);
  802e0b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802e0e:	89 c7                	mov    %eax,%edi
  802e10:	48 b8 95 1f 80 00 00 	movabs $0x801f95,%rax
  802e17:	00 00 00 
  802e1a:	ff d0                	callq  *%rax
	return r;
  802e1c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e1f:	e9 25 01 00 00       	jmpq   802f49 <spawn+0x359>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802e24:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802e28:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  802e2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e31:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  802e35:	0f b7 c0             	movzwl %ax,%eax
  802e38:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802e3b:	0f 8f 49 ff ff ff    	jg     802d8a <spawn+0x19a>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802e41:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802e44:	89 c7                	mov    %eax,%edi
  802e46:	48 b8 95 1f 80 00 00 	movabs $0x801f95,%rax
  802e4d:	00 00 00 
  802e50:	ff d0                	callq  *%rax
	fd = -1;
  802e52:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  802e59:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802e5c:	89 c7                	mov    %eax,%edi
  802e5e:	48 b8 48 36 80 00 00 	movabs $0x803648,%rax
  802e65:	00 00 00 
  802e68:	ff d0                	callq  *%rax
  802e6a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802e6d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802e71:	79 30                	jns    802ea3 <spawn+0x2b3>
		panic("copy_shared_pages: %e", r);
  802e73:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e76:	89 c1                	mov    %eax,%ecx
  802e78:	48 ba ea 49 80 00 00 	movabs $0x8049ea,%rdx
  802e7f:	00 00 00 
  802e82:	be 82 00 00 00       	mov    $0x82,%esi
  802e87:	48 bf 00 4a 80 00 00 	movabs $0x804a00,%rdi
  802e8e:	00 00 00 
  802e91:	b8 00 00 00 00       	mov    $0x0,%eax
  802e96:	49 b8 15 03 80 00 00 	movabs $0x800315,%r8
  802e9d:	00 00 00 
  802ea0:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802ea3:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  802eaa:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802ead:	48 89 d6             	mov    %rdx,%rsi
  802eb0:	89 c7                	mov    %eax,%edi
  802eb2:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  802eb9:	00 00 00 
  802ebc:	ff d0                	callq  *%rax
  802ebe:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802ec1:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802ec5:	79 30                	jns    802ef7 <spawn+0x307>
		panic("sys_env_set_trapframe: %e", r);
  802ec7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802eca:	89 c1                	mov    %eax,%ecx
  802ecc:	48 ba 0c 4a 80 00 00 	movabs $0x804a0c,%rdx
  802ed3:	00 00 00 
  802ed6:	be 85 00 00 00       	mov    $0x85,%esi
  802edb:	48 bf 00 4a 80 00 00 	movabs $0x804a00,%rdi
  802ee2:	00 00 00 
  802ee5:	b8 00 00 00 00       	mov    $0x0,%eax
  802eea:	49 b8 15 03 80 00 00 	movabs $0x800315,%r8
  802ef1:	00 00 00 
  802ef4:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802ef7:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802efa:	be 02 00 00 00       	mov    $0x2,%esi
  802eff:	89 c7                	mov    %eax,%edi
  802f01:	48 b8 27 1b 80 00 00 	movabs $0x801b27,%rax
  802f08:	00 00 00 
  802f0b:	ff d0                	callq  *%rax
  802f0d:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802f10:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802f14:	79 30                	jns    802f46 <spawn+0x356>
		panic("sys_env_set_status: %e", r);
  802f16:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802f19:	89 c1                	mov    %eax,%ecx
  802f1b:	48 ba 26 4a 80 00 00 	movabs $0x804a26,%rdx
  802f22:	00 00 00 
  802f25:	be 88 00 00 00       	mov    $0x88,%esi
  802f2a:	48 bf 00 4a 80 00 00 	movabs $0x804a00,%rdi
  802f31:	00 00 00 
  802f34:	b8 00 00 00 00       	mov    $0x0,%eax
  802f39:	49 b8 15 03 80 00 00 	movabs $0x800315,%r8
  802f40:	00 00 00 
  802f43:	41 ff d0             	callq  *%r8

	return child;
  802f46:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  802f49:	c9                   	leaveq 
  802f4a:	c3                   	retq   

0000000000802f4b <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  802f4b:	55                   	push   %rbp
  802f4c:	48 89 e5             	mov    %rsp,%rbp
  802f4f:	41 55                	push   %r13
  802f51:	41 54                	push   %r12
  802f53:	53                   	push   %rbx
  802f54:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  802f5b:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  802f62:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  802f69:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  802f70:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  802f77:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  802f7e:	84 c0                	test   %al,%al
  802f80:	74 26                	je     802fa8 <spawnl+0x5d>
  802f82:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  802f89:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  802f90:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  802f94:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  802f98:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  802f9c:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  802fa0:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  802fa4:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  802fa8:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  802faf:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  802fb6:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  802fb9:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  802fc0:	00 00 00 
  802fc3:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  802fca:	00 00 00 
  802fcd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802fd1:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  802fd8:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  802fdf:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  802fe6:	eb 07                	jmp    802fef <spawnl+0xa4>
		argc++;
  802fe8:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802fef:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  802ff5:	83 f8 30             	cmp    $0x30,%eax
  802ff8:	73 23                	jae    80301d <spawnl+0xd2>
  802ffa:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803001:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803007:	89 c0                	mov    %eax,%eax
  803009:	48 01 d0             	add    %rdx,%rax
  80300c:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803012:	83 c2 08             	add    $0x8,%edx
  803015:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  80301b:	eb 15                	jmp    803032 <spawnl+0xe7>
  80301d:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803024:	48 89 d0             	mov    %rdx,%rax
  803027:	48 83 c2 08          	add    $0x8,%rdx
  80302b:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803032:	48 8b 00             	mov    (%rax),%rax
  803035:	48 85 c0             	test   %rax,%rax
  803038:	75 ae                	jne    802fe8 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  80303a:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803040:	83 c0 02             	add    $0x2,%eax
  803043:	48 89 e2             	mov    %rsp,%rdx
  803046:	48 89 d3             	mov    %rdx,%rbx
  803049:	48 63 d0             	movslq %eax,%rdx
  80304c:	48 83 ea 01          	sub    $0x1,%rdx
  803050:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  803057:	48 63 d0             	movslq %eax,%rdx
  80305a:	49 89 d4             	mov    %rdx,%r12
  80305d:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  803063:	48 63 d0             	movslq %eax,%rdx
  803066:	49 89 d2             	mov    %rdx,%r10
  803069:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  80306f:	48 98                	cltq   
  803071:	48 c1 e0 03          	shl    $0x3,%rax
  803075:	48 8d 50 07          	lea    0x7(%rax),%rdx
  803079:	b8 10 00 00 00       	mov    $0x10,%eax
  80307e:	48 83 e8 01          	sub    $0x1,%rax
  803082:	48 01 d0             	add    %rdx,%rax
  803085:	bf 10 00 00 00       	mov    $0x10,%edi
  80308a:	ba 00 00 00 00       	mov    $0x0,%edx
  80308f:	48 f7 f7             	div    %rdi
  803092:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803096:	48 29 c4             	sub    %rax,%rsp
  803099:	48 89 e0             	mov    %rsp,%rax
  80309c:	48 83 c0 07          	add    $0x7,%rax
  8030a0:	48 c1 e8 03          	shr    $0x3,%rax
  8030a4:	48 c1 e0 03          	shl    $0x3,%rax
  8030a8:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  8030af:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8030b6:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  8030bd:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  8030c0:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8030c6:	8d 50 01             	lea    0x1(%rax),%edx
  8030c9:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8030d0:	48 63 d2             	movslq %edx,%rdx
  8030d3:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  8030da:	00 

	va_start(vl, arg0);
  8030db:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  8030e2:	00 00 00 
  8030e5:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  8030ec:	00 00 00 
  8030ef:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8030f3:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  8030fa:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803101:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  803108:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  80310f:	00 00 00 
  803112:	eb 63                	jmp    803177 <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  803114:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  80311a:	8d 70 01             	lea    0x1(%rax),%esi
  80311d:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803123:	83 f8 30             	cmp    $0x30,%eax
  803126:	73 23                	jae    80314b <spawnl+0x200>
  803128:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  80312f:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803135:	89 c0                	mov    %eax,%eax
  803137:	48 01 d0             	add    %rdx,%rax
  80313a:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803140:	83 c2 08             	add    $0x8,%edx
  803143:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803149:	eb 15                	jmp    803160 <spawnl+0x215>
  80314b:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803152:	48 89 d0             	mov    %rdx,%rax
  803155:	48 83 c2 08          	add    $0x8,%rdx
  803159:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803160:	48 8b 08             	mov    (%rax),%rcx
  803163:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80316a:	89 f2                	mov    %esi,%edx
  80316c:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  803170:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  803177:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80317d:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  803183:	77 8f                	ja     803114 <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  803185:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80318c:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  803193:	48 89 d6             	mov    %rdx,%rsi
  803196:	48 89 c7             	mov    %rax,%rdi
  803199:	48 b8 f0 2b 80 00 00 	movabs $0x802bf0,%rax
  8031a0:	00 00 00 
  8031a3:	ff d0                	callq  *%rax
  8031a5:	48 89 dc             	mov    %rbx,%rsp
}
  8031a8:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  8031ac:	5b                   	pop    %rbx
  8031ad:	41 5c                	pop    %r12
  8031af:	41 5d                	pop    %r13
  8031b1:	5d                   	pop    %rbp
  8031b2:	c3                   	retq   

00000000008031b3 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  8031b3:	55                   	push   %rbp
  8031b4:	48 89 e5             	mov    %rsp,%rbp
  8031b7:	48 83 ec 50          	sub    $0x50,%rsp
  8031bb:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8031be:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8031c2:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  8031c6:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8031cd:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  8031ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  8031d5:	eb 33                	jmp    80320a <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  8031d7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8031da:	48 98                	cltq   
  8031dc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8031e3:	00 
  8031e4:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8031e8:	48 01 d0             	add    %rdx,%rax
  8031eb:	48 8b 00             	mov    (%rax),%rax
  8031ee:	48 89 c7             	mov    %rax,%rdi
  8031f1:	48 b8 97 10 80 00 00 	movabs $0x801097,%rax
  8031f8:	00 00 00 
  8031fb:	ff d0                	callq  *%rax
  8031fd:	83 c0 01             	add    $0x1,%eax
  803200:	48 98                	cltq   
  803202:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  803206:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  80320a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80320d:	48 98                	cltq   
  80320f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803216:	00 
  803217:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80321b:	48 01 d0             	add    %rdx,%rax
  80321e:	48 8b 00             	mov    (%rax),%rax
  803221:	48 85 c0             	test   %rax,%rax
  803224:	75 b1                	jne    8031d7 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  803226:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80322a:	48 f7 d8             	neg    %rax
  80322d:	48 05 00 10 40 00    	add    $0x401000,%rax
  803233:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  803237:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80323b:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80323f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803243:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  803247:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80324a:	83 c2 01             	add    $0x1,%edx
  80324d:	c1 e2 03             	shl    $0x3,%edx
  803250:	48 63 d2             	movslq %edx,%rdx
  803253:	48 f7 da             	neg    %rdx
  803256:	48 01 d0             	add    %rdx,%rax
  803259:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80325d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803261:	48 83 e8 10          	sub    $0x10,%rax
  803265:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  80326b:	77 0a                	ja     803277 <init_stack+0xc4>
		return -E_NO_MEM;
  80326d:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  803272:	e9 e3 01 00 00       	jmpq   80345a <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803277:	ba 07 00 00 00       	mov    $0x7,%edx
  80327c:	be 00 00 40 00       	mov    $0x400000,%esi
  803281:	bf 00 00 00 00       	mov    $0x0,%edi
  803286:	48 b8 32 1a 80 00 00 	movabs $0x801a32,%rax
  80328d:	00 00 00 
  803290:	ff d0                	callq  *%rax
  803292:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803295:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803299:	79 08                	jns    8032a3 <init_stack+0xf0>
		return r;
  80329b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80329e:	e9 b7 01 00 00       	jmpq   80345a <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8032a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  8032aa:	e9 8a 00 00 00       	jmpq   803339 <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  8032af:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8032b2:	48 98                	cltq   
  8032b4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8032bb:	00 
  8032bc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032c0:	48 01 c2             	add    %rax,%rdx
  8032c3:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8032c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032cc:	48 01 c8             	add    %rcx,%rax
  8032cf:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8032d5:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  8032d8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8032db:	48 98                	cltq   
  8032dd:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8032e4:	00 
  8032e5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8032e9:	48 01 d0             	add    %rdx,%rax
  8032ec:	48 8b 10             	mov    (%rax),%rdx
  8032ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032f3:	48 89 d6             	mov    %rdx,%rsi
  8032f6:	48 89 c7             	mov    %rax,%rdi
  8032f9:	48 b8 03 11 80 00 00 	movabs $0x801103,%rax
  803300:	00 00 00 
  803303:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803305:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803308:	48 98                	cltq   
  80330a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803311:	00 
  803312:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803316:	48 01 d0             	add    %rdx,%rax
  803319:	48 8b 00             	mov    (%rax),%rax
  80331c:	48 89 c7             	mov    %rax,%rdi
  80331f:	48 b8 97 10 80 00 00 	movabs $0x801097,%rax
  803326:	00 00 00 
  803329:	ff d0                	callq  *%rax
  80332b:	48 98                	cltq   
  80332d:	48 83 c0 01          	add    $0x1,%rax
  803331:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803335:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  803339:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80333c:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80333f:	0f 8c 6a ff ff ff    	jl     8032af <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  803345:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803348:	48 98                	cltq   
  80334a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803351:	00 
  803352:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803356:	48 01 d0             	add    %rdx,%rax
  803359:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  803360:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  803367:	00 
  803368:	74 35                	je     80339f <init_stack+0x1ec>
  80336a:	48 b9 40 4a 80 00 00 	movabs $0x804a40,%rcx
  803371:	00 00 00 
  803374:	48 ba 66 4a 80 00 00 	movabs $0x804a66,%rdx
  80337b:	00 00 00 
  80337e:	be f1 00 00 00       	mov    $0xf1,%esi
  803383:	48 bf 00 4a 80 00 00 	movabs $0x804a00,%rdi
  80338a:	00 00 00 
  80338d:	b8 00 00 00 00       	mov    $0x0,%eax
  803392:	49 b8 15 03 80 00 00 	movabs $0x800315,%r8
  803399:	00 00 00 
  80339c:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  80339f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033a3:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  8033a7:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8033ac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033b0:	48 01 c8             	add    %rcx,%rax
  8033b3:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8033b9:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  8033bc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033c0:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  8033c4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8033c7:	48 98                	cltq   
  8033c9:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8033cc:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  8033d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033d5:	48 01 d0             	add    %rdx,%rax
  8033d8:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8033de:	48 89 c2             	mov    %rax,%rdx
  8033e1:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8033e5:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8033e8:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8033eb:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8033f1:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8033f6:	89 c2                	mov    %eax,%edx
  8033f8:	be 00 00 40 00       	mov    $0x400000,%esi
  8033fd:	bf 00 00 00 00       	mov    $0x0,%edi
  803402:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  803409:	00 00 00 
  80340c:	ff d0                	callq  *%rax
  80340e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803411:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803415:	79 02                	jns    803419 <init_stack+0x266>
		goto error;
  803417:	eb 28                	jmp    803441 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803419:	be 00 00 40 00       	mov    $0x400000,%esi
  80341e:	bf 00 00 00 00       	mov    $0x0,%edi
  803423:	48 b8 dd 1a 80 00 00 	movabs $0x801add,%rax
  80342a:	00 00 00 
  80342d:	ff d0                	callq  *%rax
  80342f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803432:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803436:	79 02                	jns    80343a <init_stack+0x287>
		goto error;
  803438:	eb 07                	jmp    803441 <init_stack+0x28e>

	return 0;
  80343a:	b8 00 00 00 00       	mov    $0x0,%eax
  80343f:	eb 19                	jmp    80345a <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  803441:	be 00 00 40 00       	mov    $0x400000,%esi
  803446:	bf 00 00 00 00       	mov    $0x0,%edi
  80344b:	48 b8 dd 1a 80 00 00 	movabs $0x801add,%rax
  803452:	00 00 00 
  803455:	ff d0                	callq  *%rax
	return r;
  803457:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80345a:	c9                   	leaveq 
  80345b:	c3                   	retq   

000000000080345c <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  80345c:	55                   	push   %rbp
  80345d:	48 89 e5             	mov    %rsp,%rbp
  803460:	48 83 ec 50          	sub    $0x50,%rsp
  803464:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803467:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80346b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80346f:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803472:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803476:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  80347a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80347e:	25 ff 0f 00 00       	and    $0xfff,%eax
  803483:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803486:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80348a:	74 21                	je     8034ad <map_segment+0x51>
		va -= i;
  80348c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80348f:	48 98                	cltq   
  803491:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803495:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803498:	48 98                	cltq   
  80349a:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  80349e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a1:	48 98                	cltq   
  8034a3:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  8034a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034aa:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8034ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8034b4:	e9 79 01 00 00       	jmpq   803632 <map_segment+0x1d6>
		if (i >= filesz) {
  8034b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034bc:	48 98                	cltq   
  8034be:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  8034c2:	72 3c                	jb     803500 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8034c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034c7:	48 63 d0             	movslq %eax,%rdx
  8034ca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034ce:	48 01 d0             	add    %rdx,%rax
  8034d1:	48 89 c1             	mov    %rax,%rcx
  8034d4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8034d7:	8b 55 10             	mov    0x10(%rbp),%edx
  8034da:	48 89 ce             	mov    %rcx,%rsi
  8034dd:	89 c7                	mov    %eax,%edi
  8034df:	48 b8 32 1a 80 00 00 	movabs $0x801a32,%rax
  8034e6:	00 00 00 
  8034e9:	ff d0                	callq  *%rax
  8034eb:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8034ee:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8034f2:	0f 89 33 01 00 00    	jns    80362b <map_segment+0x1cf>
				return r;
  8034f8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034fb:	e9 46 01 00 00       	jmpq   803646 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803500:	ba 07 00 00 00       	mov    $0x7,%edx
  803505:	be 00 00 40 00       	mov    $0x400000,%esi
  80350a:	bf 00 00 00 00       	mov    $0x0,%edi
  80350f:	48 b8 32 1a 80 00 00 	movabs $0x801a32,%rax
  803516:	00 00 00 
  803519:	ff d0                	callq  *%rax
  80351b:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80351e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803522:	79 08                	jns    80352c <map_segment+0xd0>
				return r;
  803524:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803527:	e9 1a 01 00 00       	jmpq   803646 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  80352c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80352f:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803532:	01 c2                	add    %eax,%edx
  803534:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803537:	89 d6                	mov    %edx,%esi
  803539:	89 c7                	mov    %eax,%edi
  80353b:	48 b8 d5 23 80 00 00 	movabs $0x8023d5,%rax
  803542:	00 00 00 
  803545:	ff d0                	callq  *%rax
  803547:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80354a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80354e:	79 08                	jns    803558 <map_segment+0xfc>
				return r;
  803550:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803553:	e9 ee 00 00 00       	jmpq   803646 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  803558:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  80355f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803562:	48 98                	cltq   
  803564:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803568:	48 29 c2             	sub    %rax,%rdx
  80356b:	48 89 d0             	mov    %rdx,%rax
  80356e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803572:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803575:	48 63 d0             	movslq %eax,%rdx
  803578:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80357c:	48 39 c2             	cmp    %rax,%rdx
  80357f:	48 0f 47 d0          	cmova  %rax,%rdx
  803583:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803586:	be 00 00 40 00       	mov    $0x400000,%esi
  80358b:	89 c7                	mov    %eax,%edi
  80358d:	48 b8 8c 22 80 00 00 	movabs $0x80228c,%rax
  803594:	00 00 00 
  803597:	ff d0                	callq  *%rax
  803599:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80359c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8035a0:	79 08                	jns    8035aa <map_segment+0x14e>
				return r;
  8035a2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035a5:	e9 9c 00 00 00       	jmpq   803646 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8035aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ad:	48 63 d0             	movslq %eax,%rdx
  8035b0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035b4:	48 01 d0             	add    %rdx,%rax
  8035b7:	48 89 c2             	mov    %rax,%rdx
  8035ba:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8035bd:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  8035c1:	48 89 d1             	mov    %rdx,%rcx
  8035c4:	89 c2                	mov    %eax,%edx
  8035c6:	be 00 00 40 00       	mov    $0x400000,%esi
  8035cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8035d0:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  8035d7:	00 00 00 
  8035da:	ff d0                	callq  *%rax
  8035dc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8035df:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8035e3:	79 30                	jns    803615 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  8035e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035e8:	89 c1                	mov    %eax,%ecx
  8035ea:	48 ba 7b 4a 80 00 00 	movabs $0x804a7b,%rdx
  8035f1:	00 00 00 
  8035f4:	be 24 01 00 00       	mov    $0x124,%esi
  8035f9:	48 bf 00 4a 80 00 00 	movabs $0x804a00,%rdi
  803600:	00 00 00 
  803603:	b8 00 00 00 00       	mov    $0x0,%eax
  803608:	49 b8 15 03 80 00 00 	movabs $0x800315,%r8
  80360f:	00 00 00 
  803612:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803615:	be 00 00 40 00       	mov    $0x400000,%esi
  80361a:	bf 00 00 00 00       	mov    $0x0,%edi
  80361f:	48 b8 dd 1a 80 00 00 	movabs $0x801add,%rax
  803626:	00 00 00 
  803629:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80362b:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803632:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803635:	48 98                	cltq   
  803637:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80363b:	0f 82 78 fe ff ff    	jb     8034b9 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  803641:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803646:	c9                   	leaveq 
  803647:	c3                   	retq   

0000000000803648 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803648:	55                   	push   %rbp
  803649:	48 89 e5             	mov    %rsp,%rbp
  80364c:	48 83 ec 70          	sub    $0x70,%rsp
  803650:	89 7d 9c             	mov    %edi,-0x64(%rbp)
	// LAB 5: Your code here.
	int r, perm;
	void* va;
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  803653:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80365a:	00 
  80365b:	e9 70 01 00 00       	jmpq   8037d0 <copy_shared_pages+0x188>
		if(uvpml4e[pml4e] & PTE_P){
  803660:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803667:	01 00 00 
  80366a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80366e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803672:	83 e0 01             	and    $0x1,%eax
  803675:	48 85 c0             	test   %rax,%rax
  803678:	0f 84 4d 01 00 00    	je     8037cb <copy_shared_pages+0x183>
			base_pml4e = pml4e * NPDPENTRIES;
  80367e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803682:	48 c1 e0 09          	shl    $0x9,%rax
  803686:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  80368a:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  803691:	00 
  803692:	e9 26 01 00 00       	jmpq   8037bd <copy_shared_pages+0x175>
				if(uvpde[base_pml4e + pdpe] & PTE_P){
  803697:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80369b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80369f:	48 01 c2             	add    %rax,%rdx
  8036a2:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8036a9:	01 00 00 
  8036ac:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8036b0:	83 e0 01             	and    $0x1,%eax
  8036b3:	48 85 c0             	test   %rax,%rax
  8036b6:	0f 84 fc 00 00 00    	je     8037b8 <copy_shared_pages+0x170>
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
  8036bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036c0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8036c4:	48 01 d0             	add    %rdx,%rax
  8036c7:	48 c1 e0 09          	shl    $0x9,%rax
  8036cb:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
					for(pde = 0; pde < NPDENTRIES; pde++){
  8036cf:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8036d6:	00 
  8036d7:	e9 ce 00 00 00       	jmpq   8037aa <copy_shared_pages+0x162>
						if(uvpd[base_pdpe + pde] & PTE_P){
  8036dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036e0:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8036e4:	48 01 c2             	add    %rax,%rdx
  8036e7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8036ee:	01 00 00 
  8036f1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8036f5:	83 e0 01             	and    $0x1,%eax
  8036f8:	48 85 c0             	test   %rax,%rax
  8036fb:	0f 84 a4 00 00 00    	je     8037a5 <copy_shared_pages+0x15d>
							base_pde = (base_pdpe + pde) * NPTENTRIES;
  803701:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803705:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  803709:	48 01 d0             	add    %rdx,%rax
  80370c:	48 c1 e0 09          	shl    $0x9,%rax
  803710:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
							for(pte = 0; pte < NPTENTRIES; pte++){
  803714:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  80371b:	00 
  80371c:	eb 79                	jmp    803797 <copy_shared_pages+0x14f>
								entry = base_pde + pte;
  80371e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803722:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803726:	48 01 d0             	add    %rdx,%rax
  803729:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
								perm = uvpt[entry] & PTE_SYSCALL;
  80372d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803734:	01 00 00 
  803737:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80373b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80373f:	25 07 0e 00 00       	and    $0xe07,%eax
  803744:	89 45 bc             	mov    %eax,-0x44(%rbp)
								if(perm & PTE_SHARE){
  803747:	8b 45 bc             	mov    -0x44(%rbp),%eax
  80374a:	25 00 04 00 00       	and    $0x400,%eax
  80374f:	85 c0                	test   %eax,%eax
  803751:	74 3f                	je     803792 <copy_shared_pages+0x14a>
									va = (void*)(PGSIZE * entry);
  803753:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803757:	48 c1 e0 0c          	shl    $0xc,%rax
  80375b:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
									r = sys_page_map(0, va, child, va, perm);		
  80375f:	8b 75 bc             	mov    -0x44(%rbp),%esi
  803762:	48 8b 4d b0          	mov    -0x50(%rbp),%rcx
  803766:	8b 55 9c             	mov    -0x64(%rbp),%edx
  803769:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80376d:	41 89 f0             	mov    %esi,%r8d
  803770:	48 89 c6             	mov    %rax,%rsi
  803773:	bf 00 00 00 00       	mov    $0x0,%edi
  803778:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  80377f:	00 00 00 
  803782:	ff d0                	callq  *%rax
  803784:	89 45 ac             	mov    %eax,-0x54(%rbp)
									if(r < 0) return r;
  803787:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80378b:	79 05                	jns    803792 <copy_shared_pages+0x14a>
  80378d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  803790:	eb 4e                	jmp    8037e0 <copy_shared_pages+0x198>
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
						if(uvpd[base_pdpe + pde] & PTE_P){
							base_pde = (base_pdpe + pde) * NPTENTRIES;
							for(pte = 0; pte < NPTENTRIES; pte++){
  803792:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  803797:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  80379e:	00 
  80379f:	0f 86 79 ff ff ff    	jbe    80371e <copy_shared_pages+0xd6>
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
  8037a5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8037aa:	48 81 7d e8 ff 01 00 	cmpq   $0x1ff,-0x18(%rbp)
  8037b1:	00 
  8037b2:	0f 86 24 ff ff ff    	jbe    8036dc <copy_shared_pages+0x94>
	void* va;
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  8037b8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  8037bd:	48 81 7d f0 ff 01 00 	cmpq   $0x1ff,-0x10(%rbp)
  8037c4:	00 
  8037c5:	0f 86 cc fe ff ff    	jbe    803697 <copy_shared_pages+0x4f>
{
	// LAB 5: Your code here.
	int r, perm;
	void* va;
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  8037cb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8037d0:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8037d5:	0f 84 85 fe ff ff    	je     803660 <copy_shared_pages+0x18>
					}
				}
			}
		}
	}
	return 0;
  8037db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037e0:	c9                   	leaveq 
  8037e1:	c3                   	retq   

00000000008037e2 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8037e2:	55                   	push   %rbp
  8037e3:	48 89 e5             	mov    %rsp,%rbp
  8037e6:	53                   	push   %rbx
  8037e7:	48 83 ec 38          	sub    $0x38,%rsp
  8037eb:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8037ef:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8037f3:	48 89 c7             	mov    %rax,%rdi
  8037f6:	48 b8 ed 1c 80 00 00 	movabs $0x801ced,%rax
  8037fd:	00 00 00 
  803800:	ff d0                	callq  *%rax
  803802:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803805:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803809:	0f 88 bf 01 00 00    	js     8039ce <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80380f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803813:	ba 07 04 00 00       	mov    $0x407,%edx
  803818:	48 89 c6             	mov    %rax,%rsi
  80381b:	bf 00 00 00 00       	mov    $0x0,%edi
  803820:	48 b8 32 1a 80 00 00 	movabs $0x801a32,%rax
  803827:	00 00 00 
  80382a:	ff d0                	callq  *%rax
  80382c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80382f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803833:	0f 88 95 01 00 00    	js     8039ce <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803839:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80383d:	48 89 c7             	mov    %rax,%rdi
  803840:	48 b8 ed 1c 80 00 00 	movabs $0x801ced,%rax
  803847:	00 00 00 
  80384a:	ff d0                	callq  *%rax
  80384c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80384f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803853:	0f 88 5d 01 00 00    	js     8039b6 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803859:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80385d:	ba 07 04 00 00       	mov    $0x407,%edx
  803862:	48 89 c6             	mov    %rax,%rsi
  803865:	bf 00 00 00 00       	mov    $0x0,%edi
  80386a:	48 b8 32 1a 80 00 00 	movabs $0x801a32,%rax
  803871:	00 00 00 
  803874:	ff d0                	callq  *%rax
  803876:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803879:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80387d:	0f 88 33 01 00 00    	js     8039b6 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803883:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803887:	48 89 c7             	mov    %rax,%rdi
  80388a:	48 b8 c2 1c 80 00 00 	movabs $0x801cc2,%rax
  803891:	00 00 00 
  803894:	ff d0                	callq  *%rax
  803896:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80389a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80389e:	ba 07 04 00 00       	mov    $0x407,%edx
  8038a3:	48 89 c6             	mov    %rax,%rsi
  8038a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8038ab:	48 b8 32 1a 80 00 00 	movabs $0x801a32,%rax
  8038b2:	00 00 00 
  8038b5:	ff d0                	callq  *%rax
  8038b7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038be:	79 05                	jns    8038c5 <pipe+0xe3>
		goto err2;
  8038c0:	e9 d9 00 00 00       	jmpq   80399e <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8038c5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038c9:	48 89 c7             	mov    %rax,%rdi
  8038cc:	48 b8 c2 1c 80 00 00 	movabs $0x801cc2,%rax
  8038d3:	00 00 00 
  8038d6:	ff d0                	callq  *%rax
  8038d8:	48 89 c2             	mov    %rax,%rdx
  8038db:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038df:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8038e5:	48 89 d1             	mov    %rdx,%rcx
  8038e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8038ed:	48 89 c6             	mov    %rax,%rsi
  8038f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8038f5:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  8038fc:	00 00 00 
  8038ff:	ff d0                	callq  *%rax
  803901:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803904:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803908:	79 1b                	jns    803925 <pipe+0x143>
		goto err3;
  80390a:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80390b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80390f:	48 89 c6             	mov    %rax,%rsi
  803912:	bf 00 00 00 00       	mov    $0x0,%edi
  803917:	48 b8 dd 1a 80 00 00 	movabs $0x801add,%rax
  80391e:	00 00 00 
  803921:	ff d0                	callq  *%rax
  803923:	eb 79                	jmp    80399e <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803925:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803929:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803930:	00 00 00 
  803933:	8b 12                	mov    (%rdx),%edx
  803935:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803937:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80393b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803942:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803946:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  80394d:	00 00 00 
  803950:	8b 12                	mov    (%rdx),%edx
  803952:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803954:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803958:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80395f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803963:	48 89 c7             	mov    %rax,%rdi
  803966:	48 b8 9f 1c 80 00 00 	movabs $0x801c9f,%rax
  80396d:	00 00 00 
  803970:	ff d0                	callq  *%rax
  803972:	89 c2                	mov    %eax,%edx
  803974:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803978:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80397a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80397e:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803982:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803986:	48 89 c7             	mov    %rax,%rdi
  803989:	48 b8 9f 1c 80 00 00 	movabs $0x801c9f,%rax
  803990:	00 00 00 
  803993:	ff d0                	callq  *%rax
  803995:	89 03                	mov    %eax,(%rbx)
	return 0;
  803997:	b8 00 00 00 00       	mov    $0x0,%eax
  80399c:	eb 33                	jmp    8039d1 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80399e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039a2:	48 89 c6             	mov    %rax,%rsi
  8039a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8039aa:	48 b8 dd 1a 80 00 00 	movabs $0x801add,%rax
  8039b1:	00 00 00 
  8039b4:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8039b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039ba:	48 89 c6             	mov    %rax,%rsi
  8039bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8039c2:	48 b8 dd 1a 80 00 00 	movabs $0x801add,%rax
  8039c9:	00 00 00 
  8039cc:	ff d0                	callq  *%rax
err:
	return r;
  8039ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8039d1:	48 83 c4 38          	add    $0x38,%rsp
  8039d5:	5b                   	pop    %rbx
  8039d6:	5d                   	pop    %rbp
  8039d7:	c3                   	retq   

00000000008039d8 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8039d8:	55                   	push   %rbp
  8039d9:	48 89 e5             	mov    %rsp,%rbp
  8039dc:	53                   	push   %rbx
  8039dd:	48 83 ec 28          	sub    $0x28,%rsp
  8039e1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039e5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8039e9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8039f0:	00 00 00 
  8039f3:	48 8b 00             	mov    (%rax),%rax
  8039f6:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8039fc:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8039ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a03:	48 89 c7             	mov    %rax,%rdi
  803a06:	48 b8 43 42 80 00 00 	movabs $0x804243,%rax
  803a0d:	00 00 00 
  803a10:	ff d0                	callq  *%rax
  803a12:	89 c3                	mov    %eax,%ebx
  803a14:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a18:	48 89 c7             	mov    %rax,%rdi
  803a1b:	48 b8 43 42 80 00 00 	movabs $0x804243,%rax
  803a22:	00 00 00 
  803a25:	ff d0                	callq  *%rax
  803a27:	39 c3                	cmp    %eax,%ebx
  803a29:	0f 94 c0             	sete   %al
  803a2c:	0f b6 c0             	movzbl %al,%eax
  803a2f:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803a32:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a39:	00 00 00 
  803a3c:	48 8b 00             	mov    (%rax),%rax
  803a3f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803a45:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803a48:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a4b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803a4e:	75 05                	jne    803a55 <_pipeisclosed+0x7d>
			return ret;
  803a50:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803a53:	eb 4f                	jmp    803aa4 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803a55:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a58:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803a5b:	74 42                	je     803a9f <_pipeisclosed+0xc7>
  803a5d:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803a61:	75 3c                	jne    803a9f <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803a63:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a6a:	00 00 00 
  803a6d:	48 8b 00             	mov    (%rax),%rax
  803a70:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803a76:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803a79:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a7c:	89 c6                	mov    %eax,%esi
  803a7e:	48 bf 9d 4a 80 00 00 	movabs $0x804a9d,%rdi
  803a85:	00 00 00 
  803a88:	b8 00 00 00 00       	mov    $0x0,%eax
  803a8d:	49 b8 4e 05 80 00 00 	movabs $0x80054e,%r8
  803a94:	00 00 00 
  803a97:	41 ff d0             	callq  *%r8
	}
  803a9a:	e9 4a ff ff ff       	jmpq   8039e9 <_pipeisclosed+0x11>
  803a9f:	e9 45 ff ff ff       	jmpq   8039e9 <_pipeisclosed+0x11>
}
  803aa4:	48 83 c4 28          	add    $0x28,%rsp
  803aa8:	5b                   	pop    %rbx
  803aa9:	5d                   	pop    %rbp
  803aaa:	c3                   	retq   

0000000000803aab <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803aab:	55                   	push   %rbp
  803aac:	48 89 e5             	mov    %rsp,%rbp
  803aaf:	48 83 ec 30          	sub    $0x30,%rsp
  803ab3:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803ab6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803aba:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803abd:	48 89 d6             	mov    %rdx,%rsi
  803ac0:	89 c7                	mov    %eax,%edi
  803ac2:	48 b8 85 1d 80 00 00 	movabs $0x801d85,%rax
  803ac9:	00 00 00 
  803acc:	ff d0                	callq  *%rax
  803ace:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ad1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ad5:	79 05                	jns    803adc <pipeisclosed+0x31>
		return r;
  803ad7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ada:	eb 31                	jmp    803b0d <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803adc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ae0:	48 89 c7             	mov    %rax,%rdi
  803ae3:	48 b8 c2 1c 80 00 00 	movabs $0x801cc2,%rax
  803aea:	00 00 00 
  803aed:	ff d0                	callq  *%rax
  803aef:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803af3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803af7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803afb:	48 89 d6             	mov    %rdx,%rsi
  803afe:	48 89 c7             	mov    %rax,%rdi
  803b01:	48 b8 d8 39 80 00 00 	movabs $0x8039d8,%rax
  803b08:	00 00 00 
  803b0b:	ff d0                	callq  *%rax
}
  803b0d:	c9                   	leaveq 
  803b0e:	c3                   	retq   

0000000000803b0f <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803b0f:	55                   	push   %rbp
  803b10:	48 89 e5             	mov    %rsp,%rbp
  803b13:	48 83 ec 40          	sub    $0x40,%rsp
  803b17:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b1b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803b1f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803b23:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b27:	48 89 c7             	mov    %rax,%rdi
  803b2a:	48 b8 c2 1c 80 00 00 	movabs $0x801cc2,%rax
  803b31:	00 00 00 
  803b34:	ff d0                	callq  *%rax
  803b36:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803b3a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b3e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803b42:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803b49:	00 
  803b4a:	e9 92 00 00 00       	jmpq   803be1 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803b4f:	eb 41                	jmp    803b92 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803b51:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803b56:	74 09                	je     803b61 <devpipe_read+0x52>
				return i;
  803b58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b5c:	e9 92 00 00 00       	jmpq   803bf3 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803b61:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b69:	48 89 d6             	mov    %rdx,%rsi
  803b6c:	48 89 c7             	mov    %rax,%rdi
  803b6f:	48 b8 d8 39 80 00 00 	movabs $0x8039d8,%rax
  803b76:	00 00 00 
  803b79:	ff d0                	callq  *%rax
  803b7b:	85 c0                	test   %eax,%eax
  803b7d:	74 07                	je     803b86 <devpipe_read+0x77>
				return 0;
  803b7f:	b8 00 00 00 00       	mov    $0x0,%eax
  803b84:	eb 6d                	jmp    803bf3 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803b86:	48 b8 f4 19 80 00 00 	movabs $0x8019f4,%rax
  803b8d:	00 00 00 
  803b90:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803b92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b96:	8b 10                	mov    (%rax),%edx
  803b98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b9c:	8b 40 04             	mov    0x4(%rax),%eax
  803b9f:	39 c2                	cmp    %eax,%edx
  803ba1:	74 ae                	je     803b51 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803ba3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ba7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803bab:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803baf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bb3:	8b 00                	mov    (%rax),%eax
  803bb5:	99                   	cltd   
  803bb6:	c1 ea 1b             	shr    $0x1b,%edx
  803bb9:	01 d0                	add    %edx,%eax
  803bbb:	83 e0 1f             	and    $0x1f,%eax
  803bbe:	29 d0                	sub    %edx,%eax
  803bc0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803bc4:	48 98                	cltq   
  803bc6:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803bcb:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803bcd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bd1:	8b 00                	mov    (%rax),%eax
  803bd3:	8d 50 01             	lea    0x1(%rax),%edx
  803bd6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bda:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803bdc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803be1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803be5:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803be9:	0f 82 60 ff ff ff    	jb     803b4f <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803bef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803bf3:	c9                   	leaveq 
  803bf4:	c3                   	retq   

0000000000803bf5 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803bf5:	55                   	push   %rbp
  803bf6:	48 89 e5             	mov    %rsp,%rbp
  803bf9:	48 83 ec 40          	sub    $0x40,%rsp
  803bfd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c01:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803c05:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803c09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c0d:	48 89 c7             	mov    %rax,%rdi
  803c10:	48 b8 c2 1c 80 00 00 	movabs $0x801cc2,%rax
  803c17:	00 00 00 
  803c1a:	ff d0                	callq  *%rax
  803c1c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803c20:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c24:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803c28:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803c2f:	00 
  803c30:	e9 8e 00 00 00       	jmpq   803cc3 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803c35:	eb 31                	jmp    803c68 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803c37:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c3b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c3f:	48 89 d6             	mov    %rdx,%rsi
  803c42:	48 89 c7             	mov    %rax,%rdi
  803c45:	48 b8 d8 39 80 00 00 	movabs $0x8039d8,%rax
  803c4c:	00 00 00 
  803c4f:	ff d0                	callq  *%rax
  803c51:	85 c0                	test   %eax,%eax
  803c53:	74 07                	je     803c5c <devpipe_write+0x67>
				return 0;
  803c55:	b8 00 00 00 00       	mov    $0x0,%eax
  803c5a:	eb 79                	jmp    803cd5 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803c5c:	48 b8 f4 19 80 00 00 	movabs $0x8019f4,%rax
  803c63:	00 00 00 
  803c66:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803c68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c6c:	8b 40 04             	mov    0x4(%rax),%eax
  803c6f:	48 63 d0             	movslq %eax,%rdx
  803c72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c76:	8b 00                	mov    (%rax),%eax
  803c78:	48 98                	cltq   
  803c7a:	48 83 c0 20          	add    $0x20,%rax
  803c7e:	48 39 c2             	cmp    %rax,%rdx
  803c81:	73 b4                	jae    803c37 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803c83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c87:	8b 40 04             	mov    0x4(%rax),%eax
  803c8a:	99                   	cltd   
  803c8b:	c1 ea 1b             	shr    $0x1b,%edx
  803c8e:	01 d0                	add    %edx,%eax
  803c90:	83 e0 1f             	and    $0x1f,%eax
  803c93:	29 d0                	sub    %edx,%eax
  803c95:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803c99:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803c9d:	48 01 ca             	add    %rcx,%rdx
  803ca0:	0f b6 0a             	movzbl (%rdx),%ecx
  803ca3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ca7:	48 98                	cltq   
  803ca9:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803cad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cb1:	8b 40 04             	mov    0x4(%rax),%eax
  803cb4:	8d 50 01             	lea    0x1(%rax),%edx
  803cb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cbb:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803cbe:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803cc3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cc7:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803ccb:	0f 82 64 ff ff ff    	jb     803c35 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803cd1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803cd5:	c9                   	leaveq 
  803cd6:	c3                   	retq   

0000000000803cd7 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803cd7:	55                   	push   %rbp
  803cd8:	48 89 e5             	mov    %rsp,%rbp
  803cdb:	48 83 ec 20          	sub    $0x20,%rsp
  803cdf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ce3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803ce7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ceb:	48 89 c7             	mov    %rax,%rdi
  803cee:	48 b8 c2 1c 80 00 00 	movabs $0x801cc2,%rax
  803cf5:	00 00 00 
  803cf8:	ff d0                	callq  *%rax
  803cfa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803cfe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d02:	48 be b0 4a 80 00 00 	movabs $0x804ab0,%rsi
  803d09:	00 00 00 
  803d0c:	48 89 c7             	mov    %rax,%rdi
  803d0f:	48 b8 03 11 80 00 00 	movabs $0x801103,%rax
  803d16:	00 00 00 
  803d19:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803d1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d1f:	8b 50 04             	mov    0x4(%rax),%edx
  803d22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d26:	8b 00                	mov    (%rax),%eax
  803d28:	29 c2                	sub    %eax,%edx
  803d2a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d2e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803d34:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d38:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803d3f:	00 00 00 
	stat->st_dev = &devpipe;
  803d42:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d46:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803d4d:	00 00 00 
  803d50:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803d57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d5c:	c9                   	leaveq 
  803d5d:	c3                   	retq   

0000000000803d5e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803d5e:	55                   	push   %rbp
  803d5f:	48 89 e5             	mov    %rsp,%rbp
  803d62:	48 83 ec 10          	sub    $0x10,%rsp
  803d66:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803d6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d6e:	48 89 c6             	mov    %rax,%rsi
  803d71:	bf 00 00 00 00       	mov    $0x0,%edi
  803d76:	48 b8 dd 1a 80 00 00 	movabs $0x801add,%rax
  803d7d:	00 00 00 
  803d80:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803d82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d86:	48 89 c7             	mov    %rax,%rdi
  803d89:	48 b8 c2 1c 80 00 00 	movabs $0x801cc2,%rax
  803d90:	00 00 00 
  803d93:	ff d0                	callq  *%rax
  803d95:	48 89 c6             	mov    %rax,%rsi
  803d98:	bf 00 00 00 00       	mov    $0x0,%edi
  803d9d:	48 b8 dd 1a 80 00 00 	movabs $0x801add,%rax
  803da4:	00 00 00 
  803da7:	ff d0                	callq  *%rax
}
  803da9:	c9                   	leaveq 
  803daa:	c3                   	retq   

0000000000803dab <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803dab:	55                   	push   %rbp
  803dac:	48 89 e5             	mov    %rsp,%rbp
  803daf:	48 83 ec 20          	sub    $0x20,%rsp
  803db3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803db6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803db9:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803dbc:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803dc0:	be 01 00 00 00       	mov    $0x1,%esi
  803dc5:	48 89 c7             	mov    %rax,%rdi
  803dc8:	48 b8 ea 18 80 00 00 	movabs $0x8018ea,%rax
  803dcf:	00 00 00 
  803dd2:	ff d0                	callq  *%rax
}
  803dd4:	c9                   	leaveq 
  803dd5:	c3                   	retq   

0000000000803dd6 <getchar>:

int
getchar(void)
{
  803dd6:	55                   	push   %rbp
  803dd7:	48 89 e5             	mov    %rsp,%rbp
  803dda:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803dde:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803de2:	ba 01 00 00 00       	mov    $0x1,%edx
  803de7:	48 89 c6             	mov    %rax,%rsi
  803dea:	bf 00 00 00 00       	mov    $0x0,%edi
  803def:	48 b8 b7 21 80 00 00 	movabs $0x8021b7,%rax
  803df6:	00 00 00 
  803df9:	ff d0                	callq  *%rax
  803dfb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803dfe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e02:	79 05                	jns    803e09 <getchar+0x33>
		return r;
  803e04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e07:	eb 14                	jmp    803e1d <getchar+0x47>
	if (r < 1)
  803e09:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e0d:	7f 07                	jg     803e16 <getchar+0x40>
		return -E_EOF;
  803e0f:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803e14:	eb 07                	jmp    803e1d <getchar+0x47>
	return c;
  803e16:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803e1a:	0f b6 c0             	movzbl %al,%eax
}
  803e1d:	c9                   	leaveq 
  803e1e:	c3                   	retq   

0000000000803e1f <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803e1f:	55                   	push   %rbp
  803e20:	48 89 e5             	mov    %rsp,%rbp
  803e23:	48 83 ec 20          	sub    $0x20,%rsp
  803e27:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803e2a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803e2e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e31:	48 89 d6             	mov    %rdx,%rsi
  803e34:	89 c7                	mov    %eax,%edi
  803e36:	48 b8 85 1d 80 00 00 	movabs $0x801d85,%rax
  803e3d:	00 00 00 
  803e40:	ff d0                	callq  *%rax
  803e42:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e45:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e49:	79 05                	jns    803e50 <iscons+0x31>
		return r;
  803e4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e4e:	eb 1a                	jmp    803e6a <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803e50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e54:	8b 10                	mov    (%rax),%edx
  803e56:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803e5d:	00 00 00 
  803e60:	8b 00                	mov    (%rax),%eax
  803e62:	39 c2                	cmp    %eax,%edx
  803e64:	0f 94 c0             	sete   %al
  803e67:	0f b6 c0             	movzbl %al,%eax
}
  803e6a:	c9                   	leaveq 
  803e6b:	c3                   	retq   

0000000000803e6c <opencons>:

int
opencons(void)
{
  803e6c:	55                   	push   %rbp
  803e6d:	48 89 e5             	mov    %rsp,%rbp
  803e70:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803e74:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803e78:	48 89 c7             	mov    %rax,%rdi
  803e7b:	48 b8 ed 1c 80 00 00 	movabs $0x801ced,%rax
  803e82:	00 00 00 
  803e85:	ff d0                	callq  *%rax
  803e87:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e8a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e8e:	79 05                	jns    803e95 <opencons+0x29>
		return r;
  803e90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e93:	eb 5b                	jmp    803ef0 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803e95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e99:	ba 07 04 00 00       	mov    $0x407,%edx
  803e9e:	48 89 c6             	mov    %rax,%rsi
  803ea1:	bf 00 00 00 00       	mov    $0x0,%edi
  803ea6:	48 b8 32 1a 80 00 00 	movabs $0x801a32,%rax
  803ead:	00 00 00 
  803eb0:	ff d0                	callq  *%rax
  803eb2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803eb5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803eb9:	79 05                	jns    803ec0 <opencons+0x54>
		return r;
  803ebb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ebe:	eb 30                	jmp    803ef0 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803ec0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ec4:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803ecb:	00 00 00 
  803ece:	8b 12                	mov    (%rdx),%edx
  803ed0:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803ed2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ed6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803edd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ee1:	48 89 c7             	mov    %rax,%rdi
  803ee4:	48 b8 9f 1c 80 00 00 	movabs $0x801c9f,%rax
  803eeb:	00 00 00 
  803eee:	ff d0                	callq  *%rax
}
  803ef0:	c9                   	leaveq 
  803ef1:	c3                   	retq   

0000000000803ef2 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803ef2:	55                   	push   %rbp
  803ef3:	48 89 e5             	mov    %rsp,%rbp
  803ef6:	48 83 ec 30          	sub    $0x30,%rsp
  803efa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803efe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f02:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803f06:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803f0b:	75 07                	jne    803f14 <devcons_read+0x22>
		return 0;
  803f0d:	b8 00 00 00 00       	mov    $0x0,%eax
  803f12:	eb 4b                	jmp    803f5f <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803f14:	eb 0c                	jmp    803f22 <devcons_read+0x30>
		sys_yield();
  803f16:	48 b8 f4 19 80 00 00 	movabs $0x8019f4,%rax
  803f1d:	00 00 00 
  803f20:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803f22:	48 b8 34 19 80 00 00 	movabs $0x801934,%rax
  803f29:	00 00 00 
  803f2c:	ff d0                	callq  *%rax
  803f2e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f31:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f35:	74 df                	je     803f16 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803f37:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f3b:	79 05                	jns    803f42 <devcons_read+0x50>
		return c;
  803f3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f40:	eb 1d                	jmp    803f5f <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803f42:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803f46:	75 07                	jne    803f4f <devcons_read+0x5d>
		return 0;
  803f48:	b8 00 00 00 00       	mov    $0x0,%eax
  803f4d:	eb 10                	jmp    803f5f <devcons_read+0x6d>
	*(char*)vbuf = c;
  803f4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f52:	89 c2                	mov    %eax,%edx
  803f54:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f58:	88 10                	mov    %dl,(%rax)
	return 1;
  803f5a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803f5f:	c9                   	leaveq 
  803f60:	c3                   	retq   

0000000000803f61 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803f61:	55                   	push   %rbp
  803f62:	48 89 e5             	mov    %rsp,%rbp
  803f65:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803f6c:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803f73:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803f7a:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803f81:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803f88:	eb 76                	jmp    804000 <devcons_write+0x9f>
		m = n - tot;
  803f8a:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803f91:	89 c2                	mov    %eax,%edx
  803f93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f96:	29 c2                	sub    %eax,%edx
  803f98:	89 d0                	mov    %edx,%eax
  803f9a:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803f9d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803fa0:	83 f8 7f             	cmp    $0x7f,%eax
  803fa3:	76 07                	jbe    803fac <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803fa5:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803fac:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803faf:	48 63 d0             	movslq %eax,%rdx
  803fb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fb5:	48 63 c8             	movslq %eax,%rcx
  803fb8:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803fbf:	48 01 c1             	add    %rax,%rcx
  803fc2:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803fc9:	48 89 ce             	mov    %rcx,%rsi
  803fcc:	48 89 c7             	mov    %rax,%rdi
  803fcf:	48 b8 27 14 80 00 00 	movabs $0x801427,%rax
  803fd6:	00 00 00 
  803fd9:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803fdb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803fde:	48 63 d0             	movslq %eax,%rdx
  803fe1:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803fe8:	48 89 d6             	mov    %rdx,%rsi
  803feb:	48 89 c7             	mov    %rax,%rdi
  803fee:	48 b8 ea 18 80 00 00 	movabs $0x8018ea,%rax
  803ff5:	00 00 00 
  803ff8:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803ffa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ffd:	01 45 fc             	add    %eax,-0x4(%rbp)
  804000:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804003:	48 98                	cltq   
  804005:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80400c:	0f 82 78 ff ff ff    	jb     803f8a <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804012:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804015:	c9                   	leaveq 
  804016:	c3                   	retq   

0000000000804017 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804017:	55                   	push   %rbp
  804018:	48 89 e5             	mov    %rsp,%rbp
  80401b:	48 83 ec 08          	sub    $0x8,%rsp
  80401f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804023:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804028:	c9                   	leaveq 
  804029:	c3                   	retq   

000000000080402a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80402a:	55                   	push   %rbp
  80402b:	48 89 e5             	mov    %rsp,%rbp
  80402e:	48 83 ec 10          	sub    $0x10,%rsp
  804032:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804036:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80403a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80403e:	48 be bc 4a 80 00 00 	movabs $0x804abc,%rsi
  804045:	00 00 00 
  804048:	48 89 c7             	mov    %rax,%rdi
  80404b:	48 b8 03 11 80 00 00 	movabs $0x801103,%rax
  804052:	00 00 00 
  804055:	ff d0                	callq  *%rax
	return 0;
  804057:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80405c:	c9                   	leaveq 
  80405d:	c3                   	retq   

000000000080405e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80405e:	55                   	push   %rbp
  80405f:	48 89 e5             	mov    %rsp,%rbp
  804062:	48 83 ec 30          	sub    $0x30,%rsp
  804066:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80406a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80406e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  804072:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804077:	74 18                	je     804091 <ipc_recv+0x33>
  804079:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80407d:	48 89 c7             	mov    %rax,%rdi
  804080:	48 b8 5b 1c 80 00 00 	movabs $0x801c5b,%rax
  804087:	00 00 00 
  80408a:	ff d0                	callq  *%rax
  80408c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80408f:	eb 19                	jmp    8040aa <ipc_recv+0x4c>
  804091:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  804098:	00 00 00 
  80409b:	48 b8 5b 1c 80 00 00 	movabs $0x801c5b,%rax
  8040a2:	00 00 00 
  8040a5:	ff d0                	callq  *%rax
  8040a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  8040aa:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8040af:	74 26                	je     8040d7 <ipc_recv+0x79>
  8040b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040b5:	75 15                	jne    8040cc <ipc_recv+0x6e>
  8040b7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8040be:	00 00 00 
  8040c1:	48 8b 00             	mov    (%rax),%rax
  8040c4:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  8040ca:	eb 05                	jmp    8040d1 <ipc_recv+0x73>
  8040cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8040d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8040d5:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  8040d7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8040dc:	74 26                	je     804104 <ipc_recv+0xa6>
  8040de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040e2:	75 15                	jne    8040f9 <ipc_recv+0x9b>
  8040e4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8040eb:	00 00 00 
  8040ee:	48 8b 00             	mov    (%rax),%rax
  8040f1:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  8040f7:	eb 05                	jmp    8040fe <ipc_recv+0xa0>
  8040f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8040fe:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804102:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  804104:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804108:	75 15                	jne    80411f <ipc_recv+0xc1>
  80410a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804111:	00 00 00 
  804114:	48 8b 00             	mov    (%rax),%rax
  804117:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  80411d:	eb 03                	jmp    804122 <ipc_recv+0xc4>
  80411f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804122:	c9                   	leaveq 
  804123:	c3                   	retq   

0000000000804124 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804124:	55                   	push   %rbp
  804125:	48 89 e5             	mov    %rsp,%rbp
  804128:	48 83 ec 30          	sub    $0x30,%rsp
  80412c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80412f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804132:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804136:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  804139:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  804140:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804145:	75 10                	jne    804157 <ipc_send+0x33>
  804147:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80414e:	00 00 00 
  804151:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  804155:	eb 62                	jmp    8041b9 <ipc_send+0x95>
  804157:	eb 60                	jmp    8041b9 <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  804159:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80415d:	74 30                	je     80418f <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  80415f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804162:	89 c1                	mov    %eax,%ecx
  804164:	48 ba c3 4a 80 00 00 	movabs $0x804ac3,%rdx
  80416b:	00 00 00 
  80416e:	be 33 00 00 00       	mov    $0x33,%esi
  804173:	48 bf df 4a 80 00 00 	movabs $0x804adf,%rdi
  80417a:	00 00 00 
  80417d:	b8 00 00 00 00       	mov    $0x0,%eax
  804182:	49 b8 15 03 80 00 00 	movabs $0x800315,%r8
  804189:	00 00 00 
  80418c:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  80418f:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804192:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804195:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804199:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80419c:	89 c7                	mov    %eax,%edi
  80419e:	48 b8 06 1c 80 00 00 	movabs $0x801c06,%rax
  8041a5:	00 00 00 
  8041a8:	ff d0                	callq  *%rax
  8041aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  8041ad:	48 b8 f4 19 80 00 00 	movabs $0x8019f4,%rax
  8041b4:	00 00 00 
  8041b7:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  8041b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041bd:	75 9a                	jne    804159 <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  8041bf:	c9                   	leaveq 
  8041c0:	c3                   	retq   

00000000008041c1 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8041c1:	55                   	push   %rbp
  8041c2:	48 89 e5             	mov    %rsp,%rbp
  8041c5:	48 83 ec 14          	sub    $0x14,%rsp
  8041c9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8041cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8041d3:	eb 5e                	jmp    804233 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8041d5:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8041dc:	00 00 00 
  8041df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041e2:	48 63 d0             	movslq %eax,%rdx
  8041e5:	48 89 d0             	mov    %rdx,%rax
  8041e8:	48 c1 e0 03          	shl    $0x3,%rax
  8041ec:	48 01 d0             	add    %rdx,%rax
  8041ef:	48 c1 e0 05          	shl    $0x5,%rax
  8041f3:	48 01 c8             	add    %rcx,%rax
  8041f6:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8041fc:	8b 00                	mov    (%rax),%eax
  8041fe:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804201:	75 2c                	jne    80422f <ipc_find_env+0x6e>
			return envs[i].env_id;
  804203:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80420a:	00 00 00 
  80420d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804210:	48 63 d0             	movslq %eax,%rdx
  804213:	48 89 d0             	mov    %rdx,%rax
  804216:	48 c1 e0 03          	shl    $0x3,%rax
  80421a:	48 01 d0             	add    %rdx,%rax
  80421d:	48 c1 e0 05          	shl    $0x5,%rax
  804221:	48 01 c8             	add    %rcx,%rax
  804224:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80422a:	8b 40 08             	mov    0x8(%rax),%eax
  80422d:	eb 12                	jmp    804241 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80422f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804233:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80423a:	7e 99                	jle    8041d5 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80423c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804241:	c9                   	leaveq 
  804242:	c3                   	retq   

0000000000804243 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804243:	55                   	push   %rbp
  804244:	48 89 e5             	mov    %rsp,%rbp
  804247:	48 83 ec 18          	sub    $0x18,%rsp
  80424b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80424f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804253:	48 c1 e8 15          	shr    $0x15,%rax
  804257:	48 89 c2             	mov    %rax,%rdx
  80425a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804261:	01 00 00 
  804264:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804268:	83 e0 01             	and    $0x1,%eax
  80426b:	48 85 c0             	test   %rax,%rax
  80426e:	75 07                	jne    804277 <pageref+0x34>
		return 0;
  804270:	b8 00 00 00 00       	mov    $0x0,%eax
  804275:	eb 53                	jmp    8042ca <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804277:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80427b:	48 c1 e8 0c          	shr    $0xc,%rax
  80427f:	48 89 c2             	mov    %rax,%rdx
  804282:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804289:	01 00 00 
  80428c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804290:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804294:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804298:	83 e0 01             	and    $0x1,%eax
  80429b:	48 85 c0             	test   %rax,%rax
  80429e:	75 07                	jne    8042a7 <pageref+0x64>
		return 0;
  8042a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8042a5:	eb 23                	jmp    8042ca <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8042a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042ab:	48 c1 e8 0c          	shr    $0xc,%rax
  8042af:	48 89 c2             	mov    %rax,%rdx
  8042b2:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8042b9:	00 00 00 
  8042bc:	48 c1 e2 04          	shl    $0x4,%rdx
  8042c0:	48 01 d0             	add    %rdx,%rax
  8042c3:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8042c7:	0f b7 c0             	movzwl %ax,%eax
}
  8042ca:	c9                   	leaveq 
  8042cb:	c3                   	retq   
