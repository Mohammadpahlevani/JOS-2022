
obj/user/testshell:     file format elf64-x86-64


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
  80003c:	e8 f5 07 00 00       	callq  800836 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

void wrong(int, int, int);

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 40          	sub    $0x40,%rsp
  80004b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80004e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	char c1, c2;
	int r, rfd, wfd, kfd, n1, n2, off, nloff;
	int pfds[2];

	close(0);
  800052:	bf 00 00 00 00       	mov    $0x0,%edi
  800057:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  80005e:	00 00 00 
  800061:	ff d0                	callq  *%rax
	close(1);
  800063:	bf 01 00 00 00       	mov    $0x1,%edi
  800068:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  80006f:	00 00 00 
  800072:	ff d0                	callq  *%rax
	opencons();
  800074:	48 b8 44 06 80 00 00 	movabs $0x800644,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
	opencons();
  800080:	48 b8 44 06 80 00 00 	movabs $0x800644,%rax
  800087:	00 00 00 
  80008a:	ff d0                	callq  *%rax

	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  80008c:	be 00 00 00 00       	mov    $0x0,%esi
  800091:	48 bf 00 4d 80 00 00 	movabs $0x804d00,%rdi
  800098:	00 00 00 
  80009b:	48 b8 ac 31 80 00 00 	movabs $0x8031ac,%rax
  8000a2:	00 00 00 
  8000a5:	ff d0                	callq  *%rax
  8000a7:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8000ae:	79 30                	jns    8000e0 <umain+0x9d>
		panic("open testshell.sh: %e", rfd);
  8000b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000b3:	89 c1                	mov    %eax,%ecx
  8000b5:	48 ba 0d 4d 80 00 00 	movabs $0x804d0d,%rdx
  8000bc:	00 00 00 
  8000bf:	be 13 00 00 00       	mov    $0x13,%esi
  8000c4:	48 bf 23 4d 80 00 00 	movabs $0x804d23,%rdi
  8000cb:	00 00 00 
  8000ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d3:	49 b8 e9 08 80 00 00 	movabs $0x8008e9,%r8
  8000da:	00 00 00 
  8000dd:	41 ff d0             	callq  *%r8
	if ((wfd = pipe(pfds)) < 0)
  8000e0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8000e4:	48 89 c7             	mov    %rax,%rdi
  8000e7:	48 b8 01 43 80 00 00 	movabs $0x804301,%rax
  8000ee:	00 00 00 
  8000f1:	ff d0                	callq  *%rax
  8000f3:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8000f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8000fa:	79 30                	jns    80012c <umain+0xe9>
		panic("pipe: %e", wfd);
  8000fc:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000ff:	89 c1                	mov    %eax,%ecx
  800101:	48 ba 34 4d 80 00 00 	movabs $0x804d34,%rdx
  800108:	00 00 00 
  80010b:	be 15 00 00 00       	mov    $0x15,%esi
  800110:	48 bf 23 4d 80 00 00 	movabs $0x804d23,%rdi
  800117:	00 00 00 
  80011a:	b8 00 00 00 00       	mov    $0x0,%eax
  80011f:	49 b8 e9 08 80 00 00 	movabs $0x8008e9,%r8
  800126:	00 00 00 
  800129:	41 ff d0             	callq  *%r8
	wfd = pfds[1];
  80012c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80012f:	89 45 f0             	mov    %eax,-0x10(%rbp)

	cprintf("running sh -x < testshell.sh | cat\n");
  800132:	48 bf 40 4d 80 00 00 	movabs $0x804d40,%rdi
  800139:	00 00 00 
  80013c:	b8 00 00 00 00       	mov    $0x0,%eax
  800141:	48 ba 22 0b 80 00 00 	movabs $0x800b22,%rdx
  800148:	00 00 00 
  80014b:	ff d2                	callq  *%rdx
	if ((r = fork()) < 0)
  80014d:	48 b8 c6 24 80 00 00 	movabs $0x8024c6,%rax
  800154:	00 00 00 
  800157:	ff d0                	callq  *%rax
  800159:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80015c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800160:	79 30                	jns    800192 <umain+0x14f>
		panic("fork: %e", r);
  800162:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800165:	89 c1                	mov    %eax,%ecx
  800167:	48 ba 64 4d 80 00 00 	movabs $0x804d64,%rdx
  80016e:	00 00 00 
  800171:	be 1a 00 00 00       	mov    $0x1a,%esi
  800176:	48 bf 23 4d 80 00 00 	movabs $0x804d23,%rdi
  80017d:	00 00 00 
  800180:	b8 00 00 00 00       	mov    $0x0,%eax
  800185:	49 b8 e9 08 80 00 00 	movabs $0x8008e9,%r8
  80018c:	00 00 00 
  80018f:	41 ff d0             	callq  *%r8
	if (r == 0) {
  800192:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800196:	0f 85 fb 00 00 00    	jne    800297 <umain+0x254>
		dup(rfd, 0);
  80019c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80019f:	be 00 00 00 00       	mov    $0x0,%esi
  8001a4:	89 c7                	mov    %eax,%edi
  8001a6:	48 b8 2d 2b 80 00 00 	movabs $0x802b2d,%rax
  8001ad:	00 00 00 
  8001b0:	ff d0                	callq  *%rax
		dup(wfd, 1);
  8001b2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001b5:	be 01 00 00 00       	mov    $0x1,%esi
  8001ba:	89 c7                	mov    %eax,%edi
  8001bc:	48 b8 2d 2b 80 00 00 	movabs $0x802b2d,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
		close(rfd);
  8001c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  8001d4:	00 00 00 
  8001d7:	ff d0                	callq  *%rax
		close(wfd);
  8001d9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001dc:	89 c7                	mov    %eax,%edi
  8001de:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  8001e5:	00 00 00 
  8001e8:	ff d0                	callq  *%rax
		if ((r = spawnl("/bin/sh", "sh", "-x", 0)) < 0)
  8001ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001ef:	48 ba 6d 4d 80 00 00 	movabs $0x804d6d,%rdx
  8001f6:	00 00 00 
  8001f9:	48 be 70 4d 80 00 00 	movabs $0x804d70,%rsi
  800200:	00 00 00 
  800203:	48 bf 73 4d 80 00 00 	movabs $0x804d73,%rdi
  80020a:	00 00 00 
  80020d:	b8 00 00 00 00       	mov    $0x0,%eax
  800212:	49 b8 6a 3a 80 00 00 	movabs $0x803a6a,%r8
  800219:	00 00 00 
  80021c:	41 ff d0             	callq  *%r8
  80021f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800222:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800226:	79 30                	jns    800258 <umain+0x215>
			panic("spawn: %e", r);
  800228:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80022b:	89 c1                	mov    %eax,%ecx
  80022d:	48 ba 7b 4d 80 00 00 	movabs $0x804d7b,%rdx
  800234:	00 00 00 
  800237:	be 21 00 00 00       	mov    $0x21,%esi
  80023c:	48 bf 23 4d 80 00 00 	movabs $0x804d23,%rdi
  800243:	00 00 00 
  800246:	b8 00 00 00 00       	mov    $0x0,%eax
  80024b:	49 b8 e9 08 80 00 00 	movabs $0x8008e9,%r8
  800252:	00 00 00 
  800255:	41 ff d0             	callq  *%r8
		close(0);
  800258:	bf 00 00 00 00       	mov    $0x0,%edi
  80025d:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  800264:	00 00 00 
  800267:	ff d0                	callq  *%rax
		close(1);
  800269:	bf 01 00 00 00       	mov    $0x1,%edi
  80026e:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  800275:	00 00 00 
  800278:	ff d0                	callq  *%rax
		wait(r);
  80027a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80027d:	89 c7                	mov    %eax,%edi
  80027f:	48 b8 ca 48 80 00 00 	movabs $0x8048ca,%rax
  800286:	00 00 00 
  800289:	ff d0                	callq  *%rax
		exit();
  80028b:	48 b8 c6 08 80 00 00 	movabs $0x8008c6,%rax
  800292:	00 00 00 
  800295:	ff d0                	callq  *%rax
	}
	close(rfd);
  800297:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80029a:	89 c7                	mov    %eax,%edi
  80029c:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  8002a3:	00 00 00 
  8002a6:	ff d0                	callq  *%rax
	close(wfd);
  8002a8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002ab:	89 c7                	mov    %eax,%edi
  8002ad:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  8002b4:	00 00 00 
  8002b7:	ff d0                	callq  *%rax

	rfd = pfds[0];
  8002b9:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8002bc:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8002bf:	be 00 00 00 00       	mov    $0x0,%esi
  8002c4:	48 bf 85 4d 80 00 00 	movabs $0x804d85,%rdi
  8002cb:	00 00 00 
  8002ce:	48 b8 ac 31 80 00 00 	movabs $0x8031ac,%rax
  8002d5:	00 00 00 
  8002d8:	ff d0                	callq  *%rax
  8002da:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8002dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8002e1:	79 30                	jns    800313 <umain+0x2d0>
		panic("open testshell.key for reading: %e", kfd);
  8002e3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002e6:	89 c1                	mov    %eax,%ecx
  8002e8:	48 ba 98 4d 80 00 00 	movabs $0x804d98,%rdx
  8002ef:	00 00 00 
  8002f2:	be 2c 00 00 00       	mov    $0x2c,%esi
  8002f7:	48 bf 23 4d 80 00 00 	movabs $0x804d23,%rdi
  8002fe:	00 00 00 
  800301:	b8 00 00 00 00       	mov    $0x0,%eax
  800306:	49 b8 e9 08 80 00 00 	movabs $0x8008e9,%r8
  80030d:	00 00 00 
  800310:	41 ff d0             	callq  *%r8

	nloff = 0;
  800313:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	for (off=0;; off++) {
  80031a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
		n1 = read(rfd, &c1, 1);
  800321:	48 8d 4d df          	lea    -0x21(%rbp),%rcx
  800325:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800328:	ba 01 00 00 00       	mov    $0x1,%edx
  80032d:	48 89 ce             	mov    %rcx,%rsi
  800330:	89 c7                	mov    %eax,%edi
  800332:	48 b8 d6 2c 80 00 00 	movabs $0x802cd6,%rax
  800339:	00 00 00 
  80033c:	ff d0                	callq  *%rax
  80033e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		n2 = read(kfd, &c2, 1);
  800341:	48 8d 4d de          	lea    -0x22(%rbp),%rcx
  800345:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800348:	ba 01 00 00 00       	mov    $0x1,%edx
  80034d:	48 89 ce             	mov    %rcx,%rsi
  800350:	89 c7                	mov    %eax,%edi
  800352:	48 b8 d6 2c 80 00 00 	movabs $0x802cd6,%rax
  800359:	00 00 00 
  80035c:	ff d0                	callq  *%rax
  80035e:	89 45 e0             	mov    %eax,-0x20(%rbp)
		if (n1 < 0)
  800361:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800365:	79 30                	jns    800397 <umain+0x354>
			panic("reading testshell.out: %e", n1);
  800367:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80036a:	89 c1                	mov    %eax,%ecx
  80036c:	48 ba bb 4d 80 00 00 	movabs $0x804dbb,%rdx
  800373:	00 00 00 
  800376:	be 33 00 00 00       	mov    $0x33,%esi
  80037b:	48 bf 23 4d 80 00 00 	movabs $0x804d23,%rdi
  800382:	00 00 00 
  800385:	b8 00 00 00 00       	mov    $0x0,%eax
  80038a:	49 b8 e9 08 80 00 00 	movabs $0x8008e9,%r8
  800391:	00 00 00 
  800394:	41 ff d0             	callq  *%r8
		if (n2 < 0)
  800397:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80039b:	79 30                	jns    8003cd <umain+0x38a>
			panic("reading testshell.key: %e", n2);
  80039d:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8003a0:	89 c1                	mov    %eax,%ecx
  8003a2:	48 ba d5 4d 80 00 00 	movabs $0x804dd5,%rdx
  8003a9:	00 00 00 
  8003ac:	be 35 00 00 00       	mov    $0x35,%esi
  8003b1:	48 bf 23 4d 80 00 00 	movabs $0x804d23,%rdi
  8003b8:	00 00 00 
  8003bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c0:	49 b8 e9 08 80 00 00 	movabs $0x8008e9,%r8
  8003c7:	00 00 00 
  8003ca:	41 ff d0             	callq  *%r8
		if (n1 == 0 && n2 == 0)
  8003cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8003d1:	75 08                	jne    8003db <umain+0x398>
  8003d3:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8003d7:	75 02                	jne    8003db <umain+0x398>
			break;
  8003d9:	eb 4b                	jmp    800426 <umain+0x3e3>
		if (n1 != 1 || n2 != 1 || c1 != c2)
  8003db:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8003df:	75 12                	jne    8003f3 <umain+0x3b0>
  8003e1:	83 7d e0 01          	cmpl   $0x1,-0x20(%rbp)
  8003e5:	75 0c                	jne    8003f3 <umain+0x3b0>
  8003e7:	0f b6 55 df          	movzbl -0x21(%rbp),%edx
  8003eb:	0f b6 45 de          	movzbl -0x22(%rbp),%eax
  8003ef:	38 c2                	cmp    %al,%dl
  8003f1:	74 19                	je     80040c <umain+0x3c9>
			wrong(rfd, kfd, nloff);
  8003f3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8003f6:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8003f9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8003fc:	89 ce                	mov    %ecx,%esi
  8003fe:	89 c7                	mov    %eax,%edi
  800400:	48 b8 44 04 80 00 00 	movabs $0x800444,%rax
  800407:	00 00 00 
  80040a:	ff d0                	callq  *%rax
		if (c1 == '\n')
  80040c:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  800410:	3c 0a                	cmp    $0xa,%al
  800412:	75 09                	jne    80041d <umain+0x3da>
			nloff = off+1;
  800414:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800417:	83 c0 01             	add    $0x1,%eax
  80041a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	rfd = pfds[0];
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
		panic("open testshell.key for reading: %e", kfd);

	nloff = 0;
	for (off=0;; off++) {
  80041d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
			break;
		if (n1 != 1 || n2 != 1 || c1 != c2)
			wrong(rfd, kfd, nloff);
		if (c1 == '\n')
			nloff = off+1;
	}
  800421:	e9 fb fe ff ff       	jmpq   800321 <umain+0x2de>
	cprintf("shell ran correctly\n");
  800426:	48 bf ef 4d 80 00 00 	movabs $0x804def,%rdi
  80042d:	00 00 00 
  800430:	b8 00 00 00 00       	mov    $0x0,%eax
  800435:	48 ba 22 0b 80 00 00 	movabs $0x800b22,%rdx
  80043c:	00 00 00 
  80043f:	ff d2                	callq  *%rdx
static __inline void read_gdtr (uint64_t *gdtbase, uint16_t *gdtlimit) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800441:	cc                   	int3   

	breakpoint();
}
  800442:	c9                   	leaveq 
  800443:	c3                   	retq   

0000000000800444 <wrong>:

void
wrong(int rfd, int kfd, int off)
{
  800444:	55                   	push   %rbp
  800445:	48 89 e5             	mov    %rsp,%rbp
  800448:	48 83 c4 80          	add    $0xffffffffffffff80,%rsp
  80044c:	89 7d 8c             	mov    %edi,-0x74(%rbp)
  80044f:	89 75 88             	mov    %esi,-0x78(%rbp)
  800452:	89 55 84             	mov    %edx,-0x7c(%rbp)
	char buf[100];
	int n;

	seek(rfd, off);
  800455:	8b 55 84             	mov    -0x7c(%rbp),%edx
  800458:	8b 45 8c             	mov    -0x74(%rbp),%eax
  80045b:	89 d6                	mov    %edx,%esi
  80045d:	89 c7                	mov    %eax,%edi
  80045f:	48 b8 f4 2e 80 00 00 	movabs $0x802ef4,%rax
  800466:	00 00 00 
  800469:	ff d0                	callq  *%rax
	seek(kfd, off);
  80046b:	8b 55 84             	mov    -0x7c(%rbp),%edx
  80046e:	8b 45 88             	mov    -0x78(%rbp),%eax
  800471:	89 d6                	mov    %edx,%esi
  800473:	89 c7                	mov    %eax,%edi
  800475:	48 b8 f4 2e 80 00 00 	movabs $0x802ef4,%rax
  80047c:	00 00 00 
  80047f:	ff d0                	callq  *%rax

	cprintf("shell produced incorrect output.\n");
  800481:	48 bf 08 4e 80 00 00 	movabs $0x804e08,%rdi
  800488:	00 00 00 
  80048b:	b8 00 00 00 00       	mov    $0x0,%eax
  800490:	48 ba 22 0b 80 00 00 	movabs $0x800b22,%rdx
  800497:	00 00 00 
  80049a:	ff d2                	callq  *%rdx
	cprintf("expected:\n===\n");
  80049c:	48 bf 2a 4e 80 00 00 	movabs $0x804e2a,%rdi
  8004a3:	00 00 00 
  8004a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ab:	48 ba 22 0b 80 00 00 	movabs $0x800b22,%rdx
  8004b2:	00 00 00 
  8004b5:	ff d2                	callq  *%rdx
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  8004b7:	eb 1c                	jmp    8004d5 <wrong+0x91>
		sys_cputs(buf, n);
  8004b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004bc:	48 63 d0             	movslq %eax,%rdx
  8004bf:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8004c3:	48 89 d6             	mov    %rdx,%rsi
  8004c6:	48 89 c7             	mov    %rax,%rdi
  8004c9:	48 b8 be 1e 80 00 00 	movabs $0x801ebe,%rax
  8004d0:	00 00 00 
  8004d3:	ff d0                	callq  *%rax
	seek(rfd, off);
	seek(kfd, off);

	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  8004d5:	48 8d 4d 90          	lea    -0x70(%rbp),%rcx
  8004d9:	8b 45 88             	mov    -0x78(%rbp),%eax
  8004dc:	ba 63 00 00 00       	mov    $0x63,%edx
  8004e1:	48 89 ce             	mov    %rcx,%rsi
  8004e4:	89 c7                	mov    %eax,%edi
  8004e6:	48 b8 d6 2c 80 00 00 	movabs $0x802cd6,%rax
  8004ed:	00 00 00 
  8004f0:	ff d0                	callq  *%rax
  8004f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004f9:	7f be                	jg     8004b9 <wrong+0x75>
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
  8004fb:	48 bf 39 4e 80 00 00 	movabs $0x804e39,%rdi
  800502:	00 00 00 
  800505:	b8 00 00 00 00       	mov    $0x0,%eax
  80050a:	48 ba 22 0b 80 00 00 	movabs $0x800b22,%rdx
  800511:	00 00 00 
  800514:	ff d2                	callq  *%rdx
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  800516:	eb 1c                	jmp    800534 <wrong+0xf0>
		sys_cputs(buf, n);
  800518:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80051b:	48 63 d0             	movslq %eax,%rdx
  80051e:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  800522:	48 89 d6             	mov    %rdx,%rsi
  800525:	48 89 c7             	mov    %rax,%rdi
  800528:	48 b8 be 1e 80 00 00 	movabs $0x801ebe,%rax
  80052f:	00 00 00 
  800532:	ff d0                	callq  *%rax
	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  800534:	48 8d 4d 90          	lea    -0x70(%rbp),%rcx
  800538:	8b 45 8c             	mov    -0x74(%rbp),%eax
  80053b:	ba 63 00 00 00       	mov    $0x63,%edx
  800540:	48 89 ce             	mov    %rcx,%rsi
  800543:	89 c7                	mov    %eax,%edi
  800545:	48 b8 d6 2c 80 00 00 	movabs $0x802cd6,%rax
  80054c:	00 00 00 
  80054f:	ff d0                	callq  *%rax
  800551:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800554:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800558:	7f be                	jg     800518 <wrong+0xd4>
		sys_cputs(buf, n);
	cprintf("===\n");
  80055a:	48 bf 47 4e 80 00 00 	movabs $0x804e47,%rdi
  800561:	00 00 00 
  800564:	b8 00 00 00 00       	mov    $0x0,%eax
  800569:	48 ba 22 0b 80 00 00 	movabs $0x800b22,%rdx
  800570:	00 00 00 
  800573:	ff d2                	callq  *%rdx
	exit();
  800575:	48 b8 c6 08 80 00 00 	movabs $0x8008c6,%rax
  80057c:	00 00 00 
  80057f:	ff d0                	callq  *%rax
}
  800581:	c9                   	leaveq 
  800582:	c3                   	retq   

0000000000800583 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800583:	55                   	push   %rbp
  800584:	48 89 e5             	mov    %rsp,%rbp
  800587:	48 83 ec 20          	sub    $0x20,%rsp
  80058b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80058e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800591:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800594:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  800598:	be 01 00 00 00       	mov    $0x1,%esi
  80059d:	48 89 c7             	mov    %rax,%rdi
  8005a0:	48 b8 be 1e 80 00 00 	movabs $0x801ebe,%rax
  8005a7:	00 00 00 
  8005aa:	ff d0                	callq  *%rax
}
  8005ac:	c9                   	leaveq 
  8005ad:	c3                   	retq   

00000000008005ae <getchar>:

int
getchar(void)
{
  8005ae:	55                   	push   %rbp
  8005af:	48 89 e5             	mov    %rsp,%rbp
  8005b2:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8005b6:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8005ba:	ba 01 00 00 00       	mov    $0x1,%edx
  8005bf:	48 89 c6             	mov    %rax,%rsi
  8005c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8005c7:	48 b8 d6 2c 80 00 00 	movabs $0x802cd6,%rax
  8005ce:	00 00 00 
  8005d1:	ff d0                	callq  *%rax
  8005d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8005d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8005da:	79 05                	jns    8005e1 <getchar+0x33>
		return r;
  8005dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005df:	eb 14                	jmp    8005f5 <getchar+0x47>
	if (r < 1)
  8005e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8005e5:	7f 07                	jg     8005ee <getchar+0x40>
		return -E_EOF;
  8005e7:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8005ec:	eb 07                	jmp    8005f5 <getchar+0x47>
	return c;
  8005ee:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8005f2:	0f b6 c0             	movzbl %al,%eax
}
  8005f5:	c9                   	leaveq 
  8005f6:	c3                   	retq   

00000000008005f7 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8005f7:	55                   	push   %rbp
  8005f8:	48 89 e5             	mov    %rsp,%rbp
  8005fb:	48 83 ec 20          	sub    $0x20,%rsp
  8005ff:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800602:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800606:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800609:	48 89 d6             	mov    %rdx,%rsi
  80060c:	89 c7                	mov    %eax,%edi
  80060e:	48 b8 a4 28 80 00 00 	movabs $0x8028a4,%rax
  800615:	00 00 00 
  800618:	ff d0                	callq  *%rax
  80061a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80061d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800621:	79 05                	jns    800628 <iscons+0x31>
		return r;
  800623:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800626:	eb 1a                	jmp    800642 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  800628:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80062c:	8b 10                	mov    (%rax),%edx
  80062e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800635:	00 00 00 
  800638:	8b 00                	mov    (%rax),%eax
  80063a:	39 c2                	cmp    %eax,%edx
  80063c:	0f 94 c0             	sete   %al
  80063f:	0f b6 c0             	movzbl %al,%eax
}
  800642:	c9                   	leaveq 
  800643:	c3                   	retq   

0000000000800644 <opencons>:

int
opencons(void)
{
  800644:	55                   	push   %rbp
  800645:	48 89 e5             	mov    %rsp,%rbp
  800648:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80064c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800650:	48 89 c7             	mov    %rax,%rdi
  800653:	48 b8 0c 28 80 00 00 	movabs $0x80280c,%rax
  80065a:	00 00 00 
  80065d:	ff d0                	callq  *%rax
  80065f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800662:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800666:	79 05                	jns    80066d <opencons+0x29>
		return r;
  800668:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80066b:	eb 5b                	jmp    8006c8 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80066d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800671:	ba 07 04 00 00       	mov    $0x407,%edx
  800676:	48 89 c6             	mov    %rax,%rsi
  800679:	bf 00 00 00 00       	mov    $0x0,%edi
  80067e:	48 b8 06 20 80 00 00 	movabs $0x802006,%rax
  800685:	00 00 00 
  800688:	ff d0                	callq  *%rax
  80068a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80068d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800691:	79 05                	jns    800698 <opencons+0x54>
		return r;
  800693:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800696:	eb 30                	jmp    8006c8 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  800698:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80069c:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8006a3:	00 00 00 
  8006a6:	8b 12                	mov    (%rdx),%edx
  8006a8:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8006aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006ae:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8006b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006b9:	48 89 c7             	mov    %rax,%rdi
  8006bc:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
  8006c3:	00 00 00 
  8006c6:	ff d0                	callq  *%rax
}
  8006c8:	c9                   	leaveq 
  8006c9:	c3                   	retq   

00000000008006ca <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8006ca:	55                   	push   %rbp
  8006cb:	48 89 e5             	mov    %rsp,%rbp
  8006ce:	48 83 ec 30          	sub    $0x30,%rsp
  8006d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006da:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8006de:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8006e3:	75 07                	jne    8006ec <devcons_read+0x22>
		return 0;
  8006e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ea:	eb 4b                	jmp    800737 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8006ec:	eb 0c                	jmp    8006fa <devcons_read+0x30>
		sys_yield();
  8006ee:	48 b8 c8 1f 80 00 00 	movabs $0x801fc8,%rax
  8006f5:	00 00 00 
  8006f8:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8006fa:	48 b8 08 1f 80 00 00 	movabs $0x801f08,%rax
  800701:	00 00 00 
  800704:	ff d0                	callq  *%rax
  800706:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800709:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80070d:	74 df                	je     8006ee <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80070f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800713:	79 05                	jns    80071a <devcons_read+0x50>
		return c;
  800715:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800718:	eb 1d                	jmp    800737 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80071a:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80071e:	75 07                	jne    800727 <devcons_read+0x5d>
		return 0;
  800720:	b8 00 00 00 00       	mov    $0x0,%eax
  800725:	eb 10                	jmp    800737 <devcons_read+0x6d>
	*(char*)vbuf = c;
  800727:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80072a:	89 c2                	mov    %eax,%edx
  80072c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800730:	88 10                	mov    %dl,(%rax)
	return 1;
  800732:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800737:	c9                   	leaveq 
  800738:	c3                   	retq   

0000000000800739 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800739:	55                   	push   %rbp
  80073a:	48 89 e5             	mov    %rsp,%rbp
  80073d:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  800744:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80074b:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  800752:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800759:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800760:	eb 76                	jmp    8007d8 <devcons_write+0x9f>
		m = n - tot;
  800762:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800769:	89 c2                	mov    %eax,%edx
  80076b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80076e:	29 c2                	sub    %eax,%edx
  800770:	89 d0                	mov    %edx,%eax
  800772:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  800775:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800778:	83 f8 7f             	cmp    $0x7f,%eax
  80077b:	76 07                	jbe    800784 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80077d:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  800784:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800787:	48 63 d0             	movslq %eax,%rdx
  80078a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80078d:	48 63 c8             	movslq %eax,%rcx
  800790:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800797:	48 01 c1             	add    %rax,%rcx
  80079a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8007a1:	48 89 ce             	mov    %rcx,%rsi
  8007a4:	48 89 c7             	mov    %rax,%rdi
  8007a7:	48 b8 fb 19 80 00 00 	movabs $0x8019fb,%rax
  8007ae:	00 00 00 
  8007b1:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8007b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8007b6:	48 63 d0             	movslq %eax,%rdx
  8007b9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8007c0:	48 89 d6             	mov    %rdx,%rsi
  8007c3:	48 89 c7             	mov    %rax,%rdi
  8007c6:	48 b8 be 1e 80 00 00 	movabs $0x801ebe,%rax
  8007cd:	00 00 00 
  8007d0:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8007d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8007d5:	01 45 fc             	add    %eax,-0x4(%rbp)
  8007d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8007db:	48 98                	cltq   
  8007dd:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8007e4:	0f 82 78 ff ff ff    	jb     800762 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8007ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8007ed:	c9                   	leaveq 
  8007ee:	c3                   	retq   

00000000008007ef <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8007ef:	55                   	push   %rbp
  8007f0:	48 89 e5             	mov    %rsp,%rbp
  8007f3:	48 83 ec 08          	sub    $0x8,%rsp
  8007f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8007fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800800:	c9                   	leaveq 
  800801:	c3                   	retq   

0000000000800802 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800802:	55                   	push   %rbp
  800803:	48 89 e5             	mov    %rsp,%rbp
  800806:	48 83 ec 10          	sub    $0x10,%rsp
  80080a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80080e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  800812:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800816:	48 be 51 4e 80 00 00 	movabs $0x804e51,%rsi
  80081d:	00 00 00 
  800820:	48 89 c7             	mov    %rax,%rdi
  800823:	48 b8 d7 16 80 00 00 	movabs $0x8016d7,%rax
  80082a:	00 00 00 
  80082d:	ff d0                	callq  *%rax
	return 0;
  80082f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800834:	c9                   	leaveq 
  800835:	c3                   	retq   

0000000000800836 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800836:	55                   	push   %rbp
  800837:	48 89 e5             	mov    %rsp,%rbp
  80083a:	48 83 ec 10          	sub    $0x10,%rsp
  80083e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800841:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  800845:	48 b8 8a 1f 80 00 00 	movabs $0x801f8a,%rax
  80084c:	00 00 00 
  80084f:	ff d0                	callq  *%rax
  800851:	48 98                	cltq   
  800853:	25 ff 03 00 00       	and    $0x3ff,%eax
  800858:	48 89 c2             	mov    %rax,%rdx
  80085b:	48 89 d0             	mov    %rdx,%rax
  80085e:	48 c1 e0 03          	shl    $0x3,%rax
  800862:	48 01 d0             	add    %rdx,%rax
  800865:	48 c1 e0 05          	shl    $0x5,%rax
  800869:	48 89 c2             	mov    %rax,%rdx
  80086c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800873:	00 00 00 
  800876:	48 01 c2             	add    %rax,%rdx
  800879:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800880:	00 00 00 
  800883:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800886:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80088a:	7e 14                	jle    8008a0 <libmain+0x6a>
		binaryname = argv[0];
  80088c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800890:	48 8b 10             	mov    (%rax),%rdx
  800893:	48 b8 38 70 80 00 00 	movabs $0x807038,%rax
  80089a:	00 00 00 
  80089d:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8008a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8008a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008a7:	48 89 d6             	mov    %rdx,%rsi
  8008aa:	89 c7                	mov    %eax,%edi
  8008ac:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8008b3:	00 00 00 
  8008b6:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8008b8:	48 b8 c6 08 80 00 00 	movabs $0x8008c6,%rax
  8008bf:	00 00 00 
  8008c2:	ff d0                	callq  *%rax
}
  8008c4:	c9                   	leaveq 
  8008c5:	c3                   	retq   

00000000008008c6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8008c6:	55                   	push   %rbp
  8008c7:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8008ca:	48 b8 ff 2a 80 00 00 	movabs $0x802aff,%rax
  8008d1:	00 00 00 
  8008d4:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8008d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8008db:	48 b8 46 1f 80 00 00 	movabs $0x801f46,%rax
  8008e2:	00 00 00 
  8008e5:	ff d0                	callq  *%rax
}
  8008e7:	5d                   	pop    %rbp
  8008e8:	c3                   	retq   

00000000008008e9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8008e9:	55                   	push   %rbp
  8008ea:	48 89 e5             	mov    %rsp,%rbp
  8008ed:	53                   	push   %rbx
  8008ee:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8008f5:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8008fc:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800902:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800909:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800910:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800917:	84 c0                	test   %al,%al
  800919:	74 23                	je     80093e <_panic+0x55>
  80091b:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800922:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800926:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80092a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80092e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800932:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800936:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80093a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80093e:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800945:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80094c:	00 00 00 
  80094f:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800956:	00 00 00 
  800959:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80095d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800964:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80096b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800972:	48 b8 38 70 80 00 00 	movabs $0x807038,%rax
  800979:	00 00 00 
  80097c:	48 8b 18             	mov    (%rax),%rbx
  80097f:	48 b8 8a 1f 80 00 00 	movabs $0x801f8a,%rax
  800986:	00 00 00 
  800989:	ff d0                	callq  *%rax
  80098b:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800991:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800998:	41 89 c8             	mov    %ecx,%r8d
  80099b:	48 89 d1             	mov    %rdx,%rcx
  80099e:	48 89 da             	mov    %rbx,%rdx
  8009a1:	89 c6                	mov    %eax,%esi
  8009a3:	48 bf 68 4e 80 00 00 	movabs $0x804e68,%rdi
  8009aa:	00 00 00 
  8009ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b2:	49 b9 22 0b 80 00 00 	movabs $0x800b22,%r9
  8009b9:	00 00 00 
  8009bc:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8009bf:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8009c6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8009cd:	48 89 d6             	mov    %rdx,%rsi
  8009d0:	48 89 c7             	mov    %rax,%rdi
  8009d3:	48 b8 76 0a 80 00 00 	movabs $0x800a76,%rax
  8009da:	00 00 00 
  8009dd:	ff d0                	callq  *%rax
	cprintf("\n");
  8009df:	48 bf 8b 4e 80 00 00 	movabs $0x804e8b,%rdi
  8009e6:	00 00 00 
  8009e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ee:	48 ba 22 0b 80 00 00 	movabs $0x800b22,%rdx
  8009f5:	00 00 00 
  8009f8:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8009fa:	cc                   	int3   
  8009fb:	eb fd                	jmp    8009fa <_panic+0x111>

00000000008009fd <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8009fd:	55                   	push   %rbp
  8009fe:	48 89 e5             	mov    %rsp,%rbp
  800a01:	48 83 ec 10          	sub    $0x10,%rsp
  800a05:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800a08:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800a0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a10:	8b 00                	mov    (%rax),%eax
  800a12:	8d 48 01             	lea    0x1(%rax),%ecx
  800a15:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a19:	89 0a                	mov    %ecx,(%rdx)
  800a1b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800a1e:	89 d1                	mov    %edx,%ecx
  800a20:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a24:	48 98                	cltq   
  800a26:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800a2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a2e:	8b 00                	mov    (%rax),%eax
  800a30:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a35:	75 2c                	jne    800a63 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800a37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a3b:	8b 00                	mov    (%rax),%eax
  800a3d:	48 98                	cltq   
  800a3f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a43:	48 83 c2 08          	add    $0x8,%rdx
  800a47:	48 89 c6             	mov    %rax,%rsi
  800a4a:	48 89 d7             	mov    %rdx,%rdi
  800a4d:	48 b8 be 1e 80 00 00 	movabs $0x801ebe,%rax
  800a54:	00 00 00 
  800a57:	ff d0                	callq  *%rax
        b->idx = 0;
  800a59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a5d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800a63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a67:	8b 40 04             	mov    0x4(%rax),%eax
  800a6a:	8d 50 01             	lea    0x1(%rax),%edx
  800a6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a71:	89 50 04             	mov    %edx,0x4(%rax)
}
  800a74:	c9                   	leaveq 
  800a75:	c3                   	retq   

0000000000800a76 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800a76:	55                   	push   %rbp
  800a77:	48 89 e5             	mov    %rsp,%rbp
  800a7a:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800a81:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800a88:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800a8f:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800a96:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800a9d:	48 8b 0a             	mov    (%rdx),%rcx
  800aa0:	48 89 08             	mov    %rcx,(%rax)
  800aa3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800aa7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800aab:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800aaf:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800ab3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800aba:	00 00 00 
    b.cnt = 0;
  800abd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800ac4:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800ac7:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800ace:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800ad5:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800adc:	48 89 c6             	mov    %rax,%rsi
  800adf:	48 bf fd 09 80 00 00 	movabs $0x8009fd,%rdi
  800ae6:	00 00 00 
  800ae9:	48 b8 d5 0e 80 00 00 	movabs $0x800ed5,%rax
  800af0:	00 00 00 
  800af3:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800af5:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800afb:	48 98                	cltq   
  800afd:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800b04:	48 83 c2 08          	add    $0x8,%rdx
  800b08:	48 89 c6             	mov    %rax,%rsi
  800b0b:	48 89 d7             	mov    %rdx,%rdi
  800b0e:	48 b8 be 1e 80 00 00 	movabs $0x801ebe,%rax
  800b15:	00 00 00 
  800b18:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800b1a:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800b20:	c9                   	leaveq 
  800b21:	c3                   	retq   

0000000000800b22 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800b22:	55                   	push   %rbp
  800b23:	48 89 e5             	mov    %rsp,%rbp
  800b26:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800b2d:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800b34:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800b3b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b42:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b49:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b50:	84 c0                	test   %al,%al
  800b52:	74 20                	je     800b74 <cprintf+0x52>
  800b54:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b58:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b5c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b60:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b64:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b68:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b6c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b70:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800b74:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800b7b:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800b82:	00 00 00 
  800b85:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800b8c:	00 00 00 
  800b8f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b93:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800b9a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ba1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800ba8:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800baf:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800bb6:	48 8b 0a             	mov    (%rdx),%rcx
  800bb9:	48 89 08             	mov    %rcx,(%rax)
  800bbc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800bc0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800bc4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800bc8:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800bcc:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800bd3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800bda:	48 89 d6             	mov    %rdx,%rsi
  800bdd:	48 89 c7             	mov    %rax,%rdi
  800be0:	48 b8 76 0a 80 00 00 	movabs $0x800a76,%rax
  800be7:	00 00 00 
  800bea:	ff d0                	callq  *%rax
  800bec:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800bf2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800bf8:	c9                   	leaveq 
  800bf9:	c3                   	retq   

0000000000800bfa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800bfa:	55                   	push   %rbp
  800bfb:	48 89 e5             	mov    %rsp,%rbp
  800bfe:	53                   	push   %rbx
  800bff:	48 83 ec 38          	sub    $0x38,%rsp
  800c03:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800c07:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800c0b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800c0f:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800c12:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800c16:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c1a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800c1d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800c21:	77 3b                	ja     800c5e <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c23:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800c26:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800c2a:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800c2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800c31:	ba 00 00 00 00       	mov    $0x0,%edx
  800c36:	48 f7 f3             	div    %rbx
  800c39:	48 89 c2             	mov    %rax,%rdx
  800c3c:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800c3f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800c42:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800c46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c4a:	41 89 f9             	mov    %edi,%r9d
  800c4d:	48 89 c7             	mov    %rax,%rdi
  800c50:	48 b8 fa 0b 80 00 00 	movabs $0x800bfa,%rax
  800c57:	00 00 00 
  800c5a:	ff d0                	callq  *%rax
  800c5c:	eb 1e                	jmp    800c7c <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c5e:	eb 12                	jmp    800c72 <printnum+0x78>
			putch(padc, putdat);
  800c60:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800c64:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800c67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c6b:	48 89 ce             	mov    %rcx,%rsi
  800c6e:	89 d7                	mov    %edx,%edi
  800c70:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c72:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800c76:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800c7a:	7f e4                	jg     800c60 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c7c:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800c7f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800c83:	ba 00 00 00 00       	mov    $0x0,%edx
  800c88:	48 f7 f1             	div    %rcx
  800c8b:	48 89 d0             	mov    %rdx,%rax
  800c8e:	48 ba 90 50 80 00 00 	movabs $0x805090,%rdx
  800c95:	00 00 00 
  800c98:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800c9c:	0f be d0             	movsbl %al,%edx
  800c9f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800ca3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ca7:	48 89 ce             	mov    %rcx,%rsi
  800caa:	89 d7                	mov    %edx,%edi
  800cac:	ff d0                	callq  *%rax
}
  800cae:	48 83 c4 38          	add    $0x38,%rsp
  800cb2:	5b                   	pop    %rbx
  800cb3:	5d                   	pop    %rbp
  800cb4:	c3                   	retq   

0000000000800cb5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cb5:	55                   	push   %rbp
  800cb6:	48 89 e5             	mov    %rsp,%rbp
  800cb9:	48 83 ec 1c          	sub    $0x1c,%rsp
  800cbd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800cc1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800cc4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800cc8:	7e 52                	jle    800d1c <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800cca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cce:	8b 00                	mov    (%rax),%eax
  800cd0:	83 f8 30             	cmp    $0x30,%eax
  800cd3:	73 24                	jae    800cf9 <getuint+0x44>
  800cd5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cd9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800cdd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ce1:	8b 00                	mov    (%rax),%eax
  800ce3:	89 c0                	mov    %eax,%eax
  800ce5:	48 01 d0             	add    %rdx,%rax
  800ce8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cec:	8b 12                	mov    (%rdx),%edx
  800cee:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800cf1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cf5:	89 0a                	mov    %ecx,(%rdx)
  800cf7:	eb 17                	jmp    800d10 <getuint+0x5b>
  800cf9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cfd:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800d01:	48 89 d0             	mov    %rdx,%rax
  800d04:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800d08:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d0c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d10:	48 8b 00             	mov    (%rax),%rax
  800d13:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800d17:	e9 a3 00 00 00       	jmpq   800dbf <getuint+0x10a>
	else if (lflag)
  800d1c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800d20:	74 4f                	je     800d71 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800d22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d26:	8b 00                	mov    (%rax),%eax
  800d28:	83 f8 30             	cmp    $0x30,%eax
  800d2b:	73 24                	jae    800d51 <getuint+0x9c>
  800d2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d31:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d39:	8b 00                	mov    (%rax),%eax
  800d3b:	89 c0                	mov    %eax,%eax
  800d3d:	48 01 d0             	add    %rdx,%rax
  800d40:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d44:	8b 12                	mov    (%rdx),%edx
  800d46:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d49:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d4d:	89 0a                	mov    %ecx,(%rdx)
  800d4f:	eb 17                	jmp    800d68 <getuint+0xb3>
  800d51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d55:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800d59:	48 89 d0             	mov    %rdx,%rax
  800d5c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800d60:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d64:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d68:	48 8b 00             	mov    (%rax),%rax
  800d6b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800d6f:	eb 4e                	jmp    800dbf <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800d71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d75:	8b 00                	mov    (%rax),%eax
  800d77:	83 f8 30             	cmp    $0x30,%eax
  800d7a:	73 24                	jae    800da0 <getuint+0xeb>
  800d7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d80:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d88:	8b 00                	mov    (%rax),%eax
  800d8a:	89 c0                	mov    %eax,%eax
  800d8c:	48 01 d0             	add    %rdx,%rax
  800d8f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d93:	8b 12                	mov    (%rdx),%edx
  800d95:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d98:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d9c:	89 0a                	mov    %ecx,(%rdx)
  800d9e:	eb 17                	jmp    800db7 <getuint+0x102>
  800da0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800da4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800da8:	48 89 d0             	mov    %rdx,%rax
  800dab:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800daf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800db3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800db7:	8b 00                	mov    (%rax),%eax
  800db9:	89 c0                	mov    %eax,%eax
  800dbb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800dbf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800dc3:	c9                   	leaveq 
  800dc4:	c3                   	retq   

0000000000800dc5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800dc5:	55                   	push   %rbp
  800dc6:	48 89 e5             	mov    %rsp,%rbp
  800dc9:	48 83 ec 1c          	sub    $0x1c,%rsp
  800dcd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800dd1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800dd4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800dd8:	7e 52                	jle    800e2c <getint+0x67>
		x=va_arg(*ap, long long);
  800dda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dde:	8b 00                	mov    (%rax),%eax
  800de0:	83 f8 30             	cmp    $0x30,%eax
  800de3:	73 24                	jae    800e09 <getint+0x44>
  800de5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800de9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ded:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800df1:	8b 00                	mov    (%rax),%eax
  800df3:	89 c0                	mov    %eax,%eax
  800df5:	48 01 d0             	add    %rdx,%rax
  800df8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800dfc:	8b 12                	mov    (%rdx),%edx
  800dfe:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800e01:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e05:	89 0a                	mov    %ecx,(%rdx)
  800e07:	eb 17                	jmp    800e20 <getint+0x5b>
  800e09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e0d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800e11:	48 89 d0             	mov    %rdx,%rax
  800e14:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800e18:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e1c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e20:	48 8b 00             	mov    (%rax),%rax
  800e23:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800e27:	e9 a3 00 00 00       	jmpq   800ecf <getint+0x10a>
	else if (lflag)
  800e2c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800e30:	74 4f                	je     800e81 <getint+0xbc>
		x=va_arg(*ap, long);
  800e32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e36:	8b 00                	mov    (%rax),%eax
  800e38:	83 f8 30             	cmp    $0x30,%eax
  800e3b:	73 24                	jae    800e61 <getint+0x9c>
  800e3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e41:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800e45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e49:	8b 00                	mov    (%rax),%eax
  800e4b:	89 c0                	mov    %eax,%eax
  800e4d:	48 01 d0             	add    %rdx,%rax
  800e50:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e54:	8b 12                	mov    (%rdx),%edx
  800e56:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800e59:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e5d:	89 0a                	mov    %ecx,(%rdx)
  800e5f:	eb 17                	jmp    800e78 <getint+0xb3>
  800e61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e65:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800e69:	48 89 d0             	mov    %rdx,%rax
  800e6c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800e70:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e74:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e78:	48 8b 00             	mov    (%rax),%rax
  800e7b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800e7f:	eb 4e                	jmp    800ecf <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800e81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e85:	8b 00                	mov    (%rax),%eax
  800e87:	83 f8 30             	cmp    $0x30,%eax
  800e8a:	73 24                	jae    800eb0 <getint+0xeb>
  800e8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e90:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800e94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e98:	8b 00                	mov    (%rax),%eax
  800e9a:	89 c0                	mov    %eax,%eax
  800e9c:	48 01 d0             	add    %rdx,%rax
  800e9f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ea3:	8b 12                	mov    (%rdx),%edx
  800ea5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ea8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800eac:	89 0a                	mov    %ecx,(%rdx)
  800eae:	eb 17                	jmp    800ec7 <getint+0x102>
  800eb0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eb4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800eb8:	48 89 d0             	mov    %rdx,%rax
  800ebb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ebf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ec3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ec7:	8b 00                	mov    (%rax),%eax
  800ec9:	48 98                	cltq   
  800ecb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800ecf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ed3:	c9                   	leaveq 
  800ed4:	c3                   	retq   

0000000000800ed5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ed5:	55                   	push   %rbp
  800ed6:	48 89 e5             	mov    %rsp,%rbp
  800ed9:	41 54                	push   %r12
  800edb:	53                   	push   %rbx
  800edc:	48 83 ec 60          	sub    $0x60,%rsp
  800ee0:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800ee4:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800ee8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800eec:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800ef0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ef4:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800ef8:	48 8b 0a             	mov    (%rdx),%rcx
  800efb:	48 89 08             	mov    %rcx,(%rax)
  800efe:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f02:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f06:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f0a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f0e:	eb 17                	jmp    800f27 <vprintfmt+0x52>
			if (ch == '\0')
  800f10:	85 db                	test   %ebx,%ebx
  800f12:	0f 84 cc 04 00 00    	je     8013e4 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800f18:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f1c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f20:	48 89 d6             	mov    %rdx,%rsi
  800f23:	89 df                	mov    %ebx,%edi
  800f25:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f27:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f2b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f2f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800f33:	0f b6 00             	movzbl (%rax),%eax
  800f36:	0f b6 d8             	movzbl %al,%ebx
  800f39:	83 fb 25             	cmp    $0x25,%ebx
  800f3c:	75 d2                	jne    800f10 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800f3e:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800f42:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800f49:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800f50:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800f57:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f5e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f62:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f66:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800f6a:	0f b6 00             	movzbl (%rax),%eax
  800f6d:	0f b6 d8             	movzbl %al,%ebx
  800f70:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800f73:	83 f8 55             	cmp    $0x55,%eax
  800f76:	0f 87 34 04 00 00    	ja     8013b0 <vprintfmt+0x4db>
  800f7c:	89 c0                	mov    %eax,%eax
  800f7e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800f85:	00 
  800f86:	48 b8 b8 50 80 00 00 	movabs $0x8050b8,%rax
  800f8d:	00 00 00 
  800f90:	48 01 d0             	add    %rdx,%rax
  800f93:	48 8b 00             	mov    (%rax),%rax
  800f96:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800f98:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800f9c:	eb c0                	jmp    800f5e <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f9e:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800fa2:	eb ba                	jmp    800f5e <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800fa4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800fab:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800fae:	89 d0                	mov    %edx,%eax
  800fb0:	c1 e0 02             	shl    $0x2,%eax
  800fb3:	01 d0                	add    %edx,%eax
  800fb5:	01 c0                	add    %eax,%eax
  800fb7:	01 d8                	add    %ebx,%eax
  800fb9:	83 e8 30             	sub    $0x30,%eax
  800fbc:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800fbf:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fc3:	0f b6 00             	movzbl (%rax),%eax
  800fc6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800fc9:	83 fb 2f             	cmp    $0x2f,%ebx
  800fcc:	7e 0c                	jle    800fda <vprintfmt+0x105>
  800fce:	83 fb 39             	cmp    $0x39,%ebx
  800fd1:	7f 07                	jg     800fda <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800fd3:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800fd8:	eb d1                	jmp    800fab <vprintfmt+0xd6>
			goto process_precision;
  800fda:	eb 58                	jmp    801034 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800fdc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fdf:	83 f8 30             	cmp    $0x30,%eax
  800fe2:	73 17                	jae    800ffb <vprintfmt+0x126>
  800fe4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800fe8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800feb:	89 c0                	mov    %eax,%eax
  800fed:	48 01 d0             	add    %rdx,%rax
  800ff0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ff3:	83 c2 08             	add    $0x8,%edx
  800ff6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ff9:	eb 0f                	jmp    80100a <vprintfmt+0x135>
  800ffb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800fff:	48 89 d0             	mov    %rdx,%rax
  801002:	48 83 c2 08          	add    $0x8,%rdx
  801006:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80100a:	8b 00                	mov    (%rax),%eax
  80100c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80100f:	eb 23                	jmp    801034 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  801011:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801015:	79 0c                	jns    801023 <vprintfmt+0x14e>
				width = 0;
  801017:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80101e:	e9 3b ff ff ff       	jmpq   800f5e <vprintfmt+0x89>
  801023:	e9 36 ff ff ff       	jmpq   800f5e <vprintfmt+0x89>

		case '#':
			altflag = 1;
  801028:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80102f:	e9 2a ff ff ff       	jmpq   800f5e <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  801034:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801038:	79 12                	jns    80104c <vprintfmt+0x177>
				width = precision, precision = -1;
  80103a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80103d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801040:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801047:	e9 12 ff ff ff       	jmpq   800f5e <vprintfmt+0x89>
  80104c:	e9 0d ff ff ff       	jmpq   800f5e <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  801051:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801055:	e9 04 ff ff ff       	jmpq   800f5e <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80105a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80105d:	83 f8 30             	cmp    $0x30,%eax
  801060:	73 17                	jae    801079 <vprintfmt+0x1a4>
  801062:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801066:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801069:	89 c0                	mov    %eax,%eax
  80106b:	48 01 d0             	add    %rdx,%rax
  80106e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801071:	83 c2 08             	add    $0x8,%edx
  801074:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801077:	eb 0f                	jmp    801088 <vprintfmt+0x1b3>
  801079:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80107d:	48 89 d0             	mov    %rdx,%rax
  801080:	48 83 c2 08          	add    $0x8,%rdx
  801084:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801088:	8b 10                	mov    (%rax),%edx
  80108a:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80108e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801092:	48 89 ce             	mov    %rcx,%rsi
  801095:	89 d7                	mov    %edx,%edi
  801097:	ff d0                	callq  *%rax
			break;
  801099:	e9 40 03 00 00       	jmpq   8013de <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80109e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010a1:	83 f8 30             	cmp    $0x30,%eax
  8010a4:	73 17                	jae    8010bd <vprintfmt+0x1e8>
  8010a6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8010aa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010ad:	89 c0                	mov    %eax,%eax
  8010af:	48 01 d0             	add    %rdx,%rax
  8010b2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8010b5:	83 c2 08             	add    $0x8,%edx
  8010b8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8010bb:	eb 0f                	jmp    8010cc <vprintfmt+0x1f7>
  8010bd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8010c1:	48 89 d0             	mov    %rdx,%rax
  8010c4:	48 83 c2 08          	add    $0x8,%rdx
  8010c8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8010cc:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8010ce:	85 db                	test   %ebx,%ebx
  8010d0:	79 02                	jns    8010d4 <vprintfmt+0x1ff>
				err = -err;
  8010d2:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8010d4:	83 fb 15             	cmp    $0x15,%ebx
  8010d7:	7f 16                	jg     8010ef <vprintfmt+0x21a>
  8010d9:	48 b8 e0 4f 80 00 00 	movabs $0x804fe0,%rax
  8010e0:	00 00 00 
  8010e3:	48 63 d3             	movslq %ebx,%rdx
  8010e6:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8010ea:	4d 85 e4             	test   %r12,%r12
  8010ed:	75 2e                	jne    80111d <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8010ef:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8010f3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010f7:	89 d9                	mov    %ebx,%ecx
  8010f9:	48 ba a1 50 80 00 00 	movabs $0x8050a1,%rdx
  801100:	00 00 00 
  801103:	48 89 c7             	mov    %rax,%rdi
  801106:	b8 00 00 00 00       	mov    $0x0,%eax
  80110b:	49 b8 ed 13 80 00 00 	movabs $0x8013ed,%r8
  801112:	00 00 00 
  801115:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801118:	e9 c1 02 00 00       	jmpq   8013de <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80111d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801121:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801125:	4c 89 e1             	mov    %r12,%rcx
  801128:	48 ba aa 50 80 00 00 	movabs $0x8050aa,%rdx
  80112f:	00 00 00 
  801132:	48 89 c7             	mov    %rax,%rdi
  801135:	b8 00 00 00 00       	mov    $0x0,%eax
  80113a:	49 b8 ed 13 80 00 00 	movabs $0x8013ed,%r8
  801141:	00 00 00 
  801144:	41 ff d0             	callq  *%r8
			break;
  801147:	e9 92 02 00 00       	jmpq   8013de <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80114c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80114f:	83 f8 30             	cmp    $0x30,%eax
  801152:	73 17                	jae    80116b <vprintfmt+0x296>
  801154:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801158:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80115b:	89 c0                	mov    %eax,%eax
  80115d:	48 01 d0             	add    %rdx,%rax
  801160:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801163:	83 c2 08             	add    $0x8,%edx
  801166:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801169:	eb 0f                	jmp    80117a <vprintfmt+0x2a5>
  80116b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80116f:	48 89 d0             	mov    %rdx,%rax
  801172:	48 83 c2 08          	add    $0x8,%rdx
  801176:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80117a:	4c 8b 20             	mov    (%rax),%r12
  80117d:	4d 85 e4             	test   %r12,%r12
  801180:	75 0a                	jne    80118c <vprintfmt+0x2b7>
				p = "(null)";
  801182:	49 bc ad 50 80 00 00 	movabs $0x8050ad,%r12
  801189:	00 00 00 
			if (width > 0 && padc != '-')
  80118c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801190:	7e 3f                	jle    8011d1 <vprintfmt+0x2fc>
  801192:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801196:	74 39                	je     8011d1 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  801198:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80119b:	48 98                	cltq   
  80119d:	48 89 c6             	mov    %rax,%rsi
  8011a0:	4c 89 e7             	mov    %r12,%rdi
  8011a3:	48 b8 99 16 80 00 00 	movabs $0x801699,%rax
  8011aa:	00 00 00 
  8011ad:	ff d0                	callq  *%rax
  8011af:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8011b2:	eb 17                	jmp    8011cb <vprintfmt+0x2f6>
					putch(padc, putdat);
  8011b4:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8011b8:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8011bc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011c0:	48 89 ce             	mov    %rcx,%rsi
  8011c3:	89 d7                	mov    %edx,%edi
  8011c5:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8011c7:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8011cb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8011cf:	7f e3                	jg     8011b4 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8011d1:	eb 37                	jmp    80120a <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8011d3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8011d7:	74 1e                	je     8011f7 <vprintfmt+0x322>
  8011d9:	83 fb 1f             	cmp    $0x1f,%ebx
  8011dc:	7e 05                	jle    8011e3 <vprintfmt+0x30e>
  8011de:	83 fb 7e             	cmp    $0x7e,%ebx
  8011e1:	7e 14                	jle    8011f7 <vprintfmt+0x322>
					putch('?', putdat);
  8011e3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011e7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011eb:	48 89 d6             	mov    %rdx,%rsi
  8011ee:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8011f3:	ff d0                	callq  *%rax
  8011f5:	eb 0f                	jmp    801206 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8011f7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011fb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011ff:	48 89 d6             	mov    %rdx,%rsi
  801202:	89 df                	mov    %ebx,%edi
  801204:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801206:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80120a:	4c 89 e0             	mov    %r12,%rax
  80120d:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801211:	0f b6 00             	movzbl (%rax),%eax
  801214:	0f be d8             	movsbl %al,%ebx
  801217:	85 db                	test   %ebx,%ebx
  801219:	74 10                	je     80122b <vprintfmt+0x356>
  80121b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80121f:	78 b2                	js     8011d3 <vprintfmt+0x2fe>
  801221:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801225:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801229:	79 a8                	jns    8011d3 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80122b:	eb 16                	jmp    801243 <vprintfmt+0x36e>
				putch(' ', putdat);
  80122d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801231:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801235:	48 89 d6             	mov    %rdx,%rsi
  801238:	bf 20 00 00 00       	mov    $0x20,%edi
  80123d:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80123f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801243:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801247:	7f e4                	jg     80122d <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  801249:	e9 90 01 00 00       	jmpq   8013de <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  80124e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801252:	be 03 00 00 00       	mov    $0x3,%esi
  801257:	48 89 c7             	mov    %rax,%rdi
  80125a:	48 b8 c5 0d 80 00 00 	movabs $0x800dc5,%rax
  801261:	00 00 00 
  801264:	ff d0                	callq  *%rax
  801266:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  80126a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80126e:	48 85 c0             	test   %rax,%rax
  801271:	79 1d                	jns    801290 <vprintfmt+0x3bb>
				putch('-', putdat);
  801273:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801277:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80127b:	48 89 d6             	mov    %rdx,%rsi
  80127e:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801283:	ff d0                	callq  *%rax
				num = -(long long) num;
  801285:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801289:	48 f7 d8             	neg    %rax
  80128c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801290:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801297:	e9 d5 00 00 00       	jmpq   801371 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  80129c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8012a0:	be 03 00 00 00       	mov    $0x3,%esi
  8012a5:	48 89 c7             	mov    %rax,%rdi
  8012a8:	48 b8 b5 0c 80 00 00 	movabs $0x800cb5,%rax
  8012af:	00 00 00 
  8012b2:	ff d0                	callq  *%rax
  8012b4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8012b8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8012bf:	e9 ad 00 00 00       	jmpq   801371 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  8012c4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8012c8:	be 03 00 00 00       	mov    $0x3,%esi
  8012cd:	48 89 c7             	mov    %rax,%rdi
  8012d0:	48 b8 b5 0c 80 00 00 	movabs $0x800cb5,%rax
  8012d7:	00 00 00 
  8012da:	ff d0                	callq  *%rax
  8012dc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  8012e0:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  8012e7:	e9 85 00 00 00       	jmpq   801371 <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  8012ec:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8012f0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012f4:	48 89 d6             	mov    %rdx,%rsi
  8012f7:	bf 30 00 00 00       	mov    $0x30,%edi
  8012fc:	ff d0                	callq  *%rax
			putch('x', putdat);
  8012fe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801302:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801306:	48 89 d6             	mov    %rdx,%rsi
  801309:	bf 78 00 00 00       	mov    $0x78,%edi
  80130e:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801310:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801313:	83 f8 30             	cmp    $0x30,%eax
  801316:	73 17                	jae    80132f <vprintfmt+0x45a>
  801318:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80131c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80131f:	89 c0                	mov    %eax,%eax
  801321:	48 01 d0             	add    %rdx,%rax
  801324:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801327:	83 c2 08             	add    $0x8,%edx
  80132a:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80132d:	eb 0f                	jmp    80133e <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  80132f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801333:	48 89 d0             	mov    %rdx,%rax
  801336:	48 83 c2 08          	add    $0x8,%rdx
  80133a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80133e:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801341:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801345:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  80134c:	eb 23                	jmp    801371 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  80134e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801352:	be 03 00 00 00       	mov    $0x3,%esi
  801357:	48 89 c7             	mov    %rax,%rdi
  80135a:	48 b8 b5 0c 80 00 00 	movabs $0x800cb5,%rax
  801361:	00 00 00 
  801364:	ff d0                	callq  *%rax
  801366:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  80136a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801371:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801376:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801379:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80137c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801380:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801384:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801388:	45 89 c1             	mov    %r8d,%r9d
  80138b:	41 89 f8             	mov    %edi,%r8d
  80138e:	48 89 c7             	mov    %rax,%rdi
  801391:	48 b8 fa 0b 80 00 00 	movabs $0x800bfa,%rax
  801398:	00 00 00 
  80139b:	ff d0                	callq  *%rax
			break;
  80139d:	eb 3f                	jmp    8013de <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  80139f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013a3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013a7:	48 89 d6             	mov    %rdx,%rsi
  8013aa:	89 df                	mov    %ebx,%edi
  8013ac:	ff d0                	callq  *%rax
			break;
  8013ae:	eb 2e                	jmp    8013de <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8013b0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013b4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013b8:	48 89 d6             	mov    %rdx,%rsi
  8013bb:	bf 25 00 00 00       	mov    $0x25,%edi
  8013c0:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8013c2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8013c7:	eb 05                	jmp    8013ce <vprintfmt+0x4f9>
  8013c9:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8013ce:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8013d2:	48 83 e8 01          	sub    $0x1,%rax
  8013d6:	0f b6 00             	movzbl (%rax),%eax
  8013d9:	3c 25                	cmp    $0x25,%al
  8013db:	75 ec                	jne    8013c9 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  8013dd:	90                   	nop
		}
	}
  8013de:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8013df:	e9 43 fb ff ff       	jmpq   800f27 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8013e4:	48 83 c4 60          	add    $0x60,%rsp
  8013e8:	5b                   	pop    %rbx
  8013e9:	41 5c                	pop    %r12
  8013eb:	5d                   	pop    %rbp
  8013ec:	c3                   	retq   

00000000008013ed <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8013ed:	55                   	push   %rbp
  8013ee:	48 89 e5             	mov    %rsp,%rbp
  8013f1:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8013f8:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8013ff:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801406:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80140d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801414:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80141b:	84 c0                	test   %al,%al
  80141d:	74 20                	je     80143f <printfmt+0x52>
  80141f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801423:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801427:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80142b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80142f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801433:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801437:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80143b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80143f:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801446:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80144d:	00 00 00 
  801450:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801457:	00 00 00 
  80145a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80145e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801465:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80146c:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801473:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80147a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801481:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801488:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80148f:	48 89 c7             	mov    %rax,%rdi
  801492:	48 b8 d5 0e 80 00 00 	movabs $0x800ed5,%rax
  801499:	00 00 00 
  80149c:	ff d0                	callq  *%rax
	va_end(ap);
}
  80149e:	c9                   	leaveq 
  80149f:	c3                   	retq   

00000000008014a0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8014a0:	55                   	push   %rbp
  8014a1:	48 89 e5             	mov    %rsp,%rbp
  8014a4:	48 83 ec 10          	sub    $0x10,%rsp
  8014a8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8014ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8014af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b3:	8b 40 10             	mov    0x10(%rax),%eax
  8014b6:	8d 50 01             	lea    0x1(%rax),%edx
  8014b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014bd:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8014c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c4:	48 8b 10             	mov    (%rax),%rdx
  8014c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014cb:	48 8b 40 08          	mov    0x8(%rax),%rax
  8014cf:	48 39 c2             	cmp    %rax,%rdx
  8014d2:	73 17                	jae    8014eb <sprintputch+0x4b>
		*b->buf++ = ch;
  8014d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d8:	48 8b 00             	mov    (%rax),%rax
  8014db:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8014df:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8014e3:	48 89 0a             	mov    %rcx,(%rdx)
  8014e6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8014e9:	88 10                	mov    %dl,(%rax)
}
  8014eb:	c9                   	leaveq 
  8014ec:	c3                   	retq   

00000000008014ed <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8014ed:	55                   	push   %rbp
  8014ee:	48 89 e5             	mov    %rsp,%rbp
  8014f1:	48 83 ec 50          	sub    $0x50,%rsp
  8014f5:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8014f9:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8014fc:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801500:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801504:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801508:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80150c:	48 8b 0a             	mov    (%rdx),%rcx
  80150f:	48 89 08             	mov    %rcx,(%rax)
  801512:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801516:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80151a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80151e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801522:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801526:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80152a:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80152d:	48 98                	cltq   
  80152f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801533:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801537:	48 01 d0             	add    %rdx,%rax
  80153a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80153e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801545:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80154a:	74 06                	je     801552 <vsnprintf+0x65>
  80154c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801550:	7f 07                	jg     801559 <vsnprintf+0x6c>
		return -E_INVAL;
  801552:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801557:	eb 2f                	jmp    801588 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801559:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80155d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801561:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801565:	48 89 c6             	mov    %rax,%rsi
  801568:	48 bf a0 14 80 00 00 	movabs $0x8014a0,%rdi
  80156f:	00 00 00 
  801572:	48 b8 d5 0e 80 00 00 	movabs $0x800ed5,%rax
  801579:	00 00 00 
  80157c:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80157e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801582:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801585:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801588:	c9                   	leaveq 
  801589:	c3                   	retq   

000000000080158a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80158a:	55                   	push   %rbp
  80158b:	48 89 e5             	mov    %rsp,%rbp
  80158e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801595:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80159c:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8015a2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8015a9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8015b0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8015b7:	84 c0                	test   %al,%al
  8015b9:	74 20                	je     8015db <snprintf+0x51>
  8015bb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8015bf:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8015c3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8015c7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8015cb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8015cf:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8015d3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8015d7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8015db:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8015e2:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8015e9:	00 00 00 
  8015ec:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8015f3:	00 00 00 
  8015f6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8015fa:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801601:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801608:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80160f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801616:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80161d:	48 8b 0a             	mov    (%rdx),%rcx
  801620:	48 89 08             	mov    %rcx,(%rax)
  801623:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801627:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80162b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80162f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801633:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80163a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801641:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801647:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80164e:	48 89 c7             	mov    %rax,%rdi
  801651:	48 b8 ed 14 80 00 00 	movabs $0x8014ed,%rax
  801658:	00 00 00 
  80165b:	ff d0                	callq  *%rax
  80165d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801663:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801669:	c9                   	leaveq 
  80166a:	c3                   	retq   

000000000080166b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80166b:	55                   	push   %rbp
  80166c:	48 89 e5             	mov    %rsp,%rbp
  80166f:	48 83 ec 18          	sub    $0x18,%rsp
  801673:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801677:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80167e:	eb 09                	jmp    801689 <strlen+0x1e>
		n++;
  801680:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801684:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801689:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80168d:	0f b6 00             	movzbl (%rax),%eax
  801690:	84 c0                	test   %al,%al
  801692:	75 ec                	jne    801680 <strlen+0x15>
		n++;
	return n;
  801694:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801697:	c9                   	leaveq 
  801698:	c3                   	retq   

0000000000801699 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801699:	55                   	push   %rbp
  80169a:	48 89 e5             	mov    %rsp,%rbp
  80169d:	48 83 ec 20          	sub    $0x20,%rsp
  8016a1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016a5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8016b0:	eb 0e                	jmp    8016c0 <strnlen+0x27>
		n++;
  8016b2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016b6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8016bb:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8016c0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8016c5:	74 0b                	je     8016d2 <strnlen+0x39>
  8016c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016cb:	0f b6 00             	movzbl (%rax),%eax
  8016ce:	84 c0                	test   %al,%al
  8016d0:	75 e0                	jne    8016b2 <strnlen+0x19>
		n++;
	return n;
  8016d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8016d5:	c9                   	leaveq 
  8016d6:	c3                   	retq   

00000000008016d7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8016d7:	55                   	push   %rbp
  8016d8:	48 89 e5             	mov    %rsp,%rbp
  8016db:	48 83 ec 20          	sub    $0x20,%rsp
  8016df:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016e3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8016e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016eb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8016ef:	90                   	nop
  8016f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016f4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016f8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8016fc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801700:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801704:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801708:	0f b6 12             	movzbl (%rdx),%edx
  80170b:	88 10                	mov    %dl,(%rax)
  80170d:	0f b6 00             	movzbl (%rax),%eax
  801710:	84 c0                	test   %al,%al
  801712:	75 dc                	jne    8016f0 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801714:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801718:	c9                   	leaveq 
  801719:	c3                   	retq   

000000000080171a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80171a:	55                   	push   %rbp
  80171b:	48 89 e5             	mov    %rsp,%rbp
  80171e:	48 83 ec 20          	sub    $0x20,%rsp
  801722:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801726:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80172a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80172e:	48 89 c7             	mov    %rax,%rdi
  801731:	48 b8 6b 16 80 00 00 	movabs $0x80166b,%rax
  801738:	00 00 00 
  80173b:	ff d0                	callq  *%rax
  80173d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801740:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801743:	48 63 d0             	movslq %eax,%rdx
  801746:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80174a:	48 01 c2             	add    %rax,%rdx
  80174d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801751:	48 89 c6             	mov    %rax,%rsi
  801754:	48 89 d7             	mov    %rdx,%rdi
  801757:	48 b8 d7 16 80 00 00 	movabs $0x8016d7,%rax
  80175e:	00 00 00 
  801761:	ff d0                	callq  *%rax
	return dst;
  801763:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801767:	c9                   	leaveq 
  801768:	c3                   	retq   

0000000000801769 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801769:	55                   	push   %rbp
  80176a:	48 89 e5             	mov    %rsp,%rbp
  80176d:	48 83 ec 28          	sub    $0x28,%rsp
  801771:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801775:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801779:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80177d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801781:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801785:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80178c:	00 
  80178d:	eb 2a                	jmp    8017b9 <strncpy+0x50>
		*dst++ = *src;
  80178f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801793:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801797:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80179b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80179f:	0f b6 12             	movzbl (%rdx),%edx
  8017a2:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8017a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017a8:	0f b6 00             	movzbl (%rax),%eax
  8017ab:	84 c0                	test   %al,%al
  8017ad:	74 05                	je     8017b4 <strncpy+0x4b>
			src++;
  8017af:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8017b4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017bd:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8017c1:	72 cc                	jb     80178f <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8017c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8017c7:	c9                   	leaveq 
  8017c8:	c3                   	retq   

00000000008017c9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8017c9:	55                   	push   %rbp
  8017ca:	48 89 e5             	mov    %rsp,%rbp
  8017cd:	48 83 ec 28          	sub    $0x28,%rsp
  8017d1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017d5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017d9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8017dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017e1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8017e5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8017ea:	74 3d                	je     801829 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8017ec:	eb 1d                	jmp    80180b <strlcpy+0x42>
			*dst++ = *src++;
  8017ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017f2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017f6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8017fa:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8017fe:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801802:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801806:	0f b6 12             	movzbl (%rdx),%edx
  801809:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80180b:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801810:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801815:	74 0b                	je     801822 <strlcpy+0x59>
  801817:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80181b:	0f b6 00             	movzbl (%rax),%eax
  80181e:	84 c0                	test   %al,%al
  801820:	75 cc                	jne    8017ee <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801822:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801826:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801829:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80182d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801831:	48 29 c2             	sub    %rax,%rdx
  801834:	48 89 d0             	mov    %rdx,%rax
}
  801837:	c9                   	leaveq 
  801838:	c3                   	retq   

0000000000801839 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801839:	55                   	push   %rbp
  80183a:	48 89 e5             	mov    %rsp,%rbp
  80183d:	48 83 ec 10          	sub    $0x10,%rsp
  801841:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801845:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801849:	eb 0a                	jmp    801855 <strcmp+0x1c>
		p++, q++;
  80184b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801850:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801855:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801859:	0f b6 00             	movzbl (%rax),%eax
  80185c:	84 c0                	test   %al,%al
  80185e:	74 12                	je     801872 <strcmp+0x39>
  801860:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801864:	0f b6 10             	movzbl (%rax),%edx
  801867:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80186b:	0f b6 00             	movzbl (%rax),%eax
  80186e:	38 c2                	cmp    %al,%dl
  801870:	74 d9                	je     80184b <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801872:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801876:	0f b6 00             	movzbl (%rax),%eax
  801879:	0f b6 d0             	movzbl %al,%edx
  80187c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801880:	0f b6 00             	movzbl (%rax),%eax
  801883:	0f b6 c0             	movzbl %al,%eax
  801886:	29 c2                	sub    %eax,%edx
  801888:	89 d0                	mov    %edx,%eax
}
  80188a:	c9                   	leaveq 
  80188b:	c3                   	retq   

000000000080188c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80188c:	55                   	push   %rbp
  80188d:	48 89 e5             	mov    %rsp,%rbp
  801890:	48 83 ec 18          	sub    $0x18,%rsp
  801894:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801898:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80189c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8018a0:	eb 0f                	jmp    8018b1 <strncmp+0x25>
		n--, p++, q++;
  8018a2:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8018a7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018ac:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8018b1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018b6:	74 1d                	je     8018d5 <strncmp+0x49>
  8018b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018bc:	0f b6 00             	movzbl (%rax),%eax
  8018bf:	84 c0                	test   %al,%al
  8018c1:	74 12                	je     8018d5 <strncmp+0x49>
  8018c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018c7:	0f b6 10             	movzbl (%rax),%edx
  8018ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018ce:	0f b6 00             	movzbl (%rax),%eax
  8018d1:	38 c2                	cmp    %al,%dl
  8018d3:	74 cd                	je     8018a2 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8018d5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018da:	75 07                	jne    8018e3 <strncmp+0x57>
		return 0;
  8018dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e1:	eb 18                	jmp    8018fb <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8018e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018e7:	0f b6 00             	movzbl (%rax),%eax
  8018ea:	0f b6 d0             	movzbl %al,%edx
  8018ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018f1:	0f b6 00             	movzbl (%rax),%eax
  8018f4:	0f b6 c0             	movzbl %al,%eax
  8018f7:	29 c2                	sub    %eax,%edx
  8018f9:	89 d0                	mov    %edx,%eax
}
  8018fb:	c9                   	leaveq 
  8018fc:	c3                   	retq   

00000000008018fd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8018fd:	55                   	push   %rbp
  8018fe:	48 89 e5             	mov    %rsp,%rbp
  801901:	48 83 ec 0c          	sub    $0xc,%rsp
  801905:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801909:	89 f0                	mov    %esi,%eax
  80190b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80190e:	eb 17                	jmp    801927 <strchr+0x2a>
		if (*s == c)
  801910:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801914:	0f b6 00             	movzbl (%rax),%eax
  801917:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80191a:	75 06                	jne    801922 <strchr+0x25>
			return (char *) s;
  80191c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801920:	eb 15                	jmp    801937 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801922:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801927:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80192b:	0f b6 00             	movzbl (%rax),%eax
  80192e:	84 c0                	test   %al,%al
  801930:	75 de                	jne    801910 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801932:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801937:	c9                   	leaveq 
  801938:	c3                   	retq   

0000000000801939 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801939:	55                   	push   %rbp
  80193a:	48 89 e5             	mov    %rsp,%rbp
  80193d:	48 83 ec 0c          	sub    $0xc,%rsp
  801941:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801945:	89 f0                	mov    %esi,%eax
  801947:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80194a:	eb 13                	jmp    80195f <strfind+0x26>
		if (*s == c)
  80194c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801950:	0f b6 00             	movzbl (%rax),%eax
  801953:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801956:	75 02                	jne    80195a <strfind+0x21>
			break;
  801958:	eb 10                	jmp    80196a <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80195a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80195f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801963:	0f b6 00             	movzbl (%rax),%eax
  801966:	84 c0                	test   %al,%al
  801968:	75 e2                	jne    80194c <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80196a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80196e:	c9                   	leaveq 
  80196f:	c3                   	retq   

0000000000801970 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801970:	55                   	push   %rbp
  801971:	48 89 e5             	mov    %rsp,%rbp
  801974:	48 83 ec 18          	sub    $0x18,%rsp
  801978:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80197c:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80197f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801983:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801988:	75 06                	jne    801990 <memset+0x20>
		return v;
  80198a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80198e:	eb 69                	jmp    8019f9 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801990:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801994:	83 e0 03             	and    $0x3,%eax
  801997:	48 85 c0             	test   %rax,%rax
  80199a:	75 48                	jne    8019e4 <memset+0x74>
  80199c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019a0:	83 e0 03             	and    $0x3,%eax
  8019a3:	48 85 c0             	test   %rax,%rax
  8019a6:	75 3c                	jne    8019e4 <memset+0x74>
		c &= 0xFF;
  8019a8:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8019af:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019b2:	c1 e0 18             	shl    $0x18,%eax
  8019b5:	89 c2                	mov    %eax,%edx
  8019b7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019ba:	c1 e0 10             	shl    $0x10,%eax
  8019bd:	09 c2                	or     %eax,%edx
  8019bf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019c2:	c1 e0 08             	shl    $0x8,%eax
  8019c5:	09 d0                	or     %edx,%eax
  8019c7:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8019ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019ce:	48 c1 e8 02          	shr    $0x2,%rax
  8019d2:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8019d5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8019d9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019dc:	48 89 d7             	mov    %rdx,%rdi
  8019df:	fc                   	cld    
  8019e0:	f3 ab                	rep stos %eax,%es:(%rdi)
  8019e2:	eb 11                	jmp    8019f5 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8019e4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8019e8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019eb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8019ef:	48 89 d7             	mov    %rdx,%rdi
  8019f2:	fc                   	cld    
  8019f3:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8019f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8019f9:	c9                   	leaveq 
  8019fa:	c3                   	retq   

00000000008019fb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8019fb:	55                   	push   %rbp
  8019fc:	48 89 e5             	mov    %rsp,%rbp
  8019ff:	48 83 ec 28          	sub    $0x28,%rsp
  801a03:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a07:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a0b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801a0f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a13:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801a17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a1b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801a1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a23:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801a27:	0f 83 88 00 00 00    	jae    801ab5 <memmove+0xba>
  801a2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a31:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a35:	48 01 d0             	add    %rdx,%rax
  801a38:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801a3c:	76 77                	jbe    801ab5 <memmove+0xba>
		s += n;
  801a3e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a42:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801a46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a4a:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801a4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a52:	83 e0 03             	and    $0x3,%eax
  801a55:	48 85 c0             	test   %rax,%rax
  801a58:	75 3b                	jne    801a95 <memmove+0x9a>
  801a5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a5e:	83 e0 03             	and    $0x3,%eax
  801a61:	48 85 c0             	test   %rax,%rax
  801a64:	75 2f                	jne    801a95 <memmove+0x9a>
  801a66:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a6a:	83 e0 03             	and    $0x3,%eax
  801a6d:	48 85 c0             	test   %rax,%rax
  801a70:	75 23                	jne    801a95 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801a72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a76:	48 83 e8 04          	sub    $0x4,%rax
  801a7a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a7e:	48 83 ea 04          	sub    $0x4,%rdx
  801a82:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801a86:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801a8a:	48 89 c7             	mov    %rax,%rdi
  801a8d:	48 89 d6             	mov    %rdx,%rsi
  801a90:	fd                   	std    
  801a91:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801a93:	eb 1d                	jmp    801ab2 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801a95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a99:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801a9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aa1:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801aa5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa9:	48 89 d7             	mov    %rdx,%rdi
  801aac:	48 89 c1             	mov    %rax,%rcx
  801aaf:	fd                   	std    
  801ab0:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801ab2:	fc                   	cld    
  801ab3:	eb 57                	jmp    801b0c <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801ab5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ab9:	83 e0 03             	and    $0x3,%eax
  801abc:	48 85 c0             	test   %rax,%rax
  801abf:	75 36                	jne    801af7 <memmove+0xfc>
  801ac1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ac5:	83 e0 03             	and    $0x3,%eax
  801ac8:	48 85 c0             	test   %rax,%rax
  801acb:	75 2a                	jne    801af7 <memmove+0xfc>
  801acd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ad1:	83 e0 03             	and    $0x3,%eax
  801ad4:	48 85 c0             	test   %rax,%rax
  801ad7:	75 1e                	jne    801af7 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801ad9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801add:	48 c1 e8 02          	shr    $0x2,%rax
  801ae1:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801ae4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ae8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801aec:	48 89 c7             	mov    %rax,%rdi
  801aef:	48 89 d6             	mov    %rdx,%rsi
  801af2:	fc                   	cld    
  801af3:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801af5:	eb 15                	jmp    801b0c <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801af7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801afb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801aff:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801b03:	48 89 c7             	mov    %rax,%rdi
  801b06:	48 89 d6             	mov    %rdx,%rsi
  801b09:	fc                   	cld    
  801b0a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801b0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801b10:	c9                   	leaveq 
  801b11:	c3                   	retq   

0000000000801b12 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801b12:	55                   	push   %rbp
  801b13:	48 89 e5             	mov    %rsp,%rbp
  801b16:	48 83 ec 18          	sub    $0x18,%rsp
  801b1a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b1e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b22:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801b26:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b2a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801b2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b32:	48 89 ce             	mov    %rcx,%rsi
  801b35:	48 89 c7             	mov    %rax,%rdi
  801b38:	48 b8 fb 19 80 00 00 	movabs $0x8019fb,%rax
  801b3f:	00 00 00 
  801b42:	ff d0                	callq  *%rax
}
  801b44:	c9                   	leaveq 
  801b45:	c3                   	retq   

0000000000801b46 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801b46:	55                   	push   %rbp
  801b47:	48 89 e5             	mov    %rsp,%rbp
  801b4a:	48 83 ec 28          	sub    $0x28,%rsp
  801b4e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b52:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801b56:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801b5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b5e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801b62:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b66:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801b6a:	eb 36                	jmp    801ba2 <memcmp+0x5c>
		if (*s1 != *s2)
  801b6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b70:	0f b6 10             	movzbl (%rax),%edx
  801b73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b77:	0f b6 00             	movzbl (%rax),%eax
  801b7a:	38 c2                	cmp    %al,%dl
  801b7c:	74 1a                	je     801b98 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801b7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b82:	0f b6 00             	movzbl (%rax),%eax
  801b85:	0f b6 d0             	movzbl %al,%edx
  801b88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b8c:	0f b6 00             	movzbl (%rax),%eax
  801b8f:	0f b6 c0             	movzbl %al,%eax
  801b92:	29 c2                	sub    %eax,%edx
  801b94:	89 d0                	mov    %edx,%eax
  801b96:	eb 20                	jmp    801bb8 <memcmp+0x72>
		s1++, s2++;
  801b98:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b9d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801ba2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ba6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801baa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801bae:	48 85 c0             	test   %rax,%rax
  801bb1:	75 b9                	jne    801b6c <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801bb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bb8:	c9                   	leaveq 
  801bb9:	c3                   	retq   

0000000000801bba <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801bba:	55                   	push   %rbp
  801bbb:	48 89 e5             	mov    %rsp,%rbp
  801bbe:	48 83 ec 28          	sub    $0x28,%rsp
  801bc2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801bc6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801bc9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801bcd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bd1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801bd5:	48 01 d0             	add    %rdx,%rax
  801bd8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801bdc:	eb 15                	jmp    801bf3 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801bde:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801be2:	0f b6 10             	movzbl (%rax),%edx
  801be5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801be8:	38 c2                	cmp    %al,%dl
  801bea:	75 02                	jne    801bee <memfind+0x34>
			break;
  801bec:	eb 0f                	jmp    801bfd <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801bee:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801bf3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bf7:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801bfb:	72 e1                	jb     801bde <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801bfd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801c01:	c9                   	leaveq 
  801c02:	c3                   	retq   

0000000000801c03 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801c03:	55                   	push   %rbp
  801c04:	48 89 e5             	mov    %rsp,%rbp
  801c07:	48 83 ec 34          	sub    $0x34,%rsp
  801c0b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801c0f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801c13:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801c16:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801c1d:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801c24:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c25:	eb 05                	jmp    801c2c <strtol+0x29>
		s++;
  801c27:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c2c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c30:	0f b6 00             	movzbl (%rax),%eax
  801c33:	3c 20                	cmp    $0x20,%al
  801c35:	74 f0                	je     801c27 <strtol+0x24>
  801c37:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c3b:	0f b6 00             	movzbl (%rax),%eax
  801c3e:	3c 09                	cmp    $0x9,%al
  801c40:	74 e5                	je     801c27 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c46:	0f b6 00             	movzbl (%rax),%eax
  801c49:	3c 2b                	cmp    $0x2b,%al
  801c4b:	75 07                	jne    801c54 <strtol+0x51>
		s++;
  801c4d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801c52:	eb 17                	jmp    801c6b <strtol+0x68>
	else if (*s == '-')
  801c54:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c58:	0f b6 00             	movzbl (%rax),%eax
  801c5b:	3c 2d                	cmp    $0x2d,%al
  801c5d:	75 0c                	jne    801c6b <strtol+0x68>
		s++, neg = 1;
  801c5f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801c64:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801c6b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801c6f:	74 06                	je     801c77 <strtol+0x74>
  801c71:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801c75:	75 28                	jne    801c9f <strtol+0x9c>
  801c77:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c7b:	0f b6 00             	movzbl (%rax),%eax
  801c7e:	3c 30                	cmp    $0x30,%al
  801c80:	75 1d                	jne    801c9f <strtol+0x9c>
  801c82:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c86:	48 83 c0 01          	add    $0x1,%rax
  801c8a:	0f b6 00             	movzbl (%rax),%eax
  801c8d:	3c 78                	cmp    $0x78,%al
  801c8f:	75 0e                	jne    801c9f <strtol+0x9c>
		s += 2, base = 16;
  801c91:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801c96:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801c9d:	eb 2c                	jmp    801ccb <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801c9f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801ca3:	75 19                	jne    801cbe <strtol+0xbb>
  801ca5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ca9:	0f b6 00             	movzbl (%rax),%eax
  801cac:	3c 30                	cmp    $0x30,%al
  801cae:	75 0e                	jne    801cbe <strtol+0xbb>
		s++, base = 8;
  801cb0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801cb5:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801cbc:	eb 0d                	jmp    801ccb <strtol+0xc8>
	else if (base == 0)
  801cbe:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801cc2:	75 07                	jne    801ccb <strtol+0xc8>
		base = 10;
  801cc4:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801ccb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ccf:	0f b6 00             	movzbl (%rax),%eax
  801cd2:	3c 2f                	cmp    $0x2f,%al
  801cd4:	7e 1d                	jle    801cf3 <strtol+0xf0>
  801cd6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cda:	0f b6 00             	movzbl (%rax),%eax
  801cdd:	3c 39                	cmp    $0x39,%al
  801cdf:	7f 12                	jg     801cf3 <strtol+0xf0>
			dig = *s - '0';
  801ce1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ce5:	0f b6 00             	movzbl (%rax),%eax
  801ce8:	0f be c0             	movsbl %al,%eax
  801ceb:	83 e8 30             	sub    $0x30,%eax
  801cee:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801cf1:	eb 4e                	jmp    801d41 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801cf3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cf7:	0f b6 00             	movzbl (%rax),%eax
  801cfa:	3c 60                	cmp    $0x60,%al
  801cfc:	7e 1d                	jle    801d1b <strtol+0x118>
  801cfe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d02:	0f b6 00             	movzbl (%rax),%eax
  801d05:	3c 7a                	cmp    $0x7a,%al
  801d07:	7f 12                	jg     801d1b <strtol+0x118>
			dig = *s - 'a' + 10;
  801d09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d0d:	0f b6 00             	movzbl (%rax),%eax
  801d10:	0f be c0             	movsbl %al,%eax
  801d13:	83 e8 57             	sub    $0x57,%eax
  801d16:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d19:	eb 26                	jmp    801d41 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801d1b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d1f:	0f b6 00             	movzbl (%rax),%eax
  801d22:	3c 40                	cmp    $0x40,%al
  801d24:	7e 48                	jle    801d6e <strtol+0x16b>
  801d26:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d2a:	0f b6 00             	movzbl (%rax),%eax
  801d2d:	3c 5a                	cmp    $0x5a,%al
  801d2f:	7f 3d                	jg     801d6e <strtol+0x16b>
			dig = *s - 'A' + 10;
  801d31:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d35:	0f b6 00             	movzbl (%rax),%eax
  801d38:	0f be c0             	movsbl %al,%eax
  801d3b:	83 e8 37             	sub    $0x37,%eax
  801d3e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801d41:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d44:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801d47:	7c 02                	jl     801d4b <strtol+0x148>
			break;
  801d49:	eb 23                	jmp    801d6e <strtol+0x16b>
		s++, val = (val * base) + dig;
  801d4b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801d50:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801d53:	48 98                	cltq   
  801d55:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801d5a:	48 89 c2             	mov    %rax,%rdx
  801d5d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d60:	48 98                	cltq   
  801d62:	48 01 d0             	add    %rdx,%rax
  801d65:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801d69:	e9 5d ff ff ff       	jmpq   801ccb <strtol+0xc8>

	if (endptr)
  801d6e:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801d73:	74 0b                	je     801d80 <strtol+0x17d>
		*endptr = (char *) s;
  801d75:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d79:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801d7d:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801d80:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d84:	74 09                	je     801d8f <strtol+0x18c>
  801d86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d8a:	48 f7 d8             	neg    %rax
  801d8d:	eb 04                	jmp    801d93 <strtol+0x190>
  801d8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801d93:	c9                   	leaveq 
  801d94:	c3                   	retq   

0000000000801d95 <strstr>:

char * strstr(const char *in, const char *str)
{
  801d95:	55                   	push   %rbp
  801d96:	48 89 e5             	mov    %rsp,%rbp
  801d99:	48 83 ec 30          	sub    $0x30,%rsp
  801d9d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801da1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801da5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801da9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801dad:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801db1:	0f b6 00             	movzbl (%rax),%eax
  801db4:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801db7:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801dbb:	75 06                	jne    801dc3 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801dbd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dc1:	eb 6b                	jmp    801e2e <strstr+0x99>

	len = strlen(str);
  801dc3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801dc7:	48 89 c7             	mov    %rax,%rdi
  801dca:	48 b8 6b 16 80 00 00 	movabs $0x80166b,%rax
  801dd1:	00 00 00 
  801dd4:	ff d0                	callq  *%rax
  801dd6:	48 98                	cltq   
  801dd8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801ddc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801de0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801de4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801de8:	0f b6 00             	movzbl (%rax),%eax
  801deb:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801dee:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801df2:	75 07                	jne    801dfb <strstr+0x66>
				return (char *) 0;
  801df4:	b8 00 00 00 00       	mov    $0x0,%eax
  801df9:	eb 33                	jmp    801e2e <strstr+0x99>
		} while (sc != c);
  801dfb:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801dff:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801e02:	75 d8                	jne    801ddc <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801e04:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e08:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801e0c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e10:	48 89 ce             	mov    %rcx,%rsi
  801e13:	48 89 c7             	mov    %rax,%rdi
  801e16:	48 b8 8c 18 80 00 00 	movabs $0x80188c,%rax
  801e1d:	00 00 00 
  801e20:	ff d0                	callq  *%rax
  801e22:	85 c0                	test   %eax,%eax
  801e24:	75 b6                	jne    801ddc <strstr+0x47>

	return (char *) (in - 1);
  801e26:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e2a:	48 83 e8 01          	sub    $0x1,%rax
}
  801e2e:	c9                   	leaveq 
  801e2f:	c3                   	retq   

0000000000801e30 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801e30:	55                   	push   %rbp
  801e31:	48 89 e5             	mov    %rsp,%rbp
  801e34:	53                   	push   %rbx
  801e35:	48 83 ec 48          	sub    $0x48,%rsp
  801e39:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801e3c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801e3f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801e43:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801e47:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801e4b:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  801e4f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801e52:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801e56:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801e5a:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801e5e:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801e62:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801e66:	4c 89 c3             	mov    %r8,%rbx
  801e69:	cd 30                	int    $0x30
  801e6b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  801e6f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801e73:	74 3e                	je     801eb3 <syscall+0x83>
  801e75:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801e7a:	7e 37                	jle    801eb3 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801e7c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801e80:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801e83:	49 89 d0             	mov    %rdx,%r8
  801e86:	89 c1                	mov    %eax,%ecx
  801e88:	48 ba 68 53 80 00 00 	movabs $0x805368,%rdx
  801e8f:	00 00 00 
  801e92:	be 4a 00 00 00       	mov    $0x4a,%esi
  801e97:	48 bf 85 53 80 00 00 	movabs $0x805385,%rdi
  801e9e:	00 00 00 
  801ea1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea6:	49 b9 e9 08 80 00 00 	movabs $0x8008e9,%r9
  801ead:	00 00 00 
  801eb0:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  801eb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801eb7:	48 83 c4 48          	add    $0x48,%rsp
  801ebb:	5b                   	pop    %rbx
  801ebc:	5d                   	pop    %rbp
  801ebd:	c3                   	retq   

0000000000801ebe <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801ebe:	55                   	push   %rbp
  801ebf:	48 89 e5             	mov    %rsp,%rbp
  801ec2:	48 83 ec 20          	sub    $0x20,%rsp
  801ec6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801eca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801ece:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ed2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ed6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801edd:	00 
  801ede:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ee4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801eea:	48 89 d1             	mov    %rdx,%rcx
  801eed:	48 89 c2             	mov    %rax,%rdx
  801ef0:	be 00 00 00 00       	mov    $0x0,%esi
  801ef5:	bf 00 00 00 00       	mov    $0x0,%edi
  801efa:	48 b8 30 1e 80 00 00 	movabs $0x801e30,%rax
  801f01:	00 00 00 
  801f04:	ff d0                	callq  *%rax
}
  801f06:	c9                   	leaveq 
  801f07:	c3                   	retq   

0000000000801f08 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f08:	55                   	push   %rbp
  801f09:	48 89 e5             	mov    %rsp,%rbp
  801f0c:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801f10:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f17:	00 
  801f18:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f1e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f24:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f29:	ba 00 00 00 00       	mov    $0x0,%edx
  801f2e:	be 00 00 00 00       	mov    $0x0,%esi
  801f33:	bf 01 00 00 00       	mov    $0x1,%edi
  801f38:	48 b8 30 1e 80 00 00 	movabs $0x801e30,%rax
  801f3f:	00 00 00 
  801f42:	ff d0                	callq  *%rax
}
  801f44:	c9                   	leaveq 
  801f45:	c3                   	retq   

0000000000801f46 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801f46:	55                   	push   %rbp
  801f47:	48 89 e5             	mov    %rsp,%rbp
  801f4a:	48 83 ec 10          	sub    $0x10,%rsp
  801f4e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801f51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f54:	48 98                	cltq   
  801f56:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f5d:	00 
  801f5e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f64:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f6a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f6f:	48 89 c2             	mov    %rax,%rdx
  801f72:	be 01 00 00 00       	mov    $0x1,%esi
  801f77:	bf 03 00 00 00       	mov    $0x3,%edi
  801f7c:	48 b8 30 1e 80 00 00 	movabs $0x801e30,%rax
  801f83:	00 00 00 
  801f86:	ff d0                	callq  *%rax
}
  801f88:	c9                   	leaveq 
  801f89:	c3                   	retq   

0000000000801f8a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801f8a:	55                   	push   %rbp
  801f8b:	48 89 e5             	mov    %rsp,%rbp
  801f8e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801f92:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f99:	00 
  801f9a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fa0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fa6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fab:	ba 00 00 00 00       	mov    $0x0,%edx
  801fb0:	be 00 00 00 00       	mov    $0x0,%esi
  801fb5:	bf 02 00 00 00       	mov    $0x2,%edi
  801fba:	48 b8 30 1e 80 00 00 	movabs $0x801e30,%rax
  801fc1:	00 00 00 
  801fc4:	ff d0                	callq  *%rax
}
  801fc6:	c9                   	leaveq 
  801fc7:	c3                   	retq   

0000000000801fc8 <sys_yield>:

void
sys_yield(void)
{
  801fc8:	55                   	push   %rbp
  801fc9:	48 89 e5             	mov    %rsp,%rbp
  801fcc:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801fd0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fd7:	00 
  801fd8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fde:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fe4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fe9:	ba 00 00 00 00       	mov    $0x0,%edx
  801fee:	be 00 00 00 00       	mov    $0x0,%esi
  801ff3:	bf 0b 00 00 00       	mov    $0xb,%edi
  801ff8:	48 b8 30 1e 80 00 00 	movabs $0x801e30,%rax
  801fff:	00 00 00 
  802002:	ff d0                	callq  *%rax
}
  802004:	c9                   	leaveq 
  802005:	c3                   	retq   

0000000000802006 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802006:	55                   	push   %rbp
  802007:	48 89 e5             	mov    %rsp,%rbp
  80200a:	48 83 ec 20          	sub    $0x20,%rsp
  80200e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802011:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802015:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802018:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80201b:	48 63 c8             	movslq %eax,%rcx
  80201e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802022:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802025:	48 98                	cltq   
  802027:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80202e:	00 
  80202f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802035:	49 89 c8             	mov    %rcx,%r8
  802038:	48 89 d1             	mov    %rdx,%rcx
  80203b:	48 89 c2             	mov    %rax,%rdx
  80203e:	be 01 00 00 00       	mov    $0x1,%esi
  802043:	bf 04 00 00 00       	mov    $0x4,%edi
  802048:	48 b8 30 1e 80 00 00 	movabs $0x801e30,%rax
  80204f:	00 00 00 
  802052:	ff d0                	callq  *%rax
}
  802054:	c9                   	leaveq 
  802055:	c3                   	retq   

0000000000802056 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802056:	55                   	push   %rbp
  802057:	48 89 e5             	mov    %rsp,%rbp
  80205a:	48 83 ec 30          	sub    $0x30,%rsp
  80205e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802061:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802065:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802068:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80206c:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  802070:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802073:	48 63 c8             	movslq %eax,%rcx
  802076:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80207a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80207d:	48 63 f0             	movslq %eax,%rsi
  802080:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802084:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802087:	48 98                	cltq   
  802089:	48 89 0c 24          	mov    %rcx,(%rsp)
  80208d:	49 89 f9             	mov    %rdi,%r9
  802090:	49 89 f0             	mov    %rsi,%r8
  802093:	48 89 d1             	mov    %rdx,%rcx
  802096:	48 89 c2             	mov    %rax,%rdx
  802099:	be 01 00 00 00       	mov    $0x1,%esi
  80209e:	bf 05 00 00 00       	mov    $0x5,%edi
  8020a3:	48 b8 30 1e 80 00 00 	movabs $0x801e30,%rax
  8020aa:	00 00 00 
  8020ad:	ff d0                	callq  *%rax
}
  8020af:	c9                   	leaveq 
  8020b0:	c3                   	retq   

00000000008020b1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8020b1:	55                   	push   %rbp
  8020b2:	48 89 e5             	mov    %rsp,%rbp
  8020b5:	48 83 ec 20          	sub    $0x20,%rsp
  8020b9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020bc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8020c0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020c7:	48 98                	cltq   
  8020c9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020d0:	00 
  8020d1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020d7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020dd:	48 89 d1             	mov    %rdx,%rcx
  8020e0:	48 89 c2             	mov    %rax,%rdx
  8020e3:	be 01 00 00 00       	mov    $0x1,%esi
  8020e8:	bf 06 00 00 00       	mov    $0x6,%edi
  8020ed:	48 b8 30 1e 80 00 00 	movabs $0x801e30,%rax
  8020f4:	00 00 00 
  8020f7:	ff d0                	callq  *%rax
}
  8020f9:	c9                   	leaveq 
  8020fa:	c3                   	retq   

00000000008020fb <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8020fb:	55                   	push   %rbp
  8020fc:	48 89 e5             	mov    %rsp,%rbp
  8020ff:	48 83 ec 10          	sub    $0x10,%rsp
  802103:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802106:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802109:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80210c:	48 63 d0             	movslq %eax,%rdx
  80210f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802112:	48 98                	cltq   
  802114:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80211b:	00 
  80211c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802122:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802128:	48 89 d1             	mov    %rdx,%rcx
  80212b:	48 89 c2             	mov    %rax,%rdx
  80212e:	be 01 00 00 00       	mov    $0x1,%esi
  802133:	bf 08 00 00 00       	mov    $0x8,%edi
  802138:	48 b8 30 1e 80 00 00 	movabs $0x801e30,%rax
  80213f:	00 00 00 
  802142:	ff d0                	callq  *%rax
}
  802144:	c9                   	leaveq 
  802145:	c3                   	retq   

0000000000802146 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802146:	55                   	push   %rbp
  802147:	48 89 e5             	mov    %rsp,%rbp
  80214a:	48 83 ec 20          	sub    $0x20,%rsp
  80214e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802151:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802155:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802159:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80215c:	48 98                	cltq   
  80215e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802165:	00 
  802166:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80216c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802172:	48 89 d1             	mov    %rdx,%rcx
  802175:	48 89 c2             	mov    %rax,%rdx
  802178:	be 01 00 00 00       	mov    $0x1,%esi
  80217d:	bf 09 00 00 00       	mov    $0x9,%edi
  802182:	48 b8 30 1e 80 00 00 	movabs $0x801e30,%rax
  802189:	00 00 00 
  80218c:	ff d0                	callq  *%rax
}
  80218e:	c9                   	leaveq 
  80218f:	c3                   	retq   

0000000000802190 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802190:	55                   	push   %rbp
  802191:	48 89 e5             	mov    %rsp,%rbp
  802194:	48 83 ec 20          	sub    $0x20,%rsp
  802198:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80219b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80219f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021a6:	48 98                	cltq   
  8021a8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021af:	00 
  8021b0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021b6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021bc:	48 89 d1             	mov    %rdx,%rcx
  8021bf:	48 89 c2             	mov    %rax,%rdx
  8021c2:	be 01 00 00 00       	mov    $0x1,%esi
  8021c7:	bf 0a 00 00 00       	mov    $0xa,%edi
  8021cc:	48 b8 30 1e 80 00 00 	movabs $0x801e30,%rax
  8021d3:	00 00 00 
  8021d6:	ff d0                	callq  *%rax
}
  8021d8:	c9                   	leaveq 
  8021d9:	c3                   	retq   

00000000008021da <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8021da:	55                   	push   %rbp
  8021db:	48 89 e5             	mov    %rsp,%rbp
  8021de:	48 83 ec 20          	sub    $0x20,%rsp
  8021e2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8021e5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8021e9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8021ed:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8021f0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021f3:	48 63 f0             	movslq %eax,%rsi
  8021f6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8021fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021fd:	48 98                	cltq   
  8021ff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802203:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80220a:	00 
  80220b:	49 89 f1             	mov    %rsi,%r9
  80220e:	49 89 c8             	mov    %rcx,%r8
  802211:	48 89 d1             	mov    %rdx,%rcx
  802214:	48 89 c2             	mov    %rax,%rdx
  802217:	be 00 00 00 00       	mov    $0x0,%esi
  80221c:	bf 0c 00 00 00       	mov    $0xc,%edi
  802221:	48 b8 30 1e 80 00 00 	movabs $0x801e30,%rax
  802228:	00 00 00 
  80222b:	ff d0                	callq  *%rax
}
  80222d:	c9                   	leaveq 
  80222e:	c3                   	retq   

000000000080222f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80222f:	55                   	push   %rbp
  802230:	48 89 e5             	mov    %rsp,%rbp
  802233:	48 83 ec 10          	sub    $0x10,%rsp
  802237:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80223b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80223f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802246:	00 
  802247:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80224d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802253:	b9 00 00 00 00       	mov    $0x0,%ecx
  802258:	48 89 c2             	mov    %rax,%rdx
  80225b:	be 01 00 00 00       	mov    $0x1,%esi
  802260:	bf 0d 00 00 00       	mov    $0xd,%edi
  802265:	48 b8 30 1e 80 00 00 	movabs $0x801e30,%rax
  80226c:	00 00 00 
  80226f:	ff d0                	callq  *%rax
}
  802271:	c9                   	leaveq 
  802272:	c3                   	retq   

0000000000802273 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  802273:	55                   	push   %rbp
  802274:	48 89 e5             	mov    %rsp,%rbp
  802277:	53                   	push   %rbx
  802278:	48 83 ec 48          	sub    $0x48,%rsp
  80227c:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  802280:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  802284:	48 8b 00             	mov    (%rax),%rax
  802287:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	uint32_t err = utf->utf_err;
  80228b:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80228f:	48 8b 40 08          	mov    0x8(%rax),%rax
  802293:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	pte_t pte = uvpt[VPN(addr)];
  802296:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80229a:	48 c1 e8 0c          	shr    $0xc,%rax
  80229e:	48 89 c2             	mov    %rax,%rdx
  8022a1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022a8:	01 00 00 
  8022ab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022af:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	envid_t pid = sys_getenvid();
  8022b3:	48 b8 8a 1f 80 00 00 	movabs $0x801f8a,%rax
  8022ba:	00 00 00 
  8022bd:	ff d0                	callq  *%rax
  8022bf:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	void* va = ROUNDDOWN(addr, PGSIZE);
  8022c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c6:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  8022ca:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8022ce:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8022d4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	if((err & FEC_WR) && (pte & PTE_COW)){
  8022d8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8022db:	83 e0 02             	and    $0x2,%eax
  8022de:	85 c0                	test   %eax,%eax
  8022e0:	0f 84 8d 00 00 00    	je     802373 <pgfault+0x100>
  8022e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022ea:	25 00 08 00 00       	and    $0x800,%eax
  8022ef:	48 85 c0             	test   %rax,%rax
  8022f2:	74 7f                	je     802373 <pgfault+0x100>
		if(!sys_page_alloc(pid, (void*)PFTEMP, PTE_P | PTE_W | PTE_U)){
  8022f4:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8022f7:	ba 07 00 00 00       	mov    $0x7,%edx
  8022fc:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802301:	89 c7                	mov    %eax,%edi
  802303:	48 b8 06 20 80 00 00 	movabs $0x802006,%rax
  80230a:	00 00 00 
  80230d:	ff d0                	callq  *%rax
  80230f:	85 c0                	test   %eax,%eax
  802311:	75 60                	jne    802373 <pgfault+0x100>
			memmove(PFTEMP, va, PGSIZE);
  802313:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802317:	ba 00 10 00 00       	mov    $0x1000,%edx
  80231c:	48 89 c6             	mov    %rax,%rsi
  80231f:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802324:	48 b8 fb 19 80 00 00 	movabs $0x8019fb,%rax
  80232b:	00 00 00 
  80232e:	ff d0                	callq  *%rax
			if(!(sys_page_map(pid, (void*)PFTEMP, pid, va, PTE_P | PTE_W | PTE_U) | 
  802330:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802334:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802337:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80233a:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802340:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802345:	89 c7                	mov    %eax,%edi
  802347:	48 b8 56 20 80 00 00 	movabs $0x802056,%rax
  80234e:	00 00 00 
  802351:	ff d0                	callq  *%rax
  802353:	89 c3                	mov    %eax,%ebx
					 sys_page_unmap(pid, (void*) PFTEMP)))
  802355:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802358:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80235d:	89 c7                	mov    %eax,%edi
  80235f:	48 b8 b1 20 80 00 00 	movabs $0x8020b1,%rax
  802366:	00 00 00 
  802369:	ff d0                	callq  *%rax
	envid_t pid = sys_getenvid();
	void* va = ROUNDDOWN(addr, PGSIZE);
	if((err & FEC_WR) && (pte & PTE_COW)){
		if(!sys_page_alloc(pid, (void*)PFTEMP, PTE_P | PTE_W | PTE_U)){
			memmove(PFTEMP, va, PGSIZE);
			if(!(sys_page_map(pid, (void*)PFTEMP, pid, va, PTE_P | PTE_W | PTE_U) | 
  80236b:	09 d8                	or     %ebx,%eax
  80236d:	85 c0                	test   %eax,%eax
  80236f:	75 02                	jne    802373 <pgfault+0x100>
					 sys_page_unmap(pid, (void*) PFTEMP)))
					return;
  802371:	eb 2a                	jmp    80239d <pgfault+0x12a>
		}
	}
	panic("Page fault handler failure\n");
  802373:	48 ba 93 53 80 00 00 	movabs $0x805393,%rdx
  80237a:	00 00 00 
  80237d:	be 26 00 00 00       	mov    $0x26,%esi
  802382:	48 bf af 53 80 00 00 	movabs $0x8053af,%rdi
  802389:	00 00 00 
  80238c:	b8 00 00 00 00       	mov    $0x0,%eax
  802391:	48 b9 e9 08 80 00 00 	movabs $0x8008e9,%rcx
  802398:	00 00 00 
  80239b:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	//panic("pgfault not implemented");
}
  80239d:	48 83 c4 48          	add    $0x48,%rsp
  8023a1:	5b                   	pop    %rbx
  8023a2:	5d                   	pop    %rbp
  8023a3:	c3                   	retq   

00000000008023a4 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8023a4:	55                   	push   %rbp
  8023a5:	48 89 e5             	mov    %rsp,%rbp
  8023a8:	53                   	push   %rbx
  8023a9:	48 83 ec 38          	sub    $0x38,%rsp
  8023ad:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8023b0:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	//struct Env *env;
	pte_t pte = uvpt[pn];
  8023b3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023ba:	01 00 00 
  8023bd:	8b 55 c8             	mov    -0x38(%rbp),%edx
  8023c0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023c4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int perm = pte & PTE_SYSCALL;
  8023c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023cc:	25 07 0e 00 00       	and    $0xe07,%eax
  8023d1:	89 45 dc             	mov    %eax,-0x24(%rbp)
	void *va = (void*)((uintptr_t)pn * PGSIZE);
  8023d4:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8023d7:	48 c1 e0 0c          	shl    $0xc,%rax
  8023db:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	if(perm & PTE_SHARE){
  8023df:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023e2:	25 00 04 00 00       	and    $0x400,%eax
  8023e7:	85 c0                	test   %eax,%eax
  8023e9:	74 30                	je     80241b <duppage+0x77>
		r = sys_page_map(0, va, envid, va, perm);
  8023eb:	8b 75 dc             	mov    -0x24(%rbp),%esi
  8023ee:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8023f2:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8023f5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023f9:	41 89 f0             	mov    %esi,%r8d
  8023fc:	48 89 c6             	mov    %rax,%rsi
  8023ff:	bf 00 00 00 00       	mov    $0x0,%edi
  802404:	48 b8 56 20 80 00 00 	movabs $0x802056,%rax
  80240b:	00 00 00 
  80240e:	ff d0                	callq  *%rax
  802410:	89 45 ec             	mov    %eax,-0x14(%rbp)
		return r;
  802413:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802416:	e9 a4 00 00 00       	jmpq   8024bf <duppage+0x11b>
	}
	//envid_t pid = sys_getenvid();
	if((perm & PTE_W) || (perm & PTE_COW)){
  80241b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80241e:	83 e0 02             	and    $0x2,%eax
  802421:	85 c0                	test   %eax,%eax
  802423:	75 0c                	jne    802431 <duppage+0x8d>
  802425:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802428:	25 00 08 00 00       	and    $0x800,%eax
  80242d:	85 c0                	test   %eax,%eax
  80242f:	74 63                	je     802494 <duppage+0xf0>
		perm &= ~PTE_W;
  802431:	83 65 dc fd          	andl   $0xfffffffd,-0x24(%rbp)
		perm |= PTE_COW;
  802435:	81 4d dc 00 08 00 00 	orl    $0x800,-0x24(%rbp)
		r = sys_page_map(0, va, envid, va, perm) | sys_page_map(0, va, 0, va, perm);
  80243c:	8b 75 dc             	mov    -0x24(%rbp),%esi
  80243f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802443:	8b 55 cc             	mov    -0x34(%rbp),%edx
  802446:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80244a:	41 89 f0             	mov    %esi,%r8d
  80244d:	48 89 c6             	mov    %rax,%rsi
  802450:	bf 00 00 00 00       	mov    $0x0,%edi
  802455:	48 b8 56 20 80 00 00 	movabs $0x802056,%rax
  80245c:	00 00 00 
  80245f:	ff d0                	callq  *%rax
  802461:	89 c3                	mov    %eax,%ebx
  802463:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802466:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80246a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80246e:	41 89 c8             	mov    %ecx,%r8d
  802471:	48 89 d1             	mov    %rdx,%rcx
  802474:	ba 00 00 00 00       	mov    $0x0,%edx
  802479:	48 89 c6             	mov    %rax,%rsi
  80247c:	bf 00 00 00 00       	mov    $0x0,%edi
  802481:	48 b8 56 20 80 00 00 	movabs $0x802056,%rax
  802488:	00 00 00 
  80248b:	ff d0                	callq  *%rax
  80248d:	09 d8                	or     %ebx,%eax
  80248f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802492:	eb 28                	jmp    8024bc <duppage+0x118>
	}
	else{
		r = sys_page_map(0, va, envid, va, perm);
  802494:	8b 75 dc             	mov    -0x24(%rbp),%esi
  802497:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80249b:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80249e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024a2:	41 89 f0             	mov    %esi,%r8d
  8024a5:	48 89 c6             	mov    %rax,%rsi
  8024a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8024ad:	48 b8 56 20 80 00 00 	movabs $0x802056,%rax
  8024b4:	00 00 00 
  8024b7:	ff d0                	callq  *%rax
  8024b9:	89 45 ec             	mov    %eax,-0x14(%rbp)
	}

	// LAB 4: Your code here.
	//panic("duppage not implemented");
	//if(r != 0) panic("Duplicating page failed: %e\n", r);
	return r;
  8024bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8024bf:	48 83 c4 38          	add    $0x38,%rsp
  8024c3:	5b                   	pop    %rbx
  8024c4:	5d                   	pop    %rbp
  8024c5:	c3                   	retq   

00000000008024c6 <fork>:
//   so you must allocate a new page for the child's user exception stack.
//

envid_t
fork(void)
{
  8024c6:	55                   	push   %rbp
  8024c7:	48 89 e5             	mov    %rsp,%rbp
  8024ca:	53                   	push   %rbx
  8024cb:	48 83 ec 58          	sub    $0x58,%rsp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  8024cf:	48 bf 73 22 80 00 00 	movabs $0x802273,%rdi
  8024d6:	00 00 00 
  8024d9:	48 b8 67 49 80 00 00 	movabs $0x804967,%rax
  8024e0:	00 00 00 
  8024e3:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8024e5:	b8 07 00 00 00       	mov    $0x7,%eax
  8024ea:	cd 30                	int    $0x30
  8024ec:	89 45 a4             	mov    %eax,-0x5c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8024ef:	8b 45 a4             	mov    -0x5c(%rbp),%eax
	envid_t cid = sys_exofork();
  8024f2:	89 45 cc             	mov    %eax,-0x34(%rbp)
	if(cid < 0) panic("fork failed: %e\n", cid);
  8024f5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8024f9:	79 30                	jns    80252b <fork+0x65>
  8024fb:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8024fe:	89 c1                	mov    %eax,%ecx
  802500:	48 ba ba 53 80 00 00 	movabs $0x8053ba,%rdx
  802507:	00 00 00 
  80250a:	be 72 00 00 00       	mov    $0x72,%esi
  80250f:	48 bf af 53 80 00 00 	movabs $0x8053af,%rdi
  802516:	00 00 00 
  802519:	b8 00 00 00 00       	mov    $0x0,%eax
  80251e:	49 b8 e9 08 80 00 00 	movabs $0x8008e9,%r8
  802525:	00 00 00 
  802528:	41 ff d0             	callq  *%r8
	if(cid == 0){
  80252b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80252f:	75 46                	jne    802577 <fork+0xb1>
		thisenv = &envs[ENVX(sys_getenvid())];
  802531:	48 b8 8a 1f 80 00 00 	movabs $0x801f8a,%rax
  802538:	00 00 00 
  80253b:	ff d0                	callq  *%rax
  80253d:	25 ff 03 00 00       	and    $0x3ff,%eax
  802542:	48 63 d0             	movslq %eax,%rdx
  802545:	48 89 d0             	mov    %rdx,%rax
  802548:	48 c1 e0 03          	shl    $0x3,%rax
  80254c:	48 01 d0             	add    %rdx,%rax
  80254f:	48 c1 e0 05          	shl    $0x5,%rax
  802553:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80255a:	00 00 00 
  80255d:	48 01 c2             	add    %rax,%rdx
  802560:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802567:	00 00 00 
  80256a:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  80256d:	b8 00 00 00 00       	mov    $0x0,%eax
  802572:	e9 12 02 00 00       	jmpq   802789 <fork+0x2c3>
	}
	int result;
	if((result = sys_page_alloc(cid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802577:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80257a:	ba 07 00 00 00       	mov    $0x7,%edx
  80257f:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802584:	89 c7                	mov    %eax,%edi
  802586:	48 b8 06 20 80 00 00 	movabs $0x802006,%rax
  80258d:	00 00 00 
  802590:	ff d0                	callq  *%rax
  802592:	89 45 c8             	mov    %eax,-0x38(%rbp)
  802595:	83 7d c8 00          	cmpl   $0x0,-0x38(%rbp)
  802599:	79 30                	jns    8025cb <fork+0x105>
		panic("fork failed: %e\n", result);
  80259b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80259e:	89 c1                	mov    %eax,%ecx
  8025a0:	48 ba ba 53 80 00 00 	movabs $0x8053ba,%rdx
  8025a7:	00 00 00 
  8025aa:	be 79 00 00 00       	mov    $0x79,%esi
  8025af:	48 bf af 53 80 00 00 	movabs $0x8053af,%rdi
  8025b6:	00 00 00 
  8025b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025be:	49 b8 e9 08 80 00 00 	movabs $0x8008e9,%r8
  8025c5:	00 00 00 
  8025c8:	41 ff d0             	callq  *%r8
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  8025cb:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8025d2:	00 
  8025d3:	e9 40 01 00 00       	jmpq   802718 <fork+0x252>
		if(uvpml4e[pml4e] & PTE_P){
  8025d8:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8025df:	01 00 00 
  8025e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8025e6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025ea:	83 e0 01             	and    $0x1,%eax
  8025ed:	48 85 c0             	test   %rax,%rax
  8025f0:	0f 84 1d 01 00 00    	je     802713 <fork+0x24d>
			base_pml4e = pml4e * NPDPENTRIES;
  8025f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025fa:	48 c1 e0 09          	shl    $0x9,%rax
  8025fe:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  802602:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  802609:	00 
  80260a:	e9 f6 00 00 00       	jmpq   802705 <fork+0x23f>
				if(uvpde[base_pml4e + pdpe] & PTE_P){
  80260f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802613:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802617:	48 01 c2             	add    %rax,%rdx
  80261a:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802621:	01 00 00 
  802624:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802628:	83 e0 01             	and    $0x1,%eax
  80262b:	48 85 c0             	test   %rax,%rax
  80262e:	0f 84 cc 00 00 00    	je     802700 <fork+0x23a>
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
  802634:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802638:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80263c:	48 01 d0             	add    %rdx,%rax
  80263f:	48 c1 e0 09          	shl    $0x9,%rax
  802643:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
					for(pde = 0; pde < NPDENTRIES; pde++){
  802647:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  80264e:	00 
  80264f:	e9 9e 00 00 00       	jmpq   8026f2 <fork+0x22c>
						if(uvpd[base_pdpe + pde] & PTE_P){
  802654:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802658:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80265c:	48 01 c2             	add    %rax,%rdx
  80265f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802666:	01 00 00 
  802669:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80266d:	83 e0 01             	and    $0x1,%eax
  802670:	48 85 c0             	test   %rax,%rax
  802673:	74 78                	je     8026ed <fork+0x227>
							base_pde = (base_pdpe + pde) * NPTENTRIES;
  802675:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802679:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80267d:	48 01 d0             	add    %rdx,%rax
  802680:	48 c1 e0 09          	shl    $0x9,%rax
  802684:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
							for(pte = 0; pte < NPTENTRIES; pte++){
  802688:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  80268f:	00 
  802690:	eb 51                	jmp    8026e3 <fork+0x21d>
								entry = base_pde + pte;
  802692:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802696:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80269a:	48 01 d0             	add    %rdx,%rax
  80269d:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
								if((uvpt[entry] & PTE_P) && (entry != VPN(UXSTACKTOP - PGSIZE))){
  8026a1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026a8:	01 00 00 
  8026ab:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8026af:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026b3:	83 e0 01             	and    $0x1,%eax
  8026b6:	48 85 c0             	test   %rax,%rax
  8026b9:	74 23                	je     8026de <fork+0x218>
  8026bb:	48 81 7d a8 ff f7 0e 	cmpq   $0xef7ff,-0x58(%rbp)
  8026c2:	00 
  8026c3:	74 19                	je     8026de <fork+0x218>
									duppage(cid, entry);
  8026c5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8026c9:	89 c2                	mov    %eax,%edx
  8026cb:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8026ce:	89 d6                	mov    %edx,%esi
  8026d0:	89 c7                	mov    %eax,%edi
  8026d2:	48 b8 a4 23 80 00 00 	movabs $0x8023a4,%rax
  8026d9:	00 00 00 
  8026dc:	ff d0                	callq  *%rax
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
						if(uvpd[base_pdpe + pde] & PTE_P){
							base_pde = (base_pdpe + pde) * NPTENTRIES;
							for(pte = 0; pte < NPTENTRIES; pte++){
  8026de:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  8026e3:	48 81 7d d0 ff 01 00 	cmpq   $0x1ff,-0x30(%rbp)
  8026ea:	00 
  8026eb:	76 a5                	jbe    802692 <fork+0x1cc>
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
  8026ed:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8026f2:	48 81 7d d8 ff 01 00 	cmpq   $0x1ff,-0x28(%rbp)
  8026f9:	00 
  8026fa:	0f 86 54 ff ff ff    	jbe    802654 <fork+0x18e>
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  802700:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  802705:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  80270c:	00 
  80270d:	0f 86 fc fe ff ff    	jbe    80260f <fork+0x149>
	int result;
	if((result = sys_page_alloc(cid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		panic("fork failed: %e\n", result);
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  802713:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802718:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80271d:	0f 84 b5 fe ff ff    	je     8025d8 <fork+0x112>
					}
				}
			}
		}
	}
	if(sys_env_set_pgfault_upcall(cid, _pgfault_upcall) | sys_env_set_status(cid, ENV_RUNNABLE))
  802723:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802726:	48 be fc 49 80 00 00 	movabs $0x8049fc,%rsi
  80272d:	00 00 00 
  802730:	89 c7                	mov    %eax,%edi
  802732:	48 b8 90 21 80 00 00 	movabs $0x802190,%rax
  802739:	00 00 00 
  80273c:	ff d0                	callq  *%rax
  80273e:	89 c3                	mov    %eax,%ebx
  802740:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802743:	be 02 00 00 00       	mov    $0x2,%esi
  802748:	89 c7                	mov    %eax,%edi
  80274a:	48 b8 fb 20 80 00 00 	movabs $0x8020fb,%rax
  802751:	00 00 00 
  802754:	ff d0                	callq  *%rax
  802756:	09 d8                	or     %ebx,%eax
  802758:	85 c0                	test   %eax,%eax
  80275a:	74 2a                	je     802786 <fork+0x2c0>
		panic("fork failed\n");
  80275c:	48 ba cb 53 80 00 00 	movabs $0x8053cb,%rdx
  802763:	00 00 00 
  802766:	be 92 00 00 00       	mov    $0x92,%esi
  80276b:	48 bf af 53 80 00 00 	movabs $0x8053af,%rdi
  802772:	00 00 00 
  802775:	b8 00 00 00 00       	mov    $0x0,%eax
  80277a:	48 b9 e9 08 80 00 00 	movabs $0x8008e9,%rcx
  802781:	00 00 00 
  802784:	ff d1                	callq  *%rcx
	return cid;
  802786:	8b 45 cc             	mov    -0x34(%rbp),%eax
	//panic("fork not implemented");
}
  802789:	48 83 c4 58          	add    $0x58,%rsp
  80278d:	5b                   	pop    %rbx
  80278e:	5d                   	pop    %rbp
  80278f:	c3                   	retq   

0000000000802790 <sfork>:


// Challenge!
int
sfork(void)
{
  802790:	55                   	push   %rbp
  802791:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802794:	48 ba d8 53 80 00 00 	movabs $0x8053d8,%rdx
  80279b:	00 00 00 
  80279e:	be 9c 00 00 00       	mov    $0x9c,%esi
  8027a3:	48 bf af 53 80 00 00 	movabs $0x8053af,%rdi
  8027aa:	00 00 00 
  8027ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b2:	48 b9 e9 08 80 00 00 	movabs $0x8008e9,%rcx
  8027b9:	00 00 00 
  8027bc:	ff d1                	callq  *%rcx

00000000008027be <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8027be:	55                   	push   %rbp
  8027bf:	48 89 e5             	mov    %rsp,%rbp
  8027c2:	48 83 ec 08          	sub    $0x8,%rsp
  8027c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8027ca:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8027ce:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8027d5:	ff ff ff 
  8027d8:	48 01 d0             	add    %rdx,%rax
  8027db:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8027df:	c9                   	leaveq 
  8027e0:	c3                   	retq   

00000000008027e1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8027e1:	55                   	push   %rbp
  8027e2:	48 89 e5             	mov    %rsp,%rbp
  8027e5:	48 83 ec 08          	sub    $0x8,%rsp
  8027e9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8027ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027f1:	48 89 c7             	mov    %rax,%rdi
  8027f4:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
  8027fb:	00 00 00 
  8027fe:	ff d0                	callq  *%rax
  802800:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802806:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80280a:	c9                   	leaveq 
  80280b:	c3                   	retq   

000000000080280c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80280c:	55                   	push   %rbp
  80280d:	48 89 e5             	mov    %rsp,%rbp
  802810:	48 83 ec 18          	sub    $0x18,%rsp
  802814:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802818:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80281f:	eb 6b                	jmp    80288c <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802821:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802824:	48 98                	cltq   
  802826:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80282c:	48 c1 e0 0c          	shl    $0xc,%rax
  802830:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802834:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802838:	48 c1 e8 15          	shr    $0x15,%rax
  80283c:	48 89 c2             	mov    %rax,%rdx
  80283f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802846:	01 00 00 
  802849:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80284d:	83 e0 01             	and    $0x1,%eax
  802850:	48 85 c0             	test   %rax,%rax
  802853:	74 21                	je     802876 <fd_alloc+0x6a>
  802855:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802859:	48 c1 e8 0c          	shr    $0xc,%rax
  80285d:	48 89 c2             	mov    %rax,%rdx
  802860:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802867:	01 00 00 
  80286a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80286e:	83 e0 01             	and    $0x1,%eax
  802871:	48 85 c0             	test   %rax,%rax
  802874:	75 12                	jne    802888 <fd_alloc+0x7c>
			*fd_store = fd;
  802876:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80287a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80287e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802881:	b8 00 00 00 00       	mov    $0x0,%eax
  802886:	eb 1a                	jmp    8028a2 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802888:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80288c:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802890:	7e 8f                	jle    802821 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802892:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802896:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80289d:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8028a2:	c9                   	leaveq 
  8028a3:	c3                   	retq   

00000000008028a4 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8028a4:	55                   	push   %rbp
  8028a5:	48 89 e5             	mov    %rsp,%rbp
  8028a8:	48 83 ec 20          	sub    $0x20,%rsp
  8028ac:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028af:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8028b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8028b7:	78 06                	js     8028bf <fd_lookup+0x1b>
  8028b9:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8028bd:	7e 07                	jle    8028c6 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8028bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028c4:	eb 6c                	jmp    802932 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8028c6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028c9:	48 98                	cltq   
  8028cb:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8028d1:	48 c1 e0 0c          	shl    $0xc,%rax
  8028d5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8028d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028dd:	48 c1 e8 15          	shr    $0x15,%rax
  8028e1:	48 89 c2             	mov    %rax,%rdx
  8028e4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8028eb:	01 00 00 
  8028ee:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028f2:	83 e0 01             	and    $0x1,%eax
  8028f5:	48 85 c0             	test   %rax,%rax
  8028f8:	74 21                	je     80291b <fd_lookup+0x77>
  8028fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028fe:	48 c1 e8 0c          	shr    $0xc,%rax
  802902:	48 89 c2             	mov    %rax,%rdx
  802905:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80290c:	01 00 00 
  80290f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802913:	83 e0 01             	and    $0x1,%eax
  802916:	48 85 c0             	test   %rax,%rax
  802919:	75 07                	jne    802922 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80291b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802920:	eb 10                	jmp    802932 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802922:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802926:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80292a:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80292d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802932:	c9                   	leaveq 
  802933:	c3                   	retq   

0000000000802934 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802934:	55                   	push   %rbp
  802935:	48 89 e5             	mov    %rsp,%rbp
  802938:	48 83 ec 30          	sub    $0x30,%rsp
  80293c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802940:	89 f0                	mov    %esi,%eax
  802942:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802945:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802949:	48 89 c7             	mov    %rax,%rdi
  80294c:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
  802953:	00 00 00 
  802956:	ff d0                	callq  *%rax
  802958:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80295c:	48 89 d6             	mov    %rdx,%rsi
  80295f:	89 c7                	mov    %eax,%edi
  802961:	48 b8 a4 28 80 00 00 	movabs $0x8028a4,%rax
  802968:	00 00 00 
  80296b:	ff d0                	callq  *%rax
  80296d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802970:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802974:	78 0a                	js     802980 <fd_close+0x4c>
	    || fd != fd2)
  802976:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80297a:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80297e:	74 12                	je     802992 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802980:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802984:	74 05                	je     80298b <fd_close+0x57>
  802986:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802989:	eb 05                	jmp    802990 <fd_close+0x5c>
  80298b:	b8 00 00 00 00       	mov    $0x0,%eax
  802990:	eb 69                	jmp    8029fb <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802992:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802996:	8b 00                	mov    (%rax),%eax
  802998:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80299c:	48 89 d6             	mov    %rdx,%rsi
  80299f:	89 c7                	mov    %eax,%edi
  8029a1:	48 b8 fd 29 80 00 00 	movabs $0x8029fd,%rax
  8029a8:	00 00 00 
  8029ab:	ff d0                	callq  *%rax
  8029ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029b4:	78 2a                	js     8029e0 <fd_close+0xac>
		if (dev->dev_close)
  8029b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029ba:	48 8b 40 20          	mov    0x20(%rax),%rax
  8029be:	48 85 c0             	test   %rax,%rax
  8029c1:	74 16                	je     8029d9 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8029c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029c7:	48 8b 40 20          	mov    0x20(%rax),%rax
  8029cb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029cf:	48 89 d7             	mov    %rdx,%rdi
  8029d2:	ff d0                	callq  *%rax
  8029d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029d7:	eb 07                	jmp    8029e0 <fd_close+0xac>
		else
			r = 0;
  8029d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8029e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029e4:	48 89 c6             	mov    %rax,%rsi
  8029e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8029ec:	48 b8 b1 20 80 00 00 	movabs $0x8020b1,%rax
  8029f3:	00 00 00 
  8029f6:	ff d0                	callq  *%rax
	return r;
  8029f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029fb:	c9                   	leaveq 
  8029fc:	c3                   	retq   

00000000008029fd <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8029fd:	55                   	push   %rbp
  8029fe:	48 89 e5             	mov    %rsp,%rbp
  802a01:	48 83 ec 20          	sub    $0x20,%rsp
  802a05:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a08:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802a0c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a13:	eb 41                	jmp    802a56 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802a15:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802a1c:	00 00 00 
  802a1f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a22:	48 63 d2             	movslq %edx,%rdx
  802a25:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a29:	8b 00                	mov    (%rax),%eax
  802a2b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802a2e:	75 22                	jne    802a52 <dev_lookup+0x55>
			*dev = devtab[i];
  802a30:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802a37:	00 00 00 
  802a3a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a3d:	48 63 d2             	movslq %edx,%rdx
  802a40:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802a44:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a48:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802a4b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a50:	eb 60                	jmp    802ab2 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802a52:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a56:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802a5d:	00 00 00 
  802a60:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a63:	48 63 d2             	movslq %edx,%rdx
  802a66:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a6a:	48 85 c0             	test   %rax,%rax
  802a6d:	75 a6                	jne    802a15 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802a6f:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802a76:	00 00 00 
  802a79:	48 8b 00             	mov    (%rax),%rax
  802a7c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a82:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802a85:	89 c6                	mov    %eax,%esi
  802a87:	48 bf f0 53 80 00 00 	movabs $0x8053f0,%rdi
  802a8e:	00 00 00 
  802a91:	b8 00 00 00 00       	mov    $0x0,%eax
  802a96:	48 b9 22 0b 80 00 00 	movabs $0x800b22,%rcx
  802a9d:	00 00 00 
  802aa0:	ff d1                	callq  *%rcx
	*dev = 0;
  802aa2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802aa6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802aad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802ab2:	c9                   	leaveq 
  802ab3:	c3                   	retq   

0000000000802ab4 <close>:

int
close(int fdnum)
{
  802ab4:	55                   	push   %rbp
  802ab5:	48 89 e5             	mov    %rsp,%rbp
  802ab8:	48 83 ec 20          	sub    $0x20,%rsp
  802abc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802abf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ac3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ac6:	48 89 d6             	mov    %rdx,%rsi
  802ac9:	89 c7                	mov    %eax,%edi
  802acb:	48 b8 a4 28 80 00 00 	movabs $0x8028a4,%rax
  802ad2:	00 00 00 
  802ad5:	ff d0                	callq  *%rax
  802ad7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ada:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ade:	79 05                	jns    802ae5 <close+0x31>
		return r;
  802ae0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae3:	eb 18                	jmp    802afd <close+0x49>
	else
		return fd_close(fd, 1);
  802ae5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ae9:	be 01 00 00 00       	mov    $0x1,%esi
  802aee:	48 89 c7             	mov    %rax,%rdi
  802af1:	48 b8 34 29 80 00 00 	movabs $0x802934,%rax
  802af8:	00 00 00 
  802afb:	ff d0                	callq  *%rax
}
  802afd:	c9                   	leaveq 
  802afe:	c3                   	retq   

0000000000802aff <close_all>:

void
close_all(void)
{
  802aff:	55                   	push   %rbp
  802b00:	48 89 e5             	mov    %rsp,%rbp
  802b03:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802b07:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b0e:	eb 15                	jmp    802b25 <close_all+0x26>
		close(i);
  802b10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b13:	89 c7                	mov    %eax,%edi
  802b15:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  802b1c:	00 00 00 
  802b1f:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802b21:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802b25:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802b29:	7e e5                	jle    802b10 <close_all+0x11>
		close(i);
}
  802b2b:	c9                   	leaveq 
  802b2c:	c3                   	retq   

0000000000802b2d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802b2d:	55                   	push   %rbp
  802b2e:	48 89 e5             	mov    %rsp,%rbp
  802b31:	48 83 ec 40          	sub    $0x40,%rsp
  802b35:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802b38:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802b3b:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802b3f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802b42:	48 89 d6             	mov    %rdx,%rsi
  802b45:	89 c7                	mov    %eax,%edi
  802b47:	48 b8 a4 28 80 00 00 	movabs $0x8028a4,%rax
  802b4e:	00 00 00 
  802b51:	ff d0                	callq  *%rax
  802b53:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b56:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b5a:	79 08                	jns    802b64 <dup+0x37>
		return r;
  802b5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b5f:	e9 70 01 00 00       	jmpq   802cd4 <dup+0x1a7>
	close(newfdnum);
  802b64:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802b67:	89 c7                	mov    %eax,%edi
  802b69:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  802b70:	00 00 00 
  802b73:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802b75:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802b78:	48 98                	cltq   
  802b7a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802b80:	48 c1 e0 0c          	shl    $0xc,%rax
  802b84:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802b88:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b8c:	48 89 c7             	mov    %rax,%rdi
  802b8f:	48 b8 e1 27 80 00 00 	movabs $0x8027e1,%rax
  802b96:	00 00 00 
  802b99:	ff d0                	callq  *%rax
  802b9b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802b9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ba3:	48 89 c7             	mov    %rax,%rdi
  802ba6:	48 b8 e1 27 80 00 00 	movabs $0x8027e1,%rax
  802bad:	00 00 00 
  802bb0:	ff d0                	callq  *%rax
  802bb2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802bb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bba:	48 c1 e8 15          	shr    $0x15,%rax
  802bbe:	48 89 c2             	mov    %rax,%rdx
  802bc1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802bc8:	01 00 00 
  802bcb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bcf:	83 e0 01             	and    $0x1,%eax
  802bd2:	48 85 c0             	test   %rax,%rax
  802bd5:	74 73                	je     802c4a <dup+0x11d>
  802bd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bdb:	48 c1 e8 0c          	shr    $0xc,%rax
  802bdf:	48 89 c2             	mov    %rax,%rdx
  802be2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802be9:	01 00 00 
  802bec:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bf0:	83 e0 01             	and    $0x1,%eax
  802bf3:	48 85 c0             	test   %rax,%rax
  802bf6:	74 52                	je     802c4a <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802bf8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bfc:	48 c1 e8 0c          	shr    $0xc,%rax
  802c00:	48 89 c2             	mov    %rax,%rdx
  802c03:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c0a:	01 00 00 
  802c0d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c11:	25 07 0e 00 00       	and    $0xe07,%eax
  802c16:	89 c1                	mov    %eax,%ecx
  802c18:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c20:	41 89 c8             	mov    %ecx,%r8d
  802c23:	48 89 d1             	mov    %rdx,%rcx
  802c26:	ba 00 00 00 00       	mov    $0x0,%edx
  802c2b:	48 89 c6             	mov    %rax,%rsi
  802c2e:	bf 00 00 00 00       	mov    $0x0,%edi
  802c33:	48 b8 56 20 80 00 00 	movabs $0x802056,%rax
  802c3a:	00 00 00 
  802c3d:	ff d0                	callq  *%rax
  802c3f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c42:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c46:	79 02                	jns    802c4a <dup+0x11d>
			goto err;
  802c48:	eb 57                	jmp    802ca1 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802c4a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c4e:	48 c1 e8 0c          	shr    $0xc,%rax
  802c52:	48 89 c2             	mov    %rax,%rdx
  802c55:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c5c:	01 00 00 
  802c5f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c63:	25 07 0e 00 00       	and    $0xe07,%eax
  802c68:	89 c1                	mov    %eax,%ecx
  802c6a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c6e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c72:	41 89 c8             	mov    %ecx,%r8d
  802c75:	48 89 d1             	mov    %rdx,%rcx
  802c78:	ba 00 00 00 00       	mov    $0x0,%edx
  802c7d:	48 89 c6             	mov    %rax,%rsi
  802c80:	bf 00 00 00 00       	mov    $0x0,%edi
  802c85:	48 b8 56 20 80 00 00 	movabs $0x802056,%rax
  802c8c:	00 00 00 
  802c8f:	ff d0                	callq  *%rax
  802c91:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c98:	79 02                	jns    802c9c <dup+0x16f>
		goto err;
  802c9a:	eb 05                	jmp    802ca1 <dup+0x174>

	return newfdnum;
  802c9c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802c9f:	eb 33                	jmp    802cd4 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802ca1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ca5:	48 89 c6             	mov    %rax,%rsi
  802ca8:	bf 00 00 00 00       	mov    $0x0,%edi
  802cad:	48 b8 b1 20 80 00 00 	movabs $0x8020b1,%rax
  802cb4:	00 00 00 
  802cb7:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802cb9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cbd:	48 89 c6             	mov    %rax,%rsi
  802cc0:	bf 00 00 00 00       	mov    $0x0,%edi
  802cc5:	48 b8 b1 20 80 00 00 	movabs $0x8020b1,%rax
  802ccc:	00 00 00 
  802ccf:	ff d0                	callq  *%rax
	return r;
  802cd1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802cd4:	c9                   	leaveq 
  802cd5:	c3                   	retq   

0000000000802cd6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802cd6:	55                   	push   %rbp
  802cd7:	48 89 e5             	mov    %rsp,%rbp
  802cda:	48 83 ec 40          	sub    $0x40,%rsp
  802cde:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ce1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802ce5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ce9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ced:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802cf0:	48 89 d6             	mov    %rdx,%rsi
  802cf3:	89 c7                	mov    %eax,%edi
  802cf5:	48 b8 a4 28 80 00 00 	movabs $0x8028a4,%rax
  802cfc:	00 00 00 
  802cff:	ff d0                	callq  *%rax
  802d01:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d04:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d08:	78 24                	js     802d2e <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d0e:	8b 00                	mov    (%rax),%eax
  802d10:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d14:	48 89 d6             	mov    %rdx,%rsi
  802d17:	89 c7                	mov    %eax,%edi
  802d19:	48 b8 fd 29 80 00 00 	movabs $0x8029fd,%rax
  802d20:	00 00 00 
  802d23:	ff d0                	callq  *%rax
  802d25:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d28:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d2c:	79 05                	jns    802d33 <read+0x5d>
		return r;
  802d2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d31:	eb 76                	jmp    802da9 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802d33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d37:	8b 40 08             	mov    0x8(%rax),%eax
  802d3a:	83 e0 03             	and    $0x3,%eax
  802d3d:	83 f8 01             	cmp    $0x1,%eax
  802d40:	75 3a                	jne    802d7c <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802d42:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802d49:	00 00 00 
  802d4c:	48 8b 00             	mov    (%rax),%rax
  802d4f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d55:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d58:	89 c6                	mov    %eax,%esi
  802d5a:	48 bf 0f 54 80 00 00 	movabs $0x80540f,%rdi
  802d61:	00 00 00 
  802d64:	b8 00 00 00 00       	mov    $0x0,%eax
  802d69:	48 b9 22 0b 80 00 00 	movabs $0x800b22,%rcx
  802d70:	00 00 00 
  802d73:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802d75:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d7a:	eb 2d                	jmp    802da9 <read+0xd3>
	}
	if (!dev->dev_read)
  802d7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d80:	48 8b 40 10          	mov    0x10(%rax),%rax
  802d84:	48 85 c0             	test   %rax,%rax
  802d87:	75 07                	jne    802d90 <read+0xba>
		return -E_NOT_SUPP;
  802d89:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d8e:	eb 19                	jmp    802da9 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802d90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d94:	48 8b 40 10          	mov    0x10(%rax),%rax
  802d98:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802d9c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802da0:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802da4:	48 89 cf             	mov    %rcx,%rdi
  802da7:	ff d0                	callq  *%rax
}
  802da9:	c9                   	leaveq 
  802daa:	c3                   	retq   

0000000000802dab <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802dab:	55                   	push   %rbp
  802dac:	48 89 e5             	mov    %rsp,%rbp
  802daf:	48 83 ec 30          	sub    $0x30,%rsp
  802db3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802db6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802dba:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802dbe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802dc5:	eb 49                	jmp    802e10 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802dc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dca:	48 98                	cltq   
  802dcc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802dd0:	48 29 c2             	sub    %rax,%rdx
  802dd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dd6:	48 63 c8             	movslq %eax,%rcx
  802dd9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ddd:	48 01 c1             	add    %rax,%rcx
  802de0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802de3:	48 89 ce             	mov    %rcx,%rsi
  802de6:	89 c7                	mov    %eax,%edi
  802de8:	48 b8 d6 2c 80 00 00 	movabs $0x802cd6,%rax
  802def:	00 00 00 
  802df2:	ff d0                	callq  *%rax
  802df4:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802df7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802dfb:	79 05                	jns    802e02 <readn+0x57>
			return m;
  802dfd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e00:	eb 1c                	jmp    802e1e <readn+0x73>
		if (m == 0)
  802e02:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802e06:	75 02                	jne    802e0a <readn+0x5f>
			break;
  802e08:	eb 11                	jmp    802e1b <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802e0a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e0d:	01 45 fc             	add    %eax,-0x4(%rbp)
  802e10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e13:	48 98                	cltq   
  802e15:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802e19:	72 ac                	jb     802dc7 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802e1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802e1e:	c9                   	leaveq 
  802e1f:	c3                   	retq   

0000000000802e20 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802e20:	55                   	push   %rbp
  802e21:	48 89 e5             	mov    %rsp,%rbp
  802e24:	48 83 ec 40          	sub    $0x40,%rsp
  802e28:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e2b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802e2f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e33:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e37:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e3a:	48 89 d6             	mov    %rdx,%rsi
  802e3d:	89 c7                	mov    %eax,%edi
  802e3f:	48 b8 a4 28 80 00 00 	movabs $0x8028a4,%rax
  802e46:	00 00 00 
  802e49:	ff d0                	callq  *%rax
  802e4b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e52:	78 24                	js     802e78 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e58:	8b 00                	mov    (%rax),%eax
  802e5a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e5e:	48 89 d6             	mov    %rdx,%rsi
  802e61:	89 c7                	mov    %eax,%edi
  802e63:	48 b8 fd 29 80 00 00 	movabs $0x8029fd,%rax
  802e6a:	00 00 00 
  802e6d:	ff d0                	callq  *%rax
  802e6f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e72:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e76:	79 05                	jns    802e7d <write+0x5d>
		return r;
  802e78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e7b:	eb 75                	jmp    802ef2 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802e7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e81:	8b 40 08             	mov    0x8(%rax),%eax
  802e84:	83 e0 03             	and    $0x3,%eax
  802e87:	85 c0                	test   %eax,%eax
  802e89:	75 3a                	jne    802ec5 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802e8b:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802e92:	00 00 00 
  802e95:	48 8b 00             	mov    (%rax),%rax
  802e98:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e9e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ea1:	89 c6                	mov    %eax,%esi
  802ea3:	48 bf 2b 54 80 00 00 	movabs $0x80542b,%rdi
  802eaa:	00 00 00 
  802ead:	b8 00 00 00 00       	mov    $0x0,%eax
  802eb2:	48 b9 22 0b 80 00 00 	movabs $0x800b22,%rcx
  802eb9:	00 00 00 
  802ebc:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802ebe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ec3:	eb 2d                	jmp    802ef2 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802ec5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ec9:	48 8b 40 18          	mov    0x18(%rax),%rax
  802ecd:	48 85 c0             	test   %rax,%rax
  802ed0:	75 07                	jne    802ed9 <write+0xb9>
		return -E_NOT_SUPP;
  802ed2:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ed7:	eb 19                	jmp    802ef2 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802ed9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802edd:	48 8b 40 18          	mov    0x18(%rax),%rax
  802ee1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802ee5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ee9:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802eed:	48 89 cf             	mov    %rcx,%rdi
  802ef0:	ff d0                	callq  *%rax
}
  802ef2:	c9                   	leaveq 
  802ef3:	c3                   	retq   

0000000000802ef4 <seek>:

int
seek(int fdnum, off_t offset)
{
  802ef4:	55                   	push   %rbp
  802ef5:	48 89 e5             	mov    %rsp,%rbp
  802ef8:	48 83 ec 18          	sub    $0x18,%rsp
  802efc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802eff:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f02:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f06:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f09:	48 89 d6             	mov    %rdx,%rsi
  802f0c:	89 c7                	mov    %eax,%edi
  802f0e:	48 b8 a4 28 80 00 00 	movabs $0x8028a4,%rax
  802f15:	00 00 00 
  802f18:	ff d0                	callq  *%rax
  802f1a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f1d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f21:	79 05                	jns    802f28 <seek+0x34>
		return r;
  802f23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f26:	eb 0f                	jmp    802f37 <seek+0x43>
	fd->fd_offset = offset;
  802f28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f2c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f2f:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802f32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f37:	c9                   	leaveq 
  802f38:	c3                   	retq   

0000000000802f39 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802f39:	55                   	push   %rbp
  802f3a:	48 89 e5             	mov    %rsp,%rbp
  802f3d:	48 83 ec 30          	sub    $0x30,%rsp
  802f41:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f44:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f47:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f4b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f4e:	48 89 d6             	mov    %rdx,%rsi
  802f51:	89 c7                	mov    %eax,%edi
  802f53:	48 b8 a4 28 80 00 00 	movabs $0x8028a4,%rax
  802f5a:	00 00 00 
  802f5d:	ff d0                	callq  *%rax
  802f5f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f62:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f66:	78 24                	js     802f8c <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f6c:	8b 00                	mov    (%rax),%eax
  802f6e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f72:	48 89 d6             	mov    %rdx,%rsi
  802f75:	89 c7                	mov    %eax,%edi
  802f77:	48 b8 fd 29 80 00 00 	movabs $0x8029fd,%rax
  802f7e:	00 00 00 
  802f81:	ff d0                	callq  *%rax
  802f83:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f86:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f8a:	79 05                	jns    802f91 <ftruncate+0x58>
		return r;
  802f8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f8f:	eb 72                	jmp    803003 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802f91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f95:	8b 40 08             	mov    0x8(%rax),%eax
  802f98:	83 e0 03             	and    $0x3,%eax
  802f9b:	85 c0                	test   %eax,%eax
  802f9d:	75 3a                	jne    802fd9 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802f9f:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802fa6:	00 00 00 
  802fa9:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802fac:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802fb2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802fb5:	89 c6                	mov    %eax,%esi
  802fb7:	48 bf 48 54 80 00 00 	movabs $0x805448,%rdi
  802fbe:	00 00 00 
  802fc1:	b8 00 00 00 00       	mov    $0x0,%eax
  802fc6:	48 b9 22 0b 80 00 00 	movabs $0x800b22,%rcx
  802fcd:	00 00 00 
  802fd0:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802fd2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802fd7:	eb 2a                	jmp    803003 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802fd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fdd:	48 8b 40 30          	mov    0x30(%rax),%rax
  802fe1:	48 85 c0             	test   %rax,%rax
  802fe4:	75 07                	jne    802fed <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802fe6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802feb:	eb 16                	jmp    803003 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802fed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ff1:	48 8b 40 30          	mov    0x30(%rax),%rax
  802ff5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ff9:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802ffc:	89 ce                	mov    %ecx,%esi
  802ffe:	48 89 d7             	mov    %rdx,%rdi
  803001:	ff d0                	callq  *%rax
}
  803003:	c9                   	leaveq 
  803004:	c3                   	retq   

0000000000803005 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  803005:	55                   	push   %rbp
  803006:	48 89 e5             	mov    %rsp,%rbp
  803009:	48 83 ec 30          	sub    $0x30,%rsp
  80300d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803010:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803014:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803018:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80301b:	48 89 d6             	mov    %rdx,%rsi
  80301e:	89 c7                	mov    %eax,%edi
  803020:	48 b8 a4 28 80 00 00 	movabs $0x8028a4,%rax
  803027:	00 00 00 
  80302a:	ff d0                	callq  *%rax
  80302c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80302f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803033:	78 24                	js     803059 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803035:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803039:	8b 00                	mov    (%rax),%eax
  80303b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80303f:	48 89 d6             	mov    %rdx,%rsi
  803042:	89 c7                	mov    %eax,%edi
  803044:	48 b8 fd 29 80 00 00 	movabs $0x8029fd,%rax
  80304b:	00 00 00 
  80304e:	ff d0                	callq  *%rax
  803050:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803053:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803057:	79 05                	jns    80305e <fstat+0x59>
		return r;
  803059:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80305c:	eb 5e                	jmp    8030bc <fstat+0xb7>
	if (!dev->dev_stat)
  80305e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803062:	48 8b 40 28          	mov    0x28(%rax),%rax
  803066:	48 85 c0             	test   %rax,%rax
  803069:	75 07                	jne    803072 <fstat+0x6d>
		return -E_NOT_SUPP;
  80306b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803070:	eb 4a                	jmp    8030bc <fstat+0xb7>
	stat->st_name[0] = 0;
  803072:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803076:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  803079:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80307d:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  803084:	00 00 00 
	stat->st_isdir = 0;
  803087:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80308b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803092:	00 00 00 
	stat->st_dev = dev;
  803095:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803099:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80309d:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8030a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030a8:	48 8b 40 28          	mov    0x28(%rax),%rax
  8030ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8030b0:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8030b4:	48 89 ce             	mov    %rcx,%rsi
  8030b7:	48 89 d7             	mov    %rdx,%rdi
  8030ba:	ff d0                	callq  *%rax
}
  8030bc:	c9                   	leaveq 
  8030bd:	c3                   	retq   

00000000008030be <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8030be:	55                   	push   %rbp
  8030bf:	48 89 e5             	mov    %rsp,%rbp
  8030c2:	48 83 ec 20          	sub    $0x20,%rsp
  8030c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030ca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8030ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030d2:	be 00 00 00 00       	mov    $0x0,%esi
  8030d7:	48 89 c7             	mov    %rax,%rdi
  8030da:	48 b8 ac 31 80 00 00 	movabs $0x8031ac,%rax
  8030e1:	00 00 00 
  8030e4:	ff d0                	callq  *%rax
  8030e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030ed:	79 05                	jns    8030f4 <stat+0x36>
		return fd;
  8030ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030f2:	eb 2f                	jmp    803123 <stat+0x65>
	r = fstat(fd, stat);
  8030f4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8030f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030fb:	48 89 d6             	mov    %rdx,%rsi
  8030fe:	89 c7                	mov    %eax,%edi
  803100:	48 b8 05 30 80 00 00 	movabs $0x803005,%rax
  803107:	00 00 00 
  80310a:	ff d0                	callq  *%rax
  80310c:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80310f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803112:	89 c7                	mov    %eax,%edi
  803114:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  80311b:	00 00 00 
  80311e:	ff d0                	callq  *%rax
	return r;
  803120:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803123:	c9                   	leaveq 
  803124:	c3                   	retq   

0000000000803125 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803125:	55                   	push   %rbp
  803126:	48 89 e5             	mov    %rsp,%rbp
  803129:	48 83 ec 10          	sub    $0x10,%rsp
  80312d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803130:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803134:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80313b:	00 00 00 
  80313e:	8b 00                	mov    (%rax),%eax
  803140:	85 c0                	test   %eax,%eax
  803142:	75 1d                	jne    803161 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803144:	bf 01 00 00 00       	mov    $0x1,%edi
  803149:	48 b8 e9 4b 80 00 00 	movabs $0x804be9,%rax
  803150:	00 00 00 
  803153:	ff d0                	callq  *%rax
  803155:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80315c:	00 00 00 
  80315f:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803161:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803168:	00 00 00 
  80316b:	8b 00                	mov    (%rax),%eax
  80316d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803170:	b9 07 00 00 00       	mov    $0x7,%ecx
  803175:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  80317c:	00 00 00 
  80317f:	89 c7                	mov    %eax,%edi
  803181:	48 b8 4c 4b 80 00 00 	movabs $0x804b4c,%rax
  803188:	00 00 00 
  80318b:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80318d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803191:	ba 00 00 00 00       	mov    $0x0,%edx
  803196:	48 89 c6             	mov    %rax,%rsi
  803199:	bf 00 00 00 00       	mov    $0x0,%edi
  80319e:	48 b8 86 4a 80 00 00 	movabs $0x804a86,%rax
  8031a5:	00 00 00 
  8031a8:	ff d0                	callq  *%rax
}
  8031aa:	c9                   	leaveq 
  8031ab:	c3                   	retq   

00000000008031ac <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8031ac:	55                   	push   %rbp
  8031ad:	48 89 e5             	mov    %rsp,%rbp
  8031b0:	48 83 ec 20          	sub    $0x20,%rsp
  8031b4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031b8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  8031bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031bf:	48 89 c7             	mov    %rax,%rdi
  8031c2:	48 b8 6b 16 80 00 00 	movabs $0x80166b,%rax
  8031c9:	00 00 00 
  8031cc:	ff d0                	callq  *%rax
  8031ce:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8031d3:	7e 0a                	jle    8031df <open+0x33>
  8031d5:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8031da:	e9 a5 00 00 00       	jmpq   803284 <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  8031df:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8031e3:	48 89 c7             	mov    %rax,%rdi
  8031e6:	48 b8 0c 28 80 00 00 	movabs $0x80280c,%rax
  8031ed:	00 00 00 
  8031f0:	ff d0                	callq  *%rax
  8031f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031f9:	79 08                	jns    803203 <open+0x57>
		return r;
  8031fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031fe:	e9 81 00 00 00       	jmpq   803284 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  803203:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80320a:	00 00 00 
  80320d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803210:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  803216:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80321a:	48 89 c6             	mov    %rax,%rsi
  80321d:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803224:	00 00 00 
  803227:	48 b8 d7 16 80 00 00 	movabs $0x8016d7,%rax
  80322e:	00 00 00 
  803231:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  803233:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803237:	48 89 c6             	mov    %rax,%rsi
  80323a:	bf 01 00 00 00       	mov    $0x1,%edi
  80323f:	48 b8 25 31 80 00 00 	movabs $0x803125,%rax
  803246:	00 00 00 
  803249:	ff d0                	callq  *%rax
  80324b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80324e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803252:	79 1d                	jns    803271 <open+0xc5>
		fd_close(fd, 0);
  803254:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803258:	be 00 00 00 00       	mov    $0x0,%esi
  80325d:	48 89 c7             	mov    %rax,%rdi
  803260:	48 b8 34 29 80 00 00 	movabs $0x802934,%rax
  803267:	00 00 00 
  80326a:	ff d0                	callq  *%rax
		return r;
  80326c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80326f:	eb 13                	jmp    803284 <open+0xd8>
	}
	return fd2num(fd);
  803271:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803275:	48 89 c7             	mov    %rax,%rdi
  803278:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
  80327f:	00 00 00 
  803282:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  803284:	c9                   	leaveq 
  803285:	c3                   	retq   

0000000000803286 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803286:	55                   	push   %rbp
  803287:	48 89 e5             	mov    %rsp,%rbp
  80328a:	48 83 ec 10          	sub    $0x10,%rsp
  80328e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803292:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803296:	8b 50 0c             	mov    0xc(%rax),%edx
  803299:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032a0:	00 00 00 
  8032a3:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8032a5:	be 00 00 00 00       	mov    $0x0,%esi
  8032aa:	bf 06 00 00 00       	mov    $0x6,%edi
  8032af:	48 b8 25 31 80 00 00 	movabs $0x803125,%rax
  8032b6:	00 00 00 
  8032b9:	ff d0                	callq  *%rax
}
  8032bb:	c9                   	leaveq 
  8032bc:	c3                   	retq   

00000000008032bd <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8032bd:	55                   	push   %rbp
  8032be:	48 89 e5             	mov    %rsp,%rbp
  8032c1:	48 83 ec 30          	sub    $0x30,%rsp
  8032c5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032c9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032cd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8032d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032d5:	8b 50 0c             	mov    0xc(%rax),%edx
  8032d8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032df:	00 00 00 
  8032e2:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8032e4:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032eb:	00 00 00 
  8032ee:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032f2:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  8032f6:	be 00 00 00 00       	mov    $0x0,%esi
  8032fb:	bf 03 00 00 00       	mov    $0x3,%edi
  803300:	48 b8 25 31 80 00 00 	movabs $0x803125,%rax
  803307:	00 00 00 
  80330a:	ff d0                	callq  *%rax
  80330c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80330f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803313:	79 05                	jns    80331a <devfile_read+0x5d>
		return r;
  803315:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803318:	eb 26                	jmp    803340 <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  80331a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80331d:	48 63 d0             	movslq %eax,%rdx
  803320:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803324:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80332b:	00 00 00 
  80332e:	48 89 c7             	mov    %rax,%rdi
  803331:	48 b8 12 1b 80 00 00 	movabs $0x801b12,%rax
  803338:	00 00 00 
  80333b:	ff d0                	callq  *%rax
	return r;
  80333d:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  803340:	c9                   	leaveq 
  803341:	c3                   	retq   

0000000000803342 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803342:	55                   	push   %rbp
  803343:	48 89 e5             	mov    %rsp,%rbp
  803346:	48 83 ec 30          	sub    $0x30,%rsp
  80334a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80334e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803352:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  803356:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  80335d:	00 
	n = n > max ? max : n;
  80335e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803362:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  803366:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  80336b:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80336f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803373:	8b 50 0c             	mov    0xc(%rax),%edx
  803376:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80337d:	00 00 00 
  803380:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  803382:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803389:	00 00 00 
  80338c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803390:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  803394:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803398:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80339c:	48 89 c6             	mov    %rax,%rsi
  80339f:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  8033a6:	00 00 00 
  8033a9:	48 b8 12 1b 80 00 00 	movabs $0x801b12,%rax
  8033b0:	00 00 00 
  8033b3:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  8033b5:	be 00 00 00 00       	mov    $0x0,%esi
  8033ba:	bf 04 00 00 00       	mov    $0x4,%edi
  8033bf:	48 b8 25 31 80 00 00 	movabs $0x803125,%rax
  8033c6:	00 00 00 
  8033c9:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  8033cb:	c9                   	leaveq 
  8033cc:	c3                   	retq   

00000000008033cd <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8033cd:	55                   	push   %rbp
  8033ce:	48 89 e5             	mov    %rsp,%rbp
  8033d1:	48 83 ec 20          	sub    $0x20,%rsp
  8033d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8033dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033e1:	8b 50 0c             	mov    0xc(%rax),%edx
  8033e4:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033eb:	00 00 00 
  8033ee:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8033f0:	be 00 00 00 00       	mov    $0x0,%esi
  8033f5:	bf 05 00 00 00       	mov    $0x5,%edi
  8033fa:	48 b8 25 31 80 00 00 	movabs $0x803125,%rax
  803401:	00 00 00 
  803404:	ff d0                	callq  *%rax
  803406:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803409:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80340d:	79 05                	jns    803414 <devfile_stat+0x47>
		return r;
  80340f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803412:	eb 56                	jmp    80346a <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803414:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803418:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80341f:	00 00 00 
  803422:	48 89 c7             	mov    %rax,%rdi
  803425:	48 b8 d7 16 80 00 00 	movabs $0x8016d7,%rax
  80342c:	00 00 00 
  80342f:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803431:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803438:	00 00 00 
  80343b:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803441:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803445:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80344b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803452:	00 00 00 
  803455:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80345b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80345f:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803465:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80346a:	c9                   	leaveq 
  80346b:	c3                   	retq   

000000000080346c <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80346c:	55                   	push   %rbp
  80346d:	48 89 e5             	mov    %rsp,%rbp
  803470:	48 83 ec 10          	sub    $0x10,%rsp
  803474:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803478:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80347b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80347f:	8b 50 0c             	mov    0xc(%rax),%edx
  803482:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803489:	00 00 00 
  80348c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80348e:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803495:	00 00 00 
  803498:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80349b:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80349e:	be 00 00 00 00       	mov    $0x0,%esi
  8034a3:	bf 02 00 00 00       	mov    $0x2,%edi
  8034a8:	48 b8 25 31 80 00 00 	movabs $0x803125,%rax
  8034af:	00 00 00 
  8034b2:	ff d0                	callq  *%rax
}
  8034b4:	c9                   	leaveq 
  8034b5:	c3                   	retq   

00000000008034b6 <remove>:

// Delete a file
int
remove(const char *path)
{
  8034b6:	55                   	push   %rbp
  8034b7:	48 89 e5             	mov    %rsp,%rbp
  8034ba:	48 83 ec 10          	sub    $0x10,%rsp
  8034be:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8034c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034c6:	48 89 c7             	mov    %rax,%rdi
  8034c9:	48 b8 6b 16 80 00 00 	movabs $0x80166b,%rax
  8034d0:	00 00 00 
  8034d3:	ff d0                	callq  *%rax
  8034d5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8034da:	7e 07                	jle    8034e3 <remove+0x2d>
		return -E_BAD_PATH;
  8034dc:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8034e1:	eb 33                	jmp    803516 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8034e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034e7:	48 89 c6             	mov    %rax,%rsi
  8034ea:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8034f1:	00 00 00 
  8034f4:	48 b8 d7 16 80 00 00 	movabs $0x8016d7,%rax
  8034fb:	00 00 00 
  8034fe:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803500:	be 00 00 00 00       	mov    $0x0,%esi
  803505:	bf 07 00 00 00       	mov    $0x7,%edi
  80350a:	48 b8 25 31 80 00 00 	movabs $0x803125,%rax
  803511:	00 00 00 
  803514:	ff d0                	callq  *%rax
}
  803516:	c9                   	leaveq 
  803517:	c3                   	retq   

0000000000803518 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803518:	55                   	push   %rbp
  803519:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80351c:	be 00 00 00 00       	mov    $0x0,%esi
  803521:	bf 08 00 00 00       	mov    $0x8,%edi
  803526:	48 b8 25 31 80 00 00 	movabs $0x803125,%rax
  80352d:	00 00 00 
  803530:	ff d0                	callq  *%rax
}
  803532:	5d                   	pop    %rbp
  803533:	c3                   	retq   

0000000000803534 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803534:	55                   	push   %rbp
  803535:	48 89 e5             	mov    %rsp,%rbp
  803538:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80353f:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803546:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80354d:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803554:	be 00 00 00 00       	mov    $0x0,%esi
  803559:	48 89 c7             	mov    %rax,%rdi
  80355c:	48 b8 ac 31 80 00 00 	movabs $0x8031ac,%rax
  803563:	00 00 00 
  803566:	ff d0                	callq  *%rax
  803568:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80356b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80356f:	79 28                	jns    803599 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803571:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803574:	89 c6                	mov    %eax,%esi
  803576:	48 bf 6e 54 80 00 00 	movabs $0x80546e,%rdi
  80357d:	00 00 00 
  803580:	b8 00 00 00 00       	mov    $0x0,%eax
  803585:	48 ba 22 0b 80 00 00 	movabs $0x800b22,%rdx
  80358c:	00 00 00 
  80358f:	ff d2                	callq  *%rdx
		return fd_src;
  803591:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803594:	e9 74 01 00 00       	jmpq   80370d <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803599:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8035a0:	be 01 01 00 00       	mov    $0x101,%esi
  8035a5:	48 89 c7             	mov    %rax,%rdi
  8035a8:	48 b8 ac 31 80 00 00 	movabs $0x8031ac,%rax
  8035af:	00 00 00 
  8035b2:	ff d0                	callq  *%rax
  8035b4:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8035b7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8035bb:	79 39                	jns    8035f6 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8035bd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035c0:	89 c6                	mov    %eax,%esi
  8035c2:	48 bf 84 54 80 00 00 	movabs $0x805484,%rdi
  8035c9:	00 00 00 
  8035cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8035d1:	48 ba 22 0b 80 00 00 	movabs $0x800b22,%rdx
  8035d8:	00 00 00 
  8035db:	ff d2                	callq  *%rdx
		close(fd_src);
  8035dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035e0:	89 c7                	mov    %eax,%edi
  8035e2:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  8035e9:	00 00 00 
  8035ec:	ff d0                	callq  *%rax
		return fd_dest;
  8035ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035f1:	e9 17 01 00 00       	jmpq   80370d <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8035f6:	eb 74                	jmp    80366c <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8035f8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8035fb:	48 63 d0             	movslq %eax,%rdx
  8035fe:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803605:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803608:	48 89 ce             	mov    %rcx,%rsi
  80360b:	89 c7                	mov    %eax,%edi
  80360d:	48 b8 20 2e 80 00 00 	movabs $0x802e20,%rax
  803614:	00 00 00 
  803617:	ff d0                	callq  *%rax
  803619:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80361c:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803620:	79 4a                	jns    80366c <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803622:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803625:	89 c6                	mov    %eax,%esi
  803627:	48 bf 9e 54 80 00 00 	movabs $0x80549e,%rdi
  80362e:	00 00 00 
  803631:	b8 00 00 00 00       	mov    $0x0,%eax
  803636:	48 ba 22 0b 80 00 00 	movabs $0x800b22,%rdx
  80363d:	00 00 00 
  803640:	ff d2                	callq  *%rdx
			close(fd_src);
  803642:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803645:	89 c7                	mov    %eax,%edi
  803647:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  80364e:	00 00 00 
  803651:	ff d0                	callq  *%rax
			close(fd_dest);
  803653:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803656:	89 c7                	mov    %eax,%edi
  803658:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  80365f:	00 00 00 
  803662:	ff d0                	callq  *%rax
			return write_size;
  803664:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803667:	e9 a1 00 00 00       	jmpq   80370d <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80366c:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803673:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803676:	ba 00 02 00 00       	mov    $0x200,%edx
  80367b:	48 89 ce             	mov    %rcx,%rsi
  80367e:	89 c7                	mov    %eax,%edi
  803680:	48 b8 d6 2c 80 00 00 	movabs $0x802cd6,%rax
  803687:	00 00 00 
  80368a:	ff d0                	callq  *%rax
  80368c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80368f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803693:	0f 8f 5f ff ff ff    	jg     8035f8 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803699:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80369d:	79 47                	jns    8036e6 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80369f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8036a2:	89 c6                	mov    %eax,%esi
  8036a4:	48 bf b1 54 80 00 00 	movabs $0x8054b1,%rdi
  8036ab:	00 00 00 
  8036ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8036b3:	48 ba 22 0b 80 00 00 	movabs $0x800b22,%rdx
  8036ba:	00 00 00 
  8036bd:	ff d2                	callq  *%rdx
		close(fd_src);
  8036bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036c2:	89 c7                	mov    %eax,%edi
  8036c4:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  8036cb:	00 00 00 
  8036ce:	ff d0                	callq  *%rax
		close(fd_dest);
  8036d0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036d3:	89 c7                	mov    %eax,%edi
  8036d5:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  8036dc:	00 00 00 
  8036df:	ff d0                	callq  *%rax
		return read_size;
  8036e1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8036e4:	eb 27                	jmp    80370d <copy+0x1d9>
	}
	close(fd_src);
  8036e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036e9:	89 c7                	mov    %eax,%edi
  8036eb:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  8036f2:	00 00 00 
  8036f5:	ff d0                	callq  *%rax
	close(fd_dest);
  8036f7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036fa:	89 c7                	mov    %eax,%edi
  8036fc:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  803703:	00 00 00 
  803706:	ff d0                	callq  *%rax
	return 0;
  803708:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80370d:	c9                   	leaveq 
  80370e:	c3                   	retq   

000000000080370f <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  80370f:	55                   	push   %rbp
  803710:	48 89 e5             	mov    %rsp,%rbp
  803713:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  80371a:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  803721:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  803728:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  80372f:	be 00 00 00 00       	mov    $0x0,%esi
  803734:	48 89 c7             	mov    %rax,%rdi
  803737:	48 b8 ac 31 80 00 00 	movabs $0x8031ac,%rax
  80373e:	00 00 00 
  803741:	ff d0                	callq  *%rax
  803743:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803746:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80374a:	79 08                	jns    803754 <spawn+0x45>
		return r;
  80374c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80374f:	e9 14 03 00 00       	jmpq   803a68 <spawn+0x359>
	fd = r;
  803754:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803757:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  80375a:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  803761:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  803765:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  80376c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80376f:	ba 00 02 00 00       	mov    $0x200,%edx
  803774:	48 89 ce             	mov    %rcx,%rsi
  803777:	89 c7                	mov    %eax,%edi
  803779:	48 b8 ab 2d 80 00 00 	movabs $0x802dab,%rax
  803780:	00 00 00 
  803783:	ff d0                	callq  *%rax
  803785:	3d 00 02 00 00       	cmp    $0x200,%eax
  80378a:	75 0d                	jne    803799 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  80378c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803790:	8b 00                	mov    (%rax),%eax
  803792:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  803797:	74 43                	je     8037dc <spawn+0xcd>
		close(fd);
  803799:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80379c:	89 c7                	mov    %eax,%edi
  80379e:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  8037a5:	00 00 00 
  8037a8:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8037aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037ae:	8b 00                	mov    (%rax),%eax
  8037b0:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  8037b5:	89 c6                	mov    %eax,%esi
  8037b7:	48 bf c8 54 80 00 00 	movabs $0x8054c8,%rdi
  8037be:	00 00 00 
  8037c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8037c6:	48 b9 22 0b 80 00 00 	movabs $0x800b22,%rcx
  8037cd:	00 00 00 
  8037d0:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  8037d2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8037d7:	e9 8c 02 00 00       	jmpq   803a68 <spawn+0x359>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8037dc:	b8 07 00 00 00       	mov    $0x7,%eax
  8037e1:	cd 30                	int    $0x30
  8037e3:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8037e6:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8037e9:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8037ec:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8037f0:	79 08                	jns    8037fa <spawn+0xeb>
		return r;
  8037f2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8037f5:	e9 6e 02 00 00       	jmpq   803a68 <spawn+0x359>
	child = r;
  8037fa:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8037fd:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  803800:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803803:	25 ff 03 00 00       	and    $0x3ff,%eax
  803808:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80380f:	00 00 00 
  803812:	48 63 d0             	movslq %eax,%rdx
  803815:	48 89 d0             	mov    %rdx,%rax
  803818:	48 c1 e0 03          	shl    $0x3,%rax
  80381c:	48 01 d0             	add    %rdx,%rax
  80381f:	48 c1 e0 05          	shl    $0x5,%rax
  803823:	48 01 c8             	add    %rcx,%rax
  803826:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  80382d:	48 89 c6             	mov    %rax,%rsi
  803830:	b8 18 00 00 00       	mov    $0x18,%eax
  803835:	48 89 d7             	mov    %rdx,%rdi
  803838:	48 89 c1             	mov    %rax,%rcx
  80383b:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  80383e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803842:	48 8b 40 18          	mov    0x18(%rax),%rax
  803846:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  80384d:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  803854:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  80385b:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  803862:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803865:	48 89 ce             	mov    %rcx,%rsi
  803868:	89 c7                	mov    %eax,%edi
  80386a:	48 b8 d2 3c 80 00 00 	movabs $0x803cd2,%rax
  803871:	00 00 00 
  803874:	ff d0                	callq  *%rax
  803876:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803879:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80387d:	79 08                	jns    803887 <spawn+0x178>
		return r;
  80387f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803882:	e9 e1 01 00 00       	jmpq   803a68 <spawn+0x359>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  803887:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80388b:	48 8b 40 20          	mov    0x20(%rax),%rax
  80388f:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  803896:	48 01 d0             	add    %rdx,%rax
  803899:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80389d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8038a4:	e9 a3 00 00 00       	jmpq   80394c <spawn+0x23d>
		if (ph->p_type != ELF_PROG_LOAD)
  8038a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038ad:	8b 00                	mov    (%rax),%eax
  8038af:	83 f8 01             	cmp    $0x1,%eax
  8038b2:	74 05                	je     8038b9 <spawn+0x1aa>
			continue;
  8038b4:	e9 8a 00 00 00       	jmpq   803943 <spawn+0x234>
		perm = PTE_P | PTE_U;
  8038b9:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8038c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038c4:	8b 40 04             	mov    0x4(%rax),%eax
  8038c7:	83 e0 02             	and    $0x2,%eax
  8038ca:	85 c0                	test   %eax,%eax
  8038cc:	74 04                	je     8038d2 <spawn+0x1c3>
			perm |= PTE_W;
  8038ce:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  8038d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038d6:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  8038da:	41 89 c1             	mov    %eax,%r9d
  8038dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038e1:	4c 8b 40 20          	mov    0x20(%rax),%r8
  8038e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038e9:	48 8b 50 28          	mov    0x28(%rax),%rdx
  8038ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038f1:	48 8b 70 10          	mov    0x10(%rax),%rsi
  8038f5:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8038f8:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8038fb:	8b 7d ec             	mov    -0x14(%rbp),%edi
  8038fe:	89 3c 24             	mov    %edi,(%rsp)
  803901:	89 c7                	mov    %eax,%edi
  803903:	48 b8 7b 3f 80 00 00 	movabs $0x803f7b,%rax
  80390a:	00 00 00 
  80390d:	ff d0                	callq  *%rax
  80390f:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803912:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803916:	79 2b                	jns    803943 <spawn+0x234>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  803918:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  803919:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80391c:	89 c7                	mov    %eax,%edi
  80391e:	48 b8 46 1f 80 00 00 	movabs $0x801f46,%rax
  803925:	00 00 00 
  803928:	ff d0                	callq  *%rax
	close(fd);
  80392a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80392d:	89 c7                	mov    %eax,%edi
  80392f:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  803936:	00 00 00 
  803939:	ff d0                	callq  *%rax
	return r;
  80393b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80393e:	e9 25 01 00 00       	jmpq   803a68 <spawn+0x359>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803943:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803947:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  80394c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803950:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  803954:	0f b7 c0             	movzwl %ax,%eax
  803957:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  80395a:	0f 8f 49 ff ff ff    	jg     8038a9 <spawn+0x19a>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  803960:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803963:	89 c7                	mov    %eax,%edi
  803965:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  80396c:	00 00 00 
  80396f:	ff d0                	callq  *%rax
	fd = -1;
  803971:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  803978:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80397b:	89 c7                	mov    %eax,%edi
  80397d:	48 b8 67 41 80 00 00 	movabs $0x804167,%rax
  803984:	00 00 00 
  803987:	ff d0                	callq  *%rax
  803989:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80398c:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803990:	79 30                	jns    8039c2 <spawn+0x2b3>
		panic("copy_shared_pages: %e", r);
  803992:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803995:	89 c1                	mov    %eax,%ecx
  803997:	48 ba e2 54 80 00 00 	movabs $0x8054e2,%rdx
  80399e:	00 00 00 
  8039a1:	be 82 00 00 00       	mov    $0x82,%esi
  8039a6:	48 bf f8 54 80 00 00 	movabs $0x8054f8,%rdi
  8039ad:	00 00 00 
  8039b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8039b5:	49 b8 e9 08 80 00 00 	movabs $0x8008e9,%r8
  8039bc:	00 00 00 
  8039bf:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8039c2:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  8039c9:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8039cc:	48 89 d6             	mov    %rdx,%rsi
  8039cf:	89 c7                	mov    %eax,%edi
  8039d1:	48 b8 46 21 80 00 00 	movabs $0x802146,%rax
  8039d8:	00 00 00 
  8039db:	ff d0                	callq  *%rax
  8039dd:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8039e0:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8039e4:	79 30                	jns    803a16 <spawn+0x307>
		panic("sys_env_set_trapframe: %e", r);
  8039e6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8039e9:	89 c1                	mov    %eax,%ecx
  8039eb:	48 ba 04 55 80 00 00 	movabs $0x805504,%rdx
  8039f2:	00 00 00 
  8039f5:	be 85 00 00 00       	mov    $0x85,%esi
  8039fa:	48 bf f8 54 80 00 00 	movabs $0x8054f8,%rdi
  803a01:	00 00 00 
  803a04:	b8 00 00 00 00       	mov    $0x0,%eax
  803a09:	49 b8 e9 08 80 00 00 	movabs $0x8008e9,%r8
  803a10:	00 00 00 
  803a13:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  803a16:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803a19:	be 02 00 00 00       	mov    $0x2,%esi
  803a1e:	89 c7                	mov    %eax,%edi
  803a20:	48 b8 fb 20 80 00 00 	movabs $0x8020fb,%rax
  803a27:	00 00 00 
  803a2a:	ff d0                	callq  *%rax
  803a2c:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803a2f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803a33:	79 30                	jns    803a65 <spawn+0x356>
		panic("sys_env_set_status: %e", r);
  803a35:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803a38:	89 c1                	mov    %eax,%ecx
  803a3a:	48 ba 1e 55 80 00 00 	movabs $0x80551e,%rdx
  803a41:	00 00 00 
  803a44:	be 88 00 00 00       	mov    $0x88,%esi
  803a49:	48 bf f8 54 80 00 00 	movabs $0x8054f8,%rdi
  803a50:	00 00 00 
  803a53:	b8 00 00 00 00       	mov    $0x0,%eax
  803a58:	49 b8 e9 08 80 00 00 	movabs $0x8008e9,%r8
  803a5f:	00 00 00 
  803a62:	41 ff d0             	callq  *%r8

	return child;
  803a65:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  803a68:	c9                   	leaveq 
  803a69:	c3                   	retq   

0000000000803a6a <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  803a6a:	55                   	push   %rbp
  803a6b:	48 89 e5             	mov    %rsp,%rbp
  803a6e:	41 55                	push   %r13
  803a70:	41 54                	push   %r12
  803a72:	53                   	push   %rbx
  803a73:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803a7a:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  803a81:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  803a88:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  803a8f:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  803a96:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  803a9d:	84 c0                	test   %al,%al
  803a9f:	74 26                	je     803ac7 <spawnl+0x5d>
  803aa1:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  803aa8:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  803aaf:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  803ab3:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  803ab7:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  803abb:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  803abf:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  803ac3:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  803ac7:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  803ace:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  803ad5:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  803ad8:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803adf:	00 00 00 
  803ae2:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803ae9:	00 00 00 
  803aec:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803af0:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803af7:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803afe:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  803b05:	eb 07                	jmp    803b0e <spawnl+0xa4>
		argc++;
  803b07:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  803b0e:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803b14:	83 f8 30             	cmp    $0x30,%eax
  803b17:	73 23                	jae    803b3c <spawnl+0xd2>
  803b19:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803b20:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803b26:	89 c0                	mov    %eax,%eax
  803b28:	48 01 d0             	add    %rdx,%rax
  803b2b:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803b31:	83 c2 08             	add    $0x8,%edx
  803b34:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803b3a:	eb 15                	jmp    803b51 <spawnl+0xe7>
  803b3c:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803b43:	48 89 d0             	mov    %rdx,%rax
  803b46:	48 83 c2 08          	add    $0x8,%rdx
  803b4a:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803b51:	48 8b 00             	mov    (%rax),%rax
  803b54:	48 85 c0             	test   %rax,%rax
  803b57:	75 ae                	jne    803b07 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  803b59:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803b5f:	83 c0 02             	add    $0x2,%eax
  803b62:	48 89 e2             	mov    %rsp,%rdx
  803b65:	48 89 d3             	mov    %rdx,%rbx
  803b68:	48 63 d0             	movslq %eax,%rdx
  803b6b:	48 83 ea 01          	sub    $0x1,%rdx
  803b6f:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  803b76:	48 63 d0             	movslq %eax,%rdx
  803b79:	49 89 d4             	mov    %rdx,%r12
  803b7c:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  803b82:	48 63 d0             	movslq %eax,%rdx
  803b85:	49 89 d2             	mov    %rdx,%r10
  803b88:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  803b8e:	48 98                	cltq   
  803b90:	48 c1 e0 03          	shl    $0x3,%rax
  803b94:	48 8d 50 07          	lea    0x7(%rax),%rdx
  803b98:	b8 10 00 00 00       	mov    $0x10,%eax
  803b9d:	48 83 e8 01          	sub    $0x1,%rax
  803ba1:	48 01 d0             	add    %rdx,%rax
  803ba4:	bf 10 00 00 00       	mov    $0x10,%edi
  803ba9:	ba 00 00 00 00       	mov    $0x0,%edx
  803bae:	48 f7 f7             	div    %rdi
  803bb1:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803bb5:	48 29 c4             	sub    %rax,%rsp
  803bb8:	48 89 e0             	mov    %rsp,%rax
  803bbb:	48 83 c0 07          	add    $0x7,%rax
  803bbf:	48 c1 e8 03          	shr    $0x3,%rax
  803bc3:	48 c1 e0 03          	shl    $0x3,%rax
  803bc7:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  803bce:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803bd5:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  803bdc:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  803bdf:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803be5:	8d 50 01             	lea    0x1(%rax),%edx
  803be8:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803bef:	48 63 d2             	movslq %edx,%rdx
  803bf2:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803bf9:	00 

	va_start(vl, arg0);
  803bfa:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803c01:	00 00 00 
  803c04:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803c0b:	00 00 00 
  803c0e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803c12:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803c19:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803c20:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  803c27:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  803c2e:	00 00 00 
  803c31:	eb 63                	jmp    803c96 <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  803c33:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  803c39:	8d 70 01             	lea    0x1(%rax),%esi
  803c3c:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803c42:	83 f8 30             	cmp    $0x30,%eax
  803c45:	73 23                	jae    803c6a <spawnl+0x200>
  803c47:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803c4e:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803c54:	89 c0                	mov    %eax,%eax
  803c56:	48 01 d0             	add    %rdx,%rax
  803c59:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803c5f:	83 c2 08             	add    $0x8,%edx
  803c62:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803c68:	eb 15                	jmp    803c7f <spawnl+0x215>
  803c6a:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803c71:	48 89 d0             	mov    %rdx,%rax
  803c74:	48 83 c2 08          	add    $0x8,%rdx
  803c78:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803c7f:	48 8b 08             	mov    (%rax),%rcx
  803c82:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803c89:	89 f2                	mov    %esi,%edx
  803c8b:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  803c8f:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  803c96:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803c9c:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  803ca2:	77 8f                	ja     803c33 <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  803ca4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803cab:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  803cb2:	48 89 d6             	mov    %rdx,%rsi
  803cb5:	48 89 c7             	mov    %rax,%rdi
  803cb8:	48 b8 0f 37 80 00 00 	movabs $0x80370f,%rax
  803cbf:	00 00 00 
  803cc2:	ff d0                	callq  *%rax
  803cc4:	48 89 dc             	mov    %rbx,%rsp
}
  803cc7:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  803ccb:	5b                   	pop    %rbx
  803ccc:	41 5c                	pop    %r12
  803cce:	41 5d                	pop    %r13
  803cd0:	5d                   	pop    %rbp
  803cd1:	c3                   	retq   

0000000000803cd2 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  803cd2:	55                   	push   %rbp
  803cd3:	48 89 e5             	mov    %rsp,%rbp
  803cd6:	48 83 ec 50          	sub    $0x50,%rsp
  803cda:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803cdd:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803ce1:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803ce5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803cec:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803ced:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  803cf4:	eb 33                	jmp    803d29 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  803cf6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803cf9:	48 98                	cltq   
  803cfb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803d02:	00 
  803d03:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803d07:	48 01 d0             	add    %rdx,%rax
  803d0a:	48 8b 00             	mov    (%rax),%rax
  803d0d:	48 89 c7             	mov    %rax,%rdi
  803d10:	48 b8 6b 16 80 00 00 	movabs $0x80166b,%rax
  803d17:	00 00 00 
  803d1a:	ff d0                	callq  *%rax
  803d1c:	83 c0 01             	add    $0x1,%eax
  803d1f:	48 98                	cltq   
  803d21:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  803d25:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803d29:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803d2c:	48 98                	cltq   
  803d2e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803d35:	00 
  803d36:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803d3a:	48 01 d0             	add    %rdx,%rax
  803d3d:	48 8b 00             	mov    (%rax),%rax
  803d40:	48 85 c0             	test   %rax,%rax
  803d43:	75 b1                	jne    803cf6 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  803d45:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d49:	48 f7 d8             	neg    %rax
  803d4c:	48 05 00 10 40 00    	add    $0x401000,%rax
  803d52:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  803d56:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d5a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803d5e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d62:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  803d66:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803d69:	83 c2 01             	add    $0x1,%edx
  803d6c:	c1 e2 03             	shl    $0x3,%edx
  803d6f:	48 63 d2             	movslq %edx,%rdx
  803d72:	48 f7 da             	neg    %rdx
  803d75:	48 01 d0             	add    %rdx,%rax
  803d78:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  803d7c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d80:	48 83 e8 10          	sub    $0x10,%rax
  803d84:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  803d8a:	77 0a                	ja     803d96 <init_stack+0xc4>
		return -E_NO_MEM;
  803d8c:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  803d91:	e9 e3 01 00 00       	jmpq   803f79 <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803d96:	ba 07 00 00 00       	mov    $0x7,%edx
  803d9b:	be 00 00 40 00       	mov    $0x400000,%esi
  803da0:	bf 00 00 00 00       	mov    $0x0,%edi
  803da5:	48 b8 06 20 80 00 00 	movabs $0x802006,%rax
  803dac:	00 00 00 
  803daf:	ff d0                	callq  *%rax
  803db1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803db4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803db8:	79 08                	jns    803dc2 <init_stack+0xf0>
		return r;
  803dba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dbd:	e9 b7 01 00 00       	jmpq   803f79 <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803dc2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  803dc9:	e9 8a 00 00 00       	jmpq   803e58 <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  803dce:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803dd1:	48 98                	cltq   
  803dd3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803dda:	00 
  803ddb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ddf:	48 01 c2             	add    %rax,%rdx
  803de2:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803de7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803deb:	48 01 c8             	add    %rcx,%rax
  803dee:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803df4:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  803df7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803dfa:	48 98                	cltq   
  803dfc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803e03:	00 
  803e04:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803e08:	48 01 d0             	add    %rdx,%rax
  803e0b:	48 8b 10             	mov    (%rax),%rdx
  803e0e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e12:	48 89 d6             	mov    %rdx,%rsi
  803e15:	48 89 c7             	mov    %rax,%rdi
  803e18:	48 b8 d7 16 80 00 00 	movabs $0x8016d7,%rax
  803e1f:	00 00 00 
  803e22:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803e24:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803e27:	48 98                	cltq   
  803e29:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803e30:	00 
  803e31:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803e35:	48 01 d0             	add    %rdx,%rax
  803e38:	48 8b 00             	mov    (%rax),%rax
  803e3b:	48 89 c7             	mov    %rax,%rdi
  803e3e:	48 b8 6b 16 80 00 00 	movabs $0x80166b,%rax
  803e45:	00 00 00 
  803e48:	ff d0                	callq  *%rax
  803e4a:	48 98                	cltq   
  803e4c:	48 83 c0 01          	add    $0x1,%rax
  803e50:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803e54:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  803e58:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803e5b:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  803e5e:	0f 8c 6a ff ff ff    	jl     803dce <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  803e64:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803e67:	48 98                	cltq   
  803e69:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803e70:	00 
  803e71:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e75:	48 01 d0             	add    %rdx,%rax
  803e78:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  803e7f:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  803e86:	00 
  803e87:	74 35                	je     803ebe <init_stack+0x1ec>
  803e89:	48 b9 38 55 80 00 00 	movabs $0x805538,%rcx
  803e90:	00 00 00 
  803e93:	48 ba 5e 55 80 00 00 	movabs $0x80555e,%rdx
  803e9a:	00 00 00 
  803e9d:	be f1 00 00 00       	mov    $0xf1,%esi
  803ea2:	48 bf f8 54 80 00 00 	movabs $0x8054f8,%rdi
  803ea9:	00 00 00 
  803eac:	b8 00 00 00 00       	mov    $0x0,%eax
  803eb1:	49 b8 e9 08 80 00 00 	movabs $0x8008e9,%r8
  803eb8:	00 00 00 
  803ebb:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  803ebe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ec2:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  803ec6:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803ecb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ecf:	48 01 c8             	add    %rcx,%rax
  803ed2:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803ed8:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  803edb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803edf:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803ee3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803ee6:	48 98                	cltq   
  803ee8:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  803eeb:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  803ef0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ef4:	48 01 d0             	add    %rdx,%rax
  803ef7:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803efd:	48 89 c2             	mov    %rax,%rdx
  803f00:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803f04:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  803f07:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803f0a:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  803f10:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803f15:	89 c2                	mov    %eax,%edx
  803f17:	be 00 00 40 00       	mov    $0x400000,%esi
  803f1c:	bf 00 00 00 00       	mov    $0x0,%edi
  803f21:	48 b8 56 20 80 00 00 	movabs $0x802056,%rax
  803f28:	00 00 00 
  803f2b:	ff d0                	callq  *%rax
  803f2d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f30:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f34:	79 02                	jns    803f38 <init_stack+0x266>
		goto error;
  803f36:	eb 28                	jmp    803f60 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803f38:	be 00 00 40 00       	mov    $0x400000,%esi
  803f3d:	bf 00 00 00 00       	mov    $0x0,%edi
  803f42:	48 b8 b1 20 80 00 00 	movabs $0x8020b1,%rax
  803f49:	00 00 00 
  803f4c:	ff d0                	callq  *%rax
  803f4e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f51:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f55:	79 02                	jns    803f59 <init_stack+0x287>
		goto error;
  803f57:	eb 07                	jmp    803f60 <init_stack+0x28e>

	return 0;
  803f59:	b8 00 00 00 00       	mov    $0x0,%eax
  803f5e:	eb 19                	jmp    803f79 <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  803f60:	be 00 00 40 00       	mov    $0x400000,%esi
  803f65:	bf 00 00 00 00       	mov    $0x0,%edi
  803f6a:	48 b8 b1 20 80 00 00 	movabs $0x8020b1,%rax
  803f71:	00 00 00 
  803f74:	ff d0                	callq  *%rax
	return r;
  803f76:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803f79:	c9                   	leaveq 
  803f7a:	c3                   	retq   

0000000000803f7b <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  803f7b:	55                   	push   %rbp
  803f7c:	48 89 e5             	mov    %rsp,%rbp
  803f7f:	48 83 ec 50          	sub    $0x50,%rsp
  803f83:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803f86:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803f8a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803f8e:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803f91:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803f95:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803f99:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f9d:	25 ff 0f 00 00       	and    $0xfff,%eax
  803fa2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fa5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fa9:	74 21                	je     803fcc <map_segment+0x51>
		va -= i;
  803fab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fae:	48 98                	cltq   
  803fb0:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803fb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fb7:	48 98                	cltq   
  803fb9:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803fbd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fc0:	48 98                	cltq   
  803fc2:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  803fc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fc9:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803fcc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803fd3:	e9 79 01 00 00       	jmpq   804151 <map_segment+0x1d6>
		if (i >= filesz) {
  803fd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fdb:	48 98                	cltq   
  803fdd:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803fe1:	72 3c                	jb     80401f <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803fe3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fe6:	48 63 d0             	movslq %eax,%rdx
  803fe9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fed:	48 01 d0             	add    %rdx,%rax
  803ff0:	48 89 c1             	mov    %rax,%rcx
  803ff3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803ff6:	8b 55 10             	mov    0x10(%rbp),%edx
  803ff9:	48 89 ce             	mov    %rcx,%rsi
  803ffc:	89 c7                	mov    %eax,%edi
  803ffe:	48 b8 06 20 80 00 00 	movabs $0x802006,%rax
  804005:	00 00 00 
  804008:	ff d0                	callq  *%rax
  80400a:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80400d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804011:	0f 89 33 01 00 00    	jns    80414a <map_segment+0x1cf>
				return r;
  804017:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80401a:	e9 46 01 00 00       	jmpq   804165 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80401f:	ba 07 00 00 00       	mov    $0x7,%edx
  804024:	be 00 00 40 00       	mov    $0x400000,%esi
  804029:	bf 00 00 00 00       	mov    $0x0,%edi
  80402e:	48 b8 06 20 80 00 00 	movabs $0x802006,%rax
  804035:	00 00 00 
  804038:	ff d0                	callq  *%rax
  80403a:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80403d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804041:	79 08                	jns    80404b <map_segment+0xd0>
				return r;
  804043:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804046:	e9 1a 01 00 00       	jmpq   804165 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  80404b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80404e:	8b 55 bc             	mov    -0x44(%rbp),%edx
  804051:	01 c2                	add    %eax,%edx
  804053:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804056:	89 d6                	mov    %edx,%esi
  804058:	89 c7                	mov    %eax,%edi
  80405a:	48 b8 f4 2e 80 00 00 	movabs $0x802ef4,%rax
  804061:	00 00 00 
  804064:	ff d0                	callq  *%rax
  804066:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804069:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80406d:	79 08                	jns    804077 <map_segment+0xfc>
				return r;
  80406f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804072:	e9 ee 00 00 00       	jmpq   804165 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  804077:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  80407e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804081:	48 98                	cltq   
  804083:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  804087:	48 29 c2             	sub    %rax,%rdx
  80408a:	48 89 d0             	mov    %rdx,%rax
  80408d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  804091:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804094:	48 63 d0             	movslq %eax,%rdx
  804097:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80409b:	48 39 c2             	cmp    %rax,%rdx
  80409e:	48 0f 47 d0          	cmova  %rax,%rdx
  8040a2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8040a5:	be 00 00 40 00       	mov    $0x400000,%esi
  8040aa:	89 c7                	mov    %eax,%edi
  8040ac:	48 b8 ab 2d 80 00 00 	movabs $0x802dab,%rax
  8040b3:	00 00 00 
  8040b6:	ff d0                	callq  *%rax
  8040b8:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8040bb:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8040bf:	79 08                	jns    8040c9 <map_segment+0x14e>
				return r;
  8040c1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8040c4:	e9 9c 00 00 00       	jmpq   804165 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8040c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040cc:	48 63 d0             	movslq %eax,%rdx
  8040cf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040d3:	48 01 d0             	add    %rdx,%rax
  8040d6:	48 89 c2             	mov    %rax,%rdx
  8040d9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8040dc:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  8040e0:	48 89 d1             	mov    %rdx,%rcx
  8040e3:	89 c2                	mov    %eax,%edx
  8040e5:	be 00 00 40 00       	mov    $0x400000,%esi
  8040ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8040ef:	48 b8 56 20 80 00 00 	movabs $0x802056,%rax
  8040f6:	00 00 00 
  8040f9:	ff d0                	callq  *%rax
  8040fb:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8040fe:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804102:	79 30                	jns    804134 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  804104:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804107:	89 c1                	mov    %eax,%ecx
  804109:	48 ba 73 55 80 00 00 	movabs $0x805573,%rdx
  804110:	00 00 00 
  804113:	be 24 01 00 00       	mov    $0x124,%esi
  804118:	48 bf f8 54 80 00 00 	movabs $0x8054f8,%rdi
  80411f:	00 00 00 
  804122:	b8 00 00 00 00       	mov    $0x0,%eax
  804127:	49 b8 e9 08 80 00 00 	movabs $0x8008e9,%r8
  80412e:	00 00 00 
  804131:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  804134:	be 00 00 40 00       	mov    $0x400000,%esi
  804139:	bf 00 00 00 00       	mov    $0x0,%edi
  80413e:	48 b8 b1 20 80 00 00 	movabs $0x8020b1,%rax
  804145:	00 00 00 
  804148:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80414a:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  804151:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804154:	48 98                	cltq   
  804156:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80415a:	0f 82 78 fe ff ff    	jb     803fd8 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  804160:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804165:	c9                   	leaveq 
  804166:	c3                   	retq   

0000000000804167 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  804167:	55                   	push   %rbp
  804168:	48 89 e5             	mov    %rsp,%rbp
  80416b:	48 83 ec 70          	sub    $0x70,%rsp
  80416f:	89 7d 9c             	mov    %edi,-0x64(%rbp)
	// LAB 5: Your code here.
	int r, perm;
	void* va;
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  804172:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804179:	00 
  80417a:	e9 70 01 00 00       	jmpq   8042ef <copy_shared_pages+0x188>
		if(uvpml4e[pml4e] & PTE_P){
  80417f:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  804186:	01 00 00 
  804189:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80418d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804191:	83 e0 01             	and    $0x1,%eax
  804194:	48 85 c0             	test   %rax,%rax
  804197:	0f 84 4d 01 00 00    	je     8042ea <copy_shared_pages+0x183>
			base_pml4e = pml4e * NPDPENTRIES;
  80419d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041a1:	48 c1 e0 09          	shl    $0x9,%rax
  8041a5:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  8041a9:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8041b0:	00 
  8041b1:	e9 26 01 00 00       	jmpq   8042dc <copy_shared_pages+0x175>
				if(uvpde[base_pml4e + pdpe] & PTE_P){
  8041b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041ba:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8041be:	48 01 c2             	add    %rax,%rdx
  8041c1:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8041c8:	01 00 00 
  8041cb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8041cf:	83 e0 01             	and    $0x1,%eax
  8041d2:	48 85 c0             	test   %rax,%rax
  8041d5:	0f 84 fc 00 00 00    	je     8042d7 <copy_shared_pages+0x170>
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
  8041db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041df:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8041e3:	48 01 d0             	add    %rdx,%rax
  8041e6:	48 c1 e0 09          	shl    $0x9,%rax
  8041ea:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
					for(pde = 0; pde < NPDENTRIES; pde++){
  8041ee:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8041f5:	00 
  8041f6:	e9 ce 00 00 00       	jmpq   8042c9 <copy_shared_pages+0x162>
						if(uvpd[base_pdpe + pde] & PTE_P){
  8041fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041ff:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  804203:	48 01 c2             	add    %rax,%rdx
  804206:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80420d:	01 00 00 
  804210:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804214:	83 e0 01             	and    $0x1,%eax
  804217:	48 85 c0             	test   %rax,%rax
  80421a:	0f 84 a4 00 00 00    	je     8042c4 <copy_shared_pages+0x15d>
							base_pde = (base_pdpe + pde) * NPTENTRIES;
  804220:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804224:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  804228:	48 01 d0             	add    %rdx,%rax
  80422b:	48 c1 e0 09          	shl    $0x9,%rax
  80422f:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
							for(pte = 0; pte < NPTENTRIES; pte++){
  804233:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  80423a:	00 
  80423b:	eb 79                	jmp    8042b6 <copy_shared_pages+0x14f>
								entry = base_pde + pte;
  80423d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804241:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  804245:	48 01 d0             	add    %rdx,%rax
  804248:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
								perm = uvpt[entry] & PTE_SYSCALL;
  80424c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804253:	01 00 00 
  804256:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80425a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80425e:	25 07 0e 00 00       	and    $0xe07,%eax
  804263:	89 45 bc             	mov    %eax,-0x44(%rbp)
								if(perm & PTE_SHARE){
  804266:	8b 45 bc             	mov    -0x44(%rbp),%eax
  804269:	25 00 04 00 00       	and    $0x400,%eax
  80426e:	85 c0                	test   %eax,%eax
  804270:	74 3f                	je     8042b1 <copy_shared_pages+0x14a>
									va = (void*)(PGSIZE * entry);
  804272:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804276:	48 c1 e0 0c          	shl    $0xc,%rax
  80427a:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
									r = sys_page_map(0, va, child, va, perm);		
  80427e:	8b 75 bc             	mov    -0x44(%rbp),%esi
  804281:	48 8b 4d b0          	mov    -0x50(%rbp),%rcx
  804285:	8b 55 9c             	mov    -0x64(%rbp),%edx
  804288:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80428c:	41 89 f0             	mov    %esi,%r8d
  80428f:	48 89 c6             	mov    %rax,%rsi
  804292:	bf 00 00 00 00       	mov    $0x0,%edi
  804297:	48 b8 56 20 80 00 00 	movabs $0x802056,%rax
  80429e:	00 00 00 
  8042a1:	ff d0                	callq  *%rax
  8042a3:	89 45 ac             	mov    %eax,-0x54(%rbp)
									if(r < 0) return r;
  8042a6:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8042aa:	79 05                	jns    8042b1 <copy_shared_pages+0x14a>
  8042ac:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8042af:	eb 4e                	jmp    8042ff <copy_shared_pages+0x198>
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
						if(uvpd[base_pdpe + pde] & PTE_P){
							base_pde = (base_pdpe + pde) * NPTENTRIES;
							for(pte = 0; pte < NPTENTRIES; pte++){
  8042b1:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  8042b6:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  8042bd:	00 
  8042be:	0f 86 79 ff ff ff    	jbe    80423d <copy_shared_pages+0xd6>
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
  8042c4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8042c9:	48 81 7d e8 ff 01 00 	cmpq   $0x1ff,-0x18(%rbp)
  8042d0:	00 
  8042d1:	0f 86 24 ff ff ff    	jbe    8041fb <copy_shared_pages+0x94>
	void* va;
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  8042d7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  8042dc:	48 81 7d f0 ff 01 00 	cmpq   $0x1ff,-0x10(%rbp)
  8042e3:	00 
  8042e4:	0f 86 cc fe ff ff    	jbe    8041b6 <copy_shared_pages+0x4f>
{
	// LAB 5: Your code here.
	int r, perm;
	void* va;
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  8042ea:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8042ef:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8042f4:	0f 84 85 fe ff ff    	je     80417f <copy_shared_pages+0x18>
					}
				}
			}
		}
	}
	return 0;
  8042fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8042ff:	c9                   	leaveq 
  804300:	c3                   	retq   

0000000000804301 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  804301:	55                   	push   %rbp
  804302:	48 89 e5             	mov    %rsp,%rbp
  804305:	53                   	push   %rbx
  804306:	48 83 ec 38          	sub    $0x38,%rsp
  80430a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80430e:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  804312:	48 89 c7             	mov    %rax,%rdi
  804315:	48 b8 0c 28 80 00 00 	movabs $0x80280c,%rax
  80431c:	00 00 00 
  80431f:	ff d0                	callq  *%rax
  804321:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804324:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804328:	0f 88 bf 01 00 00    	js     8044ed <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80432e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804332:	ba 07 04 00 00       	mov    $0x407,%edx
  804337:	48 89 c6             	mov    %rax,%rsi
  80433a:	bf 00 00 00 00       	mov    $0x0,%edi
  80433f:	48 b8 06 20 80 00 00 	movabs $0x802006,%rax
  804346:	00 00 00 
  804349:	ff d0                	callq  *%rax
  80434b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80434e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804352:	0f 88 95 01 00 00    	js     8044ed <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  804358:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80435c:	48 89 c7             	mov    %rax,%rdi
  80435f:	48 b8 0c 28 80 00 00 	movabs $0x80280c,%rax
  804366:	00 00 00 
  804369:	ff d0                	callq  *%rax
  80436b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80436e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804372:	0f 88 5d 01 00 00    	js     8044d5 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804378:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80437c:	ba 07 04 00 00       	mov    $0x407,%edx
  804381:	48 89 c6             	mov    %rax,%rsi
  804384:	bf 00 00 00 00       	mov    $0x0,%edi
  804389:	48 b8 06 20 80 00 00 	movabs $0x802006,%rax
  804390:	00 00 00 
  804393:	ff d0                	callq  *%rax
  804395:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804398:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80439c:	0f 88 33 01 00 00    	js     8044d5 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8043a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043a6:	48 89 c7             	mov    %rax,%rdi
  8043a9:	48 b8 e1 27 80 00 00 	movabs $0x8027e1,%rax
  8043b0:	00 00 00 
  8043b3:	ff d0                	callq  *%rax
  8043b5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8043b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043bd:	ba 07 04 00 00       	mov    $0x407,%edx
  8043c2:	48 89 c6             	mov    %rax,%rsi
  8043c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8043ca:	48 b8 06 20 80 00 00 	movabs $0x802006,%rax
  8043d1:	00 00 00 
  8043d4:	ff d0                	callq  *%rax
  8043d6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8043d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8043dd:	79 05                	jns    8043e4 <pipe+0xe3>
		goto err2;
  8043df:	e9 d9 00 00 00       	jmpq   8044bd <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8043e4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043e8:	48 89 c7             	mov    %rax,%rdi
  8043eb:	48 b8 e1 27 80 00 00 	movabs $0x8027e1,%rax
  8043f2:	00 00 00 
  8043f5:	ff d0                	callq  *%rax
  8043f7:	48 89 c2             	mov    %rax,%rdx
  8043fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043fe:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  804404:	48 89 d1             	mov    %rdx,%rcx
  804407:	ba 00 00 00 00       	mov    $0x0,%edx
  80440c:	48 89 c6             	mov    %rax,%rsi
  80440f:	bf 00 00 00 00       	mov    $0x0,%edi
  804414:	48 b8 56 20 80 00 00 	movabs $0x802056,%rax
  80441b:	00 00 00 
  80441e:	ff d0                	callq  *%rax
  804420:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804423:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804427:	79 1b                	jns    804444 <pipe+0x143>
		goto err3;
  804429:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80442a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80442e:	48 89 c6             	mov    %rax,%rsi
  804431:	bf 00 00 00 00       	mov    $0x0,%edi
  804436:	48 b8 b1 20 80 00 00 	movabs $0x8020b1,%rax
  80443d:	00 00 00 
  804440:	ff d0                	callq  *%rax
  804442:	eb 79                	jmp    8044bd <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804444:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804448:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  80444f:	00 00 00 
  804452:	8b 12                	mov    (%rdx),%edx
  804454:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804456:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80445a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  804461:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804465:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  80446c:	00 00 00 
  80446f:	8b 12                	mov    (%rdx),%edx
  804471:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  804473:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804477:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80447e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804482:	48 89 c7             	mov    %rax,%rdi
  804485:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
  80448c:	00 00 00 
  80448f:	ff d0                	callq  *%rax
  804491:	89 c2                	mov    %eax,%edx
  804493:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804497:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804499:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80449d:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8044a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8044a5:	48 89 c7             	mov    %rax,%rdi
  8044a8:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
  8044af:	00 00 00 
  8044b2:	ff d0                	callq  *%rax
  8044b4:	89 03                	mov    %eax,(%rbx)
	return 0;
  8044b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8044bb:	eb 33                	jmp    8044f0 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8044bd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8044c1:	48 89 c6             	mov    %rax,%rsi
  8044c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8044c9:	48 b8 b1 20 80 00 00 	movabs $0x8020b1,%rax
  8044d0:	00 00 00 
  8044d3:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8044d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044d9:	48 89 c6             	mov    %rax,%rsi
  8044dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8044e1:	48 b8 b1 20 80 00 00 	movabs $0x8020b1,%rax
  8044e8:	00 00 00 
  8044eb:	ff d0                	callq  *%rax
err:
	return r;
  8044ed:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8044f0:	48 83 c4 38          	add    $0x38,%rsp
  8044f4:	5b                   	pop    %rbx
  8044f5:	5d                   	pop    %rbp
  8044f6:	c3                   	retq   

00000000008044f7 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8044f7:	55                   	push   %rbp
  8044f8:	48 89 e5             	mov    %rsp,%rbp
  8044fb:	53                   	push   %rbx
  8044fc:	48 83 ec 28          	sub    $0x28,%rsp
  804500:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804504:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804508:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80450f:	00 00 00 
  804512:	48 8b 00             	mov    (%rax),%rax
  804515:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80451b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80451e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804522:	48 89 c7             	mov    %rax,%rdi
  804525:	48 b8 6b 4c 80 00 00 	movabs $0x804c6b,%rax
  80452c:	00 00 00 
  80452f:	ff d0                	callq  *%rax
  804531:	89 c3                	mov    %eax,%ebx
  804533:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804537:	48 89 c7             	mov    %rax,%rdi
  80453a:	48 b8 6b 4c 80 00 00 	movabs $0x804c6b,%rax
  804541:	00 00 00 
  804544:	ff d0                	callq  *%rax
  804546:	39 c3                	cmp    %eax,%ebx
  804548:	0f 94 c0             	sete   %al
  80454b:	0f b6 c0             	movzbl %al,%eax
  80454e:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804551:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804558:	00 00 00 
  80455b:	48 8b 00             	mov    (%rax),%rax
  80455e:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804564:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804567:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80456a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80456d:	75 05                	jne    804574 <_pipeisclosed+0x7d>
			return ret;
  80456f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804572:	eb 4f                	jmp    8045c3 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  804574:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804577:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80457a:	74 42                	je     8045be <_pipeisclosed+0xc7>
  80457c:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804580:	75 3c                	jne    8045be <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804582:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804589:	00 00 00 
  80458c:	48 8b 00             	mov    (%rax),%rax
  80458f:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804595:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804598:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80459b:	89 c6                	mov    %eax,%esi
  80459d:	48 bf 95 55 80 00 00 	movabs $0x805595,%rdi
  8045a4:	00 00 00 
  8045a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8045ac:	49 b8 22 0b 80 00 00 	movabs $0x800b22,%r8
  8045b3:	00 00 00 
  8045b6:	41 ff d0             	callq  *%r8
	}
  8045b9:	e9 4a ff ff ff       	jmpq   804508 <_pipeisclosed+0x11>
  8045be:	e9 45 ff ff ff       	jmpq   804508 <_pipeisclosed+0x11>
}
  8045c3:	48 83 c4 28          	add    $0x28,%rsp
  8045c7:	5b                   	pop    %rbx
  8045c8:	5d                   	pop    %rbp
  8045c9:	c3                   	retq   

00000000008045ca <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8045ca:	55                   	push   %rbp
  8045cb:	48 89 e5             	mov    %rsp,%rbp
  8045ce:	48 83 ec 30          	sub    $0x30,%rsp
  8045d2:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8045d5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8045d9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8045dc:	48 89 d6             	mov    %rdx,%rsi
  8045df:	89 c7                	mov    %eax,%edi
  8045e1:	48 b8 a4 28 80 00 00 	movabs $0x8028a4,%rax
  8045e8:	00 00 00 
  8045eb:	ff d0                	callq  *%rax
  8045ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045f4:	79 05                	jns    8045fb <pipeisclosed+0x31>
		return r;
  8045f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045f9:	eb 31                	jmp    80462c <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8045fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045ff:	48 89 c7             	mov    %rax,%rdi
  804602:	48 b8 e1 27 80 00 00 	movabs $0x8027e1,%rax
  804609:	00 00 00 
  80460c:	ff d0                	callq  *%rax
  80460e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804612:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804616:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80461a:	48 89 d6             	mov    %rdx,%rsi
  80461d:	48 89 c7             	mov    %rax,%rdi
  804620:	48 b8 f7 44 80 00 00 	movabs $0x8044f7,%rax
  804627:	00 00 00 
  80462a:	ff d0                	callq  *%rax
}
  80462c:	c9                   	leaveq 
  80462d:	c3                   	retq   

000000000080462e <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80462e:	55                   	push   %rbp
  80462f:	48 89 e5             	mov    %rsp,%rbp
  804632:	48 83 ec 40          	sub    $0x40,%rsp
  804636:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80463a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80463e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804642:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804646:	48 89 c7             	mov    %rax,%rdi
  804649:	48 b8 e1 27 80 00 00 	movabs $0x8027e1,%rax
  804650:	00 00 00 
  804653:	ff d0                	callq  *%rax
  804655:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804659:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80465d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804661:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804668:	00 
  804669:	e9 92 00 00 00       	jmpq   804700 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80466e:	eb 41                	jmp    8046b1 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804670:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804675:	74 09                	je     804680 <devpipe_read+0x52>
				return i;
  804677:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80467b:	e9 92 00 00 00       	jmpq   804712 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804680:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804684:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804688:	48 89 d6             	mov    %rdx,%rsi
  80468b:	48 89 c7             	mov    %rax,%rdi
  80468e:	48 b8 f7 44 80 00 00 	movabs $0x8044f7,%rax
  804695:	00 00 00 
  804698:	ff d0                	callq  *%rax
  80469a:	85 c0                	test   %eax,%eax
  80469c:	74 07                	je     8046a5 <devpipe_read+0x77>
				return 0;
  80469e:	b8 00 00 00 00       	mov    $0x0,%eax
  8046a3:	eb 6d                	jmp    804712 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8046a5:	48 b8 c8 1f 80 00 00 	movabs $0x801fc8,%rax
  8046ac:	00 00 00 
  8046af:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8046b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046b5:	8b 10                	mov    (%rax),%edx
  8046b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046bb:	8b 40 04             	mov    0x4(%rax),%eax
  8046be:	39 c2                	cmp    %eax,%edx
  8046c0:	74 ae                	je     804670 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8046c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8046ca:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8046ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046d2:	8b 00                	mov    (%rax),%eax
  8046d4:	99                   	cltd   
  8046d5:	c1 ea 1b             	shr    $0x1b,%edx
  8046d8:	01 d0                	add    %edx,%eax
  8046da:	83 e0 1f             	and    $0x1f,%eax
  8046dd:	29 d0                	sub    %edx,%eax
  8046df:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8046e3:	48 98                	cltq   
  8046e5:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8046ea:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8046ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046f0:	8b 00                	mov    (%rax),%eax
  8046f2:	8d 50 01             	lea    0x1(%rax),%edx
  8046f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046f9:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8046fb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804700:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804704:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804708:	0f 82 60 ff ff ff    	jb     80466e <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80470e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804712:	c9                   	leaveq 
  804713:	c3                   	retq   

0000000000804714 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804714:	55                   	push   %rbp
  804715:	48 89 e5             	mov    %rsp,%rbp
  804718:	48 83 ec 40          	sub    $0x40,%rsp
  80471c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804720:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804724:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804728:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80472c:	48 89 c7             	mov    %rax,%rdi
  80472f:	48 b8 e1 27 80 00 00 	movabs $0x8027e1,%rax
  804736:	00 00 00 
  804739:	ff d0                	callq  *%rax
  80473b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80473f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804743:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804747:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80474e:	00 
  80474f:	e9 8e 00 00 00       	jmpq   8047e2 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804754:	eb 31                	jmp    804787 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804756:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80475a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80475e:	48 89 d6             	mov    %rdx,%rsi
  804761:	48 89 c7             	mov    %rax,%rdi
  804764:	48 b8 f7 44 80 00 00 	movabs $0x8044f7,%rax
  80476b:	00 00 00 
  80476e:	ff d0                	callq  *%rax
  804770:	85 c0                	test   %eax,%eax
  804772:	74 07                	je     80477b <devpipe_write+0x67>
				return 0;
  804774:	b8 00 00 00 00       	mov    $0x0,%eax
  804779:	eb 79                	jmp    8047f4 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80477b:	48 b8 c8 1f 80 00 00 	movabs $0x801fc8,%rax
  804782:	00 00 00 
  804785:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804787:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80478b:	8b 40 04             	mov    0x4(%rax),%eax
  80478e:	48 63 d0             	movslq %eax,%rdx
  804791:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804795:	8b 00                	mov    (%rax),%eax
  804797:	48 98                	cltq   
  804799:	48 83 c0 20          	add    $0x20,%rax
  80479d:	48 39 c2             	cmp    %rax,%rdx
  8047a0:	73 b4                	jae    804756 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8047a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047a6:	8b 40 04             	mov    0x4(%rax),%eax
  8047a9:	99                   	cltd   
  8047aa:	c1 ea 1b             	shr    $0x1b,%edx
  8047ad:	01 d0                	add    %edx,%eax
  8047af:	83 e0 1f             	and    $0x1f,%eax
  8047b2:	29 d0                	sub    %edx,%eax
  8047b4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8047b8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8047bc:	48 01 ca             	add    %rcx,%rdx
  8047bf:	0f b6 0a             	movzbl (%rdx),%ecx
  8047c2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8047c6:	48 98                	cltq   
  8047c8:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8047cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047d0:	8b 40 04             	mov    0x4(%rax),%eax
  8047d3:	8d 50 01             	lea    0x1(%rax),%edx
  8047d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047da:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8047dd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8047e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047e6:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8047ea:	0f 82 64 ff ff ff    	jb     804754 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8047f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8047f4:	c9                   	leaveq 
  8047f5:	c3                   	retq   

00000000008047f6 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8047f6:	55                   	push   %rbp
  8047f7:	48 89 e5             	mov    %rsp,%rbp
  8047fa:	48 83 ec 20          	sub    $0x20,%rsp
  8047fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804802:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804806:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80480a:	48 89 c7             	mov    %rax,%rdi
  80480d:	48 b8 e1 27 80 00 00 	movabs $0x8027e1,%rax
  804814:	00 00 00 
  804817:	ff d0                	callq  *%rax
  804819:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80481d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804821:	48 be a8 55 80 00 00 	movabs $0x8055a8,%rsi
  804828:	00 00 00 
  80482b:	48 89 c7             	mov    %rax,%rdi
  80482e:	48 b8 d7 16 80 00 00 	movabs $0x8016d7,%rax
  804835:	00 00 00 
  804838:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80483a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80483e:	8b 50 04             	mov    0x4(%rax),%edx
  804841:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804845:	8b 00                	mov    (%rax),%eax
  804847:	29 c2                	sub    %eax,%edx
  804849:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80484d:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804853:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804857:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80485e:	00 00 00 
	stat->st_dev = &devpipe;
  804861:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804865:	48 b9 a0 70 80 00 00 	movabs $0x8070a0,%rcx
  80486c:	00 00 00 
  80486f:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804876:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80487b:	c9                   	leaveq 
  80487c:	c3                   	retq   

000000000080487d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80487d:	55                   	push   %rbp
  80487e:	48 89 e5             	mov    %rsp,%rbp
  804881:	48 83 ec 10          	sub    $0x10,%rsp
  804885:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804889:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80488d:	48 89 c6             	mov    %rax,%rsi
  804890:	bf 00 00 00 00       	mov    $0x0,%edi
  804895:	48 b8 b1 20 80 00 00 	movabs $0x8020b1,%rax
  80489c:	00 00 00 
  80489f:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8048a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048a5:	48 89 c7             	mov    %rax,%rdi
  8048a8:	48 b8 e1 27 80 00 00 	movabs $0x8027e1,%rax
  8048af:	00 00 00 
  8048b2:	ff d0                	callq  *%rax
  8048b4:	48 89 c6             	mov    %rax,%rsi
  8048b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8048bc:	48 b8 b1 20 80 00 00 	movabs $0x8020b1,%rax
  8048c3:	00 00 00 
  8048c6:	ff d0                	callq  *%rax
}
  8048c8:	c9                   	leaveq 
  8048c9:	c3                   	retq   

00000000008048ca <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8048ca:	55                   	push   %rbp
  8048cb:	48 89 e5             	mov    %rsp,%rbp
  8048ce:	48 83 ec 20          	sub    $0x20,%rsp
  8048d2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  8048d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8048d9:	75 35                	jne    804910 <wait+0x46>
  8048db:	48 b9 af 55 80 00 00 	movabs $0x8055af,%rcx
  8048e2:	00 00 00 
  8048e5:	48 ba ba 55 80 00 00 	movabs $0x8055ba,%rdx
  8048ec:	00 00 00 
  8048ef:	be 09 00 00 00       	mov    $0x9,%esi
  8048f4:	48 bf cf 55 80 00 00 	movabs $0x8055cf,%rdi
  8048fb:	00 00 00 
  8048fe:	b8 00 00 00 00       	mov    $0x0,%eax
  804903:	49 b8 e9 08 80 00 00 	movabs $0x8008e9,%r8
  80490a:	00 00 00 
  80490d:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  804910:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804913:	25 ff 03 00 00       	and    $0x3ff,%eax
  804918:	48 63 d0             	movslq %eax,%rdx
  80491b:	48 89 d0             	mov    %rdx,%rax
  80491e:	48 c1 e0 03          	shl    $0x3,%rax
  804922:	48 01 d0             	add    %rdx,%rax
  804925:	48 c1 e0 05          	shl    $0x5,%rax
  804929:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804930:	00 00 00 
  804933:	48 01 d0             	add    %rdx,%rax
  804936:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80493a:	eb 0c                	jmp    804948 <wait+0x7e>
		sys_yield();
  80493c:	48 b8 c8 1f 80 00 00 	movabs $0x801fc8,%rax
  804943:	00 00 00 
  804946:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804948:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80494c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804952:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804955:	75 0e                	jne    804965 <wait+0x9b>
  804957:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80495b:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804961:	85 c0                	test   %eax,%eax
  804963:	75 d7                	jne    80493c <wait+0x72>
		sys_yield();
}
  804965:	c9                   	leaveq 
  804966:	c3                   	retq   

0000000000804967 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804967:	55                   	push   %rbp
  804968:	48 89 e5             	mov    %rsp,%rbp
  80496b:	48 83 ec 10          	sub    $0x10,%rsp
  80496f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  804973:	48 b8 08 a0 80 00 00 	movabs $0x80a008,%rax
  80497a:	00 00 00 
  80497d:	48 8b 00             	mov    (%rax),%rax
  804980:	48 85 c0             	test   %rax,%rax
  804983:	75 64                	jne    8049e9 <set_pgfault_handler+0x82>
		// First time through!
		// LAB 4: Your code here.
		//envid_t eid = sys_getenvid();
		if(sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) 
  804985:	ba 07 00 00 00       	mov    $0x7,%edx
  80498a:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80498f:	bf 00 00 00 00       	mov    $0x0,%edi
  804994:	48 b8 06 20 80 00 00 	movabs $0x802006,%rax
  80499b:	00 00 00 
  80499e:	ff d0                	callq  *%rax
  8049a0:	85 c0                	test   %eax,%eax
  8049a2:	74 2a                	je     8049ce <set_pgfault_handler+0x67>
			panic("Allocation of space for UXSTACK failed\n");
  8049a4:	48 ba e0 55 80 00 00 	movabs $0x8055e0,%rdx
  8049ab:	00 00 00 
  8049ae:	be 22 00 00 00       	mov    $0x22,%esi
  8049b3:	48 bf 08 56 80 00 00 	movabs $0x805608,%rdi
  8049ba:	00 00 00 
  8049bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8049c2:	48 b9 e9 08 80 00 00 	movabs $0x8008e9,%rcx
  8049c9:	00 00 00 
  8049cc:	ff d1                	callq  *%rcx
		else
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8049ce:	48 be fc 49 80 00 00 	movabs $0x8049fc,%rsi
  8049d5:	00 00 00 
  8049d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8049dd:	48 b8 90 21 80 00 00 	movabs $0x802190,%rax
  8049e4:	00 00 00 
  8049e7:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8049e9:	48 b8 08 a0 80 00 00 	movabs $0x80a008,%rax
  8049f0:	00 00 00 
  8049f3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8049f7:	48 89 10             	mov    %rdx,(%rax)
}
  8049fa:	c9                   	leaveq 
  8049fb:	c3                   	retq   

00000000008049fc <_pgfault_upcall>:
// Call the C page fault handler.
// function argument: pointer to UTF



movq  %rsp,%rdi                // passing the function argument in rdi
  8049fc:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8049ff:	48 a1 08 a0 80 00 00 	movabs 0x80a008,%rax
  804a06:	00 00 00 
call *%rax
  804a09:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
mov 152(%rsp), %r8
  804a0b:	4c 8b 84 24 98 00 00 	mov    0x98(%rsp),%r8
  804a12:	00 
mov 136(%rsp), %r9
  804a13:	4c 8b 8c 24 88 00 00 	mov    0x88(%rsp),%r9
  804a1a:	00 
sub $8, %r8
  804a1b:	49 83 e8 08          	sub    $0x8,%r8
mov %r9, (%r8)
  804a1f:	4d 89 08             	mov    %r9,(%r8)
mov %r8, 152(%rsp)
  804a22:	4c 89 84 24 98 00 00 	mov    %r8,0x98(%rsp)
  804a29:	00 
add $16, %rsp
  804a2a:	48 83 c4 10          	add    $0x10,%rsp

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
POPA_
  804a2e:	4c 8b 3c 24          	mov    (%rsp),%r15
  804a32:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804a37:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804a3c:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804a41:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804a46:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804a4b:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804a50:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804a55:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804a5a:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804a5f:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804a64:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804a69:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804a6e:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804a73:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804a78:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
		// LAB 4: Your code here.
add $8, %rsp
  804a7c:	48 83 c4 08          	add    $0x8,%rsp
popf
  804a80:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
mov (%rsp), %rsp
  804a81:	48 8b 24 24          	mov    (%rsp),%rsp
    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
ret
  804a85:	c3                   	retq   

0000000000804a86 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804a86:	55                   	push   %rbp
  804a87:	48 89 e5             	mov    %rsp,%rbp
  804a8a:	48 83 ec 30          	sub    $0x30,%rsp
  804a8e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804a92:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804a96:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  804a9a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804a9f:	74 18                	je     804ab9 <ipc_recv+0x33>
  804aa1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804aa5:	48 89 c7             	mov    %rax,%rdi
  804aa8:	48 b8 2f 22 80 00 00 	movabs $0x80222f,%rax
  804aaf:	00 00 00 
  804ab2:	ff d0                	callq  *%rax
  804ab4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804ab7:	eb 19                	jmp    804ad2 <ipc_recv+0x4c>
  804ab9:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  804ac0:	00 00 00 
  804ac3:	48 b8 2f 22 80 00 00 	movabs $0x80222f,%rax
  804aca:	00 00 00 
  804acd:	ff d0                	callq  *%rax
  804acf:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  804ad2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804ad7:	74 26                	je     804aff <ipc_recv+0x79>
  804ad9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804add:	75 15                	jne    804af4 <ipc_recv+0x6e>
  804adf:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804ae6:	00 00 00 
  804ae9:	48 8b 00             	mov    (%rax),%rax
  804aec:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  804af2:	eb 05                	jmp    804af9 <ipc_recv+0x73>
  804af4:	b8 00 00 00 00       	mov    $0x0,%eax
  804af9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804afd:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  804aff:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804b04:	74 26                	je     804b2c <ipc_recv+0xa6>
  804b06:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804b0a:	75 15                	jne    804b21 <ipc_recv+0x9b>
  804b0c:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804b13:	00 00 00 
  804b16:	48 8b 00             	mov    (%rax),%rax
  804b19:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  804b1f:	eb 05                	jmp    804b26 <ipc_recv+0xa0>
  804b21:	b8 00 00 00 00       	mov    $0x0,%eax
  804b26:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804b2a:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  804b2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804b30:	75 15                	jne    804b47 <ipc_recv+0xc1>
  804b32:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804b39:	00 00 00 
  804b3c:	48 8b 00             	mov    (%rax),%rax
  804b3f:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  804b45:	eb 03                	jmp    804b4a <ipc_recv+0xc4>
  804b47:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804b4a:	c9                   	leaveq 
  804b4b:	c3                   	retq   

0000000000804b4c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804b4c:	55                   	push   %rbp
  804b4d:	48 89 e5             	mov    %rsp,%rbp
  804b50:	48 83 ec 30          	sub    $0x30,%rsp
  804b54:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804b57:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804b5a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804b5e:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  804b61:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  804b68:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804b6d:	75 10                	jne    804b7f <ipc_send+0x33>
  804b6f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804b76:	00 00 00 
  804b79:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  804b7d:	eb 62                	jmp    804be1 <ipc_send+0x95>
  804b7f:	eb 60                	jmp    804be1 <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  804b81:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804b85:	74 30                	je     804bb7 <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  804b87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b8a:	89 c1                	mov    %eax,%ecx
  804b8c:	48 ba 16 56 80 00 00 	movabs $0x805616,%rdx
  804b93:	00 00 00 
  804b96:	be 33 00 00 00       	mov    $0x33,%esi
  804b9b:	48 bf 32 56 80 00 00 	movabs $0x805632,%rdi
  804ba2:	00 00 00 
  804ba5:	b8 00 00 00 00       	mov    $0x0,%eax
  804baa:	49 b8 e9 08 80 00 00 	movabs $0x8008e9,%r8
  804bb1:	00 00 00 
  804bb4:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  804bb7:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804bba:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804bbd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804bc1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804bc4:	89 c7                	mov    %eax,%edi
  804bc6:	48 b8 da 21 80 00 00 	movabs $0x8021da,%rax
  804bcd:	00 00 00 
  804bd0:	ff d0                	callq  *%rax
  804bd2:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  804bd5:	48 b8 c8 1f 80 00 00 	movabs $0x801fc8,%rax
  804bdc:	00 00 00 
  804bdf:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  804be1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804be5:	75 9a                	jne    804b81 <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  804be7:	c9                   	leaveq 
  804be8:	c3                   	retq   

0000000000804be9 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804be9:	55                   	push   %rbp
  804bea:	48 89 e5             	mov    %rsp,%rbp
  804bed:	48 83 ec 14          	sub    $0x14,%rsp
  804bf1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804bf4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804bfb:	eb 5e                	jmp    804c5b <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804bfd:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804c04:	00 00 00 
  804c07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c0a:	48 63 d0             	movslq %eax,%rdx
  804c0d:	48 89 d0             	mov    %rdx,%rax
  804c10:	48 c1 e0 03          	shl    $0x3,%rax
  804c14:	48 01 d0             	add    %rdx,%rax
  804c17:	48 c1 e0 05          	shl    $0x5,%rax
  804c1b:	48 01 c8             	add    %rcx,%rax
  804c1e:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804c24:	8b 00                	mov    (%rax),%eax
  804c26:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804c29:	75 2c                	jne    804c57 <ipc_find_env+0x6e>
			return envs[i].env_id;
  804c2b:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804c32:	00 00 00 
  804c35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c38:	48 63 d0             	movslq %eax,%rdx
  804c3b:	48 89 d0             	mov    %rdx,%rax
  804c3e:	48 c1 e0 03          	shl    $0x3,%rax
  804c42:	48 01 d0             	add    %rdx,%rax
  804c45:	48 c1 e0 05          	shl    $0x5,%rax
  804c49:	48 01 c8             	add    %rcx,%rax
  804c4c:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804c52:	8b 40 08             	mov    0x8(%rax),%eax
  804c55:	eb 12                	jmp    804c69 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804c57:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804c5b:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804c62:	7e 99                	jle    804bfd <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804c64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804c69:	c9                   	leaveq 
  804c6a:	c3                   	retq   

0000000000804c6b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804c6b:	55                   	push   %rbp
  804c6c:	48 89 e5             	mov    %rsp,%rbp
  804c6f:	48 83 ec 18          	sub    $0x18,%rsp
  804c73:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804c77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804c7b:	48 c1 e8 15          	shr    $0x15,%rax
  804c7f:	48 89 c2             	mov    %rax,%rdx
  804c82:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804c89:	01 00 00 
  804c8c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804c90:	83 e0 01             	and    $0x1,%eax
  804c93:	48 85 c0             	test   %rax,%rax
  804c96:	75 07                	jne    804c9f <pageref+0x34>
		return 0;
  804c98:	b8 00 00 00 00       	mov    $0x0,%eax
  804c9d:	eb 53                	jmp    804cf2 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804c9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804ca3:	48 c1 e8 0c          	shr    $0xc,%rax
  804ca7:	48 89 c2             	mov    %rax,%rdx
  804caa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804cb1:	01 00 00 
  804cb4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804cb8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804cbc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804cc0:	83 e0 01             	and    $0x1,%eax
  804cc3:	48 85 c0             	test   %rax,%rax
  804cc6:	75 07                	jne    804ccf <pageref+0x64>
		return 0;
  804cc8:	b8 00 00 00 00       	mov    $0x0,%eax
  804ccd:	eb 23                	jmp    804cf2 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804ccf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804cd3:	48 c1 e8 0c          	shr    $0xc,%rax
  804cd7:	48 89 c2             	mov    %rax,%rdx
  804cda:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804ce1:	00 00 00 
  804ce4:	48 c1 e2 04          	shl    $0x4,%rdx
  804ce8:	48 01 d0             	add    %rdx,%rax
  804ceb:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804cef:	0f b7 c0             	movzwl %ax,%eax
}
  804cf2:	c9                   	leaveq 
  804cf3:	c3                   	retq   
