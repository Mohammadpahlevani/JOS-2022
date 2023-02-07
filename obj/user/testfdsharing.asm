
obj/user/testfdsharing:     file format elf64-x86-64


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
  80003c:	e8 fa 02 00 00       	callq  80033b <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  800052:	be 00 00 00 00       	mov    $0x0,%esi
  800057:	48 bf c0 3e 80 00 00 	movabs $0x803ec0,%rdi
  80005e:	00 00 00 
  800061:	48 b8 b1 2c 80 00 00 	movabs $0x802cb1,%rax
  800068:	00 00 00 
  80006b:	ff d0                	callq  *%rax
  80006d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800070:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800074:	79 30                	jns    8000a6 <umain+0x63>
		panic("open motd: %e", fd);
  800076:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800079:	89 c1                	mov    %eax,%ecx
  80007b:	48 ba c5 3e 80 00 00 	movabs $0x803ec5,%rdx
  800082:	00 00 00 
  800085:	be 0c 00 00 00       	mov    $0xc,%esi
  80008a:	48 bf d3 3e 80 00 00 	movabs $0x803ed3,%rdi
  800091:	00 00 00 
  800094:	b8 00 00 00 00       	mov    $0x0,%eax
  800099:	49 b8 ee 03 80 00 00 	movabs $0x8003ee,%r8
  8000a0:	00 00 00 
  8000a3:	41 ff d0             	callq  *%r8
	seek(fd, 0);
  8000a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000a9:	be 00 00 00 00       	mov    $0x0,%esi
  8000ae:	89 c7                	mov    %eax,%edi
  8000b0:	48 b8 f9 29 80 00 00 	movabs $0x8029f9,%rax
  8000b7:	00 00 00 
  8000ba:	ff d0                	callq  *%rax
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  8000bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000bf:	ba 00 02 00 00       	mov    $0x200,%edx
  8000c4:	48 be 20 72 80 00 00 	movabs $0x807220,%rsi
  8000cb:	00 00 00 
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	48 b8 b0 28 80 00 00 	movabs $0x8028b0,%rax
  8000d7:	00 00 00 
  8000da:	ff d0                	callq  *%rax
  8000dc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000df:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000e3:	7f 30                	jg     800115 <umain+0xd2>
		panic("readn: %e", n);
  8000e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000e8:	89 c1                	mov    %eax,%ecx
  8000ea:	48 ba e8 3e 80 00 00 	movabs $0x803ee8,%rdx
  8000f1:	00 00 00 
  8000f4:	be 0f 00 00 00       	mov    $0xf,%esi
  8000f9:	48 bf d3 3e 80 00 00 	movabs $0x803ed3,%rdi
  800100:	00 00 00 
  800103:	b8 00 00 00 00       	mov    $0x0,%eax
  800108:	49 b8 ee 03 80 00 00 	movabs $0x8003ee,%r8
  80010f:	00 00 00 
  800112:	41 ff d0             	callq  *%r8

	if ((r = fork()) < 0)
  800115:	48 b8 cb 1f 80 00 00 	movabs $0x801fcb,%rax
  80011c:	00 00 00 
  80011f:	ff d0                	callq  *%rax
  800121:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800124:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800128:	79 30                	jns    80015a <umain+0x117>
		panic("fork: %e", r);
  80012a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80012d:	89 c1                	mov    %eax,%ecx
  80012f:	48 ba f2 3e 80 00 00 	movabs $0x803ef2,%rdx
  800136:	00 00 00 
  800139:	be 12 00 00 00       	mov    $0x12,%esi
  80013e:	48 bf d3 3e 80 00 00 	movabs $0x803ed3,%rdi
  800145:	00 00 00 
  800148:	b8 00 00 00 00       	mov    $0x0,%eax
  80014d:	49 b8 ee 03 80 00 00 	movabs $0x8003ee,%r8
  800154:	00 00 00 
  800157:	41 ff d0             	callq  *%r8
	if (r == 0) {
  80015a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80015e:	0f 85 36 01 00 00    	jne    80029a <umain+0x257>
		seek(fd, 0);
  800164:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800167:	be 00 00 00 00       	mov    $0x0,%esi
  80016c:	89 c7                	mov    %eax,%edi
  80016e:	48 b8 f9 29 80 00 00 	movabs $0x8029f9,%rax
  800175:	00 00 00 
  800178:	ff d0                	callq  *%rax
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  80017a:	48 bf 00 3f 80 00 00 	movabs $0x803f00,%rdi
  800181:	00 00 00 
  800184:	b8 00 00 00 00       	mov    $0x0,%eax
  800189:	48 ba 27 06 80 00 00 	movabs $0x800627,%rdx
  800190:	00 00 00 
  800193:	ff d2                	callq  *%rdx
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800195:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800198:	ba 00 02 00 00       	mov    $0x200,%edx
  80019d:	48 be 20 70 80 00 00 	movabs $0x807020,%rsi
  8001a4:	00 00 00 
  8001a7:	89 c7                	mov    %eax,%edi
  8001a9:	48 b8 b0 28 80 00 00 	movabs $0x8028b0,%rax
  8001b0:	00 00 00 
  8001b3:	ff d0                	callq  *%rax
  8001b5:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8001b8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001bb:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8001be:	74 36                	je     8001f6 <umain+0x1b3>
			panic("read in parent got %d, read in child got %d", n, n2);
  8001c0:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8001c3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001c6:	41 89 d0             	mov    %edx,%r8d
  8001c9:	89 c1                	mov    %eax,%ecx
  8001cb:	48 ba 48 3f 80 00 00 	movabs $0x803f48,%rdx
  8001d2:	00 00 00 
  8001d5:	be 17 00 00 00       	mov    $0x17,%esi
  8001da:	48 bf d3 3e 80 00 00 	movabs $0x803ed3,%rdi
  8001e1:	00 00 00 
  8001e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e9:	49 b9 ee 03 80 00 00 	movabs $0x8003ee,%r9
  8001f0:	00 00 00 
  8001f3:	41 ff d1             	callq  *%r9
		if (memcmp(buf, buf2, n) != 0)
  8001f6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001f9:	48 98                	cltq   
  8001fb:	48 89 c2             	mov    %rax,%rdx
  8001fe:	48 be 20 70 80 00 00 	movabs $0x807020,%rsi
  800205:	00 00 00 
  800208:	48 bf 20 72 80 00 00 	movabs $0x807220,%rdi
  80020f:	00 00 00 
  800212:	48 b8 4b 16 80 00 00 	movabs $0x80164b,%rax
  800219:	00 00 00 
  80021c:	ff d0                	callq  *%rax
  80021e:	85 c0                	test   %eax,%eax
  800220:	74 2a                	je     80024c <umain+0x209>
			panic("read in parent got different bytes from read in child");
  800222:	48 ba 78 3f 80 00 00 	movabs $0x803f78,%rdx
  800229:	00 00 00 
  80022c:	be 19 00 00 00       	mov    $0x19,%esi
  800231:	48 bf d3 3e 80 00 00 	movabs $0x803ed3,%rdi
  800238:	00 00 00 
  80023b:	b8 00 00 00 00       	mov    $0x0,%eax
  800240:	48 b9 ee 03 80 00 00 	movabs $0x8003ee,%rcx
  800247:	00 00 00 
  80024a:	ff d1                	callq  *%rcx
		cprintf("read in child succeeded\n");
  80024c:	48 bf ae 3f 80 00 00 	movabs $0x803fae,%rdi
  800253:	00 00 00 
  800256:	b8 00 00 00 00       	mov    $0x0,%eax
  80025b:	48 ba 27 06 80 00 00 	movabs $0x800627,%rdx
  800262:	00 00 00 
  800265:	ff d2                	callq  *%rdx
		seek(fd, 0);
  800267:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80026a:	be 00 00 00 00       	mov    $0x0,%esi
  80026f:	89 c7                	mov    %eax,%edi
  800271:	48 b8 f9 29 80 00 00 	movabs $0x8029f9,%rax
  800278:	00 00 00 
  80027b:	ff d0                	callq  *%rax
		close(fd);
  80027d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800280:	89 c7                	mov    %eax,%edi
  800282:	48 b8 b9 25 80 00 00 	movabs $0x8025b9,%rax
  800289:	00 00 00 
  80028c:	ff d0                	callq  *%rax
		exit();
  80028e:	48 b8 cb 03 80 00 00 	movabs $0x8003cb,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
	}
	wait(r);
  80029a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80029d:	89 c7                	mov    %eax,%edi
  80029f:	48 b8 dd 37 80 00 00 	movabs $0x8037dd,%rax
  8002a6:	00 00 00 
  8002a9:	ff d0                	callq  *%rax
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8002ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002ae:	ba 00 02 00 00       	mov    $0x200,%edx
  8002b3:	48 be 20 70 80 00 00 	movabs $0x807020,%rsi
  8002ba:	00 00 00 
  8002bd:	89 c7                	mov    %eax,%edi
  8002bf:	48 b8 b0 28 80 00 00 	movabs $0x8028b0,%rax
  8002c6:	00 00 00 
  8002c9:	ff d0                	callq  *%rax
  8002cb:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8002ce:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002d1:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8002d4:	74 36                	je     80030c <umain+0x2c9>
		panic("read in parent got %d, then got %d", n, n2);
  8002d6:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8002d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002dc:	41 89 d0             	mov    %edx,%r8d
  8002df:	89 c1                	mov    %eax,%ecx
  8002e1:	48 ba c8 3f 80 00 00 	movabs $0x803fc8,%rdx
  8002e8:	00 00 00 
  8002eb:	be 21 00 00 00       	mov    $0x21,%esi
  8002f0:	48 bf d3 3e 80 00 00 	movabs $0x803ed3,%rdi
  8002f7:	00 00 00 
  8002fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ff:	49 b9 ee 03 80 00 00 	movabs $0x8003ee,%r9
  800306:	00 00 00 
  800309:	41 ff d1             	callq  *%r9
	cprintf("read in parent succeeded\n");
  80030c:	48 bf eb 3f 80 00 00 	movabs $0x803feb,%rdi
  800313:	00 00 00 
  800316:	b8 00 00 00 00       	mov    $0x0,%eax
  80031b:	48 ba 27 06 80 00 00 	movabs $0x800627,%rdx
  800322:	00 00 00 
  800325:	ff d2                	callq  *%rdx
	close(fd);
  800327:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80032a:	89 c7                	mov    %eax,%edi
  80032c:	48 b8 b9 25 80 00 00 	movabs $0x8025b9,%rax
  800333:	00 00 00 
  800336:	ff d0                	callq  *%rax
static __inline void read_gdtr (uint64_t *gdtbase, uint16_t *gdtlimit) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800338:	cc                   	int3   

	breakpoint();
}
  800339:	c9                   	leaveq 
  80033a:	c3                   	retq   

000000000080033b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80033b:	55                   	push   %rbp
  80033c:	48 89 e5             	mov    %rsp,%rbp
  80033f:	48 83 ec 10          	sub    $0x10,%rsp
  800343:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800346:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  80034a:	48 b8 8f 1a 80 00 00 	movabs $0x801a8f,%rax
  800351:	00 00 00 
  800354:	ff d0                	callq  *%rax
  800356:	48 98                	cltq   
  800358:	25 ff 03 00 00       	and    $0x3ff,%eax
  80035d:	48 89 c2             	mov    %rax,%rdx
  800360:	48 89 d0             	mov    %rdx,%rax
  800363:	48 c1 e0 03          	shl    $0x3,%rax
  800367:	48 01 d0             	add    %rdx,%rax
  80036a:	48 c1 e0 05          	shl    $0x5,%rax
  80036e:	48 89 c2             	mov    %rax,%rdx
  800371:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800378:	00 00 00 
  80037b:	48 01 c2             	add    %rax,%rdx
  80037e:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  800385:	00 00 00 
  800388:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80038b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80038f:	7e 14                	jle    8003a5 <libmain+0x6a>
		binaryname = argv[0];
  800391:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800395:	48 8b 10             	mov    (%rax),%rdx
  800398:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80039f:	00 00 00 
  8003a2:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003a5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003ac:	48 89 d6             	mov    %rdx,%rsi
  8003af:	89 c7                	mov    %eax,%edi
  8003b1:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8003b8:	00 00 00 
  8003bb:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8003bd:	48 b8 cb 03 80 00 00 	movabs $0x8003cb,%rax
  8003c4:	00 00 00 
  8003c7:	ff d0                	callq  *%rax
}
  8003c9:	c9                   	leaveq 
  8003ca:	c3                   	retq   

00000000008003cb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003cb:	55                   	push   %rbp
  8003cc:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8003cf:	48 b8 04 26 80 00 00 	movabs $0x802604,%rax
  8003d6:	00 00 00 
  8003d9:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8003db:	bf 00 00 00 00       	mov    $0x0,%edi
  8003e0:	48 b8 4b 1a 80 00 00 	movabs $0x801a4b,%rax
  8003e7:	00 00 00 
  8003ea:	ff d0                	callq  *%rax
}
  8003ec:	5d                   	pop    %rbp
  8003ed:	c3                   	retq   

00000000008003ee <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003ee:	55                   	push   %rbp
  8003ef:	48 89 e5             	mov    %rsp,%rbp
  8003f2:	53                   	push   %rbx
  8003f3:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8003fa:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800401:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800407:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80040e:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800415:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80041c:	84 c0                	test   %al,%al
  80041e:	74 23                	je     800443 <_panic+0x55>
  800420:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800427:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80042b:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80042f:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800433:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800437:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80043b:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80043f:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800443:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80044a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800451:	00 00 00 
  800454:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80045b:	00 00 00 
  80045e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800462:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800469:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800470:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800477:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80047e:	00 00 00 
  800481:	48 8b 18             	mov    (%rax),%rbx
  800484:	48 b8 8f 1a 80 00 00 	movabs $0x801a8f,%rax
  80048b:	00 00 00 
  80048e:	ff d0                	callq  *%rax
  800490:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800496:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80049d:	41 89 c8             	mov    %ecx,%r8d
  8004a0:	48 89 d1             	mov    %rdx,%rcx
  8004a3:	48 89 da             	mov    %rbx,%rdx
  8004a6:	89 c6                	mov    %eax,%esi
  8004a8:	48 bf 10 40 80 00 00 	movabs $0x804010,%rdi
  8004af:	00 00 00 
  8004b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b7:	49 b9 27 06 80 00 00 	movabs $0x800627,%r9
  8004be:	00 00 00 
  8004c1:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004c4:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8004cb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004d2:	48 89 d6             	mov    %rdx,%rsi
  8004d5:	48 89 c7             	mov    %rax,%rdi
  8004d8:	48 b8 7b 05 80 00 00 	movabs $0x80057b,%rax
  8004df:	00 00 00 
  8004e2:	ff d0                	callq  *%rax
	cprintf("\n");
  8004e4:	48 bf 33 40 80 00 00 	movabs $0x804033,%rdi
  8004eb:	00 00 00 
  8004ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f3:	48 ba 27 06 80 00 00 	movabs $0x800627,%rdx
  8004fa:	00 00 00 
  8004fd:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8004ff:	cc                   	int3   
  800500:	eb fd                	jmp    8004ff <_panic+0x111>

0000000000800502 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800502:	55                   	push   %rbp
  800503:	48 89 e5             	mov    %rsp,%rbp
  800506:	48 83 ec 10          	sub    $0x10,%rsp
  80050a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80050d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800511:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800515:	8b 00                	mov    (%rax),%eax
  800517:	8d 48 01             	lea    0x1(%rax),%ecx
  80051a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80051e:	89 0a                	mov    %ecx,(%rdx)
  800520:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800523:	89 d1                	mov    %edx,%ecx
  800525:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800529:	48 98                	cltq   
  80052b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80052f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800533:	8b 00                	mov    (%rax),%eax
  800535:	3d ff 00 00 00       	cmp    $0xff,%eax
  80053a:	75 2c                	jne    800568 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80053c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800540:	8b 00                	mov    (%rax),%eax
  800542:	48 98                	cltq   
  800544:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800548:	48 83 c2 08          	add    $0x8,%rdx
  80054c:	48 89 c6             	mov    %rax,%rsi
  80054f:	48 89 d7             	mov    %rdx,%rdi
  800552:	48 b8 c3 19 80 00 00 	movabs $0x8019c3,%rax
  800559:	00 00 00 
  80055c:	ff d0                	callq  *%rax
        b->idx = 0;
  80055e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800562:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800568:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80056c:	8b 40 04             	mov    0x4(%rax),%eax
  80056f:	8d 50 01             	lea    0x1(%rax),%edx
  800572:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800576:	89 50 04             	mov    %edx,0x4(%rax)
}
  800579:	c9                   	leaveq 
  80057a:	c3                   	retq   

000000000080057b <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80057b:	55                   	push   %rbp
  80057c:	48 89 e5             	mov    %rsp,%rbp
  80057f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800586:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80058d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800594:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80059b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005a2:	48 8b 0a             	mov    (%rdx),%rcx
  8005a5:	48 89 08             	mov    %rcx,(%rax)
  8005a8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005ac:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005b0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005b4:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8005b8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005bf:	00 00 00 
    b.cnt = 0;
  8005c2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8005c9:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8005cc:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8005d3:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8005da:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8005e1:	48 89 c6             	mov    %rax,%rsi
  8005e4:	48 bf 02 05 80 00 00 	movabs $0x800502,%rdi
  8005eb:	00 00 00 
  8005ee:	48 b8 da 09 80 00 00 	movabs $0x8009da,%rax
  8005f5:	00 00 00 
  8005f8:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8005fa:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800600:	48 98                	cltq   
  800602:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800609:	48 83 c2 08          	add    $0x8,%rdx
  80060d:	48 89 c6             	mov    %rax,%rsi
  800610:	48 89 d7             	mov    %rdx,%rdi
  800613:	48 b8 c3 19 80 00 00 	movabs $0x8019c3,%rax
  80061a:	00 00 00 
  80061d:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80061f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800625:	c9                   	leaveq 
  800626:	c3                   	retq   

0000000000800627 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800627:	55                   	push   %rbp
  800628:	48 89 e5             	mov    %rsp,%rbp
  80062b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800632:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800639:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800640:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800647:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80064e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800655:	84 c0                	test   %al,%al
  800657:	74 20                	je     800679 <cprintf+0x52>
  800659:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80065d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800661:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800665:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800669:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80066d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800671:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800675:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800679:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800680:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800687:	00 00 00 
  80068a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800691:	00 00 00 
  800694:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800698:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80069f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006a6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8006ad:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006b4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006bb:	48 8b 0a             	mov    (%rdx),%rcx
  8006be:	48 89 08             	mov    %rcx,(%rax)
  8006c1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006c5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006c9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006cd:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8006d1:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8006d8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006df:	48 89 d6             	mov    %rdx,%rsi
  8006e2:	48 89 c7             	mov    %rax,%rdi
  8006e5:	48 b8 7b 05 80 00 00 	movabs $0x80057b,%rax
  8006ec:	00 00 00 
  8006ef:	ff d0                	callq  *%rax
  8006f1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8006f7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8006fd:	c9                   	leaveq 
  8006fe:	c3                   	retq   

00000000008006ff <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006ff:	55                   	push   %rbp
  800700:	48 89 e5             	mov    %rsp,%rbp
  800703:	53                   	push   %rbx
  800704:	48 83 ec 38          	sub    $0x38,%rsp
  800708:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80070c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800710:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800714:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800717:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80071b:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80071f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800722:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800726:	77 3b                	ja     800763 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800728:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80072b:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80072f:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800732:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800736:	ba 00 00 00 00       	mov    $0x0,%edx
  80073b:	48 f7 f3             	div    %rbx
  80073e:	48 89 c2             	mov    %rax,%rdx
  800741:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800744:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800747:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80074b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074f:	41 89 f9             	mov    %edi,%r9d
  800752:	48 89 c7             	mov    %rax,%rdi
  800755:	48 b8 ff 06 80 00 00 	movabs $0x8006ff,%rax
  80075c:	00 00 00 
  80075f:	ff d0                	callq  *%rax
  800761:	eb 1e                	jmp    800781 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800763:	eb 12                	jmp    800777 <printnum+0x78>
			putch(padc, putdat);
  800765:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800769:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80076c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800770:	48 89 ce             	mov    %rcx,%rsi
  800773:	89 d7                	mov    %edx,%edi
  800775:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800777:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80077b:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80077f:	7f e4                	jg     800765 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800781:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800784:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800788:	ba 00 00 00 00       	mov    $0x0,%edx
  80078d:	48 f7 f1             	div    %rcx
  800790:	48 89 d0             	mov    %rdx,%rax
  800793:	48 ba 30 42 80 00 00 	movabs $0x804230,%rdx
  80079a:	00 00 00 
  80079d:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8007a1:	0f be d0             	movsbl %al,%edx
  8007a4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ac:	48 89 ce             	mov    %rcx,%rsi
  8007af:	89 d7                	mov    %edx,%edi
  8007b1:	ff d0                	callq  *%rax
}
  8007b3:	48 83 c4 38          	add    $0x38,%rsp
  8007b7:	5b                   	pop    %rbx
  8007b8:	5d                   	pop    %rbp
  8007b9:	c3                   	retq   

00000000008007ba <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007ba:	55                   	push   %rbp
  8007bb:	48 89 e5             	mov    %rsp,%rbp
  8007be:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007c6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8007c9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007cd:	7e 52                	jle    800821 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8007cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d3:	8b 00                	mov    (%rax),%eax
  8007d5:	83 f8 30             	cmp    $0x30,%eax
  8007d8:	73 24                	jae    8007fe <getuint+0x44>
  8007da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007de:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e6:	8b 00                	mov    (%rax),%eax
  8007e8:	89 c0                	mov    %eax,%eax
  8007ea:	48 01 d0             	add    %rdx,%rax
  8007ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f1:	8b 12                	mov    (%rdx),%edx
  8007f3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007fa:	89 0a                	mov    %ecx,(%rdx)
  8007fc:	eb 17                	jmp    800815 <getuint+0x5b>
  8007fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800802:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800806:	48 89 d0             	mov    %rdx,%rax
  800809:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80080d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800811:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800815:	48 8b 00             	mov    (%rax),%rax
  800818:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80081c:	e9 a3 00 00 00       	jmpq   8008c4 <getuint+0x10a>
	else if (lflag)
  800821:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800825:	74 4f                	je     800876 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800827:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082b:	8b 00                	mov    (%rax),%eax
  80082d:	83 f8 30             	cmp    $0x30,%eax
  800830:	73 24                	jae    800856 <getuint+0x9c>
  800832:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800836:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80083a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083e:	8b 00                	mov    (%rax),%eax
  800840:	89 c0                	mov    %eax,%eax
  800842:	48 01 d0             	add    %rdx,%rax
  800845:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800849:	8b 12                	mov    (%rdx),%edx
  80084b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80084e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800852:	89 0a                	mov    %ecx,(%rdx)
  800854:	eb 17                	jmp    80086d <getuint+0xb3>
  800856:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80085a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80085e:	48 89 d0             	mov    %rdx,%rax
  800861:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800865:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800869:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80086d:	48 8b 00             	mov    (%rax),%rax
  800870:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800874:	eb 4e                	jmp    8008c4 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800876:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087a:	8b 00                	mov    (%rax),%eax
  80087c:	83 f8 30             	cmp    $0x30,%eax
  80087f:	73 24                	jae    8008a5 <getuint+0xeb>
  800881:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800885:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800889:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80088d:	8b 00                	mov    (%rax),%eax
  80088f:	89 c0                	mov    %eax,%eax
  800891:	48 01 d0             	add    %rdx,%rax
  800894:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800898:	8b 12                	mov    (%rdx),%edx
  80089a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80089d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a1:	89 0a                	mov    %ecx,(%rdx)
  8008a3:	eb 17                	jmp    8008bc <getuint+0x102>
  8008a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008ad:	48 89 d0             	mov    %rdx,%rax
  8008b0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008bc:	8b 00                	mov    (%rax),%eax
  8008be:	89 c0                	mov    %eax,%eax
  8008c0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008c8:	c9                   	leaveq 
  8008c9:	c3                   	retq   

00000000008008ca <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008ca:	55                   	push   %rbp
  8008cb:	48 89 e5             	mov    %rsp,%rbp
  8008ce:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008d6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8008d9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008dd:	7e 52                	jle    800931 <getint+0x67>
		x=va_arg(*ap, long long);
  8008df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e3:	8b 00                	mov    (%rax),%eax
  8008e5:	83 f8 30             	cmp    $0x30,%eax
  8008e8:	73 24                	jae    80090e <getint+0x44>
  8008ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ee:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f6:	8b 00                	mov    (%rax),%eax
  8008f8:	89 c0                	mov    %eax,%eax
  8008fa:	48 01 d0             	add    %rdx,%rax
  8008fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800901:	8b 12                	mov    (%rdx),%edx
  800903:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800906:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80090a:	89 0a                	mov    %ecx,(%rdx)
  80090c:	eb 17                	jmp    800925 <getint+0x5b>
  80090e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800912:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800916:	48 89 d0             	mov    %rdx,%rax
  800919:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80091d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800921:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800925:	48 8b 00             	mov    (%rax),%rax
  800928:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80092c:	e9 a3 00 00 00       	jmpq   8009d4 <getint+0x10a>
	else if (lflag)
  800931:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800935:	74 4f                	je     800986 <getint+0xbc>
		x=va_arg(*ap, long);
  800937:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80093b:	8b 00                	mov    (%rax),%eax
  80093d:	83 f8 30             	cmp    $0x30,%eax
  800940:	73 24                	jae    800966 <getint+0x9c>
  800942:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800946:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80094a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80094e:	8b 00                	mov    (%rax),%eax
  800950:	89 c0                	mov    %eax,%eax
  800952:	48 01 d0             	add    %rdx,%rax
  800955:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800959:	8b 12                	mov    (%rdx),%edx
  80095b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80095e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800962:	89 0a                	mov    %ecx,(%rdx)
  800964:	eb 17                	jmp    80097d <getint+0xb3>
  800966:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80096a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80096e:	48 89 d0             	mov    %rdx,%rax
  800971:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800975:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800979:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80097d:	48 8b 00             	mov    (%rax),%rax
  800980:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800984:	eb 4e                	jmp    8009d4 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800986:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098a:	8b 00                	mov    (%rax),%eax
  80098c:	83 f8 30             	cmp    $0x30,%eax
  80098f:	73 24                	jae    8009b5 <getint+0xeb>
  800991:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800995:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800999:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80099d:	8b 00                	mov    (%rax),%eax
  80099f:	89 c0                	mov    %eax,%eax
  8009a1:	48 01 d0             	add    %rdx,%rax
  8009a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009a8:	8b 12                	mov    (%rdx),%edx
  8009aa:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b1:	89 0a                	mov    %ecx,(%rdx)
  8009b3:	eb 17                	jmp    8009cc <getint+0x102>
  8009b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009bd:	48 89 d0             	mov    %rdx,%rax
  8009c0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009cc:	8b 00                	mov    (%rax),%eax
  8009ce:	48 98                	cltq   
  8009d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009d8:	c9                   	leaveq 
  8009d9:	c3                   	retq   

00000000008009da <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009da:	55                   	push   %rbp
  8009db:	48 89 e5             	mov    %rsp,%rbp
  8009de:	41 54                	push   %r12
  8009e0:	53                   	push   %rbx
  8009e1:	48 83 ec 60          	sub    $0x60,%rsp
  8009e5:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8009e9:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8009ed:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009f1:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8009f5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009f9:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8009fd:	48 8b 0a             	mov    (%rdx),%rcx
  800a00:	48 89 08             	mov    %rcx,(%rax)
  800a03:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a07:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a0b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a0f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a13:	eb 17                	jmp    800a2c <vprintfmt+0x52>
			if (ch == '\0')
  800a15:	85 db                	test   %ebx,%ebx
  800a17:	0f 84 cc 04 00 00    	je     800ee9 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800a1d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a21:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a25:	48 89 d6             	mov    %rdx,%rsi
  800a28:	89 df                	mov    %ebx,%edi
  800a2a:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a2c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a30:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a34:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a38:	0f b6 00             	movzbl (%rax),%eax
  800a3b:	0f b6 d8             	movzbl %al,%ebx
  800a3e:	83 fb 25             	cmp    $0x25,%ebx
  800a41:	75 d2                	jne    800a15 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a43:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a47:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a4e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a55:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a5c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a63:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a67:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a6b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a6f:	0f b6 00             	movzbl (%rax),%eax
  800a72:	0f b6 d8             	movzbl %al,%ebx
  800a75:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a78:	83 f8 55             	cmp    $0x55,%eax
  800a7b:	0f 87 34 04 00 00    	ja     800eb5 <vprintfmt+0x4db>
  800a81:	89 c0                	mov    %eax,%eax
  800a83:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a8a:	00 
  800a8b:	48 b8 58 42 80 00 00 	movabs $0x804258,%rax
  800a92:	00 00 00 
  800a95:	48 01 d0             	add    %rdx,%rax
  800a98:	48 8b 00             	mov    (%rax),%rax
  800a9b:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800a9d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800aa1:	eb c0                	jmp    800a63 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800aa3:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800aa7:	eb ba                	jmp    800a63 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800aa9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800ab0:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800ab3:	89 d0                	mov    %edx,%eax
  800ab5:	c1 e0 02             	shl    $0x2,%eax
  800ab8:	01 d0                	add    %edx,%eax
  800aba:	01 c0                	add    %eax,%eax
  800abc:	01 d8                	add    %ebx,%eax
  800abe:	83 e8 30             	sub    $0x30,%eax
  800ac1:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800ac4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ac8:	0f b6 00             	movzbl (%rax),%eax
  800acb:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ace:	83 fb 2f             	cmp    $0x2f,%ebx
  800ad1:	7e 0c                	jle    800adf <vprintfmt+0x105>
  800ad3:	83 fb 39             	cmp    $0x39,%ebx
  800ad6:	7f 07                	jg     800adf <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ad8:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800add:	eb d1                	jmp    800ab0 <vprintfmt+0xd6>
			goto process_precision;
  800adf:	eb 58                	jmp    800b39 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800ae1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae4:	83 f8 30             	cmp    $0x30,%eax
  800ae7:	73 17                	jae    800b00 <vprintfmt+0x126>
  800ae9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800aed:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800af0:	89 c0                	mov    %eax,%eax
  800af2:	48 01 d0             	add    %rdx,%rax
  800af5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800af8:	83 c2 08             	add    $0x8,%edx
  800afb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800afe:	eb 0f                	jmp    800b0f <vprintfmt+0x135>
  800b00:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b04:	48 89 d0             	mov    %rdx,%rax
  800b07:	48 83 c2 08          	add    $0x8,%rdx
  800b0b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b0f:	8b 00                	mov    (%rax),%eax
  800b11:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b14:	eb 23                	jmp    800b39 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800b16:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b1a:	79 0c                	jns    800b28 <vprintfmt+0x14e>
				width = 0;
  800b1c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b23:	e9 3b ff ff ff       	jmpq   800a63 <vprintfmt+0x89>
  800b28:	e9 36 ff ff ff       	jmpq   800a63 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800b2d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b34:	e9 2a ff ff ff       	jmpq   800a63 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800b39:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b3d:	79 12                	jns    800b51 <vprintfmt+0x177>
				width = precision, precision = -1;
  800b3f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b42:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b45:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b4c:	e9 12 ff ff ff       	jmpq   800a63 <vprintfmt+0x89>
  800b51:	e9 0d ff ff ff       	jmpq   800a63 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b56:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b5a:	e9 04 ff ff ff       	jmpq   800a63 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b5f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b62:	83 f8 30             	cmp    $0x30,%eax
  800b65:	73 17                	jae    800b7e <vprintfmt+0x1a4>
  800b67:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b6b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b6e:	89 c0                	mov    %eax,%eax
  800b70:	48 01 d0             	add    %rdx,%rax
  800b73:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b76:	83 c2 08             	add    $0x8,%edx
  800b79:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b7c:	eb 0f                	jmp    800b8d <vprintfmt+0x1b3>
  800b7e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b82:	48 89 d0             	mov    %rdx,%rax
  800b85:	48 83 c2 08          	add    $0x8,%rdx
  800b89:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b8d:	8b 10                	mov    (%rax),%edx
  800b8f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b93:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b97:	48 89 ce             	mov    %rcx,%rsi
  800b9a:	89 d7                	mov    %edx,%edi
  800b9c:	ff d0                	callq  *%rax
			break;
  800b9e:	e9 40 03 00 00       	jmpq   800ee3 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800ba3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ba6:	83 f8 30             	cmp    $0x30,%eax
  800ba9:	73 17                	jae    800bc2 <vprintfmt+0x1e8>
  800bab:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800baf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bb2:	89 c0                	mov    %eax,%eax
  800bb4:	48 01 d0             	add    %rdx,%rax
  800bb7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bba:	83 c2 08             	add    $0x8,%edx
  800bbd:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bc0:	eb 0f                	jmp    800bd1 <vprintfmt+0x1f7>
  800bc2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bc6:	48 89 d0             	mov    %rdx,%rax
  800bc9:	48 83 c2 08          	add    $0x8,%rdx
  800bcd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bd1:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800bd3:	85 db                	test   %ebx,%ebx
  800bd5:	79 02                	jns    800bd9 <vprintfmt+0x1ff>
				err = -err;
  800bd7:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800bd9:	83 fb 15             	cmp    $0x15,%ebx
  800bdc:	7f 16                	jg     800bf4 <vprintfmt+0x21a>
  800bde:	48 b8 80 41 80 00 00 	movabs $0x804180,%rax
  800be5:	00 00 00 
  800be8:	48 63 d3             	movslq %ebx,%rdx
  800beb:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800bef:	4d 85 e4             	test   %r12,%r12
  800bf2:	75 2e                	jne    800c22 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800bf4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bf8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bfc:	89 d9                	mov    %ebx,%ecx
  800bfe:	48 ba 41 42 80 00 00 	movabs $0x804241,%rdx
  800c05:	00 00 00 
  800c08:	48 89 c7             	mov    %rax,%rdi
  800c0b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c10:	49 b8 f2 0e 80 00 00 	movabs $0x800ef2,%r8
  800c17:	00 00 00 
  800c1a:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c1d:	e9 c1 02 00 00       	jmpq   800ee3 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c22:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c26:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c2a:	4c 89 e1             	mov    %r12,%rcx
  800c2d:	48 ba 4a 42 80 00 00 	movabs $0x80424a,%rdx
  800c34:	00 00 00 
  800c37:	48 89 c7             	mov    %rax,%rdi
  800c3a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3f:	49 b8 f2 0e 80 00 00 	movabs $0x800ef2,%r8
  800c46:	00 00 00 
  800c49:	41 ff d0             	callq  *%r8
			break;
  800c4c:	e9 92 02 00 00       	jmpq   800ee3 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c51:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c54:	83 f8 30             	cmp    $0x30,%eax
  800c57:	73 17                	jae    800c70 <vprintfmt+0x296>
  800c59:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c5d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c60:	89 c0                	mov    %eax,%eax
  800c62:	48 01 d0             	add    %rdx,%rax
  800c65:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c68:	83 c2 08             	add    $0x8,%edx
  800c6b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c6e:	eb 0f                	jmp    800c7f <vprintfmt+0x2a5>
  800c70:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c74:	48 89 d0             	mov    %rdx,%rax
  800c77:	48 83 c2 08          	add    $0x8,%rdx
  800c7b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c7f:	4c 8b 20             	mov    (%rax),%r12
  800c82:	4d 85 e4             	test   %r12,%r12
  800c85:	75 0a                	jne    800c91 <vprintfmt+0x2b7>
				p = "(null)";
  800c87:	49 bc 4d 42 80 00 00 	movabs $0x80424d,%r12
  800c8e:	00 00 00 
			if (width > 0 && padc != '-')
  800c91:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c95:	7e 3f                	jle    800cd6 <vprintfmt+0x2fc>
  800c97:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c9b:	74 39                	je     800cd6 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c9d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ca0:	48 98                	cltq   
  800ca2:	48 89 c6             	mov    %rax,%rsi
  800ca5:	4c 89 e7             	mov    %r12,%rdi
  800ca8:	48 b8 9e 11 80 00 00 	movabs $0x80119e,%rax
  800caf:	00 00 00 
  800cb2:	ff d0                	callq  *%rax
  800cb4:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800cb7:	eb 17                	jmp    800cd0 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800cb9:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800cbd:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cc1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cc5:	48 89 ce             	mov    %rcx,%rsi
  800cc8:	89 d7                	mov    %edx,%edi
  800cca:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ccc:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cd0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cd4:	7f e3                	jg     800cb9 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cd6:	eb 37                	jmp    800d0f <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800cd8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800cdc:	74 1e                	je     800cfc <vprintfmt+0x322>
  800cde:	83 fb 1f             	cmp    $0x1f,%ebx
  800ce1:	7e 05                	jle    800ce8 <vprintfmt+0x30e>
  800ce3:	83 fb 7e             	cmp    $0x7e,%ebx
  800ce6:	7e 14                	jle    800cfc <vprintfmt+0x322>
					putch('?', putdat);
  800ce8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cec:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cf0:	48 89 d6             	mov    %rdx,%rsi
  800cf3:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800cf8:	ff d0                	callq  *%rax
  800cfa:	eb 0f                	jmp    800d0b <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800cfc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d00:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d04:	48 89 d6             	mov    %rdx,%rsi
  800d07:	89 df                	mov    %ebx,%edi
  800d09:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d0b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d0f:	4c 89 e0             	mov    %r12,%rax
  800d12:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d16:	0f b6 00             	movzbl (%rax),%eax
  800d19:	0f be d8             	movsbl %al,%ebx
  800d1c:	85 db                	test   %ebx,%ebx
  800d1e:	74 10                	je     800d30 <vprintfmt+0x356>
  800d20:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d24:	78 b2                	js     800cd8 <vprintfmt+0x2fe>
  800d26:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d2a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d2e:	79 a8                	jns    800cd8 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d30:	eb 16                	jmp    800d48 <vprintfmt+0x36e>
				putch(' ', putdat);
  800d32:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d36:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d3a:	48 89 d6             	mov    %rdx,%rsi
  800d3d:	bf 20 00 00 00       	mov    $0x20,%edi
  800d42:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d44:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d48:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d4c:	7f e4                	jg     800d32 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800d4e:	e9 90 01 00 00       	jmpq   800ee3 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d53:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d57:	be 03 00 00 00       	mov    $0x3,%esi
  800d5c:	48 89 c7             	mov    %rax,%rdi
  800d5f:	48 b8 ca 08 80 00 00 	movabs $0x8008ca,%rax
  800d66:	00 00 00 
  800d69:	ff d0                	callq  *%rax
  800d6b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d73:	48 85 c0             	test   %rax,%rax
  800d76:	79 1d                	jns    800d95 <vprintfmt+0x3bb>
				putch('-', putdat);
  800d78:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d7c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d80:	48 89 d6             	mov    %rdx,%rsi
  800d83:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d88:	ff d0                	callq  *%rax
				num = -(long long) num;
  800d8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d8e:	48 f7 d8             	neg    %rax
  800d91:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d95:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d9c:	e9 d5 00 00 00       	jmpq   800e76 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800da1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800da5:	be 03 00 00 00       	mov    $0x3,%esi
  800daa:	48 89 c7             	mov    %rax,%rdi
  800dad:	48 b8 ba 07 80 00 00 	movabs $0x8007ba,%rax
  800db4:	00 00 00 
  800db7:	ff d0                	callq  *%rax
  800db9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800dbd:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800dc4:	e9 ad 00 00 00       	jmpq   800e76 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  800dc9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dcd:	be 03 00 00 00       	mov    $0x3,%esi
  800dd2:	48 89 c7             	mov    %rax,%rdi
  800dd5:	48 b8 ba 07 80 00 00 	movabs $0x8007ba,%rax
  800ddc:	00 00 00 
  800ddf:	ff d0                	callq  *%rax
  800de1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  800de5:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  800dec:	e9 85 00 00 00       	jmpq   800e76 <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  800df1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800df5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800df9:	48 89 d6             	mov    %rdx,%rsi
  800dfc:	bf 30 00 00 00       	mov    $0x30,%edi
  800e01:	ff d0                	callq  *%rax
			putch('x', putdat);
  800e03:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e07:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e0b:	48 89 d6             	mov    %rdx,%rsi
  800e0e:	bf 78 00 00 00       	mov    $0x78,%edi
  800e13:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e15:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e18:	83 f8 30             	cmp    $0x30,%eax
  800e1b:	73 17                	jae    800e34 <vprintfmt+0x45a>
  800e1d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e21:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e24:	89 c0                	mov    %eax,%eax
  800e26:	48 01 d0             	add    %rdx,%rax
  800e29:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e2c:	83 c2 08             	add    $0x8,%edx
  800e2f:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e32:	eb 0f                	jmp    800e43 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800e34:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e38:	48 89 d0             	mov    %rdx,%rax
  800e3b:	48 83 c2 08          	add    $0x8,%rdx
  800e3f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e43:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e46:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e4a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e51:	eb 23                	jmp    800e76 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e53:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e57:	be 03 00 00 00       	mov    $0x3,%esi
  800e5c:	48 89 c7             	mov    %rax,%rdi
  800e5f:	48 b8 ba 07 80 00 00 	movabs $0x8007ba,%rax
  800e66:	00 00 00 
  800e69:	ff d0                	callq  *%rax
  800e6b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e6f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e76:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e7b:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e7e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e81:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e85:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e89:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e8d:	45 89 c1             	mov    %r8d,%r9d
  800e90:	41 89 f8             	mov    %edi,%r8d
  800e93:	48 89 c7             	mov    %rax,%rdi
  800e96:	48 b8 ff 06 80 00 00 	movabs $0x8006ff,%rax
  800e9d:	00 00 00 
  800ea0:	ff d0                	callq  *%rax
			break;
  800ea2:	eb 3f                	jmp    800ee3 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ea4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ea8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eac:	48 89 d6             	mov    %rdx,%rsi
  800eaf:	89 df                	mov    %ebx,%edi
  800eb1:	ff d0                	callq  *%rax
			break;
  800eb3:	eb 2e                	jmp    800ee3 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800eb5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eb9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ebd:	48 89 d6             	mov    %rdx,%rsi
  800ec0:	bf 25 00 00 00       	mov    $0x25,%edi
  800ec5:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ec7:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ecc:	eb 05                	jmp    800ed3 <vprintfmt+0x4f9>
  800ece:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ed3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ed7:	48 83 e8 01          	sub    $0x1,%rax
  800edb:	0f b6 00             	movzbl (%rax),%eax
  800ede:	3c 25                	cmp    $0x25,%al
  800ee0:	75 ec                	jne    800ece <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800ee2:	90                   	nop
		}
	}
  800ee3:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ee4:	e9 43 fb ff ff       	jmpq   800a2c <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800ee9:	48 83 c4 60          	add    $0x60,%rsp
  800eed:	5b                   	pop    %rbx
  800eee:	41 5c                	pop    %r12
  800ef0:	5d                   	pop    %rbp
  800ef1:	c3                   	retq   

0000000000800ef2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ef2:	55                   	push   %rbp
  800ef3:	48 89 e5             	mov    %rsp,%rbp
  800ef6:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800efd:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f04:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f0b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f12:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f19:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f20:	84 c0                	test   %al,%al
  800f22:	74 20                	je     800f44 <printfmt+0x52>
  800f24:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f28:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f2c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f30:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f34:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f38:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f3c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f40:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f44:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f4b:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f52:	00 00 00 
  800f55:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f5c:	00 00 00 
  800f5f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f63:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f6a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f71:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f78:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f7f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800f86:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800f8d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800f94:	48 89 c7             	mov    %rax,%rdi
  800f97:	48 b8 da 09 80 00 00 	movabs $0x8009da,%rax
  800f9e:	00 00 00 
  800fa1:	ff d0                	callq  *%rax
	va_end(ap);
}
  800fa3:	c9                   	leaveq 
  800fa4:	c3                   	retq   

0000000000800fa5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fa5:	55                   	push   %rbp
  800fa6:	48 89 e5             	mov    %rsp,%rbp
  800fa9:	48 83 ec 10          	sub    $0x10,%rsp
  800fad:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fb0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800fb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fb8:	8b 40 10             	mov    0x10(%rax),%eax
  800fbb:	8d 50 01             	lea    0x1(%rax),%edx
  800fbe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fc2:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800fc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fc9:	48 8b 10             	mov    (%rax),%rdx
  800fcc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fd0:	48 8b 40 08          	mov    0x8(%rax),%rax
  800fd4:	48 39 c2             	cmp    %rax,%rdx
  800fd7:	73 17                	jae    800ff0 <sprintputch+0x4b>
		*b->buf++ = ch;
  800fd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fdd:	48 8b 00             	mov    (%rax),%rax
  800fe0:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800fe4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800fe8:	48 89 0a             	mov    %rcx,(%rdx)
  800feb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800fee:	88 10                	mov    %dl,(%rax)
}
  800ff0:	c9                   	leaveq 
  800ff1:	c3                   	retq   

0000000000800ff2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ff2:	55                   	push   %rbp
  800ff3:	48 89 e5             	mov    %rsp,%rbp
  800ff6:	48 83 ec 50          	sub    $0x50,%rsp
  800ffa:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800ffe:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801001:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801005:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801009:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80100d:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801011:	48 8b 0a             	mov    (%rdx),%rcx
  801014:	48 89 08             	mov    %rcx,(%rax)
  801017:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80101b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80101f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801023:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801027:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80102b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80102f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801032:	48 98                	cltq   
  801034:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801038:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80103c:	48 01 d0             	add    %rdx,%rax
  80103f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801043:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80104a:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80104f:	74 06                	je     801057 <vsnprintf+0x65>
  801051:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801055:	7f 07                	jg     80105e <vsnprintf+0x6c>
		return -E_INVAL;
  801057:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80105c:	eb 2f                	jmp    80108d <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80105e:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801062:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801066:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80106a:	48 89 c6             	mov    %rax,%rsi
  80106d:	48 bf a5 0f 80 00 00 	movabs $0x800fa5,%rdi
  801074:	00 00 00 
  801077:	48 b8 da 09 80 00 00 	movabs $0x8009da,%rax
  80107e:	00 00 00 
  801081:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801083:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801087:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80108a:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80108d:	c9                   	leaveq 
  80108e:	c3                   	retq   

000000000080108f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80108f:	55                   	push   %rbp
  801090:	48 89 e5             	mov    %rsp,%rbp
  801093:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80109a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8010a1:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8010a7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010ae:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010b5:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010bc:	84 c0                	test   %al,%al
  8010be:	74 20                	je     8010e0 <snprintf+0x51>
  8010c0:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010c4:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010c8:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010cc:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010d0:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010d4:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8010d8:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010dc:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8010e0:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8010e7:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8010ee:	00 00 00 
  8010f1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8010f8:	00 00 00 
  8010fb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8010ff:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801106:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80110d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801114:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80111b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801122:	48 8b 0a             	mov    (%rdx),%rcx
  801125:	48 89 08             	mov    %rcx,(%rax)
  801128:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80112c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801130:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801134:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801138:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80113f:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801146:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80114c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801153:	48 89 c7             	mov    %rax,%rdi
  801156:	48 b8 f2 0f 80 00 00 	movabs $0x800ff2,%rax
  80115d:	00 00 00 
  801160:	ff d0                	callq  *%rax
  801162:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801168:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80116e:	c9                   	leaveq 
  80116f:	c3                   	retq   

0000000000801170 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801170:	55                   	push   %rbp
  801171:	48 89 e5             	mov    %rsp,%rbp
  801174:	48 83 ec 18          	sub    $0x18,%rsp
  801178:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80117c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801183:	eb 09                	jmp    80118e <strlen+0x1e>
		n++;
  801185:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801189:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80118e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801192:	0f b6 00             	movzbl (%rax),%eax
  801195:	84 c0                	test   %al,%al
  801197:	75 ec                	jne    801185 <strlen+0x15>
		n++;
	return n;
  801199:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80119c:	c9                   	leaveq 
  80119d:	c3                   	retq   

000000000080119e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80119e:	55                   	push   %rbp
  80119f:	48 89 e5             	mov    %rsp,%rbp
  8011a2:	48 83 ec 20          	sub    $0x20,%rsp
  8011a6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011aa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011b5:	eb 0e                	jmp    8011c5 <strnlen+0x27>
		n++;
  8011b7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011bb:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011c0:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8011c5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8011ca:	74 0b                	je     8011d7 <strnlen+0x39>
  8011cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011d0:	0f b6 00             	movzbl (%rax),%eax
  8011d3:	84 c0                	test   %al,%al
  8011d5:	75 e0                	jne    8011b7 <strnlen+0x19>
		n++;
	return n;
  8011d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011da:	c9                   	leaveq 
  8011db:	c3                   	retq   

00000000008011dc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011dc:	55                   	push   %rbp
  8011dd:	48 89 e5             	mov    %rsp,%rbp
  8011e0:	48 83 ec 20          	sub    $0x20,%rsp
  8011e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8011ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8011f4:	90                   	nop
  8011f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011fd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801201:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801205:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801209:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80120d:	0f b6 12             	movzbl (%rdx),%edx
  801210:	88 10                	mov    %dl,(%rax)
  801212:	0f b6 00             	movzbl (%rax),%eax
  801215:	84 c0                	test   %al,%al
  801217:	75 dc                	jne    8011f5 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801219:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80121d:	c9                   	leaveq 
  80121e:	c3                   	retq   

000000000080121f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80121f:	55                   	push   %rbp
  801220:	48 89 e5             	mov    %rsp,%rbp
  801223:	48 83 ec 20          	sub    $0x20,%rsp
  801227:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80122b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80122f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801233:	48 89 c7             	mov    %rax,%rdi
  801236:	48 b8 70 11 80 00 00 	movabs $0x801170,%rax
  80123d:	00 00 00 
  801240:	ff d0                	callq  *%rax
  801242:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801245:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801248:	48 63 d0             	movslq %eax,%rdx
  80124b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80124f:	48 01 c2             	add    %rax,%rdx
  801252:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801256:	48 89 c6             	mov    %rax,%rsi
  801259:	48 89 d7             	mov    %rdx,%rdi
  80125c:	48 b8 dc 11 80 00 00 	movabs $0x8011dc,%rax
  801263:	00 00 00 
  801266:	ff d0                	callq  *%rax
	return dst;
  801268:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80126c:	c9                   	leaveq 
  80126d:	c3                   	retq   

000000000080126e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80126e:	55                   	push   %rbp
  80126f:	48 89 e5             	mov    %rsp,%rbp
  801272:	48 83 ec 28          	sub    $0x28,%rsp
  801276:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80127a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80127e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801282:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801286:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80128a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801291:	00 
  801292:	eb 2a                	jmp    8012be <strncpy+0x50>
		*dst++ = *src;
  801294:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801298:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80129c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012a0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012a4:	0f b6 12             	movzbl (%rdx),%edx
  8012a7:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012ad:	0f b6 00             	movzbl (%rax),%eax
  8012b0:	84 c0                	test   %al,%al
  8012b2:	74 05                	je     8012b9 <strncpy+0x4b>
			src++;
  8012b4:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012b9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8012c6:	72 cc                	jb     801294 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8012cc:	c9                   	leaveq 
  8012cd:	c3                   	retq   

00000000008012ce <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8012ce:	55                   	push   %rbp
  8012cf:	48 89 e5             	mov    %rsp,%rbp
  8012d2:	48 83 ec 28          	sub    $0x28,%rsp
  8012d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012da:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012de:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8012e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8012ea:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012ef:	74 3d                	je     80132e <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8012f1:	eb 1d                	jmp    801310 <strlcpy+0x42>
			*dst++ = *src++;
  8012f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012fb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012ff:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801303:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801307:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80130b:	0f b6 12             	movzbl (%rdx),%edx
  80130e:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801310:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801315:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80131a:	74 0b                	je     801327 <strlcpy+0x59>
  80131c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801320:	0f b6 00             	movzbl (%rax),%eax
  801323:	84 c0                	test   %al,%al
  801325:	75 cc                	jne    8012f3 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801327:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132b:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80132e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801332:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801336:	48 29 c2             	sub    %rax,%rdx
  801339:	48 89 d0             	mov    %rdx,%rax
}
  80133c:	c9                   	leaveq 
  80133d:	c3                   	retq   

000000000080133e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80133e:	55                   	push   %rbp
  80133f:	48 89 e5             	mov    %rsp,%rbp
  801342:	48 83 ec 10          	sub    $0x10,%rsp
  801346:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80134a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80134e:	eb 0a                	jmp    80135a <strcmp+0x1c>
		p++, q++;
  801350:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801355:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80135a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80135e:	0f b6 00             	movzbl (%rax),%eax
  801361:	84 c0                	test   %al,%al
  801363:	74 12                	je     801377 <strcmp+0x39>
  801365:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801369:	0f b6 10             	movzbl (%rax),%edx
  80136c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801370:	0f b6 00             	movzbl (%rax),%eax
  801373:	38 c2                	cmp    %al,%dl
  801375:	74 d9                	je     801350 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801377:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137b:	0f b6 00             	movzbl (%rax),%eax
  80137e:	0f b6 d0             	movzbl %al,%edx
  801381:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801385:	0f b6 00             	movzbl (%rax),%eax
  801388:	0f b6 c0             	movzbl %al,%eax
  80138b:	29 c2                	sub    %eax,%edx
  80138d:	89 d0                	mov    %edx,%eax
}
  80138f:	c9                   	leaveq 
  801390:	c3                   	retq   

0000000000801391 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801391:	55                   	push   %rbp
  801392:	48 89 e5             	mov    %rsp,%rbp
  801395:	48 83 ec 18          	sub    $0x18,%rsp
  801399:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80139d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013a1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8013a5:	eb 0f                	jmp    8013b6 <strncmp+0x25>
		n--, p++, q++;
  8013a7:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8013ac:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013b1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8013b6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013bb:	74 1d                	je     8013da <strncmp+0x49>
  8013bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c1:	0f b6 00             	movzbl (%rax),%eax
  8013c4:	84 c0                	test   %al,%al
  8013c6:	74 12                	je     8013da <strncmp+0x49>
  8013c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013cc:	0f b6 10             	movzbl (%rax),%edx
  8013cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013d3:	0f b6 00             	movzbl (%rax),%eax
  8013d6:	38 c2                	cmp    %al,%dl
  8013d8:	74 cd                	je     8013a7 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8013da:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013df:	75 07                	jne    8013e8 <strncmp+0x57>
		return 0;
  8013e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e6:	eb 18                	jmp    801400 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ec:	0f b6 00             	movzbl (%rax),%eax
  8013ef:	0f b6 d0             	movzbl %al,%edx
  8013f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013f6:	0f b6 00             	movzbl (%rax),%eax
  8013f9:	0f b6 c0             	movzbl %al,%eax
  8013fc:	29 c2                	sub    %eax,%edx
  8013fe:	89 d0                	mov    %edx,%eax
}
  801400:	c9                   	leaveq 
  801401:	c3                   	retq   

0000000000801402 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801402:	55                   	push   %rbp
  801403:	48 89 e5             	mov    %rsp,%rbp
  801406:	48 83 ec 0c          	sub    $0xc,%rsp
  80140a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80140e:	89 f0                	mov    %esi,%eax
  801410:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801413:	eb 17                	jmp    80142c <strchr+0x2a>
		if (*s == c)
  801415:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801419:	0f b6 00             	movzbl (%rax),%eax
  80141c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80141f:	75 06                	jne    801427 <strchr+0x25>
			return (char *) s;
  801421:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801425:	eb 15                	jmp    80143c <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801427:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80142c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801430:	0f b6 00             	movzbl (%rax),%eax
  801433:	84 c0                	test   %al,%al
  801435:	75 de                	jne    801415 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801437:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80143c:	c9                   	leaveq 
  80143d:	c3                   	retq   

000000000080143e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80143e:	55                   	push   %rbp
  80143f:	48 89 e5             	mov    %rsp,%rbp
  801442:	48 83 ec 0c          	sub    $0xc,%rsp
  801446:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80144a:	89 f0                	mov    %esi,%eax
  80144c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80144f:	eb 13                	jmp    801464 <strfind+0x26>
		if (*s == c)
  801451:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801455:	0f b6 00             	movzbl (%rax),%eax
  801458:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80145b:	75 02                	jne    80145f <strfind+0x21>
			break;
  80145d:	eb 10                	jmp    80146f <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80145f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801464:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801468:	0f b6 00             	movzbl (%rax),%eax
  80146b:	84 c0                	test   %al,%al
  80146d:	75 e2                	jne    801451 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80146f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801473:	c9                   	leaveq 
  801474:	c3                   	retq   

0000000000801475 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801475:	55                   	push   %rbp
  801476:	48 89 e5             	mov    %rsp,%rbp
  801479:	48 83 ec 18          	sub    $0x18,%rsp
  80147d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801481:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801484:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801488:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80148d:	75 06                	jne    801495 <memset+0x20>
		return v;
  80148f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801493:	eb 69                	jmp    8014fe <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801495:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801499:	83 e0 03             	and    $0x3,%eax
  80149c:	48 85 c0             	test   %rax,%rax
  80149f:	75 48                	jne    8014e9 <memset+0x74>
  8014a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a5:	83 e0 03             	and    $0x3,%eax
  8014a8:	48 85 c0             	test   %rax,%rax
  8014ab:	75 3c                	jne    8014e9 <memset+0x74>
		c &= 0xFF;
  8014ad:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014b4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014b7:	c1 e0 18             	shl    $0x18,%eax
  8014ba:	89 c2                	mov    %eax,%edx
  8014bc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014bf:	c1 e0 10             	shl    $0x10,%eax
  8014c2:	09 c2                	or     %eax,%edx
  8014c4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014c7:	c1 e0 08             	shl    $0x8,%eax
  8014ca:	09 d0                	or     %edx,%eax
  8014cc:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8014cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d3:	48 c1 e8 02          	shr    $0x2,%rax
  8014d7:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8014da:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014de:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014e1:	48 89 d7             	mov    %rdx,%rdi
  8014e4:	fc                   	cld    
  8014e5:	f3 ab                	rep stos %eax,%es:(%rdi)
  8014e7:	eb 11                	jmp    8014fa <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8014e9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014ed:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014f0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8014f4:	48 89 d7             	mov    %rdx,%rdi
  8014f7:	fc                   	cld    
  8014f8:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8014fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014fe:	c9                   	leaveq 
  8014ff:	c3                   	retq   

0000000000801500 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801500:	55                   	push   %rbp
  801501:	48 89 e5             	mov    %rsp,%rbp
  801504:	48 83 ec 28          	sub    $0x28,%rsp
  801508:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80150c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801510:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801514:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801518:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80151c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801520:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801524:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801528:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80152c:	0f 83 88 00 00 00    	jae    8015ba <memmove+0xba>
  801532:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801536:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80153a:	48 01 d0             	add    %rdx,%rax
  80153d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801541:	76 77                	jbe    8015ba <memmove+0xba>
		s += n;
  801543:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801547:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80154b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154f:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801553:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801557:	83 e0 03             	and    $0x3,%eax
  80155a:	48 85 c0             	test   %rax,%rax
  80155d:	75 3b                	jne    80159a <memmove+0x9a>
  80155f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801563:	83 e0 03             	and    $0x3,%eax
  801566:	48 85 c0             	test   %rax,%rax
  801569:	75 2f                	jne    80159a <memmove+0x9a>
  80156b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156f:	83 e0 03             	and    $0x3,%eax
  801572:	48 85 c0             	test   %rax,%rax
  801575:	75 23                	jne    80159a <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801577:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80157b:	48 83 e8 04          	sub    $0x4,%rax
  80157f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801583:	48 83 ea 04          	sub    $0x4,%rdx
  801587:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80158b:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80158f:	48 89 c7             	mov    %rax,%rdi
  801592:	48 89 d6             	mov    %rdx,%rsi
  801595:	fd                   	std    
  801596:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801598:	eb 1d                	jmp    8015b7 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80159a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80159e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a6:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8015aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ae:	48 89 d7             	mov    %rdx,%rdi
  8015b1:	48 89 c1             	mov    %rax,%rcx
  8015b4:	fd                   	std    
  8015b5:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015b7:	fc                   	cld    
  8015b8:	eb 57                	jmp    801611 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015be:	83 e0 03             	and    $0x3,%eax
  8015c1:	48 85 c0             	test   %rax,%rax
  8015c4:	75 36                	jne    8015fc <memmove+0xfc>
  8015c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015ca:	83 e0 03             	and    $0x3,%eax
  8015cd:	48 85 c0             	test   %rax,%rax
  8015d0:	75 2a                	jne    8015fc <memmove+0xfc>
  8015d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d6:	83 e0 03             	and    $0x3,%eax
  8015d9:	48 85 c0             	test   %rax,%rax
  8015dc:	75 1e                	jne    8015fc <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8015de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e2:	48 c1 e8 02          	shr    $0x2,%rax
  8015e6:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8015e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015ed:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015f1:	48 89 c7             	mov    %rax,%rdi
  8015f4:	48 89 d6             	mov    %rdx,%rsi
  8015f7:	fc                   	cld    
  8015f8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015fa:	eb 15                	jmp    801611 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8015fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801600:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801604:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801608:	48 89 c7             	mov    %rax,%rdi
  80160b:	48 89 d6             	mov    %rdx,%rsi
  80160e:	fc                   	cld    
  80160f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801611:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801615:	c9                   	leaveq 
  801616:	c3                   	retq   

0000000000801617 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801617:	55                   	push   %rbp
  801618:	48 89 e5             	mov    %rsp,%rbp
  80161b:	48 83 ec 18          	sub    $0x18,%rsp
  80161f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801623:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801627:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80162b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80162f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801633:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801637:	48 89 ce             	mov    %rcx,%rsi
  80163a:	48 89 c7             	mov    %rax,%rdi
  80163d:	48 b8 00 15 80 00 00 	movabs $0x801500,%rax
  801644:	00 00 00 
  801647:	ff d0                	callq  *%rax
}
  801649:	c9                   	leaveq 
  80164a:	c3                   	retq   

000000000080164b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80164b:	55                   	push   %rbp
  80164c:	48 89 e5             	mov    %rsp,%rbp
  80164f:	48 83 ec 28          	sub    $0x28,%rsp
  801653:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801657:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80165b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80165f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801663:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801667:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80166b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80166f:	eb 36                	jmp    8016a7 <memcmp+0x5c>
		if (*s1 != *s2)
  801671:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801675:	0f b6 10             	movzbl (%rax),%edx
  801678:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80167c:	0f b6 00             	movzbl (%rax),%eax
  80167f:	38 c2                	cmp    %al,%dl
  801681:	74 1a                	je     80169d <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801683:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801687:	0f b6 00             	movzbl (%rax),%eax
  80168a:	0f b6 d0             	movzbl %al,%edx
  80168d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801691:	0f b6 00             	movzbl (%rax),%eax
  801694:	0f b6 c0             	movzbl %al,%eax
  801697:	29 c2                	sub    %eax,%edx
  801699:	89 d0                	mov    %edx,%eax
  80169b:	eb 20                	jmp    8016bd <memcmp+0x72>
		s1++, s2++;
  80169d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016a2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8016a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ab:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016af:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8016b3:	48 85 c0             	test   %rax,%rax
  8016b6:	75 b9                	jne    801671 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016bd:	c9                   	leaveq 
  8016be:	c3                   	retq   

00000000008016bf <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016bf:	55                   	push   %rbp
  8016c0:	48 89 e5             	mov    %rsp,%rbp
  8016c3:	48 83 ec 28          	sub    $0x28,%rsp
  8016c7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016cb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8016ce:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8016d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016da:	48 01 d0             	add    %rdx,%rax
  8016dd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8016e1:	eb 15                	jmp    8016f8 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016e7:	0f b6 10             	movzbl (%rax),%edx
  8016ea:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8016ed:	38 c2                	cmp    %al,%dl
  8016ef:	75 02                	jne    8016f3 <memfind+0x34>
			break;
  8016f1:	eb 0f                	jmp    801702 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016f3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8016f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016fc:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801700:	72 e1                	jb     8016e3 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801702:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801706:	c9                   	leaveq 
  801707:	c3                   	retq   

0000000000801708 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801708:	55                   	push   %rbp
  801709:	48 89 e5             	mov    %rsp,%rbp
  80170c:	48 83 ec 34          	sub    $0x34,%rsp
  801710:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801714:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801718:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80171b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801722:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801729:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80172a:	eb 05                	jmp    801731 <strtol+0x29>
		s++;
  80172c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801731:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801735:	0f b6 00             	movzbl (%rax),%eax
  801738:	3c 20                	cmp    $0x20,%al
  80173a:	74 f0                	je     80172c <strtol+0x24>
  80173c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801740:	0f b6 00             	movzbl (%rax),%eax
  801743:	3c 09                	cmp    $0x9,%al
  801745:	74 e5                	je     80172c <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801747:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174b:	0f b6 00             	movzbl (%rax),%eax
  80174e:	3c 2b                	cmp    $0x2b,%al
  801750:	75 07                	jne    801759 <strtol+0x51>
		s++;
  801752:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801757:	eb 17                	jmp    801770 <strtol+0x68>
	else if (*s == '-')
  801759:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175d:	0f b6 00             	movzbl (%rax),%eax
  801760:	3c 2d                	cmp    $0x2d,%al
  801762:	75 0c                	jne    801770 <strtol+0x68>
		s++, neg = 1;
  801764:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801769:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801770:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801774:	74 06                	je     80177c <strtol+0x74>
  801776:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80177a:	75 28                	jne    8017a4 <strtol+0x9c>
  80177c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801780:	0f b6 00             	movzbl (%rax),%eax
  801783:	3c 30                	cmp    $0x30,%al
  801785:	75 1d                	jne    8017a4 <strtol+0x9c>
  801787:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178b:	48 83 c0 01          	add    $0x1,%rax
  80178f:	0f b6 00             	movzbl (%rax),%eax
  801792:	3c 78                	cmp    $0x78,%al
  801794:	75 0e                	jne    8017a4 <strtol+0x9c>
		s += 2, base = 16;
  801796:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80179b:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8017a2:	eb 2c                	jmp    8017d0 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8017a4:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017a8:	75 19                	jne    8017c3 <strtol+0xbb>
  8017aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ae:	0f b6 00             	movzbl (%rax),%eax
  8017b1:	3c 30                	cmp    $0x30,%al
  8017b3:	75 0e                	jne    8017c3 <strtol+0xbb>
		s++, base = 8;
  8017b5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017ba:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8017c1:	eb 0d                	jmp    8017d0 <strtol+0xc8>
	else if (base == 0)
  8017c3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017c7:	75 07                	jne    8017d0 <strtol+0xc8>
		base = 10;
  8017c9:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d4:	0f b6 00             	movzbl (%rax),%eax
  8017d7:	3c 2f                	cmp    $0x2f,%al
  8017d9:	7e 1d                	jle    8017f8 <strtol+0xf0>
  8017db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017df:	0f b6 00             	movzbl (%rax),%eax
  8017e2:	3c 39                	cmp    $0x39,%al
  8017e4:	7f 12                	jg     8017f8 <strtol+0xf0>
			dig = *s - '0';
  8017e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ea:	0f b6 00             	movzbl (%rax),%eax
  8017ed:	0f be c0             	movsbl %al,%eax
  8017f0:	83 e8 30             	sub    $0x30,%eax
  8017f3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017f6:	eb 4e                	jmp    801846 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8017f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017fc:	0f b6 00             	movzbl (%rax),%eax
  8017ff:	3c 60                	cmp    $0x60,%al
  801801:	7e 1d                	jle    801820 <strtol+0x118>
  801803:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801807:	0f b6 00             	movzbl (%rax),%eax
  80180a:	3c 7a                	cmp    $0x7a,%al
  80180c:	7f 12                	jg     801820 <strtol+0x118>
			dig = *s - 'a' + 10;
  80180e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801812:	0f b6 00             	movzbl (%rax),%eax
  801815:	0f be c0             	movsbl %al,%eax
  801818:	83 e8 57             	sub    $0x57,%eax
  80181b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80181e:	eb 26                	jmp    801846 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801820:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801824:	0f b6 00             	movzbl (%rax),%eax
  801827:	3c 40                	cmp    $0x40,%al
  801829:	7e 48                	jle    801873 <strtol+0x16b>
  80182b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182f:	0f b6 00             	movzbl (%rax),%eax
  801832:	3c 5a                	cmp    $0x5a,%al
  801834:	7f 3d                	jg     801873 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801836:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80183a:	0f b6 00             	movzbl (%rax),%eax
  80183d:	0f be c0             	movsbl %al,%eax
  801840:	83 e8 37             	sub    $0x37,%eax
  801843:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801846:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801849:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80184c:	7c 02                	jl     801850 <strtol+0x148>
			break;
  80184e:	eb 23                	jmp    801873 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801850:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801855:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801858:	48 98                	cltq   
  80185a:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80185f:	48 89 c2             	mov    %rax,%rdx
  801862:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801865:	48 98                	cltq   
  801867:	48 01 d0             	add    %rdx,%rax
  80186a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80186e:	e9 5d ff ff ff       	jmpq   8017d0 <strtol+0xc8>

	if (endptr)
  801873:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801878:	74 0b                	je     801885 <strtol+0x17d>
		*endptr = (char *) s;
  80187a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80187e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801882:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801885:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801889:	74 09                	je     801894 <strtol+0x18c>
  80188b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80188f:	48 f7 d8             	neg    %rax
  801892:	eb 04                	jmp    801898 <strtol+0x190>
  801894:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801898:	c9                   	leaveq 
  801899:	c3                   	retq   

000000000080189a <strstr>:

char * strstr(const char *in, const char *str)
{
  80189a:	55                   	push   %rbp
  80189b:	48 89 e5             	mov    %rsp,%rbp
  80189e:	48 83 ec 30          	sub    $0x30,%rsp
  8018a2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018a6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8018aa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018ae:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018b2:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018b6:	0f b6 00             	movzbl (%rax),%eax
  8018b9:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8018bc:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8018c0:	75 06                	jne    8018c8 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8018c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c6:	eb 6b                	jmp    801933 <strstr+0x99>

	len = strlen(str);
  8018c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018cc:	48 89 c7             	mov    %rax,%rdi
  8018cf:	48 b8 70 11 80 00 00 	movabs $0x801170,%rax
  8018d6:	00 00 00 
  8018d9:	ff d0                	callq  *%rax
  8018db:	48 98                	cltq   
  8018dd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8018e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018e9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8018ed:	0f b6 00             	movzbl (%rax),%eax
  8018f0:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8018f3:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8018f7:	75 07                	jne    801900 <strstr+0x66>
				return (char *) 0;
  8018f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8018fe:	eb 33                	jmp    801933 <strstr+0x99>
		} while (sc != c);
  801900:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801904:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801907:	75 d8                	jne    8018e1 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801909:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80190d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801911:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801915:	48 89 ce             	mov    %rcx,%rsi
  801918:	48 89 c7             	mov    %rax,%rdi
  80191b:	48 b8 91 13 80 00 00 	movabs $0x801391,%rax
  801922:	00 00 00 
  801925:	ff d0                	callq  *%rax
  801927:	85 c0                	test   %eax,%eax
  801929:	75 b6                	jne    8018e1 <strstr+0x47>

	return (char *) (in - 1);
  80192b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80192f:	48 83 e8 01          	sub    $0x1,%rax
}
  801933:	c9                   	leaveq 
  801934:	c3                   	retq   

0000000000801935 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801935:	55                   	push   %rbp
  801936:	48 89 e5             	mov    %rsp,%rbp
  801939:	53                   	push   %rbx
  80193a:	48 83 ec 48          	sub    $0x48,%rsp
  80193e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801941:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801944:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801948:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80194c:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801950:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  801954:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801957:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80195b:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80195f:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801963:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801967:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80196b:	4c 89 c3             	mov    %r8,%rbx
  80196e:	cd 30                	int    $0x30
  801970:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  801974:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801978:	74 3e                	je     8019b8 <syscall+0x83>
  80197a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80197f:	7e 37                	jle    8019b8 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801981:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801985:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801988:	49 89 d0             	mov    %rdx,%r8
  80198b:	89 c1                	mov    %eax,%ecx
  80198d:	48 ba 08 45 80 00 00 	movabs $0x804508,%rdx
  801994:	00 00 00 
  801997:	be 4a 00 00 00       	mov    $0x4a,%esi
  80199c:	48 bf 25 45 80 00 00 	movabs $0x804525,%rdi
  8019a3:	00 00 00 
  8019a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ab:	49 b9 ee 03 80 00 00 	movabs $0x8003ee,%r9
  8019b2:	00 00 00 
  8019b5:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  8019b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019bc:	48 83 c4 48          	add    $0x48,%rsp
  8019c0:	5b                   	pop    %rbx
  8019c1:	5d                   	pop    %rbp
  8019c2:	c3                   	retq   

00000000008019c3 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8019c3:	55                   	push   %rbp
  8019c4:	48 89 e5             	mov    %rsp,%rbp
  8019c7:	48 83 ec 20          	sub    $0x20,%rsp
  8019cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019cf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8019d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019d7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019db:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019e2:	00 
  8019e3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019e9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019ef:	48 89 d1             	mov    %rdx,%rcx
  8019f2:	48 89 c2             	mov    %rax,%rdx
  8019f5:	be 00 00 00 00       	mov    $0x0,%esi
  8019fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8019ff:	48 b8 35 19 80 00 00 	movabs $0x801935,%rax
  801a06:	00 00 00 
  801a09:	ff d0                	callq  *%rax
}
  801a0b:	c9                   	leaveq 
  801a0c:	c3                   	retq   

0000000000801a0d <sys_cgetc>:

int
sys_cgetc(void)
{
  801a0d:	55                   	push   %rbp
  801a0e:	48 89 e5             	mov    %rsp,%rbp
  801a11:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a15:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a1c:	00 
  801a1d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a23:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a29:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a2e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a33:	be 00 00 00 00       	mov    $0x0,%esi
  801a38:	bf 01 00 00 00       	mov    $0x1,%edi
  801a3d:	48 b8 35 19 80 00 00 	movabs $0x801935,%rax
  801a44:	00 00 00 
  801a47:	ff d0                	callq  *%rax
}
  801a49:	c9                   	leaveq 
  801a4a:	c3                   	retq   

0000000000801a4b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a4b:	55                   	push   %rbp
  801a4c:	48 89 e5             	mov    %rsp,%rbp
  801a4f:	48 83 ec 10          	sub    $0x10,%rsp
  801a53:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a59:	48 98                	cltq   
  801a5b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a62:	00 
  801a63:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a69:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a6f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a74:	48 89 c2             	mov    %rax,%rdx
  801a77:	be 01 00 00 00       	mov    $0x1,%esi
  801a7c:	bf 03 00 00 00       	mov    $0x3,%edi
  801a81:	48 b8 35 19 80 00 00 	movabs $0x801935,%rax
  801a88:	00 00 00 
  801a8b:	ff d0                	callq  *%rax
}
  801a8d:	c9                   	leaveq 
  801a8e:	c3                   	retq   

0000000000801a8f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801a8f:	55                   	push   %rbp
  801a90:	48 89 e5             	mov    %rsp,%rbp
  801a93:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801a97:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a9e:	00 
  801a9f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aab:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ab0:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab5:	be 00 00 00 00       	mov    $0x0,%esi
  801aba:	bf 02 00 00 00       	mov    $0x2,%edi
  801abf:	48 b8 35 19 80 00 00 	movabs $0x801935,%rax
  801ac6:	00 00 00 
  801ac9:	ff d0                	callq  *%rax
}
  801acb:	c9                   	leaveq 
  801acc:	c3                   	retq   

0000000000801acd <sys_yield>:

void
sys_yield(void)
{
  801acd:	55                   	push   %rbp
  801ace:	48 89 e5             	mov    %rsp,%rbp
  801ad1:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801ad5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801adc:	00 
  801add:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ae3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ae9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aee:	ba 00 00 00 00       	mov    $0x0,%edx
  801af3:	be 00 00 00 00       	mov    $0x0,%esi
  801af8:	bf 0b 00 00 00       	mov    $0xb,%edi
  801afd:	48 b8 35 19 80 00 00 	movabs $0x801935,%rax
  801b04:	00 00 00 
  801b07:	ff d0                	callq  *%rax
}
  801b09:	c9                   	leaveq 
  801b0a:	c3                   	retq   

0000000000801b0b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b0b:	55                   	push   %rbp
  801b0c:	48 89 e5             	mov    %rsp,%rbp
  801b0f:	48 83 ec 20          	sub    $0x20,%rsp
  801b13:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b16:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b1a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b1d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b20:	48 63 c8             	movslq %eax,%rcx
  801b23:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b27:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b2a:	48 98                	cltq   
  801b2c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b33:	00 
  801b34:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b3a:	49 89 c8             	mov    %rcx,%r8
  801b3d:	48 89 d1             	mov    %rdx,%rcx
  801b40:	48 89 c2             	mov    %rax,%rdx
  801b43:	be 01 00 00 00       	mov    $0x1,%esi
  801b48:	bf 04 00 00 00       	mov    $0x4,%edi
  801b4d:	48 b8 35 19 80 00 00 	movabs $0x801935,%rax
  801b54:	00 00 00 
  801b57:	ff d0                	callq  *%rax
}
  801b59:	c9                   	leaveq 
  801b5a:	c3                   	retq   

0000000000801b5b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b5b:	55                   	push   %rbp
  801b5c:	48 89 e5             	mov    %rsp,%rbp
  801b5f:	48 83 ec 30          	sub    $0x30,%rsp
  801b63:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b66:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b6a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b6d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b71:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b75:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b78:	48 63 c8             	movslq %eax,%rcx
  801b7b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b7f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b82:	48 63 f0             	movslq %eax,%rsi
  801b85:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b8c:	48 98                	cltq   
  801b8e:	48 89 0c 24          	mov    %rcx,(%rsp)
  801b92:	49 89 f9             	mov    %rdi,%r9
  801b95:	49 89 f0             	mov    %rsi,%r8
  801b98:	48 89 d1             	mov    %rdx,%rcx
  801b9b:	48 89 c2             	mov    %rax,%rdx
  801b9e:	be 01 00 00 00       	mov    $0x1,%esi
  801ba3:	bf 05 00 00 00       	mov    $0x5,%edi
  801ba8:	48 b8 35 19 80 00 00 	movabs $0x801935,%rax
  801baf:	00 00 00 
  801bb2:	ff d0                	callq  *%rax
}
  801bb4:	c9                   	leaveq 
  801bb5:	c3                   	retq   

0000000000801bb6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801bb6:	55                   	push   %rbp
  801bb7:	48 89 e5             	mov    %rsp,%rbp
  801bba:	48 83 ec 20          	sub    $0x20,%rsp
  801bbe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bc1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801bc5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bcc:	48 98                	cltq   
  801bce:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bd5:	00 
  801bd6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bdc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801be2:	48 89 d1             	mov    %rdx,%rcx
  801be5:	48 89 c2             	mov    %rax,%rdx
  801be8:	be 01 00 00 00       	mov    $0x1,%esi
  801bed:	bf 06 00 00 00       	mov    $0x6,%edi
  801bf2:	48 b8 35 19 80 00 00 	movabs $0x801935,%rax
  801bf9:	00 00 00 
  801bfc:	ff d0                	callq  *%rax
}
  801bfe:	c9                   	leaveq 
  801bff:	c3                   	retq   

0000000000801c00 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c00:	55                   	push   %rbp
  801c01:	48 89 e5             	mov    %rsp,%rbp
  801c04:	48 83 ec 10          	sub    $0x10,%rsp
  801c08:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c0b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c0e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c11:	48 63 d0             	movslq %eax,%rdx
  801c14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c17:	48 98                	cltq   
  801c19:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c20:	00 
  801c21:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c27:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c2d:	48 89 d1             	mov    %rdx,%rcx
  801c30:	48 89 c2             	mov    %rax,%rdx
  801c33:	be 01 00 00 00       	mov    $0x1,%esi
  801c38:	bf 08 00 00 00       	mov    $0x8,%edi
  801c3d:	48 b8 35 19 80 00 00 	movabs $0x801935,%rax
  801c44:	00 00 00 
  801c47:	ff d0                	callq  *%rax
}
  801c49:	c9                   	leaveq 
  801c4a:	c3                   	retq   

0000000000801c4b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c4b:	55                   	push   %rbp
  801c4c:	48 89 e5             	mov    %rsp,%rbp
  801c4f:	48 83 ec 20          	sub    $0x20,%rsp
  801c53:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c56:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c5a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c61:	48 98                	cltq   
  801c63:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c6a:	00 
  801c6b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c71:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c77:	48 89 d1             	mov    %rdx,%rcx
  801c7a:	48 89 c2             	mov    %rax,%rdx
  801c7d:	be 01 00 00 00       	mov    $0x1,%esi
  801c82:	bf 09 00 00 00       	mov    $0x9,%edi
  801c87:	48 b8 35 19 80 00 00 	movabs $0x801935,%rax
  801c8e:	00 00 00 
  801c91:	ff d0                	callq  *%rax
}
  801c93:	c9                   	leaveq 
  801c94:	c3                   	retq   

0000000000801c95 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801c95:	55                   	push   %rbp
  801c96:	48 89 e5             	mov    %rsp,%rbp
  801c99:	48 83 ec 20          	sub    $0x20,%rsp
  801c9d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ca0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801ca4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ca8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cab:	48 98                	cltq   
  801cad:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cb4:	00 
  801cb5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cbb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cc1:	48 89 d1             	mov    %rdx,%rcx
  801cc4:	48 89 c2             	mov    %rax,%rdx
  801cc7:	be 01 00 00 00       	mov    $0x1,%esi
  801ccc:	bf 0a 00 00 00       	mov    $0xa,%edi
  801cd1:	48 b8 35 19 80 00 00 	movabs $0x801935,%rax
  801cd8:	00 00 00 
  801cdb:	ff d0                	callq  *%rax
}
  801cdd:	c9                   	leaveq 
  801cde:	c3                   	retq   

0000000000801cdf <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801cdf:	55                   	push   %rbp
  801ce0:	48 89 e5             	mov    %rsp,%rbp
  801ce3:	48 83 ec 20          	sub    $0x20,%rsp
  801ce7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cee:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801cf2:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801cf5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cf8:	48 63 f0             	movslq %eax,%rsi
  801cfb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801cff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d02:	48 98                	cltq   
  801d04:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d08:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d0f:	00 
  801d10:	49 89 f1             	mov    %rsi,%r9
  801d13:	49 89 c8             	mov    %rcx,%r8
  801d16:	48 89 d1             	mov    %rdx,%rcx
  801d19:	48 89 c2             	mov    %rax,%rdx
  801d1c:	be 00 00 00 00       	mov    $0x0,%esi
  801d21:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d26:	48 b8 35 19 80 00 00 	movabs $0x801935,%rax
  801d2d:	00 00 00 
  801d30:	ff d0                	callq  *%rax
}
  801d32:	c9                   	leaveq 
  801d33:	c3                   	retq   

0000000000801d34 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d34:	55                   	push   %rbp
  801d35:	48 89 e5             	mov    %rsp,%rbp
  801d38:	48 83 ec 10          	sub    $0x10,%rsp
  801d3c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d44:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d4b:	00 
  801d4c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d52:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d58:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d5d:	48 89 c2             	mov    %rax,%rdx
  801d60:	be 01 00 00 00       	mov    $0x1,%esi
  801d65:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d6a:	48 b8 35 19 80 00 00 	movabs $0x801935,%rax
  801d71:	00 00 00 
  801d74:	ff d0                	callq  *%rax
}
  801d76:	c9                   	leaveq 
  801d77:	c3                   	retq   

0000000000801d78 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801d78:	55                   	push   %rbp
  801d79:	48 89 e5             	mov    %rsp,%rbp
  801d7c:	53                   	push   %rbx
  801d7d:	48 83 ec 48          	sub    $0x48,%rsp
  801d81:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801d85:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801d89:	48 8b 00             	mov    (%rax),%rax
  801d8c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	uint32_t err = utf->utf_err;
  801d90:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801d94:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d98:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	pte_t pte = uvpt[VPN(addr)];
  801d9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d9f:	48 c1 e8 0c          	shr    $0xc,%rax
  801da3:	48 89 c2             	mov    %rax,%rdx
  801da6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801dad:	01 00 00 
  801db0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801db4:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	envid_t pid = sys_getenvid();
  801db8:	48 b8 8f 1a 80 00 00 	movabs $0x801a8f,%rax
  801dbf:	00 00 00 
  801dc2:	ff d0                	callq  *%rax
  801dc4:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	void* va = ROUNDDOWN(addr, PGSIZE);
  801dc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dcb:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  801dcf:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801dd3:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801dd9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	if((err & FEC_WR) && (pte & PTE_COW)){
  801ddd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801de0:	83 e0 02             	and    $0x2,%eax
  801de3:	85 c0                	test   %eax,%eax
  801de5:	0f 84 8d 00 00 00    	je     801e78 <pgfault+0x100>
  801deb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801def:	25 00 08 00 00       	and    $0x800,%eax
  801df4:	48 85 c0             	test   %rax,%rax
  801df7:	74 7f                	je     801e78 <pgfault+0x100>
		if(!sys_page_alloc(pid, (void*)PFTEMP, PTE_P | PTE_W | PTE_U)){
  801df9:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801dfc:	ba 07 00 00 00       	mov    $0x7,%edx
  801e01:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e06:	89 c7                	mov    %eax,%edi
  801e08:	48 b8 0b 1b 80 00 00 	movabs $0x801b0b,%rax
  801e0f:	00 00 00 
  801e12:	ff d0                	callq  *%rax
  801e14:	85 c0                	test   %eax,%eax
  801e16:	75 60                	jne    801e78 <pgfault+0x100>
			memmove(PFTEMP, va, PGSIZE);
  801e18:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801e1c:	ba 00 10 00 00       	mov    $0x1000,%edx
  801e21:	48 89 c6             	mov    %rax,%rsi
  801e24:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801e29:	48 b8 00 15 80 00 00 	movabs $0x801500,%rax
  801e30:	00 00 00 
  801e33:	ff d0                	callq  *%rax
			if(!(sys_page_map(pid, (void*)PFTEMP, pid, va, PTE_P | PTE_W | PTE_U) | 
  801e35:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  801e39:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  801e3c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801e3f:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801e45:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e4a:	89 c7                	mov    %eax,%edi
  801e4c:	48 b8 5b 1b 80 00 00 	movabs $0x801b5b,%rax
  801e53:	00 00 00 
  801e56:	ff d0                	callq  *%rax
  801e58:	89 c3                	mov    %eax,%ebx
					 sys_page_unmap(pid, (void*) PFTEMP)))
  801e5a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801e5d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e62:	89 c7                	mov    %eax,%edi
  801e64:	48 b8 b6 1b 80 00 00 	movabs $0x801bb6,%rax
  801e6b:	00 00 00 
  801e6e:	ff d0                	callq  *%rax
	envid_t pid = sys_getenvid();
	void* va = ROUNDDOWN(addr, PGSIZE);
	if((err & FEC_WR) && (pte & PTE_COW)){
		if(!sys_page_alloc(pid, (void*)PFTEMP, PTE_P | PTE_W | PTE_U)){
			memmove(PFTEMP, va, PGSIZE);
			if(!(sys_page_map(pid, (void*)PFTEMP, pid, va, PTE_P | PTE_W | PTE_U) | 
  801e70:	09 d8                	or     %ebx,%eax
  801e72:	85 c0                	test   %eax,%eax
  801e74:	75 02                	jne    801e78 <pgfault+0x100>
					 sys_page_unmap(pid, (void*) PFTEMP)))
					return;
  801e76:	eb 2a                	jmp    801ea2 <pgfault+0x12a>
		}
	}
	panic("Page fault handler failure\n");
  801e78:	48 ba 33 45 80 00 00 	movabs $0x804533,%rdx
  801e7f:	00 00 00 
  801e82:	be 26 00 00 00       	mov    $0x26,%esi
  801e87:	48 bf 4f 45 80 00 00 	movabs $0x80454f,%rdi
  801e8e:	00 00 00 
  801e91:	b8 00 00 00 00       	mov    $0x0,%eax
  801e96:	48 b9 ee 03 80 00 00 	movabs $0x8003ee,%rcx
  801e9d:	00 00 00 
  801ea0:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	//panic("pgfault not implemented");
}
  801ea2:	48 83 c4 48          	add    $0x48,%rsp
  801ea6:	5b                   	pop    %rbx
  801ea7:	5d                   	pop    %rbp
  801ea8:	c3                   	retq   

0000000000801ea9 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801ea9:	55                   	push   %rbp
  801eaa:	48 89 e5             	mov    %rsp,%rbp
  801ead:	53                   	push   %rbx
  801eae:	48 83 ec 38          	sub    $0x38,%rsp
  801eb2:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801eb5:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	//struct Env *env;
	pte_t pte = uvpt[pn];
  801eb8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ebf:	01 00 00 
  801ec2:	8b 55 c8             	mov    -0x38(%rbp),%edx
  801ec5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ec9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int perm = pte & PTE_SYSCALL;
  801ecd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ed1:	25 07 0e 00 00       	and    $0xe07,%eax
  801ed6:	89 45 dc             	mov    %eax,-0x24(%rbp)
	void *va = (void*)((uintptr_t)pn * PGSIZE);
  801ed9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801edc:	48 c1 e0 0c          	shl    $0xc,%rax
  801ee0:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	if(perm & PTE_SHARE){
  801ee4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801ee7:	25 00 04 00 00       	and    $0x400,%eax
  801eec:	85 c0                	test   %eax,%eax
  801eee:	74 30                	je     801f20 <duppage+0x77>
		r = sys_page_map(0, va, envid, va, perm);
  801ef0:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801ef3:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801ef7:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801efa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801efe:	41 89 f0             	mov    %esi,%r8d
  801f01:	48 89 c6             	mov    %rax,%rsi
  801f04:	bf 00 00 00 00       	mov    $0x0,%edi
  801f09:	48 b8 5b 1b 80 00 00 	movabs $0x801b5b,%rax
  801f10:	00 00 00 
  801f13:	ff d0                	callq  *%rax
  801f15:	89 45 ec             	mov    %eax,-0x14(%rbp)
		return r;
  801f18:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f1b:	e9 a4 00 00 00       	jmpq   801fc4 <duppage+0x11b>
	}
	//envid_t pid = sys_getenvid();
	if((perm & PTE_W) || (perm & PTE_COW)){
  801f20:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801f23:	83 e0 02             	and    $0x2,%eax
  801f26:	85 c0                	test   %eax,%eax
  801f28:	75 0c                	jne    801f36 <duppage+0x8d>
  801f2a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801f2d:	25 00 08 00 00       	and    $0x800,%eax
  801f32:	85 c0                	test   %eax,%eax
  801f34:	74 63                	je     801f99 <duppage+0xf0>
		perm &= ~PTE_W;
  801f36:	83 65 dc fd          	andl   $0xfffffffd,-0x24(%rbp)
		perm |= PTE_COW;
  801f3a:	81 4d dc 00 08 00 00 	orl    $0x800,-0x24(%rbp)
		r = sys_page_map(0, va, envid, va, perm) | sys_page_map(0, va, 0, va, perm);
  801f41:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801f44:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801f48:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801f4b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f4f:	41 89 f0             	mov    %esi,%r8d
  801f52:	48 89 c6             	mov    %rax,%rsi
  801f55:	bf 00 00 00 00       	mov    $0x0,%edi
  801f5a:	48 b8 5b 1b 80 00 00 	movabs $0x801b5b,%rax
  801f61:	00 00 00 
  801f64:	ff d0                	callq  *%rax
  801f66:	89 c3                	mov    %eax,%ebx
  801f68:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  801f6b:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801f6f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f73:	41 89 c8             	mov    %ecx,%r8d
  801f76:	48 89 d1             	mov    %rdx,%rcx
  801f79:	ba 00 00 00 00       	mov    $0x0,%edx
  801f7e:	48 89 c6             	mov    %rax,%rsi
  801f81:	bf 00 00 00 00       	mov    $0x0,%edi
  801f86:	48 b8 5b 1b 80 00 00 	movabs $0x801b5b,%rax
  801f8d:	00 00 00 
  801f90:	ff d0                	callq  *%rax
  801f92:	09 d8                	or     %ebx,%eax
  801f94:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f97:	eb 28                	jmp    801fc1 <duppage+0x118>
	}
	else{
		r = sys_page_map(0, va, envid, va, perm);
  801f99:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801f9c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801fa0:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801fa3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fa7:	41 89 f0             	mov    %esi,%r8d
  801faa:	48 89 c6             	mov    %rax,%rsi
  801fad:	bf 00 00 00 00       	mov    $0x0,%edi
  801fb2:	48 b8 5b 1b 80 00 00 	movabs $0x801b5b,%rax
  801fb9:	00 00 00 
  801fbc:	ff d0                	callq  *%rax
  801fbe:	89 45 ec             	mov    %eax,-0x14(%rbp)
	}

	// LAB 4: Your code here.
	//panic("duppage not implemented");
	//if(r != 0) panic("Duplicating page failed: %e\n", r);
	return r;
  801fc1:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  801fc4:	48 83 c4 38          	add    $0x38,%rsp
  801fc8:	5b                   	pop    %rbx
  801fc9:	5d                   	pop    %rbp
  801fca:	c3                   	retq   

0000000000801fcb <fork>:
//   so you must allocate a new page for the child's user exception stack.
//

envid_t
fork(void)
{
  801fcb:	55                   	push   %rbp
  801fcc:	48 89 e5             	mov    %rsp,%rbp
  801fcf:	53                   	push   %rbx
  801fd0:	48 83 ec 58          	sub    $0x58,%rsp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  801fd4:	48 bf 78 1d 80 00 00 	movabs $0x801d78,%rdi
  801fdb:	00 00 00 
  801fde:	48 b8 2d 3b 80 00 00 	movabs $0x803b2d,%rax
  801fe5:	00 00 00 
  801fe8:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801fea:	b8 07 00 00 00       	mov    $0x7,%eax
  801fef:	cd 30                	int    $0x30
  801ff1:	89 45 a4             	mov    %eax,-0x5c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801ff4:	8b 45 a4             	mov    -0x5c(%rbp),%eax
	envid_t cid = sys_exofork();
  801ff7:	89 45 cc             	mov    %eax,-0x34(%rbp)
	if(cid < 0) panic("fork failed: %e\n", cid);
  801ffa:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801ffe:	79 30                	jns    802030 <fork+0x65>
  802000:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802003:	89 c1                	mov    %eax,%ecx
  802005:	48 ba 5a 45 80 00 00 	movabs $0x80455a,%rdx
  80200c:	00 00 00 
  80200f:	be 72 00 00 00       	mov    $0x72,%esi
  802014:	48 bf 4f 45 80 00 00 	movabs $0x80454f,%rdi
  80201b:	00 00 00 
  80201e:	b8 00 00 00 00       	mov    $0x0,%eax
  802023:	49 b8 ee 03 80 00 00 	movabs $0x8003ee,%r8
  80202a:	00 00 00 
  80202d:	41 ff d0             	callq  *%r8
	if(cid == 0){
  802030:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802034:	75 46                	jne    80207c <fork+0xb1>
		thisenv = &envs[ENVX(sys_getenvid())];
  802036:	48 b8 8f 1a 80 00 00 	movabs $0x801a8f,%rax
  80203d:	00 00 00 
  802040:	ff d0                	callq  *%rax
  802042:	25 ff 03 00 00       	and    $0x3ff,%eax
  802047:	48 63 d0             	movslq %eax,%rdx
  80204a:	48 89 d0             	mov    %rdx,%rax
  80204d:	48 c1 e0 03          	shl    $0x3,%rax
  802051:	48 01 d0             	add    %rdx,%rax
  802054:	48 c1 e0 05          	shl    $0x5,%rax
  802058:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80205f:	00 00 00 
  802062:	48 01 c2             	add    %rax,%rdx
  802065:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  80206c:	00 00 00 
  80206f:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802072:	b8 00 00 00 00       	mov    $0x0,%eax
  802077:	e9 12 02 00 00       	jmpq   80228e <fork+0x2c3>
	}
	int result;
	if((result = sys_page_alloc(cid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80207c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80207f:	ba 07 00 00 00       	mov    $0x7,%edx
  802084:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802089:	89 c7                	mov    %eax,%edi
  80208b:	48 b8 0b 1b 80 00 00 	movabs $0x801b0b,%rax
  802092:	00 00 00 
  802095:	ff d0                	callq  *%rax
  802097:	89 45 c8             	mov    %eax,-0x38(%rbp)
  80209a:	83 7d c8 00          	cmpl   $0x0,-0x38(%rbp)
  80209e:	79 30                	jns    8020d0 <fork+0x105>
		panic("fork failed: %e\n", result);
  8020a0:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020a3:	89 c1                	mov    %eax,%ecx
  8020a5:	48 ba 5a 45 80 00 00 	movabs $0x80455a,%rdx
  8020ac:	00 00 00 
  8020af:	be 79 00 00 00       	mov    $0x79,%esi
  8020b4:	48 bf 4f 45 80 00 00 	movabs $0x80454f,%rdi
  8020bb:	00 00 00 
  8020be:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c3:	49 b8 ee 03 80 00 00 	movabs $0x8003ee,%r8
  8020ca:	00 00 00 
  8020cd:	41 ff d0             	callq  *%r8
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  8020d0:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8020d7:	00 
  8020d8:	e9 40 01 00 00       	jmpq   80221d <fork+0x252>
		if(uvpml4e[pml4e] & PTE_P){
  8020dd:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8020e4:	01 00 00 
  8020e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8020eb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020ef:	83 e0 01             	and    $0x1,%eax
  8020f2:	48 85 c0             	test   %rax,%rax
  8020f5:	0f 84 1d 01 00 00    	je     802218 <fork+0x24d>
			base_pml4e = pml4e * NPDPENTRIES;
  8020fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020ff:	48 c1 e0 09          	shl    $0x9,%rax
  802103:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  802107:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  80210e:	00 
  80210f:	e9 f6 00 00 00       	jmpq   80220a <fork+0x23f>
				if(uvpde[base_pml4e + pdpe] & PTE_P){
  802114:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802118:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80211c:	48 01 c2             	add    %rax,%rdx
  80211f:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802126:	01 00 00 
  802129:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80212d:	83 e0 01             	and    $0x1,%eax
  802130:	48 85 c0             	test   %rax,%rax
  802133:	0f 84 cc 00 00 00    	je     802205 <fork+0x23a>
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
  802139:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80213d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802141:	48 01 d0             	add    %rdx,%rax
  802144:	48 c1 e0 09          	shl    $0x9,%rax
  802148:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
					for(pde = 0; pde < NPDENTRIES; pde++){
  80214c:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  802153:	00 
  802154:	e9 9e 00 00 00       	jmpq   8021f7 <fork+0x22c>
						if(uvpd[base_pdpe + pde] & PTE_P){
  802159:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80215d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802161:	48 01 c2             	add    %rax,%rdx
  802164:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80216b:	01 00 00 
  80216e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802172:	83 e0 01             	and    $0x1,%eax
  802175:	48 85 c0             	test   %rax,%rax
  802178:	74 78                	je     8021f2 <fork+0x227>
							base_pde = (base_pdpe + pde) * NPTENTRIES;
  80217a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80217e:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802182:	48 01 d0             	add    %rdx,%rax
  802185:	48 c1 e0 09          	shl    $0x9,%rax
  802189:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
							for(pte = 0; pte < NPTENTRIES; pte++){
  80218d:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  802194:	00 
  802195:	eb 51                	jmp    8021e8 <fork+0x21d>
								entry = base_pde + pte;
  802197:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80219b:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80219f:	48 01 d0             	add    %rdx,%rax
  8021a2:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
								if((uvpt[entry] & PTE_P) && (entry != VPN(UXSTACKTOP - PGSIZE))){
  8021a6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021ad:	01 00 00 
  8021b0:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8021b4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021b8:	83 e0 01             	and    $0x1,%eax
  8021bb:	48 85 c0             	test   %rax,%rax
  8021be:	74 23                	je     8021e3 <fork+0x218>
  8021c0:	48 81 7d a8 ff f7 0e 	cmpq   $0xef7ff,-0x58(%rbp)
  8021c7:	00 
  8021c8:	74 19                	je     8021e3 <fork+0x218>
									duppage(cid, entry);
  8021ca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8021ce:	89 c2                	mov    %eax,%edx
  8021d0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8021d3:	89 d6                	mov    %edx,%esi
  8021d5:	89 c7                	mov    %eax,%edi
  8021d7:	48 b8 a9 1e 80 00 00 	movabs $0x801ea9,%rax
  8021de:	00 00 00 
  8021e1:	ff d0                	callq  *%rax
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
						if(uvpd[base_pdpe + pde] & PTE_P){
							base_pde = (base_pdpe + pde) * NPTENTRIES;
							for(pte = 0; pte < NPTENTRIES; pte++){
  8021e3:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  8021e8:	48 81 7d d0 ff 01 00 	cmpq   $0x1ff,-0x30(%rbp)
  8021ef:	00 
  8021f0:	76 a5                	jbe    802197 <fork+0x1cc>
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
  8021f2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8021f7:	48 81 7d d8 ff 01 00 	cmpq   $0x1ff,-0x28(%rbp)
  8021fe:	00 
  8021ff:	0f 86 54 ff ff ff    	jbe    802159 <fork+0x18e>
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  802205:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  80220a:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  802211:	00 
  802212:	0f 86 fc fe ff ff    	jbe    802114 <fork+0x149>
	int result;
	if((result = sys_page_alloc(cid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		panic("fork failed: %e\n", result);
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  802218:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80221d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802222:	0f 84 b5 fe ff ff    	je     8020dd <fork+0x112>
					}
				}
			}
		}
	}
	if(sys_env_set_pgfault_upcall(cid, _pgfault_upcall) | sys_env_set_status(cid, ENV_RUNNABLE))
  802228:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80222b:	48 be c2 3b 80 00 00 	movabs $0x803bc2,%rsi
  802232:	00 00 00 
  802235:	89 c7                	mov    %eax,%edi
  802237:	48 b8 95 1c 80 00 00 	movabs $0x801c95,%rax
  80223e:	00 00 00 
  802241:	ff d0                	callq  *%rax
  802243:	89 c3                	mov    %eax,%ebx
  802245:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802248:	be 02 00 00 00       	mov    $0x2,%esi
  80224d:	89 c7                	mov    %eax,%edi
  80224f:	48 b8 00 1c 80 00 00 	movabs $0x801c00,%rax
  802256:	00 00 00 
  802259:	ff d0                	callq  *%rax
  80225b:	09 d8                	or     %ebx,%eax
  80225d:	85 c0                	test   %eax,%eax
  80225f:	74 2a                	je     80228b <fork+0x2c0>
		panic("fork failed\n");
  802261:	48 ba 6b 45 80 00 00 	movabs $0x80456b,%rdx
  802268:	00 00 00 
  80226b:	be 92 00 00 00       	mov    $0x92,%esi
  802270:	48 bf 4f 45 80 00 00 	movabs $0x80454f,%rdi
  802277:	00 00 00 
  80227a:	b8 00 00 00 00       	mov    $0x0,%eax
  80227f:	48 b9 ee 03 80 00 00 	movabs $0x8003ee,%rcx
  802286:	00 00 00 
  802289:	ff d1                	callq  *%rcx
	return cid;
  80228b:	8b 45 cc             	mov    -0x34(%rbp),%eax
	//panic("fork not implemented");
}
  80228e:	48 83 c4 58          	add    $0x58,%rsp
  802292:	5b                   	pop    %rbx
  802293:	5d                   	pop    %rbp
  802294:	c3                   	retq   

0000000000802295 <sfork>:


// Challenge!
int
sfork(void)
{
  802295:	55                   	push   %rbp
  802296:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802299:	48 ba 78 45 80 00 00 	movabs $0x804578,%rdx
  8022a0:	00 00 00 
  8022a3:	be 9c 00 00 00       	mov    $0x9c,%esi
  8022a8:	48 bf 4f 45 80 00 00 	movabs $0x80454f,%rdi
  8022af:	00 00 00 
  8022b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b7:	48 b9 ee 03 80 00 00 	movabs $0x8003ee,%rcx
  8022be:	00 00 00 
  8022c1:	ff d1                	callq  *%rcx

00000000008022c3 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8022c3:	55                   	push   %rbp
  8022c4:	48 89 e5             	mov    %rsp,%rbp
  8022c7:	48 83 ec 08          	sub    $0x8,%rsp
  8022cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8022cf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8022d3:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8022da:	ff ff ff 
  8022dd:	48 01 d0             	add    %rdx,%rax
  8022e0:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8022e4:	c9                   	leaveq 
  8022e5:	c3                   	retq   

00000000008022e6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8022e6:	55                   	push   %rbp
  8022e7:	48 89 e5             	mov    %rsp,%rbp
  8022ea:	48 83 ec 08          	sub    $0x8,%rsp
  8022ee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8022f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022f6:	48 89 c7             	mov    %rax,%rdi
  8022f9:	48 b8 c3 22 80 00 00 	movabs $0x8022c3,%rax
  802300:	00 00 00 
  802303:	ff d0                	callq  *%rax
  802305:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80230b:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80230f:	c9                   	leaveq 
  802310:	c3                   	retq   

0000000000802311 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802311:	55                   	push   %rbp
  802312:	48 89 e5             	mov    %rsp,%rbp
  802315:	48 83 ec 18          	sub    $0x18,%rsp
  802319:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80231d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802324:	eb 6b                	jmp    802391 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802326:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802329:	48 98                	cltq   
  80232b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802331:	48 c1 e0 0c          	shl    $0xc,%rax
  802335:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802339:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80233d:	48 c1 e8 15          	shr    $0x15,%rax
  802341:	48 89 c2             	mov    %rax,%rdx
  802344:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80234b:	01 00 00 
  80234e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802352:	83 e0 01             	and    $0x1,%eax
  802355:	48 85 c0             	test   %rax,%rax
  802358:	74 21                	je     80237b <fd_alloc+0x6a>
  80235a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80235e:	48 c1 e8 0c          	shr    $0xc,%rax
  802362:	48 89 c2             	mov    %rax,%rdx
  802365:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80236c:	01 00 00 
  80236f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802373:	83 e0 01             	and    $0x1,%eax
  802376:	48 85 c0             	test   %rax,%rax
  802379:	75 12                	jne    80238d <fd_alloc+0x7c>
			*fd_store = fd;
  80237b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80237f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802383:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802386:	b8 00 00 00 00       	mov    $0x0,%eax
  80238b:	eb 1a                	jmp    8023a7 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80238d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802391:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802395:	7e 8f                	jle    802326 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802397:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80239b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8023a2:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8023a7:	c9                   	leaveq 
  8023a8:	c3                   	retq   

00000000008023a9 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8023a9:	55                   	push   %rbp
  8023aa:	48 89 e5             	mov    %rsp,%rbp
  8023ad:	48 83 ec 20          	sub    $0x20,%rsp
  8023b1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023b4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8023b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8023bc:	78 06                	js     8023c4 <fd_lookup+0x1b>
  8023be:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8023c2:	7e 07                	jle    8023cb <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8023c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023c9:	eb 6c                	jmp    802437 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8023cb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023ce:	48 98                	cltq   
  8023d0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8023d6:	48 c1 e0 0c          	shl    $0xc,%rax
  8023da:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8023de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023e2:	48 c1 e8 15          	shr    $0x15,%rax
  8023e6:	48 89 c2             	mov    %rax,%rdx
  8023e9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8023f0:	01 00 00 
  8023f3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023f7:	83 e0 01             	and    $0x1,%eax
  8023fa:	48 85 c0             	test   %rax,%rax
  8023fd:	74 21                	je     802420 <fd_lookup+0x77>
  8023ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802403:	48 c1 e8 0c          	shr    $0xc,%rax
  802407:	48 89 c2             	mov    %rax,%rdx
  80240a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802411:	01 00 00 
  802414:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802418:	83 e0 01             	and    $0x1,%eax
  80241b:	48 85 c0             	test   %rax,%rax
  80241e:	75 07                	jne    802427 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802420:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802425:	eb 10                	jmp    802437 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802427:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80242b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80242f:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802432:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802437:	c9                   	leaveq 
  802438:	c3                   	retq   

0000000000802439 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802439:	55                   	push   %rbp
  80243a:	48 89 e5             	mov    %rsp,%rbp
  80243d:	48 83 ec 30          	sub    $0x30,%rsp
  802441:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802445:	89 f0                	mov    %esi,%eax
  802447:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80244a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80244e:	48 89 c7             	mov    %rax,%rdi
  802451:	48 b8 c3 22 80 00 00 	movabs $0x8022c3,%rax
  802458:	00 00 00 
  80245b:	ff d0                	callq  *%rax
  80245d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802461:	48 89 d6             	mov    %rdx,%rsi
  802464:	89 c7                	mov    %eax,%edi
  802466:	48 b8 a9 23 80 00 00 	movabs $0x8023a9,%rax
  80246d:	00 00 00 
  802470:	ff d0                	callq  *%rax
  802472:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802475:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802479:	78 0a                	js     802485 <fd_close+0x4c>
	    || fd != fd2)
  80247b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80247f:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802483:	74 12                	je     802497 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802485:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802489:	74 05                	je     802490 <fd_close+0x57>
  80248b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80248e:	eb 05                	jmp    802495 <fd_close+0x5c>
  802490:	b8 00 00 00 00       	mov    $0x0,%eax
  802495:	eb 69                	jmp    802500 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802497:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80249b:	8b 00                	mov    (%rax),%eax
  80249d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024a1:	48 89 d6             	mov    %rdx,%rsi
  8024a4:	89 c7                	mov    %eax,%edi
  8024a6:	48 b8 02 25 80 00 00 	movabs $0x802502,%rax
  8024ad:	00 00 00 
  8024b0:	ff d0                	callq  *%rax
  8024b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024b9:	78 2a                	js     8024e5 <fd_close+0xac>
		if (dev->dev_close)
  8024bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024bf:	48 8b 40 20          	mov    0x20(%rax),%rax
  8024c3:	48 85 c0             	test   %rax,%rax
  8024c6:	74 16                	je     8024de <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8024c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024cc:	48 8b 40 20          	mov    0x20(%rax),%rax
  8024d0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8024d4:	48 89 d7             	mov    %rdx,%rdi
  8024d7:	ff d0                	callq  *%rax
  8024d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024dc:	eb 07                	jmp    8024e5 <fd_close+0xac>
		else
			r = 0;
  8024de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8024e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024e9:	48 89 c6             	mov    %rax,%rsi
  8024ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8024f1:	48 b8 b6 1b 80 00 00 	movabs $0x801bb6,%rax
  8024f8:	00 00 00 
  8024fb:	ff d0                	callq  *%rax
	return r;
  8024fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802500:	c9                   	leaveq 
  802501:	c3                   	retq   

0000000000802502 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802502:	55                   	push   %rbp
  802503:	48 89 e5             	mov    %rsp,%rbp
  802506:	48 83 ec 20          	sub    $0x20,%rsp
  80250a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80250d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802511:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802518:	eb 41                	jmp    80255b <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80251a:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802521:	00 00 00 
  802524:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802527:	48 63 d2             	movslq %edx,%rdx
  80252a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80252e:	8b 00                	mov    (%rax),%eax
  802530:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802533:	75 22                	jne    802557 <dev_lookup+0x55>
			*dev = devtab[i];
  802535:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80253c:	00 00 00 
  80253f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802542:	48 63 d2             	movslq %edx,%rdx
  802545:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802549:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80254d:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802550:	b8 00 00 00 00       	mov    $0x0,%eax
  802555:	eb 60                	jmp    8025b7 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802557:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80255b:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802562:	00 00 00 
  802565:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802568:	48 63 d2             	movslq %edx,%rdx
  80256b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80256f:	48 85 c0             	test   %rax,%rax
  802572:	75 a6                	jne    80251a <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802574:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  80257b:	00 00 00 
  80257e:	48 8b 00             	mov    (%rax),%rax
  802581:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802587:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80258a:	89 c6                	mov    %eax,%esi
  80258c:	48 bf 90 45 80 00 00 	movabs $0x804590,%rdi
  802593:	00 00 00 
  802596:	b8 00 00 00 00       	mov    $0x0,%eax
  80259b:	48 b9 27 06 80 00 00 	movabs $0x800627,%rcx
  8025a2:	00 00 00 
  8025a5:	ff d1                	callq  *%rcx
	*dev = 0;
  8025a7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025ab:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8025b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8025b7:	c9                   	leaveq 
  8025b8:	c3                   	retq   

00000000008025b9 <close>:

int
close(int fdnum)
{
  8025b9:	55                   	push   %rbp
  8025ba:	48 89 e5             	mov    %rsp,%rbp
  8025bd:	48 83 ec 20          	sub    $0x20,%rsp
  8025c1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025c4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025c8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025cb:	48 89 d6             	mov    %rdx,%rsi
  8025ce:	89 c7                	mov    %eax,%edi
  8025d0:	48 b8 a9 23 80 00 00 	movabs $0x8023a9,%rax
  8025d7:	00 00 00 
  8025da:	ff d0                	callq  *%rax
  8025dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025e3:	79 05                	jns    8025ea <close+0x31>
		return r;
  8025e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025e8:	eb 18                	jmp    802602 <close+0x49>
	else
		return fd_close(fd, 1);
  8025ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ee:	be 01 00 00 00       	mov    $0x1,%esi
  8025f3:	48 89 c7             	mov    %rax,%rdi
  8025f6:	48 b8 39 24 80 00 00 	movabs $0x802439,%rax
  8025fd:	00 00 00 
  802600:	ff d0                	callq  *%rax
}
  802602:	c9                   	leaveq 
  802603:	c3                   	retq   

0000000000802604 <close_all>:

void
close_all(void)
{
  802604:	55                   	push   %rbp
  802605:	48 89 e5             	mov    %rsp,%rbp
  802608:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80260c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802613:	eb 15                	jmp    80262a <close_all+0x26>
		close(i);
  802615:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802618:	89 c7                	mov    %eax,%edi
  80261a:	48 b8 b9 25 80 00 00 	movabs $0x8025b9,%rax
  802621:	00 00 00 
  802624:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802626:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80262a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80262e:	7e e5                	jle    802615 <close_all+0x11>
		close(i);
}
  802630:	c9                   	leaveq 
  802631:	c3                   	retq   

0000000000802632 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802632:	55                   	push   %rbp
  802633:	48 89 e5             	mov    %rsp,%rbp
  802636:	48 83 ec 40          	sub    $0x40,%rsp
  80263a:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80263d:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802640:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802644:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802647:	48 89 d6             	mov    %rdx,%rsi
  80264a:	89 c7                	mov    %eax,%edi
  80264c:	48 b8 a9 23 80 00 00 	movabs $0x8023a9,%rax
  802653:	00 00 00 
  802656:	ff d0                	callq  *%rax
  802658:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80265b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80265f:	79 08                	jns    802669 <dup+0x37>
		return r;
  802661:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802664:	e9 70 01 00 00       	jmpq   8027d9 <dup+0x1a7>
	close(newfdnum);
  802669:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80266c:	89 c7                	mov    %eax,%edi
  80266e:	48 b8 b9 25 80 00 00 	movabs $0x8025b9,%rax
  802675:	00 00 00 
  802678:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80267a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80267d:	48 98                	cltq   
  80267f:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802685:	48 c1 e0 0c          	shl    $0xc,%rax
  802689:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80268d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802691:	48 89 c7             	mov    %rax,%rdi
  802694:	48 b8 e6 22 80 00 00 	movabs $0x8022e6,%rax
  80269b:	00 00 00 
  80269e:	ff d0                	callq  *%rax
  8026a0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8026a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026a8:	48 89 c7             	mov    %rax,%rdi
  8026ab:	48 b8 e6 22 80 00 00 	movabs $0x8022e6,%rax
  8026b2:	00 00 00 
  8026b5:	ff d0                	callq  *%rax
  8026b7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8026bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026bf:	48 c1 e8 15          	shr    $0x15,%rax
  8026c3:	48 89 c2             	mov    %rax,%rdx
  8026c6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8026cd:	01 00 00 
  8026d0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026d4:	83 e0 01             	and    $0x1,%eax
  8026d7:	48 85 c0             	test   %rax,%rax
  8026da:	74 73                	je     80274f <dup+0x11d>
  8026dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026e0:	48 c1 e8 0c          	shr    $0xc,%rax
  8026e4:	48 89 c2             	mov    %rax,%rdx
  8026e7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026ee:	01 00 00 
  8026f1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026f5:	83 e0 01             	and    $0x1,%eax
  8026f8:	48 85 c0             	test   %rax,%rax
  8026fb:	74 52                	je     80274f <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8026fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802701:	48 c1 e8 0c          	shr    $0xc,%rax
  802705:	48 89 c2             	mov    %rax,%rdx
  802708:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80270f:	01 00 00 
  802712:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802716:	25 07 0e 00 00       	and    $0xe07,%eax
  80271b:	89 c1                	mov    %eax,%ecx
  80271d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802721:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802725:	41 89 c8             	mov    %ecx,%r8d
  802728:	48 89 d1             	mov    %rdx,%rcx
  80272b:	ba 00 00 00 00       	mov    $0x0,%edx
  802730:	48 89 c6             	mov    %rax,%rsi
  802733:	bf 00 00 00 00       	mov    $0x0,%edi
  802738:	48 b8 5b 1b 80 00 00 	movabs $0x801b5b,%rax
  80273f:	00 00 00 
  802742:	ff d0                	callq  *%rax
  802744:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802747:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80274b:	79 02                	jns    80274f <dup+0x11d>
			goto err;
  80274d:	eb 57                	jmp    8027a6 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80274f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802753:	48 c1 e8 0c          	shr    $0xc,%rax
  802757:	48 89 c2             	mov    %rax,%rdx
  80275a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802761:	01 00 00 
  802764:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802768:	25 07 0e 00 00       	and    $0xe07,%eax
  80276d:	89 c1                	mov    %eax,%ecx
  80276f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802773:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802777:	41 89 c8             	mov    %ecx,%r8d
  80277a:	48 89 d1             	mov    %rdx,%rcx
  80277d:	ba 00 00 00 00       	mov    $0x0,%edx
  802782:	48 89 c6             	mov    %rax,%rsi
  802785:	bf 00 00 00 00       	mov    $0x0,%edi
  80278a:	48 b8 5b 1b 80 00 00 	movabs $0x801b5b,%rax
  802791:	00 00 00 
  802794:	ff d0                	callq  *%rax
  802796:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802799:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80279d:	79 02                	jns    8027a1 <dup+0x16f>
		goto err;
  80279f:	eb 05                	jmp    8027a6 <dup+0x174>

	return newfdnum;
  8027a1:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027a4:	eb 33                	jmp    8027d9 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8027a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027aa:	48 89 c6             	mov    %rax,%rsi
  8027ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8027b2:	48 b8 b6 1b 80 00 00 	movabs $0x801bb6,%rax
  8027b9:	00 00 00 
  8027bc:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8027be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027c2:	48 89 c6             	mov    %rax,%rsi
  8027c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8027ca:	48 b8 b6 1b 80 00 00 	movabs $0x801bb6,%rax
  8027d1:	00 00 00 
  8027d4:	ff d0                	callq  *%rax
	return r;
  8027d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8027d9:	c9                   	leaveq 
  8027da:	c3                   	retq   

00000000008027db <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8027db:	55                   	push   %rbp
  8027dc:	48 89 e5             	mov    %rsp,%rbp
  8027df:	48 83 ec 40          	sub    $0x40,%rsp
  8027e3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8027e6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8027ea:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8027ee:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027f2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8027f5:	48 89 d6             	mov    %rdx,%rsi
  8027f8:	89 c7                	mov    %eax,%edi
  8027fa:	48 b8 a9 23 80 00 00 	movabs $0x8023a9,%rax
  802801:	00 00 00 
  802804:	ff d0                	callq  *%rax
  802806:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802809:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80280d:	78 24                	js     802833 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80280f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802813:	8b 00                	mov    (%rax),%eax
  802815:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802819:	48 89 d6             	mov    %rdx,%rsi
  80281c:	89 c7                	mov    %eax,%edi
  80281e:	48 b8 02 25 80 00 00 	movabs $0x802502,%rax
  802825:	00 00 00 
  802828:	ff d0                	callq  *%rax
  80282a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80282d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802831:	79 05                	jns    802838 <read+0x5d>
		return r;
  802833:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802836:	eb 76                	jmp    8028ae <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802838:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80283c:	8b 40 08             	mov    0x8(%rax),%eax
  80283f:	83 e0 03             	and    $0x3,%eax
  802842:	83 f8 01             	cmp    $0x1,%eax
  802845:	75 3a                	jne    802881 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802847:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  80284e:	00 00 00 
  802851:	48 8b 00             	mov    (%rax),%rax
  802854:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80285a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80285d:	89 c6                	mov    %eax,%esi
  80285f:	48 bf af 45 80 00 00 	movabs $0x8045af,%rdi
  802866:	00 00 00 
  802869:	b8 00 00 00 00       	mov    $0x0,%eax
  80286e:	48 b9 27 06 80 00 00 	movabs $0x800627,%rcx
  802875:	00 00 00 
  802878:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80287a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80287f:	eb 2d                	jmp    8028ae <read+0xd3>
	}
	if (!dev->dev_read)
  802881:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802885:	48 8b 40 10          	mov    0x10(%rax),%rax
  802889:	48 85 c0             	test   %rax,%rax
  80288c:	75 07                	jne    802895 <read+0xba>
		return -E_NOT_SUPP;
  80288e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802893:	eb 19                	jmp    8028ae <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802895:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802899:	48 8b 40 10          	mov    0x10(%rax),%rax
  80289d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8028a1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8028a5:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8028a9:	48 89 cf             	mov    %rcx,%rdi
  8028ac:	ff d0                	callq  *%rax
}
  8028ae:	c9                   	leaveq 
  8028af:	c3                   	retq   

00000000008028b0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8028b0:	55                   	push   %rbp
  8028b1:	48 89 e5             	mov    %rsp,%rbp
  8028b4:	48 83 ec 30          	sub    $0x30,%rsp
  8028b8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028bb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028bf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8028c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8028ca:	eb 49                	jmp    802915 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8028cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028cf:	48 98                	cltq   
  8028d1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028d5:	48 29 c2             	sub    %rax,%rdx
  8028d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028db:	48 63 c8             	movslq %eax,%rcx
  8028de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028e2:	48 01 c1             	add    %rax,%rcx
  8028e5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028e8:	48 89 ce             	mov    %rcx,%rsi
  8028eb:	89 c7                	mov    %eax,%edi
  8028ed:	48 b8 db 27 80 00 00 	movabs $0x8027db,%rax
  8028f4:	00 00 00 
  8028f7:	ff d0                	callq  *%rax
  8028f9:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8028fc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802900:	79 05                	jns    802907 <readn+0x57>
			return m;
  802902:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802905:	eb 1c                	jmp    802923 <readn+0x73>
		if (m == 0)
  802907:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80290b:	75 02                	jne    80290f <readn+0x5f>
			break;
  80290d:	eb 11                	jmp    802920 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80290f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802912:	01 45 fc             	add    %eax,-0x4(%rbp)
  802915:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802918:	48 98                	cltq   
  80291a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80291e:	72 ac                	jb     8028cc <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802920:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802923:	c9                   	leaveq 
  802924:	c3                   	retq   

0000000000802925 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802925:	55                   	push   %rbp
  802926:	48 89 e5             	mov    %rsp,%rbp
  802929:	48 83 ec 40          	sub    $0x40,%rsp
  80292d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802930:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802934:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802938:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80293c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80293f:	48 89 d6             	mov    %rdx,%rsi
  802942:	89 c7                	mov    %eax,%edi
  802944:	48 b8 a9 23 80 00 00 	movabs $0x8023a9,%rax
  80294b:	00 00 00 
  80294e:	ff d0                	callq  *%rax
  802950:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802953:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802957:	78 24                	js     80297d <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802959:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80295d:	8b 00                	mov    (%rax),%eax
  80295f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802963:	48 89 d6             	mov    %rdx,%rsi
  802966:	89 c7                	mov    %eax,%edi
  802968:	48 b8 02 25 80 00 00 	movabs $0x802502,%rax
  80296f:	00 00 00 
  802972:	ff d0                	callq  *%rax
  802974:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802977:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80297b:	79 05                	jns    802982 <write+0x5d>
		return r;
  80297d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802980:	eb 75                	jmp    8029f7 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802982:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802986:	8b 40 08             	mov    0x8(%rax),%eax
  802989:	83 e0 03             	and    $0x3,%eax
  80298c:	85 c0                	test   %eax,%eax
  80298e:	75 3a                	jne    8029ca <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802990:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802997:	00 00 00 
  80299a:	48 8b 00             	mov    (%rax),%rax
  80299d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029a3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8029a6:	89 c6                	mov    %eax,%esi
  8029a8:	48 bf cb 45 80 00 00 	movabs $0x8045cb,%rdi
  8029af:	00 00 00 
  8029b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b7:	48 b9 27 06 80 00 00 	movabs $0x800627,%rcx
  8029be:	00 00 00 
  8029c1:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8029c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029c8:	eb 2d                	jmp    8029f7 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8029ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029ce:	48 8b 40 18          	mov    0x18(%rax),%rax
  8029d2:	48 85 c0             	test   %rax,%rax
  8029d5:	75 07                	jne    8029de <write+0xb9>
		return -E_NOT_SUPP;
  8029d7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029dc:	eb 19                	jmp    8029f7 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8029de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029e2:	48 8b 40 18          	mov    0x18(%rax),%rax
  8029e6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8029ea:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8029ee:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8029f2:	48 89 cf             	mov    %rcx,%rdi
  8029f5:	ff d0                	callq  *%rax
}
  8029f7:	c9                   	leaveq 
  8029f8:	c3                   	retq   

00000000008029f9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8029f9:	55                   	push   %rbp
  8029fa:	48 89 e5             	mov    %rsp,%rbp
  8029fd:	48 83 ec 18          	sub    $0x18,%rsp
  802a01:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a04:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a07:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a0b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a0e:	48 89 d6             	mov    %rdx,%rsi
  802a11:	89 c7                	mov    %eax,%edi
  802a13:	48 b8 a9 23 80 00 00 	movabs $0x8023a9,%rax
  802a1a:	00 00 00 
  802a1d:	ff d0                	callq  *%rax
  802a1f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a22:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a26:	79 05                	jns    802a2d <seek+0x34>
		return r;
  802a28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a2b:	eb 0f                	jmp    802a3c <seek+0x43>
	fd->fd_offset = offset;
  802a2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a31:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802a34:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802a37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a3c:	c9                   	leaveq 
  802a3d:	c3                   	retq   

0000000000802a3e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802a3e:	55                   	push   %rbp
  802a3f:	48 89 e5             	mov    %rsp,%rbp
  802a42:	48 83 ec 30          	sub    $0x30,%rsp
  802a46:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a49:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a4c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a50:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a53:	48 89 d6             	mov    %rdx,%rsi
  802a56:	89 c7                	mov    %eax,%edi
  802a58:	48 b8 a9 23 80 00 00 	movabs $0x8023a9,%rax
  802a5f:	00 00 00 
  802a62:	ff d0                	callq  *%rax
  802a64:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a6b:	78 24                	js     802a91 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a71:	8b 00                	mov    (%rax),%eax
  802a73:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a77:	48 89 d6             	mov    %rdx,%rsi
  802a7a:	89 c7                	mov    %eax,%edi
  802a7c:	48 b8 02 25 80 00 00 	movabs $0x802502,%rax
  802a83:	00 00 00 
  802a86:	ff d0                	callq  *%rax
  802a88:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a8f:	79 05                	jns    802a96 <ftruncate+0x58>
		return r;
  802a91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a94:	eb 72                	jmp    802b08 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a9a:	8b 40 08             	mov    0x8(%rax),%eax
  802a9d:	83 e0 03             	and    $0x3,%eax
  802aa0:	85 c0                	test   %eax,%eax
  802aa2:	75 3a                	jne    802ade <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802aa4:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802aab:	00 00 00 
  802aae:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802ab1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ab7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802aba:	89 c6                	mov    %eax,%esi
  802abc:	48 bf e8 45 80 00 00 	movabs $0x8045e8,%rdi
  802ac3:	00 00 00 
  802ac6:	b8 00 00 00 00       	mov    $0x0,%eax
  802acb:	48 b9 27 06 80 00 00 	movabs $0x800627,%rcx
  802ad2:	00 00 00 
  802ad5:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802ad7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802adc:	eb 2a                	jmp    802b08 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802ade:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ae2:	48 8b 40 30          	mov    0x30(%rax),%rax
  802ae6:	48 85 c0             	test   %rax,%rax
  802ae9:	75 07                	jne    802af2 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802aeb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802af0:	eb 16                	jmp    802b08 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802af2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802af6:	48 8b 40 30          	mov    0x30(%rax),%rax
  802afa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802afe:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802b01:	89 ce                	mov    %ecx,%esi
  802b03:	48 89 d7             	mov    %rdx,%rdi
  802b06:	ff d0                	callq  *%rax
}
  802b08:	c9                   	leaveq 
  802b09:	c3                   	retq   

0000000000802b0a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802b0a:	55                   	push   %rbp
  802b0b:	48 89 e5             	mov    %rsp,%rbp
  802b0e:	48 83 ec 30          	sub    $0x30,%rsp
  802b12:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b15:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b19:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b1d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b20:	48 89 d6             	mov    %rdx,%rsi
  802b23:	89 c7                	mov    %eax,%edi
  802b25:	48 b8 a9 23 80 00 00 	movabs $0x8023a9,%rax
  802b2c:	00 00 00 
  802b2f:	ff d0                	callq  *%rax
  802b31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b38:	78 24                	js     802b5e <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b3e:	8b 00                	mov    (%rax),%eax
  802b40:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b44:	48 89 d6             	mov    %rdx,%rsi
  802b47:	89 c7                	mov    %eax,%edi
  802b49:	48 b8 02 25 80 00 00 	movabs $0x802502,%rax
  802b50:	00 00 00 
  802b53:	ff d0                	callq  *%rax
  802b55:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b58:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b5c:	79 05                	jns    802b63 <fstat+0x59>
		return r;
  802b5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b61:	eb 5e                	jmp    802bc1 <fstat+0xb7>
	if (!dev->dev_stat)
  802b63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b67:	48 8b 40 28          	mov    0x28(%rax),%rax
  802b6b:	48 85 c0             	test   %rax,%rax
  802b6e:	75 07                	jne    802b77 <fstat+0x6d>
		return -E_NOT_SUPP;
  802b70:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b75:	eb 4a                	jmp    802bc1 <fstat+0xb7>
	stat->st_name[0] = 0;
  802b77:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b7b:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802b7e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b82:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802b89:	00 00 00 
	stat->st_isdir = 0;
  802b8c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b90:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802b97:	00 00 00 
	stat->st_dev = dev;
  802b9a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b9e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ba2:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802ba9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bad:	48 8b 40 28          	mov    0x28(%rax),%rax
  802bb1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bb5:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802bb9:	48 89 ce             	mov    %rcx,%rsi
  802bbc:	48 89 d7             	mov    %rdx,%rdi
  802bbf:	ff d0                	callq  *%rax
}
  802bc1:	c9                   	leaveq 
  802bc2:	c3                   	retq   

0000000000802bc3 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802bc3:	55                   	push   %rbp
  802bc4:	48 89 e5             	mov    %rsp,%rbp
  802bc7:	48 83 ec 20          	sub    $0x20,%rsp
  802bcb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802bcf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802bd3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bd7:	be 00 00 00 00       	mov    $0x0,%esi
  802bdc:	48 89 c7             	mov    %rax,%rdi
  802bdf:	48 b8 b1 2c 80 00 00 	movabs $0x802cb1,%rax
  802be6:	00 00 00 
  802be9:	ff d0                	callq  *%rax
  802beb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bf2:	79 05                	jns    802bf9 <stat+0x36>
		return fd;
  802bf4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bf7:	eb 2f                	jmp    802c28 <stat+0x65>
	r = fstat(fd, stat);
  802bf9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802bfd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c00:	48 89 d6             	mov    %rdx,%rsi
  802c03:	89 c7                	mov    %eax,%edi
  802c05:	48 b8 0a 2b 80 00 00 	movabs $0x802b0a,%rax
  802c0c:	00 00 00 
  802c0f:	ff d0                	callq  *%rax
  802c11:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802c14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c17:	89 c7                	mov    %eax,%edi
  802c19:	48 b8 b9 25 80 00 00 	movabs $0x8025b9,%rax
  802c20:	00 00 00 
  802c23:	ff d0                	callq  *%rax
	return r;
  802c25:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802c28:	c9                   	leaveq 
  802c29:	c3                   	retq   

0000000000802c2a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802c2a:	55                   	push   %rbp
  802c2b:	48 89 e5             	mov    %rsp,%rbp
  802c2e:	48 83 ec 10          	sub    $0x10,%rsp
  802c32:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c35:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802c39:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c40:	00 00 00 
  802c43:	8b 00                	mov    (%rax),%eax
  802c45:	85 c0                	test   %eax,%eax
  802c47:	75 1d                	jne    802c66 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802c49:	bf 01 00 00 00       	mov    $0x1,%edi
  802c4e:	48 b8 af 3d 80 00 00 	movabs $0x803daf,%rax
  802c55:	00 00 00 
  802c58:	ff d0                	callq  *%rax
  802c5a:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802c61:	00 00 00 
  802c64:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802c66:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c6d:	00 00 00 
  802c70:	8b 00                	mov    (%rax),%eax
  802c72:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802c75:	b9 07 00 00 00       	mov    $0x7,%ecx
  802c7a:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802c81:	00 00 00 
  802c84:	89 c7                	mov    %eax,%edi
  802c86:	48 b8 12 3d 80 00 00 	movabs $0x803d12,%rax
  802c8d:	00 00 00 
  802c90:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802c92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c96:	ba 00 00 00 00       	mov    $0x0,%edx
  802c9b:	48 89 c6             	mov    %rax,%rsi
  802c9e:	bf 00 00 00 00       	mov    $0x0,%edi
  802ca3:	48 b8 4c 3c 80 00 00 	movabs $0x803c4c,%rax
  802caa:	00 00 00 
  802cad:	ff d0                	callq  *%rax
}
  802caf:	c9                   	leaveq 
  802cb0:	c3                   	retq   

0000000000802cb1 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802cb1:	55                   	push   %rbp
  802cb2:	48 89 e5             	mov    %rsp,%rbp
  802cb5:	48 83 ec 20          	sub    $0x20,%rsp
  802cb9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802cbd:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  802cc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cc4:	48 89 c7             	mov    %rax,%rdi
  802cc7:	48 b8 70 11 80 00 00 	movabs $0x801170,%rax
  802cce:	00 00 00 
  802cd1:	ff d0                	callq  *%rax
  802cd3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802cd8:	7e 0a                	jle    802ce4 <open+0x33>
  802cda:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802cdf:	e9 a5 00 00 00       	jmpq   802d89 <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  802ce4:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802ce8:	48 89 c7             	mov    %rax,%rdi
  802ceb:	48 b8 11 23 80 00 00 	movabs $0x802311,%rax
  802cf2:	00 00 00 
  802cf5:	ff d0                	callq  *%rax
  802cf7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cfa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cfe:	79 08                	jns    802d08 <open+0x57>
		return r;
  802d00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d03:	e9 81 00 00 00       	jmpq   802d89 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  802d08:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d0f:	00 00 00 
  802d12:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802d15:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  802d1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d1f:	48 89 c6             	mov    %rax,%rsi
  802d22:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802d29:	00 00 00 
  802d2c:	48 b8 dc 11 80 00 00 	movabs $0x8011dc,%rax
  802d33:	00 00 00 
  802d36:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  802d38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d3c:	48 89 c6             	mov    %rax,%rsi
  802d3f:	bf 01 00 00 00       	mov    $0x1,%edi
  802d44:	48 b8 2a 2c 80 00 00 	movabs $0x802c2a,%rax
  802d4b:	00 00 00 
  802d4e:	ff d0                	callq  *%rax
  802d50:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d53:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d57:	79 1d                	jns    802d76 <open+0xc5>
		fd_close(fd, 0);
  802d59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d5d:	be 00 00 00 00       	mov    $0x0,%esi
  802d62:	48 89 c7             	mov    %rax,%rdi
  802d65:	48 b8 39 24 80 00 00 	movabs $0x802439,%rax
  802d6c:	00 00 00 
  802d6f:	ff d0                	callq  *%rax
		return r;
  802d71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d74:	eb 13                	jmp    802d89 <open+0xd8>
	}
	return fd2num(fd);
  802d76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d7a:	48 89 c7             	mov    %rax,%rdi
  802d7d:	48 b8 c3 22 80 00 00 	movabs $0x8022c3,%rax
  802d84:	00 00 00 
  802d87:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  802d89:	c9                   	leaveq 
  802d8a:	c3                   	retq   

0000000000802d8b <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802d8b:	55                   	push   %rbp
  802d8c:	48 89 e5             	mov    %rsp,%rbp
  802d8f:	48 83 ec 10          	sub    $0x10,%rsp
  802d93:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802d97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d9b:	8b 50 0c             	mov    0xc(%rax),%edx
  802d9e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802da5:	00 00 00 
  802da8:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802daa:	be 00 00 00 00       	mov    $0x0,%esi
  802daf:	bf 06 00 00 00       	mov    $0x6,%edi
  802db4:	48 b8 2a 2c 80 00 00 	movabs $0x802c2a,%rax
  802dbb:	00 00 00 
  802dbe:	ff d0                	callq  *%rax
}
  802dc0:	c9                   	leaveq 
  802dc1:	c3                   	retq   

0000000000802dc2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802dc2:	55                   	push   %rbp
  802dc3:	48 89 e5             	mov    %rsp,%rbp
  802dc6:	48 83 ec 30          	sub    $0x30,%rsp
  802dca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802dce:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802dd2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802dd6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dda:	8b 50 0c             	mov    0xc(%rax),%edx
  802ddd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802de4:	00 00 00 
  802de7:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802de9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802df0:	00 00 00 
  802df3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802df7:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  802dfb:	be 00 00 00 00       	mov    $0x0,%esi
  802e00:	bf 03 00 00 00       	mov    $0x3,%edi
  802e05:	48 b8 2a 2c 80 00 00 	movabs $0x802c2a,%rax
  802e0c:	00 00 00 
  802e0f:	ff d0                	callq  *%rax
  802e11:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e14:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e18:	79 05                	jns    802e1f <devfile_read+0x5d>
		return r;
  802e1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e1d:	eb 26                	jmp    802e45 <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  802e1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e22:	48 63 d0             	movslq %eax,%rdx
  802e25:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e29:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802e30:	00 00 00 
  802e33:	48 89 c7             	mov    %rax,%rdi
  802e36:	48 b8 17 16 80 00 00 	movabs $0x801617,%rax
  802e3d:	00 00 00 
  802e40:	ff d0                	callq  *%rax
	return r;
  802e42:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802e45:	c9                   	leaveq 
  802e46:	c3                   	retq   

0000000000802e47 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802e47:	55                   	push   %rbp
  802e48:	48 89 e5             	mov    %rsp,%rbp
  802e4b:	48 83 ec 30          	sub    $0x30,%rsp
  802e4f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e53:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e57:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  802e5b:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  802e62:	00 
	n = n > max ? max : n;
  802e63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e67:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802e6b:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  802e70:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802e74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e78:	8b 50 0c             	mov    0xc(%rax),%edx
  802e7b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e82:	00 00 00 
  802e85:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802e87:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e8e:	00 00 00 
  802e91:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e95:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802e99:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e9d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ea1:	48 89 c6             	mov    %rax,%rsi
  802ea4:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802eab:	00 00 00 
  802eae:	48 b8 17 16 80 00 00 	movabs $0x801617,%rax
  802eb5:	00 00 00 
  802eb8:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  802eba:	be 00 00 00 00       	mov    $0x0,%esi
  802ebf:	bf 04 00 00 00       	mov    $0x4,%edi
  802ec4:	48 b8 2a 2c 80 00 00 	movabs $0x802c2a,%rax
  802ecb:	00 00 00 
  802ece:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  802ed0:	c9                   	leaveq 
  802ed1:	c3                   	retq   

0000000000802ed2 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802ed2:	55                   	push   %rbp
  802ed3:	48 89 e5             	mov    %rsp,%rbp
  802ed6:	48 83 ec 20          	sub    $0x20,%rsp
  802eda:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ede:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802ee2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ee6:	8b 50 0c             	mov    0xc(%rax),%edx
  802ee9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ef0:	00 00 00 
  802ef3:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802ef5:	be 00 00 00 00       	mov    $0x0,%esi
  802efa:	bf 05 00 00 00       	mov    $0x5,%edi
  802eff:	48 b8 2a 2c 80 00 00 	movabs $0x802c2a,%rax
  802f06:	00 00 00 
  802f09:	ff d0                	callq  *%rax
  802f0b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f12:	79 05                	jns    802f19 <devfile_stat+0x47>
		return r;
  802f14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f17:	eb 56                	jmp    802f6f <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802f19:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f1d:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802f24:	00 00 00 
  802f27:	48 89 c7             	mov    %rax,%rdi
  802f2a:	48 b8 dc 11 80 00 00 	movabs $0x8011dc,%rax
  802f31:	00 00 00 
  802f34:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802f36:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f3d:	00 00 00 
  802f40:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802f46:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f4a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802f50:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f57:	00 00 00 
  802f5a:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802f60:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f64:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802f6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f6f:	c9                   	leaveq 
  802f70:	c3                   	retq   

0000000000802f71 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802f71:	55                   	push   %rbp
  802f72:	48 89 e5             	mov    %rsp,%rbp
  802f75:	48 83 ec 10          	sub    $0x10,%rsp
  802f79:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f7d:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802f80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f84:	8b 50 0c             	mov    0xc(%rax),%edx
  802f87:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f8e:	00 00 00 
  802f91:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802f93:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f9a:	00 00 00 
  802f9d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802fa0:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802fa3:	be 00 00 00 00       	mov    $0x0,%esi
  802fa8:	bf 02 00 00 00       	mov    $0x2,%edi
  802fad:	48 b8 2a 2c 80 00 00 	movabs $0x802c2a,%rax
  802fb4:	00 00 00 
  802fb7:	ff d0                	callq  *%rax
}
  802fb9:	c9                   	leaveq 
  802fba:	c3                   	retq   

0000000000802fbb <remove>:

// Delete a file
int
remove(const char *path)
{
  802fbb:	55                   	push   %rbp
  802fbc:	48 89 e5             	mov    %rsp,%rbp
  802fbf:	48 83 ec 10          	sub    $0x10,%rsp
  802fc3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802fc7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fcb:	48 89 c7             	mov    %rax,%rdi
  802fce:	48 b8 70 11 80 00 00 	movabs $0x801170,%rax
  802fd5:	00 00 00 
  802fd8:	ff d0                	callq  *%rax
  802fda:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802fdf:	7e 07                	jle    802fe8 <remove+0x2d>
		return -E_BAD_PATH;
  802fe1:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802fe6:	eb 33                	jmp    80301b <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802fe8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fec:	48 89 c6             	mov    %rax,%rsi
  802fef:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802ff6:	00 00 00 
  802ff9:	48 b8 dc 11 80 00 00 	movabs $0x8011dc,%rax
  803000:	00 00 00 
  803003:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803005:	be 00 00 00 00       	mov    $0x0,%esi
  80300a:	bf 07 00 00 00       	mov    $0x7,%edi
  80300f:	48 b8 2a 2c 80 00 00 	movabs $0x802c2a,%rax
  803016:	00 00 00 
  803019:	ff d0                	callq  *%rax
}
  80301b:	c9                   	leaveq 
  80301c:	c3                   	retq   

000000000080301d <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80301d:	55                   	push   %rbp
  80301e:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803021:	be 00 00 00 00       	mov    $0x0,%esi
  803026:	bf 08 00 00 00       	mov    $0x8,%edi
  80302b:	48 b8 2a 2c 80 00 00 	movabs $0x802c2a,%rax
  803032:	00 00 00 
  803035:	ff d0                	callq  *%rax
}
  803037:	5d                   	pop    %rbp
  803038:	c3                   	retq   

0000000000803039 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803039:	55                   	push   %rbp
  80303a:	48 89 e5             	mov    %rsp,%rbp
  80303d:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803044:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80304b:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803052:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803059:	be 00 00 00 00       	mov    $0x0,%esi
  80305e:	48 89 c7             	mov    %rax,%rdi
  803061:	48 b8 b1 2c 80 00 00 	movabs $0x802cb1,%rax
  803068:	00 00 00 
  80306b:	ff d0                	callq  *%rax
  80306d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803070:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803074:	79 28                	jns    80309e <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803076:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803079:	89 c6                	mov    %eax,%esi
  80307b:	48 bf 0e 46 80 00 00 	movabs $0x80460e,%rdi
  803082:	00 00 00 
  803085:	b8 00 00 00 00       	mov    $0x0,%eax
  80308a:	48 ba 27 06 80 00 00 	movabs $0x800627,%rdx
  803091:	00 00 00 
  803094:	ff d2                	callq  *%rdx
		return fd_src;
  803096:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803099:	e9 74 01 00 00       	jmpq   803212 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80309e:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8030a5:	be 01 01 00 00       	mov    $0x101,%esi
  8030aa:	48 89 c7             	mov    %rax,%rdi
  8030ad:	48 b8 b1 2c 80 00 00 	movabs $0x802cb1,%rax
  8030b4:	00 00 00 
  8030b7:	ff d0                	callq  *%rax
  8030b9:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8030bc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8030c0:	79 39                	jns    8030fb <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8030c2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030c5:	89 c6                	mov    %eax,%esi
  8030c7:	48 bf 24 46 80 00 00 	movabs $0x804624,%rdi
  8030ce:	00 00 00 
  8030d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8030d6:	48 ba 27 06 80 00 00 	movabs $0x800627,%rdx
  8030dd:	00 00 00 
  8030e0:	ff d2                	callq  *%rdx
		close(fd_src);
  8030e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030e5:	89 c7                	mov    %eax,%edi
  8030e7:	48 b8 b9 25 80 00 00 	movabs $0x8025b9,%rax
  8030ee:	00 00 00 
  8030f1:	ff d0                	callq  *%rax
		return fd_dest;
  8030f3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030f6:	e9 17 01 00 00       	jmpq   803212 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8030fb:	eb 74                	jmp    803171 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8030fd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803100:	48 63 d0             	movslq %eax,%rdx
  803103:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80310a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80310d:	48 89 ce             	mov    %rcx,%rsi
  803110:	89 c7                	mov    %eax,%edi
  803112:	48 b8 25 29 80 00 00 	movabs $0x802925,%rax
  803119:	00 00 00 
  80311c:	ff d0                	callq  *%rax
  80311e:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803121:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803125:	79 4a                	jns    803171 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803127:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80312a:	89 c6                	mov    %eax,%esi
  80312c:	48 bf 3e 46 80 00 00 	movabs $0x80463e,%rdi
  803133:	00 00 00 
  803136:	b8 00 00 00 00       	mov    $0x0,%eax
  80313b:	48 ba 27 06 80 00 00 	movabs $0x800627,%rdx
  803142:	00 00 00 
  803145:	ff d2                	callq  *%rdx
			close(fd_src);
  803147:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80314a:	89 c7                	mov    %eax,%edi
  80314c:	48 b8 b9 25 80 00 00 	movabs $0x8025b9,%rax
  803153:	00 00 00 
  803156:	ff d0                	callq  *%rax
			close(fd_dest);
  803158:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80315b:	89 c7                	mov    %eax,%edi
  80315d:	48 b8 b9 25 80 00 00 	movabs $0x8025b9,%rax
  803164:	00 00 00 
  803167:	ff d0                	callq  *%rax
			return write_size;
  803169:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80316c:	e9 a1 00 00 00       	jmpq   803212 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803171:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803178:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80317b:	ba 00 02 00 00       	mov    $0x200,%edx
  803180:	48 89 ce             	mov    %rcx,%rsi
  803183:	89 c7                	mov    %eax,%edi
  803185:	48 b8 db 27 80 00 00 	movabs $0x8027db,%rax
  80318c:	00 00 00 
  80318f:	ff d0                	callq  *%rax
  803191:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803194:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803198:	0f 8f 5f ff ff ff    	jg     8030fd <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80319e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8031a2:	79 47                	jns    8031eb <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8031a4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8031a7:	89 c6                	mov    %eax,%esi
  8031a9:	48 bf 51 46 80 00 00 	movabs $0x804651,%rdi
  8031b0:	00 00 00 
  8031b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8031b8:	48 ba 27 06 80 00 00 	movabs $0x800627,%rdx
  8031bf:	00 00 00 
  8031c2:	ff d2                	callq  *%rdx
		close(fd_src);
  8031c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031c7:	89 c7                	mov    %eax,%edi
  8031c9:	48 b8 b9 25 80 00 00 	movabs $0x8025b9,%rax
  8031d0:	00 00 00 
  8031d3:	ff d0                	callq  *%rax
		close(fd_dest);
  8031d5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031d8:	89 c7                	mov    %eax,%edi
  8031da:	48 b8 b9 25 80 00 00 	movabs $0x8025b9,%rax
  8031e1:	00 00 00 
  8031e4:	ff d0                	callq  *%rax
		return read_size;
  8031e6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8031e9:	eb 27                	jmp    803212 <copy+0x1d9>
	}
	close(fd_src);
  8031eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031ee:	89 c7                	mov    %eax,%edi
  8031f0:	48 b8 b9 25 80 00 00 	movabs $0x8025b9,%rax
  8031f7:	00 00 00 
  8031fa:	ff d0                	callq  *%rax
	close(fd_dest);
  8031fc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031ff:	89 c7                	mov    %eax,%edi
  803201:	48 b8 b9 25 80 00 00 	movabs $0x8025b9,%rax
  803208:	00 00 00 
  80320b:	ff d0                	callq  *%rax
	return 0;
  80320d:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803212:	c9                   	leaveq 
  803213:	c3                   	retq   

0000000000803214 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803214:	55                   	push   %rbp
  803215:	48 89 e5             	mov    %rsp,%rbp
  803218:	53                   	push   %rbx
  803219:	48 83 ec 38          	sub    $0x38,%rsp
  80321d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803221:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803225:	48 89 c7             	mov    %rax,%rdi
  803228:	48 b8 11 23 80 00 00 	movabs $0x802311,%rax
  80322f:	00 00 00 
  803232:	ff d0                	callq  *%rax
  803234:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803237:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80323b:	0f 88 bf 01 00 00    	js     803400 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803241:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803245:	ba 07 04 00 00       	mov    $0x407,%edx
  80324a:	48 89 c6             	mov    %rax,%rsi
  80324d:	bf 00 00 00 00       	mov    $0x0,%edi
  803252:	48 b8 0b 1b 80 00 00 	movabs $0x801b0b,%rax
  803259:	00 00 00 
  80325c:	ff d0                	callq  *%rax
  80325e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803261:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803265:	0f 88 95 01 00 00    	js     803400 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80326b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80326f:	48 89 c7             	mov    %rax,%rdi
  803272:	48 b8 11 23 80 00 00 	movabs $0x802311,%rax
  803279:	00 00 00 
  80327c:	ff d0                	callq  *%rax
  80327e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803281:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803285:	0f 88 5d 01 00 00    	js     8033e8 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80328b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80328f:	ba 07 04 00 00       	mov    $0x407,%edx
  803294:	48 89 c6             	mov    %rax,%rsi
  803297:	bf 00 00 00 00       	mov    $0x0,%edi
  80329c:	48 b8 0b 1b 80 00 00 	movabs $0x801b0b,%rax
  8032a3:	00 00 00 
  8032a6:	ff d0                	callq  *%rax
  8032a8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032af:	0f 88 33 01 00 00    	js     8033e8 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8032b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032b9:	48 89 c7             	mov    %rax,%rdi
  8032bc:	48 b8 e6 22 80 00 00 	movabs $0x8022e6,%rax
  8032c3:	00 00 00 
  8032c6:	ff d0                	callq  *%rax
  8032c8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032d0:	ba 07 04 00 00       	mov    $0x407,%edx
  8032d5:	48 89 c6             	mov    %rax,%rsi
  8032d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8032dd:	48 b8 0b 1b 80 00 00 	movabs $0x801b0b,%rax
  8032e4:	00 00 00 
  8032e7:	ff d0                	callq  *%rax
  8032e9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032f0:	79 05                	jns    8032f7 <pipe+0xe3>
		goto err2;
  8032f2:	e9 d9 00 00 00       	jmpq   8033d0 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032fb:	48 89 c7             	mov    %rax,%rdi
  8032fe:	48 b8 e6 22 80 00 00 	movabs $0x8022e6,%rax
  803305:	00 00 00 
  803308:	ff d0                	callq  *%rax
  80330a:	48 89 c2             	mov    %rax,%rdx
  80330d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803311:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803317:	48 89 d1             	mov    %rdx,%rcx
  80331a:	ba 00 00 00 00       	mov    $0x0,%edx
  80331f:	48 89 c6             	mov    %rax,%rsi
  803322:	bf 00 00 00 00       	mov    $0x0,%edi
  803327:	48 b8 5b 1b 80 00 00 	movabs $0x801b5b,%rax
  80332e:	00 00 00 
  803331:	ff d0                	callq  *%rax
  803333:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803336:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80333a:	79 1b                	jns    803357 <pipe+0x143>
		goto err3;
  80333c:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80333d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803341:	48 89 c6             	mov    %rax,%rsi
  803344:	bf 00 00 00 00       	mov    $0x0,%edi
  803349:	48 b8 b6 1b 80 00 00 	movabs $0x801bb6,%rax
  803350:	00 00 00 
  803353:	ff d0                	callq  *%rax
  803355:	eb 79                	jmp    8033d0 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803357:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80335b:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803362:	00 00 00 
  803365:	8b 12                	mov    (%rdx),%edx
  803367:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803369:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80336d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803374:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803378:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  80337f:	00 00 00 
  803382:	8b 12                	mov    (%rdx),%edx
  803384:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803386:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80338a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803391:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803395:	48 89 c7             	mov    %rax,%rdi
  803398:	48 b8 c3 22 80 00 00 	movabs $0x8022c3,%rax
  80339f:	00 00 00 
  8033a2:	ff d0                	callq  *%rax
  8033a4:	89 c2                	mov    %eax,%edx
  8033a6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8033aa:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8033ac:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8033b0:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8033b4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033b8:	48 89 c7             	mov    %rax,%rdi
  8033bb:	48 b8 c3 22 80 00 00 	movabs $0x8022c3,%rax
  8033c2:	00 00 00 
  8033c5:	ff d0                	callq  *%rax
  8033c7:	89 03                	mov    %eax,(%rbx)
	return 0;
  8033c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8033ce:	eb 33                	jmp    803403 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8033d0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033d4:	48 89 c6             	mov    %rax,%rsi
  8033d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8033dc:	48 b8 b6 1b 80 00 00 	movabs $0x801bb6,%rax
  8033e3:	00 00 00 
  8033e6:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8033e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033ec:	48 89 c6             	mov    %rax,%rsi
  8033ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8033f4:	48 b8 b6 1b 80 00 00 	movabs $0x801bb6,%rax
  8033fb:	00 00 00 
  8033fe:	ff d0                	callq  *%rax
err:
	return r;
  803400:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803403:	48 83 c4 38          	add    $0x38,%rsp
  803407:	5b                   	pop    %rbx
  803408:	5d                   	pop    %rbp
  803409:	c3                   	retq   

000000000080340a <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80340a:	55                   	push   %rbp
  80340b:	48 89 e5             	mov    %rsp,%rbp
  80340e:	53                   	push   %rbx
  80340f:	48 83 ec 28          	sub    $0x28,%rsp
  803413:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803417:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80341b:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803422:	00 00 00 
  803425:	48 8b 00             	mov    (%rax),%rax
  803428:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80342e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803431:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803435:	48 89 c7             	mov    %rax,%rdi
  803438:	48 b8 31 3e 80 00 00 	movabs $0x803e31,%rax
  80343f:	00 00 00 
  803442:	ff d0                	callq  *%rax
  803444:	89 c3                	mov    %eax,%ebx
  803446:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80344a:	48 89 c7             	mov    %rax,%rdi
  80344d:	48 b8 31 3e 80 00 00 	movabs $0x803e31,%rax
  803454:	00 00 00 
  803457:	ff d0                	callq  *%rax
  803459:	39 c3                	cmp    %eax,%ebx
  80345b:	0f 94 c0             	sete   %al
  80345e:	0f b6 c0             	movzbl %al,%eax
  803461:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803464:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  80346b:	00 00 00 
  80346e:	48 8b 00             	mov    (%rax),%rax
  803471:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803477:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80347a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80347d:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803480:	75 05                	jne    803487 <_pipeisclosed+0x7d>
			return ret;
  803482:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803485:	eb 4f                	jmp    8034d6 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803487:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80348a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80348d:	74 42                	je     8034d1 <_pipeisclosed+0xc7>
  80348f:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803493:	75 3c                	jne    8034d1 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803495:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  80349c:	00 00 00 
  80349f:	48 8b 00             	mov    (%rax),%rax
  8034a2:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8034a8:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8034ab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034ae:	89 c6                	mov    %eax,%esi
  8034b0:	48 bf 6c 46 80 00 00 	movabs $0x80466c,%rdi
  8034b7:	00 00 00 
  8034ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8034bf:	49 b8 27 06 80 00 00 	movabs $0x800627,%r8
  8034c6:	00 00 00 
  8034c9:	41 ff d0             	callq  *%r8
	}
  8034cc:	e9 4a ff ff ff       	jmpq   80341b <_pipeisclosed+0x11>
  8034d1:	e9 45 ff ff ff       	jmpq   80341b <_pipeisclosed+0x11>
}
  8034d6:	48 83 c4 28          	add    $0x28,%rsp
  8034da:	5b                   	pop    %rbx
  8034db:	5d                   	pop    %rbp
  8034dc:	c3                   	retq   

00000000008034dd <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8034dd:	55                   	push   %rbp
  8034de:	48 89 e5             	mov    %rsp,%rbp
  8034e1:	48 83 ec 30          	sub    $0x30,%rsp
  8034e5:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8034e8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8034ec:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8034ef:	48 89 d6             	mov    %rdx,%rsi
  8034f2:	89 c7                	mov    %eax,%edi
  8034f4:	48 b8 a9 23 80 00 00 	movabs $0x8023a9,%rax
  8034fb:	00 00 00 
  8034fe:	ff d0                	callq  *%rax
  803500:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803503:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803507:	79 05                	jns    80350e <pipeisclosed+0x31>
		return r;
  803509:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80350c:	eb 31                	jmp    80353f <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80350e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803512:	48 89 c7             	mov    %rax,%rdi
  803515:	48 b8 e6 22 80 00 00 	movabs $0x8022e6,%rax
  80351c:	00 00 00 
  80351f:	ff d0                	callq  *%rax
  803521:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803525:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803529:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80352d:	48 89 d6             	mov    %rdx,%rsi
  803530:	48 89 c7             	mov    %rax,%rdi
  803533:	48 b8 0a 34 80 00 00 	movabs $0x80340a,%rax
  80353a:	00 00 00 
  80353d:	ff d0                	callq  *%rax
}
  80353f:	c9                   	leaveq 
  803540:	c3                   	retq   

0000000000803541 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803541:	55                   	push   %rbp
  803542:	48 89 e5             	mov    %rsp,%rbp
  803545:	48 83 ec 40          	sub    $0x40,%rsp
  803549:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80354d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803551:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803555:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803559:	48 89 c7             	mov    %rax,%rdi
  80355c:	48 b8 e6 22 80 00 00 	movabs $0x8022e6,%rax
  803563:	00 00 00 
  803566:	ff d0                	callq  *%rax
  803568:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80356c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803570:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803574:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80357b:	00 
  80357c:	e9 92 00 00 00       	jmpq   803613 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803581:	eb 41                	jmp    8035c4 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803583:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803588:	74 09                	je     803593 <devpipe_read+0x52>
				return i;
  80358a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80358e:	e9 92 00 00 00       	jmpq   803625 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803593:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803597:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80359b:	48 89 d6             	mov    %rdx,%rsi
  80359e:	48 89 c7             	mov    %rax,%rdi
  8035a1:	48 b8 0a 34 80 00 00 	movabs $0x80340a,%rax
  8035a8:	00 00 00 
  8035ab:	ff d0                	callq  *%rax
  8035ad:	85 c0                	test   %eax,%eax
  8035af:	74 07                	je     8035b8 <devpipe_read+0x77>
				return 0;
  8035b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b6:	eb 6d                	jmp    803625 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8035b8:	48 b8 cd 1a 80 00 00 	movabs $0x801acd,%rax
  8035bf:	00 00 00 
  8035c2:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8035c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035c8:	8b 10                	mov    (%rax),%edx
  8035ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035ce:	8b 40 04             	mov    0x4(%rax),%eax
  8035d1:	39 c2                	cmp    %eax,%edx
  8035d3:	74 ae                	je     803583 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8035d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8035dd:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8035e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035e5:	8b 00                	mov    (%rax),%eax
  8035e7:	99                   	cltd   
  8035e8:	c1 ea 1b             	shr    $0x1b,%edx
  8035eb:	01 d0                	add    %edx,%eax
  8035ed:	83 e0 1f             	and    $0x1f,%eax
  8035f0:	29 d0                	sub    %edx,%eax
  8035f2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035f6:	48 98                	cltq   
  8035f8:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8035fd:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8035ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803603:	8b 00                	mov    (%rax),%eax
  803605:	8d 50 01             	lea    0x1(%rax),%edx
  803608:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80360c:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80360e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803613:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803617:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80361b:	0f 82 60 ff ff ff    	jb     803581 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803621:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803625:	c9                   	leaveq 
  803626:	c3                   	retq   

0000000000803627 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803627:	55                   	push   %rbp
  803628:	48 89 e5             	mov    %rsp,%rbp
  80362b:	48 83 ec 40          	sub    $0x40,%rsp
  80362f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803633:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803637:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80363b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80363f:	48 89 c7             	mov    %rax,%rdi
  803642:	48 b8 e6 22 80 00 00 	movabs $0x8022e6,%rax
  803649:	00 00 00 
  80364c:	ff d0                	callq  *%rax
  80364e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803652:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803656:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80365a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803661:	00 
  803662:	e9 8e 00 00 00       	jmpq   8036f5 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803667:	eb 31                	jmp    80369a <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803669:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80366d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803671:	48 89 d6             	mov    %rdx,%rsi
  803674:	48 89 c7             	mov    %rax,%rdi
  803677:	48 b8 0a 34 80 00 00 	movabs $0x80340a,%rax
  80367e:	00 00 00 
  803681:	ff d0                	callq  *%rax
  803683:	85 c0                	test   %eax,%eax
  803685:	74 07                	je     80368e <devpipe_write+0x67>
				return 0;
  803687:	b8 00 00 00 00       	mov    $0x0,%eax
  80368c:	eb 79                	jmp    803707 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80368e:	48 b8 cd 1a 80 00 00 	movabs $0x801acd,%rax
  803695:	00 00 00 
  803698:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80369a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80369e:	8b 40 04             	mov    0x4(%rax),%eax
  8036a1:	48 63 d0             	movslq %eax,%rdx
  8036a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036a8:	8b 00                	mov    (%rax),%eax
  8036aa:	48 98                	cltq   
  8036ac:	48 83 c0 20          	add    $0x20,%rax
  8036b0:	48 39 c2             	cmp    %rax,%rdx
  8036b3:	73 b4                	jae    803669 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8036b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036b9:	8b 40 04             	mov    0x4(%rax),%eax
  8036bc:	99                   	cltd   
  8036bd:	c1 ea 1b             	shr    $0x1b,%edx
  8036c0:	01 d0                	add    %edx,%eax
  8036c2:	83 e0 1f             	and    $0x1f,%eax
  8036c5:	29 d0                	sub    %edx,%eax
  8036c7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8036cb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8036cf:	48 01 ca             	add    %rcx,%rdx
  8036d2:	0f b6 0a             	movzbl (%rdx),%ecx
  8036d5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036d9:	48 98                	cltq   
  8036db:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8036df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036e3:	8b 40 04             	mov    0x4(%rax),%eax
  8036e6:	8d 50 01             	lea    0x1(%rax),%edx
  8036e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036ed:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8036f0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8036f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036f9:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8036fd:	0f 82 64 ff ff ff    	jb     803667 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803703:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803707:	c9                   	leaveq 
  803708:	c3                   	retq   

0000000000803709 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803709:	55                   	push   %rbp
  80370a:	48 89 e5             	mov    %rsp,%rbp
  80370d:	48 83 ec 20          	sub    $0x20,%rsp
  803711:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803715:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803719:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80371d:	48 89 c7             	mov    %rax,%rdi
  803720:	48 b8 e6 22 80 00 00 	movabs $0x8022e6,%rax
  803727:	00 00 00 
  80372a:	ff d0                	callq  *%rax
  80372c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803730:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803734:	48 be 7f 46 80 00 00 	movabs $0x80467f,%rsi
  80373b:	00 00 00 
  80373e:	48 89 c7             	mov    %rax,%rdi
  803741:	48 b8 dc 11 80 00 00 	movabs $0x8011dc,%rax
  803748:	00 00 00 
  80374b:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80374d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803751:	8b 50 04             	mov    0x4(%rax),%edx
  803754:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803758:	8b 00                	mov    (%rax),%eax
  80375a:	29 c2                	sub    %eax,%edx
  80375c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803760:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803766:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80376a:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803771:	00 00 00 
	stat->st_dev = &devpipe;
  803774:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803778:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  80377f:	00 00 00 
  803782:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803789:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80378e:	c9                   	leaveq 
  80378f:	c3                   	retq   

0000000000803790 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803790:	55                   	push   %rbp
  803791:	48 89 e5             	mov    %rsp,%rbp
  803794:	48 83 ec 10          	sub    $0x10,%rsp
  803798:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80379c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037a0:	48 89 c6             	mov    %rax,%rsi
  8037a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8037a8:	48 b8 b6 1b 80 00 00 	movabs $0x801bb6,%rax
  8037af:	00 00 00 
  8037b2:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8037b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037b8:	48 89 c7             	mov    %rax,%rdi
  8037bb:	48 b8 e6 22 80 00 00 	movabs $0x8022e6,%rax
  8037c2:	00 00 00 
  8037c5:	ff d0                	callq  *%rax
  8037c7:	48 89 c6             	mov    %rax,%rsi
  8037ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8037cf:	48 b8 b6 1b 80 00 00 	movabs $0x801bb6,%rax
  8037d6:	00 00 00 
  8037d9:	ff d0                	callq  *%rax
}
  8037db:	c9                   	leaveq 
  8037dc:	c3                   	retq   

00000000008037dd <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8037dd:	55                   	push   %rbp
  8037de:	48 89 e5             	mov    %rsp,%rbp
  8037e1:	48 83 ec 20          	sub    $0x20,%rsp
  8037e5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  8037e8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037ec:	75 35                	jne    803823 <wait+0x46>
  8037ee:	48 b9 86 46 80 00 00 	movabs $0x804686,%rcx
  8037f5:	00 00 00 
  8037f8:	48 ba 91 46 80 00 00 	movabs $0x804691,%rdx
  8037ff:	00 00 00 
  803802:	be 09 00 00 00       	mov    $0x9,%esi
  803807:	48 bf a6 46 80 00 00 	movabs $0x8046a6,%rdi
  80380e:	00 00 00 
  803811:	b8 00 00 00 00       	mov    $0x0,%eax
  803816:	49 b8 ee 03 80 00 00 	movabs $0x8003ee,%r8
  80381d:	00 00 00 
  803820:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  803823:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803826:	25 ff 03 00 00       	and    $0x3ff,%eax
  80382b:	48 63 d0             	movslq %eax,%rdx
  80382e:	48 89 d0             	mov    %rdx,%rax
  803831:	48 c1 e0 03          	shl    $0x3,%rax
  803835:	48 01 d0             	add    %rdx,%rax
  803838:	48 c1 e0 05          	shl    $0x5,%rax
  80383c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803843:	00 00 00 
  803846:	48 01 d0             	add    %rdx,%rax
  803849:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80384d:	eb 0c                	jmp    80385b <wait+0x7e>
		sys_yield();
  80384f:	48 b8 cd 1a 80 00 00 	movabs $0x801acd,%rax
  803856:	00 00 00 
  803859:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80385b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80385f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803865:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803868:	75 0e                	jne    803878 <wait+0x9b>
  80386a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80386e:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803874:	85 c0                	test   %eax,%eax
  803876:	75 d7                	jne    80384f <wait+0x72>
		sys_yield();
}
  803878:	c9                   	leaveq 
  803879:	c3                   	retq   

000000000080387a <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80387a:	55                   	push   %rbp
  80387b:	48 89 e5             	mov    %rsp,%rbp
  80387e:	48 83 ec 20          	sub    $0x20,%rsp
  803882:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803885:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803888:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80388b:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80388f:	be 01 00 00 00       	mov    $0x1,%esi
  803894:	48 89 c7             	mov    %rax,%rdi
  803897:	48 b8 c3 19 80 00 00 	movabs $0x8019c3,%rax
  80389e:	00 00 00 
  8038a1:	ff d0                	callq  *%rax
}
  8038a3:	c9                   	leaveq 
  8038a4:	c3                   	retq   

00000000008038a5 <getchar>:

int
getchar(void)
{
  8038a5:	55                   	push   %rbp
  8038a6:	48 89 e5             	mov    %rsp,%rbp
  8038a9:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8038ad:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8038b1:	ba 01 00 00 00       	mov    $0x1,%edx
  8038b6:	48 89 c6             	mov    %rax,%rsi
  8038b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8038be:	48 b8 db 27 80 00 00 	movabs $0x8027db,%rax
  8038c5:	00 00 00 
  8038c8:	ff d0                	callq  *%rax
  8038ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8038cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038d1:	79 05                	jns    8038d8 <getchar+0x33>
		return r;
  8038d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038d6:	eb 14                	jmp    8038ec <getchar+0x47>
	if (r < 1)
  8038d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038dc:	7f 07                	jg     8038e5 <getchar+0x40>
		return -E_EOF;
  8038de:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8038e3:	eb 07                	jmp    8038ec <getchar+0x47>
	return c;
  8038e5:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8038e9:	0f b6 c0             	movzbl %al,%eax
}
  8038ec:	c9                   	leaveq 
  8038ed:	c3                   	retq   

00000000008038ee <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8038ee:	55                   	push   %rbp
  8038ef:	48 89 e5             	mov    %rsp,%rbp
  8038f2:	48 83 ec 20          	sub    $0x20,%rsp
  8038f6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8038f9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8038fd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803900:	48 89 d6             	mov    %rdx,%rsi
  803903:	89 c7                	mov    %eax,%edi
  803905:	48 b8 a9 23 80 00 00 	movabs $0x8023a9,%rax
  80390c:	00 00 00 
  80390f:	ff d0                	callq  *%rax
  803911:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803914:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803918:	79 05                	jns    80391f <iscons+0x31>
		return r;
  80391a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80391d:	eb 1a                	jmp    803939 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80391f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803923:	8b 10                	mov    (%rax),%edx
  803925:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  80392c:	00 00 00 
  80392f:	8b 00                	mov    (%rax),%eax
  803931:	39 c2                	cmp    %eax,%edx
  803933:	0f 94 c0             	sete   %al
  803936:	0f b6 c0             	movzbl %al,%eax
}
  803939:	c9                   	leaveq 
  80393a:	c3                   	retq   

000000000080393b <opencons>:

int
opencons(void)
{
  80393b:	55                   	push   %rbp
  80393c:	48 89 e5             	mov    %rsp,%rbp
  80393f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803943:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803947:	48 89 c7             	mov    %rax,%rdi
  80394a:	48 b8 11 23 80 00 00 	movabs $0x802311,%rax
  803951:	00 00 00 
  803954:	ff d0                	callq  *%rax
  803956:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803959:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80395d:	79 05                	jns    803964 <opencons+0x29>
		return r;
  80395f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803962:	eb 5b                	jmp    8039bf <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803964:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803968:	ba 07 04 00 00       	mov    $0x407,%edx
  80396d:	48 89 c6             	mov    %rax,%rsi
  803970:	bf 00 00 00 00       	mov    $0x0,%edi
  803975:	48 b8 0b 1b 80 00 00 	movabs $0x801b0b,%rax
  80397c:	00 00 00 
  80397f:	ff d0                	callq  *%rax
  803981:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803984:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803988:	79 05                	jns    80398f <opencons+0x54>
		return r;
  80398a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80398d:	eb 30                	jmp    8039bf <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80398f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803993:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  80399a:	00 00 00 
  80399d:	8b 12                	mov    (%rdx),%edx
  80399f:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8039a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039a5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8039ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039b0:	48 89 c7             	mov    %rax,%rdi
  8039b3:	48 b8 c3 22 80 00 00 	movabs $0x8022c3,%rax
  8039ba:	00 00 00 
  8039bd:	ff d0                	callq  *%rax
}
  8039bf:	c9                   	leaveq 
  8039c0:	c3                   	retq   

00000000008039c1 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8039c1:	55                   	push   %rbp
  8039c2:	48 89 e5             	mov    %rsp,%rbp
  8039c5:	48 83 ec 30          	sub    $0x30,%rsp
  8039c9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039cd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8039d1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8039d5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8039da:	75 07                	jne    8039e3 <devcons_read+0x22>
		return 0;
  8039dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8039e1:	eb 4b                	jmp    803a2e <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8039e3:	eb 0c                	jmp    8039f1 <devcons_read+0x30>
		sys_yield();
  8039e5:	48 b8 cd 1a 80 00 00 	movabs $0x801acd,%rax
  8039ec:	00 00 00 
  8039ef:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8039f1:	48 b8 0d 1a 80 00 00 	movabs $0x801a0d,%rax
  8039f8:	00 00 00 
  8039fb:	ff d0                	callq  *%rax
  8039fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a00:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a04:	74 df                	je     8039e5 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803a06:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a0a:	79 05                	jns    803a11 <devcons_read+0x50>
		return c;
  803a0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a0f:	eb 1d                	jmp    803a2e <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803a11:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803a15:	75 07                	jne    803a1e <devcons_read+0x5d>
		return 0;
  803a17:	b8 00 00 00 00       	mov    $0x0,%eax
  803a1c:	eb 10                	jmp    803a2e <devcons_read+0x6d>
	*(char*)vbuf = c;
  803a1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a21:	89 c2                	mov    %eax,%edx
  803a23:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a27:	88 10                	mov    %dl,(%rax)
	return 1;
  803a29:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803a2e:	c9                   	leaveq 
  803a2f:	c3                   	retq   

0000000000803a30 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a30:	55                   	push   %rbp
  803a31:	48 89 e5             	mov    %rsp,%rbp
  803a34:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803a3b:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803a42:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803a49:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803a50:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803a57:	eb 76                	jmp    803acf <devcons_write+0x9f>
		m = n - tot;
  803a59:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803a60:	89 c2                	mov    %eax,%edx
  803a62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a65:	29 c2                	sub    %eax,%edx
  803a67:	89 d0                	mov    %edx,%eax
  803a69:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803a6c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a6f:	83 f8 7f             	cmp    $0x7f,%eax
  803a72:	76 07                	jbe    803a7b <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803a74:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803a7b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a7e:	48 63 d0             	movslq %eax,%rdx
  803a81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a84:	48 63 c8             	movslq %eax,%rcx
  803a87:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803a8e:	48 01 c1             	add    %rax,%rcx
  803a91:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803a98:	48 89 ce             	mov    %rcx,%rsi
  803a9b:	48 89 c7             	mov    %rax,%rdi
  803a9e:	48 b8 00 15 80 00 00 	movabs $0x801500,%rax
  803aa5:	00 00 00 
  803aa8:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803aaa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803aad:	48 63 d0             	movslq %eax,%rdx
  803ab0:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803ab7:	48 89 d6             	mov    %rdx,%rsi
  803aba:	48 89 c7             	mov    %rax,%rdi
  803abd:	48 b8 c3 19 80 00 00 	movabs $0x8019c3,%rax
  803ac4:	00 00 00 
  803ac7:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803ac9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803acc:	01 45 fc             	add    %eax,-0x4(%rbp)
  803acf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ad2:	48 98                	cltq   
  803ad4:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803adb:	0f 82 78 ff ff ff    	jb     803a59 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803ae1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ae4:	c9                   	leaveq 
  803ae5:	c3                   	retq   

0000000000803ae6 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803ae6:	55                   	push   %rbp
  803ae7:	48 89 e5             	mov    %rsp,%rbp
  803aea:	48 83 ec 08          	sub    $0x8,%rsp
  803aee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803af2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803af7:	c9                   	leaveq 
  803af8:	c3                   	retq   

0000000000803af9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803af9:	55                   	push   %rbp
  803afa:	48 89 e5             	mov    %rsp,%rbp
  803afd:	48 83 ec 10          	sub    $0x10,%rsp
  803b01:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803b05:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803b09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b0d:	48 be b6 46 80 00 00 	movabs $0x8046b6,%rsi
  803b14:	00 00 00 
  803b17:	48 89 c7             	mov    %rax,%rdi
  803b1a:	48 b8 dc 11 80 00 00 	movabs $0x8011dc,%rax
  803b21:	00 00 00 
  803b24:	ff d0                	callq  *%rax
	return 0;
  803b26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b2b:	c9                   	leaveq 
  803b2c:	c3                   	retq   

0000000000803b2d <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803b2d:	55                   	push   %rbp
  803b2e:	48 89 e5             	mov    %rsp,%rbp
  803b31:	48 83 ec 10          	sub    $0x10,%rsp
  803b35:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  803b39:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803b40:	00 00 00 
  803b43:	48 8b 00             	mov    (%rax),%rax
  803b46:	48 85 c0             	test   %rax,%rax
  803b49:	75 64                	jne    803baf <set_pgfault_handler+0x82>
		// First time through!
		// LAB 4: Your code here.
		//envid_t eid = sys_getenvid();
		if(sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) 
  803b4b:	ba 07 00 00 00       	mov    $0x7,%edx
  803b50:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803b55:	bf 00 00 00 00       	mov    $0x0,%edi
  803b5a:	48 b8 0b 1b 80 00 00 	movabs $0x801b0b,%rax
  803b61:	00 00 00 
  803b64:	ff d0                	callq  *%rax
  803b66:	85 c0                	test   %eax,%eax
  803b68:	74 2a                	je     803b94 <set_pgfault_handler+0x67>
			panic("Allocation of space for UXSTACK failed\n");
  803b6a:	48 ba c0 46 80 00 00 	movabs $0x8046c0,%rdx
  803b71:	00 00 00 
  803b74:	be 22 00 00 00       	mov    $0x22,%esi
  803b79:	48 bf e8 46 80 00 00 	movabs $0x8046e8,%rdi
  803b80:	00 00 00 
  803b83:	b8 00 00 00 00       	mov    $0x0,%eax
  803b88:	48 b9 ee 03 80 00 00 	movabs $0x8003ee,%rcx
  803b8f:	00 00 00 
  803b92:	ff d1                	callq  *%rcx
		else
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  803b94:	48 be c2 3b 80 00 00 	movabs $0x803bc2,%rsi
  803b9b:	00 00 00 
  803b9e:	bf 00 00 00 00       	mov    $0x0,%edi
  803ba3:	48 b8 95 1c 80 00 00 	movabs $0x801c95,%rax
  803baa:	00 00 00 
  803bad:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803baf:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803bb6:	00 00 00 
  803bb9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803bbd:	48 89 10             	mov    %rdx,(%rax)
}
  803bc0:	c9                   	leaveq 
  803bc1:	c3                   	retq   

0000000000803bc2 <_pgfault_upcall>:
// Call the C page fault handler.
// function argument: pointer to UTF



movq  %rsp,%rdi                // passing the function argument in rdi
  803bc2:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  803bc5:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803bcc:	00 00 00 
call *%rax
  803bcf:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
mov 152(%rsp), %r8
  803bd1:	4c 8b 84 24 98 00 00 	mov    0x98(%rsp),%r8
  803bd8:	00 
mov 136(%rsp), %r9
  803bd9:	4c 8b 8c 24 88 00 00 	mov    0x88(%rsp),%r9
  803be0:	00 
sub $8, %r8
  803be1:	49 83 e8 08          	sub    $0x8,%r8
mov %r9, (%r8)
  803be5:	4d 89 08             	mov    %r9,(%r8)
mov %r8, 152(%rsp)
  803be8:	4c 89 84 24 98 00 00 	mov    %r8,0x98(%rsp)
  803bef:	00 
add $16, %rsp
  803bf0:	48 83 c4 10          	add    $0x10,%rsp

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
POPA_
  803bf4:	4c 8b 3c 24          	mov    (%rsp),%r15
  803bf8:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803bfd:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803c02:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803c07:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803c0c:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803c11:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803c16:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803c1b:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803c20:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803c25:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803c2a:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803c2f:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803c34:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803c39:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803c3e:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
		// LAB 4: Your code here.
add $8, %rsp
  803c42:	48 83 c4 08          	add    $0x8,%rsp
popf
  803c46:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
mov (%rsp), %rsp
  803c47:	48 8b 24 24          	mov    (%rsp),%rsp
    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
ret
  803c4b:	c3                   	retq   

0000000000803c4c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803c4c:	55                   	push   %rbp
  803c4d:	48 89 e5             	mov    %rsp,%rbp
  803c50:	48 83 ec 30          	sub    $0x30,%rsp
  803c54:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c58:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c5c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  803c60:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803c65:	74 18                	je     803c7f <ipc_recv+0x33>
  803c67:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c6b:	48 89 c7             	mov    %rax,%rdi
  803c6e:	48 b8 34 1d 80 00 00 	movabs $0x801d34,%rax
  803c75:	00 00 00 
  803c78:	ff d0                	callq  *%rax
  803c7a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c7d:	eb 19                	jmp    803c98 <ipc_recv+0x4c>
  803c7f:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  803c86:	00 00 00 
  803c89:	48 b8 34 1d 80 00 00 	movabs $0x801d34,%rax
  803c90:	00 00 00 
  803c93:	ff d0                	callq  *%rax
  803c95:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  803c98:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803c9d:	74 26                	je     803cc5 <ipc_recv+0x79>
  803c9f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ca3:	75 15                	jne    803cba <ipc_recv+0x6e>
  803ca5:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803cac:	00 00 00 
  803caf:	48 8b 00             	mov    (%rax),%rax
  803cb2:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  803cb8:	eb 05                	jmp    803cbf <ipc_recv+0x73>
  803cba:	b8 00 00 00 00       	mov    $0x0,%eax
  803cbf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803cc3:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  803cc5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803cca:	74 26                	je     803cf2 <ipc_recv+0xa6>
  803ccc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cd0:	75 15                	jne    803ce7 <ipc_recv+0x9b>
  803cd2:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803cd9:	00 00 00 
  803cdc:	48 8b 00             	mov    (%rax),%rax
  803cdf:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  803ce5:	eb 05                	jmp    803cec <ipc_recv+0xa0>
  803ce7:	b8 00 00 00 00       	mov    $0x0,%eax
  803cec:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803cf0:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  803cf2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cf6:	75 15                	jne    803d0d <ipc_recv+0xc1>
  803cf8:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803cff:	00 00 00 
  803d02:	48 8b 00             	mov    (%rax),%rax
  803d05:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  803d0b:	eb 03                	jmp    803d10 <ipc_recv+0xc4>
  803d0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803d10:	c9                   	leaveq 
  803d11:	c3                   	retq   

0000000000803d12 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803d12:	55                   	push   %rbp
  803d13:	48 89 e5             	mov    %rsp,%rbp
  803d16:	48 83 ec 30          	sub    $0x30,%rsp
  803d1a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d1d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803d20:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803d24:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  803d27:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  803d2e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803d33:	75 10                	jne    803d45 <ipc_send+0x33>
  803d35:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803d3c:	00 00 00 
  803d3f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  803d43:	eb 62                	jmp    803da7 <ipc_send+0x95>
  803d45:	eb 60                	jmp    803da7 <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  803d47:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803d4b:	74 30                	je     803d7d <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  803d4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d50:	89 c1                	mov    %eax,%ecx
  803d52:	48 ba f6 46 80 00 00 	movabs $0x8046f6,%rdx
  803d59:	00 00 00 
  803d5c:	be 33 00 00 00       	mov    $0x33,%esi
  803d61:	48 bf 12 47 80 00 00 	movabs $0x804712,%rdi
  803d68:	00 00 00 
  803d6b:	b8 00 00 00 00       	mov    $0x0,%eax
  803d70:	49 b8 ee 03 80 00 00 	movabs $0x8003ee,%r8
  803d77:	00 00 00 
  803d7a:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  803d7d:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803d80:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803d83:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803d87:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d8a:	89 c7                	mov    %eax,%edi
  803d8c:	48 b8 df 1c 80 00 00 	movabs $0x801cdf,%rax
  803d93:	00 00 00 
  803d96:	ff d0                	callq  *%rax
  803d98:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  803d9b:	48 b8 cd 1a 80 00 00 	movabs $0x801acd,%rax
  803da2:	00 00 00 
  803da5:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  803da7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dab:	75 9a                	jne    803d47 <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  803dad:	c9                   	leaveq 
  803dae:	c3                   	retq   

0000000000803daf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803daf:	55                   	push   %rbp
  803db0:	48 89 e5             	mov    %rsp,%rbp
  803db3:	48 83 ec 14          	sub    $0x14,%rsp
  803db7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803dba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803dc1:	eb 5e                	jmp    803e21 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803dc3:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803dca:	00 00 00 
  803dcd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dd0:	48 63 d0             	movslq %eax,%rdx
  803dd3:	48 89 d0             	mov    %rdx,%rax
  803dd6:	48 c1 e0 03          	shl    $0x3,%rax
  803dda:	48 01 d0             	add    %rdx,%rax
  803ddd:	48 c1 e0 05          	shl    $0x5,%rax
  803de1:	48 01 c8             	add    %rcx,%rax
  803de4:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803dea:	8b 00                	mov    (%rax),%eax
  803dec:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803def:	75 2c                	jne    803e1d <ipc_find_env+0x6e>
			return envs[i].env_id;
  803df1:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803df8:	00 00 00 
  803dfb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dfe:	48 63 d0             	movslq %eax,%rdx
  803e01:	48 89 d0             	mov    %rdx,%rax
  803e04:	48 c1 e0 03          	shl    $0x3,%rax
  803e08:	48 01 d0             	add    %rdx,%rax
  803e0b:	48 c1 e0 05          	shl    $0x5,%rax
  803e0f:	48 01 c8             	add    %rcx,%rax
  803e12:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803e18:	8b 40 08             	mov    0x8(%rax),%eax
  803e1b:	eb 12                	jmp    803e2f <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803e1d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803e21:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803e28:	7e 99                	jle    803dc3 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803e2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e2f:	c9                   	leaveq 
  803e30:	c3                   	retq   

0000000000803e31 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803e31:	55                   	push   %rbp
  803e32:	48 89 e5             	mov    %rsp,%rbp
  803e35:	48 83 ec 18          	sub    $0x18,%rsp
  803e39:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803e3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e41:	48 c1 e8 15          	shr    $0x15,%rax
  803e45:	48 89 c2             	mov    %rax,%rdx
  803e48:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803e4f:	01 00 00 
  803e52:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e56:	83 e0 01             	and    $0x1,%eax
  803e59:	48 85 c0             	test   %rax,%rax
  803e5c:	75 07                	jne    803e65 <pageref+0x34>
		return 0;
  803e5e:	b8 00 00 00 00       	mov    $0x0,%eax
  803e63:	eb 53                	jmp    803eb8 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803e65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e69:	48 c1 e8 0c          	shr    $0xc,%rax
  803e6d:	48 89 c2             	mov    %rax,%rdx
  803e70:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803e77:	01 00 00 
  803e7a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e7e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803e82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e86:	83 e0 01             	and    $0x1,%eax
  803e89:	48 85 c0             	test   %rax,%rax
  803e8c:	75 07                	jne    803e95 <pageref+0x64>
		return 0;
  803e8e:	b8 00 00 00 00       	mov    $0x0,%eax
  803e93:	eb 23                	jmp    803eb8 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803e95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e99:	48 c1 e8 0c          	shr    $0xc,%rax
  803e9d:	48 89 c2             	mov    %rax,%rdx
  803ea0:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803ea7:	00 00 00 
  803eaa:	48 c1 e2 04          	shl    $0x4,%rdx
  803eae:	48 01 d0             	add    %rdx,%rax
  803eb1:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803eb5:	0f b7 c0             	movzwl %ax,%eax
}
  803eb8:	c9                   	leaveq 
  803eb9:	c3                   	retq   
