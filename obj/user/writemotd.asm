
obj/user/writemotd:     file format elf64-x86-64


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
  80003c:	e8 36 03 00 00       	callq  800377 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80004e:	89 bd ec fd ff ff    	mov    %edi,-0x214(%rbp)
  800054:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int rfd, wfd;
	char buf[512];
	int n, r;

	if ((rfd = open("/newmotd", O_RDONLY)) < 0)
  80005b:	be 00 00 00 00       	mov    $0x0,%esi
  800060:	48 bf 00 38 80 00 00 	movabs $0x803800,%rdi
  800067:	00 00 00 
  80006a:	48 b8 a2 27 80 00 00 	movabs $0x8027a2,%rax
  800071:	00 00 00 
  800074:	ff d0                	callq  *%rax
  800076:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800079:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80007d:	79 30                	jns    8000af <umain+0x6c>
		panic("open /newmotd: %e", rfd);
  80007f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800082:	89 c1                	mov    %eax,%ecx
  800084:	48 ba 09 38 80 00 00 	movabs $0x803809,%rdx
  80008b:	00 00 00 
  80008e:	be 0b 00 00 00       	mov    $0xb,%esi
  800093:	48 bf 1b 38 80 00 00 	movabs $0x80381b,%rdi
  80009a:	00 00 00 
  80009d:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a2:	49 b8 2a 04 80 00 00 	movabs $0x80042a,%r8
  8000a9:	00 00 00 
  8000ac:	41 ff d0             	callq  *%r8
	if ((wfd = open("/motd", O_RDWR)) < 0)
  8000af:	be 02 00 00 00       	mov    $0x2,%esi
  8000b4:	48 bf 2c 38 80 00 00 	movabs $0x80382c,%rdi
  8000bb:	00 00 00 
  8000be:	48 b8 a2 27 80 00 00 	movabs $0x8027a2,%rax
  8000c5:	00 00 00 
  8000c8:	ff d0                	callq  *%rax
  8000ca:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000cd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000d1:	79 30                	jns    800103 <umain+0xc0>
		panic("open /motd: %e", wfd);
  8000d3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d6:	89 c1                	mov    %eax,%ecx
  8000d8:	48 ba 32 38 80 00 00 	movabs $0x803832,%rdx
  8000df:	00 00 00 
  8000e2:	be 0d 00 00 00       	mov    $0xd,%esi
  8000e7:	48 bf 1b 38 80 00 00 	movabs $0x80381b,%rdi
  8000ee:	00 00 00 
  8000f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f6:	49 b8 2a 04 80 00 00 	movabs $0x80042a,%r8
  8000fd:	00 00 00 
  800100:	41 ff d0             	callq  *%r8
	cprintf("file descriptors %d %d\n", rfd, wfd);
  800103:	8b 55 f8             	mov    -0x8(%rbp),%edx
  800106:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800109:	89 c6                	mov    %eax,%esi
  80010b:	48 bf 41 38 80 00 00 	movabs $0x803841,%rdi
  800112:	00 00 00 
  800115:	b8 00 00 00 00       	mov    $0x0,%eax
  80011a:	48 b9 63 06 80 00 00 	movabs $0x800663,%rcx
  800121:	00 00 00 
  800124:	ff d1                	callq  *%rcx
	if (rfd == wfd)
  800126:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800129:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  80012c:	75 2a                	jne    800158 <umain+0x115>
		panic("open /newmotd and /motd give same file descriptor");
  80012e:	48 ba 60 38 80 00 00 	movabs $0x803860,%rdx
  800135:	00 00 00 
  800138:	be 10 00 00 00       	mov    $0x10,%esi
  80013d:	48 bf 1b 38 80 00 00 	movabs $0x80381b,%rdi
  800144:	00 00 00 
  800147:	b8 00 00 00 00       	mov    $0x0,%eax
  80014c:	48 b9 2a 04 80 00 00 	movabs $0x80042a,%rcx
  800153:	00 00 00 
  800156:	ff d1                	callq  *%rcx

	cprintf("OLD MOTD\n===\n");
  800158:	48 bf 92 38 80 00 00 	movabs $0x803892,%rdi
  80015f:	00 00 00 
  800162:	b8 00 00 00 00       	mov    $0x0,%eax
  800167:	48 ba 63 06 80 00 00 	movabs $0x800663,%rdx
  80016e:	00 00 00 
  800171:	ff d2                	callq  *%rdx
	while ((n = read(wfd, buf, sizeof buf-1)) > 0)
  800173:	eb 1f                	jmp    800194 <umain+0x151>
		sys_cputs(buf, n);
  800175:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800178:	48 63 d0             	movslq %eax,%rdx
  80017b:	48 8d 85 f0 fd ff ff 	lea    -0x210(%rbp),%rax
  800182:	48 89 d6             	mov    %rdx,%rsi
  800185:	48 89 c7             	mov    %rax,%rdi
  800188:	48 b8 ff 19 80 00 00 	movabs $0x8019ff,%rax
  80018f:	00 00 00 
  800192:	ff d0                	callq  *%rax
	cprintf("file descriptors %d %d\n", rfd, wfd);
	if (rfd == wfd)
		panic("open /newmotd and /motd give same file descriptor");

	cprintf("OLD MOTD\n===\n");
	while ((n = read(wfd, buf, sizeof buf-1)) > 0)
  800194:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80019b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80019e:	ba ff 01 00 00       	mov    $0x1ff,%edx
  8001a3:	48 89 ce             	mov    %rcx,%rsi
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	48 b8 cc 22 80 00 00 	movabs $0x8022cc,%rax
  8001af:	00 00 00 
  8001b2:	ff d0                	callq  *%rax
  8001b4:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8001b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8001bb:	7f b8                	jg     800175 <umain+0x132>
		sys_cputs(buf, n);
	cprintf("===\n");
  8001bd:	48 bf a0 38 80 00 00 	movabs $0x8038a0,%rdi
  8001c4:	00 00 00 
  8001c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8001cc:	48 ba 63 06 80 00 00 	movabs $0x800663,%rdx
  8001d3:	00 00 00 
  8001d6:	ff d2                	callq  *%rdx
	seek(wfd, 0);
  8001d8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001db:	be 00 00 00 00       	mov    $0x0,%esi
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  8001e9:	00 00 00 
  8001ec:	ff d0                	callq  *%rax

	if ((r = ftruncate(wfd, 0)) < 0)
  8001ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001f1:	be 00 00 00 00       	mov    $0x0,%esi
  8001f6:	89 c7                	mov    %eax,%edi
  8001f8:	48 b8 2f 25 80 00 00 	movabs $0x80252f,%rax
  8001ff:	00 00 00 
  800202:	ff d0                	callq  *%rax
  800204:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800207:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80020b:	79 30                	jns    80023d <umain+0x1fa>
		panic("truncate /motd: %e", r);
  80020d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800210:	89 c1                	mov    %eax,%ecx
  800212:	48 ba a5 38 80 00 00 	movabs $0x8038a5,%rdx
  800219:	00 00 00 
  80021c:	be 19 00 00 00       	mov    $0x19,%esi
  800221:	48 bf 1b 38 80 00 00 	movabs $0x80381b,%rdi
  800228:	00 00 00 
  80022b:	b8 00 00 00 00       	mov    $0x0,%eax
  800230:	49 b8 2a 04 80 00 00 	movabs $0x80042a,%r8
  800237:	00 00 00 
  80023a:	41 ff d0             	callq  *%r8

	cprintf("NEW MOTD\n===\n");
  80023d:	48 bf b8 38 80 00 00 	movabs $0x8038b8,%rdi
  800244:	00 00 00 
  800247:	b8 00 00 00 00       	mov    $0x0,%eax
  80024c:	48 ba 63 06 80 00 00 	movabs $0x800663,%rdx
  800253:	00 00 00 
  800256:	ff d2                	callq  *%rdx
	while ((n = read(rfd, buf, sizeof buf-1)) > 0) {
  800258:	eb 7b                	jmp    8002d5 <umain+0x292>
		sys_cputs(buf, n);
  80025a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80025d:	48 63 d0             	movslq %eax,%rdx
  800260:	48 8d 85 f0 fd ff ff 	lea    -0x210(%rbp),%rax
  800267:	48 89 d6             	mov    %rdx,%rsi
  80026a:	48 89 c7             	mov    %rax,%rdi
  80026d:	48 b8 ff 19 80 00 00 	movabs $0x8019ff,%rax
  800274:	00 00 00 
  800277:	ff d0                	callq  *%rax
		if ((r = write(wfd, buf, n)) != n)
  800279:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80027c:	48 63 d0             	movslq %eax,%rdx
  80027f:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  800286:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800289:	48 89 ce             	mov    %rcx,%rsi
  80028c:	89 c7                	mov    %eax,%edi
  80028e:	48 b8 16 24 80 00 00 	movabs $0x802416,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
  80029a:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80029d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002a0:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8002a3:	74 30                	je     8002d5 <umain+0x292>
			panic("write /motd: %e", r);
  8002a5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002a8:	89 c1                	mov    %eax,%ecx
  8002aa:	48 ba c6 38 80 00 00 	movabs $0x8038c6,%rdx
  8002b1:	00 00 00 
  8002b4:	be 1f 00 00 00       	mov    $0x1f,%esi
  8002b9:	48 bf 1b 38 80 00 00 	movabs $0x80381b,%rdi
  8002c0:	00 00 00 
  8002c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c8:	49 b8 2a 04 80 00 00 	movabs $0x80042a,%r8
  8002cf:	00 00 00 
  8002d2:	41 ff d0             	callq  *%r8

	if ((r = ftruncate(wfd, 0)) < 0)
		panic("truncate /motd: %e", r);

	cprintf("NEW MOTD\n===\n");
	while ((n = read(rfd, buf, sizeof buf-1)) > 0) {
  8002d5:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8002dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002df:	ba ff 01 00 00       	mov    $0x1ff,%edx
  8002e4:	48 89 ce             	mov    %rcx,%rsi
  8002e7:	89 c7                	mov    %eax,%edi
  8002e9:	48 b8 cc 22 80 00 00 	movabs $0x8022cc,%rax
  8002f0:	00 00 00 
  8002f3:	ff d0                	callq  *%rax
  8002f5:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8002f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8002fc:	0f 8f 58 ff ff ff    	jg     80025a <umain+0x217>
		sys_cputs(buf, n);
		if ((r = write(wfd, buf, n)) != n)
			panic("write /motd: %e", r);
	}
	cprintf("===\n");
  800302:	48 bf a0 38 80 00 00 	movabs $0x8038a0,%rdi
  800309:	00 00 00 
  80030c:	b8 00 00 00 00       	mov    $0x0,%eax
  800311:	48 ba 63 06 80 00 00 	movabs $0x800663,%rdx
  800318:	00 00 00 
  80031b:	ff d2                	callq  *%rdx

	if (n < 0)
  80031d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800321:	79 30                	jns    800353 <umain+0x310>
		panic("read /newmotd: %e", n);
  800323:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800326:	89 c1                	mov    %eax,%ecx
  800328:	48 ba d6 38 80 00 00 	movabs $0x8038d6,%rdx
  80032f:	00 00 00 
  800332:	be 24 00 00 00       	mov    $0x24,%esi
  800337:	48 bf 1b 38 80 00 00 	movabs $0x80381b,%rdi
  80033e:	00 00 00 
  800341:	b8 00 00 00 00       	mov    $0x0,%eax
  800346:	49 b8 2a 04 80 00 00 	movabs $0x80042a,%r8
  80034d:	00 00 00 
  800350:	41 ff d0             	callq  *%r8

	close(rfd);
  800353:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800356:	89 c7                	mov    %eax,%edi
  800358:	48 b8 aa 20 80 00 00 	movabs $0x8020aa,%rax
  80035f:	00 00 00 
  800362:	ff d0                	callq  *%rax
	close(wfd);
  800364:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800367:	89 c7                	mov    %eax,%edi
  800369:	48 b8 aa 20 80 00 00 	movabs $0x8020aa,%rax
  800370:	00 00 00 
  800373:	ff d0                	callq  *%rax
}
  800375:	c9                   	leaveq 
  800376:	c3                   	retq   

0000000000800377 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800377:	55                   	push   %rbp
  800378:	48 89 e5             	mov    %rsp,%rbp
  80037b:	48 83 ec 10          	sub    $0x10,%rsp
  80037f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800382:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  800386:	48 b8 cb 1a 80 00 00 	movabs $0x801acb,%rax
  80038d:	00 00 00 
  800390:	ff d0                	callq  *%rax
  800392:	48 98                	cltq   
  800394:	25 ff 03 00 00       	and    $0x3ff,%eax
  800399:	48 89 c2             	mov    %rax,%rdx
  80039c:	48 89 d0             	mov    %rdx,%rax
  80039f:	48 c1 e0 03          	shl    $0x3,%rax
  8003a3:	48 01 d0             	add    %rdx,%rax
  8003a6:	48 c1 e0 05          	shl    $0x5,%rax
  8003aa:	48 89 c2             	mov    %rax,%rdx
  8003ad:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8003b4:	00 00 00 
  8003b7:	48 01 c2             	add    %rax,%rdx
  8003ba:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8003c1:	00 00 00 
  8003c4:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003cb:	7e 14                	jle    8003e1 <libmain+0x6a>
		binaryname = argv[0];
  8003cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d1:	48 8b 10             	mov    (%rax),%rdx
  8003d4:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8003db:	00 00 00 
  8003de:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003e1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003e8:	48 89 d6             	mov    %rdx,%rsi
  8003eb:	89 c7                	mov    %eax,%edi
  8003ed:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8003f4:	00 00 00 
  8003f7:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8003f9:	48 b8 07 04 80 00 00 	movabs $0x800407,%rax
  800400:	00 00 00 
  800403:	ff d0                	callq  *%rax
}
  800405:	c9                   	leaveq 
  800406:	c3                   	retq   

0000000000800407 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800407:	55                   	push   %rbp
  800408:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80040b:	48 b8 f5 20 80 00 00 	movabs $0x8020f5,%rax
  800412:	00 00 00 
  800415:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800417:	bf 00 00 00 00       	mov    $0x0,%edi
  80041c:	48 b8 87 1a 80 00 00 	movabs $0x801a87,%rax
  800423:	00 00 00 
  800426:	ff d0                	callq  *%rax
}
  800428:	5d                   	pop    %rbp
  800429:	c3                   	retq   

000000000080042a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80042a:	55                   	push   %rbp
  80042b:	48 89 e5             	mov    %rsp,%rbp
  80042e:	53                   	push   %rbx
  80042f:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800436:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80043d:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800443:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80044a:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800451:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800458:	84 c0                	test   %al,%al
  80045a:	74 23                	je     80047f <_panic+0x55>
  80045c:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800463:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800467:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80046b:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80046f:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800473:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800477:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80047b:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80047f:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800486:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80048d:	00 00 00 
  800490:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800497:	00 00 00 
  80049a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80049e:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8004a5:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8004ac:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8004b3:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8004ba:	00 00 00 
  8004bd:	48 8b 18             	mov    (%rax),%rbx
  8004c0:	48 b8 cb 1a 80 00 00 	movabs $0x801acb,%rax
  8004c7:	00 00 00 
  8004ca:	ff d0                	callq  *%rax
  8004cc:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8004d2:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8004d9:	41 89 c8             	mov    %ecx,%r8d
  8004dc:	48 89 d1             	mov    %rdx,%rcx
  8004df:	48 89 da             	mov    %rbx,%rdx
  8004e2:	89 c6                	mov    %eax,%esi
  8004e4:	48 bf f8 38 80 00 00 	movabs $0x8038f8,%rdi
  8004eb:	00 00 00 
  8004ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f3:	49 b9 63 06 80 00 00 	movabs $0x800663,%r9
  8004fa:	00 00 00 
  8004fd:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800500:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800507:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80050e:	48 89 d6             	mov    %rdx,%rsi
  800511:	48 89 c7             	mov    %rax,%rdi
  800514:	48 b8 b7 05 80 00 00 	movabs $0x8005b7,%rax
  80051b:	00 00 00 
  80051e:	ff d0                	callq  *%rax
	cprintf("\n");
  800520:	48 bf 1b 39 80 00 00 	movabs $0x80391b,%rdi
  800527:	00 00 00 
  80052a:	b8 00 00 00 00       	mov    $0x0,%eax
  80052f:	48 ba 63 06 80 00 00 	movabs $0x800663,%rdx
  800536:	00 00 00 
  800539:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80053b:	cc                   	int3   
  80053c:	eb fd                	jmp    80053b <_panic+0x111>

000000000080053e <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80053e:	55                   	push   %rbp
  80053f:	48 89 e5             	mov    %rsp,%rbp
  800542:	48 83 ec 10          	sub    $0x10,%rsp
  800546:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800549:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80054d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800551:	8b 00                	mov    (%rax),%eax
  800553:	8d 48 01             	lea    0x1(%rax),%ecx
  800556:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80055a:	89 0a                	mov    %ecx,(%rdx)
  80055c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80055f:	89 d1                	mov    %edx,%ecx
  800561:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800565:	48 98                	cltq   
  800567:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80056b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80056f:	8b 00                	mov    (%rax),%eax
  800571:	3d ff 00 00 00       	cmp    $0xff,%eax
  800576:	75 2c                	jne    8005a4 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800578:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80057c:	8b 00                	mov    (%rax),%eax
  80057e:	48 98                	cltq   
  800580:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800584:	48 83 c2 08          	add    $0x8,%rdx
  800588:	48 89 c6             	mov    %rax,%rsi
  80058b:	48 89 d7             	mov    %rdx,%rdi
  80058e:	48 b8 ff 19 80 00 00 	movabs $0x8019ff,%rax
  800595:	00 00 00 
  800598:	ff d0                	callq  *%rax
        b->idx = 0;
  80059a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80059e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8005a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005a8:	8b 40 04             	mov    0x4(%rax),%eax
  8005ab:	8d 50 01             	lea    0x1(%rax),%edx
  8005ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005b2:	89 50 04             	mov    %edx,0x4(%rax)
}
  8005b5:	c9                   	leaveq 
  8005b6:	c3                   	retq   

00000000008005b7 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8005b7:	55                   	push   %rbp
  8005b8:	48 89 e5             	mov    %rsp,%rbp
  8005bb:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8005c2:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8005c9:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8005d0:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8005d7:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005de:	48 8b 0a             	mov    (%rdx),%rcx
  8005e1:	48 89 08             	mov    %rcx,(%rax)
  8005e4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005e8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005ec:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005f0:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8005f4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005fb:	00 00 00 
    b.cnt = 0;
  8005fe:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800605:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800608:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80060f:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800616:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80061d:	48 89 c6             	mov    %rax,%rsi
  800620:	48 bf 3e 05 80 00 00 	movabs $0x80053e,%rdi
  800627:	00 00 00 
  80062a:	48 b8 16 0a 80 00 00 	movabs $0x800a16,%rax
  800631:	00 00 00 
  800634:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800636:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80063c:	48 98                	cltq   
  80063e:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800645:	48 83 c2 08          	add    $0x8,%rdx
  800649:	48 89 c6             	mov    %rax,%rsi
  80064c:	48 89 d7             	mov    %rdx,%rdi
  80064f:	48 b8 ff 19 80 00 00 	movabs $0x8019ff,%rax
  800656:	00 00 00 
  800659:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80065b:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800661:	c9                   	leaveq 
  800662:	c3                   	retq   

0000000000800663 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800663:	55                   	push   %rbp
  800664:	48 89 e5             	mov    %rsp,%rbp
  800667:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80066e:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800675:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80067c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800683:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80068a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800691:	84 c0                	test   %al,%al
  800693:	74 20                	je     8006b5 <cprintf+0x52>
  800695:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800699:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80069d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8006a1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8006a5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8006a9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8006ad:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8006b1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8006b5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8006bc:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8006c3:	00 00 00 
  8006c6:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8006cd:	00 00 00 
  8006d0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006d4:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8006db:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006e2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8006e9:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006f0:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006f7:	48 8b 0a             	mov    (%rdx),%rcx
  8006fa:	48 89 08             	mov    %rcx,(%rax)
  8006fd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800701:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800705:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800709:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80070d:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800714:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80071b:	48 89 d6             	mov    %rdx,%rsi
  80071e:	48 89 c7             	mov    %rax,%rdi
  800721:	48 b8 b7 05 80 00 00 	movabs $0x8005b7,%rax
  800728:	00 00 00 
  80072b:	ff d0                	callq  *%rax
  80072d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800733:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800739:	c9                   	leaveq 
  80073a:	c3                   	retq   

000000000080073b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80073b:	55                   	push   %rbp
  80073c:	48 89 e5             	mov    %rsp,%rbp
  80073f:	53                   	push   %rbx
  800740:	48 83 ec 38          	sub    $0x38,%rsp
  800744:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800748:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80074c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800750:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800753:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800757:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80075b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80075e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800762:	77 3b                	ja     80079f <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800764:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800767:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80076b:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80076e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800772:	ba 00 00 00 00       	mov    $0x0,%edx
  800777:	48 f7 f3             	div    %rbx
  80077a:	48 89 c2             	mov    %rax,%rdx
  80077d:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800780:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800783:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800787:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078b:	41 89 f9             	mov    %edi,%r9d
  80078e:	48 89 c7             	mov    %rax,%rdi
  800791:	48 b8 3b 07 80 00 00 	movabs $0x80073b,%rax
  800798:	00 00 00 
  80079b:	ff d0                	callq  *%rax
  80079d:	eb 1e                	jmp    8007bd <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80079f:	eb 12                	jmp    8007b3 <printnum+0x78>
			putch(padc, putdat);
  8007a1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007a5:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8007a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ac:	48 89 ce             	mov    %rcx,%rsi
  8007af:	89 d7                	mov    %edx,%edi
  8007b1:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007b3:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8007b7:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8007bb:	7f e4                	jg     8007a1 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007bd:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8007c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c9:	48 f7 f1             	div    %rcx
  8007cc:	48 89 d0             	mov    %rdx,%rax
  8007cf:	48 ba 10 3b 80 00 00 	movabs $0x803b10,%rdx
  8007d6:	00 00 00 
  8007d9:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8007dd:	0f be d0             	movsbl %al,%edx
  8007e0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e8:	48 89 ce             	mov    %rcx,%rsi
  8007eb:	89 d7                	mov    %edx,%edi
  8007ed:	ff d0                	callq  *%rax
}
  8007ef:	48 83 c4 38          	add    $0x38,%rsp
  8007f3:	5b                   	pop    %rbx
  8007f4:	5d                   	pop    %rbp
  8007f5:	c3                   	retq   

00000000008007f6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007f6:	55                   	push   %rbp
  8007f7:	48 89 e5             	mov    %rsp,%rbp
  8007fa:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800802:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800805:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800809:	7e 52                	jle    80085d <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80080b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080f:	8b 00                	mov    (%rax),%eax
  800811:	83 f8 30             	cmp    $0x30,%eax
  800814:	73 24                	jae    80083a <getuint+0x44>
  800816:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80081e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800822:	8b 00                	mov    (%rax),%eax
  800824:	89 c0                	mov    %eax,%eax
  800826:	48 01 d0             	add    %rdx,%rax
  800829:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082d:	8b 12                	mov    (%rdx),%edx
  80082f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800832:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800836:	89 0a                	mov    %ecx,(%rdx)
  800838:	eb 17                	jmp    800851 <getuint+0x5b>
  80083a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800842:	48 89 d0             	mov    %rdx,%rax
  800845:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800849:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80084d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800851:	48 8b 00             	mov    (%rax),%rax
  800854:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800858:	e9 a3 00 00 00       	jmpq   800900 <getuint+0x10a>
	else if (lflag)
  80085d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800861:	74 4f                	je     8008b2 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800863:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800867:	8b 00                	mov    (%rax),%eax
  800869:	83 f8 30             	cmp    $0x30,%eax
  80086c:	73 24                	jae    800892 <getuint+0x9c>
  80086e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800872:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800876:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087a:	8b 00                	mov    (%rax),%eax
  80087c:	89 c0                	mov    %eax,%eax
  80087e:	48 01 d0             	add    %rdx,%rax
  800881:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800885:	8b 12                	mov    (%rdx),%edx
  800887:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80088a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80088e:	89 0a                	mov    %ecx,(%rdx)
  800890:	eb 17                	jmp    8008a9 <getuint+0xb3>
  800892:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800896:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80089a:	48 89 d0             	mov    %rdx,%rax
  80089d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008a1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008a9:	48 8b 00             	mov    (%rax),%rax
  8008ac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008b0:	eb 4e                	jmp    800900 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8008b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b6:	8b 00                	mov    (%rax),%eax
  8008b8:	83 f8 30             	cmp    $0x30,%eax
  8008bb:	73 24                	jae    8008e1 <getuint+0xeb>
  8008bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c9:	8b 00                	mov    (%rax),%eax
  8008cb:	89 c0                	mov    %eax,%eax
  8008cd:	48 01 d0             	add    %rdx,%rax
  8008d0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d4:	8b 12                	mov    (%rdx),%edx
  8008d6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008dd:	89 0a                	mov    %ecx,(%rdx)
  8008df:	eb 17                	jmp    8008f8 <getuint+0x102>
  8008e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008e9:	48 89 d0             	mov    %rdx,%rax
  8008ec:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008f8:	8b 00                	mov    (%rax),%eax
  8008fa:	89 c0                	mov    %eax,%eax
  8008fc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800900:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800904:	c9                   	leaveq 
  800905:	c3                   	retq   

0000000000800906 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800906:	55                   	push   %rbp
  800907:	48 89 e5             	mov    %rsp,%rbp
  80090a:	48 83 ec 1c          	sub    $0x1c,%rsp
  80090e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800912:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800915:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800919:	7e 52                	jle    80096d <getint+0x67>
		x=va_arg(*ap, long long);
  80091b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091f:	8b 00                	mov    (%rax),%eax
  800921:	83 f8 30             	cmp    $0x30,%eax
  800924:	73 24                	jae    80094a <getint+0x44>
  800926:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80092e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800932:	8b 00                	mov    (%rax),%eax
  800934:	89 c0                	mov    %eax,%eax
  800936:	48 01 d0             	add    %rdx,%rax
  800939:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80093d:	8b 12                	mov    (%rdx),%edx
  80093f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800942:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800946:	89 0a                	mov    %ecx,(%rdx)
  800948:	eb 17                	jmp    800961 <getint+0x5b>
  80094a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80094e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800952:	48 89 d0             	mov    %rdx,%rax
  800955:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800959:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80095d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800961:	48 8b 00             	mov    (%rax),%rax
  800964:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800968:	e9 a3 00 00 00       	jmpq   800a10 <getint+0x10a>
	else if (lflag)
  80096d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800971:	74 4f                	je     8009c2 <getint+0xbc>
		x=va_arg(*ap, long);
  800973:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800977:	8b 00                	mov    (%rax),%eax
  800979:	83 f8 30             	cmp    $0x30,%eax
  80097c:	73 24                	jae    8009a2 <getint+0x9c>
  80097e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800982:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800986:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098a:	8b 00                	mov    (%rax),%eax
  80098c:	89 c0                	mov    %eax,%eax
  80098e:	48 01 d0             	add    %rdx,%rax
  800991:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800995:	8b 12                	mov    (%rdx),%edx
  800997:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80099a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80099e:	89 0a                	mov    %ecx,(%rdx)
  8009a0:	eb 17                	jmp    8009b9 <getint+0xb3>
  8009a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009aa:	48 89 d0             	mov    %rdx,%rax
  8009ad:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009b9:	48 8b 00             	mov    (%rax),%rax
  8009bc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009c0:	eb 4e                	jmp    800a10 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8009c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c6:	8b 00                	mov    (%rax),%eax
  8009c8:	83 f8 30             	cmp    $0x30,%eax
  8009cb:	73 24                	jae    8009f1 <getint+0xeb>
  8009cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d9:	8b 00                	mov    (%rax),%eax
  8009db:	89 c0                	mov    %eax,%eax
  8009dd:	48 01 d0             	add    %rdx,%rax
  8009e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e4:	8b 12                	mov    (%rdx),%edx
  8009e6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009e9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ed:	89 0a                	mov    %ecx,(%rdx)
  8009ef:	eb 17                	jmp    800a08 <getint+0x102>
  8009f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009f9:	48 89 d0             	mov    %rdx,%rax
  8009fc:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a00:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a04:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a08:	8b 00                	mov    (%rax),%eax
  800a0a:	48 98                	cltq   
  800a0c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a14:	c9                   	leaveq 
  800a15:	c3                   	retq   

0000000000800a16 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a16:	55                   	push   %rbp
  800a17:	48 89 e5             	mov    %rsp,%rbp
  800a1a:	41 54                	push   %r12
  800a1c:	53                   	push   %rbx
  800a1d:	48 83 ec 60          	sub    $0x60,%rsp
  800a21:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800a25:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800a29:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a2d:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800a31:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a35:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800a39:	48 8b 0a             	mov    (%rdx),%rcx
  800a3c:	48 89 08             	mov    %rcx,(%rax)
  800a3f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a43:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a47:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a4b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a4f:	eb 17                	jmp    800a68 <vprintfmt+0x52>
			if (ch == '\0')
  800a51:	85 db                	test   %ebx,%ebx
  800a53:	0f 84 cc 04 00 00    	je     800f25 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800a59:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a5d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a61:	48 89 d6             	mov    %rdx,%rsi
  800a64:	89 df                	mov    %ebx,%edi
  800a66:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a68:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a6c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a70:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a74:	0f b6 00             	movzbl (%rax),%eax
  800a77:	0f b6 d8             	movzbl %al,%ebx
  800a7a:	83 fb 25             	cmp    $0x25,%ebx
  800a7d:	75 d2                	jne    800a51 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a7f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a83:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a8a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a91:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a98:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a9f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800aa3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800aa7:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800aab:	0f b6 00             	movzbl (%rax),%eax
  800aae:	0f b6 d8             	movzbl %al,%ebx
  800ab1:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800ab4:	83 f8 55             	cmp    $0x55,%eax
  800ab7:	0f 87 34 04 00 00    	ja     800ef1 <vprintfmt+0x4db>
  800abd:	89 c0                	mov    %eax,%eax
  800abf:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800ac6:	00 
  800ac7:	48 b8 38 3b 80 00 00 	movabs $0x803b38,%rax
  800ace:	00 00 00 
  800ad1:	48 01 d0             	add    %rdx,%rax
  800ad4:	48 8b 00             	mov    (%rax),%rax
  800ad7:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800ad9:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800add:	eb c0                	jmp    800a9f <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800adf:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800ae3:	eb ba                	jmp    800a9f <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ae5:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800aec:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800aef:	89 d0                	mov    %edx,%eax
  800af1:	c1 e0 02             	shl    $0x2,%eax
  800af4:	01 d0                	add    %edx,%eax
  800af6:	01 c0                	add    %eax,%eax
  800af8:	01 d8                	add    %ebx,%eax
  800afa:	83 e8 30             	sub    $0x30,%eax
  800afd:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800b00:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b04:	0f b6 00             	movzbl (%rax),%eax
  800b07:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b0a:	83 fb 2f             	cmp    $0x2f,%ebx
  800b0d:	7e 0c                	jle    800b1b <vprintfmt+0x105>
  800b0f:	83 fb 39             	cmp    $0x39,%ebx
  800b12:	7f 07                	jg     800b1b <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b14:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b19:	eb d1                	jmp    800aec <vprintfmt+0xd6>
			goto process_precision;
  800b1b:	eb 58                	jmp    800b75 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800b1d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b20:	83 f8 30             	cmp    $0x30,%eax
  800b23:	73 17                	jae    800b3c <vprintfmt+0x126>
  800b25:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b29:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b2c:	89 c0                	mov    %eax,%eax
  800b2e:	48 01 d0             	add    %rdx,%rax
  800b31:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b34:	83 c2 08             	add    $0x8,%edx
  800b37:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b3a:	eb 0f                	jmp    800b4b <vprintfmt+0x135>
  800b3c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b40:	48 89 d0             	mov    %rdx,%rax
  800b43:	48 83 c2 08          	add    $0x8,%rdx
  800b47:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b4b:	8b 00                	mov    (%rax),%eax
  800b4d:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b50:	eb 23                	jmp    800b75 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800b52:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b56:	79 0c                	jns    800b64 <vprintfmt+0x14e>
				width = 0;
  800b58:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b5f:	e9 3b ff ff ff       	jmpq   800a9f <vprintfmt+0x89>
  800b64:	e9 36 ff ff ff       	jmpq   800a9f <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800b69:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b70:	e9 2a ff ff ff       	jmpq   800a9f <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800b75:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b79:	79 12                	jns    800b8d <vprintfmt+0x177>
				width = precision, precision = -1;
  800b7b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b7e:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b81:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b88:	e9 12 ff ff ff       	jmpq   800a9f <vprintfmt+0x89>
  800b8d:	e9 0d ff ff ff       	jmpq   800a9f <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b92:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b96:	e9 04 ff ff ff       	jmpq   800a9f <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b9b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b9e:	83 f8 30             	cmp    $0x30,%eax
  800ba1:	73 17                	jae    800bba <vprintfmt+0x1a4>
  800ba3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ba7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800baa:	89 c0                	mov    %eax,%eax
  800bac:	48 01 d0             	add    %rdx,%rax
  800baf:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bb2:	83 c2 08             	add    $0x8,%edx
  800bb5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bb8:	eb 0f                	jmp    800bc9 <vprintfmt+0x1b3>
  800bba:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bbe:	48 89 d0             	mov    %rdx,%rax
  800bc1:	48 83 c2 08          	add    $0x8,%rdx
  800bc5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bc9:	8b 10                	mov    (%rax),%edx
  800bcb:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800bcf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bd3:	48 89 ce             	mov    %rcx,%rsi
  800bd6:	89 d7                	mov    %edx,%edi
  800bd8:	ff d0                	callq  *%rax
			break;
  800bda:	e9 40 03 00 00       	jmpq   800f1f <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800bdf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800be2:	83 f8 30             	cmp    $0x30,%eax
  800be5:	73 17                	jae    800bfe <vprintfmt+0x1e8>
  800be7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800beb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bee:	89 c0                	mov    %eax,%eax
  800bf0:	48 01 d0             	add    %rdx,%rax
  800bf3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bf6:	83 c2 08             	add    $0x8,%edx
  800bf9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bfc:	eb 0f                	jmp    800c0d <vprintfmt+0x1f7>
  800bfe:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c02:	48 89 d0             	mov    %rdx,%rax
  800c05:	48 83 c2 08          	add    $0x8,%rdx
  800c09:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c0d:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800c0f:	85 db                	test   %ebx,%ebx
  800c11:	79 02                	jns    800c15 <vprintfmt+0x1ff>
				err = -err;
  800c13:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800c15:	83 fb 15             	cmp    $0x15,%ebx
  800c18:	7f 16                	jg     800c30 <vprintfmt+0x21a>
  800c1a:	48 b8 60 3a 80 00 00 	movabs $0x803a60,%rax
  800c21:	00 00 00 
  800c24:	48 63 d3             	movslq %ebx,%rdx
  800c27:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c2b:	4d 85 e4             	test   %r12,%r12
  800c2e:	75 2e                	jne    800c5e <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800c30:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c34:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c38:	89 d9                	mov    %ebx,%ecx
  800c3a:	48 ba 21 3b 80 00 00 	movabs $0x803b21,%rdx
  800c41:	00 00 00 
  800c44:	48 89 c7             	mov    %rax,%rdi
  800c47:	b8 00 00 00 00       	mov    $0x0,%eax
  800c4c:	49 b8 2e 0f 80 00 00 	movabs $0x800f2e,%r8
  800c53:	00 00 00 
  800c56:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c59:	e9 c1 02 00 00       	jmpq   800f1f <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c5e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c62:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c66:	4c 89 e1             	mov    %r12,%rcx
  800c69:	48 ba 2a 3b 80 00 00 	movabs $0x803b2a,%rdx
  800c70:	00 00 00 
  800c73:	48 89 c7             	mov    %rax,%rdi
  800c76:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7b:	49 b8 2e 0f 80 00 00 	movabs $0x800f2e,%r8
  800c82:	00 00 00 
  800c85:	41 ff d0             	callq  *%r8
			break;
  800c88:	e9 92 02 00 00       	jmpq   800f1f <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c8d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c90:	83 f8 30             	cmp    $0x30,%eax
  800c93:	73 17                	jae    800cac <vprintfmt+0x296>
  800c95:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c99:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c9c:	89 c0                	mov    %eax,%eax
  800c9e:	48 01 d0             	add    %rdx,%rax
  800ca1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ca4:	83 c2 08             	add    $0x8,%edx
  800ca7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800caa:	eb 0f                	jmp    800cbb <vprintfmt+0x2a5>
  800cac:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cb0:	48 89 d0             	mov    %rdx,%rax
  800cb3:	48 83 c2 08          	add    $0x8,%rdx
  800cb7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cbb:	4c 8b 20             	mov    (%rax),%r12
  800cbe:	4d 85 e4             	test   %r12,%r12
  800cc1:	75 0a                	jne    800ccd <vprintfmt+0x2b7>
				p = "(null)";
  800cc3:	49 bc 2d 3b 80 00 00 	movabs $0x803b2d,%r12
  800cca:	00 00 00 
			if (width > 0 && padc != '-')
  800ccd:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cd1:	7e 3f                	jle    800d12 <vprintfmt+0x2fc>
  800cd3:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800cd7:	74 39                	je     800d12 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cd9:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800cdc:	48 98                	cltq   
  800cde:	48 89 c6             	mov    %rax,%rsi
  800ce1:	4c 89 e7             	mov    %r12,%rdi
  800ce4:	48 b8 da 11 80 00 00 	movabs $0x8011da,%rax
  800ceb:	00 00 00 
  800cee:	ff d0                	callq  *%rax
  800cf0:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800cf3:	eb 17                	jmp    800d0c <vprintfmt+0x2f6>
					putch(padc, putdat);
  800cf5:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800cf9:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cfd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d01:	48 89 ce             	mov    %rcx,%rsi
  800d04:	89 d7                	mov    %edx,%edi
  800d06:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d08:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d0c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d10:	7f e3                	jg     800cf5 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d12:	eb 37                	jmp    800d4b <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800d14:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800d18:	74 1e                	je     800d38 <vprintfmt+0x322>
  800d1a:	83 fb 1f             	cmp    $0x1f,%ebx
  800d1d:	7e 05                	jle    800d24 <vprintfmt+0x30e>
  800d1f:	83 fb 7e             	cmp    $0x7e,%ebx
  800d22:	7e 14                	jle    800d38 <vprintfmt+0x322>
					putch('?', putdat);
  800d24:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d28:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d2c:	48 89 d6             	mov    %rdx,%rsi
  800d2f:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d34:	ff d0                	callq  *%rax
  800d36:	eb 0f                	jmp    800d47 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800d38:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d3c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d40:	48 89 d6             	mov    %rdx,%rsi
  800d43:	89 df                	mov    %ebx,%edi
  800d45:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d47:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d4b:	4c 89 e0             	mov    %r12,%rax
  800d4e:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d52:	0f b6 00             	movzbl (%rax),%eax
  800d55:	0f be d8             	movsbl %al,%ebx
  800d58:	85 db                	test   %ebx,%ebx
  800d5a:	74 10                	je     800d6c <vprintfmt+0x356>
  800d5c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d60:	78 b2                	js     800d14 <vprintfmt+0x2fe>
  800d62:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d66:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d6a:	79 a8                	jns    800d14 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d6c:	eb 16                	jmp    800d84 <vprintfmt+0x36e>
				putch(' ', putdat);
  800d6e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d72:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d76:	48 89 d6             	mov    %rdx,%rsi
  800d79:	bf 20 00 00 00       	mov    $0x20,%edi
  800d7e:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d80:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d84:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d88:	7f e4                	jg     800d6e <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800d8a:	e9 90 01 00 00       	jmpq   800f1f <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d8f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d93:	be 03 00 00 00       	mov    $0x3,%esi
  800d98:	48 89 c7             	mov    %rax,%rdi
  800d9b:	48 b8 06 09 80 00 00 	movabs $0x800906,%rax
  800da2:	00 00 00 
  800da5:	ff d0                	callq  *%rax
  800da7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800dab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800daf:	48 85 c0             	test   %rax,%rax
  800db2:	79 1d                	jns    800dd1 <vprintfmt+0x3bb>
				putch('-', putdat);
  800db4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800db8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dbc:	48 89 d6             	mov    %rdx,%rsi
  800dbf:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800dc4:	ff d0                	callq  *%rax
				num = -(long long) num;
  800dc6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dca:	48 f7 d8             	neg    %rax
  800dcd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800dd1:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800dd8:	e9 d5 00 00 00       	jmpq   800eb2 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800ddd:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800de1:	be 03 00 00 00       	mov    $0x3,%esi
  800de6:	48 89 c7             	mov    %rax,%rdi
  800de9:	48 b8 f6 07 80 00 00 	movabs $0x8007f6,%rax
  800df0:	00 00 00 
  800df3:	ff d0                	callq  *%rax
  800df5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800df9:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e00:	e9 ad 00 00 00       	jmpq   800eb2 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  800e05:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e09:	be 03 00 00 00       	mov    $0x3,%esi
  800e0e:	48 89 c7             	mov    %rax,%rdi
  800e11:	48 b8 f6 07 80 00 00 	movabs $0x8007f6,%rax
  800e18:	00 00 00 
  800e1b:	ff d0                	callq  *%rax
  800e1d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  800e21:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  800e28:	e9 85 00 00 00       	jmpq   800eb2 <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  800e2d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e31:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e35:	48 89 d6             	mov    %rdx,%rsi
  800e38:	bf 30 00 00 00       	mov    $0x30,%edi
  800e3d:	ff d0                	callq  *%rax
			putch('x', putdat);
  800e3f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e43:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e47:	48 89 d6             	mov    %rdx,%rsi
  800e4a:	bf 78 00 00 00       	mov    $0x78,%edi
  800e4f:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e51:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e54:	83 f8 30             	cmp    $0x30,%eax
  800e57:	73 17                	jae    800e70 <vprintfmt+0x45a>
  800e59:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e5d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e60:	89 c0                	mov    %eax,%eax
  800e62:	48 01 d0             	add    %rdx,%rax
  800e65:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e68:	83 c2 08             	add    $0x8,%edx
  800e6b:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e6e:	eb 0f                	jmp    800e7f <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800e70:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e74:	48 89 d0             	mov    %rdx,%rax
  800e77:	48 83 c2 08          	add    $0x8,%rdx
  800e7b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e7f:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e82:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e86:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e8d:	eb 23                	jmp    800eb2 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e8f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e93:	be 03 00 00 00       	mov    $0x3,%esi
  800e98:	48 89 c7             	mov    %rax,%rdi
  800e9b:	48 b8 f6 07 80 00 00 	movabs $0x8007f6,%rax
  800ea2:	00 00 00 
  800ea5:	ff d0                	callq  *%rax
  800ea7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800eab:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800eb2:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800eb7:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800eba:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ebd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ec1:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ec5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ec9:	45 89 c1             	mov    %r8d,%r9d
  800ecc:	41 89 f8             	mov    %edi,%r8d
  800ecf:	48 89 c7             	mov    %rax,%rdi
  800ed2:	48 b8 3b 07 80 00 00 	movabs $0x80073b,%rax
  800ed9:	00 00 00 
  800edc:	ff d0                	callq  *%rax
			break;
  800ede:	eb 3f                	jmp    800f1f <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ee0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ee4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ee8:	48 89 d6             	mov    %rdx,%rsi
  800eeb:	89 df                	mov    %ebx,%edi
  800eed:	ff d0                	callq  *%rax
			break;
  800eef:	eb 2e                	jmp    800f1f <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ef1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ef5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ef9:	48 89 d6             	mov    %rdx,%rsi
  800efc:	bf 25 00 00 00       	mov    $0x25,%edi
  800f01:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f03:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f08:	eb 05                	jmp    800f0f <vprintfmt+0x4f9>
  800f0a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f0f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f13:	48 83 e8 01          	sub    $0x1,%rax
  800f17:	0f b6 00             	movzbl (%rax),%eax
  800f1a:	3c 25                	cmp    $0x25,%al
  800f1c:	75 ec                	jne    800f0a <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800f1e:	90                   	nop
		}
	}
  800f1f:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f20:	e9 43 fb ff ff       	jmpq   800a68 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800f25:	48 83 c4 60          	add    $0x60,%rsp
  800f29:	5b                   	pop    %rbx
  800f2a:	41 5c                	pop    %r12
  800f2c:	5d                   	pop    %rbp
  800f2d:	c3                   	retq   

0000000000800f2e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f2e:	55                   	push   %rbp
  800f2f:	48 89 e5             	mov    %rsp,%rbp
  800f32:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f39:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f40:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f47:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f4e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f55:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f5c:	84 c0                	test   %al,%al
  800f5e:	74 20                	je     800f80 <printfmt+0x52>
  800f60:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f64:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f68:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f6c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f70:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f74:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f78:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f7c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f80:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f87:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f8e:	00 00 00 
  800f91:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f98:	00 00 00 
  800f9b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f9f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800fa6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fad:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800fb4:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800fbb:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800fc2:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800fc9:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800fd0:	48 89 c7             	mov    %rax,%rdi
  800fd3:	48 b8 16 0a 80 00 00 	movabs $0x800a16,%rax
  800fda:	00 00 00 
  800fdd:	ff d0                	callq  *%rax
	va_end(ap);
}
  800fdf:	c9                   	leaveq 
  800fe0:	c3                   	retq   

0000000000800fe1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fe1:	55                   	push   %rbp
  800fe2:	48 89 e5             	mov    %rsp,%rbp
  800fe5:	48 83 ec 10          	sub    $0x10,%rsp
  800fe9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fec:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800ff0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff4:	8b 40 10             	mov    0x10(%rax),%eax
  800ff7:	8d 50 01             	lea    0x1(%rax),%edx
  800ffa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ffe:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801001:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801005:	48 8b 10             	mov    (%rax),%rdx
  801008:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80100c:	48 8b 40 08          	mov    0x8(%rax),%rax
  801010:	48 39 c2             	cmp    %rax,%rdx
  801013:	73 17                	jae    80102c <sprintputch+0x4b>
		*b->buf++ = ch;
  801015:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801019:	48 8b 00             	mov    (%rax),%rax
  80101c:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801020:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801024:	48 89 0a             	mov    %rcx,(%rdx)
  801027:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80102a:	88 10                	mov    %dl,(%rax)
}
  80102c:	c9                   	leaveq 
  80102d:	c3                   	retq   

000000000080102e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80102e:	55                   	push   %rbp
  80102f:	48 89 e5             	mov    %rsp,%rbp
  801032:	48 83 ec 50          	sub    $0x50,%rsp
  801036:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80103a:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80103d:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801041:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801045:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801049:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80104d:	48 8b 0a             	mov    (%rdx),%rcx
  801050:	48 89 08             	mov    %rcx,(%rax)
  801053:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801057:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80105b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80105f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801063:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801067:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80106b:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80106e:	48 98                	cltq   
  801070:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801074:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801078:	48 01 d0             	add    %rdx,%rax
  80107b:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80107f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801086:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80108b:	74 06                	je     801093 <vsnprintf+0x65>
  80108d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801091:	7f 07                	jg     80109a <vsnprintf+0x6c>
		return -E_INVAL;
  801093:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801098:	eb 2f                	jmp    8010c9 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80109a:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80109e:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8010a2:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8010a6:	48 89 c6             	mov    %rax,%rsi
  8010a9:	48 bf e1 0f 80 00 00 	movabs $0x800fe1,%rdi
  8010b0:	00 00 00 
  8010b3:	48 b8 16 0a 80 00 00 	movabs $0x800a16,%rax
  8010ba:	00 00 00 
  8010bd:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8010bf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8010c3:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8010c6:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8010c9:	c9                   	leaveq 
  8010ca:	c3                   	retq   

00000000008010cb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010cb:	55                   	push   %rbp
  8010cc:	48 89 e5             	mov    %rsp,%rbp
  8010cf:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8010d6:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8010dd:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8010e3:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010ea:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010f1:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010f8:	84 c0                	test   %al,%al
  8010fa:	74 20                	je     80111c <snprintf+0x51>
  8010fc:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801100:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801104:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801108:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80110c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801110:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801114:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801118:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80111c:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801123:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80112a:	00 00 00 
  80112d:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801134:	00 00 00 
  801137:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80113b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801142:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801149:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801150:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801157:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80115e:	48 8b 0a             	mov    (%rdx),%rcx
  801161:	48 89 08             	mov    %rcx,(%rax)
  801164:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801168:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80116c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801170:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801174:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80117b:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801182:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801188:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80118f:	48 89 c7             	mov    %rax,%rdi
  801192:	48 b8 2e 10 80 00 00 	movabs $0x80102e,%rax
  801199:	00 00 00 
  80119c:	ff d0                	callq  *%rax
  80119e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8011a4:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8011aa:	c9                   	leaveq 
  8011ab:	c3                   	retq   

00000000008011ac <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8011ac:	55                   	push   %rbp
  8011ad:	48 89 e5             	mov    %rsp,%rbp
  8011b0:	48 83 ec 18          	sub    $0x18,%rsp
  8011b4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8011b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011bf:	eb 09                	jmp    8011ca <strlen+0x1e>
		n++;
  8011c1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011c5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ce:	0f b6 00             	movzbl (%rax),%eax
  8011d1:	84 c0                	test   %al,%al
  8011d3:	75 ec                	jne    8011c1 <strlen+0x15>
		n++;
	return n;
  8011d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011d8:	c9                   	leaveq 
  8011d9:	c3                   	retq   

00000000008011da <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8011da:	55                   	push   %rbp
  8011db:	48 89 e5             	mov    %rsp,%rbp
  8011de:	48 83 ec 20          	sub    $0x20,%rsp
  8011e2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011e6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011f1:	eb 0e                	jmp    801201 <strnlen+0x27>
		n++;
  8011f3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011f7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011fc:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801201:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801206:	74 0b                	je     801213 <strnlen+0x39>
  801208:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80120c:	0f b6 00             	movzbl (%rax),%eax
  80120f:	84 c0                	test   %al,%al
  801211:	75 e0                	jne    8011f3 <strnlen+0x19>
		n++;
	return n;
  801213:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801216:	c9                   	leaveq 
  801217:	c3                   	retq   

0000000000801218 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801218:	55                   	push   %rbp
  801219:	48 89 e5             	mov    %rsp,%rbp
  80121c:	48 83 ec 20          	sub    $0x20,%rsp
  801220:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801224:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801228:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80122c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801230:	90                   	nop
  801231:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801235:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801239:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80123d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801241:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801245:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801249:	0f b6 12             	movzbl (%rdx),%edx
  80124c:	88 10                	mov    %dl,(%rax)
  80124e:	0f b6 00             	movzbl (%rax),%eax
  801251:	84 c0                	test   %al,%al
  801253:	75 dc                	jne    801231 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801255:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801259:	c9                   	leaveq 
  80125a:	c3                   	retq   

000000000080125b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80125b:	55                   	push   %rbp
  80125c:	48 89 e5             	mov    %rsp,%rbp
  80125f:	48 83 ec 20          	sub    $0x20,%rsp
  801263:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801267:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80126b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80126f:	48 89 c7             	mov    %rax,%rdi
  801272:	48 b8 ac 11 80 00 00 	movabs $0x8011ac,%rax
  801279:	00 00 00 
  80127c:	ff d0                	callq  *%rax
  80127e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801281:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801284:	48 63 d0             	movslq %eax,%rdx
  801287:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80128b:	48 01 c2             	add    %rax,%rdx
  80128e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801292:	48 89 c6             	mov    %rax,%rsi
  801295:	48 89 d7             	mov    %rdx,%rdi
  801298:	48 b8 18 12 80 00 00 	movabs $0x801218,%rax
  80129f:	00 00 00 
  8012a2:	ff d0                	callq  *%rax
	return dst;
  8012a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012a8:	c9                   	leaveq 
  8012a9:	c3                   	retq   

00000000008012aa <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8012aa:	55                   	push   %rbp
  8012ab:	48 89 e5             	mov    %rsp,%rbp
  8012ae:	48 83 ec 28          	sub    $0x28,%rsp
  8012b2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012b6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012ba:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8012be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8012c6:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8012cd:	00 
  8012ce:	eb 2a                	jmp    8012fa <strncpy+0x50>
		*dst++ = *src;
  8012d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012d8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012dc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012e0:	0f b6 12             	movzbl (%rdx),%edx
  8012e3:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012e9:	0f b6 00             	movzbl (%rax),%eax
  8012ec:	84 c0                	test   %al,%al
  8012ee:	74 05                	je     8012f5 <strncpy+0x4b>
			src++;
  8012f0:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012f5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012fe:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801302:	72 cc                	jb     8012d0 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801304:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801308:	c9                   	leaveq 
  801309:	c3                   	retq   

000000000080130a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80130a:	55                   	push   %rbp
  80130b:	48 89 e5             	mov    %rsp,%rbp
  80130e:	48 83 ec 28          	sub    $0x28,%rsp
  801312:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801316:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80131a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80131e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801322:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801326:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80132b:	74 3d                	je     80136a <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80132d:	eb 1d                	jmp    80134c <strlcpy+0x42>
			*dst++ = *src++;
  80132f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801333:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801337:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80133b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80133f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801343:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801347:	0f b6 12             	movzbl (%rdx),%edx
  80134a:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80134c:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801351:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801356:	74 0b                	je     801363 <strlcpy+0x59>
  801358:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80135c:	0f b6 00             	movzbl (%rax),%eax
  80135f:	84 c0                	test   %al,%al
  801361:	75 cc                	jne    80132f <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801363:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801367:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80136a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80136e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801372:	48 29 c2             	sub    %rax,%rdx
  801375:	48 89 d0             	mov    %rdx,%rax
}
  801378:	c9                   	leaveq 
  801379:	c3                   	retq   

000000000080137a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80137a:	55                   	push   %rbp
  80137b:	48 89 e5             	mov    %rsp,%rbp
  80137e:	48 83 ec 10          	sub    $0x10,%rsp
  801382:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801386:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80138a:	eb 0a                	jmp    801396 <strcmp+0x1c>
		p++, q++;
  80138c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801391:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801396:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139a:	0f b6 00             	movzbl (%rax),%eax
  80139d:	84 c0                	test   %al,%al
  80139f:	74 12                	je     8013b3 <strcmp+0x39>
  8013a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a5:	0f b6 10             	movzbl (%rax),%edx
  8013a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ac:	0f b6 00             	movzbl (%rax),%eax
  8013af:	38 c2                	cmp    %al,%dl
  8013b1:	74 d9                	je     80138c <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b7:	0f b6 00             	movzbl (%rax),%eax
  8013ba:	0f b6 d0             	movzbl %al,%edx
  8013bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c1:	0f b6 00             	movzbl (%rax),%eax
  8013c4:	0f b6 c0             	movzbl %al,%eax
  8013c7:	29 c2                	sub    %eax,%edx
  8013c9:	89 d0                	mov    %edx,%eax
}
  8013cb:	c9                   	leaveq 
  8013cc:	c3                   	retq   

00000000008013cd <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8013cd:	55                   	push   %rbp
  8013ce:	48 89 e5             	mov    %rsp,%rbp
  8013d1:	48 83 ec 18          	sub    $0x18,%rsp
  8013d5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013d9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013dd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8013e1:	eb 0f                	jmp    8013f2 <strncmp+0x25>
		n--, p++, q++;
  8013e3:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8013e8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013ed:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8013f2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013f7:	74 1d                	je     801416 <strncmp+0x49>
  8013f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013fd:	0f b6 00             	movzbl (%rax),%eax
  801400:	84 c0                	test   %al,%al
  801402:	74 12                	je     801416 <strncmp+0x49>
  801404:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801408:	0f b6 10             	movzbl (%rax),%edx
  80140b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80140f:	0f b6 00             	movzbl (%rax),%eax
  801412:	38 c2                	cmp    %al,%dl
  801414:	74 cd                	je     8013e3 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801416:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80141b:	75 07                	jne    801424 <strncmp+0x57>
		return 0;
  80141d:	b8 00 00 00 00       	mov    $0x0,%eax
  801422:	eb 18                	jmp    80143c <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801424:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801428:	0f b6 00             	movzbl (%rax),%eax
  80142b:	0f b6 d0             	movzbl %al,%edx
  80142e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801432:	0f b6 00             	movzbl (%rax),%eax
  801435:	0f b6 c0             	movzbl %al,%eax
  801438:	29 c2                	sub    %eax,%edx
  80143a:	89 d0                	mov    %edx,%eax
}
  80143c:	c9                   	leaveq 
  80143d:	c3                   	retq   

000000000080143e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80143e:	55                   	push   %rbp
  80143f:	48 89 e5             	mov    %rsp,%rbp
  801442:	48 83 ec 0c          	sub    $0xc,%rsp
  801446:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80144a:	89 f0                	mov    %esi,%eax
  80144c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80144f:	eb 17                	jmp    801468 <strchr+0x2a>
		if (*s == c)
  801451:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801455:	0f b6 00             	movzbl (%rax),%eax
  801458:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80145b:	75 06                	jne    801463 <strchr+0x25>
			return (char *) s;
  80145d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801461:	eb 15                	jmp    801478 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801463:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801468:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80146c:	0f b6 00             	movzbl (%rax),%eax
  80146f:	84 c0                	test   %al,%al
  801471:	75 de                	jne    801451 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801473:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801478:	c9                   	leaveq 
  801479:	c3                   	retq   

000000000080147a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80147a:	55                   	push   %rbp
  80147b:	48 89 e5             	mov    %rsp,%rbp
  80147e:	48 83 ec 0c          	sub    $0xc,%rsp
  801482:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801486:	89 f0                	mov    %esi,%eax
  801488:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80148b:	eb 13                	jmp    8014a0 <strfind+0x26>
		if (*s == c)
  80148d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801491:	0f b6 00             	movzbl (%rax),%eax
  801494:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801497:	75 02                	jne    80149b <strfind+0x21>
			break;
  801499:	eb 10                	jmp    8014ab <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80149b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a4:	0f b6 00             	movzbl (%rax),%eax
  8014a7:	84 c0                	test   %al,%al
  8014a9:	75 e2                	jne    80148d <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8014ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014af:	c9                   	leaveq 
  8014b0:	c3                   	retq   

00000000008014b1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8014b1:	55                   	push   %rbp
  8014b2:	48 89 e5             	mov    %rsp,%rbp
  8014b5:	48 83 ec 18          	sub    $0x18,%rsp
  8014b9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014bd:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8014c0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8014c4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014c9:	75 06                	jne    8014d1 <memset+0x20>
		return v;
  8014cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014cf:	eb 69                	jmp    80153a <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8014d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d5:	83 e0 03             	and    $0x3,%eax
  8014d8:	48 85 c0             	test   %rax,%rax
  8014db:	75 48                	jne    801525 <memset+0x74>
  8014dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014e1:	83 e0 03             	and    $0x3,%eax
  8014e4:	48 85 c0             	test   %rax,%rax
  8014e7:	75 3c                	jne    801525 <memset+0x74>
		c &= 0xFF;
  8014e9:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014f0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014f3:	c1 e0 18             	shl    $0x18,%eax
  8014f6:	89 c2                	mov    %eax,%edx
  8014f8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014fb:	c1 e0 10             	shl    $0x10,%eax
  8014fe:	09 c2                	or     %eax,%edx
  801500:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801503:	c1 e0 08             	shl    $0x8,%eax
  801506:	09 d0                	or     %edx,%eax
  801508:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80150b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80150f:	48 c1 e8 02          	shr    $0x2,%rax
  801513:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801516:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80151a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80151d:	48 89 d7             	mov    %rdx,%rdi
  801520:	fc                   	cld    
  801521:	f3 ab                	rep stos %eax,%es:(%rdi)
  801523:	eb 11                	jmp    801536 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801525:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801529:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80152c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801530:	48 89 d7             	mov    %rdx,%rdi
  801533:	fc                   	cld    
  801534:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801536:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80153a:	c9                   	leaveq 
  80153b:	c3                   	retq   

000000000080153c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80153c:	55                   	push   %rbp
  80153d:	48 89 e5             	mov    %rsp,%rbp
  801540:	48 83 ec 28          	sub    $0x28,%rsp
  801544:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801548:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80154c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801550:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801554:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801558:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80155c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801560:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801564:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801568:	0f 83 88 00 00 00    	jae    8015f6 <memmove+0xba>
  80156e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801572:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801576:	48 01 d0             	add    %rdx,%rax
  801579:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80157d:	76 77                	jbe    8015f6 <memmove+0xba>
		s += n;
  80157f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801583:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801587:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158b:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80158f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801593:	83 e0 03             	and    $0x3,%eax
  801596:	48 85 c0             	test   %rax,%rax
  801599:	75 3b                	jne    8015d6 <memmove+0x9a>
  80159b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80159f:	83 e0 03             	and    $0x3,%eax
  8015a2:	48 85 c0             	test   %rax,%rax
  8015a5:	75 2f                	jne    8015d6 <memmove+0x9a>
  8015a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ab:	83 e0 03             	and    $0x3,%eax
  8015ae:	48 85 c0             	test   %rax,%rax
  8015b1:	75 23                	jne    8015d6 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8015b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b7:	48 83 e8 04          	sub    $0x4,%rax
  8015bb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015bf:	48 83 ea 04          	sub    $0x4,%rdx
  8015c3:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015c7:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8015cb:	48 89 c7             	mov    %rax,%rdi
  8015ce:	48 89 d6             	mov    %rdx,%rsi
  8015d1:	fd                   	std    
  8015d2:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015d4:	eb 1d                	jmp    8015f3 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8015d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015da:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e2:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8015e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ea:	48 89 d7             	mov    %rdx,%rdi
  8015ed:	48 89 c1             	mov    %rax,%rcx
  8015f0:	fd                   	std    
  8015f1:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015f3:	fc                   	cld    
  8015f4:	eb 57                	jmp    80164d <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015fa:	83 e0 03             	and    $0x3,%eax
  8015fd:	48 85 c0             	test   %rax,%rax
  801600:	75 36                	jne    801638 <memmove+0xfc>
  801602:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801606:	83 e0 03             	and    $0x3,%eax
  801609:	48 85 c0             	test   %rax,%rax
  80160c:	75 2a                	jne    801638 <memmove+0xfc>
  80160e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801612:	83 e0 03             	and    $0x3,%eax
  801615:	48 85 c0             	test   %rax,%rax
  801618:	75 1e                	jne    801638 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80161a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161e:	48 c1 e8 02          	shr    $0x2,%rax
  801622:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801625:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801629:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80162d:	48 89 c7             	mov    %rax,%rdi
  801630:	48 89 d6             	mov    %rdx,%rsi
  801633:	fc                   	cld    
  801634:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801636:	eb 15                	jmp    80164d <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801638:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80163c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801640:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801644:	48 89 c7             	mov    %rax,%rdi
  801647:	48 89 d6             	mov    %rdx,%rsi
  80164a:	fc                   	cld    
  80164b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80164d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801651:	c9                   	leaveq 
  801652:	c3                   	retq   

0000000000801653 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801653:	55                   	push   %rbp
  801654:	48 89 e5             	mov    %rsp,%rbp
  801657:	48 83 ec 18          	sub    $0x18,%rsp
  80165b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80165f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801663:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801667:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80166b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80166f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801673:	48 89 ce             	mov    %rcx,%rsi
  801676:	48 89 c7             	mov    %rax,%rdi
  801679:	48 b8 3c 15 80 00 00 	movabs $0x80153c,%rax
  801680:	00 00 00 
  801683:	ff d0                	callq  *%rax
}
  801685:	c9                   	leaveq 
  801686:	c3                   	retq   

0000000000801687 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801687:	55                   	push   %rbp
  801688:	48 89 e5             	mov    %rsp,%rbp
  80168b:	48 83 ec 28          	sub    $0x28,%rsp
  80168f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801693:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801697:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80169b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80169f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8016a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016a7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8016ab:	eb 36                	jmp    8016e3 <memcmp+0x5c>
		if (*s1 != *s2)
  8016ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016b1:	0f b6 10             	movzbl (%rax),%edx
  8016b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b8:	0f b6 00             	movzbl (%rax),%eax
  8016bb:	38 c2                	cmp    %al,%dl
  8016bd:	74 1a                	je     8016d9 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8016bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016c3:	0f b6 00             	movzbl (%rax),%eax
  8016c6:	0f b6 d0             	movzbl %al,%edx
  8016c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016cd:	0f b6 00             	movzbl (%rax),%eax
  8016d0:	0f b6 c0             	movzbl %al,%eax
  8016d3:	29 c2                	sub    %eax,%edx
  8016d5:	89 d0                	mov    %edx,%eax
  8016d7:	eb 20                	jmp    8016f9 <memcmp+0x72>
		s1++, s2++;
  8016d9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016de:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8016e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e7:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016eb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8016ef:	48 85 c0             	test   %rax,%rax
  8016f2:	75 b9                	jne    8016ad <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f9:	c9                   	leaveq 
  8016fa:	c3                   	retq   

00000000008016fb <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016fb:	55                   	push   %rbp
  8016fc:	48 89 e5             	mov    %rsp,%rbp
  8016ff:	48 83 ec 28          	sub    $0x28,%rsp
  801703:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801707:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80170a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80170e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801712:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801716:	48 01 d0             	add    %rdx,%rax
  801719:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80171d:	eb 15                	jmp    801734 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80171f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801723:	0f b6 10             	movzbl (%rax),%edx
  801726:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801729:	38 c2                	cmp    %al,%dl
  80172b:	75 02                	jne    80172f <memfind+0x34>
			break;
  80172d:	eb 0f                	jmp    80173e <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80172f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801734:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801738:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80173c:	72 e1                	jb     80171f <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80173e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801742:	c9                   	leaveq 
  801743:	c3                   	retq   

0000000000801744 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801744:	55                   	push   %rbp
  801745:	48 89 e5             	mov    %rsp,%rbp
  801748:	48 83 ec 34          	sub    $0x34,%rsp
  80174c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801750:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801754:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801757:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80175e:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801765:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801766:	eb 05                	jmp    80176d <strtol+0x29>
		s++;
  801768:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80176d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801771:	0f b6 00             	movzbl (%rax),%eax
  801774:	3c 20                	cmp    $0x20,%al
  801776:	74 f0                	je     801768 <strtol+0x24>
  801778:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177c:	0f b6 00             	movzbl (%rax),%eax
  80177f:	3c 09                	cmp    $0x9,%al
  801781:	74 e5                	je     801768 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801783:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801787:	0f b6 00             	movzbl (%rax),%eax
  80178a:	3c 2b                	cmp    $0x2b,%al
  80178c:	75 07                	jne    801795 <strtol+0x51>
		s++;
  80178e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801793:	eb 17                	jmp    8017ac <strtol+0x68>
	else if (*s == '-')
  801795:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801799:	0f b6 00             	movzbl (%rax),%eax
  80179c:	3c 2d                	cmp    $0x2d,%al
  80179e:	75 0c                	jne    8017ac <strtol+0x68>
		s++, neg = 1;
  8017a0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017a5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017ac:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017b0:	74 06                	je     8017b8 <strtol+0x74>
  8017b2:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8017b6:	75 28                	jne    8017e0 <strtol+0x9c>
  8017b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017bc:	0f b6 00             	movzbl (%rax),%eax
  8017bf:	3c 30                	cmp    $0x30,%al
  8017c1:	75 1d                	jne    8017e0 <strtol+0x9c>
  8017c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c7:	48 83 c0 01          	add    $0x1,%rax
  8017cb:	0f b6 00             	movzbl (%rax),%eax
  8017ce:	3c 78                	cmp    $0x78,%al
  8017d0:	75 0e                	jne    8017e0 <strtol+0x9c>
		s += 2, base = 16;
  8017d2:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8017d7:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8017de:	eb 2c                	jmp    80180c <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8017e0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017e4:	75 19                	jne    8017ff <strtol+0xbb>
  8017e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ea:	0f b6 00             	movzbl (%rax),%eax
  8017ed:	3c 30                	cmp    $0x30,%al
  8017ef:	75 0e                	jne    8017ff <strtol+0xbb>
		s++, base = 8;
  8017f1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017f6:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8017fd:	eb 0d                	jmp    80180c <strtol+0xc8>
	else if (base == 0)
  8017ff:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801803:	75 07                	jne    80180c <strtol+0xc8>
		base = 10;
  801805:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80180c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801810:	0f b6 00             	movzbl (%rax),%eax
  801813:	3c 2f                	cmp    $0x2f,%al
  801815:	7e 1d                	jle    801834 <strtol+0xf0>
  801817:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181b:	0f b6 00             	movzbl (%rax),%eax
  80181e:	3c 39                	cmp    $0x39,%al
  801820:	7f 12                	jg     801834 <strtol+0xf0>
			dig = *s - '0';
  801822:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801826:	0f b6 00             	movzbl (%rax),%eax
  801829:	0f be c0             	movsbl %al,%eax
  80182c:	83 e8 30             	sub    $0x30,%eax
  80182f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801832:	eb 4e                	jmp    801882 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801834:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801838:	0f b6 00             	movzbl (%rax),%eax
  80183b:	3c 60                	cmp    $0x60,%al
  80183d:	7e 1d                	jle    80185c <strtol+0x118>
  80183f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801843:	0f b6 00             	movzbl (%rax),%eax
  801846:	3c 7a                	cmp    $0x7a,%al
  801848:	7f 12                	jg     80185c <strtol+0x118>
			dig = *s - 'a' + 10;
  80184a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80184e:	0f b6 00             	movzbl (%rax),%eax
  801851:	0f be c0             	movsbl %al,%eax
  801854:	83 e8 57             	sub    $0x57,%eax
  801857:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80185a:	eb 26                	jmp    801882 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80185c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801860:	0f b6 00             	movzbl (%rax),%eax
  801863:	3c 40                	cmp    $0x40,%al
  801865:	7e 48                	jle    8018af <strtol+0x16b>
  801867:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80186b:	0f b6 00             	movzbl (%rax),%eax
  80186e:	3c 5a                	cmp    $0x5a,%al
  801870:	7f 3d                	jg     8018af <strtol+0x16b>
			dig = *s - 'A' + 10;
  801872:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801876:	0f b6 00             	movzbl (%rax),%eax
  801879:	0f be c0             	movsbl %al,%eax
  80187c:	83 e8 37             	sub    $0x37,%eax
  80187f:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801882:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801885:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801888:	7c 02                	jl     80188c <strtol+0x148>
			break;
  80188a:	eb 23                	jmp    8018af <strtol+0x16b>
		s++, val = (val * base) + dig;
  80188c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801891:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801894:	48 98                	cltq   
  801896:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80189b:	48 89 c2             	mov    %rax,%rdx
  80189e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018a1:	48 98                	cltq   
  8018a3:	48 01 d0             	add    %rdx,%rax
  8018a6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8018aa:	e9 5d ff ff ff       	jmpq   80180c <strtol+0xc8>

	if (endptr)
  8018af:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8018b4:	74 0b                	je     8018c1 <strtol+0x17d>
		*endptr = (char *) s;
  8018b6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018ba:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8018be:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8018c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018c5:	74 09                	je     8018d0 <strtol+0x18c>
  8018c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018cb:	48 f7 d8             	neg    %rax
  8018ce:	eb 04                	jmp    8018d4 <strtol+0x190>
  8018d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8018d4:	c9                   	leaveq 
  8018d5:	c3                   	retq   

00000000008018d6 <strstr>:

char * strstr(const char *in, const char *str)
{
  8018d6:	55                   	push   %rbp
  8018d7:	48 89 e5             	mov    %rsp,%rbp
  8018da:	48 83 ec 30          	sub    $0x30,%rsp
  8018de:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018e2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8018e6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018ea:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018ee:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018f2:	0f b6 00             	movzbl (%rax),%eax
  8018f5:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8018f8:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8018fc:	75 06                	jne    801904 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8018fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801902:	eb 6b                	jmp    80196f <strstr+0x99>

	len = strlen(str);
  801904:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801908:	48 89 c7             	mov    %rax,%rdi
  80190b:	48 b8 ac 11 80 00 00 	movabs $0x8011ac,%rax
  801912:	00 00 00 
  801915:	ff d0                	callq  *%rax
  801917:	48 98                	cltq   
  801919:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80191d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801921:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801925:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801929:	0f b6 00             	movzbl (%rax),%eax
  80192c:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80192f:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801933:	75 07                	jne    80193c <strstr+0x66>
				return (char *) 0;
  801935:	b8 00 00 00 00       	mov    $0x0,%eax
  80193a:	eb 33                	jmp    80196f <strstr+0x99>
		} while (sc != c);
  80193c:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801940:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801943:	75 d8                	jne    80191d <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801945:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801949:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80194d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801951:	48 89 ce             	mov    %rcx,%rsi
  801954:	48 89 c7             	mov    %rax,%rdi
  801957:	48 b8 cd 13 80 00 00 	movabs $0x8013cd,%rax
  80195e:	00 00 00 
  801961:	ff d0                	callq  *%rax
  801963:	85 c0                	test   %eax,%eax
  801965:	75 b6                	jne    80191d <strstr+0x47>

	return (char *) (in - 1);
  801967:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80196b:	48 83 e8 01          	sub    $0x1,%rax
}
  80196f:	c9                   	leaveq 
  801970:	c3                   	retq   

0000000000801971 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801971:	55                   	push   %rbp
  801972:	48 89 e5             	mov    %rsp,%rbp
  801975:	53                   	push   %rbx
  801976:	48 83 ec 48          	sub    $0x48,%rsp
  80197a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80197d:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801980:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801984:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801988:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80198c:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  801990:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801993:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801997:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80199b:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80199f:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8019a3:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8019a7:	4c 89 c3             	mov    %r8,%rbx
  8019aa:	cd 30                	int    $0x30
  8019ac:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  8019b0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8019b4:	74 3e                	je     8019f4 <syscall+0x83>
  8019b6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019bb:	7e 37                	jle    8019f4 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019c1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019c4:	49 89 d0             	mov    %rdx,%r8
  8019c7:	89 c1                	mov    %eax,%ecx
  8019c9:	48 ba e8 3d 80 00 00 	movabs $0x803de8,%rdx
  8019d0:	00 00 00 
  8019d3:	be 4a 00 00 00       	mov    $0x4a,%esi
  8019d8:	48 bf 05 3e 80 00 00 	movabs $0x803e05,%rdi
  8019df:	00 00 00 
  8019e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8019e7:	49 b9 2a 04 80 00 00 	movabs $0x80042a,%r9
  8019ee:	00 00 00 
  8019f1:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  8019f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019f8:	48 83 c4 48          	add    $0x48,%rsp
  8019fc:	5b                   	pop    %rbx
  8019fd:	5d                   	pop    %rbp
  8019fe:	c3                   	retq   

00000000008019ff <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8019ff:	55                   	push   %rbp
  801a00:	48 89 e5             	mov    %rsp,%rbp
  801a03:	48 83 ec 20          	sub    $0x20,%rsp
  801a07:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a0b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801a0f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a13:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a17:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a1e:	00 
  801a1f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a25:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a2b:	48 89 d1             	mov    %rdx,%rcx
  801a2e:	48 89 c2             	mov    %rax,%rdx
  801a31:	be 00 00 00 00       	mov    $0x0,%esi
  801a36:	bf 00 00 00 00       	mov    $0x0,%edi
  801a3b:	48 b8 71 19 80 00 00 	movabs $0x801971,%rax
  801a42:	00 00 00 
  801a45:	ff d0                	callq  *%rax
}
  801a47:	c9                   	leaveq 
  801a48:	c3                   	retq   

0000000000801a49 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a49:	55                   	push   %rbp
  801a4a:	48 89 e5             	mov    %rsp,%rbp
  801a4d:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a51:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a58:	00 
  801a59:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a5f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a65:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a6a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a6f:	be 00 00 00 00       	mov    $0x0,%esi
  801a74:	bf 01 00 00 00       	mov    $0x1,%edi
  801a79:	48 b8 71 19 80 00 00 	movabs $0x801971,%rax
  801a80:	00 00 00 
  801a83:	ff d0                	callq  *%rax
}
  801a85:	c9                   	leaveq 
  801a86:	c3                   	retq   

0000000000801a87 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a87:	55                   	push   %rbp
  801a88:	48 89 e5             	mov    %rsp,%rbp
  801a8b:	48 83 ec 10          	sub    $0x10,%rsp
  801a8f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a95:	48 98                	cltq   
  801a97:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a9e:	00 
  801a9f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aab:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ab0:	48 89 c2             	mov    %rax,%rdx
  801ab3:	be 01 00 00 00       	mov    $0x1,%esi
  801ab8:	bf 03 00 00 00       	mov    $0x3,%edi
  801abd:	48 b8 71 19 80 00 00 	movabs $0x801971,%rax
  801ac4:	00 00 00 
  801ac7:	ff d0                	callq  *%rax
}
  801ac9:	c9                   	leaveq 
  801aca:	c3                   	retq   

0000000000801acb <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801acb:	55                   	push   %rbp
  801acc:	48 89 e5             	mov    %rsp,%rbp
  801acf:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801ad3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ada:	00 
  801adb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ae1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ae7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aec:	ba 00 00 00 00       	mov    $0x0,%edx
  801af1:	be 00 00 00 00       	mov    $0x0,%esi
  801af6:	bf 02 00 00 00       	mov    $0x2,%edi
  801afb:	48 b8 71 19 80 00 00 	movabs $0x801971,%rax
  801b02:	00 00 00 
  801b05:	ff d0                	callq  *%rax
}
  801b07:	c9                   	leaveq 
  801b08:	c3                   	retq   

0000000000801b09 <sys_yield>:

void
sys_yield(void)
{
  801b09:	55                   	push   %rbp
  801b0a:	48 89 e5             	mov    %rsp,%rbp
  801b0d:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801b11:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b18:	00 
  801b19:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b1f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b25:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b2a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b2f:	be 00 00 00 00       	mov    $0x0,%esi
  801b34:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b39:	48 b8 71 19 80 00 00 	movabs $0x801971,%rax
  801b40:	00 00 00 
  801b43:	ff d0                	callq  *%rax
}
  801b45:	c9                   	leaveq 
  801b46:	c3                   	retq   

0000000000801b47 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b47:	55                   	push   %rbp
  801b48:	48 89 e5             	mov    %rsp,%rbp
  801b4b:	48 83 ec 20          	sub    $0x20,%rsp
  801b4f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b52:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b56:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b59:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b5c:	48 63 c8             	movslq %eax,%rcx
  801b5f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b66:	48 98                	cltq   
  801b68:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b6f:	00 
  801b70:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b76:	49 89 c8             	mov    %rcx,%r8
  801b79:	48 89 d1             	mov    %rdx,%rcx
  801b7c:	48 89 c2             	mov    %rax,%rdx
  801b7f:	be 01 00 00 00       	mov    $0x1,%esi
  801b84:	bf 04 00 00 00       	mov    $0x4,%edi
  801b89:	48 b8 71 19 80 00 00 	movabs $0x801971,%rax
  801b90:	00 00 00 
  801b93:	ff d0                	callq  *%rax
}
  801b95:	c9                   	leaveq 
  801b96:	c3                   	retq   

0000000000801b97 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b97:	55                   	push   %rbp
  801b98:	48 89 e5             	mov    %rsp,%rbp
  801b9b:	48 83 ec 30          	sub    $0x30,%rsp
  801b9f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ba2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ba6:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801ba9:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801bad:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801bb1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801bb4:	48 63 c8             	movslq %eax,%rcx
  801bb7:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801bbb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bbe:	48 63 f0             	movslq %eax,%rsi
  801bc1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bc8:	48 98                	cltq   
  801bca:	48 89 0c 24          	mov    %rcx,(%rsp)
  801bce:	49 89 f9             	mov    %rdi,%r9
  801bd1:	49 89 f0             	mov    %rsi,%r8
  801bd4:	48 89 d1             	mov    %rdx,%rcx
  801bd7:	48 89 c2             	mov    %rax,%rdx
  801bda:	be 01 00 00 00       	mov    $0x1,%esi
  801bdf:	bf 05 00 00 00       	mov    $0x5,%edi
  801be4:	48 b8 71 19 80 00 00 	movabs $0x801971,%rax
  801beb:	00 00 00 
  801bee:	ff d0                	callq  *%rax
}
  801bf0:	c9                   	leaveq 
  801bf1:	c3                   	retq   

0000000000801bf2 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801bf2:	55                   	push   %rbp
  801bf3:	48 89 e5             	mov    %rsp,%rbp
  801bf6:	48 83 ec 20          	sub    $0x20,%rsp
  801bfa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bfd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801c01:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c08:	48 98                	cltq   
  801c0a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c11:	00 
  801c12:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c18:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c1e:	48 89 d1             	mov    %rdx,%rcx
  801c21:	48 89 c2             	mov    %rax,%rdx
  801c24:	be 01 00 00 00       	mov    $0x1,%esi
  801c29:	bf 06 00 00 00       	mov    $0x6,%edi
  801c2e:	48 b8 71 19 80 00 00 	movabs $0x801971,%rax
  801c35:	00 00 00 
  801c38:	ff d0                	callq  *%rax
}
  801c3a:	c9                   	leaveq 
  801c3b:	c3                   	retq   

0000000000801c3c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c3c:	55                   	push   %rbp
  801c3d:	48 89 e5             	mov    %rsp,%rbp
  801c40:	48 83 ec 10          	sub    $0x10,%rsp
  801c44:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c47:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c4a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c4d:	48 63 d0             	movslq %eax,%rdx
  801c50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c53:	48 98                	cltq   
  801c55:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c5c:	00 
  801c5d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c63:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c69:	48 89 d1             	mov    %rdx,%rcx
  801c6c:	48 89 c2             	mov    %rax,%rdx
  801c6f:	be 01 00 00 00       	mov    $0x1,%esi
  801c74:	bf 08 00 00 00       	mov    $0x8,%edi
  801c79:	48 b8 71 19 80 00 00 	movabs $0x801971,%rax
  801c80:	00 00 00 
  801c83:	ff d0                	callq  *%rax
}
  801c85:	c9                   	leaveq 
  801c86:	c3                   	retq   

0000000000801c87 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c87:	55                   	push   %rbp
  801c88:	48 89 e5             	mov    %rsp,%rbp
  801c8b:	48 83 ec 20          	sub    $0x20,%rsp
  801c8f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c92:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c96:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c9d:	48 98                	cltq   
  801c9f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ca6:	00 
  801ca7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cad:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cb3:	48 89 d1             	mov    %rdx,%rcx
  801cb6:	48 89 c2             	mov    %rax,%rdx
  801cb9:	be 01 00 00 00       	mov    $0x1,%esi
  801cbe:	bf 09 00 00 00       	mov    $0x9,%edi
  801cc3:	48 b8 71 19 80 00 00 	movabs $0x801971,%rax
  801cca:	00 00 00 
  801ccd:	ff d0                	callq  *%rax
}
  801ccf:	c9                   	leaveq 
  801cd0:	c3                   	retq   

0000000000801cd1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801cd1:	55                   	push   %rbp
  801cd2:	48 89 e5             	mov    %rsp,%rbp
  801cd5:	48 83 ec 20          	sub    $0x20,%rsp
  801cd9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cdc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801ce0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ce4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ce7:	48 98                	cltq   
  801ce9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cf0:	00 
  801cf1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cf7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cfd:	48 89 d1             	mov    %rdx,%rcx
  801d00:	48 89 c2             	mov    %rax,%rdx
  801d03:	be 01 00 00 00       	mov    $0x1,%esi
  801d08:	bf 0a 00 00 00       	mov    $0xa,%edi
  801d0d:	48 b8 71 19 80 00 00 	movabs $0x801971,%rax
  801d14:	00 00 00 
  801d17:	ff d0                	callq  *%rax
}
  801d19:	c9                   	leaveq 
  801d1a:	c3                   	retq   

0000000000801d1b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801d1b:	55                   	push   %rbp
  801d1c:	48 89 e5             	mov    %rsp,%rbp
  801d1f:	48 83 ec 20          	sub    $0x20,%rsp
  801d23:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d26:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d2a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d2e:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d31:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d34:	48 63 f0             	movslq %eax,%rsi
  801d37:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d3e:	48 98                	cltq   
  801d40:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d44:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d4b:	00 
  801d4c:	49 89 f1             	mov    %rsi,%r9
  801d4f:	49 89 c8             	mov    %rcx,%r8
  801d52:	48 89 d1             	mov    %rdx,%rcx
  801d55:	48 89 c2             	mov    %rax,%rdx
  801d58:	be 00 00 00 00       	mov    $0x0,%esi
  801d5d:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d62:	48 b8 71 19 80 00 00 	movabs $0x801971,%rax
  801d69:	00 00 00 
  801d6c:	ff d0                	callq  *%rax
}
  801d6e:	c9                   	leaveq 
  801d6f:	c3                   	retq   

0000000000801d70 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d70:	55                   	push   %rbp
  801d71:	48 89 e5             	mov    %rsp,%rbp
  801d74:	48 83 ec 10          	sub    $0x10,%rsp
  801d78:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d7c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d80:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d87:	00 
  801d88:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d8e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d94:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d99:	48 89 c2             	mov    %rax,%rdx
  801d9c:	be 01 00 00 00       	mov    $0x1,%esi
  801da1:	bf 0d 00 00 00       	mov    $0xd,%edi
  801da6:	48 b8 71 19 80 00 00 	movabs $0x801971,%rax
  801dad:	00 00 00 
  801db0:	ff d0                	callq  *%rax
}
  801db2:	c9                   	leaveq 
  801db3:	c3                   	retq   

0000000000801db4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801db4:	55                   	push   %rbp
  801db5:	48 89 e5             	mov    %rsp,%rbp
  801db8:	48 83 ec 08          	sub    $0x8,%rsp
  801dbc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801dc0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801dc4:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801dcb:	ff ff ff 
  801dce:	48 01 d0             	add    %rdx,%rax
  801dd1:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801dd5:	c9                   	leaveq 
  801dd6:	c3                   	retq   

0000000000801dd7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801dd7:	55                   	push   %rbp
  801dd8:	48 89 e5             	mov    %rsp,%rbp
  801ddb:	48 83 ec 08          	sub    $0x8,%rsp
  801ddf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801de3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801de7:	48 89 c7             	mov    %rax,%rdi
  801dea:	48 b8 b4 1d 80 00 00 	movabs $0x801db4,%rax
  801df1:	00 00 00 
  801df4:	ff d0                	callq  *%rax
  801df6:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801dfc:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801e00:	c9                   	leaveq 
  801e01:	c3                   	retq   

0000000000801e02 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801e02:	55                   	push   %rbp
  801e03:	48 89 e5             	mov    %rsp,%rbp
  801e06:	48 83 ec 18          	sub    $0x18,%rsp
  801e0a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e0e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e15:	eb 6b                	jmp    801e82 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801e17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e1a:	48 98                	cltq   
  801e1c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e22:	48 c1 e0 0c          	shl    $0xc,%rax
  801e26:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801e2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e2e:	48 c1 e8 15          	shr    $0x15,%rax
  801e32:	48 89 c2             	mov    %rax,%rdx
  801e35:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e3c:	01 00 00 
  801e3f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e43:	83 e0 01             	and    $0x1,%eax
  801e46:	48 85 c0             	test   %rax,%rax
  801e49:	74 21                	je     801e6c <fd_alloc+0x6a>
  801e4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e4f:	48 c1 e8 0c          	shr    $0xc,%rax
  801e53:	48 89 c2             	mov    %rax,%rdx
  801e56:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e5d:	01 00 00 
  801e60:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e64:	83 e0 01             	and    $0x1,%eax
  801e67:	48 85 c0             	test   %rax,%rax
  801e6a:	75 12                	jne    801e7e <fd_alloc+0x7c>
			*fd_store = fd;
  801e6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e70:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e74:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e77:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7c:	eb 1a                	jmp    801e98 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e7e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e82:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e86:	7e 8f                	jle    801e17 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e8c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801e93:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801e98:	c9                   	leaveq 
  801e99:	c3                   	retq   

0000000000801e9a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e9a:	55                   	push   %rbp
  801e9b:	48 89 e5             	mov    %rsp,%rbp
  801e9e:	48 83 ec 20          	sub    $0x20,%rsp
  801ea2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ea5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801ea9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ead:	78 06                	js     801eb5 <fd_lookup+0x1b>
  801eaf:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801eb3:	7e 07                	jle    801ebc <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801eb5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801eba:	eb 6c                	jmp    801f28 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801ebc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ebf:	48 98                	cltq   
  801ec1:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ec7:	48 c1 e0 0c          	shl    $0xc,%rax
  801ecb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801ecf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ed3:	48 c1 e8 15          	shr    $0x15,%rax
  801ed7:	48 89 c2             	mov    %rax,%rdx
  801eda:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ee1:	01 00 00 
  801ee4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ee8:	83 e0 01             	and    $0x1,%eax
  801eeb:	48 85 c0             	test   %rax,%rax
  801eee:	74 21                	je     801f11 <fd_lookup+0x77>
  801ef0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ef4:	48 c1 e8 0c          	shr    $0xc,%rax
  801ef8:	48 89 c2             	mov    %rax,%rdx
  801efb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f02:	01 00 00 
  801f05:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f09:	83 e0 01             	and    $0x1,%eax
  801f0c:	48 85 c0             	test   %rax,%rax
  801f0f:	75 07                	jne    801f18 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f11:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f16:	eb 10                	jmp    801f28 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801f18:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f1c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f20:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801f23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f28:	c9                   	leaveq 
  801f29:	c3                   	retq   

0000000000801f2a <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801f2a:	55                   	push   %rbp
  801f2b:	48 89 e5             	mov    %rsp,%rbp
  801f2e:	48 83 ec 30          	sub    $0x30,%rsp
  801f32:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f36:	89 f0                	mov    %esi,%eax
  801f38:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f3b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f3f:	48 89 c7             	mov    %rax,%rdi
  801f42:	48 b8 b4 1d 80 00 00 	movabs $0x801db4,%rax
  801f49:	00 00 00 
  801f4c:	ff d0                	callq  *%rax
  801f4e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f52:	48 89 d6             	mov    %rdx,%rsi
  801f55:	89 c7                	mov    %eax,%edi
  801f57:	48 b8 9a 1e 80 00 00 	movabs $0x801e9a,%rax
  801f5e:	00 00 00 
  801f61:	ff d0                	callq  *%rax
  801f63:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f66:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f6a:	78 0a                	js     801f76 <fd_close+0x4c>
	    || fd != fd2)
  801f6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f70:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f74:	74 12                	je     801f88 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801f76:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801f7a:	74 05                	je     801f81 <fd_close+0x57>
  801f7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f7f:	eb 05                	jmp    801f86 <fd_close+0x5c>
  801f81:	b8 00 00 00 00       	mov    $0x0,%eax
  801f86:	eb 69                	jmp    801ff1 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f88:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f8c:	8b 00                	mov    (%rax),%eax
  801f8e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f92:	48 89 d6             	mov    %rdx,%rsi
  801f95:	89 c7                	mov    %eax,%edi
  801f97:	48 b8 f3 1f 80 00 00 	movabs $0x801ff3,%rax
  801f9e:	00 00 00 
  801fa1:	ff d0                	callq  *%rax
  801fa3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fa6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801faa:	78 2a                	js     801fd6 <fd_close+0xac>
		if (dev->dev_close)
  801fac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fb0:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fb4:	48 85 c0             	test   %rax,%rax
  801fb7:	74 16                	je     801fcf <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801fb9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fbd:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fc1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801fc5:	48 89 d7             	mov    %rdx,%rdi
  801fc8:	ff d0                	callq  *%rax
  801fca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fcd:	eb 07                	jmp    801fd6 <fd_close+0xac>
		else
			r = 0;
  801fcf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801fd6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fda:	48 89 c6             	mov    %rax,%rsi
  801fdd:	bf 00 00 00 00       	mov    $0x0,%edi
  801fe2:	48 b8 f2 1b 80 00 00 	movabs $0x801bf2,%rax
  801fe9:	00 00 00 
  801fec:	ff d0                	callq  *%rax
	return r;
  801fee:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801ff1:	c9                   	leaveq 
  801ff2:	c3                   	retq   

0000000000801ff3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801ff3:	55                   	push   %rbp
  801ff4:	48 89 e5             	mov    %rsp,%rbp
  801ff7:	48 83 ec 20          	sub    $0x20,%rsp
  801ffb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ffe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802002:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802009:	eb 41                	jmp    80204c <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80200b:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802012:	00 00 00 
  802015:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802018:	48 63 d2             	movslq %edx,%rdx
  80201b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80201f:	8b 00                	mov    (%rax),%eax
  802021:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802024:	75 22                	jne    802048 <dev_lookup+0x55>
			*dev = devtab[i];
  802026:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  80202d:	00 00 00 
  802030:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802033:	48 63 d2             	movslq %edx,%rdx
  802036:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80203a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80203e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802041:	b8 00 00 00 00       	mov    $0x0,%eax
  802046:	eb 60                	jmp    8020a8 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802048:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80204c:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802053:	00 00 00 
  802056:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802059:	48 63 d2             	movslq %edx,%rdx
  80205c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802060:	48 85 c0             	test   %rax,%rax
  802063:	75 a6                	jne    80200b <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802065:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80206c:	00 00 00 
  80206f:	48 8b 00             	mov    (%rax),%rax
  802072:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802078:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80207b:	89 c6                	mov    %eax,%esi
  80207d:	48 bf 18 3e 80 00 00 	movabs $0x803e18,%rdi
  802084:	00 00 00 
  802087:	b8 00 00 00 00       	mov    $0x0,%eax
  80208c:	48 b9 63 06 80 00 00 	movabs $0x800663,%rcx
  802093:	00 00 00 
  802096:	ff d1                	callq  *%rcx
	*dev = 0;
  802098:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80209c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8020a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8020a8:	c9                   	leaveq 
  8020a9:	c3                   	retq   

00000000008020aa <close>:

int
close(int fdnum)
{
  8020aa:	55                   	push   %rbp
  8020ab:	48 89 e5             	mov    %rsp,%rbp
  8020ae:	48 83 ec 20          	sub    $0x20,%rsp
  8020b2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020b5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8020b9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020bc:	48 89 d6             	mov    %rdx,%rsi
  8020bf:	89 c7                	mov    %eax,%edi
  8020c1:	48 b8 9a 1e 80 00 00 	movabs $0x801e9a,%rax
  8020c8:	00 00 00 
  8020cb:	ff d0                	callq  *%rax
  8020cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020d4:	79 05                	jns    8020db <close+0x31>
		return r;
  8020d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020d9:	eb 18                	jmp    8020f3 <close+0x49>
	else
		return fd_close(fd, 1);
  8020db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020df:	be 01 00 00 00       	mov    $0x1,%esi
  8020e4:	48 89 c7             	mov    %rax,%rdi
  8020e7:	48 b8 2a 1f 80 00 00 	movabs $0x801f2a,%rax
  8020ee:	00 00 00 
  8020f1:	ff d0                	callq  *%rax
}
  8020f3:	c9                   	leaveq 
  8020f4:	c3                   	retq   

00000000008020f5 <close_all>:

void
close_all(void)
{
  8020f5:	55                   	push   %rbp
  8020f6:	48 89 e5             	mov    %rsp,%rbp
  8020f9:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8020fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802104:	eb 15                	jmp    80211b <close_all+0x26>
		close(i);
  802106:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802109:	89 c7                	mov    %eax,%edi
  80210b:	48 b8 aa 20 80 00 00 	movabs $0x8020aa,%rax
  802112:	00 00 00 
  802115:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802117:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80211b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80211f:	7e e5                	jle    802106 <close_all+0x11>
		close(i);
}
  802121:	c9                   	leaveq 
  802122:	c3                   	retq   

0000000000802123 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802123:	55                   	push   %rbp
  802124:	48 89 e5             	mov    %rsp,%rbp
  802127:	48 83 ec 40          	sub    $0x40,%rsp
  80212b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80212e:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802131:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802135:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802138:	48 89 d6             	mov    %rdx,%rsi
  80213b:	89 c7                	mov    %eax,%edi
  80213d:	48 b8 9a 1e 80 00 00 	movabs $0x801e9a,%rax
  802144:	00 00 00 
  802147:	ff d0                	callq  *%rax
  802149:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80214c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802150:	79 08                	jns    80215a <dup+0x37>
		return r;
  802152:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802155:	e9 70 01 00 00       	jmpq   8022ca <dup+0x1a7>
	close(newfdnum);
  80215a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80215d:	89 c7                	mov    %eax,%edi
  80215f:	48 b8 aa 20 80 00 00 	movabs $0x8020aa,%rax
  802166:	00 00 00 
  802169:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80216b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80216e:	48 98                	cltq   
  802170:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802176:	48 c1 e0 0c          	shl    $0xc,%rax
  80217a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80217e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802182:	48 89 c7             	mov    %rax,%rdi
  802185:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  80218c:	00 00 00 
  80218f:	ff d0                	callq  *%rax
  802191:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802195:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802199:	48 89 c7             	mov    %rax,%rdi
  80219c:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  8021a3:	00 00 00 
  8021a6:	ff d0                	callq  *%rax
  8021a8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8021ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021b0:	48 c1 e8 15          	shr    $0x15,%rax
  8021b4:	48 89 c2             	mov    %rax,%rdx
  8021b7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021be:	01 00 00 
  8021c1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021c5:	83 e0 01             	and    $0x1,%eax
  8021c8:	48 85 c0             	test   %rax,%rax
  8021cb:	74 73                	je     802240 <dup+0x11d>
  8021cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021d1:	48 c1 e8 0c          	shr    $0xc,%rax
  8021d5:	48 89 c2             	mov    %rax,%rdx
  8021d8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021df:	01 00 00 
  8021e2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021e6:	83 e0 01             	and    $0x1,%eax
  8021e9:	48 85 c0             	test   %rax,%rax
  8021ec:	74 52                	je     802240 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8021ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021f2:	48 c1 e8 0c          	shr    $0xc,%rax
  8021f6:	48 89 c2             	mov    %rax,%rdx
  8021f9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802200:	01 00 00 
  802203:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802207:	25 07 0e 00 00       	and    $0xe07,%eax
  80220c:	89 c1                	mov    %eax,%ecx
  80220e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802212:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802216:	41 89 c8             	mov    %ecx,%r8d
  802219:	48 89 d1             	mov    %rdx,%rcx
  80221c:	ba 00 00 00 00       	mov    $0x0,%edx
  802221:	48 89 c6             	mov    %rax,%rsi
  802224:	bf 00 00 00 00       	mov    $0x0,%edi
  802229:	48 b8 97 1b 80 00 00 	movabs $0x801b97,%rax
  802230:	00 00 00 
  802233:	ff d0                	callq  *%rax
  802235:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802238:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80223c:	79 02                	jns    802240 <dup+0x11d>
			goto err;
  80223e:	eb 57                	jmp    802297 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802240:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802244:	48 c1 e8 0c          	shr    $0xc,%rax
  802248:	48 89 c2             	mov    %rax,%rdx
  80224b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802252:	01 00 00 
  802255:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802259:	25 07 0e 00 00       	and    $0xe07,%eax
  80225e:	89 c1                	mov    %eax,%ecx
  802260:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802264:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802268:	41 89 c8             	mov    %ecx,%r8d
  80226b:	48 89 d1             	mov    %rdx,%rcx
  80226e:	ba 00 00 00 00       	mov    $0x0,%edx
  802273:	48 89 c6             	mov    %rax,%rsi
  802276:	bf 00 00 00 00       	mov    $0x0,%edi
  80227b:	48 b8 97 1b 80 00 00 	movabs $0x801b97,%rax
  802282:	00 00 00 
  802285:	ff d0                	callq  *%rax
  802287:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80228a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80228e:	79 02                	jns    802292 <dup+0x16f>
		goto err;
  802290:	eb 05                	jmp    802297 <dup+0x174>

	return newfdnum;
  802292:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802295:	eb 33                	jmp    8022ca <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802297:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80229b:	48 89 c6             	mov    %rax,%rsi
  80229e:	bf 00 00 00 00       	mov    $0x0,%edi
  8022a3:	48 b8 f2 1b 80 00 00 	movabs $0x801bf2,%rax
  8022aa:	00 00 00 
  8022ad:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8022af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022b3:	48 89 c6             	mov    %rax,%rsi
  8022b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8022bb:	48 b8 f2 1b 80 00 00 	movabs $0x801bf2,%rax
  8022c2:	00 00 00 
  8022c5:	ff d0                	callq  *%rax
	return r;
  8022c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022ca:	c9                   	leaveq 
  8022cb:	c3                   	retq   

00000000008022cc <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8022cc:	55                   	push   %rbp
  8022cd:	48 89 e5             	mov    %rsp,%rbp
  8022d0:	48 83 ec 40          	sub    $0x40,%rsp
  8022d4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022d7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8022db:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022df:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022e3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022e6:	48 89 d6             	mov    %rdx,%rsi
  8022e9:	89 c7                	mov    %eax,%edi
  8022eb:	48 b8 9a 1e 80 00 00 	movabs $0x801e9a,%rax
  8022f2:	00 00 00 
  8022f5:	ff d0                	callq  *%rax
  8022f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022fe:	78 24                	js     802324 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802300:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802304:	8b 00                	mov    (%rax),%eax
  802306:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80230a:	48 89 d6             	mov    %rdx,%rsi
  80230d:	89 c7                	mov    %eax,%edi
  80230f:	48 b8 f3 1f 80 00 00 	movabs $0x801ff3,%rax
  802316:	00 00 00 
  802319:	ff d0                	callq  *%rax
  80231b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80231e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802322:	79 05                	jns    802329 <read+0x5d>
		return r;
  802324:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802327:	eb 76                	jmp    80239f <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802329:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80232d:	8b 40 08             	mov    0x8(%rax),%eax
  802330:	83 e0 03             	and    $0x3,%eax
  802333:	83 f8 01             	cmp    $0x1,%eax
  802336:	75 3a                	jne    802372 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802338:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80233f:	00 00 00 
  802342:	48 8b 00             	mov    (%rax),%rax
  802345:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80234b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80234e:	89 c6                	mov    %eax,%esi
  802350:	48 bf 37 3e 80 00 00 	movabs $0x803e37,%rdi
  802357:	00 00 00 
  80235a:	b8 00 00 00 00       	mov    $0x0,%eax
  80235f:	48 b9 63 06 80 00 00 	movabs $0x800663,%rcx
  802366:	00 00 00 
  802369:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80236b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802370:	eb 2d                	jmp    80239f <read+0xd3>
	}
	if (!dev->dev_read)
  802372:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802376:	48 8b 40 10          	mov    0x10(%rax),%rax
  80237a:	48 85 c0             	test   %rax,%rax
  80237d:	75 07                	jne    802386 <read+0xba>
		return -E_NOT_SUPP;
  80237f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802384:	eb 19                	jmp    80239f <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802386:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80238a:	48 8b 40 10          	mov    0x10(%rax),%rax
  80238e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802392:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802396:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80239a:	48 89 cf             	mov    %rcx,%rdi
  80239d:	ff d0                	callq  *%rax
}
  80239f:	c9                   	leaveq 
  8023a0:	c3                   	retq   

00000000008023a1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8023a1:	55                   	push   %rbp
  8023a2:	48 89 e5             	mov    %rsp,%rbp
  8023a5:	48 83 ec 30          	sub    $0x30,%rsp
  8023a9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023ac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8023b0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023bb:	eb 49                	jmp    802406 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8023bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023c0:	48 98                	cltq   
  8023c2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023c6:	48 29 c2             	sub    %rax,%rdx
  8023c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023cc:	48 63 c8             	movslq %eax,%rcx
  8023cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023d3:	48 01 c1             	add    %rax,%rcx
  8023d6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023d9:	48 89 ce             	mov    %rcx,%rsi
  8023dc:	89 c7                	mov    %eax,%edi
  8023de:	48 b8 cc 22 80 00 00 	movabs $0x8022cc,%rax
  8023e5:	00 00 00 
  8023e8:	ff d0                	callq  *%rax
  8023ea:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8023ed:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023f1:	79 05                	jns    8023f8 <readn+0x57>
			return m;
  8023f3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023f6:	eb 1c                	jmp    802414 <readn+0x73>
		if (m == 0)
  8023f8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023fc:	75 02                	jne    802400 <readn+0x5f>
			break;
  8023fe:	eb 11                	jmp    802411 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802400:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802403:	01 45 fc             	add    %eax,-0x4(%rbp)
  802406:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802409:	48 98                	cltq   
  80240b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80240f:	72 ac                	jb     8023bd <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802411:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802414:	c9                   	leaveq 
  802415:	c3                   	retq   

0000000000802416 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802416:	55                   	push   %rbp
  802417:	48 89 e5             	mov    %rsp,%rbp
  80241a:	48 83 ec 40          	sub    $0x40,%rsp
  80241e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802421:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802425:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802429:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80242d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802430:	48 89 d6             	mov    %rdx,%rsi
  802433:	89 c7                	mov    %eax,%edi
  802435:	48 b8 9a 1e 80 00 00 	movabs $0x801e9a,%rax
  80243c:	00 00 00 
  80243f:	ff d0                	callq  *%rax
  802441:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802444:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802448:	78 24                	js     80246e <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80244a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80244e:	8b 00                	mov    (%rax),%eax
  802450:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802454:	48 89 d6             	mov    %rdx,%rsi
  802457:	89 c7                	mov    %eax,%edi
  802459:	48 b8 f3 1f 80 00 00 	movabs $0x801ff3,%rax
  802460:	00 00 00 
  802463:	ff d0                	callq  *%rax
  802465:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802468:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80246c:	79 05                	jns    802473 <write+0x5d>
		return r;
  80246e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802471:	eb 75                	jmp    8024e8 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802473:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802477:	8b 40 08             	mov    0x8(%rax),%eax
  80247a:	83 e0 03             	and    $0x3,%eax
  80247d:	85 c0                	test   %eax,%eax
  80247f:	75 3a                	jne    8024bb <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802481:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802488:	00 00 00 
  80248b:	48 8b 00             	mov    (%rax),%rax
  80248e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802494:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802497:	89 c6                	mov    %eax,%esi
  802499:	48 bf 53 3e 80 00 00 	movabs $0x803e53,%rdi
  8024a0:	00 00 00 
  8024a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a8:	48 b9 63 06 80 00 00 	movabs $0x800663,%rcx
  8024af:	00 00 00 
  8024b2:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8024b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024b9:	eb 2d                	jmp    8024e8 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8024bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024bf:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024c3:	48 85 c0             	test   %rax,%rax
  8024c6:	75 07                	jne    8024cf <write+0xb9>
		return -E_NOT_SUPP;
  8024c8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024cd:	eb 19                	jmp    8024e8 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8024cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024d3:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024d7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8024db:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024df:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8024e3:	48 89 cf             	mov    %rcx,%rdi
  8024e6:	ff d0                	callq  *%rax
}
  8024e8:	c9                   	leaveq 
  8024e9:	c3                   	retq   

00000000008024ea <seek>:

int
seek(int fdnum, off_t offset)
{
  8024ea:	55                   	push   %rbp
  8024eb:	48 89 e5             	mov    %rsp,%rbp
  8024ee:	48 83 ec 18          	sub    $0x18,%rsp
  8024f2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024f5:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024f8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024fc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024ff:	48 89 d6             	mov    %rdx,%rsi
  802502:	89 c7                	mov    %eax,%edi
  802504:	48 b8 9a 1e 80 00 00 	movabs $0x801e9a,%rax
  80250b:	00 00 00 
  80250e:	ff d0                	callq  *%rax
  802510:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802513:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802517:	79 05                	jns    80251e <seek+0x34>
		return r;
  802519:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80251c:	eb 0f                	jmp    80252d <seek+0x43>
	fd->fd_offset = offset;
  80251e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802522:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802525:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802528:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80252d:	c9                   	leaveq 
  80252e:	c3                   	retq   

000000000080252f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80252f:	55                   	push   %rbp
  802530:	48 89 e5             	mov    %rsp,%rbp
  802533:	48 83 ec 30          	sub    $0x30,%rsp
  802537:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80253a:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80253d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802541:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802544:	48 89 d6             	mov    %rdx,%rsi
  802547:	89 c7                	mov    %eax,%edi
  802549:	48 b8 9a 1e 80 00 00 	movabs $0x801e9a,%rax
  802550:	00 00 00 
  802553:	ff d0                	callq  *%rax
  802555:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802558:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80255c:	78 24                	js     802582 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80255e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802562:	8b 00                	mov    (%rax),%eax
  802564:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802568:	48 89 d6             	mov    %rdx,%rsi
  80256b:	89 c7                	mov    %eax,%edi
  80256d:	48 b8 f3 1f 80 00 00 	movabs $0x801ff3,%rax
  802574:	00 00 00 
  802577:	ff d0                	callq  *%rax
  802579:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80257c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802580:	79 05                	jns    802587 <ftruncate+0x58>
		return r;
  802582:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802585:	eb 72                	jmp    8025f9 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802587:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80258b:	8b 40 08             	mov    0x8(%rax),%eax
  80258e:	83 e0 03             	and    $0x3,%eax
  802591:	85 c0                	test   %eax,%eax
  802593:	75 3a                	jne    8025cf <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802595:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80259c:	00 00 00 
  80259f:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8025a2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025a8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025ab:	89 c6                	mov    %eax,%esi
  8025ad:	48 bf 70 3e 80 00 00 	movabs $0x803e70,%rdi
  8025b4:	00 00 00 
  8025b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025bc:	48 b9 63 06 80 00 00 	movabs $0x800663,%rcx
  8025c3:	00 00 00 
  8025c6:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8025c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025cd:	eb 2a                	jmp    8025f9 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8025cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025d3:	48 8b 40 30          	mov    0x30(%rax),%rax
  8025d7:	48 85 c0             	test   %rax,%rax
  8025da:	75 07                	jne    8025e3 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8025dc:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025e1:	eb 16                	jmp    8025f9 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8025e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e7:	48 8b 40 30          	mov    0x30(%rax),%rax
  8025eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8025ef:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8025f2:	89 ce                	mov    %ecx,%esi
  8025f4:	48 89 d7             	mov    %rdx,%rdi
  8025f7:	ff d0                	callq  *%rax
}
  8025f9:	c9                   	leaveq 
  8025fa:	c3                   	retq   

00000000008025fb <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8025fb:	55                   	push   %rbp
  8025fc:	48 89 e5             	mov    %rsp,%rbp
  8025ff:	48 83 ec 30          	sub    $0x30,%rsp
  802603:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802606:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80260a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80260e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802611:	48 89 d6             	mov    %rdx,%rsi
  802614:	89 c7                	mov    %eax,%edi
  802616:	48 b8 9a 1e 80 00 00 	movabs $0x801e9a,%rax
  80261d:	00 00 00 
  802620:	ff d0                	callq  *%rax
  802622:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802625:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802629:	78 24                	js     80264f <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80262b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80262f:	8b 00                	mov    (%rax),%eax
  802631:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802635:	48 89 d6             	mov    %rdx,%rsi
  802638:	89 c7                	mov    %eax,%edi
  80263a:	48 b8 f3 1f 80 00 00 	movabs $0x801ff3,%rax
  802641:	00 00 00 
  802644:	ff d0                	callq  *%rax
  802646:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802649:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80264d:	79 05                	jns    802654 <fstat+0x59>
		return r;
  80264f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802652:	eb 5e                	jmp    8026b2 <fstat+0xb7>
	if (!dev->dev_stat)
  802654:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802658:	48 8b 40 28          	mov    0x28(%rax),%rax
  80265c:	48 85 c0             	test   %rax,%rax
  80265f:	75 07                	jne    802668 <fstat+0x6d>
		return -E_NOT_SUPP;
  802661:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802666:	eb 4a                	jmp    8026b2 <fstat+0xb7>
	stat->st_name[0] = 0;
  802668:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80266c:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80266f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802673:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80267a:	00 00 00 
	stat->st_isdir = 0;
  80267d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802681:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802688:	00 00 00 
	stat->st_dev = dev;
  80268b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80268f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802693:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80269a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80269e:	48 8b 40 28          	mov    0x28(%rax),%rax
  8026a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026a6:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8026aa:	48 89 ce             	mov    %rcx,%rsi
  8026ad:	48 89 d7             	mov    %rdx,%rdi
  8026b0:	ff d0                	callq  *%rax
}
  8026b2:	c9                   	leaveq 
  8026b3:	c3                   	retq   

00000000008026b4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8026b4:	55                   	push   %rbp
  8026b5:	48 89 e5             	mov    %rsp,%rbp
  8026b8:	48 83 ec 20          	sub    $0x20,%rsp
  8026bc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026c0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8026c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026c8:	be 00 00 00 00       	mov    $0x0,%esi
  8026cd:	48 89 c7             	mov    %rax,%rdi
  8026d0:	48 b8 a2 27 80 00 00 	movabs $0x8027a2,%rax
  8026d7:	00 00 00 
  8026da:	ff d0                	callq  *%rax
  8026dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026e3:	79 05                	jns    8026ea <stat+0x36>
		return fd;
  8026e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026e8:	eb 2f                	jmp    802719 <stat+0x65>
	r = fstat(fd, stat);
  8026ea:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8026ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026f1:	48 89 d6             	mov    %rdx,%rsi
  8026f4:	89 c7                	mov    %eax,%edi
  8026f6:	48 b8 fb 25 80 00 00 	movabs $0x8025fb,%rax
  8026fd:	00 00 00 
  802700:	ff d0                	callq  *%rax
  802702:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802705:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802708:	89 c7                	mov    %eax,%edi
  80270a:	48 b8 aa 20 80 00 00 	movabs $0x8020aa,%rax
  802711:	00 00 00 
  802714:	ff d0                	callq  *%rax
	return r;
  802716:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802719:	c9                   	leaveq 
  80271a:	c3                   	retq   

000000000080271b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80271b:	55                   	push   %rbp
  80271c:	48 89 e5             	mov    %rsp,%rbp
  80271f:	48 83 ec 10          	sub    $0x10,%rsp
  802723:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802726:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80272a:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802731:	00 00 00 
  802734:	8b 00                	mov    (%rax),%eax
  802736:	85 c0                	test   %eax,%eax
  802738:	75 1d                	jne    802757 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80273a:	bf 01 00 00 00       	mov    $0x1,%edi
  80273f:	48 b8 e4 36 80 00 00 	movabs $0x8036e4,%rax
  802746:	00 00 00 
  802749:	ff d0                	callq  *%rax
  80274b:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  802752:	00 00 00 
  802755:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802757:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80275e:	00 00 00 
  802761:	8b 00                	mov    (%rax),%eax
  802763:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802766:	b9 07 00 00 00       	mov    $0x7,%ecx
  80276b:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802772:	00 00 00 
  802775:	89 c7                	mov    %eax,%edi
  802777:	48 b8 47 36 80 00 00 	movabs $0x803647,%rax
  80277e:	00 00 00 
  802781:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802783:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802787:	ba 00 00 00 00       	mov    $0x0,%edx
  80278c:	48 89 c6             	mov    %rax,%rsi
  80278f:	bf 00 00 00 00       	mov    $0x0,%edi
  802794:	48 b8 81 35 80 00 00 	movabs $0x803581,%rax
  80279b:	00 00 00 
  80279e:	ff d0                	callq  *%rax
}
  8027a0:	c9                   	leaveq 
  8027a1:	c3                   	retq   

00000000008027a2 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8027a2:	55                   	push   %rbp
  8027a3:	48 89 e5             	mov    %rsp,%rbp
  8027a6:	48 83 ec 20          	sub    $0x20,%rsp
  8027aa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027ae:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  8027b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b5:	48 89 c7             	mov    %rax,%rdi
  8027b8:	48 b8 ac 11 80 00 00 	movabs $0x8011ac,%rax
  8027bf:	00 00 00 
  8027c2:	ff d0                	callq  *%rax
  8027c4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8027c9:	7e 0a                	jle    8027d5 <open+0x33>
  8027cb:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8027d0:	e9 a5 00 00 00       	jmpq   80287a <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  8027d5:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8027d9:	48 89 c7             	mov    %rax,%rdi
  8027dc:	48 b8 02 1e 80 00 00 	movabs $0x801e02,%rax
  8027e3:	00 00 00 
  8027e6:	ff d0                	callq  *%rax
  8027e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027ef:	79 08                	jns    8027f9 <open+0x57>
		return r;
  8027f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027f4:	e9 81 00 00 00       	jmpq   80287a <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  8027f9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802800:	00 00 00 
  802803:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802806:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  80280c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802810:	48 89 c6             	mov    %rax,%rsi
  802813:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  80281a:	00 00 00 
  80281d:	48 b8 18 12 80 00 00 	movabs $0x801218,%rax
  802824:	00 00 00 
  802827:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  802829:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80282d:	48 89 c6             	mov    %rax,%rsi
  802830:	bf 01 00 00 00       	mov    $0x1,%edi
  802835:	48 b8 1b 27 80 00 00 	movabs $0x80271b,%rax
  80283c:	00 00 00 
  80283f:	ff d0                	callq  *%rax
  802841:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802844:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802848:	79 1d                	jns    802867 <open+0xc5>
		fd_close(fd, 0);
  80284a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80284e:	be 00 00 00 00       	mov    $0x0,%esi
  802853:	48 89 c7             	mov    %rax,%rdi
  802856:	48 b8 2a 1f 80 00 00 	movabs $0x801f2a,%rax
  80285d:	00 00 00 
  802860:	ff d0                	callq  *%rax
		return r;
  802862:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802865:	eb 13                	jmp    80287a <open+0xd8>
	}
	return fd2num(fd);
  802867:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80286b:	48 89 c7             	mov    %rax,%rdi
  80286e:	48 b8 b4 1d 80 00 00 	movabs $0x801db4,%rax
  802875:	00 00 00 
  802878:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  80287a:	c9                   	leaveq 
  80287b:	c3                   	retq   

000000000080287c <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80287c:	55                   	push   %rbp
  80287d:	48 89 e5             	mov    %rsp,%rbp
  802880:	48 83 ec 10          	sub    $0x10,%rsp
  802884:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802888:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80288c:	8b 50 0c             	mov    0xc(%rax),%edx
  80288f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802896:	00 00 00 
  802899:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80289b:	be 00 00 00 00       	mov    $0x0,%esi
  8028a0:	bf 06 00 00 00       	mov    $0x6,%edi
  8028a5:	48 b8 1b 27 80 00 00 	movabs $0x80271b,%rax
  8028ac:	00 00 00 
  8028af:	ff d0                	callq  *%rax
}
  8028b1:	c9                   	leaveq 
  8028b2:	c3                   	retq   

00000000008028b3 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8028b3:	55                   	push   %rbp
  8028b4:	48 89 e5             	mov    %rsp,%rbp
  8028b7:	48 83 ec 30          	sub    $0x30,%rsp
  8028bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028bf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028c3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8028c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028cb:	8b 50 0c             	mov    0xc(%rax),%edx
  8028ce:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028d5:	00 00 00 
  8028d8:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8028da:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028e1:	00 00 00 
  8028e4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028e8:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  8028ec:	be 00 00 00 00       	mov    $0x0,%esi
  8028f1:	bf 03 00 00 00       	mov    $0x3,%edi
  8028f6:	48 b8 1b 27 80 00 00 	movabs $0x80271b,%rax
  8028fd:	00 00 00 
  802900:	ff d0                	callq  *%rax
  802902:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802905:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802909:	79 05                	jns    802910 <devfile_read+0x5d>
		return r;
  80290b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80290e:	eb 26                	jmp    802936 <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  802910:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802913:	48 63 d0             	movslq %eax,%rdx
  802916:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80291a:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802921:	00 00 00 
  802924:	48 89 c7             	mov    %rax,%rdi
  802927:	48 b8 53 16 80 00 00 	movabs $0x801653,%rax
  80292e:	00 00 00 
  802931:	ff d0                	callq  *%rax
	return r;
  802933:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802936:	c9                   	leaveq 
  802937:	c3                   	retq   

0000000000802938 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802938:	55                   	push   %rbp
  802939:	48 89 e5             	mov    %rsp,%rbp
  80293c:	48 83 ec 30          	sub    $0x30,%rsp
  802940:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802944:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802948:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  80294c:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  802953:	00 
	n = n > max ? max : n;
  802954:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802958:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80295c:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  802961:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802965:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802969:	8b 50 0c             	mov    0xc(%rax),%edx
  80296c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802973:	00 00 00 
  802976:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802978:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80297f:	00 00 00 
  802982:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802986:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80298a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80298e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802992:	48 89 c6             	mov    %rax,%rsi
  802995:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  80299c:	00 00 00 
  80299f:	48 b8 53 16 80 00 00 	movabs $0x801653,%rax
  8029a6:	00 00 00 
  8029a9:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  8029ab:	be 00 00 00 00       	mov    $0x0,%esi
  8029b0:	bf 04 00 00 00       	mov    $0x4,%edi
  8029b5:	48 b8 1b 27 80 00 00 	movabs $0x80271b,%rax
  8029bc:	00 00 00 
  8029bf:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  8029c1:	c9                   	leaveq 
  8029c2:	c3                   	retq   

00000000008029c3 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8029c3:	55                   	push   %rbp
  8029c4:	48 89 e5             	mov    %rsp,%rbp
  8029c7:	48 83 ec 20          	sub    $0x20,%rsp
  8029cb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029cf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8029d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029d7:	8b 50 0c             	mov    0xc(%rax),%edx
  8029da:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029e1:	00 00 00 
  8029e4:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8029e6:	be 00 00 00 00       	mov    $0x0,%esi
  8029eb:	bf 05 00 00 00       	mov    $0x5,%edi
  8029f0:	48 b8 1b 27 80 00 00 	movabs $0x80271b,%rax
  8029f7:	00 00 00 
  8029fa:	ff d0                	callq  *%rax
  8029fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a03:	79 05                	jns    802a0a <devfile_stat+0x47>
		return r;
  802a05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a08:	eb 56                	jmp    802a60 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802a0a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a0e:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802a15:	00 00 00 
  802a18:	48 89 c7             	mov    %rax,%rdi
  802a1b:	48 b8 18 12 80 00 00 	movabs $0x801218,%rax
  802a22:	00 00 00 
  802a25:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802a27:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a2e:	00 00 00 
  802a31:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802a37:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a3b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802a41:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a48:	00 00 00 
  802a4b:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802a51:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a55:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802a5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a60:	c9                   	leaveq 
  802a61:	c3                   	retq   

0000000000802a62 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802a62:	55                   	push   %rbp
  802a63:	48 89 e5             	mov    %rsp,%rbp
  802a66:	48 83 ec 10          	sub    $0x10,%rsp
  802a6a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802a6e:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802a71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a75:	8b 50 0c             	mov    0xc(%rax),%edx
  802a78:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a7f:	00 00 00 
  802a82:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802a84:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a8b:	00 00 00 
  802a8e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802a91:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802a94:	be 00 00 00 00       	mov    $0x0,%esi
  802a99:	bf 02 00 00 00       	mov    $0x2,%edi
  802a9e:	48 b8 1b 27 80 00 00 	movabs $0x80271b,%rax
  802aa5:	00 00 00 
  802aa8:	ff d0                	callq  *%rax
}
  802aaa:	c9                   	leaveq 
  802aab:	c3                   	retq   

0000000000802aac <remove>:

// Delete a file
int
remove(const char *path)
{
  802aac:	55                   	push   %rbp
  802aad:	48 89 e5             	mov    %rsp,%rbp
  802ab0:	48 83 ec 10          	sub    $0x10,%rsp
  802ab4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802ab8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802abc:	48 89 c7             	mov    %rax,%rdi
  802abf:	48 b8 ac 11 80 00 00 	movabs $0x8011ac,%rax
  802ac6:	00 00 00 
  802ac9:	ff d0                	callq  *%rax
  802acb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802ad0:	7e 07                	jle    802ad9 <remove+0x2d>
		return -E_BAD_PATH;
  802ad2:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ad7:	eb 33                	jmp    802b0c <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802ad9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802add:	48 89 c6             	mov    %rax,%rsi
  802ae0:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802ae7:	00 00 00 
  802aea:	48 b8 18 12 80 00 00 	movabs $0x801218,%rax
  802af1:	00 00 00 
  802af4:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802af6:	be 00 00 00 00       	mov    $0x0,%esi
  802afb:	bf 07 00 00 00       	mov    $0x7,%edi
  802b00:	48 b8 1b 27 80 00 00 	movabs $0x80271b,%rax
  802b07:	00 00 00 
  802b0a:	ff d0                	callq  *%rax
}
  802b0c:	c9                   	leaveq 
  802b0d:	c3                   	retq   

0000000000802b0e <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802b0e:	55                   	push   %rbp
  802b0f:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802b12:	be 00 00 00 00       	mov    $0x0,%esi
  802b17:	bf 08 00 00 00       	mov    $0x8,%edi
  802b1c:	48 b8 1b 27 80 00 00 	movabs $0x80271b,%rax
  802b23:	00 00 00 
  802b26:	ff d0                	callq  *%rax
}
  802b28:	5d                   	pop    %rbp
  802b29:	c3                   	retq   

0000000000802b2a <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802b2a:	55                   	push   %rbp
  802b2b:	48 89 e5             	mov    %rsp,%rbp
  802b2e:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802b35:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802b3c:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802b43:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802b4a:	be 00 00 00 00       	mov    $0x0,%esi
  802b4f:	48 89 c7             	mov    %rax,%rdi
  802b52:	48 b8 a2 27 80 00 00 	movabs $0x8027a2,%rax
  802b59:	00 00 00 
  802b5c:	ff d0                	callq  *%rax
  802b5e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802b61:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b65:	79 28                	jns    802b8f <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802b67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b6a:	89 c6                	mov    %eax,%esi
  802b6c:	48 bf 96 3e 80 00 00 	movabs $0x803e96,%rdi
  802b73:	00 00 00 
  802b76:	b8 00 00 00 00       	mov    $0x0,%eax
  802b7b:	48 ba 63 06 80 00 00 	movabs $0x800663,%rdx
  802b82:	00 00 00 
  802b85:	ff d2                	callq  *%rdx
		return fd_src;
  802b87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b8a:	e9 74 01 00 00       	jmpq   802d03 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802b8f:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802b96:	be 01 01 00 00       	mov    $0x101,%esi
  802b9b:	48 89 c7             	mov    %rax,%rdi
  802b9e:	48 b8 a2 27 80 00 00 	movabs $0x8027a2,%rax
  802ba5:	00 00 00 
  802ba8:	ff d0                	callq  *%rax
  802baa:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802bad:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802bb1:	79 39                	jns    802bec <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802bb3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bb6:	89 c6                	mov    %eax,%esi
  802bb8:	48 bf ac 3e 80 00 00 	movabs $0x803eac,%rdi
  802bbf:	00 00 00 
  802bc2:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc7:	48 ba 63 06 80 00 00 	movabs $0x800663,%rdx
  802bce:	00 00 00 
  802bd1:	ff d2                	callq  *%rdx
		close(fd_src);
  802bd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bd6:	89 c7                	mov    %eax,%edi
  802bd8:	48 b8 aa 20 80 00 00 	movabs $0x8020aa,%rax
  802bdf:	00 00 00 
  802be2:	ff d0                	callq  *%rax
		return fd_dest;
  802be4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802be7:	e9 17 01 00 00       	jmpq   802d03 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802bec:	eb 74                	jmp    802c62 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802bee:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802bf1:	48 63 d0             	movslq %eax,%rdx
  802bf4:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802bfb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bfe:	48 89 ce             	mov    %rcx,%rsi
  802c01:	89 c7                	mov    %eax,%edi
  802c03:	48 b8 16 24 80 00 00 	movabs $0x802416,%rax
  802c0a:	00 00 00 
  802c0d:	ff d0                	callq  *%rax
  802c0f:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802c12:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802c16:	79 4a                	jns    802c62 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802c18:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c1b:	89 c6                	mov    %eax,%esi
  802c1d:	48 bf c6 3e 80 00 00 	movabs $0x803ec6,%rdi
  802c24:	00 00 00 
  802c27:	b8 00 00 00 00       	mov    $0x0,%eax
  802c2c:	48 ba 63 06 80 00 00 	movabs $0x800663,%rdx
  802c33:	00 00 00 
  802c36:	ff d2                	callq  *%rdx
			close(fd_src);
  802c38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c3b:	89 c7                	mov    %eax,%edi
  802c3d:	48 b8 aa 20 80 00 00 	movabs $0x8020aa,%rax
  802c44:	00 00 00 
  802c47:	ff d0                	callq  *%rax
			close(fd_dest);
  802c49:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c4c:	89 c7                	mov    %eax,%edi
  802c4e:	48 b8 aa 20 80 00 00 	movabs $0x8020aa,%rax
  802c55:	00 00 00 
  802c58:	ff d0                	callq  *%rax
			return write_size;
  802c5a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c5d:	e9 a1 00 00 00       	jmpq   802d03 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802c62:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c6c:	ba 00 02 00 00       	mov    $0x200,%edx
  802c71:	48 89 ce             	mov    %rcx,%rsi
  802c74:	89 c7                	mov    %eax,%edi
  802c76:	48 b8 cc 22 80 00 00 	movabs $0x8022cc,%rax
  802c7d:	00 00 00 
  802c80:	ff d0                	callq  *%rax
  802c82:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802c85:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802c89:	0f 8f 5f ff ff ff    	jg     802bee <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802c8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802c93:	79 47                	jns    802cdc <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802c95:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c98:	89 c6                	mov    %eax,%esi
  802c9a:	48 bf d9 3e 80 00 00 	movabs $0x803ed9,%rdi
  802ca1:	00 00 00 
  802ca4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca9:	48 ba 63 06 80 00 00 	movabs $0x800663,%rdx
  802cb0:	00 00 00 
  802cb3:	ff d2                	callq  *%rdx
		close(fd_src);
  802cb5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cb8:	89 c7                	mov    %eax,%edi
  802cba:	48 b8 aa 20 80 00 00 	movabs $0x8020aa,%rax
  802cc1:	00 00 00 
  802cc4:	ff d0                	callq  *%rax
		close(fd_dest);
  802cc6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cc9:	89 c7                	mov    %eax,%edi
  802ccb:	48 b8 aa 20 80 00 00 	movabs $0x8020aa,%rax
  802cd2:	00 00 00 
  802cd5:	ff d0                	callq  *%rax
		return read_size;
  802cd7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802cda:	eb 27                	jmp    802d03 <copy+0x1d9>
	}
	close(fd_src);
  802cdc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cdf:	89 c7                	mov    %eax,%edi
  802ce1:	48 b8 aa 20 80 00 00 	movabs $0x8020aa,%rax
  802ce8:	00 00 00 
  802ceb:	ff d0                	callq  *%rax
	close(fd_dest);
  802ced:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cf0:	89 c7                	mov    %eax,%edi
  802cf2:	48 b8 aa 20 80 00 00 	movabs $0x8020aa,%rax
  802cf9:	00 00 00 
  802cfc:	ff d0                	callq  *%rax
	return 0;
  802cfe:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802d03:	c9                   	leaveq 
  802d04:	c3                   	retq   

0000000000802d05 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802d05:	55                   	push   %rbp
  802d06:	48 89 e5             	mov    %rsp,%rbp
  802d09:	53                   	push   %rbx
  802d0a:	48 83 ec 38          	sub    $0x38,%rsp
  802d0e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802d12:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802d16:	48 89 c7             	mov    %rax,%rdi
  802d19:	48 b8 02 1e 80 00 00 	movabs $0x801e02,%rax
  802d20:	00 00 00 
  802d23:	ff d0                	callq  *%rax
  802d25:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802d28:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802d2c:	0f 88 bf 01 00 00    	js     802ef1 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d32:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d36:	ba 07 04 00 00       	mov    $0x407,%edx
  802d3b:	48 89 c6             	mov    %rax,%rsi
  802d3e:	bf 00 00 00 00       	mov    $0x0,%edi
  802d43:	48 b8 47 1b 80 00 00 	movabs $0x801b47,%rax
  802d4a:	00 00 00 
  802d4d:	ff d0                	callq  *%rax
  802d4f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802d52:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802d56:	0f 88 95 01 00 00    	js     802ef1 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802d5c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802d60:	48 89 c7             	mov    %rax,%rdi
  802d63:	48 b8 02 1e 80 00 00 	movabs $0x801e02,%rax
  802d6a:	00 00 00 
  802d6d:	ff d0                	callq  *%rax
  802d6f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802d72:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802d76:	0f 88 5d 01 00 00    	js     802ed9 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d7c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d80:	ba 07 04 00 00       	mov    $0x407,%edx
  802d85:	48 89 c6             	mov    %rax,%rsi
  802d88:	bf 00 00 00 00       	mov    $0x0,%edi
  802d8d:	48 b8 47 1b 80 00 00 	movabs $0x801b47,%rax
  802d94:	00 00 00 
  802d97:	ff d0                	callq  *%rax
  802d99:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802d9c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802da0:	0f 88 33 01 00 00    	js     802ed9 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802da6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802daa:	48 89 c7             	mov    %rax,%rdi
  802dad:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  802db4:	00 00 00 
  802db7:	ff d0                	callq  *%rax
  802db9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802dbd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dc1:	ba 07 04 00 00       	mov    $0x407,%edx
  802dc6:	48 89 c6             	mov    %rax,%rsi
  802dc9:	bf 00 00 00 00       	mov    $0x0,%edi
  802dce:	48 b8 47 1b 80 00 00 	movabs $0x801b47,%rax
  802dd5:	00 00 00 
  802dd8:	ff d0                	callq  *%rax
  802dda:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802ddd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802de1:	79 05                	jns    802de8 <pipe+0xe3>
		goto err2;
  802de3:	e9 d9 00 00 00       	jmpq   802ec1 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802de8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dec:	48 89 c7             	mov    %rax,%rdi
  802def:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  802df6:	00 00 00 
  802df9:	ff d0                	callq  *%rax
  802dfb:	48 89 c2             	mov    %rax,%rdx
  802dfe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e02:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802e08:	48 89 d1             	mov    %rdx,%rcx
  802e0b:	ba 00 00 00 00       	mov    $0x0,%edx
  802e10:	48 89 c6             	mov    %rax,%rsi
  802e13:	bf 00 00 00 00       	mov    $0x0,%edi
  802e18:	48 b8 97 1b 80 00 00 	movabs $0x801b97,%rax
  802e1f:	00 00 00 
  802e22:	ff d0                	callq  *%rax
  802e24:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802e27:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802e2b:	79 1b                	jns    802e48 <pipe+0x143>
		goto err3;
  802e2d:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  802e2e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e32:	48 89 c6             	mov    %rax,%rsi
  802e35:	bf 00 00 00 00       	mov    $0x0,%edi
  802e3a:	48 b8 f2 1b 80 00 00 	movabs $0x801bf2,%rax
  802e41:	00 00 00 
  802e44:	ff d0                	callq  *%rax
  802e46:	eb 79                	jmp    802ec1 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802e48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e4c:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802e53:	00 00 00 
  802e56:	8b 12                	mov    (%rdx),%edx
  802e58:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802e5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e5e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802e65:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e69:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802e70:	00 00 00 
  802e73:	8b 12                	mov    (%rdx),%edx
  802e75:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802e77:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e7b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802e82:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e86:	48 89 c7             	mov    %rax,%rdi
  802e89:	48 b8 b4 1d 80 00 00 	movabs $0x801db4,%rax
  802e90:	00 00 00 
  802e93:	ff d0                	callq  *%rax
  802e95:	89 c2                	mov    %eax,%edx
  802e97:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802e9b:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802e9d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802ea1:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802ea5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ea9:	48 89 c7             	mov    %rax,%rdi
  802eac:	48 b8 b4 1d 80 00 00 	movabs $0x801db4,%rax
  802eb3:	00 00 00 
  802eb6:	ff d0                	callq  *%rax
  802eb8:	89 03                	mov    %eax,(%rbx)
	return 0;
  802eba:	b8 00 00 00 00       	mov    $0x0,%eax
  802ebf:	eb 33                	jmp    802ef4 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  802ec1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ec5:	48 89 c6             	mov    %rax,%rsi
  802ec8:	bf 00 00 00 00       	mov    $0x0,%edi
  802ecd:	48 b8 f2 1b 80 00 00 	movabs $0x801bf2,%rax
  802ed4:	00 00 00 
  802ed7:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  802ed9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802edd:	48 89 c6             	mov    %rax,%rsi
  802ee0:	bf 00 00 00 00       	mov    $0x0,%edi
  802ee5:	48 b8 f2 1b 80 00 00 	movabs $0x801bf2,%rax
  802eec:	00 00 00 
  802eef:	ff d0                	callq  *%rax
err:
	return r;
  802ef1:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802ef4:	48 83 c4 38          	add    $0x38,%rsp
  802ef8:	5b                   	pop    %rbx
  802ef9:	5d                   	pop    %rbp
  802efa:	c3                   	retq   

0000000000802efb <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802efb:	55                   	push   %rbp
  802efc:	48 89 e5             	mov    %rsp,%rbp
  802eff:	53                   	push   %rbx
  802f00:	48 83 ec 28          	sub    $0x28,%rsp
  802f04:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802f08:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802f0c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802f13:	00 00 00 
  802f16:	48 8b 00             	mov    (%rax),%rax
  802f19:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802f1f:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802f22:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f26:	48 89 c7             	mov    %rax,%rdi
  802f29:	48 b8 66 37 80 00 00 	movabs $0x803766,%rax
  802f30:	00 00 00 
  802f33:	ff d0                	callq  *%rax
  802f35:	89 c3                	mov    %eax,%ebx
  802f37:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f3b:	48 89 c7             	mov    %rax,%rdi
  802f3e:	48 b8 66 37 80 00 00 	movabs $0x803766,%rax
  802f45:	00 00 00 
  802f48:	ff d0                	callq  *%rax
  802f4a:	39 c3                	cmp    %eax,%ebx
  802f4c:	0f 94 c0             	sete   %al
  802f4f:	0f b6 c0             	movzbl %al,%eax
  802f52:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802f55:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802f5c:	00 00 00 
  802f5f:	48 8b 00             	mov    (%rax),%rax
  802f62:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802f68:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802f6b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f6e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802f71:	75 05                	jne    802f78 <_pipeisclosed+0x7d>
			return ret;
  802f73:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802f76:	eb 4f                	jmp    802fc7 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802f78:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f7b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802f7e:	74 42                	je     802fc2 <_pipeisclosed+0xc7>
  802f80:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802f84:	75 3c                	jne    802fc2 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802f86:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802f8d:	00 00 00 
  802f90:	48 8b 00             	mov    (%rax),%rax
  802f93:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802f99:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802f9c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f9f:	89 c6                	mov    %eax,%esi
  802fa1:	48 bf f4 3e 80 00 00 	movabs $0x803ef4,%rdi
  802fa8:	00 00 00 
  802fab:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb0:	49 b8 63 06 80 00 00 	movabs $0x800663,%r8
  802fb7:	00 00 00 
  802fba:	41 ff d0             	callq  *%r8
	}
  802fbd:	e9 4a ff ff ff       	jmpq   802f0c <_pipeisclosed+0x11>
  802fc2:	e9 45 ff ff ff       	jmpq   802f0c <_pipeisclosed+0x11>
}
  802fc7:	48 83 c4 28          	add    $0x28,%rsp
  802fcb:	5b                   	pop    %rbx
  802fcc:	5d                   	pop    %rbp
  802fcd:	c3                   	retq   

0000000000802fce <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802fce:	55                   	push   %rbp
  802fcf:	48 89 e5             	mov    %rsp,%rbp
  802fd2:	48 83 ec 30          	sub    $0x30,%rsp
  802fd6:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802fd9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802fdd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802fe0:	48 89 d6             	mov    %rdx,%rsi
  802fe3:	89 c7                	mov    %eax,%edi
  802fe5:	48 b8 9a 1e 80 00 00 	movabs $0x801e9a,%rax
  802fec:	00 00 00 
  802fef:	ff d0                	callq  *%rax
  802ff1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ff4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ff8:	79 05                	jns    802fff <pipeisclosed+0x31>
		return r;
  802ffa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ffd:	eb 31                	jmp    803030 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802fff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803003:	48 89 c7             	mov    %rax,%rdi
  803006:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  80300d:	00 00 00 
  803010:	ff d0                	callq  *%rax
  803012:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803016:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80301a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80301e:	48 89 d6             	mov    %rdx,%rsi
  803021:	48 89 c7             	mov    %rax,%rdi
  803024:	48 b8 fb 2e 80 00 00 	movabs $0x802efb,%rax
  80302b:	00 00 00 
  80302e:	ff d0                	callq  *%rax
}
  803030:	c9                   	leaveq 
  803031:	c3                   	retq   

0000000000803032 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803032:	55                   	push   %rbp
  803033:	48 89 e5             	mov    %rsp,%rbp
  803036:	48 83 ec 40          	sub    $0x40,%rsp
  80303a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80303e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803042:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803046:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80304a:	48 89 c7             	mov    %rax,%rdi
  80304d:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  803054:	00 00 00 
  803057:	ff d0                	callq  *%rax
  803059:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80305d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803061:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803065:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80306c:	00 
  80306d:	e9 92 00 00 00       	jmpq   803104 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803072:	eb 41                	jmp    8030b5 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803074:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803079:	74 09                	je     803084 <devpipe_read+0x52>
				return i;
  80307b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80307f:	e9 92 00 00 00       	jmpq   803116 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803084:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803088:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80308c:	48 89 d6             	mov    %rdx,%rsi
  80308f:	48 89 c7             	mov    %rax,%rdi
  803092:	48 b8 fb 2e 80 00 00 	movabs $0x802efb,%rax
  803099:	00 00 00 
  80309c:	ff d0                	callq  *%rax
  80309e:	85 c0                	test   %eax,%eax
  8030a0:	74 07                	je     8030a9 <devpipe_read+0x77>
				return 0;
  8030a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8030a7:	eb 6d                	jmp    803116 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8030a9:	48 b8 09 1b 80 00 00 	movabs $0x801b09,%rax
  8030b0:	00 00 00 
  8030b3:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8030b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030b9:	8b 10                	mov    (%rax),%edx
  8030bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030bf:	8b 40 04             	mov    0x4(%rax),%eax
  8030c2:	39 c2                	cmp    %eax,%edx
  8030c4:	74 ae                	je     803074 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8030c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8030ce:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8030d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030d6:	8b 00                	mov    (%rax),%eax
  8030d8:	99                   	cltd   
  8030d9:	c1 ea 1b             	shr    $0x1b,%edx
  8030dc:	01 d0                	add    %edx,%eax
  8030de:	83 e0 1f             	and    $0x1f,%eax
  8030e1:	29 d0                	sub    %edx,%eax
  8030e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8030e7:	48 98                	cltq   
  8030e9:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8030ee:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8030f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030f4:	8b 00                	mov    (%rax),%eax
  8030f6:	8d 50 01             	lea    0x1(%rax),%edx
  8030f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030fd:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8030ff:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803104:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803108:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80310c:	0f 82 60 ff ff ff    	jb     803072 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803112:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803116:	c9                   	leaveq 
  803117:	c3                   	retq   

0000000000803118 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803118:	55                   	push   %rbp
  803119:	48 89 e5             	mov    %rsp,%rbp
  80311c:	48 83 ec 40          	sub    $0x40,%rsp
  803120:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803124:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803128:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80312c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803130:	48 89 c7             	mov    %rax,%rdi
  803133:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  80313a:	00 00 00 
  80313d:	ff d0                	callq  *%rax
  80313f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803143:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803147:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80314b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803152:	00 
  803153:	e9 8e 00 00 00       	jmpq   8031e6 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803158:	eb 31                	jmp    80318b <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80315a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80315e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803162:	48 89 d6             	mov    %rdx,%rsi
  803165:	48 89 c7             	mov    %rax,%rdi
  803168:	48 b8 fb 2e 80 00 00 	movabs $0x802efb,%rax
  80316f:	00 00 00 
  803172:	ff d0                	callq  *%rax
  803174:	85 c0                	test   %eax,%eax
  803176:	74 07                	je     80317f <devpipe_write+0x67>
				return 0;
  803178:	b8 00 00 00 00       	mov    $0x0,%eax
  80317d:	eb 79                	jmp    8031f8 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80317f:	48 b8 09 1b 80 00 00 	movabs $0x801b09,%rax
  803186:	00 00 00 
  803189:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80318b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80318f:	8b 40 04             	mov    0x4(%rax),%eax
  803192:	48 63 d0             	movslq %eax,%rdx
  803195:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803199:	8b 00                	mov    (%rax),%eax
  80319b:	48 98                	cltq   
  80319d:	48 83 c0 20          	add    $0x20,%rax
  8031a1:	48 39 c2             	cmp    %rax,%rdx
  8031a4:	73 b4                	jae    80315a <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8031a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031aa:	8b 40 04             	mov    0x4(%rax),%eax
  8031ad:	99                   	cltd   
  8031ae:	c1 ea 1b             	shr    $0x1b,%edx
  8031b1:	01 d0                	add    %edx,%eax
  8031b3:	83 e0 1f             	and    $0x1f,%eax
  8031b6:	29 d0                	sub    %edx,%eax
  8031b8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8031bc:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8031c0:	48 01 ca             	add    %rcx,%rdx
  8031c3:	0f b6 0a             	movzbl (%rdx),%ecx
  8031c6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8031ca:	48 98                	cltq   
  8031cc:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8031d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031d4:	8b 40 04             	mov    0x4(%rax),%eax
  8031d7:	8d 50 01             	lea    0x1(%rax),%edx
  8031da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031de:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8031e1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8031e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031ea:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8031ee:	0f 82 64 ff ff ff    	jb     803158 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8031f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8031f8:	c9                   	leaveq 
  8031f9:	c3                   	retq   

00000000008031fa <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8031fa:	55                   	push   %rbp
  8031fb:	48 89 e5             	mov    %rsp,%rbp
  8031fe:	48 83 ec 20          	sub    $0x20,%rsp
  803202:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803206:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80320a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80320e:	48 89 c7             	mov    %rax,%rdi
  803211:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  803218:	00 00 00 
  80321b:	ff d0                	callq  *%rax
  80321d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803221:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803225:	48 be 07 3f 80 00 00 	movabs $0x803f07,%rsi
  80322c:	00 00 00 
  80322f:	48 89 c7             	mov    %rax,%rdi
  803232:	48 b8 18 12 80 00 00 	movabs $0x801218,%rax
  803239:	00 00 00 
  80323c:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80323e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803242:	8b 50 04             	mov    0x4(%rax),%edx
  803245:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803249:	8b 00                	mov    (%rax),%eax
  80324b:	29 c2                	sub    %eax,%edx
  80324d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803251:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803257:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80325b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803262:	00 00 00 
	stat->st_dev = &devpipe;
  803265:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803269:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  803270:	00 00 00 
  803273:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80327a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80327f:	c9                   	leaveq 
  803280:	c3                   	retq   

0000000000803281 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803281:	55                   	push   %rbp
  803282:	48 89 e5             	mov    %rsp,%rbp
  803285:	48 83 ec 10          	sub    $0x10,%rsp
  803289:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80328d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803291:	48 89 c6             	mov    %rax,%rsi
  803294:	bf 00 00 00 00       	mov    $0x0,%edi
  803299:	48 b8 f2 1b 80 00 00 	movabs $0x801bf2,%rax
  8032a0:	00 00 00 
  8032a3:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8032a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032a9:	48 89 c7             	mov    %rax,%rdi
  8032ac:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  8032b3:	00 00 00 
  8032b6:	ff d0                	callq  *%rax
  8032b8:	48 89 c6             	mov    %rax,%rsi
  8032bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8032c0:	48 b8 f2 1b 80 00 00 	movabs $0x801bf2,%rax
  8032c7:	00 00 00 
  8032ca:	ff d0                	callq  *%rax
}
  8032cc:	c9                   	leaveq 
  8032cd:	c3                   	retq   

00000000008032ce <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8032ce:	55                   	push   %rbp
  8032cf:	48 89 e5             	mov    %rsp,%rbp
  8032d2:	48 83 ec 20          	sub    $0x20,%rsp
  8032d6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8032d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032dc:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8032df:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8032e3:	be 01 00 00 00       	mov    $0x1,%esi
  8032e8:	48 89 c7             	mov    %rax,%rdi
  8032eb:	48 b8 ff 19 80 00 00 	movabs $0x8019ff,%rax
  8032f2:	00 00 00 
  8032f5:	ff d0                	callq  *%rax
}
  8032f7:	c9                   	leaveq 
  8032f8:	c3                   	retq   

00000000008032f9 <getchar>:

int
getchar(void)
{
  8032f9:	55                   	push   %rbp
  8032fa:	48 89 e5             	mov    %rsp,%rbp
  8032fd:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803301:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803305:	ba 01 00 00 00       	mov    $0x1,%edx
  80330a:	48 89 c6             	mov    %rax,%rsi
  80330d:	bf 00 00 00 00       	mov    $0x0,%edi
  803312:	48 b8 cc 22 80 00 00 	movabs $0x8022cc,%rax
  803319:	00 00 00 
  80331c:	ff d0                	callq  *%rax
  80331e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803321:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803325:	79 05                	jns    80332c <getchar+0x33>
		return r;
  803327:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80332a:	eb 14                	jmp    803340 <getchar+0x47>
	if (r < 1)
  80332c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803330:	7f 07                	jg     803339 <getchar+0x40>
		return -E_EOF;
  803332:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803337:	eb 07                	jmp    803340 <getchar+0x47>
	return c;
  803339:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80333d:	0f b6 c0             	movzbl %al,%eax
}
  803340:	c9                   	leaveq 
  803341:	c3                   	retq   

0000000000803342 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803342:	55                   	push   %rbp
  803343:	48 89 e5             	mov    %rsp,%rbp
  803346:	48 83 ec 20          	sub    $0x20,%rsp
  80334a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80334d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803351:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803354:	48 89 d6             	mov    %rdx,%rsi
  803357:	89 c7                	mov    %eax,%edi
  803359:	48 b8 9a 1e 80 00 00 	movabs $0x801e9a,%rax
  803360:	00 00 00 
  803363:	ff d0                	callq  *%rax
  803365:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803368:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80336c:	79 05                	jns    803373 <iscons+0x31>
		return r;
  80336e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803371:	eb 1a                	jmp    80338d <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803373:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803377:	8b 10                	mov    (%rax),%edx
  803379:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  803380:	00 00 00 
  803383:	8b 00                	mov    (%rax),%eax
  803385:	39 c2                	cmp    %eax,%edx
  803387:	0f 94 c0             	sete   %al
  80338a:	0f b6 c0             	movzbl %al,%eax
}
  80338d:	c9                   	leaveq 
  80338e:	c3                   	retq   

000000000080338f <opencons>:

int
opencons(void)
{
  80338f:	55                   	push   %rbp
  803390:	48 89 e5             	mov    %rsp,%rbp
  803393:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803397:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80339b:	48 89 c7             	mov    %rax,%rdi
  80339e:	48 b8 02 1e 80 00 00 	movabs $0x801e02,%rax
  8033a5:	00 00 00 
  8033a8:	ff d0                	callq  *%rax
  8033aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033b1:	79 05                	jns    8033b8 <opencons+0x29>
		return r;
  8033b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033b6:	eb 5b                	jmp    803413 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8033b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033bc:	ba 07 04 00 00       	mov    $0x407,%edx
  8033c1:	48 89 c6             	mov    %rax,%rsi
  8033c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8033c9:	48 b8 47 1b 80 00 00 	movabs $0x801b47,%rax
  8033d0:	00 00 00 
  8033d3:	ff d0                	callq  *%rax
  8033d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033dc:	79 05                	jns    8033e3 <opencons+0x54>
		return r;
  8033de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033e1:	eb 30                	jmp    803413 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8033e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033e7:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  8033ee:	00 00 00 
  8033f1:	8b 12                	mov    (%rdx),%edx
  8033f3:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8033f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033f9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803400:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803404:	48 89 c7             	mov    %rax,%rdi
  803407:	48 b8 b4 1d 80 00 00 	movabs $0x801db4,%rax
  80340e:	00 00 00 
  803411:	ff d0                	callq  *%rax
}
  803413:	c9                   	leaveq 
  803414:	c3                   	retq   

0000000000803415 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803415:	55                   	push   %rbp
  803416:	48 89 e5             	mov    %rsp,%rbp
  803419:	48 83 ec 30          	sub    $0x30,%rsp
  80341d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803421:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803425:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803429:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80342e:	75 07                	jne    803437 <devcons_read+0x22>
		return 0;
  803430:	b8 00 00 00 00       	mov    $0x0,%eax
  803435:	eb 4b                	jmp    803482 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803437:	eb 0c                	jmp    803445 <devcons_read+0x30>
		sys_yield();
  803439:	48 b8 09 1b 80 00 00 	movabs $0x801b09,%rax
  803440:	00 00 00 
  803443:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803445:	48 b8 49 1a 80 00 00 	movabs $0x801a49,%rax
  80344c:	00 00 00 
  80344f:	ff d0                	callq  *%rax
  803451:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803454:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803458:	74 df                	je     803439 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80345a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80345e:	79 05                	jns    803465 <devcons_read+0x50>
		return c;
  803460:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803463:	eb 1d                	jmp    803482 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803465:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803469:	75 07                	jne    803472 <devcons_read+0x5d>
		return 0;
  80346b:	b8 00 00 00 00       	mov    $0x0,%eax
  803470:	eb 10                	jmp    803482 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803472:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803475:	89 c2                	mov    %eax,%edx
  803477:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80347b:	88 10                	mov    %dl,(%rax)
	return 1;
  80347d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803482:	c9                   	leaveq 
  803483:	c3                   	retq   

0000000000803484 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803484:	55                   	push   %rbp
  803485:	48 89 e5             	mov    %rsp,%rbp
  803488:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80348f:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803496:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80349d:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8034a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8034ab:	eb 76                	jmp    803523 <devcons_write+0x9f>
		m = n - tot;
  8034ad:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8034b4:	89 c2                	mov    %eax,%edx
  8034b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034b9:	29 c2                	sub    %eax,%edx
  8034bb:	89 d0                	mov    %edx,%eax
  8034bd:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8034c0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034c3:	83 f8 7f             	cmp    $0x7f,%eax
  8034c6:	76 07                	jbe    8034cf <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8034c8:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8034cf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034d2:	48 63 d0             	movslq %eax,%rdx
  8034d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034d8:	48 63 c8             	movslq %eax,%rcx
  8034db:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8034e2:	48 01 c1             	add    %rax,%rcx
  8034e5:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8034ec:	48 89 ce             	mov    %rcx,%rsi
  8034ef:	48 89 c7             	mov    %rax,%rdi
  8034f2:	48 b8 3c 15 80 00 00 	movabs $0x80153c,%rax
  8034f9:	00 00 00 
  8034fc:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8034fe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803501:	48 63 d0             	movslq %eax,%rdx
  803504:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80350b:	48 89 d6             	mov    %rdx,%rsi
  80350e:	48 89 c7             	mov    %rax,%rdi
  803511:	48 b8 ff 19 80 00 00 	movabs $0x8019ff,%rax
  803518:	00 00 00 
  80351b:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80351d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803520:	01 45 fc             	add    %eax,-0x4(%rbp)
  803523:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803526:	48 98                	cltq   
  803528:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80352f:	0f 82 78 ff ff ff    	jb     8034ad <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803535:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803538:	c9                   	leaveq 
  803539:	c3                   	retq   

000000000080353a <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80353a:	55                   	push   %rbp
  80353b:	48 89 e5             	mov    %rsp,%rbp
  80353e:	48 83 ec 08          	sub    $0x8,%rsp
  803542:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803546:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80354b:	c9                   	leaveq 
  80354c:	c3                   	retq   

000000000080354d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80354d:	55                   	push   %rbp
  80354e:	48 89 e5             	mov    %rsp,%rbp
  803551:	48 83 ec 10          	sub    $0x10,%rsp
  803555:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803559:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80355d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803561:	48 be 13 3f 80 00 00 	movabs $0x803f13,%rsi
  803568:	00 00 00 
  80356b:	48 89 c7             	mov    %rax,%rdi
  80356e:	48 b8 18 12 80 00 00 	movabs $0x801218,%rax
  803575:	00 00 00 
  803578:	ff d0                	callq  *%rax
	return 0;
  80357a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80357f:	c9                   	leaveq 
  803580:	c3                   	retq   

0000000000803581 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803581:	55                   	push   %rbp
  803582:	48 89 e5             	mov    %rsp,%rbp
  803585:	48 83 ec 30          	sub    $0x30,%rsp
  803589:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80358d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803591:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  803595:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80359a:	74 18                	je     8035b4 <ipc_recv+0x33>
  80359c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035a0:	48 89 c7             	mov    %rax,%rdi
  8035a3:	48 b8 70 1d 80 00 00 	movabs $0x801d70,%rax
  8035aa:	00 00 00 
  8035ad:	ff d0                	callq  *%rax
  8035af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035b2:	eb 19                	jmp    8035cd <ipc_recv+0x4c>
  8035b4:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  8035bb:	00 00 00 
  8035be:	48 b8 70 1d 80 00 00 	movabs $0x801d70,%rax
  8035c5:	00 00 00 
  8035c8:	ff d0                	callq  *%rax
  8035ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  8035cd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8035d2:	74 26                	je     8035fa <ipc_recv+0x79>
  8035d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035d8:	75 15                	jne    8035ef <ipc_recv+0x6e>
  8035da:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8035e1:	00 00 00 
  8035e4:	48 8b 00             	mov    (%rax),%rax
  8035e7:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  8035ed:	eb 05                	jmp    8035f4 <ipc_recv+0x73>
  8035ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8035f4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8035f8:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  8035fa:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8035ff:	74 26                	je     803627 <ipc_recv+0xa6>
  803601:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803605:	75 15                	jne    80361c <ipc_recv+0x9b>
  803607:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80360e:	00 00 00 
  803611:	48 8b 00             	mov    (%rax),%rax
  803614:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  80361a:	eb 05                	jmp    803621 <ipc_recv+0xa0>
  80361c:	b8 00 00 00 00       	mov    $0x0,%eax
  803621:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803625:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  803627:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80362b:	75 15                	jne    803642 <ipc_recv+0xc1>
  80362d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803634:	00 00 00 
  803637:	48 8b 00             	mov    (%rax),%rax
  80363a:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  803640:	eb 03                	jmp    803645 <ipc_recv+0xc4>
  803642:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803645:	c9                   	leaveq 
  803646:	c3                   	retq   

0000000000803647 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803647:	55                   	push   %rbp
  803648:	48 89 e5             	mov    %rsp,%rbp
  80364b:	48 83 ec 30          	sub    $0x30,%rsp
  80364f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803652:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803655:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803659:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  80365c:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  803663:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803668:	75 10                	jne    80367a <ipc_send+0x33>
  80366a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803671:	00 00 00 
  803674:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  803678:	eb 62                	jmp    8036dc <ipc_send+0x95>
  80367a:	eb 60                	jmp    8036dc <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  80367c:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803680:	74 30                	je     8036b2 <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  803682:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803685:	89 c1                	mov    %eax,%ecx
  803687:	48 ba 1a 3f 80 00 00 	movabs $0x803f1a,%rdx
  80368e:	00 00 00 
  803691:	be 33 00 00 00       	mov    $0x33,%esi
  803696:	48 bf 36 3f 80 00 00 	movabs $0x803f36,%rdi
  80369d:	00 00 00 
  8036a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8036a5:	49 b8 2a 04 80 00 00 	movabs $0x80042a,%r8
  8036ac:	00 00 00 
  8036af:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  8036b2:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8036b5:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8036b8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8036bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036bf:	89 c7                	mov    %eax,%edi
  8036c1:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  8036c8:	00 00 00 
  8036cb:	ff d0                	callq  *%rax
  8036cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  8036d0:	48 b8 09 1b 80 00 00 	movabs $0x801b09,%rax
  8036d7:	00 00 00 
  8036da:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  8036dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036e0:	75 9a                	jne    80367c <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  8036e2:	c9                   	leaveq 
  8036e3:	c3                   	retq   

00000000008036e4 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8036e4:	55                   	push   %rbp
  8036e5:	48 89 e5             	mov    %rsp,%rbp
  8036e8:	48 83 ec 14          	sub    $0x14,%rsp
  8036ec:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8036ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8036f6:	eb 5e                	jmp    803756 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8036f8:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8036ff:	00 00 00 
  803702:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803705:	48 63 d0             	movslq %eax,%rdx
  803708:	48 89 d0             	mov    %rdx,%rax
  80370b:	48 c1 e0 03          	shl    $0x3,%rax
  80370f:	48 01 d0             	add    %rdx,%rax
  803712:	48 c1 e0 05          	shl    $0x5,%rax
  803716:	48 01 c8             	add    %rcx,%rax
  803719:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80371f:	8b 00                	mov    (%rax),%eax
  803721:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803724:	75 2c                	jne    803752 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803726:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80372d:	00 00 00 
  803730:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803733:	48 63 d0             	movslq %eax,%rdx
  803736:	48 89 d0             	mov    %rdx,%rax
  803739:	48 c1 e0 03          	shl    $0x3,%rax
  80373d:	48 01 d0             	add    %rdx,%rax
  803740:	48 c1 e0 05          	shl    $0x5,%rax
  803744:	48 01 c8             	add    %rcx,%rax
  803747:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80374d:	8b 40 08             	mov    0x8(%rax),%eax
  803750:	eb 12                	jmp    803764 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803752:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803756:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80375d:	7e 99                	jle    8036f8 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80375f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803764:	c9                   	leaveq 
  803765:	c3                   	retq   

0000000000803766 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803766:	55                   	push   %rbp
  803767:	48 89 e5             	mov    %rsp,%rbp
  80376a:	48 83 ec 18          	sub    $0x18,%rsp
  80376e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803772:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803776:	48 c1 e8 15          	shr    $0x15,%rax
  80377a:	48 89 c2             	mov    %rax,%rdx
  80377d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803784:	01 00 00 
  803787:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80378b:	83 e0 01             	and    $0x1,%eax
  80378e:	48 85 c0             	test   %rax,%rax
  803791:	75 07                	jne    80379a <pageref+0x34>
		return 0;
  803793:	b8 00 00 00 00       	mov    $0x0,%eax
  803798:	eb 53                	jmp    8037ed <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80379a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80379e:	48 c1 e8 0c          	shr    $0xc,%rax
  8037a2:	48 89 c2             	mov    %rax,%rdx
  8037a5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8037ac:	01 00 00 
  8037af:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8037b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8037b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037bb:	83 e0 01             	and    $0x1,%eax
  8037be:	48 85 c0             	test   %rax,%rax
  8037c1:	75 07                	jne    8037ca <pageref+0x64>
		return 0;
  8037c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8037c8:	eb 23                	jmp    8037ed <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8037ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037ce:	48 c1 e8 0c          	shr    $0xc,%rax
  8037d2:	48 89 c2             	mov    %rax,%rdx
  8037d5:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8037dc:	00 00 00 
  8037df:	48 c1 e2 04          	shl    $0x4,%rdx
  8037e3:	48 01 d0             	add    %rdx,%rax
  8037e6:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8037ea:	0f b7 c0             	movzwl %ax,%eax
}
  8037ed:	c9                   	leaveq 
  8037ee:	c3                   	retq   
