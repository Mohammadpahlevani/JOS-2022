
obj/user/echo:     file format elf64-x86-64


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
  80003c:	e8 11 01 00 00       	callq  800152 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i, nflag;

	nflag = 0;
  800052:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800059:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
  80005d:	7e 38                	jle    800097 <umain+0x54>
  80005f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800063:	48 83 c0 08          	add    $0x8,%rax
  800067:	48 8b 00             	mov    (%rax),%rax
  80006a:	48 be e0 35 80 00 00 	movabs $0x8035e0,%rsi
  800071:	00 00 00 
  800074:	48 89 c7             	mov    %rax,%rdi
  800077:	48 b8 d3 03 80 00 00 	movabs $0x8003d3,%rax
  80007e:	00 00 00 
  800081:	ff d0                	callq  *%rax
  800083:	85 c0                	test   %eax,%eax
  800085:	75 10                	jne    800097 <umain+0x54>
		nflag = 1;
  800087:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
		argc--;
  80008e:	83 6d ec 01          	subl   $0x1,-0x14(%rbp)
		argv++;
  800092:	48 83 45 e0 08       	addq   $0x8,-0x20(%rbp)
	}
	for (i = 1; i < argc; i++) {
  800097:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  80009e:	eb 7e                	jmp    80011e <umain+0xdb>
		if (i > 1)
  8000a0:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
  8000a4:	7e 20                	jle    8000c6 <umain+0x83>
			write(1, " ", 1);
  8000a6:	ba 01 00 00 00       	mov    $0x1,%edx
  8000ab:	48 be e3 35 80 00 00 	movabs $0x8035e3,%rsi
  8000b2:	00 00 00 
  8000b5:	bf 01 00 00 00       	mov    $0x1,%edi
  8000ba:	48 b8 6f 14 80 00 00 	movabs $0x80146f,%rax
  8000c1:	00 00 00 
  8000c4:	ff d0                	callq  *%rax
		write(1, argv[i], strlen(argv[i]));
  8000c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000c9:	48 98                	cltq   
  8000cb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8000d2:	00 
  8000d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000d7:	48 01 d0             	add    %rdx,%rax
  8000da:	48 8b 00             	mov    (%rax),%rax
  8000dd:	48 89 c7             	mov    %rax,%rdi
  8000e0:	48 b8 05 02 80 00 00 	movabs $0x800205,%rax
  8000e7:	00 00 00 
  8000ea:	ff d0                	callq  *%rax
  8000ec:	48 63 d0             	movslq %eax,%rdx
  8000ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000f2:	48 98                	cltq   
  8000f4:	48 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%rcx
  8000fb:	00 
  8000fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800100:	48 01 c8             	add    %rcx,%rax
  800103:	48 8b 00             	mov    (%rax),%rax
  800106:	48 89 c6             	mov    %rax,%rsi
  800109:	bf 01 00 00 00       	mov    $0x1,%edi
  80010e:	48 b8 6f 14 80 00 00 	movabs $0x80146f,%rax
  800115:	00 00 00 
  800118:	ff d0                	callq  *%rax
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
		nflag = 1;
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  80011a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80011e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800121:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  800124:	0f 8c 76 ff ff ff    	jl     8000a0 <umain+0x5d>
		if (i > 1)
			write(1, " ", 1);
		write(1, argv[i], strlen(argv[i]));
	}
	if (!nflag)
  80012a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80012e:	75 20                	jne    800150 <umain+0x10d>
		write(1, "\n", 1);
  800130:	ba 01 00 00 00       	mov    $0x1,%edx
  800135:	48 be e5 35 80 00 00 	movabs $0x8035e5,%rsi
  80013c:	00 00 00 
  80013f:	bf 01 00 00 00       	mov    $0x1,%edi
  800144:	48 b8 6f 14 80 00 00 	movabs $0x80146f,%rax
  80014b:	00 00 00 
  80014e:	ff d0                	callq  *%rax
}
  800150:	c9                   	leaveq 
  800151:	c3                   	retq   

0000000000800152 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800152:	55                   	push   %rbp
  800153:	48 89 e5             	mov    %rsp,%rbp
  800156:	48 83 ec 10          	sub    $0x10,%rsp
  80015a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80015d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  800161:	48 b8 24 0b 80 00 00 	movabs $0x800b24,%rax
  800168:	00 00 00 
  80016b:	ff d0                	callq  *%rax
  80016d:	48 98                	cltq   
  80016f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800174:	48 89 c2             	mov    %rax,%rdx
  800177:	48 89 d0             	mov    %rdx,%rax
  80017a:	48 c1 e0 03          	shl    $0x3,%rax
  80017e:	48 01 d0             	add    %rdx,%rax
  800181:	48 c1 e0 05          	shl    $0x5,%rax
  800185:	48 89 c2             	mov    %rax,%rdx
  800188:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80018f:	00 00 00 
  800192:	48 01 c2             	add    %rax,%rdx
  800195:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80019c:	00 00 00 
  80019f:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001a6:	7e 14                	jle    8001bc <libmain+0x6a>
		binaryname = argv[0];
  8001a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001ac:	48 8b 10             	mov    (%rax),%rdx
  8001af:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8001b6:	00 00 00 
  8001b9:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001bc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001c3:	48 89 d6             	mov    %rdx,%rsi
  8001c6:	89 c7                	mov    %eax,%edi
  8001c8:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001cf:	00 00 00 
  8001d2:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001d4:	48 b8 e2 01 80 00 00 	movabs $0x8001e2,%rax
  8001db:	00 00 00 
  8001de:	ff d0                	callq  *%rax
}
  8001e0:	c9                   	leaveq 
  8001e1:	c3                   	retq   

00000000008001e2 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001e2:	55                   	push   %rbp
  8001e3:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001e6:	48 b8 4e 11 80 00 00 	movabs $0x80114e,%rax
  8001ed:	00 00 00 
  8001f0:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f7:	48 b8 e0 0a 80 00 00 	movabs $0x800ae0,%rax
  8001fe:	00 00 00 
  800201:	ff d0                	callq  *%rax
}
  800203:	5d                   	pop    %rbp
  800204:	c3                   	retq   

0000000000800205 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800205:	55                   	push   %rbp
  800206:	48 89 e5             	mov    %rsp,%rbp
  800209:	48 83 ec 18          	sub    $0x18,%rsp
  80020d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800211:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800218:	eb 09                	jmp    800223 <strlen+0x1e>
		n++;
  80021a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80021e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800223:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800227:	0f b6 00             	movzbl (%rax),%eax
  80022a:	84 c0                	test   %al,%al
  80022c:	75 ec                	jne    80021a <strlen+0x15>
		n++;
	return n;
  80022e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800231:	c9                   	leaveq 
  800232:	c3                   	retq   

0000000000800233 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800233:	55                   	push   %rbp
  800234:	48 89 e5             	mov    %rsp,%rbp
  800237:	48 83 ec 20          	sub    $0x20,%rsp
  80023b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80023f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800243:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80024a:	eb 0e                	jmp    80025a <strnlen+0x27>
		n++;
  80024c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800250:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800255:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80025a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80025f:	74 0b                	je     80026c <strnlen+0x39>
  800261:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800265:	0f b6 00             	movzbl (%rax),%eax
  800268:	84 c0                	test   %al,%al
  80026a:	75 e0                	jne    80024c <strnlen+0x19>
		n++;
	return n;
  80026c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80026f:	c9                   	leaveq 
  800270:	c3                   	retq   

0000000000800271 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800271:	55                   	push   %rbp
  800272:	48 89 e5             	mov    %rsp,%rbp
  800275:	48 83 ec 20          	sub    $0x20,%rsp
  800279:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80027d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800281:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800285:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800289:	90                   	nop
  80028a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80028e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800292:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800296:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80029a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80029e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8002a2:	0f b6 12             	movzbl (%rdx),%edx
  8002a5:	88 10                	mov    %dl,(%rax)
  8002a7:	0f b6 00             	movzbl (%rax),%eax
  8002aa:	84 c0                	test   %al,%al
  8002ac:	75 dc                	jne    80028a <strcpy+0x19>
		/* do nothing */;
	return ret;
  8002ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8002b2:	c9                   	leaveq 
  8002b3:	c3                   	retq   

00000000008002b4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8002b4:	55                   	push   %rbp
  8002b5:	48 89 e5             	mov    %rsp,%rbp
  8002b8:	48 83 ec 20          	sub    $0x20,%rsp
  8002bc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8002c0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8002c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002c8:	48 89 c7             	mov    %rax,%rdi
  8002cb:	48 b8 05 02 80 00 00 	movabs $0x800205,%rax
  8002d2:	00 00 00 
  8002d5:	ff d0                	callq  *%rax
  8002d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8002da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002dd:	48 63 d0             	movslq %eax,%rdx
  8002e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002e4:	48 01 c2             	add    %rax,%rdx
  8002e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8002eb:	48 89 c6             	mov    %rax,%rsi
  8002ee:	48 89 d7             	mov    %rdx,%rdi
  8002f1:	48 b8 71 02 80 00 00 	movabs $0x800271,%rax
  8002f8:	00 00 00 
  8002fb:	ff d0                	callq  *%rax
	return dst;
  8002fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800301:	c9                   	leaveq 
  800302:	c3                   	retq   

0000000000800303 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800303:	55                   	push   %rbp
  800304:	48 89 e5             	mov    %rsp,%rbp
  800307:	48 83 ec 28          	sub    $0x28,%rsp
  80030b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80030f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800313:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800317:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80031b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80031f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800326:	00 
  800327:	eb 2a                	jmp    800353 <strncpy+0x50>
		*dst++ = *src;
  800329:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80032d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800331:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800335:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800339:	0f b6 12             	movzbl (%rdx),%edx
  80033c:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80033e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800342:	0f b6 00             	movzbl (%rax),%eax
  800345:	84 c0                	test   %al,%al
  800347:	74 05                	je     80034e <strncpy+0x4b>
			src++;
  800349:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80034e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800353:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800357:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80035b:	72 cc                	jb     800329 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80035d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800361:	c9                   	leaveq 
  800362:	c3                   	retq   

0000000000800363 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800363:	55                   	push   %rbp
  800364:	48 89 e5             	mov    %rsp,%rbp
  800367:	48 83 ec 28          	sub    $0x28,%rsp
  80036b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80036f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800373:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800377:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80037b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80037f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800384:	74 3d                	je     8003c3 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800386:	eb 1d                	jmp    8003a5 <strlcpy+0x42>
			*dst++ = *src++;
  800388:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80038c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800390:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800394:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800398:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80039c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8003a0:	0f b6 12             	movzbl (%rdx),%edx
  8003a3:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8003a5:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8003aa:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8003af:	74 0b                	je     8003bc <strlcpy+0x59>
  8003b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8003b5:	0f b6 00             	movzbl (%rax),%eax
  8003b8:	84 c0                	test   %al,%al
  8003ba:	75 cc                	jne    800388 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8003bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003c0:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8003c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8003c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003cb:	48 29 c2             	sub    %rax,%rdx
  8003ce:	48 89 d0             	mov    %rdx,%rax
}
  8003d1:	c9                   	leaveq 
  8003d2:	c3                   	retq   

00000000008003d3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8003d3:	55                   	push   %rbp
  8003d4:	48 89 e5             	mov    %rsp,%rbp
  8003d7:	48 83 ec 10          	sub    $0x10,%rsp
  8003db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8003df:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8003e3:	eb 0a                	jmp    8003ef <strcmp+0x1c>
		p++, q++;
  8003e5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8003ea:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8003ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003f3:	0f b6 00             	movzbl (%rax),%eax
  8003f6:	84 c0                	test   %al,%al
  8003f8:	74 12                	je     80040c <strcmp+0x39>
  8003fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003fe:	0f b6 10             	movzbl (%rax),%edx
  800401:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800405:	0f b6 00             	movzbl (%rax),%eax
  800408:	38 c2                	cmp    %al,%dl
  80040a:	74 d9                	je     8003e5 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80040c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800410:	0f b6 00             	movzbl (%rax),%eax
  800413:	0f b6 d0             	movzbl %al,%edx
  800416:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80041a:	0f b6 00             	movzbl (%rax),%eax
  80041d:	0f b6 c0             	movzbl %al,%eax
  800420:	29 c2                	sub    %eax,%edx
  800422:	89 d0                	mov    %edx,%eax
}
  800424:	c9                   	leaveq 
  800425:	c3                   	retq   

0000000000800426 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800426:	55                   	push   %rbp
  800427:	48 89 e5             	mov    %rsp,%rbp
  80042a:	48 83 ec 18          	sub    $0x18,%rsp
  80042e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800432:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800436:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80043a:	eb 0f                	jmp    80044b <strncmp+0x25>
		n--, p++, q++;
  80043c:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  800441:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800446:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80044b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800450:	74 1d                	je     80046f <strncmp+0x49>
  800452:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800456:	0f b6 00             	movzbl (%rax),%eax
  800459:	84 c0                	test   %al,%al
  80045b:	74 12                	je     80046f <strncmp+0x49>
  80045d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800461:	0f b6 10             	movzbl (%rax),%edx
  800464:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800468:	0f b6 00             	movzbl (%rax),%eax
  80046b:	38 c2                	cmp    %al,%dl
  80046d:	74 cd                	je     80043c <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80046f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800474:	75 07                	jne    80047d <strncmp+0x57>
		return 0;
  800476:	b8 00 00 00 00       	mov    $0x0,%eax
  80047b:	eb 18                	jmp    800495 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80047d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800481:	0f b6 00             	movzbl (%rax),%eax
  800484:	0f b6 d0             	movzbl %al,%edx
  800487:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80048b:	0f b6 00             	movzbl (%rax),%eax
  80048e:	0f b6 c0             	movzbl %al,%eax
  800491:	29 c2                	sub    %eax,%edx
  800493:	89 d0                	mov    %edx,%eax
}
  800495:	c9                   	leaveq 
  800496:	c3                   	retq   

0000000000800497 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800497:	55                   	push   %rbp
  800498:	48 89 e5             	mov    %rsp,%rbp
  80049b:	48 83 ec 0c          	sub    $0xc,%rsp
  80049f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004a3:	89 f0                	mov    %esi,%eax
  8004a5:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8004a8:	eb 17                	jmp    8004c1 <strchr+0x2a>
		if (*s == c)
  8004aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004ae:	0f b6 00             	movzbl (%rax),%eax
  8004b1:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8004b4:	75 06                	jne    8004bc <strchr+0x25>
			return (char *) s;
  8004b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004ba:	eb 15                	jmp    8004d1 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8004bc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004c5:	0f b6 00             	movzbl (%rax),%eax
  8004c8:	84 c0                	test   %al,%al
  8004ca:	75 de                	jne    8004aa <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8004cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004d1:	c9                   	leaveq 
  8004d2:	c3                   	retq   

00000000008004d3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8004d3:	55                   	push   %rbp
  8004d4:	48 89 e5             	mov    %rsp,%rbp
  8004d7:	48 83 ec 0c          	sub    $0xc,%rsp
  8004db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004df:	89 f0                	mov    %esi,%eax
  8004e1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8004e4:	eb 13                	jmp    8004f9 <strfind+0x26>
		if (*s == c)
  8004e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004ea:	0f b6 00             	movzbl (%rax),%eax
  8004ed:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8004f0:	75 02                	jne    8004f4 <strfind+0x21>
			break;
  8004f2:	eb 10                	jmp    800504 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8004f4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004fd:	0f b6 00             	movzbl (%rax),%eax
  800500:	84 c0                	test   %al,%al
  800502:	75 e2                	jne    8004e6 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  800504:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800508:	c9                   	leaveq 
  800509:	c3                   	retq   

000000000080050a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80050a:	55                   	push   %rbp
  80050b:	48 89 e5             	mov    %rsp,%rbp
  80050e:	48 83 ec 18          	sub    $0x18,%rsp
  800512:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800516:	89 75 f4             	mov    %esi,-0xc(%rbp)
  800519:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80051d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800522:	75 06                	jne    80052a <memset+0x20>
		return v;
  800524:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800528:	eb 69                	jmp    800593 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80052a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80052e:	83 e0 03             	and    $0x3,%eax
  800531:	48 85 c0             	test   %rax,%rax
  800534:	75 48                	jne    80057e <memset+0x74>
  800536:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80053a:	83 e0 03             	and    $0x3,%eax
  80053d:	48 85 c0             	test   %rax,%rax
  800540:	75 3c                	jne    80057e <memset+0x74>
		c &= 0xFF;
  800542:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800549:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80054c:	c1 e0 18             	shl    $0x18,%eax
  80054f:	89 c2                	mov    %eax,%edx
  800551:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800554:	c1 e0 10             	shl    $0x10,%eax
  800557:	09 c2                	or     %eax,%edx
  800559:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80055c:	c1 e0 08             	shl    $0x8,%eax
  80055f:	09 d0                	or     %edx,%eax
  800561:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  800564:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800568:	48 c1 e8 02          	shr    $0x2,%rax
  80056c:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80056f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800573:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800576:	48 89 d7             	mov    %rdx,%rdi
  800579:	fc                   	cld    
  80057a:	f3 ab                	rep stos %eax,%es:(%rdi)
  80057c:	eb 11                	jmp    80058f <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80057e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800582:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800585:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800589:	48 89 d7             	mov    %rdx,%rdi
  80058c:	fc                   	cld    
  80058d:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80058f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800593:	c9                   	leaveq 
  800594:	c3                   	retq   

0000000000800595 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800595:	55                   	push   %rbp
  800596:	48 89 e5             	mov    %rsp,%rbp
  800599:	48 83 ec 28          	sub    $0x28,%rsp
  80059d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005a1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8005a5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8005a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8005ad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8005b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8005b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005bd:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8005c1:	0f 83 88 00 00 00    	jae    80064f <memmove+0xba>
  8005c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005cb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8005cf:	48 01 d0             	add    %rdx,%rax
  8005d2:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8005d6:	76 77                	jbe    80064f <memmove+0xba>
		s += n;
  8005d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005dc:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8005e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005e4:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8005e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005ec:	83 e0 03             	and    $0x3,%eax
  8005ef:	48 85 c0             	test   %rax,%rax
  8005f2:	75 3b                	jne    80062f <memmove+0x9a>
  8005f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005f8:	83 e0 03             	and    $0x3,%eax
  8005fb:	48 85 c0             	test   %rax,%rax
  8005fe:	75 2f                	jne    80062f <memmove+0x9a>
  800600:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800604:	83 e0 03             	and    $0x3,%eax
  800607:	48 85 c0             	test   %rax,%rax
  80060a:	75 23                	jne    80062f <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80060c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800610:	48 83 e8 04          	sub    $0x4,%rax
  800614:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800618:	48 83 ea 04          	sub    $0x4,%rdx
  80061c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  800620:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800624:	48 89 c7             	mov    %rax,%rdi
  800627:	48 89 d6             	mov    %rdx,%rsi
  80062a:	fd                   	std    
  80062b:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80062d:	eb 1d                	jmp    80064c <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80062f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800633:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800637:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80063b:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80063f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800643:	48 89 d7             	mov    %rdx,%rdi
  800646:	48 89 c1             	mov    %rax,%rcx
  800649:	fd                   	std    
  80064a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80064c:	fc                   	cld    
  80064d:	eb 57                	jmp    8006a6 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80064f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800653:	83 e0 03             	and    $0x3,%eax
  800656:	48 85 c0             	test   %rax,%rax
  800659:	75 36                	jne    800691 <memmove+0xfc>
  80065b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80065f:	83 e0 03             	and    $0x3,%eax
  800662:	48 85 c0             	test   %rax,%rax
  800665:	75 2a                	jne    800691 <memmove+0xfc>
  800667:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80066b:	83 e0 03             	and    $0x3,%eax
  80066e:	48 85 c0             	test   %rax,%rax
  800671:	75 1e                	jne    800691 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800673:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800677:	48 c1 e8 02          	shr    $0x2,%rax
  80067b:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80067e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800682:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800686:	48 89 c7             	mov    %rax,%rdi
  800689:	48 89 d6             	mov    %rdx,%rsi
  80068c:	fc                   	cld    
  80068d:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80068f:	eb 15                	jmp    8006a6 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800691:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800695:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800699:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80069d:	48 89 c7             	mov    %rax,%rdi
  8006a0:	48 89 d6             	mov    %rdx,%rsi
  8006a3:	fc                   	cld    
  8006a4:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8006a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8006aa:	c9                   	leaveq 
  8006ab:	c3                   	retq   

00000000008006ac <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8006ac:	55                   	push   %rbp
  8006ad:	48 89 e5             	mov    %rsp,%rbp
  8006b0:	48 83 ec 18          	sub    $0x18,%rsp
  8006b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8006b8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8006bc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8006c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8006c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006cc:	48 89 ce             	mov    %rcx,%rsi
  8006cf:	48 89 c7             	mov    %rax,%rdi
  8006d2:	48 b8 95 05 80 00 00 	movabs $0x800595,%rax
  8006d9:	00 00 00 
  8006dc:	ff d0                	callq  *%rax
}
  8006de:	c9                   	leaveq 
  8006df:	c3                   	retq   

00000000008006e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8006e0:	55                   	push   %rbp
  8006e1:	48 89 e5             	mov    %rsp,%rbp
  8006e4:	48 83 ec 28          	sub    $0x28,%rsp
  8006e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006f0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8006f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8006fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800700:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  800704:	eb 36                	jmp    80073c <memcmp+0x5c>
		if (*s1 != *s2)
  800706:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80070a:	0f b6 10             	movzbl (%rax),%edx
  80070d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800711:	0f b6 00             	movzbl (%rax),%eax
  800714:	38 c2                	cmp    %al,%dl
  800716:	74 1a                	je     800732 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  800718:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80071c:	0f b6 00             	movzbl (%rax),%eax
  80071f:	0f b6 d0             	movzbl %al,%edx
  800722:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800726:	0f b6 00             	movzbl (%rax),%eax
  800729:	0f b6 c0             	movzbl %al,%eax
  80072c:	29 c2                	sub    %eax,%edx
  80072e:	89 d0                	mov    %edx,%eax
  800730:	eb 20                	jmp    800752 <memcmp+0x72>
		s1++, s2++;
  800732:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800737:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80073c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800740:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800744:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800748:	48 85 c0             	test   %rax,%rax
  80074b:	75 b9                	jne    800706 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80074d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800752:	c9                   	leaveq 
  800753:	c3                   	retq   

0000000000800754 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800754:	55                   	push   %rbp
  800755:	48 89 e5             	mov    %rsp,%rbp
  800758:	48 83 ec 28          	sub    $0x28,%rsp
  80075c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800760:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  800763:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  800767:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80076b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80076f:	48 01 d0             	add    %rdx,%rax
  800772:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  800776:	eb 15                	jmp    80078d <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  800778:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077c:	0f b6 10             	movzbl (%rax),%edx
  80077f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800782:	38 c2                	cmp    %al,%dl
  800784:	75 02                	jne    800788 <memfind+0x34>
			break;
  800786:	eb 0f                	jmp    800797 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800788:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80078d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800791:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  800795:	72 e1                	jb     800778 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  800797:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80079b:	c9                   	leaveq 
  80079c:	c3                   	retq   

000000000080079d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80079d:	55                   	push   %rbp
  80079e:	48 89 e5             	mov    %rsp,%rbp
  8007a1:	48 83 ec 34          	sub    $0x34,%rsp
  8007a5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8007a9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8007ad:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8007b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8007b7:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8007be:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8007bf:	eb 05                	jmp    8007c6 <strtol+0x29>
		s++;
  8007c1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8007c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007ca:	0f b6 00             	movzbl (%rax),%eax
  8007cd:	3c 20                	cmp    $0x20,%al
  8007cf:	74 f0                	je     8007c1 <strtol+0x24>
  8007d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007d5:	0f b6 00             	movzbl (%rax),%eax
  8007d8:	3c 09                	cmp    $0x9,%al
  8007da:	74 e5                	je     8007c1 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8007dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007e0:	0f b6 00             	movzbl (%rax),%eax
  8007e3:	3c 2b                	cmp    $0x2b,%al
  8007e5:	75 07                	jne    8007ee <strtol+0x51>
		s++;
  8007e7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8007ec:	eb 17                	jmp    800805 <strtol+0x68>
	else if (*s == '-')
  8007ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007f2:	0f b6 00             	movzbl (%rax),%eax
  8007f5:	3c 2d                	cmp    $0x2d,%al
  8007f7:	75 0c                	jne    800805 <strtol+0x68>
		s++, neg = 1;
  8007f9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8007fe:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800805:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  800809:	74 06                	je     800811 <strtol+0x74>
  80080b:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80080f:	75 28                	jne    800839 <strtol+0x9c>
  800811:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800815:	0f b6 00             	movzbl (%rax),%eax
  800818:	3c 30                	cmp    $0x30,%al
  80081a:	75 1d                	jne    800839 <strtol+0x9c>
  80081c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800820:	48 83 c0 01          	add    $0x1,%rax
  800824:	0f b6 00             	movzbl (%rax),%eax
  800827:	3c 78                	cmp    $0x78,%al
  800829:	75 0e                	jne    800839 <strtol+0x9c>
		s += 2, base = 16;
  80082b:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  800830:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  800837:	eb 2c                	jmp    800865 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  800839:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80083d:	75 19                	jne    800858 <strtol+0xbb>
  80083f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800843:	0f b6 00             	movzbl (%rax),%eax
  800846:	3c 30                	cmp    $0x30,%al
  800848:	75 0e                	jne    800858 <strtol+0xbb>
		s++, base = 8;
  80084a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80084f:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  800856:	eb 0d                	jmp    800865 <strtol+0xc8>
	else if (base == 0)
  800858:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80085c:	75 07                	jne    800865 <strtol+0xc8>
		base = 10;
  80085e:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800865:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800869:	0f b6 00             	movzbl (%rax),%eax
  80086c:	3c 2f                	cmp    $0x2f,%al
  80086e:	7e 1d                	jle    80088d <strtol+0xf0>
  800870:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800874:	0f b6 00             	movzbl (%rax),%eax
  800877:	3c 39                	cmp    $0x39,%al
  800879:	7f 12                	jg     80088d <strtol+0xf0>
			dig = *s - '0';
  80087b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80087f:	0f b6 00             	movzbl (%rax),%eax
  800882:	0f be c0             	movsbl %al,%eax
  800885:	83 e8 30             	sub    $0x30,%eax
  800888:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80088b:	eb 4e                	jmp    8008db <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80088d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800891:	0f b6 00             	movzbl (%rax),%eax
  800894:	3c 60                	cmp    $0x60,%al
  800896:	7e 1d                	jle    8008b5 <strtol+0x118>
  800898:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80089c:	0f b6 00             	movzbl (%rax),%eax
  80089f:	3c 7a                	cmp    $0x7a,%al
  8008a1:	7f 12                	jg     8008b5 <strtol+0x118>
			dig = *s - 'a' + 10;
  8008a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008a7:	0f b6 00             	movzbl (%rax),%eax
  8008aa:	0f be c0             	movsbl %al,%eax
  8008ad:	83 e8 57             	sub    $0x57,%eax
  8008b0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8008b3:	eb 26                	jmp    8008db <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8008b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008b9:	0f b6 00             	movzbl (%rax),%eax
  8008bc:	3c 40                	cmp    $0x40,%al
  8008be:	7e 48                	jle    800908 <strtol+0x16b>
  8008c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008c4:	0f b6 00             	movzbl (%rax),%eax
  8008c7:	3c 5a                	cmp    $0x5a,%al
  8008c9:	7f 3d                	jg     800908 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8008cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008cf:	0f b6 00             	movzbl (%rax),%eax
  8008d2:	0f be c0             	movsbl %al,%eax
  8008d5:	83 e8 37             	sub    $0x37,%eax
  8008d8:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8008db:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8008de:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8008e1:	7c 02                	jl     8008e5 <strtol+0x148>
			break;
  8008e3:	eb 23                	jmp    800908 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8008e5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8008ea:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8008ed:	48 98                	cltq   
  8008ef:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8008f4:	48 89 c2             	mov    %rax,%rdx
  8008f7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8008fa:	48 98                	cltq   
  8008fc:	48 01 d0             	add    %rdx,%rax
  8008ff:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  800903:	e9 5d ff ff ff       	jmpq   800865 <strtol+0xc8>

	if (endptr)
  800908:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80090d:	74 0b                	je     80091a <strtol+0x17d>
		*endptr = (char *) s;
  80090f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800913:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800917:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80091a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80091e:	74 09                	je     800929 <strtol+0x18c>
  800920:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800924:	48 f7 d8             	neg    %rax
  800927:	eb 04                	jmp    80092d <strtol+0x190>
  800929:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80092d:	c9                   	leaveq 
  80092e:	c3                   	retq   

000000000080092f <strstr>:

char * strstr(const char *in, const char *str)
{
  80092f:	55                   	push   %rbp
  800930:	48 89 e5             	mov    %rsp,%rbp
  800933:	48 83 ec 30          	sub    $0x30,%rsp
  800937:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80093b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80093f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800943:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800947:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80094b:	0f b6 00             	movzbl (%rax),%eax
  80094e:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  800951:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  800955:	75 06                	jne    80095d <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  800957:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80095b:	eb 6b                	jmp    8009c8 <strstr+0x99>

	len = strlen(str);
  80095d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800961:	48 89 c7             	mov    %rax,%rdi
  800964:	48 b8 05 02 80 00 00 	movabs $0x800205,%rax
  80096b:	00 00 00 
  80096e:	ff d0                	callq  *%rax
  800970:	48 98                	cltq   
  800972:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  800976:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80097a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80097e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800982:	0f b6 00             	movzbl (%rax),%eax
  800985:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  800988:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80098c:	75 07                	jne    800995 <strstr+0x66>
				return (char *) 0;
  80098e:	b8 00 00 00 00       	mov    $0x0,%eax
  800993:	eb 33                	jmp    8009c8 <strstr+0x99>
		} while (sc != c);
  800995:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  800999:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80099c:	75 d8                	jne    800976 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80099e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8009a2:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8009a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009aa:	48 89 ce             	mov    %rcx,%rsi
  8009ad:	48 89 c7             	mov    %rax,%rdi
  8009b0:	48 b8 26 04 80 00 00 	movabs $0x800426,%rax
  8009b7:	00 00 00 
  8009ba:	ff d0                	callq  *%rax
  8009bc:	85 c0                	test   %eax,%eax
  8009be:	75 b6                	jne    800976 <strstr+0x47>

	return (char *) (in - 1);
  8009c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009c4:	48 83 e8 01          	sub    $0x1,%rax
}
  8009c8:	c9                   	leaveq 
  8009c9:	c3                   	retq   

00000000008009ca <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8009ca:	55                   	push   %rbp
  8009cb:	48 89 e5             	mov    %rsp,%rbp
  8009ce:	53                   	push   %rbx
  8009cf:	48 83 ec 48          	sub    $0x48,%rsp
  8009d3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8009d6:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8009d9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8009dd:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8009e1:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8009e5:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  8009e9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8009ec:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8009f0:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8009f4:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8009f8:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8009fc:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800a00:	4c 89 c3             	mov    %r8,%rbx
  800a03:	cd 30                	int    $0x30
  800a05:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  800a09:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a0d:	74 3e                	je     800a4d <syscall+0x83>
  800a0f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800a14:	7e 37                	jle    800a4d <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800a16:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a1a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800a1d:	49 89 d0             	mov    %rdx,%r8
  800a20:	89 c1                	mov    %eax,%ecx
  800a22:	48 ba f1 35 80 00 00 	movabs $0x8035f1,%rdx
  800a29:	00 00 00 
  800a2c:	be 4a 00 00 00       	mov    $0x4a,%esi
  800a31:	48 bf 0e 36 80 00 00 	movabs $0x80360e,%rdi
  800a38:	00 00 00 
  800a3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800a40:	49 b9 da 25 80 00 00 	movabs $0x8025da,%r9
  800a47:	00 00 00 
  800a4a:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  800a4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800a51:	48 83 c4 48          	add    $0x48,%rsp
  800a55:	5b                   	pop    %rbx
  800a56:	5d                   	pop    %rbp
  800a57:	c3                   	retq   

0000000000800a58 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800a58:	55                   	push   %rbp
  800a59:	48 89 e5             	mov    %rsp,%rbp
  800a5c:	48 83 ec 20          	sub    $0x20,%rsp
  800a60:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800a64:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  800a68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800a6c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a70:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800a77:	00 
  800a78:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800a7e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800a84:	48 89 d1             	mov    %rdx,%rcx
  800a87:	48 89 c2             	mov    %rax,%rdx
  800a8a:	be 00 00 00 00       	mov    $0x0,%esi
  800a8f:	bf 00 00 00 00       	mov    $0x0,%edi
  800a94:	48 b8 ca 09 80 00 00 	movabs $0x8009ca,%rax
  800a9b:	00 00 00 
  800a9e:	ff d0                	callq  *%rax
}
  800aa0:	c9                   	leaveq 
  800aa1:	c3                   	retq   

0000000000800aa2 <sys_cgetc>:

int
sys_cgetc(void)
{
  800aa2:	55                   	push   %rbp
  800aa3:	48 89 e5             	mov    %rsp,%rbp
  800aa6:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800aaa:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800ab1:	00 
  800ab2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800ab8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800abe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ac3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac8:	be 00 00 00 00       	mov    $0x0,%esi
  800acd:	bf 01 00 00 00       	mov    $0x1,%edi
  800ad2:	48 b8 ca 09 80 00 00 	movabs $0x8009ca,%rax
  800ad9:	00 00 00 
  800adc:	ff d0                	callq  *%rax
}
  800ade:	c9                   	leaveq 
  800adf:	c3                   	retq   

0000000000800ae0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ae0:	55                   	push   %rbp
  800ae1:	48 89 e5             	mov    %rsp,%rbp
  800ae4:	48 83 ec 10          	sub    $0x10,%rsp
  800ae8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800aeb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800aee:	48 98                	cltq   
  800af0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800af7:	00 
  800af8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800afe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800b04:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b09:	48 89 c2             	mov    %rax,%rdx
  800b0c:	be 01 00 00 00       	mov    $0x1,%esi
  800b11:	bf 03 00 00 00       	mov    $0x3,%edi
  800b16:	48 b8 ca 09 80 00 00 	movabs $0x8009ca,%rax
  800b1d:	00 00 00 
  800b20:	ff d0                	callq  *%rax
}
  800b22:	c9                   	leaveq 
  800b23:	c3                   	retq   

0000000000800b24 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b24:	55                   	push   %rbp
  800b25:	48 89 e5             	mov    %rsp,%rbp
  800b28:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800b2c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800b33:	00 
  800b34:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800b3a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800b40:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b45:	ba 00 00 00 00       	mov    $0x0,%edx
  800b4a:	be 00 00 00 00       	mov    $0x0,%esi
  800b4f:	bf 02 00 00 00       	mov    $0x2,%edi
  800b54:	48 b8 ca 09 80 00 00 	movabs $0x8009ca,%rax
  800b5b:	00 00 00 
  800b5e:	ff d0                	callq  *%rax
}
  800b60:	c9                   	leaveq 
  800b61:	c3                   	retq   

0000000000800b62 <sys_yield>:

void
sys_yield(void)
{
  800b62:	55                   	push   %rbp
  800b63:	48 89 e5             	mov    %rsp,%rbp
  800b66:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800b6a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800b71:	00 
  800b72:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800b78:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800b7e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b83:	ba 00 00 00 00       	mov    $0x0,%edx
  800b88:	be 00 00 00 00       	mov    $0x0,%esi
  800b8d:	bf 0b 00 00 00       	mov    $0xb,%edi
  800b92:	48 b8 ca 09 80 00 00 	movabs $0x8009ca,%rax
  800b99:	00 00 00 
  800b9c:	ff d0                	callq  *%rax
}
  800b9e:	c9                   	leaveq 
  800b9f:	c3                   	retq   

0000000000800ba0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ba0:	55                   	push   %rbp
  800ba1:	48 89 e5             	mov    %rsp,%rbp
  800ba4:	48 83 ec 20          	sub    $0x20,%rsp
  800ba8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800baf:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800bb2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800bb5:	48 63 c8             	movslq %eax,%rcx
  800bb8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800bbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800bbf:	48 98                	cltq   
  800bc1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800bc8:	00 
  800bc9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800bcf:	49 89 c8             	mov    %rcx,%r8
  800bd2:	48 89 d1             	mov    %rdx,%rcx
  800bd5:	48 89 c2             	mov    %rax,%rdx
  800bd8:	be 01 00 00 00       	mov    $0x1,%esi
  800bdd:	bf 04 00 00 00       	mov    $0x4,%edi
  800be2:	48 b8 ca 09 80 00 00 	movabs $0x8009ca,%rax
  800be9:	00 00 00 
  800bec:	ff d0                	callq  *%rax
}
  800bee:	c9                   	leaveq 
  800bef:	c3                   	retq   

0000000000800bf0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bf0:	55                   	push   %rbp
  800bf1:	48 89 e5             	mov    %rsp,%rbp
  800bf4:	48 83 ec 30          	sub    $0x30,%rsp
  800bf8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bfb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800bff:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800c02:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800c06:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800c0a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800c0d:	48 63 c8             	movslq %eax,%rcx
  800c10:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800c14:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c17:	48 63 f0             	movslq %eax,%rsi
  800c1a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c21:	48 98                	cltq   
  800c23:	48 89 0c 24          	mov    %rcx,(%rsp)
  800c27:	49 89 f9             	mov    %rdi,%r9
  800c2a:	49 89 f0             	mov    %rsi,%r8
  800c2d:	48 89 d1             	mov    %rdx,%rcx
  800c30:	48 89 c2             	mov    %rax,%rdx
  800c33:	be 01 00 00 00       	mov    $0x1,%esi
  800c38:	bf 05 00 00 00       	mov    $0x5,%edi
  800c3d:	48 b8 ca 09 80 00 00 	movabs $0x8009ca,%rax
  800c44:	00 00 00 
  800c47:	ff d0                	callq  *%rax
}
  800c49:	c9                   	leaveq 
  800c4a:	c3                   	retq   

0000000000800c4b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c4b:	55                   	push   %rbp
  800c4c:	48 89 e5             	mov    %rsp,%rbp
  800c4f:	48 83 ec 20          	sub    $0x20,%rsp
  800c53:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c56:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  800c5a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c61:	48 98                	cltq   
  800c63:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800c6a:	00 
  800c6b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800c71:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800c77:	48 89 d1             	mov    %rdx,%rcx
  800c7a:	48 89 c2             	mov    %rax,%rdx
  800c7d:	be 01 00 00 00       	mov    $0x1,%esi
  800c82:	bf 06 00 00 00       	mov    $0x6,%edi
  800c87:	48 b8 ca 09 80 00 00 	movabs $0x8009ca,%rax
  800c8e:	00 00 00 
  800c91:	ff d0                	callq  *%rax
}
  800c93:	c9                   	leaveq 
  800c94:	c3                   	retq   

0000000000800c95 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c95:	55                   	push   %rbp
  800c96:	48 89 e5             	mov    %rsp,%rbp
  800c99:	48 83 ec 10          	sub    $0x10,%rsp
  800c9d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ca0:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800ca3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800ca6:	48 63 d0             	movslq %eax,%rdx
  800ca9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cac:	48 98                	cltq   
  800cae:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800cb5:	00 
  800cb6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800cbc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800cc2:	48 89 d1             	mov    %rdx,%rcx
  800cc5:	48 89 c2             	mov    %rax,%rdx
  800cc8:	be 01 00 00 00       	mov    $0x1,%esi
  800ccd:	bf 08 00 00 00       	mov    $0x8,%edi
  800cd2:	48 b8 ca 09 80 00 00 	movabs $0x8009ca,%rax
  800cd9:	00 00 00 
  800cdc:	ff d0                	callq  *%rax
}
  800cde:	c9                   	leaveq 
  800cdf:	c3                   	retq   

0000000000800ce0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ce0:	55                   	push   %rbp
  800ce1:	48 89 e5             	mov    %rsp,%rbp
  800ce4:	48 83 ec 20          	sub    $0x20,%rsp
  800ce8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ceb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  800cef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cf3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cf6:	48 98                	cltq   
  800cf8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800cff:	00 
  800d00:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800d06:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800d0c:	48 89 d1             	mov    %rdx,%rcx
  800d0f:	48 89 c2             	mov    %rax,%rdx
  800d12:	be 01 00 00 00       	mov    $0x1,%esi
  800d17:	bf 09 00 00 00       	mov    $0x9,%edi
  800d1c:	48 b8 ca 09 80 00 00 	movabs $0x8009ca,%rax
  800d23:	00 00 00 
  800d26:	ff d0                	callq  *%rax
}
  800d28:	c9                   	leaveq 
  800d29:	c3                   	retq   

0000000000800d2a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d2a:	55                   	push   %rbp
  800d2b:	48 89 e5             	mov    %rsp,%rbp
  800d2e:	48 83 ec 20          	sub    $0x20,%rsp
  800d32:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d35:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800d39:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d40:	48 98                	cltq   
  800d42:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800d49:	00 
  800d4a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800d50:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800d56:	48 89 d1             	mov    %rdx,%rcx
  800d59:	48 89 c2             	mov    %rax,%rdx
  800d5c:	be 01 00 00 00       	mov    $0x1,%esi
  800d61:	bf 0a 00 00 00       	mov    $0xa,%edi
  800d66:	48 b8 ca 09 80 00 00 	movabs $0x8009ca,%rax
  800d6d:	00 00 00 
  800d70:	ff d0                	callq  *%rax
}
  800d72:	c9                   	leaveq 
  800d73:	c3                   	retq   

0000000000800d74 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  800d74:	55                   	push   %rbp
  800d75:	48 89 e5             	mov    %rsp,%rbp
  800d78:	48 83 ec 20          	sub    $0x20,%rsp
  800d7c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d7f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800d83:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800d87:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  800d8a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800d8d:	48 63 f0             	movslq %eax,%rsi
  800d90:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800d94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d97:	48 98                	cltq   
  800d99:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d9d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800da4:	00 
  800da5:	49 89 f1             	mov    %rsi,%r9
  800da8:	49 89 c8             	mov    %rcx,%r8
  800dab:	48 89 d1             	mov    %rdx,%rcx
  800dae:	48 89 c2             	mov    %rax,%rdx
  800db1:	be 00 00 00 00       	mov    $0x0,%esi
  800db6:	bf 0c 00 00 00       	mov    $0xc,%edi
  800dbb:	48 b8 ca 09 80 00 00 	movabs $0x8009ca,%rax
  800dc2:	00 00 00 
  800dc5:	ff d0                	callq  *%rax
}
  800dc7:	c9                   	leaveq 
  800dc8:	c3                   	retq   

0000000000800dc9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dc9:	55                   	push   %rbp
  800dca:	48 89 e5             	mov    %rsp,%rbp
  800dcd:	48 83 ec 10          	sub    $0x10,%rsp
  800dd1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800dd5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800dd9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800de0:	00 
  800de1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800de7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800ded:	b9 00 00 00 00       	mov    $0x0,%ecx
  800df2:	48 89 c2             	mov    %rax,%rdx
  800df5:	be 01 00 00 00       	mov    $0x1,%esi
  800dfa:	bf 0d 00 00 00       	mov    $0xd,%edi
  800dff:	48 b8 ca 09 80 00 00 	movabs $0x8009ca,%rax
  800e06:	00 00 00 
  800e09:	ff d0                	callq  *%rax
}
  800e0b:	c9                   	leaveq 
  800e0c:	c3                   	retq   

0000000000800e0d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  800e0d:	55                   	push   %rbp
  800e0e:	48 89 e5             	mov    %rsp,%rbp
  800e11:	48 83 ec 08          	sub    $0x8,%rsp
  800e15:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e19:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800e1d:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800e24:	ff ff ff 
  800e27:	48 01 d0             	add    %rdx,%rax
  800e2a:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800e2e:	c9                   	leaveq 
  800e2f:	c3                   	retq   

0000000000800e30 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e30:	55                   	push   %rbp
  800e31:	48 89 e5             	mov    %rsp,%rbp
  800e34:	48 83 ec 08          	sub    $0x8,%rsp
  800e38:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  800e3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800e40:	48 89 c7             	mov    %rax,%rdi
  800e43:	48 b8 0d 0e 80 00 00 	movabs $0x800e0d,%rax
  800e4a:	00 00 00 
  800e4d:	ff d0                	callq  *%rax
  800e4f:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  800e55:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800e59:	c9                   	leaveq 
  800e5a:	c3                   	retq   

0000000000800e5b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e5b:	55                   	push   %rbp
  800e5c:	48 89 e5             	mov    %rsp,%rbp
  800e5f:	48 83 ec 18          	sub    $0x18,%rsp
  800e63:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800e67:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e6e:	eb 6b                	jmp    800edb <fd_alloc+0x80>
		fd = INDEX2FD(i);
  800e70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e73:	48 98                	cltq   
  800e75:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800e7b:	48 c1 e0 0c          	shl    $0xc,%rax
  800e7f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e87:	48 c1 e8 15          	shr    $0x15,%rax
  800e8b:	48 89 c2             	mov    %rax,%rdx
  800e8e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800e95:	01 00 00 
  800e98:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800e9c:	83 e0 01             	and    $0x1,%eax
  800e9f:	48 85 c0             	test   %rax,%rax
  800ea2:	74 21                	je     800ec5 <fd_alloc+0x6a>
  800ea4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ea8:	48 c1 e8 0c          	shr    $0xc,%rax
  800eac:	48 89 c2             	mov    %rax,%rdx
  800eaf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800eb6:	01 00 00 
  800eb9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800ebd:	83 e0 01             	and    $0x1,%eax
  800ec0:	48 85 c0             	test   %rax,%rax
  800ec3:	75 12                	jne    800ed7 <fd_alloc+0x7c>
			*fd_store = fd;
  800ec5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ecd:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800ed0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed5:	eb 1a                	jmp    800ef1 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800ed7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800edb:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800edf:	7e 8f                	jle    800e70 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800ee1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee5:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  800eec:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  800ef1:	c9                   	leaveq 
  800ef2:	c3                   	retq   

0000000000800ef3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800ef3:	55                   	push   %rbp
  800ef4:	48 89 e5             	mov    %rsp,%rbp
  800ef7:	48 83 ec 20          	sub    $0x20,%rsp
  800efb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800efe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f02:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800f06:	78 06                	js     800f0e <fd_lookup+0x1b>
  800f08:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  800f0c:	7e 07                	jle    800f15 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800f0e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f13:	eb 6c                	jmp    800f81 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  800f15:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800f18:	48 98                	cltq   
  800f1a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800f20:	48 c1 e0 0c          	shl    $0xc,%rax
  800f24:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f2c:	48 c1 e8 15          	shr    $0x15,%rax
  800f30:	48 89 c2             	mov    %rax,%rdx
  800f33:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800f3a:	01 00 00 
  800f3d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800f41:	83 e0 01             	and    $0x1,%eax
  800f44:	48 85 c0             	test   %rax,%rax
  800f47:	74 21                	je     800f6a <fd_lookup+0x77>
  800f49:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f4d:	48 c1 e8 0c          	shr    $0xc,%rax
  800f51:	48 89 c2             	mov    %rax,%rdx
  800f54:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800f5b:	01 00 00 
  800f5e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800f62:	83 e0 01             	and    $0x1,%eax
  800f65:	48 85 c0             	test   %rax,%rax
  800f68:	75 07                	jne    800f71 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800f6a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f6f:	eb 10                	jmp    800f81 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  800f71:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f75:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800f79:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  800f7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f81:	c9                   	leaveq 
  800f82:	c3                   	retq   

0000000000800f83 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800f83:	55                   	push   %rbp
  800f84:	48 89 e5             	mov    %rsp,%rbp
  800f87:	48 83 ec 30          	sub    $0x30,%rsp
  800f8b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  800f8f:	89 f0                	mov    %esi,%eax
  800f91:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f94:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800f98:	48 89 c7             	mov    %rax,%rdi
  800f9b:	48 b8 0d 0e 80 00 00 	movabs $0x800e0d,%rax
  800fa2:	00 00 00 
  800fa5:	ff d0                	callq  *%rax
  800fa7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800fab:	48 89 d6             	mov    %rdx,%rsi
  800fae:	89 c7                	mov    %eax,%edi
  800fb0:	48 b8 f3 0e 80 00 00 	movabs $0x800ef3,%rax
  800fb7:	00 00 00 
  800fba:	ff d0                	callq  *%rax
  800fbc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fbf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fc3:	78 0a                	js     800fcf <fd_close+0x4c>
	    || fd != fd2)
  800fc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fc9:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  800fcd:	74 12                	je     800fe1 <fd_close+0x5e>
		return (must_exist ? r : 0);
  800fcf:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  800fd3:	74 05                	je     800fda <fd_close+0x57>
  800fd5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fd8:	eb 05                	jmp    800fdf <fd_close+0x5c>
  800fda:	b8 00 00 00 00       	mov    $0x0,%eax
  800fdf:	eb 69                	jmp    80104a <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800fe1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800fe5:	8b 00                	mov    (%rax),%eax
  800fe7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800feb:	48 89 d6             	mov    %rdx,%rsi
  800fee:	89 c7                	mov    %eax,%edi
  800ff0:	48 b8 4c 10 80 00 00 	movabs $0x80104c,%rax
  800ff7:	00 00 00 
  800ffa:	ff d0                	callq  *%rax
  800ffc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801003:	78 2a                	js     80102f <fd_close+0xac>
		if (dev->dev_close)
  801005:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801009:	48 8b 40 20          	mov    0x20(%rax),%rax
  80100d:	48 85 c0             	test   %rax,%rax
  801010:	74 16                	je     801028 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801012:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801016:	48 8b 40 20          	mov    0x20(%rax),%rax
  80101a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80101e:	48 89 d7             	mov    %rdx,%rdi
  801021:	ff d0                	callq  *%rax
  801023:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801026:	eb 07                	jmp    80102f <fd_close+0xac>
		else
			r = 0;
  801028:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80102f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801033:	48 89 c6             	mov    %rax,%rsi
  801036:	bf 00 00 00 00       	mov    $0x0,%edi
  80103b:	48 b8 4b 0c 80 00 00 	movabs $0x800c4b,%rax
  801042:	00 00 00 
  801045:	ff d0                	callq  *%rax
	return r;
  801047:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80104a:	c9                   	leaveq 
  80104b:	c3                   	retq   

000000000080104c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80104c:	55                   	push   %rbp
  80104d:	48 89 e5             	mov    %rsp,%rbp
  801050:	48 83 ec 20          	sub    $0x20,%rsp
  801054:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801057:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80105b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801062:	eb 41                	jmp    8010a5 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801064:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  80106b:	00 00 00 
  80106e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801071:	48 63 d2             	movslq %edx,%rdx
  801074:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801078:	8b 00                	mov    (%rax),%eax
  80107a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80107d:	75 22                	jne    8010a1 <dev_lookup+0x55>
			*dev = devtab[i];
  80107f:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801086:	00 00 00 
  801089:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80108c:	48 63 d2             	movslq %edx,%rdx
  80108f:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801093:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801097:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80109a:	b8 00 00 00 00       	mov    $0x0,%eax
  80109f:	eb 60                	jmp    801101 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8010a1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8010a5:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8010ac:	00 00 00 
  8010af:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8010b2:	48 63 d2             	movslq %edx,%rdx
  8010b5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8010b9:	48 85 c0             	test   %rax,%rax
  8010bc:	75 a6                	jne    801064 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010be:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8010c5:	00 00 00 
  8010c8:	48 8b 00             	mov    (%rax),%rax
  8010cb:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8010d1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8010d4:	89 c6                	mov    %eax,%esi
  8010d6:	48 bf 20 36 80 00 00 	movabs $0x803620,%rdi
  8010dd:	00 00 00 
  8010e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8010e5:	48 b9 13 28 80 00 00 	movabs $0x802813,%rcx
  8010ec:	00 00 00 
  8010ef:	ff d1                	callq  *%rcx
	*dev = 0;
  8010f1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010f5:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8010fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801101:	c9                   	leaveq 
  801102:	c3                   	retq   

0000000000801103 <close>:

int
close(int fdnum)
{
  801103:	55                   	push   %rbp
  801104:	48 89 e5             	mov    %rsp,%rbp
  801107:	48 83 ec 20          	sub    $0x20,%rsp
  80110b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80110e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801112:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801115:	48 89 d6             	mov    %rdx,%rsi
  801118:	89 c7                	mov    %eax,%edi
  80111a:	48 b8 f3 0e 80 00 00 	movabs $0x800ef3,%rax
  801121:	00 00 00 
  801124:	ff d0                	callq  *%rax
  801126:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801129:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80112d:	79 05                	jns    801134 <close+0x31>
		return r;
  80112f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801132:	eb 18                	jmp    80114c <close+0x49>
	else
		return fd_close(fd, 1);
  801134:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801138:	be 01 00 00 00       	mov    $0x1,%esi
  80113d:	48 89 c7             	mov    %rax,%rdi
  801140:	48 b8 83 0f 80 00 00 	movabs $0x800f83,%rax
  801147:	00 00 00 
  80114a:	ff d0                	callq  *%rax
}
  80114c:	c9                   	leaveq 
  80114d:	c3                   	retq   

000000000080114e <close_all>:

void
close_all(void)
{
  80114e:	55                   	push   %rbp
  80114f:	48 89 e5             	mov    %rsp,%rbp
  801152:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801156:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80115d:	eb 15                	jmp    801174 <close_all+0x26>
		close(i);
  80115f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801162:	89 c7                	mov    %eax,%edi
  801164:	48 b8 03 11 80 00 00 	movabs $0x801103,%rax
  80116b:	00 00 00 
  80116e:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801170:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801174:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801178:	7e e5                	jle    80115f <close_all+0x11>
		close(i);
}
  80117a:	c9                   	leaveq 
  80117b:	c3                   	retq   

000000000080117c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80117c:	55                   	push   %rbp
  80117d:	48 89 e5             	mov    %rsp,%rbp
  801180:	48 83 ec 40          	sub    $0x40,%rsp
  801184:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801187:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80118a:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80118e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801191:	48 89 d6             	mov    %rdx,%rsi
  801194:	89 c7                	mov    %eax,%edi
  801196:	48 b8 f3 0e 80 00 00 	movabs $0x800ef3,%rax
  80119d:	00 00 00 
  8011a0:	ff d0                	callq  *%rax
  8011a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8011a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8011a9:	79 08                	jns    8011b3 <dup+0x37>
		return r;
  8011ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011ae:	e9 70 01 00 00       	jmpq   801323 <dup+0x1a7>
	close(newfdnum);
  8011b3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8011b6:	89 c7                	mov    %eax,%edi
  8011b8:	48 b8 03 11 80 00 00 	movabs $0x801103,%rax
  8011bf:	00 00 00 
  8011c2:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8011c4:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8011c7:	48 98                	cltq   
  8011c9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8011cf:	48 c1 e0 0c          	shl    $0xc,%rax
  8011d3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8011d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011db:	48 89 c7             	mov    %rax,%rdi
  8011de:	48 b8 30 0e 80 00 00 	movabs $0x800e30,%rax
  8011e5:	00 00 00 
  8011e8:	ff d0                	callq  *%rax
  8011ea:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8011ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f2:	48 89 c7             	mov    %rax,%rdi
  8011f5:	48 b8 30 0e 80 00 00 	movabs $0x800e30,%rax
  8011fc:	00 00 00 
  8011ff:	ff d0                	callq  *%rax
  801201:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801205:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801209:	48 c1 e8 15          	shr    $0x15,%rax
  80120d:	48 89 c2             	mov    %rax,%rdx
  801210:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801217:	01 00 00 
  80121a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80121e:	83 e0 01             	and    $0x1,%eax
  801221:	48 85 c0             	test   %rax,%rax
  801224:	74 73                	je     801299 <dup+0x11d>
  801226:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80122a:	48 c1 e8 0c          	shr    $0xc,%rax
  80122e:	48 89 c2             	mov    %rax,%rdx
  801231:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801238:	01 00 00 
  80123b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80123f:	83 e0 01             	and    $0x1,%eax
  801242:	48 85 c0             	test   %rax,%rax
  801245:	74 52                	je     801299 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801247:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80124b:	48 c1 e8 0c          	shr    $0xc,%rax
  80124f:	48 89 c2             	mov    %rax,%rdx
  801252:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801259:	01 00 00 
  80125c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801260:	25 07 0e 00 00       	and    $0xe07,%eax
  801265:	89 c1                	mov    %eax,%ecx
  801267:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80126b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80126f:	41 89 c8             	mov    %ecx,%r8d
  801272:	48 89 d1             	mov    %rdx,%rcx
  801275:	ba 00 00 00 00       	mov    $0x0,%edx
  80127a:	48 89 c6             	mov    %rax,%rsi
  80127d:	bf 00 00 00 00       	mov    $0x0,%edi
  801282:	48 b8 f0 0b 80 00 00 	movabs $0x800bf0,%rax
  801289:	00 00 00 
  80128c:	ff d0                	callq  *%rax
  80128e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801291:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801295:	79 02                	jns    801299 <dup+0x11d>
			goto err;
  801297:	eb 57                	jmp    8012f0 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801299:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80129d:	48 c1 e8 0c          	shr    $0xc,%rax
  8012a1:	48 89 c2             	mov    %rax,%rdx
  8012a4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8012ab:	01 00 00 
  8012ae:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8012b2:	25 07 0e 00 00       	and    $0xe07,%eax
  8012b7:	89 c1                	mov    %eax,%ecx
  8012b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8012c1:	41 89 c8             	mov    %ecx,%r8d
  8012c4:	48 89 d1             	mov    %rdx,%rcx
  8012c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8012cc:	48 89 c6             	mov    %rax,%rsi
  8012cf:	bf 00 00 00 00       	mov    $0x0,%edi
  8012d4:	48 b8 f0 0b 80 00 00 	movabs $0x800bf0,%rax
  8012db:	00 00 00 
  8012de:	ff d0                	callq  *%rax
  8012e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8012e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8012e7:	79 02                	jns    8012eb <dup+0x16f>
		goto err;
  8012e9:	eb 05                	jmp    8012f0 <dup+0x174>

	return newfdnum;
  8012eb:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8012ee:	eb 33                	jmp    801323 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8012f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f4:	48 89 c6             	mov    %rax,%rsi
  8012f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8012fc:	48 b8 4b 0c 80 00 00 	movabs $0x800c4b,%rax
  801303:	00 00 00 
  801306:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  801308:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80130c:	48 89 c6             	mov    %rax,%rsi
  80130f:	bf 00 00 00 00       	mov    $0x0,%edi
  801314:	48 b8 4b 0c 80 00 00 	movabs $0x800c4b,%rax
  80131b:	00 00 00 
  80131e:	ff d0                	callq  *%rax
	return r;
  801320:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801323:	c9                   	leaveq 
  801324:	c3                   	retq   

0000000000801325 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801325:	55                   	push   %rbp
  801326:	48 89 e5             	mov    %rsp,%rbp
  801329:	48 83 ec 40          	sub    $0x40,%rsp
  80132d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801330:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801334:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801338:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80133c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80133f:	48 89 d6             	mov    %rdx,%rsi
  801342:	89 c7                	mov    %eax,%edi
  801344:	48 b8 f3 0e 80 00 00 	movabs $0x800ef3,%rax
  80134b:	00 00 00 
  80134e:	ff d0                	callq  *%rax
  801350:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801353:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801357:	78 24                	js     80137d <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801359:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80135d:	8b 00                	mov    (%rax),%eax
  80135f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801363:	48 89 d6             	mov    %rdx,%rsi
  801366:	89 c7                	mov    %eax,%edi
  801368:	48 b8 4c 10 80 00 00 	movabs $0x80104c,%rax
  80136f:	00 00 00 
  801372:	ff d0                	callq  *%rax
  801374:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801377:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80137b:	79 05                	jns    801382 <read+0x5d>
		return r;
  80137d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801380:	eb 76                	jmp    8013f8 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801382:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801386:	8b 40 08             	mov    0x8(%rax),%eax
  801389:	83 e0 03             	and    $0x3,%eax
  80138c:	83 f8 01             	cmp    $0x1,%eax
  80138f:	75 3a                	jne    8013cb <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801391:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801398:	00 00 00 
  80139b:	48 8b 00             	mov    (%rax),%rax
  80139e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8013a4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8013a7:	89 c6                	mov    %eax,%esi
  8013a9:	48 bf 3f 36 80 00 00 	movabs $0x80363f,%rdi
  8013b0:	00 00 00 
  8013b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b8:	48 b9 13 28 80 00 00 	movabs $0x802813,%rcx
  8013bf:	00 00 00 
  8013c2:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8013c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013c9:	eb 2d                	jmp    8013f8 <read+0xd3>
	}
	if (!dev->dev_read)
  8013cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013cf:	48 8b 40 10          	mov    0x10(%rax),%rax
  8013d3:	48 85 c0             	test   %rax,%rax
  8013d6:	75 07                	jne    8013df <read+0xba>
		return -E_NOT_SUPP;
  8013d8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8013dd:	eb 19                	jmp    8013f8 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8013df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e3:	48 8b 40 10          	mov    0x10(%rax),%rax
  8013e7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013eb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8013ef:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8013f3:	48 89 cf             	mov    %rcx,%rdi
  8013f6:	ff d0                	callq  *%rax
}
  8013f8:	c9                   	leaveq 
  8013f9:	c3                   	retq   

00000000008013fa <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013fa:	55                   	push   %rbp
  8013fb:	48 89 e5             	mov    %rsp,%rbp
  8013fe:	48 83 ec 30          	sub    $0x30,%rsp
  801402:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801405:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801409:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80140d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801414:	eb 49                	jmp    80145f <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801416:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801419:	48 98                	cltq   
  80141b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80141f:	48 29 c2             	sub    %rax,%rdx
  801422:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801425:	48 63 c8             	movslq %eax,%rcx
  801428:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80142c:	48 01 c1             	add    %rax,%rcx
  80142f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801432:	48 89 ce             	mov    %rcx,%rsi
  801435:	89 c7                	mov    %eax,%edi
  801437:	48 b8 25 13 80 00 00 	movabs $0x801325,%rax
  80143e:	00 00 00 
  801441:	ff d0                	callq  *%rax
  801443:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  801446:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80144a:	79 05                	jns    801451 <readn+0x57>
			return m;
  80144c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80144f:	eb 1c                	jmp    80146d <readn+0x73>
		if (m == 0)
  801451:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801455:	75 02                	jne    801459 <readn+0x5f>
			break;
  801457:	eb 11                	jmp    80146a <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801459:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80145c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80145f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801462:	48 98                	cltq   
  801464:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801468:	72 ac                	jb     801416 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80146a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80146d:	c9                   	leaveq 
  80146e:	c3                   	retq   

000000000080146f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80146f:	55                   	push   %rbp
  801470:	48 89 e5             	mov    %rsp,%rbp
  801473:	48 83 ec 40          	sub    $0x40,%rsp
  801477:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80147a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80147e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801482:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801486:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801489:	48 89 d6             	mov    %rdx,%rsi
  80148c:	89 c7                	mov    %eax,%edi
  80148e:	48 b8 f3 0e 80 00 00 	movabs $0x800ef3,%rax
  801495:	00 00 00 
  801498:	ff d0                	callq  *%rax
  80149a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80149d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014a1:	78 24                	js     8014c7 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a7:	8b 00                	mov    (%rax),%eax
  8014a9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8014ad:	48 89 d6             	mov    %rdx,%rsi
  8014b0:	89 c7                	mov    %eax,%edi
  8014b2:	48 b8 4c 10 80 00 00 	movabs $0x80104c,%rax
  8014b9:	00 00 00 
  8014bc:	ff d0                	callq  *%rax
  8014be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8014c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014c5:	79 05                	jns    8014cc <write+0x5d>
		return r;
  8014c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014ca:	eb 75                	jmp    801541 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d0:	8b 40 08             	mov    0x8(%rax),%eax
  8014d3:	83 e0 03             	and    $0x3,%eax
  8014d6:	85 c0                	test   %eax,%eax
  8014d8:	75 3a                	jne    801514 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014da:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8014e1:	00 00 00 
  8014e4:	48 8b 00             	mov    (%rax),%rax
  8014e7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8014ed:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8014f0:	89 c6                	mov    %eax,%esi
  8014f2:	48 bf 5b 36 80 00 00 	movabs $0x80365b,%rdi
  8014f9:	00 00 00 
  8014fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801501:	48 b9 13 28 80 00 00 	movabs $0x802813,%rcx
  801508:	00 00 00 
  80150b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80150d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801512:	eb 2d                	jmp    801541 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801514:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801518:	48 8b 40 18          	mov    0x18(%rax),%rax
  80151c:	48 85 c0             	test   %rax,%rax
  80151f:	75 07                	jne    801528 <write+0xb9>
		return -E_NOT_SUPP;
  801521:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  801526:	eb 19                	jmp    801541 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  801528:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80152c:	48 8b 40 18          	mov    0x18(%rax),%rax
  801530:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801534:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801538:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80153c:	48 89 cf             	mov    %rcx,%rdi
  80153f:	ff d0                	callq  *%rax
}
  801541:	c9                   	leaveq 
  801542:	c3                   	retq   

0000000000801543 <seek>:

int
seek(int fdnum, off_t offset)
{
  801543:	55                   	push   %rbp
  801544:	48 89 e5             	mov    %rsp,%rbp
  801547:	48 83 ec 18          	sub    $0x18,%rsp
  80154b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80154e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801551:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801555:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801558:	48 89 d6             	mov    %rdx,%rsi
  80155b:	89 c7                	mov    %eax,%edi
  80155d:	48 b8 f3 0e 80 00 00 	movabs $0x800ef3,%rax
  801564:	00 00 00 
  801567:	ff d0                	callq  *%rax
  801569:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80156c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801570:	79 05                	jns    801577 <seek+0x34>
		return r;
  801572:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801575:	eb 0f                	jmp    801586 <seek+0x43>
	fd->fd_offset = offset;
  801577:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80157b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80157e:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  801581:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801586:	c9                   	leaveq 
  801587:	c3                   	retq   

0000000000801588 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801588:	55                   	push   %rbp
  801589:	48 89 e5             	mov    %rsp,%rbp
  80158c:	48 83 ec 30          	sub    $0x30,%rsp
  801590:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801593:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801596:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80159a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80159d:	48 89 d6             	mov    %rdx,%rsi
  8015a0:	89 c7                	mov    %eax,%edi
  8015a2:	48 b8 f3 0e 80 00 00 	movabs $0x800ef3,%rax
  8015a9:	00 00 00 
  8015ac:	ff d0                	callq  *%rax
  8015ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8015b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015b5:	78 24                	js     8015db <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015bb:	8b 00                	mov    (%rax),%eax
  8015bd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8015c1:	48 89 d6             	mov    %rdx,%rsi
  8015c4:	89 c7                	mov    %eax,%edi
  8015c6:	48 b8 4c 10 80 00 00 	movabs $0x80104c,%rax
  8015cd:	00 00 00 
  8015d0:	ff d0                	callq  *%rax
  8015d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8015d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015d9:	79 05                	jns    8015e0 <ftruncate+0x58>
		return r;
  8015db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015de:	eb 72                	jmp    801652 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015e4:	8b 40 08             	mov    0x8(%rax),%eax
  8015e7:	83 e0 03             	and    $0x3,%eax
  8015ea:	85 c0                	test   %eax,%eax
  8015ec:	75 3a                	jne    801628 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8015ee:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8015f5:	00 00 00 
  8015f8:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015fb:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801601:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801604:	89 c6                	mov    %eax,%esi
  801606:	48 bf 78 36 80 00 00 	movabs $0x803678,%rdi
  80160d:	00 00 00 
  801610:	b8 00 00 00 00       	mov    $0x0,%eax
  801615:	48 b9 13 28 80 00 00 	movabs $0x802813,%rcx
  80161c:	00 00 00 
  80161f:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801621:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801626:	eb 2a                	jmp    801652 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  801628:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80162c:	48 8b 40 30          	mov    0x30(%rax),%rax
  801630:	48 85 c0             	test   %rax,%rax
  801633:	75 07                	jne    80163c <ftruncate+0xb4>
		return -E_NOT_SUPP;
  801635:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80163a:	eb 16                	jmp    801652 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80163c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801640:	48 8b 40 30          	mov    0x30(%rax),%rax
  801644:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801648:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80164b:	89 ce                	mov    %ecx,%esi
  80164d:	48 89 d7             	mov    %rdx,%rdi
  801650:	ff d0                	callq  *%rax
}
  801652:	c9                   	leaveq 
  801653:	c3                   	retq   

0000000000801654 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801654:	55                   	push   %rbp
  801655:	48 89 e5             	mov    %rsp,%rbp
  801658:	48 83 ec 30          	sub    $0x30,%rsp
  80165c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80165f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801663:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801667:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80166a:	48 89 d6             	mov    %rdx,%rsi
  80166d:	89 c7                	mov    %eax,%edi
  80166f:	48 b8 f3 0e 80 00 00 	movabs $0x800ef3,%rax
  801676:	00 00 00 
  801679:	ff d0                	callq  *%rax
  80167b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80167e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801682:	78 24                	js     8016a8 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801684:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801688:	8b 00                	mov    (%rax),%eax
  80168a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80168e:	48 89 d6             	mov    %rdx,%rsi
  801691:	89 c7                	mov    %eax,%edi
  801693:	48 b8 4c 10 80 00 00 	movabs $0x80104c,%rax
  80169a:	00 00 00 
  80169d:	ff d0                	callq  *%rax
  80169f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8016a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016a6:	79 05                	jns    8016ad <fstat+0x59>
		return r;
  8016a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016ab:	eb 5e                	jmp    80170b <fstat+0xb7>
	if (!dev->dev_stat)
  8016ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b1:	48 8b 40 28          	mov    0x28(%rax),%rax
  8016b5:	48 85 c0             	test   %rax,%rax
  8016b8:	75 07                	jne    8016c1 <fstat+0x6d>
		return -E_NOT_SUPP;
  8016ba:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8016bf:	eb 4a                	jmp    80170b <fstat+0xb7>
	stat->st_name[0] = 0;
  8016c1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016c5:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8016c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016cc:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8016d3:	00 00 00 
	stat->st_isdir = 0;
  8016d6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016da:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8016e1:	00 00 00 
	stat->st_dev = dev;
  8016e4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016e8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016ec:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8016f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f7:	48 8b 40 28          	mov    0x28(%rax),%rax
  8016fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016ff:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801703:	48 89 ce             	mov    %rcx,%rsi
  801706:	48 89 d7             	mov    %rdx,%rdi
  801709:	ff d0                	callq  *%rax
}
  80170b:	c9                   	leaveq 
  80170c:	c3                   	retq   

000000000080170d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80170d:	55                   	push   %rbp
  80170e:	48 89 e5             	mov    %rsp,%rbp
  801711:	48 83 ec 20          	sub    $0x20,%rsp
  801715:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801719:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80171d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801721:	be 00 00 00 00       	mov    $0x0,%esi
  801726:	48 89 c7             	mov    %rax,%rdi
  801729:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  801730:	00 00 00 
  801733:	ff d0                	callq  *%rax
  801735:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801738:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80173c:	79 05                	jns    801743 <stat+0x36>
		return fd;
  80173e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801741:	eb 2f                	jmp    801772 <stat+0x65>
	r = fstat(fd, stat);
  801743:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801747:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80174a:	48 89 d6             	mov    %rdx,%rsi
  80174d:	89 c7                	mov    %eax,%edi
  80174f:	48 b8 54 16 80 00 00 	movabs $0x801654,%rax
  801756:	00 00 00 
  801759:	ff d0                	callq  *%rax
  80175b:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80175e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801761:	89 c7                	mov    %eax,%edi
  801763:	48 b8 03 11 80 00 00 	movabs $0x801103,%rax
  80176a:	00 00 00 
  80176d:	ff d0                	callq  *%rax
	return r;
  80176f:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  801772:	c9                   	leaveq 
  801773:	c3                   	retq   

0000000000801774 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801774:	55                   	push   %rbp
  801775:	48 89 e5             	mov    %rsp,%rbp
  801778:	48 83 ec 10          	sub    $0x10,%rsp
  80177c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80177f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  801783:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80178a:	00 00 00 
  80178d:	8b 00                	mov    (%rax),%eax
  80178f:	85 c0                	test   %eax,%eax
  801791:	75 1d                	jne    8017b0 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801793:	bf 01 00 00 00       	mov    $0x1,%edi
  801798:	48 b8 bf 34 80 00 00 	movabs $0x8034bf,%rax
  80179f:	00 00 00 
  8017a2:	ff d0                	callq  *%rax
  8017a4:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8017ab:	00 00 00 
  8017ae:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017b0:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8017b7:	00 00 00 
  8017ba:	8b 00                	mov    (%rax),%eax
  8017bc:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8017bf:	b9 07 00 00 00       	mov    $0x7,%ecx
  8017c4:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8017cb:	00 00 00 
  8017ce:	89 c7                	mov    %eax,%edi
  8017d0:	48 b8 22 34 80 00 00 	movabs $0x803422,%rax
  8017d7:	00 00 00 
  8017da:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8017dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e5:	48 89 c6             	mov    %rax,%rsi
  8017e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8017ed:	48 b8 5c 33 80 00 00 	movabs $0x80335c,%rax
  8017f4:	00 00 00 
  8017f7:	ff d0                	callq  *%rax
}
  8017f9:	c9                   	leaveq 
  8017fa:	c3                   	retq   

00000000008017fb <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8017fb:	55                   	push   %rbp
  8017fc:	48 89 e5             	mov    %rsp,%rbp
  8017ff:	48 83 ec 20          	sub    $0x20,%rsp
  801803:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801807:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  80180a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80180e:	48 89 c7             	mov    %rax,%rdi
  801811:	48 b8 05 02 80 00 00 	movabs $0x800205,%rax
  801818:	00 00 00 
  80181b:	ff d0                	callq  *%rax
  80181d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801822:	7e 0a                	jle    80182e <open+0x33>
  801824:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801829:	e9 a5 00 00 00       	jmpq   8018d3 <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  80182e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801832:	48 89 c7             	mov    %rax,%rdi
  801835:	48 b8 5b 0e 80 00 00 	movabs $0x800e5b,%rax
  80183c:	00 00 00 
  80183f:	ff d0                	callq  *%rax
  801841:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801844:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801848:	79 08                	jns    801852 <open+0x57>
		return r;
  80184a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80184d:	e9 81 00 00 00       	jmpq   8018d3 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  801852:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801859:	00 00 00 
  80185c:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80185f:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  801865:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801869:	48 89 c6             	mov    %rax,%rsi
  80186c:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  801873:	00 00 00 
  801876:	48 b8 71 02 80 00 00 	movabs $0x800271,%rax
  80187d:	00 00 00 
  801880:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  801882:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801886:	48 89 c6             	mov    %rax,%rsi
  801889:	bf 01 00 00 00       	mov    $0x1,%edi
  80188e:	48 b8 74 17 80 00 00 	movabs $0x801774,%rax
  801895:	00 00 00 
  801898:	ff d0                	callq  *%rax
  80189a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80189d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018a1:	79 1d                	jns    8018c0 <open+0xc5>
		fd_close(fd, 0);
  8018a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018a7:	be 00 00 00 00       	mov    $0x0,%esi
  8018ac:	48 89 c7             	mov    %rax,%rdi
  8018af:	48 b8 83 0f 80 00 00 	movabs $0x800f83,%rax
  8018b6:	00 00 00 
  8018b9:	ff d0                	callq  *%rax
		return r;
  8018bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018be:	eb 13                	jmp    8018d3 <open+0xd8>
	}
	return fd2num(fd);
  8018c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018c4:	48 89 c7             	mov    %rax,%rdi
  8018c7:	48 b8 0d 0e 80 00 00 	movabs $0x800e0d,%rax
  8018ce:	00 00 00 
  8018d1:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  8018d3:	c9                   	leaveq 
  8018d4:	c3                   	retq   

00000000008018d5 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8018d5:	55                   	push   %rbp
  8018d6:	48 89 e5             	mov    %rsp,%rbp
  8018d9:	48 83 ec 10          	sub    $0x10,%rsp
  8018dd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018e5:	8b 50 0c             	mov    0xc(%rax),%edx
  8018e8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8018ef:	00 00 00 
  8018f2:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8018f4:	be 00 00 00 00       	mov    $0x0,%esi
  8018f9:	bf 06 00 00 00       	mov    $0x6,%edi
  8018fe:	48 b8 74 17 80 00 00 	movabs $0x801774,%rax
  801905:	00 00 00 
  801908:	ff d0                	callq  *%rax
}
  80190a:	c9                   	leaveq 
  80190b:	c3                   	retq   

000000000080190c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80190c:	55                   	push   %rbp
  80190d:	48 89 e5             	mov    %rsp,%rbp
  801910:	48 83 ec 30          	sub    $0x30,%rsp
  801914:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801918:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80191c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801920:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801924:	8b 50 0c             	mov    0xc(%rax),%edx
  801927:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80192e:	00 00 00 
  801931:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  801933:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80193a:	00 00 00 
  80193d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801941:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  801945:	be 00 00 00 00       	mov    $0x0,%esi
  80194a:	bf 03 00 00 00       	mov    $0x3,%edi
  80194f:	48 b8 74 17 80 00 00 	movabs $0x801774,%rax
  801956:	00 00 00 
  801959:	ff d0                	callq  *%rax
  80195b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80195e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801962:	79 05                	jns    801969 <devfile_read+0x5d>
		return r;
  801964:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801967:	eb 26                	jmp    80198f <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  801969:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80196c:	48 63 d0             	movslq %eax,%rdx
  80196f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801973:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80197a:	00 00 00 
  80197d:	48 89 c7             	mov    %rax,%rdi
  801980:	48 b8 ac 06 80 00 00 	movabs $0x8006ac,%rax
  801987:	00 00 00 
  80198a:	ff d0                	callq  *%rax
	return r;
  80198c:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80198f:	c9                   	leaveq 
  801990:	c3                   	retq   

0000000000801991 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801991:	55                   	push   %rbp
  801992:	48 89 e5             	mov    %rsp,%rbp
  801995:	48 83 ec 30          	sub    $0x30,%rsp
  801999:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80199d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8019a1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  8019a5:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  8019ac:	00 
	n = n > max ? max : n;
  8019ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019b1:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8019b5:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  8019ba:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019c2:	8b 50 0c             	mov    0xc(%rax),%edx
  8019c5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8019cc:	00 00 00 
  8019cf:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8019d1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8019d8:	00 00 00 
  8019db:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8019df:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8019e3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8019e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019eb:	48 89 c6             	mov    %rax,%rsi
  8019ee:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  8019f5:	00 00 00 
  8019f8:	48 b8 ac 06 80 00 00 	movabs $0x8006ac,%rax
  8019ff:	00 00 00 
  801a02:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  801a04:	be 00 00 00 00       	mov    $0x0,%esi
  801a09:	bf 04 00 00 00       	mov    $0x4,%edi
  801a0e:	48 b8 74 17 80 00 00 	movabs $0x801774,%rax
  801a15:	00 00 00 
  801a18:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  801a1a:	c9                   	leaveq 
  801a1b:	c3                   	retq   

0000000000801a1c <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801a1c:	55                   	push   %rbp
  801a1d:	48 89 e5             	mov    %rsp,%rbp
  801a20:	48 83 ec 20          	sub    $0x20,%rsp
  801a24:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a28:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a30:	8b 50 0c             	mov    0xc(%rax),%edx
  801a33:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801a3a:	00 00 00 
  801a3d:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a3f:	be 00 00 00 00       	mov    $0x0,%esi
  801a44:	bf 05 00 00 00       	mov    $0x5,%edi
  801a49:	48 b8 74 17 80 00 00 	movabs $0x801774,%rax
  801a50:	00 00 00 
  801a53:	ff d0                	callq  *%rax
  801a55:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a58:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a5c:	79 05                	jns    801a63 <devfile_stat+0x47>
		return r;
  801a5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a61:	eb 56                	jmp    801ab9 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a63:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a67:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  801a6e:	00 00 00 
  801a71:	48 89 c7             	mov    %rax,%rdi
  801a74:	48 b8 71 02 80 00 00 	movabs $0x800271,%rax
  801a7b:	00 00 00 
  801a7e:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  801a80:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801a87:	00 00 00 
  801a8a:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801a90:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a94:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a9a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801aa1:	00 00 00 
  801aa4:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  801aaa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801aae:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  801ab4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ab9:	c9                   	leaveq 
  801aba:	c3                   	retq   

0000000000801abb <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801abb:	55                   	push   %rbp
  801abc:	48 89 e5             	mov    %rsp,%rbp
  801abf:	48 83 ec 10          	sub    $0x10,%rsp
  801ac3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ac7:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801aca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ace:	8b 50 0c             	mov    0xc(%rax),%edx
  801ad1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801ad8:	00 00 00 
  801adb:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  801add:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801ae4:	00 00 00 
  801ae7:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801aea:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  801aed:	be 00 00 00 00       	mov    $0x0,%esi
  801af2:	bf 02 00 00 00       	mov    $0x2,%edi
  801af7:	48 b8 74 17 80 00 00 	movabs $0x801774,%rax
  801afe:	00 00 00 
  801b01:	ff d0                	callq  *%rax
}
  801b03:	c9                   	leaveq 
  801b04:	c3                   	retq   

0000000000801b05 <remove>:

// Delete a file
int
remove(const char *path)
{
  801b05:	55                   	push   %rbp
  801b06:	48 89 e5             	mov    %rsp,%rbp
  801b09:	48 83 ec 10          	sub    $0x10,%rsp
  801b0d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  801b11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b15:	48 89 c7             	mov    %rax,%rdi
  801b18:	48 b8 05 02 80 00 00 	movabs $0x800205,%rax
  801b1f:	00 00 00 
  801b22:	ff d0                	callq  *%rax
  801b24:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b29:	7e 07                	jle    801b32 <remove+0x2d>
		return -E_BAD_PATH;
  801b2b:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801b30:	eb 33                	jmp    801b65 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  801b32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b36:	48 89 c6             	mov    %rax,%rsi
  801b39:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  801b40:	00 00 00 
  801b43:	48 b8 71 02 80 00 00 	movabs $0x800271,%rax
  801b4a:	00 00 00 
  801b4d:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  801b4f:	be 00 00 00 00       	mov    $0x0,%esi
  801b54:	bf 07 00 00 00       	mov    $0x7,%edi
  801b59:	48 b8 74 17 80 00 00 	movabs $0x801774,%rax
  801b60:	00 00 00 
  801b63:	ff d0                	callq  *%rax
}
  801b65:	c9                   	leaveq 
  801b66:	c3                   	retq   

0000000000801b67 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801b67:	55                   	push   %rbp
  801b68:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b6b:	be 00 00 00 00       	mov    $0x0,%esi
  801b70:	bf 08 00 00 00       	mov    $0x8,%edi
  801b75:	48 b8 74 17 80 00 00 	movabs $0x801774,%rax
  801b7c:	00 00 00 
  801b7f:	ff d0                	callq  *%rax
}
  801b81:	5d                   	pop    %rbp
  801b82:	c3                   	retq   

0000000000801b83 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  801b83:	55                   	push   %rbp
  801b84:	48 89 e5             	mov    %rsp,%rbp
  801b87:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  801b8e:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  801b95:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  801b9c:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  801ba3:	be 00 00 00 00       	mov    $0x0,%esi
  801ba8:	48 89 c7             	mov    %rax,%rdi
  801bab:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  801bb2:	00 00 00 
  801bb5:	ff d0                	callq  *%rax
  801bb7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  801bba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bbe:	79 28                	jns    801be8 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  801bc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bc3:	89 c6                	mov    %eax,%esi
  801bc5:	48 bf 9e 36 80 00 00 	movabs $0x80369e,%rdi
  801bcc:	00 00 00 
  801bcf:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd4:	48 ba 13 28 80 00 00 	movabs $0x802813,%rdx
  801bdb:	00 00 00 
  801bde:	ff d2                	callq  *%rdx
		return fd_src;
  801be0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801be3:	e9 74 01 00 00       	jmpq   801d5c <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  801be8:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  801bef:	be 01 01 00 00       	mov    $0x101,%esi
  801bf4:	48 89 c7             	mov    %rax,%rdi
  801bf7:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  801bfe:	00 00 00 
  801c01:	ff d0                	callq  *%rax
  801c03:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  801c06:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801c0a:	79 39                	jns    801c45 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  801c0c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c0f:	89 c6                	mov    %eax,%esi
  801c11:	48 bf b4 36 80 00 00 	movabs $0x8036b4,%rdi
  801c18:	00 00 00 
  801c1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c20:	48 ba 13 28 80 00 00 	movabs $0x802813,%rdx
  801c27:	00 00 00 
  801c2a:	ff d2                	callq  *%rdx
		close(fd_src);
  801c2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c2f:	89 c7                	mov    %eax,%edi
  801c31:	48 b8 03 11 80 00 00 	movabs $0x801103,%rax
  801c38:	00 00 00 
  801c3b:	ff d0                	callq  *%rax
		return fd_dest;
  801c3d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c40:	e9 17 01 00 00       	jmpq   801d5c <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  801c45:	eb 74                	jmp    801cbb <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  801c47:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801c4a:	48 63 d0             	movslq %eax,%rdx
  801c4d:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801c54:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c57:	48 89 ce             	mov    %rcx,%rsi
  801c5a:	89 c7                	mov    %eax,%edi
  801c5c:	48 b8 6f 14 80 00 00 	movabs $0x80146f,%rax
  801c63:	00 00 00 
  801c66:	ff d0                	callq  *%rax
  801c68:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  801c6b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801c6f:	79 4a                	jns    801cbb <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  801c71:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801c74:	89 c6                	mov    %eax,%esi
  801c76:	48 bf ce 36 80 00 00 	movabs $0x8036ce,%rdi
  801c7d:	00 00 00 
  801c80:	b8 00 00 00 00       	mov    $0x0,%eax
  801c85:	48 ba 13 28 80 00 00 	movabs $0x802813,%rdx
  801c8c:	00 00 00 
  801c8f:	ff d2                	callq  *%rdx
			close(fd_src);
  801c91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c94:	89 c7                	mov    %eax,%edi
  801c96:	48 b8 03 11 80 00 00 	movabs $0x801103,%rax
  801c9d:	00 00 00 
  801ca0:	ff d0                	callq  *%rax
			close(fd_dest);
  801ca2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ca5:	89 c7                	mov    %eax,%edi
  801ca7:	48 b8 03 11 80 00 00 	movabs $0x801103,%rax
  801cae:	00 00 00 
  801cb1:	ff d0                	callq  *%rax
			return write_size;
  801cb3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801cb6:	e9 a1 00 00 00       	jmpq   801d5c <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  801cbb:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801cc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cc5:	ba 00 02 00 00       	mov    $0x200,%edx
  801cca:	48 89 ce             	mov    %rcx,%rsi
  801ccd:	89 c7                	mov    %eax,%edi
  801ccf:	48 b8 25 13 80 00 00 	movabs $0x801325,%rax
  801cd6:	00 00 00 
  801cd9:	ff d0                	callq  *%rax
  801cdb:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801cde:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801ce2:	0f 8f 5f ff ff ff    	jg     801c47 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  801ce8:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801cec:	79 47                	jns    801d35 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  801cee:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801cf1:	89 c6                	mov    %eax,%esi
  801cf3:	48 bf e1 36 80 00 00 	movabs $0x8036e1,%rdi
  801cfa:	00 00 00 
  801cfd:	b8 00 00 00 00       	mov    $0x0,%eax
  801d02:	48 ba 13 28 80 00 00 	movabs $0x802813,%rdx
  801d09:	00 00 00 
  801d0c:	ff d2                	callq  *%rdx
		close(fd_src);
  801d0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d11:	89 c7                	mov    %eax,%edi
  801d13:	48 b8 03 11 80 00 00 	movabs $0x801103,%rax
  801d1a:	00 00 00 
  801d1d:	ff d0                	callq  *%rax
		close(fd_dest);
  801d1f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d22:	89 c7                	mov    %eax,%edi
  801d24:	48 b8 03 11 80 00 00 	movabs $0x801103,%rax
  801d2b:	00 00 00 
  801d2e:	ff d0                	callq  *%rax
		return read_size;
  801d30:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801d33:	eb 27                	jmp    801d5c <copy+0x1d9>
	}
	close(fd_src);
  801d35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d38:	89 c7                	mov    %eax,%edi
  801d3a:	48 b8 03 11 80 00 00 	movabs $0x801103,%rax
  801d41:	00 00 00 
  801d44:	ff d0                	callq  *%rax
	close(fd_dest);
  801d46:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d49:	89 c7                	mov    %eax,%edi
  801d4b:	48 b8 03 11 80 00 00 	movabs $0x801103,%rax
  801d52:	00 00 00 
  801d55:	ff d0                	callq  *%rax
	return 0;
  801d57:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  801d5c:	c9                   	leaveq 
  801d5d:	c3                   	retq   

0000000000801d5e <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801d5e:	55                   	push   %rbp
  801d5f:	48 89 e5             	mov    %rsp,%rbp
  801d62:	53                   	push   %rbx
  801d63:	48 83 ec 38          	sub    $0x38,%rsp
  801d67:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801d6b:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  801d6f:	48 89 c7             	mov    %rax,%rdi
  801d72:	48 b8 5b 0e 80 00 00 	movabs $0x800e5b,%rax
  801d79:	00 00 00 
  801d7c:	ff d0                	callq  *%rax
  801d7e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d81:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801d85:	0f 88 bf 01 00 00    	js     801f4a <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d8b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d8f:	ba 07 04 00 00       	mov    $0x407,%edx
  801d94:	48 89 c6             	mov    %rax,%rsi
  801d97:	bf 00 00 00 00       	mov    $0x0,%edi
  801d9c:	48 b8 a0 0b 80 00 00 	movabs $0x800ba0,%rax
  801da3:	00 00 00 
  801da6:	ff d0                	callq  *%rax
  801da8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801dab:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801daf:	0f 88 95 01 00 00    	js     801f4a <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801db5:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801db9:	48 89 c7             	mov    %rax,%rdi
  801dbc:	48 b8 5b 0e 80 00 00 	movabs $0x800e5b,%rax
  801dc3:	00 00 00 
  801dc6:	ff d0                	callq  *%rax
  801dc8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801dcb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801dcf:	0f 88 5d 01 00 00    	js     801f32 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dd5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801dd9:	ba 07 04 00 00       	mov    $0x407,%edx
  801dde:	48 89 c6             	mov    %rax,%rsi
  801de1:	bf 00 00 00 00       	mov    $0x0,%edi
  801de6:	48 b8 a0 0b 80 00 00 	movabs $0x800ba0,%rax
  801ded:	00 00 00 
  801df0:	ff d0                	callq  *%rax
  801df2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801df5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801df9:	0f 88 33 01 00 00    	js     801f32 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801dff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e03:	48 89 c7             	mov    %rax,%rdi
  801e06:	48 b8 30 0e 80 00 00 	movabs $0x800e30,%rax
  801e0d:	00 00 00 
  801e10:	ff d0                	callq  *%rax
  801e12:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e16:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e1a:	ba 07 04 00 00       	mov    $0x407,%edx
  801e1f:	48 89 c6             	mov    %rax,%rsi
  801e22:	bf 00 00 00 00       	mov    $0x0,%edi
  801e27:	48 b8 a0 0b 80 00 00 	movabs $0x800ba0,%rax
  801e2e:	00 00 00 
  801e31:	ff d0                	callq  *%rax
  801e33:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801e36:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e3a:	79 05                	jns    801e41 <pipe+0xe3>
		goto err2;
  801e3c:	e9 d9 00 00 00       	jmpq   801f1a <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e41:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e45:	48 89 c7             	mov    %rax,%rdi
  801e48:	48 b8 30 0e 80 00 00 	movabs $0x800e30,%rax
  801e4f:	00 00 00 
  801e52:	ff d0                	callq  *%rax
  801e54:	48 89 c2             	mov    %rax,%rdx
  801e57:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e5b:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  801e61:	48 89 d1             	mov    %rdx,%rcx
  801e64:	ba 00 00 00 00       	mov    $0x0,%edx
  801e69:	48 89 c6             	mov    %rax,%rsi
  801e6c:	bf 00 00 00 00       	mov    $0x0,%edi
  801e71:	48 b8 f0 0b 80 00 00 	movabs $0x800bf0,%rax
  801e78:	00 00 00 
  801e7b:	ff d0                	callq  *%rax
  801e7d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801e80:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e84:	79 1b                	jns    801ea1 <pipe+0x143>
		goto err3;
  801e86:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  801e87:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e8b:	48 89 c6             	mov    %rax,%rsi
  801e8e:	bf 00 00 00 00       	mov    $0x0,%edi
  801e93:	48 b8 4b 0c 80 00 00 	movabs $0x800c4b,%rax
  801e9a:	00 00 00 
  801e9d:	ff d0                	callq  *%rax
  801e9f:	eb 79                	jmp    801f1a <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801ea1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ea5:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  801eac:	00 00 00 
  801eaf:	8b 12                	mov    (%rdx),%edx
  801eb1:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  801eb3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eb7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  801ebe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ec2:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  801ec9:	00 00 00 
  801ecc:	8b 12                	mov    (%rdx),%edx
  801ece:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  801ed0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ed4:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801edb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801edf:	48 89 c7             	mov    %rax,%rdi
  801ee2:	48 b8 0d 0e 80 00 00 	movabs $0x800e0d,%rax
  801ee9:	00 00 00 
  801eec:	ff d0                	callq  *%rax
  801eee:	89 c2                	mov    %eax,%edx
  801ef0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801ef4:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  801ef6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801efa:	48 8d 58 04          	lea    0x4(%rax),%rbx
  801efe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f02:	48 89 c7             	mov    %rax,%rdi
  801f05:	48 b8 0d 0e 80 00 00 	movabs $0x800e0d,%rax
  801f0c:	00 00 00 
  801f0f:	ff d0                	callq  *%rax
  801f11:	89 03                	mov    %eax,(%rbx)
	return 0;
  801f13:	b8 00 00 00 00       	mov    $0x0,%eax
  801f18:	eb 33                	jmp    801f4d <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  801f1a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f1e:	48 89 c6             	mov    %rax,%rsi
  801f21:	bf 00 00 00 00       	mov    $0x0,%edi
  801f26:	48 b8 4b 0c 80 00 00 	movabs $0x800c4b,%rax
  801f2d:	00 00 00 
  801f30:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  801f32:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f36:	48 89 c6             	mov    %rax,%rsi
  801f39:	bf 00 00 00 00       	mov    $0x0,%edi
  801f3e:	48 b8 4b 0c 80 00 00 	movabs $0x800c4b,%rax
  801f45:	00 00 00 
  801f48:	ff d0                	callq  *%rax
err:
	return r;
  801f4a:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  801f4d:	48 83 c4 38          	add    $0x38,%rsp
  801f51:	5b                   	pop    %rbx
  801f52:	5d                   	pop    %rbp
  801f53:	c3                   	retq   

0000000000801f54 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801f54:	55                   	push   %rbp
  801f55:	48 89 e5             	mov    %rsp,%rbp
  801f58:	53                   	push   %rbx
  801f59:	48 83 ec 28          	sub    $0x28,%rsp
  801f5d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f61:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801f65:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801f6c:	00 00 00 
  801f6f:	48 8b 00             	mov    (%rax),%rax
  801f72:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  801f78:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  801f7b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f7f:	48 89 c7             	mov    %rax,%rdi
  801f82:	48 b8 41 35 80 00 00 	movabs $0x803541,%rax
  801f89:	00 00 00 
  801f8c:	ff d0                	callq  *%rax
  801f8e:	89 c3                	mov    %eax,%ebx
  801f90:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f94:	48 89 c7             	mov    %rax,%rdi
  801f97:	48 b8 41 35 80 00 00 	movabs $0x803541,%rax
  801f9e:	00 00 00 
  801fa1:	ff d0                	callq  *%rax
  801fa3:	39 c3                	cmp    %eax,%ebx
  801fa5:	0f 94 c0             	sete   %al
  801fa8:	0f b6 c0             	movzbl %al,%eax
  801fab:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  801fae:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801fb5:	00 00 00 
  801fb8:	48 8b 00             	mov    (%rax),%rax
  801fbb:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  801fc1:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  801fc4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801fc7:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801fca:	75 05                	jne    801fd1 <_pipeisclosed+0x7d>
			return ret;
  801fcc:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801fcf:	eb 4f                	jmp    802020 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  801fd1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801fd4:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801fd7:	74 42                	je     80201b <_pipeisclosed+0xc7>
  801fd9:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  801fdd:	75 3c                	jne    80201b <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801fdf:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801fe6:	00 00 00 
  801fe9:	48 8b 00             	mov    (%rax),%rax
  801fec:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  801ff2:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  801ff5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ff8:	89 c6                	mov    %eax,%esi
  801ffa:	48 bf fc 36 80 00 00 	movabs $0x8036fc,%rdi
  802001:	00 00 00 
  802004:	b8 00 00 00 00       	mov    $0x0,%eax
  802009:	49 b8 13 28 80 00 00 	movabs $0x802813,%r8
  802010:	00 00 00 
  802013:	41 ff d0             	callq  *%r8
	}
  802016:	e9 4a ff ff ff       	jmpq   801f65 <_pipeisclosed+0x11>
  80201b:	e9 45 ff ff ff       	jmpq   801f65 <_pipeisclosed+0x11>
}
  802020:	48 83 c4 28          	add    $0x28,%rsp
  802024:	5b                   	pop    %rbx
  802025:	5d                   	pop    %rbp
  802026:	c3                   	retq   

0000000000802027 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802027:	55                   	push   %rbp
  802028:	48 89 e5             	mov    %rsp,%rbp
  80202b:	48 83 ec 30          	sub    $0x30,%rsp
  80202f:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802032:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802036:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802039:	48 89 d6             	mov    %rdx,%rsi
  80203c:	89 c7                	mov    %eax,%edi
  80203e:	48 b8 f3 0e 80 00 00 	movabs $0x800ef3,%rax
  802045:	00 00 00 
  802048:	ff d0                	callq  *%rax
  80204a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80204d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802051:	79 05                	jns    802058 <pipeisclosed+0x31>
		return r;
  802053:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802056:	eb 31                	jmp    802089 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802058:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80205c:	48 89 c7             	mov    %rax,%rdi
  80205f:	48 b8 30 0e 80 00 00 	movabs $0x800e30,%rax
  802066:	00 00 00 
  802069:	ff d0                	callq  *%rax
  80206b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80206f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802073:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802077:	48 89 d6             	mov    %rdx,%rsi
  80207a:	48 89 c7             	mov    %rax,%rdi
  80207d:	48 b8 54 1f 80 00 00 	movabs $0x801f54,%rax
  802084:	00 00 00 
  802087:	ff d0                	callq  *%rax
}
  802089:	c9                   	leaveq 
  80208a:	c3                   	retq   

000000000080208b <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80208b:	55                   	push   %rbp
  80208c:	48 89 e5             	mov    %rsp,%rbp
  80208f:	48 83 ec 40          	sub    $0x40,%rsp
  802093:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802097:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80209b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80209f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020a3:	48 89 c7             	mov    %rax,%rdi
  8020a6:	48 b8 30 0e 80 00 00 	movabs $0x800e30,%rax
  8020ad:	00 00 00 
  8020b0:	ff d0                	callq  *%rax
  8020b2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8020b6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8020ba:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8020be:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8020c5:	00 
  8020c6:	e9 92 00 00 00       	jmpq   80215d <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8020cb:	eb 41                	jmp    80210e <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8020cd:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8020d2:	74 09                	je     8020dd <devpipe_read+0x52>
				return i;
  8020d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020d8:	e9 92 00 00 00       	jmpq   80216f <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8020dd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020e5:	48 89 d6             	mov    %rdx,%rsi
  8020e8:	48 89 c7             	mov    %rax,%rdi
  8020eb:	48 b8 54 1f 80 00 00 	movabs $0x801f54,%rax
  8020f2:	00 00 00 
  8020f5:	ff d0                	callq  *%rax
  8020f7:	85 c0                	test   %eax,%eax
  8020f9:	74 07                	je     802102 <devpipe_read+0x77>
				return 0;
  8020fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802100:	eb 6d                	jmp    80216f <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802102:	48 b8 62 0b 80 00 00 	movabs $0x800b62,%rax
  802109:	00 00 00 
  80210c:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80210e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802112:	8b 10                	mov    (%rax),%edx
  802114:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802118:	8b 40 04             	mov    0x4(%rax),%eax
  80211b:	39 c2                	cmp    %eax,%edx
  80211d:	74 ae                	je     8020cd <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80211f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802123:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802127:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80212b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80212f:	8b 00                	mov    (%rax),%eax
  802131:	99                   	cltd   
  802132:	c1 ea 1b             	shr    $0x1b,%edx
  802135:	01 d0                	add    %edx,%eax
  802137:	83 e0 1f             	and    $0x1f,%eax
  80213a:	29 d0                	sub    %edx,%eax
  80213c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802140:	48 98                	cltq   
  802142:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802147:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  802149:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80214d:	8b 00                	mov    (%rax),%eax
  80214f:	8d 50 01             	lea    0x1(%rax),%edx
  802152:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802156:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802158:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80215d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802161:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802165:	0f 82 60 ff ff ff    	jb     8020cb <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80216b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80216f:	c9                   	leaveq 
  802170:	c3                   	retq   

0000000000802171 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802171:	55                   	push   %rbp
  802172:	48 89 e5             	mov    %rsp,%rbp
  802175:	48 83 ec 40          	sub    $0x40,%rsp
  802179:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80217d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802181:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802185:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802189:	48 89 c7             	mov    %rax,%rdi
  80218c:	48 b8 30 0e 80 00 00 	movabs $0x800e30,%rax
  802193:	00 00 00 
  802196:	ff d0                	callq  *%rax
  802198:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80219c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8021a0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8021a4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8021ab:	00 
  8021ac:	e9 8e 00 00 00       	jmpq   80223f <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8021b1:	eb 31                	jmp    8021e4 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8021b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021bb:	48 89 d6             	mov    %rdx,%rsi
  8021be:	48 89 c7             	mov    %rax,%rdi
  8021c1:	48 b8 54 1f 80 00 00 	movabs $0x801f54,%rax
  8021c8:	00 00 00 
  8021cb:	ff d0                	callq  *%rax
  8021cd:	85 c0                	test   %eax,%eax
  8021cf:	74 07                	je     8021d8 <devpipe_write+0x67>
				return 0;
  8021d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d6:	eb 79                	jmp    802251 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8021d8:	48 b8 62 0b 80 00 00 	movabs $0x800b62,%rax
  8021df:	00 00 00 
  8021e2:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8021e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021e8:	8b 40 04             	mov    0x4(%rax),%eax
  8021eb:	48 63 d0             	movslq %eax,%rdx
  8021ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021f2:	8b 00                	mov    (%rax),%eax
  8021f4:	48 98                	cltq   
  8021f6:	48 83 c0 20          	add    $0x20,%rax
  8021fa:	48 39 c2             	cmp    %rax,%rdx
  8021fd:	73 b4                	jae    8021b3 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8021ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802203:	8b 40 04             	mov    0x4(%rax),%eax
  802206:	99                   	cltd   
  802207:	c1 ea 1b             	shr    $0x1b,%edx
  80220a:	01 d0                	add    %edx,%eax
  80220c:	83 e0 1f             	and    $0x1f,%eax
  80220f:	29 d0                	sub    %edx,%eax
  802211:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802215:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802219:	48 01 ca             	add    %rcx,%rdx
  80221c:	0f b6 0a             	movzbl (%rdx),%ecx
  80221f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802223:	48 98                	cltq   
  802225:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  802229:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80222d:	8b 40 04             	mov    0x4(%rax),%eax
  802230:	8d 50 01             	lea    0x1(%rax),%edx
  802233:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802237:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80223a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80223f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802243:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802247:	0f 82 64 ff ff ff    	jb     8021b1 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80224d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802251:	c9                   	leaveq 
  802252:	c3                   	retq   

0000000000802253 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802253:	55                   	push   %rbp
  802254:	48 89 e5             	mov    %rsp,%rbp
  802257:	48 83 ec 20          	sub    $0x20,%rsp
  80225b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80225f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802263:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802267:	48 89 c7             	mov    %rax,%rdi
  80226a:	48 b8 30 0e 80 00 00 	movabs $0x800e30,%rax
  802271:	00 00 00 
  802274:	ff d0                	callq  *%rax
  802276:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80227a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80227e:	48 be 0f 37 80 00 00 	movabs $0x80370f,%rsi
  802285:	00 00 00 
  802288:	48 89 c7             	mov    %rax,%rdi
  80228b:	48 b8 71 02 80 00 00 	movabs $0x800271,%rax
  802292:	00 00 00 
  802295:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  802297:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80229b:	8b 50 04             	mov    0x4(%rax),%edx
  80229e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022a2:	8b 00                	mov    (%rax),%eax
  8022a4:	29 c2                	sub    %eax,%edx
  8022a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022aa:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8022b0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022b4:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8022bb:	00 00 00 
	stat->st_dev = &devpipe;
  8022be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022c2:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  8022c9:	00 00 00 
  8022cc:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8022d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022d8:	c9                   	leaveq 
  8022d9:	c3                   	retq   

00000000008022da <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8022da:	55                   	push   %rbp
  8022db:	48 89 e5             	mov    %rsp,%rbp
  8022de:	48 83 ec 10          	sub    $0x10,%rsp
  8022e2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8022e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022ea:	48 89 c6             	mov    %rax,%rsi
  8022ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8022f2:	48 b8 4b 0c 80 00 00 	movabs $0x800c4b,%rax
  8022f9:	00 00 00 
  8022fc:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8022fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802302:	48 89 c7             	mov    %rax,%rdi
  802305:	48 b8 30 0e 80 00 00 	movabs $0x800e30,%rax
  80230c:	00 00 00 
  80230f:	ff d0                	callq  *%rax
  802311:	48 89 c6             	mov    %rax,%rsi
  802314:	bf 00 00 00 00       	mov    $0x0,%edi
  802319:	48 b8 4b 0c 80 00 00 	movabs $0x800c4b,%rax
  802320:	00 00 00 
  802323:	ff d0                	callq  *%rax
}
  802325:	c9                   	leaveq 
  802326:	c3                   	retq   

0000000000802327 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802327:	55                   	push   %rbp
  802328:	48 89 e5             	mov    %rsp,%rbp
  80232b:	48 83 ec 20          	sub    $0x20,%rsp
  80232f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  802332:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802335:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802338:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80233c:	be 01 00 00 00       	mov    $0x1,%esi
  802341:	48 89 c7             	mov    %rax,%rdi
  802344:	48 b8 58 0a 80 00 00 	movabs $0x800a58,%rax
  80234b:	00 00 00 
  80234e:	ff d0                	callq  *%rax
}
  802350:	c9                   	leaveq 
  802351:	c3                   	retq   

0000000000802352 <getchar>:

int
getchar(void)
{
  802352:	55                   	push   %rbp
  802353:	48 89 e5             	mov    %rsp,%rbp
  802356:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80235a:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80235e:	ba 01 00 00 00       	mov    $0x1,%edx
  802363:	48 89 c6             	mov    %rax,%rsi
  802366:	bf 00 00 00 00       	mov    $0x0,%edi
  80236b:	48 b8 25 13 80 00 00 	movabs $0x801325,%rax
  802372:	00 00 00 
  802375:	ff d0                	callq  *%rax
  802377:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80237a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80237e:	79 05                	jns    802385 <getchar+0x33>
		return r;
  802380:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802383:	eb 14                	jmp    802399 <getchar+0x47>
	if (r < 1)
  802385:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802389:	7f 07                	jg     802392 <getchar+0x40>
		return -E_EOF;
  80238b:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  802390:	eb 07                	jmp    802399 <getchar+0x47>
	return c;
  802392:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  802396:	0f b6 c0             	movzbl %al,%eax
}
  802399:	c9                   	leaveq 
  80239a:	c3                   	retq   

000000000080239b <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80239b:	55                   	push   %rbp
  80239c:	48 89 e5             	mov    %rsp,%rbp
  80239f:	48 83 ec 20          	sub    $0x20,%rsp
  8023a3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023a6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023aa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023ad:	48 89 d6             	mov    %rdx,%rsi
  8023b0:	89 c7                	mov    %eax,%edi
  8023b2:	48 b8 f3 0e 80 00 00 	movabs $0x800ef3,%rax
  8023b9:	00 00 00 
  8023bc:	ff d0                	callq  *%rax
  8023be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023c5:	79 05                	jns    8023cc <iscons+0x31>
		return r;
  8023c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ca:	eb 1a                	jmp    8023e6 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8023cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023d0:	8b 10                	mov    (%rax),%edx
  8023d2:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  8023d9:	00 00 00 
  8023dc:	8b 00                	mov    (%rax),%eax
  8023de:	39 c2                	cmp    %eax,%edx
  8023e0:	0f 94 c0             	sete   %al
  8023e3:	0f b6 c0             	movzbl %al,%eax
}
  8023e6:	c9                   	leaveq 
  8023e7:	c3                   	retq   

00000000008023e8 <opencons>:

int
opencons(void)
{
  8023e8:	55                   	push   %rbp
  8023e9:	48 89 e5             	mov    %rsp,%rbp
  8023ec:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8023f0:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8023f4:	48 89 c7             	mov    %rax,%rdi
  8023f7:	48 b8 5b 0e 80 00 00 	movabs $0x800e5b,%rax
  8023fe:	00 00 00 
  802401:	ff d0                	callq  *%rax
  802403:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802406:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80240a:	79 05                	jns    802411 <opencons+0x29>
		return r;
  80240c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80240f:	eb 5b                	jmp    80246c <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802411:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802415:	ba 07 04 00 00       	mov    $0x407,%edx
  80241a:	48 89 c6             	mov    %rax,%rsi
  80241d:	bf 00 00 00 00       	mov    $0x0,%edi
  802422:	48 b8 a0 0b 80 00 00 	movabs $0x800ba0,%rax
  802429:	00 00 00 
  80242c:	ff d0                	callq  *%rax
  80242e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802431:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802435:	79 05                	jns    80243c <opencons+0x54>
		return r;
  802437:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80243a:	eb 30                	jmp    80246c <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80243c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802440:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  802447:	00 00 00 
  80244a:	8b 12                	mov    (%rdx),%edx
  80244c:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80244e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802452:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  802459:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80245d:	48 89 c7             	mov    %rax,%rdi
  802460:	48 b8 0d 0e 80 00 00 	movabs $0x800e0d,%rax
  802467:	00 00 00 
  80246a:	ff d0                	callq  *%rax
}
  80246c:	c9                   	leaveq 
  80246d:	c3                   	retq   

000000000080246e <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80246e:	55                   	push   %rbp
  80246f:	48 89 e5             	mov    %rsp,%rbp
  802472:	48 83 ec 30          	sub    $0x30,%rsp
  802476:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80247a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80247e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  802482:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802487:	75 07                	jne    802490 <devcons_read+0x22>
		return 0;
  802489:	b8 00 00 00 00       	mov    $0x0,%eax
  80248e:	eb 4b                	jmp    8024db <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  802490:	eb 0c                	jmp    80249e <devcons_read+0x30>
		sys_yield();
  802492:	48 b8 62 0b 80 00 00 	movabs $0x800b62,%rax
  802499:	00 00 00 
  80249c:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80249e:	48 b8 a2 0a 80 00 00 	movabs $0x800aa2,%rax
  8024a5:	00 00 00 
  8024a8:	ff d0                	callq  *%rax
  8024aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024b1:	74 df                	je     802492 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8024b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024b7:	79 05                	jns    8024be <devcons_read+0x50>
		return c;
  8024b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024bc:	eb 1d                	jmp    8024db <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8024be:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8024c2:	75 07                	jne    8024cb <devcons_read+0x5d>
		return 0;
  8024c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c9:	eb 10                	jmp    8024db <devcons_read+0x6d>
	*(char*)vbuf = c;
  8024cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024ce:	89 c2                	mov    %eax,%edx
  8024d0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024d4:	88 10                	mov    %dl,(%rax)
	return 1;
  8024d6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8024db:	c9                   	leaveq 
  8024dc:	c3                   	retq   

00000000008024dd <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8024dd:	55                   	push   %rbp
  8024de:	48 89 e5             	mov    %rsp,%rbp
  8024e1:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8024e8:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8024ef:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8024f6:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8024fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802504:	eb 76                	jmp    80257c <devcons_write+0x9f>
		m = n - tot;
  802506:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80250d:	89 c2                	mov    %eax,%edx
  80250f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802512:	29 c2                	sub    %eax,%edx
  802514:	89 d0                	mov    %edx,%eax
  802516:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  802519:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80251c:	83 f8 7f             	cmp    $0x7f,%eax
  80251f:	76 07                	jbe    802528 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  802521:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  802528:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80252b:	48 63 d0             	movslq %eax,%rdx
  80252e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802531:	48 63 c8             	movslq %eax,%rcx
  802534:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80253b:	48 01 c1             	add    %rax,%rcx
  80253e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802545:	48 89 ce             	mov    %rcx,%rsi
  802548:	48 89 c7             	mov    %rax,%rdi
  80254b:	48 b8 95 05 80 00 00 	movabs $0x800595,%rax
  802552:	00 00 00 
  802555:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  802557:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80255a:	48 63 d0             	movslq %eax,%rdx
  80255d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802564:	48 89 d6             	mov    %rdx,%rsi
  802567:	48 89 c7             	mov    %rax,%rdi
  80256a:	48 b8 58 0a 80 00 00 	movabs $0x800a58,%rax
  802571:	00 00 00 
  802574:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802576:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802579:	01 45 fc             	add    %eax,-0x4(%rbp)
  80257c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80257f:	48 98                	cltq   
  802581:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  802588:	0f 82 78 ff ff ff    	jb     802506 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80258e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802591:	c9                   	leaveq 
  802592:	c3                   	retq   

0000000000802593 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  802593:	55                   	push   %rbp
  802594:	48 89 e5             	mov    %rsp,%rbp
  802597:	48 83 ec 08          	sub    $0x8,%rsp
  80259b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80259f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025a4:	c9                   	leaveq 
  8025a5:	c3                   	retq   

00000000008025a6 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8025a6:	55                   	push   %rbp
  8025a7:	48 89 e5             	mov    %rsp,%rbp
  8025aa:	48 83 ec 10          	sub    $0x10,%rsp
  8025ae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8025b2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8025b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ba:	48 be 1b 37 80 00 00 	movabs $0x80371b,%rsi
  8025c1:	00 00 00 
  8025c4:	48 89 c7             	mov    %rax,%rdi
  8025c7:	48 b8 71 02 80 00 00 	movabs $0x800271,%rax
  8025ce:	00 00 00 
  8025d1:	ff d0                	callq  *%rax
	return 0;
  8025d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025d8:	c9                   	leaveq 
  8025d9:	c3                   	retq   

00000000008025da <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8025da:	55                   	push   %rbp
  8025db:	48 89 e5             	mov    %rsp,%rbp
  8025de:	53                   	push   %rbx
  8025df:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8025e6:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8025ed:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8025f3:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8025fa:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  802601:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  802608:	84 c0                	test   %al,%al
  80260a:	74 23                	je     80262f <_panic+0x55>
  80260c:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  802613:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  802617:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80261b:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80261f:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  802623:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  802627:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80262b:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80262f:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  802636:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80263d:	00 00 00 
  802640:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  802647:	00 00 00 
  80264a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80264e:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  802655:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80265c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802663:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80266a:	00 00 00 
  80266d:	48 8b 18             	mov    (%rax),%rbx
  802670:	48 b8 24 0b 80 00 00 	movabs $0x800b24,%rax
  802677:	00 00 00 
  80267a:	ff d0                	callq  *%rax
  80267c:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  802682:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  802689:	41 89 c8             	mov    %ecx,%r8d
  80268c:	48 89 d1             	mov    %rdx,%rcx
  80268f:	48 89 da             	mov    %rbx,%rdx
  802692:	89 c6                	mov    %eax,%esi
  802694:	48 bf 28 37 80 00 00 	movabs $0x803728,%rdi
  80269b:	00 00 00 
  80269e:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a3:	49 b9 13 28 80 00 00 	movabs $0x802813,%r9
  8026aa:	00 00 00 
  8026ad:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8026b0:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8026b7:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8026be:	48 89 d6             	mov    %rdx,%rsi
  8026c1:	48 89 c7             	mov    %rax,%rdi
  8026c4:	48 b8 67 27 80 00 00 	movabs $0x802767,%rax
  8026cb:	00 00 00 
  8026ce:	ff d0                	callq  *%rax
	cprintf("\n");
  8026d0:	48 bf 4b 37 80 00 00 	movabs $0x80374b,%rdi
  8026d7:	00 00 00 
  8026da:	b8 00 00 00 00       	mov    $0x0,%eax
  8026df:	48 ba 13 28 80 00 00 	movabs $0x802813,%rdx
  8026e6:	00 00 00 
  8026e9:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8026eb:	cc                   	int3   
  8026ec:	eb fd                	jmp    8026eb <_panic+0x111>

00000000008026ee <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8026ee:	55                   	push   %rbp
  8026ef:	48 89 e5             	mov    %rsp,%rbp
  8026f2:	48 83 ec 10          	sub    $0x10,%rsp
  8026f6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8026f9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8026fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802701:	8b 00                	mov    (%rax),%eax
  802703:	8d 48 01             	lea    0x1(%rax),%ecx
  802706:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80270a:	89 0a                	mov    %ecx,(%rdx)
  80270c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80270f:	89 d1                	mov    %edx,%ecx
  802711:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802715:	48 98                	cltq   
  802717:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80271b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80271f:	8b 00                	mov    (%rax),%eax
  802721:	3d ff 00 00 00       	cmp    $0xff,%eax
  802726:	75 2c                	jne    802754 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  802728:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80272c:	8b 00                	mov    (%rax),%eax
  80272e:	48 98                	cltq   
  802730:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802734:	48 83 c2 08          	add    $0x8,%rdx
  802738:	48 89 c6             	mov    %rax,%rsi
  80273b:	48 89 d7             	mov    %rdx,%rdi
  80273e:	48 b8 58 0a 80 00 00 	movabs $0x800a58,%rax
  802745:	00 00 00 
  802748:	ff d0                	callq  *%rax
        b->idx = 0;
  80274a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80274e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  802754:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802758:	8b 40 04             	mov    0x4(%rax),%eax
  80275b:	8d 50 01             	lea    0x1(%rax),%edx
  80275e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802762:	89 50 04             	mov    %edx,0x4(%rax)
}
  802765:	c9                   	leaveq 
  802766:	c3                   	retq   

0000000000802767 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  802767:	55                   	push   %rbp
  802768:	48 89 e5             	mov    %rsp,%rbp
  80276b:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  802772:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  802779:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  802780:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  802787:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80278e:	48 8b 0a             	mov    (%rdx),%rcx
  802791:	48 89 08             	mov    %rcx,(%rax)
  802794:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802798:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80279c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8027a0:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8027a4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8027ab:	00 00 00 
    b.cnt = 0;
  8027ae:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8027b5:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8027b8:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8027bf:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8027c6:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8027cd:	48 89 c6             	mov    %rax,%rsi
  8027d0:	48 bf ee 26 80 00 00 	movabs $0x8026ee,%rdi
  8027d7:	00 00 00 
  8027da:	48 b8 c6 2b 80 00 00 	movabs $0x802bc6,%rax
  8027e1:	00 00 00 
  8027e4:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8027e6:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8027ec:	48 98                	cltq   
  8027ee:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8027f5:	48 83 c2 08          	add    $0x8,%rdx
  8027f9:	48 89 c6             	mov    %rax,%rsi
  8027fc:	48 89 d7             	mov    %rdx,%rdi
  8027ff:	48 b8 58 0a 80 00 00 	movabs $0x800a58,%rax
  802806:	00 00 00 
  802809:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80280b:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  802811:	c9                   	leaveq 
  802812:	c3                   	retq   

0000000000802813 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  802813:	55                   	push   %rbp
  802814:	48 89 e5             	mov    %rsp,%rbp
  802817:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80281e:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802825:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80282c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802833:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80283a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802841:	84 c0                	test   %al,%al
  802843:	74 20                	je     802865 <cprintf+0x52>
  802845:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802849:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80284d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802851:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802855:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802859:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80285d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802861:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802865:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80286c:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802873:	00 00 00 
  802876:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80287d:	00 00 00 
  802880:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802884:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80288b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802892:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  802899:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8028a0:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8028a7:	48 8b 0a             	mov    (%rdx),%rcx
  8028aa:	48 89 08             	mov    %rcx,(%rax)
  8028ad:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8028b1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8028b5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8028b9:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8028bd:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8028c4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8028cb:	48 89 d6             	mov    %rdx,%rsi
  8028ce:	48 89 c7             	mov    %rax,%rdi
  8028d1:	48 b8 67 27 80 00 00 	movabs $0x802767,%rax
  8028d8:	00 00 00 
  8028db:	ff d0                	callq  *%rax
  8028dd:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8028e3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8028e9:	c9                   	leaveq 
  8028ea:	c3                   	retq   

00000000008028eb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8028eb:	55                   	push   %rbp
  8028ec:	48 89 e5             	mov    %rsp,%rbp
  8028ef:	53                   	push   %rbx
  8028f0:	48 83 ec 38          	sub    $0x38,%rsp
  8028f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028f8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028fc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802900:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  802903:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  802907:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80290b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80290e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802912:	77 3b                	ja     80294f <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  802914:	8b 45 d0             	mov    -0x30(%rbp),%eax
  802917:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80291b:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80291e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802922:	ba 00 00 00 00       	mov    $0x0,%edx
  802927:	48 f7 f3             	div    %rbx
  80292a:	48 89 c2             	mov    %rax,%rdx
  80292d:	8b 7d cc             	mov    -0x34(%rbp),%edi
  802930:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802933:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  802937:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80293b:	41 89 f9             	mov    %edi,%r9d
  80293e:	48 89 c7             	mov    %rax,%rdi
  802941:	48 b8 eb 28 80 00 00 	movabs $0x8028eb,%rax
  802948:	00 00 00 
  80294b:	ff d0                	callq  *%rax
  80294d:	eb 1e                	jmp    80296d <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80294f:	eb 12                	jmp    802963 <printnum+0x78>
			putch(padc, putdat);
  802951:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802955:	8b 55 cc             	mov    -0x34(%rbp),%edx
  802958:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80295c:	48 89 ce             	mov    %rcx,%rsi
  80295f:	89 d7                	mov    %edx,%edi
  802961:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802963:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  802967:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80296b:	7f e4                	jg     802951 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80296d:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802970:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802974:	ba 00 00 00 00       	mov    $0x0,%edx
  802979:	48 f7 f1             	div    %rcx
  80297c:	48 89 d0             	mov    %rdx,%rax
  80297f:	48 ba 50 39 80 00 00 	movabs $0x803950,%rdx
  802986:	00 00 00 
  802989:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80298d:	0f be d0             	movsbl %al,%edx
  802990:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802994:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802998:	48 89 ce             	mov    %rcx,%rsi
  80299b:	89 d7                	mov    %edx,%edi
  80299d:	ff d0                	callq  *%rax
}
  80299f:	48 83 c4 38          	add    $0x38,%rsp
  8029a3:	5b                   	pop    %rbx
  8029a4:	5d                   	pop    %rbp
  8029a5:	c3                   	retq   

00000000008029a6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8029a6:	55                   	push   %rbp
  8029a7:	48 89 e5             	mov    %rsp,%rbp
  8029aa:	48 83 ec 1c          	sub    $0x1c,%rsp
  8029ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029b2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8029b5:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8029b9:	7e 52                	jle    802a0d <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8029bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029bf:	8b 00                	mov    (%rax),%eax
  8029c1:	83 f8 30             	cmp    $0x30,%eax
  8029c4:	73 24                	jae    8029ea <getuint+0x44>
  8029c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029ca:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8029ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029d2:	8b 00                	mov    (%rax),%eax
  8029d4:	89 c0                	mov    %eax,%eax
  8029d6:	48 01 d0             	add    %rdx,%rax
  8029d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029dd:	8b 12                	mov    (%rdx),%edx
  8029df:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8029e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029e6:	89 0a                	mov    %ecx,(%rdx)
  8029e8:	eb 17                	jmp    802a01 <getuint+0x5b>
  8029ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029ee:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8029f2:	48 89 d0             	mov    %rdx,%rax
  8029f5:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8029f9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029fd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802a01:	48 8b 00             	mov    (%rax),%rax
  802a04:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802a08:	e9 a3 00 00 00       	jmpq   802ab0 <getuint+0x10a>
	else if (lflag)
  802a0d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802a11:	74 4f                	je     802a62 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  802a13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a17:	8b 00                	mov    (%rax),%eax
  802a19:	83 f8 30             	cmp    $0x30,%eax
  802a1c:	73 24                	jae    802a42 <getuint+0x9c>
  802a1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a22:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802a26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a2a:	8b 00                	mov    (%rax),%eax
  802a2c:	89 c0                	mov    %eax,%eax
  802a2e:	48 01 d0             	add    %rdx,%rax
  802a31:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a35:	8b 12                	mov    (%rdx),%edx
  802a37:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802a3a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a3e:	89 0a                	mov    %ecx,(%rdx)
  802a40:	eb 17                	jmp    802a59 <getuint+0xb3>
  802a42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a46:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802a4a:	48 89 d0             	mov    %rdx,%rax
  802a4d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802a51:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a55:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802a59:	48 8b 00             	mov    (%rax),%rax
  802a5c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802a60:	eb 4e                	jmp    802ab0 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  802a62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a66:	8b 00                	mov    (%rax),%eax
  802a68:	83 f8 30             	cmp    $0x30,%eax
  802a6b:	73 24                	jae    802a91 <getuint+0xeb>
  802a6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a71:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802a75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a79:	8b 00                	mov    (%rax),%eax
  802a7b:	89 c0                	mov    %eax,%eax
  802a7d:	48 01 d0             	add    %rdx,%rax
  802a80:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a84:	8b 12                	mov    (%rdx),%edx
  802a86:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802a89:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a8d:	89 0a                	mov    %ecx,(%rdx)
  802a8f:	eb 17                	jmp    802aa8 <getuint+0x102>
  802a91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a95:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802a99:	48 89 d0             	mov    %rdx,%rax
  802a9c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802aa0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802aa4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802aa8:	8b 00                	mov    (%rax),%eax
  802aaa:	89 c0                	mov    %eax,%eax
  802aac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802ab0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802ab4:	c9                   	leaveq 
  802ab5:	c3                   	retq   

0000000000802ab6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  802ab6:	55                   	push   %rbp
  802ab7:	48 89 e5             	mov    %rsp,%rbp
  802aba:	48 83 ec 1c          	sub    $0x1c,%rsp
  802abe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ac2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  802ac5:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802ac9:	7e 52                	jle    802b1d <getint+0x67>
		x=va_arg(*ap, long long);
  802acb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802acf:	8b 00                	mov    (%rax),%eax
  802ad1:	83 f8 30             	cmp    $0x30,%eax
  802ad4:	73 24                	jae    802afa <getint+0x44>
  802ad6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ada:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802ade:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ae2:	8b 00                	mov    (%rax),%eax
  802ae4:	89 c0                	mov    %eax,%eax
  802ae6:	48 01 d0             	add    %rdx,%rax
  802ae9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802aed:	8b 12                	mov    (%rdx),%edx
  802aef:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802af2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802af6:	89 0a                	mov    %ecx,(%rdx)
  802af8:	eb 17                	jmp    802b11 <getint+0x5b>
  802afa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802afe:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802b02:	48 89 d0             	mov    %rdx,%rax
  802b05:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802b09:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b0d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802b11:	48 8b 00             	mov    (%rax),%rax
  802b14:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802b18:	e9 a3 00 00 00       	jmpq   802bc0 <getint+0x10a>
	else if (lflag)
  802b1d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802b21:	74 4f                	je     802b72 <getint+0xbc>
		x=va_arg(*ap, long);
  802b23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b27:	8b 00                	mov    (%rax),%eax
  802b29:	83 f8 30             	cmp    $0x30,%eax
  802b2c:	73 24                	jae    802b52 <getint+0x9c>
  802b2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b32:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802b36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b3a:	8b 00                	mov    (%rax),%eax
  802b3c:	89 c0                	mov    %eax,%eax
  802b3e:	48 01 d0             	add    %rdx,%rax
  802b41:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b45:	8b 12                	mov    (%rdx),%edx
  802b47:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802b4a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b4e:	89 0a                	mov    %ecx,(%rdx)
  802b50:	eb 17                	jmp    802b69 <getint+0xb3>
  802b52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b56:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802b5a:	48 89 d0             	mov    %rdx,%rax
  802b5d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802b61:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b65:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802b69:	48 8b 00             	mov    (%rax),%rax
  802b6c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802b70:	eb 4e                	jmp    802bc0 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  802b72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b76:	8b 00                	mov    (%rax),%eax
  802b78:	83 f8 30             	cmp    $0x30,%eax
  802b7b:	73 24                	jae    802ba1 <getint+0xeb>
  802b7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b81:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802b85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b89:	8b 00                	mov    (%rax),%eax
  802b8b:	89 c0                	mov    %eax,%eax
  802b8d:	48 01 d0             	add    %rdx,%rax
  802b90:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b94:	8b 12                	mov    (%rdx),%edx
  802b96:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802b99:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b9d:	89 0a                	mov    %ecx,(%rdx)
  802b9f:	eb 17                	jmp    802bb8 <getint+0x102>
  802ba1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ba5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802ba9:	48 89 d0             	mov    %rdx,%rax
  802bac:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802bb0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bb4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802bb8:	8b 00                	mov    (%rax),%eax
  802bba:	48 98                	cltq   
  802bbc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802bc0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802bc4:	c9                   	leaveq 
  802bc5:	c3                   	retq   

0000000000802bc6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  802bc6:	55                   	push   %rbp
  802bc7:	48 89 e5             	mov    %rsp,%rbp
  802bca:	41 54                	push   %r12
  802bcc:	53                   	push   %rbx
  802bcd:	48 83 ec 60          	sub    $0x60,%rsp
  802bd1:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  802bd5:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  802bd9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802bdd:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  802be1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802be5:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  802be9:	48 8b 0a             	mov    (%rdx),%rcx
  802bec:	48 89 08             	mov    %rcx,(%rax)
  802bef:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802bf3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802bf7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802bfb:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802bff:	eb 17                	jmp    802c18 <vprintfmt+0x52>
			if (ch == '\0')
  802c01:	85 db                	test   %ebx,%ebx
  802c03:	0f 84 cc 04 00 00    	je     8030d5 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  802c09:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802c0d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802c11:	48 89 d6             	mov    %rdx,%rsi
  802c14:	89 df                	mov    %ebx,%edi
  802c16:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802c18:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802c1c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802c20:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802c24:	0f b6 00             	movzbl (%rax),%eax
  802c27:	0f b6 d8             	movzbl %al,%ebx
  802c2a:	83 fb 25             	cmp    $0x25,%ebx
  802c2d:	75 d2                	jne    802c01 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  802c2f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  802c33:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  802c3a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  802c41:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  802c48:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802c4f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802c53:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802c57:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802c5b:	0f b6 00             	movzbl (%rax),%eax
  802c5e:	0f b6 d8             	movzbl %al,%ebx
  802c61:	8d 43 dd             	lea    -0x23(%rbx),%eax
  802c64:	83 f8 55             	cmp    $0x55,%eax
  802c67:	0f 87 34 04 00 00    	ja     8030a1 <vprintfmt+0x4db>
  802c6d:	89 c0                	mov    %eax,%eax
  802c6f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802c76:	00 
  802c77:	48 b8 78 39 80 00 00 	movabs $0x803978,%rax
  802c7e:	00 00 00 
  802c81:	48 01 d0             	add    %rdx,%rax
  802c84:	48 8b 00             	mov    (%rax),%rax
  802c87:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  802c89:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  802c8d:	eb c0                	jmp    802c4f <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  802c8f:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  802c93:	eb ba                	jmp    802c4f <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802c95:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  802c9c:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802c9f:	89 d0                	mov    %edx,%eax
  802ca1:	c1 e0 02             	shl    $0x2,%eax
  802ca4:	01 d0                	add    %edx,%eax
  802ca6:	01 c0                	add    %eax,%eax
  802ca8:	01 d8                	add    %ebx,%eax
  802caa:	83 e8 30             	sub    $0x30,%eax
  802cad:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  802cb0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802cb4:	0f b6 00             	movzbl (%rax),%eax
  802cb7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  802cba:	83 fb 2f             	cmp    $0x2f,%ebx
  802cbd:	7e 0c                	jle    802ccb <vprintfmt+0x105>
  802cbf:	83 fb 39             	cmp    $0x39,%ebx
  802cc2:	7f 07                	jg     802ccb <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802cc4:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802cc9:	eb d1                	jmp    802c9c <vprintfmt+0xd6>
			goto process_precision;
  802ccb:	eb 58                	jmp    802d25 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  802ccd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802cd0:	83 f8 30             	cmp    $0x30,%eax
  802cd3:	73 17                	jae    802cec <vprintfmt+0x126>
  802cd5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802cd9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802cdc:	89 c0                	mov    %eax,%eax
  802cde:	48 01 d0             	add    %rdx,%rax
  802ce1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802ce4:	83 c2 08             	add    $0x8,%edx
  802ce7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802cea:	eb 0f                	jmp    802cfb <vprintfmt+0x135>
  802cec:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802cf0:	48 89 d0             	mov    %rdx,%rax
  802cf3:	48 83 c2 08          	add    $0x8,%rdx
  802cf7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802cfb:	8b 00                	mov    (%rax),%eax
  802cfd:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  802d00:	eb 23                	jmp    802d25 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  802d02:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802d06:	79 0c                	jns    802d14 <vprintfmt+0x14e>
				width = 0;
  802d08:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  802d0f:	e9 3b ff ff ff       	jmpq   802c4f <vprintfmt+0x89>
  802d14:	e9 36 ff ff ff       	jmpq   802c4f <vprintfmt+0x89>

		case '#':
			altflag = 1;
  802d19:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  802d20:	e9 2a ff ff ff       	jmpq   802c4f <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  802d25:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802d29:	79 12                	jns    802d3d <vprintfmt+0x177>
				width = precision, precision = -1;
  802d2b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802d2e:	89 45 dc             	mov    %eax,-0x24(%rbp)
  802d31:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  802d38:	e9 12 ff ff ff       	jmpq   802c4f <vprintfmt+0x89>
  802d3d:	e9 0d ff ff ff       	jmpq   802c4f <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  802d42:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  802d46:	e9 04 ff ff ff       	jmpq   802c4f <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  802d4b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802d4e:	83 f8 30             	cmp    $0x30,%eax
  802d51:	73 17                	jae    802d6a <vprintfmt+0x1a4>
  802d53:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802d57:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802d5a:	89 c0                	mov    %eax,%eax
  802d5c:	48 01 d0             	add    %rdx,%rax
  802d5f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802d62:	83 c2 08             	add    $0x8,%edx
  802d65:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802d68:	eb 0f                	jmp    802d79 <vprintfmt+0x1b3>
  802d6a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802d6e:	48 89 d0             	mov    %rdx,%rax
  802d71:	48 83 c2 08          	add    $0x8,%rdx
  802d75:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802d79:	8b 10                	mov    (%rax),%edx
  802d7b:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802d7f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802d83:	48 89 ce             	mov    %rcx,%rsi
  802d86:	89 d7                	mov    %edx,%edi
  802d88:	ff d0                	callq  *%rax
			break;
  802d8a:	e9 40 03 00 00       	jmpq   8030cf <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  802d8f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802d92:	83 f8 30             	cmp    $0x30,%eax
  802d95:	73 17                	jae    802dae <vprintfmt+0x1e8>
  802d97:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802d9b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802d9e:	89 c0                	mov    %eax,%eax
  802da0:	48 01 d0             	add    %rdx,%rax
  802da3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802da6:	83 c2 08             	add    $0x8,%edx
  802da9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802dac:	eb 0f                	jmp    802dbd <vprintfmt+0x1f7>
  802dae:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802db2:	48 89 d0             	mov    %rdx,%rax
  802db5:	48 83 c2 08          	add    $0x8,%rdx
  802db9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802dbd:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  802dbf:	85 db                	test   %ebx,%ebx
  802dc1:	79 02                	jns    802dc5 <vprintfmt+0x1ff>
				err = -err;
  802dc3:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802dc5:	83 fb 15             	cmp    $0x15,%ebx
  802dc8:	7f 16                	jg     802de0 <vprintfmt+0x21a>
  802dca:	48 b8 a0 38 80 00 00 	movabs $0x8038a0,%rax
  802dd1:	00 00 00 
  802dd4:	48 63 d3             	movslq %ebx,%rdx
  802dd7:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  802ddb:	4d 85 e4             	test   %r12,%r12
  802dde:	75 2e                	jne    802e0e <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  802de0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802de4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802de8:	89 d9                	mov    %ebx,%ecx
  802dea:	48 ba 61 39 80 00 00 	movabs $0x803961,%rdx
  802df1:	00 00 00 
  802df4:	48 89 c7             	mov    %rax,%rdi
  802df7:	b8 00 00 00 00       	mov    $0x0,%eax
  802dfc:	49 b8 de 30 80 00 00 	movabs $0x8030de,%r8
  802e03:	00 00 00 
  802e06:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  802e09:	e9 c1 02 00 00       	jmpq   8030cf <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  802e0e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802e12:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802e16:	4c 89 e1             	mov    %r12,%rcx
  802e19:	48 ba 6a 39 80 00 00 	movabs $0x80396a,%rdx
  802e20:	00 00 00 
  802e23:	48 89 c7             	mov    %rax,%rdi
  802e26:	b8 00 00 00 00       	mov    $0x0,%eax
  802e2b:	49 b8 de 30 80 00 00 	movabs $0x8030de,%r8
  802e32:	00 00 00 
  802e35:	41 ff d0             	callq  *%r8
			break;
  802e38:	e9 92 02 00 00       	jmpq   8030cf <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  802e3d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e40:	83 f8 30             	cmp    $0x30,%eax
  802e43:	73 17                	jae    802e5c <vprintfmt+0x296>
  802e45:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e49:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e4c:	89 c0                	mov    %eax,%eax
  802e4e:	48 01 d0             	add    %rdx,%rax
  802e51:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802e54:	83 c2 08             	add    $0x8,%edx
  802e57:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802e5a:	eb 0f                	jmp    802e6b <vprintfmt+0x2a5>
  802e5c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802e60:	48 89 d0             	mov    %rdx,%rax
  802e63:	48 83 c2 08          	add    $0x8,%rdx
  802e67:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802e6b:	4c 8b 20             	mov    (%rax),%r12
  802e6e:	4d 85 e4             	test   %r12,%r12
  802e71:	75 0a                	jne    802e7d <vprintfmt+0x2b7>
				p = "(null)";
  802e73:	49 bc 6d 39 80 00 00 	movabs $0x80396d,%r12
  802e7a:	00 00 00 
			if (width > 0 && padc != '-')
  802e7d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802e81:	7e 3f                	jle    802ec2 <vprintfmt+0x2fc>
  802e83:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  802e87:	74 39                	je     802ec2 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  802e89:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802e8c:	48 98                	cltq   
  802e8e:	48 89 c6             	mov    %rax,%rsi
  802e91:	4c 89 e7             	mov    %r12,%rdi
  802e94:	48 b8 33 02 80 00 00 	movabs $0x800233,%rax
  802e9b:	00 00 00 
  802e9e:	ff d0                	callq  *%rax
  802ea0:	29 45 dc             	sub    %eax,-0x24(%rbp)
  802ea3:	eb 17                	jmp    802ebc <vprintfmt+0x2f6>
					putch(padc, putdat);
  802ea5:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  802ea9:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802ead:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802eb1:	48 89 ce             	mov    %rcx,%rsi
  802eb4:	89 d7                	mov    %edx,%edi
  802eb6:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802eb8:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802ebc:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802ec0:	7f e3                	jg     802ea5 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802ec2:	eb 37                	jmp    802efb <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  802ec4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802ec8:	74 1e                	je     802ee8 <vprintfmt+0x322>
  802eca:	83 fb 1f             	cmp    $0x1f,%ebx
  802ecd:	7e 05                	jle    802ed4 <vprintfmt+0x30e>
  802ecf:	83 fb 7e             	cmp    $0x7e,%ebx
  802ed2:	7e 14                	jle    802ee8 <vprintfmt+0x322>
					putch('?', putdat);
  802ed4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802ed8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802edc:	48 89 d6             	mov    %rdx,%rsi
  802edf:	bf 3f 00 00 00       	mov    $0x3f,%edi
  802ee4:	ff d0                	callq  *%rax
  802ee6:	eb 0f                	jmp    802ef7 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  802ee8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802eec:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802ef0:	48 89 d6             	mov    %rdx,%rsi
  802ef3:	89 df                	mov    %ebx,%edi
  802ef5:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802ef7:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802efb:	4c 89 e0             	mov    %r12,%rax
  802efe:	4c 8d 60 01          	lea    0x1(%rax),%r12
  802f02:	0f b6 00             	movzbl (%rax),%eax
  802f05:	0f be d8             	movsbl %al,%ebx
  802f08:	85 db                	test   %ebx,%ebx
  802f0a:	74 10                	je     802f1c <vprintfmt+0x356>
  802f0c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802f10:	78 b2                	js     802ec4 <vprintfmt+0x2fe>
  802f12:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  802f16:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802f1a:	79 a8                	jns    802ec4 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802f1c:	eb 16                	jmp    802f34 <vprintfmt+0x36e>
				putch(' ', putdat);
  802f1e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802f22:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802f26:	48 89 d6             	mov    %rdx,%rsi
  802f29:	bf 20 00 00 00       	mov    $0x20,%edi
  802f2e:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802f30:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802f34:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802f38:	7f e4                	jg     802f1e <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  802f3a:	e9 90 01 00 00       	jmpq   8030cf <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  802f3f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802f43:	be 03 00 00 00       	mov    $0x3,%esi
  802f48:	48 89 c7             	mov    %rax,%rdi
  802f4b:	48 b8 b6 2a 80 00 00 	movabs $0x802ab6,%rax
  802f52:	00 00 00 
  802f55:	ff d0                	callq  *%rax
  802f57:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  802f5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f5f:	48 85 c0             	test   %rax,%rax
  802f62:	79 1d                	jns    802f81 <vprintfmt+0x3bb>
				putch('-', putdat);
  802f64:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802f68:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802f6c:	48 89 d6             	mov    %rdx,%rsi
  802f6f:	bf 2d 00 00 00       	mov    $0x2d,%edi
  802f74:	ff d0                	callq  *%rax
				num = -(long long) num;
  802f76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f7a:	48 f7 d8             	neg    %rax
  802f7d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  802f81:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  802f88:	e9 d5 00 00 00       	jmpq   803062 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  802f8d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802f91:	be 03 00 00 00       	mov    $0x3,%esi
  802f96:	48 89 c7             	mov    %rax,%rdi
  802f99:	48 b8 a6 29 80 00 00 	movabs $0x8029a6,%rax
  802fa0:	00 00 00 
  802fa3:	ff d0                	callq  *%rax
  802fa5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  802fa9:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  802fb0:	e9 ad 00 00 00       	jmpq   803062 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  802fb5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802fb9:	be 03 00 00 00       	mov    $0x3,%esi
  802fbe:	48 89 c7             	mov    %rax,%rdi
  802fc1:	48 b8 a6 29 80 00 00 	movabs $0x8029a6,%rax
  802fc8:	00 00 00 
  802fcb:	ff d0                	callq  *%rax
  802fcd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  802fd1:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  802fd8:	e9 85 00 00 00       	jmpq   803062 <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  802fdd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802fe1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802fe5:	48 89 d6             	mov    %rdx,%rsi
  802fe8:	bf 30 00 00 00       	mov    $0x30,%edi
  802fed:	ff d0                	callq  *%rax
			putch('x', putdat);
  802fef:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802ff3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802ff7:	48 89 d6             	mov    %rdx,%rsi
  802ffa:	bf 78 00 00 00       	mov    $0x78,%edi
  802fff:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  803001:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803004:	83 f8 30             	cmp    $0x30,%eax
  803007:	73 17                	jae    803020 <vprintfmt+0x45a>
  803009:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80300d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803010:	89 c0                	mov    %eax,%eax
  803012:	48 01 d0             	add    %rdx,%rax
  803015:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803018:	83 c2 08             	add    $0x8,%edx
  80301b:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80301e:	eb 0f                	jmp    80302f <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  803020:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803024:	48 89 d0             	mov    %rdx,%rax
  803027:	48 83 c2 08          	add    $0x8,%rdx
  80302b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80302f:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803032:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  803036:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  80303d:	eb 23                	jmp    803062 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  80303f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803043:	be 03 00 00 00       	mov    $0x3,%esi
  803048:	48 89 c7             	mov    %rax,%rdi
  80304b:	48 b8 a6 29 80 00 00 	movabs $0x8029a6,%rax
  803052:	00 00 00 
  803055:	ff d0                	callq  *%rax
  803057:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  80305b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  803062:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  803067:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80306a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80306d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803071:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803075:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803079:	45 89 c1             	mov    %r8d,%r9d
  80307c:	41 89 f8             	mov    %edi,%r8d
  80307f:	48 89 c7             	mov    %rax,%rdi
  803082:	48 b8 eb 28 80 00 00 	movabs $0x8028eb,%rax
  803089:	00 00 00 
  80308c:	ff d0                	callq  *%rax
			break;
  80308e:	eb 3f                	jmp    8030cf <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  803090:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803094:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803098:	48 89 d6             	mov    %rdx,%rsi
  80309b:	89 df                	mov    %ebx,%edi
  80309d:	ff d0                	callq  *%rax
			break;
  80309f:	eb 2e                	jmp    8030cf <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8030a1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8030a5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8030a9:	48 89 d6             	mov    %rdx,%rsi
  8030ac:	bf 25 00 00 00       	mov    $0x25,%edi
  8030b1:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8030b3:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8030b8:	eb 05                	jmp    8030bf <vprintfmt+0x4f9>
  8030ba:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8030bf:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8030c3:	48 83 e8 01          	sub    $0x1,%rax
  8030c7:	0f b6 00             	movzbl (%rax),%eax
  8030ca:	3c 25                	cmp    $0x25,%al
  8030cc:	75 ec                	jne    8030ba <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  8030ce:	90                   	nop
		}
	}
  8030cf:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8030d0:	e9 43 fb ff ff       	jmpq   802c18 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8030d5:	48 83 c4 60          	add    $0x60,%rsp
  8030d9:	5b                   	pop    %rbx
  8030da:	41 5c                	pop    %r12
  8030dc:	5d                   	pop    %rbp
  8030dd:	c3                   	retq   

00000000008030de <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8030de:	55                   	push   %rbp
  8030df:	48 89 e5             	mov    %rsp,%rbp
  8030e2:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8030e9:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8030f0:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8030f7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8030fe:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803105:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80310c:	84 c0                	test   %al,%al
  80310e:	74 20                	je     803130 <printfmt+0x52>
  803110:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803114:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803118:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80311c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803120:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803124:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803128:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80312c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803130:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803137:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80313e:	00 00 00 
  803141:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  803148:	00 00 00 
  80314b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80314f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  803156:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80315d:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  803164:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80316b:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803172:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  803179:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803180:	48 89 c7             	mov    %rax,%rdi
  803183:	48 b8 c6 2b 80 00 00 	movabs $0x802bc6,%rax
  80318a:	00 00 00 
  80318d:	ff d0                	callq  *%rax
	va_end(ap);
}
  80318f:	c9                   	leaveq 
  803190:	c3                   	retq   

0000000000803191 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  803191:	55                   	push   %rbp
  803192:	48 89 e5             	mov    %rsp,%rbp
  803195:	48 83 ec 10          	sub    $0x10,%rsp
  803199:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80319c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8031a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031a4:	8b 40 10             	mov    0x10(%rax),%eax
  8031a7:	8d 50 01             	lea    0x1(%rax),%edx
  8031aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031ae:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8031b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031b5:	48 8b 10             	mov    (%rax),%rdx
  8031b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031bc:	48 8b 40 08          	mov    0x8(%rax),%rax
  8031c0:	48 39 c2             	cmp    %rax,%rdx
  8031c3:	73 17                	jae    8031dc <sprintputch+0x4b>
		*b->buf++ = ch;
  8031c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031c9:	48 8b 00             	mov    (%rax),%rax
  8031cc:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8031d0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8031d4:	48 89 0a             	mov    %rcx,(%rdx)
  8031d7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8031da:	88 10                	mov    %dl,(%rax)
}
  8031dc:	c9                   	leaveq 
  8031dd:	c3                   	retq   

00000000008031de <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8031de:	55                   	push   %rbp
  8031df:	48 89 e5             	mov    %rsp,%rbp
  8031e2:	48 83 ec 50          	sub    $0x50,%rsp
  8031e6:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8031ea:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8031ed:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8031f1:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8031f5:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8031f9:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8031fd:	48 8b 0a             	mov    (%rdx),%rcx
  803200:	48 89 08             	mov    %rcx,(%rax)
  803203:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803207:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80320b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80320f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  803213:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803217:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80321b:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80321e:	48 98                	cltq   
  803220:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803224:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803228:	48 01 d0             	add    %rdx,%rax
  80322b:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80322f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  803236:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80323b:	74 06                	je     803243 <vsnprintf+0x65>
  80323d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  803241:	7f 07                	jg     80324a <vsnprintf+0x6c>
		return -E_INVAL;
  803243:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803248:	eb 2f                	jmp    803279 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80324a:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80324e:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803252:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803256:	48 89 c6             	mov    %rax,%rsi
  803259:	48 bf 91 31 80 00 00 	movabs $0x803191,%rdi
  803260:	00 00 00 
  803263:	48 b8 c6 2b 80 00 00 	movabs $0x802bc6,%rax
  80326a:	00 00 00 
  80326d:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80326f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803273:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  803276:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  803279:	c9                   	leaveq 
  80327a:	c3                   	retq   

000000000080327b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80327b:	55                   	push   %rbp
  80327c:	48 89 e5             	mov    %rsp,%rbp
  80327f:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  803286:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80328d:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  803293:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80329a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8032a1:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8032a8:	84 c0                	test   %al,%al
  8032aa:	74 20                	je     8032cc <snprintf+0x51>
  8032ac:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8032b0:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8032b4:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8032b8:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8032bc:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8032c0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8032c4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8032c8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8032cc:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8032d3:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8032da:	00 00 00 
  8032dd:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8032e4:	00 00 00 
  8032e7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8032eb:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8032f2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8032f9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  803300:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  803307:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80330e:	48 8b 0a             	mov    (%rdx),%rcx
  803311:	48 89 08             	mov    %rcx,(%rax)
  803314:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803318:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80331c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803320:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  803324:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80332b:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  803332:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  803338:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80333f:	48 89 c7             	mov    %rax,%rdi
  803342:	48 b8 de 31 80 00 00 	movabs $0x8031de,%rax
  803349:	00 00 00 
  80334c:	ff d0                	callq  *%rax
  80334e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  803354:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80335a:	c9                   	leaveq 
  80335b:	c3                   	retq   

000000000080335c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80335c:	55                   	push   %rbp
  80335d:	48 89 e5             	mov    %rsp,%rbp
  803360:	48 83 ec 30          	sub    $0x30,%rsp
  803364:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803368:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80336c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  803370:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803375:	74 18                	je     80338f <ipc_recv+0x33>
  803377:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80337b:	48 89 c7             	mov    %rax,%rdi
  80337e:	48 b8 c9 0d 80 00 00 	movabs $0x800dc9,%rax
  803385:	00 00 00 
  803388:	ff d0                	callq  *%rax
  80338a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80338d:	eb 19                	jmp    8033a8 <ipc_recv+0x4c>
  80338f:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  803396:	00 00 00 
  803399:	48 b8 c9 0d 80 00 00 	movabs $0x800dc9,%rax
  8033a0:	00 00 00 
  8033a3:	ff d0                	callq  *%rax
  8033a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  8033a8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033ad:	74 26                	je     8033d5 <ipc_recv+0x79>
  8033af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033b3:	75 15                	jne    8033ca <ipc_recv+0x6e>
  8033b5:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8033bc:	00 00 00 
  8033bf:	48 8b 00             	mov    (%rax),%rax
  8033c2:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  8033c8:	eb 05                	jmp    8033cf <ipc_recv+0x73>
  8033ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8033cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8033d3:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  8033d5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8033da:	74 26                	je     803402 <ipc_recv+0xa6>
  8033dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033e0:	75 15                	jne    8033f7 <ipc_recv+0x9b>
  8033e2:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8033e9:	00 00 00 
  8033ec:	48 8b 00             	mov    (%rax),%rax
  8033ef:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  8033f5:	eb 05                	jmp    8033fc <ipc_recv+0xa0>
  8033f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8033fc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803400:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  803402:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803406:	75 15                	jne    80341d <ipc_recv+0xc1>
  803408:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80340f:	00 00 00 
  803412:	48 8b 00             	mov    (%rax),%rax
  803415:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  80341b:	eb 03                	jmp    803420 <ipc_recv+0xc4>
  80341d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803420:	c9                   	leaveq 
  803421:	c3                   	retq   

0000000000803422 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803422:	55                   	push   %rbp
  803423:	48 89 e5             	mov    %rsp,%rbp
  803426:	48 83 ec 30          	sub    $0x30,%rsp
  80342a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80342d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803430:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803434:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  803437:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  80343e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803443:	75 10                	jne    803455 <ipc_send+0x33>
  803445:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80344c:	00 00 00 
  80344f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  803453:	eb 62                	jmp    8034b7 <ipc_send+0x95>
  803455:	eb 60                	jmp    8034b7 <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  803457:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80345b:	74 30                	je     80348d <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  80345d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803460:	89 c1                	mov    %eax,%ecx
  803462:	48 ba 28 3c 80 00 00 	movabs $0x803c28,%rdx
  803469:	00 00 00 
  80346c:	be 33 00 00 00       	mov    $0x33,%esi
  803471:	48 bf 44 3c 80 00 00 	movabs $0x803c44,%rdi
  803478:	00 00 00 
  80347b:	b8 00 00 00 00       	mov    $0x0,%eax
  803480:	49 b8 da 25 80 00 00 	movabs $0x8025da,%r8
  803487:	00 00 00 
  80348a:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  80348d:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803490:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803493:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803497:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80349a:	89 c7                	mov    %eax,%edi
  80349c:	48 b8 74 0d 80 00 00 	movabs $0x800d74,%rax
  8034a3:	00 00 00 
  8034a6:	ff d0                	callq  *%rax
  8034a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  8034ab:	48 b8 62 0b 80 00 00 	movabs $0x800b62,%rax
  8034b2:	00 00 00 
  8034b5:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  8034b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034bb:	75 9a                	jne    803457 <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  8034bd:	c9                   	leaveq 
  8034be:	c3                   	retq   

00000000008034bf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8034bf:	55                   	push   %rbp
  8034c0:	48 89 e5             	mov    %rsp,%rbp
  8034c3:	48 83 ec 14          	sub    $0x14,%rsp
  8034c7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8034ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8034d1:	eb 5e                	jmp    803531 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8034d3:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8034da:	00 00 00 
  8034dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034e0:	48 63 d0             	movslq %eax,%rdx
  8034e3:	48 89 d0             	mov    %rdx,%rax
  8034e6:	48 c1 e0 03          	shl    $0x3,%rax
  8034ea:	48 01 d0             	add    %rdx,%rax
  8034ed:	48 c1 e0 05          	shl    $0x5,%rax
  8034f1:	48 01 c8             	add    %rcx,%rax
  8034f4:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8034fa:	8b 00                	mov    (%rax),%eax
  8034fc:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8034ff:	75 2c                	jne    80352d <ipc_find_env+0x6e>
			return envs[i].env_id;
  803501:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803508:	00 00 00 
  80350b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80350e:	48 63 d0             	movslq %eax,%rdx
  803511:	48 89 d0             	mov    %rdx,%rax
  803514:	48 c1 e0 03          	shl    $0x3,%rax
  803518:	48 01 d0             	add    %rdx,%rax
  80351b:	48 c1 e0 05          	shl    $0x5,%rax
  80351f:	48 01 c8             	add    %rcx,%rax
  803522:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803528:	8b 40 08             	mov    0x8(%rax),%eax
  80352b:	eb 12                	jmp    80353f <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80352d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803531:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803538:	7e 99                	jle    8034d3 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80353a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80353f:	c9                   	leaveq 
  803540:	c3                   	retq   

0000000000803541 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803541:	55                   	push   %rbp
  803542:	48 89 e5             	mov    %rsp,%rbp
  803545:	48 83 ec 18          	sub    $0x18,%rsp
  803549:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80354d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803551:	48 c1 e8 15          	shr    $0x15,%rax
  803555:	48 89 c2             	mov    %rax,%rdx
  803558:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80355f:	01 00 00 
  803562:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803566:	83 e0 01             	and    $0x1,%eax
  803569:	48 85 c0             	test   %rax,%rax
  80356c:	75 07                	jne    803575 <pageref+0x34>
		return 0;
  80356e:	b8 00 00 00 00       	mov    $0x0,%eax
  803573:	eb 53                	jmp    8035c8 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803575:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803579:	48 c1 e8 0c          	shr    $0xc,%rax
  80357d:	48 89 c2             	mov    %rax,%rdx
  803580:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803587:	01 00 00 
  80358a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80358e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803592:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803596:	83 e0 01             	and    $0x1,%eax
  803599:	48 85 c0             	test   %rax,%rax
  80359c:	75 07                	jne    8035a5 <pageref+0x64>
		return 0;
  80359e:	b8 00 00 00 00       	mov    $0x0,%eax
  8035a3:	eb 23                	jmp    8035c8 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8035a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035a9:	48 c1 e8 0c          	shr    $0xc,%rax
  8035ad:	48 89 c2             	mov    %rax,%rdx
  8035b0:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8035b7:	00 00 00 
  8035ba:	48 c1 e2 04          	shl    $0x4,%rdx
  8035be:	48 01 d0             	add    %rdx,%rax
  8035c1:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8035c5:	0f b7 c0             	movzwl %ax,%eax
}
  8035c8:	c9                   	leaveq 
  8035c9:	c3                   	retq   
