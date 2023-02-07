
obj/user/ls:     file format elf64-x86-64


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
  80003c:	e8 da 04 00 00       	callq  80051b <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <ls>:
void lsdir(const char*, const char*);
void ls1(const char*, bool, off_t, const char*);

void
ls(const char *path, const char *prefix)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80004e:	48 89 bd 58 ff ff ff 	mov    %rdi,-0xa8(%rbp)
  800055:	48 89 b5 50 ff ff ff 	mov    %rsi,-0xb0(%rbp)
	int r;
	struct Stat st;

	if ((r = stat(path, &st)) < 0)
  80005c:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800063:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80006a:	48 89 d6             	mov    %rdx,%rsi
  80006d:	48 89 c7             	mov    %rax,%rdi
  800070:	48 b8 3d 2b 80 00 00 	movabs $0x802b3d,%rax
  800077:	00 00 00 
  80007a:	ff d0                	callq  *%rax
  80007c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80007f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800083:	79 3b                	jns    8000c0 <ls+0x7d>
		panic("stat %s: %e", path, r);
  800085:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800088:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80008f:	41 89 d0             	mov    %edx,%r8d
  800092:	48 89 c1             	mov    %rax,%rcx
  800095:	48 ba 80 3f 80 00 00 	movabs $0x803f80,%rdx
  80009c:	00 00 00 
  80009f:	be 0f 00 00 00       	mov    $0xf,%esi
  8000a4:	48 bf 8c 3f 80 00 00 	movabs $0x803f8c,%rdi
  8000ab:	00 00 00 
  8000ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b3:	49 b9 ce 05 80 00 00 	movabs $0x8005ce,%r9
  8000ba:	00 00 00 
  8000bd:	41 ff d1             	callq  *%r9
	if (st.st_isdir && !flag['d'])
  8000c0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8000c3:	85 c0                	test   %eax,%eax
  8000c5:	74 36                	je     8000fd <ls+0xba>
  8000c7:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8000ce:	00 00 00 
  8000d1:	8b 80 90 01 00 00    	mov    0x190(%rax),%eax
  8000d7:	85 c0                	test   %eax,%eax
  8000d9:	75 22                	jne    8000fd <ls+0xba>
		lsdir(path, prefix);
  8000db:	48 8b 95 50 ff ff ff 	mov    -0xb0(%rbp),%rdx
  8000e2:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8000e9:	48 89 d6             	mov    %rdx,%rsi
  8000ec:	48 89 c7             	mov    %rax,%rdi
  8000ef:	48 b8 27 01 80 00 00 	movabs $0x800127,%rax
  8000f6:	00 00 00 
  8000f9:	ff d0                	callq  *%rax
  8000fb:	eb 28                	jmp    800125 <ls+0xe2>
	else
		ls1(0, st.st_isdir, st.st_size, path);
  8000fd:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800100:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800103:	85 c0                	test   %eax,%eax
  800105:	0f 95 c0             	setne  %al
  800108:	0f b6 c0             	movzbl %al,%eax
  80010b:	48 8b 8d 58 ff ff ff 	mov    -0xa8(%rbp),%rcx
  800112:	89 c6                	mov    %eax,%esi
  800114:	bf 00 00 00 00       	mov    $0x0,%edi
  800119:	48 b8 88 02 80 00 00 	movabs $0x800288,%rax
  800120:	00 00 00 
  800123:	ff d0                	callq  *%rax
}
  800125:	c9                   	leaveq 
  800126:	c3                   	retq   

0000000000800127 <lsdir>:

void
lsdir(const char *path, const char *prefix)
{
  800127:	55                   	push   %rbp
  800128:	48 89 e5             	mov    %rsp,%rbp
  80012b:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  800132:	48 89 bd e8 fe ff ff 	mov    %rdi,-0x118(%rbp)
  800139:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
  800140:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  800147:	be 00 00 00 00       	mov    $0x0,%esi
  80014c:	48 89 c7             	mov    %rax,%rdi
  80014f:	48 b8 2b 2c 80 00 00 	movabs $0x802c2b,%rax
  800156:	00 00 00 
  800159:	ff d0                	callq  *%rax
  80015b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80015e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800162:	79 3b                	jns    80019f <lsdir+0x78>
		panic("open %s: %e", path, fd);
  800164:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800167:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  80016e:	41 89 d0             	mov    %edx,%r8d
  800171:	48 89 c1             	mov    %rax,%rcx
  800174:	48 ba 96 3f 80 00 00 	movabs $0x803f96,%rdx
  80017b:	00 00 00 
  80017e:	be 1d 00 00 00       	mov    $0x1d,%esi
  800183:	48 bf 8c 3f 80 00 00 	movabs $0x803f8c,%rdi
  80018a:	00 00 00 
  80018d:	b8 00 00 00 00       	mov    $0x0,%eax
  800192:	49 b9 ce 05 80 00 00 	movabs $0x8005ce,%r9
  800199:	00 00 00 
  80019c:	41 ff d1             	callq  *%r9
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  80019f:	eb 3d                	jmp    8001de <lsdir+0xb7>
		if (f.f_name[0])
  8001a1:	0f b6 85 f0 fe ff ff 	movzbl -0x110(%rbp),%eax
  8001a8:	84 c0                	test   %al,%al
  8001aa:	74 32                	je     8001de <lsdir+0xb7>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  8001ac:	8b 95 70 ff ff ff    	mov    -0x90(%rbp),%edx
  8001b2:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  8001b8:	83 f8 01             	cmp    $0x1,%eax
  8001bb:	0f 94 c0             	sete   %al
  8001be:	0f b6 f0             	movzbl %al,%esi
  8001c1:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  8001c8:	48 8b 85 e0 fe ff ff 	mov    -0x120(%rbp),%rax
  8001cf:	48 89 c7             	mov    %rax,%rdi
  8001d2:	48 b8 88 02 80 00 00 	movabs $0x800288,%rax
  8001d9:	00 00 00 
  8001dc:	ff d0                	callq  *%rax
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
		panic("open %s: %e", path, fd);
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  8001de:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  8001e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001e8:	ba 00 01 00 00       	mov    $0x100,%edx
  8001ed:	48 89 ce             	mov    %rcx,%rsi
  8001f0:	89 c7                	mov    %eax,%edi
  8001f2:	48 b8 2a 28 80 00 00 	movabs $0x80282a,%rax
  8001f9:	00 00 00 
  8001fc:	ff d0                	callq  *%rax
  8001fe:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800201:	81 7d f8 00 01 00 00 	cmpl   $0x100,-0x8(%rbp)
  800208:	74 97                	je     8001a1 <lsdir+0x7a>
		if (f.f_name[0])
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
	if (n > 0)
  80020a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80020e:	7e 35                	jle    800245 <lsdir+0x11e>
		panic("short read in directory %s", path);
  800210:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  800217:	48 89 c1             	mov    %rax,%rcx
  80021a:	48 ba a2 3f 80 00 00 	movabs $0x803fa2,%rdx
  800221:	00 00 00 
  800224:	be 22 00 00 00       	mov    $0x22,%esi
  800229:	48 bf 8c 3f 80 00 00 	movabs $0x803f8c,%rdi
  800230:	00 00 00 
  800233:	b8 00 00 00 00       	mov    $0x0,%eax
  800238:	49 b8 ce 05 80 00 00 	movabs $0x8005ce,%r8
  80023f:	00 00 00 
  800242:	41 ff d0             	callq  *%r8
	if (n < 0)
  800245:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800249:	79 3b                	jns    800286 <lsdir+0x15f>
		panic("error reading directory %s: %e", path, n);
  80024b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80024e:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  800255:	41 89 d0             	mov    %edx,%r8d
  800258:	48 89 c1             	mov    %rax,%rcx
  80025b:	48 ba c0 3f 80 00 00 	movabs $0x803fc0,%rdx
  800262:	00 00 00 
  800265:	be 24 00 00 00       	mov    $0x24,%esi
  80026a:	48 bf 8c 3f 80 00 00 	movabs $0x803f8c,%rdi
  800271:	00 00 00 
  800274:	b8 00 00 00 00       	mov    $0x0,%eax
  800279:	49 b9 ce 05 80 00 00 	movabs $0x8005ce,%r9
  800280:	00 00 00 
  800283:	41 ff d1             	callq  *%r9
}
  800286:	c9                   	leaveq 
  800287:	c3                   	retq   

0000000000800288 <ls1>:

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  800288:	55                   	push   %rbp
  800289:	48 89 e5             	mov    %rsp,%rbp
  80028c:	48 83 ec 30          	sub    $0x30,%rsp
  800290:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800294:	89 f0                	mov    %esi,%eax
  800296:	89 55 e0             	mov    %edx,-0x20(%rbp)
  800299:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
  80029d:	88 45 e4             	mov    %al,-0x1c(%rbp)
	const char *sep;

	if(flag['l'])
  8002a0:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8002a7:	00 00 00 
  8002aa:	8b 80 b0 01 00 00    	mov    0x1b0(%rax),%eax
  8002b0:	85 c0                	test   %eax,%eax
  8002b2:	74 34                	je     8002e8 <ls1+0x60>
		printf("%11d %c ", size, isdir ? 'd' : '-');
  8002b4:	80 7d e4 00          	cmpb   $0x0,-0x1c(%rbp)
  8002b8:	74 07                	je     8002c1 <ls1+0x39>
  8002ba:	b8 64 00 00 00       	mov    $0x64,%eax
  8002bf:	eb 05                	jmp    8002c6 <ls1+0x3e>
  8002c1:	b8 2d 00 00 00       	mov    $0x2d,%eax
  8002c6:	8b 4d e0             	mov    -0x20(%rbp),%ecx
  8002c9:	89 c2                	mov    %eax,%edx
  8002cb:	89 ce                	mov    %ecx,%esi
  8002cd:	48 bf df 3f 80 00 00 	movabs $0x803fdf,%rdi
  8002d4:	00 00 00 
  8002d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002dc:	48 b9 dc 33 80 00 00 	movabs $0x8033dc,%rcx
  8002e3:	00 00 00 
  8002e6:	ff d1                	callq  *%rcx
	if(prefix) {
  8002e8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8002ed:	74 76                	je     800365 <ls1+0xdd>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  8002ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002f3:	0f b6 00             	movzbl (%rax),%eax
  8002f6:	84 c0                	test   %al,%al
  8002f8:	74 37                	je     800331 <ls1+0xa9>
  8002fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002fe:	48 89 c7             	mov    %rax,%rdi
  800301:	48 b8 50 13 80 00 00 	movabs $0x801350,%rax
  800308:	00 00 00 
  80030b:	ff d0                	callq  *%rax
  80030d:	48 98                	cltq   
  80030f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800313:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800317:	48 01 d0             	add    %rdx,%rax
  80031a:	0f b6 00             	movzbl (%rax),%eax
  80031d:	3c 2f                	cmp    $0x2f,%al
  80031f:	74 10                	je     800331 <ls1+0xa9>
			sep = "/";
  800321:	48 b8 e8 3f 80 00 00 	movabs $0x803fe8,%rax
  800328:	00 00 00 
  80032b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80032f:	eb 0e                	jmp    80033f <ls1+0xb7>
		else
			sep = "";
  800331:	48 b8 ea 3f 80 00 00 	movabs $0x803fea,%rax
  800338:	00 00 00 
  80033b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		printf("%s%s", prefix, sep);
  80033f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800343:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800347:	48 89 c6             	mov    %rax,%rsi
  80034a:	48 bf eb 3f 80 00 00 	movabs $0x803feb,%rdi
  800351:	00 00 00 
  800354:	b8 00 00 00 00       	mov    $0x0,%eax
  800359:	48 b9 dc 33 80 00 00 	movabs $0x8033dc,%rcx
  800360:	00 00 00 
  800363:	ff d1                	callq  *%rcx
	}
	printf("%s", name);
  800365:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800369:	48 89 c6             	mov    %rax,%rsi
  80036c:	48 bf f0 3f 80 00 00 	movabs $0x803ff0,%rdi
  800373:	00 00 00 
  800376:	b8 00 00 00 00       	mov    $0x0,%eax
  80037b:	48 ba dc 33 80 00 00 	movabs $0x8033dc,%rdx
  800382:	00 00 00 
  800385:	ff d2                	callq  *%rdx
	if(flag['F'] && isdir)
  800387:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80038e:	00 00 00 
  800391:	8b 80 18 01 00 00    	mov    0x118(%rax),%eax
  800397:	85 c0                	test   %eax,%eax
  800399:	74 21                	je     8003bc <ls1+0x134>
  80039b:	80 7d e4 00          	cmpb   $0x0,-0x1c(%rbp)
  80039f:	74 1b                	je     8003bc <ls1+0x134>
		printf("/");
  8003a1:	48 bf e8 3f 80 00 00 	movabs $0x803fe8,%rdi
  8003a8:	00 00 00 
  8003ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b0:	48 ba dc 33 80 00 00 	movabs $0x8033dc,%rdx
  8003b7:	00 00 00 
  8003ba:	ff d2                	callq  *%rdx
	printf("\n");
  8003bc:	48 bf f3 3f 80 00 00 	movabs $0x803ff3,%rdi
  8003c3:	00 00 00 
  8003c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8003cb:	48 ba dc 33 80 00 00 	movabs $0x8033dc,%rdx
  8003d2:	00 00 00 
  8003d5:	ff d2                	callq  *%rdx
}
  8003d7:	c9                   	leaveq 
  8003d8:	c3                   	retq   

00000000008003d9 <usage>:

void
usage(void)
{
  8003d9:	55                   	push   %rbp
  8003da:	48 89 e5             	mov    %rsp,%rbp
	printf("usage: ls [-dFl] [file...]\n");
  8003dd:	48 bf f5 3f 80 00 00 	movabs $0x803ff5,%rdi
  8003e4:	00 00 00 
  8003e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ec:	48 ba dc 33 80 00 00 	movabs $0x8033dc,%rdx
  8003f3:	00 00 00 
  8003f6:	ff d2                	callq  *%rdx
	exit();
  8003f8:	48 b8 ab 05 80 00 00 	movabs $0x8005ab,%rax
  8003ff:	00 00 00 
  800402:	ff d0                	callq  *%rax
}
  800404:	5d                   	pop    %rbp
  800405:	c3                   	retq   

0000000000800406 <umain>:

void
umain(int argc, char **argv)
{
  800406:	55                   	push   %rbp
  800407:	48 89 e5             	mov    %rsp,%rbp
  80040a:	48 83 ec 40          	sub    $0x40,%rsp
  80040e:	89 7d cc             	mov    %edi,-0x34(%rbp)
  800411:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800415:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
  800419:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80041d:	48 8d 45 cc          	lea    -0x34(%rbp),%rax
  800421:	48 89 ce             	mov    %rcx,%rsi
  800424:	48 89 c7             	mov    %rax,%rdi
  800427:	48 b8 58 1f 80 00 00 	movabs $0x801f58,%rax
  80042e:	00 00 00 
  800431:	ff d0                	callq  *%rax
	while ((i = argnext(&args)) >= 0)
  800433:	eb 49                	jmp    80047e <umain+0x78>
		switch (i) {
  800435:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800438:	83 f8 64             	cmp    $0x64,%eax
  80043b:	74 0a                	je     800447 <umain+0x41>
  80043d:	83 f8 6c             	cmp    $0x6c,%eax
  800440:	74 05                	je     800447 <umain+0x41>
  800442:	83 f8 46             	cmp    $0x46,%eax
  800445:	75 2b                	jne    800472 <umain+0x6c>
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  800447:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80044e:	00 00 00 
  800451:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800454:	48 63 d2             	movslq %edx,%rdx
  800457:	8b 04 90             	mov    (%rax,%rdx,4),%eax
  80045a:	8d 48 01             	lea    0x1(%rax),%ecx
  80045d:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  800464:	00 00 00 
  800467:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80046a:	48 63 d2             	movslq %edx,%rdx
  80046d:	89 0c 90             	mov    %ecx,(%rax,%rdx,4)
			break;
  800470:	eb 0c                	jmp    80047e <umain+0x78>
		default:
			usage();
  800472:	48 b8 d9 03 80 00 00 	movabs $0x8003d9,%rax
  800479:	00 00 00 
  80047c:	ff d0                	callq  *%rax
{
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  80047e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800482:	48 89 c7             	mov    %rax,%rdi
  800485:	48 b8 bc 1f 80 00 00 	movabs $0x801fbc,%rax
  80048c:	00 00 00 
  80048f:	ff d0                	callq  *%rax
  800491:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800494:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800498:	79 9b                	jns    800435 <umain+0x2f>
			break;
		default:
			usage();
		}

	if (argc == 1)
  80049a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80049d:	83 f8 01             	cmp    $0x1,%eax
  8004a0:	75 22                	jne    8004c4 <umain+0xbe>
		ls("/", "");
  8004a2:	48 be ea 3f 80 00 00 	movabs $0x803fea,%rsi
  8004a9:	00 00 00 
  8004ac:	48 bf e8 3f 80 00 00 	movabs $0x803fe8,%rdi
  8004b3:	00 00 00 
  8004b6:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8004bd:	00 00 00 
  8004c0:	ff d0                	callq  *%rax
  8004c2:	eb 55                	jmp    800519 <umain+0x113>
	else {
		for (i = 1; i < argc; i++)
  8004c4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  8004cb:	eb 44                	jmp    800511 <umain+0x10b>
			ls(argv[i], argv[i]);
  8004cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004d0:	48 98                	cltq   
  8004d2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8004d9:	00 
  8004da:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004de:	48 01 d0             	add    %rdx,%rax
  8004e1:	48 8b 10             	mov    (%rax),%rdx
  8004e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004e7:	48 98                	cltq   
  8004e9:	48 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%rcx
  8004f0:	00 
  8004f1:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004f5:	48 01 c8             	add    %rcx,%rax
  8004f8:	48 8b 00             	mov    (%rax),%rax
  8004fb:	48 89 d6             	mov    %rdx,%rsi
  8004fe:	48 89 c7             	mov    %rax,%rdi
  800501:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800508:	00 00 00 
  80050b:	ff d0                	callq  *%rax
		}

	if (argc == 1)
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  80050d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800511:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800514:	39 45 fc             	cmp    %eax,-0x4(%rbp)
  800517:	7c b4                	jl     8004cd <umain+0xc7>
			ls(argv[i], argv[i]);
	}
}
  800519:	c9                   	leaveq 
  80051a:	c3                   	retq   

000000000080051b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80051b:	55                   	push   %rbp
  80051c:	48 89 e5             	mov    %rsp,%rbp
  80051f:	48 83 ec 10          	sub    $0x10,%rsp
  800523:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800526:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  80052a:	48 b8 6f 1c 80 00 00 	movabs $0x801c6f,%rax
  800531:	00 00 00 
  800534:	ff d0                	callq  *%rax
  800536:	48 98                	cltq   
  800538:	25 ff 03 00 00       	and    $0x3ff,%eax
  80053d:	48 89 c2             	mov    %rax,%rdx
  800540:	48 89 d0             	mov    %rdx,%rax
  800543:	48 c1 e0 03          	shl    $0x3,%rax
  800547:	48 01 d0             	add    %rdx,%rax
  80054a:	48 c1 e0 05          	shl    $0x5,%rax
  80054e:	48 89 c2             	mov    %rax,%rdx
  800551:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800558:	00 00 00 
  80055b:	48 01 c2             	add    %rax,%rdx
  80055e:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  800565:	00 00 00 
  800568:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80056b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80056f:	7e 14                	jle    800585 <libmain+0x6a>
		binaryname = argv[0];
  800571:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800575:	48 8b 10             	mov    (%rax),%rdx
  800578:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80057f:	00 00 00 
  800582:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800585:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800589:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80058c:	48 89 d6             	mov    %rdx,%rsi
  80058f:	89 c7                	mov    %eax,%edi
  800591:	48 b8 06 04 80 00 00 	movabs $0x800406,%rax
  800598:	00 00 00 
  80059b:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80059d:	48 b8 ab 05 80 00 00 	movabs $0x8005ab,%rax
  8005a4:	00 00 00 
  8005a7:	ff d0                	callq  *%rax
}
  8005a9:	c9                   	leaveq 
  8005aa:	c3                   	retq   

00000000008005ab <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8005ab:	55                   	push   %rbp
  8005ac:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8005af:	48 b8 7e 25 80 00 00 	movabs $0x80257e,%rax
  8005b6:	00 00 00 
  8005b9:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8005bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8005c0:	48 b8 2b 1c 80 00 00 	movabs $0x801c2b,%rax
  8005c7:	00 00 00 
  8005ca:	ff d0                	callq  *%rax
}
  8005cc:	5d                   	pop    %rbp
  8005cd:	c3                   	retq   

00000000008005ce <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005ce:	55                   	push   %rbp
  8005cf:	48 89 e5             	mov    %rsp,%rbp
  8005d2:	53                   	push   %rbx
  8005d3:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8005da:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8005e1:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8005e7:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8005ee:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8005f5:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8005fc:	84 c0                	test   %al,%al
  8005fe:	74 23                	je     800623 <_panic+0x55>
  800600:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800607:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80060b:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80060f:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800613:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800617:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80061b:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80061f:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800623:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80062a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800631:	00 00 00 
  800634:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80063b:	00 00 00 
  80063e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800642:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800649:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800650:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800657:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80065e:	00 00 00 
  800661:	48 8b 18             	mov    (%rax),%rbx
  800664:	48 b8 6f 1c 80 00 00 	movabs $0x801c6f,%rax
  80066b:	00 00 00 
  80066e:	ff d0                	callq  *%rax
  800670:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800676:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80067d:	41 89 c8             	mov    %ecx,%r8d
  800680:	48 89 d1             	mov    %rdx,%rcx
  800683:	48 89 da             	mov    %rbx,%rdx
  800686:	89 c6                	mov    %eax,%esi
  800688:	48 bf 20 40 80 00 00 	movabs $0x804020,%rdi
  80068f:	00 00 00 
  800692:	b8 00 00 00 00       	mov    $0x0,%eax
  800697:	49 b9 07 08 80 00 00 	movabs $0x800807,%r9
  80069e:	00 00 00 
  8006a1:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8006a4:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8006ab:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006b2:	48 89 d6             	mov    %rdx,%rsi
  8006b5:	48 89 c7             	mov    %rax,%rdi
  8006b8:	48 b8 5b 07 80 00 00 	movabs $0x80075b,%rax
  8006bf:	00 00 00 
  8006c2:	ff d0                	callq  *%rax
	cprintf("\n");
  8006c4:	48 bf 43 40 80 00 00 	movabs $0x804043,%rdi
  8006cb:	00 00 00 
  8006ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8006d3:	48 ba 07 08 80 00 00 	movabs $0x800807,%rdx
  8006da:	00 00 00 
  8006dd:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8006df:	cc                   	int3   
  8006e0:	eb fd                	jmp    8006df <_panic+0x111>

00000000008006e2 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8006e2:	55                   	push   %rbp
  8006e3:	48 89 e5             	mov    %rsp,%rbp
  8006e6:	48 83 ec 10          	sub    $0x10,%rsp
  8006ea:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8006ed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8006f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006f5:	8b 00                	mov    (%rax),%eax
  8006f7:	8d 48 01             	lea    0x1(%rax),%ecx
  8006fa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006fe:	89 0a                	mov    %ecx,(%rdx)
  800700:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800703:	89 d1                	mov    %edx,%ecx
  800705:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800709:	48 98                	cltq   
  80070b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80070f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800713:	8b 00                	mov    (%rax),%eax
  800715:	3d ff 00 00 00       	cmp    $0xff,%eax
  80071a:	75 2c                	jne    800748 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80071c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800720:	8b 00                	mov    (%rax),%eax
  800722:	48 98                	cltq   
  800724:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800728:	48 83 c2 08          	add    $0x8,%rdx
  80072c:	48 89 c6             	mov    %rax,%rsi
  80072f:	48 89 d7             	mov    %rdx,%rdi
  800732:	48 b8 a3 1b 80 00 00 	movabs $0x801ba3,%rax
  800739:	00 00 00 
  80073c:	ff d0                	callq  *%rax
        b->idx = 0;
  80073e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800742:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800748:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80074c:	8b 40 04             	mov    0x4(%rax),%eax
  80074f:	8d 50 01             	lea    0x1(%rax),%edx
  800752:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800756:	89 50 04             	mov    %edx,0x4(%rax)
}
  800759:	c9                   	leaveq 
  80075a:	c3                   	retq   

000000000080075b <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80075b:	55                   	push   %rbp
  80075c:	48 89 e5             	mov    %rsp,%rbp
  80075f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800766:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80076d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800774:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80077b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800782:	48 8b 0a             	mov    (%rdx),%rcx
  800785:	48 89 08             	mov    %rcx,(%rax)
  800788:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80078c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800790:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800794:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800798:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80079f:	00 00 00 
    b.cnt = 0;
  8007a2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8007a9:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8007ac:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8007b3:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8007ba:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8007c1:	48 89 c6             	mov    %rax,%rsi
  8007c4:	48 bf e2 06 80 00 00 	movabs $0x8006e2,%rdi
  8007cb:	00 00 00 
  8007ce:	48 b8 ba 0b 80 00 00 	movabs $0x800bba,%rax
  8007d5:	00 00 00 
  8007d8:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8007da:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8007e0:	48 98                	cltq   
  8007e2:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8007e9:	48 83 c2 08          	add    $0x8,%rdx
  8007ed:	48 89 c6             	mov    %rax,%rsi
  8007f0:	48 89 d7             	mov    %rdx,%rdi
  8007f3:	48 b8 a3 1b 80 00 00 	movabs $0x801ba3,%rax
  8007fa:	00 00 00 
  8007fd:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8007ff:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800805:	c9                   	leaveq 
  800806:	c3                   	retq   

0000000000800807 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800807:	55                   	push   %rbp
  800808:	48 89 e5             	mov    %rsp,%rbp
  80080b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800812:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800819:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800820:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800827:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80082e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800835:	84 c0                	test   %al,%al
  800837:	74 20                	je     800859 <cprintf+0x52>
  800839:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80083d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800841:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800845:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800849:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80084d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800851:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800855:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800859:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800860:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800867:	00 00 00 
  80086a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800871:	00 00 00 
  800874:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800878:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80087f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800886:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80088d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800894:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80089b:	48 8b 0a             	mov    (%rdx),%rcx
  80089e:	48 89 08             	mov    %rcx,(%rax)
  8008a1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008a5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008a9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008ad:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8008b1:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8008b8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8008bf:	48 89 d6             	mov    %rdx,%rsi
  8008c2:	48 89 c7             	mov    %rax,%rdi
  8008c5:	48 b8 5b 07 80 00 00 	movabs $0x80075b,%rax
  8008cc:	00 00 00 
  8008cf:	ff d0                	callq  *%rax
  8008d1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8008d7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8008dd:	c9                   	leaveq 
  8008de:	c3                   	retq   

00000000008008df <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008df:	55                   	push   %rbp
  8008e0:	48 89 e5             	mov    %rsp,%rbp
  8008e3:	53                   	push   %rbx
  8008e4:	48 83 ec 38          	sub    $0x38,%rsp
  8008e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8008f0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8008f4:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8008f7:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8008fb:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008ff:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800902:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800906:	77 3b                	ja     800943 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800908:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80090b:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80090f:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800912:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800916:	ba 00 00 00 00       	mov    $0x0,%edx
  80091b:	48 f7 f3             	div    %rbx
  80091e:	48 89 c2             	mov    %rax,%rdx
  800921:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800924:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800927:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80092b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092f:	41 89 f9             	mov    %edi,%r9d
  800932:	48 89 c7             	mov    %rax,%rdi
  800935:	48 b8 df 08 80 00 00 	movabs $0x8008df,%rax
  80093c:	00 00 00 
  80093f:	ff d0                	callq  *%rax
  800941:	eb 1e                	jmp    800961 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800943:	eb 12                	jmp    800957 <printnum+0x78>
			putch(padc, putdat);
  800945:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800949:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80094c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800950:	48 89 ce             	mov    %rcx,%rsi
  800953:	89 d7                	mov    %edx,%edi
  800955:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800957:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80095b:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80095f:	7f e4                	jg     800945 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800961:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800964:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800968:	ba 00 00 00 00       	mov    $0x0,%edx
  80096d:	48 f7 f1             	div    %rcx
  800970:	48 89 d0             	mov    %rdx,%rax
  800973:	48 ba 50 42 80 00 00 	movabs $0x804250,%rdx
  80097a:	00 00 00 
  80097d:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800981:	0f be d0             	movsbl %al,%edx
  800984:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800988:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098c:	48 89 ce             	mov    %rcx,%rsi
  80098f:	89 d7                	mov    %edx,%edi
  800991:	ff d0                	callq  *%rax
}
  800993:	48 83 c4 38          	add    $0x38,%rsp
  800997:	5b                   	pop    %rbx
  800998:	5d                   	pop    %rbp
  800999:	c3                   	retq   

000000000080099a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80099a:	55                   	push   %rbp
  80099b:	48 89 e5             	mov    %rsp,%rbp
  80099e:	48 83 ec 1c          	sub    $0x1c,%rsp
  8009a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009a6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8009a9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009ad:	7e 52                	jle    800a01 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8009af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b3:	8b 00                	mov    (%rax),%eax
  8009b5:	83 f8 30             	cmp    $0x30,%eax
  8009b8:	73 24                	jae    8009de <getuint+0x44>
  8009ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009be:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c6:	8b 00                	mov    (%rax),%eax
  8009c8:	89 c0                	mov    %eax,%eax
  8009ca:	48 01 d0             	add    %rdx,%rax
  8009cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d1:	8b 12                	mov    (%rdx),%edx
  8009d3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009da:	89 0a                	mov    %ecx,(%rdx)
  8009dc:	eb 17                	jmp    8009f5 <getuint+0x5b>
  8009de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009e6:	48 89 d0             	mov    %rdx,%rax
  8009e9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009f5:	48 8b 00             	mov    (%rax),%rax
  8009f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009fc:	e9 a3 00 00 00       	jmpq   800aa4 <getuint+0x10a>
	else if (lflag)
  800a01:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a05:	74 4f                	je     800a56 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800a07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a0b:	8b 00                	mov    (%rax),%eax
  800a0d:	83 f8 30             	cmp    $0x30,%eax
  800a10:	73 24                	jae    800a36 <getuint+0x9c>
  800a12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a16:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a1e:	8b 00                	mov    (%rax),%eax
  800a20:	89 c0                	mov    %eax,%eax
  800a22:	48 01 d0             	add    %rdx,%rax
  800a25:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a29:	8b 12                	mov    (%rdx),%edx
  800a2b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a2e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a32:	89 0a                	mov    %ecx,(%rdx)
  800a34:	eb 17                	jmp    800a4d <getuint+0xb3>
  800a36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a3a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a3e:	48 89 d0             	mov    %rdx,%rax
  800a41:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a45:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a49:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a4d:	48 8b 00             	mov    (%rax),%rax
  800a50:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a54:	eb 4e                	jmp    800aa4 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800a56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a5a:	8b 00                	mov    (%rax),%eax
  800a5c:	83 f8 30             	cmp    $0x30,%eax
  800a5f:	73 24                	jae    800a85 <getuint+0xeb>
  800a61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a65:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a6d:	8b 00                	mov    (%rax),%eax
  800a6f:	89 c0                	mov    %eax,%eax
  800a71:	48 01 d0             	add    %rdx,%rax
  800a74:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a78:	8b 12                	mov    (%rdx),%edx
  800a7a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a7d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a81:	89 0a                	mov    %ecx,(%rdx)
  800a83:	eb 17                	jmp    800a9c <getuint+0x102>
  800a85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a89:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a8d:	48 89 d0             	mov    %rdx,%rax
  800a90:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a94:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a98:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a9c:	8b 00                	mov    (%rax),%eax
  800a9e:	89 c0                	mov    %eax,%eax
  800aa0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800aa4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800aa8:	c9                   	leaveq 
  800aa9:	c3                   	retq   

0000000000800aaa <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800aaa:	55                   	push   %rbp
  800aab:	48 89 e5             	mov    %rsp,%rbp
  800aae:	48 83 ec 1c          	sub    $0x1c,%rsp
  800ab2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ab6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800ab9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800abd:	7e 52                	jle    800b11 <getint+0x67>
		x=va_arg(*ap, long long);
  800abf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac3:	8b 00                	mov    (%rax),%eax
  800ac5:	83 f8 30             	cmp    $0x30,%eax
  800ac8:	73 24                	jae    800aee <getint+0x44>
  800aca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ace:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ad2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad6:	8b 00                	mov    (%rax),%eax
  800ad8:	89 c0                	mov    %eax,%eax
  800ada:	48 01 d0             	add    %rdx,%rax
  800add:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ae1:	8b 12                	mov    (%rdx),%edx
  800ae3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ae6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aea:	89 0a                	mov    %ecx,(%rdx)
  800aec:	eb 17                	jmp    800b05 <getint+0x5b>
  800aee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800af2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800af6:	48 89 d0             	mov    %rdx,%rax
  800af9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800afd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b01:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b05:	48 8b 00             	mov    (%rax),%rax
  800b08:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b0c:	e9 a3 00 00 00       	jmpq   800bb4 <getint+0x10a>
	else if (lflag)
  800b11:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800b15:	74 4f                	je     800b66 <getint+0xbc>
		x=va_arg(*ap, long);
  800b17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b1b:	8b 00                	mov    (%rax),%eax
  800b1d:	83 f8 30             	cmp    $0x30,%eax
  800b20:	73 24                	jae    800b46 <getint+0x9c>
  800b22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b26:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b2e:	8b 00                	mov    (%rax),%eax
  800b30:	89 c0                	mov    %eax,%eax
  800b32:	48 01 d0             	add    %rdx,%rax
  800b35:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b39:	8b 12                	mov    (%rdx),%edx
  800b3b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b3e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b42:	89 0a                	mov    %ecx,(%rdx)
  800b44:	eb 17                	jmp    800b5d <getint+0xb3>
  800b46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b4a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b4e:	48 89 d0             	mov    %rdx,%rax
  800b51:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b55:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b59:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b5d:	48 8b 00             	mov    (%rax),%rax
  800b60:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b64:	eb 4e                	jmp    800bb4 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800b66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b6a:	8b 00                	mov    (%rax),%eax
  800b6c:	83 f8 30             	cmp    $0x30,%eax
  800b6f:	73 24                	jae    800b95 <getint+0xeb>
  800b71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b75:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b7d:	8b 00                	mov    (%rax),%eax
  800b7f:	89 c0                	mov    %eax,%eax
  800b81:	48 01 d0             	add    %rdx,%rax
  800b84:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b88:	8b 12                	mov    (%rdx),%edx
  800b8a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b8d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b91:	89 0a                	mov    %ecx,(%rdx)
  800b93:	eb 17                	jmp    800bac <getint+0x102>
  800b95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b99:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b9d:	48 89 d0             	mov    %rdx,%rax
  800ba0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ba4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ba8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800bac:	8b 00                	mov    (%rax),%eax
  800bae:	48 98                	cltq   
  800bb0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800bb4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800bb8:	c9                   	leaveq 
  800bb9:	c3                   	retq   

0000000000800bba <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bba:	55                   	push   %rbp
  800bbb:	48 89 e5             	mov    %rsp,%rbp
  800bbe:	41 54                	push   %r12
  800bc0:	53                   	push   %rbx
  800bc1:	48 83 ec 60          	sub    $0x60,%rsp
  800bc5:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800bc9:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800bcd:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800bd1:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800bd5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bd9:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800bdd:	48 8b 0a             	mov    (%rdx),%rcx
  800be0:	48 89 08             	mov    %rcx,(%rax)
  800be3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800be7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800beb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800bef:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bf3:	eb 17                	jmp    800c0c <vprintfmt+0x52>
			if (ch == '\0')
  800bf5:	85 db                	test   %ebx,%ebx
  800bf7:	0f 84 cc 04 00 00    	je     8010c9 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800bfd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c01:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c05:	48 89 d6             	mov    %rdx,%rsi
  800c08:	89 df                	mov    %ebx,%edi
  800c0a:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c0c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c10:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c14:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c18:	0f b6 00             	movzbl (%rax),%eax
  800c1b:	0f b6 d8             	movzbl %al,%ebx
  800c1e:	83 fb 25             	cmp    $0x25,%ebx
  800c21:	75 d2                	jne    800bf5 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c23:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800c27:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800c2e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800c35:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800c3c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c43:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c47:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c4b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c4f:	0f b6 00             	movzbl (%rax),%eax
  800c52:	0f b6 d8             	movzbl %al,%ebx
  800c55:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800c58:	83 f8 55             	cmp    $0x55,%eax
  800c5b:	0f 87 34 04 00 00    	ja     801095 <vprintfmt+0x4db>
  800c61:	89 c0                	mov    %eax,%eax
  800c63:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800c6a:	00 
  800c6b:	48 b8 78 42 80 00 00 	movabs $0x804278,%rax
  800c72:	00 00 00 
  800c75:	48 01 d0             	add    %rdx,%rax
  800c78:	48 8b 00             	mov    (%rax),%rax
  800c7b:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800c7d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800c81:	eb c0                	jmp    800c43 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c83:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800c87:	eb ba                	jmp    800c43 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c89:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800c90:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800c93:	89 d0                	mov    %edx,%eax
  800c95:	c1 e0 02             	shl    $0x2,%eax
  800c98:	01 d0                	add    %edx,%eax
  800c9a:	01 c0                	add    %eax,%eax
  800c9c:	01 d8                	add    %ebx,%eax
  800c9e:	83 e8 30             	sub    $0x30,%eax
  800ca1:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800ca4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ca8:	0f b6 00             	movzbl (%rax),%eax
  800cab:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cae:	83 fb 2f             	cmp    $0x2f,%ebx
  800cb1:	7e 0c                	jle    800cbf <vprintfmt+0x105>
  800cb3:	83 fb 39             	cmp    $0x39,%ebx
  800cb6:	7f 07                	jg     800cbf <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cb8:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cbd:	eb d1                	jmp    800c90 <vprintfmt+0xd6>
			goto process_precision;
  800cbf:	eb 58                	jmp    800d19 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800cc1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cc4:	83 f8 30             	cmp    $0x30,%eax
  800cc7:	73 17                	jae    800ce0 <vprintfmt+0x126>
  800cc9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ccd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cd0:	89 c0                	mov    %eax,%eax
  800cd2:	48 01 d0             	add    %rdx,%rax
  800cd5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cd8:	83 c2 08             	add    $0x8,%edx
  800cdb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cde:	eb 0f                	jmp    800cef <vprintfmt+0x135>
  800ce0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ce4:	48 89 d0             	mov    %rdx,%rax
  800ce7:	48 83 c2 08          	add    $0x8,%rdx
  800ceb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cef:	8b 00                	mov    (%rax),%eax
  800cf1:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800cf4:	eb 23                	jmp    800d19 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800cf6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cfa:	79 0c                	jns    800d08 <vprintfmt+0x14e>
				width = 0;
  800cfc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800d03:	e9 3b ff ff ff       	jmpq   800c43 <vprintfmt+0x89>
  800d08:	e9 36 ff ff ff       	jmpq   800c43 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800d0d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800d14:	e9 2a ff ff ff       	jmpq   800c43 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800d19:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d1d:	79 12                	jns    800d31 <vprintfmt+0x177>
				width = precision, precision = -1;
  800d1f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d22:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800d25:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800d2c:	e9 12 ff ff ff       	jmpq   800c43 <vprintfmt+0x89>
  800d31:	e9 0d ff ff ff       	jmpq   800c43 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d36:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800d3a:	e9 04 ff ff ff       	jmpq   800c43 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800d3f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d42:	83 f8 30             	cmp    $0x30,%eax
  800d45:	73 17                	jae    800d5e <vprintfmt+0x1a4>
  800d47:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d4b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d4e:	89 c0                	mov    %eax,%eax
  800d50:	48 01 d0             	add    %rdx,%rax
  800d53:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d56:	83 c2 08             	add    $0x8,%edx
  800d59:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d5c:	eb 0f                	jmp    800d6d <vprintfmt+0x1b3>
  800d5e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d62:	48 89 d0             	mov    %rdx,%rax
  800d65:	48 83 c2 08          	add    $0x8,%rdx
  800d69:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d6d:	8b 10                	mov    (%rax),%edx
  800d6f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d73:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d77:	48 89 ce             	mov    %rcx,%rsi
  800d7a:	89 d7                	mov    %edx,%edi
  800d7c:	ff d0                	callq  *%rax
			break;
  800d7e:	e9 40 03 00 00       	jmpq   8010c3 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800d83:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d86:	83 f8 30             	cmp    $0x30,%eax
  800d89:	73 17                	jae    800da2 <vprintfmt+0x1e8>
  800d8b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d8f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d92:	89 c0                	mov    %eax,%eax
  800d94:	48 01 d0             	add    %rdx,%rax
  800d97:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d9a:	83 c2 08             	add    $0x8,%edx
  800d9d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800da0:	eb 0f                	jmp    800db1 <vprintfmt+0x1f7>
  800da2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800da6:	48 89 d0             	mov    %rdx,%rax
  800da9:	48 83 c2 08          	add    $0x8,%rdx
  800dad:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800db1:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800db3:	85 db                	test   %ebx,%ebx
  800db5:	79 02                	jns    800db9 <vprintfmt+0x1ff>
				err = -err;
  800db7:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800db9:	83 fb 15             	cmp    $0x15,%ebx
  800dbc:	7f 16                	jg     800dd4 <vprintfmt+0x21a>
  800dbe:	48 b8 a0 41 80 00 00 	movabs $0x8041a0,%rax
  800dc5:	00 00 00 
  800dc8:	48 63 d3             	movslq %ebx,%rdx
  800dcb:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800dcf:	4d 85 e4             	test   %r12,%r12
  800dd2:	75 2e                	jne    800e02 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800dd4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800dd8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ddc:	89 d9                	mov    %ebx,%ecx
  800dde:	48 ba 61 42 80 00 00 	movabs $0x804261,%rdx
  800de5:	00 00 00 
  800de8:	48 89 c7             	mov    %rax,%rdi
  800deb:	b8 00 00 00 00       	mov    $0x0,%eax
  800df0:	49 b8 d2 10 80 00 00 	movabs $0x8010d2,%r8
  800df7:	00 00 00 
  800dfa:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800dfd:	e9 c1 02 00 00       	jmpq   8010c3 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e02:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e06:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e0a:	4c 89 e1             	mov    %r12,%rcx
  800e0d:	48 ba 6a 42 80 00 00 	movabs $0x80426a,%rdx
  800e14:	00 00 00 
  800e17:	48 89 c7             	mov    %rax,%rdi
  800e1a:	b8 00 00 00 00       	mov    $0x0,%eax
  800e1f:	49 b8 d2 10 80 00 00 	movabs $0x8010d2,%r8
  800e26:	00 00 00 
  800e29:	41 ff d0             	callq  *%r8
			break;
  800e2c:	e9 92 02 00 00       	jmpq   8010c3 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800e31:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e34:	83 f8 30             	cmp    $0x30,%eax
  800e37:	73 17                	jae    800e50 <vprintfmt+0x296>
  800e39:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e3d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e40:	89 c0                	mov    %eax,%eax
  800e42:	48 01 d0             	add    %rdx,%rax
  800e45:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e48:	83 c2 08             	add    $0x8,%edx
  800e4b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e4e:	eb 0f                	jmp    800e5f <vprintfmt+0x2a5>
  800e50:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e54:	48 89 d0             	mov    %rdx,%rax
  800e57:	48 83 c2 08          	add    $0x8,%rdx
  800e5b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e5f:	4c 8b 20             	mov    (%rax),%r12
  800e62:	4d 85 e4             	test   %r12,%r12
  800e65:	75 0a                	jne    800e71 <vprintfmt+0x2b7>
				p = "(null)";
  800e67:	49 bc 6d 42 80 00 00 	movabs $0x80426d,%r12
  800e6e:	00 00 00 
			if (width > 0 && padc != '-')
  800e71:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e75:	7e 3f                	jle    800eb6 <vprintfmt+0x2fc>
  800e77:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800e7b:	74 39                	je     800eb6 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e7d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800e80:	48 98                	cltq   
  800e82:	48 89 c6             	mov    %rax,%rsi
  800e85:	4c 89 e7             	mov    %r12,%rdi
  800e88:	48 b8 7e 13 80 00 00 	movabs $0x80137e,%rax
  800e8f:	00 00 00 
  800e92:	ff d0                	callq  *%rax
  800e94:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800e97:	eb 17                	jmp    800eb0 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800e99:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800e9d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ea1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ea5:	48 89 ce             	mov    %rcx,%rsi
  800ea8:	89 d7                	mov    %edx,%edi
  800eaa:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800eac:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800eb0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800eb4:	7f e3                	jg     800e99 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800eb6:	eb 37                	jmp    800eef <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800eb8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800ebc:	74 1e                	je     800edc <vprintfmt+0x322>
  800ebe:	83 fb 1f             	cmp    $0x1f,%ebx
  800ec1:	7e 05                	jle    800ec8 <vprintfmt+0x30e>
  800ec3:	83 fb 7e             	cmp    $0x7e,%ebx
  800ec6:	7e 14                	jle    800edc <vprintfmt+0x322>
					putch('?', putdat);
  800ec8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ecc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ed0:	48 89 d6             	mov    %rdx,%rsi
  800ed3:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800ed8:	ff d0                	callq  *%rax
  800eda:	eb 0f                	jmp    800eeb <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800edc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ee0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ee4:	48 89 d6             	mov    %rdx,%rsi
  800ee7:	89 df                	mov    %ebx,%edi
  800ee9:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800eeb:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800eef:	4c 89 e0             	mov    %r12,%rax
  800ef2:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800ef6:	0f b6 00             	movzbl (%rax),%eax
  800ef9:	0f be d8             	movsbl %al,%ebx
  800efc:	85 db                	test   %ebx,%ebx
  800efe:	74 10                	je     800f10 <vprintfmt+0x356>
  800f00:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f04:	78 b2                	js     800eb8 <vprintfmt+0x2fe>
  800f06:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800f0a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f0e:	79 a8                	jns    800eb8 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f10:	eb 16                	jmp    800f28 <vprintfmt+0x36e>
				putch(' ', putdat);
  800f12:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f16:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f1a:	48 89 d6             	mov    %rdx,%rsi
  800f1d:	bf 20 00 00 00       	mov    $0x20,%edi
  800f22:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f24:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f28:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f2c:	7f e4                	jg     800f12 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800f2e:	e9 90 01 00 00       	jmpq   8010c3 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800f33:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f37:	be 03 00 00 00       	mov    $0x3,%esi
  800f3c:	48 89 c7             	mov    %rax,%rdi
  800f3f:	48 b8 aa 0a 80 00 00 	movabs $0x800aaa,%rax
  800f46:	00 00 00 
  800f49:	ff d0                	callq  *%rax
  800f4b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800f4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f53:	48 85 c0             	test   %rax,%rax
  800f56:	79 1d                	jns    800f75 <vprintfmt+0x3bb>
				putch('-', putdat);
  800f58:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f5c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f60:	48 89 d6             	mov    %rdx,%rsi
  800f63:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800f68:	ff d0                	callq  *%rax
				num = -(long long) num;
  800f6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f6e:	48 f7 d8             	neg    %rax
  800f71:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800f75:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f7c:	e9 d5 00 00 00       	jmpq   801056 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800f81:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f85:	be 03 00 00 00       	mov    $0x3,%esi
  800f8a:	48 89 c7             	mov    %rax,%rdi
  800f8d:	48 b8 9a 09 80 00 00 	movabs $0x80099a,%rax
  800f94:	00 00 00 
  800f97:	ff d0                	callq  *%rax
  800f99:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800f9d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800fa4:	e9 ad 00 00 00       	jmpq   801056 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  800fa9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fad:	be 03 00 00 00       	mov    $0x3,%esi
  800fb2:	48 89 c7             	mov    %rax,%rdi
  800fb5:	48 b8 9a 09 80 00 00 	movabs $0x80099a,%rax
  800fbc:	00 00 00 
  800fbf:	ff d0                	callq  *%rax
  800fc1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  800fc5:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  800fcc:	e9 85 00 00 00       	jmpq   801056 <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  800fd1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fd5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fd9:	48 89 d6             	mov    %rdx,%rsi
  800fdc:	bf 30 00 00 00       	mov    $0x30,%edi
  800fe1:	ff d0                	callq  *%rax
			putch('x', putdat);
  800fe3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fe7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800feb:	48 89 d6             	mov    %rdx,%rsi
  800fee:	bf 78 00 00 00       	mov    $0x78,%edi
  800ff3:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800ff5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ff8:	83 f8 30             	cmp    $0x30,%eax
  800ffb:	73 17                	jae    801014 <vprintfmt+0x45a>
  800ffd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801001:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801004:	89 c0                	mov    %eax,%eax
  801006:	48 01 d0             	add    %rdx,%rax
  801009:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80100c:	83 c2 08             	add    $0x8,%edx
  80100f:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801012:	eb 0f                	jmp    801023 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  801014:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801018:	48 89 d0             	mov    %rdx,%rax
  80101b:	48 83 c2 08          	add    $0x8,%rdx
  80101f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801023:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801026:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80102a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801031:	eb 23                	jmp    801056 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801033:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801037:	be 03 00 00 00       	mov    $0x3,%esi
  80103c:	48 89 c7             	mov    %rax,%rdi
  80103f:	48 b8 9a 09 80 00 00 	movabs $0x80099a,%rax
  801046:	00 00 00 
  801049:	ff d0                	callq  *%rax
  80104b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  80104f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801056:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80105b:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80105e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801061:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801065:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801069:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80106d:	45 89 c1             	mov    %r8d,%r9d
  801070:	41 89 f8             	mov    %edi,%r8d
  801073:	48 89 c7             	mov    %rax,%rdi
  801076:	48 b8 df 08 80 00 00 	movabs $0x8008df,%rax
  80107d:	00 00 00 
  801080:	ff d0                	callq  *%rax
			break;
  801082:	eb 3f                	jmp    8010c3 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  801084:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801088:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80108c:	48 89 d6             	mov    %rdx,%rsi
  80108f:	89 df                	mov    %ebx,%edi
  801091:	ff d0                	callq  *%rax
			break;
  801093:	eb 2e                	jmp    8010c3 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801095:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801099:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80109d:	48 89 d6             	mov    %rdx,%rsi
  8010a0:	bf 25 00 00 00       	mov    $0x25,%edi
  8010a5:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010a7:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8010ac:	eb 05                	jmp    8010b3 <vprintfmt+0x4f9>
  8010ae:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8010b3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8010b7:	48 83 e8 01          	sub    $0x1,%rax
  8010bb:	0f b6 00             	movzbl (%rax),%eax
  8010be:	3c 25                	cmp    $0x25,%al
  8010c0:	75 ec                	jne    8010ae <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  8010c2:	90                   	nop
		}
	}
  8010c3:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010c4:	e9 43 fb ff ff       	jmpq   800c0c <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8010c9:	48 83 c4 60          	add    $0x60,%rsp
  8010cd:	5b                   	pop    %rbx
  8010ce:	41 5c                	pop    %r12
  8010d0:	5d                   	pop    %rbp
  8010d1:	c3                   	retq   

00000000008010d2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010d2:	55                   	push   %rbp
  8010d3:	48 89 e5             	mov    %rsp,%rbp
  8010d6:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8010dd:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8010e4:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8010eb:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010f2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010f9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801100:	84 c0                	test   %al,%al
  801102:	74 20                	je     801124 <printfmt+0x52>
  801104:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801108:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80110c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801110:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801114:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801118:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80111c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801120:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801124:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80112b:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801132:	00 00 00 
  801135:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80113c:	00 00 00 
  80113f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801143:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80114a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801151:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801158:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80115f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801166:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80116d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801174:	48 89 c7             	mov    %rax,%rdi
  801177:	48 b8 ba 0b 80 00 00 	movabs $0x800bba,%rax
  80117e:	00 00 00 
  801181:	ff d0                	callq  *%rax
	va_end(ap);
}
  801183:	c9                   	leaveq 
  801184:	c3                   	retq   

0000000000801185 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801185:	55                   	push   %rbp
  801186:	48 89 e5             	mov    %rsp,%rbp
  801189:	48 83 ec 10          	sub    $0x10,%rsp
  80118d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801190:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801194:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801198:	8b 40 10             	mov    0x10(%rax),%eax
  80119b:	8d 50 01             	lea    0x1(%rax),%edx
  80119e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011a2:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8011a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011a9:	48 8b 10             	mov    (%rax),%rdx
  8011ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011b0:	48 8b 40 08          	mov    0x8(%rax),%rax
  8011b4:	48 39 c2             	cmp    %rax,%rdx
  8011b7:	73 17                	jae    8011d0 <sprintputch+0x4b>
		*b->buf++ = ch;
  8011b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011bd:	48 8b 00             	mov    (%rax),%rax
  8011c0:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8011c4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8011c8:	48 89 0a             	mov    %rcx,(%rdx)
  8011cb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8011ce:	88 10                	mov    %dl,(%rax)
}
  8011d0:	c9                   	leaveq 
  8011d1:	c3                   	retq   

00000000008011d2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011d2:	55                   	push   %rbp
  8011d3:	48 89 e5             	mov    %rsp,%rbp
  8011d6:	48 83 ec 50          	sub    $0x50,%rsp
  8011da:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8011de:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8011e1:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8011e5:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8011e9:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8011ed:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8011f1:	48 8b 0a             	mov    (%rdx),%rcx
  8011f4:	48 89 08             	mov    %rcx,(%rax)
  8011f7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8011fb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8011ff:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801203:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801207:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80120b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80120f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801212:	48 98                	cltq   
  801214:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801218:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80121c:	48 01 d0             	add    %rdx,%rax
  80121f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801223:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80122a:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80122f:	74 06                	je     801237 <vsnprintf+0x65>
  801231:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801235:	7f 07                	jg     80123e <vsnprintf+0x6c>
		return -E_INVAL;
  801237:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80123c:	eb 2f                	jmp    80126d <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80123e:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801242:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801246:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80124a:	48 89 c6             	mov    %rax,%rsi
  80124d:	48 bf 85 11 80 00 00 	movabs $0x801185,%rdi
  801254:	00 00 00 
  801257:	48 b8 ba 0b 80 00 00 	movabs $0x800bba,%rax
  80125e:	00 00 00 
  801261:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801263:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801267:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80126a:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80126d:	c9                   	leaveq 
  80126e:	c3                   	retq   

000000000080126f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80126f:	55                   	push   %rbp
  801270:	48 89 e5             	mov    %rsp,%rbp
  801273:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80127a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801281:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801287:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80128e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801295:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80129c:	84 c0                	test   %al,%al
  80129e:	74 20                	je     8012c0 <snprintf+0x51>
  8012a0:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8012a4:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8012a8:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8012ac:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8012b0:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8012b4:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8012b8:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8012bc:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8012c0:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8012c7:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8012ce:	00 00 00 
  8012d1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8012d8:	00 00 00 
  8012db:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8012df:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8012e6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8012ed:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8012f4:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8012fb:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801302:	48 8b 0a             	mov    (%rdx),%rcx
  801305:	48 89 08             	mov    %rcx,(%rax)
  801308:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80130c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801310:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801314:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801318:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80131f:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801326:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80132c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801333:	48 89 c7             	mov    %rax,%rdi
  801336:	48 b8 d2 11 80 00 00 	movabs $0x8011d2,%rax
  80133d:	00 00 00 
  801340:	ff d0                	callq  *%rax
  801342:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801348:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80134e:	c9                   	leaveq 
  80134f:	c3                   	retq   

0000000000801350 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801350:	55                   	push   %rbp
  801351:	48 89 e5             	mov    %rsp,%rbp
  801354:	48 83 ec 18          	sub    $0x18,%rsp
  801358:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80135c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801363:	eb 09                	jmp    80136e <strlen+0x1e>
		n++;
  801365:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801369:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80136e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801372:	0f b6 00             	movzbl (%rax),%eax
  801375:	84 c0                	test   %al,%al
  801377:	75 ec                	jne    801365 <strlen+0x15>
		n++;
	return n;
  801379:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80137c:	c9                   	leaveq 
  80137d:	c3                   	retq   

000000000080137e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80137e:	55                   	push   %rbp
  80137f:	48 89 e5             	mov    %rsp,%rbp
  801382:	48 83 ec 20          	sub    $0x20,%rsp
  801386:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80138a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80138e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801395:	eb 0e                	jmp    8013a5 <strnlen+0x27>
		n++;
  801397:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80139b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013a0:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8013a5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8013aa:	74 0b                	je     8013b7 <strnlen+0x39>
  8013ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013b0:	0f b6 00             	movzbl (%rax),%eax
  8013b3:	84 c0                	test   %al,%al
  8013b5:	75 e0                	jne    801397 <strnlen+0x19>
		n++;
	return n;
  8013b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013ba:	c9                   	leaveq 
  8013bb:	c3                   	retq   

00000000008013bc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013bc:	55                   	push   %rbp
  8013bd:	48 89 e5             	mov    %rsp,%rbp
  8013c0:	48 83 ec 20          	sub    $0x20,%rsp
  8013c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013c8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8013cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8013d4:	90                   	nop
  8013d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013dd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013e1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013e5:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8013e9:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8013ed:	0f b6 12             	movzbl (%rdx),%edx
  8013f0:	88 10                	mov    %dl,(%rax)
  8013f2:	0f b6 00             	movzbl (%rax),%eax
  8013f5:	84 c0                	test   %al,%al
  8013f7:	75 dc                	jne    8013d5 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8013f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013fd:	c9                   	leaveq 
  8013fe:	c3                   	retq   

00000000008013ff <strcat>:

char *
strcat(char *dst, const char *src)
{
  8013ff:	55                   	push   %rbp
  801400:	48 89 e5             	mov    %rsp,%rbp
  801403:	48 83 ec 20          	sub    $0x20,%rsp
  801407:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80140b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80140f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801413:	48 89 c7             	mov    %rax,%rdi
  801416:	48 b8 50 13 80 00 00 	movabs $0x801350,%rax
  80141d:	00 00 00 
  801420:	ff d0                	callq  *%rax
  801422:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801425:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801428:	48 63 d0             	movslq %eax,%rdx
  80142b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80142f:	48 01 c2             	add    %rax,%rdx
  801432:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801436:	48 89 c6             	mov    %rax,%rsi
  801439:	48 89 d7             	mov    %rdx,%rdi
  80143c:	48 b8 bc 13 80 00 00 	movabs $0x8013bc,%rax
  801443:	00 00 00 
  801446:	ff d0                	callq  *%rax
	return dst;
  801448:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80144c:	c9                   	leaveq 
  80144d:	c3                   	retq   

000000000080144e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80144e:	55                   	push   %rbp
  80144f:	48 89 e5             	mov    %rsp,%rbp
  801452:	48 83 ec 28          	sub    $0x28,%rsp
  801456:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80145a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80145e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801462:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801466:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80146a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801471:	00 
  801472:	eb 2a                	jmp    80149e <strncpy+0x50>
		*dst++ = *src;
  801474:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801478:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80147c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801480:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801484:	0f b6 12             	movzbl (%rdx),%edx
  801487:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801489:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80148d:	0f b6 00             	movzbl (%rax),%eax
  801490:	84 c0                	test   %al,%al
  801492:	74 05                	je     801499 <strncpy+0x4b>
			src++;
  801494:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801499:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80149e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8014a6:	72 cc                	jb     801474 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014ac:	c9                   	leaveq 
  8014ad:	c3                   	retq   

00000000008014ae <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8014ae:	55                   	push   %rbp
  8014af:	48 89 e5             	mov    %rsp,%rbp
  8014b2:	48 83 ec 28          	sub    $0x28,%rsp
  8014b6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014ba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014be:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8014c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8014ca:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8014cf:	74 3d                	je     80150e <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8014d1:	eb 1d                	jmp    8014f0 <strlcpy+0x42>
			*dst++ = *src++;
  8014d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014db:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8014df:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8014e3:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8014e7:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8014eb:	0f b6 12             	movzbl (%rdx),%edx
  8014ee:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014f0:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8014f5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8014fa:	74 0b                	je     801507 <strlcpy+0x59>
  8014fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801500:	0f b6 00             	movzbl (%rax),%eax
  801503:	84 c0                	test   %al,%al
  801505:	75 cc                	jne    8014d3 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801507:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80150b:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80150e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801512:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801516:	48 29 c2             	sub    %rax,%rdx
  801519:	48 89 d0             	mov    %rdx,%rax
}
  80151c:	c9                   	leaveq 
  80151d:	c3                   	retq   

000000000080151e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80151e:	55                   	push   %rbp
  80151f:	48 89 e5             	mov    %rsp,%rbp
  801522:	48 83 ec 10          	sub    $0x10,%rsp
  801526:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80152a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80152e:	eb 0a                	jmp    80153a <strcmp+0x1c>
		p++, q++;
  801530:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801535:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80153a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80153e:	0f b6 00             	movzbl (%rax),%eax
  801541:	84 c0                	test   %al,%al
  801543:	74 12                	je     801557 <strcmp+0x39>
  801545:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801549:	0f b6 10             	movzbl (%rax),%edx
  80154c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801550:	0f b6 00             	movzbl (%rax),%eax
  801553:	38 c2                	cmp    %al,%dl
  801555:	74 d9                	je     801530 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801557:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155b:	0f b6 00             	movzbl (%rax),%eax
  80155e:	0f b6 d0             	movzbl %al,%edx
  801561:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801565:	0f b6 00             	movzbl (%rax),%eax
  801568:	0f b6 c0             	movzbl %al,%eax
  80156b:	29 c2                	sub    %eax,%edx
  80156d:	89 d0                	mov    %edx,%eax
}
  80156f:	c9                   	leaveq 
  801570:	c3                   	retq   

0000000000801571 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801571:	55                   	push   %rbp
  801572:	48 89 e5             	mov    %rsp,%rbp
  801575:	48 83 ec 18          	sub    $0x18,%rsp
  801579:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80157d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801581:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801585:	eb 0f                	jmp    801596 <strncmp+0x25>
		n--, p++, q++;
  801587:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80158c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801591:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801596:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80159b:	74 1d                	je     8015ba <strncmp+0x49>
  80159d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a1:	0f b6 00             	movzbl (%rax),%eax
  8015a4:	84 c0                	test   %al,%al
  8015a6:	74 12                	je     8015ba <strncmp+0x49>
  8015a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ac:	0f b6 10             	movzbl (%rax),%edx
  8015af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b3:	0f b6 00             	movzbl (%rax),%eax
  8015b6:	38 c2                	cmp    %al,%dl
  8015b8:	74 cd                	je     801587 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8015ba:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015bf:	75 07                	jne    8015c8 <strncmp+0x57>
		return 0;
  8015c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c6:	eb 18                	jmp    8015e0 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8015c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015cc:	0f b6 00             	movzbl (%rax),%eax
  8015cf:	0f b6 d0             	movzbl %al,%edx
  8015d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015d6:	0f b6 00             	movzbl (%rax),%eax
  8015d9:	0f b6 c0             	movzbl %al,%eax
  8015dc:	29 c2                	sub    %eax,%edx
  8015de:	89 d0                	mov    %edx,%eax
}
  8015e0:	c9                   	leaveq 
  8015e1:	c3                   	retq   

00000000008015e2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015e2:	55                   	push   %rbp
  8015e3:	48 89 e5             	mov    %rsp,%rbp
  8015e6:	48 83 ec 0c          	sub    $0xc,%rsp
  8015ea:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015ee:	89 f0                	mov    %esi,%eax
  8015f0:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8015f3:	eb 17                	jmp    80160c <strchr+0x2a>
		if (*s == c)
  8015f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f9:	0f b6 00             	movzbl (%rax),%eax
  8015fc:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8015ff:	75 06                	jne    801607 <strchr+0x25>
			return (char *) s;
  801601:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801605:	eb 15                	jmp    80161c <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801607:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80160c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801610:	0f b6 00             	movzbl (%rax),%eax
  801613:	84 c0                	test   %al,%al
  801615:	75 de                	jne    8015f5 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801617:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80161c:	c9                   	leaveq 
  80161d:	c3                   	retq   

000000000080161e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80161e:	55                   	push   %rbp
  80161f:	48 89 e5             	mov    %rsp,%rbp
  801622:	48 83 ec 0c          	sub    $0xc,%rsp
  801626:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80162a:	89 f0                	mov    %esi,%eax
  80162c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80162f:	eb 13                	jmp    801644 <strfind+0x26>
		if (*s == c)
  801631:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801635:	0f b6 00             	movzbl (%rax),%eax
  801638:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80163b:	75 02                	jne    80163f <strfind+0x21>
			break;
  80163d:	eb 10                	jmp    80164f <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80163f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801644:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801648:	0f b6 00             	movzbl (%rax),%eax
  80164b:	84 c0                	test   %al,%al
  80164d:	75 e2                	jne    801631 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80164f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801653:	c9                   	leaveq 
  801654:	c3                   	retq   

0000000000801655 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801655:	55                   	push   %rbp
  801656:	48 89 e5             	mov    %rsp,%rbp
  801659:	48 83 ec 18          	sub    $0x18,%rsp
  80165d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801661:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801664:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801668:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80166d:	75 06                	jne    801675 <memset+0x20>
		return v;
  80166f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801673:	eb 69                	jmp    8016de <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801675:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801679:	83 e0 03             	and    $0x3,%eax
  80167c:	48 85 c0             	test   %rax,%rax
  80167f:	75 48                	jne    8016c9 <memset+0x74>
  801681:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801685:	83 e0 03             	and    $0x3,%eax
  801688:	48 85 c0             	test   %rax,%rax
  80168b:	75 3c                	jne    8016c9 <memset+0x74>
		c &= 0xFF;
  80168d:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801694:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801697:	c1 e0 18             	shl    $0x18,%eax
  80169a:	89 c2                	mov    %eax,%edx
  80169c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80169f:	c1 e0 10             	shl    $0x10,%eax
  8016a2:	09 c2                	or     %eax,%edx
  8016a4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016a7:	c1 e0 08             	shl    $0x8,%eax
  8016aa:	09 d0                	or     %edx,%eax
  8016ac:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8016af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016b3:	48 c1 e8 02          	shr    $0x2,%rax
  8016b7:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8016ba:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016be:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016c1:	48 89 d7             	mov    %rdx,%rdi
  8016c4:	fc                   	cld    
  8016c5:	f3 ab                	rep stos %eax,%es:(%rdi)
  8016c7:	eb 11                	jmp    8016da <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8016c9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016cd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016d0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8016d4:	48 89 d7             	mov    %rdx,%rdi
  8016d7:	fc                   	cld    
  8016d8:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8016da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016de:	c9                   	leaveq 
  8016df:	c3                   	retq   

00000000008016e0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8016e0:	55                   	push   %rbp
  8016e1:	48 89 e5             	mov    %rsp,%rbp
  8016e4:	48 83 ec 28          	sub    $0x28,%rsp
  8016e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8016f0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8016f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8016fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801700:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801704:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801708:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80170c:	0f 83 88 00 00 00    	jae    80179a <memmove+0xba>
  801712:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801716:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80171a:	48 01 d0             	add    %rdx,%rax
  80171d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801721:	76 77                	jbe    80179a <memmove+0xba>
		s += n;
  801723:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801727:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80172b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172f:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801733:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801737:	83 e0 03             	and    $0x3,%eax
  80173a:	48 85 c0             	test   %rax,%rax
  80173d:	75 3b                	jne    80177a <memmove+0x9a>
  80173f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801743:	83 e0 03             	and    $0x3,%eax
  801746:	48 85 c0             	test   %rax,%rax
  801749:	75 2f                	jne    80177a <memmove+0x9a>
  80174b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174f:	83 e0 03             	and    $0x3,%eax
  801752:	48 85 c0             	test   %rax,%rax
  801755:	75 23                	jne    80177a <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801757:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80175b:	48 83 e8 04          	sub    $0x4,%rax
  80175f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801763:	48 83 ea 04          	sub    $0x4,%rdx
  801767:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80176b:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80176f:	48 89 c7             	mov    %rax,%rdi
  801772:	48 89 d6             	mov    %rdx,%rsi
  801775:	fd                   	std    
  801776:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801778:	eb 1d                	jmp    801797 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80177a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80177e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801782:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801786:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80178a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178e:	48 89 d7             	mov    %rdx,%rdi
  801791:	48 89 c1             	mov    %rax,%rcx
  801794:	fd                   	std    
  801795:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801797:	fc                   	cld    
  801798:	eb 57                	jmp    8017f1 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80179a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80179e:	83 e0 03             	and    $0x3,%eax
  8017a1:	48 85 c0             	test   %rax,%rax
  8017a4:	75 36                	jne    8017dc <memmove+0xfc>
  8017a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017aa:	83 e0 03             	and    $0x3,%eax
  8017ad:	48 85 c0             	test   %rax,%rax
  8017b0:	75 2a                	jne    8017dc <memmove+0xfc>
  8017b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b6:	83 e0 03             	and    $0x3,%eax
  8017b9:	48 85 c0             	test   %rax,%rax
  8017bc:	75 1e                	jne    8017dc <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8017be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c2:	48 c1 e8 02          	shr    $0x2,%rax
  8017c6:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8017c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017cd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017d1:	48 89 c7             	mov    %rax,%rdi
  8017d4:	48 89 d6             	mov    %rdx,%rsi
  8017d7:	fc                   	cld    
  8017d8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8017da:	eb 15                	jmp    8017f1 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8017dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017e0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017e4:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8017e8:	48 89 c7             	mov    %rax,%rdi
  8017eb:	48 89 d6             	mov    %rdx,%rsi
  8017ee:	fc                   	cld    
  8017ef:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8017f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017f5:	c9                   	leaveq 
  8017f6:	c3                   	retq   

00000000008017f7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8017f7:	55                   	push   %rbp
  8017f8:	48 89 e5             	mov    %rsp,%rbp
  8017fb:	48 83 ec 18          	sub    $0x18,%rsp
  8017ff:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801803:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801807:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80180b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80180f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801813:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801817:	48 89 ce             	mov    %rcx,%rsi
  80181a:	48 89 c7             	mov    %rax,%rdi
  80181d:	48 b8 e0 16 80 00 00 	movabs $0x8016e0,%rax
  801824:	00 00 00 
  801827:	ff d0                	callq  *%rax
}
  801829:	c9                   	leaveq 
  80182a:	c3                   	retq   

000000000080182b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80182b:	55                   	push   %rbp
  80182c:	48 89 e5             	mov    %rsp,%rbp
  80182f:	48 83 ec 28          	sub    $0x28,%rsp
  801833:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801837:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80183b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80183f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801843:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801847:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80184b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80184f:	eb 36                	jmp    801887 <memcmp+0x5c>
		if (*s1 != *s2)
  801851:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801855:	0f b6 10             	movzbl (%rax),%edx
  801858:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80185c:	0f b6 00             	movzbl (%rax),%eax
  80185f:	38 c2                	cmp    %al,%dl
  801861:	74 1a                	je     80187d <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801863:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801867:	0f b6 00             	movzbl (%rax),%eax
  80186a:	0f b6 d0             	movzbl %al,%edx
  80186d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801871:	0f b6 00             	movzbl (%rax),%eax
  801874:	0f b6 c0             	movzbl %al,%eax
  801877:	29 c2                	sub    %eax,%edx
  801879:	89 d0                	mov    %edx,%eax
  80187b:	eb 20                	jmp    80189d <memcmp+0x72>
		s1++, s2++;
  80187d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801882:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801887:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80188b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80188f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801893:	48 85 c0             	test   %rax,%rax
  801896:	75 b9                	jne    801851 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801898:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80189d:	c9                   	leaveq 
  80189e:	c3                   	retq   

000000000080189f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80189f:	55                   	push   %rbp
  8018a0:	48 89 e5             	mov    %rsp,%rbp
  8018a3:	48 83 ec 28          	sub    $0x28,%rsp
  8018a7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018ab:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8018ae:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8018b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018ba:	48 01 d0             	add    %rdx,%rax
  8018bd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8018c1:	eb 15                	jmp    8018d8 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018c7:	0f b6 10             	movzbl (%rax),%edx
  8018ca:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8018cd:	38 c2                	cmp    %al,%dl
  8018cf:	75 02                	jne    8018d3 <memfind+0x34>
			break;
  8018d1:	eb 0f                	jmp    8018e2 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018d3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8018d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018dc:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8018e0:	72 e1                	jb     8018c3 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8018e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018e6:	c9                   	leaveq 
  8018e7:	c3                   	retq   

00000000008018e8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018e8:	55                   	push   %rbp
  8018e9:	48 89 e5             	mov    %rsp,%rbp
  8018ec:	48 83 ec 34          	sub    $0x34,%rsp
  8018f0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018f4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8018f8:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8018fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801902:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801909:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80190a:	eb 05                	jmp    801911 <strtol+0x29>
		s++;
  80190c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801911:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801915:	0f b6 00             	movzbl (%rax),%eax
  801918:	3c 20                	cmp    $0x20,%al
  80191a:	74 f0                	je     80190c <strtol+0x24>
  80191c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801920:	0f b6 00             	movzbl (%rax),%eax
  801923:	3c 09                	cmp    $0x9,%al
  801925:	74 e5                	je     80190c <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801927:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80192b:	0f b6 00             	movzbl (%rax),%eax
  80192e:	3c 2b                	cmp    $0x2b,%al
  801930:	75 07                	jne    801939 <strtol+0x51>
		s++;
  801932:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801937:	eb 17                	jmp    801950 <strtol+0x68>
	else if (*s == '-')
  801939:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80193d:	0f b6 00             	movzbl (%rax),%eax
  801940:	3c 2d                	cmp    $0x2d,%al
  801942:	75 0c                	jne    801950 <strtol+0x68>
		s++, neg = 1;
  801944:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801949:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801950:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801954:	74 06                	je     80195c <strtol+0x74>
  801956:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80195a:	75 28                	jne    801984 <strtol+0x9c>
  80195c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801960:	0f b6 00             	movzbl (%rax),%eax
  801963:	3c 30                	cmp    $0x30,%al
  801965:	75 1d                	jne    801984 <strtol+0x9c>
  801967:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80196b:	48 83 c0 01          	add    $0x1,%rax
  80196f:	0f b6 00             	movzbl (%rax),%eax
  801972:	3c 78                	cmp    $0x78,%al
  801974:	75 0e                	jne    801984 <strtol+0x9c>
		s += 2, base = 16;
  801976:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80197b:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801982:	eb 2c                	jmp    8019b0 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801984:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801988:	75 19                	jne    8019a3 <strtol+0xbb>
  80198a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80198e:	0f b6 00             	movzbl (%rax),%eax
  801991:	3c 30                	cmp    $0x30,%al
  801993:	75 0e                	jne    8019a3 <strtol+0xbb>
		s++, base = 8;
  801995:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80199a:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8019a1:	eb 0d                	jmp    8019b0 <strtol+0xc8>
	else if (base == 0)
  8019a3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019a7:	75 07                	jne    8019b0 <strtol+0xc8>
		base = 10;
  8019a9:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019b4:	0f b6 00             	movzbl (%rax),%eax
  8019b7:	3c 2f                	cmp    $0x2f,%al
  8019b9:	7e 1d                	jle    8019d8 <strtol+0xf0>
  8019bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019bf:	0f b6 00             	movzbl (%rax),%eax
  8019c2:	3c 39                	cmp    $0x39,%al
  8019c4:	7f 12                	jg     8019d8 <strtol+0xf0>
			dig = *s - '0';
  8019c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ca:	0f b6 00             	movzbl (%rax),%eax
  8019cd:	0f be c0             	movsbl %al,%eax
  8019d0:	83 e8 30             	sub    $0x30,%eax
  8019d3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8019d6:	eb 4e                	jmp    801a26 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8019d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019dc:	0f b6 00             	movzbl (%rax),%eax
  8019df:	3c 60                	cmp    $0x60,%al
  8019e1:	7e 1d                	jle    801a00 <strtol+0x118>
  8019e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e7:	0f b6 00             	movzbl (%rax),%eax
  8019ea:	3c 7a                	cmp    $0x7a,%al
  8019ec:	7f 12                	jg     801a00 <strtol+0x118>
			dig = *s - 'a' + 10;
  8019ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019f2:	0f b6 00             	movzbl (%rax),%eax
  8019f5:	0f be c0             	movsbl %al,%eax
  8019f8:	83 e8 57             	sub    $0x57,%eax
  8019fb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8019fe:	eb 26                	jmp    801a26 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801a00:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a04:	0f b6 00             	movzbl (%rax),%eax
  801a07:	3c 40                	cmp    $0x40,%al
  801a09:	7e 48                	jle    801a53 <strtol+0x16b>
  801a0b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a0f:	0f b6 00             	movzbl (%rax),%eax
  801a12:	3c 5a                	cmp    $0x5a,%al
  801a14:	7f 3d                	jg     801a53 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801a16:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a1a:	0f b6 00             	movzbl (%rax),%eax
  801a1d:	0f be c0             	movsbl %al,%eax
  801a20:	83 e8 37             	sub    $0x37,%eax
  801a23:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801a26:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a29:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801a2c:	7c 02                	jl     801a30 <strtol+0x148>
			break;
  801a2e:	eb 23                	jmp    801a53 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801a30:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a35:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801a38:	48 98                	cltq   
  801a3a:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801a3f:	48 89 c2             	mov    %rax,%rdx
  801a42:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a45:	48 98                	cltq   
  801a47:	48 01 d0             	add    %rdx,%rax
  801a4a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801a4e:	e9 5d ff ff ff       	jmpq   8019b0 <strtol+0xc8>

	if (endptr)
  801a53:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801a58:	74 0b                	je     801a65 <strtol+0x17d>
		*endptr = (char *) s;
  801a5a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a5e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a62:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801a65:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a69:	74 09                	je     801a74 <strtol+0x18c>
  801a6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a6f:	48 f7 d8             	neg    %rax
  801a72:	eb 04                	jmp    801a78 <strtol+0x190>
  801a74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801a78:	c9                   	leaveq 
  801a79:	c3                   	retq   

0000000000801a7a <strstr>:

char * strstr(const char *in, const char *str)
{
  801a7a:	55                   	push   %rbp
  801a7b:	48 89 e5             	mov    %rsp,%rbp
  801a7e:	48 83 ec 30          	sub    $0x30,%rsp
  801a82:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801a86:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801a8a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a8e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a92:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801a96:	0f b6 00             	movzbl (%rax),%eax
  801a99:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801a9c:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801aa0:	75 06                	jne    801aa8 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801aa2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa6:	eb 6b                	jmp    801b13 <strstr+0x99>

	len = strlen(str);
  801aa8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801aac:	48 89 c7             	mov    %rax,%rdi
  801aaf:	48 b8 50 13 80 00 00 	movabs $0x801350,%rax
  801ab6:	00 00 00 
  801ab9:	ff d0                	callq  *%rax
  801abb:	48 98                	cltq   
  801abd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801ac1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ac5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801ac9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801acd:	0f b6 00             	movzbl (%rax),%eax
  801ad0:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801ad3:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801ad7:	75 07                	jne    801ae0 <strstr+0x66>
				return (char *) 0;
  801ad9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ade:	eb 33                	jmp    801b13 <strstr+0x99>
		} while (sc != c);
  801ae0:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801ae4:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801ae7:	75 d8                	jne    801ac1 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801ae9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aed:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801af1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801af5:	48 89 ce             	mov    %rcx,%rsi
  801af8:	48 89 c7             	mov    %rax,%rdi
  801afb:	48 b8 71 15 80 00 00 	movabs $0x801571,%rax
  801b02:	00 00 00 
  801b05:	ff d0                	callq  *%rax
  801b07:	85 c0                	test   %eax,%eax
  801b09:	75 b6                	jne    801ac1 <strstr+0x47>

	return (char *) (in - 1);
  801b0b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b0f:	48 83 e8 01          	sub    $0x1,%rax
}
  801b13:	c9                   	leaveq 
  801b14:	c3                   	retq   

0000000000801b15 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801b15:	55                   	push   %rbp
  801b16:	48 89 e5             	mov    %rsp,%rbp
  801b19:	53                   	push   %rbx
  801b1a:	48 83 ec 48          	sub    $0x48,%rsp
  801b1e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801b21:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801b24:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b28:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801b2c:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801b30:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  801b34:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b37:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801b3b:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801b3f:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801b43:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801b47:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801b4b:	4c 89 c3             	mov    %r8,%rbx
  801b4e:	cd 30                	int    $0x30
  801b50:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  801b54:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b58:	74 3e                	je     801b98 <syscall+0x83>
  801b5a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b5f:	7e 37                	jle    801b98 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801b61:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b65:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b68:	49 89 d0             	mov    %rdx,%r8
  801b6b:	89 c1                	mov    %eax,%ecx
  801b6d:	48 ba 28 45 80 00 00 	movabs $0x804528,%rdx
  801b74:	00 00 00 
  801b77:	be 4a 00 00 00       	mov    $0x4a,%esi
  801b7c:	48 bf 45 45 80 00 00 	movabs $0x804545,%rdi
  801b83:	00 00 00 
  801b86:	b8 00 00 00 00       	mov    $0x0,%eax
  801b8b:	49 b9 ce 05 80 00 00 	movabs $0x8005ce,%r9
  801b92:	00 00 00 
  801b95:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  801b98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801b9c:	48 83 c4 48          	add    $0x48,%rsp
  801ba0:	5b                   	pop    %rbx
  801ba1:	5d                   	pop    %rbp
  801ba2:	c3                   	retq   

0000000000801ba3 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801ba3:	55                   	push   %rbp
  801ba4:	48 89 e5             	mov    %rsp,%rbp
  801ba7:	48 83 ec 20          	sub    $0x20,%rsp
  801bab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801baf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801bb3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bb7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bbb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bc2:	00 
  801bc3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bc9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bcf:	48 89 d1             	mov    %rdx,%rcx
  801bd2:	48 89 c2             	mov    %rax,%rdx
  801bd5:	be 00 00 00 00       	mov    $0x0,%esi
  801bda:	bf 00 00 00 00       	mov    $0x0,%edi
  801bdf:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  801be6:	00 00 00 
  801be9:	ff d0                	callq  *%rax
}
  801beb:	c9                   	leaveq 
  801bec:	c3                   	retq   

0000000000801bed <sys_cgetc>:

int
sys_cgetc(void)
{
  801bed:	55                   	push   %rbp
  801bee:	48 89 e5             	mov    %rsp,%rbp
  801bf1:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801bf5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bfc:	00 
  801bfd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c03:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c09:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c0e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c13:	be 00 00 00 00       	mov    $0x0,%esi
  801c18:	bf 01 00 00 00       	mov    $0x1,%edi
  801c1d:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  801c24:	00 00 00 
  801c27:	ff d0                	callq  *%rax
}
  801c29:	c9                   	leaveq 
  801c2a:	c3                   	retq   

0000000000801c2b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801c2b:	55                   	push   %rbp
  801c2c:	48 89 e5             	mov    %rsp,%rbp
  801c2f:	48 83 ec 10          	sub    $0x10,%rsp
  801c33:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801c36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c39:	48 98                	cltq   
  801c3b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c42:	00 
  801c43:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c49:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c4f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c54:	48 89 c2             	mov    %rax,%rdx
  801c57:	be 01 00 00 00       	mov    $0x1,%esi
  801c5c:	bf 03 00 00 00       	mov    $0x3,%edi
  801c61:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  801c68:	00 00 00 
  801c6b:	ff d0                	callq  *%rax
}
  801c6d:	c9                   	leaveq 
  801c6e:	c3                   	retq   

0000000000801c6f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801c6f:	55                   	push   %rbp
  801c70:	48 89 e5             	mov    %rsp,%rbp
  801c73:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801c77:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c7e:	00 
  801c7f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c85:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c8b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c90:	ba 00 00 00 00       	mov    $0x0,%edx
  801c95:	be 00 00 00 00       	mov    $0x0,%esi
  801c9a:	bf 02 00 00 00       	mov    $0x2,%edi
  801c9f:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  801ca6:	00 00 00 
  801ca9:	ff d0                	callq  *%rax
}
  801cab:	c9                   	leaveq 
  801cac:	c3                   	retq   

0000000000801cad <sys_yield>:

void
sys_yield(void)
{
  801cad:	55                   	push   %rbp
  801cae:	48 89 e5             	mov    %rsp,%rbp
  801cb1:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801cb5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cbc:	00 
  801cbd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cc3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cc9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cce:	ba 00 00 00 00       	mov    $0x0,%edx
  801cd3:	be 00 00 00 00       	mov    $0x0,%esi
  801cd8:	bf 0b 00 00 00       	mov    $0xb,%edi
  801cdd:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  801ce4:	00 00 00 
  801ce7:	ff d0                	callq  *%rax
}
  801ce9:	c9                   	leaveq 
  801cea:	c3                   	retq   

0000000000801ceb <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801ceb:	55                   	push   %rbp
  801cec:	48 89 e5             	mov    %rsp,%rbp
  801cef:	48 83 ec 20          	sub    $0x20,%rsp
  801cf3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cf6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cfa:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801cfd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d00:	48 63 c8             	movslq %eax,%rcx
  801d03:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d0a:	48 98                	cltq   
  801d0c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d13:	00 
  801d14:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d1a:	49 89 c8             	mov    %rcx,%r8
  801d1d:	48 89 d1             	mov    %rdx,%rcx
  801d20:	48 89 c2             	mov    %rax,%rdx
  801d23:	be 01 00 00 00       	mov    $0x1,%esi
  801d28:	bf 04 00 00 00       	mov    $0x4,%edi
  801d2d:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  801d34:	00 00 00 
  801d37:	ff d0                	callq  *%rax
}
  801d39:	c9                   	leaveq 
  801d3a:	c3                   	retq   

0000000000801d3b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801d3b:	55                   	push   %rbp
  801d3c:	48 89 e5             	mov    %rsp,%rbp
  801d3f:	48 83 ec 30          	sub    $0x30,%rsp
  801d43:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d46:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d4a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d4d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d51:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801d55:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d58:	48 63 c8             	movslq %eax,%rcx
  801d5b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d5f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d62:	48 63 f0             	movslq %eax,%rsi
  801d65:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d6c:	48 98                	cltq   
  801d6e:	48 89 0c 24          	mov    %rcx,(%rsp)
  801d72:	49 89 f9             	mov    %rdi,%r9
  801d75:	49 89 f0             	mov    %rsi,%r8
  801d78:	48 89 d1             	mov    %rdx,%rcx
  801d7b:	48 89 c2             	mov    %rax,%rdx
  801d7e:	be 01 00 00 00       	mov    $0x1,%esi
  801d83:	bf 05 00 00 00       	mov    $0x5,%edi
  801d88:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  801d8f:	00 00 00 
  801d92:	ff d0                	callq  *%rax
}
  801d94:	c9                   	leaveq 
  801d95:	c3                   	retq   

0000000000801d96 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801d96:	55                   	push   %rbp
  801d97:	48 89 e5             	mov    %rsp,%rbp
  801d9a:	48 83 ec 20          	sub    $0x20,%rsp
  801d9e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801da1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801da5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801da9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dac:	48 98                	cltq   
  801dae:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801db5:	00 
  801db6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dbc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dc2:	48 89 d1             	mov    %rdx,%rcx
  801dc5:	48 89 c2             	mov    %rax,%rdx
  801dc8:	be 01 00 00 00       	mov    $0x1,%esi
  801dcd:	bf 06 00 00 00       	mov    $0x6,%edi
  801dd2:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  801dd9:	00 00 00 
  801ddc:	ff d0                	callq  *%rax
}
  801dde:	c9                   	leaveq 
  801ddf:	c3                   	retq   

0000000000801de0 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801de0:	55                   	push   %rbp
  801de1:	48 89 e5             	mov    %rsp,%rbp
  801de4:	48 83 ec 10          	sub    $0x10,%rsp
  801de8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801deb:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801dee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801df1:	48 63 d0             	movslq %eax,%rdx
  801df4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801df7:	48 98                	cltq   
  801df9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e00:	00 
  801e01:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e07:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e0d:	48 89 d1             	mov    %rdx,%rcx
  801e10:	48 89 c2             	mov    %rax,%rdx
  801e13:	be 01 00 00 00       	mov    $0x1,%esi
  801e18:	bf 08 00 00 00       	mov    $0x8,%edi
  801e1d:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  801e24:	00 00 00 
  801e27:	ff d0                	callq  *%rax
}
  801e29:	c9                   	leaveq 
  801e2a:	c3                   	retq   

0000000000801e2b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801e2b:	55                   	push   %rbp
  801e2c:	48 89 e5             	mov    %rsp,%rbp
  801e2f:	48 83 ec 20          	sub    $0x20,%rsp
  801e33:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e36:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801e3a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e41:	48 98                	cltq   
  801e43:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e4a:	00 
  801e4b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e51:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e57:	48 89 d1             	mov    %rdx,%rcx
  801e5a:	48 89 c2             	mov    %rax,%rdx
  801e5d:	be 01 00 00 00       	mov    $0x1,%esi
  801e62:	bf 09 00 00 00       	mov    $0x9,%edi
  801e67:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  801e6e:	00 00 00 
  801e71:	ff d0                	callq  *%rax
}
  801e73:	c9                   	leaveq 
  801e74:	c3                   	retq   

0000000000801e75 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801e75:	55                   	push   %rbp
  801e76:	48 89 e5             	mov    %rsp,%rbp
  801e79:	48 83 ec 20          	sub    $0x20,%rsp
  801e7d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e80:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801e84:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e8b:	48 98                	cltq   
  801e8d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e94:	00 
  801e95:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e9b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ea1:	48 89 d1             	mov    %rdx,%rcx
  801ea4:	48 89 c2             	mov    %rax,%rdx
  801ea7:	be 01 00 00 00       	mov    $0x1,%esi
  801eac:	bf 0a 00 00 00       	mov    $0xa,%edi
  801eb1:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  801eb8:	00 00 00 
  801ebb:	ff d0                	callq  *%rax
}
  801ebd:	c9                   	leaveq 
  801ebe:	c3                   	retq   

0000000000801ebf <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801ebf:	55                   	push   %rbp
  801ec0:	48 89 e5             	mov    %rsp,%rbp
  801ec3:	48 83 ec 20          	sub    $0x20,%rsp
  801ec7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801eca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ece:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801ed2:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801ed5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ed8:	48 63 f0             	movslq %eax,%rsi
  801edb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801edf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ee2:	48 98                	cltq   
  801ee4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ee8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801eef:	00 
  801ef0:	49 89 f1             	mov    %rsi,%r9
  801ef3:	49 89 c8             	mov    %rcx,%r8
  801ef6:	48 89 d1             	mov    %rdx,%rcx
  801ef9:	48 89 c2             	mov    %rax,%rdx
  801efc:	be 00 00 00 00       	mov    $0x0,%esi
  801f01:	bf 0c 00 00 00       	mov    $0xc,%edi
  801f06:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  801f0d:	00 00 00 
  801f10:	ff d0                	callq  *%rax
}
  801f12:	c9                   	leaveq 
  801f13:	c3                   	retq   

0000000000801f14 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801f14:	55                   	push   %rbp
  801f15:	48 89 e5             	mov    %rsp,%rbp
  801f18:	48 83 ec 10          	sub    $0x10,%rsp
  801f1c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801f20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f24:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f2b:	00 
  801f2c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f32:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f38:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f3d:	48 89 c2             	mov    %rax,%rdx
  801f40:	be 01 00 00 00       	mov    $0x1,%esi
  801f45:	bf 0d 00 00 00       	mov    $0xd,%edi
  801f4a:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  801f51:	00 00 00 
  801f54:	ff d0                	callq  *%rax
}
  801f56:	c9                   	leaveq 
  801f57:	c3                   	retq   

0000000000801f58 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801f58:	55                   	push   %rbp
  801f59:	48 89 e5             	mov    %rsp,%rbp
  801f5c:	48 83 ec 18          	sub    $0x18,%rsp
  801f60:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f64:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f68:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  801f6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f70:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f74:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  801f77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f7b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f7f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801f83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f87:	8b 00                	mov    (%rax),%eax
  801f89:	83 f8 01             	cmp    $0x1,%eax
  801f8c:	7e 13                	jle    801fa1 <argstart+0x49>
  801f8e:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  801f93:	74 0c                	je     801fa1 <argstart+0x49>
  801f95:	48 b8 53 45 80 00 00 	movabs $0x804553,%rax
  801f9c:	00 00 00 
  801f9f:	eb 05                	jmp    801fa6 <argstart+0x4e>
  801fa1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801faa:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  801fae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fb2:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801fb9:	00 
}
  801fba:	c9                   	leaveq 
  801fbb:	c3                   	retq   

0000000000801fbc <argnext>:

int
argnext(struct Argstate *args)
{
  801fbc:	55                   	push   %rbp
  801fbd:	48 89 e5             	mov    %rsp,%rbp
  801fc0:	48 83 ec 20          	sub    $0x20,%rsp
  801fc4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  801fc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fcc:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801fd3:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801fd4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fd8:	48 8b 40 10          	mov    0x10(%rax),%rax
  801fdc:	48 85 c0             	test   %rax,%rax
  801fdf:	75 0a                	jne    801feb <argnext+0x2f>
		return -1;
  801fe1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801fe6:	e9 25 01 00 00       	jmpq   802110 <argnext+0x154>

	if (!*args->curarg) {
  801feb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fef:	48 8b 40 10          	mov    0x10(%rax),%rax
  801ff3:	0f b6 00             	movzbl (%rax),%eax
  801ff6:	84 c0                	test   %al,%al
  801ff8:	0f 85 d7 00 00 00    	jne    8020d5 <argnext+0x119>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801ffe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802002:	48 8b 00             	mov    (%rax),%rax
  802005:	8b 00                	mov    (%rax),%eax
  802007:	83 f8 01             	cmp    $0x1,%eax
  80200a:	0f 84 ef 00 00 00    	je     8020ff <argnext+0x143>
		    || args->argv[1][0] != '-'
  802010:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802014:	48 8b 40 08          	mov    0x8(%rax),%rax
  802018:	48 83 c0 08          	add    $0x8,%rax
  80201c:	48 8b 00             	mov    (%rax),%rax
  80201f:	0f b6 00             	movzbl (%rax),%eax
  802022:	3c 2d                	cmp    $0x2d,%al
  802024:	0f 85 d5 00 00 00    	jne    8020ff <argnext+0x143>
		    || args->argv[1][1] == '\0')
  80202a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80202e:	48 8b 40 08          	mov    0x8(%rax),%rax
  802032:	48 83 c0 08          	add    $0x8,%rax
  802036:	48 8b 00             	mov    (%rax),%rax
  802039:	48 83 c0 01          	add    $0x1,%rax
  80203d:	0f b6 00             	movzbl (%rax),%eax
  802040:	84 c0                	test   %al,%al
  802042:	0f 84 b7 00 00 00    	je     8020ff <argnext+0x143>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  802048:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80204c:	48 8b 40 08          	mov    0x8(%rax),%rax
  802050:	48 83 c0 08          	add    $0x8,%rax
  802054:	48 8b 00             	mov    (%rax),%rax
  802057:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80205b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80205f:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  802063:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802067:	48 8b 00             	mov    (%rax),%rax
  80206a:	8b 00                	mov    (%rax),%eax
  80206c:	83 e8 01             	sub    $0x1,%eax
  80206f:	48 98                	cltq   
  802071:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802078:	00 
  802079:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80207d:	48 8b 40 08          	mov    0x8(%rax),%rax
  802081:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802085:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802089:	48 8b 40 08          	mov    0x8(%rax),%rax
  80208d:	48 83 c0 08          	add    $0x8,%rax
  802091:	48 89 ce             	mov    %rcx,%rsi
  802094:	48 89 c7             	mov    %rax,%rdi
  802097:	48 b8 e0 16 80 00 00 	movabs $0x8016e0,%rax
  80209e:	00 00 00 
  8020a1:	ff d0                	callq  *%rax
		(*args->argc)--;
  8020a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020a7:	48 8b 00             	mov    (%rax),%rax
  8020aa:	8b 10                	mov    (%rax),%edx
  8020ac:	83 ea 01             	sub    $0x1,%edx
  8020af:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8020b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020b5:	48 8b 40 10          	mov    0x10(%rax),%rax
  8020b9:	0f b6 00             	movzbl (%rax),%eax
  8020bc:	3c 2d                	cmp    $0x2d,%al
  8020be:	75 15                	jne    8020d5 <argnext+0x119>
  8020c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020c4:	48 8b 40 10          	mov    0x10(%rax),%rax
  8020c8:	48 83 c0 01          	add    $0x1,%rax
  8020cc:	0f b6 00             	movzbl (%rax),%eax
  8020cf:	84 c0                	test   %al,%al
  8020d1:	75 02                	jne    8020d5 <argnext+0x119>
			goto endofargs;
  8020d3:	eb 2a                	jmp    8020ff <argnext+0x143>
	}

	arg = (unsigned char) *args->curarg;
  8020d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020d9:	48 8b 40 10          	mov    0x10(%rax),%rax
  8020dd:	0f b6 00             	movzbl (%rax),%eax
  8020e0:	0f b6 c0             	movzbl %al,%eax
  8020e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  8020e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020ea:	48 8b 40 10          	mov    0x10(%rax),%rax
  8020ee:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8020f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020f6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  8020fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020fd:	eb 11                	jmp    802110 <argnext+0x154>

endofargs:
	args->curarg = 0;
  8020ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802103:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  80210a:	00 
	return -1;
  80210b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  802110:	c9                   	leaveq 
  802111:	c3                   	retq   

0000000000802112 <argvalue>:

char *
argvalue(struct Argstate *args)
{
  802112:	55                   	push   %rbp
  802113:	48 89 e5             	mov    %rsp,%rbp
  802116:	48 83 ec 10          	sub    $0x10,%rsp
  80211a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  80211e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802122:	48 8b 40 18          	mov    0x18(%rax),%rax
  802126:	48 85 c0             	test   %rax,%rax
  802129:	74 0a                	je     802135 <argvalue+0x23>
  80212b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80212f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802133:	eb 13                	jmp    802148 <argvalue+0x36>
  802135:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802139:	48 89 c7             	mov    %rax,%rdi
  80213c:	48 b8 4a 21 80 00 00 	movabs $0x80214a,%rax
  802143:	00 00 00 
  802146:	ff d0                	callq  *%rax
}
  802148:	c9                   	leaveq 
  802149:	c3                   	retq   

000000000080214a <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  80214a:	55                   	push   %rbp
  80214b:	48 89 e5             	mov    %rsp,%rbp
  80214e:	53                   	push   %rbx
  80214f:	48 83 ec 18          	sub    $0x18,%rsp
  802153:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (!args->curarg)
  802157:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80215b:	48 8b 40 10          	mov    0x10(%rax),%rax
  80215f:	48 85 c0             	test   %rax,%rax
  802162:	75 0a                	jne    80216e <argnextvalue+0x24>
		return 0;
  802164:	b8 00 00 00 00       	mov    $0x0,%eax
  802169:	e9 c8 00 00 00       	jmpq   802236 <argnextvalue+0xec>
	if (*args->curarg) {
  80216e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802172:	48 8b 40 10          	mov    0x10(%rax),%rax
  802176:	0f b6 00             	movzbl (%rax),%eax
  802179:	84 c0                	test   %al,%al
  80217b:	74 27                	je     8021a4 <argnextvalue+0x5a>
		args->argvalue = args->curarg;
  80217d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802181:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802185:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802189:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  80218d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802191:	48 bb 53 45 80 00 00 	movabs $0x804553,%rbx
  802198:	00 00 00 
  80219b:	48 89 58 10          	mov    %rbx,0x10(%rax)
  80219f:	e9 8a 00 00 00       	jmpq   80222e <argnextvalue+0xe4>
	} else if (*args->argc > 1) {
  8021a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a8:	48 8b 00             	mov    (%rax),%rax
  8021ab:	8b 00                	mov    (%rax),%eax
  8021ad:	83 f8 01             	cmp    $0x1,%eax
  8021b0:	7e 64                	jle    802216 <argnextvalue+0xcc>
		args->argvalue = args->argv[1];
  8021b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021b6:	48 8b 40 08          	mov    0x8(%rax),%rax
  8021ba:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8021be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c2:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8021c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ca:	48 8b 00             	mov    (%rax),%rax
  8021cd:	8b 00                	mov    (%rax),%eax
  8021cf:	83 e8 01             	sub    $0x1,%eax
  8021d2:	48 98                	cltq   
  8021d4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8021db:	00 
  8021dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021e0:	48 8b 40 08          	mov    0x8(%rax),%rax
  8021e4:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8021e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ec:	48 8b 40 08          	mov    0x8(%rax),%rax
  8021f0:	48 83 c0 08          	add    $0x8,%rax
  8021f4:	48 89 ce             	mov    %rcx,%rsi
  8021f7:	48 89 c7             	mov    %rax,%rdi
  8021fa:	48 b8 e0 16 80 00 00 	movabs $0x8016e0,%rax
  802201:	00 00 00 
  802204:	ff d0                	callq  *%rax
		(*args->argc)--;
  802206:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80220a:	48 8b 00             	mov    (%rax),%rax
  80220d:	8b 10                	mov    (%rax),%edx
  80220f:	83 ea 01             	sub    $0x1,%edx
  802212:	89 10                	mov    %edx,(%rax)
  802214:	eb 18                	jmp    80222e <argnextvalue+0xe4>
	} else {
		args->argvalue = 0;
  802216:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80221a:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  802221:	00 
		args->curarg = 0;
  802222:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802226:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  80222d:	00 
	}
	return (char*) args->argvalue;
  80222e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802232:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  802236:	48 83 c4 18          	add    $0x18,%rsp
  80223a:	5b                   	pop    %rbx
  80223b:	5d                   	pop    %rbp
  80223c:	c3                   	retq   

000000000080223d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80223d:	55                   	push   %rbp
  80223e:	48 89 e5             	mov    %rsp,%rbp
  802241:	48 83 ec 08          	sub    $0x8,%rsp
  802245:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802249:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80224d:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802254:	ff ff ff 
  802257:	48 01 d0             	add    %rdx,%rax
  80225a:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80225e:	c9                   	leaveq 
  80225f:	c3                   	retq   

0000000000802260 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802260:	55                   	push   %rbp
  802261:	48 89 e5             	mov    %rsp,%rbp
  802264:	48 83 ec 08          	sub    $0x8,%rsp
  802268:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80226c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802270:	48 89 c7             	mov    %rax,%rdi
  802273:	48 b8 3d 22 80 00 00 	movabs $0x80223d,%rax
  80227a:	00 00 00 
  80227d:	ff d0                	callq  *%rax
  80227f:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802285:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802289:	c9                   	leaveq 
  80228a:	c3                   	retq   

000000000080228b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80228b:	55                   	push   %rbp
  80228c:	48 89 e5             	mov    %rsp,%rbp
  80228f:	48 83 ec 18          	sub    $0x18,%rsp
  802293:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802297:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80229e:	eb 6b                	jmp    80230b <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8022a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022a3:	48 98                	cltq   
  8022a5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8022ab:	48 c1 e0 0c          	shl    $0xc,%rax
  8022af:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8022b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022b7:	48 c1 e8 15          	shr    $0x15,%rax
  8022bb:	48 89 c2             	mov    %rax,%rdx
  8022be:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022c5:	01 00 00 
  8022c8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022cc:	83 e0 01             	and    $0x1,%eax
  8022cf:	48 85 c0             	test   %rax,%rax
  8022d2:	74 21                	je     8022f5 <fd_alloc+0x6a>
  8022d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022d8:	48 c1 e8 0c          	shr    $0xc,%rax
  8022dc:	48 89 c2             	mov    %rax,%rdx
  8022df:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022e6:	01 00 00 
  8022e9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022ed:	83 e0 01             	and    $0x1,%eax
  8022f0:	48 85 c0             	test   %rax,%rax
  8022f3:	75 12                	jne    802307 <fd_alloc+0x7c>
			*fd_store = fd;
  8022f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022f9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022fd:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802300:	b8 00 00 00 00       	mov    $0x0,%eax
  802305:	eb 1a                	jmp    802321 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802307:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80230b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80230f:	7e 8f                	jle    8022a0 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802311:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802315:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80231c:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802321:	c9                   	leaveq 
  802322:	c3                   	retq   

0000000000802323 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802323:	55                   	push   %rbp
  802324:	48 89 e5             	mov    %rsp,%rbp
  802327:	48 83 ec 20          	sub    $0x20,%rsp
  80232b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80232e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802332:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802336:	78 06                	js     80233e <fd_lookup+0x1b>
  802338:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80233c:	7e 07                	jle    802345 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80233e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802343:	eb 6c                	jmp    8023b1 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802345:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802348:	48 98                	cltq   
  80234a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802350:	48 c1 e0 0c          	shl    $0xc,%rax
  802354:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802358:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80235c:	48 c1 e8 15          	shr    $0x15,%rax
  802360:	48 89 c2             	mov    %rax,%rdx
  802363:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80236a:	01 00 00 
  80236d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802371:	83 e0 01             	and    $0x1,%eax
  802374:	48 85 c0             	test   %rax,%rax
  802377:	74 21                	je     80239a <fd_lookup+0x77>
  802379:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80237d:	48 c1 e8 0c          	shr    $0xc,%rax
  802381:	48 89 c2             	mov    %rax,%rdx
  802384:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80238b:	01 00 00 
  80238e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802392:	83 e0 01             	and    $0x1,%eax
  802395:	48 85 c0             	test   %rax,%rax
  802398:	75 07                	jne    8023a1 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80239a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80239f:	eb 10                	jmp    8023b1 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8023a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023a5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8023a9:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8023ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023b1:	c9                   	leaveq 
  8023b2:	c3                   	retq   

00000000008023b3 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8023b3:	55                   	push   %rbp
  8023b4:	48 89 e5             	mov    %rsp,%rbp
  8023b7:	48 83 ec 30          	sub    $0x30,%rsp
  8023bb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8023bf:	89 f0                	mov    %esi,%eax
  8023c1:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8023c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023c8:	48 89 c7             	mov    %rax,%rdi
  8023cb:	48 b8 3d 22 80 00 00 	movabs $0x80223d,%rax
  8023d2:	00 00 00 
  8023d5:	ff d0                	callq  *%rax
  8023d7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023db:	48 89 d6             	mov    %rdx,%rsi
  8023de:	89 c7                	mov    %eax,%edi
  8023e0:	48 b8 23 23 80 00 00 	movabs $0x802323,%rax
  8023e7:	00 00 00 
  8023ea:	ff d0                	callq  *%rax
  8023ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023f3:	78 0a                	js     8023ff <fd_close+0x4c>
	    || fd != fd2)
  8023f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023f9:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8023fd:	74 12                	je     802411 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8023ff:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802403:	74 05                	je     80240a <fd_close+0x57>
  802405:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802408:	eb 05                	jmp    80240f <fd_close+0x5c>
  80240a:	b8 00 00 00 00       	mov    $0x0,%eax
  80240f:	eb 69                	jmp    80247a <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802411:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802415:	8b 00                	mov    (%rax),%eax
  802417:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80241b:	48 89 d6             	mov    %rdx,%rsi
  80241e:	89 c7                	mov    %eax,%edi
  802420:	48 b8 7c 24 80 00 00 	movabs $0x80247c,%rax
  802427:	00 00 00 
  80242a:	ff d0                	callq  *%rax
  80242c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80242f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802433:	78 2a                	js     80245f <fd_close+0xac>
		if (dev->dev_close)
  802435:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802439:	48 8b 40 20          	mov    0x20(%rax),%rax
  80243d:	48 85 c0             	test   %rax,%rax
  802440:	74 16                	je     802458 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802442:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802446:	48 8b 40 20          	mov    0x20(%rax),%rax
  80244a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80244e:	48 89 d7             	mov    %rdx,%rdi
  802451:	ff d0                	callq  *%rax
  802453:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802456:	eb 07                	jmp    80245f <fd_close+0xac>
		else
			r = 0;
  802458:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80245f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802463:	48 89 c6             	mov    %rax,%rsi
  802466:	bf 00 00 00 00       	mov    $0x0,%edi
  80246b:	48 b8 96 1d 80 00 00 	movabs $0x801d96,%rax
  802472:	00 00 00 
  802475:	ff d0                	callq  *%rax
	return r;
  802477:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80247a:	c9                   	leaveq 
  80247b:	c3                   	retq   

000000000080247c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80247c:	55                   	push   %rbp
  80247d:	48 89 e5             	mov    %rsp,%rbp
  802480:	48 83 ec 20          	sub    $0x20,%rsp
  802484:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802487:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80248b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802492:	eb 41                	jmp    8024d5 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802494:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80249b:	00 00 00 
  80249e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024a1:	48 63 d2             	movslq %edx,%rdx
  8024a4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024a8:	8b 00                	mov    (%rax),%eax
  8024aa:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8024ad:	75 22                	jne    8024d1 <dev_lookup+0x55>
			*dev = devtab[i];
  8024af:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8024b6:	00 00 00 
  8024b9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024bc:	48 63 d2             	movslq %edx,%rdx
  8024bf:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8024c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024c7:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8024ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8024cf:	eb 60                	jmp    802531 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8024d1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8024d5:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8024dc:	00 00 00 
  8024df:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024e2:	48 63 d2             	movslq %edx,%rdx
  8024e5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024e9:	48 85 c0             	test   %rax,%rax
  8024ec:	75 a6                	jne    802494 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8024ee:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8024f5:	00 00 00 
  8024f8:	48 8b 00             	mov    (%rax),%rax
  8024fb:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802501:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802504:	89 c6                	mov    %eax,%esi
  802506:	48 bf 58 45 80 00 00 	movabs $0x804558,%rdi
  80250d:	00 00 00 
  802510:	b8 00 00 00 00       	mov    $0x0,%eax
  802515:	48 b9 07 08 80 00 00 	movabs $0x800807,%rcx
  80251c:	00 00 00 
  80251f:	ff d1                	callq  *%rcx
	*dev = 0;
  802521:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802525:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80252c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802531:	c9                   	leaveq 
  802532:	c3                   	retq   

0000000000802533 <close>:

int
close(int fdnum)
{
  802533:	55                   	push   %rbp
  802534:	48 89 e5             	mov    %rsp,%rbp
  802537:	48 83 ec 20          	sub    $0x20,%rsp
  80253b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80253e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802542:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802545:	48 89 d6             	mov    %rdx,%rsi
  802548:	89 c7                	mov    %eax,%edi
  80254a:	48 b8 23 23 80 00 00 	movabs $0x802323,%rax
  802551:	00 00 00 
  802554:	ff d0                	callq  *%rax
  802556:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802559:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80255d:	79 05                	jns    802564 <close+0x31>
		return r;
  80255f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802562:	eb 18                	jmp    80257c <close+0x49>
	else
		return fd_close(fd, 1);
  802564:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802568:	be 01 00 00 00       	mov    $0x1,%esi
  80256d:	48 89 c7             	mov    %rax,%rdi
  802570:	48 b8 b3 23 80 00 00 	movabs $0x8023b3,%rax
  802577:	00 00 00 
  80257a:	ff d0                	callq  *%rax
}
  80257c:	c9                   	leaveq 
  80257d:	c3                   	retq   

000000000080257e <close_all>:

void
close_all(void)
{
  80257e:	55                   	push   %rbp
  80257f:	48 89 e5             	mov    %rsp,%rbp
  802582:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802586:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80258d:	eb 15                	jmp    8025a4 <close_all+0x26>
		close(i);
  80258f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802592:	89 c7                	mov    %eax,%edi
  802594:	48 b8 33 25 80 00 00 	movabs $0x802533,%rax
  80259b:	00 00 00 
  80259e:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8025a0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025a4:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8025a8:	7e e5                	jle    80258f <close_all+0x11>
		close(i);
}
  8025aa:	c9                   	leaveq 
  8025ab:	c3                   	retq   

00000000008025ac <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8025ac:	55                   	push   %rbp
  8025ad:	48 89 e5             	mov    %rsp,%rbp
  8025b0:	48 83 ec 40          	sub    $0x40,%rsp
  8025b4:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8025b7:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8025ba:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8025be:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8025c1:	48 89 d6             	mov    %rdx,%rsi
  8025c4:	89 c7                	mov    %eax,%edi
  8025c6:	48 b8 23 23 80 00 00 	movabs $0x802323,%rax
  8025cd:	00 00 00 
  8025d0:	ff d0                	callq  *%rax
  8025d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025d9:	79 08                	jns    8025e3 <dup+0x37>
		return r;
  8025db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025de:	e9 70 01 00 00       	jmpq   802753 <dup+0x1a7>
	close(newfdnum);
  8025e3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8025e6:	89 c7                	mov    %eax,%edi
  8025e8:	48 b8 33 25 80 00 00 	movabs $0x802533,%rax
  8025ef:	00 00 00 
  8025f2:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8025f4:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8025f7:	48 98                	cltq   
  8025f9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8025ff:	48 c1 e0 0c          	shl    $0xc,%rax
  802603:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802607:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80260b:	48 89 c7             	mov    %rax,%rdi
  80260e:	48 b8 60 22 80 00 00 	movabs $0x802260,%rax
  802615:	00 00 00 
  802618:	ff d0                	callq  *%rax
  80261a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80261e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802622:	48 89 c7             	mov    %rax,%rdi
  802625:	48 b8 60 22 80 00 00 	movabs $0x802260,%rax
  80262c:	00 00 00 
  80262f:	ff d0                	callq  *%rax
  802631:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802635:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802639:	48 c1 e8 15          	shr    $0x15,%rax
  80263d:	48 89 c2             	mov    %rax,%rdx
  802640:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802647:	01 00 00 
  80264a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80264e:	83 e0 01             	and    $0x1,%eax
  802651:	48 85 c0             	test   %rax,%rax
  802654:	74 73                	je     8026c9 <dup+0x11d>
  802656:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80265a:	48 c1 e8 0c          	shr    $0xc,%rax
  80265e:	48 89 c2             	mov    %rax,%rdx
  802661:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802668:	01 00 00 
  80266b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80266f:	83 e0 01             	and    $0x1,%eax
  802672:	48 85 c0             	test   %rax,%rax
  802675:	74 52                	je     8026c9 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802677:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80267b:	48 c1 e8 0c          	shr    $0xc,%rax
  80267f:	48 89 c2             	mov    %rax,%rdx
  802682:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802689:	01 00 00 
  80268c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802690:	25 07 0e 00 00       	and    $0xe07,%eax
  802695:	89 c1                	mov    %eax,%ecx
  802697:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80269b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80269f:	41 89 c8             	mov    %ecx,%r8d
  8026a2:	48 89 d1             	mov    %rdx,%rcx
  8026a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8026aa:	48 89 c6             	mov    %rax,%rsi
  8026ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8026b2:	48 b8 3b 1d 80 00 00 	movabs $0x801d3b,%rax
  8026b9:	00 00 00 
  8026bc:	ff d0                	callq  *%rax
  8026be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026c5:	79 02                	jns    8026c9 <dup+0x11d>
			goto err;
  8026c7:	eb 57                	jmp    802720 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8026c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026cd:	48 c1 e8 0c          	shr    $0xc,%rax
  8026d1:	48 89 c2             	mov    %rax,%rdx
  8026d4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026db:	01 00 00 
  8026de:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026e2:	25 07 0e 00 00       	and    $0xe07,%eax
  8026e7:	89 c1                	mov    %eax,%ecx
  8026e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026ed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026f1:	41 89 c8             	mov    %ecx,%r8d
  8026f4:	48 89 d1             	mov    %rdx,%rcx
  8026f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8026fc:	48 89 c6             	mov    %rax,%rsi
  8026ff:	bf 00 00 00 00       	mov    $0x0,%edi
  802704:	48 b8 3b 1d 80 00 00 	movabs $0x801d3b,%rax
  80270b:	00 00 00 
  80270e:	ff d0                	callq  *%rax
  802710:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802713:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802717:	79 02                	jns    80271b <dup+0x16f>
		goto err;
  802719:	eb 05                	jmp    802720 <dup+0x174>

	return newfdnum;
  80271b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80271e:	eb 33                	jmp    802753 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802720:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802724:	48 89 c6             	mov    %rax,%rsi
  802727:	bf 00 00 00 00       	mov    $0x0,%edi
  80272c:	48 b8 96 1d 80 00 00 	movabs $0x801d96,%rax
  802733:	00 00 00 
  802736:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802738:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80273c:	48 89 c6             	mov    %rax,%rsi
  80273f:	bf 00 00 00 00       	mov    $0x0,%edi
  802744:	48 b8 96 1d 80 00 00 	movabs $0x801d96,%rax
  80274b:	00 00 00 
  80274e:	ff d0                	callq  *%rax
	return r;
  802750:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802753:	c9                   	leaveq 
  802754:	c3                   	retq   

0000000000802755 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802755:	55                   	push   %rbp
  802756:	48 89 e5             	mov    %rsp,%rbp
  802759:	48 83 ec 40          	sub    $0x40,%rsp
  80275d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802760:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802764:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802768:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80276c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80276f:	48 89 d6             	mov    %rdx,%rsi
  802772:	89 c7                	mov    %eax,%edi
  802774:	48 b8 23 23 80 00 00 	movabs $0x802323,%rax
  80277b:	00 00 00 
  80277e:	ff d0                	callq  *%rax
  802780:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802783:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802787:	78 24                	js     8027ad <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802789:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80278d:	8b 00                	mov    (%rax),%eax
  80278f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802793:	48 89 d6             	mov    %rdx,%rsi
  802796:	89 c7                	mov    %eax,%edi
  802798:	48 b8 7c 24 80 00 00 	movabs $0x80247c,%rax
  80279f:	00 00 00 
  8027a2:	ff d0                	callq  *%rax
  8027a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027ab:	79 05                	jns    8027b2 <read+0x5d>
		return r;
  8027ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027b0:	eb 76                	jmp    802828 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8027b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b6:	8b 40 08             	mov    0x8(%rax),%eax
  8027b9:	83 e0 03             	and    $0x3,%eax
  8027bc:	83 f8 01             	cmp    $0x1,%eax
  8027bf:	75 3a                	jne    8027fb <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8027c1:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8027c8:	00 00 00 
  8027cb:	48 8b 00             	mov    (%rax),%rax
  8027ce:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027d4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8027d7:	89 c6                	mov    %eax,%esi
  8027d9:	48 bf 77 45 80 00 00 	movabs $0x804577,%rdi
  8027e0:	00 00 00 
  8027e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e8:	48 b9 07 08 80 00 00 	movabs $0x800807,%rcx
  8027ef:	00 00 00 
  8027f2:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8027f4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027f9:	eb 2d                	jmp    802828 <read+0xd3>
	}
	if (!dev->dev_read)
  8027fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027ff:	48 8b 40 10          	mov    0x10(%rax),%rax
  802803:	48 85 c0             	test   %rax,%rax
  802806:	75 07                	jne    80280f <read+0xba>
		return -E_NOT_SUPP;
  802808:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80280d:	eb 19                	jmp    802828 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80280f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802813:	48 8b 40 10          	mov    0x10(%rax),%rax
  802817:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80281b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80281f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802823:	48 89 cf             	mov    %rcx,%rdi
  802826:	ff d0                	callq  *%rax
}
  802828:	c9                   	leaveq 
  802829:	c3                   	retq   

000000000080282a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80282a:	55                   	push   %rbp
  80282b:	48 89 e5             	mov    %rsp,%rbp
  80282e:	48 83 ec 30          	sub    $0x30,%rsp
  802832:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802835:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802839:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80283d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802844:	eb 49                	jmp    80288f <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802846:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802849:	48 98                	cltq   
  80284b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80284f:	48 29 c2             	sub    %rax,%rdx
  802852:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802855:	48 63 c8             	movslq %eax,%rcx
  802858:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80285c:	48 01 c1             	add    %rax,%rcx
  80285f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802862:	48 89 ce             	mov    %rcx,%rsi
  802865:	89 c7                	mov    %eax,%edi
  802867:	48 b8 55 27 80 00 00 	movabs $0x802755,%rax
  80286e:	00 00 00 
  802871:	ff d0                	callq  *%rax
  802873:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802876:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80287a:	79 05                	jns    802881 <readn+0x57>
			return m;
  80287c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80287f:	eb 1c                	jmp    80289d <readn+0x73>
		if (m == 0)
  802881:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802885:	75 02                	jne    802889 <readn+0x5f>
			break;
  802887:	eb 11                	jmp    80289a <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802889:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80288c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80288f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802892:	48 98                	cltq   
  802894:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802898:	72 ac                	jb     802846 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80289a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80289d:	c9                   	leaveq 
  80289e:	c3                   	retq   

000000000080289f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80289f:	55                   	push   %rbp
  8028a0:	48 89 e5             	mov    %rsp,%rbp
  8028a3:	48 83 ec 40          	sub    $0x40,%rsp
  8028a7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028aa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8028ae:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8028b2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028b6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028b9:	48 89 d6             	mov    %rdx,%rsi
  8028bc:	89 c7                	mov    %eax,%edi
  8028be:	48 b8 23 23 80 00 00 	movabs $0x802323,%rax
  8028c5:	00 00 00 
  8028c8:	ff d0                	callq  *%rax
  8028ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028d1:	78 24                	js     8028f7 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8028d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028d7:	8b 00                	mov    (%rax),%eax
  8028d9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028dd:	48 89 d6             	mov    %rdx,%rsi
  8028e0:	89 c7                	mov    %eax,%edi
  8028e2:	48 b8 7c 24 80 00 00 	movabs $0x80247c,%rax
  8028e9:	00 00 00 
  8028ec:	ff d0                	callq  *%rax
  8028ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028f5:	79 05                	jns    8028fc <write+0x5d>
		return r;
  8028f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028fa:	eb 75                	jmp    802971 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8028fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802900:	8b 40 08             	mov    0x8(%rax),%eax
  802903:	83 e0 03             	and    $0x3,%eax
  802906:	85 c0                	test   %eax,%eax
  802908:	75 3a                	jne    802944 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80290a:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802911:	00 00 00 
  802914:	48 8b 00             	mov    (%rax),%rax
  802917:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80291d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802920:	89 c6                	mov    %eax,%esi
  802922:	48 bf 93 45 80 00 00 	movabs $0x804593,%rdi
  802929:	00 00 00 
  80292c:	b8 00 00 00 00       	mov    $0x0,%eax
  802931:	48 b9 07 08 80 00 00 	movabs $0x800807,%rcx
  802938:	00 00 00 
  80293b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80293d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802942:	eb 2d                	jmp    802971 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802944:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802948:	48 8b 40 18          	mov    0x18(%rax),%rax
  80294c:	48 85 c0             	test   %rax,%rax
  80294f:	75 07                	jne    802958 <write+0xb9>
		return -E_NOT_SUPP;
  802951:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802956:	eb 19                	jmp    802971 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802958:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80295c:	48 8b 40 18          	mov    0x18(%rax),%rax
  802960:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802964:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802968:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80296c:	48 89 cf             	mov    %rcx,%rdi
  80296f:	ff d0                	callq  *%rax
}
  802971:	c9                   	leaveq 
  802972:	c3                   	retq   

0000000000802973 <seek>:

int
seek(int fdnum, off_t offset)
{
  802973:	55                   	push   %rbp
  802974:	48 89 e5             	mov    %rsp,%rbp
  802977:	48 83 ec 18          	sub    $0x18,%rsp
  80297b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80297e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802981:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802985:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802988:	48 89 d6             	mov    %rdx,%rsi
  80298b:	89 c7                	mov    %eax,%edi
  80298d:	48 b8 23 23 80 00 00 	movabs $0x802323,%rax
  802994:	00 00 00 
  802997:	ff d0                	callq  *%rax
  802999:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80299c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029a0:	79 05                	jns    8029a7 <seek+0x34>
		return r;
  8029a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029a5:	eb 0f                	jmp    8029b6 <seek+0x43>
	fd->fd_offset = offset;
  8029a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029ab:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8029ae:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8029b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029b6:	c9                   	leaveq 
  8029b7:	c3                   	retq   

00000000008029b8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8029b8:	55                   	push   %rbp
  8029b9:	48 89 e5             	mov    %rsp,%rbp
  8029bc:	48 83 ec 30          	sub    $0x30,%rsp
  8029c0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029c3:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029c6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029ca:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029cd:	48 89 d6             	mov    %rdx,%rsi
  8029d0:	89 c7                	mov    %eax,%edi
  8029d2:	48 b8 23 23 80 00 00 	movabs $0x802323,%rax
  8029d9:	00 00 00 
  8029dc:	ff d0                	callq  *%rax
  8029de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029e5:	78 24                	js     802a0b <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029eb:	8b 00                	mov    (%rax),%eax
  8029ed:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029f1:	48 89 d6             	mov    %rdx,%rsi
  8029f4:	89 c7                	mov    %eax,%edi
  8029f6:	48 b8 7c 24 80 00 00 	movabs $0x80247c,%rax
  8029fd:	00 00 00 
  802a00:	ff d0                	callq  *%rax
  802a02:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a05:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a09:	79 05                	jns    802a10 <ftruncate+0x58>
		return r;
  802a0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a0e:	eb 72                	jmp    802a82 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a14:	8b 40 08             	mov    0x8(%rax),%eax
  802a17:	83 e0 03             	and    $0x3,%eax
  802a1a:	85 c0                	test   %eax,%eax
  802a1c:	75 3a                	jne    802a58 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802a1e:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802a25:	00 00 00 
  802a28:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802a2b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a31:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a34:	89 c6                	mov    %eax,%esi
  802a36:	48 bf b0 45 80 00 00 	movabs $0x8045b0,%rdi
  802a3d:	00 00 00 
  802a40:	b8 00 00 00 00       	mov    $0x0,%eax
  802a45:	48 b9 07 08 80 00 00 	movabs $0x800807,%rcx
  802a4c:	00 00 00 
  802a4f:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802a51:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a56:	eb 2a                	jmp    802a82 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802a58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a5c:	48 8b 40 30          	mov    0x30(%rax),%rax
  802a60:	48 85 c0             	test   %rax,%rax
  802a63:	75 07                	jne    802a6c <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802a65:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a6a:	eb 16                	jmp    802a82 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802a6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a70:	48 8b 40 30          	mov    0x30(%rax),%rax
  802a74:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a78:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802a7b:	89 ce                	mov    %ecx,%esi
  802a7d:	48 89 d7             	mov    %rdx,%rdi
  802a80:	ff d0                	callq  *%rax
}
  802a82:	c9                   	leaveq 
  802a83:	c3                   	retq   

0000000000802a84 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802a84:	55                   	push   %rbp
  802a85:	48 89 e5             	mov    %rsp,%rbp
  802a88:	48 83 ec 30          	sub    $0x30,%rsp
  802a8c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a8f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a93:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a97:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a9a:	48 89 d6             	mov    %rdx,%rsi
  802a9d:	89 c7                	mov    %eax,%edi
  802a9f:	48 b8 23 23 80 00 00 	movabs $0x802323,%rax
  802aa6:	00 00 00 
  802aa9:	ff d0                	callq  *%rax
  802aab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ab2:	78 24                	js     802ad8 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ab4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ab8:	8b 00                	mov    (%rax),%eax
  802aba:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802abe:	48 89 d6             	mov    %rdx,%rsi
  802ac1:	89 c7                	mov    %eax,%edi
  802ac3:	48 b8 7c 24 80 00 00 	movabs $0x80247c,%rax
  802aca:	00 00 00 
  802acd:	ff d0                	callq  *%rax
  802acf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ad2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ad6:	79 05                	jns    802add <fstat+0x59>
		return r;
  802ad8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802adb:	eb 5e                	jmp    802b3b <fstat+0xb7>
	if (!dev->dev_stat)
  802add:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ae1:	48 8b 40 28          	mov    0x28(%rax),%rax
  802ae5:	48 85 c0             	test   %rax,%rax
  802ae8:	75 07                	jne    802af1 <fstat+0x6d>
		return -E_NOT_SUPP;
  802aea:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802aef:	eb 4a                	jmp    802b3b <fstat+0xb7>
	stat->st_name[0] = 0;
  802af1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802af5:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802af8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802afc:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802b03:	00 00 00 
	stat->st_isdir = 0;
  802b06:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b0a:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802b11:	00 00 00 
	stat->st_dev = dev;
  802b14:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b18:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b1c:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802b23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b27:	48 8b 40 28          	mov    0x28(%rax),%rax
  802b2b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b2f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802b33:	48 89 ce             	mov    %rcx,%rsi
  802b36:	48 89 d7             	mov    %rdx,%rdi
  802b39:	ff d0                	callq  *%rax
}
  802b3b:	c9                   	leaveq 
  802b3c:	c3                   	retq   

0000000000802b3d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802b3d:	55                   	push   %rbp
  802b3e:	48 89 e5             	mov    %rsp,%rbp
  802b41:	48 83 ec 20          	sub    $0x20,%rsp
  802b45:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b49:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802b4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b51:	be 00 00 00 00       	mov    $0x0,%esi
  802b56:	48 89 c7             	mov    %rax,%rdi
  802b59:	48 b8 2b 2c 80 00 00 	movabs $0x802c2b,%rax
  802b60:	00 00 00 
  802b63:	ff d0                	callq  *%rax
  802b65:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b68:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b6c:	79 05                	jns    802b73 <stat+0x36>
		return fd;
  802b6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b71:	eb 2f                	jmp    802ba2 <stat+0x65>
	r = fstat(fd, stat);
  802b73:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b7a:	48 89 d6             	mov    %rdx,%rsi
  802b7d:	89 c7                	mov    %eax,%edi
  802b7f:	48 b8 84 2a 80 00 00 	movabs $0x802a84,%rax
  802b86:	00 00 00 
  802b89:	ff d0                	callq  *%rax
  802b8b:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802b8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b91:	89 c7                	mov    %eax,%edi
  802b93:	48 b8 33 25 80 00 00 	movabs $0x802533,%rax
  802b9a:	00 00 00 
  802b9d:	ff d0                	callq  *%rax
	return r;
  802b9f:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802ba2:	c9                   	leaveq 
  802ba3:	c3                   	retq   

0000000000802ba4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802ba4:	55                   	push   %rbp
  802ba5:	48 89 e5             	mov    %rsp,%rbp
  802ba8:	48 83 ec 10          	sub    $0x10,%rsp
  802bac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802baf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802bb3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802bba:	00 00 00 
  802bbd:	8b 00                	mov    (%rax),%eax
  802bbf:	85 c0                	test   %eax,%eax
  802bc1:	75 1d                	jne    802be0 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802bc3:	bf 01 00 00 00       	mov    $0x1,%edi
  802bc8:	48 b8 71 3e 80 00 00 	movabs $0x803e71,%rax
  802bcf:	00 00 00 
  802bd2:	ff d0                	callq  *%rax
  802bd4:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802bdb:	00 00 00 
  802bde:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802be0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802be7:	00 00 00 
  802bea:	8b 00                	mov    (%rax),%eax
  802bec:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802bef:	b9 07 00 00 00       	mov    $0x7,%ecx
  802bf4:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802bfb:	00 00 00 
  802bfe:	89 c7                	mov    %eax,%edi
  802c00:	48 b8 d4 3d 80 00 00 	movabs $0x803dd4,%rax
  802c07:	00 00 00 
  802c0a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802c0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c10:	ba 00 00 00 00       	mov    $0x0,%edx
  802c15:	48 89 c6             	mov    %rax,%rsi
  802c18:	bf 00 00 00 00       	mov    $0x0,%edi
  802c1d:	48 b8 0e 3d 80 00 00 	movabs $0x803d0e,%rax
  802c24:	00 00 00 
  802c27:	ff d0                	callq  *%rax
}
  802c29:	c9                   	leaveq 
  802c2a:	c3                   	retq   

0000000000802c2b <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802c2b:	55                   	push   %rbp
  802c2c:	48 89 e5             	mov    %rsp,%rbp
  802c2f:	48 83 ec 20          	sub    $0x20,%rsp
  802c33:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c37:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  802c3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c3e:	48 89 c7             	mov    %rax,%rdi
  802c41:	48 b8 50 13 80 00 00 	movabs $0x801350,%rax
  802c48:	00 00 00 
  802c4b:	ff d0                	callq  *%rax
  802c4d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802c52:	7e 0a                	jle    802c5e <open+0x33>
  802c54:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c59:	e9 a5 00 00 00       	jmpq   802d03 <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  802c5e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802c62:	48 89 c7             	mov    %rax,%rdi
  802c65:	48 b8 8b 22 80 00 00 	movabs $0x80228b,%rax
  802c6c:	00 00 00 
  802c6f:	ff d0                	callq  *%rax
  802c71:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c74:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c78:	79 08                	jns    802c82 <open+0x57>
		return r;
  802c7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c7d:	e9 81 00 00 00       	jmpq   802d03 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  802c82:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c89:	00 00 00 
  802c8c:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802c8f:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  802c95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c99:	48 89 c6             	mov    %rax,%rsi
  802c9c:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802ca3:	00 00 00 
  802ca6:	48 b8 bc 13 80 00 00 	movabs $0x8013bc,%rax
  802cad:	00 00 00 
  802cb0:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  802cb2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cb6:	48 89 c6             	mov    %rax,%rsi
  802cb9:	bf 01 00 00 00       	mov    $0x1,%edi
  802cbe:	48 b8 a4 2b 80 00 00 	movabs $0x802ba4,%rax
  802cc5:	00 00 00 
  802cc8:	ff d0                	callq  *%rax
  802cca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ccd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cd1:	79 1d                	jns    802cf0 <open+0xc5>
		fd_close(fd, 0);
  802cd3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cd7:	be 00 00 00 00       	mov    $0x0,%esi
  802cdc:	48 89 c7             	mov    %rax,%rdi
  802cdf:	48 b8 b3 23 80 00 00 	movabs $0x8023b3,%rax
  802ce6:	00 00 00 
  802ce9:	ff d0                	callq  *%rax
		return r;
  802ceb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cee:	eb 13                	jmp    802d03 <open+0xd8>
	}
	return fd2num(fd);
  802cf0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cf4:	48 89 c7             	mov    %rax,%rdi
  802cf7:	48 b8 3d 22 80 00 00 	movabs $0x80223d,%rax
  802cfe:	00 00 00 
  802d01:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  802d03:	c9                   	leaveq 
  802d04:	c3                   	retq   

0000000000802d05 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802d05:	55                   	push   %rbp
  802d06:	48 89 e5             	mov    %rsp,%rbp
  802d09:	48 83 ec 10          	sub    $0x10,%rsp
  802d0d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802d11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d15:	8b 50 0c             	mov    0xc(%rax),%edx
  802d18:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d1f:	00 00 00 
  802d22:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802d24:	be 00 00 00 00       	mov    $0x0,%esi
  802d29:	bf 06 00 00 00       	mov    $0x6,%edi
  802d2e:	48 b8 a4 2b 80 00 00 	movabs $0x802ba4,%rax
  802d35:	00 00 00 
  802d38:	ff d0                	callq  *%rax
}
  802d3a:	c9                   	leaveq 
  802d3b:	c3                   	retq   

0000000000802d3c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802d3c:	55                   	push   %rbp
  802d3d:	48 89 e5             	mov    %rsp,%rbp
  802d40:	48 83 ec 30          	sub    $0x30,%rsp
  802d44:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d48:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d4c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802d50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d54:	8b 50 0c             	mov    0xc(%rax),%edx
  802d57:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d5e:	00 00 00 
  802d61:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802d63:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d6a:	00 00 00 
  802d6d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d71:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  802d75:	be 00 00 00 00       	mov    $0x0,%esi
  802d7a:	bf 03 00 00 00       	mov    $0x3,%edi
  802d7f:	48 b8 a4 2b 80 00 00 	movabs $0x802ba4,%rax
  802d86:	00 00 00 
  802d89:	ff d0                	callq  *%rax
  802d8b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d92:	79 05                	jns    802d99 <devfile_read+0x5d>
		return r;
  802d94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d97:	eb 26                	jmp    802dbf <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  802d99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d9c:	48 63 d0             	movslq %eax,%rdx
  802d9f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802da3:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802daa:	00 00 00 
  802dad:	48 89 c7             	mov    %rax,%rdi
  802db0:	48 b8 f7 17 80 00 00 	movabs $0x8017f7,%rax
  802db7:	00 00 00 
  802dba:	ff d0                	callq  *%rax
	return r;
  802dbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802dbf:	c9                   	leaveq 
  802dc0:	c3                   	retq   

0000000000802dc1 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802dc1:	55                   	push   %rbp
  802dc2:	48 89 e5             	mov    %rsp,%rbp
  802dc5:	48 83 ec 30          	sub    $0x30,%rsp
  802dc9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802dcd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802dd1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  802dd5:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  802ddc:	00 
	n = n > max ? max : n;
  802ddd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802de1:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802de5:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  802dea:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802dee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802df2:	8b 50 0c             	mov    0xc(%rax),%edx
  802df5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802dfc:	00 00 00 
  802dff:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802e01:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e08:	00 00 00 
  802e0b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e0f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802e13:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e17:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e1b:	48 89 c6             	mov    %rax,%rsi
  802e1e:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802e25:	00 00 00 
  802e28:	48 b8 f7 17 80 00 00 	movabs $0x8017f7,%rax
  802e2f:	00 00 00 
  802e32:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  802e34:	be 00 00 00 00       	mov    $0x0,%esi
  802e39:	bf 04 00 00 00       	mov    $0x4,%edi
  802e3e:	48 b8 a4 2b 80 00 00 	movabs $0x802ba4,%rax
  802e45:	00 00 00 
  802e48:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  802e4a:	c9                   	leaveq 
  802e4b:	c3                   	retq   

0000000000802e4c <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802e4c:	55                   	push   %rbp
  802e4d:	48 89 e5             	mov    %rsp,%rbp
  802e50:	48 83 ec 20          	sub    $0x20,%rsp
  802e54:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e58:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802e5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e60:	8b 50 0c             	mov    0xc(%rax),%edx
  802e63:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e6a:	00 00 00 
  802e6d:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802e6f:	be 00 00 00 00       	mov    $0x0,%esi
  802e74:	bf 05 00 00 00       	mov    $0x5,%edi
  802e79:	48 b8 a4 2b 80 00 00 	movabs $0x802ba4,%rax
  802e80:	00 00 00 
  802e83:	ff d0                	callq  *%rax
  802e85:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e88:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e8c:	79 05                	jns    802e93 <devfile_stat+0x47>
		return r;
  802e8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e91:	eb 56                	jmp    802ee9 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802e93:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e97:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802e9e:	00 00 00 
  802ea1:	48 89 c7             	mov    %rax,%rdi
  802ea4:	48 b8 bc 13 80 00 00 	movabs $0x8013bc,%rax
  802eab:	00 00 00 
  802eae:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802eb0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802eb7:	00 00 00 
  802eba:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802ec0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ec4:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802eca:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ed1:	00 00 00 
  802ed4:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802eda:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ede:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802ee4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ee9:	c9                   	leaveq 
  802eea:	c3                   	retq   

0000000000802eeb <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802eeb:	55                   	push   %rbp
  802eec:	48 89 e5             	mov    %rsp,%rbp
  802eef:	48 83 ec 10          	sub    $0x10,%rsp
  802ef3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ef7:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802efa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802efe:	8b 50 0c             	mov    0xc(%rax),%edx
  802f01:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f08:	00 00 00 
  802f0b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802f0d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f14:	00 00 00 
  802f17:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802f1a:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802f1d:	be 00 00 00 00       	mov    $0x0,%esi
  802f22:	bf 02 00 00 00       	mov    $0x2,%edi
  802f27:	48 b8 a4 2b 80 00 00 	movabs $0x802ba4,%rax
  802f2e:	00 00 00 
  802f31:	ff d0                	callq  *%rax
}
  802f33:	c9                   	leaveq 
  802f34:	c3                   	retq   

0000000000802f35 <remove>:

// Delete a file
int
remove(const char *path)
{
  802f35:	55                   	push   %rbp
  802f36:	48 89 e5             	mov    %rsp,%rbp
  802f39:	48 83 ec 10          	sub    $0x10,%rsp
  802f3d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802f41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f45:	48 89 c7             	mov    %rax,%rdi
  802f48:	48 b8 50 13 80 00 00 	movabs $0x801350,%rax
  802f4f:	00 00 00 
  802f52:	ff d0                	callq  *%rax
  802f54:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802f59:	7e 07                	jle    802f62 <remove+0x2d>
		return -E_BAD_PATH;
  802f5b:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802f60:	eb 33                	jmp    802f95 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802f62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f66:	48 89 c6             	mov    %rax,%rsi
  802f69:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802f70:	00 00 00 
  802f73:	48 b8 bc 13 80 00 00 	movabs $0x8013bc,%rax
  802f7a:	00 00 00 
  802f7d:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802f7f:	be 00 00 00 00       	mov    $0x0,%esi
  802f84:	bf 07 00 00 00       	mov    $0x7,%edi
  802f89:	48 b8 a4 2b 80 00 00 	movabs $0x802ba4,%rax
  802f90:	00 00 00 
  802f93:	ff d0                	callq  *%rax
}
  802f95:	c9                   	leaveq 
  802f96:	c3                   	retq   

0000000000802f97 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802f97:	55                   	push   %rbp
  802f98:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802f9b:	be 00 00 00 00       	mov    $0x0,%esi
  802fa0:	bf 08 00 00 00       	mov    $0x8,%edi
  802fa5:	48 b8 a4 2b 80 00 00 	movabs $0x802ba4,%rax
  802fac:	00 00 00 
  802faf:	ff d0                	callq  *%rax
}
  802fb1:	5d                   	pop    %rbp
  802fb2:	c3                   	retq   

0000000000802fb3 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802fb3:	55                   	push   %rbp
  802fb4:	48 89 e5             	mov    %rsp,%rbp
  802fb7:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802fbe:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802fc5:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802fcc:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802fd3:	be 00 00 00 00       	mov    $0x0,%esi
  802fd8:	48 89 c7             	mov    %rax,%rdi
  802fdb:	48 b8 2b 2c 80 00 00 	movabs $0x802c2b,%rax
  802fe2:	00 00 00 
  802fe5:	ff d0                	callq  *%rax
  802fe7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802fea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fee:	79 28                	jns    803018 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802ff0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ff3:	89 c6                	mov    %eax,%esi
  802ff5:	48 bf d6 45 80 00 00 	movabs $0x8045d6,%rdi
  802ffc:	00 00 00 
  802fff:	b8 00 00 00 00       	mov    $0x0,%eax
  803004:	48 ba 07 08 80 00 00 	movabs $0x800807,%rdx
  80300b:	00 00 00 
  80300e:	ff d2                	callq  *%rdx
		return fd_src;
  803010:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803013:	e9 74 01 00 00       	jmpq   80318c <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803018:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80301f:	be 01 01 00 00       	mov    $0x101,%esi
  803024:	48 89 c7             	mov    %rax,%rdi
  803027:	48 b8 2b 2c 80 00 00 	movabs $0x802c2b,%rax
  80302e:	00 00 00 
  803031:	ff d0                	callq  *%rax
  803033:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803036:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80303a:	79 39                	jns    803075 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80303c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80303f:	89 c6                	mov    %eax,%esi
  803041:	48 bf ec 45 80 00 00 	movabs $0x8045ec,%rdi
  803048:	00 00 00 
  80304b:	b8 00 00 00 00       	mov    $0x0,%eax
  803050:	48 ba 07 08 80 00 00 	movabs $0x800807,%rdx
  803057:	00 00 00 
  80305a:	ff d2                	callq  *%rdx
		close(fd_src);
  80305c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80305f:	89 c7                	mov    %eax,%edi
  803061:	48 b8 33 25 80 00 00 	movabs $0x802533,%rax
  803068:	00 00 00 
  80306b:	ff d0                	callq  *%rax
		return fd_dest;
  80306d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803070:	e9 17 01 00 00       	jmpq   80318c <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803075:	eb 74                	jmp    8030eb <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803077:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80307a:	48 63 d0             	movslq %eax,%rdx
  80307d:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803084:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803087:	48 89 ce             	mov    %rcx,%rsi
  80308a:	89 c7                	mov    %eax,%edi
  80308c:	48 b8 9f 28 80 00 00 	movabs $0x80289f,%rax
  803093:	00 00 00 
  803096:	ff d0                	callq  *%rax
  803098:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80309b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80309f:	79 4a                	jns    8030eb <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8030a1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8030a4:	89 c6                	mov    %eax,%esi
  8030a6:	48 bf 06 46 80 00 00 	movabs $0x804606,%rdi
  8030ad:	00 00 00 
  8030b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8030b5:	48 ba 07 08 80 00 00 	movabs $0x800807,%rdx
  8030bc:	00 00 00 
  8030bf:	ff d2                	callq  *%rdx
			close(fd_src);
  8030c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030c4:	89 c7                	mov    %eax,%edi
  8030c6:	48 b8 33 25 80 00 00 	movabs $0x802533,%rax
  8030cd:	00 00 00 
  8030d0:	ff d0                	callq  *%rax
			close(fd_dest);
  8030d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030d5:	89 c7                	mov    %eax,%edi
  8030d7:	48 b8 33 25 80 00 00 	movabs $0x802533,%rax
  8030de:	00 00 00 
  8030e1:	ff d0                	callq  *%rax
			return write_size;
  8030e3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8030e6:	e9 a1 00 00 00       	jmpq   80318c <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8030eb:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8030f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030f5:	ba 00 02 00 00       	mov    $0x200,%edx
  8030fa:	48 89 ce             	mov    %rcx,%rsi
  8030fd:	89 c7                	mov    %eax,%edi
  8030ff:	48 b8 55 27 80 00 00 	movabs $0x802755,%rax
  803106:	00 00 00 
  803109:	ff d0                	callq  *%rax
  80310b:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80310e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803112:	0f 8f 5f ff ff ff    	jg     803077 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803118:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80311c:	79 47                	jns    803165 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80311e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803121:	89 c6                	mov    %eax,%esi
  803123:	48 bf 19 46 80 00 00 	movabs $0x804619,%rdi
  80312a:	00 00 00 
  80312d:	b8 00 00 00 00       	mov    $0x0,%eax
  803132:	48 ba 07 08 80 00 00 	movabs $0x800807,%rdx
  803139:	00 00 00 
  80313c:	ff d2                	callq  *%rdx
		close(fd_src);
  80313e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803141:	89 c7                	mov    %eax,%edi
  803143:	48 b8 33 25 80 00 00 	movabs $0x802533,%rax
  80314a:	00 00 00 
  80314d:	ff d0                	callq  *%rax
		close(fd_dest);
  80314f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803152:	89 c7                	mov    %eax,%edi
  803154:	48 b8 33 25 80 00 00 	movabs $0x802533,%rax
  80315b:	00 00 00 
  80315e:	ff d0                	callq  *%rax
		return read_size;
  803160:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803163:	eb 27                	jmp    80318c <copy+0x1d9>
	}
	close(fd_src);
  803165:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803168:	89 c7                	mov    %eax,%edi
  80316a:	48 b8 33 25 80 00 00 	movabs $0x802533,%rax
  803171:	00 00 00 
  803174:	ff d0                	callq  *%rax
	close(fd_dest);
  803176:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803179:	89 c7                	mov    %eax,%edi
  80317b:	48 b8 33 25 80 00 00 	movabs $0x802533,%rax
  803182:	00 00 00 
  803185:	ff d0                	callq  *%rax
	return 0;
  803187:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80318c:	c9                   	leaveq 
  80318d:	c3                   	retq   

000000000080318e <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  80318e:	55                   	push   %rbp
  80318f:	48 89 e5             	mov    %rsp,%rbp
  803192:	48 83 ec 20          	sub    $0x20,%rsp
  803196:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  80319a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80319e:	8b 40 0c             	mov    0xc(%rax),%eax
  8031a1:	85 c0                	test   %eax,%eax
  8031a3:	7e 67                	jle    80320c <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  8031a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031a9:	8b 40 04             	mov    0x4(%rax),%eax
  8031ac:	48 63 d0             	movslq %eax,%rdx
  8031af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031b3:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8031b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031bb:	8b 00                	mov    (%rax),%eax
  8031bd:	48 89 ce             	mov    %rcx,%rsi
  8031c0:	89 c7                	mov    %eax,%edi
  8031c2:	48 b8 9f 28 80 00 00 	movabs $0x80289f,%rax
  8031c9:	00 00 00 
  8031cc:	ff d0                	callq  *%rax
  8031ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  8031d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031d5:	7e 13                	jle    8031ea <writebuf+0x5c>
			b->result += result;
  8031d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031db:	8b 50 08             	mov    0x8(%rax),%edx
  8031de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031e1:	01 c2                	add    %eax,%edx
  8031e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031e7:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  8031ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031ee:	8b 40 04             	mov    0x4(%rax),%eax
  8031f1:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8031f4:	74 16                	je     80320c <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  8031f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8031fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031ff:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  803203:	89 c2                	mov    %eax,%edx
  803205:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803209:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  80320c:	c9                   	leaveq 
  80320d:	c3                   	retq   

000000000080320e <putch>:

static void
putch(int ch, void *thunk)
{
  80320e:	55                   	push   %rbp
  80320f:	48 89 e5             	mov    %rsp,%rbp
  803212:	48 83 ec 20          	sub    $0x20,%rsp
  803216:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803219:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  80321d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803221:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  803225:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803229:	8b 40 04             	mov    0x4(%rax),%eax
  80322c:	8d 48 01             	lea    0x1(%rax),%ecx
  80322f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803233:	89 4a 04             	mov    %ecx,0x4(%rdx)
  803236:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803239:	89 d1                	mov    %edx,%ecx
  80323b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80323f:	48 98                	cltq   
  803241:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  803245:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803249:	8b 40 04             	mov    0x4(%rax),%eax
  80324c:	3d 00 01 00 00       	cmp    $0x100,%eax
  803251:	75 1e                	jne    803271 <putch+0x63>
		writebuf(b);
  803253:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803257:	48 89 c7             	mov    %rax,%rdi
  80325a:	48 b8 8e 31 80 00 00 	movabs $0x80318e,%rax
  803261:	00 00 00 
  803264:	ff d0                	callq  *%rax
		b->idx = 0;
  803266:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80326a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  803271:	c9                   	leaveq 
  803272:	c3                   	retq   

0000000000803273 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  803273:	55                   	push   %rbp
  803274:	48 89 e5             	mov    %rsp,%rbp
  803277:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  80327e:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  803284:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  80328b:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  803292:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  803298:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  80329e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8032a5:	00 00 00 
	b.result = 0;
  8032a8:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  8032af:	00 00 00 
	b.error = 1;
  8032b2:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  8032b9:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8032bc:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  8032c3:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  8032ca:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8032d1:	48 89 c6             	mov    %rax,%rsi
  8032d4:	48 bf 0e 32 80 00 00 	movabs $0x80320e,%rdi
  8032db:	00 00 00 
  8032de:	48 b8 ba 0b 80 00 00 	movabs $0x800bba,%rax
  8032e5:	00 00 00 
  8032e8:	ff d0                	callq  *%rax
	if (b.idx > 0)
  8032ea:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  8032f0:	85 c0                	test   %eax,%eax
  8032f2:	7e 16                	jle    80330a <vfprintf+0x97>
		writebuf(&b);
  8032f4:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8032fb:	48 89 c7             	mov    %rax,%rdi
  8032fe:	48 b8 8e 31 80 00 00 	movabs $0x80318e,%rax
  803305:	00 00 00 
  803308:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  80330a:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  803310:	85 c0                	test   %eax,%eax
  803312:	74 08                	je     80331c <vfprintf+0xa9>
  803314:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  80331a:	eb 06                	jmp    803322 <vfprintf+0xaf>
  80331c:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  803322:	c9                   	leaveq 
  803323:	c3                   	retq   

0000000000803324 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  803324:	55                   	push   %rbp
  803325:	48 89 e5             	mov    %rsp,%rbp
  803328:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  80332f:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  803335:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80333c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803343:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80334a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803351:	84 c0                	test   %al,%al
  803353:	74 20                	je     803375 <fprintf+0x51>
  803355:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803359:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80335d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803361:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803365:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803369:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80336d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803371:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803375:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80337c:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  803383:	00 00 00 
  803386:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80338d:	00 00 00 
  803390:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803394:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80339b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8033a2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  8033a9:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8033b0:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  8033b7:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8033bd:	48 89 ce             	mov    %rcx,%rsi
  8033c0:	89 c7                	mov    %eax,%edi
  8033c2:	48 b8 73 32 80 00 00 	movabs $0x803273,%rax
  8033c9:	00 00 00 
  8033cc:	ff d0                	callq  *%rax
  8033ce:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8033d4:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8033da:	c9                   	leaveq 
  8033db:	c3                   	retq   

00000000008033dc <printf>:

int
printf(const char *fmt, ...)
{
  8033dc:	55                   	push   %rbp
  8033dd:	48 89 e5             	mov    %rsp,%rbp
  8033e0:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8033e7:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8033ee:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8033f5:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8033fc:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803403:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80340a:	84 c0                	test   %al,%al
  80340c:	74 20                	je     80342e <printf+0x52>
  80340e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803412:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803416:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80341a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80341e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803422:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803426:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80342a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80342e:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803435:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80343c:	00 00 00 
  80343f:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803446:	00 00 00 
  803449:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80344d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803454:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80345b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  803462:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803469:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803470:	48 89 c6             	mov    %rax,%rsi
  803473:	bf 01 00 00 00       	mov    $0x1,%edi
  803478:	48 b8 73 32 80 00 00 	movabs $0x803273,%rax
  80347f:	00 00 00 
  803482:	ff d0                	callq  *%rax
  803484:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  80348a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803490:	c9                   	leaveq 
  803491:	c3                   	retq   

0000000000803492 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803492:	55                   	push   %rbp
  803493:	48 89 e5             	mov    %rsp,%rbp
  803496:	53                   	push   %rbx
  803497:	48 83 ec 38          	sub    $0x38,%rsp
  80349b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80349f:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8034a3:	48 89 c7             	mov    %rax,%rdi
  8034a6:	48 b8 8b 22 80 00 00 	movabs $0x80228b,%rax
  8034ad:	00 00 00 
  8034b0:	ff d0                	callq  *%rax
  8034b2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034b9:	0f 88 bf 01 00 00    	js     80367e <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8034bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034c3:	ba 07 04 00 00       	mov    $0x407,%edx
  8034c8:	48 89 c6             	mov    %rax,%rsi
  8034cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8034d0:	48 b8 eb 1c 80 00 00 	movabs $0x801ceb,%rax
  8034d7:	00 00 00 
  8034da:	ff d0                	callq  *%rax
  8034dc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034df:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034e3:	0f 88 95 01 00 00    	js     80367e <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8034e9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8034ed:	48 89 c7             	mov    %rax,%rdi
  8034f0:	48 b8 8b 22 80 00 00 	movabs $0x80228b,%rax
  8034f7:	00 00 00 
  8034fa:	ff d0                	callq  *%rax
  8034fc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803503:	0f 88 5d 01 00 00    	js     803666 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803509:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80350d:	ba 07 04 00 00       	mov    $0x407,%edx
  803512:	48 89 c6             	mov    %rax,%rsi
  803515:	bf 00 00 00 00       	mov    $0x0,%edi
  80351a:	48 b8 eb 1c 80 00 00 	movabs $0x801ceb,%rax
  803521:	00 00 00 
  803524:	ff d0                	callq  *%rax
  803526:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803529:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80352d:	0f 88 33 01 00 00    	js     803666 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803533:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803537:	48 89 c7             	mov    %rax,%rdi
  80353a:	48 b8 60 22 80 00 00 	movabs $0x802260,%rax
  803541:	00 00 00 
  803544:	ff d0                	callq  *%rax
  803546:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80354a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80354e:	ba 07 04 00 00       	mov    $0x407,%edx
  803553:	48 89 c6             	mov    %rax,%rsi
  803556:	bf 00 00 00 00       	mov    $0x0,%edi
  80355b:	48 b8 eb 1c 80 00 00 	movabs $0x801ceb,%rax
  803562:	00 00 00 
  803565:	ff d0                	callq  *%rax
  803567:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80356a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80356e:	79 05                	jns    803575 <pipe+0xe3>
		goto err2;
  803570:	e9 d9 00 00 00       	jmpq   80364e <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803575:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803579:	48 89 c7             	mov    %rax,%rdi
  80357c:	48 b8 60 22 80 00 00 	movabs $0x802260,%rax
  803583:	00 00 00 
  803586:	ff d0                	callq  *%rax
  803588:	48 89 c2             	mov    %rax,%rdx
  80358b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80358f:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803595:	48 89 d1             	mov    %rdx,%rcx
  803598:	ba 00 00 00 00       	mov    $0x0,%edx
  80359d:	48 89 c6             	mov    %rax,%rsi
  8035a0:	bf 00 00 00 00       	mov    $0x0,%edi
  8035a5:	48 b8 3b 1d 80 00 00 	movabs $0x801d3b,%rax
  8035ac:	00 00 00 
  8035af:	ff d0                	callq  *%rax
  8035b1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035b8:	79 1b                	jns    8035d5 <pipe+0x143>
		goto err3;
  8035ba:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8035bb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035bf:	48 89 c6             	mov    %rax,%rsi
  8035c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8035c7:	48 b8 96 1d 80 00 00 	movabs $0x801d96,%rax
  8035ce:	00 00 00 
  8035d1:	ff d0                	callq  *%rax
  8035d3:	eb 79                	jmp    80364e <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8035d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035d9:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  8035e0:	00 00 00 
  8035e3:	8b 12                	mov    (%rdx),%edx
  8035e5:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8035e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035eb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8035f2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035f6:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  8035fd:	00 00 00 
  803600:	8b 12                	mov    (%rdx),%edx
  803602:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803604:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803608:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80360f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803613:	48 89 c7             	mov    %rax,%rdi
  803616:	48 b8 3d 22 80 00 00 	movabs $0x80223d,%rax
  80361d:	00 00 00 
  803620:	ff d0                	callq  *%rax
  803622:	89 c2                	mov    %eax,%edx
  803624:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803628:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80362a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80362e:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803632:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803636:	48 89 c7             	mov    %rax,%rdi
  803639:	48 b8 3d 22 80 00 00 	movabs $0x80223d,%rax
  803640:	00 00 00 
  803643:	ff d0                	callq  *%rax
  803645:	89 03                	mov    %eax,(%rbx)
	return 0;
  803647:	b8 00 00 00 00       	mov    $0x0,%eax
  80364c:	eb 33                	jmp    803681 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80364e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803652:	48 89 c6             	mov    %rax,%rsi
  803655:	bf 00 00 00 00       	mov    $0x0,%edi
  80365a:	48 b8 96 1d 80 00 00 	movabs $0x801d96,%rax
  803661:	00 00 00 
  803664:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803666:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80366a:	48 89 c6             	mov    %rax,%rsi
  80366d:	bf 00 00 00 00       	mov    $0x0,%edi
  803672:	48 b8 96 1d 80 00 00 	movabs $0x801d96,%rax
  803679:	00 00 00 
  80367c:	ff d0                	callq  *%rax
err:
	return r;
  80367e:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803681:	48 83 c4 38          	add    $0x38,%rsp
  803685:	5b                   	pop    %rbx
  803686:	5d                   	pop    %rbp
  803687:	c3                   	retq   

0000000000803688 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803688:	55                   	push   %rbp
  803689:	48 89 e5             	mov    %rsp,%rbp
  80368c:	53                   	push   %rbx
  80368d:	48 83 ec 28          	sub    $0x28,%rsp
  803691:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803695:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803699:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8036a0:	00 00 00 
  8036a3:	48 8b 00             	mov    (%rax),%rax
  8036a6:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8036ac:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8036af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036b3:	48 89 c7             	mov    %rax,%rdi
  8036b6:	48 b8 f3 3e 80 00 00 	movabs $0x803ef3,%rax
  8036bd:	00 00 00 
  8036c0:	ff d0                	callq  *%rax
  8036c2:	89 c3                	mov    %eax,%ebx
  8036c4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036c8:	48 89 c7             	mov    %rax,%rdi
  8036cb:	48 b8 f3 3e 80 00 00 	movabs $0x803ef3,%rax
  8036d2:	00 00 00 
  8036d5:	ff d0                	callq  *%rax
  8036d7:	39 c3                	cmp    %eax,%ebx
  8036d9:	0f 94 c0             	sete   %al
  8036dc:	0f b6 c0             	movzbl %al,%eax
  8036df:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8036e2:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8036e9:	00 00 00 
  8036ec:	48 8b 00             	mov    (%rax),%rax
  8036ef:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8036f5:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8036f8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036fb:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8036fe:	75 05                	jne    803705 <_pipeisclosed+0x7d>
			return ret;
  803700:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803703:	eb 4f                	jmp    803754 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803705:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803708:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80370b:	74 42                	je     80374f <_pipeisclosed+0xc7>
  80370d:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803711:	75 3c                	jne    80374f <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803713:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  80371a:	00 00 00 
  80371d:	48 8b 00             	mov    (%rax),%rax
  803720:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803726:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803729:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80372c:	89 c6                	mov    %eax,%esi
  80372e:	48 bf 34 46 80 00 00 	movabs $0x804634,%rdi
  803735:	00 00 00 
  803738:	b8 00 00 00 00       	mov    $0x0,%eax
  80373d:	49 b8 07 08 80 00 00 	movabs $0x800807,%r8
  803744:	00 00 00 
  803747:	41 ff d0             	callq  *%r8
	}
  80374a:	e9 4a ff ff ff       	jmpq   803699 <_pipeisclosed+0x11>
  80374f:	e9 45 ff ff ff       	jmpq   803699 <_pipeisclosed+0x11>
}
  803754:	48 83 c4 28          	add    $0x28,%rsp
  803758:	5b                   	pop    %rbx
  803759:	5d                   	pop    %rbp
  80375a:	c3                   	retq   

000000000080375b <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80375b:	55                   	push   %rbp
  80375c:	48 89 e5             	mov    %rsp,%rbp
  80375f:	48 83 ec 30          	sub    $0x30,%rsp
  803763:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803766:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80376a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80376d:	48 89 d6             	mov    %rdx,%rsi
  803770:	89 c7                	mov    %eax,%edi
  803772:	48 b8 23 23 80 00 00 	movabs $0x802323,%rax
  803779:	00 00 00 
  80377c:	ff d0                	callq  *%rax
  80377e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803781:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803785:	79 05                	jns    80378c <pipeisclosed+0x31>
		return r;
  803787:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80378a:	eb 31                	jmp    8037bd <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80378c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803790:	48 89 c7             	mov    %rax,%rdi
  803793:	48 b8 60 22 80 00 00 	movabs $0x802260,%rax
  80379a:	00 00 00 
  80379d:	ff d0                	callq  *%rax
  80379f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8037a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037a7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037ab:	48 89 d6             	mov    %rdx,%rsi
  8037ae:	48 89 c7             	mov    %rax,%rdi
  8037b1:	48 b8 88 36 80 00 00 	movabs $0x803688,%rax
  8037b8:	00 00 00 
  8037bb:	ff d0                	callq  *%rax
}
  8037bd:	c9                   	leaveq 
  8037be:	c3                   	retq   

00000000008037bf <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8037bf:	55                   	push   %rbp
  8037c0:	48 89 e5             	mov    %rsp,%rbp
  8037c3:	48 83 ec 40          	sub    $0x40,%rsp
  8037c7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8037cb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8037cf:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8037d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037d7:	48 89 c7             	mov    %rax,%rdi
  8037da:	48 b8 60 22 80 00 00 	movabs $0x802260,%rax
  8037e1:	00 00 00 
  8037e4:	ff d0                	callq  *%rax
  8037e6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8037ea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037ee:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8037f2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8037f9:	00 
  8037fa:	e9 92 00 00 00       	jmpq   803891 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8037ff:	eb 41                	jmp    803842 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803801:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803806:	74 09                	je     803811 <devpipe_read+0x52>
				return i;
  803808:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80380c:	e9 92 00 00 00       	jmpq   8038a3 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803811:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803815:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803819:	48 89 d6             	mov    %rdx,%rsi
  80381c:	48 89 c7             	mov    %rax,%rdi
  80381f:	48 b8 88 36 80 00 00 	movabs $0x803688,%rax
  803826:	00 00 00 
  803829:	ff d0                	callq  *%rax
  80382b:	85 c0                	test   %eax,%eax
  80382d:	74 07                	je     803836 <devpipe_read+0x77>
				return 0;
  80382f:	b8 00 00 00 00       	mov    $0x0,%eax
  803834:	eb 6d                	jmp    8038a3 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803836:	48 b8 ad 1c 80 00 00 	movabs $0x801cad,%rax
  80383d:	00 00 00 
  803840:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803842:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803846:	8b 10                	mov    (%rax),%edx
  803848:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80384c:	8b 40 04             	mov    0x4(%rax),%eax
  80384f:	39 c2                	cmp    %eax,%edx
  803851:	74 ae                	je     803801 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803853:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803857:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80385b:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80385f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803863:	8b 00                	mov    (%rax),%eax
  803865:	99                   	cltd   
  803866:	c1 ea 1b             	shr    $0x1b,%edx
  803869:	01 d0                	add    %edx,%eax
  80386b:	83 e0 1f             	and    $0x1f,%eax
  80386e:	29 d0                	sub    %edx,%eax
  803870:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803874:	48 98                	cltq   
  803876:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80387b:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80387d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803881:	8b 00                	mov    (%rax),%eax
  803883:	8d 50 01             	lea    0x1(%rax),%edx
  803886:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80388a:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80388c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803891:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803895:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803899:	0f 82 60 ff ff ff    	jb     8037ff <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80389f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8038a3:	c9                   	leaveq 
  8038a4:	c3                   	retq   

00000000008038a5 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8038a5:	55                   	push   %rbp
  8038a6:	48 89 e5             	mov    %rsp,%rbp
  8038a9:	48 83 ec 40          	sub    $0x40,%rsp
  8038ad:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8038b1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8038b5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8038b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038bd:	48 89 c7             	mov    %rax,%rdi
  8038c0:	48 b8 60 22 80 00 00 	movabs $0x802260,%rax
  8038c7:	00 00 00 
  8038ca:	ff d0                	callq  *%rax
  8038cc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8038d0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038d4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8038d8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8038df:	00 
  8038e0:	e9 8e 00 00 00       	jmpq   803973 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8038e5:	eb 31                	jmp    803918 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8038e7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038ef:	48 89 d6             	mov    %rdx,%rsi
  8038f2:	48 89 c7             	mov    %rax,%rdi
  8038f5:	48 b8 88 36 80 00 00 	movabs $0x803688,%rax
  8038fc:	00 00 00 
  8038ff:	ff d0                	callq  *%rax
  803901:	85 c0                	test   %eax,%eax
  803903:	74 07                	je     80390c <devpipe_write+0x67>
				return 0;
  803905:	b8 00 00 00 00       	mov    $0x0,%eax
  80390a:	eb 79                	jmp    803985 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80390c:	48 b8 ad 1c 80 00 00 	movabs $0x801cad,%rax
  803913:	00 00 00 
  803916:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803918:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80391c:	8b 40 04             	mov    0x4(%rax),%eax
  80391f:	48 63 d0             	movslq %eax,%rdx
  803922:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803926:	8b 00                	mov    (%rax),%eax
  803928:	48 98                	cltq   
  80392a:	48 83 c0 20          	add    $0x20,%rax
  80392e:	48 39 c2             	cmp    %rax,%rdx
  803931:	73 b4                	jae    8038e7 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803933:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803937:	8b 40 04             	mov    0x4(%rax),%eax
  80393a:	99                   	cltd   
  80393b:	c1 ea 1b             	shr    $0x1b,%edx
  80393e:	01 d0                	add    %edx,%eax
  803940:	83 e0 1f             	and    $0x1f,%eax
  803943:	29 d0                	sub    %edx,%eax
  803945:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803949:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80394d:	48 01 ca             	add    %rcx,%rdx
  803950:	0f b6 0a             	movzbl (%rdx),%ecx
  803953:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803957:	48 98                	cltq   
  803959:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80395d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803961:	8b 40 04             	mov    0x4(%rax),%eax
  803964:	8d 50 01             	lea    0x1(%rax),%edx
  803967:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80396b:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80396e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803973:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803977:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80397b:	0f 82 64 ff ff ff    	jb     8038e5 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803981:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803985:	c9                   	leaveq 
  803986:	c3                   	retq   

0000000000803987 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803987:	55                   	push   %rbp
  803988:	48 89 e5             	mov    %rsp,%rbp
  80398b:	48 83 ec 20          	sub    $0x20,%rsp
  80398f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803993:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803997:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80399b:	48 89 c7             	mov    %rax,%rdi
  80399e:	48 b8 60 22 80 00 00 	movabs $0x802260,%rax
  8039a5:	00 00 00 
  8039a8:	ff d0                	callq  *%rax
  8039aa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8039ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039b2:	48 be 47 46 80 00 00 	movabs $0x804647,%rsi
  8039b9:	00 00 00 
  8039bc:	48 89 c7             	mov    %rax,%rdi
  8039bf:	48 b8 bc 13 80 00 00 	movabs $0x8013bc,%rax
  8039c6:	00 00 00 
  8039c9:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8039cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039cf:	8b 50 04             	mov    0x4(%rax),%edx
  8039d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039d6:	8b 00                	mov    (%rax),%eax
  8039d8:	29 c2                	sub    %eax,%edx
  8039da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039de:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8039e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039e8:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8039ef:	00 00 00 
	stat->st_dev = &devpipe;
  8039f2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039f6:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  8039fd:	00 00 00 
  803a00:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803a07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a0c:	c9                   	leaveq 
  803a0d:	c3                   	retq   

0000000000803a0e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803a0e:	55                   	push   %rbp
  803a0f:	48 89 e5             	mov    %rsp,%rbp
  803a12:	48 83 ec 10          	sub    $0x10,%rsp
  803a16:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803a1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a1e:	48 89 c6             	mov    %rax,%rsi
  803a21:	bf 00 00 00 00       	mov    $0x0,%edi
  803a26:	48 b8 96 1d 80 00 00 	movabs $0x801d96,%rax
  803a2d:	00 00 00 
  803a30:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803a32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a36:	48 89 c7             	mov    %rax,%rdi
  803a39:	48 b8 60 22 80 00 00 	movabs $0x802260,%rax
  803a40:	00 00 00 
  803a43:	ff d0                	callq  *%rax
  803a45:	48 89 c6             	mov    %rax,%rsi
  803a48:	bf 00 00 00 00       	mov    $0x0,%edi
  803a4d:	48 b8 96 1d 80 00 00 	movabs $0x801d96,%rax
  803a54:	00 00 00 
  803a57:	ff d0                	callq  *%rax
}
  803a59:	c9                   	leaveq 
  803a5a:	c3                   	retq   

0000000000803a5b <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803a5b:	55                   	push   %rbp
  803a5c:	48 89 e5             	mov    %rsp,%rbp
  803a5f:	48 83 ec 20          	sub    $0x20,%rsp
  803a63:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803a66:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a69:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803a6c:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803a70:	be 01 00 00 00       	mov    $0x1,%esi
  803a75:	48 89 c7             	mov    %rax,%rdi
  803a78:	48 b8 a3 1b 80 00 00 	movabs $0x801ba3,%rax
  803a7f:	00 00 00 
  803a82:	ff d0                	callq  *%rax
}
  803a84:	c9                   	leaveq 
  803a85:	c3                   	retq   

0000000000803a86 <getchar>:

int
getchar(void)
{
  803a86:	55                   	push   %rbp
  803a87:	48 89 e5             	mov    %rsp,%rbp
  803a8a:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803a8e:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803a92:	ba 01 00 00 00       	mov    $0x1,%edx
  803a97:	48 89 c6             	mov    %rax,%rsi
  803a9a:	bf 00 00 00 00       	mov    $0x0,%edi
  803a9f:	48 b8 55 27 80 00 00 	movabs $0x802755,%rax
  803aa6:	00 00 00 
  803aa9:	ff d0                	callq  *%rax
  803aab:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803aae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ab2:	79 05                	jns    803ab9 <getchar+0x33>
		return r;
  803ab4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ab7:	eb 14                	jmp    803acd <getchar+0x47>
	if (r < 1)
  803ab9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803abd:	7f 07                	jg     803ac6 <getchar+0x40>
		return -E_EOF;
  803abf:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803ac4:	eb 07                	jmp    803acd <getchar+0x47>
	return c;
  803ac6:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803aca:	0f b6 c0             	movzbl %al,%eax
}
  803acd:	c9                   	leaveq 
  803ace:	c3                   	retq   

0000000000803acf <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803acf:	55                   	push   %rbp
  803ad0:	48 89 e5             	mov    %rsp,%rbp
  803ad3:	48 83 ec 20          	sub    $0x20,%rsp
  803ad7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803ada:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803ade:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ae1:	48 89 d6             	mov    %rdx,%rsi
  803ae4:	89 c7                	mov    %eax,%edi
  803ae6:	48 b8 23 23 80 00 00 	movabs $0x802323,%rax
  803aed:	00 00 00 
  803af0:	ff d0                	callq  *%rax
  803af2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803af5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803af9:	79 05                	jns    803b00 <iscons+0x31>
		return r;
  803afb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803afe:	eb 1a                	jmp    803b1a <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803b00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b04:	8b 10                	mov    (%rax),%edx
  803b06:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803b0d:	00 00 00 
  803b10:	8b 00                	mov    (%rax),%eax
  803b12:	39 c2                	cmp    %eax,%edx
  803b14:	0f 94 c0             	sete   %al
  803b17:	0f b6 c0             	movzbl %al,%eax
}
  803b1a:	c9                   	leaveq 
  803b1b:	c3                   	retq   

0000000000803b1c <opencons>:

int
opencons(void)
{
  803b1c:	55                   	push   %rbp
  803b1d:	48 89 e5             	mov    %rsp,%rbp
  803b20:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803b24:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803b28:	48 89 c7             	mov    %rax,%rdi
  803b2b:	48 b8 8b 22 80 00 00 	movabs $0x80228b,%rax
  803b32:	00 00 00 
  803b35:	ff d0                	callq  *%rax
  803b37:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b3e:	79 05                	jns    803b45 <opencons+0x29>
		return r;
  803b40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b43:	eb 5b                	jmp    803ba0 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803b45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b49:	ba 07 04 00 00       	mov    $0x407,%edx
  803b4e:	48 89 c6             	mov    %rax,%rsi
  803b51:	bf 00 00 00 00       	mov    $0x0,%edi
  803b56:	48 b8 eb 1c 80 00 00 	movabs $0x801ceb,%rax
  803b5d:	00 00 00 
  803b60:	ff d0                	callq  *%rax
  803b62:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b65:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b69:	79 05                	jns    803b70 <opencons+0x54>
		return r;
  803b6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b6e:	eb 30                	jmp    803ba0 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803b70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b74:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803b7b:	00 00 00 
  803b7e:	8b 12                	mov    (%rdx),%edx
  803b80:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803b82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b86:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803b8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b91:	48 89 c7             	mov    %rax,%rdi
  803b94:	48 b8 3d 22 80 00 00 	movabs $0x80223d,%rax
  803b9b:	00 00 00 
  803b9e:	ff d0                	callq  *%rax
}
  803ba0:	c9                   	leaveq 
  803ba1:	c3                   	retq   

0000000000803ba2 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803ba2:	55                   	push   %rbp
  803ba3:	48 89 e5             	mov    %rsp,%rbp
  803ba6:	48 83 ec 30          	sub    $0x30,%rsp
  803baa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803bae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803bb2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803bb6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803bbb:	75 07                	jne    803bc4 <devcons_read+0x22>
		return 0;
  803bbd:	b8 00 00 00 00       	mov    $0x0,%eax
  803bc2:	eb 4b                	jmp    803c0f <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803bc4:	eb 0c                	jmp    803bd2 <devcons_read+0x30>
		sys_yield();
  803bc6:	48 b8 ad 1c 80 00 00 	movabs $0x801cad,%rax
  803bcd:	00 00 00 
  803bd0:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803bd2:	48 b8 ed 1b 80 00 00 	movabs $0x801bed,%rax
  803bd9:	00 00 00 
  803bdc:	ff d0                	callq  *%rax
  803bde:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803be1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803be5:	74 df                	je     803bc6 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803be7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803beb:	79 05                	jns    803bf2 <devcons_read+0x50>
		return c;
  803bed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bf0:	eb 1d                	jmp    803c0f <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803bf2:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803bf6:	75 07                	jne    803bff <devcons_read+0x5d>
		return 0;
  803bf8:	b8 00 00 00 00       	mov    $0x0,%eax
  803bfd:	eb 10                	jmp    803c0f <devcons_read+0x6d>
	*(char*)vbuf = c;
  803bff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c02:	89 c2                	mov    %eax,%edx
  803c04:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c08:	88 10                	mov    %dl,(%rax)
	return 1;
  803c0a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803c0f:	c9                   	leaveq 
  803c10:	c3                   	retq   

0000000000803c11 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803c11:	55                   	push   %rbp
  803c12:	48 89 e5             	mov    %rsp,%rbp
  803c15:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803c1c:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803c23:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803c2a:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803c31:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803c38:	eb 76                	jmp    803cb0 <devcons_write+0x9f>
		m = n - tot;
  803c3a:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803c41:	89 c2                	mov    %eax,%edx
  803c43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c46:	29 c2                	sub    %eax,%edx
  803c48:	89 d0                	mov    %edx,%eax
  803c4a:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803c4d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c50:	83 f8 7f             	cmp    $0x7f,%eax
  803c53:	76 07                	jbe    803c5c <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803c55:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803c5c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c5f:	48 63 d0             	movslq %eax,%rdx
  803c62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c65:	48 63 c8             	movslq %eax,%rcx
  803c68:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803c6f:	48 01 c1             	add    %rax,%rcx
  803c72:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803c79:	48 89 ce             	mov    %rcx,%rsi
  803c7c:	48 89 c7             	mov    %rax,%rdi
  803c7f:	48 b8 e0 16 80 00 00 	movabs $0x8016e0,%rax
  803c86:	00 00 00 
  803c89:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803c8b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c8e:	48 63 d0             	movslq %eax,%rdx
  803c91:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803c98:	48 89 d6             	mov    %rdx,%rsi
  803c9b:	48 89 c7             	mov    %rax,%rdi
  803c9e:	48 b8 a3 1b 80 00 00 	movabs $0x801ba3,%rax
  803ca5:	00 00 00 
  803ca8:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803caa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cad:	01 45 fc             	add    %eax,-0x4(%rbp)
  803cb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cb3:	48 98                	cltq   
  803cb5:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803cbc:	0f 82 78 ff ff ff    	jb     803c3a <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803cc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803cc5:	c9                   	leaveq 
  803cc6:	c3                   	retq   

0000000000803cc7 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803cc7:	55                   	push   %rbp
  803cc8:	48 89 e5             	mov    %rsp,%rbp
  803ccb:	48 83 ec 08          	sub    $0x8,%rsp
  803ccf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803cd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803cd8:	c9                   	leaveq 
  803cd9:	c3                   	retq   

0000000000803cda <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803cda:	55                   	push   %rbp
  803cdb:	48 89 e5             	mov    %rsp,%rbp
  803cde:	48 83 ec 10          	sub    $0x10,%rsp
  803ce2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803ce6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803cea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cee:	48 be 53 46 80 00 00 	movabs $0x804653,%rsi
  803cf5:	00 00 00 
  803cf8:	48 89 c7             	mov    %rax,%rdi
  803cfb:	48 b8 bc 13 80 00 00 	movabs $0x8013bc,%rax
  803d02:	00 00 00 
  803d05:	ff d0                	callq  *%rax
	return 0;
  803d07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d0c:	c9                   	leaveq 
  803d0d:	c3                   	retq   

0000000000803d0e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803d0e:	55                   	push   %rbp
  803d0f:	48 89 e5             	mov    %rsp,%rbp
  803d12:	48 83 ec 30          	sub    $0x30,%rsp
  803d16:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d1a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d1e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  803d22:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803d27:	74 18                	je     803d41 <ipc_recv+0x33>
  803d29:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d2d:	48 89 c7             	mov    %rax,%rdi
  803d30:	48 b8 14 1f 80 00 00 	movabs $0x801f14,%rax
  803d37:	00 00 00 
  803d3a:	ff d0                	callq  *%rax
  803d3c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d3f:	eb 19                	jmp    803d5a <ipc_recv+0x4c>
  803d41:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  803d48:	00 00 00 
  803d4b:	48 b8 14 1f 80 00 00 	movabs $0x801f14,%rax
  803d52:	00 00 00 
  803d55:	ff d0                	callq  *%rax
  803d57:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  803d5a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803d5f:	74 26                	je     803d87 <ipc_recv+0x79>
  803d61:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d65:	75 15                	jne    803d7c <ipc_recv+0x6e>
  803d67:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803d6e:	00 00 00 
  803d71:	48 8b 00             	mov    (%rax),%rax
  803d74:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  803d7a:	eb 05                	jmp    803d81 <ipc_recv+0x73>
  803d7c:	b8 00 00 00 00       	mov    $0x0,%eax
  803d81:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803d85:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  803d87:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803d8c:	74 26                	je     803db4 <ipc_recv+0xa6>
  803d8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d92:	75 15                	jne    803da9 <ipc_recv+0x9b>
  803d94:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803d9b:	00 00 00 
  803d9e:	48 8b 00             	mov    (%rax),%rax
  803da1:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  803da7:	eb 05                	jmp    803dae <ipc_recv+0xa0>
  803da9:	b8 00 00 00 00       	mov    $0x0,%eax
  803dae:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803db2:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  803db4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803db8:	75 15                	jne    803dcf <ipc_recv+0xc1>
  803dba:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803dc1:	00 00 00 
  803dc4:	48 8b 00             	mov    (%rax),%rax
  803dc7:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  803dcd:	eb 03                	jmp    803dd2 <ipc_recv+0xc4>
  803dcf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803dd2:	c9                   	leaveq 
  803dd3:	c3                   	retq   

0000000000803dd4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803dd4:	55                   	push   %rbp
  803dd5:	48 89 e5             	mov    %rsp,%rbp
  803dd8:	48 83 ec 30          	sub    $0x30,%rsp
  803ddc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ddf:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803de2:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803de6:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  803de9:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  803df0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803df5:	75 10                	jne    803e07 <ipc_send+0x33>
  803df7:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803dfe:	00 00 00 
  803e01:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  803e05:	eb 62                	jmp    803e69 <ipc_send+0x95>
  803e07:	eb 60                	jmp    803e69 <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  803e09:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803e0d:	74 30                	je     803e3f <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  803e0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e12:	89 c1                	mov    %eax,%ecx
  803e14:	48 ba 5a 46 80 00 00 	movabs $0x80465a,%rdx
  803e1b:	00 00 00 
  803e1e:	be 33 00 00 00       	mov    $0x33,%esi
  803e23:	48 bf 76 46 80 00 00 	movabs $0x804676,%rdi
  803e2a:	00 00 00 
  803e2d:	b8 00 00 00 00       	mov    $0x0,%eax
  803e32:	49 b8 ce 05 80 00 00 	movabs $0x8005ce,%r8
  803e39:	00 00 00 
  803e3c:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  803e3f:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803e42:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803e45:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803e49:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e4c:	89 c7                	mov    %eax,%edi
  803e4e:	48 b8 bf 1e 80 00 00 	movabs $0x801ebf,%rax
  803e55:	00 00 00 
  803e58:	ff d0                	callq  *%rax
  803e5a:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  803e5d:	48 b8 ad 1c 80 00 00 	movabs $0x801cad,%rax
  803e64:	00 00 00 
  803e67:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  803e69:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e6d:	75 9a                	jne    803e09 <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  803e6f:	c9                   	leaveq 
  803e70:	c3                   	retq   

0000000000803e71 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803e71:	55                   	push   %rbp
  803e72:	48 89 e5             	mov    %rsp,%rbp
  803e75:	48 83 ec 14          	sub    $0x14,%rsp
  803e79:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803e7c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803e83:	eb 5e                	jmp    803ee3 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803e85:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803e8c:	00 00 00 
  803e8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e92:	48 63 d0             	movslq %eax,%rdx
  803e95:	48 89 d0             	mov    %rdx,%rax
  803e98:	48 c1 e0 03          	shl    $0x3,%rax
  803e9c:	48 01 d0             	add    %rdx,%rax
  803e9f:	48 c1 e0 05          	shl    $0x5,%rax
  803ea3:	48 01 c8             	add    %rcx,%rax
  803ea6:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803eac:	8b 00                	mov    (%rax),%eax
  803eae:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803eb1:	75 2c                	jne    803edf <ipc_find_env+0x6e>
			return envs[i].env_id;
  803eb3:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803eba:	00 00 00 
  803ebd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ec0:	48 63 d0             	movslq %eax,%rdx
  803ec3:	48 89 d0             	mov    %rdx,%rax
  803ec6:	48 c1 e0 03          	shl    $0x3,%rax
  803eca:	48 01 d0             	add    %rdx,%rax
  803ecd:	48 c1 e0 05          	shl    $0x5,%rax
  803ed1:	48 01 c8             	add    %rcx,%rax
  803ed4:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803eda:	8b 40 08             	mov    0x8(%rax),%eax
  803edd:	eb 12                	jmp    803ef1 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803edf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803ee3:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803eea:	7e 99                	jle    803e85 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803eec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ef1:	c9                   	leaveq 
  803ef2:	c3                   	retq   

0000000000803ef3 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803ef3:	55                   	push   %rbp
  803ef4:	48 89 e5             	mov    %rsp,%rbp
  803ef7:	48 83 ec 18          	sub    $0x18,%rsp
  803efb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803eff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f03:	48 c1 e8 15          	shr    $0x15,%rax
  803f07:	48 89 c2             	mov    %rax,%rdx
  803f0a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803f11:	01 00 00 
  803f14:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f18:	83 e0 01             	and    $0x1,%eax
  803f1b:	48 85 c0             	test   %rax,%rax
  803f1e:	75 07                	jne    803f27 <pageref+0x34>
		return 0;
  803f20:	b8 00 00 00 00       	mov    $0x0,%eax
  803f25:	eb 53                	jmp    803f7a <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803f27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f2b:	48 c1 e8 0c          	shr    $0xc,%rax
  803f2f:	48 89 c2             	mov    %rax,%rdx
  803f32:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803f39:	01 00 00 
  803f3c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f40:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803f44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f48:	83 e0 01             	and    $0x1,%eax
  803f4b:	48 85 c0             	test   %rax,%rax
  803f4e:	75 07                	jne    803f57 <pageref+0x64>
		return 0;
  803f50:	b8 00 00 00 00       	mov    $0x0,%eax
  803f55:	eb 23                	jmp    803f7a <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803f57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f5b:	48 c1 e8 0c          	shr    $0xc,%rax
  803f5f:	48 89 c2             	mov    %rax,%rdx
  803f62:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803f69:	00 00 00 
  803f6c:	48 c1 e2 04          	shl    $0x4,%rdx
  803f70:	48 01 d0             	add    %rdx,%rax
  803f73:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803f77:	0f b7 c0             	movzwl %ax,%eax
}
  803f7a:	c9                   	leaveq 
  803f7b:	c3                   	retq   
