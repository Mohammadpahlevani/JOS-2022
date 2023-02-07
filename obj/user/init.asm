
obj/user/init:     file format elf64-x86-64


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
  80003c:	e8 6c 06 00 00       	callq  8006ad <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <sum>:

char bss[6000];

int
sum(const char *s, int n)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 1c          	sub    $0x1c,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80004f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int i, tot = 0;
  800052:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	for (i = 0; i < n; i++)
  800059:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800060:	eb 1e                	jmp    800080 <sum+0x3d>
		tot ^= i * s[i];
  800062:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800065:	48 63 d0             	movslq %eax,%rdx
  800068:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80006c:	48 01 d0             	add    %rdx,%rax
  80006f:	0f b6 00             	movzbl (%rax),%eax
  800072:	0f be c0             	movsbl %al,%eax
  800075:	0f af 45 fc          	imul   -0x4(%rbp),%eax
  800079:	31 45 f8             	xor    %eax,-0x8(%rbp)

int
sum(const char *s, int n)
{
	int i, tot = 0;
	for (i = 0; i < n; i++)
  80007c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800080:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800083:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  800086:	7c da                	jl     800062 <sum+0x1f>
		tot ^= i * s[i];
	return tot;
  800088:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80008b:	c9                   	leaveq 
  80008c:	c3                   	retq   

000000000080008d <umain>:

void
umain(int argc, char **argv)
{
  80008d:	55                   	push   %rbp
  80008e:	48 89 e5             	mov    %rsp,%rbp
  800091:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  800098:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  80009e:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
	int i, r, x, want;
	char args[256];

	cprintf("init: running\n");
  8000a5:	48 bf 20 45 80 00 00 	movabs $0x804520,%rdi
  8000ac:	00 00 00 
  8000af:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b4:	48 ba 99 09 80 00 00 	movabs $0x800999,%rdx
  8000bb:	00 00 00 
  8000be:	ff d2                	callq  *%rdx

	want = 0xf989e;
  8000c0:	c7 45 f8 9e 98 0f 00 	movl   $0xf989e,-0x8(%rbp)
	if ((x = sum((char*)&data, sizeof data)) != want)
  8000c7:	be 70 17 00 00       	mov    $0x1770,%esi
  8000cc:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  8000d3:	00 00 00 
  8000d6:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000dd:	00 00 00 
  8000e0:	ff d0                	callq  *%rax
  8000e2:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000e5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000e8:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8000eb:	74 25                	je     800112 <umain+0x85>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  8000ed:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8000f0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000f3:	89 c6                	mov    %eax,%esi
  8000f5:	48 bf 30 45 80 00 00 	movabs $0x804530,%rdi
  8000fc:	00 00 00 
  8000ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800104:	48 b9 99 09 80 00 00 	movabs $0x800999,%rcx
  80010b:	00 00 00 
  80010e:	ff d1                	callq  *%rcx
  800110:	eb 1b                	jmp    80012d <umain+0xa0>
			x, want);
	else
		cprintf("init: data seems okay\n");
  800112:	48 bf 69 45 80 00 00 	movabs $0x804569,%rdi
  800119:	00 00 00 
  80011c:	b8 00 00 00 00       	mov    $0x0,%eax
  800121:	48 ba 99 09 80 00 00 	movabs $0x800999,%rdx
  800128:	00 00 00 
  80012b:	ff d2                	callq  *%rdx
	if ((x = sum(bss, sizeof bss)) != 0)
  80012d:	be 70 17 00 00       	mov    $0x1770,%esi
  800132:	48 bf 20 80 80 00 00 	movabs $0x808020,%rdi
  800139:	00 00 00 
  80013c:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800143:	00 00 00 
  800146:	ff d0                	callq  *%rax
  800148:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80014b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80014f:	74 22                	je     800173 <umain+0xe6>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  800151:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800154:	89 c6                	mov    %eax,%esi
  800156:	48 bf 80 45 80 00 00 	movabs $0x804580,%rdi
  80015d:	00 00 00 
  800160:	b8 00 00 00 00       	mov    $0x0,%eax
  800165:	48 ba 99 09 80 00 00 	movabs $0x800999,%rdx
  80016c:	00 00 00 
  80016f:	ff d2                	callq  *%rdx
  800171:	eb 1b                	jmp    80018e <umain+0x101>
	else
		cprintf("init: bss seems okay\n");
  800173:	48 bf af 45 80 00 00 	movabs $0x8045af,%rdi
  80017a:	00 00 00 
  80017d:	b8 00 00 00 00       	mov    $0x0,%eax
  800182:	48 ba 99 09 80 00 00 	movabs $0x800999,%rdx
  800189:	00 00 00 
  80018c:	ff d2                	callq  *%rdx

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  80018e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800195:	48 be c5 45 80 00 00 	movabs $0x8045c5,%rsi
  80019c:	00 00 00 
  80019f:	48 89 c7             	mov    %rax,%rdi
  8001a2:	48 b8 91 15 80 00 00 	movabs $0x801591,%rax
  8001a9:	00 00 00 
  8001ac:	ff d0                	callq  *%rax
	for (i = 0; i < argc; i++) {
  8001ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8001b5:	eb 77                	jmp    80022e <umain+0x1a1>
		strcat(args, " '");
  8001b7:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8001be:	48 be d1 45 80 00 00 	movabs $0x8045d1,%rsi
  8001c5:	00 00 00 
  8001c8:	48 89 c7             	mov    %rax,%rdi
  8001cb:	48 b8 91 15 80 00 00 	movabs $0x801591,%rax
  8001d2:	00 00 00 
  8001d5:	ff d0                	callq  *%rax
		strcat(args, argv[i]);
  8001d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001da:	48 98                	cltq   
  8001dc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8001e3:	00 
  8001e4:	48 8b 85 e0 fe ff ff 	mov    -0x120(%rbp),%rax
  8001eb:	48 01 d0             	add    %rdx,%rax
  8001ee:	48 8b 10             	mov    (%rax),%rdx
  8001f1:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8001f8:	48 89 d6             	mov    %rdx,%rsi
  8001fb:	48 89 c7             	mov    %rax,%rdi
  8001fe:	48 b8 91 15 80 00 00 	movabs $0x801591,%rax
  800205:	00 00 00 
  800208:	ff d0                	callq  *%rax
		strcat(args, "'");
  80020a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800211:	48 be d4 45 80 00 00 	movabs $0x8045d4,%rsi
  800218:	00 00 00 
  80021b:	48 89 c7             	mov    %rax,%rdi
  80021e:	48 b8 91 15 80 00 00 	movabs $0x801591,%rax
  800225:	00 00 00 
  800228:	ff d0                	callq  *%rax
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
	for (i = 0; i < argc; i++) {
  80022a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80022e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800231:	3b 85 ec fe ff ff    	cmp    -0x114(%rbp),%eax
  800237:	0f 8c 7a ff ff ff    	jl     8001b7 <umain+0x12a>
		strcat(args, " '");
		strcat(args, argv[i]);
		strcat(args, "'");
	}
	cprintf("%s\n", args);
  80023d:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800244:	48 89 c6             	mov    %rax,%rsi
  800247:	48 bf d6 45 80 00 00 	movabs $0x8045d6,%rdi
  80024e:	00 00 00 
  800251:	b8 00 00 00 00       	mov    $0x0,%eax
  800256:	48 ba 99 09 80 00 00 	movabs $0x800999,%rdx
  80025d:	00 00 00 
  800260:	ff d2                	callq  *%rdx

	cprintf("init: running sh\n");
  800262:	48 bf da 45 80 00 00 	movabs $0x8045da,%rdi
  800269:	00 00 00 
  80026c:	b8 00 00 00 00       	mov    $0x0,%eax
  800271:	48 ba 99 09 80 00 00 	movabs $0x800999,%rdx
  800278:	00 00 00 
  80027b:	ff d2                	callq  *%rdx

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  80027d:	bf 00 00 00 00       	mov    $0x0,%edi
  800282:	48 b8 e0 23 80 00 00 	movabs $0x8023e0,%rax
  800289:	00 00 00 
  80028c:	ff d0                	callq  *%rax
	if ((r = opencons()) < 0)
  80028e:	48 b8 bb 04 80 00 00 	movabs $0x8004bb,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
  80029a:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80029d:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8002a1:	79 30                	jns    8002d3 <umain+0x246>
		panic("opencons: %e", r);
  8002a3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002a6:	89 c1                	mov    %eax,%ecx
  8002a8:	48 ba ec 45 80 00 00 	movabs $0x8045ec,%rdx
  8002af:	00 00 00 
  8002b2:	be 37 00 00 00       	mov    $0x37,%esi
  8002b7:	48 bf f9 45 80 00 00 	movabs $0x8045f9,%rdi
  8002be:	00 00 00 
  8002c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c6:	49 b8 60 07 80 00 00 	movabs $0x800760,%r8
  8002cd:	00 00 00 
  8002d0:	41 ff d0             	callq  *%r8
	if (r != 0)
  8002d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8002d7:	74 30                	je     800309 <umain+0x27c>
		panic("first opencons used fd %d", r);
  8002d9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002dc:	89 c1                	mov    %eax,%ecx
  8002de:	48 ba 05 46 80 00 00 	movabs $0x804605,%rdx
  8002e5:	00 00 00 
  8002e8:	be 39 00 00 00       	mov    $0x39,%esi
  8002ed:	48 bf f9 45 80 00 00 	movabs $0x8045f9,%rdi
  8002f4:	00 00 00 
  8002f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fc:	49 b8 60 07 80 00 00 	movabs $0x800760,%r8
  800303:	00 00 00 
  800306:	41 ff d0             	callq  *%r8
	if ((r = dup(0, 1)) < 0)
  800309:	be 01 00 00 00       	mov    $0x1,%esi
  80030e:	bf 00 00 00 00       	mov    $0x0,%edi
  800313:	48 b8 59 24 80 00 00 	movabs $0x802459,%rax
  80031a:	00 00 00 
  80031d:	ff d0                	callq  *%rax
  80031f:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800322:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800326:	79 30                	jns    800358 <umain+0x2cb>
		panic("dup: %e", r);
  800328:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80032b:	89 c1                	mov    %eax,%ecx
  80032d:	48 ba 1f 46 80 00 00 	movabs $0x80461f,%rdx
  800334:	00 00 00 
  800337:	be 3b 00 00 00       	mov    $0x3b,%esi
  80033c:	48 bf f9 45 80 00 00 	movabs $0x8045f9,%rdi
  800343:	00 00 00 
  800346:	b8 00 00 00 00       	mov    $0x0,%eax
  80034b:	49 b8 60 07 80 00 00 	movabs $0x800760,%r8
  800352:	00 00 00 
  800355:	41 ff d0             	callq  *%r8
	while (1) {
		cprintf("init: starting sh\n");
  800358:	48 bf 27 46 80 00 00 	movabs $0x804627,%rdi
  80035f:	00 00 00 
  800362:	b8 00 00 00 00       	mov    $0x0,%eax
  800367:	48 ba 99 09 80 00 00 	movabs $0x800999,%rdx
  80036e:	00 00 00 
  800371:	ff d2                	callq  *%rdx
		r = spawnl("/bin/sh", "sh", (char*)0);
  800373:	ba 00 00 00 00       	mov    $0x0,%edx
  800378:	48 be 3a 46 80 00 00 	movabs $0x80463a,%rsi
  80037f:	00 00 00 
  800382:	48 bf 3d 46 80 00 00 	movabs $0x80463d,%rdi
  800389:	00 00 00 
  80038c:	b8 00 00 00 00       	mov    $0x0,%eax
  800391:	48 b9 96 33 80 00 00 	movabs $0x803396,%rcx
  800398:	00 00 00 
  80039b:	ff d1                	callq  *%rcx
  80039d:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (r < 0) {
  8003a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8003a4:	79 23                	jns    8003c9 <umain+0x33c>
			cprintf("init: spawn sh: %e\n", r);
  8003a6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8003a9:	89 c6                	mov    %eax,%esi
  8003ab:	48 bf 45 46 80 00 00 	movabs $0x804645,%rdi
  8003b2:	00 00 00 
  8003b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ba:	48 ba 99 09 80 00 00 	movabs $0x800999,%rdx
  8003c1:	00 00 00 
  8003c4:	ff d2                	callq  *%rdx
			continue;
  8003c6:	90                   	nop
		}
		cprintf("init waiting\n");
		wait(r);
	}
  8003c7:	eb 8f                	jmp    800358 <umain+0x2cb>
		r = spawnl("/bin/sh", "sh", (char*)0);
		if (r < 0) {
			cprintf("init: spawn sh: %e\n", r);
			continue;
		}
		cprintf("init waiting\n");
  8003c9:	48 bf 59 46 80 00 00 	movabs $0x804659,%rdi
  8003d0:	00 00 00 
  8003d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d8:	48 ba 99 09 80 00 00 	movabs $0x800999,%rdx
  8003df:	00 00 00 
  8003e2:	ff d2                	callq  *%rdx
		wait(r);
  8003e4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8003e7:	89 c7                	mov    %eax,%edi
  8003e9:	48 b8 f6 41 80 00 00 	movabs $0x8041f6,%rax
  8003f0:	00 00 00 
  8003f3:	ff d0                	callq  *%rax
	}
  8003f5:	e9 5e ff ff ff       	jmpq   800358 <umain+0x2cb>

00000000008003fa <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8003fa:	55                   	push   %rbp
  8003fb:	48 89 e5             	mov    %rsp,%rbp
  8003fe:	48 83 ec 20          	sub    $0x20,%rsp
  800402:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  800405:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800408:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80040b:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80040f:	be 01 00 00 00       	mov    $0x1,%esi
  800414:	48 89 c7             	mov    %rax,%rdi
  800417:	48 b8 35 1d 80 00 00 	movabs $0x801d35,%rax
  80041e:	00 00 00 
  800421:	ff d0                	callq  *%rax
}
  800423:	c9                   	leaveq 
  800424:	c3                   	retq   

0000000000800425 <getchar>:

int
getchar(void)
{
  800425:	55                   	push   %rbp
  800426:	48 89 e5             	mov    %rsp,%rbp
  800429:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80042d:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  800431:	ba 01 00 00 00       	mov    $0x1,%edx
  800436:	48 89 c6             	mov    %rax,%rsi
  800439:	bf 00 00 00 00       	mov    $0x0,%edi
  80043e:	48 b8 02 26 80 00 00 	movabs $0x802602,%rax
  800445:	00 00 00 
  800448:	ff d0                	callq  *%rax
  80044a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80044d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800451:	79 05                	jns    800458 <getchar+0x33>
		return r;
  800453:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800456:	eb 14                	jmp    80046c <getchar+0x47>
	if (r < 1)
  800458:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80045c:	7f 07                	jg     800465 <getchar+0x40>
		return -E_EOF;
  80045e:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800463:	eb 07                	jmp    80046c <getchar+0x47>
	return c;
  800465:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  800469:	0f b6 c0             	movzbl %al,%eax
}
  80046c:	c9                   	leaveq 
  80046d:	c3                   	retq   

000000000080046e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80046e:	55                   	push   %rbp
  80046f:	48 89 e5             	mov    %rsp,%rbp
  800472:	48 83 ec 20          	sub    $0x20,%rsp
  800476:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800479:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80047d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800480:	48 89 d6             	mov    %rdx,%rsi
  800483:	89 c7                	mov    %eax,%edi
  800485:	48 b8 d0 21 80 00 00 	movabs $0x8021d0,%rax
  80048c:	00 00 00 
  80048f:	ff d0                	callq  *%rax
  800491:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800494:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800498:	79 05                	jns    80049f <iscons+0x31>
		return r;
  80049a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80049d:	eb 1a                	jmp    8004b9 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80049f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004a3:	8b 10                	mov    (%rax),%edx
  8004a5:	48 b8 80 77 80 00 00 	movabs $0x807780,%rax
  8004ac:	00 00 00 
  8004af:	8b 00                	mov    (%rax),%eax
  8004b1:	39 c2                	cmp    %eax,%edx
  8004b3:	0f 94 c0             	sete   %al
  8004b6:	0f b6 c0             	movzbl %al,%eax
}
  8004b9:	c9                   	leaveq 
  8004ba:	c3                   	retq   

00000000008004bb <opencons>:

int
opencons(void)
{
  8004bb:	55                   	push   %rbp
  8004bc:	48 89 e5             	mov    %rsp,%rbp
  8004bf:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8004c3:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8004c7:	48 89 c7             	mov    %rax,%rdi
  8004ca:	48 b8 38 21 80 00 00 	movabs $0x802138,%rax
  8004d1:	00 00 00 
  8004d4:	ff d0                	callq  *%rax
  8004d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004dd:	79 05                	jns    8004e4 <opencons+0x29>
		return r;
  8004df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004e2:	eb 5b                	jmp    80053f <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8004e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004e8:	ba 07 04 00 00       	mov    $0x407,%edx
  8004ed:	48 89 c6             	mov    %rax,%rsi
  8004f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8004f5:	48 b8 7d 1e 80 00 00 	movabs $0x801e7d,%rax
  8004fc:	00 00 00 
  8004ff:	ff d0                	callq  *%rax
  800501:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800504:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800508:	79 05                	jns    80050f <opencons+0x54>
		return r;
  80050a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80050d:	eb 30                	jmp    80053f <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80050f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800513:	48 ba 80 77 80 00 00 	movabs $0x807780,%rdx
  80051a:	00 00 00 
  80051d:	8b 12                	mov    (%rdx),%edx
  80051f:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  800521:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800525:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80052c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800530:	48 89 c7             	mov    %rax,%rdi
  800533:	48 b8 ea 20 80 00 00 	movabs $0x8020ea,%rax
  80053a:	00 00 00 
  80053d:	ff d0                	callq  *%rax
}
  80053f:	c9                   	leaveq 
  800540:	c3                   	retq   

0000000000800541 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800541:	55                   	push   %rbp
  800542:	48 89 e5             	mov    %rsp,%rbp
  800545:	48 83 ec 30          	sub    $0x30,%rsp
  800549:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80054d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800551:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  800555:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80055a:	75 07                	jne    800563 <devcons_read+0x22>
		return 0;
  80055c:	b8 00 00 00 00       	mov    $0x0,%eax
  800561:	eb 4b                	jmp    8005ae <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  800563:	eb 0c                	jmp    800571 <devcons_read+0x30>
		sys_yield();
  800565:	48 b8 3f 1e 80 00 00 	movabs $0x801e3f,%rax
  80056c:	00 00 00 
  80056f:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  800571:	48 b8 7f 1d 80 00 00 	movabs $0x801d7f,%rax
  800578:	00 00 00 
  80057b:	ff d0                	callq  *%rax
  80057d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800580:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800584:	74 df                	je     800565 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  800586:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80058a:	79 05                	jns    800591 <devcons_read+0x50>
		return c;
  80058c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80058f:	eb 1d                	jmp    8005ae <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  800591:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800595:	75 07                	jne    80059e <devcons_read+0x5d>
		return 0;
  800597:	b8 00 00 00 00       	mov    $0x0,%eax
  80059c:	eb 10                	jmp    8005ae <devcons_read+0x6d>
	*(char*)vbuf = c;
  80059e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005a1:	89 c2                	mov    %eax,%edx
  8005a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8005a7:	88 10                	mov    %dl,(%rax)
	return 1;
  8005a9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8005ae:	c9                   	leaveq 
  8005af:	c3                   	retq   

00000000008005b0 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8005b0:	55                   	push   %rbp
  8005b1:	48 89 e5             	mov    %rsp,%rbp
  8005b4:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8005bb:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8005c2:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8005c9:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8005d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8005d7:	eb 76                	jmp    80064f <devcons_write+0x9f>
		m = n - tot;
  8005d9:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8005e0:	89 c2                	mov    %eax,%edx
  8005e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005e5:	29 c2                	sub    %eax,%edx
  8005e7:	89 d0                	mov    %edx,%eax
  8005e9:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8005ec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005ef:	83 f8 7f             	cmp    $0x7f,%eax
  8005f2:	76 07                	jbe    8005fb <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8005f4:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8005fb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005fe:	48 63 d0             	movslq %eax,%rdx
  800601:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800604:	48 63 c8             	movslq %eax,%rcx
  800607:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80060e:	48 01 c1             	add    %rax,%rcx
  800611:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  800618:	48 89 ce             	mov    %rcx,%rsi
  80061b:	48 89 c7             	mov    %rax,%rdi
  80061e:	48 b8 72 18 80 00 00 	movabs $0x801872,%rax
  800625:	00 00 00 
  800628:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80062a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80062d:	48 63 d0             	movslq %eax,%rdx
  800630:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  800637:	48 89 d6             	mov    %rdx,%rsi
  80063a:	48 89 c7             	mov    %rax,%rdi
  80063d:	48 b8 35 1d 80 00 00 	movabs $0x801d35,%rax
  800644:	00 00 00 
  800647:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800649:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80064c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80064f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800652:	48 98                	cltq   
  800654:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80065b:	0f 82 78 ff ff ff    	jb     8005d9 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  800661:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800664:	c9                   	leaveq 
  800665:	c3                   	retq   

0000000000800666 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  800666:	55                   	push   %rbp
  800667:	48 89 e5             	mov    %rsp,%rbp
  80066a:	48 83 ec 08          	sub    $0x8,%rsp
  80066e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  800672:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800677:	c9                   	leaveq 
  800678:	c3                   	retq   

0000000000800679 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800679:	55                   	push   %rbp
  80067a:	48 89 e5             	mov    %rsp,%rbp
  80067d:	48 83 ec 10          	sub    $0x10,%rsp
  800681:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800685:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  800689:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80068d:	48 be 6c 46 80 00 00 	movabs $0x80466c,%rsi
  800694:	00 00 00 
  800697:	48 89 c7             	mov    %rax,%rdi
  80069a:	48 b8 4e 15 80 00 00 	movabs $0x80154e,%rax
  8006a1:	00 00 00 
  8006a4:	ff d0                	callq  *%rax
	return 0;
  8006a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006ab:	c9                   	leaveq 
  8006ac:	c3                   	retq   

00000000008006ad <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8006ad:	55                   	push   %rbp
  8006ae:	48 89 e5             	mov    %rsp,%rbp
  8006b1:	48 83 ec 10          	sub    $0x10,%rsp
  8006b5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8006b8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  8006bc:	48 b8 01 1e 80 00 00 	movabs $0x801e01,%rax
  8006c3:	00 00 00 
  8006c6:	ff d0                	callq  *%rax
  8006c8:	48 98                	cltq   
  8006ca:	25 ff 03 00 00       	and    $0x3ff,%eax
  8006cf:	48 89 c2             	mov    %rax,%rdx
  8006d2:	48 89 d0             	mov    %rdx,%rax
  8006d5:	48 c1 e0 03          	shl    $0x3,%rax
  8006d9:	48 01 d0             	add    %rdx,%rax
  8006dc:	48 c1 e0 05          	shl    $0x5,%rax
  8006e0:	48 89 c2             	mov    %rax,%rdx
  8006e3:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8006ea:	00 00 00 
  8006ed:	48 01 c2             	add    %rax,%rdx
  8006f0:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  8006f7:	00 00 00 
  8006fa:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800701:	7e 14                	jle    800717 <libmain+0x6a>
		binaryname = argv[0];
  800703:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800707:	48 8b 10             	mov    (%rax),%rdx
  80070a:	48 b8 b8 77 80 00 00 	movabs $0x8077b8,%rax
  800711:	00 00 00 
  800714:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800717:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80071b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80071e:	48 89 d6             	mov    %rdx,%rsi
  800721:	89 c7                	mov    %eax,%edi
  800723:	48 b8 8d 00 80 00 00 	movabs $0x80008d,%rax
  80072a:	00 00 00 
  80072d:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80072f:	48 b8 3d 07 80 00 00 	movabs $0x80073d,%rax
  800736:	00 00 00 
  800739:	ff d0                	callq  *%rax
}
  80073b:	c9                   	leaveq 
  80073c:	c3                   	retq   

000000000080073d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80073d:	55                   	push   %rbp
  80073e:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800741:	48 b8 2b 24 80 00 00 	movabs $0x80242b,%rax
  800748:	00 00 00 
  80074b:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80074d:	bf 00 00 00 00       	mov    $0x0,%edi
  800752:	48 b8 bd 1d 80 00 00 	movabs $0x801dbd,%rax
  800759:	00 00 00 
  80075c:	ff d0                	callq  *%rax
}
  80075e:	5d                   	pop    %rbp
  80075f:	c3                   	retq   

0000000000800760 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800760:	55                   	push   %rbp
  800761:	48 89 e5             	mov    %rsp,%rbp
  800764:	53                   	push   %rbx
  800765:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80076c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800773:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800779:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800780:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800787:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80078e:	84 c0                	test   %al,%al
  800790:	74 23                	je     8007b5 <_panic+0x55>
  800792:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800799:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80079d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8007a1:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8007a5:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8007a9:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8007ad:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8007b1:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8007b5:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8007bc:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8007c3:	00 00 00 
  8007c6:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8007cd:	00 00 00 
  8007d0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007d4:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8007db:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8007e2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8007e9:	48 b8 b8 77 80 00 00 	movabs $0x8077b8,%rax
  8007f0:	00 00 00 
  8007f3:	48 8b 18             	mov    (%rax),%rbx
  8007f6:	48 b8 01 1e 80 00 00 	movabs $0x801e01,%rax
  8007fd:	00 00 00 
  800800:	ff d0                	callq  *%rax
  800802:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800808:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80080f:	41 89 c8             	mov    %ecx,%r8d
  800812:	48 89 d1             	mov    %rdx,%rcx
  800815:	48 89 da             	mov    %rbx,%rdx
  800818:	89 c6                	mov    %eax,%esi
  80081a:	48 bf 80 46 80 00 00 	movabs $0x804680,%rdi
  800821:	00 00 00 
  800824:	b8 00 00 00 00       	mov    $0x0,%eax
  800829:	49 b9 99 09 80 00 00 	movabs $0x800999,%r9
  800830:	00 00 00 
  800833:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800836:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80083d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800844:	48 89 d6             	mov    %rdx,%rsi
  800847:	48 89 c7             	mov    %rax,%rdi
  80084a:	48 b8 ed 08 80 00 00 	movabs $0x8008ed,%rax
  800851:	00 00 00 
  800854:	ff d0                	callq  *%rax
	cprintf("\n");
  800856:	48 bf a3 46 80 00 00 	movabs $0x8046a3,%rdi
  80085d:	00 00 00 
  800860:	b8 00 00 00 00       	mov    $0x0,%eax
  800865:	48 ba 99 09 80 00 00 	movabs $0x800999,%rdx
  80086c:	00 00 00 
  80086f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800871:	cc                   	int3   
  800872:	eb fd                	jmp    800871 <_panic+0x111>

0000000000800874 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800874:	55                   	push   %rbp
  800875:	48 89 e5             	mov    %rsp,%rbp
  800878:	48 83 ec 10          	sub    $0x10,%rsp
  80087c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80087f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800883:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800887:	8b 00                	mov    (%rax),%eax
  800889:	8d 48 01             	lea    0x1(%rax),%ecx
  80088c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800890:	89 0a                	mov    %ecx,(%rdx)
  800892:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800895:	89 d1                	mov    %edx,%ecx
  800897:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80089b:	48 98                	cltq   
  80089d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8008a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008a5:	8b 00                	mov    (%rax),%eax
  8008a7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008ac:	75 2c                	jne    8008da <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8008ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008b2:	8b 00                	mov    (%rax),%eax
  8008b4:	48 98                	cltq   
  8008b6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8008ba:	48 83 c2 08          	add    $0x8,%rdx
  8008be:	48 89 c6             	mov    %rax,%rsi
  8008c1:	48 89 d7             	mov    %rdx,%rdi
  8008c4:	48 b8 35 1d 80 00 00 	movabs $0x801d35,%rax
  8008cb:	00 00 00 
  8008ce:	ff d0                	callq  *%rax
        b->idx = 0;
  8008d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008d4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8008da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008de:	8b 40 04             	mov    0x4(%rax),%eax
  8008e1:	8d 50 01             	lea    0x1(%rax),%edx
  8008e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008e8:	89 50 04             	mov    %edx,0x4(%rax)
}
  8008eb:	c9                   	leaveq 
  8008ec:	c3                   	retq   

00000000008008ed <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8008ed:	55                   	push   %rbp
  8008ee:	48 89 e5             	mov    %rsp,%rbp
  8008f1:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8008f8:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8008ff:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800906:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80090d:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800914:	48 8b 0a             	mov    (%rdx),%rcx
  800917:	48 89 08             	mov    %rcx,(%rax)
  80091a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80091e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800922:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800926:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80092a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800931:	00 00 00 
    b.cnt = 0;
  800934:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80093b:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80093e:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800945:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80094c:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800953:	48 89 c6             	mov    %rax,%rsi
  800956:	48 bf 74 08 80 00 00 	movabs $0x800874,%rdi
  80095d:	00 00 00 
  800960:	48 b8 4c 0d 80 00 00 	movabs $0x800d4c,%rax
  800967:	00 00 00 
  80096a:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80096c:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800972:	48 98                	cltq   
  800974:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80097b:	48 83 c2 08          	add    $0x8,%rdx
  80097f:	48 89 c6             	mov    %rax,%rsi
  800982:	48 89 d7             	mov    %rdx,%rdi
  800985:	48 b8 35 1d 80 00 00 	movabs $0x801d35,%rax
  80098c:	00 00 00 
  80098f:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800991:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800997:	c9                   	leaveq 
  800998:	c3                   	retq   

0000000000800999 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800999:	55                   	push   %rbp
  80099a:	48 89 e5             	mov    %rsp,%rbp
  80099d:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8009a4:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8009ab:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8009b2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8009b9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8009c0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8009c7:	84 c0                	test   %al,%al
  8009c9:	74 20                	je     8009eb <cprintf+0x52>
  8009cb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8009cf:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8009d3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8009d7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8009db:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8009df:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8009e3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8009e7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8009eb:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8009f2:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8009f9:	00 00 00 
  8009fc:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800a03:	00 00 00 
  800a06:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800a0a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800a11:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800a18:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800a1f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800a26:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800a2d:	48 8b 0a             	mov    (%rdx),%rcx
  800a30:	48 89 08             	mov    %rcx,(%rax)
  800a33:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a37:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a3b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a3f:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800a43:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800a4a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800a51:	48 89 d6             	mov    %rdx,%rsi
  800a54:	48 89 c7             	mov    %rax,%rdi
  800a57:	48 b8 ed 08 80 00 00 	movabs $0x8008ed,%rax
  800a5e:	00 00 00 
  800a61:	ff d0                	callq  *%rax
  800a63:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800a69:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800a6f:	c9                   	leaveq 
  800a70:	c3                   	retq   

0000000000800a71 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a71:	55                   	push   %rbp
  800a72:	48 89 e5             	mov    %rsp,%rbp
  800a75:	53                   	push   %rbx
  800a76:	48 83 ec 38          	sub    $0x38,%rsp
  800a7a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a7e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800a82:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800a86:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800a89:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800a8d:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a91:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800a94:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800a98:	77 3b                	ja     800ad5 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a9a:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800a9d:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800aa1:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800aa4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800aa8:	ba 00 00 00 00       	mov    $0x0,%edx
  800aad:	48 f7 f3             	div    %rbx
  800ab0:	48 89 c2             	mov    %rax,%rdx
  800ab3:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800ab6:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800ab9:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800abd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac1:	41 89 f9             	mov    %edi,%r9d
  800ac4:	48 89 c7             	mov    %rax,%rdi
  800ac7:	48 b8 71 0a 80 00 00 	movabs $0x800a71,%rax
  800ace:	00 00 00 
  800ad1:	ff d0                	callq  *%rax
  800ad3:	eb 1e                	jmp    800af3 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ad5:	eb 12                	jmp    800ae9 <printnum+0x78>
			putch(padc, putdat);
  800ad7:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800adb:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800ade:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae2:	48 89 ce             	mov    %rcx,%rsi
  800ae5:	89 d7                	mov    %edx,%edi
  800ae7:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ae9:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800aed:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800af1:	7f e4                	jg     800ad7 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800af3:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800af6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800afa:	ba 00 00 00 00       	mov    $0x0,%edx
  800aff:	48 f7 f1             	div    %rcx
  800b02:	48 89 d0             	mov    %rdx,%rax
  800b05:	48 ba b0 48 80 00 00 	movabs $0x8048b0,%rdx
  800b0c:	00 00 00 
  800b0f:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800b13:	0f be d0             	movsbl %al,%edx
  800b16:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800b1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b1e:	48 89 ce             	mov    %rcx,%rsi
  800b21:	89 d7                	mov    %edx,%edi
  800b23:	ff d0                	callq  *%rax
}
  800b25:	48 83 c4 38          	add    $0x38,%rsp
  800b29:	5b                   	pop    %rbx
  800b2a:	5d                   	pop    %rbp
  800b2b:	c3                   	retq   

0000000000800b2c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b2c:	55                   	push   %rbp
  800b2d:	48 89 e5             	mov    %rsp,%rbp
  800b30:	48 83 ec 1c          	sub    $0x1c,%rsp
  800b34:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800b38:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800b3b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800b3f:	7e 52                	jle    800b93 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800b41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b45:	8b 00                	mov    (%rax),%eax
  800b47:	83 f8 30             	cmp    $0x30,%eax
  800b4a:	73 24                	jae    800b70 <getuint+0x44>
  800b4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b50:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b58:	8b 00                	mov    (%rax),%eax
  800b5a:	89 c0                	mov    %eax,%eax
  800b5c:	48 01 d0             	add    %rdx,%rax
  800b5f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b63:	8b 12                	mov    (%rdx),%edx
  800b65:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b68:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b6c:	89 0a                	mov    %ecx,(%rdx)
  800b6e:	eb 17                	jmp    800b87 <getuint+0x5b>
  800b70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b74:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b78:	48 89 d0             	mov    %rdx,%rax
  800b7b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b7f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b83:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b87:	48 8b 00             	mov    (%rax),%rax
  800b8a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b8e:	e9 a3 00 00 00       	jmpq   800c36 <getuint+0x10a>
	else if (lflag)
  800b93:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800b97:	74 4f                	je     800be8 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800b99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b9d:	8b 00                	mov    (%rax),%eax
  800b9f:	83 f8 30             	cmp    $0x30,%eax
  800ba2:	73 24                	jae    800bc8 <getuint+0x9c>
  800ba4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ba8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800bac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bb0:	8b 00                	mov    (%rax),%eax
  800bb2:	89 c0                	mov    %eax,%eax
  800bb4:	48 01 d0             	add    %rdx,%rax
  800bb7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bbb:	8b 12                	mov    (%rdx),%edx
  800bbd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800bc0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bc4:	89 0a                	mov    %ecx,(%rdx)
  800bc6:	eb 17                	jmp    800bdf <getuint+0xb3>
  800bc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bcc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800bd0:	48 89 d0             	mov    %rdx,%rax
  800bd3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800bd7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bdb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800bdf:	48 8b 00             	mov    (%rax),%rax
  800be2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800be6:	eb 4e                	jmp    800c36 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800be8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bec:	8b 00                	mov    (%rax),%eax
  800bee:	83 f8 30             	cmp    $0x30,%eax
  800bf1:	73 24                	jae    800c17 <getuint+0xeb>
  800bf3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bf7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800bfb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bff:	8b 00                	mov    (%rax),%eax
  800c01:	89 c0                	mov    %eax,%eax
  800c03:	48 01 d0             	add    %rdx,%rax
  800c06:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c0a:	8b 12                	mov    (%rdx),%edx
  800c0c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800c0f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c13:	89 0a                	mov    %ecx,(%rdx)
  800c15:	eb 17                	jmp    800c2e <getuint+0x102>
  800c17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c1b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800c1f:	48 89 d0             	mov    %rdx,%rax
  800c22:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800c26:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c2a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800c2e:	8b 00                	mov    (%rax),%eax
  800c30:	89 c0                	mov    %eax,%eax
  800c32:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800c36:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800c3a:	c9                   	leaveq 
  800c3b:	c3                   	retq   

0000000000800c3c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c3c:	55                   	push   %rbp
  800c3d:	48 89 e5             	mov    %rsp,%rbp
  800c40:	48 83 ec 1c          	sub    $0x1c,%rsp
  800c44:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800c48:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800c4b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800c4f:	7e 52                	jle    800ca3 <getint+0x67>
		x=va_arg(*ap, long long);
  800c51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c55:	8b 00                	mov    (%rax),%eax
  800c57:	83 f8 30             	cmp    $0x30,%eax
  800c5a:	73 24                	jae    800c80 <getint+0x44>
  800c5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c60:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800c64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c68:	8b 00                	mov    (%rax),%eax
  800c6a:	89 c0                	mov    %eax,%eax
  800c6c:	48 01 d0             	add    %rdx,%rax
  800c6f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c73:	8b 12                	mov    (%rdx),%edx
  800c75:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800c78:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c7c:	89 0a                	mov    %ecx,(%rdx)
  800c7e:	eb 17                	jmp    800c97 <getint+0x5b>
  800c80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c84:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800c88:	48 89 d0             	mov    %rdx,%rax
  800c8b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800c8f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c93:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800c97:	48 8b 00             	mov    (%rax),%rax
  800c9a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800c9e:	e9 a3 00 00 00       	jmpq   800d46 <getint+0x10a>
	else if (lflag)
  800ca3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800ca7:	74 4f                	je     800cf8 <getint+0xbc>
		x=va_arg(*ap, long);
  800ca9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cad:	8b 00                	mov    (%rax),%eax
  800caf:	83 f8 30             	cmp    $0x30,%eax
  800cb2:	73 24                	jae    800cd8 <getint+0x9c>
  800cb4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cb8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800cbc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cc0:	8b 00                	mov    (%rax),%eax
  800cc2:	89 c0                	mov    %eax,%eax
  800cc4:	48 01 d0             	add    %rdx,%rax
  800cc7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ccb:	8b 12                	mov    (%rdx),%edx
  800ccd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800cd0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cd4:	89 0a                	mov    %ecx,(%rdx)
  800cd6:	eb 17                	jmp    800cef <getint+0xb3>
  800cd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cdc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ce0:	48 89 d0             	mov    %rdx,%rax
  800ce3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ce7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ceb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800cef:	48 8b 00             	mov    (%rax),%rax
  800cf2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800cf6:	eb 4e                	jmp    800d46 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800cf8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cfc:	8b 00                	mov    (%rax),%eax
  800cfe:	83 f8 30             	cmp    $0x30,%eax
  800d01:	73 24                	jae    800d27 <getint+0xeb>
  800d03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d07:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d0f:	8b 00                	mov    (%rax),%eax
  800d11:	89 c0                	mov    %eax,%eax
  800d13:	48 01 d0             	add    %rdx,%rax
  800d16:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d1a:	8b 12                	mov    (%rdx),%edx
  800d1c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d1f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d23:	89 0a                	mov    %ecx,(%rdx)
  800d25:	eb 17                	jmp    800d3e <getint+0x102>
  800d27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d2b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800d2f:	48 89 d0             	mov    %rdx,%rax
  800d32:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800d36:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d3a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d3e:	8b 00                	mov    (%rax),%eax
  800d40:	48 98                	cltq   
  800d42:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800d46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800d4a:	c9                   	leaveq 
  800d4b:	c3                   	retq   

0000000000800d4c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d4c:	55                   	push   %rbp
  800d4d:	48 89 e5             	mov    %rsp,%rbp
  800d50:	41 54                	push   %r12
  800d52:	53                   	push   %rbx
  800d53:	48 83 ec 60          	sub    $0x60,%rsp
  800d57:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800d5b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800d5f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800d63:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800d67:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d6b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800d6f:	48 8b 0a             	mov    (%rdx),%rcx
  800d72:	48 89 08             	mov    %rcx,(%rax)
  800d75:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d79:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d7d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d81:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d85:	eb 17                	jmp    800d9e <vprintfmt+0x52>
			if (ch == '\0')
  800d87:	85 db                	test   %ebx,%ebx
  800d89:	0f 84 cc 04 00 00    	je     80125b <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800d8f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d93:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d97:	48 89 d6             	mov    %rdx,%rsi
  800d9a:	89 df                	mov    %ebx,%edi
  800d9c:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d9e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800da2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800da6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800daa:	0f b6 00             	movzbl (%rax),%eax
  800dad:	0f b6 d8             	movzbl %al,%ebx
  800db0:	83 fb 25             	cmp    $0x25,%ebx
  800db3:	75 d2                	jne    800d87 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800db5:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800db9:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800dc0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800dc7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800dce:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dd5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800dd9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ddd:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800de1:	0f b6 00             	movzbl (%rax),%eax
  800de4:	0f b6 d8             	movzbl %al,%ebx
  800de7:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800dea:	83 f8 55             	cmp    $0x55,%eax
  800ded:	0f 87 34 04 00 00    	ja     801227 <vprintfmt+0x4db>
  800df3:	89 c0                	mov    %eax,%eax
  800df5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800dfc:	00 
  800dfd:	48 b8 d8 48 80 00 00 	movabs $0x8048d8,%rax
  800e04:	00 00 00 
  800e07:	48 01 d0             	add    %rdx,%rax
  800e0a:	48 8b 00             	mov    (%rax),%rax
  800e0d:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800e0f:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800e13:	eb c0                	jmp    800dd5 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e15:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800e19:	eb ba                	jmp    800dd5 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e1b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800e22:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800e25:	89 d0                	mov    %edx,%eax
  800e27:	c1 e0 02             	shl    $0x2,%eax
  800e2a:	01 d0                	add    %edx,%eax
  800e2c:	01 c0                	add    %eax,%eax
  800e2e:	01 d8                	add    %ebx,%eax
  800e30:	83 e8 30             	sub    $0x30,%eax
  800e33:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800e36:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e3a:	0f b6 00             	movzbl (%rax),%eax
  800e3d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e40:	83 fb 2f             	cmp    $0x2f,%ebx
  800e43:	7e 0c                	jle    800e51 <vprintfmt+0x105>
  800e45:	83 fb 39             	cmp    $0x39,%ebx
  800e48:	7f 07                	jg     800e51 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e4a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e4f:	eb d1                	jmp    800e22 <vprintfmt+0xd6>
			goto process_precision;
  800e51:	eb 58                	jmp    800eab <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800e53:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e56:	83 f8 30             	cmp    $0x30,%eax
  800e59:	73 17                	jae    800e72 <vprintfmt+0x126>
  800e5b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e5f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e62:	89 c0                	mov    %eax,%eax
  800e64:	48 01 d0             	add    %rdx,%rax
  800e67:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e6a:	83 c2 08             	add    $0x8,%edx
  800e6d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e70:	eb 0f                	jmp    800e81 <vprintfmt+0x135>
  800e72:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e76:	48 89 d0             	mov    %rdx,%rax
  800e79:	48 83 c2 08          	add    $0x8,%rdx
  800e7d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e81:	8b 00                	mov    (%rax),%eax
  800e83:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800e86:	eb 23                	jmp    800eab <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800e88:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e8c:	79 0c                	jns    800e9a <vprintfmt+0x14e>
				width = 0;
  800e8e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800e95:	e9 3b ff ff ff       	jmpq   800dd5 <vprintfmt+0x89>
  800e9a:	e9 36 ff ff ff       	jmpq   800dd5 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800e9f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800ea6:	e9 2a ff ff ff       	jmpq   800dd5 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800eab:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800eaf:	79 12                	jns    800ec3 <vprintfmt+0x177>
				width = precision, precision = -1;
  800eb1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800eb4:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800eb7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800ebe:	e9 12 ff ff ff       	jmpq   800dd5 <vprintfmt+0x89>
  800ec3:	e9 0d ff ff ff       	jmpq   800dd5 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ec8:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800ecc:	e9 04 ff ff ff       	jmpq   800dd5 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800ed1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ed4:	83 f8 30             	cmp    $0x30,%eax
  800ed7:	73 17                	jae    800ef0 <vprintfmt+0x1a4>
  800ed9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800edd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ee0:	89 c0                	mov    %eax,%eax
  800ee2:	48 01 d0             	add    %rdx,%rax
  800ee5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ee8:	83 c2 08             	add    $0x8,%edx
  800eeb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800eee:	eb 0f                	jmp    800eff <vprintfmt+0x1b3>
  800ef0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ef4:	48 89 d0             	mov    %rdx,%rax
  800ef7:	48 83 c2 08          	add    $0x8,%rdx
  800efb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800eff:	8b 10                	mov    (%rax),%edx
  800f01:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800f05:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f09:	48 89 ce             	mov    %rcx,%rsi
  800f0c:	89 d7                	mov    %edx,%edi
  800f0e:	ff d0                	callq  *%rax
			break;
  800f10:	e9 40 03 00 00       	jmpq   801255 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800f15:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f18:	83 f8 30             	cmp    $0x30,%eax
  800f1b:	73 17                	jae    800f34 <vprintfmt+0x1e8>
  800f1d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f21:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f24:	89 c0                	mov    %eax,%eax
  800f26:	48 01 d0             	add    %rdx,%rax
  800f29:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f2c:	83 c2 08             	add    $0x8,%edx
  800f2f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800f32:	eb 0f                	jmp    800f43 <vprintfmt+0x1f7>
  800f34:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f38:	48 89 d0             	mov    %rdx,%rax
  800f3b:	48 83 c2 08          	add    $0x8,%rdx
  800f3f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f43:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800f45:	85 db                	test   %ebx,%ebx
  800f47:	79 02                	jns    800f4b <vprintfmt+0x1ff>
				err = -err;
  800f49:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800f4b:	83 fb 15             	cmp    $0x15,%ebx
  800f4e:	7f 16                	jg     800f66 <vprintfmt+0x21a>
  800f50:	48 b8 00 48 80 00 00 	movabs $0x804800,%rax
  800f57:	00 00 00 
  800f5a:	48 63 d3             	movslq %ebx,%rdx
  800f5d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800f61:	4d 85 e4             	test   %r12,%r12
  800f64:	75 2e                	jne    800f94 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800f66:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f6a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f6e:	89 d9                	mov    %ebx,%ecx
  800f70:	48 ba c1 48 80 00 00 	movabs $0x8048c1,%rdx
  800f77:	00 00 00 
  800f7a:	48 89 c7             	mov    %rax,%rdi
  800f7d:	b8 00 00 00 00       	mov    $0x0,%eax
  800f82:	49 b8 64 12 80 00 00 	movabs $0x801264,%r8
  800f89:	00 00 00 
  800f8c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f8f:	e9 c1 02 00 00       	jmpq   801255 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f94:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f98:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f9c:	4c 89 e1             	mov    %r12,%rcx
  800f9f:	48 ba ca 48 80 00 00 	movabs $0x8048ca,%rdx
  800fa6:	00 00 00 
  800fa9:	48 89 c7             	mov    %rax,%rdi
  800fac:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb1:	49 b8 64 12 80 00 00 	movabs $0x801264,%r8
  800fb8:	00 00 00 
  800fbb:	41 ff d0             	callq  *%r8
			break;
  800fbe:	e9 92 02 00 00       	jmpq   801255 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800fc3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fc6:	83 f8 30             	cmp    $0x30,%eax
  800fc9:	73 17                	jae    800fe2 <vprintfmt+0x296>
  800fcb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800fcf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fd2:	89 c0                	mov    %eax,%eax
  800fd4:	48 01 d0             	add    %rdx,%rax
  800fd7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fda:	83 c2 08             	add    $0x8,%edx
  800fdd:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800fe0:	eb 0f                	jmp    800ff1 <vprintfmt+0x2a5>
  800fe2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800fe6:	48 89 d0             	mov    %rdx,%rax
  800fe9:	48 83 c2 08          	add    $0x8,%rdx
  800fed:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ff1:	4c 8b 20             	mov    (%rax),%r12
  800ff4:	4d 85 e4             	test   %r12,%r12
  800ff7:	75 0a                	jne    801003 <vprintfmt+0x2b7>
				p = "(null)";
  800ff9:	49 bc cd 48 80 00 00 	movabs $0x8048cd,%r12
  801000:	00 00 00 
			if (width > 0 && padc != '-')
  801003:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801007:	7e 3f                	jle    801048 <vprintfmt+0x2fc>
  801009:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80100d:	74 39                	je     801048 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  80100f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801012:	48 98                	cltq   
  801014:	48 89 c6             	mov    %rax,%rsi
  801017:	4c 89 e7             	mov    %r12,%rdi
  80101a:	48 b8 10 15 80 00 00 	movabs $0x801510,%rax
  801021:	00 00 00 
  801024:	ff d0                	callq  *%rax
  801026:	29 45 dc             	sub    %eax,-0x24(%rbp)
  801029:	eb 17                	jmp    801042 <vprintfmt+0x2f6>
					putch(padc, putdat);
  80102b:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  80102f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801033:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801037:	48 89 ce             	mov    %rcx,%rsi
  80103a:	89 d7                	mov    %edx,%edi
  80103c:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80103e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801042:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801046:	7f e3                	jg     80102b <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801048:	eb 37                	jmp    801081 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  80104a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80104e:	74 1e                	je     80106e <vprintfmt+0x322>
  801050:	83 fb 1f             	cmp    $0x1f,%ebx
  801053:	7e 05                	jle    80105a <vprintfmt+0x30e>
  801055:	83 fb 7e             	cmp    $0x7e,%ebx
  801058:	7e 14                	jle    80106e <vprintfmt+0x322>
					putch('?', putdat);
  80105a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80105e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801062:	48 89 d6             	mov    %rdx,%rsi
  801065:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80106a:	ff d0                	callq  *%rax
  80106c:	eb 0f                	jmp    80107d <vprintfmt+0x331>
				else
					putch(ch, putdat);
  80106e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801072:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801076:	48 89 d6             	mov    %rdx,%rsi
  801079:	89 df                	mov    %ebx,%edi
  80107b:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80107d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801081:	4c 89 e0             	mov    %r12,%rax
  801084:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801088:	0f b6 00             	movzbl (%rax),%eax
  80108b:	0f be d8             	movsbl %al,%ebx
  80108e:	85 db                	test   %ebx,%ebx
  801090:	74 10                	je     8010a2 <vprintfmt+0x356>
  801092:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801096:	78 b2                	js     80104a <vprintfmt+0x2fe>
  801098:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80109c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8010a0:	79 a8                	jns    80104a <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010a2:	eb 16                	jmp    8010ba <vprintfmt+0x36e>
				putch(' ', putdat);
  8010a4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010a8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010ac:	48 89 d6             	mov    %rdx,%rsi
  8010af:	bf 20 00 00 00       	mov    $0x20,%edi
  8010b4:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010b6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8010ba:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8010be:	7f e4                	jg     8010a4 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  8010c0:	e9 90 01 00 00       	jmpq   801255 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8010c5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8010c9:	be 03 00 00 00       	mov    $0x3,%esi
  8010ce:	48 89 c7             	mov    %rax,%rdi
  8010d1:	48 b8 3c 0c 80 00 00 	movabs $0x800c3c,%rax
  8010d8:	00 00 00 
  8010db:	ff d0                	callq  *%rax
  8010dd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8010e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e5:	48 85 c0             	test   %rax,%rax
  8010e8:	79 1d                	jns    801107 <vprintfmt+0x3bb>
				putch('-', putdat);
  8010ea:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010ee:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010f2:	48 89 d6             	mov    %rdx,%rsi
  8010f5:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8010fa:	ff d0                	callq  *%rax
				num = -(long long) num;
  8010fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801100:	48 f7 d8             	neg    %rax
  801103:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801107:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80110e:	e9 d5 00 00 00       	jmpq   8011e8 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801113:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801117:	be 03 00 00 00       	mov    $0x3,%esi
  80111c:	48 89 c7             	mov    %rax,%rdi
  80111f:	48 b8 2c 0b 80 00 00 	movabs $0x800b2c,%rax
  801126:	00 00 00 
  801129:	ff d0                	callq  *%rax
  80112b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  80112f:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801136:	e9 ad 00 00 00       	jmpq   8011e8 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  80113b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80113f:	be 03 00 00 00       	mov    $0x3,%esi
  801144:	48 89 c7             	mov    %rax,%rdi
  801147:	48 b8 2c 0b 80 00 00 	movabs $0x800b2c,%rax
  80114e:	00 00 00 
  801151:	ff d0                	callq  *%rax
  801153:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  801157:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  80115e:	e9 85 00 00 00       	jmpq   8011e8 <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  801163:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801167:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80116b:	48 89 d6             	mov    %rdx,%rsi
  80116e:	bf 30 00 00 00       	mov    $0x30,%edi
  801173:	ff d0                	callq  *%rax
			putch('x', putdat);
  801175:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801179:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80117d:	48 89 d6             	mov    %rdx,%rsi
  801180:	bf 78 00 00 00       	mov    $0x78,%edi
  801185:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801187:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80118a:	83 f8 30             	cmp    $0x30,%eax
  80118d:	73 17                	jae    8011a6 <vprintfmt+0x45a>
  80118f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801193:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801196:	89 c0                	mov    %eax,%eax
  801198:	48 01 d0             	add    %rdx,%rax
  80119b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80119e:	83 c2 08             	add    $0x8,%edx
  8011a1:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8011a4:	eb 0f                	jmp    8011b5 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  8011a6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8011aa:	48 89 d0             	mov    %rdx,%rax
  8011ad:	48 83 c2 08          	add    $0x8,%rdx
  8011b1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8011b5:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8011b8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  8011bc:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8011c3:	eb 23                	jmp    8011e8 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8011c5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8011c9:	be 03 00 00 00       	mov    $0x3,%esi
  8011ce:	48 89 c7             	mov    %rax,%rdi
  8011d1:	48 b8 2c 0b 80 00 00 	movabs $0x800b2c,%rax
  8011d8:	00 00 00 
  8011db:	ff d0                	callq  *%rax
  8011dd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8011e1:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8011e8:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8011ed:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8011f0:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8011f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011f7:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8011fb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011ff:	45 89 c1             	mov    %r8d,%r9d
  801202:	41 89 f8             	mov    %edi,%r8d
  801205:	48 89 c7             	mov    %rax,%rdi
  801208:	48 b8 71 0a 80 00 00 	movabs $0x800a71,%rax
  80120f:	00 00 00 
  801212:	ff d0                	callq  *%rax
			break;
  801214:	eb 3f                	jmp    801255 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  801216:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80121a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80121e:	48 89 d6             	mov    %rdx,%rsi
  801221:	89 df                	mov    %ebx,%edi
  801223:	ff d0                	callq  *%rax
			break;
  801225:	eb 2e                	jmp    801255 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801227:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80122b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80122f:	48 89 d6             	mov    %rdx,%rsi
  801232:	bf 25 00 00 00       	mov    $0x25,%edi
  801237:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801239:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80123e:	eb 05                	jmp    801245 <vprintfmt+0x4f9>
  801240:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801245:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801249:	48 83 e8 01          	sub    $0x1,%rax
  80124d:	0f b6 00             	movzbl (%rax),%eax
  801250:	3c 25                	cmp    $0x25,%al
  801252:	75 ec                	jne    801240 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  801254:	90                   	nop
		}
	}
  801255:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801256:	e9 43 fb ff ff       	jmpq   800d9e <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  80125b:	48 83 c4 60          	add    $0x60,%rsp
  80125f:	5b                   	pop    %rbx
  801260:	41 5c                	pop    %r12
  801262:	5d                   	pop    %rbp
  801263:	c3                   	retq   

0000000000801264 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801264:	55                   	push   %rbp
  801265:	48 89 e5             	mov    %rsp,%rbp
  801268:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80126f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801276:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80127d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801284:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80128b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801292:	84 c0                	test   %al,%al
  801294:	74 20                	je     8012b6 <printfmt+0x52>
  801296:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80129a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80129e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8012a2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8012a6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8012aa:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8012ae:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8012b2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8012b6:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8012bd:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8012c4:	00 00 00 
  8012c7:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8012ce:	00 00 00 
  8012d1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8012d5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8012dc:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8012e3:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8012ea:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8012f1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8012f8:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8012ff:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801306:	48 89 c7             	mov    %rax,%rdi
  801309:	48 b8 4c 0d 80 00 00 	movabs $0x800d4c,%rax
  801310:	00 00 00 
  801313:	ff d0                	callq  *%rax
	va_end(ap);
}
  801315:	c9                   	leaveq 
  801316:	c3                   	retq   

0000000000801317 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801317:	55                   	push   %rbp
  801318:	48 89 e5             	mov    %rsp,%rbp
  80131b:	48 83 ec 10          	sub    $0x10,%rsp
  80131f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801322:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801326:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80132a:	8b 40 10             	mov    0x10(%rax),%eax
  80132d:	8d 50 01             	lea    0x1(%rax),%edx
  801330:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801334:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801337:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80133b:	48 8b 10             	mov    (%rax),%rdx
  80133e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801342:	48 8b 40 08          	mov    0x8(%rax),%rax
  801346:	48 39 c2             	cmp    %rax,%rdx
  801349:	73 17                	jae    801362 <sprintputch+0x4b>
		*b->buf++ = ch;
  80134b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80134f:	48 8b 00             	mov    (%rax),%rax
  801352:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801356:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80135a:	48 89 0a             	mov    %rcx,(%rdx)
  80135d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801360:	88 10                	mov    %dl,(%rax)
}
  801362:	c9                   	leaveq 
  801363:	c3                   	retq   

0000000000801364 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801364:	55                   	push   %rbp
  801365:	48 89 e5             	mov    %rsp,%rbp
  801368:	48 83 ec 50          	sub    $0x50,%rsp
  80136c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801370:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801373:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801377:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80137b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80137f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801383:	48 8b 0a             	mov    (%rdx),%rcx
  801386:	48 89 08             	mov    %rcx,(%rax)
  801389:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80138d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801391:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801395:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801399:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80139d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8013a1:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8013a4:	48 98                	cltq   
  8013a6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013aa:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8013ae:	48 01 d0             	add    %rdx,%rax
  8013b1:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8013b5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8013bc:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8013c1:	74 06                	je     8013c9 <vsnprintf+0x65>
  8013c3:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8013c7:	7f 07                	jg     8013d0 <vsnprintf+0x6c>
		return -E_INVAL;
  8013c9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013ce:	eb 2f                	jmp    8013ff <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8013d0:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8013d4:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8013d8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8013dc:	48 89 c6             	mov    %rax,%rsi
  8013df:	48 bf 17 13 80 00 00 	movabs $0x801317,%rdi
  8013e6:	00 00 00 
  8013e9:	48 b8 4c 0d 80 00 00 	movabs $0x800d4c,%rax
  8013f0:	00 00 00 
  8013f3:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8013f5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8013f9:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8013fc:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8013ff:	c9                   	leaveq 
  801400:	c3                   	retq   

0000000000801401 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801401:	55                   	push   %rbp
  801402:	48 89 e5             	mov    %rsp,%rbp
  801405:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80140c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801413:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801419:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801420:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801427:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80142e:	84 c0                	test   %al,%al
  801430:	74 20                	je     801452 <snprintf+0x51>
  801432:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801436:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80143a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80143e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801442:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801446:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80144a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80144e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801452:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801459:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801460:	00 00 00 
  801463:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80146a:	00 00 00 
  80146d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801471:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801478:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80147f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801486:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80148d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801494:	48 8b 0a             	mov    (%rdx),%rcx
  801497:	48 89 08             	mov    %rcx,(%rax)
  80149a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80149e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8014a2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8014a6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8014aa:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8014b1:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8014b8:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8014be:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8014c5:	48 89 c7             	mov    %rax,%rdi
  8014c8:	48 b8 64 13 80 00 00 	movabs $0x801364,%rax
  8014cf:	00 00 00 
  8014d2:	ff d0                	callq  *%rax
  8014d4:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8014da:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8014e0:	c9                   	leaveq 
  8014e1:	c3                   	retq   

00000000008014e2 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8014e2:	55                   	push   %rbp
  8014e3:	48 89 e5             	mov    %rsp,%rbp
  8014e6:	48 83 ec 18          	sub    $0x18,%rsp
  8014ea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8014ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8014f5:	eb 09                	jmp    801500 <strlen+0x1e>
		n++;
  8014f7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8014fb:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801500:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801504:	0f b6 00             	movzbl (%rax),%eax
  801507:	84 c0                	test   %al,%al
  801509:	75 ec                	jne    8014f7 <strlen+0x15>
		n++;
	return n;
  80150b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80150e:	c9                   	leaveq 
  80150f:	c3                   	retq   

0000000000801510 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801510:	55                   	push   %rbp
  801511:	48 89 e5             	mov    %rsp,%rbp
  801514:	48 83 ec 20          	sub    $0x20,%rsp
  801518:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80151c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801520:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801527:	eb 0e                	jmp    801537 <strnlen+0x27>
		n++;
  801529:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80152d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801532:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801537:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80153c:	74 0b                	je     801549 <strnlen+0x39>
  80153e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801542:	0f b6 00             	movzbl (%rax),%eax
  801545:	84 c0                	test   %al,%al
  801547:	75 e0                	jne    801529 <strnlen+0x19>
		n++;
	return n;
  801549:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80154c:	c9                   	leaveq 
  80154d:	c3                   	retq   

000000000080154e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80154e:	55                   	push   %rbp
  80154f:	48 89 e5             	mov    %rsp,%rbp
  801552:	48 83 ec 20          	sub    $0x20,%rsp
  801556:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80155a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80155e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801562:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801566:	90                   	nop
  801567:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80156b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80156f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801573:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801577:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80157b:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80157f:	0f b6 12             	movzbl (%rdx),%edx
  801582:	88 10                	mov    %dl,(%rax)
  801584:	0f b6 00             	movzbl (%rax),%eax
  801587:	84 c0                	test   %al,%al
  801589:	75 dc                	jne    801567 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80158b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80158f:	c9                   	leaveq 
  801590:	c3                   	retq   

0000000000801591 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801591:	55                   	push   %rbp
  801592:	48 89 e5             	mov    %rsp,%rbp
  801595:	48 83 ec 20          	sub    $0x20,%rsp
  801599:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80159d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8015a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015a5:	48 89 c7             	mov    %rax,%rdi
  8015a8:	48 b8 e2 14 80 00 00 	movabs $0x8014e2,%rax
  8015af:	00 00 00 
  8015b2:	ff d0                	callq  *%rax
  8015b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8015b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015ba:	48 63 d0             	movslq %eax,%rdx
  8015bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015c1:	48 01 c2             	add    %rax,%rdx
  8015c4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015c8:	48 89 c6             	mov    %rax,%rsi
  8015cb:	48 89 d7             	mov    %rdx,%rdi
  8015ce:	48 b8 4e 15 80 00 00 	movabs $0x80154e,%rax
  8015d5:	00 00 00 
  8015d8:	ff d0                	callq  *%rax
	return dst;
  8015da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015de:	c9                   	leaveq 
  8015df:	c3                   	retq   

00000000008015e0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8015e0:	55                   	push   %rbp
  8015e1:	48 89 e5             	mov    %rsp,%rbp
  8015e4:	48 83 ec 28          	sub    $0x28,%rsp
  8015e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015f0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8015f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015f8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8015fc:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801603:	00 
  801604:	eb 2a                	jmp    801630 <strncpy+0x50>
		*dst++ = *src;
  801606:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80160a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80160e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801612:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801616:	0f b6 12             	movzbl (%rdx),%edx
  801619:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80161b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80161f:	0f b6 00             	movzbl (%rax),%eax
  801622:	84 c0                	test   %al,%al
  801624:	74 05                	je     80162b <strncpy+0x4b>
			src++;
  801626:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80162b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801630:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801634:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801638:	72 cc                	jb     801606 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80163a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80163e:	c9                   	leaveq 
  80163f:	c3                   	retq   

0000000000801640 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801640:	55                   	push   %rbp
  801641:	48 89 e5             	mov    %rsp,%rbp
  801644:	48 83 ec 28          	sub    $0x28,%rsp
  801648:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80164c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801650:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801654:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801658:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80165c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801661:	74 3d                	je     8016a0 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801663:	eb 1d                	jmp    801682 <strlcpy+0x42>
			*dst++ = *src++;
  801665:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801669:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80166d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801671:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801675:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801679:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80167d:	0f b6 12             	movzbl (%rdx),%edx
  801680:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801682:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801687:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80168c:	74 0b                	je     801699 <strlcpy+0x59>
  80168e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801692:	0f b6 00             	movzbl (%rax),%eax
  801695:	84 c0                	test   %al,%al
  801697:	75 cc                	jne    801665 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801699:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80169d:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8016a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a8:	48 29 c2             	sub    %rax,%rdx
  8016ab:	48 89 d0             	mov    %rdx,%rax
}
  8016ae:	c9                   	leaveq 
  8016af:	c3                   	retq   

00000000008016b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016b0:	55                   	push   %rbp
  8016b1:	48 89 e5             	mov    %rsp,%rbp
  8016b4:	48 83 ec 10          	sub    $0x10,%rsp
  8016b8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016bc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8016c0:	eb 0a                	jmp    8016cc <strcmp+0x1c>
		p++, q++;
  8016c2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016c7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016d0:	0f b6 00             	movzbl (%rax),%eax
  8016d3:	84 c0                	test   %al,%al
  8016d5:	74 12                	je     8016e9 <strcmp+0x39>
  8016d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016db:	0f b6 10             	movzbl (%rax),%edx
  8016de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016e2:	0f b6 00             	movzbl (%rax),%eax
  8016e5:	38 c2                	cmp    %al,%dl
  8016e7:	74 d9                	je     8016c2 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ed:	0f b6 00             	movzbl (%rax),%eax
  8016f0:	0f b6 d0             	movzbl %al,%edx
  8016f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f7:	0f b6 00             	movzbl (%rax),%eax
  8016fa:	0f b6 c0             	movzbl %al,%eax
  8016fd:	29 c2                	sub    %eax,%edx
  8016ff:	89 d0                	mov    %edx,%eax
}
  801701:	c9                   	leaveq 
  801702:	c3                   	retq   

0000000000801703 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801703:	55                   	push   %rbp
  801704:	48 89 e5             	mov    %rsp,%rbp
  801707:	48 83 ec 18          	sub    $0x18,%rsp
  80170b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80170f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801713:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801717:	eb 0f                	jmp    801728 <strncmp+0x25>
		n--, p++, q++;
  801719:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80171e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801723:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801728:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80172d:	74 1d                	je     80174c <strncmp+0x49>
  80172f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801733:	0f b6 00             	movzbl (%rax),%eax
  801736:	84 c0                	test   %al,%al
  801738:	74 12                	je     80174c <strncmp+0x49>
  80173a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80173e:	0f b6 10             	movzbl (%rax),%edx
  801741:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801745:	0f b6 00             	movzbl (%rax),%eax
  801748:	38 c2                	cmp    %al,%dl
  80174a:	74 cd                	je     801719 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80174c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801751:	75 07                	jne    80175a <strncmp+0x57>
		return 0;
  801753:	b8 00 00 00 00       	mov    $0x0,%eax
  801758:	eb 18                	jmp    801772 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80175a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80175e:	0f b6 00             	movzbl (%rax),%eax
  801761:	0f b6 d0             	movzbl %al,%edx
  801764:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801768:	0f b6 00             	movzbl (%rax),%eax
  80176b:	0f b6 c0             	movzbl %al,%eax
  80176e:	29 c2                	sub    %eax,%edx
  801770:	89 d0                	mov    %edx,%eax
}
  801772:	c9                   	leaveq 
  801773:	c3                   	retq   

0000000000801774 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801774:	55                   	push   %rbp
  801775:	48 89 e5             	mov    %rsp,%rbp
  801778:	48 83 ec 0c          	sub    $0xc,%rsp
  80177c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801780:	89 f0                	mov    %esi,%eax
  801782:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801785:	eb 17                	jmp    80179e <strchr+0x2a>
		if (*s == c)
  801787:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80178b:	0f b6 00             	movzbl (%rax),%eax
  80178e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801791:	75 06                	jne    801799 <strchr+0x25>
			return (char *) s;
  801793:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801797:	eb 15                	jmp    8017ae <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801799:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80179e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017a2:	0f b6 00             	movzbl (%rax),%eax
  8017a5:	84 c0                	test   %al,%al
  8017a7:	75 de                	jne    801787 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8017a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ae:	c9                   	leaveq 
  8017af:	c3                   	retq   

00000000008017b0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8017b0:	55                   	push   %rbp
  8017b1:	48 89 e5             	mov    %rsp,%rbp
  8017b4:	48 83 ec 0c          	sub    $0xc,%rsp
  8017b8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017bc:	89 f0                	mov    %esi,%eax
  8017be:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8017c1:	eb 13                	jmp    8017d6 <strfind+0x26>
		if (*s == c)
  8017c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017c7:	0f b6 00             	movzbl (%rax),%eax
  8017ca:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8017cd:	75 02                	jne    8017d1 <strfind+0x21>
			break;
  8017cf:	eb 10                	jmp    8017e1 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8017d1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017da:	0f b6 00             	movzbl (%rax),%eax
  8017dd:	84 c0                	test   %al,%al
  8017df:	75 e2                	jne    8017c3 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8017e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8017e5:	c9                   	leaveq 
  8017e6:	c3                   	retq   

00000000008017e7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8017e7:	55                   	push   %rbp
  8017e8:	48 89 e5             	mov    %rsp,%rbp
  8017eb:	48 83 ec 18          	sub    $0x18,%rsp
  8017ef:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017f3:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8017f6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8017fa:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017ff:	75 06                	jne    801807 <memset+0x20>
		return v;
  801801:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801805:	eb 69                	jmp    801870 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801807:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80180b:	83 e0 03             	and    $0x3,%eax
  80180e:	48 85 c0             	test   %rax,%rax
  801811:	75 48                	jne    80185b <memset+0x74>
  801813:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801817:	83 e0 03             	and    $0x3,%eax
  80181a:	48 85 c0             	test   %rax,%rax
  80181d:	75 3c                	jne    80185b <memset+0x74>
		c &= 0xFF;
  80181f:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801826:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801829:	c1 e0 18             	shl    $0x18,%eax
  80182c:	89 c2                	mov    %eax,%edx
  80182e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801831:	c1 e0 10             	shl    $0x10,%eax
  801834:	09 c2                	or     %eax,%edx
  801836:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801839:	c1 e0 08             	shl    $0x8,%eax
  80183c:	09 d0                	or     %edx,%eax
  80183e:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801841:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801845:	48 c1 e8 02          	shr    $0x2,%rax
  801849:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80184c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801850:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801853:	48 89 d7             	mov    %rdx,%rdi
  801856:	fc                   	cld    
  801857:	f3 ab                	rep stos %eax,%es:(%rdi)
  801859:	eb 11                	jmp    80186c <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80185b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80185f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801862:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801866:	48 89 d7             	mov    %rdx,%rdi
  801869:	fc                   	cld    
  80186a:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80186c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801870:	c9                   	leaveq 
  801871:	c3                   	retq   

0000000000801872 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801872:	55                   	push   %rbp
  801873:	48 89 e5             	mov    %rsp,%rbp
  801876:	48 83 ec 28          	sub    $0x28,%rsp
  80187a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80187e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801882:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801886:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80188a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80188e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801892:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801896:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80189a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80189e:	0f 83 88 00 00 00    	jae    80192c <memmove+0xba>
  8018a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018ac:	48 01 d0             	add    %rdx,%rax
  8018af:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8018b3:	76 77                	jbe    80192c <memmove+0xba>
		s += n;
  8018b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b9:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8018bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c1:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8018c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018c9:	83 e0 03             	and    $0x3,%eax
  8018cc:	48 85 c0             	test   %rax,%rax
  8018cf:	75 3b                	jne    80190c <memmove+0x9a>
  8018d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018d5:	83 e0 03             	and    $0x3,%eax
  8018d8:	48 85 c0             	test   %rax,%rax
  8018db:	75 2f                	jne    80190c <memmove+0x9a>
  8018dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e1:	83 e0 03             	and    $0x3,%eax
  8018e4:	48 85 c0             	test   %rax,%rax
  8018e7:	75 23                	jne    80190c <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8018e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018ed:	48 83 e8 04          	sub    $0x4,%rax
  8018f1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018f5:	48 83 ea 04          	sub    $0x4,%rdx
  8018f9:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8018fd:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801901:	48 89 c7             	mov    %rax,%rdi
  801904:	48 89 d6             	mov    %rdx,%rsi
  801907:	fd                   	std    
  801908:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80190a:	eb 1d                	jmp    801929 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80190c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801910:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801914:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801918:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80191c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801920:	48 89 d7             	mov    %rdx,%rdi
  801923:	48 89 c1             	mov    %rax,%rcx
  801926:	fd                   	std    
  801927:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801929:	fc                   	cld    
  80192a:	eb 57                	jmp    801983 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80192c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801930:	83 e0 03             	and    $0x3,%eax
  801933:	48 85 c0             	test   %rax,%rax
  801936:	75 36                	jne    80196e <memmove+0xfc>
  801938:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80193c:	83 e0 03             	and    $0x3,%eax
  80193f:	48 85 c0             	test   %rax,%rax
  801942:	75 2a                	jne    80196e <memmove+0xfc>
  801944:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801948:	83 e0 03             	and    $0x3,%eax
  80194b:	48 85 c0             	test   %rax,%rax
  80194e:	75 1e                	jne    80196e <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801950:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801954:	48 c1 e8 02          	shr    $0x2,%rax
  801958:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80195b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80195f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801963:	48 89 c7             	mov    %rax,%rdi
  801966:	48 89 d6             	mov    %rdx,%rsi
  801969:	fc                   	cld    
  80196a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80196c:	eb 15                	jmp    801983 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80196e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801972:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801976:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80197a:	48 89 c7             	mov    %rax,%rdi
  80197d:	48 89 d6             	mov    %rdx,%rsi
  801980:	fc                   	cld    
  801981:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801983:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801987:	c9                   	leaveq 
  801988:	c3                   	retq   

0000000000801989 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801989:	55                   	push   %rbp
  80198a:	48 89 e5             	mov    %rsp,%rbp
  80198d:	48 83 ec 18          	sub    $0x18,%rsp
  801991:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801995:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801999:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80199d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019a1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8019a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019a9:	48 89 ce             	mov    %rcx,%rsi
  8019ac:	48 89 c7             	mov    %rax,%rdi
  8019af:	48 b8 72 18 80 00 00 	movabs $0x801872,%rax
  8019b6:	00 00 00 
  8019b9:	ff d0                	callq  *%rax
}
  8019bb:	c9                   	leaveq 
  8019bc:	c3                   	retq   

00000000008019bd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8019bd:	55                   	push   %rbp
  8019be:	48 89 e5             	mov    %rsp,%rbp
  8019c1:	48 83 ec 28          	sub    $0x28,%rsp
  8019c5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019c9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8019cd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8019d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019d5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8019d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019dd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8019e1:	eb 36                	jmp    801a19 <memcmp+0x5c>
		if (*s1 != *s2)
  8019e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019e7:	0f b6 10             	movzbl (%rax),%edx
  8019ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019ee:	0f b6 00             	movzbl (%rax),%eax
  8019f1:	38 c2                	cmp    %al,%dl
  8019f3:	74 1a                	je     801a0f <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8019f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019f9:	0f b6 00             	movzbl (%rax),%eax
  8019fc:	0f b6 d0             	movzbl %al,%edx
  8019ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a03:	0f b6 00             	movzbl (%rax),%eax
  801a06:	0f b6 c0             	movzbl %al,%eax
  801a09:	29 c2                	sub    %eax,%edx
  801a0b:	89 d0                	mov    %edx,%eax
  801a0d:	eb 20                	jmp    801a2f <memcmp+0x72>
		s1++, s2++;
  801a0f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a14:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801a19:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a1d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801a21:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801a25:	48 85 c0             	test   %rax,%rax
  801a28:	75 b9                	jne    8019e3 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801a2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a2f:	c9                   	leaveq 
  801a30:	c3                   	retq   

0000000000801a31 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801a31:	55                   	push   %rbp
  801a32:	48 89 e5             	mov    %rsp,%rbp
  801a35:	48 83 ec 28          	sub    $0x28,%rsp
  801a39:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a3d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801a40:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801a44:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a48:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a4c:	48 01 d0             	add    %rdx,%rax
  801a4f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801a53:	eb 15                	jmp    801a6a <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a59:	0f b6 10             	movzbl (%rax),%edx
  801a5c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a5f:	38 c2                	cmp    %al,%dl
  801a61:	75 02                	jne    801a65 <memfind+0x34>
			break;
  801a63:	eb 0f                	jmp    801a74 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801a65:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801a6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a6e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801a72:	72 e1                	jb     801a55 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801a74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a78:	c9                   	leaveq 
  801a79:	c3                   	retq   

0000000000801a7a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a7a:	55                   	push   %rbp
  801a7b:	48 89 e5             	mov    %rsp,%rbp
  801a7e:	48 83 ec 34          	sub    $0x34,%rsp
  801a82:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801a86:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801a8a:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801a8d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801a94:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801a9b:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a9c:	eb 05                	jmp    801aa3 <strtol+0x29>
		s++;
  801a9e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801aa3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa7:	0f b6 00             	movzbl (%rax),%eax
  801aaa:	3c 20                	cmp    $0x20,%al
  801aac:	74 f0                	je     801a9e <strtol+0x24>
  801aae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ab2:	0f b6 00             	movzbl (%rax),%eax
  801ab5:	3c 09                	cmp    $0x9,%al
  801ab7:	74 e5                	je     801a9e <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801ab9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801abd:	0f b6 00             	movzbl (%rax),%eax
  801ac0:	3c 2b                	cmp    $0x2b,%al
  801ac2:	75 07                	jne    801acb <strtol+0x51>
		s++;
  801ac4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801ac9:	eb 17                	jmp    801ae2 <strtol+0x68>
	else if (*s == '-')
  801acb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801acf:	0f b6 00             	movzbl (%rax),%eax
  801ad2:	3c 2d                	cmp    $0x2d,%al
  801ad4:	75 0c                	jne    801ae2 <strtol+0x68>
		s++, neg = 1;
  801ad6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801adb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ae2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801ae6:	74 06                	je     801aee <strtol+0x74>
  801ae8:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801aec:	75 28                	jne    801b16 <strtol+0x9c>
  801aee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801af2:	0f b6 00             	movzbl (%rax),%eax
  801af5:	3c 30                	cmp    $0x30,%al
  801af7:	75 1d                	jne    801b16 <strtol+0x9c>
  801af9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801afd:	48 83 c0 01          	add    $0x1,%rax
  801b01:	0f b6 00             	movzbl (%rax),%eax
  801b04:	3c 78                	cmp    $0x78,%al
  801b06:	75 0e                	jne    801b16 <strtol+0x9c>
		s += 2, base = 16;
  801b08:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801b0d:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801b14:	eb 2c                	jmp    801b42 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801b16:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801b1a:	75 19                	jne    801b35 <strtol+0xbb>
  801b1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b20:	0f b6 00             	movzbl (%rax),%eax
  801b23:	3c 30                	cmp    $0x30,%al
  801b25:	75 0e                	jne    801b35 <strtol+0xbb>
		s++, base = 8;
  801b27:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801b2c:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801b33:	eb 0d                	jmp    801b42 <strtol+0xc8>
	else if (base == 0)
  801b35:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801b39:	75 07                	jne    801b42 <strtol+0xc8>
		base = 10;
  801b3b:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801b42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b46:	0f b6 00             	movzbl (%rax),%eax
  801b49:	3c 2f                	cmp    $0x2f,%al
  801b4b:	7e 1d                	jle    801b6a <strtol+0xf0>
  801b4d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b51:	0f b6 00             	movzbl (%rax),%eax
  801b54:	3c 39                	cmp    $0x39,%al
  801b56:	7f 12                	jg     801b6a <strtol+0xf0>
			dig = *s - '0';
  801b58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b5c:	0f b6 00             	movzbl (%rax),%eax
  801b5f:	0f be c0             	movsbl %al,%eax
  801b62:	83 e8 30             	sub    $0x30,%eax
  801b65:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801b68:	eb 4e                	jmp    801bb8 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801b6a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b6e:	0f b6 00             	movzbl (%rax),%eax
  801b71:	3c 60                	cmp    $0x60,%al
  801b73:	7e 1d                	jle    801b92 <strtol+0x118>
  801b75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b79:	0f b6 00             	movzbl (%rax),%eax
  801b7c:	3c 7a                	cmp    $0x7a,%al
  801b7e:	7f 12                	jg     801b92 <strtol+0x118>
			dig = *s - 'a' + 10;
  801b80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b84:	0f b6 00             	movzbl (%rax),%eax
  801b87:	0f be c0             	movsbl %al,%eax
  801b8a:	83 e8 57             	sub    $0x57,%eax
  801b8d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801b90:	eb 26                	jmp    801bb8 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801b92:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b96:	0f b6 00             	movzbl (%rax),%eax
  801b99:	3c 40                	cmp    $0x40,%al
  801b9b:	7e 48                	jle    801be5 <strtol+0x16b>
  801b9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ba1:	0f b6 00             	movzbl (%rax),%eax
  801ba4:	3c 5a                	cmp    $0x5a,%al
  801ba6:	7f 3d                	jg     801be5 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801ba8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bac:	0f b6 00             	movzbl (%rax),%eax
  801baf:	0f be c0             	movsbl %al,%eax
  801bb2:	83 e8 37             	sub    $0x37,%eax
  801bb5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801bb8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801bbb:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801bbe:	7c 02                	jl     801bc2 <strtol+0x148>
			break;
  801bc0:	eb 23                	jmp    801be5 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801bc2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801bc7:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801bca:	48 98                	cltq   
  801bcc:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801bd1:	48 89 c2             	mov    %rax,%rdx
  801bd4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801bd7:	48 98                	cltq   
  801bd9:	48 01 d0             	add    %rdx,%rax
  801bdc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801be0:	e9 5d ff ff ff       	jmpq   801b42 <strtol+0xc8>

	if (endptr)
  801be5:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801bea:	74 0b                	je     801bf7 <strtol+0x17d>
		*endptr = (char *) s;
  801bec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801bf0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801bf4:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801bf7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bfb:	74 09                	je     801c06 <strtol+0x18c>
  801bfd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c01:	48 f7 d8             	neg    %rax
  801c04:	eb 04                	jmp    801c0a <strtol+0x190>
  801c06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801c0a:	c9                   	leaveq 
  801c0b:	c3                   	retq   

0000000000801c0c <strstr>:

char * strstr(const char *in, const char *str)
{
  801c0c:	55                   	push   %rbp
  801c0d:	48 89 e5             	mov    %rsp,%rbp
  801c10:	48 83 ec 30          	sub    $0x30,%rsp
  801c14:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801c18:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801c1c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c20:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801c24:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801c28:	0f b6 00             	movzbl (%rax),%eax
  801c2b:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801c2e:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801c32:	75 06                	jne    801c3a <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801c34:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c38:	eb 6b                	jmp    801ca5 <strstr+0x99>

	len = strlen(str);
  801c3a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c3e:	48 89 c7             	mov    %rax,%rdi
  801c41:	48 b8 e2 14 80 00 00 	movabs $0x8014e2,%rax
  801c48:	00 00 00 
  801c4b:	ff d0                	callq  *%rax
  801c4d:	48 98                	cltq   
  801c4f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801c53:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c57:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801c5b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801c5f:	0f b6 00             	movzbl (%rax),%eax
  801c62:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801c65:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801c69:	75 07                	jne    801c72 <strstr+0x66>
				return (char *) 0;
  801c6b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c70:	eb 33                	jmp    801ca5 <strstr+0x99>
		} while (sc != c);
  801c72:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801c76:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801c79:	75 d8                	jne    801c53 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801c7b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c7f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801c83:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c87:	48 89 ce             	mov    %rcx,%rsi
  801c8a:	48 89 c7             	mov    %rax,%rdi
  801c8d:	48 b8 03 17 80 00 00 	movabs $0x801703,%rax
  801c94:	00 00 00 
  801c97:	ff d0                	callq  *%rax
  801c99:	85 c0                	test   %eax,%eax
  801c9b:	75 b6                	jne    801c53 <strstr+0x47>

	return (char *) (in - 1);
  801c9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ca1:	48 83 e8 01          	sub    $0x1,%rax
}
  801ca5:	c9                   	leaveq 
  801ca6:	c3                   	retq   

0000000000801ca7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801ca7:	55                   	push   %rbp
  801ca8:	48 89 e5             	mov    %rsp,%rbp
  801cab:	53                   	push   %rbx
  801cac:	48 83 ec 48          	sub    $0x48,%rsp
  801cb0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801cb3:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801cb6:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801cba:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801cbe:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801cc2:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  801cc6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801cc9:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801ccd:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801cd1:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801cd5:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801cd9:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801cdd:	4c 89 c3             	mov    %r8,%rbx
  801ce0:	cd 30                	int    $0x30
  801ce2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  801ce6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801cea:	74 3e                	je     801d2a <syscall+0x83>
  801cec:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801cf1:	7e 37                	jle    801d2a <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801cf3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801cf7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801cfa:	49 89 d0             	mov    %rdx,%r8
  801cfd:	89 c1                	mov    %eax,%ecx
  801cff:	48 ba 88 4b 80 00 00 	movabs $0x804b88,%rdx
  801d06:	00 00 00 
  801d09:	be 4a 00 00 00       	mov    $0x4a,%esi
  801d0e:	48 bf a5 4b 80 00 00 	movabs $0x804ba5,%rdi
  801d15:	00 00 00 
  801d18:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1d:	49 b9 60 07 80 00 00 	movabs $0x800760,%r9
  801d24:	00 00 00 
  801d27:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  801d2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801d2e:	48 83 c4 48          	add    $0x48,%rsp
  801d32:	5b                   	pop    %rbx
  801d33:	5d                   	pop    %rbp
  801d34:	c3                   	retq   

0000000000801d35 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801d35:	55                   	push   %rbp
  801d36:	48 89 e5             	mov    %rsp,%rbp
  801d39:	48 83 ec 20          	sub    $0x20,%rsp
  801d3d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d41:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801d45:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d49:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d4d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d54:	00 
  801d55:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d5b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d61:	48 89 d1             	mov    %rdx,%rcx
  801d64:	48 89 c2             	mov    %rax,%rdx
  801d67:	be 00 00 00 00       	mov    $0x0,%esi
  801d6c:	bf 00 00 00 00       	mov    $0x0,%edi
  801d71:	48 b8 a7 1c 80 00 00 	movabs $0x801ca7,%rax
  801d78:	00 00 00 
  801d7b:	ff d0                	callq  *%rax
}
  801d7d:	c9                   	leaveq 
  801d7e:	c3                   	retq   

0000000000801d7f <sys_cgetc>:

int
sys_cgetc(void)
{
  801d7f:	55                   	push   %rbp
  801d80:	48 89 e5             	mov    %rsp,%rbp
  801d83:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801d87:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d8e:	00 
  801d8f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d95:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d9b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801da0:	ba 00 00 00 00       	mov    $0x0,%edx
  801da5:	be 00 00 00 00       	mov    $0x0,%esi
  801daa:	bf 01 00 00 00       	mov    $0x1,%edi
  801daf:	48 b8 a7 1c 80 00 00 	movabs $0x801ca7,%rax
  801db6:	00 00 00 
  801db9:	ff d0                	callq  *%rax
}
  801dbb:	c9                   	leaveq 
  801dbc:	c3                   	retq   

0000000000801dbd <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801dbd:	55                   	push   %rbp
  801dbe:	48 89 e5             	mov    %rsp,%rbp
  801dc1:	48 83 ec 10          	sub    $0x10,%rsp
  801dc5:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801dc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dcb:	48 98                	cltq   
  801dcd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dd4:	00 
  801dd5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ddb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801de1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801de6:	48 89 c2             	mov    %rax,%rdx
  801de9:	be 01 00 00 00       	mov    $0x1,%esi
  801dee:	bf 03 00 00 00       	mov    $0x3,%edi
  801df3:	48 b8 a7 1c 80 00 00 	movabs $0x801ca7,%rax
  801dfa:	00 00 00 
  801dfd:	ff d0                	callq  *%rax
}
  801dff:	c9                   	leaveq 
  801e00:	c3                   	retq   

0000000000801e01 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801e01:	55                   	push   %rbp
  801e02:	48 89 e5             	mov    %rsp,%rbp
  801e05:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801e09:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e10:	00 
  801e11:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e17:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e1d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e22:	ba 00 00 00 00       	mov    $0x0,%edx
  801e27:	be 00 00 00 00       	mov    $0x0,%esi
  801e2c:	bf 02 00 00 00       	mov    $0x2,%edi
  801e31:	48 b8 a7 1c 80 00 00 	movabs $0x801ca7,%rax
  801e38:	00 00 00 
  801e3b:	ff d0                	callq  *%rax
}
  801e3d:	c9                   	leaveq 
  801e3e:	c3                   	retq   

0000000000801e3f <sys_yield>:

void
sys_yield(void)
{
  801e3f:	55                   	push   %rbp
  801e40:	48 89 e5             	mov    %rsp,%rbp
  801e43:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801e47:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e4e:	00 
  801e4f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e55:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e5b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e60:	ba 00 00 00 00       	mov    $0x0,%edx
  801e65:	be 00 00 00 00       	mov    $0x0,%esi
  801e6a:	bf 0b 00 00 00       	mov    $0xb,%edi
  801e6f:	48 b8 a7 1c 80 00 00 	movabs $0x801ca7,%rax
  801e76:	00 00 00 
  801e79:	ff d0                	callq  *%rax
}
  801e7b:	c9                   	leaveq 
  801e7c:	c3                   	retq   

0000000000801e7d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801e7d:	55                   	push   %rbp
  801e7e:	48 89 e5             	mov    %rsp,%rbp
  801e81:	48 83 ec 20          	sub    $0x20,%rsp
  801e85:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e88:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e8c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801e8f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e92:	48 63 c8             	movslq %eax,%rcx
  801e95:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e9c:	48 98                	cltq   
  801e9e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ea5:	00 
  801ea6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801eac:	49 89 c8             	mov    %rcx,%r8
  801eaf:	48 89 d1             	mov    %rdx,%rcx
  801eb2:	48 89 c2             	mov    %rax,%rdx
  801eb5:	be 01 00 00 00       	mov    $0x1,%esi
  801eba:	bf 04 00 00 00       	mov    $0x4,%edi
  801ebf:	48 b8 a7 1c 80 00 00 	movabs $0x801ca7,%rax
  801ec6:	00 00 00 
  801ec9:	ff d0                	callq  *%rax
}
  801ecb:	c9                   	leaveq 
  801ecc:	c3                   	retq   

0000000000801ecd <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801ecd:	55                   	push   %rbp
  801ece:	48 89 e5             	mov    %rsp,%rbp
  801ed1:	48 83 ec 30          	sub    $0x30,%rsp
  801ed5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ed8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801edc:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801edf:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ee3:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801ee7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801eea:	48 63 c8             	movslq %eax,%rcx
  801eed:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ef1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ef4:	48 63 f0             	movslq %eax,%rsi
  801ef7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801efb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801efe:	48 98                	cltq   
  801f00:	48 89 0c 24          	mov    %rcx,(%rsp)
  801f04:	49 89 f9             	mov    %rdi,%r9
  801f07:	49 89 f0             	mov    %rsi,%r8
  801f0a:	48 89 d1             	mov    %rdx,%rcx
  801f0d:	48 89 c2             	mov    %rax,%rdx
  801f10:	be 01 00 00 00       	mov    $0x1,%esi
  801f15:	bf 05 00 00 00       	mov    $0x5,%edi
  801f1a:	48 b8 a7 1c 80 00 00 	movabs $0x801ca7,%rax
  801f21:	00 00 00 
  801f24:	ff d0                	callq  *%rax
}
  801f26:	c9                   	leaveq 
  801f27:	c3                   	retq   

0000000000801f28 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801f28:	55                   	push   %rbp
  801f29:	48 89 e5             	mov    %rsp,%rbp
  801f2c:	48 83 ec 20          	sub    $0x20,%rsp
  801f30:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f33:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801f37:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f3e:	48 98                	cltq   
  801f40:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f47:	00 
  801f48:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f4e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f54:	48 89 d1             	mov    %rdx,%rcx
  801f57:	48 89 c2             	mov    %rax,%rdx
  801f5a:	be 01 00 00 00       	mov    $0x1,%esi
  801f5f:	bf 06 00 00 00       	mov    $0x6,%edi
  801f64:	48 b8 a7 1c 80 00 00 	movabs $0x801ca7,%rax
  801f6b:	00 00 00 
  801f6e:	ff d0                	callq  *%rax
}
  801f70:	c9                   	leaveq 
  801f71:	c3                   	retq   

0000000000801f72 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801f72:	55                   	push   %rbp
  801f73:	48 89 e5             	mov    %rsp,%rbp
  801f76:	48 83 ec 10          	sub    $0x10,%rsp
  801f7a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f7d:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801f80:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f83:	48 63 d0             	movslq %eax,%rdx
  801f86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f89:	48 98                	cltq   
  801f8b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f92:	00 
  801f93:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f99:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f9f:	48 89 d1             	mov    %rdx,%rcx
  801fa2:	48 89 c2             	mov    %rax,%rdx
  801fa5:	be 01 00 00 00       	mov    $0x1,%esi
  801faa:	bf 08 00 00 00       	mov    $0x8,%edi
  801faf:	48 b8 a7 1c 80 00 00 	movabs $0x801ca7,%rax
  801fb6:	00 00 00 
  801fb9:	ff d0                	callq  *%rax
}
  801fbb:	c9                   	leaveq 
  801fbc:	c3                   	retq   

0000000000801fbd <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801fbd:	55                   	push   %rbp
  801fbe:	48 89 e5             	mov    %rsp,%rbp
  801fc1:	48 83 ec 20          	sub    $0x20,%rsp
  801fc5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801fc8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801fcc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fd0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fd3:	48 98                	cltq   
  801fd5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fdc:	00 
  801fdd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fe3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fe9:	48 89 d1             	mov    %rdx,%rcx
  801fec:	48 89 c2             	mov    %rax,%rdx
  801fef:	be 01 00 00 00       	mov    $0x1,%esi
  801ff4:	bf 09 00 00 00       	mov    $0x9,%edi
  801ff9:	48 b8 a7 1c 80 00 00 	movabs $0x801ca7,%rax
  802000:	00 00 00 
  802003:	ff d0                	callq  *%rax
}
  802005:	c9                   	leaveq 
  802006:	c3                   	retq   

0000000000802007 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802007:	55                   	push   %rbp
  802008:	48 89 e5             	mov    %rsp,%rbp
  80200b:	48 83 ec 20          	sub    $0x20,%rsp
  80200f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802012:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802016:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80201a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80201d:	48 98                	cltq   
  80201f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802026:	00 
  802027:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80202d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802033:	48 89 d1             	mov    %rdx,%rcx
  802036:	48 89 c2             	mov    %rax,%rdx
  802039:	be 01 00 00 00       	mov    $0x1,%esi
  80203e:	bf 0a 00 00 00       	mov    $0xa,%edi
  802043:	48 b8 a7 1c 80 00 00 	movabs $0x801ca7,%rax
  80204a:	00 00 00 
  80204d:	ff d0                	callq  *%rax
}
  80204f:	c9                   	leaveq 
  802050:	c3                   	retq   

0000000000802051 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802051:	55                   	push   %rbp
  802052:	48 89 e5             	mov    %rsp,%rbp
  802055:	48 83 ec 20          	sub    $0x20,%rsp
  802059:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80205c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802060:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802064:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  802067:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80206a:	48 63 f0             	movslq %eax,%rsi
  80206d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802071:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802074:	48 98                	cltq   
  802076:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80207a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802081:	00 
  802082:	49 89 f1             	mov    %rsi,%r9
  802085:	49 89 c8             	mov    %rcx,%r8
  802088:	48 89 d1             	mov    %rdx,%rcx
  80208b:	48 89 c2             	mov    %rax,%rdx
  80208e:	be 00 00 00 00       	mov    $0x0,%esi
  802093:	bf 0c 00 00 00       	mov    $0xc,%edi
  802098:	48 b8 a7 1c 80 00 00 	movabs $0x801ca7,%rax
  80209f:	00 00 00 
  8020a2:	ff d0                	callq  *%rax
}
  8020a4:	c9                   	leaveq 
  8020a5:	c3                   	retq   

00000000008020a6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8020a6:	55                   	push   %rbp
  8020a7:	48 89 e5             	mov    %rsp,%rbp
  8020aa:	48 83 ec 10          	sub    $0x10,%rsp
  8020ae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8020b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020b6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020bd:	00 
  8020be:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020c4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020ca:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020cf:	48 89 c2             	mov    %rax,%rdx
  8020d2:	be 01 00 00 00       	mov    $0x1,%esi
  8020d7:	bf 0d 00 00 00       	mov    $0xd,%edi
  8020dc:	48 b8 a7 1c 80 00 00 	movabs $0x801ca7,%rax
  8020e3:	00 00 00 
  8020e6:	ff d0                	callq  *%rax
}
  8020e8:	c9                   	leaveq 
  8020e9:	c3                   	retq   

00000000008020ea <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8020ea:	55                   	push   %rbp
  8020eb:	48 89 e5             	mov    %rsp,%rbp
  8020ee:	48 83 ec 08          	sub    $0x8,%rsp
  8020f2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8020f6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8020fa:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802101:	ff ff ff 
  802104:	48 01 d0             	add    %rdx,%rax
  802107:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80210b:	c9                   	leaveq 
  80210c:	c3                   	retq   

000000000080210d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80210d:	55                   	push   %rbp
  80210e:	48 89 e5             	mov    %rsp,%rbp
  802111:	48 83 ec 08          	sub    $0x8,%rsp
  802115:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802119:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80211d:	48 89 c7             	mov    %rax,%rdi
  802120:	48 b8 ea 20 80 00 00 	movabs $0x8020ea,%rax
  802127:	00 00 00 
  80212a:	ff d0                	callq  *%rax
  80212c:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802132:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802136:	c9                   	leaveq 
  802137:	c3                   	retq   

0000000000802138 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802138:	55                   	push   %rbp
  802139:	48 89 e5             	mov    %rsp,%rbp
  80213c:	48 83 ec 18          	sub    $0x18,%rsp
  802140:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802144:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80214b:	eb 6b                	jmp    8021b8 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80214d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802150:	48 98                	cltq   
  802152:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802158:	48 c1 e0 0c          	shl    $0xc,%rax
  80215c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802160:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802164:	48 c1 e8 15          	shr    $0x15,%rax
  802168:	48 89 c2             	mov    %rax,%rdx
  80216b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802172:	01 00 00 
  802175:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802179:	83 e0 01             	and    $0x1,%eax
  80217c:	48 85 c0             	test   %rax,%rax
  80217f:	74 21                	je     8021a2 <fd_alloc+0x6a>
  802181:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802185:	48 c1 e8 0c          	shr    $0xc,%rax
  802189:	48 89 c2             	mov    %rax,%rdx
  80218c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802193:	01 00 00 
  802196:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80219a:	83 e0 01             	and    $0x1,%eax
  80219d:	48 85 c0             	test   %rax,%rax
  8021a0:	75 12                	jne    8021b4 <fd_alloc+0x7c>
			*fd_store = fd;
  8021a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021aa:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8021ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b2:	eb 1a                	jmp    8021ce <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8021b4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021b8:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8021bc:	7e 8f                	jle    80214d <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8021be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c2:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8021c9:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8021ce:	c9                   	leaveq 
  8021cf:	c3                   	retq   

00000000008021d0 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8021d0:	55                   	push   %rbp
  8021d1:	48 89 e5             	mov    %rsp,%rbp
  8021d4:	48 83 ec 20          	sub    $0x20,%rsp
  8021d8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021db:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8021df:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8021e3:	78 06                	js     8021eb <fd_lookup+0x1b>
  8021e5:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8021e9:	7e 07                	jle    8021f2 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8021eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021f0:	eb 6c                	jmp    80225e <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8021f2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021f5:	48 98                	cltq   
  8021f7:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8021fd:	48 c1 e0 0c          	shl    $0xc,%rax
  802201:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802205:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802209:	48 c1 e8 15          	shr    $0x15,%rax
  80220d:	48 89 c2             	mov    %rax,%rdx
  802210:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802217:	01 00 00 
  80221a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80221e:	83 e0 01             	and    $0x1,%eax
  802221:	48 85 c0             	test   %rax,%rax
  802224:	74 21                	je     802247 <fd_lookup+0x77>
  802226:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80222a:	48 c1 e8 0c          	shr    $0xc,%rax
  80222e:	48 89 c2             	mov    %rax,%rdx
  802231:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802238:	01 00 00 
  80223b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80223f:	83 e0 01             	and    $0x1,%eax
  802242:	48 85 c0             	test   %rax,%rax
  802245:	75 07                	jne    80224e <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802247:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80224c:	eb 10                	jmp    80225e <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80224e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802252:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802256:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802259:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80225e:	c9                   	leaveq 
  80225f:	c3                   	retq   

0000000000802260 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802260:	55                   	push   %rbp
  802261:	48 89 e5             	mov    %rsp,%rbp
  802264:	48 83 ec 30          	sub    $0x30,%rsp
  802268:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80226c:	89 f0                	mov    %esi,%eax
  80226e:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802271:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802275:	48 89 c7             	mov    %rax,%rdi
  802278:	48 b8 ea 20 80 00 00 	movabs $0x8020ea,%rax
  80227f:	00 00 00 
  802282:	ff d0                	callq  *%rax
  802284:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802288:	48 89 d6             	mov    %rdx,%rsi
  80228b:	89 c7                	mov    %eax,%edi
  80228d:	48 b8 d0 21 80 00 00 	movabs $0x8021d0,%rax
  802294:	00 00 00 
  802297:	ff d0                	callq  *%rax
  802299:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80229c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022a0:	78 0a                	js     8022ac <fd_close+0x4c>
	    || fd != fd2)
  8022a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022a6:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8022aa:	74 12                	je     8022be <fd_close+0x5e>
		return (must_exist ? r : 0);
  8022ac:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8022b0:	74 05                	je     8022b7 <fd_close+0x57>
  8022b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022b5:	eb 05                	jmp    8022bc <fd_close+0x5c>
  8022b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022bc:	eb 69                	jmp    802327 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8022be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022c2:	8b 00                	mov    (%rax),%eax
  8022c4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022c8:	48 89 d6             	mov    %rdx,%rsi
  8022cb:	89 c7                	mov    %eax,%edi
  8022cd:	48 b8 29 23 80 00 00 	movabs $0x802329,%rax
  8022d4:	00 00 00 
  8022d7:	ff d0                	callq  *%rax
  8022d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022e0:	78 2a                	js     80230c <fd_close+0xac>
		if (dev->dev_close)
  8022e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e6:	48 8b 40 20          	mov    0x20(%rax),%rax
  8022ea:	48 85 c0             	test   %rax,%rax
  8022ed:	74 16                	je     802305 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8022ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022f3:	48 8b 40 20          	mov    0x20(%rax),%rax
  8022f7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8022fb:	48 89 d7             	mov    %rdx,%rdi
  8022fe:	ff d0                	callq  *%rax
  802300:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802303:	eb 07                	jmp    80230c <fd_close+0xac>
		else
			r = 0;
  802305:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80230c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802310:	48 89 c6             	mov    %rax,%rsi
  802313:	bf 00 00 00 00       	mov    $0x0,%edi
  802318:	48 b8 28 1f 80 00 00 	movabs $0x801f28,%rax
  80231f:	00 00 00 
  802322:	ff d0                	callq  *%rax
	return r;
  802324:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802327:	c9                   	leaveq 
  802328:	c3                   	retq   

0000000000802329 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802329:	55                   	push   %rbp
  80232a:	48 89 e5             	mov    %rsp,%rbp
  80232d:	48 83 ec 20          	sub    $0x20,%rsp
  802331:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802334:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802338:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80233f:	eb 41                	jmp    802382 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802341:	48 b8 c0 77 80 00 00 	movabs $0x8077c0,%rax
  802348:	00 00 00 
  80234b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80234e:	48 63 d2             	movslq %edx,%rdx
  802351:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802355:	8b 00                	mov    (%rax),%eax
  802357:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80235a:	75 22                	jne    80237e <dev_lookup+0x55>
			*dev = devtab[i];
  80235c:	48 b8 c0 77 80 00 00 	movabs $0x8077c0,%rax
  802363:	00 00 00 
  802366:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802369:	48 63 d2             	movslq %edx,%rdx
  80236c:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802370:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802374:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802377:	b8 00 00 00 00       	mov    $0x0,%eax
  80237c:	eb 60                	jmp    8023de <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80237e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802382:	48 b8 c0 77 80 00 00 	movabs $0x8077c0,%rax
  802389:	00 00 00 
  80238c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80238f:	48 63 d2             	movslq %edx,%rdx
  802392:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802396:	48 85 c0             	test   %rax,%rax
  802399:	75 a6                	jne    802341 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80239b:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  8023a2:	00 00 00 
  8023a5:	48 8b 00             	mov    (%rax),%rax
  8023a8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023ae:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8023b1:	89 c6                	mov    %eax,%esi
  8023b3:	48 bf b8 4b 80 00 00 	movabs $0x804bb8,%rdi
  8023ba:	00 00 00 
  8023bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c2:	48 b9 99 09 80 00 00 	movabs $0x800999,%rcx
  8023c9:	00 00 00 
  8023cc:	ff d1                	callq  *%rcx
	*dev = 0;
  8023ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023d2:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8023d9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8023de:	c9                   	leaveq 
  8023df:	c3                   	retq   

00000000008023e0 <close>:

int
close(int fdnum)
{
  8023e0:	55                   	push   %rbp
  8023e1:	48 89 e5             	mov    %rsp,%rbp
  8023e4:	48 83 ec 20          	sub    $0x20,%rsp
  8023e8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023eb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023ef:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023f2:	48 89 d6             	mov    %rdx,%rsi
  8023f5:	89 c7                	mov    %eax,%edi
  8023f7:	48 b8 d0 21 80 00 00 	movabs $0x8021d0,%rax
  8023fe:	00 00 00 
  802401:	ff d0                	callq  *%rax
  802403:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802406:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80240a:	79 05                	jns    802411 <close+0x31>
		return r;
  80240c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80240f:	eb 18                	jmp    802429 <close+0x49>
	else
		return fd_close(fd, 1);
  802411:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802415:	be 01 00 00 00       	mov    $0x1,%esi
  80241a:	48 89 c7             	mov    %rax,%rdi
  80241d:	48 b8 60 22 80 00 00 	movabs $0x802260,%rax
  802424:	00 00 00 
  802427:	ff d0                	callq  *%rax
}
  802429:	c9                   	leaveq 
  80242a:	c3                   	retq   

000000000080242b <close_all>:

void
close_all(void)
{
  80242b:	55                   	push   %rbp
  80242c:	48 89 e5             	mov    %rsp,%rbp
  80242f:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802433:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80243a:	eb 15                	jmp    802451 <close_all+0x26>
		close(i);
  80243c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80243f:	89 c7                	mov    %eax,%edi
  802441:	48 b8 e0 23 80 00 00 	movabs $0x8023e0,%rax
  802448:	00 00 00 
  80244b:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80244d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802451:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802455:	7e e5                	jle    80243c <close_all+0x11>
		close(i);
}
  802457:	c9                   	leaveq 
  802458:	c3                   	retq   

0000000000802459 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802459:	55                   	push   %rbp
  80245a:	48 89 e5             	mov    %rsp,%rbp
  80245d:	48 83 ec 40          	sub    $0x40,%rsp
  802461:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802464:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802467:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80246b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80246e:	48 89 d6             	mov    %rdx,%rsi
  802471:	89 c7                	mov    %eax,%edi
  802473:	48 b8 d0 21 80 00 00 	movabs $0x8021d0,%rax
  80247a:	00 00 00 
  80247d:	ff d0                	callq  *%rax
  80247f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802482:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802486:	79 08                	jns    802490 <dup+0x37>
		return r;
  802488:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80248b:	e9 70 01 00 00       	jmpq   802600 <dup+0x1a7>
	close(newfdnum);
  802490:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802493:	89 c7                	mov    %eax,%edi
  802495:	48 b8 e0 23 80 00 00 	movabs $0x8023e0,%rax
  80249c:	00 00 00 
  80249f:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8024a1:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8024a4:	48 98                	cltq   
  8024a6:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8024ac:	48 c1 e0 0c          	shl    $0xc,%rax
  8024b0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8024b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024b8:	48 89 c7             	mov    %rax,%rdi
  8024bb:	48 b8 0d 21 80 00 00 	movabs $0x80210d,%rax
  8024c2:	00 00 00 
  8024c5:	ff d0                	callq  *%rax
  8024c7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8024cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024cf:	48 89 c7             	mov    %rax,%rdi
  8024d2:	48 b8 0d 21 80 00 00 	movabs $0x80210d,%rax
  8024d9:	00 00 00 
  8024dc:	ff d0                	callq  *%rax
  8024de:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8024e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024e6:	48 c1 e8 15          	shr    $0x15,%rax
  8024ea:	48 89 c2             	mov    %rax,%rdx
  8024ed:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024f4:	01 00 00 
  8024f7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024fb:	83 e0 01             	and    $0x1,%eax
  8024fe:	48 85 c0             	test   %rax,%rax
  802501:	74 73                	je     802576 <dup+0x11d>
  802503:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802507:	48 c1 e8 0c          	shr    $0xc,%rax
  80250b:	48 89 c2             	mov    %rax,%rdx
  80250e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802515:	01 00 00 
  802518:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80251c:	83 e0 01             	and    $0x1,%eax
  80251f:	48 85 c0             	test   %rax,%rax
  802522:	74 52                	je     802576 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802524:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802528:	48 c1 e8 0c          	shr    $0xc,%rax
  80252c:	48 89 c2             	mov    %rax,%rdx
  80252f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802536:	01 00 00 
  802539:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80253d:	25 07 0e 00 00       	and    $0xe07,%eax
  802542:	89 c1                	mov    %eax,%ecx
  802544:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802548:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80254c:	41 89 c8             	mov    %ecx,%r8d
  80254f:	48 89 d1             	mov    %rdx,%rcx
  802552:	ba 00 00 00 00       	mov    $0x0,%edx
  802557:	48 89 c6             	mov    %rax,%rsi
  80255a:	bf 00 00 00 00       	mov    $0x0,%edi
  80255f:	48 b8 cd 1e 80 00 00 	movabs $0x801ecd,%rax
  802566:	00 00 00 
  802569:	ff d0                	callq  *%rax
  80256b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80256e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802572:	79 02                	jns    802576 <dup+0x11d>
			goto err;
  802574:	eb 57                	jmp    8025cd <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802576:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80257a:	48 c1 e8 0c          	shr    $0xc,%rax
  80257e:	48 89 c2             	mov    %rax,%rdx
  802581:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802588:	01 00 00 
  80258b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80258f:	25 07 0e 00 00       	and    $0xe07,%eax
  802594:	89 c1                	mov    %eax,%ecx
  802596:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80259a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80259e:	41 89 c8             	mov    %ecx,%r8d
  8025a1:	48 89 d1             	mov    %rdx,%rcx
  8025a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8025a9:	48 89 c6             	mov    %rax,%rsi
  8025ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8025b1:	48 b8 cd 1e 80 00 00 	movabs $0x801ecd,%rax
  8025b8:	00 00 00 
  8025bb:	ff d0                	callq  *%rax
  8025bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025c4:	79 02                	jns    8025c8 <dup+0x16f>
		goto err;
  8025c6:	eb 05                	jmp    8025cd <dup+0x174>

	return newfdnum;
  8025c8:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8025cb:	eb 33                	jmp    802600 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8025cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025d1:	48 89 c6             	mov    %rax,%rsi
  8025d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8025d9:	48 b8 28 1f 80 00 00 	movabs $0x801f28,%rax
  8025e0:	00 00 00 
  8025e3:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8025e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025e9:	48 89 c6             	mov    %rax,%rsi
  8025ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8025f1:	48 b8 28 1f 80 00 00 	movabs $0x801f28,%rax
  8025f8:	00 00 00 
  8025fb:	ff d0                	callq  *%rax
	return r;
  8025fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802600:	c9                   	leaveq 
  802601:	c3                   	retq   

0000000000802602 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802602:	55                   	push   %rbp
  802603:	48 89 e5             	mov    %rsp,%rbp
  802606:	48 83 ec 40          	sub    $0x40,%rsp
  80260a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80260d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802611:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802615:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802619:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80261c:	48 89 d6             	mov    %rdx,%rsi
  80261f:	89 c7                	mov    %eax,%edi
  802621:	48 b8 d0 21 80 00 00 	movabs $0x8021d0,%rax
  802628:	00 00 00 
  80262b:	ff d0                	callq  *%rax
  80262d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802630:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802634:	78 24                	js     80265a <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802636:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80263a:	8b 00                	mov    (%rax),%eax
  80263c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802640:	48 89 d6             	mov    %rdx,%rsi
  802643:	89 c7                	mov    %eax,%edi
  802645:	48 b8 29 23 80 00 00 	movabs $0x802329,%rax
  80264c:	00 00 00 
  80264f:	ff d0                	callq  *%rax
  802651:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802654:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802658:	79 05                	jns    80265f <read+0x5d>
		return r;
  80265a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80265d:	eb 76                	jmp    8026d5 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80265f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802663:	8b 40 08             	mov    0x8(%rax),%eax
  802666:	83 e0 03             	and    $0x3,%eax
  802669:	83 f8 01             	cmp    $0x1,%eax
  80266c:	75 3a                	jne    8026a8 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80266e:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  802675:	00 00 00 
  802678:	48 8b 00             	mov    (%rax),%rax
  80267b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802681:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802684:	89 c6                	mov    %eax,%esi
  802686:	48 bf d7 4b 80 00 00 	movabs $0x804bd7,%rdi
  80268d:	00 00 00 
  802690:	b8 00 00 00 00       	mov    $0x0,%eax
  802695:	48 b9 99 09 80 00 00 	movabs $0x800999,%rcx
  80269c:	00 00 00 
  80269f:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8026a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026a6:	eb 2d                	jmp    8026d5 <read+0xd3>
	}
	if (!dev->dev_read)
  8026a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ac:	48 8b 40 10          	mov    0x10(%rax),%rax
  8026b0:	48 85 c0             	test   %rax,%rax
  8026b3:	75 07                	jne    8026bc <read+0xba>
		return -E_NOT_SUPP;
  8026b5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026ba:	eb 19                	jmp    8026d5 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8026bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026c0:	48 8b 40 10          	mov    0x10(%rax),%rax
  8026c4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8026c8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8026cc:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8026d0:	48 89 cf             	mov    %rcx,%rdi
  8026d3:	ff d0                	callq  *%rax
}
  8026d5:	c9                   	leaveq 
  8026d6:	c3                   	retq   

00000000008026d7 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8026d7:	55                   	push   %rbp
  8026d8:	48 89 e5             	mov    %rsp,%rbp
  8026db:	48 83 ec 30          	sub    $0x30,%rsp
  8026df:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026e2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8026e6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8026ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026f1:	eb 49                	jmp    80273c <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8026f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026f6:	48 98                	cltq   
  8026f8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026fc:	48 29 c2             	sub    %rax,%rdx
  8026ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802702:	48 63 c8             	movslq %eax,%rcx
  802705:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802709:	48 01 c1             	add    %rax,%rcx
  80270c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80270f:	48 89 ce             	mov    %rcx,%rsi
  802712:	89 c7                	mov    %eax,%edi
  802714:	48 b8 02 26 80 00 00 	movabs $0x802602,%rax
  80271b:	00 00 00 
  80271e:	ff d0                	callq  *%rax
  802720:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802723:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802727:	79 05                	jns    80272e <readn+0x57>
			return m;
  802729:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80272c:	eb 1c                	jmp    80274a <readn+0x73>
		if (m == 0)
  80272e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802732:	75 02                	jne    802736 <readn+0x5f>
			break;
  802734:	eb 11                	jmp    802747 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802736:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802739:	01 45 fc             	add    %eax,-0x4(%rbp)
  80273c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80273f:	48 98                	cltq   
  802741:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802745:	72 ac                	jb     8026f3 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802747:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80274a:	c9                   	leaveq 
  80274b:	c3                   	retq   

000000000080274c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80274c:	55                   	push   %rbp
  80274d:	48 89 e5             	mov    %rsp,%rbp
  802750:	48 83 ec 40          	sub    $0x40,%rsp
  802754:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802757:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80275b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80275f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802763:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802766:	48 89 d6             	mov    %rdx,%rsi
  802769:	89 c7                	mov    %eax,%edi
  80276b:	48 b8 d0 21 80 00 00 	movabs $0x8021d0,%rax
  802772:	00 00 00 
  802775:	ff d0                	callq  *%rax
  802777:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80277a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80277e:	78 24                	js     8027a4 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802780:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802784:	8b 00                	mov    (%rax),%eax
  802786:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80278a:	48 89 d6             	mov    %rdx,%rsi
  80278d:	89 c7                	mov    %eax,%edi
  80278f:	48 b8 29 23 80 00 00 	movabs $0x802329,%rax
  802796:	00 00 00 
  802799:	ff d0                	callq  *%rax
  80279b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80279e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027a2:	79 05                	jns    8027a9 <write+0x5d>
		return r;
  8027a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027a7:	eb 75                	jmp    80281e <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8027a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ad:	8b 40 08             	mov    0x8(%rax),%eax
  8027b0:	83 e0 03             	and    $0x3,%eax
  8027b3:	85 c0                	test   %eax,%eax
  8027b5:	75 3a                	jne    8027f1 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8027b7:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  8027be:	00 00 00 
  8027c1:	48 8b 00             	mov    (%rax),%rax
  8027c4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027ca:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8027cd:	89 c6                	mov    %eax,%esi
  8027cf:	48 bf f3 4b 80 00 00 	movabs $0x804bf3,%rdi
  8027d6:	00 00 00 
  8027d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027de:	48 b9 99 09 80 00 00 	movabs $0x800999,%rcx
  8027e5:	00 00 00 
  8027e8:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8027ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027ef:	eb 2d                	jmp    80281e <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8027f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027f5:	48 8b 40 18          	mov    0x18(%rax),%rax
  8027f9:	48 85 c0             	test   %rax,%rax
  8027fc:	75 07                	jne    802805 <write+0xb9>
		return -E_NOT_SUPP;
  8027fe:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802803:	eb 19                	jmp    80281e <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802805:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802809:	48 8b 40 18          	mov    0x18(%rax),%rax
  80280d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802811:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802815:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802819:	48 89 cf             	mov    %rcx,%rdi
  80281c:	ff d0                	callq  *%rax
}
  80281e:	c9                   	leaveq 
  80281f:	c3                   	retq   

0000000000802820 <seek>:

int
seek(int fdnum, off_t offset)
{
  802820:	55                   	push   %rbp
  802821:	48 89 e5             	mov    %rsp,%rbp
  802824:	48 83 ec 18          	sub    $0x18,%rsp
  802828:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80282b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80282e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802832:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802835:	48 89 d6             	mov    %rdx,%rsi
  802838:	89 c7                	mov    %eax,%edi
  80283a:	48 b8 d0 21 80 00 00 	movabs $0x8021d0,%rax
  802841:	00 00 00 
  802844:	ff d0                	callq  *%rax
  802846:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802849:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80284d:	79 05                	jns    802854 <seek+0x34>
		return r;
  80284f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802852:	eb 0f                	jmp    802863 <seek+0x43>
	fd->fd_offset = offset;
  802854:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802858:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80285b:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80285e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802863:	c9                   	leaveq 
  802864:	c3                   	retq   

0000000000802865 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802865:	55                   	push   %rbp
  802866:	48 89 e5             	mov    %rsp,%rbp
  802869:	48 83 ec 30          	sub    $0x30,%rsp
  80286d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802870:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802873:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802877:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80287a:	48 89 d6             	mov    %rdx,%rsi
  80287d:	89 c7                	mov    %eax,%edi
  80287f:	48 b8 d0 21 80 00 00 	movabs $0x8021d0,%rax
  802886:	00 00 00 
  802889:	ff d0                	callq  *%rax
  80288b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80288e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802892:	78 24                	js     8028b8 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802894:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802898:	8b 00                	mov    (%rax),%eax
  80289a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80289e:	48 89 d6             	mov    %rdx,%rsi
  8028a1:	89 c7                	mov    %eax,%edi
  8028a3:	48 b8 29 23 80 00 00 	movabs $0x802329,%rax
  8028aa:	00 00 00 
  8028ad:	ff d0                	callq  *%rax
  8028af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028b6:	79 05                	jns    8028bd <ftruncate+0x58>
		return r;
  8028b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028bb:	eb 72                	jmp    80292f <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8028bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c1:	8b 40 08             	mov    0x8(%rax),%eax
  8028c4:	83 e0 03             	and    $0x3,%eax
  8028c7:	85 c0                	test   %eax,%eax
  8028c9:	75 3a                	jne    802905 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8028cb:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  8028d2:	00 00 00 
  8028d5:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8028d8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028de:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8028e1:	89 c6                	mov    %eax,%esi
  8028e3:	48 bf 10 4c 80 00 00 	movabs $0x804c10,%rdi
  8028ea:	00 00 00 
  8028ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f2:	48 b9 99 09 80 00 00 	movabs $0x800999,%rcx
  8028f9:	00 00 00 
  8028fc:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8028fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802903:	eb 2a                	jmp    80292f <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802905:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802909:	48 8b 40 30          	mov    0x30(%rax),%rax
  80290d:	48 85 c0             	test   %rax,%rax
  802910:	75 07                	jne    802919 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802912:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802917:	eb 16                	jmp    80292f <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802919:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80291d:	48 8b 40 30          	mov    0x30(%rax),%rax
  802921:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802925:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802928:	89 ce                	mov    %ecx,%esi
  80292a:	48 89 d7             	mov    %rdx,%rdi
  80292d:	ff d0                	callq  *%rax
}
  80292f:	c9                   	leaveq 
  802930:	c3                   	retq   

0000000000802931 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802931:	55                   	push   %rbp
  802932:	48 89 e5             	mov    %rsp,%rbp
  802935:	48 83 ec 30          	sub    $0x30,%rsp
  802939:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80293c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802940:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802944:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802947:	48 89 d6             	mov    %rdx,%rsi
  80294a:	89 c7                	mov    %eax,%edi
  80294c:	48 b8 d0 21 80 00 00 	movabs $0x8021d0,%rax
  802953:	00 00 00 
  802956:	ff d0                	callq  *%rax
  802958:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80295b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80295f:	78 24                	js     802985 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802961:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802965:	8b 00                	mov    (%rax),%eax
  802967:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80296b:	48 89 d6             	mov    %rdx,%rsi
  80296e:	89 c7                	mov    %eax,%edi
  802970:	48 b8 29 23 80 00 00 	movabs $0x802329,%rax
  802977:	00 00 00 
  80297a:	ff d0                	callq  *%rax
  80297c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80297f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802983:	79 05                	jns    80298a <fstat+0x59>
		return r;
  802985:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802988:	eb 5e                	jmp    8029e8 <fstat+0xb7>
	if (!dev->dev_stat)
  80298a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80298e:	48 8b 40 28          	mov    0x28(%rax),%rax
  802992:	48 85 c0             	test   %rax,%rax
  802995:	75 07                	jne    80299e <fstat+0x6d>
		return -E_NOT_SUPP;
  802997:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80299c:	eb 4a                	jmp    8029e8 <fstat+0xb7>
	stat->st_name[0] = 0;
  80299e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029a2:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8029a5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029a9:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8029b0:	00 00 00 
	stat->st_isdir = 0;
  8029b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029b7:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8029be:	00 00 00 
	stat->st_dev = dev;
  8029c1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8029c5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029c9:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8029d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029d4:	48 8b 40 28          	mov    0x28(%rax),%rax
  8029d8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029dc:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8029e0:	48 89 ce             	mov    %rcx,%rsi
  8029e3:	48 89 d7             	mov    %rdx,%rdi
  8029e6:	ff d0                	callq  *%rax
}
  8029e8:	c9                   	leaveq 
  8029e9:	c3                   	retq   

00000000008029ea <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8029ea:	55                   	push   %rbp
  8029eb:	48 89 e5             	mov    %rsp,%rbp
  8029ee:	48 83 ec 20          	sub    $0x20,%rsp
  8029f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029f6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8029fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029fe:	be 00 00 00 00       	mov    $0x0,%esi
  802a03:	48 89 c7             	mov    %rax,%rdi
  802a06:	48 b8 d8 2a 80 00 00 	movabs $0x802ad8,%rax
  802a0d:	00 00 00 
  802a10:	ff d0                	callq  *%rax
  802a12:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a15:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a19:	79 05                	jns    802a20 <stat+0x36>
		return fd;
  802a1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a1e:	eb 2f                	jmp    802a4f <stat+0x65>
	r = fstat(fd, stat);
  802a20:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a27:	48 89 d6             	mov    %rdx,%rsi
  802a2a:	89 c7                	mov    %eax,%edi
  802a2c:	48 b8 31 29 80 00 00 	movabs $0x802931,%rax
  802a33:	00 00 00 
  802a36:	ff d0                	callq  *%rax
  802a38:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802a3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a3e:	89 c7                	mov    %eax,%edi
  802a40:	48 b8 e0 23 80 00 00 	movabs $0x8023e0,%rax
  802a47:	00 00 00 
  802a4a:	ff d0                	callq  *%rax
	return r;
  802a4c:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802a4f:	c9                   	leaveq 
  802a50:	c3                   	retq   

0000000000802a51 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802a51:	55                   	push   %rbp
  802a52:	48 89 e5             	mov    %rsp,%rbp
  802a55:	48 83 ec 10          	sub    $0x10,%rsp
  802a59:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802a5c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802a60:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a67:	00 00 00 
  802a6a:	8b 00                	mov    (%rax),%eax
  802a6c:	85 c0                	test   %eax,%eax
  802a6e:	75 1d                	jne    802a8d <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802a70:	bf 01 00 00 00       	mov    $0x1,%edi
  802a75:	48 b8 f6 43 80 00 00 	movabs $0x8043f6,%rax
  802a7c:	00 00 00 
  802a7f:	ff d0                	callq  *%rax
  802a81:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802a88:	00 00 00 
  802a8b:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802a8d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a94:	00 00 00 
  802a97:	8b 00                	mov    (%rax),%eax
  802a99:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802a9c:	b9 07 00 00 00       	mov    $0x7,%ecx
  802aa1:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  802aa8:	00 00 00 
  802aab:	89 c7                	mov    %eax,%edi
  802aad:	48 b8 59 43 80 00 00 	movabs $0x804359,%rax
  802ab4:	00 00 00 
  802ab7:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802ab9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802abd:	ba 00 00 00 00       	mov    $0x0,%edx
  802ac2:	48 89 c6             	mov    %rax,%rsi
  802ac5:	bf 00 00 00 00       	mov    $0x0,%edi
  802aca:	48 b8 93 42 80 00 00 	movabs $0x804293,%rax
  802ad1:	00 00 00 
  802ad4:	ff d0                	callq  *%rax
}
  802ad6:	c9                   	leaveq 
  802ad7:	c3                   	retq   

0000000000802ad8 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802ad8:	55                   	push   %rbp
  802ad9:	48 89 e5             	mov    %rsp,%rbp
  802adc:	48 83 ec 20          	sub    $0x20,%rsp
  802ae0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ae4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  802ae7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aeb:	48 89 c7             	mov    %rax,%rdi
  802aee:	48 b8 e2 14 80 00 00 	movabs $0x8014e2,%rax
  802af5:	00 00 00 
  802af8:	ff d0                	callq  *%rax
  802afa:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802aff:	7e 0a                	jle    802b0b <open+0x33>
  802b01:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802b06:	e9 a5 00 00 00       	jmpq   802bb0 <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  802b0b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802b0f:	48 89 c7             	mov    %rax,%rdi
  802b12:	48 b8 38 21 80 00 00 	movabs $0x802138,%rax
  802b19:	00 00 00 
  802b1c:	ff d0                	callq  *%rax
  802b1e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b21:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b25:	79 08                	jns    802b2f <open+0x57>
		return r;
  802b27:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b2a:	e9 81 00 00 00       	jmpq   802bb0 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  802b2f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802b36:	00 00 00 
  802b39:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802b3c:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  802b42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b46:	48 89 c6             	mov    %rax,%rsi
  802b49:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  802b50:	00 00 00 
  802b53:	48 b8 4e 15 80 00 00 	movabs $0x80154e,%rax
  802b5a:	00 00 00 
  802b5d:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  802b5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b63:	48 89 c6             	mov    %rax,%rsi
  802b66:	bf 01 00 00 00       	mov    $0x1,%edi
  802b6b:	48 b8 51 2a 80 00 00 	movabs $0x802a51,%rax
  802b72:	00 00 00 
  802b75:	ff d0                	callq  *%rax
  802b77:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b7e:	79 1d                	jns    802b9d <open+0xc5>
		fd_close(fd, 0);
  802b80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b84:	be 00 00 00 00       	mov    $0x0,%esi
  802b89:	48 89 c7             	mov    %rax,%rdi
  802b8c:	48 b8 60 22 80 00 00 	movabs $0x802260,%rax
  802b93:	00 00 00 
  802b96:	ff d0                	callq  *%rax
		return r;
  802b98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b9b:	eb 13                	jmp    802bb0 <open+0xd8>
	}
	return fd2num(fd);
  802b9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ba1:	48 89 c7             	mov    %rax,%rdi
  802ba4:	48 b8 ea 20 80 00 00 	movabs $0x8020ea,%rax
  802bab:	00 00 00 
  802bae:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  802bb0:	c9                   	leaveq 
  802bb1:	c3                   	retq   

0000000000802bb2 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802bb2:	55                   	push   %rbp
  802bb3:	48 89 e5             	mov    %rsp,%rbp
  802bb6:	48 83 ec 10          	sub    $0x10,%rsp
  802bba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802bbe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bc2:	8b 50 0c             	mov    0xc(%rax),%edx
  802bc5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802bcc:	00 00 00 
  802bcf:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802bd1:	be 00 00 00 00       	mov    $0x0,%esi
  802bd6:	bf 06 00 00 00       	mov    $0x6,%edi
  802bdb:	48 b8 51 2a 80 00 00 	movabs $0x802a51,%rax
  802be2:	00 00 00 
  802be5:	ff d0                	callq  *%rax
}
  802be7:	c9                   	leaveq 
  802be8:	c3                   	retq   

0000000000802be9 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802be9:	55                   	push   %rbp
  802bea:	48 89 e5             	mov    %rsp,%rbp
  802bed:	48 83 ec 30          	sub    $0x30,%rsp
  802bf1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802bf5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802bf9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802bfd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c01:	8b 50 0c             	mov    0xc(%rax),%edx
  802c04:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802c0b:	00 00 00 
  802c0e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802c10:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802c17:	00 00 00 
  802c1a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c1e:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  802c22:	be 00 00 00 00       	mov    $0x0,%esi
  802c27:	bf 03 00 00 00       	mov    $0x3,%edi
  802c2c:	48 b8 51 2a 80 00 00 	movabs $0x802a51,%rax
  802c33:	00 00 00 
  802c36:	ff d0                	callq  *%rax
  802c38:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c3b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c3f:	79 05                	jns    802c46 <devfile_read+0x5d>
		return r;
  802c41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c44:	eb 26                	jmp    802c6c <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  802c46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c49:	48 63 d0             	movslq %eax,%rdx
  802c4c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c50:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  802c57:	00 00 00 
  802c5a:	48 89 c7             	mov    %rax,%rdi
  802c5d:	48 b8 89 19 80 00 00 	movabs $0x801989,%rax
  802c64:	00 00 00 
  802c67:	ff d0                	callq  *%rax
	return r;
  802c69:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802c6c:	c9                   	leaveq 
  802c6d:	c3                   	retq   

0000000000802c6e <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802c6e:	55                   	push   %rbp
  802c6f:	48 89 e5             	mov    %rsp,%rbp
  802c72:	48 83 ec 30          	sub    $0x30,%rsp
  802c76:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c7a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c7e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  802c82:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  802c89:	00 
	n = n > max ? max : n;
  802c8a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c8e:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802c92:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  802c97:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802c9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c9f:	8b 50 0c             	mov    0xc(%rax),%edx
  802ca2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ca9:	00 00 00 
  802cac:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802cae:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802cb5:	00 00 00 
  802cb8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802cbc:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802cc0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802cc4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cc8:	48 89 c6             	mov    %rax,%rsi
  802ccb:	48 bf 10 a0 80 00 00 	movabs $0x80a010,%rdi
  802cd2:	00 00 00 
  802cd5:	48 b8 89 19 80 00 00 	movabs $0x801989,%rax
  802cdc:	00 00 00 
  802cdf:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  802ce1:	be 00 00 00 00       	mov    $0x0,%esi
  802ce6:	bf 04 00 00 00       	mov    $0x4,%edi
  802ceb:	48 b8 51 2a 80 00 00 	movabs $0x802a51,%rax
  802cf2:	00 00 00 
  802cf5:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  802cf7:	c9                   	leaveq 
  802cf8:	c3                   	retq   

0000000000802cf9 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802cf9:	55                   	push   %rbp
  802cfa:	48 89 e5             	mov    %rsp,%rbp
  802cfd:	48 83 ec 20          	sub    $0x20,%rsp
  802d01:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d05:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802d09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d0d:	8b 50 0c             	mov    0xc(%rax),%edx
  802d10:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802d17:	00 00 00 
  802d1a:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802d1c:	be 00 00 00 00       	mov    $0x0,%esi
  802d21:	bf 05 00 00 00       	mov    $0x5,%edi
  802d26:	48 b8 51 2a 80 00 00 	movabs $0x802a51,%rax
  802d2d:	00 00 00 
  802d30:	ff d0                	callq  *%rax
  802d32:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d35:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d39:	79 05                	jns    802d40 <devfile_stat+0x47>
		return r;
  802d3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d3e:	eb 56                	jmp    802d96 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802d40:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d44:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  802d4b:	00 00 00 
  802d4e:	48 89 c7             	mov    %rax,%rdi
  802d51:	48 b8 4e 15 80 00 00 	movabs $0x80154e,%rax
  802d58:	00 00 00 
  802d5b:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802d5d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802d64:	00 00 00 
  802d67:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802d6d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d71:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802d77:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802d7e:	00 00 00 
  802d81:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802d87:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d8b:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802d91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d96:	c9                   	leaveq 
  802d97:	c3                   	retq   

0000000000802d98 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802d98:	55                   	push   %rbp
  802d99:	48 89 e5             	mov    %rsp,%rbp
  802d9c:	48 83 ec 10          	sub    $0x10,%rsp
  802da0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802da4:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802da7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dab:	8b 50 0c             	mov    0xc(%rax),%edx
  802dae:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802db5:	00 00 00 
  802db8:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802dba:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802dc1:	00 00 00 
  802dc4:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802dc7:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802dca:	be 00 00 00 00       	mov    $0x0,%esi
  802dcf:	bf 02 00 00 00       	mov    $0x2,%edi
  802dd4:	48 b8 51 2a 80 00 00 	movabs $0x802a51,%rax
  802ddb:	00 00 00 
  802dde:	ff d0                	callq  *%rax
}
  802de0:	c9                   	leaveq 
  802de1:	c3                   	retq   

0000000000802de2 <remove>:

// Delete a file
int
remove(const char *path)
{
  802de2:	55                   	push   %rbp
  802de3:	48 89 e5             	mov    %rsp,%rbp
  802de6:	48 83 ec 10          	sub    $0x10,%rsp
  802dea:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802dee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802df2:	48 89 c7             	mov    %rax,%rdi
  802df5:	48 b8 e2 14 80 00 00 	movabs $0x8014e2,%rax
  802dfc:	00 00 00 
  802dff:	ff d0                	callq  *%rax
  802e01:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802e06:	7e 07                	jle    802e0f <remove+0x2d>
		return -E_BAD_PATH;
  802e08:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802e0d:	eb 33                	jmp    802e42 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802e0f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e13:	48 89 c6             	mov    %rax,%rsi
  802e16:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  802e1d:	00 00 00 
  802e20:	48 b8 4e 15 80 00 00 	movabs $0x80154e,%rax
  802e27:	00 00 00 
  802e2a:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802e2c:	be 00 00 00 00       	mov    $0x0,%esi
  802e31:	bf 07 00 00 00       	mov    $0x7,%edi
  802e36:	48 b8 51 2a 80 00 00 	movabs $0x802a51,%rax
  802e3d:	00 00 00 
  802e40:	ff d0                	callq  *%rax
}
  802e42:	c9                   	leaveq 
  802e43:	c3                   	retq   

0000000000802e44 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802e44:	55                   	push   %rbp
  802e45:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802e48:	be 00 00 00 00       	mov    $0x0,%esi
  802e4d:	bf 08 00 00 00       	mov    $0x8,%edi
  802e52:	48 b8 51 2a 80 00 00 	movabs $0x802a51,%rax
  802e59:	00 00 00 
  802e5c:	ff d0                	callq  *%rax
}
  802e5e:	5d                   	pop    %rbp
  802e5f:	c3                   	retq   

0000000000802e60 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802e60:	55                   	push   %rbp
  802e61:	48 89 e5             	mov    %rsp,%rbp
  802e64:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802e6b:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802e72:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802e79:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802e80:	be 00 00 00 00       	mov    $0x0,%esi
  802e85:	48 89 c7             	mov    %rax,%rdi
  802e88:	48 b8 d8 2a 80 00 00 	movabs $0x802ad8,%rax
  802e8f:	00 00 00 
  802e92:	ff d0                	callq  *%rax
  802e94:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802e97:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e9b:	79 28                	jns    802ec5 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802e9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ea0:	89 c6                	mov    %eax,%esi
  802ea2:	48 bf 36 4c 80 00 00 	movabs $0x804c36,%rdi
  802ea9:	00 00 00 
  802eac:	b8 00 00 00 00       	mov    $0x0,%eax
  802eb1:	48 ba 99 09 80 00 00 	movabs $0x800999,%rdx
  802eb8:	00 00 00 
  802ebb:	ff d2                	callq  *%rdx
		return fd_src;
  802ebd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ec0:	e9 74 01 00 00       	jmpq   803039 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802ec5:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802ecc:	be 01 01 00 00       	mov    $0x101,%esi
  802ed1:	48 89 c7             	mov    %rax,%rdi
  802ed4:	48 b8 d8 2a 80 00 00 	movabs $0x802ad8,%rax
  802edb:	00 00 00 
  802ede:	ff d0                	callq  *%rax
  802ee0:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802ee3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ee7:	79 39                	jns    802f22 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802ee9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802eec:	89 c6                	mov    %eax,%esi
  802eee:	48 bf 4c 4c 80 00 00 	movabs $0x804c4c,%rdi
  802ef5:	00 00 00 
  802ef8:	b8 00 00 00 00       	mov    $0x0,%eax
  802efd:	48 ba 99 09 80 00 00 	movabs $0x800999,%rdx
  802f04:	00 00 00 
  802f07:	ff d2                	callq  *%rdx
		close(fd_src);
  802f09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f0c:	89 c7                	mov    %eax,%edi
  802f0e:	48 b8 e0 23 80 00 00 	movabs $0x8023e0,%rax
  802f15:	00 00 00 
  802f18:	ff d0                	callq  *%rax
		return fd_dest;
  802f1a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f1d:	e9 17 01 00 00       	jmpq   803039 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802f22:	eb 74                	jmp    802f98 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802f24:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f27:	48 63 d0             	movslq %eax,%rdx
  802f2a:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802f31:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f34:	48 89 ce             	mov    %rcx,%rsi
  802f37:	89 c7                	mov    %eax,%edi
  802f39:	48 b8 4c 27 80 00 00 	movabs $0x80274c,%rax
  802f40:	00 00 00 
  802f43:	ff d0                	callq  *%rax
  802f45:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802f48:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802f4c:	79 4a                	jns    802f98 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802f4e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802f51:	89 c6                	mov    %eax,%esi
  802f53:	48 bf 66 4c 80 00 00 	movabs $0x804c66,%rdi
  802f5a:	00 00 00 
  802f5d:	b8 00 00 00 00       	mov    $0x0,%eax
  802f62:	48 ba 99 09 80 00 00 	movabs $0x800999,%rdx
  802f69:	00 00 00 
  802f6c:	ff d2                	callq  *%rdx
			close(fd_src);
  802f6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f71:	89 c7                	mov    %eax,%edi
  802f73:	48 b8 e0 23 80 00 00 	movabs $0x8023e0,%rax
  802f7a:	00 00 00 
  802f7d:	ff d0                	callq  *%rax
			close(fd_dest);
  802f7f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f82:	89 c7                	mov    %eax,%edi
  802f84:	48 b8 e0 23 80 00 00 	movabs $0x8023e0,%rax
  802f8b:	00 00 00 
  802f8e:	ff d0                	callq  *%rax
			return write_size;
  802f90:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802f93:	e9 a1 00 00 00       	jmpq   803039 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802f98:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802f9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fa2:	ba 00 02 00 00       	mov    $0x200,%edx
  802fa7:	48 89 ce             	mov    %rcx,%rsi
  802faa:	89 c7                	mov    %eax,%edi
  802fac:	48 b8 02 26 80 00 00 	movabs $0x802602,%rax
  802fb3:	00 00 00 
  802fb6:	ff d0                	callq  *%rax
  802fb8:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802fbb:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802fbf:	0f 8f 5f ff ff ff    	jg     802f24 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802fc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802fc9:	79 47                	jns    803012 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802fcb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802fce:	89 c6                	mov    %eax,%esi
  802fd0:	48 bf 79 4c 80 00 00 	movabs $0x804c79,%rdi
  802fd7:	00 00 00 
  802fda:	b8 00 00 00 00       	mov    $0x0,%eax
  802fdf:	48 ba 99 09 80 00 00 	movabs $0x800999,%rdx
  802fe6:	00 00 00 
  802fe9:	ff d2                	callq  *%rdx
		close(fd_src);
  802feb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fee:	89 c7                	mov    %eax,%edi
  802ff0:	48 b8 e0 23 80 00 00 	movabs $0x8023e0,%rax
  802ff7:	00 00 00 
  802ffa:	ff d0                	callq  *%rax
		close(fd_dest);
  802ffc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fff:	89 c7                	mov    %eax,%edi
  803001:	48 b8 e0 23 80 00 00 	movabs $0x8023e0,%rax
  803008:	00 00 00 
  80300b:	ff d0                	callq  *%rax
		return read_size;
  80300d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803010:	eb 27                	jmp    803039 <copy+0x1d9>
	}
	close(fd_src);
  803012:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803015:	89 c7                	mov    %eax,%edi
  803017:	48 b8 e0 23 80 00 00 	movabs $0x8023e0,%rax
  80301e:	00 00 00 
  803021:	ff d0                	callq  *%rax
	close(fd_dest);
  803023:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803026:	89 c7                	mov    %eax,%edi
  803028:	48 b8 e0 23 80 00 00 	movabs $0x8023e0,%rax
  80302f:	00 00 00 
  803032:	ff d0                	callq  *%rax
	return 0;
  803034:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803039:	c9                   	leaveq 
  80303a:	c3                   	retq   

000000000080303b <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  80303b:	55                   	push   %rbp
  80303c:	48 89 e5             	mov    %rsp,%rbp
  80303f:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  803046:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  80304d:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  803054:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  80305b:	be 00 00 00 00       	mov    $0x0,%esi
  803060:	48 89 c7             	mov    %rax,%rdi
  803063:	48 b8 d8 2a 80 00 00 	movabs $0x802ad8,%rax
  80306a:	00 00 00 
  80306d:	ff d0                	callq  *%rax
  80306f:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803072:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803076:	79 08                	jns    803080 <spawn+0x45>
		return r;
  803078:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80307b:	e9 14 03 00 00       	jmpq   803394 <spawn+0x359>
	fd = r;
  803080:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803083:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  803086:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  80308d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  803091:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  803098:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80309b:	ba 00 02 00 00       	mov    $0x200,%edx
  8030a0:	48 89 ce             	mov    %rcx,%rsi
  8030a3:	89 c7                	mov    %eax,%edi
  8030a5:	48 b8 d7 26 80 00 00 	movabs $0x8026d7,%rax
  8030ac:	00 00 00 
  8030af:	ff d0                	callq  *%rax
  8030b1:	3d 00 02 00 00       	cmp    $0x200,%eax
  8030b6:	75 0d                	jne    8030c5 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  8030b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030bc:	8b 00                	mov    (%rax),%eax
  8030be:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  8030c3:	74 43                	je     803108 <spawn+0xcd>
		close(fd);
  8030c5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8030c8:	89 c7                	mov    %eax,%edi
  8030ca:	48 b8 e0 23 80 00 00 	movabs $0x8023e0,%rax
  8030d1:	00 00 00 
  8030d4:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8030d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030da:	8b 00                	mov    (%rax),%eax
  8030dc:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  8030e1:	89 c6                	mov    %eax,%esi
  8030e3:	48 bf 90 4c 80 00 00 	movabs $0x804c90,%rdi
  8030ea:	00 00 00 
  8030ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8030f2:	48 b9 99 09 80 00 00 	movabs $0x800999,%rcx
  8030f9:	00 00 00 
  8030fc:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  8030fe:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803103:	e9 8c 02 00 00       	jmpq   803394 <spawn+0x359>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  803108:	b8 07 00 00 00       	mov    $0x7,%eax
  80310d:	cd 30                	int    $0x30
  80310f:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  803112:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  803115:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803118:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80311c:	79 08                	jns    803126 <spawn+0xeb>
		return r;
  80311e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803121:	e9 6e 02 00 00       	jmpq   803394 <spawn+0x359>
	child = r;
  803126:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803129:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80312c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80312f:	25 ff 03 00 00       	and    $0x3ff,%eax
  803134:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80313b:	00 00 00 
  80313e:	48 63 d0             	movslq %eax,%rdx
  803141:	48 89 d0             	mov    %rdx,%rax
  803144:	48 c1 e0 03          	shl    $0x3,%rax
  803148:	48 01 d0             	add    %rdx,%rax
  80314b:	48 c1 e0 05          	shl    $0x5,%rax
  80314f:	48 01 c8             	add    %rcx,%rax
  803152:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803159:	48 89 c6             	mov    %rax,%rsi
  80315c:	b8 18 00 00 00       	mov    $0x18,%eax
  803161:	48 89 d7             	mov    %rdx,%rdi
  803164:	48 89 c1             	mov    %rax,%rcx
  803167:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  80316a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80316e:	48 8b 40 18          	mov    0x18(%rax),%rax
  803172:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  803179:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  803180:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  803187:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  80318e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803191:	48 89 ce             	mov    %rcx,%rsi
  803194:	89 c7                	mov    %eax,%edi
  803196:	48 b8 fe 35 80 00 00 	movabs $0x8035fe,%rax
  80319d:	00 00 00 
  8031a0:	ff d0                	callq  *%rax
  8031a2:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8031a5:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8031a9:	79 08                	jns    8031b3 <spawn+0x178>
		return r;
  8031ab:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8031ae:	e9 e1 01 00 00       	jmpq   803394 <spawn+0x359>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8031b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031b7:	48 8b 40 20          	mov    0x20(%rax),%rax
  8031bb:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  8031c2:	48 01 d0             	add    %rdx,%rax
  8031c5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8031c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8031d0:	e9 a3 00 00 00       	jmpq   803278 <spawn+0x23d>
		if (ph->p_type != ELF_PROG_LOAD)
  8031d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031d9:	8b 00                	mov    (%rax),%eax
  8031db:	83 f8 01             	cmp    $0x1,%eax
  8031de:	74 05                	je     8031e5 <spawn+0x1aa>
			continue;
  8031e0:	e9 8a 00 00 00       	jmpq   80326f <spawn+0x234>
		perm = PTE_P | PTE_U;
  8031e5:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8031ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031f0:	8b 40 04             	mov    0x4(%rax),%eax
  8031f3:	83 e0 02             	and    $0x2,%eax
  8031f6:	85 c0                	test   %eax,%eax
  8031f8:	74 04                	je     8031fe <spawn+0x1c3>
			perm |= PTE_W;
  8031fa:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  8031fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803202:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  803206:	41 89 c1             	mov    %eax,%r9d
  803209:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80320d:	4c 8b 40 20          	mov    0x20(%rax),%r8
  803211:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803215:	48 8b 50 28          	mov    0x28(%rax),%rdx
  803219:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80321d:	48 8b 70 10          	mov    0x10(%rax),%rsi
  803221:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803224:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803227:	8b 7d ec             	mov    -0x14(%rbp),%edi
  80322a:	89 3c 24             	mov    %edi,(%rsp)
  80322d:	89 c7                	mov    %eax,%edi
  80322f:	48 b8 a7 38 80 00 00 	movabs $0x8038a7,%rax
  803236:	00 00 00 
  803239:	ff d0                	callq  *%rax
  80323b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80323e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803242:	79 2b                	jns    80326f <spawn+0x234>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  803244:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  803245:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803248:	89 c7                	mov    %eax,%edi
  80324a:	48 b8 bd 1d 80 00 00 	movabs $0x801dbd,%rax
  803251:	00 00 00 
  803254:	ff d0                	callq  *%rax
	close(fd);
  803256:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803259:	89 c7                	mov    %eax,%edi
  80325b:	48 b8 e0 23 80 00 00 	movabs $0x8023e0,%rax
  803262:	00 00 00 
  803265:	ff d0                	callq  *%rax
	return r;
  803267:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80326a:	e9 25 01 00 00       	jmpq   803394 <spawn+0x359>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80326f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803273:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  803278:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80327c:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  803280:	0f b7 c0             	movzwl %ax,%eax
  803283:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  803286:	0f 8f 49 ff ff ff    	jg     8031d5 <spawn+0x19a>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  80328c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80328f:	89 c7                	mov    %eax,%edi
  803291:	48 b8 e0 23 80 00 00 	movabs $0x8023e0,%rax
  803298:	00 00 00 
  80329b:	ff d0                	callq  *%rax
	fd = -1;
  80329d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  8032a4:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8032a7:	89 c7                	mov    %eax,%edi
  8032a9:	48 b8 93 3a 80 00 00 	movabs $0x803a93,%rax
  8032b0:	00 00 00 
  8032b3:	ff d0                	callq  *%rax
  8032b5:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8032b8:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8032bc:	79 30                	jns    8032ee <spawn+0x2b3>
		panic("copy_shared_pages: %e", r);
  8032be:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8032c1:	89 c1                	mov    %eax,%ecx
  8032c3:	48 ba aa 4c 80 00 00 	movabs $0x804caa,%rdx
  8032ca:	00 00 00 
  8032cd:	be 82 00 00 00       	mov    $0x82,%esi
  8032d2:	48 bf c0 4c 80 00 00 	movabs $0x804cc0,%rdi
  8032d9:	00 00 00 
  8032dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e1:	49 b8 60 07 80 00 00 	movabs $0x800760,%r8
  8032e8:	00 00 00 
  8032eb:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8032ee:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  8032f5:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8032f8:	48 89 d6             	mov    %rdx,%rsi
  8032fb:	89 c7                	mov    %eax,%edi
  8032fd:	48 b8 bd 1f 80 00 00 	movabs $0x801fbd,%rax
  803304:	00 00 00 
  803307:	ff d0                	callq  *%rax
  803309:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80330c:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803310:	79 30                	jns    803342 <spawn+0x307>
		panic("sys_env_set_trapframe: %e", r);
  803312:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803315:	89 c1                	mov    %eax,%ecx
  803317:	48 ba cc 4c 80 00 00 	movabs $0x804ccc,%rdx
  80331e:	00 00 00 
  803321:	be 85 00 00 00       	mov    $0x85,%esi
  803326:	48 bf c0 4c 80 00 00 	movabs $0x804cc0,%rdi
  80332d:	00 00 00 
  803330:	b8 00 00 00 00       	mov    $0x0,%eax
  803335:	49 b8 60 07 80 00 00 	movabs $0x800760,%r8
  80333c:	00 00 00 
  80333f:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  803342:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803345:	be 02 00 00 00       	mov    $0x2,%esi
  80334a:	89 c7                	mov    %eax,%edi
  80334c:	48 b8 72 1f 80 00 00 	movabs $0x801f72,%rax
  803353:	00 00 00 
  803356:	ff d0                	callq  *%rax
  803358:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80335b:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80335f:	79 30                	jns    803391 <spawn+0x356>
		panic("sys_env_set_status: %e", r);
  803361:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803364:	89 c1                	mov    %eax,%ecx
  803366:	48 ba e6 4c 80 00 00 	movabs $0x804ce6,%rdx
  80336d:	00 00 00 
  803370:	be 88 00 00 00       	mov    $0x88,%esi
  803375:	48 bf c0 4c 80 00 00 	movabs $0x804cc0,%rdi
  80337c:	00 00 00 
  80337f:	b8 00 00 00 00       	mov    $0x0,%eax
  803384:	49 b8 60 07 80 00 00 	movabs $0x800760,%r8
  80338b:	00 00 00 
  80338e:	41 ff d0             	callq  *%r8

	return child;
  803391:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  803394:	c9                   	leaveq 
  803395:	c3                   	retq   

0000000000803396 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  803396:	55                   	push   %rbp
  803397:	48 89 e5             	mov    %rsp,%rbp
  80339a:	41 55                	push   %r13
  80339c:	41 54                	push   %r12
  80339e:	53                   	push   %rbx
  80339f:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8033a6:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  8033ad:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  8033b4:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  8033bb:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  8033c2:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  8033c9:	84 c0                	test   %al,%al
  8033cb:	74 26                	je     8033f3 <spawnl+0x5d>
  8033cd:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  8033d4:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  8033db:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  8033df:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  8033e3:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  8033e7:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  8033eb:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  8033ef:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  8033f3:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  8033fa:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  803401:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  803404:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  80340b:	00 00 00 
  80340e:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803415:	00 00 00 
  803418:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80341c:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803423:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  80342a:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  803431:	eb 07                	jmp    80343a <spawnl+0xa4>
		argc++;
  803433:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  80343a:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803440:	83 f8 30             	cmp    $0x30,%eax
  803443:	73 23                	jae    803468 <spawnl+0xd2>
  803445:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  80344c:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803452:	89 c0                	mov    %eax,%eax
  803454:	48 01 d0             	add    %rdx,%rax
  803457:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  80345d:	83 c2 08             	add    $0x8,%edx
  803460:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803466:	eb 15                	jmp    80347d <spawnl+0xe7>
  803468:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  80346f:	48 89 d0             	mov    %rdx,%rax
  803472:	48 83 c2 08          	add    $0x8,%rdx
  803476:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  80347d:	48 8b 00             	mov    (%rax),%rax
  803480:	48 85 c0             	test   %rax,%rax
  803483:	75 ae                	jne    803433 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  803485:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80348b:	83 c0 02             	add    $0x2,%eax
  80348e:	48 89 e2             	mov    %rsp,%rdx
  803491:	48 89 d3             	mov    %rdx,%rbx
  803494:	48 63 d0             	movslq %eax,%rdx
  803497:	48 83 ea 01          	sub    $0x1,%rdx
  80349b:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  8034a2:	48 63 d0             	movslq %eax,%rdx
  8034a5:	49 89 d4             	mov    %rdx,%r12
  8034a8:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8034ae:	48 63 d0             	movslq %eax,%rdx
  8034b1:	49 89 d2             	mov    %rdx,%r10
  8034b4:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  8034ba:	48 98                	cltq   
  8034bc:	48 c1 e0 03          	shl    $0x3,%rax
  8034c0:	48 8d 50 07          	lea    0x7(%rax),%rdx
  8034c4:	b8 10 00 00 00       	mov    $0x10,%eax
  8034c9:	48 83 e8 01          	sub    $0x1,%rax
  8034cd:	48 01 d0             	add    %rdx,%rax
  8034d0:	bf 10 00 00 00       	mov    $0x10,%edi
  8034d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8034da:	48 f7 f7             	div    %rdi
  8034dd:	48 6b c0 10          	imul   $0x10,%rax,%rax
  8034e1:	48 29 c4             	sub    %rax,%rsp
  8034e4:	48 89 e0             	mov    %rsp,%rax
  8034e7:	48 83 c0 07          	add    $0x7,%rax
  8034eb:	48 c1 e8 03          	shr    $0x3,%rax
  8034ef:	48 c1 e0 03          	shl    $0x3,%rax
  8034f3:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  8034fa:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803501:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  803508:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  80350b:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803511:	8d 50 01             	lea    0x1(%rax),%edx
  803514:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80351b:	48 63 d2             	movslq %edx,%rdx
  80351e:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803525:	00 

	va_start(vl, arg0);
  803526:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  80352d:	00 00 00 
  803530:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803537:	00 00 00 
  80353a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80353e:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803545:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  80354c:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  803553:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  80355a:	00 00 00 
  80355d:	eb 63                	jmp    8035c2 <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  80355f:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  803565:	8d 70 01             	lea    0x1(%rax),%esi
  803568:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80356e:	83 f8 30             	cmp    $0x30,%eax
  803571:	73 23                	jae    803596 <spawnl+0x200>
  803573:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  80357a:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803580:	89 c0                	mov    %eax,%eax
  803582:	48 01 d0             	add    %rdx,%rax
  803585:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  80358b:	83 c2 08             	add    $0x8,%edx
  80358e:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803594:	eb 15                	jmp    8035ab <spawnl+0x215>
  803596:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  80359d:	48 89 d0             	mov    %rdx,%rax
  8035a0:	48 83 c2 08          	add    $0x8,%rdx
  8035a4:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8035ab:	48 8b 08             	mov    (%rax),%rcx
  8035ae:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8035b5:	89 f2                	mov    %esi,%edx
  8035b7:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8035bb:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  8035c2:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8035c8:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  8035ce:	77 8f                	ja     80355f <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  8035d0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8035d7:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  8035de:	48 89 d6             	mov    %rdx,%rsi
  8035e1:	48 89 c7             	mov    %rax,%rdi
  8035e4:	48 b8 3b 30 80 00 00 	movabs $0x80303b,%rax
  8035eb:	00 00 00 
  8035ee:	ff d0                	callq  *%rax
  8035f0:	48 89 dc             	mov    %rbx,%rsp
}
  8035f3:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  8035f7:	5b                   	pop    %rbx
  8035f8:	41 5c                	pop    %r12
  8035fa:	41 5d                	pop    %r13
  8035fc:	5d                   	pop    %rbp
  8035fd:	c3                   	retq   

00000000008035fe <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  8035fe:	55                   	push   %rbp
  8035ff:	48 89 e5             	mov    %rsp,%rbp
  803602:	48 83 ec 50          	sub    $0x50,%rsp
  803606:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803609:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80360d:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803611:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803618:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803619:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  803620:	eb 33                	jmp    803655 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  803622:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803625:	48 98                	cltq   
  803627:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80362e:	00 
  80362f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803633:	48 01 d0             	add    %rdx,%rax
  803636:	48 8b 00             	mov    (%rax),%rax
  803639:	48 89 c7             	mov    %rax,%rdi
  80363c:	48 b8 e2 14 80 00 00 	movabs $0x8014e2,%rax
  803643:	00 00 00 
  803646:	ff d0                	callq  *%rax
  803648:	83 c0 01             	add    $0x1,%eax
  80364b:	48 98                	cltq   
  80364d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  803651:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803655:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803658:	48 98                	cltq   
  80365a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803661:	00 
  803662:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803666:	48 01 d0             	add    %rdx,%rax
  803669:	48 8b 00             	mov    (%rax),%rax
  80366c:	48 85 c0             	test   %rax,%rax
  80366f:	75 b1                	jne    803622 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  803671:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803675:	48 f7 d8             	neg    %rax
  803678:	48 05 00 10 40 00    	add    $0x401000,%rax
  80367e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  803682:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803686:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80368a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80368e:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  803692:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803695:	83 c2 01             	add    $0x1,%edx
  803698:	c1 e2 03             	shl    $0x3,%edx
  80369b:	48 63 d2             	movslq %edx,%rdx
  80369e:	48 f7 da             	neg    %rdx
  8036a1:	48 01 d0             	add    %rdx,%rax
  8036a4:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8036a8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036ac:	48 83 e8 10          	sub    $0x10,%rax
  8036b0:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  8036b6:	77 0a                	ja     8036c2 <init_stack+0xc4>
		return -E_NO_MEM;
  8036b8:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  8036bd:	e9 e3 01 00 00       	jmpq   8038a5 <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8036c2:	ba 07 00 00 00       	mov    $0x7,%edx
  8036c7:	be 00 00 40 00       	mov    $0x400000,%esi
  8036cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8036d1:	48 b8 7d 1e 80 00 00 	movabs $0x801e7d,%rax
  8036d8:	00 00 00 
  8036db:	ff d0                	callq  *%rax
  8036dd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036e4:	79 08                	jns    8036ee <init_stack+0xf0>
		return r;
  8036e6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036e9:	e9 b7 01 00 00       	jmpq   8038a5 <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8036ee:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  8036f5:	e9 8a 00 00 00       	jmpq   803784 <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  8036fa:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8036fd:	48 98                	cltq   
  8036ff:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803706:	00 
  803707:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80370b:	48 01 c2             	add    %rax,%rdx
  80370e:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803713:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803717:	48 01 c8             	add    %rcx,%rax
  80371a:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803720:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  803723:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803726:	48 98                	cltq   
  803728:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80372f:	00 
  803730:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803734:	48 01 d0             	add    %rdx,%rax
  803737:	48 8b 10             	mov    (%rax),%rdx
  80373a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80373e:	48 89 d6             	mov    %rdx,%rsi
  803741:	48 89 c7             	mov    %rax,%rdi
  803744:	48 b8 4e 15 80 00 00 	movabs $0x80154e,%rax
  80374b:	00 00 00 
  80374e:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803750:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803753:	48 98                	cltq   
  803755:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80375c:	00 
  80375d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803761:	48 01 d0             	add    %rdx,%rax
  803764:	48 8b 00             	mov    (%rax),%rax
  803767:	48 89 c7             	mov    %rax,%rdi
  80376a:	48 b8 e2 14 80 00 00 	movabs $0x8014e2,%rax
  803771:	00 00 00 
  803774:	ff d0                	callq  *%rax
  803776:	48 98                	cltq   
  803778:	48 83 c0 01          	add    $0x1,%rax
  80377c:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803780:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  803784:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803787:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80378a:	0f 8c 6a ff ff ff    	jl     8036fa <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  803790:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803793:	48 98                	cltq   
  803795:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80379c:	00 
  80379d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037a1:	48 01 d0             	add    %rdx,%rax
  8037a4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8037ab:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  8037b2:	00 
  8037b3:	74 35                	je     8037ea <init_stack+0x1ec>
  8037b5:	48 b9 00 4d 80 00 00 	movabs $0x804d00,%rcx
  8037bc:	00 00 00 
  8037bf:	48 ba 26 4d 80 00 00 	movabs $0x804d26,%rdx
  8037c6:	00 00 00 
  8037c9:	be f1 00 00 00       	mov    $0xf1,%esi
  8037ce:	48 bf c0 4c 80 00 00 	movabs $0x804cc0,%rdi
  8037d5:	00 00 00 
  8037d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8037dd:	49 b8 60 07 80 00 00 	movabs $0x800760,%r8
  8037e4:	00 00 00 
  8037e7:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8037ea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037ee:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  8037f2:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8037f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037fb:	48 01 c8             	add    %rcx,%rax
  8037fe:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803804:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  803807:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80380b:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  80380f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803812:	48 98                	cltq   
  803814:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  803817:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  80381c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803820:	48 01 d0             	add    %rdx,%rax
  803823:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803829:	48 89 c2             	mov    %rax,%rdx
  80382c:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803830:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  803833:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803836:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80383c:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803841:	89 c2                	mov    %eax,%edx
  803843:	be 00 00 40 00       	mov    $0x400000,%esi
  803848:	bf 00 00 00 00       	mov    $0x0,%edi
  80384d:	48 b8 cd 1e 80 00 00 	movabs $0x801ecd,%rax
  803854:	00 00 00 
  803857:	ff d0                	callq  *%rax
  803859:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80385c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803860:	79 02                	jns    803864 <init_stack+0x266>
		goto error;
  803862:	eb 28                	jmp    80388c <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803864:	be 00 00 40 00       	mov    $0x400000,%esi
  803869:	bf 00 00 00 00       	mov    $0x0,%edi
  80386e:	48 b8 28 1f 80 00 00 	movabs $0x801f28,%rax
  803875:	00 00 00 
  803878:	ff d0                	callq  *%rax
  80387a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80387d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803881:	79 02                	jns    803885 <init_stack+0x287>
		goto error;
  803883:	eb 07                	jmp    80388c <init_stack+0x28e>

	return 0;
  803885:	b8 00 00 00 00       	mov    $0x0,%eax
  80388a:	eb 19                	jmp    8038a5 <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  80388c:	be 00 00 40 00       	mov    $0x400000,%esi
  803891:	bf 00 00 00 00       	mov    $0x0,%edi
  803896:	48 b8 28 1f 80 00 00 	movabs $0x801f28,%rax
  80389d:	00 00 00 
  8038a0:	ff d0                	callq  *%rax
	return r;
  8038a2:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8038a5:	c9                   	leaveq 
  8038a6:	c3                   	retq   

00000000008038a7 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  8038a7:	55                   	push   %rbp
  8038a8:	48 89 e5             	mov    %rsp,%rbp
  8038ab:	48 83 ec 50          	sub    $0x50,%rsp
  8038af:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8038b2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8038b6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8038ba:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  8038bd:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8038c1:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  8038c5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038c9:	25 ff 0f 00 00       	and    $0xfff,%eax
  8038ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038d5:	74 21                	je     8038f8 <map_segment+0x51>
		va -= i;
  8038d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038da:	48 98                	cltq   
  8038dc:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  8038e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e3:	48 98                	cltq   
  8038e5:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  8038e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038ec:	48 98                	cltq   
  8038ee:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  8038f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038f5:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8038f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8038ff:	e9 79 01 00 00       	jmpq   803a7d <map_segment+0x1d6>
		if (i >= filesz) {
  803904:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803907:	48 98                	cltq   
  803909:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  80390d:	72 3c                	jb     80394b <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  80390f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803912:	48 63 d0             	movslq %eax,%rdx
  803915:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803919:	48 01 d0             	add    %rdx,%rax
  80391c:	48 89 c1             	mov    %rax,%rcx
  80391f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803922:	8b 55 10             	mov    0x10(%rbp),%edx
  803925:	48 89 ce             	mov    %rcx,%rsi
  803928:	89 c7                	mov    %eax,%edi
  80392a:	48 b8 7d 1e 80 00 00 	movabs $0x801e7d,%rax
  803931:	00 00 00 
  803934:	ff d0                	callq  *%rax
  803936:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803939:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80393d:	0f 89 33 01 00 00    	jns    803a76 <map_segment+0x1cf>
				return r;
  803943:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803946:	e9 46 01 00 00       	jmpq   803a91 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80394b:	ba 07 00 00 00       	mov    $0x7,%edx
  803950:	be 00 00 40 00       	mov    $0x400000,%esi
  803955:	bf 00 00 00 00       	mov    $0x0,%edi
  80395a:	48 b8 7d 1e 80 00 00 	movabs $0x801e7d,%rax
  803961:	00 00 00 
  803964:	ff d0                	callq  *%rax
  803966:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803969:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80396d:	79 08                	jns    803977 <map_segment+0xd0>
				return r;
  80396f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803972:	e9 1a 01 00 00       	jmpq   803a91 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  803977:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80397a:	8b 55 bc             	mov    -0x44(%rbp),%edx
  80397d:	01 c2                	add    %eax,%edx
  80397f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803982:	89 d6                	mov    %edx,%esi
  803984:	89 c7                	mov    %eax,%edi
  803986:	48 b8 20 28 80 00 00 	movabs $0x802820,%rax
  80398d:	00 00 00 
  803990:	ff d0                	callq  *%rax
  803992:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803995:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803999:	79 08                	jns    8039a3 <map_segment+0xfc>
				return r;
  80399b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80399e:	e9 ee 00 00 00       	jmpq   803a91 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8039a3:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  8039aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039ad:	48 98                	cltq   
  8039af:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8039b3:	48 29 c2             	sub    %rax,%rdx
  8039b6:	48 89 d0             	mov    %rdx,%rax
  8039b9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8039bd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8039c0:	48 63 d0             	movslq %eax,%rdx
  8039c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039c7:	48 39 c2             	cmp    %rax,%rdx
  8039ca:	48 0f 47 d0          	cmova  %rax,%rdx
  8039ce:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8039d1:	be 00 00 40 00       	mov    $0x400000,%esi
  8039d6:	89 c7                	mov    %eax,%edi
  8039d8:	48 b8 d7 26 80 00 00 	movabs $0x8026d7,%rax
  8039df:	00 00 00 
  8039e2:	ff d0                	callq  *%rax
  8039e4:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8039e7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8039eb:	79 08                	jns    8039f5 <map_segment+0x14e>
				return r;
  8039ed:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039f0:	e9 9c 00 00 00       	jmpq   803a91 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8039f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039f8:	48 63 d0             	movslq %eax,%rdx
  8039fb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039ff:	48 01 d0             	add    %rdx,%rax
  803a02:	48 89 c2             	mov    %rax,%rdx
  803a05:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803a08:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803a0c:	48 89 d1             	mov    %rdx,%rcx
  803a0f:	89 c2                	mov    %eax,%edx
  803a11:	be 00 00 40 00       	mov    $0x400000,%esi
  803a16:	bf 00 00 00 00       	mov    $0x0,%edi
  803a1b:	48 b8 cd 1e 80 00 00 	movabs $0x801ecd,%rax
  803a22:	00 00 00 
  803a25:	ff d0                	callq  *%rax
  803a27:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803a2a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803a2e:	79 30                	jns    803a60 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  803a30:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a33:	89 c1                	mov    %eax,%ecx
  803a35:	48 ba 3b 4d 80 00 00 	movabs $0x804d3b,%rdx
  803a3c:	00 00 00 
  803a3f:	be 24 01 00 00       	mov    $0x124,%esi
  803a44:	48 bf c0 4c 80 00 00 	movabs $0x804cc0,%rdi
  803a4b:	00 00 00 
  803a4e:	b8 00 00 00 00       	mov    $0x0,%eax
  803a53:	49 b8 60 07 80 00 00 	movabs $0x800760,%r8
  803a5a:	00 00 00 
  803a5d:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803a60:	be 00 00 40 00       	mov    $0x400000,%esi
  803a65:	bf 00 00 00 00       	mov    $0x0,%edi
  803a6a:	48 b8 28 1f 80 00 00 	movabs $0x801f28,%rax
  803a71:	00 00 00 
  803a74:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803a76:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803a7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a80:	48 98                	cltq   
  803a82:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a86:	0f 82 78 fe ff ff    	jb     803904 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  803a8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a91:	c9                   	leaveq 
  803a92:	c3                   	retq   

0000000000803a93 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803a93:	55                   	push   %rbp
  803a94:	48 89 e5             	mov    %rsp,%rbp
  803a97:	48 83 ec 70          	sub    $0x70,%rsp
  803a9b:	89 7d 9c             	mov    %edi,-0x64(%rbp)
	// LAB 5: Your code here.
	int r, perm;
	void* va;
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  803a9e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803aa5:	00 
  803aa6:	e9 70 01 00 00       	jmpq   803c1b <copy_shared_pages+0x188>
		if(uvpml4e[pml4e] & PTE_P){
  803aab:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803ab2:	01 00 00 
  803ab5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803ab9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803abd:	83 e0 01             	and    $0x1,%eax
  803ac0:	48 85 c0             	test   %rax,%rax
  803ac3:	0f 84 4d 01 00 00    	je     803c16 <copy_shared_pages+0x183>
			base_pml4e = pml4e * NPDPENTRIES;
  803ac9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803acd:	48 c1 e0 09          	shl    $0x9,%rax
  803ad1:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  803ad5:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  803adc:	00 
  803add:	e9 26 01 00 00       	jmpq   803c08 <copy_shared_pages+0x175>
				if(uvpde[base_pml4e + pdpe] & PTE_P){
  803ae2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ae6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803aea:	48 01 c2             	add    %rax,%rdx
  803aed:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803af4:	01 00 00 
  803af7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803afb:	83 e0 01             	and    $0x1,%eax
  803afe:	48 85 c0             	test   %rax,%rax
  803b01:	0f 84 fc 00 00 00    	je     803c03 <copy_shared_pages+0x170>
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
  803b07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b0b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803b0f:	48 01 d0             	add    %rdx,%rax
  803b12:	48 c1 e0 09          	shl    $0x9,%rax
  803b16:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
					for(pde = 0; pde < NPDENTRIES; pde++){
  803b1a:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  803b21:	00 
  803b22:	e9 ce 00 00 00       	jmpq   803bf5 <copy_shared_pages+0x162>
						if(uvpd[base_pdpe + pde] & PTE_P){
  803b27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b2b:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  803b2f:	48 01 c2             	add    %rax,%rdx
  803b32:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803b39:	01 00 00 
  803b3c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b40:	83 e0 01             	and    $0x1,%eax
  803b43:	48 85 c0             	test   %rax,%rax
  803b46:	0f 84 a4 00 00 00    	je     803bf0 <copy_shared_pages+0x15d>
							base_pde = (base_pdpe + pde) * NPTENTRIES;
  803b4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b50:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  803b54:	48 01 d0             	add    %rdx,%rax
  803b57:	48 c1 e0 09          	shl    $0x9,%rax
  803b5b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
							for(pte = 0; pte < NPTENTRIES; pte++){
  803b5f:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  803b66:	00 
  803b67:	eb 79                	jmp    803be2 <copy_shared_pages+0x14f>
								entry = base_pde + pte;
  803b69:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b6d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803b71:	48 01 d0             	add    %rdx,%rax
  803b74:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
								perm = uvpt[entry] & PTE_SYSCALL;
  803b78:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803b7f:	01 00 00 
  803b82:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803b86:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b8a:	25 07 0e 00 00       	and    $0xe07,%eax
  803b8f:	89 45 bc             	mov    %eax,-0x44(%rbp)
								if(perm & PTE_SHARE){
  803b92:	8b 45 bc             	mov    -0x44(%rbp),%eax
  803b95:	25 00 04 00 00       	and    $0x400,%eax
  803b9a:	85 c0                	test   %eax,%eax
  803b9c:	74 3f                	je     803bdd <copy_shared_pages+0x14a>
									va = (void*)(PGSIZE * entry);
  803b9e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803ba2:	48 c1 e0 0c          	shl    $0xc,%rax
  803ba6:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
									r = sys_page_map(0, va, child, va, perm);		
  803baa:	8b 75 bc             	mov    -0x44(%rbp),%esi
  803bad:	48 8b 4d b0          	mov    -0x50(%rbp),%rcx
  803bb1:	8b 55 9c             	mov    -0x64(%rbp),%edx
  803bb4:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  803bb8:	41 89 f0             	mov    %esi,%r8d
  803bbb:	48 89 c6             	mov    %rax,%rsi
  803bbe:	bf 00 00 00 00       	mov    $0x0,%edi
  803bc3:	48 b8 cd 1e 80 00 00 	movabs $0x801ecd,%rax
  803bca:	00 00 00 
  803bcd:	ff d0                	callq  *%rax
  803bcf:	89 45 ac             	mov    %eax,-0x54(%rbp)
									if(r < 0) return r;
  803bd2:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  803bd6:	79 05                	jns    803bdd <copy_shared_pages+0x14a>
  803bd8:	8b 45 ac             	mov    -0x54(%rbp),%eax
  803bdb:	eb 4e                	jmp    803c2b <copy_shared_pages+0x198>
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
						if(uvpd[base_pdpe + pde] & PTE_P){
							base_pde = (base_pdpe + pde) * NPTENTRIES;
							for(pte = 0; pte < NPTENTRIES; pte++){
  803bdd:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  803be2:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  803be9:	00 
  803bea:	0f 86 79 ff ff ff    	jbe    803b69 <copy_shared_pages+0xd6>
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
  803bf0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803bf5:	48 81 7d e8 ff 01 00 	cmpq   $0x1ff,-0x18(%rbp)
  803bfc:	00 
  803bfd:	0f 86 24 ff ff ff    	jbe    803b27 <copy_shared_pages+0x94>
	void* va;
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  803c03:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  803c08:	48 81 7d f0 ff 01 00 	cmpq   $0x1ff,-0x10(%rbp)
  803c0f:	00 
  803c10:	0f 86 cc fe ff ff    	jbe    803ae2 <copy_shared_pages+0x4f>
{
	// LAB 5: Your code here.
	int r, perm;
	void* va;
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  803c16:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803c1b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803c20:	0f 84 85 fe ff ff    	je     803aab <copy_shared_pages+0x18>
					}
				}
			}
		}
	}
	return 0;
  803c26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c2b:	c9                   	leaveq 
  803c2c:	c3                   	retq   

0000000000803c2d <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803c2d:	55                   	push   %rbp
  803c2e:	48 89 e5             	mov    %rsp,%rbp
  803c31:	53                   	push   %rbx
  803c32:	48 83 ec 38          	sub    $0x38,%rsp
  803c36:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803c3a:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803c3e:	48 89 c7             	mov    %rax,%rdi
  803c41:	48 b8 38 21 80 00 00 	movabs $0x802138,%rax
  803c48:	00 00 00 
  803c4b:	ff d0                	callq  *%rax
  803c4d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c50:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c54:	0f 88 bf 01 00 00    	js     803e19 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c5e:	ba 07 04 00 00       	mov    $0x407,%edx
  803c63:	48 89 c6             	mov    %rax,%rsi
  803c66:	bf 00 00 00 00       	mov    $0x0,%edi
  803c6b:	48 b8 7d 1e 80 00 00 	movabs $0x801e7d,%rax
  803c72:	00 00 00 
  803c75:	ff d0                	callq  *%rax
  803c77:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c7a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c7e:	0f 88 95 01 00 00    	js     803e19 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803c84:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803c88:	48 89 c7             	mov    %rax,%rdi
  803c8b:	48 b8 38 21 80 00 00 	movabs $0x802138,%rax
  803c92:	00 00 00 
  803c95:	ff d0                	callq  *%rax
  803c97:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c9a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c9e:	0f 88 5d 01 00 00    	js     803e01 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ca4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ca8:	ba 07 04 00 00       	mov    $0x407,%edx
  803cad:	48 89 c6             	mov    %rax,%rsi
  803cb0:	bf 00 00 00 00       	mov    $0x0,%edi
  803cb5:	48 b8 7d 1e 80 00 00 	movabs $0x801e7d,%rax
  803cbc:	00 00 00 
  803cbf:	ff d0                	callq  *%rax
  803cc1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803cc4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cc8:	0f 88 33 01 00 00    	js     803e01 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803cce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cd2:	48 89 c7             	mov    %rax,%rdi
  803cd5:	48 b8 0d 21 80 00 00 	movabs $0x80210d,%rax
  803cdc:	00 00 00 
  803cdf:	ff d0                	callq  *%rax
  803ce1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ce5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ce9:	ba 07 04 00 00       	mov    $0x407,%edx
  803cee:	48 89 c6             	mov    %rax,%rsi
  803cf1:	bf 00 00 00 00       	mov    $0x0,%edi
  803cf6:	48 b8 7d 1e 80 00 00 	movabs $0x801e7d,%rax
  803cfd:	00 00 00 
  803d00:	ff d0                	callq  *%rax
  803d02:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d05:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d09:	79 05                	jns    803d10 <pipe+0xe3>
		goto err2;
  803d0b:	e9 d9 00 00 00       	jmpq   803de9 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d10:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d14:	48 89 c7             	mov    %rax,%rdi
  803d17:	48 b8 0d 21 80 00 00 	movabs $0x80210d,%rax
  803d1e:	00 00 00 
  803d21:	ff d0                	callq  *%rax
  803d23:	48 89 c2             	mov    %rax,%rdx
  803d26:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d2a:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803d30:	48 89 d1             	mov    %rdx,%rcx
  803d33:	ba 00 00 00 00       	mov    $0x0,%edx
  803d38:	48 89 c6             	mov    %rax,%rsi
  803d3b:	bf 00 00 00 00       	mov    $0x0,%edi
  803d40:	48 b8 cd 1e 80 00 00 	movabs $0x801ecd,%rax
  803d47:	00 00 00 
  803d4a:	ff d0                	callq  *%rax
  803d4c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d4f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d53:	79 1b                	jns    803d70 <pipe+0x143>
		goto err3;
  803d55:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803d56:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d5a:	48 89 c6             	mov    %rax,%rsi
  803d5d:	bf 00 00 00 00       	mov    $0x0,%edi
  803d62:	48 b8 28 1f 80 00 00 	movabs $0x801f28,%rax
  803d69:	00 00 00 
  803d6c:	ff d0                	callq  *%rax
  803d6e:	eb 79                	jmp    803de9 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803d70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d74:	48 ba 20 78 80 00 00 	movabs $0x807820,%rdx
  803d7b:	00 00 00 
  803d7e:	8b 12                	mov    (%rdx),%edx
  803d80:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803d82:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d86:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803d8d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d91:	48 ba 20 78 80 00 00 	movabs $0x807820,%rdx
  803d98:	00 00 00 
  803d9b:	8b 12                	mov    (%rdx),%edx
  803d9d:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803d9f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803da3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803daa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dae:	48 89 c7             	mov    %rax,%rdi
  803db1:	48 b8 ea 20 80 00 00 	movabs $0x8020ea,%rax
  803db8:	00 00 00 
  803dbb:	ff d0                	callq  *%rax
  803dbd:	89 c2                	mov    %eax,%edx
  803dbf:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803dc3:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803dc5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803dc9:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803dcd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803dd1:	48 89 c7             	mov    %rax,%rdi
  803dd4:	48 b8 ea 20 80 00 00 	movabs $0x8020ea,%rax
  803ddb:	00 00 00 
  803dde:	ff d0                	callq  *%rax
  803de0:	89 03                	mov    %eax,(%rbx)
	return 0;
  803de2:	b8 00 00 00 00       	mov    $0x0,%eax
  803de7:	eb 33                	jmp    803e1c <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803de9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ded:	48 89 c6             	mov    %rax,%rsi
  803df0:	bf 00 00 00 00       	mov    $0x0,%edi
  803df5:	48 b8 28 1f 80 00 00 	movabs $0x801f28,%rax
  803dfc:	00 00 00 
  803dff:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803e01:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e05:	48 89 c6             	mov    %rax,%rsi
  803e08:	bf 00 00 00 00       	mov    $0x0,%edi
  803e0d:	48 b8 28 1f 80 00 00 	movabs $0x801f28,%rax
  803e14:	00 00 00 
  803e17:	ff d0                	callq  *%rax
err:
	return r;
  803e19:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803e1c:	48 83 c4 38          	add    $0x38,%rsp
  803e20:	5b                   	pop    %rbx
  803e21:	5d                   	pop    %rbp
  803e22:	c3                   	retq   

0000000000803e23 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803e23:	55                   	push   %rbp
  803e24:	48 89 e5             	mov    %rsp,%rbp
  803e27:	53                   	push   %rbx
  803e28:	48 83 ec 28          	sub    $0x28,%rsp
  803e2c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803e30:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803e34:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  803e3b:	00 00 00 
  803e3e:	48 8b 00             	mov    (%rax),%rax
  803e41:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803e47:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803e4a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e4e:	48 89 c7             	mov    %rax,%rdi
  803e51:	48 b8 78 44 80 00 00 	movabs $0x804478,%rax
  803e58:	00 00 00 
  803e5b:	ff d0                	callq  *%rax
  803e5d:	89 c3                	mov    %eax,%ebx
  803e5f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e63:	48 89 c7             	mov    %rax,%rdi
  803e66:	48 b8 78 44 80 00 00 	movabs $0x804478,%rax
  803e6d:	00 00 00 
  803e70:	ff d0                	callq  *%rax
  803e72:	39 c3                	cmp    %eax,%ebx
  803e74:	0f 94 c0             	sete   %al
  803e77:	0f b6 c0             	movzbl %al,%eax
  803e7a:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803e7d:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  803e84:	00 00 00 
  803e87:	48 8b 00             	mov    (%rax),%rax
  803e8a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803e90:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803e93:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e96:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803e99:	75 05                	jne    803ea0 <_pipeisclosed+0x7d>
			return ret;
  803e9b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803e9e:	eb 4f                	jmp    803eef <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803ea0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ea3:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803ea6:	74 42                	je     803eea <_pipeisclosed+0xc7>
  803ea8:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803eac:	75 3c                	jne    803eea <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803eae:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  803eb5:	00 00 00 
  803eb8:	48 8b 00             	mov    (%rax),%rax
  803ebb:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803ec1:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803ec4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ec7:	89 c6                	mov    %eax,%esi
  803ec9:	48 bf 5d 4d 80 00 00 	movabs $0x804d5d,%rdi
  803ed0:	00 00 00 
  803ed3:	b8 00 00 00 00       	mov    $0x0,%eax
  803ed8:	49 b8 99 09 80 00 00 	movabs $0x800999,%r8
  803edf:	00 00 00 
  803ee2:	41 ff d0             	callq  *%r8
	}
  803ee5:	e9 4a ff ff ff       	jmpq   803e34 <_pipeisclosed+0x11>
  803eea:	e9 45 ff ff ff       	jmpq   803e34 <_pipeisclosed+0x11>
}
  803eef:	48 83 c4 28          	add    $0x28,%rsp
  803ef3:	5b                   	pop    %rbx
  803ef4:	5d                   	pop    %rbp
  803ef5:	c3                   	retq   

0000000000803ef6 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803ef6:	55                   	push   %rbp
  803ef7:	48 89 e5             	mov    %rsp,%rbp
  803efa:	48 83 ec 30          	sub    $0x30,%rsp
  803efe:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803f01:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803f05:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803f08:	48 89 d6             	mov    %rdx,%rsi
  803f0b:	89 c7                	mov    %eax,%edi
  803f0d:	48 b8 d0 21 80 00 00 	movabs $0x8021d0,%rax
  803f14:	00 00 00 
  803f17:	ff d0                	callq  *%rax
  803f19:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f20:	79 05                	jns    803f27 <pipeisclosed+0x31>
		return r;
  803f22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f25:	eb 31                	jmp    803f58 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803f27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f2b:	48 89 c7             	mov    %rax,%rdi
  803f2e:	48 b8 0d 21 80 00 00 	movabs $0x80210d,%rax
  803f35:	00 00 00 
  803f38:	ff d0                	callq  *%rax
  803f3a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803f3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f42:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f46:	48 89 d6             	mov    %rdx,%rsi
  803f49:	48 89 c7             	mov    %rax,%rdi
  803f4c:	48 b8 23 3e 80 00 00 	movabs $0x803e23,%rax
  803f53:	00 00 00 
  803f56:	ff d0                	callq  *%rax
}
  803f58:	c9                   	leaveq 
  803f59:	c3                   	retq   

0000000000803f5a <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803f5a:	55                   	push   %rbp
  803f5b:	48 89 e5             	mov    %rsp,%rbp
  803f5e:	48 83 ec 40          	sub    $0x40,%rsp
  803f62:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803f66:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803f6a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803f6e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f72:	48 89 c7             	mov    %rax,%rdi
  803f75:	48 b8 0d 21 80 00 00 	movabs $0x80210d,%rax
  803f7c:	00 00 00 
  803f7f:	ff d0                	callq  *%rax
  803f81:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803f85:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f89:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803f8d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803f94:	00 
  803f95:	e9 92 00 00 00       	jmpq   80402c <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803f9a:	eb 41                	jmp    803fdd <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803f9c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803fa1:	74 09                	je     803fac <devpipe_read+0x52>
				return i;
  803fa3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fa7:	e9 92 00 00 00       	jmpq   80403e <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803fac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803fb0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fb4:	48 89 d6             	mov    %rdx,%rsi
  803fb7:	48 89 c7             	mov    %rax,%rdi
  803fba:	48 b8 23 3e 80 00 00 	movabs $0x803e23,%rax
  803fc1:	00 00 00 
  803fc4:	ff d0                	callq  *%rax
  803fc6:	85 c0                	test   %eax,%eax
  803fc8:	74 07                	je     803fd1 <devpipe_read+0x77>
				return 0;
  803fca:	b8 00 00 00 00       	mov    $0x0,%eax
  803fcf:	eb 6d                	jmp    80403e <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803fd1:	48 b8 3f 1e 80 00 00 	movabs $0x801e3f,%rax
  803fd8:	00 00 00 
  803fdb:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803fdd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fe1:	8b 10                	mov    (%rax),%edx
  803fe3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fe7:	8b 40 04             	mov    0x4(%rax),%eax
  803fea:	39 c2                	cmp    %eax,%edx
  803fec:	74 ae                	je     803f9c <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803fee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ff2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803ff6:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803ffa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ffe:	8b 00                	mov    (%rax),%eax
  804000:	99                   	cltd   
  804001:	c1 ea 1b             	shr    $0x1b,%edx
  804004:	01 d0                	add    %edx,%eax
  804006:	83 e0 1f             	and    $0x1f,%eax
  804009:	29 d0                	sub    %edx,%eax
  80400b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80400f:	48 98                	cltq   
  804011:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804016:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804018:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80401c:	8b 00                	mov    (%rax),%eax
  80401e:	8d 50 01             	lea    0x1(%rax),%edx
  804021:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804025:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804027:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80402c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804030:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804034:	0f 82 60 ff ff ff    	jb     803f9a <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80403a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80403e:	c9                   	leaveq 
  80403f:	c3                   	retq   

0000000000804040 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804040:	55                   	push   %rbp
  804041:	48 89 e5             	mov    %rsp,%rbp
  804044:	48 83 ec 40          	sub    $0x40,%rsp
  804048:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80404c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804050:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804054:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804058:	48 89 c7             	mov    %rax,%rdi
  80405b:	48 b8 0d 21 80 00 00 	movabs $0x80210d,%rax
  804062:	00 00 00 
  804065:	ff d0                	callq  *%rax
  804067:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80406b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80406f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804073:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80407a:	00 
  80407b:	e9 8e 00 00 00       	jmpq   80410e <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804080:	eb 31                	jmp    8040b3 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804082:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804086:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80408a:	48 89 d6             	mov    %rdx,%rsi
  80408d:	48 89 c7             	mov    %rax,%rdi
  804090:	48 b8 23 3e 80 00 00 	movabs $0x803e23,%rax
  804097:	00 00 00 
  80409a:	ff d0                	callq  *%rax
  80409c:	85 c0                	test   %eax,%eax
  80409e:	74 07                	je     8040a7 <devpipe_write+0x67>
				return 0;
  8040a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8040a5:	eb 79                	jmp    804120 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8040a7:	48 b8 3f 1e 80 00 00 	movabs $0x801e3f,%rax
  8040ae:	00 00 00 
  8040b1:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8040b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040b7:	8b 40 04             	mov    0x4(%rax),%eax
  8040ba:	48 63 d0             	movslq %eax,%rdx
  8040bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040c1:	8b 00                	mov    (%rax),%eax
  8040c3:	48 98                	cltq   
  8040c5:	48 83 c0 20          	add    $0x20,%rax
  8040c9:	48 39 c2             	cmp    %rax,%rdx
  8040cc:	73 b4                	jae    804082 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8040ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040d2:	8b 40 04             	mov    0x4(%rax),%eax
  8040d5:	99                   	cltd   
  8040d6:	c1 ea 1b             	shr    $0x1b,%edx
  8040d9:	01 d0                	add    %edx,%eax
  8040db:	83 e0 1f             	and    $0x1f,%eax
  8040de:	29 d0                	sub    %edx,%eax
  8040e0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8040e4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8040e8:	48 01 ca             	add    %rcx,%rdx
  8040eb:	0f b6 0a             	movzbl (%rdx),%ecx
  8040ee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040f2:	48 98                	cltq   
  8040f4:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8040f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040fc:	8b 40 04             	mov    0x4(%rax),%eax
  8040ff:	8d 50 01             	lea    0x1(%rax),%edx
  804102:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804106:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804109:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80410e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804112:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804116:	0f 82 64 ff ff ff    	jb     804080 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80411c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804120:	c9                   	leaveq 
  804121:	c3                   	retq   

0000000000804122 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804122:	55                   	push   %rbp
  804123:	48 89 e5             	mov    %rsp,%rbp
  804126:	48 83 ec 20          	sub    $0x20,%rsp
  80412a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80412e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804132:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804136:	48 89 c7             	mov    %rax,%rdi
  804139:	48 b8 0d 21 80 00 00 	movabs $0x80210d,%rax
  804140:	00 00 00 
  804143:	ff d0                	callq  *%rax
  804145:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804149:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80414d:	48 be 70 4d 80 00 00 	movabs $0x804d70,%rsi
  804154:	00 00 00 
  804157:	48 89 c7             	mov    %rax,%rdi
  80415a:	48 b8 4e 15 80 00 00 	movabs $0x80154e,%rax
  804161:	00 00 00 
  804164:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804166:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80416a:	8b 50 04             	mov    0x4(%rax),%edx
  80416d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804171:	8b 00                	mov    (%rax),%eax
  804173:	29 c2                	sub    %eax,%edx
  804175:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804179:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80417f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804183:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80418a:	00 00 00 
	stat->st_dev = &devpipe;
  80418d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804191:	48 b9 20 78 80 00 00 	movabs $0x807820,%rcx
  804198:	00 00 00 
  80419b:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8041a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8041a7:	c9                   	leaveq 
  8041a8:	c3                   	retq   

00000000008041a9 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8041a9:	55                   	push   %rbp
  8041aa:	48 89 e5             	mov    %rsp,%rbp
  8041ad:	48 83 ec 10          	sub    $0x10,%rsp
  8041b1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8041b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041b9:	48 89 c6             	mov    %rax,%rsi
  8041bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8041c1:	48 b8 28 1f 80 00 00 	movabs $0x801f28,%rax
  8041c8:	00 00 00 
  8041cb:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8041cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041d1:	48 89 c7             	mov    %rax,%rdi
  8041d4:	48 b8 0d 21 80 00 00 	movabs $0x80210d,%rax
  8041db:	00 00 00 
  8041de:	ff d0                	callq  *%rax
  8041e0:	48 89 c6             	mov    %rax,%rsi
  8041e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8041e8:	48 b8 28 1f 80 00 00 	movabs $0x801f28,%rax
  8041ef:	00 00 00 
  8041f2:	ff d0                	callq  *%rax
}
  8041f4:	c9                   	leaveq 
  8041f5:	c3                   	retq   

00000000008041f6 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8041f6:	55                   	push   %rbp
  8041f7:	48 89 e5             	mov    %rsp,%rbp
  8041fa:	48 83 ec 20          	sub    $0x20,%rsp
  8041fe:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  804201:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804205:	75 35                	jne    80423c <wait+0x46>
  804207:	48 b9 77 4d 80 00 00 	movabs $0x804d77,%rcx
  80420e:	00 00 00 
  804211:	48 ba 82 4d 80 00 00 	movabs $0x804d82,%rdx
  804218:	00 00 00 
  80421b:	be 09 00 00 00       	mov    $0x9,%esi
  804220:	48 bf 97 4d 80 00 00 	movabs $0x804d97,%rdi
  804227:	00 00 00 
  80422a:	b8 00 00 00 00       	mov    $0x0,%eax
  80422f:	49 b8 60 07 80 00 00 	movabs $0x800760,%r8
  804236:	00 00 00 
  804239:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  80423c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80423f:	25 ff 03 00 00       	and    $0x3ff,%eax
  804244:	48 63 d0             	movslq %eax,%rdx
  804247:	48 89 d0             	mov    %rdx,%rax
  80424a:	48 c1 e0 03          	shl    $0x3,%rax
  80424e:	48 01 d0             	add    %rdx,%rax
  804251:	48 c1 e0 05          	shl    $0x5,%rax
  804255:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80425c:	00 00 00 
  80425f:	48 01 d0             	add    %rdx,%rax
  804262:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804266:	eb 0c                	jmp    804274 <wait+0x7e>
		sys_yield();
  804268:	48 b8 3f 1e 80 00 00 	movabs $0x801e3f,%rax
  80426f:	00 00 00 
  804272:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804274:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804278:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80427e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804281:	75 0e                	jne    804291 <wait+0x9b>
  804283:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804287:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80428d:	85 c0                	test   %eax,%eax
  80428f:	75 d7                	jne    804268 <wait+0x72>
		sys_yield();
}
  804291:	c9                   	leaveq 
  804292:	c3                   	retq   

0000000000804293 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804293:	55                   	push   %rbp
  804294:	48 89 e5             	mov    %rsp,%rbp
  804297:	48 83 ec 30          	sub    $0x30,%rsp
  80429b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80429f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8042a3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  8042a7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8042ac:	74 18                	je     8042c6 <ipc_recv+0x33>
  8042ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042b2:	48 89 c7             	mov    %rax,%rdi
  8042b5:	48 b8 a6 20 80 00 00 	movabs $0x8020a6,%rax
  8042bc:	00 00 00 
  8042bf:	ff d0                	callq  *%rax
  8042c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042c4:	eb 19                	jmp    8042df <ipc_recv+0x4c>
  8042c6:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  8042cd:	00 00 00 
  8042d0:	48 b8 a6 20 80 00 00 	movabs $0x8020a6,%rax
  8042d7:	00 00 00 
  8042da:	ff d0                	callq  *%rax
  8042dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  8042df:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8042e4:	74 26                	je     80430c <ipc_recv+0x79>
  8042e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042ea:	75 15                	jne    804301 <ipc_recv+0x6e>
  8042ec:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  8042f3:	00 00 00 
  8042f6:	48 8b 00             	mov    (%rax),%rax
  8042f9:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  8042ff:	eb 05                	jmp    804306 <ipc_recv+0x73>
  804301:	b8 00 00 00 00       	mov    $0x0,%eax
  804306:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80430a:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  80430c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804311:	74 26                	je     804339 <ipc_recv+0xa6>
  804313:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804317:	75 15                	jne    80432e <ipc_recv+0x9b>
  804319:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  804320:	00 00 00 
  804323:	48 8b 00             	mov    (%rax),%rax
  804326:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  80432c:	eb 05                	jmp    804333 <ipc_recv+0xa0>
  80432e:	b8 00 00 00 00       	mov    $0x0,%eax
  804333:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804337:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  804339:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80433d:	75 15                	jne    804354 <ipc_recv+0xc1>
  80433f:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  804346:	00 00 00 
  804349:	48 8b 00             	mov    (%rax),%rax
  80434c:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  804352:	eb 03                	jmp    804357 <ipc_recv+0xc4>
  804354:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804357:	c9                   	leaveq 
  804358:	c3                   	retq   

0000000000804359 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804359:	55                   	push   %rbp
  80435a:	48 89 e5             	mov    %rsp,%rbp
  80435d:	48 83 ec 30          	sub    $0x30,%rsp
  804361:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804364:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804367:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80436b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  80436e:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  804375:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80437a:	75 10                	jne    80438c <ipc_send+0x33>
  80437c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804383:	00 00 00 
  804386:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  80438a:	eb 62                	jmp    8043ee <ipc_send+0x95>
  80438c:	eb 60                	jmp    8043ee <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  80438e:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804392:	74 30                	je     8043c4 <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  804394:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804397:	89 c1                	mov    %eax,%ecx
  804399:	48 ba a2 4d 80 00 00 	movabs $0x804da2,%rdx
  8043a0:	00 00 00 
  8043a3:	be 33 00 00 00       	mov    $0x33,%esi
  8043a8:	48 bf be 4d 80 00 00 	movabs $0x804dbe,%rdi
  8043af:	00 00 00 
  8043b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8043b7:	49 b8 60 07 80 00 00 	movabs $0x800760,%r8
  8043be:	00 00 00 
  8043c1:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  8043c4:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8043c7:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8043ca:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8043ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8043d1:	89 c7                	mov    %eax,%edi
  8043d3:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  8043da:	00 00 00 
  8043dd:	ff d0                	callq  *%rax
  8043df:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  8043e2:	48 b8 3f 1e 80 00 00 	movabs $0x801e3f,%rax
  8043e9:	00 00 00 
  8043ec:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  8043ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043f2:	75 9a                	jne    80438e <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  8043f4:	c9                   	leaveq 
  8043f5:	c3                   	retq   

00000000008043f6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8043f6:	55                   	push   %rbp
  8043f7:	48 89 e5             	mov    %rsp,%rbp
  8043fa:	48 83 ec 14          	sub    $0x14,%rsp
  8043fe:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804401:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804408:	eb 5e                	jmp    804468 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80440a:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804411:	00 00 00 
  804414:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804417:	48 63 d0             	movslq %eax,%rdx
  80441a:	48 89 d0             	mov    %rdx,%rax
  80441d:	48 c1 e0 03          	shl    $0x3,%rax
  804421:	48 01 d0             	add    %rdx,%rax
  804424:	48 c1 e0 05          	shl    $0x5,%rax
  804428:	48 01 c8             	add    %rcx,%rax
  80442b:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804431:	8b 00                	mov    (%rax),%eax
  804433:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804436:	75 2c                	jne    804464 <ipc_find_env+0x6e>
			return envs[i].env_id;
  804438:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80443f:	00 00 00 
  804442:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804445:	48 63 d0             	movslq %eax,%rdx
  804448:	48 89 d0             	mov    %rdx,%rax
  80444b:	48 c1 e0 03          	shl    $0x3,%rax
  80444f:	48 01 d0             	add    %rdx,%rax
  804452:	48 c1 e0 05          	shl    $0x5,%rax
  804456:	48 01 c8             	add    %rcx,%rax
  804459:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80445f:	8b 40 08             	mov    0x8(%rax),%eax
  804462:	eb 12                	jmp    804476 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804464:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804468:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80446f:	7e 99                	jle    80440a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804471:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804476:	c9                   	leaveq 
  804477:	c3                   	retq   

0000000000804478 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804478:	55                   	push   %rbp
  804479:	48 89 e5             	mov    %rsp,%rbp
  80447c:	48 83 ec 18          	sub    $0x18,%rsp
  804480:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804484:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804488:	48 c1 e8 15          	shr    $0x15,%rax
  80448c:	48 89 c2             	mov    %rax,%rdx
  80448f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804496:	01 00 00 
  804499:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80449d:	83 e0 01             	and    $0x1,%eax
  8044a0:	48 85 c0             	test   %rax,%rax
  8044a3:	75 07                	jne    8044ac <pageref+0x34>
		return 0;
  8044a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8044aa:	eb 53                	jmp    8044ff <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8044ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044b0:	48 c1 e8 0c          	shr    $0xc,%rax
  8044b4:	48 89 c2             	mov    %rax,%rdx
  8044b7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8044be:	01 00 00 
  8044c1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8044c5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8044c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044cd:	83 e0 01             	and    $0x1,%eax
  8044d0:	48 85 c0             	test   %rax,%rax
  8044d3:	75 07                	jne    8044dc <pageref+0x64>
		return 0;
  8044d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8044da:	eb 23                	jmp    8044ff <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8044dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044e0:	48 c1 e8 0c          	shr    $0xc,%rax
  8044e4:	48 89 c2             	mov    %rax,%rdx
  8044e7:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8044ee:	00 00 00 
  8044f1:	48 c1 e2 04          	shl    $0x4,%rdx
  8044f5:	48 01 d0             	add    %rdx,%rax
  8044f8:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8044fc:	0f b7 c0             	movzwl %ax,%eax
}
  8044ff:	c9                   	leaveq 
  804500:	c3                   	retq   
