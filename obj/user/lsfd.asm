
obj/user/lsfd:     file format elf64-x86-64


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
  80003c:	e8 7c 01 00 00       	callq  8001bd <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
	cprintf("usage: lsfd [-1]\n");
  800047:	48 bf 20 3c 80 00 00 	movabs $0x803c20,%rdi
  80004e:	00 00 00 
  800051:	b8 00 00 00 00       	mov    $0x0,%eax
  800056:	48 ba 95 03 80 00 00 	movabs $0x800395,%rdx
  80005d:	00 00 00 
  800060:	ff d2                	callq  *%rdx
	exit();
  800062:	48 b8 4d 02 80 00 00 	movabs $0x80024d,%rax
  800069:	00 00 00 
  80006c:	ff d0                	callq  *%rax
}
  80006e:	5d                   	pop    %rbp
  80006f:	c3                   	retq   

0000000000800070 <umain>:

void
umain(int argc, char **argv)
{
  800070:	55                   	push   %rbp
  800071:	48 89 e5             	mov    %rsp,%rbp
  800074:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  80007b:	89 bd 3c ff ff ff    	mov    %edi,-0xc4(%rbp)
  800081:	48 89 b5 30 ff ff ff 	mov    %rsi,-0xd0(%rbp)
	int i, usefprint = 0;
  800088:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
  80008f:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  800096:	48 8b 8d 30 ff ff ff 	mov    -0xd0(%rbp),%rcx
  80009d:	48 8d 85 3c ff ff ff 	lea    -0xc4(%rbp),%rax
  8000a4:	48 89 ce             	mov    %rcx,%rsi
  8000a7:	48 89 c7             	mov    %rax,%rdi
  8000aa:	48 b8 e6 1a 80 00 00 	movabs $0x801ae6,%rax
  8000b1:	00 00 00 
  8000b4:	ff d0                	callq  *%rax
	while ((i = argnext(&args)) >= 0)
  8000b6:	eb 1b                	jmp    8000d3 <umain+0x63>
		if (i == '1')
  8000b8:	83 7d fc 31          	cmpl   $0x31,-0x4(%rbp)
  8000bc:	75 09                	jne    8000c7 <umain+0x57>
			usefprint = 1;
  8000be:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
  8000c5:	eb 0c                	jmp    8000d3 <umain+0x63>
		else
			usage();
  8000c7:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000ce:	00 00 00 
  8000d1:	ff d0                	callq  *%rax
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  8000d3:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8000da:	48 89 c7             	mov    %rax,%rdi
  8000dd:	48 b8 4a 1b 80 00 00 	movabs $0x801b4a,%rax
  8000e4:	00 00 00 
  8000e7:	ff d0                	callq  *%rax
  8000e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000f0:	79 c6                	jns    8000b8 <umain+0x48>
		if (i == '1')
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
  8000f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8000f9:	e9 b3 00 00 00       	jmpq   8001b1 <umain+0x141>
		if (fstat(i, &st) >= 0) {
  8000fe:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800105:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800108:	48 89 d6             	mov    %rdx,%rsi
  80010b:	89 c7                	mov    %eax,%edi
  80010d:	48 b8 12 26 80 00 00 	movabs $0x802612,%rax
  800114:	00 00 00 
  800117:	ff d0                	callq  *%rax
  800119:	85 c0                	test   %eax,%eax
  80011b:	0f 88 8c 00 00 00    	js     8001ad <umain+0x13d>
			if (usefprint)
  800121:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800125:	74 4a                	je     800171 <umain+0x101>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
  800127:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
			usage();

	for (i = 0; i < 32; i++)
		if (fstat(i, &st) >= 0) {
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  80012b:	48 8b 48 08          	mov    0x8(%rax),%rcx
  80012f:	8b 7d e0             	mov    -0x20(%rbp),%edi
  800132:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800135:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  80013c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80013f:	48 89 0c 24          	mov    %rcx,(%rsp)
  800143:	41 89 f9             	mov    %edi,%r9d
  800146:	41 89 f0             	mov    %esi,%r8d
  800149:	48 89 d1             	mov    %rdx,%rcx
  80014c:	89 c2                	mov    %eax,%edx
  80014e:	48 be 38 3c 80 00 00 	movabs $0x803c38,%rsi
  800155:	00 00 00 
  800158:	bf 01 00 00 00       	mov    $0x1,%edi
  80015d:	b8 00 00 00 00       	mov    $0x0,%eax
  800162:	49 ba b2 2e 80 00 00 	movabs $0x802eb2,%r10
  800169:	00 00 00 
  80016c:	41 ff d2             	callq  *%r10
  80016f:	eb 3c                	jmp    8001ad <umain+0x13d>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
  800171:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  800175:	48 8b 78 08          	mov    0x8(%rax),%rdi
  800179:	8b 75 e0             	mov    -0x20(%rbp),%esi
  80017c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80017f:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800186:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800189:	49 89 f9             	mov    %rdi,%r9
  80018c:	41 89 f0             	mov    %esi,%r8d
  80018f:	89 c6                	mov    %eax,%esi
  800191:	48 bf 38 3c 80 00 00 	movabs $0x803c38,%rdi
  800198:	00 00 00 
  80019b:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a0:	49 ba 95 03 80 00 00 	movabs $0x800395,%r10
  8001a7:	00 00 00 
  8001aa:	41 ff d2             	callq  *%r10
		if (i == '1')
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
  8001ad:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8001b1:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8001b5:	0f 8e 43 ff ff ff    	jle    8000fe <umain+0x8e>
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  8001bb:	c9                   	leaveq 
  8001bc:	c3                   	retq   

00000000008001bd <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001bd:	55                   	push   %rbp
  8001be:	48 89 e5             	mov    %rsp,%rbp
  8001c1:	48 83 ec 10          	sub    $0x10,%rsp
  8001c5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001c8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  8001cc:	48 b8 fd 17 80 00 00 	movabs $0x8017fd,%rax
  8001d3:	00 00 00 
  8001d6:	ff d0                	callq  *%rax
  8001d8:	48 98                	cltq   
  8001da:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001df:	48 89 c2             	mov    %rax,%rdx
  8001e2:	48 89 d0             	mov    %rdx,%rax
  8001e5:	48 c1 e0 03          	shl    $0x3,%rax
  8001e9:	48 01 d0             	add    %rdx,%rax
  8001ec:	48 c1 e0 05          	shl    $0x5,%rax
  8001f0:	48 89 c2             	mov    %rax,%rdx
  8001f3:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001fa:	00 00 00 
  8001fd:	48 01 c2             	add    %rax,%rdx
  800200:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800207:	00 00 00 
  80020a:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80020d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800211:	7e 14                	jle    800227 <libmain+0x6a>
		binaryname = argv[0];
  800213:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800217:	48 8b 10             	mov    (%rax),%rdx
  80021a:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800221:	00 00 00 
  800224:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800227:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80022b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80022e:	48 89 d6             	mov    %rdx,%rsi
  800231:	89 c7                	mov    %eax,%edi
  800233:	48 b8 70 00 80 00 00 	movabs $0x800070,%rax
  80023a:	00 00 00 
  80023d:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80023f:	48 b8 4d 02 80 00 00 	movabs $0x80024d,%rax
  800246:	00 00 00 
  800249:	ff d0                	callq  *%rax
}
  80024b:	c9                   	leaveq 
  80024c:	c3                   	retq   

000000000080024d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80024d:	55                   	push   %rbp
  80024e:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800251:	48 b8 0c 21 80 00 00 	movabs $0x80210c,%rax
  800258:	00 00 00 
  80025b:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80025d:	bf 00 00 00 00       	mov    $0x0,%edi
  800262:	48 b8 b9 17 80 00 00 	movabs $0x8017b9,%rax
  800269:	00 00 00 
  80026c:	ff d0                	callq  *%rax
}
  80026e:	5d                   	pop    %rbp
  80026f:	c3                   	retq   

0000000000800270 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800270:	55                   	push   %rbp
  800271:	48 89 e5             	mov    %rsp,%rbp
  800274:	48 83 ec 10          	sub    $0x10,%rsp
  800278:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80027b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80027f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800283:	8b 00                	mov    (%rax),%eax
  800285:	8d 48 01             	lea    0x1(%rax),%ecx
  800288:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80028c:	89 0a                	mov    %ecx,(%rdx)
  80028e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800291:	89 d1                	mov    %edx,%ecx
  800293:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800297:	48 98                	cltq   
  800299:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80029d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002a1:	8b 00                	mov    (%rax),%eax
  8002a3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002a8:	75 2c                	jne    8002d6 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8002aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002ae:	8b 00                	mov    (%rax),%eax
  8002b0:	48 98                	cltq   
  8002b2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002b6:	48 83 c2 08          	add    $0x8,%rdx
  8002ba:	48 89 c6             	mov    %rax,%rsi
  8002bd:	48 89 d7             	mov    %rdx,%rdi
  8002c0:	48 b8 31 17 80 00 00 	movabs $0x801731,%rax
  8002c7:	00 00 00 
  8002ca:	ff d0                	callq  *%rax
        b->idx = 0;
  8002cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002d0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8002d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002da:	8b 40 04             	mov    0x4(%rax),%eax
  8002dd:	8d 50 01             	lea    0x1(%rax),%edx
  8002e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002e4:	89 50 04             	mov    %edx,0x4(%rax)
}
  8002e7:	c9                   	leaveq 
  8002e8:	c3                   	retq   

00000000008002e9 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8002e9:	55                   	push   %rbp
  8002ea:	48 89 e5             	mov    %rsp,%rbp
  8002ed:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8002f4:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8002fb:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800302:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800309:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800310:	48 8b 0a             	mov    (%rdx),%rcx
  800313:	48 89 08             	mov    %rcx,(%rax)
  800316:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80031a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80031e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800322:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800326:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80032d:	00 00 00 
    b.cnt = 0;
  800330:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800337:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80033a:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800341:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800348:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80034f:	48 89 c6             	mov    %rax,%rsi
  800352:	48 bf 70 02 80 00 00 	movabs $0x800270,%rdi
  800359:	00 00 00 
  80035c:	48 b8 48 07 80 00 00 	movabs $0x800748,%rax
  800363:	00 00 00 
  800366:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800368:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80036e:	48 98                	cltq   
  800370:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800377:	48 83 c2 08          	add    $0x8,%rdx
  80037b:	48 89 c6             	mov    %rax,%rsi
  80037e:	48 89 d7             	mov    %rdx,%rdi
  800381:	48 b8 31 17 80 00 00 	movabs $0x801731,%rax
  800388:	00 00 00 
  80038b:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80038d:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800393:	c9                   	leaveq 
  800394:	c3                   	retq   

0000000000800395 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800395:	55                   	push   %rbp
  800396:	48 89 e5             	mov    %rsp,%rbp
  800399:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8003a0:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8003a7:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8003ae:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8003b5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8003bc:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8003c3:	84 c0                	test   %al,%al
  8003c5:	74 20                	je     8003e7 <cprintf+0x52>
  8003c7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8003cb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8003cf:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8003d3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8003d7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8003db:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8003df:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8003e3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8003e7:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8003ee:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8003f5:	00 00 00 
  8003f8:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8003ff:	00 00 00 
  800402:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800406:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80040d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800414:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80041b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800422:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800429:	48 8b 0a             	mov    (%rdx),%rcx
  80042c:	48 89 08             	mov    %rcx,(%rax)
  80042f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800433:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800437:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80043b:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80043f:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800446:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80044d:	48 89 d6             	mov    %rdx,%rsi
  800450:	48 89 c7             	mov    %rax,%rdi
  800453:	48 b8 e9 02 80 00 00 	movabs $0x8002e9,%rax
  80045a:	00 00 00 
  80045d:	ff d0                	callq  *%rax
  80045f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800465:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80046b:	c9                   	leaveq 
  80046c:	c3                   	retq   

000000000080046d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80046d:	55                   	push   %rbp
  80046e:	48 89 e5             	mov    %rsp,%rbp
  800471:	53                   	push   %rbx
  800472:	48 83 ec 38          	sub    $0x38,%rsp
  800476:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80047a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80047e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800482:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800485:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800489:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80048d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800490:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800494:	77 3b                	ja     8004d1 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800496:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800499:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80049d:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8004a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a9:	48 f7 f3             	div    %rbx
  8004ac:	48 89 c2             	mov    %rax,%rdx
  8004af:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8004b2:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8004b5:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8004b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004bd:	41 89 f9             	mov    %edi,%r9d
  8004c0:	48 89 c7             	mov    %rax,%rdi
  8004c3:	48 b8 6d 04 80 00 00 	movabs $0x80046d,%rax
  8004ca:	00 00 00 
  8004cd:	ff d0                	callq  *%rax
  8004cf:	eb 1e                	jmp    8004ef <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004d1:	eb 12                	jmp    8004e5 <printnum+0x78>
			putch(padc, putdat);
  8004d3:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8004d7:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8004da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004de:	48 89 ce             	mov    %rcx,%rsi
  8004e1:	89 d7                	mov    %edx,%edi
  8004e3:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004e5:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8004e9:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8004ed:	7f e4                	jg     8004d3 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004ef:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8004f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8004fb:	48 f7 f1             	div    %rcx
  8004fe:	48 89 d0             	mov    %rdx,%rax
  800501:	48 ba 70 3e 80 00 00 	movabs $0x803e70,%rdx
  800508:	00 00 00 
  80050b:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80050f:	0f be d0             	movsbl %al,%edx
  800512:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800516:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80051a:	48 89 ce             	mov    %rcx,%rsi
  80051d:	89 d7                	mov    %edx,%edi
  80051f:	ff d0                	callq  *%rax
}
  800521:	48 83 c4 38          	add    $0x38,%rsp
  800525:	5b                   	pop    %rbx
  800526:	5d                   	pop    %rbp
  800527:	c3                   	retq   

0000000000800528 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800528:	55                   	push   %rbp
  800529:	48 89 e5             	mov    %rsp,%rbp
  80052c:	48 83 ec 1c          	sub    $0x1c,%rsp
  800530:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800534:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800537:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80053b:	7e 52                	jle    80058f <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80053d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800541:	8b 00                	mov    (%rax),%eax
  800543:	83 f8 30             	cmp    $0x30,%eax
  800546:	73 24                	jae    80056c <getuint+0x44>
  800548:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800550:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800554:	8b 00                	mov    (%rax),%eax
  800556:	89 c0                	mov    %eax,%eax
  800558:	48 01 d0             	add    %rdx,%rax
  80055b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80055f:	8b 12                	mov    (%rdx),%edx
  800561:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800564:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800568:	89 0a                	mov    %ecx,(%rdx)
  80056a:	eb 17                	jmp    800583 <getuint+0x5b>
  80056c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800570:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800574:	48 89 d0             	mov    %rdx,%rax
  800577:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80057b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80057f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800583:	48 8b 00             	mov    (%rax),%rax
  800586:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80058a:	e9 a3 00 00 00       	jmpq   800632 <getuint+0x10a>
	else if (lflag)
  80058f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800593:	74 4f                	je     8005e4 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800595:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800599:	8b 00                	mov    (%rax),%eax
  80059b:	83 f8 30             	cmp    $0x30,%eax
  80059e:	73 24                	jae    8005c4 <getuint+0x9c>
  8005a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ac:	8b 00                	mov    (%rax),%eax
  8005ae:	89 c0                	mov    %eax,%eax
  8005b0:	48 01 d0             	add    %rdx,%rax
  8005b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b7:	8b 12                	mov    (%rdx),%edx
  8005b9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005c0:	89 0a                	mov    %ecx,(%rdx)
  8005c2:	eb 17                	jmp    8005db <getuint+0xb3>
  8005c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005cc:	48 89 d0             	mov    %rdx,%rax
  8005cf:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005db:	48 8b 00             	mov    (%rax),%rax
  8005de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005e2:	eb 4e                	jmp    800632 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8005e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e8:	8b 00                	mov    (%rax),%eax
  8005ea:	83 f8 30             	cmp    $0x30,%eax
  8005ed:	73 24                	jae    800613 <getuint+0xeb>
  8005ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005fb:	8b 00                	mov    (%rax),%eax
  8005fd:	89 c0                	mov    %eax,%eax
  8005ff:	48 01 d0             	add    %rdx,%rax
  800602:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800606:	8b 12                	mov    (%rdx),%edx
  800608:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80060b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80060f:	89 0a                	mov    %ecx,(%rdx)
  800611:	eb 17                	jmp    80062a <getuint+0x102>
  800613:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800617:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80061b:	48 89 d0             	mov    %rdx,%rax
  80061e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800622:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800626:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80062a:	8b 00                	mov    (%rax),%eax
  80062c:	89 c0                	mov    %eax,%eax
  80062e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800632:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800636:	c9                   	leaveq 
  800637:	c3                   	retq   

0000000000800638 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800638:	55                   	push   %rbp
  800639:	48 89 e5             	mov    %rsp,%rbp
  80063c:	48 83 ec 1c          	sub    $0x1c,%rsp
  800640:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800644:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800647:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80064b:	7e 52                	jle    80069f <getint+0x67>
		x=va_arg(*ap, long long);
  80064d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800651:	8b 00                	mov    (%rax),%eax
  800653:	83 f8 30             	cmp    $0x30,%eax
  800656:	73 24                	jae    80067c <getint+0x44>
  800658:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800660:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800664:	8b 00                	mov    (%rax),%eax
  800666:	89 c0                	mov    %eax,%eax
  800668:	48 01 d0             	add    %rdx,%rax
  80066b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80066f:	8b 12                	mov    (%rdx),%edx
  800671:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800674:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800678:	89 0a                	mov    %ecx,(%rdx)
  80067a:	eb 17                	jmp    800693 <getint+0x5b>
  80067c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800680:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800684:	48 89 d0             	mov    %rdx,%rax
  800687:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80068b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800693:	48 8b 00             	mov    (%rax),%rax
  800696:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80069a:	e9 a3 00 00 00       	jmpq   800742 <getint+0x10a>
	else if (lflag)
  80069f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006a3:	74 4f                	je     8006f4 <getint+0xbc>
		x=va_arg(*ap, long);
  8006a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a9:	8b 00                	mov    (%rax),%eax
  8006ab:	83 f8 30             	cmp    $0x30,%eax
  8006ae:	73 24                	jae    8006d4 <getint+0x9c>
  8006b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bc:	8b 00                	mov    (%rax),%eax
  8006be:	89 c0                	mov    %eax,%eax
  8006c0:	48 01 d0             	add    %rdx,%rax
  8006c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c7:	8b 12                	mov    (%rdx),%edx
  8006c9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d0:	89 0a                	mov    %ecx,(%rdx)
  8006d2:	eb 17                	jmp    8006eb <getint+0xb3>
  8006d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006dc:	48 89 d0             	mov    %rdx,%rax
  8006df:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006eb:	48 8b 00             	mov    (%rax),%rax
  8006ee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006f2:	eb 4e                	jmp    800742 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8006f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f8:	8b 00                	mov    (%rax),%eax
  8006fa:	83 f8 30             	cmp    $0x30,%eax
  8006fd:	73 24                	jae    800723 <getint+0xeb>
  8006ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800703:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800707:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070b:	8b 00                	mov    (%rax),%eax
  80070d:	89 c0                	mov    %eax,%eax
  80070f:	48 01 d0             	add    %rdx,%rax
  800712:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800716:	8b 12                	mov    (%rdx),%edx
  800718:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80071b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071f:	89 0a                	mov    %ecx,(%rdx)
  800721:	eb 17                	jmp    80073a <getint+0x102>
  800723:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800727:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80072b:	48 89 d0             	mov    %rdx,%rax
  80072e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800732:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800736:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80073a:	8b 00                	mov    (%rax),%eax
  80073c:	48 98                	cltq   
  80073e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800742:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800746:	c9                   	leaveq 
  800747:	c3                   	retq   

0000000000800748 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800748:	55                   	push   %rbp
  800749:	48 89 e5             	mov    %rsp,%rbp
  80074c:	41 54                	push   %r12
  80074e:	53                   	push   %rbx
  80074f:	48 83 ec 60          	sub    $0x60,%rsp
  800753:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800757:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80075b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80075f:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800763:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800767:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80076b:	48 8b 0a             	mov    (%rdx),%rcx
  80076e:	48 89 08             	mov    %rcx,(%rax)
  800771:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800775:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800779:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80077d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800781:	eb 17                	jmp    80079a <vprintfmt+0x52>
			if (ch == '\0')
  800783:	85 db                	test   %ebx,%ebx
  800785:	0f 84 cc 04 00 00    	je     800c57 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  80078b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80078f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800793:	48 89 d6             	mov    %rdx,%rsi
  800796:	89 df                	mov    %ebx,%edi
  800798:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80079a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80079e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8007a2:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007a6:	0f b6 00             	movzbl (%rax),%eax
  8007a9:	0f b6 d8             	movzbl %al,%ebx
  8007ac:	83 fb 25             	cmp    $0x25,%ebx
  8007af:	75 d2                	jne    800783 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007b1:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8007b5:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8007bc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8007c3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8007ca:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007d1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007d5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8007d9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007dd:	0f b6 00             	movzbl (%rax),%eax
  8007e0:	0f b6 d8             	movzbl %al,%ebx
  8007e3:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8007e6:	83 f8 55             	cmp    $0x55,%eax
  8007e9:	0f 87 34 04 00 00    	ja     800c23 <vprintfmt+0x4db>
  8007ef:	89 c0                	mov    %eax,%eax
  8007f1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8007f8:	00 
  8007f9:	48 b8 98 3e 80 00 00 	movabs $0x803e98,%rax
  800800:	00 00 00 
  800803:	48 01 d0             	add    %rdx,%rax
  800806:	48 8b 00             	mov    (%rax),%rax
  800809:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80080b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80080f:	eb c0                	jmp    8007d1 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800811:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800815:	eb ba                	jmp    8007d1 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800817:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80081e:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800821:	89 d0                	mov    %edx,%eax
  800823:	c1 e0 02             	shl    $0x2,%eax
  800826:	01 d0                	add    %edx,%eax
  800828:	01 c0                	add    %eax,%eax
  80082a:	01 d8                	add    %ebx,%eax
  80082c:	83 e8 30             	sub    $0x30,%eax
  80082f:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800832:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800836:	0f b6 00             	movzbl (%rax),%eax
  800839:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80083c:	83 fb 2f             	cmp    $0x2f,%ebx
  80083f:	7e 0c                	jle    80084d <vprintfmt+0x105>
  800841:	83 fb 39             	cmp    $0x39,%ebx
  800844:	7f 07                	jg     80084d <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800846:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80084b:	eb d1                	jmp    80081e <vprintfmt+0xd6>
			goto process_precision;
  80084d:	eb 58                	jmp    8008a7 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80084f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800852:	83 f8 30             	cmp    $0x30,%eax
  800855:	73 17                	jae    80086e <vprintfmt+0x126>
  800857:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80085b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80085e:	89 c0                	mov    %eax,%eax
  800860:	48 01 d0             	add    %rdx,%rax
  800863:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800866:	83 c2 08             	add    $0x8,%edx
  800869:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80086c:	eb 0f                	jmp    80087d <vprintfmt+0x135>
  80086e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800872:	48 89 d0             	mov    %rdx,%rax
  800875:	48 83 c2 08          	add    $0x8,%rdx
  800879:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80087d:	8b 00                	mov    (%rax),%eax
  80087f:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800882:	eb 23                	jmp    8008a7 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800884:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800888:	79 0c                	jns    800896 <vprintfmt+0x14e>
				width = 0;
  80088a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800891:	e9 3b ff ff ff       	jmpq   8007d1 <vprintfmt+0x89>
  800896:	e9 36 ff ff ff       	jmpq   8007d1 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80089b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8008a2:	e9 2a ff ff ff       	jmpq   8007d1 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8008a7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008ab:	79 12                	jns    8008bf <vprintfmt+0x177>
				width = precision, precision = -1;
  8008ad:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008b0:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8008b3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8008ba:	e9 12 ff ff ff       	jmpq   8007d1 <vprintfmt+0x89>
  8008bf:	e9 0d ff ff ff       	jmpq   8007d1 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008c4:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8008c8:	e9 04 ff ff ff       	jmpq   8007d1 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8008cd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008d0:	83 f8 30             	cmp    $0x30,%eax
  8008d3:	73 17                	jae    8008ec <vprintfmt+0x1a4>
  8008d5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008d9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008dc:	89 c0                	mov    %eax,%eax
  8008de:	48 01 d0             	add    %rdx,%rax
  8008e1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008e4:	83 c2 08             	add    $0x8,%edx
  8008e7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008ea:	eb 0f                	jmp    8008fb <vprintfmt+0x1b3>
  8008ec:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008f0:	48 89 d0             	mov    %rdx,%rax
  8008f3:	48 83 c2 08          	add    $0x8,%rdx
  8008f7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008fb:	8b 10                	mov    (%rax),%edx
  8008fd:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800901:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800905:	48 89 ce             	mov    %rcx,%rsi
  800908:	89 d7                	mov    %edx,%edi
  80090a:	ff d0                	callq  *%rax
			break;
  80090c:	e9 40 03 00 00       	jmpq   800c51 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800911:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800914:	83 f8 30             	cmp    $0x30,%eax
  800917:	73 17                	jae    800930 <vprintfmt+0x1e8>
  800919:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80091d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800920:	89 c0                	mov    %eax,%eax
  800922:	48 01 d0             	add    %rdx,%rax
  800925:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800928:	83 c2 08             	add    $0x8,%edx
  80092b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80092e:	eb 0f                	jmp    80093f <vprintfmt+0x1f7>
  800930:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800934:	48 89 d0             	mov    %rdx,%rax
  800937:	48 83 c2 08          	add    $0x8,%rdx
  80093b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80093f:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800941:	85 db                	test   %ebx,%ebx
  800943:	79 02                	jns    800947 <vprintfmt+0x1ff>
				err = -err;
  800945:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800947:	83 fb 15             	cmp    $0x15,%ebx
  80094a:	7f 16                	jg     800962 <vprintfmt+0x21a>
  80094c:	48 b8 c0 3d 80 00 00 	movabs $0x803dc0,%rax
  800953:	00 00 00 
  800956:	48 63 d3             	movslq %ebx,%rdx
  800959:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80095d:	4d 85 e4             	test   %r12,%r12
  800960:	75 2e                	jne    800990 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800962:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800966:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80096a:	89 d9                	mov    %ebx,%ecx
  80096c:	48 ba 81 3e 80 00 00 	movabs $0x803e81,%rdx
  800973:	00 00 00 
  800976:	48 89 c7             	mov    %rax,%rdi
  800979:	b8 00 00 00 00       	mov    $0x0,%eax
  80097e:	49 b8 60 0c 80 00 00 	movabs $0x800c60,%r8
  800985:	00 00 00 
  800988:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80098b:	e9 c1 02 00 00       	jmpq   800c51 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800990:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800994:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800998:	4c 89 e1             	mov    %r12,%rcx
  80099b:	48 ba 8a 3e 80 00 00 	movabs $0x803e8a,%rdx
  8009a2:	00 00 00 
  8009a5:	48 89 c7             	mov    %rax,%rdi
  8009a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ad:	49 b8 60 0c 80 00 00 	movabs $0x800c60,%r8
  8009b4:	00 00 00 
  8009b7:	41 ff d0             	callq  *%r8
			break;
  8009ba:	e9 92 02 00 00       	jmpq   800c51 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8009bf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c2:	83 f8 30             	cmp    $0x30,%eax
  8009c5:	73 17                	jae    8009de <vprintfmt+0x296>
  8009c7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009cb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ce:	89 c0                	mov    %eax,%eax
  8009d0:	48 01 d0             	add    %rdx,%rax
  8009d3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009d6:	83 c2 08             	add    $0x8,%edx
  8009d9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009dc:	eb 0f                	jmp    8009ed <vprintfmt+0x2a5>
  8009de:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009e2:	48 89 d0             	mov    %rdx,%rax
  8009e5:	48 83 c2 08          	add    $0x8,%rdx
  8009e9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009ed:	4c 8b 20             	mov    (%rax),%r12
  8009f0:	4d 85 e4             	test   %r12,%r12
  8009f3:	75 0a                	jne    8009ff <vprintfmt+0x2b7>
				p = "(null)";
  8009f5:	49 bc 8d 3e 80 00 00 	movabs $0x803e8d,%r12
  8009fc:	00 00 00 
			if (width > 0 && padc != '-')
  8009ff:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a03:	7e 3f                	jle    800a44 <vprintfmt+0x2fc>
  800a05:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800a09:	74 39                	je     800a44 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a0b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a0e:	48 98                	cltq   
  800a10:	48 89 c6             	mov    %rax,%rsi
  800a13:	4c 89 e7             	mov    %r12,%rdi
  800a16:	48 b8 0c 0f 80 00 00 	movabs $0x800f0c,%rax
  800a1d:	00 00 00 
  800a20:	ff d0                	callq  *%rax
  800a22:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800a25:	eb 17                	jmp    800a3e <vprintfmt+0x2f6>
					putch(padc, putdat);
  800a27:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800a2b:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a2f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a33:	48 89 ce             	mov    %rcx,%rsi
  800a36:	89 d7                	mov    %edx,%edi
  800a38:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a3a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a3e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a42:	7f e3                	jg     800a27 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a44:	eb 37                	jmp    800a7d <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800a46:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800a4a:	74 1e                	je     800a6a <vprintfmt+0x322>
  800a4c:	83 fb 1f             	cmp    $0x1f,%ebx
  800a4f:	7e 05                	jle    800a56 <vprintfmt+0x30e>
  800a51:	83 fb 7e             	cmp    $0x7e,%ebx
  800a54:	7e 14                	jle    800a6a <vprintfmt+0x322>
					putch('?', putdat);
  800a56:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a5a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a5e:	48 89 d6             	mov    %rdx,%rsi
  800a61:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800a66:	ff d0                	callq  *%rax
  800a68:	eb 0f                	jmp    800a79 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800a6a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a6e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a72:	48 89 d6             	mov    %rdx,%rsi
  800a75:	89 df                	mov    %ebx,%edi
  800a77:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a79:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a7d:	4c 89 e0             	mov    %r12,%rax
  800a80:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800a84:	0f b6 00             	movzbl (%rax),%eax
  800a87:	0f be d8             	movsbl %al,%ebx
  800a8a:	85 db                	test   %ebx,%ebx
  800a8c:	74 10                	je     800a9e <vprintfmt+0x356>
  800a8e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a92:	78 b2                	js     800a46 <vprintfmt+0x2fe>
  800a94:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a98:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a9c:	79 a8                	jns    800a46 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a9e:	eb 16                	jmp    800ab6 <vprintfmt+0x36e>
				putch(' ', putdat);
  800aa0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aa4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aa8:	48 89 d6             	mov    %rdx,%rsi
  800aab:	bf 20 00 00 00       	mov    $0x20,%edi
  800ab0:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ab2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ab6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800aba:	7f e4                	jg     800aa0 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800abc:	e9 90 01 00 00       	jmpq   800c51 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800ac1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ac5:	be 03 00 00 00       	mov    $0x3,%esi
  800aca:	48 89 c7             	mov    %rax,%rdi
  800acd:	48 b8 38 06 80 00 00 	movabs $0x800638,%rax
  800ad4:	00 00 00 
  800ad7:	ff d0                	callq  *%rax
  800ad9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800add:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae1:	48 85 c0             	test   %rax,%rax
  800ae4:	79 1d                	jns    800b03 <vprintfmt+0x3bb>
				putch('-', putdat);
  800ae6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aea:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aee:	48 89 d6             	mov    %rdx,%rsi
  800af1:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800af6:	ff d0                	callq  *%rax
				num = -(long long) num;
  800af8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800afc:	48 f7 d8             	neg    %rax
  800aff:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800b03:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b0a:	e9 d5 00 00 00       	jmpq   800be4 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800b0f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b13:	be 03 00 00 00       	mov    $0x3,%esi
  800b18:	48 89 c7             	mov    %rax,%rdi
  800b1b:	48 b8 28 05 80 00 00 	movabs $0x800528,%rax
  800b22:	00 00 00 
  800b25:	ff d0                	callq  *%rax
  800b27:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800b2b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b32:	e9 ad 00 00 00       	jmpq   800be4 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  800b37:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b3b:	be 03 00 00 00       	mov    $0x3,%esi
  800b40:	48 89 c7             	mov    %rax,%rdi
  800b43:	48 b8 28 05 80 00 00 	movabs $0x800528,%rax
  800b4a:	00 00 00 
  800b4d:	ff d0                	callq  *%rax
  800b4f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  800b53:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  800b5a:	e9 85 00 00 00       	jmpq   800be4 <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  800b5f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b63:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b67:	48 89 d6             	mov    %rdx,%rsi
  800b6a:	bf 30 00 00 00       	mov    $0x30,%edi
  800b6f:	ff d0                	callq  *%rax
			putch('x', putdat);
  800b71:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b75:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b79:	48 89 d6             	mov    %rdx,%rsi
  800b7c:	bf 78 00 00 00       	mov    $0x78,%edi
  800b81:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b83:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b86:	83 f8 30             	cmp    $0x30,%eax
  800b89:	73 17                	jae    800ba2 <vprintfmt+0x45a>
  800b8b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b8f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b92:	89 c0                	mov    %eax,%eax
  800b94:	48 01 d0             	add    %rdx,%rax
  800b97:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b9a:	83 c2 08             	add    $0x8,%edx
  800b9d:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ba0:	eb 0f                	jmp    800bb1 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800ba2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ba6:	48 89 d0             	mov    %rdx,%rax
  800ba9:	48 83 c2 08          	add    $0x8,%rdx
  800bad:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bb1:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bb4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800bb8:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800bbf:	eb 23                	jmp    800be4 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800bc1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bc5:	be 03 00 00 00       	mov    $0x3,%esi
  800bca:	48 89 c7             	mov    %rax,%rdi
  800bcd:	48 b8 28 05 80 00 00 	movabs $0x800528,%rax
  800bd4:	00 00 00 
  800bd7:	ff d0                	callq  *%rax
  800bd9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800bdd:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800be4:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800be9:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800bec:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800bef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bf3:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bf7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bfb:	45 89 c1             	mov    %r8d,%r9d
  800bfe:	41 89 f8             	mov    %edi,%r8d
  800c01:	48 89 c7             	mov    %rax,%rdi
  800c04:	48 b8 6d 04 80 00 00 	movabs $0x80046d,%rax
  800c0b:	00 00 00 
  800c0e:	ff d0                	callq  *%rax
			break;
  800c10:	eb 3f                	jmp    800c51 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c12:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c16:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c1a:	48 89 d6             	mov    %rdx,%rsi
  800c1d:	89 df                	mov    %ebx,%edi
  800c1f:	ff d0                	callq  *%rax
			break;
  800c21:	eb 2e                	jmp    800c51 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c23:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c27:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c2b:	48 89 d6             	mov    %rdx,%rsi
  800c2e:	bf 25 00 00 00       	mov    $0x25,%edi
  800c33:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c35:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c3a:	eb 05                	jmp    800c41 <vprintfmt+0x4f9>
  800c3c:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c41:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c45:	48 83 e8 01          	sub    $0x1,%rax
  800c49:	0f b6 00             	movzbl (%rax),%eax
  800c4c:	3c 25                	cmp    $0x25,%al
  800c4e:	75 ec                	jne    800c3c <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800c50:	90                   	nop
		}
	}
  800c51:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c52:	e9 43 fb ff ff       	jmpq   80079a <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800c57:	48 83 c4 60          	add    $0x60,%rsp
  800c5b:	5b                   	pop    %rbx
  800c5c:	41 5c                	pop    %r12
  800c5e:	5d                   	pop    %rbp
  800c5f:	c3                   	retq   

0000000000800c60 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c60:	55                   	push   %rbp
  800c61:	48 89 e5             	mov    %rsp,%rbp
  800c64:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800c6b:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800c72:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800c79:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c80:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c87:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c8e:	84 c0                	test   %al,%al
  800c90:	74 20                	je     800cb2 <printfmt+0x52>
  800c92:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c96:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c9a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c9e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ca2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ca6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800caa:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800cae:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800cb2:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800cb9:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800cc0:	00 00 00 
  800cc3:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800cca:	00 00 00 
  800ccd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800cd1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800cd8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800cdf:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800ce6:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800ced:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800cf4:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800cfb:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800d02:	48 89 c7             	mov    %rax,%rdi
  800d05:	48 b8 48 07 80 00 00 	movabs $0x800748,%rax
  800d0c:	00 00 00 
  800d0f:	ff d0                	callq  *%rax
	va_end(ap);
}
  800d11:	c9                   	leaveq 
  800d12:	c3                   	retq   

0000000000800d13 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d13:	55                   	push   %rbp
  800d14:	48 89 e5             	mov    %rsp,%rbp
  800d17:	48 83 ec 10          	sub    $0x10,%rsp
  800d1b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d1e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800d22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d26:	8b 40 10             	mov    0x10(%rax),%eax
  800d29:	8d 50 01             	lea    0x1(%rax),%edx
  800d2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d30:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800d33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d37:	48 8b 10             	mov    (%rax),%rdx
  800d3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d3e:	48 8b 40 08          	mov    0x8(%rax),%rax
  800d42:	48 39 c2             	cmp    %rax,%rdx
  800d45:	73 17                	jae    800d5e <sprintputch+0x4b>
		*b->buf++ = ch;
  800d47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d4b:	48 8b 00             	mov    (%rax),%rax
  800d4e:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800d52:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d56:	48 89 0a             	mov    %rcx,(%rdx)
  800d59:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d5c:	88 10                	mov    %dl,(%rax)
}
  800d5e:	c9                   	leaveq 
  800d5f:	c3                   	retq   

0000000000800d60 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d60:	55                   	push   %rbp
  800d61:	48 89 e5             	mov    %rsp,%rbp
  800d64:	48 83 ec 50          	sub    $0x50,%rsp
  800d68:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800d6c:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800d6f:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800d73:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800d77:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800d7b:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800d7f:	48 8b 0a             	mov    (%rdx),%rcx
  800d82:	48 89 08             	mov    %rcx,(%rax)
  800d85:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d89:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d8d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d91:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d95:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d99:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800d9d:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800da0:	48 98                	cltq   
  800da2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800da6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800daa:	48 01 d0             	add    %rdx,%rax
  800dad:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800db1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800db8:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800dbd:	74 06                	je     800dc5 <vsnprintf+0x65>
  800dbf:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800dc3:	7f 07                	jg     800dcc <vsnprintf+0x6c>
		return -E_INVAL;
  800dc5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dca:	eb 2f                	jmp    800dfb <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800dcc:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800dd0:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800dd4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800dd8:	48 89 c6             	mov    %rax,%rsi
  800ddb:	48 bf 13 0d 80 00 00 	movabs $0x800d13,%rdi
  800de2:	00 00 00 
  800de5:	48 b8 48 07 80 00 00 	movabs $0x800748,%rax
  800dec:	00 00 00 
  800def:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800df1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800df5:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800df8:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800dfb:	c9                   	leaveq 
  800dfc:	c3                   	retq   

0000000000800dfd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dfd:	55                   	push   %rbp
  800dfe:	48 89 e5             	mov    %rsp,%rbp
  800e01:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800e08:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800e0f:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800e15:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e1c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e23:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e2a:	84 c0                	test   %al,%al
  800e2c:	74 20                	je     800e4e <snprintf+0x51>
  800e2e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e32:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e36:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e3a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e3e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e42:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e46:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e4a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e4e:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800e55:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800e5c:	00 00 00 
  800e5f:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800e66:	00 00 00 
  800e69:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e6d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800e74:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e7b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800e82:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e89:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800e90:	48 8b 0a             	mov    (%rdx),%rcx
  800e93:	48 89 08             	mov    %rcx,(%rax)
  800e96:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e9a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e9e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ea2:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800ea6:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800ead:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800eb4:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800eba:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800ec1:	48 89 c7             	mov    %rax,%rdi
  800ec4:	48 b8 60 0d 80 00 00 	movabs $0x800d60,%rax
  800ecb:	00 00 00 
  800ece:	ff d0                	callq  *%rax
  800ed0:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800ed6:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800edc:	c9                   	leaveq 
  800edd:	c3                   	retq   

0000000000800ede <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ede:	55                   	push   %rbp
  800edf:	48 89 e5             	mov    %rsp,%rbp
  800ee2:	48 83 ec 18          	sub    $0x18,%rsp
  800ee6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800eea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ef1:	eb 09                	jmp    800efc <strlen+0x1e>
		n++;
  800ef3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ef7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800efc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f00:	0f b6 00             	movzbl (%rax),%eax
  800f03:	84 c0                	test   %al,%al
  800f05:	75 ec                	jne    800ef3 <strlen+0x15>
		n++;
	return n;
  800f07:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f0a:	c9                   	leaveq 
  800f0b:	c3                   	retq   

0000000000800f0c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800f0c:	55                   	push   %rbp
  800f0d:	48 89 e5             	mov    %rsp,%rbp
  800f10:	48 83 ec 20          	sub    $0x20,%rsp
  800f14:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f18:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f1c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f23:	eb 0e                	jmp    800f33 <strnlen+0x27>
		n++;
  800f25:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f29:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f2e:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800f33:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800f38:	74 0b                	je     800f45 <strnlen+0x39>
  800f3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f3e:	0f b6 00             	movzbl (%rax),%eax
  800f41:	84 c0                	test   %al,%al
  800f43:	75 e0                	jne    800f25 <strnlen+0x19>
		n++;
	return n;
  800f45:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f48:	c9                   	leaveq 
  800f49:	c3                   	retq   

0000000000800f4a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f4a:	55                   	push   %rbp
  800f4b:	48 89 e5             	mov    %rsp,%rbp
  800f4e:	48 83 ec 20          	sub    $0x20,%rsp
  800f52:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f56:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800f5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f5e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800f62:	90                   	nop
  800f63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f67:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f6b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f6f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f73:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f77:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f7b:	0f b6 12             	movzbl (%rdx),%edx
  800f7e:	88 10                	mov    %dl,(%rax)
  800f80:	0f b6 00             	movzbl (%rax),%eax
  800f83:	84 c0                	test   %al,%al
  800f85:	75 dc                	jne    800f63 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800f87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f8b:	c9                   	leaveq 
  800f8c:	c3                   	retq   

0000000000800f8d <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f8d:	55                   	push   %rbp
  800f8e:	48 89 e5             	mov    %rsp,%rbp
  800f91:	48 83 ec 20          	sub    $0x20,%rsp
  800f95:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f99:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800f9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa1:	48 89 c7             	mov    %rax,%rdi
  800fa4:	48 b8 de 0e 80 00 00 	movabs $0x800ede,%rax
  800fab:	00 00 00 
  800fae:	ff d0                	callq  *%rax
  800fb0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800fb3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fb6:	48 63 d0             	movslq %eax,%rdx
  800fb9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fbd:	48 01 c2             	add    %rax,%rdx
  800fc0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fc4:	48 89 c6             	mov    %rax,%rsi
  800fc7:	48 89 d7             	mov    %rdx,%rdi
  800fca:	48 b8 4a 0f 80 00 00 	movabs $0x800f4a,%rax
  800fd1:	00 00 00 
  800fd4:	ff d0                	callq  *%rax
	return dst;
  800fd6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800fda:	c9                   	leaveq 
  800fdb:	c3                   	retq   

0000000000800fdc <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800fdc:	55                   	push   %rbp
  800fdd:	48 89 e5             	mov    %rsp,%rbp
  800fe0:	48 83 ec 28          	sub    $0x28,%rsp
  800fe4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fe8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fec:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800ff0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800ff8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800fff:	00 
  801000:	eb 2a                	jmp    80102c <strncpy+0x50>
		*dst++ = *src;
  801002:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801006:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80100a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80100e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801012:	0f b6 12             	movzbl (%rdx),%edx
  801015:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801017:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80101b:	0f b6 00             	movzbl (%rax),%eax
  80101e:	84 c0                	test   %al,%al
  801020:	74 05                	je     801027 <strncpy+0x4b>
			src++;
  801022:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801027:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80102c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801030:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801034:	72 cc                	jb     801002 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801036:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80103a:	c9                   	leaveq 
  80103b:	c3                   	retq   

000000000080103c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80103c:	55                   	push   %rbp
  80103d:	48 89 e5             	mov    %rsp,%rbp
  801040:	48 83 ec 28          	sub    $0x28,%rsp
  801044:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801048:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80104c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801050:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801054:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801058:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80105d:	74 3d                	je     80109c <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80105f:	eb 1d                	jmp    80107e <strlcpy+0x42>
			*dst++ = *src++;
  801061:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801065:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801069:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80106d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801071:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801075:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801079:	0f b6 12             	movzbl (%rdx),%edx
  80107c:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80107e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801083:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801088:	74 0b                	je     801095 <strlcpy+0x59>
  80108a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80108e:	0f b6 00             	movzbl (%rax),%eax
  801091:	84 c0                	test   %al,%al
  801093:	75 cc                	jne    801061 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801095:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801099:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80109c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010a4:	48 29 c2             	sub    %rax,%rdx
  8010a7:	48 89 d0             	mov    %rdx,%rax
}
  8010aa:	c9                   	leaveq 
  8010ab:	c3                   	retq   

00000000008010ac <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010ac:	55                   	push   %rbp
  8010ad:	48 89 e5             	mov    %rsp,%rbp
  8010b0:	48 83 ec 10          	sub    $0x10,%rsp
  8010b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010b8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8010bc:	eb 0a                	jmp    8010c8 <strcmp+0x1c>
		p++, q++;
  8010be:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010c3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8010c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010cc:	0f b6 00             	movzbl (%rax),%eax
  8010cf:	84 c0                	test   %al,%al
  8010d1:	74 12                	je     8010e5 <strcmp+0x39>
  8010d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d7:	0f b6 10             	movzbl (%rax),%edx
  8010da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010de:	0f b6 00             	movzbl (%rax),%eax
  8010e1:	38 c2                	cmp    %al,%dl
  8010e3:	74 d9                	je     8010be <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8010e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e9:	0f b6 00             	movzbl (%rax),%eax
  8010ec:	0f b6 d0             	movzbl %al,%edx
  8010ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010f3:	0f b6 00             	movzbl (%rax),%eax
  8010f6:	0f b6 c0             	movzbl %al,%eax
  8010f9:	29 c2                	sub    %eax,%edx
  8010fb:	89 d0                	mov    %edx,%eax
}
  8010fd:	c9                   	leaveq 
  8010fe:	c3                   	retq   

00000000008010ff <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8010ff:	55                   	push   %rbp
  801100:	48 89 e5             	mov    %rsp,%rbp
  801103:	48 83 ec 18          	sub    $0x18,%rsp
  801107:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80110b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80110f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801113:	eb 0f                	jmp    801124 <strncmp+0x25>
		n--, p++, q++;
  801115:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80111a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80111f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801124:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801129:	74 1d                	je     801148 <strncmp+0x49>
  80112b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80112f:	0f b6 00             	movzbl (%rax),%eax
  801132:	84 c0                	test   %al,%al
  801134:	74 12                	je     801148 <strncmp+0x49>
  801136:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80113a:	0f b6 10             	movzbl (%rax),%edx
  80113d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801141:	0f b6 00             	movzbl (%rax),%eax
  801144:	38 c2                	cmp    %al,%dl
  801146:	74 cd                	je     801115 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801148:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80114d:	75 07                	jne    801156 <strncmp+0x57>
		return 0;
  80114f:	b8 00 00 00 00       	mov    $0x0,%eax
  801154:	eb 18                	jmp    80116e <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801156:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80115a:	0f b6 00             	movzbl (%rax),%eax
  80115d:	0f b6 d0             	movzbl %al,%edx
  801160:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801164:	0f b6 00             	movzbl (%rax),%eax
  801167:	0f b6 c0             	movzbl %al,%eax
  80116a:	29 c2                	sub    %eax,%edx
  80116c:	89 d0                	mov    %edx,%eax
}
  80116e:	c9                   	leaveq 
  80116f:	c3                   	retq   

0000000000801170 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801170:	55                   	push   %rbp
  801171:	48 89 e5             	mov    %rsp,%rbp
  801174:	48 83 ec 0c          	sub    $0xc,%rsp
  801178:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80117c:	89 f0                	mov    %esi,%eax
  80117e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801181:	eb 17                	jmp    80119a <strchr+0x2a>
		if (*s == c)
  801183:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801187:	0f b6 00             	movzbl (%rax),%eax
  80118a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80118d:	75 06                	jne    801195 <strchr+0x25>
			return (char *) s;
  80118f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801193:	eb 15                	jmp    8011aa <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801195:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80119a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80119e:	0f b6 00             	movzbl (%rax),%eax
  8011a1:	84 c0                	test   %al,%al
  8011a3:	75 de                	jne    801183 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8011a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011aa:	c9                   	leaveq 
  8011ab:	c3                   	retq   

00000000008011ac <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011ac:	55                   	push   %rbp
  8011ad:	48 89 e5             	mov    %rsp,%rbp
  8011b0:	48 83 ec 0c          	sub    $0xc,%rsp
  8011b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011b8:	89 f0                	mov    %esi,%eax
  8011ba:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011bd:	eb 13                	jmp    8011d2 <strfind+0x26>
		if (*s == c)
  8011bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c3:	0f b6 00             	movzbl (%rax),%eax
  8011c6:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8011c9:	75 02                	jne    8011cd <strfind+0x21>
			break;
  8011cb:	eb 10                	jmp    8011dd <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011cd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d6:	0f b6 00             	movzbl (%rax),%eax
  8011d9:	84 c0                	test   %al,%al
  8011db:	75 e2                	jne    8011bf <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8011dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011e1:	c9                   	leaveq 
  8011e2:	c3                   	retq   

00000000008011e3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8011e3:	55                   	push   %rbp
  8011e4:	48 89 e5             	mov    %rsp,%rbp
  8011e7:	48 83 ec 18          	sub    $0x18,%rsp
  8011eb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011ef:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8011f2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8011f6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011fb:	75 06                	jne    801203 <memset+0x20>
		return v;
  8011fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801201:	eb 69                	jmp    80126c <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801203:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801207:	83 e0 03             	and    $0x3,%eax
  80120a:	48 85 c0             	test   %rax,%rax
  80120d:	75 48                	jne    801257 <memset+0x74>
  80120f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801213:	83 e0 03             	and    $0x3,%eax
  801216:	48 85 c0             	test   %rax,%rax
  801219:	75 3c                	jne    801257 <memset+0x74>
		c &= 0xFF;
  80121b:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801222:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801225:	c1 e0 18             	shl    $0x18,%eax
  801228:	89 c2                	mov    %eax,%edx
  80122a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80122d:	c1 e0 10             	shl    $0x10,%eax
  801230:	09 c2                	or     %eax,%edx
  801232:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801235:	c1 e0 08             	shl    $0x8,%eax
  801238:	09 d0                	or     %edx,%eax
  80123a:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80123d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801241:	48 c1 e8 02          	shr    $0x2,%rax
  801245:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801248:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80124c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80124f:	48 89 d7             	mov    %rdx,%rdi
  801252:	fc                   	cld    
  801253:	f3 ab                	rep stos %eax,%es:(%rdi)
  801255:	eb 11                	jmp    801268 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801257:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80125b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80125e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801262:	48 89 d7             	mov    %rdx,%rdi
  801265:	fc                   	cld    
  801266:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801268:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80126c:	c9                   	leaveq 
  80126d:	c3                   	retq   

000000000080126e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80126e:	55                   	push   %rbp
  80126f:	48 89 e5             	mov    %rsp,%rbp
  801272:	48 83 ec 28          	sub    $0x28,%rsp
  801276:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80127a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80127e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801282:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801286:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80128a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80128e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801292:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801296:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80129a:	0f 83 88 00 00 00    	jae    801328 <memmove+0xba>
  8012a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012a4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012a8:	48 01 d0             	add    %rdx,%rax
  8012ab:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012af:	76 77                	jbe    801328 <memmove+0xba>
		s += n;
  8012b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012b5:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8012b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012bd:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c5:	83 e0 03             	and    $0x3,%eax
  8012c8:	48 85 c0             	test   %rax,%rax
  8012cb:	75 3b                	jne    801308 <memmove+0x9a>
  8012cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012d1:	83 e0 03             	and    $0x3,%eax
  8012d4:	48 85 c0             	test   %rax,%rax
  8012d7:	75 2f                	jne    801308 <memmove+0x9a>
  8012d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012dd:	83 e0 03             	and    $0x3,%eax
  8012e0:	48 85 c0             	test   %rax,%rax
  8012e3:	75 23                	jne    801308 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8012e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012e9:	48 83 e8 04          	sub    $0x4,%rax
  8012ed:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012f1:	48 83 ea 04          	sub    $0x4,%rdx
  8012f5:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012f9:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8012fd:	48 89 c7             	mov    %rax,%rdi
  801300:	48 89 d6             	mov    %rdx,%rsi
  801303:	fd                   	std    
  801304:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801306:	eb 1d                	jmp    801325 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801308:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80130c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801310:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801314:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801318:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80131c:	48 89 d7             	mov    %rdx,%rdi
  80131f:	48 89 c1             	mov    %rax,%rcx
  801322:	fd                   	std    
  801323:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801325:	fc                   	cld    
  801326:	eb 57                	jmp    80137f <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801328:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132c:	83 e0 03             	and    $0x3,%eax
  80132f:	48 85 c0             	test   %rax,%rax
  801332:	75 36                	jne    80136a <memmove+0xfc>
  801334:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801338:	83 e0 03             	and    $0x3,%eax
  80133b:	48 85 c0             	test   %rax,%rax
  80133e:	75 2a                	jne    80136a <memmove+0xfc>
  801340:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801344:	83 e0 03             	and    $0x3,%eax
  801347:	48 85 c0             	test   %rax,%rax
  80134a:	75 1e                	jne    80136a <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80134c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801350:	48 c1 e8 02          	shr    $0x2,%rax
  801354:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801357:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80135b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80135f:	48 89 c7             	mov    %rax,%rdi
  801362:	48 89 d6             	mov    %rdx,%rsi
  801365:	fc                   	cld    
  801366:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801368:	eb 15                	jmp    80137f <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80136a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80136e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801372:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801376:	48 89 c7             	mov    %rax,%rdi
  801379:	48 89 d6             	mov    %rdx,%rsi
  80137c:	fc                   	cld    
  80137d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80137f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801383:	c9                   	leaveq 
  801384:	c3                   	retq   

0000000000801385 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801385:	55                   	push   %rbp
  801386:	48 89 e5             	mov    %rsp,%rbp
  801389:	48 83 ec 18          	sub    $0x18,%rsp
  80138d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801391:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801395:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801399:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80139d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8013a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a5:	48 89 ce             	mov    %rcx,%rsi
  8013a8:	48 89 c7             	mov    %rax,%rdi
  8013ab:	48 b8 6e 12 80 00 00 	movabs $0x80126e,%rax
  8013b2:	00 00 00 
  8013b5:	ff d0                	callq  *%rax
}
  8013b7:	c9                   	leaveq 
  8013b8:	c3                   	retq   

00000000008013b9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8013b9:	55                   	push   %rbp
  8013ba:	48 89 e5             	mov    %rsp,%rbp
  8013bd:	48 83 ec 28          	sub    $0x28,%rsp
  8013c1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013c5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013c9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8013cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8013d5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013d9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8013dd:	eb 36                	jmp    801415 <memcmp+0x5c>
		if (*s1 != *s2)
  8013df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e3:	0f b6 10             	movzbl (%rax),%edx
  8013e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ea:	0f b6 00             	movzbl (%rax),%eax
  8013ed:	38 c2                	cmp    %al,%dl
  8013ef:	74 1a                	je     80140b <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8013f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f5:	0f b6 00             	movzbl (%rax),%eax
  8013f8:	0f b6 d0             	movzbl %al,%edx
  8013fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ff:	0f b6 00             	movzbl (%rax),%eax
  801402:	0f b6 c0             	movzbl %al,%eax
  801405:	29 c2                	sub    %eax,%edx
  801407:	89 d0                	mov    %edx,%eax
  801409:	eb 20                	jmp    80142b <memcmp+0x72>
		s1++, s2++;
  80140b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801410:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801415:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801419:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80141d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801421:	48 85 c0             	test   %rax,%rax
  801424:	75 b9                	jne    8013df <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801426:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80142b:	c9                   	leaveq 
  80142c:	c3                   	retq   

000000000080142d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80142d:	55                   	push   %rbp
  80142e:	48 89 e5             	mov    %rsp,%rbp
  801431:	48 83 ec 28          	sub    $0x28,%rsp
  801435:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801439:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80143c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801440:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801444:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801448:	48 01 d0             	add    %rdx,%rax
  80144b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80144f:	eb 15                	jmp    801466 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801451:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801455:	0f b6 10             	movzbl (%rax),%edx
  801458:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80145b:	38 c2                	cmp    %al,%dl
  80145d:	75 02                	jne    801461 <memfind+0x34>
			break;
  80145f:	eb 0f                	jmp    801470 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801461:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801466:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80146a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80146e:	72 e1                	jb     801451 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801470:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801474:	c9                   	leaveq 
  801475:	c3                   	retq   

0000000000801476 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801476:	55                   	push   %rbp
  801477:	48 89 e5             	mov    %rsp,%rbp
  80147a:	48 83 ec 34          	sub    $0x34,%rsp
  80147e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801482:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801486:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801489:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801490:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801497:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801498:	eb 05                	jmp    80149f <strtol+0x29>
		s++;
  80149a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80149f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a3:	0f b6 00             	movzbl (%rax),%eax
  8014a6:	3c 20                	cmp    $0x20,%al
  8014a8:	74 f0                	je     80149a <strtol+0x24>
  8014aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ae:	0f b6 00             	movzbl (%rax),%eax
  8014b1:	3c 09                	cmp    $0x9,%al
  8014b3:	74 e5                	je     80149a <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b9:	0f b6 00             	movzbl (%rax),%eax
  8014bc:	3c 2b                	cmp    $0x2b,%al
  8014be:	75 07                	jne    8014c7 <strtol+0x51>
		s++;
  8014c0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014c5:	eb 17                	jmp    8014de <strtol+0x68>
	else if (*s == '-')
  8014c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014cb:	0f b6 00             	movzbl (%rax),%eax
  8014ce:	3c 2d                	cmp    $0x2d,%al
  8014d0:	75 0c                	jne    8014de <strtol+0x68>
		s++, neg = 1;
  8014d2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014d7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014de:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014e2:	74 06                	je     8014ea <strtol+0x74>
  8014e4:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8014e8:	75 28                	jne    801512 <strtol+0x9c>
  8014ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ee:	0f b6 00             	movzbl (%rax),%eax
  8014f1:	3c 30                	cmp    $0x30,%al
  8014f3:	75 1d                	jne    801512 <strtol+0x9c>
  8014f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f9:	48 83 c0 01          	add    $0x1,%rax
  8014fd:	0f b6 00             	movzbl (%rax),%eax
  801500:	3c 78                	cmp    $0x78,%al
  801502:	75 0e                	jne    801512 <strtol+0x9c>
		s += 2, base = 16;
  801504:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801509:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801510:	eb 2c                	jmp    80153e <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801512:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801516:	75 19                	jne    801531 <strtol+0xbb>
  801518:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80151c:	0f b6 00             	movzbl (%rax),%eax
  80151f:	3c 30                	cmp    $0x30,%al
  801521:	75 0e                	jne    801531 <strtol+0xbb>
		s++, base = 8;
  801523:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801528:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80152f:	eb 0d                	jmp    80153e <strtol+0xc8>
	else if (base == 0)
  801531:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801535:	75 07                	jne    80153e <strtol+0xc8>
		base = 10;
  801537:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80153e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801542:	0f b6 00             	movzbl (%rax),%eax
  801545:	3c 2f                	cmp    $0x2f,%al
  801547:	7e 1d                	jle    801566 <strtol+0xf0>
  801549:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154d:	0f b6 00             	movzbl (%rax),%eax
  801550:	3c 39                	cmp    $0x39,%al
  801552:	7f 12                	jg     801566 <strtol+0xf0>
			dig = *s - '0';
  801554:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801558:	0f b6 00             	movzbl (%rax),%eax
  80155b:	0f be c0             	movsbl %al,%eax
  80155e:	83 e8 30             	sub    $0x30,%eax
  801561:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801564:	eb 4e                	jmp    8015b4 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801566:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156a:	0f b6 00             	movzbl (%rax),%eax
  80156d:	3c 60                	cmp    $0x60,%al
  80156f:	7e 1d                	jle    80158e <strtol+0x118>
  801571:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801575:	0f b6 00             	movzbl (%rax),%eax
  801578:	3c 7a                	cmp    $0x7a,%al
  80157a:	7f 12                	jg     80158e <strtol+0x118>
			dig = *s - 'a' + 10;
  80157c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801580:	0f b6 00             	movzbl (%rax),%eax
  801583:	0f be c0             	movsbl %al,%eax
  801586:	83 e8 57             	sub    $0x57,%eax
  801589:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80158c:	eb 26                	jmp    8015b4 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80158e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801592:	0f b6 00             	movzbl (%rax),%eax
  801595:	3c 40                	cmp    $0x40,%al
  801597:	7e 48                	jle    8015e1 <strtol+0x16b>
  801599:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159d:	0f b6 00             	movzbl (%rax),%eax
  8015a0:	3c 5a                	cmp    $0x5a,%al
  8015a2:	7f 3d                	jg     8015e1 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8015a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a8:	0f b6 00             	movzbl (%rax),%eax
  8015ab:	0f be c0             	movsbl %al,%eax
  8015ae:	83 e8 37             	sub    $0x37,%eax
  8015b1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8015b4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015b7:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8015ba:	7c 02                	jl     8015be <strtol+0x148>
			break;
  8015bc:	eb 23                	jmp    8015e1 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8015be:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015c3:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8015c6:	48 98                	cltq   
  8015c8:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8015cd:	48 89 c2             	mov    %rax,%rdx
  8015d0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015d3:	48 98                	cltq   
  8015d5:	48 01 d0             	add    %rdx,%rax
  8015d8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8015dc:	e9 5d ff ff ff       	jmpq   80153e <strtol+0xc8>

	if (endptr)
  8015e1:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8015e6:	74 0b                	je     8015f3 <strtol+0x17d>
		*endptr = (char *) s;
  8015e8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015ec:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8015f0:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8015f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015f7:	74 09                	je     801602 <strtol+0x18c>
  8015f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015fd:	48 f7 d8             	neg    %rax
  801600:	eb 04                	jmp    801606 <strtol+0x190>
  801602:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801606:	c9                   	leaveq 
  801607:	c3                   	retq   

0000000000801608 <strstr>:

char * strstr(const char *in, const char *str)
{
  801608:	55                   	push   %rbp
  801609:	48 89 e5             	mov    %rsp,%rbp
  80160c:	48 83 ec 30          	sub    $0x30,%rsp
  801610:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801614:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801618:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80161c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801620:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801624:	0f b6 00             	movzbl (%rax),%eax
  801627:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80162a:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80162e:	75 06                	jne    801636 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801630:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801634:	eb 6b                	jmp    8016a1 <strstr+0x99>

	len = strlen(str);
  801636:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80163a:	48 89 c7             	mov    %rax,%rdi
  80163d:	48 b8 de 0e 80 00 00 	movabs $0x800ede,%rax
  801644:	00 00 00 
  801647:	ff d0                	callq  *%rax
  801649:	48 98                	cltq   
  80164b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80164f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801653:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801657:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80165b:	0f b6 00             	movzbl (%rax),%eax
  80165e:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801661:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801665:	75 07                	jne    80166e <strstr+0x66>
				return (char *) 0;
  801667:	b8 00 00 00 00       	mov    $0x0,%eax
  80166c:	eb 33                	jmp    8016a1 <strstr+0x99>
		} while (sc != c);
  80166e:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801672:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801675:	75 d8                	jne    80164f <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801677:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80167b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80167f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801683:	48 89 ce             	mov    %rcx,%rsi
  801686:	48 89 c7             	mov    %rax,%rdi
  801689:	48 b8 ff 10 80 00 00 	movabs $0x8010ff,%rax
  801690:	00 00 00 
  801693:	ff d0                	callq  *%rax
  801695:	85 c0                	test   %eax,%eax
  801697:	75 b6                	jne    80164f <strstr+0x47>

	return (char *) (in - 1);
  801699:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169d:	48 83 e8 01          	sub    $0x1,%rax
}
  8016a1:	c9                   	leaveq 
  8016a2:	c3                   	retq   

00000000008016a3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8016a3:	55                   	push   %rbp
  8016a4:	48 89 e5             	mov    %rsp,%rbp
  8016a7:	53                   	push   %rbx
  8016a8:	48 83 ec 48          	sub    $0x48,%rsp
  8016ac:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8016af:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8016b2:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016b6:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8016ba:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8016be:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  8016c2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016c5:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8016c9:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8016cd:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8016d1:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8016d5:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8016d9:	4c 89 c3             	mov    %r8,%rbx
  8016dc:	cd 30                	int    $0x30
  8016de:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  8016e2:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8016e6:	74 3e                	je     801726 <syscall+0x83>
  8016e8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016ed:	7e 37                	jle    801726 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8016ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016f3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016f6:	49 89 d0             	mov    %rdx,%r8
  8016f9:	89 c1                	mov    %eax,%ecx
  8016fb:	48 ba 48 41 80 00 00 	movabs $0x804148,%rdx
  801702:	00 00 00 
  801705:	be 4a 00 00 00       	mov    $0x4a,%esi
  80170a:	48 bf 65 41 80 00 00 	movabs $0x804165,%rdi
  801711:	00 00 00 
  801714:	b8 00 00 00 00       	mov    $0x0,%eax
  801719:	49 b9 9c 38 80 00 00 	movabs $0x80389c,%r9
  801720:	00 00 00 
  801723:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  801726:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80172a:	48 83 c4 48          	add    $0x48,%rsp
  80172e:	5b                   	pop    %rbx
  80172f:	5d                   	pop    %rbp
  801730:	c3                   	retq   

0000000000801731 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801731:	55                   	push   %rbp
  801732:	48 89 e5             	mov    %rsp,%rbp
  801735:	48 83 ec 20          	sub    $0x20,%rsp
  801739:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80173d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801741:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801745:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801749:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801750:	00 
  801751:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801757:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80175d:	48 89 d1             	mov    %rdx,%rcx
  801760:	48 89 c2             	mov    %rax,%rdx
  801763:	be 00 00 00 00       	mov    $0x0,%esi
  801768:	bf 00 00 00 00       	mov    $0x0,%edi
  80176d:	48 b8 a3 16 80 00 00 	movabs $0x8016a3,%rax
  801774:	00 00 00 
  801777:	ff d0                	callq  *%rax
}
  801779:	c9                   	leaveq 
  80177a:	c3                   	retq   

000000000080177b <sys_cgetc>:

int
sys_cgetc(void)
{
  80177b:	55                   	push   %rbp
  80177c:	48 89 e5             	mov    %rsp,%rbp
  80177f:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801783:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80178a:	00 
  80178b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801791:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801797:	b9 00 00 00 00       	mov    $0x0,%ecx
  80179c:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a1:	be 00 00 00 00       	mov    $0x0,%esi
  8017a6:	bf 01 00 00 00       	mov    $0x1,%edi
  8017ab:	48 b8 a3 16 80 00 00 	movabs $0x8016a3,%rax
  8017b2:	00 00 00 
  8017b5:	ff d0                	callq  *%rax
}
  8017b7:	c9                   	leaveq 
  8017b8:	c3                   	retq   

00000000008017b9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8017b9:	55                   	push   %rbp
  8017ba:	48 89 e5             	mov    %rsp,%rbp
  8017bd:	48 83 ec 10          	sub    $0x10,%rsp
  8017c1:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8017c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017c7:	48 98                	cltq   
  8017c9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017d0:	00 
  8017d1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017d7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017dd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017e2:	48 89 c2             	mov    %rax,%rdx
  8017e5:	be 01 00 00 00       	mov    $0x1,%esi
  8017ea:	bf 03 00 00 00       	mov    $0x3,%edi
  8017ef:	48 b8 a3 16 80 00 00 	movabs $0x8016a3,%rax
  8017f6:	00 00 00 
  8017f9:	ff d0                	callq  *%rax
}
  8017fb:	c9                   	leaveq 
  8017fc:	c3                   	retq   

00000000008017fd <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8017fd:	55                   	push   %rbp
  8017fe:	48 89 e5             	mov    %rsp,%rbp
  801801:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801805:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80180c:	00 
  80180d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801813:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801819:	b9 00 00 00 00       	mov    $0x0,%ecx
  80181e:	ba 00 00 00 00       	mov    $0x0,%edx
  801823:	be 00 00 00 00       	mov    $0x0,%esi
  801828:	bf 02 00 00 00       	mov    $0x2,%edi
  80182d:	48 b8 a3 16 80 00 00 	movabs $0x8016a3,%rax
  801834:	00 00 00 
  801837:	ff d0                	callq  *%rax
}
  801839:	c9                   	leaveq 
  80183a:	c3                   	retq   

000000000080183b <sys_yield>:

void
sys_yield(void)
{
  80183b:	55                   	push   %rbp
  80183c:	48 89 e5             	mov    %rsp,%rbp
  80183f:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801843:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80184a:	00 
  80184b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801851:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801857:	b9 00 00 00 00       	mov    $0x0,%ecx
  80185c:	ba 00 00 00 00       	mov    $0x0,%edx
  801861:	be 00 00 00 00       	mov    $0x0,%esi
  801866:	bf 0b 00 00 00       	mov    $0xb,%edi
  80186b:	48 b8 a3 16 80 00 00 	movabs $0x8016a3,%rax
  801872:	00 00 00 
  801875:	ff d0                	callq  *%rax
}
  801877:	c9                   	leaveq 
  801878:	c3                   	retq   

0000000000801879 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801879:	55                   	push   %rbp
  80187a:	48 89 e5             	mov    %rsp,%rbp
  80187d:	48 83 ec 20          	sub    $0x20,%rsp
  801881:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801884:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801888:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80188b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80188e:	48 63 c8             	movslq %eax,%rcx
  801891:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801895:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801898:	48 98                	cltq   
  80189a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018a1:	00 
  8018a2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018a8:	49 89 c8             	mov    %rcx,%r8
  8018ab:	48 89 d1             	mov    %rdx,%rcx
  8018ae:	48 89 c2             	mov    %rax,%rdx
  8018b1:	be 01 00 00 00       	mov    $0x1,%esi
  8018b6:	bf 04 00 00 00       	mov    $0x4,%edi
  8018bb:	48 b8 a3 16 80 00 00 	movabs $0x8016a3,%rax
  8018c2:	00 00 00 
  8018c5:	ff d0                	callq  *%rax
}
  8018c7:	c9                   	leaveq 
  8018c8:	c3                   	retq   

00000000008018c9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8018c9:	55                   	push   %rbp
  8018ca:	48 89 e5             	mov    %rsp,%rbp
  8018cd:	48 83 ec 30          	sub    $0x30,%rsp
  8018d1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018d4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018d8:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8018db:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8018df:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8018e3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8018e6:	48 63 c8             	movslq %eax,%rcx
  8018e9:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8018ed:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018f0:	48 63 f0             	movslq %eax,%rsi
  8018f3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018fa:	48 98                	cltq   
  8018fc:	48 89 0c 24          	mov    %rcx,(%rsp)
  801900:	49 89 f9             	mov    %rdi,%r9
  801903:	49 89 f0             	mov    %rsi,%r8
  801906:	48 89 d1             	mov    %rdx,%rcx
  801909:	48 89 c2             	mov    %rax,%rdx
  80190c:	be 01 00 00 00       	mov    $0x1,%esi
  801911:	bf 05 00 00 00       	mov    $0x5,%edi
  801916:	48 b8 a3 16 80 00 00 	movabs $0x8016a3,%rax
  80191d:	00 00 00 
  801920:	ff d0                	callq  *%rax
}
  801922:	c9                   	leaveq 
  801923:	c3                   	retq   

0000000000801924 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801924:	55                   	push   %rbp
  801925:	48 89 e5             	mov    %rsp,%rbp
  801928:	48 83 ec 20          	sub    $0x20,%rsp
  80192c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80192f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801933:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801937:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80193a:	48 98                	cltq   
  80193c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801943:	00 
  801944:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80194a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801950:	48 89 d1             	mov    %rdx,%rcx
  801953:	48 89 c2             	mov    %rax,%rdx
  801956:	be 01 00 00 00       	mov    $0x1,%esi
  80195b:	bf 06 00 00 00       	mov    $0x6,%edi
  801960:	48 b8 a3 16 80 00 00 	movabs $0x8016a3,%rax
  801967:	00 00 00 
  80196a:	ff d0                	callq  *%rax
}
  80196c:	c9                   	leaveq 
  80196d:	c3                   	retq   

000000000080196e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80196e:	55                   	push   %rbp
  80196f:	48 89 e5             	mov    %rsp,%rbp
  801972:	48 83 ec 10          	sub    $0x10,%rsp
  801976:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801979:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80197c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80197f:	48 63 d0             	movslq %eax,%rdx
  801982:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801985:	48 98                	cltq   
  801987:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80198e:	00 
  80198f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801995:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80199b:	48 89 d1             	mov    %rdx,%rcx
  80199e:	48 89 c2             	mov    %rax,%rdx
  8019a1:	be 01 00 00 00       	mov    $0x1,%esi
  8019a6:	bf 08 00 00 00       	mov    $0x8,%edi
  8019ab:	48 b8 a3 16 80 00 00 	movabs $0x8016a3,%rax
  8019b2:	00 00 00 
  8019b5:	ff d0                	callq  *%rax
}
  8019b7:	c9                   	leaveq 
  8019b8:	c3                   	retq   

00000000008019b9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8019b9:	55                   	push   %rbp
  8019ba:	48 89 e5             	mov    %rsp,%rbp
  8019bd:	48 83 ec 20          	sub    $0x20,%rsp
  8019c1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019c4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8019c8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019cf:	48 98                	cltq   
  8019d1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019d8:	00 
  8019d9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019df:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019e5:	48 89 d1             	mov    %rdx,%rcx
  8019e8:	48 89 c2             	mov    %rax,%rdx
  8019eb:	be 01 00 00 00       	mov    $0x1,%esi
  8019f0:	bf 09 00 00 00       	mov    $0x9,%edi
  8019f5:	48 b8 a3 16 80 00 00 	movabs $0x8016a3,%rax
  8019fc:	00 00 00 
  8019ff:	ff d0                	callq  *%rax
}
  801a01:	c9                   	leaveq 
  801a02:	c3                   	retq   

0000000000801a03 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801a03:	55                   	push   %rbp
  801a04:	48 89 e5             	mov    %rsp,%rbp
  801a07:	48 83 ec 20          	sub    $0x20,%rsp
  801a0b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a0e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801a12:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a19:	48 98                	cltq   
  801a1b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a22:	00 
  801a23:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a29:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a2f:	48 89 d1             	mov    %rdx,%rcx
  801a32:	48 89 c2             	mov    %rax,%rdx
  801a35:	be 01 00 00 00       	mov    $0x1,%esi
  801a3a:	bf 0a 00 00 00       	mov    $0xa,%edi
  801a3f:	48 b8 a3 16 80 00 00 	movabs $0x8016a3,%rax
  801a46:	00 00 00 
  801a49:	ff d0                	callq  *%rax
}
  801a4b:	c9                   	leaveq 
  801a4c:	c3                   	retq   

0000000000801a4d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801a4d:	55                   	push   %rbp
  801a4e:	48 89 e5             	mov    %rsp,%rbp
  801a51:	48 83 ec 20          	sub    $0x20,%rsp
  801a55:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a58:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a5c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a60:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801a63:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a66:	48 63 f0             	movslq %eax,%rsi
  801a69:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a70:	48 98                	cltq   
  801a72:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a76:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a7d:	00 
  801a7e:	49 89 f1             	mov    %rsi,%r9
  801a81:	49 89 c8             	mov    %rcx,%r8
  801a84:	48 89 d1             	mov    %rdx,%rcx
  801a87:	48 89 c2             	mov    %rax,%rdx
  801a8a:	be 00 00 00 00       	mov    $0x0,%esi
  801a8f:	bf 0c 00 00 00       	mov    $0xc,%edi
  801a94:	48 b8 a3 16 80 00 00 	movabs $0x8016a3,%rax
  801a9b:	00 00 00 
  801a9e:	ff d0                	callq  *%rax
}
  801aa0:	c9                   	leaveq 
  801aa1:	c3                   	retq   

0000000000801aa2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801aa2:	55                   	push   %rbp
  801aa3:	48 89 e5             	mov    %rsp,%rbp
  801aa6:	48 83 ec 10          	sub    $0x10,%rsp
  801aaa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801aae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ab2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ab9:	00 
  801aba:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ac0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ac6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801acb:	48 89 c2             	mov    %rax,%rdx
  801ace:	be 01 00 00 00       	mov    $0x1,%esi
  801ad3:	bf 0d 00 00 00       	mov    $0xd,%edi
  801ad8:	48 b8 a3 16 80 00 00 	movabs $0x8016a3,%rax
  801adf:	00 00 00 
  801ae2:	ff d0                	callq  *%rax
}
  801ae4:	c9                   	leaveq 
  801ae5:	c3                   	retq   

0000000000801ae6 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801ae6:	55                   	push   %rbp
  801ae7:	48 89 e5             	mov    %rsp,%rbp
  801aea:	48 83 ec 18          	sub    $0x18,%rsp
  801aee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801af2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801af6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  801afa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801afe:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b02:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  801b05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b09:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b0d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801b11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b15:	8b 00                	mov    (%rax),%eax
  801b17:	83 f8 01             	cmp    $0x1,%eax
  801b1a:	7e 13                	jle    801b2f <argstart+0x49>
  801b1c:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  801b21:	74 0c                	je     801b2f <argstart+0x49>
  801b23:	48 b8 73 41 80 00 00 	movabs $0x804173,%rax
  801b2a:	00 00 00 
  801b2d:	eb 05                	jmp    801b34 <argstart+0x4e>
  801b2f:	b8 00 00 00 00       	mov    $0x0,%eax
  801b34:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b38:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  801b3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b40:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801b47:	00 
}
  801b48:	c9                   	leaveq 
  801b49:	c3                   	retq   

0000000000801b4a <argnext>:

int
argnext(struct Argstate *args)
{
  801b4a:	55                   	push   %rbp
  801b4b:	48 89 e5             	mov    %rsp,%rbp
  801b4e:	48 83 ec 20          	sub    $0x20,%rsp
  801b52:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  801b56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b5a:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801b61:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801b62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b66:	48 8b 40 10          	mov    0x10(%rax),%rax
  801b6a:	48 85 c0             	test   %rax,%rax
  801b6d:	75 0a                	jne    801b79 <argnext+0x2f>
		return -1;
  801b6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801b74:	e9 25 01 00 00       	jmpq   801c9e <argnext+0x154>

	if (!*args->curarg) {
  801b79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b7d:	48 8b 40 10          	mov    0x10(%rax),%rax
  801b81:	0f b6 00             	movzbl (%rax),%eax
  801b84:	84 c0                	test   %al,%al
  801b86:	0f 85 d7 00 00 00    	jne    801c63 <argnext+0x119>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801b8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b90:	48 8b 00             	mov    (%rax),%rax
  801b93:	8b 00                	mov    (%rax),%eax
  801b95:	83 f8 01             	cmp    $0x1,%eax
  801b98:	0f 84 ef 00 00 00    	je     801c8d <argnext+0x143>
		    || args->argv[1][0] != '-'
  801b9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ba2:	48 8b 40 08          	mov    0x8(%rax),%rax
  801ba6:	48 83 c0 08          	add    $0x8,%rax
  801baa:	48 8b 00             	mov    (%rax),%rax
  801bad:	0f b6 00             	movzbl (%rax),%eax
  801bb0:	3c 2d                	cmp    $0x2d,%al
  801bb2:	0f 85 d5 00 00 00    	jne    801c8d <argnext+0x143>
		    || args->argv[1][1] == '\0')
  801bb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bbc:	48 8b 40 08          	mov    0x8(%rax),%rax
  801bc0:	48 83 c0 08          	add    $0x8,%rax
  801bc4:	48 8b 00             	mov    (%rax),%rax
  801bc7:	48 83 c0 01          	add    $0x1,%rax
  801bcb:	0f b6 00             	movzbl (%rax),%eax
  801bce:	84 c0                	test   %al,%al
  801bd0:	0f 84 b7 00 00 00    	je     801c8d <argnext+0x143>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801bd6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bda:	48 8b 40 08          	mov    0x8(%rax),%rax
  801bde:	48 83 c0 08          	add    $0x8,%rax
  801be2:	48 8b 00             	mov    (%rax),%rax
  801be5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801be9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bed:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801bf1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bf5:	48 8b 00             	mov    (%rax),%rax
  801bf8:	8b 00                	mov    (%rax),%eax
  801bfa:	83 e8 01             	sub    $0x1,%eax
  801bfd:	48 98                	cltq   
  801bff:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801c06:	00 
  801c07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c0b:	48 8b 40 08          	mov    0x8(%rax),%rax
  801c0f:	48 8d 48 10          	lea    0x10(%rax),%rcx
  801c13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c17:	48 8b 40 08          	mov    0x8(%rax),%rax
  801c1b:	48 83 c0 08          	add    $0x8,%rax
  801c1f:	48 89 ce             	mov    %rcx,%rsi
  801c22:	48 89 c7             	mov    %rax,%rdi
  801c25:	48 b8 6e 12 80 00 00 	movabs $0x80126e,%rax
  801c2c:	00 00 00 
  801c2f:	ff d0                	callq  *%rax
		(*args->argc)--;
  801c31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c35:	48 8b 00             	mov    (%rax),%rax
  801c38:	8b 10                	mov    (%rax),%edx
  801c3a:	83 ea 01             	sub    $0x1,%edx
  801c3d:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801c3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c43:	48 8b 40 10          	mov    0x10(%rax),%rax
  801c47:	0f b6 00             	movzbl (%rax),%eax
  801c4a:	3c 2d                	cmp    $0x2d,%al
  801c4c:	75 15                	jne    801c63 <argnext+0x119>
  801c4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c52:	48 8b 40 10          	mov    0x10(%rax),%rax
  801c56:	48 83 c0 01          	add    $0x1,%rax
  801c5a:	0f b6 00             	movzbl (%rax),%eax
  801c5d:	84 c0                	test   %al,%al
  801c5f:	75 02                	jne    801c63 <argnext+0x119>
			goto endofargs;
  801c61:	eb 2a                	jmp    801c8d <argnext+0x143>
	}

	arg = (unsigned char) *args->curarg;
  801c63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c67:	48 8b 40 10          	mov    0x10(%rax),%rax
  801c6b:	0f b6 00             	movzbl (%rax),%eax
  801c6e:	0f b6 c0             	movzbl %al,%eax
  801c71:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  801c74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c78:	48 8b 40 10          	mov    0x10(%rax),%rax
  801c7c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801c80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c84:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  801c88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c8b:	eb 11                	jmp    801c9e <argnext+0x154>

endofargs:
	args->curarg = 0;
  801c8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c91:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  801c98:	00 
	return -1;
  801c99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  801c9e:	c9                   	leaveq 
  801c9f:	c3                   	retq   

0000000000801ca0 <argvalue>:

char *
argvalue(struct Argstate *args)
{
  801ca0:	55                   	push   %rbp
  801ca1:	48 89 e5             	mov    %rsp,%rbp
  801ca4:	48 83 ec 10          	sub    $0x10,%rsp
  801ca8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801cac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cb0:	48 8b 40 18          	mov    0x18(%rax),%rax
  801cb4:	48 85 c0             	test   %rax,%rax
  801cb7:	74 0a                	je     801cc3 <argvalue+0x23>
  801cb9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cbd:	48 8b 40 18          	mov    0x18(%rax),%rax
  801cc1:	eb 13                	jmp    801cd6 <argvalue+0x36>
  801cc3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cc7:	48 89 c7             	mov    %rax,%rdi
  801cca:	48 b8 d8 1c 80 00 00 	movabs $0x801cd8,%rax
  801cd1:	00 00 00 
  801cd4:	ff d0                	callq  *%rax
}
  801cd6:	c9                   	leaveq 
  801cd7:	c3                   	retq   

0000000000801cd8 <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  801cd8:	55                   	push   %rbp
  801cd9:	48 89 e5             	mov    %rsp,%rbp
  801cdc:	53                   	push   %rbx
  801cdd:	48 83 ec 18          	sub    $0x18,%rsp
  801ce1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (!args->curarg)
  801ce5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ce9:	48 8b 40 10          	mov    0x10(%rax),%rax
  801ced:	48 85 c0             	test   %rax,%rax
  801cf0:	75 0a                	jne    801cfc <argnextvalue+0x24>
		return 0;
  801cf2:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf7:	e9 c8 00 00 00       	jmpq   801dc4 <argnextvalue+0xec>
	if (*args->curarg) {
  801cfc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d00:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d04:	0f b6 00             	movzbl (%rax),%eax
  801d07:	84 c0                	test   %al,%al
  801d09:	74 27                	je     801d32 <argnextvalue+0x5a>
		args->argvalue = args->curarg;
  801d0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d0f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801d13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d17:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  801d1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d1f:	48 bb 73 41 80 00 00 	movabs $0x804173,%rbx
  801d26:	00 00 00 
  801d29:	48 89 58 10          	mov    %rbx,0x10(%rax)
  801d2d:	e9 8a 00 00 00       	jmpq   801dbc <argnextvalue+0xe4>
	} else if (*args->argc > 1) {
  801d32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d36:	48 8b 00             	mov    (%rax),%rax
  801d39:	8b 00                	mov    (%rax),%eax
  801d3b:	83 f8 01             	cmp    $0x1,%eax
  801d3e:	7e 64                	jle    801da4 <argnextvalue+0xcc>
		args->argvalue = args->argv[1];
  801d40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d44:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d48:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801d4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d50:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801d54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d58:	48 8b 00             	mov    (%rax),%rax
  801d5b:	8b 00                	mov    (%rax),%eax
  801d5d:	83 e8 01             	sub    $0x1,%eax
  801d60:	48 98                	cltq   
  801d62:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801d69:	00 
  801d6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d6e:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d72:	48 8d 48 10          	lea    0x10(%rax),%rcx
  801d76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d7a:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d7e:	48 83 c0 08          	add    $0x8,%rax
  801d82:	48 89 ce             	mov    %rcx,%rsi
  801d85:	48 89 c7             	mov    %rax,%rdi
  801d88:	48 b8 6e 12 80 00 00 	movabs $0x80126e,%rax
  801d8f:	00 00 00 
  801d92:	ff d0                	callq  *%rax
		(*args->argc)--;
  801d94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d98:	48 8b 00             	mov    (%rax),%rax
  801d9b:	8b 10                	mov    (%rax),%edx
  801d9d:	83 ea 01             	sub    $0x1,%edx
  801da0:	89 10                	mov    %edx,(%rax)
  801da2:	eb 18                	jmp    801dbc <argnextvalue+0xe4>
	} else {
		args->argvalue = 0;
  801da4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801da8:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801daf:	00 
		args->curarg = 0;
  801db0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801db4:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  801dbb:	00 
	}
	return (char*) args->argvalue;
  801dbc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dc0:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  801dc4:	48 83 c4 18          	add    $0x18,%rsp
  801dc8:	5b                   	pop    %rbx
  801dc9:	5d                   	pop    %rbp
  801dca:	c3                   	retq   

0000000000801dcb <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801dcb:	55                   	push   %rbp
  801dcc:	48 89 e5             	mov    %rsp,%rbp
  801dcf:	48 83 ec 08          	sub    $0x8,%rsp
  801dd3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801dd7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ddb:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801de2:	ff ff ff 
  801de5:	48 01 d0             	add    %rdx,%rax
  801de8:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801dec:	c9                   	leaveq 
  801ded:	c3                   	retq   

0000000000801dee <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801dee:	55                   	push   %rbp
  801def:	48 89 e5             	mov    %rsp,%rbp
  801df2:	48 83 ec 08          	sub    $0x8,%rsp
  801df6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801dfa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dfe:	48 89 c7             	mov    %rax,%rdi
  801e01:	48 b8 cb 1d 80 00 00 	movabs $0x801dcb,%rax
  801e08:	00 00 00 
  801e0b:	ff d0                	callq  *%rax
  801e0d:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801e13:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801e17:	c9                   	leaveq 
  801e18:	c3                   	retq   

0000000000801e19 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801e19:	55                   	push   %rbp
  801e1a:	48 89 e5             	mov    %rsp,%rbp
  801e1d:	48 83 ec 18          	sub    $0x18,%rsp
  801e21:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e2c:	eb 6b                	jmp    801e99 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801e2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e31:	48 98                	cltq   
  801e33:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e39:	48 c1 e0 0c          	shl    $0xc,%rax
  801e3d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801e41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e45:	48 c1 e8 15          	shr    $0x15,%rax
  801e49:	48 89 c2             	mov    %rax,%rdx
  801e4c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e53:	01 00 00 
  801e56:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e5a:	83 e0 01             	and    $0x1,%eax
  801e5d:	48 85 c0             	test   %rax,%rax
  801e60:	74 21                	je     801e83 <fd_alloc+0x6a>
  801e62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e66:	48 c1 e8 0c          	shr    $0xc,%rax
  801e6a:	48 89 c2             	mov    %rax,%rdx
  801e6d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e74:	01 00 00 
  801e77:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e7b:	83 e0 01             	and    $0x1,%eax
  801e7e:	48 85 c0             	test   %rax,%rax
  801e81:	75 12                	jne    801e95 <fd_alloc+0x7c>
			*fd_store = fd;
  801e83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e87:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e8b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e8e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e93:	eb 1a                	jmp    801eaf <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e95:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e99:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e9d:	7e 8f                	jle    801e2e <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ea3:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801eaa:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801eaf:	c9                   	leaveq 
  801eb0:	c3                   	retq   

0000000000801eb1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801eb1:	55                   	push   %rbp
  801eb2:	48 89 e5             	mov    %rsp,%rbp
  801eb5:	48 83 ec 20          	sub    $0x20,%rsp
  801eb9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ebc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801ec0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ec4:	78 06                	js     801ecc <fd_lookup+0x1b>
  801ec6:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801eca:	7e 07                	jle    801ed3 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ecc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ed1:	eb 6c                	jmp    801f3f <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801ed3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ed6:	48 98                	cltq   
  801ed8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ede:	48 c1 e0 0c          	shl    $0xc,%rax
  801ee2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801ee6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eea:	48 c1 e8 15          	shr    $0x15,%rax
  801eee:	48 89 c2             	mov    %rax,%rdx
  801ef1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ef8:	01 00 00 
  801efb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eff:	83 e0 01             	and    $0x1,%eax
  801f02:	48 85 c0             	test   %rax,%rax
  801f05:	74 21                	je     801f28 <fd_lookup+0x77>
  801f07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f0b:	48 c1 e8 0c          	shr    $0xc,%rax
  801f0f:	48 89 c2             	mov    %rax,%rdx
  801f12:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f19:	01 00 00 
  801f1c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f20:	83 e0 01             	and    $0x1,%eax
  801f23:	48 85 c0             	test   %rax,%rax
  801f26:	75 07                	jne    801f2f <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f28:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f2d:	eb 10                	jmp    801f3f <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801f2f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f33:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f37:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801f3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f3f:	c9                   	leaveq 
  801f40:	c3                   	retq   

0000000000801f41 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801f41:	55                   	push   %rbp
  801f42:	48 89 e5             	mov    %rsp,%rbp
  801f45:	48 83 ec 30          	sub    $0x30,%rsp
  801f49:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f4d:	89 f0                	mov    %esi,%eax
  801f4f:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f52:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f56:	48 89 c7             	mov    %rax,%rdi
  801f59:	48 b8 cb 1d 80 00 00 	movabs $0x801dcb,%rax
  801f60:	00 00 00 
  801f63:	ff d0                	callq  *%rax
  801f65:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f69:	48 89 d6             	mov    %rdx,%rsi
  801f6c:	89 c7                	mov    %eax,%edi
  801f6e:	48 b8 b1 1e 80 00 00 	movabs $0x801eb1,%rax
  801f75:	00 00 00 
  801f78:	ff d0                	callq  *%rax
  801f7a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f7d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f81:	78 0a                	js     801f8d <fd_close+0x4c>
	    || fd != fd2)
  801f83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f87:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f8b:	74 12                	je     801f9f <fd_close+0x5e>
		return (must_exist ? r : 0);
  801f8d:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801f91:	74 05                	je     801f98 <fd_close+0x57>
  801f93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f96:	eb 05                	jmp    801f9d <fd_close+0x5c>
  801f98:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9d:	eb 69                	jmp    802008 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f9f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fa3:	8b 00                	mov    (%rax),%eax
  801fa5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801fa9:	48 89 d6             	mov    %rdx,%rsi
  801fac:	89 c7                	mov    %eax,%edi
  801fae:	48 b8 0a 20 80 00 00 	movabs $0x80200a,%rax
  801fb5:	00 00 00 
  801fb8:	ff d0                	callq  *%rax
  801fba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fbd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fc1:	78 2a                	js     801fed <fd_close+0xac>
		if (dev->dev_close)
  801fc3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fc7:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fcb:	48 85 c0             	test   %rax,%rax
  801fce:	74 16                	je     801fe6 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801fd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fd4:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fd8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801fdc:	48 89 d7             	mov    %rdx,%rdi
  801fdf:	ff d0                	callq  *%rax
  801fe1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fe4:	eb 07                	jmp    801fed <fd_close+0xac>
		else
			r = 0;
  801fe6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801fed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ff1:	48 89 c6             	mov    %rax,%rsi
  801ff4:	bf 00 00 00 00       	mov    $0x0,%edi
  801ff9:	48 b8 24 19 80 00 00 	movabs $0x801924,%rax
  802000:	00 00 00 
  802003:	ff d0                	callq  *%rax
	return r;
  802005:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802008:	c9                   	leaveq 
  802009:	c3                   	retq   

000000000080200a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80200a:	55                   	push   %rbp
  80200b:	48 89 e5             	mov    %rsp,%rbp
  80200e:	48 83 ec 20          	sub    $0x20,%rsp
  802012:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802015:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802019:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802020:	eb 41                	jmp    802063 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802022:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802029:	00 00 00 
  80202c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80202f:	48 63 d2             	movslq %edx,%rdx
  802032:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802036:	8b 00                	mov    (%rax),%eax
  802038:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80203b:	75 22                	jne    80205f <dev_lookup+0x55>
			*dev = devtab[i];
  80203d:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802044:	00 00 00 
  802047:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80204a:	48 63 d2             	movslq %edx,%rdx
  80204d:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802051:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802055:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802058:	b8 00 00 00 00       	mov    $0x0,%eax
  80205d:	eb 60                	jmp    8020bf <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80205f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802063:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  80206a:	00 00 00 
  80206d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802070:	48 63 d2             	movslq %edx,%rdx
  802073:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802077:	48 85 c0             	test   %rax,%rax
  80207a:	75 a6                	jne    802022 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80207c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802083:	00 00 00 
  802086:	48 8b 00             	mov    (%rax),%rax
  802089:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80208f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802092:	89 c6                	mov    %eax,%esi
  802094:	48 bf 78 41 80 00 00 	movabs $0x804178,%rdi
  80209b:	00 00 00 
  80209e:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a3:	48 b9 95 03 80 00 00 	movabs $0x800395,%rcx
  8020aa:	00 00 00 
  8020ad:	ff d1                	callq  *%rcx
	*dev = 0;
  8020af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020b3:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8020ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8020bf:	c9                   	leaveq 
  8020c0:	c3                   	retq   

00000000008020c1 <close>:

int
close(int fdnum)
{
  8020c1:	55                   	push   %rbp
  8020c2:	48 89 e5             	mov    %rsp,%rbp
  8020c5:	48 83 ec 20          	sub    $0x20,%rsp
  8020c9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020cc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8020d0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020d3:	48 89 d6             	mov    %rdx,%rsi
  8020d6:	89 c7                	mov    %eax,%edi
  8020d8:	48 b8 b1 1e 80 00 00 	movabs $0x801eb1,%rax
  8020df:	00 00 00 
  8020e2:	ff d0                	callq  *%rax
  8020e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020eb:	79 05                	jns    8020f2 <close+0x31>
		return r;
  8020ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020f0:	eb 18                	jmp    80210a <close+0x49>
	else
		return fd_close(fd, 1);
  8020f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020f6:	be 01 00 00 00       	mov    $0x1,%esi
  8020fb:	48 89 c7             	mov    %rax,%rdi
  8020fe:	48 b8 41 1f 80 00 00 	movabs $0x801f41,%rax
  802105:	00 00 00 
  802108:	ff d0                	callq  *%rax
}
  80210a:	c9                   	leaveq 
  80210b:	c3                   	retq   

000000000080210c <close_all>:

void
close_all(void)
{
  80210c:	55                   	push   %rbp
  80210d:	48 89 e5             	mov    %rsp,%rbp
  802110:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802114:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80211b:	eb 15                	jmp    802132 <close_all+0x26>
		close(i);
  80211d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802120:	89 c7                	mov    %eax,%edi
  802122:	48 b8 c1 20 80 00 00 	movabs $0x8020c1,%rax
  802129:	00 00 00 
  80212c:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80212e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802132:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802136:	7e e5                	jle    80211d <close_all+0x11>
		close(i);
}
  802138:	c9                   	leaveq 
  802139:	c3                   	retq   

000000000080213a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80213a:	55                   	push   %rbp
  80213b:	48 89 e5             	mov    %rsp,%rbp
  80213e:	48 83 ec 40          	sub    $0x40,%rsp
  802142:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802145:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802148:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80214c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80214f:	48 89 d6             	mov    %rdx,%rsi
  802152:	89 c7                	mov    %eax,%edi
  802154:	48 b8 b1 1e 80 00 00 	movabs $0x801eb1,%rax
  80215b:	00 00 00 
  80215e:	ff d0                	callq  *%rax
  802160:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802163:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802167:	79 08                	jns    802171 <dup+0x37>
		return r;
  802169:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80216c:	e9 70 01 00 00       	jmpq   8022e1 <dup+0x1a7>
	close(newfdnum);
  802171:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802174:	89 c7                	mov    %eax,%edi
  802176:	48 b8 c1 20 80 00 00 	movabs $0x8020c1,%rax
  80217d:	00 00 00 
  802180:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802182:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802185:	48 98                	cltq   
  802187:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80218d:	48 c1 e0 0c          	shl    $0xc,%rax
  802191:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802195:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802199:	48 89 c7             	mov    %rax,%rdi
  80219c:	48 b8 ee 1d 80 00 00 	movabs $0x801dee,%rax
  8021a3:	00 00 00 
  8021a6:	ff d0                	callq  *%rax
  8021a8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8021ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021b0:	48 89 c7             	mov    %rax,%rdi
  8021b3:	48 b8 ee 1d 80 00 00 	movabs $0x801dee,%rax
  8021ba:	00 00 00 
  8021bd:	ff d0                	callq  *%rax
  8021bf:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8021c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c7:	48 c1 e8 15          	shr    $0x15,%rax
  8021cb:	48 89 c2             	mov    %rax,%rdx
  8021ce:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021d5:	01 00 00 
  8021d8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021dc:	83 e0 01             	and    $0x1,%eax
  8021df:	48 85 c0             	test   %rax,%rax
  8021e2:	74 73                	je     802257 <dup+0x11d>
  8021e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021e8:	48 c1 e8 0c          	shr    $0xc,%rax
  8021ec:	48 89 c2             	mov    %rax,%rdx
  8021ef:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021f6:	01 00 00 
  8021f9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021fd:	83 e0 01             	and    $0x1,%eax
  802200:	48 85 c0             	test   %rax,%rax
  802203:	74 52                	je     802257 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802205:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802209:	48 c1 e8 0c          	shr    $0xc,%rax
  80220d:	48 89 c2             	mov    %rax,%rdx
  802210:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802217:	01 00 00 
  80221a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80221e:	25 07 0e 00 00       	and    $0xe07,%eax
  802223:	89 c1                	mov    %eax,%ecx
  802225:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802229:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80222d:	41 89 c8             	mov    %ecx,%r8d
  802230:	48 89 d1             	mov    %rdx,%rcx
  802233:	ba 00 00 00 00       	mov    $0x0,%edx
  802238:	48 89 c6             	mov    %rax,%rsi
  80223b:	bf 00 00 00 00       	mov    $0x0,%edi
  802240:	48 b8 c9 18 80 00 00 	movabs $0x8018c9,%rax
  802247:	00 00 00 
  80224a:	ff d0                	callq  *%rax
  80224c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80224f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802253:	79 02                	jns    802257 <dup+0x11d>
			goto err;
  802255:	eb 57                	jmp    8022ae <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802257:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80225b:	48 c1 e8 0c          	shr    $0xc,%rax
  80225f:	48 89 c2             	mov    %rax,%rdx
  802262:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802269:	01 00 00 
  80226c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802270:	25 07 0e 00 00       	and    $0xe07,%eax
  802275:	89 c1                	mov    %eax,%ecx
  802277:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80227b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80227f:	41 89 c8             	mov    %ecx,%r8d
  802282:	48 89 d1             	mov    %rdx,%rcx
  802285:	ba 00 00 00 00       	mov    $0x0,%edx
  80228a:	48 89 c6             	mov    %rax,%rsi
  80228d:	bf 00 00 00 00       	mov    $0x0,%edi
  802292:	48 b8 c9 18 80 00 00 	movabs $0x8018c9,%rax
  802299:	00 00 00 
  80229c:	ff d0                	callq  *%rax
  80229e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022a5:	79 02                	jns    8022a9 <dup+0x16f>
		goto err;
  8022a7:	eb 05                	jmp    8022ae <dup+0x174>

	return newfdnum;
  8022a9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022ac:	eb 33                	jmp    8022e1 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8022ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022b2:	48 89 c6             	mov    %rax,%rsi
  8022b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8022ba:	48 b8 24 19 80 00 00 	movabs $0x801924,%rax
  8022c1:	00 00 00 
  8022c4:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8022c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022ca:	48 89 c6             	mov    %rax,%rsi
  8022cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8022d2:	48 b8 24 19 80 00 00 	movabs $0x801924,%rax
  8022d9:	00 00 00 
  8022dc:	ff d0                	callq  *%rax
	return r;
  8022de:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022e1:	c9                   	leaveq 
  8022e2:	c3                   	retq   

00000000008022e3 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8022e3:	55                   	push   %rbp
  8022e4:	48 89 e5             	mov    %rsp,%rbp
  8022e7:	48 83 ec 40          	sub    $0x40,%rsp
  8022eb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022ee:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8022f2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022f6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022fa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022fd:	48 89 d6             	mov    %rdx,%rsi
  802300:	89 c7                	mov    %eax,%edi
  802302:	48 b8 b1 1e 80 00 00 	movabs $0x801eb1,%rax
  802309:	00 00 00 
  80230c:	ff d0                	callq  *%rax
  80230e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802311:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802315:	78 24                	js     80233b <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802317:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80231b:	8b 00                	mov    (%rax),%eax
  80231d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802321:	48 89 d6             	mov    %rdx,%rsi
  802324:	89 c7                	mov    %eax,%edi
  802326:	48 b8 0a 20 80 00 00 	movabs $0x80200a,%rax
  80232d:	00 00 00 
  802330:	ff d0                	callq  *%rax
  802332:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802335:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802339:	79 05                	jns    802340 <read+0x5d>
		return r;
  80233b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80233e:	eb 76                	jmp    8023b6 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802340:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802344:	8b 40 08             	mov    0x8(%rax),%eax
  802347:	83 e0 03             	and    $0x3,%eax
  80234a:	83 f8 01             	cmp    $0x1,%eax
  80234d:	75 3a                	jne    802389 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80234f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802356:	00 00 00 
  802359:	48 8b 00             	mov    (%rax),%rax
  80235c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802362:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802365:	89 c6                	mov    %eax,%esi
  802367:	48 bf 97 41 80 00 00 	movabs $0x804197,%rdi
  80236e:	00 00 00 
  802371:	b8 00 00 00 00       	mov    $0x0,%eax
  802376:	48 b9 95 03 80 00 00 	movabs $0x800395,%rcx
  80237d:	00 00 00 
  802380:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802382:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802387:	eb 2d                	jmp    8023b6 <read+0xd3>
	}
	if (!dev->dev_read)
  802389:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80238d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802391:	48 85 c0             	test   %rax,%rax
  802394:	75 07                	jne    80239d <read+0xba>
		return -E_NOT_SUPP;
  802396:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80239b:	eb 19                	jmp    8023b6 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80239d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023a1:	48 8b 40 10          	mov    0x10(%rax),%rax
  8023a5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023a9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023ad:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023b1:	48 89 cf             	mov    %rcx,%rdi
  8023b4:	ff d0                	callq  *%rax
}
  8023b6:	c9                   	leaveq 
  8023b7:	c3                   	retq   

00000000008023b8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8023b8:	55                   	push   %rbp
  8023b9:	48 89 e5             	mov    %rsp,%rbp
  8023bc:	48 83 ec 30          	sub    $0x30,%rsp
  8023c0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023c3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8023c7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023d2:	eb 49                	jmp    80241d <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8023d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023d7:	48 98                	cltq   
  8023d9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023dd:	48 29 c2             	sub    %rax,%rdx
  8023e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023e3:	48 63 c8             	movslq %eax,%rcx
  8023e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023ea:	48 01 c1             	add    %rax,%rcx
  8023ed:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023f0:	48 89 ce             	mov    %rcx,%rsi
  8023f3:	89 c7                	mov    %eax,%edi
  8023f5:	48 b8 e3 22 80 00 00 	movabs $0x8022e3,%rax
  8023fc:	00 00 00 
  8023ff:	ff d0                	callq  *%rax
  802401:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802404:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802408:	79 05                	jns    80240f <readn+0x57>
			return m;
  80240a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80240d:	eb 1c                	jmp    80242b <readn+0x73>
		if (m == 0)
  80240f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802413:	75 02                	jne    802417 <readn+0x5f>
			break;
  802415:	eb 11                	jmp    802428 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802417:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80241a:	01 45 fc             	add    %eax,-0x4(%rbp)
  80241d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802420:	48 98                	cltq   
  802422:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802426:	72 ac                	jb     8023d4 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802428:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80242b:	c9                   	leaveq 
  80242c:	c3                   	retq   

000000000080242d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80242d:	55                   	push   %rbp
  80242e:	48 89 e5             	mov    %rsp,%rbp
  802431:	48 83 ec 40          	sub    $0x40,%rsp
  802435:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802438:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80243c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802440:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802444:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802447:	48 89 d6             	mov    %rdx,%rsi
  80244a:	89 c7                	mov    %eax,%edi
  80244c:	48 b8 b1 1e 80 00 00 	movabs $0x801eb1,%rax
  802453:	00 00 00 
  802456:	ff d0                	callq  *%rax
  802458:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80245b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80245f:	78 24                	js     802485 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802461:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802465:	8b 00                	mov    (%rax),%eax
  802467:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80246b:	48 89 d6             	mov    %rdx,%rsi
  80246e:	89 c7                	mov    %eax,%edi
  802470:	48 b8 0a 20 80 00 00 	movabs $0x80200a,%rax
  802477:	00 00 00 
  80247a:	ff d0                	callq  *%rax
  80247c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80247f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802483:	79 05                	jns    80248a <write+0x5d>
		return r;
  802485:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802488:	eb 75                	jmp    8024ff <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80248a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80248e:	8b 40 08             	mov    0x8(%rax),%eax
  802491:	83 e0 03             	and    $0x3,%eax
  802494:	85 c0                	test   %eax,%eax
  802496:	75 3a                	jne    8024d2 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802498:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80249f:	00 00 00 
  8024a2:	48 8b 00             	mov    (%rax),%rax
  8024a5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024ab:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024ae:	89 c6                	mov    %eax,%esi
  8024b0:	48 bf b3 41 80 00 00 	movabs $0x8041b3,%rdi
  8024b7:	00 00 00 
  8024ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8024bf:	48 b9 95 03 80 00 00 	movabs $0x800395,%rcx
  8024c6:	00 00 00 
  8024c9:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8024cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024d0:	eb 2d                	jmp    8024ff <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8024d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024d6:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024da:	48 85 c0             	test   %rax,%rax
  8024dd:	75 07                	jne    8024e6 <write+0xb9>
		return -E_NOT_SUPP;
  8024df:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024e4:	eb 19                	jmp    8024ff <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8024e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024ea:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024ee:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8024f2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024f6:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8024fa:	48 89 cf             	mov    %rcx,%rdi
  8024fd:	ff d0                	callq  *%rax
}
  8024ff:	c9                   	leaveq 
  802500:	c3                   	retq   

0000000000802501 <seek>:

int
seek(int fdnum, off_t offset)
{
  802501:	55                   	push   %rbp
  802502:	48 89 e5             	mov    %rsp,%rbp
  802505:	48 83 ec 18          	sub    $0x18,%rsp
  802509:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80250c:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80250f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802513:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802516:	48 89 d6             	mov    %rdx,%rsi
  802519:	89 c7                	mov    %eax,%edi
  80251b:	48 b8 b1 1e 80 00 00 	movabs $0x801eb1,%rax
  802522:	00 00 00 
  802525:	ff d0                	callq  *%rax
  802527:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80252a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80252e:	79 05                	jns    802535 <seek+0x34>
		return r;
  802530:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802533:	eb 0f                	jmp    802544 <seek+0x43>
	fd->fd_offset = offset;
  802535:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802539:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80253c:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80253f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802544:	c9                   	leaveq 
  802545:	c3                   	retq   

0000000000802546 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802546:	55                   	push   %rbp
  802547:	48 89 e5             	mov    %rsp,%rbp
  80254a:	48 83 ec 30          	sub    $0x30,%rsp
  80254e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802551:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802554:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802558:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80255b:	48 89 d6             	mov    %rdx,%rsi
  80255e:	89 c7                	mov    %eax,%edi
  802560:	48 b8 b1 1e 80 00 00 	movabs $0x801eb1,%rax
  802567:	00 00 00 
  80256a:	ff d0                	callq  *%rax
  80256c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80256f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802573:	78 24                	js     802599 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802575:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802579:	8b 00                	mov    (%rax),%eax
  80257b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80257f:	48 89 d6             	mov    %rdx,%rsi
  802582:	89 c7                	mov    %eax,%edi
  802584:	48 b8 0a 20 80 00 00 	movabs $0x80200a,%rax
  80258b:	00 00 00 
  80258e:	ff d0                	callq  *%rax
  802590:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802593:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802597:	79 05                	jns    80259e <ftruncate+0x58>
		return r;
  802599:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80259c:	eb 72                	jmp    802610 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80259e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025a2:	8b 40 08             	mov    0x8(%rax),%eax
  8025a5:	83 e0 03             	and    $0x3,%eax
  8025a8:	85 c0                	test   %eax,%eax
  8025aa:	75 3a                	jne    8025e6 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8025ac:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8025b3:	00 00 00 
  8025b6:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8025b9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025bf:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025c2:	89 c6                	mov    %eax,%esi
  8025c4:	48 bf d0 41 80 00 00 	movabs $0x8041d0,%rdi
  8025cb:	00 00 00 
  8025ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d3:	48 b9 95 03 80 00 00 	movabs $0x800395,%rcx
  8025da:	00 00 00 
  8025dd:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8025df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025e4:	eb 2a                	jmp    802610 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8025e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ea:	48 8b 40 30          	mov    0x30(%rax),%rax
  8025ee:	48 85 c0             	test   %rax,%rax
  8025f1:	75 07                	jne    8025fa <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8025f3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025f8:	eb 16                	jmp    802610 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8025fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025fe:	48 8b 40 30          	mov    0x30(%rax),%rax
  802602:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802606:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802609:	89 ce                	mov    %ecx,%esi
  80260b:	48 89 d7             	mov    %rdx,%rdi
  80260e:	ff d0                	callq  *%rax
}
  802610:	c9                   	leaveq 
  802611:	c3                   	retq   

0000000000802612 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802612:	55                   	push   %rbp
  802613:	48 89 e5             	mov    %rsp,%rbp
  802616:	48 83 ec 30          	sub    $0x30,%rsp
  80261a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80261d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802621:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802625:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802628:	48 89 d6             	mov    %rdx,%rsi
  80262b:	89 c7                	mov    %eax,%edi
  80262d:	48 b8 b1 1e 80 00 00 	movabs $0x801eb1,%rax
  802634:	00 00 00 
  802637:	ff d0                	callq  *%rax
  802639:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80263c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802640:	78 24                	js     802666 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802642:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802646:	8b 00                	mov    (%rax),%eax
  802648:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80264c:	48 89 d6             	mov    %rdx,%rsi
  80264f:	89 c7                	mov    %eax,%edi
  802651:	48 b8 0a 20 80 00 00 	movabs $0x80200a,%rax
  802658:	00 00 00 
  80265b:	ff d0                	callq  *%rax
  80265d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802660:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802664:	79 05                	jns    80266b <fstat+0x59>
		return r;
  802666:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802669:	eb 5e                	jmp    8026c9 <fstat+0xb7>
	if (!dev->dev_stat)
  80266b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80266f:	48 8b 40 28          	mov    0x28(%rax),%rax
  802673:	48 85 c0             	test   %rax,%rax
  802676:	75 07                	jne    80267f <fstat+0x6d>
		return -E_NOT_SUPP;
  802678:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80267d:	eb 4a                	jmp    8026c9 <fstat+0xb7>
	stat->st_name[0] = 0;
  80267f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802683:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802686:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80268a:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802691:	00 00 00 
	stat->st_isdir = 0;
  802694:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802698:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80269f:	00 00 00 
	stat->st_dev = dev;
  8026a2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026a6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026aa:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8026b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026b5:	48 8b 40 28          	mov    0x28(%rax),%rax
  8026b9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026bd:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8026c1:	48 89 ce             	mov    %rcx,%rsi
  8026c4:	48 89 d7             	mov    %rdx,%rdi
  8026c7:	ff d0                	callq  *%rax
}
  8026c9:	c9                   	leaveq 
  8026ca:	c3                   	retq   

00000000008026cb <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8026cb:	55                   	push   %rbp
  8026cc:	48 89 e5             	mov    %rsp,%rbp
  8026cf:	48 83 ec 20          	sub    $0x20,%rsp
  8026d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026d7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8026db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026df:	be 00 00 00 00       	mov    $0x0,%esi
  8026e4:	48 89 c7             	mov    %rax,%rdi
  8026e7:	48 b8 b9 27 80 00 00 	movabs $0x8027b9,%rax
  8026ee:	00 00 00 
  8026f1:	ff d0                	callq  *%rax
  8026f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026fa:	79 05                	jns    802701 <stat+0x36>
		return fd;
  8026fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026ff:	eb 2f                	jmp    802730 <stat+0x65>
	r = fstat(fd, stat);
  802701:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802705:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802708:	48 89 d6             	mov    %rdx,%rsi
  80270b:	89 c7                	mov    %eax,%edi
  80270d:	48 b8 12 26 80 00 00 	movabs $0x802612,%rax
  802714:	00 00 00 
  802717:	ff d0                	callq  *%rax
  802719:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80271c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80271f:	89 c7                	mov    %eax,%edi
  802721:	48 b8 c1 20 80 00 00 	movabs $0x8020c1,%rax
  802728:	00 00 00 
  80272b:	ff d0                	callq  *%rax
	return r;
  80272d:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802730:	c9                   	leaveq 
  802731:	c3                   	retq   

0000000000802732 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802732:	55                   	push   %rbp
  802733:	48 89 e5             	mov    %rsp,%rbp
  802736:	48 83 ec 10          	sub    $0x10,%rsp
  80273a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80273d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802741:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802748:	00 00 00 
  80274b:	8b 00                	mov    (%rax),%eax
  80274d:	85 c0                	test   %eax,%eax
  80274f:	75 1d                	jne    80276e <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802751:	bf 01 00 00 00       	mov    $0x1,%edi
  802756:	48 b8 13 3b 80 00 00 	movabs $0x803b13,%rax
  80275d:	00 00 00 
  802760:	ff d0                	callq  *%rax
  802762:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  802769:	00 00 00 
  80276c:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80276e:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802775:	00 00 00 
  802778:	8b 00                	mov    (%rax),%eax
  80277a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80277d:	b9 07 00 00 00       	mov    $0x7,%ecx
  802782:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802789:	00 00 00 
  80278c:	89 c7                	mov    %eax,%edi
  80278e:	48 b8 76 3a 80 00 00 	movabs $0x803a76,%rax
  802795:	00 00 00 
  802798:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80279a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80279e:	ba 00 00 00 00       	mov    $0x0,%edx
  8027a3:	48 89 c6             	mov    %rax,%rsi
  8027a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8027ab:	48 b8 b0 39 80 00 00 	movabs $0x8039b0,%rax
  8027b2:	00 00 00 
  8027b5:	ff d0                	callq  *%rax
}
  8027b7:	c9                   	leaveq 
  8027b8:	c3                   	retq   

00000000008027b9 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8027b9:	55                   	push   %rbp
  8027ba:	48 89 e5             	mov    %rsp,%rbp
  8027bd:	48 83 ec 20          	sub    $0x20,%rsp
  8027c1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027c5:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  8027c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027cc:	48 89 c7             	mov    %rax,%rdi
  8027cf:	48 b8 de 0e 80 00 00 	movabs $0x800ede,%rax
  8027d6:	00 00 00 
  8027d9:	ff d0                	callq  *%rax
  8027db:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8027e0:	7e 0a                	jle    8027ec <open+0x33>
  8027e2:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8027e7:	e9 a5 00 00 00       	jmpq   802891 <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  8027ec:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8027f0:	48 89 c7             	mov    %rax,%rdi
  8027f3:	48 b8 19 1e 80 00 00 	movabs $0x801e19,%rax
  8027fa:	00 00 00 
  8027fd:	ff d0                	callq  *%rax
  8027ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802802:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802806:	79 08                	jns    802810 <open+0x57>
		return r;
  802808:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80280b:	e9 81 00 00 00       	jmpq   802891 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  802810:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802817:	00 00 00 
  80281a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80281d:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  802823:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802827:	48 89 c6             	mov    %rax,%rsi
  80282a:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802831:	00 00 00 
  802834:	48 b8 4a 0f 80 00 00 	movabs $0x800f4a,%rax
  80283b:	00 00 00 
  80283e:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  802840:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802844:	48 89 c6             	mov    %rax,%rsi
  802847:	bf 01 00 00 00       	mov    $0x1,%edi
  80284c:	48 b8 32 27 80 00 00 	movabs $0x802732,%rax
  802853:	00 00 00 
  802856:	ff d0                	callq  *%rax
  802858:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80285b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80285f:	79 1d                	jns    80287e <open+0xc5>
		fd_close(fd, 0);
  802861:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802865:	be 00 00 00 00       	mov    $0x0,%esi
  80286a:	48 89 c7             	mov    %rax,%rdi
  80286d:	48 b8 41 1f 80 00 00 	movabs $0x801f41,%rax
  802874:	00 00 00 
  802877:	ff d0                	callq  *%rax
		return r;
  802879:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80287c:	eb 13                	jmp    802891 <open+0xd8>
	}
	return fd2num(fd);
  80287e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802882:	48 89 c7             	mov    %rax,%rdi
  802885:	48 b8 cb 1d 80 00 00 	movabs $0x801dcb,%rax
  80288c:	00 00 00 
  80288f:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  802891:	c9                   	leaveq 
  802892:	c3                   	retq   

0000000000802893 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802893:	55                   	push   %rbp
  802894:	48 89 e5             	mov    %rsp,%rbp
  802897:	48 83 ec 10          	sub    $0x10,%rsp
  80289b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80289f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028a3:	8b 50 0c             	mov    0xc(%rax),%edx
  8028a6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028ad:	00 00 00 
  8028b0:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8028b2:	be 00 00 00 00       	mov    $0x0,%esi
  8028b7:	bf 06 00 00 00       	mov    $0x6,%edi
  8028bc:	48 b8 32 27 80 00 00 	movabs $0x802732,%rax
  8028c3:	00 00 00 
  8028c6:	ff d0                	callq  *%rax
}
  8028c8:	c9                   	leaveq 
  8028c9:	c3                   	retq   

00000000008028ca <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8028ca:	55                   	push   %rbp
  8028cb:	48 89 e5             	mov    %rsp,%rbp
  8028ce:	48 83 ec 30          	sub    $0x30,%rsp
  8028d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028da:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8028de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028e2:	8b 50 0c             	mov    0xc(%rax),%edx
  8028e5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028ec:	00 00 00 
  8028ef:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8028f1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028f8:	00 00 00 
  8028fb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028ff:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  802903:	be 00 00 00 00       	mov    $0x0,%esi
  802908:	bf 03 00 00 00       	mov    $0x3,%edi
  80290d:	48 b8 32 27 80 00 00 	movabs $0x802732,%rax
  802914:	00 00 00 
  802917:	ff d0                	callq  *%rax
  802919:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80291c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802920:	79 05                	jns    802927 <devfile_read+0x5d>
		return r;
  802922:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802925:	eb 26                	jmp    80294d <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  802927:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80292a:	48 63 d0             	movslq %eax,%rdx
  80292d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802931:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802938:	00 00 00 
  80293b:	48 89 c7             	mov    %rax,%rdi
  80293e:	48 b8 85 13 80 00 00 	movabs $0x801385,%rax
  802945:	00 00 00 
  802948:	ff d0                	callq  *%rax
	return r;
  80294a:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80294d:	c9                   	leaveq 
  80294e:	c3                   	retq   

000000000080294f <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80294f:	55                   	push   %rbp
  802950:	48 89 e5             	mov    %rsp,%rbp
  802953:	48 83 ec 30          	sub    $0x30,%rsp
  802957:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80295b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80295f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  802963:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  80296a:	00 
	n = n > max ? max : n;
  80296b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80296f:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802973:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  802978:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80297c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802980:	8b 50 0c             	mov    0xc(%rax),%edx
  802983:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80298a:	00 00 00 
  80298d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  80298f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802996:	00 00 00 
  802999:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80299d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8029a1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029a9:	48 89 c6             	mov    %rax,%rsi
  8029ac:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  8029b3:	00 00 00 
  8029b6:	48 b8 85 13 80 00 00 	movabs $0x801385,%rax
  8029bd:	00 00 00 
  8029c0:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  8029c2:	be 00 00 00 00       	mov    $0x0,%esi
  8029c7:	bf 04 00 00 00       	mov    $0x4,%edi
  8029cc:	48 b8 32 27 80 00 00 	movabs $0x802732,%rax
  8029d3:	00 00 00 
  8029d6:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  8029d8:	c9                   	leaveq 
  8029d9:	c3                   	retq   

00000000008029da <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8029da:	55                   	push   %rbp
  8029db:	48 89 e5             	mov    %rsp,%rbp
  8029de:	48 83 ec 20          	sub    $0x20,%rsp
  8029e2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029e6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8029ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029ee:	8b 50 0c             	mov    0xc(%rax),%edx
  8029f1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029f8:	00 00 00 
  8029fb:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8029fd:	be 00 00 00 00       	mov    $0x0,%esi
  802a02:	bf 05 00 00 00       	mov    $0x5,%edi
  802a07:	48 b8 32 27 80 00 00 	movabs $0x802732,%rax
  802a0e:	00 00 00 
  802a11:	ff d0                	callq  *%rax
  802a13:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a1a:	79 05                	jns    802a21 <devfile_stat+0x47>
		return r;
  802a1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a1f:	eb 56                	jmp    802a77 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802a21:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a25:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802a2c:	00 00 00 
  802a2f:	48 89 c7             	mov    %rax,%rdi
  802a32:	48 b8 4a 0f 80 00 00 	movabs $0x800f4a,%rax
  802a39:	00 00 00 
  802a3c:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802a3e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a45:	00 00 00 
  802a48:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802a4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a52:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802a58:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a5f:	00 00 00 
  802a62:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802a68:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a6c:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802a72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a77:	c9                   	leaveq 
  802a78:	c3                   	retq   

0000000000802a79 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802a79:	55                   	push   %rbp
  802a7a:	48 89 e5             	mov    %rsp,%rbp
  802a7d:	48 83 ec 10          	sub    $0x10,%rsp
  802a81:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802a85:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802a88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a8c:	8b 50 0c             	mov    0xc(%rax),%edx
  802a8f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a96:	00 00 00 
  802a99:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802a9b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802aa2:	00 00 00 
  802aa5:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802aa8:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802aab:	be 00 00 00 00       	mov    $0x0,%esi
  802ab0:	bf 02 00 00 00       	mov    $0x2,%edi
  802ab5:	48 b8 32 27 80 00 00 	movabs $0x802732,%rax
  802abc:	00 00 00 
  802abf:	ff d0                	callq  *%rax
}
  802ac1:	c9                   	leaveq 
  802ac2:	c3                   	retq   

0000000000802ac3 <remove>:

// Delete a file
int
remove(const char *path)
{
  802ac3:	55                   	push   %rbp
  802ac4:	48 89 e5             	mov    %rsp,%rbp
  802ac7:	48 83 ec 10          	sub    $0x10,%rsp
  802acb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802acf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ad3:	48 89 c7             	mov    %rax,%rdi
  802ad6:	48 b8 de 0e 80 00 00 	movabs $0x800ede,%rax
  802add:	00 00 00 
  802ae0:	ff d0                	callq  *%rax
  802ae2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802ae7:	7e 07                	jle    802af0 <remove+0x2d>
		return -E_BAD_PATH;
  802ae9:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802aee:	eb 33                	jmp    802b23 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802af0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802af4:	48 89 c6             	mov    %rax,%rsi
  802af7:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802afe:	00 00 00 
  802b01:	48 b8 4a 0f 80 00 00 	movabs $0x800f4a,%rax
  802b08:	00 00 00 
  802b0b:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802b0d:	be 00 00 00 00       	mov    $0x0,%esi
  802b12:	bf 07 00 00 00       	mov    $0x7,%edi
  802b17:	48 b8 32 27 80 00 00 	movabs $0x802732,%rax
  802b1e:	00 00 00 
  802b21:	ff d0                	callq  *%rax
}
  802b23:	c9                   	leaveq 
  802b24:	c3                   	retq   

0000000000802b25 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802b25:	55                   	push   %rbp
  802b26:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802b29:	be 00 00 00 00       	mov    $0x0,%esi
  802b2e:	bf 08 00 00 00       	mov    $0x8,%edi
  802b33:	48 b8 32 27 80 00 00 	movabs $0x802732,%rax
  802b3a:	00 00 00 
  802b3d:	ff d0                	callq  *%rax
}
  802b3f:	5d                   	pop    %rbp
  802b40:	c3                   	retq   

0000000000802b41 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802b41:	55                   	push   %rbp
  802b42:	48 89 e5             	mov    %rsp,%rbp
  802b45:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802b4c:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802b53:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802b5a:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802b61:	be 00 00 00 00       	mov    $0x0,%esi
  802b66:	48 89 c7             	mov    %rax,%rdi
  802b69:	48 b8 b9 27 80 00 00 	movabs $0x8027b9,%rax
  802b70:	00 00 00 
  802b73:	ff d0                	callq  *%rax
  802b75:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802b78:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b7c:	79 28                	jns    802ba6 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802b7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b81:	89 c6                	mov    %eax,%esi
  802b83:	48 bf f6 41 80 00 00 	movabs $0x8041f6,%rdi
  802b8a:	00 00 00 
  802b8d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b92:	48 ba 95 03 80 00 00 	movabs $0x800395,%rdx
  802b99:	00 00 00 
  802b9c:	ff d2                	callq  *%rdx
		return fd_src;
  802b9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba1:	e9 74 01 00 00       	jmpq   802d1a <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802ba6:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802bad:	be 01 01 00 00       	mov    $0x101,%esi
  802bb2:	48 89 c7             	mov    %rax,%rdi
  802bb5:	48 b8 b9 27 80 00 00 	movabs $0x8027b9,%rax
  802bbc:	00 00 00 
  802bbf:	ff d0                	callq  *%rax
  802bc1:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802bc4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802bc8:	79 39                	jns    802c03 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802bca:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bcd:	89 c6                	mov    %eax,%esi
  802bcf:	48 bf 0c 42 80 00 00 	movabs $0x80420c,%rdi
  802bd6:	00 00 00 
  802bd9:	b8 00 00 00 00       	mov    $0x0,%eax
  802bde:	48 ba 95 03 80 00 00 	movabs $0x800395,%rdx
  802be5:	00 00 00 
  802be8:	ff d2                	callq  *%rdx
		close(fd_src);
  802bea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bed:	89 c7                	mov    %eax,%edi
  802bef:	48 b8 c1 20 80 00 00 	movabs $0x8020c1,%rax
  802bf6:	00 00 00 
  802bf9:	ff d0                	callq  *%rax
		return fd_dest;
  802bfb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bfe:	e9 17 01 00 00       	jmpq   802d1a <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802c03:	eb 74                	jmp    802c79 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802c05:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c08:	48 63 d0             	movslq %eax,%rdx
  802c0b:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c12:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c15:	48 89 ce             	mov    %rcx,%rsi
  802c18:	89 c7                	mov    %eax,%edi
  802c1a:	48 b8 2d 24 80 00 00 	movabs $0x80242d,%rax
  802c21:	00 00 00 
  802c24:	ff d0                	callq  *%rax
  802c26:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802c29:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802c2d:	79 4a                	jns    802c79 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802c2f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c32:	89 c6                	mov    %eax,%esi
  802c34:	48 bf 26 42 80 00 00 	movabs $0x804226,%rdi
  802c3b:	00 00 00 
  802c3e:	b8 00 00 00 00       	mov    $0x0,%eax
  802c43:	48 ba 95 03 80 00 00 	movabs $0x800395,%rdx
  802c4a:	00 00 00 
  802c4d:	ff d2                	callq  *%rdx
			close(fd_src);
  802c4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c52:	89 c7                	mov    %eax,%edi
  802c54:	48 b8 c1 20 80 00 00 	movabs $0x8020c1,%rax
  802c5b:	00 00 00 
  802c5e:	ff d0                	callq  *%rax
			close(fd_dest);
  802c60:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c63:	89 c7                	mov    %eax,%edi
  802c65:	48 b8 c1 20 80 00 00 	movabs $0x8020c1,%rax
  802c6c:	00 00 00 
  802c6f:	ff d0                	callq  *%rax
			return write_size;
  802c71:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c74:	e9 a1 00 00 00       	jmpq   802d1a <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802c79:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c83:	ba 00 02 00 00       	mov    $0x200,%edx
  802c88:	48 89 ce             	mov    %rcx,%rsi
  802c8b:	89 c7                	mov    %eax,%edi
  802c8d:	48 b8 e3 22 80 00 00 	movabs $0x8022e3,%rax
  802c94:	00 00 00 
  802c97:	ff d0                	callq  *%rax
  802c99:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802c9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802ca0:	0f 8f 5f ff ff ff    	jg     802c05 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802ca6:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802caa:	79 47                	jns    802cf3 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802cac:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802caf:	89 c6                	mov    %eax,%esi
  802cb1:	48 bf 39 42 80 00 00 	movabs $0x804239,%rdi
  802cb8:	00 00 00 
  802cbb:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc0:	48 ba 95 03 80 00 00 	movabs $0x800395,%rdx
  802cc7:	00 00 00 
  802cca:	ff d2                	callq  *%rdx
		close(fd_src);
  802ccc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ccf:	89 c7                	mov    %eax,%edi
  802cd1:	48 b8 c1 20 80 00 00 	movabs $0x8020c1,%rax
  802cd8:	00 00 00 
  802cdb:	ff d0                	callq  *%rax
		close(fd_dest);
  802cdd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ce0:	89 c7                	mov    %eax,%edi
  802ce2:	48 b8 c1 20 80 00 00 	movabs $0x8020c1,%rax
  802ce9:	00 00 00 
  802cec:	ff d0                	callq  *%rax
		return read_size;
  802cee:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802cf1:	eb 27                	jmp    802d1a <copy+0x1d9>
	}
	close(fd_src);
  802cf3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cf6:	89 c7                	mov    %eax,%edi
  802cf8:	48 b8 c1 20 80 00 00 	movabs $0x8020c1,%rax
  802cff:	00 00 00 
  802d02:	ff d0                	callq  *%rax
	close(fd_dest);
  802d04:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d07:	89 c7                	mov    %eax,%edi
  802d09:	48 b8 c1 20 80 00 00 	movabs $0x8020c1,%rax
  802d10:	00 00 00 
  802d13:	ff d0                	callq  *%rax
	return 0;
  802d15:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802d1a:	c9                   	leaveq 
  802d1b:	c3                   	retq   

0000000000802d1c <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802d1c:	55                   	push   %rbp
  802d1d:	48 89 e5             	mov    %rsp,%rbp
  802d20:	48 83 ec 20          	sub    $0x20,%rsp
  802d24:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802d28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d2c:	8b 40 0c             	mov    0xc(%rax),%eax
  802d2f:	85 c0                	test   %eax,%eax
  802d31:	7e 67                	jle    802d9a <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802d33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d37:	8b 40 04             	mov    0x4(%rax),%eax
  802d3a:	48 63 d0             	movslq %eax,%rdx
  802d3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d41:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802d45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d49:	8b 00                	mov    (%rax),%eax
  802d4b:	48 89 ce             	mov    %rcx,%rsi
  802d4e:	89 c7                	mov    %eax,%edi
  802d50:	48 b8 2d 24 80 00 00 	movabs $0x80242d,%rax
  802d57:	00 00 00 
  802d5a:	ff d0                	callq  *%rax
  802d5c:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802d5f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d63:	7e 13                	jle    802d78 <writebuf+0x5c>
			b->result += result;
  802d65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d69:	8b 50 08             	mov    0x8(%rax),%edx
  802d6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d6f:	01 c2                	add    %eax,%edx
  802d71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d75:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802d78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d7c:	8b 40 04             	mov    0x4(%rax),%eax
  802d7f:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802d82:	74 16                	je     802d9a <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802d84:	b8 00 00 00 00       	mov    $0x0,%eax
  802d89:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d8d:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802d91:	89 c2                	mov    %eax,%edx
  802d93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d97:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802d9a:	c9                   	leaveq 
  802d9b:	c3                   	retq   

0000000000802d9c <putch>:

static void
putch(int ch, void *thunk)
{
  802d9c:	55                   	push   %rbp
  802d9d:	48 89 e5             	mov    %rsp,%rbp
  802da0:	48 83 ec 20          	sub    $0x20,%rsp
  802da4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802da7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802dab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802daf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802db3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802db7:	8b 40 04             	mov    0x4(%rax),%eax
  802dba:	8d 48 01             	lea    0x1(%rax),%ecx
  802dbd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802dc1:	89 4a 04             	mov    %ecx,0x4(%rdx)
  802dc4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802dc7:	89 d1                	mov    %edx,%ecx
  802dc9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802dcd:	48 98                	cltq   
  802dcf:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  802dd3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dd7:	8b 40 04             	mov    0x4(%rax),%eax
  802dda:	3d 00 01 00 00       	cmp    $0x100,%eax
  802ddf:	75 1e                	jne    802dff <putch+0x63>
		writebuf(b);
  802de1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802de5:	48 89 c7             	mov    %rax,%rdi
  802de8:	48 b8 1c 2d 80 00 00 	movabs $0x802d1c,%rax
  802def:	00 00 00 
  802df2:	ff d0                	callq  *%rax
		b->idx = 0;
  802df4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802df8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802dff:	c9                   	leaveq 
  802e00:	c3                   	retq   

0000000000802e01 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802e01:	55                   	push   %rbp
  802e02:	48 89 e5             	mov    %rsp,%rbp
  802e05:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802e0c:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802e12:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802e19:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802e20:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802e26:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802e2c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802e33:	00 00 00 
	b.result = 0;
  802e36:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802e3d:	00 00 00 
	b.error = 1;
  802e40:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802e47:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802e4a:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802e51:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802e58:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802e5f:	48 89 c6             	mov    %rax,%rsi
  802e62:	48 bf 9c 2d 80 00 00 	movabs $0x802d9c,%rdi
  802e69:	00 00 00 
  802e6c:	48 b8 48 07 80 00 00 	movabs $0x800748,%rax
  802e73:	00 00 00 
  802e76:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802e78:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802e7e:	85 c0                	test   %eax,%eax
  802e80:	7e 16                	jle    802e98 <vfprintf+0x97>
		writebuf(&b);
  802e82:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802e89:	48 89 c7             	mov    %rax,%rdi
  802e8c:	48 b8 1c 2d 80 00 00 	movabs $0x802d1c,%rax
  802e93:	00 00 00 
  802e96:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  802e98:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802e9e:	85 c0                	test   %eax,%eax
  802ea0:	74 08                	je     802eaa <vfprintf+0xa9>
  802ea2:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802ea8:	eb 06                	jmp    802eb0 <vfprintf+0xaf>
  802eaa:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  802eb0:	c9                   	leaveq 
  802eb1:	c3                   	retq   

0000000000802eb2 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802eb2:	55                   	push   %rbp
  802eb3:	48 89 e5             	mov    %rsp,%rbp
  802eb6:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802ebd:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  802ec3:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802eca:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802ed1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802ed8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802edf:	84 c0                	test   %al,%al
  802ee1:	74 20                	je     802f03 <fprintf+0x51>
  802ee3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802ee7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802eeb:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802eef:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802ef3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802ef7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802efb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802eff:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802f03:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802f0a:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  802f11:	00 00 00 
  802f14:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802f1b:	00 00 00 
  802f1e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802f22:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802f29:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802f30:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  802f37:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802f3e:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  802f45:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802f4b:	48 89 ce             	mov    %rcx,%rsi
  802f4e:	89 c7                	mov    %eax,%edi
  802f50:	48 b8 01 2e 80 00 00 	movabs $0x802e01,%rax
  802f57:	00 00 00 
  802f5a:	ff d0                	callq  *%rax
  802f5c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802f62:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802f68:	c9                   	leaveq 
  802f69:	c3                   	retq   

0000000000802f6a <printf>:

int
printf(const char *fmt, ...)
{
  802f6a:	55                   	push   %rbp
  802f6b:	48 89 e5             	mov    %rsp,%rbp
  802f6e:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802f75:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802f7c:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802f83:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802f8a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802f91:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802f98:	84 c0                	test   %al,%al
  802f9a:	74 20                	je     802fbc <printf+0x52>
  802f9c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802fa0:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802fa4:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802fa8:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802fac:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802fb0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802fb4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802fb8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802fbc:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802fc3:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802fca:	00 00 00 
  802fcd:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802fd4:	00 00 00 
  802fd7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802fdb:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802fe2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802fe9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  802ff0:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802ff7:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802ffe:	48 89 c6             	mov    %rax,%rsi
  803001:	bf 01 00 00 00       	mov    $0x1,%edi
  803006:	48 b8 01 2e 80 00 00 	movabs $0x802e01,%rax
  80300d:	00 00 00 
  803010:	ff d0                	callq  *%rax
  803012:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  803018:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80301e:	c9                   	leaveq 
  80301f:	c3                   	retq   

0000000000803020 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803020:	55                   	push   %rbp
  803021:	48 89 e5             	mov    %rsp,%rbp
  803024:	53                   	push   %rbx
  803025:	48 83 ec 38          	sub    $0x38,%rsp
  803029:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80302d:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803031:	48 89 c7             	mov    %rax,%rdi
  803034:	48 b8 19 1e 80 00 00 	movabs $0x801e19,%rax
  80303b:	00 00 00 
  80303e:	ff d0                	callq  *%rax
  803040:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803043:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803047:	0f 88 bf 01 00 00    	js     80320c <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80304d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803051:	ba 07 04 00 00       	mov    $0x407,%edx
  803056:	48 89 c6             	mov    %rax,%rsi
  803059:	bf 00 00 00 00       	mov    $0x0,%edi
  80305e:	48 b8 79 18 80 00 00 	movabs $0x801879,%rax
  803065:	00 00 00 
  803068:	ff d0                	callq  *%rax
  80306a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80306d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803071:	0f 88 95 01 00 00    	js     80320c <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803077:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80307b:	48 89 c7             	mov    %rax,%rdi
  80307e:	48 b8 19 1e 80 00 00 	movabs $0x801e19,%rax
  803085:	00 00 00 
  803088:	ff d0                	callq  *%rax
  80308a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80308d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803091:	0f 88 5d 01 00 00    	js     8031f4 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803097:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80309b:	ba 07 04 00 00       	mov    $0x407,%edx
  8030a0:	48 89 c6             	mov    %rax,%rsi
  8030a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8030a8:	48 b8 79 18 80 00 00 	movabs $0x801879,%rax
  8030af:	00 00 00 
  8030b2:	ff d0                	callq  *%rax
  8030b4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8030b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8030bb:	0f 88 33 01 00 00    	js     8031f4 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8030c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030c5:	48 89 c7             	mov    %rax,%rdi
  8030c8:	48 b8 ee 1d 80 00 00 	movabs $0x801dee,%rax
  8030cf:	00 00 00 
  8030d2:	ff d0                	callq  *%rax
  8030d4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8030d8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030dc:	ba 07 04 00 00       	mov    $0x407,%edx
  8030e1:	48 89 c6             	mov    %rax,%rsi
  8030e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8030e9:	48 b8 79 18 80 00 00 	movabs $0x801879,%rax
  8030f0:	00 00 00 
  8030f3:	ff d0                	callq  *%rax
  8030f5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8030f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8030fc:	79 05                	jns    803103 <pipe+0xe3>
		goto err2;
  8030fe:	e9 d9 00 00 00       	jmpq   8031dc <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803103:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803107:	48 89 c7             	mov    %rax,%rdi
  80310a:	48 b8 ee 1d 80 00 00 	movabs $0x801dee,%rax
  803111:	00 00 00 
  803114:	ff d0                	callq  *%rax
  803116:	48 89 c2             	mov    %rax,%rdx
  803119:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80311d:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803123:	48 89 d1             	mov    %rdx,%rcx
  803126:	ba 00 00 00 00       	mov    $0x0,%edx
  80312b:	48 89 c6             	mov    %rax,%rsi
  80312e:	bf 00 00 00 00       	mov    $0x0,%edi
  803133:	48 b8 c9 18 80 00 00 	movabs $0x8018c9,%rax
  80313a:	00 00 00 
  80313d:	ff d0                	callq  *%rax
  80313f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803142:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803146:	79 1b                	jns    803163 <pipe+0x143>
		goto err3;
  803148:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803149:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80314d:	48 89 c6             	mov    %rax,%rsi
  803150:	bf 00 00 00 00       	mov    $0x0,%edi
  803155:	48 b8 24 19 80 00 00 	movabs $0x801924,%rax
  80315c:	00 00 00 
  80315f:	ff d0                	callq  *%rax
  803161:	eb 79                	jmp    8031dc <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803163:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803167:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  80316e:	00 00 00 
  803171:	8b 12                	mov    (%rdx),%edx
  803173:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803175:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803179:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803180:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803184:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  80318b:	00 00 00 
  80318e:	8b 12                	mov    (%rdx),%edx
  803190:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803192:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803196:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80319d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031a1:	48 89 c7             	mov    %rax,%rdi
  8031a4:	48 b8 cb 1d 80 00 00 	movabs $0x801dcb,%rax
  8031ab:	00 00 00 
  8031ae:	ff d0                	callq  *%rax
  8031b0:	89 c2                	mov    %eax,%edx
  8031b2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8031b6:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8031b8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8031bc:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8031c0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031c4:	48 89 c7             	mov    %rax,%rdi
  8031c7:	48 b8 cb 1d 80 00 00 	movabs $0x801dcb,%rax
  8031ce:	00 00 00 
  8031d1:	ff d0                	callq  *%rax
  8031d3:	89 03                	mov    %eax,(%rbx)
	return 0;
  8031d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8031da:	eb 33                	jmp    80320f <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8031dc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031e0:	48 89 c6             	mov    %rax,%rsi
  8031e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8031e8:	48 b8 24 19 80 00 00 	movabs $0x801924,%rax
  8031ef:	00 00 00 
  8031f2:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8031f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031f8:	48 89 c6             	mov    %rax,%rsi
  8031fb:	bf 00 00 00 00       	mov    $0x0,%edi
  803200:	48 b8 24 19 80 00 00 	movabs $0x801924,%rax
  803207:	00 00 00 
  80320a:	ff d0                	callq  *%rax
err:
	return r;
  80320c:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80320f:	48 83 c4 38          	add    $0x38,%rsp
  803213:	5b                   	pop    %rbx
  803214:	5d                   	pop    %rbp
  803215:	c3                   	retq   

0000000000803216 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803216:	55                   	push   %rbp
  803217:	48 89 e5             	mov    %rsp,%rbp
  80321a:	53                   	push   %rbx
  80321b:	48 83 ec 28          	sub    $0x28,%rsp
  80321f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803223:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803227:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80322e:	00 00 00 
  803231:	48 8b 00             	mov    (%rax),%rax
  803234:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80323a:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80323d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803241:	48 89 c7             	mov    %rax,%rdi
  803244:	48 b8 95 3b 80 00 00 	movabs $0x803b95,%rax
  80324b:	00 00 00 
  80324e:	ff d0                	callq  *%rax
  803250:	89 c3                	mov    %eax,%ebx
  803252:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803256:	48 89 c7             	mov    %rax,%rdi
  803259:	48 b8 95 3b 80 00 00 	movabs $0x803b95,%rax
  803260:	00 00 00 
  803263:	ff d0                	callq  *%rax
  803265:	39 c3                	cmp    %eax,%ebx
  803267:	0f 94 c0             	sete   %al
  80326a:	0f b6 c0             	movzbl %al,%eax
  80326d:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803270:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803277:	00 00 00 
  80327a:	48 8b 00             	mov    (%rax),%rax
  80327d:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803283:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803286:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803289:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80328c:	75 05                	jne    803293 <_pipeisclosed+0x7d>
			return ret;
  80328e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803291:	eb 4f                	jmp    8032e2 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803293:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803296:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803299:	74 42                	je     8032dd <_pipeisclosed+0xc7>
  80329b:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80329f:	75 3c                	jne    8032dd <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8032a1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8032a8:	00 00 00 
  8032ab:	48 8b 00             	mov    (%rax),%rax
  8032ae:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8032b4:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8032b7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032ba:	89 c6                	mov    %eax,%esi
  8032bc:	48 bf 54 42 80 00 00 	movabs $0x804254,%rdi
  8032c3:	00 00 00 
  8032c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8032cb:	49 b8 95 03 80 00 00 	movabs $0x800395,%r8
  8032d2:	00 00 00 
  8032d5:	41 ff d0             	callq  *%r8
	}
  8032d8:	e9 4a ff ff ff       	jmpq   803227 <_pipeisclosed+0x11>
  8032dd:	e9 45 ff ff ff       	jmpq   803227 <_pipeisclosed+0x11>
}
  8032e2:	48 83 c4 28          	add    $0x28,%rsp
  8032e6:	5b                   	pop    %rbx
  8032e7:	5d                   	pop    %rbp
  8032e8:	c3                   	retq   

00000000008032e9 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8032e9:	55                   	push   %rbp
  8032ea:	48 89 e5             	mov    %rsp,%rbp
  8032ed:	48 83 ec 30          	sub    $0x30,%rsp
  8032f1:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8032f4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8032f8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8032fb:	48 89 d6             	mov    %rdx,%rsi
  8032fe:	89 c7                	mov    %eax,%edi
  803300:	48 b8 b1 1e 80 00 00 	movabs $0x801eb1,%rax
  803307:	00 00 00 
  80330a:	ff d0                	callq  *%rax
  80330c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80330f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803313:	79 05                	jns    80331a <pipeisclosed+0x31>
		return r;
  803315:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803318:	eb 31                	jmp    80334b <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80331a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80331e:	48 89 c7             	mov    %rax,%rdi
  803321:	48 b8 ee 1d 80 00 00 	movabs $0x801dee,%rax
  803328:	00 00 00 
  80332b:	ff d0                	callq  *%rax
  80332d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803331:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803335:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803339:	48 89 d6             	mov    %rdx,%rsi
  80333c:	48 89 c7             	mov    %rax,%rdi
  80333f:	48 b8 16 32 80 00 00 	movabs $0x803216,%rax
  803346:	00 00 00 
  803349:	ff d0                	callq  *%rax
}
  80334b:	c9                   	leaveq 
  80334c:	c3                   	retq   

000000000080334d <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80334d:	55                   	push   %rbp
  80334e:	48 89 e5             	mov    %rsp,%rbp
  803351:	48 83 ec 40          	sub    $0x40,%rsp
  803355:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803359:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80335d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803361:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803365:	48 89 c7             	mov    %rax,%rdi
  803368:	48 b8 ee 1d 80 00 00 	movabs $0x801dee,%rax
  80336f:	00 00 00 
  803372:	ff d0                	callq  *%rax
  803374:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803378:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80337c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803380:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803387:	00 
  803388:	e9 92 00 00 00       	jmpq   80341f <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80338d:	eb 41                	jmp    8033d0 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80338f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803394:	74 09                	je     80339f <devpipe_read+0x52>
				return i;
  803396:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80339a:	e9 92 00 00 00       	jmpq   803431 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80339f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033a7:	48 89 d6             	mov    %rdx,%rsi
  8033aa:	48 89 c7             	mov    %rax,%rdi
  8033ad:	48 b8 16 32 80 00 00 	movabs $0x803216,%rax
  8033b4:	00 00 00 
  8033b7:	ff d0                	callq  *%rax
  8033b9:	85 c0                	test   %eax,%eax
  8033bb:	74 07                	je     8033c4 <devpipe_read+0x77>
				return 0;
  8033bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8033c2:	eb 6d                	jmp    803431 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8033c4:	48 b8 3b 18 80 00 00 	movabs $0x80183b,%rax
  8033cb:	00 00 00 
  8033ce:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8033d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033d4:	8b 10                	mov    (%rax),%edx
  8033d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033da:	8b 40 04             	mov    0x4(%rax),%eax
  8033dd:	39 c2                	cmp    %eax,%edx
  8033df:	74 ae                	je     80338f <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8033e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033e5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8033e9:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8033ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033f1:	8b 00                	mov    (%rax),%eax
  8033f3:	99                   	cltd   
  8033f4:	c1 ea 1b             	shr    $0x1b,%edx
  8033f7:	01 d0                	add    %edx,%eax
  8033f9:	83 e0 1f             	and    $0x1f,%eax
  8033fc:	29 d0                	sub    %edx,%eax
  8033fe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803402:	48 98                	cltq   
  803404:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803409:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80340b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80340f:	8b 00                	mov    (%rax),%eax
  803411:	8d 50 01             	lea    0x1(%rax),%edx
  803414:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803418:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80341a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80341f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803423:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803427:	0f 82 60 ff ff ff    	jb     80338d <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80342d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803431:	c9                   	leaveq 
  803432:	c3                   	retq   

0000000000803433 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803433:	55                   	push   %rbp
  803434:	48 89 e5             	mov    %rsp,%rbp
  803437:	48 83 ec 40          	sub    $0x40,%rsp
  80343b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80343f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803443:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803447:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80344b:	48 89 c7             	mov    %rax,%rdi
  80344e:	48 b8 ee 1d 80 00 00 	movabs $0x801dee,%rax
  803455:	00 00 00 
  803458:	ff d0                	callq  *%rax
  80345a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80345e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803462:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803466:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80346d:	00 
  80346e:	e9 8e 00 00 00       	jmpq   803501 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803473:	eb 31                	jmp    8034a6 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803475:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803479:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80347d:	48 89 d6             	mov    %rdx,%rsi
  803480:	48 89 c7             	mov    %rax,%rdi
  803483:	48 b8 16 32 80 00 00 	movabs $0x803216,%rax
  80348a:	00 00 00 
  80348d:	ff d0                	callq  *%rax
  80348f:	85 c0                	test   %eax,%eax
  803491:	74 07                	je     80349a <devpipe_write+0x67>
				return 0;
  803493:	b8 00 00 00 00       	mov    $0x0,%eax
  803498:	eb 79                	jmp    803513 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80349a:	48 b8 3b 18 80 00 00 	movabs $0x80183b,%rax
  8034a1:	00 00 00 
  8034a4:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8034a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034aa:	8b 40 04             	mov    0x4(%rax),%eax
  8034ad:	48 63 d0             	movslq %eax,%rdx
  8034b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034b4:	8b 00                	mov    (%rax),%eax
  8034b6:	48 98                	cltq   
  8034b8:	48 83 c0 20          	add    $0x20,%rax
  8034bc:	48 39 c2             	cmp    %rax,%rdx
  8034bf:	73 b4                	jae    803475 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8034c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034c5:	8b 40 04             	mov    0x4(%rax),%eax
  8034c8:	99                   	cltd   
  8034c9:	c1 ea 1b             	shr    $0x1b,%edx
  8034cc:	01 d0                	add    %edx,%eax
  8034ce:	83 e0 1f             	and    $0x1f,%eax
  8034d1:	29 d0                	sub    %edx,%eax
  8034d3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8034d7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8034db:	48 01 ca             	add    %rcx,%rdx
  8034de:	0f b6 0a             	movzbl (%rdx),%ecx
  8034e1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8034e5:	48 98                	cltq   
  8034e7:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8034eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034ef:	8b 40 04             	mov    0x4(%rax),%eax
  8034f2:	8d 50 01             	lea    0x1(%rax),%edx
  8034f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034f9:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8034fc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803501:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803505:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803509:	0f 82 64 ff ff ff    	jb     803473 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80350f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803513:	c9                   	leaveq 
  803514:	c3                   	retq   

0000000000803515 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803515:	55                   	push   %rbp
  803516:	48 89 e5             	mov    %rsp,%rbp
  803519:	48 83 ec 20          	sub    $0x20,%rsp
  80351d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803521:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803525:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803529:	48 89 c7             	mov    %rax,%rdi
  80352c:	48 b8 ee 1d 80 00 00 	movabs $0x801dee,%rax
  803533:	00 00 00 
  803536:	ff d0                	callq  *%rax
  803538:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80353c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803540:	48 be 67 42 80 00 00 	movabs $0x804267,%rsi
  803547:	00 00 00 
  80354a:	48 89 c7             	mov    %rax,%rdi
  80354d:	48 b8 4a 0f 80 00 00 	movabs $0x800f4a,%rax
  803554:	00 00 00 
  803557:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803559:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80355d:	8b 50 04             	mov    0x4(%rax),%edx
  803560:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803564:	8b 00                	mov    (%rax),%eax
  803566:	29 c2                	sub    %eax,%edx
  803568:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80356c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803572:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803576:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80357d:	00 00 00 
	stat->st_dev = &devpipe;
  803580:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803584:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  80358b:	00 00 00 
  80358e:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803595:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80359a:	c9                   	leaveq 
  80359b:	c3                   	retq   

000000000080359c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80359c:	55                   	push   %rbp
  80359d:	48 89 e5             	mov    %rsp,%rbp
  8035a0:	48 83 ec 10          	sub    $0x10,%rsp
  8035a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8035a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035ac:	48 89 c6             	mov    %rax,%rsi
  8035af:	bf 00 00 00 00       	mov    $0x0,%edi
  8035b4:	48 b8 24 19 80 00 00 	movabs $0x801924,%rax
  8035bb:	00 00 00 
  8035be:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8035c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035c4:	48 89 c7             	mov    %rax,%rdi
  8035c7:	48 b8 ee 1d 80 00 00 	movabs $0x801dee,%rax
  8035ce:	00 00 00 
  8035d1:	ff d0                	callq  *%rax
  8035d3:	48 89 c6             	mov    %rax,%rsi
  8035d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8035db:	48 b8 24 19 80 00 00 	movabs $0x801924,%rax
  8035e2:	00 00 00 
  8035e5:	ff d0                	callq  *%rax
}
  8035e7:	c9                   	leaveq 
  8035e8:	c3                   	retq   

00000000008035e9 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8035e9:	55                   	push   %rbp
  8035ea:	48 89 e5             	mov    %rsp,%rbp
  8035ed:	48 83 ec 20          	sub    $0x20,%rsp
  8035f1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8035f4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035f7:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8035fa:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8035fe:	be 01 00 00 00       	mov    $0x1,%esi
  803603:	48 89 c7             	mov    %rax,%rdi
  803606:	48 b8 31 17 80 00 00 	movabs $0x801731,%rax
  80360d:	00 00 00 
  803610:	ff d0                	callq  *%rax
}
  803612:	c9                   	leaveq 
  803613:	c3                   	retq   

0000000000803614 <getchar>:

int
getchar(void)
{
  803614:	55                   	push   %rbp
  803615:	48 89 e5             	mov    %rsp,%rbp
  803618:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80361c:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803620:	ba 01 00 00 00       	mov    $0x1,%edx
  803625:	48 89 c6             	mov    %rax,%rsi
  803628:	bf 00 00 00 00       	mov    $0x0,%edi
  80362d:	48 b8 e3 22 80 00 00 	movabs $0x8022e3,%rax
  803634:	00 00 00 
  803637:	ff d0                	callq  *%rax
  803639:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80363c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803640:	79 05                	jns    803647 <getchar+0x33>
		return r;
  803642:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803645:	eb 14                	jmp    80365b <getchar+0x47>
	if (r < 1)
  803647:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80364b:	7f 07                	jg     803654 <getchar+0x40>
		return -E_EOF;
  80364d:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803652:	eb 07                	jmp    80365b <getchar+0x47>
	return c;
  803654:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803658:	0f b6 c0             	movzbl %al,%eax
}
  80365b:	c9                   	leaveq 
  80365c:	c3                   	retq   

000000000080365d <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80365d:	55                   	push   %rbp
  80365e:	48 89 e5             	mov    %rsp,%rbp
  803661:	48 83 ec 20          	sub    $0x20,%rsp
  803665:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803668:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80366c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80366f:	48 89 d6             	mov    %rdx,%rsi
  803672:	89 c7                	mov    %eax,%edi
  803674:	48 b8 b1 1e 80 00 00 	movabs $0x801eb1,%rax
  80367b:	00 00 00 
  80367e:	ff d0                	callq  *%rax
  803680:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803683:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803687:	79 05                	jns    80368e <iscons+0x31>
		return r;
  803689:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80368c:	eb 1a                	jmp    8036a8 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80368e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803692:	8b 10                	mov    (%rax),%edx
  803694:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  80369b:	00 00 00 
  80369e:	8b 00                	mov    (%rax),%eax
  8036a0:	39 c2                	cmp    %eax,%edx
  8036a2:	0f 94 c0             	sete   %al
  8036a5:	0f b6 c0             	movzbl %al,%eax
}
  8036a8:	c9                   	leaveq 
  8036a9:	c3                   	retq   

00000000008036aa <opencons>:

int
opencons(void)
{
  8036aa:	55                   	push   %rbp
  8036ab:	48 89 e5             	mov    %rsp,%rbp
  8036ae:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8036b2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8036b6:	48 89 c7             	mov    %rax,%rdi
  8036b9:	48 b8 19 1e 80 00 00 	movabs $0x801e19,%rax
  8036c0:	00 00 00 
  8036c3:	ff d0                	callq  *%rax
  8036c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036cc:	79 05                	jns    8036d3 <opencons+0x29>
		return r;
  8036ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036d1:	eb 5b                	jmp    80372e <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8036d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036d7:	ba 07 04 00 00       	mov    $0x407,%edx
  8036dc:	48 89 c6             	mov    %rax,%rsi
  8036df:	bf 00 00 00 00       	mov    $0x0,%edi
  8036e4:	48 b8 79 18 80 00 00 	movabs $0x801879,%rax
  8036eb:	00 00 00 
  8036ee:	ff d0                	callq  *%rax
  8036f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036f7:	79 05                	jns    8036fe <opencons+0x54>
		return r;
  8036f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036fc:	eb 30                	jmp    80372e <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8036fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803702:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  803709:	00 00 00 
  80370c:	8b 12                	mov    (%rdx),%edx
  80370e:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803710:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803714:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80371b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80371f:	48 89 c7             	mov    %rax,%rdi
  803722:	48 b8 cb 1d 80 00 00 	movabs $0x801dcb,%rax
  803729:	00 00 00 
  80372c:	ff d0                	callq  *%rax
}
  80372e:	c9                   	leaveq 
  80372f:	c3                   	retq   

0000000000803730 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803730:	55                   	push   %rbp
  803731:	48 89 e5             	mov    %rsp,%rbp
  803734:	48 83 ec 30          	sub    $0x30,%rsp
  803738:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80373c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803740:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803744:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803749:	75 07                	jne    803752 <devcons_read+0x22>
		return 0;
  80374b:	b8 00 00 00 00       	mov    $0x0,%eax
  803750:	eb 4b                	jmp    80379d <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803752:	eb 0c                	jmp    803760 <devcons_read+0x30>
		sys_yield();
  803754:	48 b8 3b 18 80 00 00 	movabs $0x80183b,%rax
  80375b:	00 00 00 
  80375e:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803760:	48 b8 7b 17 80 00 00 	movabs $0x80177b,%rax
  803767:	00 00 00 
  80376a:	ff d0                	callq  *%rax
  80376c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80376f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803773:	74 df                	je     803754 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803775:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803779:	79 05                	jns    803780 <devcons_read+0x50>
		return c;
  80377b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80377e:	eb 1d                	jmp    80379d <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803780:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803784:	75 07                	jne    80378d <devcons_read+0x5d>
		return 0;
  803786:	b8 00 00 00 00       	mov    $0x0,%eax
  80378b:	eb 10                	jmp    80379d <devcons_read+0x6d>
	*(char*)vbuf = c;
  80378d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803790:	89 c2                	mov    %eax,%edx
  803792:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803796:	88 10                	mov    %dl,(%rax)
	return 1;
  803798:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80379d:	c9                   	leaveq 
  80379e:	c3                   	retq   

000000000080379f <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80379f:	55                   	push   %rbp
  8037a0:	48 89 e5             	mov    %rsp,%rbp
  8037a3:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8037aa:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8037b1:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8037b8:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8037bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8037c6:	eb 76                	jmp    80383e <devcons_write+0x9f>
		m = n - tot;
  8037c8:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8037cf:	89 c2                	mov    %eax,%edx
  8037d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037d4:	29 c2                	sub    %eax,%edx
  8037d6:	89 d0                	mov    %edx,%eax
  8037d8:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8037db:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037de:	83 f8 7f             	cmp    $0x7f,%eax
  8037e1:	76 07                	jbe    8037ea <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8037e3:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8037ea:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037ed:	48 63 d0             	movslq %eax,%rdx
  8037f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037f3:	48 63 c8             	movslq %eax,%rcx
  8037f6:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8037fd:	48 01 c1             	add    %rax,%rcx
  803800:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803807:	48 89 ce             	mov    %rcx,%rsi
  80380a:	48 89 c7             	mov    %rax,%rdi
  80380d:	48 b8 6e 12 80 00 00 	movabs $0x80126e,%rax
  803814:	00 00 00 
  803817:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803819:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80381c:	48 63 d0             	movslq %eax,%rdx
  80381f:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803826:	48 89 d6             	mov    %rdx,%rsi
  803829:	48 89 c7             	mov    %rax,%rdi
  80382c:	48 b8 31 17 80 00 00 	movabs $0x801731,%rax
  803833:	00 00 00 
  803836:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803838:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80383b:	01 45 fc             	add    %eax,-0x4(%rbp)
  80383e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803841:	48 98                	cltq   
  803843:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80384a:	0f 82 78 ff ff ff    	jb     8037c8 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803850:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803853:	c9                   	leaveq 
  803854:	c3                   	retq   

0000000000803855 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803855:	55                   	push   %rbp
  803856:	48 89 e5             	mov    %rsp,%rbp
  803859:	48 83 ec 08          	sub    $0x8,%rsp
  80385d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803861:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803866:	c9                   	leaveq 
  803867:	c3                   	retq   

0000000000803868 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803868:	55                   	push   %rbp
  803869:	48 89 e5             	mov    %rsp,%rbp
  80386c:	48 83 ec 10          	sub    $0x10,%rsp
  803870:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803874:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803878:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80387c:	48 be 73 42 80 00 00 	movabs $0x804273,%rsi
  803883:	00 00 00 
  803886:	48 89 c7             	mov    %rax,%rdi
  803889:	48 b8 4a 0f 80 00 00 	movabs $0x800f4a,%rax
  803890:	00 00 00 
  803893:	ff d0                	callq  *%rax
	return 0;
  803895:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80389a:	c9                   	leaveq 
  80389b:	c3                   	retq   

000000000080389c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80389c:	55                   	push   %rbp
  80389d:	48 89 e5             	mov    %rsp,%rbp
  8038a0:	53                   	push   %rbx
  8038a1:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8038a8:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8038af:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8038b5:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8038bc:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8038c3:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8038ca:	84 c0                	test   %al,%al
  8038cc:	74 23                	je     8038f1 <_panic+0x55>
  8038ce:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8038d5:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8038d9:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8038dd:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8038e1:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8038e5:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8038e9:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8038ed:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8038f1:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8038f8:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8038ff:	00 00 00 
  803902:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803909:	00 00 00 
  80390c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803910:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803917:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80391e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803925:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80392c:	00 00 00 
  80392f:	48 8b 18             	mov    (%rax),%rbx
  803932:	48 b8 fd 17 80 00 00 	movabs $0x8017fd,%rax
  803939:	00 00 00 
  80393c:	ff d0                	callq  *%rax
  80393e:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803944:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80394b:	41 89 c8             	mov    %ecx,%r8d
  80394e:	48 89 d1             	mov    %rdx,%rcx
  803951:	48 89 da             	mov    %rbx,%rdx
  803954:	89 c6                	mov    %eax,%esi
  803956:	48 bf 80 42 80 00 00 	movabs $0x804280,%rdi
  80395d:	00 00 00 
  803960:	b8 00 00 00 00       	mov    $0x0,%eax
  803965:	49 b9 95 03 80 00 00 	movabs $0x800395,%r9
  80396c:	00 00 00 
  80396f:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803972:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803979:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803980:	48 89 d6             	mov    %rdx,%rsi
  803983:	48 89 c7             	mov    %rax,%rdi
  803986:	48 b8 e9 02 80 00 00 	movabs $0x8002e9,%rax
  80398d:	00 00 00 
  803990:	ff d0                	callq  *%rax
	cprintf("\n");
  803992:	48 bf a3 42 80 00 00 	movabs $0x8042a3,%rdi
  803999:	00 00 00 
  80399c:	b8 00 00 00 00       	mov    $0x0,%eax
  8039a1:	48 ba 95 03 80 00 00 	movabs $0x800395,%rdx
  8039a8:	00 00 00 
  8039ab:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8039ad:	cc                   	int3   
  8039ae:	eb fd                	jmp    8039ad <_panic+0x111>

00000000008039b0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8039b0:	55                   	push   %rbp
  8039b1:	48 89 e5             	mov    %rsp,%rbp
  8039b4:	48 83 ec 30          	sub    $0x30,%rsp
  8039b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039bc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8039c0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  8039c4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8039c9:	74 18                	je     8039e3 <ipc_recv+0x33>
  8039cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039cf:	48 89 c7             	mov    %rax,%rdi
  8039d2:	48 b8 a2 1a 80 00 00 	movabs $0x801aa2,%rax
  8039d9:	00 00 00 
  8039dc:	ff d0                	callq  *%rax
  8039de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039e1:	eb 19                	jmp    8039fc <ipc_recv+0x4c>
  8039e3:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  8039ea:	00 00 00 
  8039ed:	48 b8 a2 1a 80 00 00 	movabs $0x801aa2,%rax
  8039f4:	00 00 00 
  8039f7:	ff d0                	callq  *%rax
  8039f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  8039fc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803a01:	74 26                	je     803a29 <ipc_recv+0x79>
  803a03:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a07:	75 15                	jne    803a1e <ipc_recv+0x6e>
  803a09:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803a10:	00 00 00 
  803a13:	48 8b 00             	mov    (%rax),%rax
  803a16:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  803a1c:	eb 05                	jmp    803a23 <ipc_recv+0x73>
  803a1e:	b8 00 00 00 00       	mov    $0x0,%eax
  803a23:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a27:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  803a29:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803a2e:	74 26                	je     803a56 <ipc_recv+0xa6>
  803a30:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a34:	75 15                	jne    803a4b <ipc_recv+0x9b>
  803a36:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803a3d:	00 00 00 
  803a40:	48 8b 00             	mov    (%rax),%rax
  803a43:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  803a49:	eb 05                	jmp    803a50 <ipc_recv+0xa0>
  803a4b:	b8 00 00 00 00       	mov    $0x0,%eax
  803a50:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803a54:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  803a56:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a5a:	75 15                	jne    803a71 <ipc_recv+0xc1>
  803a5c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803a63:	00 00 00 
  803a66:	48 8b 00             	mov    (%rax),%rax
  803a69:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  803a6f:	eb 03                	jmp    803a74 <ipc_recv+0xc4>
  803a71:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803a74:	c9                   	leaveq 
  803a75:	c3                   	retq   

0000000000803a76 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803a76:	55                   	push   %rbp
  803a77:	48 89 e5             	mov    %rsp,%rbp
  803a7a:	48 83 ec 30          	sub    $0x30,%rsp
  803a7e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a81:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803a84:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803a88:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  803a8b:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  803a92:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803a97:	75 10                	jne    803aa9 <ipc_send+0x33>
  803a99:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803aa0:	00 00 00 
  803aa3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  803aa7:	eb 62                	jmp    803b0b <ipc_send+0x95>
  803aa9:	eb 60                	jmp    803b0b <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  803aab:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803aaf:	74 30                	je     803ae1 <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  803ab1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ab4:	89 c1                	mov    %eax,%ecx
  803ab6:	48 ba a5 42 80 00 00 	movabs $0x8042a5,%rdx
  803abd:	00 00 00 
  803ac0:	be 33 00 00 00       	mov    $0x33,%esi
  803ac5:	48 bf c1 42 80 00 00 	movabs $0x8042c1,%rdi
  803acc:	00 00 00 
  803acf:	b8 00 00 00 00       	mov    $0x0,%eax
  803ad4:	49 b8 9c 38 80 00 00 	movabs $0x80389c,%r8
  803adb:	00 00 00 
  803ade:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  803ae1:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803ae4:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803ae7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803aeb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803aee:	89 c7                	mov    %eax,%edi
  803af0:	48 b8 4d 1a 80 00 00 	movabs $0x801a4d,%rax
  803af7:	00 00 00 
  803afa:	ff d0                	callq  *%rax
  803afc:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  803aff:	48 b8 3b 18 80 00 00 	movabs $0x80183b,%rax
  803b06:	00 00 00 
  803b09:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  803b0b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b0f:	75 9a                	jne    803aab <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  803b11:	c9                   	leaveq 
  803b12:	c3                   	retq   

0000000000803b13 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803b13:	55                   	push   %rbp
  803b14:	48 89 e5             	mov    %rsp,%rbp
  803b17:	48 83 ec 14          	sub    $0x14,%rsp
  803b1b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803b1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803b25:	eb 5e                	jmp    803b85 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803b27:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803b2e:	00 00 00 
  803b31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b34:	48 63 d0             	movslq %eax,%rdx
  803b37:	48 89 d0             	mov    %rdx,%rax
  803b3a:	48 c1 e0 03          	shl    $0x3,%rax
  803b3e:	48 01 d0             	add    %rdx,%rax
  803b41:	48 c1 e0 05          	shl    $0x5,%rax
  803b45:	48 01 c8             	add    %rcx,%rax
  803b48:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803b4e:	8b 00                	mov    (%rax),%eax
  803b50:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803b53:	75 2c                	jne    803b81 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803b55:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803b5c:	00 00 00 
  803b5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b62:	48 63 d0             	movslq %eax,%rdx
  803b65:	48 89 d0             	mov    %rdx,%rax
  803b68:	48 c1 e0 03          	shl    $0x3,%rax
  803b6c:	48 01 d0             	add    %rdx,%rax
  803b6f:	48 c1 e0 05          	shl    $0x5,%rax
  803b73:	48 01 c8             	add    %rcx,%rax
  803b76:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803b7c:	8b 40 08             	mov    0x8(%rax),%eax
  803b7f:	eb 12                	jmp    803b93 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803b81:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803b85:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803b8c:	7e 99                	jle    803b27 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803b8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b93:	c9                   	leaveq 
  803b94:	c3                   	retq   

0000000000803b95 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803b95:	55                   	push   %rbp
  803b96:	48 89 e5             	mov    %rsp,%rbp
  803b99:	48 83 ec 18          	sub    $0x18,%rsp
  803b9d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803ba1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ba5:	48 c1 e8 15          	shr    $0x15,%rax
  803ba9:	48 89 c2             	mov    %rax,%rdx
  803bac:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803bb3:	01 00 00 
  803bb6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803bba:	83 e0 01             	and    $0x1,%eax
  803bbd:	48 85 c0             	test   %rax,%rax
  803bc0:	75 07                	jne    803bc9 <pageref+0x34>
		return 0;
  803bc2:	b8 00 00 00 00       	mov    $0x0,%eax
  803bc7:	eb 53                	jmp    803c1c <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803bc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bcd:	48 c1 e8 0c          	shr    $0xc,%rax
  803bd1:	48 89 c2             	mov    %rax,%rdx
  803bd4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803bdb:	01 00 00 
  803bde:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803be2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803be6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bea:	83 e0 01             	and    $0x1,%eax
  803bed:	48 85 c0             	test   %rax,%rax
  803bf0:	75 07                	jne    803bf9 <pageref+0x64>
		return 0;
  803bf2:	b8 00 00 00 00       	mov    $0x0,%eax
  803bf7:	eb 23                	jmp    803c1c <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803bf9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bfd:	48 c1 e8 0c          	shr    $0xc,%rax
  803c01:	48 89 c2             	mov    %rax,%rdx
  803c04:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803c0b:	00 00 00 
  803c0e:	48 c1 e2 04          	shl    $0x4,%rdx
  803c12:	48 01 d0             	add    %rdx,%rax
  803c15:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803c19:	0f b7 c0             	movzwl %ax,%eax
}
  803c1c:	c9                   	leaveq 
  803c1d:	c3                   	retq   
