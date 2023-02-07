
obj/user/testkbd:     file format elf64-x86-64


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
  80003c:	e8 2a 04 00 00       	callq  80046b <libmain>
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
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
  800052:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800059:	eb 10                	jmp    80006b <umain+0x28>
		sys_yield();
  80005b:	48 b8 57 1d 80 00 00 	movabs $0x801d57,%rax
  800062:	00 00 00 
  800065:	ff d0                	callq  *%rax
umain(int argc, char **argv)
{
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
  800067:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80006b:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
  80006f:	7e ea                	jle    80005b <umain+0x18>
		sys_yield();

	close(0);
  800071:	bf 00 00 00 00       	mov    $0x0,%edi
  800076:	48 b8 f8 22 80 00 00 	movabs $0x8022f8,%rax
  80007d:	00 00 00 
  800080:	ff d0                	callq  *%rax
	if ((r = opencons()) < 0)
  800082:	48 b8 79 02 80 00 00 	movabs $0x800279,%rax
  800089:	00 00 00 
  80008c:	ff d0                	callq  *%rax
  80008e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800091:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800095:	79 30                	jns    8000c7 <umain+0x84>
		panic("opencons: %e", r);
  800097:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80009a:	89 c1                	mov    %eax,%ecx
  80009c:	48 ba a0 3a 80 00 00 	movabs $0x803aa0,%rdx
  8000a3:	00 00 00 
  8000a6:	be 0f 00 00 00       	mov    $0xf,%esi
  8000ab:	48 bf ad 3a 80 00 00 	movabs $0x803aad,%rdi
  8000b2:	00 00 00 
  8000b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ba:	49 b8 1e 05 80 00 00 	movabs $0x80051e,%r8
  8000c1:	00 00 00 
  8000c4:	41 ff d0             	callq  *%r8
	if (r != 0)
  8000c7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000cb:	74 30                	je     8000fd <umain+0xba>
		panic("first opencons used fd %d", r);
  8000cd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d0:	89 c1                	mov    %eax,%ecx
  8000d2:	48 ba bc 3a 80 00 00 	movabs $0x803abc,%rdx
  8000d9:	00 00 00 
  8000dc:	be 11 00 00 00       	mov    $0x11,%esi
  8000e1:	48 bf ad 3a 80 00 00 	movabs $0x803aad,%rdi
  8000e8:	00 00 00 
  8000eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f0:	49 b8 1e 05 80 00 00 	movabs $0x80051e,%r8
  8000f7:	00 00 00 
  8000fa:	41 ff d0             	callq  *%r8
	if ((r = dup(0, 1)) < 0)
  8000fd:	be 01 00 00 00       	mov    $0x1,%esi
  800102:	bf 00 00 00 00       	mov    $0x0,%edi
  800107:	48 b8 71 23 80 00 00 	movabs $0x802371,%rax
  80010e:	00 00 00 
  800111:	ff d0                	callq  *%rax
  800113:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800116:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80011a:	79 30                	jns    80014c <umain+0x109>
		panic("dup: %e", r);
  80011c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80011f:	89 c1                	mov    %eax,%ecx
  800121:	48 ba d6 3a 80 00 00 	movabs $0x803ad6,%rdx
  800128:	00 00 00 
  80012b:	be 13 00 00 00       	mov    $0x13,%esi
  800130:	48 bf ad 3a 80 00 00 	movabs $0x803aad,%rdi
  800137:	00 00 00 
  80013a:	b8 00 00 00 00       	mov    $0x0,%eax
  80013f:	49 b8 1e 05 80 00 00 	movabs $0x80051e,%r8
  800146:	00 00 00 
  800149:	41 ff d0             	callq  *%r8

	for(;;){
		char *buf;

		buf = readline("Type a line: ");
  80014c:	48 bf de 3a 80 00 00 	movabs $0x803ade,%rdi
  800153:	00 00 00 
  800156:	48 b8 a0 12 80 00 00 	movabs $0x8012a0,%rax
  80015d:	00 00 00 
  800160:	ff d0                	callq  *%rax
  800162:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if (buf != NULL)
  800166:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  80016b:	74 29                	je     800196 <umain+0x153>
			fprintf(1, "%s\n", buf);
  80016d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800171:	48 89 c2             	mov    %rax,%rdx
  800174:	48 be ec 3a 80 00 00 	movabs $0x803aec,%rsi
  80017b:	00 00 00 
  80017e:	bf 01 00 00 00       	mov    $0x1,%edi
  800183:	b8 00 00 00 00       	mov    $0x0,%eax
  800188:	48 b9 e9 30 80 00 00 	movabs $0x8030e9,%rcx
  80018f:	00 00 00 
  800192:	ff d1                	callq  *%rcx
		else
			fprintf(1, "(end of file received)\n");
	}
  800194:	eb b6                	jmp    80014c <umain+0x109>

		buf = readline("Type a line: ");
		if (buf != NULL)
			fprintf(1, "%s\n", buf);
		else
			fprintf(1, "(end of file received)\n");
  800196:	48 be f0 3a 80 00 00 	movabs $0x803af0,%rsi
  80019d:	00 00 00 
  8001a0:	bf 01 00 00 00       	mov    $0x1,%edi
  8001a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001aa:	48 ba e9 30 80 00 00 	movabs $0x8030e9,%rdx
  8001b1:	00 00 00 
  8001b4:	ff d2                	callq  *%rdx
	}
  8001b6:	eb 94                	jmp    80014c <umain+0x109>

00000000008001b8 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8001b8:	55                   	push   %rbp
  8001b9:	48 89 e5             	mov    %rsp,%rbp
  8001bc:	48 83 ec 20          	sub    $0x20,%rsp
  8001c0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8001c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001c6:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8001c9:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8001cd:	be 01 00 00 00       	mov    $0x1,%esi
  8001d2:	48 89 c7             	mov    %rax,%rdi
  8001d5:	48 b8 4d 1c 80 00 00 	movabs $0x801c4d,%rax
  8001dc:	00 00 00 
  8001df:	ff d0                	callq  *%rax
}
  8001e1:	c9                   	leaveq 
  8001e2:	c3                   	retq   

00000000008001e3 <getchar>:

int
getchar(void)
{
  8001e3:	55                   	push   %rbp
  8001e4:	48 89 e5             	mov    %rsp,%rbp
  8001e7:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8001eb:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8001ef:	ba 01 00 00 00       	mov    $0x1,%edx
  8001f4:	48 89 c6             	mov    %rax,%rsi
  8001f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8001fc:	48 b8 1a 25 80 00 00 	movabs $0x80251a,%rax
  800203:	00 00 00 
  800206:	ff d0                	callq  *%rax
  800208:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80020b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80020f:	79 05                	jns    800216 <getchar+0x33>
		return r;
  800211:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800214:	eb 14                	jmp    80022a <getchar+0x47>
	if (r < 1)
  800216:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80021a:	7f 07                	jg     800223 <getchar+0x40>
		return -E_EOF;
  80021c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800221:	eb 07                	jmp    80022a <getchar+0x47>
	return c;
  800223:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  800227:	0f b6 c0             	movzbl %al,%eax
}
  80022a:	c9                   	leaveq 
  80022b:	c3                   	retq   

000000000080022c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80022c:	55                   	push   %rbp
  80022d:	48 89 e5             	mov    %rsp,%rbp
  800230:	48 83 ec 20          	sub    $0x20,%rsp
  800234:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800237:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80023b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80023e:	48 89 d6             	mov    %rdx,%rsi
  800241:	89 c7                	mov    %eax,%edi
  800243:	48 b8 e8 20 80 00 00 	movabs $0x8020e8,%rax
  80024a:	00 00 00 
  80024d:	ff d0                	callq  *%rax
  80024f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800252:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800256:	79 05                	jns    80025d <iscons+0x31>
		return r;
  800258:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80025b:	eb 1a                	jmp    800277 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80025d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800261:	8b 10                	mov    (%rax),%edx
  800263:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80026a:	00 00 00 
  80026d:	8b 00                	mov    (%rax),%eax
  80026f:	39 c2                	cmp    %eax,%edx
  800271:	0f 94 c0             	sete   %al
  800274:	0f b6 c0             	movzbl %al,%eax
}
  800277:	c9                   	leaveq 
  800278:	c3                   	retq   

0000000000800279 <opencons>:

int
opencons(void)
{
  800279:	55                   	push   %rbp
  80027a:	48 89 e5             	mov    %rsp,%rbp
  80027d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800281:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800285:	48 89 c7             	mov    %rax,%rdi
  800288:	48 b8 50 20 80 00 00 	movabs $0x802050,%rax
  80028f:	00 00 00 
  800292:	ff d0                	callq  *%rax
  800294:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800297:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80029b:	79 05                	jns    8002a2 <opencons+0x29>
		return r;
  80029d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002a0:	eb 5b                	jmp    8002fd <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8002a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002a6:	ba 07 04 00 00       	mov    $0x407,%edx
  8002ab:	48 89 c6             	mov    %rax,%rsi
  8002ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b3:	48 b8 95 1d 80 00 00 	movabs $0x801d95,%rax
  8002ba:	00 00 00 
  8002bd:	ff d0                	callq  *%rax
  8002bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8002c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002c6:	79 05                	jns    8002cd <opencons+0x54>
		return r;
  8002c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002cb:	eb 30                	jmp    8002fd <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8002cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002d1:	48 ba 00 50 80 00 00 	movabs $0x805000,%rdx
  8002d8:	00 00 00 
  8002db:	8b 12                	mov    (%rdx),%edx
  8002dd:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8002df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002e3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8002ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002ee:	48 89 c7             	mov    %rax,%rdi
  8002f1:	48 b8 02 20 80 00 00 	movabs $0x802002,%rax
  8002f8:	00 00 00 
  8002fb:	ff d0                	callq  *%rax
}
  8002fd:	c9                   	leaveq 
  8002fe:	c3                   	retq   

00000000008002ff <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8002ff:	55                   	push   %rbp
  800300:	48 89 e5             	mov    %rsp,%rbp
  800303:	48 83 ec 30          	sub    $0x30,%rsp
  800307:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80030b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80030f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  800313:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800318:	75 07                	jne    800321 <devcons_read+0x22>
		return 0;
  80031a:	b8 00 00 00 00       	mov    $0x0,%eax
  80031f:	eb 4b                	jmp    80036c <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  800321:	eb 0c                	jmp    80032f <devcons_read+0x30>
		sys_yield();
  800323:	48 b8 57 1d 80 00 00 	movabs $0x801d57,%rax
  80032a:	00 00 00 
  80032d:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80032f:	48 b8 97 1c 80 00 00 	movabs $0x801c97,%rax
  800336:	00 00 00 
  800339:	ff d0                	callq  *%rax
  80033b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80033e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800342:	74 df                	je     800323 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  800344:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800348:	79 05                	jns    80034f <devcons_read+0x50>
		return c;
  80034a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80034d:	eb 1d                	jmp    80036c <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80034f:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800353:	75 07                	jne    80035c <devcons_read+0x5d>
		return 0;
  800355:	b8 00 00 00 00       	mov    $0x0,%eax
  80035a:	eb 10                	jmp    80036c <devcons_read+0x6d>
	*(char*)vbuf = c;
  80035c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80035f:	89 c2                	mov    %eax,%edx
  800361:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800365:	88 10                	mov    %dl,(%rax)
	return 1;
  800367:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80036c:	c9                   	leaveq 
  80036d:	c3                   	retq   

000000000080036e <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80036e:	55                   	push   %rbp
  80036f:	48 89 e5             	mov    %rsp,%rbp
  800372:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  800379:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  800380:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  800387:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80038e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800395:	eb 76                	jmp    80040d <devcons_write+0x9f>
		m = n - tot;
  800397:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80039e:	89 c2                	mov    %eax,%edx
  8003a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003a3:	29 c2                	sub    %eax,%edx
  8003a5:	89 d0                	mov    %edx,%eax
  8003a7:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8003aa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003ad:	83 f8 7f             	cmp    $0x7f,%eax
  8003b0:	76 07                	jbe    8003b9 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8003b2:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8003b9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003bc:	48 63 d0             	movslq %eax,%rdx
  8003bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003c2:	48 63 c8             	movslq %eax,%rcx
  8003c5:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8003cc:	48 01 c1             	add    %rax,%rcx
  8003cf:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8003d6:	48 89 ce             	mov    %rcx,%rsi
  8003d9:	48 89 c7             	mov    %rax,%rdi
  8003dc:	48 b8 8a 17 80 00 00 	movabs $0x80178a,%rax
  8003e3:	00 00 00 
  8003e6:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8003e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003eb:	48 63 d0             	movslq %eax,%rdx
  8003ee:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8003f5:	48 89 d6             	mov    %rdx,%rsi
  8003f8:	48 89 c7             	mov    %rax,%rdi
  8003fb:	48 b8 4d 1c 80 00 00 	movabs $0x801c4d,%rax
  800402:	00 00 00 
  800405:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800407:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80040a:	01 45 fc             	add    %eax,-0x4(%rbp)
  80040d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800410:	48 98                	cltq   
  800412:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  800419:	0f 82 78 ff ff ff    	jb     800397 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80041f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800422:	c9                   	leaveq 
  800423:	c3                   	retq   

0000000000800424 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  800424:	55                   	push   %rbp
  800425:	48 89 e5             	mov    %rsp,%rbp
  800428:	48 83 ec 08          	sub    $0x8,%rsp
  80042c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  800430:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800435:	c9                   	leaveq 
  800436:	c3                   	retq   

0000000000800437 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800437:	55                   	push   %rbp
  800438:	48 89 e5             	mov    %rsp,%rbp
  80043b:	48 83 ec 10          	sub    $0x10,%rsp
  80043f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800443:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  800447:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80044b:	48 be 0d 3b 80 00 00 	movabs $0x803b0d,%rsi
  800452:	00 00 00 
  800455:	48 89 c7             	mov    %rax,%rdi
  800458:	48 b8 66 14 80 00 00 	movabs $0x801466,%rax
  80045f:	00 00 00 
  800462:	ff d0                	callq  *%rax
	return 0;
  800464:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800469:	c9                   	leaveq 
  80046a:	c3                   	retq   

000000000080046b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80046b:	55                   	push   %rbp
  80046c:	48 89 e5             	mov    %rsp,%rbp
  80046f:	48 83 ec 10          	sub    $0x10,%rsp
  800473:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800476:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  80047a:	48 b8 19 1d 80 00 00 	movabs $0x801d19,%rax
  800481:	00 00 00 
  800484:	ff d0                	callq  *%rax
  800486:	48 98                	cltq   
  800488:	25 ff 03 00 00       	and    $0x3ff,%eax
  80048d:	48 89 c2             	mov    %rax,%rdx
  800490:	48 89 d0             	mov    %rdx,%rax
  800493:	48 c1 e0 03          	shl    $0x3,%rax
  800497:	48 01 d0             	add    %rdx,%rax
  80049a:	48 c1 e0 05          	shl    $0x5,%rax
  80049e:	48 89 c2             	mov    %rax,%rdx
  8004a1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8004a8:	00 00 00 
  8004ab:	48 01 c2             	add    %rax,%rdx
  8004ae:	48 b8 08 64 80 00 00 	movabs $0x806408,%rax
  8004b5:	00 00 00 
  8004b8:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004bf:	7e 14                	jle    8004d5 <libmain+0x6a>
		binaryname = argv[0];
  8004c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004c5:	48 8b 10             	mov    (%rax),%rdx
  8004c8:	48 b8 38 50 80 00 00 	movabs $0x805038,%rax
  8004cf:	00 00 00 
  8004d2:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8004d5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004dc:	48 89 d6             	mov    %rdx,%rsi
  8004df:	89 c7                	mov    %eax,%edi
  8004e1:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8004e8:	00 00 00 
  8004eb:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8004ed:	48 b8 fb 04 80 00 00 	movabs $0x8004fb,%rax
  8004f4:	00 00 00 
  8004f7:	ff d0                	callq  *%rax
}
  8004f9:	c9                   	leaveq 
  8004fa:	c3                   	retq   

00000000008004fb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8004fb:	55                   	push   %rbp
  8004fc:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8004ff:	48 b8 43 23 80 00 00 	movabs $0x802343,%rax
  800506:	00 00 00 
  800509:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80050b:	bf 00 00 00 00       	mov    $0x0,%edi
  800510:	48 b8 d5 1c 80 00 00 	movabs $0x801cd5,%rax
  800517:	00 00 00 
  80051a:	ff d0                	callq  *%rax
}
  80051c:	5d                   	pop    %rbp
  80051d:	c3                   	retq   

000000000080051e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80051e:	55                   	push   %rbp
  80051f:	48 89 e5             	mov    %rsp,%rbp
  800522:	53                   	push   %rbx
  800523:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80052a:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800531:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800537:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80053e:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800545:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80054c:	84 c0                	test   %al,%al
  80054e:	74 23                	je     800573 <_panic+0x55>
  800550:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800557:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80055b:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80055f:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800563:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800567:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80056b:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80056f:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800573:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80057a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800581:	00 00 00 
  800584:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80058b:	00 00 00 
  80058e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800592:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800599:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8005a0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8005a7:	48 b8 38 50 80 00 00 	movabs $0x805038,%rax
  8005ae:	00 00 00 
  8005b1:	48 8b 18             	mov    (%rax),%rbx
  8005b4:	48 b8 19 1d 80 00 00 	movabs $0x801d19,%rax
  8005bb:	00 00 00 
  8005be:	ff d0                	callq  *%rax
  8005c0:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8005c6:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8005cd:	41 89 c8             	mov    %ecx,%r8d
  8005d0:	48 89 d1             	mov    %rdx,%rcx
  8005d3:	48 89 da             	mov    %rbx,%rdx
  8005d6:	89 c6                	mov    %eax,%esi
  8005d8:	48 bf 20 3b 80 00 00 	movabs $0x803b20,%rdi
  8005df:	00 00 00 
  8005e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e7:	49 b9 57 07 80 00 00 	movabs $0x800757,%r9
  8005ee:	00 00 00 
  8005f1:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005f4:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8005fb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800602:	48 89 d6             	mov    %rdx,%rsi
  800605:	48 89 c7             	mov    %rax,%rdi
  800608:	48 b8 ab 06 80 00 00 	movabs $0x8006ab,%rax
  80060f:	00 00 00 
  800612:	ff d0                	callq  *%rax
	cprintf("\n");
  800614:	48 bf 43 3b 80 00 00 	movabs $0x803b43,%rdi
  80061b:	00 00 00 
  80061e:	b8 00 00 00 00       	mov    $0x0,%eax
  800623:	48 ba 57 07 80 00 00 	movabs $0x800757,%rdx
  80062a:	00 00 00 
  80062d:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80062f:	cc                   	int3   
  800630:	eb fd                	jmp    80062f <_panic+0x111>

0000000000800632 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800632:	55                   	push   %rbp
  800633:	48 89 e5             	mov    %rsp,%rbp
  800636:	48 83 ec 10          	sub    $0x10,%rsp
  80063a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80063d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800641:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800645:	8b 00                	mov    (%rax),%eax
  800647:	8d 48 01             	lea    0x1(%rax),%ecx
  80064a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80064e:	89 0a                	mov    %ecx,(%rdx)
  800650:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800653:	89 d1                	mov    %edx,%ecx
  800655:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800659:	48 98                	cltq   
  80065b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80065f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800663:	8b 00                	mov    (%rax),%eax
  800665:	3d ff 00 00 00       	cmp    $0xff,%eax
  80066a:	75 2c                	jne    800698 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80066c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800670:	8b 00                	mov    (%rax),%eax
  800672:	48 98                	cltq   
  800674:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800678:	48 83 c2 08          	add    $0x8,%rdx
  80067c:	48 89 c6             	mov    %rax,%rsi
  80067f:	48 89 d7             	mov    %rdx,%rdi
  800682:	48 b8 4d 1c 80 00 00 	movabs $0x801c4d,%rax
  800689:	00 00 00 
  80068c:	ff d0                	callq  *%rax
        b->idx = 0;
  80068e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800692:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800698:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80069c:	8b 40 04             	mov    0x4(%rax),%eax
  80069f:	8d 50 01             	lea    0x1(%rax),%edx
  8006a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006a6:	89 50 04             	mov    %edx,0x4(%rax)
}
  8006a9:	c9                   	leaveq 
  8006aa:	c3                   	retq   

00000000008006ab <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8006ab:	55                   	push   %rbp
  8006ac:	48 89 e5             	mov    %rsp,%rbp
  8006af:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8006b6:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8006bd:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8006c4:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006cb:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006d2:	48 8b 0a             	mov    (%rdx),%rcx
  8006d5:	48 89 08             	mov    %rcx,(%rax)
  8006d8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006dc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006e0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006e4:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8006e8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8006ef:	00 00 00 
    b.cnt = 0;
  8006f2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8006f9:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8006fc:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800703:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80070a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800711:	48 89 c6             	mov    %rax,%rsi
  800714:	48 bf 32 06 80 00 00 	movabs $0x800632,%rdi
  80071b:	00 00 00 
  80071e:	48 b8 0a 0b 80 00 00 	movabs $0x800b0a,%rax
  800725:	00 00 00 
  800728:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80072a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800730:	48 98                	cltq   
  800732:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800739:	48 83 c2 08          	add    $0x8,%rdx
  80073d:	48 89 c6             	mov    %rax,%rsi
  800740:	48 89 d7             	mov    %rdx,%rdi
  800743:	48 b8 4d 1c 80 00 00 	movabs $0x801c4d,%rax
  80074a:	00 00 00 
  80074d:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80074f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800755:	c9                   	leaveq 
  800756:	c3                   	retq   

0000000000800757 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800757:	55                   	push   %rbp
  800758:	48 89 e5             	mov    %rsp,%rbp
  80075b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800762:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800769:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800770:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800777:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80077e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800785:	84 c0                	test   %al,%al
  800787:	74 20                	je     8007a9 <cprintf+0x52>
  800789:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80078d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800791:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800795:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800799:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80079d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8007a1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8007a5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8007a9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8007b0:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8007b7:	00 00 00 
  8007ba:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8007c1:	00 00 00 
  8007c4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007c8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007cf:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007d6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8007dd:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007e4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007eb:	48 8b 0a             	mov    (%rdx),%rcx
  8007ee:	48 89 08             	mov    %rcx,(%rax)
  8007f1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007f5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007f9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007fd:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800801:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800808:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80080f:	48 89 d6             	mov    %rdx,%rsi
  800812:	48 89 c7             	mov    %rax,%rdi
  800815:	48 b8 ab 06 80 00 00 	movabs $0x8006ab,%rax
  80081c:	00 00 00 
  80081f:	ff d0                	callq  *%rax
  800821:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800827:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80082d:	c9                   	leaveq 
  80082e:	c3                   	retq   

000000000080082f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80082f:	55                   	push   %rbp
  800830:	48 89 e5             	mov    %rsp,%rbp
  800833:	53                   	push   %rbx
  800834:	48 83 ec 38          	sub    $0x38,%rsp
  800838:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80083c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800840:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800844:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800847:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80084b:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80084f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800852:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800856:	77 3b                	ja     800893 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800858:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80085b:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80085f:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800862:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800866:	ba 00 00 00 00       	mov    $0x0,%edx
  80086b:	48 f7 f3             	div    %rbx
  80086e:	48 89 c2             	mov    %rax,%rdx
  800871:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800874:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800877:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80087b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087f:	41 89 f9             	mov    %edi,%r9d
  800882:	48 89 c7             	mov    %rax,%rdi
  800885:	48 b8 2f 08 80 00 00 	movabs $0x80082f,%rax
  80088c:	00 00 00 
  80088f:	ff d0                	callq  *%rax
  800891:	eb 1e                	jmp    8008b1 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800893:	eb 12                	jmp    8008a7 <printnum+0x78>
			putch(padc, putdat);
  800895:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800899:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80089c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a0:	48 89 ce             	mov    %rcx,%rsi
  8008a3:	89 d7                	mov    %edx,%edi
  8008a5:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008a7:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8008ab:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8008af:	7f e4                	jg     800895 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008b1:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8008b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8008bd:	48 f7 f1             	div    %rcx
  8008c0:	48 89 d0             	mov    %rdx,%rax
  8008c3:	48 ba 50 3d 80 00 00 	movabs $0x803d50,%rdx
  8008ca:	00 00 00 
  8008cd:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8008d1:	0f be d0             	movsbl %al,%edx
  8008d4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8008d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008dc:	48 89 ce             	mov    %rcx,%rsi
  8008df:	89 d7                	mov    %edx,%edi
  8008e1:	ff d0                	callq  *%rax
}
  8008e3:	48 83 c4 38          	add    $0x38,%rsp
  8008e7:	5b                   	pop    %rbx
  8008e8:	5d                   	pop    %rbp
  8008e9:	c3                   	retq   

00000000008008ea <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008ea:	55                   	push   %rbp
  8008eb:	48 89 e5             	mov    %rsp,%rbp
  8008ee:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008f6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8008f9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008fd:	7e 52                	jle    800951 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8008ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800903:	8b 00                	mov    (%rax),%eax
  800905:	83 f8 30             	cmp    $0x30,%eax
  800908:	73 24                	jae    80092e <getuint+0x44>
  80090a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800912:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800916:	8b 00                	mov    (%rax),%eax
  800918:	89 c0                	mov    %eax,%eax
  80091a:	48 01 d0             	add    %rdx,%rax
  80091d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800921:	8b 12                	mov    (%rdx),%edx
  800923:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800926:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80092a:	89 0a                	mov    %ecx,(%rdx)
  80092c:	eb 17                	jmp    800945 <getuint+0x5b>
  80092e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800932:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800936:	48 89 d0             	mov    %rdx,%rax
  800939:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80093d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800941:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800945:	48 8b 00             	mov    (%rax),%rax
  800948:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80094c:	e9 a3 00 00 00       	jmpq   8009f4 <getuint+0x10a>
	else if (lflag)
  800951:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800955:	74 4f                	je     8009a6 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800957:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095b:	8b 00                	mov    (%rax),%eax
  80095d:	83 f8 30             	cmp    $0x30,%eax
  800960:	73 24                	jae    800986 <getuint+0x9c>
  800962:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800966:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80096a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80096e:	8b 00                	mov    (%rax),%eax
  800970:	89 c0                	mov    %eax,%eax
  800972:	48 01 d0             	add    %rdx,%rax
  800975:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800979:	8b 12                	mov    (%rdx),%edx
  80097b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80097e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800982:	89 0a                	mov    %ecx,(%rdx)
  800984:	eb 17                	jmp    80099d <getuint+0xb3>
  800986:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80098e:	48 89 d0             	mov    %rdx,%rax
  800991:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800995:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800999:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80099d:	48 8b 00             	mov    (%rax),%rax
  8009a0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009a4:	eb 4e                	jmp    8009f4 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8009a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009aa:	8b 00                	mov    (%rax),%eax
  8009ac:	83 f8 30             	cmp    $0x30,%eax
  8009af:	73 24                	jae    8009d5 <getuint+0xeb>
  8009b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009bd:	8b 00                	mov    (%rax),%eax
  8009bf:	89 c0                	mov    %eax,%eax
  8009c1:	48 01 d0             	add    %rdx,%rax
  8009c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c8:	8b 12                	mov    (%rdx),%edx
  8009ca:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d1:	89 0a                	mov    %ecx,(%rdx)
  8009d3:	eb 17                	jmp    8009ec <getuint+0x102>
  8009d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009dd:	48 89 d0             	mov    %rdx,%rax
  8009e0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009ec:	8b 00                	mov    (%rax),%eax
  8009ee:	89 c0                	mov    %eax,%eax
  8009f0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009f8:	c9                   	leaveq 
  8009f9:	c3                   	retq   

00000000008009fa <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009fa:	55                   	push   %rbp
  8009fb:	48 89 e5             	mov    %rsp,%rbp
  8009fe:	48 83 ec 1c          	sub    $0x1c,%rsp
  800a02:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a06:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800a09:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a0d:	7e 52                	jle    800a61 <getint+0x67>
		x=va_arg(*ap, long long);
  800a0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a13:	8b 00                	mov    (%rax),%eax
  800a15:	83 f8 30             	cmp    $0x30,%eax
  800a18:	73 24                	jae    800a3e <getint+0x44>
  800a1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a1e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a26:	8b 00                	mov    (%rax),%eax
  800a28:	89 c0                	mov    %eax,%eax
  800a2a:	48 01 d0             	add    %rdx,%rax
  800a2d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a31:	8b 12                	mov    (%rdx),%edx
  800a33:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a36:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a3a:	89 0a                	mov    %ecx,(%rdx)
  800a3c:	eb 17                	jmp    800a55 <getint+0x5b>
  800a3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a42:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a46:	48 89 d0             	mov    %rdx,%rax
  800a49:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a4d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a51:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a55:	48 8b 00             	mov    (%rax),%rax
  800a58:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a5c:	e9 a3 00 00 00       	jmpq   800b04 <getint+0x10a>
	else if (lflag)
  800a61:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a65:	74 4f                	je     800ab6 <getint+0xbc>
		x=va_arg(*ap, long);
  800a67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a6b:	8b 00                	mov    (%rax),%eax
  800a6d:	83 f8 30             	cmp    $0x30,%eax
  800a70:	73 24                	jae    800a96 <getint+0x9c>
  800a72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a76:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a7e:	8b 00                	mov    (%rax),%eax
  800a80:	89 c0                	mov    %eax,%eax
  800a82:	48 01 d0             	add    %rdx,%rax
  800a85:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a89:	8b 12                	mov    (%rdx),%edx
  800a8b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a8e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a92:	89 0a                	mov    %ecx,(%rdx)
  800a94:	eb 17                	jmp    800aad <getint+0xb3>
  800a96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a9a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a9e:	48 89 d0             	mov    %rdx,%rax
  800aa1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800aa5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aa9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800aad:	48 8b 00             	mov    (%rax),%rax
  800ab0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800ab4:	eb 4e                	jmp    800b04 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800ab6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aba:	8b 00                	mov    (%rax),%eax
  800abc:	83 f8 30             	cmp    $0x30,%eax
  800abf:	73 24                	jae    800ae5 <getint+0xeb>
  800ac1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ac9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800acd:	8b 00                	mov    (%rax),%eax
  800acf:	89 c0                	mov    %eax,%eax
  800ad1:	48 01 d0             	add    %rdx,%rax
  800ad4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad8:	8b 12                	mov    (%rdx),%edx
  800ada:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800add:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ae1:	89 0a                	mov    %ecx,(%rdx)
  800ae3:	eb 17                	jmp    800afc <getint+0x102>
  800ae5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800aed:	48 89 d0             	mov    %rdx,%rax
  800af0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800af4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800af8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800afc:	8b 00                	mov    (%rax),%eax
  800afe:	48 98                	cltq   
  800b00:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800b04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800b08:	c9                   	leaveq 
  800b09:	c3                   	retq   

0000000000800b0a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b0a:	55                   	push   %rbp
  800b0b:	48 89 e5             	mov    %rsp,%rbp
  800b0e:	41 54                	push   %r12
  800b10:	53                   	push   %rbx
  800b11:	48 83 ec 60          	sub    $0x60,%rsp
  800b15:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800b19:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800b1d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b21:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800b25:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b29:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b2d:	48 8b 0a             	mov    (%rdx),%rcx
  800b30:	48 89 08             	mov    %rcx,(%rax)
  800b33:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b37:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b3b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b3f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b43:	eb 17                	jmp    800b5c <vprintfmt+0x52>
			if (ch == '\0')
  800b45:	85 db                	test   %ebx,%ebx
  800b47:	0f 84 cc 04 00 00    	je     801019 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800b4d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b51:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b55:	48 89 d6             	mov    %rdx,%rsi
  800b58:	89 df                	mov    %ebx,%edi
  800b5a:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b5c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b60:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b64:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b68:	0f b6 00             	movzbl (%rax),%eax
  800b6b:	0f b6 d8             	movzbl %al,%ebx
  800b6e:	83 fb 25             	cmp    $0x25,%ebx
  800b71:	75 d2                	jne    800b45 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b73:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b77:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b7e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b85:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b8c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b93:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b97:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b9b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b9f:	0f b6 00             	movzbl (%rax),%eax
  800ba2:	0f b6 d8             	movzbl %al,%ebx
  800ba5:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800ba8:	83 f8 55             	cmp    $0x55,%eax
  800bab:	0f 87 34 04 00 00    	ja     800fe5 <vprintfmt+0x4db>
  800bb1:	89 c0                	mov    %eax,%eax
  800bb3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800bba:	00 
  800bbb:	48 b8 78 3d 80 00 00 	movabs $0x803d78,%rax
  800bc2:	00 00 00 
  800bc5:	48 01 d0             	add    %rdx,%rax
  800bc8:	48 8b 00             	mov    (%rax),%rax
  800bcb:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800bcd:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800bd1:	eb c0                	jmp    800b93 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bd3:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800bd7:	eb ba                	jmp    800b93 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bd9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800be0:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800be3:	89 d0                	mov    %edx,%eax
  800be5:	c1 e0 02             	shl    $0x2,%eax
  800be8:	01 d0                	add    %edx,%eax
  800bea:	01 c0                	add    %eax,%eax
  800bec:	01 d8                	add    %ebx,%eax
  800bee:	83 e8 30             	sub    $0x30,%eax
  800bf1:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800bf4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bf8:	0f b6 00             	movzbl (%rax),%eax
  800bfb:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bfe:	83 fb 2f             	cmp    $0x2f,%ebx
  800c01:	7e 0c                	jle    800c0f <vprintfmt+0x105>
  800c03:	83 fb 39             	cmp    $0x39,%ebx
  800c06:	7f 07                	jg     800c0f <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c08:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c0d:	eb d1                	jmp    800be0 <vprintfmt+0xd6>
			goto process_precision;
  800c0f:	eb 58                	jmp    800c69 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800c11:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c14:	83 f8 30             	cmp    $0x30,%eax
  800c17:	73 17                	jae    800c30 <vprintfmt+0x126>
  800c19:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c1d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c20:	89 c0                	mov    %eax,%eax
  800c22:	48 01 d0             	add    %rdx,%rax
  800c25:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c28:	83 c2 08             	add    $0x8,%edx
  800c2b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c2e:	eb 0f                	jmp    800c3f <vprintfmt+0x135>
  800c30:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c34:	48 89 d0             	mov    %rdx,%rax
  800c37:	48 83 c2 08          	add    $0x8,%rdx
  800c3b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c3f:	8b 00                	mov    (%rax),%eax
  800c41:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c44:	eb 23                	jmp    800c69 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800c46:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c4a:	79 0c                	jns    800c58 <vprintfmt+0x14e>
				width = 0;
  800c4c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c53:	e9 3b ff ff ff       	jmpq   800b93 <vprintfmt+0x89>
  800c58:	e9 36 ff ff ff       	jmpq   800b93 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c5d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c64:	e9 2a ff ff ff       	jmpq   800b93 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800c69:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c6d:	79 12                	jns    800c81 <vprintfmt+0x177>
				width = precision, precision = -1;
  800c6f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c72:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c75:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c7c:	e9 12 ff ff ff       	jmpq   800b93 <vprintfmt+0x89>
  800c81:	e9 0d ff ff ff       	jmpq   800b93 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c86:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c8a:	e9 04 ff ff ff       	jmpq   800b93 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c8f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c92:	83 f8 30             	cmp    $0x30,%eax
  800c95:	73 17                	jae    800cae <vprintfmt+0x1a4>
  800c97:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c9b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c9e:	89 c0                	mov    %eax,%eax
  800ca0:	48 01 d0             	add    %rdx,%rax
  800ca3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ca6:	83 c2 08             	add    $0x8,%edx
  800ca9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cac:	eb 0f                	jmp    800cbd <vprintfmt+0x1b3>
  800cae:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cb2:	48 89 d0             	mov    %rdx,%rax
  800cb5:	48 83 c2 08          	add    $0x8,%rdx
  800cb9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cbd:	8b 10                	mov    (%rax),%edx
  800cbf:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cc3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cc7:	48 89 ce             	mov    %rcx,%rsi
  800cca:	89 d7                	mov    %edx,%edi
  800ccc:	ff d0                	callq  *%rax
			break;
  800cce:	e9 40 03 00 00       	jmpq   801013 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800cd3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cd6:	83 f8 30             	cmp    $0x30,%eax
  800cd9:	73 17                	jae    800cf2 <vprintfmt+0x1e8>
  800cdb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cdf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ce2:	89 c0                	mov    %eax,%eax
  800ce4:	48 01 d0             	add    %rdx,%rax
  800ce7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cea:	83 c2 08             	add    $0x8,%edx
  800ced:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cf0:	eb 0f                	jmp    800d01 <vprintfmt+0x1f7>
  800cf2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cf6:	48 89 d0             	mov    %rdx,%rax
  800cf9:	48 83 c2 08          	add    $0x8,%rdx
  800cfd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d01:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800d03:	85 db                	test   %ebx,%ebx
  800d05:	79 02                	jns    800d09 <vprintfmt+0x1ff>
				err = -err;
  800d07:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d09:	83 fb 15             	cmp    $0x15,%ebx
  800d0c:	7f 16                	jg     800d24 <vprintfmt+0x21a>
  800d0e:	48 b8 a0 3c 80 00 00 	movabs $0x803ca0,%rax
  800d15:	00 00 00 
  800d18:	48 63 d3             	movslq %ebx,%rdx
  800d1b:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800d1f:	4d 85 e4             	test   %r12,%r12
  800d22:	75 2e                	jne    800d52 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800d24:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d28:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d2c:	89 d9                	mov    %ebx,%ecx
  800d2e:	48 ba 61 3d 80 00 00 	movabs $0x803d61,%rdx
  800d35:	00 00 00 
  800d38:	48 89 c7             	mov    %rax,%rdi
  800d3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d40:	49 b8 22 10 80 00 00 	movabs $0x801022,%r8
  800d47:	00 00 00 
  800d4a:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d4d:	e9 c1 02 00 00       	jmpq   801013 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d52:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d56:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d5a:	4c 89 e1             	mov    %r12,%rcx
  800d5d:	48 ba 6a 3d 80 00 00 	movabs $0x803d6a,%rdx
  800d64:	00 00 00 
  800d67:	48 89 c7             	mov    %rax,%rdi
  800d6a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6f:	49 b8 22 10 80 00 00 	movabs $0x801022,%r8
  800d76:	00 00 00 
  800d79:	41 ff d0             	callq  *%r8
			break;
  800d7c:	e9 92 02 00 00       	jmpq   801013 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d81:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d84:	83 f8 30             	cmp    $0x30,%eax
  800d87:	73 17                	jae    800da0 <vprintfmt+0x296>
  800d89:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d8d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d90:	89 c0                	mov    %eax,%eax
  800d92:	48 01 d0             	add    %rdx,%rax
  800d95:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d98:	83 c2 08             	add    $0x8,%edx
  800d9b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d9e:	eb 0f                	jmp    800daf <vprintfmt+0x2a5>
  800da0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800da4:	48 89 d0             	mov    %rdx,%rax
  800da7:	48 83 c2 08          	add    $0x8,%rdx
  800dab:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800daf:	4c 8b 20             	mov    (%rax),%r12
  800db2:	4d 85 e4             	test   %r12,%r12
  800db5:	75 0a                	jne    800dc1 <vprintfmt+0x2b7>
				p = "(null)";
  800db7:	49 bc 6d 3d 80 00 00 	movabs $0x803d6d,%r12
  800dbe:	00 00 00 
			if (width > 0 && padc != '-')
  800dc1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dc5:	7e 3f                	jle    800e06 <vprintfmt+0x2fc>
  800dc7:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800dcb:	74 39                	je     800e06 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dcd:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800dd0:	48 98                	cltq   
  800dd2:	48 89 c6             	mov    %rax,%rsi
  800dd5:	4c 89 e7             	mov    %r12,%rdi
  800dd8:	48 b8 28 14 80 00 00 	movabs $0x801428,%rax
  800ddf:	00 00 00 
  800de2:	ff d0                	callq  *%rax
  800de4:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800de7:	eb 17                	jmp    800e00 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800de9:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800ded:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800df1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800df5:	48 89 ce             	mov    %rcx,%rsi
  800df8:	89 d7                	mov    %edx,%edi
  800dfa:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dfc:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e00:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e04:	7f e3                	jg     800de9 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e06:	eb 37                	jmp    800e3f <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800e08:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800e0c:	74 1e                	je     800e2c <vprintfmt+0x322>
  800e0e:	83 fb 1f             	cmp    $0x1f,%ebx
  800e11:	7e 05                	jle    800e18 <vprintfmt+0x30e>
  800e13:	83 fb 7e             	cmp    $0x7e,%ebx
  800e16:	7e 14                	jle    800e2c <vprintfmt+0x322>
					putch('?', putdat);
  800e18:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e1c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e20:	48 89 d6             	mov    %rdx,%rsi
  800e23:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e28:	ff d0                	callq  *%rax
  800e2a:	eb 0f                	jmp    800e3b <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800e2c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e30:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e34:	48 89 d6             	mov    %rdx,%rsi
  800e37:	89 df                	mov    %ebx,%edi
  800e39:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e3b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e3f:	4c 89 e0             	mov    %r12,%rax
  800e42:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e46:	0f b6 00             	movzbl (%rax),%eax
  800e49:	0f be d8             	movsbl %al,%ebx
  800e4c:	85 db                	test   %ebx,%ebx
  800e4e:	74 10                	je     800e60 <vprintfmt+0x356>
  800e50:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e54:	78 b2                	js     800e08 <vprintfmt+0x2fe>
  800e56:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e5a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e5e:	79 a8                	jns    800e08 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e60:	eb 16                	jmp    800e78 <vprintfmt+0x36e>
				putch(' ', putdat);
  800e62:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e66:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e6a:	48 89 d6             	mov    %rdx,%rsi
  800e6d:	bf 20 00 00 00       	mov    $0x20,%edi
  800e72:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e74:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e78:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e7c:	7f e4                	jg     800e62 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800e7e:	e9 90 01 00 00       	jmpq   801013 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e83:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e87:	be 03 00 00 00       	mov    $0x3,%esi
  800e8c:	48 89 c7             	mov    %rax,%rdi
  800e8f:	48 b8 fa 09 80 00 00 	movabs $0x8009fa,%rax
  800e96:	00 00 00 
  800e99:	ff d0                	callq  *%rax
  800e9b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea3:	48 85 c0             	test   %rax,%rax
  800ea6:	79 1d                	jns    800ec5 <vprintfmt+0x3bb>
				putch('-', putdat);
  800ea8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eac:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eb0:	48 89 d6             	mov    %rdx,%rsi
  800eb3:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800eb8:	ff d0                	callq  *%rax
				num = -(long long) num;
  800eba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ebe:	48 f7 d8             	neg    %rax
  800ec1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800ec5:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ecc:	e9 d5 00 00 00       	jmpq   800fa6 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800ed1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ed5:	be 03 00 00 00       	mov    $0x3,%esi
  800eda:	48 89 c7             	mov    %rax,%rdi
  800edd:	48 b8 ea 08 80 00 00 	movabs $0x8008ea,%rax
  800ee4:	00 00 00 
  800ee7:	ff d0                	callq  *%rax
  800ee9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800eed:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ef4:	e9 ad 00 00 00       	jmpq   800fa6 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  800ef9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800efd:	be 03 00 00 00       	mov    $0x3,%esi
  800f02:	48 89 c7             	mov    %rax,%rdi
  800f05:	48 b8 ea 08 80 00 00 	movabs $0x8008ea,%rax
  800f0c:	00 00 00 
  800f0f:	ff d0                	callq  *%rax
  800f11:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  800f15:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  800f1c:	e9 85 00 00 00       	jmpq   800fa6 <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  800f21:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f25:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f29:	48 89 d6             	mov    %rdx,%rsi
  800f2c:	bf 30 00 00 00       	mov    $0x30,%edi
  800f31:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f33:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f37:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f3b:	48 89 d6             	mov    %rdx,%rsi
  800f3e:	bf 78 00 00 00       	mov    $0x78,%edi
  800f43:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f45:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f48:	83 f8 30             	cmp    $0x30,%eax
  800f4b:	73 17                	jae    800f64 <vprintfmt+0x45a>
  800f4d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f51:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f54:	89 c0                	mov    %eax,%eax
  800f56:	48 01 d0             	add    %rdx,%rax
  800f59:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f5c:	83 c2 08             	add    $0x8,%edx
  800f5f:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f62:	eb 0f                	jmp    800f73 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800f64:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f68:	48 89 d0             	mov    %rdx,%rax
  800f6b:	48 83 c2 08          	add    $0x8,%rdx
  800f6f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f73:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f76:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f7a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f81:	eb 23                	jmp    800fa6 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f83:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f87:	be 03 00 00 00       	mov    $0x3,%esi
  800f8c:	48 89 c7             	mov    %rax,%rdi
  800f8f:	48 b8 ea 08 80 00 00 	movabs $0x8008ea,%rax
  800f96:	00 00 00 
  800f99:	ff d0                	callq  *%rax
  800f9b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f9f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fa6:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800fab:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800fae:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800fb1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fb5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800fb9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fbd:	45 89 c1             	mov    %r8d,%r9d
  800fc0:	41 89 f8             	mov    %edi,%r8d
  800fc3:	48 89 c7             	mov    %rax,%rdi
  800fc6:	48 b8 2f 08 80 00 00 	movabs $0x80082f,%rax
  800fcd:	00 00 00 
  800fd0:	ff d0                	callq  *%rax
			break;
  800fd2:	eb 3f                	jmp    801013 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fd4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fd8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fdc:	48 89 d6             	mov    %rdx,%rsi
  800fdf:	89 df                	mov    %ebx,%edi
  800fe1:	ff d0                	callq  *%rax
			break;
  800fe3:	eb 2e                	jmp    801013 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fe5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fe9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fed:	48 89 d6             	mov    %rdx,%rsi
  800ff0:	bf 25 00 00 00       	mov    $0x25,%edi
  800ff5:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ff7:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ffc:	eb 05                	jmp    801003 <vprintfmt+0x4f9>
  800ffe:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801003:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801007:	48 83 e8 01          	sub    $0x1,%rax
  80100b:	0f b6 00             	movzbl (%rax),%eax
  80100e:	3c 25                	cmp    $0x25,%al
  801010:	75 ec                	jne    800ffe <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  801012:	90                   	nop
		}
	}
  801013:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801014:	e9 43 fb ff ff       	jmpq   800b5c <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801019:	48 83 c4 60          	add    $0x60,%rsp
  80101d:	5b                   	pop    %rbx
  80101e:	41 5c                	pop    %r12
  801020:	5d                   	pop    %rbp
  801021:	c3                   	retq   

0000000000801022 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801022:	55                   	push   %rbp
  801023:	48 89 e5             	mov    %rsp,%rbp
  801026:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80102d:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801034:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80103b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801042:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801049:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801050:	84 c0                	test   %al,%al
  801052:	74 20                	je     801074 <printfmt+0x52>
  801054:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801058:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80105c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801060:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801064:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801068:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80106c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801070:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801074:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80107b:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801082:	00 00 00 
  801085:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80108c:	00 00 00 
  80108f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801093:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80109a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010a1:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8010a8:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8010af:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8010b6:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8010bd:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8010c4:	48 89 c7             	mov    %rax,%rdi
  8010c7:	48 b8 0a 0b 80 00 00 	movabs $0x800b0a,%rax
  8010ce:	00 00 00 
  8010d1:	ff d0                	callq  *%rax
	va_end(ap);
}
  8010d3:	c9                   	leaveq 
  8010d4:	c3                   	retq   

00000000008010d5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010d5:	55                   	push   %rbp
  8010d6:	48 89 e5             	mov    %rsp,%rbp
  8010d9:	48 83 ec 10          	sub    $0x10,%rsp
  8010dd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e8:	8b 40 10             	mov    0x10(%rax),%eax
  8010eb:	8d 50 01             	lea    0x1(%rax),%edx
  8010ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010f2:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8010f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010f9:	48 8b 10             	mov    (%rax),%rdx
  8010fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801100:	48 8b 40 08          	mov    0x8(%rax),%rax
  801104:	48 39 c2             	cmp    %rax,%rdx
  801107:	73 17                	jae    801120 <sprintputch+0x4b>
		*b->buf++ = ch;
  801109:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80110d:	48 8b 00             	mov    (%rax),%rax
  801110:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801114:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801118:	48 89 0a             	mov    %rcx,(%rdx)
  80111b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80111e:	88 10                	mov    %dl,(%rax)
}
  801120:	c9                   	leaveq 
  801121:	c3                   	retq   

0000000000801122 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801122:	55                   	push   %rbp
  801123:	48 89 e5             	mov    %rsp,%rbp
  801126:	48 83 ec 50          	sub    $0x50,%rsp
  80112a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80112e:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801131:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801135:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801139:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80113d:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801141:	48 8b 0a             	mov    (%rdx),%rcx
  801144:	48 89 08             	mov    %rcx,(%rax)
  801147:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80114b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80114f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801153:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801157:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80115b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80115f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801162:	48 98                	cltq   
  801164:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801168:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80116c:	48 01 d0             	add    %rdx,%rax
  80116f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801173:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80117a:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80117f:	74 06                	je     801187 <vsnprintf+0x65>
  801181:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801185:	7f 07                	jg     80118e <vsnprintf+0x6c>
		return -E_INVAL;
  801187:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80118c:	eb 2f                	jmp    8011bd <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80118e:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801192:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801196:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80119a:	48 89 c6             	mov    %rax,%rsi
  80119d:	48 bf d5 10 80 00 00 	movabs $0x8010d5,%rdi
  8011a4:	00 00 00 
  8011a7:	48 b8 0a 0b 80 00 00 	movabs $0x800b0a,%rax
  8011ae:	00 00 00 
  8011b1:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8011b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8011b7:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8011ba:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8011bd:	c9                   	leaveq 
  8011be:	c3                   	retq   

00000000008011bf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011bf:	55                   	push   %rbp
  8011c0:	48 89 e5             	mov    %rsp,%rbp
  8011c3:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8011ca:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8011d1:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8011d7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011de:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011e5:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011ec:	84 c0                	test   %al,%al
  8011ee:	74 20                	je     801210 <snprintf+0x51>
  8011f0:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011f4:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011f8:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8011fc:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801200:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801204:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801208:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80120c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801210:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801217:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80121e:	00 00 00 
  801221:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801228:	00 00 00 
  80122b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80122f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801236:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80123d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801244:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80124b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801252:	48 8b 0a             	mov    (%rdx),%rcx
  801255:	48 89 08             	mov    %rcx,(%rax)
  801258:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80125c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801260:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801264:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801268:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80126f:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801276:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80127c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801283:	48 89 c7             	mov    %rax,%rdi
  801286:	48 b8 22 11 80 00 00 	movabs $0x801122,%rax
  80128d:	00 00 00 
  801290:	ff d0                	callq  *%rax
  801292:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801298:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80129e:	c9                   	leaveq 
  80129f:	c3                   	retq   

00000000008012a0 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  8012a0:	55                   	push   %rbp
  8012a1:	48 89 e5             	mov    %rsp,%rbp
  8012a4:	48 83 ec 20          	sub    $0x20,%rsp
  8012a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  8012ac:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012b1:	74 27                	je     8012da <readline+0x3a>
		fprintf(1, "%s", prompt);
  8012b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012b7:	48 89 c2             	mov    %rax,%rdx
  8012ba:	48 be 28 40 80 00 00 	movabs $0x804028,%rsi
  8012c1:	00 00 00 
  8012c4:	bf 01 00 00 00       	mov    $0x1,%edi
  8012c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ce:	48 b9 e9 30 80 00 00 	movabs $0x8030e9,%rcx
  8012d5:	00 00 00 
  8012d8:	ff d1                	callq  *%rcx
#endif

	i = 0;
  8012da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	echoing = iscons(0);
  8012e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8012e6:	48 b8 2c 02 80 00 00 	movabs $0x80022c,%rax
  8012ed:	00 00 00 
  8012f0:	ff d0                	callq  *%rax
  8012f2:	89 45 f8             	mov    %eax,-0x8(%rbp)
	while (1) {
		c = getchar();
  8012f5:	48 b8 e3 01 80 00 00 	movabs $0x8001e3,%rax
  8012fc:	00 00 00 
  8012ff:	ff d0                	callq  *%rax
  801301:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (c < 0) {
  801304:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801308:	79 30                	jns    80133a <readline+0x9a>
			if (c != -E_EOF)
  80130a:	83 7d f4 f7          	cmpl   $0xfffffff7,-0xc(%rbp)
  80130e:	74 20                	je     801330 <readline+0x90>
				cprintf("read error: %e\n", c);
  801310:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801313:	89 c6                	mov    %eax,%esi
  801315:	48 bf 2b 40 80 00 00 	movabs $0x80402b,%rdi
  80131c:	00 00 00 
  80131f:	b8 00 00 00 00       	mov    $0x0,%eax
  801324:	48 ba 57 07 80 00 00 	movabs $0x800757,%rdx
  80132b:	00 00 00 
  80132e:	ff d2                	callq  *%rdx
			return NULL;
  801330:	b8 00 00 00 00       	mov    $0x0,%eax
  801335:	e9 be 00 00 00       	jmpq   8013f8 <readline+0x158>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  80133a:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
  80133e:	74 06                	je     801346 <readline+0xa6>
  801340:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  801344:	75 26                	jne    80136c <readline+0xcc>
  801346:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80134a:	7e 20                	jle    80136c <readline+0xcc>
			if (echoing)
  80134c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801350:	74 11                	je     801363 <readline+0xc3>
				cputchar('\b');
  801352:	bf 08 00 00 00       	mov    $0x8,%edi
  801357:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  80135e:	00 00 00 
  801361:	ff d0                	callq  *%rax
			i--;
  801363:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  801367:	e9 87 00 00 00       	jmpq   8013f3 <readline+0x153>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80136c:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  801370:	7e 3f                	jle    8013b1 <readline+0x111>
  801372:	81 7d fc fe 03 00 00 	cmpl   $0x3fe,-0x4(%rbp)
  801379:	7f 36                	jg     8013b1 <readline+0x111>
			if (echoing)
  80137b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80137f:	74 11                	je     801392 <readline+0xf2>
				cputchar(c);
  801381:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801384:	89 c7                	mov    %eax,%edi
  801386:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  80138d:	00 00 00 
  801390:	ff d0                	callq  *%rax
			buf[i++] = c;
  801392:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801395:	8d 50 01             	lea    0x1(%rax),%edx
  801398:	89 55 fc             	mov    %edx,-0x4(%rbp)
  80139b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80139e:	89 d1                	mov    %edx,%ecx
  8013a0:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8013a7:	00 00 00 
  8013aa:	48 98                	cltq   
  8013ac:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
  8013af:	eb 42                	jmp    8013f3 <readline+0x153>
		} else if (c == '\n' || c == '\r') {
  8013b1:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  8013b5:	74 06                	je     8013bd <readline+0x11d>
  8013b7:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  8013bb:	75 36                	jne    8013f3 <readline+0x153>
			if (echoing)
  8013bd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8013c1:	74 11                	je     8013d4 <readline+0x134>
				cputchar('\n');
  8013c3:	bf 0a 00 00 00       	mov    $0xa,%edi
  8013c8:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  8013cf:	00 00 00 
  8013d2:	ff d0                	callq  *%rax
			buf[i] = 0;
  8013d4:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8013db:	00 00 00 
  8013de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013e1:	48 98                	cltq   
  8013e3:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
			return buf;
  8013e7:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8013ee:	00 00 00 
  8013f1:	eb 05                	jmp    8013f8 <readline+0x158>
		}
	}
  8013f3:	e9 fd fe ff ff       	jmpq   8012f5 <readline+0x55>
}
  8013f8:	c9                   	leaveq 
  8013f9:	c3                   	retq   

00000000008013fa <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8013fa:	55                   	push   %rbp
  8013fb:	48 89 e5             	mov    %rsp,%rbp
  8013fe:	48 83 ec 18          	sub    $0x18,%rsp
  801402:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801406:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80140d:	eb 09                	jmp    801418 <strlen+0x1e>
		n++;
  80140f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801413:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801418:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80141c:	0f b6 00             	movzbl (%rax),%eax
  80141f:	84 c0                	test   %al,%al
  801421:	75 ec                	jne    80140f <strlen+0x15>
		n++;
	return n;
  801423:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801426:	c9                   	leaveq 
  801427:	c3                   	retq   

0000000000801428 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801428:	55                   	push   %rbp
  801429:	48 89 e5             	mov    %rsp,%rbp
  80142c:	48 83 ec 20          	sub    $0x20,%rsp
  801430:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801434:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801438:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80143f:	eb 0e                	jmp    80144f <strnlen+0x27>
		n++;
  801441:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801445:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80144a:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80144f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801454:	74 0b                	je     801461 <strnlen+0x39>
  801456:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80145a:	0f b6 00             	movzbl (%rax),%eax
  80145d:	84 c0                	test   %al,%al
  80145f:	75 e0                	jne    801441 <strnlen+0x19>
		n++;
	return n;
  801461:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801464:	c9                   	leaveq 
  801465:	c3                   	retq   

0000000000801466 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801466:	55                   	push   %rbp
  801467:	48 89 e5             	mov    %rsp,%rbp
  80146a:	48 83 ec 20          	sub    $0x20,%rsp
  80146e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801472:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801476:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80147a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80147e:	90                   	nop
  80147f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801483:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801487:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80148b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80148f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801493:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801497:	0f b6 12             	movzbl (%rdx),%edx
  80149a:	88 10                	mov    %dl,(%rax)
  80149c:	0f b6 00             	movzbl (%rax),%eax
  80149f:	84 c0                	test   %al,%al
  8014a1:	75 dc                	jne    80147f <strcpy+0x19>
		/* do nothing */;
	return ret;
  8014a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014a7:	c9                   	leaveq 
  8014a8:	c3                   	retq   

00000000008014a9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8014a9:	55                   	push   %rbp
  8014aa:	48 89 e5             	mov    %rsp,%rbp
  8014ad:	48 83 ec 20          	sub    $0x20,%rsp
  8014b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8014b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014bd:	48 89 c7             	mov    %rax,%rdi
  8014c0:	48 b8 fa 13 80 00 00 	movabs $0x8013fa,%rax
  8014c7:	00 00 00 
  8014ca:	ff d0                	callq  *%rax
  8014cc:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8014cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014d2:	48 63 d0             	movslq %eax,%rdx
  8014d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d9:	48 01 c2             	add    %rax,%rdx
  8014dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014e0:	48 89 c6             	mov    %rax,%rsi
  8014e3:	48 89 d7             	mov    %rdx,%rdi
  8014e6:	48 b8 66 14 80 00 00 	movabs $0x801466,%rax
  8014ed:	00 00 00 
  8014f0:	ff d0                	callq  *%rax
	return dst;
  8014f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014f6:	c9                   	leaveq 
  8014f7:	c3                   	retq   

00000000008014f8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8014f8:	55                   	push   %rbp
  8014f9:	48 89 e5             	mov    %rsp,%rbp
  8014fc:	48 83 ec 28          	sub    $0x28,%rsp
  801500:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801504:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801508:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80150c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801510:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801514:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80151b:	00 
  80151c:	eb 2a                	jmp    801548 <strncpy+0x50>
		*dst++ = *src;
  80151e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801522:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801526:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80152a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80152e:	0f b6 12             	movzbl (%rdx),%edx
  801531:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801533:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801537:	0f b6 00             	movzbl (%rax),%eax
  80153a:	84 c0                	test   %al,%al
  80153c:	74 05                	je     801543 <strncpy+0x4b>
			src++;
  80153e:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801543:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801548:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80154c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801550:	72 cc                	jb     80151e <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801552:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801556:	c9                   	leaveq 
  801557:	c3                   	retq   

0000000000801558 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801558:	55                   	push   %rbp
  801559:	48 89 e5             	mov    %rsp,%rbp
  80155c:	48 83 ec 28          	sub    $0x28,%rsp
  801560:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801564:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801568:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80156c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801570:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801574:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801579:	74 3d                	je     8015b8 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80157b:	eb 1d                	jmp    80159a <strlcpy+0x42>
			*dst++ = *src++;
  80157d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801581:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801585:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801589:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80158d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801591:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801595:	0f b6 12             	movzbl (%rdx),%edx
  801598:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80159a:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80159f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8015a4:	74 0b                	je     8015b1 <strlcpy+0x59>
  8015a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015aa:	0f b6 00             	movzbl (%rax),%eax
  8015ad:	84 c0                	test   %al,%al
  8015af:	75 cc                	jne    80157d <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8015b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015b5:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8015b8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c0:	48 29 c2             	sub    %rax,%rdx
  8015c3:	48 89 d0             	mov    %rdx,%rax
}
  8015c6:	c9                   	leaveq 
  8015c7:	c3                   	retq   

00000000008015c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8015c8:	55                   	push   %rbp
  8015c9:	48 89 e5             	mov    %rsp,%rbp
  8015cc:	48 83 ec 10          	sub    $0x10,%rsp
  8015d0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015d4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8015d8:	eb 0a                	jmp    8015e4 <strcmp+0x1c>
		p++, q++;
  8015da:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015df:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8015e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e8:	0f b6 00             	movzbl (%rax),%eax
  8015eb:	84 c0                	test   %al,%al
  8015ed:	74 12                	je     801601 <strcmp+0x39>
  8015ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f3:	0f b6 10             	movzbl (%rax),%edx
  8015f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015fa:	0f b6 00             	movzbl (%rax),%eax
  8015fd:	38 c2                	cmp    %al,%dl
  8015ff:	74 d9                	je     8015da <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801601:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801605:	0f b6 00             	movzbl (%rax),%eax
  801608:	0f b6 d0             	movzbl %al,%edx
  80160b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80160f:	0f b6 00             	movzbl (%rax),%eax
  801612:	0f b6 c0             	movzbl %al,%eax
  801615:	29 c2                	sub    %eax,%edx
  801617:	89 d0                	mov    %edx,%eax
}
  801619:	c9                   	leaveq 
  80161a:	c3                   	retq   

000000000080161b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80161b:	55                   	push   %rbp
  80161c:	48 89 e5             	mov    %rsp,%rbp
  80161f:	48 83 ec 18          	sub    $0x18,%rsp
  801623:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801627:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80162b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80162f:	eb 0f                	jmp    801640 <strncmp+0x25>
		n--, p++, q++;
  801631:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801636:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80163b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801640:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801645:	74 1d                	je     801664 <strncmp+0x49>
  801647:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80164b:	0f b6 00             	movzbl (%rax),%eax
  80164e:	84 c0                	test   %al,%al
  801650:	74 12                	je     801664 <strncmp+0x49>
  801652:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801656:	0f b6 10             	movzbl (%rax),%edx
  801659:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80165d:	0f b6 00             	movzbl (%rax),%eax
  801660:	38 c2                	cmp    %al,%dl
  801662:	74 cd                	je     801631 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801664:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801669:	75 07                	jne    801672 <strncmp+0x57>
		return 0;
  80166b:	b8 00 00 00 00       	mov    $0x0,%eax
  801670:	eb 18                	jmp    80168a <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801672:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801676:	0f b6 00             	movzbl (%rax),%eax
  801679:	0f b6 d0             	movzbl %al,%edx
  80167c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801680:	0f b6 00             	movzbl (%rax),%eax
  801683:	0f b6 c0             	movzbl %al,%eax
  801686:	29 c2                	sub    %eax,%edx
  801688:	89 d0                	mov    %edx,%eax
}
  80168a:	c9                   	leaveq 
  80168b:	c3                   	retq   

000000000080168c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80168c:	55                   	push   %rbp
  80168d:	48 89 e5             	mov    %rsp,%rbp
  801690:	48 83 ec 0c          	sub    $0xc,%rsp
  801694:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801698:	89 f0                	mov    %esi,%eax
  80169a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80169d:	eb 17                	jmp    8016b6 <strchr+0x2a>
		if (*s == c)
  80169f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a3:	0f b6 00             	movzbl (%rax),%eax
  8016a6:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8016a9:	75 06                	jne    8016b1 <strchr+0x25>
			return (char *) s;
  8016ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016af:	eb 15                	jmp    8016c6 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8016b1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ba:	0f b6 00             	movzbl (%rax),%eax
  8016bd:	84 c0                	test   %al,%al
  8016bf:	75 de                	jne    80169f <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8016c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016c6:	c9                   	leaveq 
  8016c7:	c3                   	retq   

00000000008016c8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8016c8:	55                   	push   %rbp
  8016c9:	48 89 e5             	mov    %rsp,%rbp
  8016cc:	48 83 ec 0c          	sub    $0xc,%rsp
  8016d0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016d4:	89 f0                	mov    %esi,%eax
  8016d6:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8016d9:	eb 13                	jmp    8016ee <strfind+0x26>
		if (*s == c)
  8016db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016df:	0f b6 00             	movzbl (%rax),%eax
  8016e2:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8016e5:	75 02                	jne    8016e9 <strfind+0x21>
			break;
  8016e7:	eb 10                	jmp    8016f9 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8016e9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016f2:	0f b6 00             	movzbl (%rax),%eax
  8016f5:	84 c0                	test   %al,%al
  8016f7:	75 e2                	jne    8016db <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8016f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016fd:	c9                   	leaveq 
  8016fe:	c3                   	retq   

00000000008016ff <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8016ff:	55                   	push   %rbp
  801700:	48 89 e5             	mov    %rsp,%rbp
  801703:	48 83 ec 18          	sub    $0x18,%rsp
  801707:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80170b:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80170e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801712:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801717:	75 06                	jne    80171f <memset+0x20>
		return v;
  801719:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80171d:	eb 69                	jmp    801788 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80171f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801723:	83 e0 03             	and    $0x3,%eax
  801726:	48 85 c0             	test   %rax,%rax
  801729:	75 48                	jne    801773 <memset+0x74>
  80172b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80172f:	83 e0 03             	and    $0x3,%eax
  801732:	48 85 c0             	test   %rax,%rax
  801735:	75 3c                	jne    801773 <memset+0x74>
		c &= 0xFF;
  801737:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80173e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801741:	c1 e0 18             	shl    $0x18,%eax
  801744:	89 c2                	mov    %eax,%edx
  801746:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801749:	c1 e0 10             	shl    $0x10,%eax
  80174c:	09 c2                	or     %eax,%edx
  80174e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801751:	c1 e0 08             	shl    $0x8,%eax
  801754:	09 d0                	or     %edx,%eax
  801756:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801759:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80175d:	48 c1 e8 02          	shr    $0x2,%rax
  801761:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801764:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801768:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80176b:	48 89 d7             	mov    %rdx,%rdi
  80176e:	fc                   	cld    
  80176f:	f3 ab                	rep stos %eax,%es:(%rdi)
  801771:	eb 11                	jmp    801784 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801773:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801777:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80177a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80177e:	48 89 d7             	mov    %rdx,%rdi
  801781:	fc                   	cld    
  801782:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801784:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801788:	c9                   	leaveq 
  801789:	c3                   	retq   

000000000080178a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80178a:	55                   	push   %rbp
  80178b:	48 89 e5             	mov    %rsp,%rbp
  80178e:	48 83 ec 28          	sub    $0x28,%rsp
  801792:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801796:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80179a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80179e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017a2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8017a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017aa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8017ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017b2:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8017b6:	0f 83 88 00 00 00    	jae    801844 <memmove+0xba>
  8017bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017c4:	48 01 d0             	add    %rdx,%rax
  8017c7:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8017cb:	76 77                	jbe    801844 <memmove+0xba>
		s += n;
  8017cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d1:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8017d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d9:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8017dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017e1:	83 e0 03             	and    $0x3,%eax
  8017e4:	48 85 c0             	test   %rax,%rax
  8017e7:	75 3b                	jne    801824 <memmove+0x9a>
  8017e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017ed:	83 e0 03             	and    $0x3,%eax
  8017f0:	48 85 c0             	test   %rax,%rax
  8017f3:	75 2f                	jne    801824 <memmove+0x9a>
  8017f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f9:	83 e0 03             	and    $0x3,%eax
  8017fc:	48 85 c0             	test   %rax,%rax
  8017ff:	75 23                	jne    801824 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801801:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801805:	48 83 e8 04          	sub    $0x4,%rax
  801809:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80180d:	48 83 ea 04          	sub    $0x4,%rdx
  801811:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801815:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801819:	48 89 c7             	mov    %rax,%rdi
  80181c:	48 89 d6             	mov    %rdx,%rsi
  80181f:	fd                   	std    
  801820:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801822:	eb 1d                	jmp    801841 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801824:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801828:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80182c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801830:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801834:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801838:	48 89 d7             	mov    %rdx,%rdi
  80183b:	48 89 c1             	mov    %rax,%rcx
  80183e:	fd                   	std    
  80183f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801841:	fc                   	cld    
  801842:	eb 57                	jmp    80189b <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801844:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801848:	83 e0 03             	and    $0x3,%eax
  80184b:	48 85 c0             	test   %rax,%rax
  80184e:	75 36                	jne    801886 <memmove+0xfc>
  801850:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801854:	83 e0 03             	and    $0x3,%eax
  801857:	48 85 c0             	test   %rax,%rax
  80185a:	75 2a                	jne    801886 <memmove+0xfc>
  80185c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801860:	83 e0 03             	and    $0x3,%eax
  801863:	48 85 c0             	test   %rax,%rax
  801866:	75 1e                	jne    801886 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801868:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80186c:	48 c1 e8 02          	shr    $0x2,%rax
  801870:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801873:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801877:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80187b:	48 89 c7             	mov    %rax,%rdi
  80187e:	48 89 d6             	mov    %rdx,%rsi
  801881:	fc                   	cld    
  801882:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801884:	eb 15                	jmp    80189b <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801886:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80188a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80188e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801892:	48 89 c7             	mov    %rax,%rdi
  801895:	48 89 d6             	mov    %rdx,%rsi
  801898:	fc                   	cld    
  801899:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80189b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80189f:	c9                   	leaveq 
  8018a0:	c3                   	retq   

00000000008018a1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8018a1:	55                   	push   %rbp
  8018a2:	48 89 e5             	mov    %rsp,%rbp
  8018a5:	48 83 ec 18          	sub    $0x18,%rsp
  8018a9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018ad:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018b1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8018b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018b9:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8018bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018c1:	48 89 ce             	mov    %rcx,%rsi
  8018c4:	48 89 c7             	mov    %rax,%rdi
  8018c7:	48 b8 8a 17 80 00 00 	movabs $0x80178a,%rax
  8018ce:	00 00 00 
  8018d1:	ff d0                	callq  *%rax
}
  8018d3:	c9                   	leaveq 
  8018d4:	c3                   	retq   

00000000008018d5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8018d5:	55                   	push   %rbp
  8018d6:	48 89 e5             	mov    %rsp,%rbp
  8018d9:	48 83 ec 28          	sub    $0x28,%rsp
  8018dd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018e1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8018e5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8018e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018ed:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8018f1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8018f5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8018f9:	eb 36                	jmp    801931 <memcmp+0x5c>
		if (*s1 != *s2)
  8018fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018ff:	0f b6 10             	movzbl (%rax),%edx
  801902:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801906:	0f b6 00             	movzbl (%rax),%eax
  801909:	38 c2                	cmp    %al,%dl
  80190b:	74 1a                	je     801927 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80190d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801911:	0f b6 00             	movzbl (%rax),%eax
  801914:	0f b6 d0             	movzbl %al,%edx
  801917:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80191b:	0f b6 00             	movzbl (%rax),%eax
  80191e:	0f b6 c0             	movzbl %al,%eax
  801921:	29 c2                	sub    %eax,%edx
  801923:	89 d0                	mov    %edx,%eax
  801925:	eb 20                	jmp    801947 <memcmp+0x72>
		s1++, s2++;
  801927:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80192c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801931:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801935:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801939:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80193d:	48 85 c0             	test   %rax,%rax
  801940:	75 b9                	jne    8018fb <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801942:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801947:	c9                   	leaveq 
  801948:	c3                   	retq   

0000000000801949 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801949:	55                   	push   %rbp
  80194a:	48 89 e5             	mov    %rsp,%rbp
  80194d:	48 83 ec 28          	sub    $0x28,%rsp
  801951:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801955:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801958:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80195c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801960:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801964:	48 01 d0             	add    %rdx,%rax
  801967:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80196b:	eb 15                	jmp    801982 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80196d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801971:	0f b6 10             	movzbl (%rax),%edx
  801974:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801977:	38 c2                	cmp    %al,%dl
  801979:	75 02                	jne    80197d <memfind+0x34>
			break;
  80197b:	eb 0f                	jmp    80198c <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80197d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801982:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801986:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80198a:	72 e1                	jb     80196d <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80198c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801990:	c9                   	leaveq 
  801991:	c3                   	retq   

0000000000801992 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801992:	55                   	push   %rbp
  801993:	48 89 e5             	mov    %rsp,%rbp
  801996:	48 83 ec 34          	sub    $0x34,%rsp
  80199a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80199e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8019a2:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8019a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8019ac:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8019b3:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019b4:	eb 05                	jmp    8019bb <strtol+0x29>
		s++;
  8019b6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019bf:	0f b6 00             	movzbl (%rax),%eax
  8019c2:	3c 20                	cmp    $0x20,%al
  8019c4:	74 f0                	je     8019b6 <strtol+0x24>
  8019c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ca:	0f b6 00             	movzbl (%rax),%eax
  8019cd:	3c 09                	cmp    $0x9,%al
  8019cf:	74 e5                	je     8019b6 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8019d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019d5:	0f b6 00             	movzbl (%rax),%eax
  8019d8:	3c 2b                	cmp    $0x2b,%al
  8019da:	75 07                	jne    8019e3 <strtol+0x51>
		s++;
  8019dc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019e1:	eb 17                	jmp    8019fa <strtol+0x68>
	else if (*s == '-')
  8019e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e7:	0f b6 00             	movzbl (%rax),%eax
  8019ea:	3c 2d                	cmp    $0x2d,%al
  8019ec:	75 0c                	jne    8019fa <strtol+0x68>
		s++, neg = 1;
  8019ee:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019f3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019fa:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019fe:	74 06                	je     801a06 <strtol+0x74>
  801a00:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801a04:	75 28                	jne    801a2e <strtol+0x9c>
  801a06:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a0a:	0f b6 00             	movzbl (%rax),%eax
  801a0d:	3c 30                	cmp    $0x30,%al
  801a0f:	75 1d                	jne    801a2e <strtol+0x9c>
  801a11:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a15:	48 83 c0 01          	add    $0x1,%rax
  801a19:	0f b6 00             	movzbl (%rax),%eax
  801a1c:	3c 78                	cmp    $0x78,%al
  801a1e:	75 0e                	jne    801a2e <strtol+0x9c>
		s += 2, base = 16;
  801a20:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801a25:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801a2c:	eb 2c                	jmp    801a5a <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801a2e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a32:	75 19                	jne    801a4d <strtol+0xbb>
  801a34:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a38:	0f b6 00             	movzbl (%rax),%eax
  801a3b:	3c 30                	cmp    $0x30,%al
  801a3d:	75 0e                	jne    801a4d <strtol+0xbb>
		s++, base = 8;
  801a3f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a44:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801a4b:	eb 0d                	jmp    801a5a <strtol+0xc8>
	else if (base == 0)
  801a4d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a51:	75 07                	jne    801a5a <strtol+0xc8>
		base = 10;
  801a53:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a5e:	0f b6 00             	movzbl (%rax),%eax
  801a61:	3c 2f                	cmp    $0x2f,%al
  801a63:	7e 1d                	jle    801a82 <strtol+0xf0>
  801a65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a69:	0f b6 00             	movzbl (%rax),%eax
  801a6c:	3c 39                	cmp    $0x39,%al
  801a6e:	7f 12                	jg     801a82 <strtol+0xf0>
			dig = *s - '0';
  801a70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a74:	0f b6 00             	movzbl (%rax),%eax
  801a77:	0f be c0             	movsbl %al,%eax
  801a7a:	83 e8 30             	sub    $0x30,%eax
  801a7d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a80:	eb 4e                	jmp    801ad0 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801a82:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a86:	0f b6 00             	movzbl (%rax),%eax
  801a89:	3c 60                	cmp    $0x60,%al
  801a8b:	7e 1d                	jle    801aaa <strtol+0x118>
  801a8d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a91:	0f b6 00             	movzbl (%rax),%eax
  801a94:	3c 7a                	cmp    $0x7a,%al
  801a96:	7f 12                	jg     801aaa <strtol+0x118>
			dig = *s - 'a' + 10;
  801a98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a9c:	0f b6 00             	movzbl (%rax),%eax
  801a9f:	0f be c0             	movsbl %al,%eax
  801aa2:	83 e8 57             	sub    $0x57,%eax
  801aa5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801aa8:	eb 26                	jmp    801ad0 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801aaa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aae:	0f b6 00             	movzbl (%rax),%eax
  801ab1:	3c 40                	cmp    $0x40,%al
  801ab3:	7e 48                	jle    801afd <strtol+0x16b>
  801ab5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ab9:	0f b6 00             	movzbl (%rax),%eax
  801abc:	3c 5a                	cmp    $0x5a,%al
  801abe:	7f 3d                	jg     801afd <strtol+0x16b>
			dig = *s - 'A' + 10;
  801ac0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ac4:	0f b6 00             	movzbl (%rax),%eax
  801ac7:	0f be c0             	movsbl %al,%eax
  801aca:	83 e8 37             	sub    $0x37,%eax
  801acd:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801ad0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ad3:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801ad6:	7c 02                	jl     801ada <strtol+0x148>
			break;
  801ad8:	eb 23                	jmp    801afd <strtol+0x16b>
		s++, val = (val * base) + dig;
  801ada:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801adf:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801ae2:	48 98                	cltq   
  801ae4:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801ae9:	48 89 c2             	mov    %rax,%rdx
  801aec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801aef:	48 98                	cltq   
  801af1:	48 01 d0             	add    %rdx,%rax
  801af4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801af8:	e9 5d ff ff ff       	jmpq   801a5a <strtol+0xc8>

	if (endptr)
  801afd:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801b02:	74 0b                	je     801b0f <strtol+0x17d>
		*endptr = (char *) s;
  801b04:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b08:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801b0c:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801b0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b13:	74 09                	je     801b1e <strtol+0x18c>
  801b15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b19:	48 f7 d8             	neg    %rax
  801b1c:	eb 04                	jmp    801b22 <strtol+0x190>
  801b1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801b22:	c9                   	leaveq 
  801b23:	c3                   	retq   

0000000000801b24 <strstr>:

char * strstr(const char *in, const char *str)
{
  801b24:	55                   	push   %rbp
  801b25:	48 89 e5             	mov    %rsp,%rbp
  801b28:	48 83 ec 30          	sub    $0x30,%rsp
  801b2c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801b30:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801b34:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b38:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b3c:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b40:	0f b6 00             	movzbl (%rax),%eax
  801b43:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801b46:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801b4a:	75 06                	jne    801b52 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801b4c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b50:	eb 6b                	jmp    801bbd <strstr+0x99>

	len = strlen(str);
  801b52:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b56:	48 89 c7             	mov    %rax,%rdi
  801b59:	48 b8 fa 13 80 00 00 	movabs $0x8013fa,%rax
  801b60:	00 00 00 
  801b63:	ff d0                	callq  *%rax
  801b65:	48 98                	cltq   
  801b67:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801b6b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b6f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b73:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801b77:	0f b6 00             	movzbl (%rax),%eax
  801b7a:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801b7d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801b81:	75 07                	jne    801b8a <strstr+0x66>
				return (char *) 0;
  801b83:	b8 00 00 00 00       	mov    $0x0,%eax
  801b88:	eb 33                	jmp    801bbd <strstr+0x99>
		} while (sc != c);
  801b8a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801b8e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801b91:	75 d8                	jne    801b6b <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801b93:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b97:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801b9b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b9f:	48 89 ce             	mov    %rcx,%rsi
  801ba2:	48 89 c7             	mov    %rax,%rdi
  801ba5:	48 b8 1b 16 80 00 00 	movabs $0x80161b,%rax
  801bac:	00 00 00 
  801baf:	ff d0                	callq  *%rax
  801bb1:	85 c0                	test   %eax,%eax
  801bb3:	75 b6                	jne    801b6b <strstr+0x47>

	return (char *) (in - 1);
  801bb5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bb9:	48 83 e8 01          	sub    $0x1,%rax
}
  801bbd:	c9                   	leaveq 
  801bbe:	c3                   	retq   

0000000000801bbf <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801bbf:	55                   	push   %rbp
  801bc0:	48 89 e5             	mov    %rsp,%rbp
  801bc3:	53                   	push   %rbx
  801bc4:	48 83 ec 48          	sub    $0x48,%rsp
  801bc8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801bcb:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801bce:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801bd2:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801bd6:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801bda:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  801bde:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801be1:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801be5:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801be9:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801bed:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801bf1:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801bf5:	4c 89 c3             	mov    %r8,%rbx
  801bf8:	cd 30                	int    $0x30
  801bfa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  801bfe:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801c02:	74 3e                	je     801c42 <syscall+0x83>
  801c04:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801c09:	7e 37                	jle    801c42 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801c0b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c0f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801c12:	49 89 d0             	mov    %rdx,%r8
  801c15:	89 c1                	mov    %eax,%ecx
  801c17:	48 ba 3b 40 80 00 00 	movabs $0x80403b,%rdx
  801c1e:	00 00 00 
  801c21:	be 4a 00 00 00       	mov    $0x4a,%esi
  801c26:	48 bf 58 40 80 00 00 	movabs $0x804058,%rdi
  801c2d:	00 00 00 
  801c30:	b8 00 00 00 00       	mov    $0x0,%eax
  801c35:	49 b9 1e 05 80 00 00 	movabs $0x80051e,%r9
  801c3c:	00 00 00 
  801c3f:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  801c42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801c46:	48 83 c4 48          	add    $0x48,%rsp
  801c4a:	5b                   	pop    %rbx
  801c4b:	5d                   	pop    %rbp
  801c4c:	c3                   	retq   

0000000000801c4d <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801c4d:	55                   	push   %rbp
  801c4e:	48 89 e5             	mov    %rsp,%rbp
  801c51:	48 83 ec 20          	sub    $0x20,%rsp
  801c55:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c59:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801c5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c61:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c65:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c6c:	00 
  801c6d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c73:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c79:	48 89 d1             	mov    %rdx,%rcx
  801c7c:	48 89 c2             	mov    %rax,%rdx
  801c7f:	be 00 00 00 00       	mov    $0x0,%esi
  801c84:	bf 00 00 00 00       	mov    $0x0,%edi
  801c89:	48 b8 bf 1b 80 00 00 	movabs $0x801bbf,%rax
  801c90:	00 00 00 
  801c93:	ff d0                	callq  *%rax
}
  801c95:	c9                   	leaveq 
  801c96:	c3                   	retq   

0000000000801c97 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c97:	55                   	push   %rbp
  801c98:	48 89 e5             	mov    %rsp,%rbp
  801c9b:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801c9f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ca6:	00 
  801ca7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cad:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cb3:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cb8:	ba 00 00 00 00       	mov    $0x0,%edx
  801cbd:	be 00 00 00 00       	mov    $0x0,%esi
  801cc2:	bf 01 00 00 00       	mov    $0x1,%edi
  801cc7:	48 b8 bf 1b 80 00 00 	movabs $0x801bbf,%rax
  801cce:	00 00 00 
  801cd1:	ff d0                	callq  *%rax
}
  801cd3:	c9                   	leaveq 
  801cd4:	c3                   	retq   

0000000000801cd5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801cd5:	55                   	push   %rbp
  801cd6:	48 89 e5             	mov    %rsp,%rbp
  801cd9:	48 83 ec 10          	sub    $0x10,%rsp
  801cdd:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801ce0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ce3:	48 98                	cltq   
  801ce5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cec:	00 
  801ced:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cf3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cf9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cfe:	48 89 c2             	mov    %rax,%rdx
  801d01:	be 01 00 00 00       	mov    $0x1,%esi
  801d06:	bf 03 00 00 00       	mov    $0x3,%edi
  801d0b:	48 b8 bf 1b 80 00 00 	movabs $0x801bbf,%rax
  801d12:	00 00 00 
  801d15:	ff d0                	callq  *%rax
}
  801d17:	c9                   	leaveq 
  801d18:	c3                   	retq   

0000000000801d19 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801d19:	55                   	push   %rbp
  801d1a:	48 89 e5             	mov    %rsp,%rbp
  801d1d:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801d21:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d28:	00 
  801d29:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d2f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d35:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d3a:	ba 00 00 00 00       	mov    $0x0,%edx
  801d3f:	be 00 00 00 00       	mov    $0x0,%esi
  801d44:	bf 02 00 00 00       	mov    $0x2,%edi
  801d49:	48 b8 bf 1b 80 00 00 	movabs $0x801bbf,%rax
  801d50:	00 00 00 
  801d53:	ff d0                	callq  *%rax
}
  801d55:	c9                   	leaveq 
  801d56:	c3                   	retq   

0000000000801d57 <sys_yield>:

void
sys_yield(void)
{
  801d57:	55                   	push   %rbp
  801d58:	48 89 e5             	mov    %rsp,%rbp
  801d5b:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801d5f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d66:	00 
  801d67:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d6d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d73:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d78:	ba 00 00 00 00       	mov    $0x0,%edx
  801d7d:	be 00 00 00 00       	mov    $0x0,%esi
  801d82:	bf 0b 00 00 00       	mov    $0xb,%edi
  801d87:	48 b8 bf 1b 80 00 00 	movabs $0x801bbf,%rax
  801d8e:	00 00 00 
  801d91:	ff d0                	callq  *%rax
}
  801d93:	c9                   	leaveq 
  801d94:	c3                   	retq   

0000000000801d95 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801d95:	55                   	push   %rbp
  801d96:	48 89 e5             	mov    %rsp,%rbp
  801d99:	48 83 ec 20          	sub    $0x20,%rsp
  801d9d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801da0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801da4:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801da7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801daa:	48 63 c8             	movslq %eax,%rcx
  801dad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801db1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801db4:	48 98                	cltq   
  801db6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dbd:	00 
  801dbe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dc4:	49 89 c8             	mov    %rcx,%r8
  801dc7:	48 89 d1             	mov    %rdx,%rcx
  801dca:	48 89 c2             	mov    %rax,%rdx
  801dcd:	be 01 00 00 00       	mov    $0x1,%esi
  801dd2:	bf 04 00 00 00       	mov    $0x4,%edi
  801dd7:	48 b8 bf 1b 80 00 00 	movabs $0x801bbf,%rax
  801dde:	00 00 00 
  801de1:	ff d0                	callq  *%rax
}
  801de3:	c9                   	leaveq 
  801de4:	c3                   	retq   

0000000000801de5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801de5:	55                   	push   %rbp
  801de6:	48 89 e5             	mov    %rsp,%rbp
  801de9:	48 83 ec 30          	sub    $0x30,%rsp
  801ded:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801df0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801df4:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801df7:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801dfb:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801dff:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801e02:	48 63 c8             	movslq %eax,%rcx
  801e05:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801e09:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e0c:	48 63 f0             	movslq %eax,%rsi
  801e0f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e16:	48 98                	cltq   
  801e18:	48 89 0c 24          	mov    %rcx,(%rsp)
  801e1c:	49 89 f9             	mov    %rdi,%r9
  801e1f:	49 89 f0             	mov    %rsi,%r8
  801e22:	48 89 d1             	mov    %rdx,%rcx
  801e25:	48 89 c2             	mov    %rax,%rdx
  801e28:	be 01 00 00 00       	mov    $0x1,%esi
  801e2d:	bf 05 00 00 00       	mov    $0x5,%edi
  801e32:	48 b8 bf 1b 80 00 00 	movabs $0x801bbf,%rax
  801e39:	00 00 00 
  801e3c:	ff d0                	callq  *%rax
}
  801e3e:	c9                   	leaveq 
  801e3f:	c3                   	retq   

0000000000801e40 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801e40:	55                   	push   %rbp
  801e41:	48 89 e5             	mov    %rsp,%rbp
  801e44:	48 83 ec 20          	sub    $0x20,%rsp
  801e48:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e4b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801e4f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e53:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e56:	48 98                	cltq   
  801e58:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e5f:	00 
  801e60:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e66:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e6c:	48 89 d1             	mov    %rdx,%rcx
  801e6f:	48 89 c2             	mov    %rax,%rdx
  801e72:	be 01 00 00 00       	mov    $0x1,%esi
  801e77:	bf 06 00 00 00       	mov    $0x6,%edi
  801e7c:	48 b8 bf 1b 80 00 00 	movabs $0x801bbf,%rax
  801e83:	00 00 00 
  801e86:	ff d0                	callq  *%rax
}
  801e88:	c9                   	leaveq 
  801e89:	c3                   	retq   

0000000000801e8a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801e8a:	55                   	push   %rbp
  801e8b:	48 89 e5             	mov    %rsp,%rbp
  801e8e:	48 83 ec 10          	sub    $0x10,%rsp
  801e92:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e95:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801e98:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e9b:	48 63 d0             	movslq %eax,%rdx
  801e9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ea1:	48 98                	cltq   
  801ea3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801eaa:	00 
  801eab:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801eb1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801eb7:	48 89 d1             	mov    %rdx,%rcx
  801eba:	48 89 c2             	mov    %rax,%rdx
  801ebd:	be 01 00 00 00       	mov    $0x1,%esi
  801ec2:	bf 08 00 00 00       	mov    $0x8,%edi
  801ec7:	48 b8 bf 1b 80 00 00 	movabs $0x801bbf,%rax
  801ece:	00 00 00 
  801ed1:	ff d0                	callq  *%rax
}
  801ed3:	c9                   	leaveq 
  801ed4:	c3                   	retq   

0000000000801ed5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801ed5:	55                   	push   %rbp
  801ed6:	48 89 e5             	mov    %rsp,%rbp
  801ed9:	48 83 ec 20          	sub    $0x20,%rsp
  801edd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ee0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801ee4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ee8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eeb:	48 98                	cltq   
  801eed:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ef4:	00 
  801ef5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801efb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f01:	48 89 d1             	mov    %rdx,%rcx
  801f04:	48 89 c2             	mov    %rax,%rdx
  801f07:	be 01 00 00 00       	mov    $0x1,%esi
  801f0c:	bf 09 00 00 00       	mov    $0x9,%edi
  801f11:	48 b8 bf 1b 80 00 00 	movabs $0x801bbf,%rax
  801f18:	00 00 00 
  801f1b:	ff d0                	callq  *%rax
}
  801f1d:	c9                   	leaveq 
  801f1e:	c3                   	retq   

0000000000801f1f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801f1f:	55                   	push   %rbp
  801f20:	48 89 e5             	mov    %rsp,%rbp
  801f23:	48 83 ec 20          	sub    $0x20,%rsp
  801f27:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f2a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801f2e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f35:	48 98                	cltq   
  801f37:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f3e:	00 
  801f3f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f45:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f4b:	48 89 d1             	mov    %rdx,%rcx
  801f4e:	48 89 c2             	mov    %rax,%rdx
  801f51:	be 01 00 00 00       	mov    $0x1,%esi
  801f56:	bf 0a 00 00 00       	mov    $0xa,%edi
  801f5b:	48 b8 bf 1b 80 00 00 	movabs $0x801bbf,%rax
  801f62:	00 00 00 
  801f65:	ff d0                	callq  *%rax
}
  801f67:	c9                   	leaveq 
  801f68:	c3                   	retq   

0000000000801f69 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801f69:	55                   	push   %rbp
  801f6a:	48 89 e5             	mov    %rsp,%rbp
  801f6d:	48 83 ec 20          	sub    $0x20,%rsp
  801f71:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f74:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f78:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801f7c:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801f7f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f82:	48 63 f0             	movslq %eax,%rsi
  801f85:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801f89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f8c:	48 98                	cltq   
  801f8e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f92:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f99:	00 
  801f9a:	49 89 f1             	mov    %rsi,%r9
  801f9d:	49 89 c8             	mov    %rcx,%r8
  801fa0:	48 89 d1             	mov    %rdx,%rcx
  801fa3:	48 89 c2             	mov    %rax,%rdx
  801fa6:	be 00 00 00 00       	mov    $0x0,%esi
  801fab:	bf 0c 00 00 00       	mov    $0xc,%edi
  801fb0:	48 b8 bf 1b 80 00 00 	movabs $0x801bbf,%rax
  801fb7:	00 00 00 
  801fba:	ff d0                	callq  *%rax
}
  801fbc:	c9                   	leaveq 
  801fbd:	c3                   	retq   

0000000000801fbe <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801fbe:	55                   	push   %rbp
  801fbf:	48 89 e5             	mov    %rsp,%rbp
  801fc2:	48 83 ec 10          	sub    $0x10,%rsp
  801fc6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801fca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fce:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fd5:	00 
  801fd6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fdc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fe2:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fe7:	48 89 c2             	mov    %rax,%rdx
  801fea:	be 01 00 00 00       	mov    $0x1,%esi
  801fef:	bf 0d 00 00 00       	mov    $0xd,%edi
  801ff4:	48 b8 bf 1b 80 00 00 	movabs $0x801bbf,%rax
  801ffb:	00 00 00 
  801ffe:	ff d0                	callq  *%rax
}
  802000:	c9                   	leaveq 
  802001:	c3                   	retq   

0000000000802002 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802002:	55                   	push   %rbp
  802003:	48 89 e5             	mov    %rsp,%rbp
  802006:	48 83 ec 08          	sub    $0x8,%rsp
  80200a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80200e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802012:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802019:	ff ff ff 
  80201c:	48 01 d0             	add    %rdx,%rax
  80201f:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802023:	c9                   	leaveq 
  802024:	c3                   	retq   

0000000000802025 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802025:	55                   	push   %rbp
  802026:	48 89 e5             	mov    %rsp,%rbp
  802029:	48 83 ec 08          	sub    $0x8,%rsp
  80202d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802031:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802035:	48 89 c7             	mov    %rax,%rdi
  802038:	48 b8 02 20 80 00 00 	movabs $0x802002,%rax
  80203f:	00 00 00 
  802042:	ff d0                	callq  *%rax
  802044:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80204a:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80204e:	c9                   	leaveq 
  80204f:	c3                   	retq   

0000000000802050 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802050:	55                   	push   %rbp
  802051:	48 89 e5             	mov    %rsp,%rbp
  802054:	48 83 ec 18          	sub    $0x18,%rsp
  802058:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80205c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802063:	eb 6b                	jmp    8020d0 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802065:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802068:	48 98                	cltq   
  80206a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802070:	48 c1 e0 0c          	shl    $0xc,%rax
  802074:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802078:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80207c:	48 c1 e8 15          	shr    $0x15,%rax
  802080:	48 89 c2             	mov    %rax,%rdx
  802083:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80208a:	01 00 00 
  80208d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802091:	83 e0 01             	and    $0x1,%eax
  802094:	48 85 c0             	test   %rax,%rax
  802097:	74 21                	je     8020ba <fd_alloc+0x6a>
  802099:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80209d:	48 c1 e8 0c          	shr    $0xc,%rax
  8020a1:	48 89 c2             	mov    %rax,%rdx
  8020a4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020ab:	01 00 00 
  8020ae:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020b2:	83 e0 01             	and    $0x1,%eax
  8020b5:	48 85 c0             	test   %rax,%rax
  8020b8:	75 12                	jne    8020cc <fd_alloc+0x7c>
			*fd_store = fd;
  8020ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020be:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020c2:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8020c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ca:	eb 1a                	jmp    8020e6 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8020cc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020d0:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8020d4:	7e 8f                	jle    802065 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8020d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020da:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8020e1:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8020e6:	c9                   	leaveq 
  8020e7:	c3                   	retq   

00000000008020e8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8020e8:	55                   	push   %rbp
  8020e9:	48 89 e5             	mov    %rsp,%rbp
  8020ec:	48 83 ec 20          	sub    $0x20,%rsp
  8020f0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020f3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8020f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8020fb:	78 06                	js     802103 <fd_lookup+0x1b>
  8020fd:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802101:	7e 07                	jle    80210a <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802103:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802108:	eb 6c                	jmp    802176 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80210a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80210d:	48 98                	cltq   
  80210f:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802115:	48 c1 e0 0c          	shl    $0xc,%rax
  802119:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80211d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802121:	48 c1 e8 15          	shr    $0x15,%rax
  802125:	48 89 c2             	mov    %rax,%rdx
  802128:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80212f:	01 00 00 
  802132:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802136:	83 e0 01             	and    $0x1,%eax
  802139:	48 85 c0             	test   %rax,%rax
  80213c:	74 21                	je     80215f <fd_lookup+0x77>
  80213e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802142:	48 c1 e8 0c          	shr    $0xc,%rax
  802146:	48 89 c2             	mov    %rax,%rdx
  802149:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802150:	01 00 00 
  802153:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802157:	83 e0 01             	and    $0x1,%eax
  80215a:	48 85 c0             	test   %rax,%rax
  80215d:	75 07                	jne    802166 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80215f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802164:	eb 10                	jmp    802176 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802166:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80216a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80216e:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802171:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802176:	c9                   	leaveq 
  802177:	c3                   	retq   

0000000000802178 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802178:	55                   	push   %rbp
  802179:	48 89 e5             	mov    %rsp,%rbp
  80217c:	48 83 ec 30          	sub    $0x30,%rsp
  802180:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802184:	89 f0                	mov    %esi,%eax
  802186:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802189:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80218d:	48 89 c7             	mov    %rax,%rdi
  802190:	48 b8 02 20 80 00 00 	movabs $0x802002,%rax
  802197:	00 00 00 
  80219a:	ff d0                	callq  *%rax
  80219c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021a0:	48 89 d6             	mov    %rdx,%rsi
  8021a3:	89 c7                	mov    %eax,%edi
  8021a5:	48 b8 e8 20 80 00 00 	movabs $0x8020e8,%rax
  8021ac:	00 00 00 
  8021af:	ff d0                	callq  *%rax
  8021b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021b8:	78 0a                	js     8021c4 <fd_close+0x4c>
	    || fd != fd2)
  8021ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021be:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8021c2:	74 12                	je     8021d6 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8021c4:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8021c8:	74 05                	je     8021cf <fd_close+0x57>
  8021ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021cd:	eb 05                	jmp    8021d4 <fd_close+0x5c>
  8021cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d4:	eb 69                	jmp    80223f <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8021d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021da:	8b 00                	mov    (%rax),%eax
  8021dc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021e0:	48 89 d6             	mov    %rdx,%rsi
  8021e3:	89 c7                	mov    %eax,%edi
  8021e5:	48 b8 41 22 80 00 00 	movabs $0x802241,%rax
  8021ec:	00 00 00 
  8021ef:	ff d0                	callq  *%rax
  8021f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021f8:	78 2a                	js     802224 <fd_close+0xac>
		if (dev->dev_close)
  8021fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021fe:	48 8b 40 20          	mov    0x20(%rax),%rax
  802202:	48 85 c0             	test   %rax,%rax
  802205:	74 16                	je     80221d <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802207:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80220b:	48 8b 40 20          	mov    0x20(%rax),%rax
  80220f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802213:	48 89 d7             	mov    %rdx,%rdi
  802216:	ff d0                	callq  *%rax
  802218:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80221b:	eb 07                	jmp    802224 <fd_close+0xac>
		else
			r = 0;
  80221d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802224:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802228:	48 89 c6             	mov    %rax,%rsi
  80222b:	bf 00 00 00 00       	mov    $0x0,%edi
  802230:	48 b8 40 1e 80 00 00 	movabs $0x801e40,%rax
  802237:	00 00 00 
  80223a:	ff d0                	callq  *%rax
	return r;
  80223c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80223f:	c9                   	leaveq 
  802240:	c3                   	retq   

0000000000802241 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802241:	55                   	push   %rbp
  802242:	48 89 e5             	mov    %rsp,%rbp
  802245:	48 83 ec 20          	sub    $0x20,%rsp
  802249:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80224c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802250:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802257:	eb 41                	jmp    80229a <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802259:	48 b8 40 50 80 00 00 	movabs $0x805040,%rax
  802260:	00 00 00 
  802263:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802266:	48 63 d2             	movslq %edx,%rdx
  802269:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80226d:	8b 00                	mov    (%rax),%eax
  80226f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802272:	75 22                	jne    802296 <dev_lookup+0x55>
			*dev = devtab[i];
  802274:	48 b8 40 50 80 00 00 	movabs $0x805040,%rax
  80227b:	00 00 00 
  80227e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802281:	48 63 d2             	movslq %edx,%rdx
  802284:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802288:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80228c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80228f:	b8 00 00 00 00       	mov    $0x0,%eax
  802294:	eb 60                	jmp    8022f6 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802296:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80229a:	48 b8 40 50 80 00 00 	movabs $0x805040,%rax
  8022a1:	00 00 00 
  8022a4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8022a7:	48 63 d2             	movslq %edx,%rdx
  8022aa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022ae:	48 85 c0             	test   %rax,%rax
  8022b1:	75 a6                	jne    802259 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8022b3:	48 b8 08 64 80 00 00 	movabs $0x806408,%rax
  8022ba:	00 00 00 
  8022bd:	48 8b 00             	mov    (%rax),%rax
  8022c0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022c6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8022c9:	89 c6                	mov    %eax,%esi
  8022cb:	48 bf 68 40 80 00 00 	movabs $0x804068,%rdi
  8022d2:	00 00 00 
  8022d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022da:	48 b9 57 07 80 00 00 	movabs $0x800757,%rcx
  8022e1:	00 00 00 
  8022e4:	ff d1                	callq  *%rcx
	*dev = 0;
  8022e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022ea:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8022f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8022f6:	c9                   	leaveq 
  8022f7:	c3                   	retq   

00000000008022f8 <close>:

int
close(int fdnum)
{
  8022f8:	55                   	push   %rbp
  8022f9:	48 89 e5             	mov    %rsp,%rbp
  8022fc:	48 83 ec 20          	sub    $0x20,%rsp
  802300:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802303:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802307:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80230a:	48 89 d6             	mov    %rdx,%rsi
  80230d:	89 c7                	mov    %eax,%edi
  80230f:	48 b8 e8 20 80 00 00 	movabs $0x8020e8,%rax
  802316:	00 00 00 
  802319:	ff d0                	callq  *%rax
  80231b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80231e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802322:	79 05                	jns    802329 <close+0x31>
		return r;
  802324:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802327:	eb 18                	jmp    802341 <close+0x49>
	else
		return fd_close(fd, 1);
  802329:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80232d:	be 01 00 00 00       	mov    $0x1,%esi
  802332:	48 89 c7             	mov    %rax,%rdi
  802335:	48 b8 78 21 80 00 00 	movabs $0x802178,%rax
  80233c:	00 00 00 
  80233f:	ff d0                	callq  *%rax
}
  802341:	c9                   	leaveq 
  802342:	c3                   	retq   

0000000000802343 <close_all>:

void
close_all(void)
{
  802343:	55                   	push   %rbp
  802344:	48 89 e5             	mov    %rsp,%rbp
  802347:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80234b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802352:	eb 15                	jmp    802369 <close_all+0x26>
		close(i);
  802354:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802357:	89 c7                	mov    %eax,%edi
  802359:	48 b8 f8 22 80 00 00 	movabs $0x8022f8,%rax
  802360:	00 00 00 
  802363:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802365:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802369:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80236d:	7e e5                	jle    802354 <close_all+0x11>
		close(i);
}
  80236f:	c9                   	leaveq 
  802370:	c3                   	retq   

0000000000802371 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802371:	55                   	push   %rbp
  802372:	48 89 e5             	mov    %rsp,%rbp
  802375:	48 83 ec 40          	sub    $0x40,%rsp
  802379:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80237c:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80237f:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802383:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802386:	48 89 d6             	mov    %rdx,%rsi
  802389:	89 c7                	mov    %eax,%edi
  80238b:	48 b8 e8 20 80 00 00 	movabs $0x8020e8,%rax
  802392:	00 00 00 
  802395:	ff d0                	callq  *%rax
  802397:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80239a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80239e:	79 08                	jns    8023a8 <dup+0x37>
		return r;
  8023a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023a3:	e9 70 01 00 00       	jmpq   802518 <dup+0x1a7>
	close(newfdnum);
  8023a8:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8023ab:	89 c7                	mov    %eax,%edi
  8023ad:	48 b8 f8 22 80 00 00 	movabs $0x8022f8,%rax
  8023b4:	00 00 00 
  8023b7:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8023b9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8023bc:	48 98                	cltq   
  8023be:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8023c4:	48 c1 e0 0c          	shl    $0xc,%rax
  8023c8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8023cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023d0:	48 89 c7             	mov    %rax,%rdi
  8023d3:	48 b8 25 20 80 00 00 	movabs $0x802025,%rax
  8023da:	00 00 00 
  8023dd:	ff d0                	callq  *%rax
  8023df:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8023e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023e7:	48 89 c7             	mov    %rax,%rdi
  8023ea:	48 b8 25 20 80 00 00 	movabs $0x802025,%rax
  8023f1:	00 00 00 
  8023f4:	ff d0                	callq  *%rax
  8023f6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8023fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023fe:	48 c1 e8 15          	shr    $0x15,%rax
  802402:	48 89 c2             	mov    %rax,%rdx
  802405:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80240c:	01 00 00 
  80240f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802413:	83 e0 01             	and    $0x1,%eax
  802416:	48 85 c0             	test   %rax,%rax
  802419:	74 73                	je     80248e <dup+0x11d>
  80241b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80241f:	48 c1 e8 0c          	shr    $0xc,%rax
  802423:	48 89 c2             	mov    %rax,%rdx
  802426:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80242d:	01 00 00 
  802430:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802434:	83 e0 01             	and    $0x1,%eax
  802437:	48 85 c0             	test   %rax,%rax
  80243a:	74 52                	je     80248e <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80243c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802440:	48 c1 e8 0c          	shr    $0xc,%rax
  802444:	48 89 c2             	mov    %rax,%rdx
  802447:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80244e:	01 00 00 
  802451:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802455:	25 07 0e 00 00       	and    $0xe07,%eax
  80245a:	89 c1                	mov    %eax,%ecx
  80245c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802460:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802464:	41 89 c8             	mov    %ecx,%r8d
  802467:	48 89 d1             	mov    %rdx,%rcx
  80246a:	ba 00 00 00 00       	mov    $0x0,%edx
  80246f:	48 89 c6             	mov    %rax,%rsi
  802472:	bf 00 00 00 00       	mov    $0x0,%edi
  802477:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  80247e:	00 00 00 
  802481:	ff d0                	callq  *%rax
  802483:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802486:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80248a:	79 02                	jns    80248e <dup+0x11d>
			goto err;
  80248c:	eb 57                	jmp    8024e5 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80248e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802492:	48 c1 e8 0c          	shr    $0xc,%rax
  802496:	48 89 c2             	mov    %rax,%rdx
  802499:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024a0:	01 00 00 
  8024a3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024a7:	25 07 0e 00 00       	and    $0xe07,%eax
  8024ac:	89 c1                	mov    %eax,%ecx
  8024ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024b2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024b6:	41 89 c8             	mov    %ecx,%r8d
  8024b9:	48 89 d1             	mov    %rdx,%rcx
  8024bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8024c1:	48 89 c6             	mov    %rax,%rsi
  8024c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8024c9:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  8024d0:	00 00 00 
  8024d3:	ff d0                	callq  *%rax
  8024d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024dc:	79 02                	jns    8024e0 <dup+0x16f>
		goto err;
  8024de:	eb 05                	jmp    8024e5 <dup+0x174>

	return newfdnum;
  8024e0:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8024e3:	eb 33                	jmp    802518 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8024e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024e9:	48 89 c6             	mov    %rax,%rsi
  8024ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8024f1:	48 b8 40 1e 80 00 00 	movabs $0x801e40,%rax
  8024f8:	00 00 00 
  8024fb:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8024fd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802501:	48 89 c6             	mov    %rax,%rsi
  802504:	bf 00 00 00 00       	mov    $0x0,%edi
  802509:	48 b8 40 1e 80 00 00 	movabs $0x801e40,%rax
  802510:	00 00 00 
  802513:	ff d0                	callq  *%rax
	return r;
  802515:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802518:	c9                   	leaveq 
  802519:	c3                   	retq   

000000000080251a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80251a:	55                   	push   %rbp
  80251b:	48 89 e5             	mov    %rsp,%rbp
  80251e:	48 83 ec 40          	sub    $0x40,%rsp
  802522:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802525:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802529:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80252d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802531:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802534:	48 89 d6             	mov    %rdx,%rsi
  802537:	89 c7                	mov    %eax,%edi
  802539:	48 b8 e8 20 80 00 00 	movabs $0x8020e8,%rax
  802540:	00 00 00 
  802543:	ff d0                	callq  *%rax
  802545:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802548:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80254c:	78 24                	js     802572 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80254e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802552:	8b 00                	mov    (%rax),%eax
  802554:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802558:	48 89 d6             	mov    %rdx,%rsi
  80255b:	89 c7                	mov    %eax,%edi
  80255d:	48 b8 41 22 80 00 00 	movabs $0x802241,%rax
  802564:	00 00 00 
  802567:	ff d0                	callq  *%rax
  802569:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80256c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802570:	79 05                	jns    802577 <read+0x5d>
		return r;
  802572:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802575:	eb 76                	jmp    8025ed <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802577:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80257b:	8b 40 08             	mov    0x8(%rax),%eax
  80257e:	83 e0 03             	and    $0x3,%eax
  802581:	83 f8 01             	cmp    $0x1,%eax
  802584:	75 3a                	jne    8025c0 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802586:	48 b8 08 64 80 00 00 	movabs $0x806408,%rax
  80258d:	00 00 00 
  802590:	48 8b 00             	mov    (%rax),%rax
  802593:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802599:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80259c:	89 c6                	mov    %eax,%esi
  80259e:	48 bf 87 40 80 00 00 	movabs $0x804087,%rdi
  8025a5:	00 00 00 
  8025a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ad:	48 b9 57 07 80 00 00 	movabs $0x800757,%rcx
  8025b4:	00 00 00 
  8025b7:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8025b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025be:	eb 2d                	jmp    8025ed <read+0xd3>
	}
	if (!dev->dev_read)
  8025c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025c4:	48 8b 40 10          	mov    0x10(%rax),%rax
  8025c8:	48 85 c0             	test   %rax,%rax
  8025cb:	75 07                	jne    8025d4 <read+0xba>
		return -E_NOT_SUPP;
  8025cd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025d2:	eb 19                	jmp    8025ed <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8025d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025d8:	48 8b 40 10          	mov    0x10(%rax),%rax
  8025dc:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8025e0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025e4:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025e8:	48 89 cf             	mov    %rcx,%rdi
  8025eb:	ff d0                	callq  *%rax
}
  8025ed:	c9                   	leaveq 
  8025ee:	c3                   	retq   

00000000008025ef <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8025ef:	55                   	push   %rbp
  8025f0:	48 89 e5             	mov    %rsp,%rbp
  8025f3:	48 83 ec 30          	sub    $0x30,%rsp
  8025f7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025fa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8025fe:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802602:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802609:	eb 49                	jmp    802654 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80260b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80260e:	48 98                	cltq   
  802610:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802614:	48 29 c2             	sub    %rax,%rdx
  802617:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80261a:	48 63 c8             	movslq %eax,%rcx
  80261d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802621:	48 01 c1             	add    %rax,%rcx
  802624:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802627:	48 89 ce             	mov    %rcx,%rsi
  80262a:	89 c7                	mov    %eax,%edi
  80262c:	48 b8 1a 25 80 00 00 	movabs $0x80251a,%rax
  802633:	00 00 00 
  802636:	ff d0                	callq  *%rax
  802638:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80263b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80263f:	79 05                	jns    802646 <readn+0x57>
			return m;
  802641:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802644:	eb 1c                	jmp    802662 <readn+0x73>
		if (m == 0)
  802646:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80264a:	75 02                	jne    80264e <readn+0x5f>
			break;
  80264c:	eb 11                	jmp    80265f <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80264e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802651:	01 45 fc             	add    %eax,-0x4(%rbp)
  802654:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802657:	48 98                	cltq   
  802659:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80265d:	72 ac                	jb     80260b <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80265f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802662:	c9                   	leaveq 
  802663:	c3                   	retq   

0000000000802664 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802664:	55                   	push   %rbp
  802665:	48 89 e5             	mov    %rsp,%rbp
  802668:	48 83 ec 40          	sub    $0x40,%rsp
  80266c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80266f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802673:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802677:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80267b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80267e:	48 89 d6             	mov    %rdx,%rsi
  802681:	89 c7                	mov    %eax,%edi
  802683:	48 b8 e8 20 80 00 00 	movabs $0x8020e8,%rax
  80268a:	00 00 00 
  80268d:	ff d0                	callq  *%rax
  80268f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802692:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802696:	78 24                	js     8026bc <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802698:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80269c:	8b 00                	mov    (%rax),%eax
  80269e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026a2:	48 89 d6             	mov    %rdx,%rsi
  8026a5:	89 c7                	mov    %eax,%edi
  8026a7:	48 b8 41 22 80 00 00 	movabs $0x802241,%rax
  8026ae:	00 00 00 
  8026b1:	ff d0                	callq  *%rax
  8026b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026ba:	79 05                	jns    8026c1 <write+0x5d>
		return r;
  8026bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026bf:	eb 75                	jmp    802736 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8026c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026c5:	8b 40 08             	mov    0x8(%rax),%eax
  8026c8:	83 e0 03             	and    $0x3,%eax
  8026cb:	85 c0                	test   %eax,%eax
  8026cd:	75 3a                	jne    802709 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8026cf:	48 b8 08 64 80 00 00 	movabs $0x806408,%rax
  8026d6:	00 00 00 
  8026d9:	48 8b 00             	mov    (%rax),%rax
  8026dc:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8026e2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8026e5:	89 c6                	mov    %eax,%esi
  8026e7:	48 bf a3 40 80 00 00 	movabs $0x8040a3,%rdi
  8026ee:	00 00 00 
  8026f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f6:	48 b9 57 07 80 00 00 	movabs $0x800757,%rcx
  8026fd:	00 00 00 
  802700:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802702:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802707:	eb 2d                	jmp    802736 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802709:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80270d:	48 8b 40 18          	mov    0x18(%rax),%rax
  802711:	48 85 c0             	test   %rax,%rax
  802714:	75 07                	jne    80271d <write+0xb9>
		return -E_NOT_SUPP;
  802716:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80271b:	eb 19                	jmp    802736 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80271d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802721:	48 8b 40 18          	mov    0x18(%rax),%rax
  802725:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802729:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80272d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802731:	48 89 cf             	mov    %rcx,%rdi
  802734:	ff d0                	callq  *%rax
}
  802736:	c9                   	leaveq 
  802737:	c3                   	retq   

0000000000802738 <seek>:

int
seek(int fdnum, off_t offset)
{
  802738:	55                   	push   %rbp
  802739:	48 89 e5             	mov    %rsp,%rbp
  80273c:	48 83 ec 18          	sub    $0x18,%rsp
  802740:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802743:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802746:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80274a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80274d:	48 89 d6             	mov    %rdx,%rsi
  802750:	89 c7                	mov    %eax,%edi
  802752:	48 b8 e8 20 80 00 00 	movabs $0x8020e8,%rax
  802759:	00 00 00 
  80275c:	ff d0                	callq  *%rax
  80275e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802761:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802765:	79 05                	jns    80276c <seek+0x34>
		return r;
  802767:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80276a:	eb 0f                	jmp    80277b <seek+0x43>
	fd->fd_offset = offset;
  80276c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802770:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802773:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802776:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80277b:	c9                   	leaveq 
  80277c:	c3                   	retq   

000000000080277d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80277d:	55                   	push   %rbp
  80277e:	48 89 e5             	mov    %rsp,%rbp
  802781:	48 83 ec 30          	sub    $0x30,%rsp
  802785:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802788:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80278b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80278f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802792:	48 89 d6             	mov    %rdx,%rsi
  802795:	89 c7                	mov    %eax,%edi
  802797:	48 b8 e8 20 80 00 00 	movabs $0x8020e8,%rax
  80279e:	00 00 00 
  8027a1:	ff d0                	callq  *%rax
  8027a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027aa:	78 24                	js     8027d0 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8027ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b0:	8b 00                	mov    (%rax),%eax
  8027b2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027b6:	48 89 d6             	mov    %rdx,%rsi
  8027b9:	89 c7                	mov    %eax,%edi
  8027bb:	48 b8 41 22 80 00 00 	movabs $0x802241,%rax
  8027c2:	00 00 00 
  8027c5:	ff d0                	callq  *%rax
  8027c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027ce:	79 05                	jns    8027d5 <ftruncate+0x58>
		return r;
  8027d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027d3:	eb 72                	jmp    802847 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8027d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027d9:	8b 40 08             	mov    0x8(%rax),%eax
  8027dc:	83 e0 03             	and    $0x3,%eax
  8027df:	85 c0                	test   %eax,%eax
  8027e1:	75 3a                	jne    80281d <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8027e3:	48 b8 08 64 80 00 00 	movabs $0x806408,%rax
  8027ea:	00 00 00 
  8027ed:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8027f0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027f6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8027f9:	89 c6                	mov    %eax,%esi
  8027fb:	48 bf c0 40 80 00 00 	movabs $0x8040c0,%rdi
  802802:	00 00 00 
  802805:	b8 00 00 00 00       	mov    $0x0,%eax
  80280a:	48 b9 57 07 80 00 00 	movabs $0x800757,%rcx
  802811:	00 00 00 
  802814:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802816:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80281b:	eb 2a                	jmp    802847 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80281d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802821:	48 8b 40 30          	mov    0x30(%rax),%rax
  802825:	48 85 c0             	test   %rax,%rax
  802828:	75 07                	jne    802831 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80282a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80282f:	eb 16                	jmp    802847 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802831:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802835:	48 8b 40 30          	mov    0x30(%rax),%rax
  802839:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80283d:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802840:	89 ce                	mov    %ecx,%esi
  802842:	48 89 d7             	mov    %rdx,%rdi
  802845:	ff d0                	callq  *%rax
}
  802847:	c9                   	leaveq 
  802848:	c3                   	retq   

0000000000802849 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802849:	55                   	push   %rbp
  80284a:	48 89 e5             	mov    %rsp,%rbp
  80284d:	48 83 ec 30          	sub    $0x30,%rsp
  802851:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802854:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802858:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80285c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80285f:	48 89 d6             	mov    %rdx,%rsi
  802862:	89 c7                	mov    %eax,%edi
  802864:	48 b8 e8 20 80 00 00 	movabs $0x8020e8,%rax
  80286b:	00 00 00 
  80286e:	ff d0                	callq  *%rax
  802870:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802873:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802877:	78 24                	js     80289d <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802879:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80287d:	8b 00                	mov    (%rax),%eax
  80287f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802883:	48 89 d6             	mov    %rdx,%rsi
  802886:	89 c7                	mov    %eax,%edi
  802888:	48 b8 41 22 80 00 00 	movabs $0x802241,%rax
  80288f:	00 00 00 
  802892:	ff d0                	callq  *%rax
  802894:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802897:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80289b:	79 05                	jns    8028a2 <fstat+0x59>
		return r;
  80289d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028a0:	eb 5e                	jmp    802900 <fstat+0xb7>
	if (!dev->dev_stat)
  8028a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028a6:	48 8b 40 28          	mov    0x28(%rax),%rax
  8028aa:	48 85 c0             	test   %rax,%rax
  8028ad:	75 07                	jne    8028b6 <fstat+0x6d>
		return -E_NOT_SUPP;
  8028af:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028b4:	eb 4a                	jmp    802900 <fstat+0xb7>
	stat->st_name[0] = 0;
  8028b6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028ba:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8028bd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028c1:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8028c8:	00 00 00 
	stat->st_isdir = 0;
  8028cb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028cf:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8028d6:	00 00 00 
	stat->st_dev = dev;
  8028d9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8028dd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028e1:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8028e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028ec:	48 8b 40 28          	mov    0x28(%rax),%rax
  8028f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028f4:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8028f8:	48 89 ce             	mov    %rcx,%rsi
  8028fb:	48 89 d7             	mov    %rdx,%rdi
  8028fe:	ff d0                	callq  *%rax
}
  802900:	c9                   	leaveq 
  802901:	c3                   	retq   

0000000000802902 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802902:	55                   	push   %rbp
  802903:	48 89 e5             	mov    %rsp,%rbp
  802906:	48 83 ec 20          	sub    $0x20,%rsp
  80290a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80290e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802912:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802916:	be 00 00 00 00       	mov    $0x0,%esi
  80291b:	48 89 c7             	mov    %rax,%rdi
  80291e:	48 b8 f0 29 80 00 00 	movabs $0x8029f0,%rax
  802925:	00 00 00 
  802928:	ff d0                	callq  *%rax
  80292a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80292d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802931:	79 05                	jns    802938 <stat+0x36>
		return fd;
  802933:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802936:	eb 2f                	jmp    802967 <stat+0x65>
	r = fstat(fd, stat);
  802938:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80293c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80293f:	48 89 d6             	mov    %rdx,%rsi
  802942:	89 c7                	mov    %eax,%edi
  802944:	48 b8 49 28 80 00 00 	movabs $0x802849,%rax
  80294b:	00 00 00 
  80294e:	ff d0                	callq  *%rax
  802950:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802953:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802956:	89 c7                	mov    %eax,%edi
  802958:	48 b8 f8 22 80 00 00 	movabs $0x8022f8,%rax
  80295f:	00 00 00 
  802962:	ff d0                	callq  *%rax
	return r;
  802964:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802967:	c9                   	leaveq 
  802968:	c3                   	retq   

0000000000802969 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802969:	55                   	push   %rbp
  80296a:	48 89 e5             	mov    %rsp,%rbp
  80296d:	48 83 ec 10          	sub    $0x10,%rsp
  802971:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802974:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802978:	48 b8 00 64 80 00 00 	movabs $0x806400,%rax
  80297f:	00 00 00 
  802982:	8b 00                	mov    (%rax),%eax
  802984:	85 c0                	test   %eax,%eax
  802986:	75 1d                	jne    8029a5 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802988:	bf 01 00 00 00       	mov    $0x1,%edi
  80298d:	48 b8 83 39 80 00 00 	movabs $0x803983,%rax
  802994:	00 00 00 
  802997:	ff d0                	callq  *%rax
  802999:	48 ba 00 64 80 00 00 	movabs $0x806400,%rdx
  8029a0:	00 00 00 
  8029a3:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8029a5:	48 b8 00 64 80 00 00 	movabs $0x806400,%rax
  8029ac:	00 00 00 
  8029af:	8b 00                	mov    (%rax),%eax
  8029b1:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8029b4:	b9 07 00 00 00       	mov    $0x7,%ecx
  8029b9:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8029c0:	00 00 00 
  8029c3:	89 c7                	mov    %eax,%edi
  8029c5:	48 b8 e6 38 80 00 00 	movabs $0x8038e6,%rax
  8029cc:	00 00 00 
  8029cf:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8029d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8029da:	48 89 c6             	mov    %rax,%rsi
  8029dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8029e2:	48 b8 20 38 80 00 00 	movabs $0x803820,%rax
  8029e9:	00 00 00 
  8029ec:	ff d0                	callq  *%rax
}
  8029ee:	c9                   	leaveq 
  8029ef:	c3                   	retq   

00000000008029f0 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8029f0:	55                   	push   %rbp
  8029f1:	48 89 e5             	mov    %rsp,%rbp
  8029f4:	48 83 ec 20          	sub    $0x20,%rsp
  8029f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029fc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  8029ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a03:	48 89 c7             	mov    %rax,%rdi
  802a06:	48 b8 fa 13 80 00 00 	movabs $0x8013fa,%rax
  802a0d:	00 00 00 
  802a10:	ff d0                	callq  *%rax
  802a12:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802a17:	7e 0a                	jle    802a23 <open+0x33>
  802a19:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802a1e:	e9 a5 00 00 00       	jmpq   802ac8 <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  802a23:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802a27:	48 89 c7             	mov    %rax,%rdi
  802a2a:	48 b8 50 20 80 00 00 	movabs $0x802050,%rax
  802a31:	00 00 00 
  802a34:	ff d0                	callq  *%rax
  802a36:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a39:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a3d:	79 08                	jns    802a47 <open+0x57>
		return r;
  802a3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a42:	e9 81 00 00 00       	jmpq   802ac8 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  802a47:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a4e:	00 00 00 
  802a51:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802a54:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  802a5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a5e:	48 89 c6             	mov    %rax,%rsi
  802a61:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802a68:	00 00 00 
  802a6b:	48 b8 66 14 80 00 00 	movabs $0x801466,%rax
  802a72:	00 00 00 
  802a75:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  802a77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a7b:	48 89 c6             	mov    %rax,%rsi
  802a7e:	bf 01 00 00 00       	mov    $0x1,%edi
  802a83:	48 b8 69 29 80 00 00 	movabs $0x802969,%rax
  802a8a:	00 00 00 
  802a8d:	ff d0                	callq  *%rax
  802a8f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a92:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a96:	79 1d                	jns    802ab5 <open+0xc5>
		fd_close(fd, 0);
  802a98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a9c:	be 00 00 00 00       	mov    $0x0,%esi
  802aa1:	48 89 c7             	mov    %rax,%rdi
  802aa4:	48 b8 78 21 80 00 00 	movabs $0x802178,%rax
  802aab:	00 00 00 
  802aae:	ff d0                	callq  *%rax
		return r;
  802ab0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ab3:	eb 13                	jmp    802ac8 <open+0xd8>
	}
	return fd2num(fd);
  802ab5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ab9:	48 89 c7             	mov    %rax,%rdi
  802abc:	48 b8 02 20 80 00 00 	movabs $0x802002,%rax
  802ac3:	00 00 00 
  802ac6:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  802ac8:	c9                   	leaveq 
  802ac9:	c3                   	retq   

0000000000802aca <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802aca:	55                   	push   %rbp
  802acb:	48 89 e5             	mov    %rsp,%rbp
  802ace:	48 83 ec 10          	sub    $0x10,%rsp
  802ad2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802ad6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ada:	8b 50 0c             	mov    0xc(%rax),%edx
  802add:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802ae4:	00 00 00 
  802ae7:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802ae9:	be 00 00 00 00       	mov    $0x0,%esi
  802aee:	bf 06 00 00 00       	mov    $0x6,%edi
  802af3:	48 b8 69 29 80 00 00 	movabs $0x802969,%rax
  802afa:	00 00 00 
  802afd:	ff d0                	callq  *%rax
}
  802aff:	c9                   	leaveq 
  802b00:	c3                   	retq   

0000000000802b01 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802b01:	55                   	push   %rbp
  802b02:	48 89 e5             	mov    %rsp,%rbp
  802b05:	48 83 ec 30          	sub    $0x30,%rsp
  802b09:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b0d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b11:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802b15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b19:	8b 50 0c             	mov    0xc(%rax),%edx
  802b1c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b23:	00 00 00 
  802b26:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802b28:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b2f:	00 00 00 
  802b32:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b36:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  802b3a:	be 00 00 00 00       	mov    $0x0,%esi
  802b3f:	bf 03 00 00 00       	mov    $0x3,%edi
  802b44:	48 b8 69 29 80 00 00 	movabs $0x802969,%rax
  802b4b:	00 00 00 
  802b4e:	ff d0                	callq  *%rax
  802b50:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b53:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b57:	79 05                	jns    802b5e <devfile_read+0x5d>
		return r;
  802b59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b5c:	eb 26                	jmp    802b84 <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  802b5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b61:	48 63 d0             	movslq %eax,%rdx
  802b64:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b68:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802b6f:	00 00 00 
  802b72:	48 89 c7             	mov    %rax,%rdi
  802b75:	48 b8 a1 18 80 00 00 	movabs $0x8018a1,%rax
  802b7c:	00 00 00 
  802b7f:	ff d0                	callq  *%rax
	return r;
  802b81:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802b84:	c9                   	leaveq 
  802b85:	c3                   	retq   

0000000000802b86 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802b86:	55                   	push   %rbp
  802b87:	48 89 e5             	mov    %rsp,%rbp
  802b8a:	48 83 ec 30          	sub    $0x30,%rsp
  802b8e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b92:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b96:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  802b9a:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  802ba1:	00 
	n = n > max ? max : n;
  802ba2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ba6:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802baa:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  802baf:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802bb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bb7:	8b 50 0c             	mov    0xc(%rax),%edx
  802bba:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802bc1:	00 00 00 
  802bc4:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802bc6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802bcd:	00 00 00 
  802bd0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802bd4:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802bd8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802bdc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802be0:	48 89 c6             	mov    %rax,%rsi
  802be3:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802bea:	00 00 00 
  802bed:	48 b8 a1 18 80 00 00 	movabs $0x8018a1,%rax
  802bf4:	00 00 00 
  802bf7:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  802bf9:	be 00 00 00 00       	mov    $0x0,%esi
  802bfe:	bf 04 00 00 00       	mov    $0x4,%edi
  802c03:	48 b8 69 29 80 00 00 	movabs $0x802969,%rax
  802c0a:	00 00 00 
  802c0d:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  802c0f:	c9                   	leaveq 
  802c10:	c3                   	retq   

0000000000802c11 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802c11:	55                   	push   %rbp
  802c12:	48 89 e5             	mov    %rsp,%rbp
  802c15:	48 83 ec 20          	sub    $0x20,%rsp
  802c19:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c1d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802c21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c25:	8b 50 0c             	mov    0xc(%rax),%edx
  802c28:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c2f:	00 00 00 
  802c32:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802c34:	be 00 00 00 00       	mov    $0x0,%esi
  802c39:	bf 05 00 00 00       	mov    $0x5,%edi
  802c3e:	48 b8 69 29 80 00 00 	movabs $0x802969,%rax
  802c45:	00 00 00 
  802c48:	ff d0                	callq  *%rax
  802c4a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c4d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c51:	79 05                	jns    802c58 <devfile_stat+0x47>
		return r;
  802c53:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c56:	eb 56                	jmp    802cae <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802c58:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c5c:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802c63:	00 00 00 
  802c66:	48 89 c7             	mov    %rax,%rdi
  802c69:	48 b8 66 14 80 00 00 	movabs $0x801466,%rax
  802c70:	00 00 00 
  802c73:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802c75:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c7c:	00 00 00 
  802c7f:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802c85:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c89:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802c8f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c96:	00 00 00 
  802c99:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802c9f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ca3:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802ca9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cae:	c9                   	leaveq 
  802caf:	c3                   	retq   

0000000000802cb0 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802cb0:	55                   	push   %rbp
  802cb1:	48 89 e5             	mov    %rsp,%rbp
  802cb4:	48 83 ec 10          	sub    $0x10,%rsp
  802cb8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802cbc:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802cbf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cc3:	8b 50 0c             	mov    0xc(%rax),%edx
  802cc6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802ccd:	00 00 00 
  802cd0:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802cd2:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802cd9:	00 00 00 
  802cdc:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802cdf:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802ce2:	be 00 00 00 00       	mov    $0x0,%esi
  802ce7:	bf 02 00 00 00       	mov    $0x2,%edi
  802cec:	48 b8 69 29 80 00 00 	movabs $0x802969,%rax
  802cf3:	00 00 00 
  802cf6:	ff d0                	callq  *%rax
}
  802cf8:	c9                   	leaveq 
  802cf9:	c3                   	retq   

0000000000802cfa <remove>:

// Delete a file
int
remove(const char *path)
{
  802cfa:	55                   	push   %rbp
  802cfb:	48 89 e5             	mov    %rsp,%rbp
  802cfe:	48 83 ec 10          	sub    $0x10,%rsp
  802d02:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802d06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d0a:	48 89 c7             	mov    %rax,%rdi
  802d0d:	48 b8 fa 13 80 00 00 	movabs $0x8013fa,%rax
  802d14:	00 00 00 
  802d17:	ff d0                	callq  *%rax
  802d19:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802d1e:	7e 07                	jle    802d27 <remove+0x2d>
		return -E_BAD_PATH;
  802d20:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802d25:	eb 33                	jmp    802d5a <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802d27:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d2b:	48 89 c6             	mov    %rax,%rsi
  802d2e:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802d35:	00 00 00 
  802d38:	48 b8 66 14 80 00 00 	movabs $0x801466,%rax
  802d3f:	00 00 00 
  802d42:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802d44:	be 00 00 00 00       	mov    $0x0,%esi
  802d49:	bf 07 00 00 00       	mov    $0x7,%edi
  802d4e:	48 b8 69 29 80 00 00 	movabs $0x802969,%rax
  802d55:	00 00 00 
  802d58:	ff d0                	callq  *%rax
}
  802d5a:	c9                   	leaveq 
  802d5b:	c3                   	retq   

0000000000802d5c <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802d5c:	55                   	push   %rbp
  802d5d:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802d60:	be 00 00 00 00       	mov    $0x0,%esi
  802d65:	bf 08 00 00 00       	mov    $0x8,%edi
  802d6a:	48 b8 69 29 80 00 00 	movabs $0x802969,%rax
  802d71:	00 00 00 
  802d74:	ff d0                	callq  *%rax
}
  802d76:	5d                   	pop    %rbp
  802d77:	c3                   	retq   

0000000000802d78 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802d78:	55                   	push   %rbp
  802d79:	48 89 e5             	mov    %rsp,%rbp
  802d7c:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802d83:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802d8a:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802d91:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802d98:	be 00 00 00 00       	mov    $0x0,%esi
  802d9d:	48 89 c7             	mov    %rax,%rdi
  802da0:	48 b8 f0 29 80 00 00 	movabs $0x8029f0,%rax
  802da7:	00 00 00 
  802daa:	ff d0                	callq  *%rax
  802dac:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802daf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802db3:	79 28                	jns    802ddd <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802db5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db8:	89 c6                	mov    %eax,%esi
  802dba:	48 bf e6 40 80 00 00 	movabs $0x8040e6,%rdi
  802dc1:	00 00 00 
  802dc4:	b8 00 00 00 00       	mov    $0x0,%eax
  802dc9:	48 ba 57 07 80 00 00 	movabs $0x800757,%rdx
  802dd0:	00 00 00 
  802dd3:	ff d2                	callq  *%rdx
		return fd_src;
  802dd5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dd8:	e9 74 01 00 00       	jmpq   802f51 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802ddd:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802de4:	be 01 01 00 00       	mov    $0x101,%esi
  802de9:	48 89 c7             	mov    %rax,%rdi
  802dec:	48 b8 f0 29 80 00 00 	movabs $0x8029f0,%rax
  802df3:	00 00 00 
  802df6:	ff d0                	callq  *%rax
  802df8:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802dfb:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802dff:	79 39                	jns    802e3a <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802e01:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e04:	89 c6                	mov    %eax,%esi
  802e06:	48 bf fc 40 80 00 00 	movabs $0x8040fc,%rdi
  802e0d:	00 00 00 
  802e10:	b8 00 00 00 00       	mov    $0x0,%eax
  802e15:	48 ba 57 07 80 00 00 	movabs $0x800757,%rdx
  802e1c:	00 00 00 
  802e1f:	ff d2                	callq  *%rdx
		close(fd_src);
  802e21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e24:	89 c7                	mov    %eax,%edi
  802e26:	48 b8 f8 22 80 00 00 	movabs $0x8022f8,%rax
  802e2d:	00 00 00 
  802e30:	ff d0                	callq  *%rax
		return fd_dest;
  802e32:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e35:	e9 17 01 00 00       	jmpq   802f51 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802e3a:	eb 74                	jmp    802eb0 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802e3c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e3f:	48 63 d0             	movslq %eax,%rdx
  802e42:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802e49:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e4c:	48 89 ce             	mov    %rcx,%rsi
  802e4f:	89 c7                	mov    %eax,%edi
  802e51:	48 b8 64 26 80 00 00 	movabs $0x802664,%rax
  802e58:	00 00 00 
  802e5b:	ff d0                	callq  *%rax
  802e5d:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802e60:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802e64:	79 4a                	jns    802eb0 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802e66:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802e69:	89 c6                	mov    %eax,%esi
  802e6b:	48 bf 16 41 80 00 00 	movabs $0x804116,%rdi
  802e72:	00 00 00 
  802e75:	b8 00 00 00 00       	mov    $0x0,%eax
  802e7a:	48 ba 57 07 80 00 00 	movabs $0x800757,%rdx
  802e81:	00 00 00 
  802e84:	ff d2                	callq  *%rdx
			close(fd_src);
  802e86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e89:	89 c7                	mov    %eax,%edi
  802e8b:	48 b8 f8 22 80 00 00 	movabs $0x8022f8,%rax
  802e92:	00 00 00 
  802e95:	ff d0                	callq  *%rax
			close(fd_dest);
  802e97:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e9a:	89 c7                	mov    %eax,%edi
  802e9c:	48 b8 f8 22 80 00 00 	movabs $0x8022f8,%rax
  802ea3:	00 00 00 
  802ea6:	ff d0                	callq  *%rax
			return write_size;
  802ea8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802eab:	e9 a1 00 00 00       	jmpq   802f51 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802eb0:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802eb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eba:	ba 00 02 00 00       	mov    $0x200,%edx
  802ebf:	48 89 ce             	mov    %rcx,%rsi
  802ec2:	89 c7                	mov    %eax,%edi
  802ec4:	48 b8 1a 25 80 00 00 	movabs $0x80251a,%rax
  802ecb:	00 00 00 
  802ece:	ff d0                	callq  *%rax
  802ed0:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802ed3:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802ed7:	0f 8f 5f ff ff ff    	jg     802e3c <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802edd:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802ee1:	79 47                	jns    802f2a <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802ee3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ee6:	89 c6                	mov    %eax,%esi
  802ee8:	48 bf 29 41 80 00 00 	movabs $0x804129,%rdi
  802eef:	00 00 00 
  802ef2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ef7:	48 ba 57 07 80 00 00 	movabs $0x800757,%rdx
  802efe:	00 00 00 
  802f01:	ff d2                	callq  *%rdx
		close(fd_src);
  802f03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f06:	89 c7                	mov    %eax,%edi
  802f08:	48 b8 f8 22 80 00 00 	movabs $0x8022f8,%rax
  802f0f:	00 00 00 
  802f12:	ff d0                	callq  *%rax
		close(fd_dest);
  802f14:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f17:	89 c7                	mov    %eax,%edi
  802f19:	48 b8 f8 22 80 00 00 	movabs $0x8022f8,%rax
  802f20:	00 00 00 
  802f23:	ff d0                	callq  *%rax
		return read_size;
  802f25:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f28:	eb 27                	jmp    802f51 <copy+0x1d9>
	}
	close(fd_src);
  802f2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f2d:	89 c7                	mov    %eax,%edi
  802f2f:	48 b8 f8 22 80 00 00 	movabs $0x8022f8,%rax
  802f36:	00 00 00 
  802f39:	ff d0                	callq  *%rax
	close(fd_dest);
  802f3b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f3e:	89 c7                	mov    %eax,%edi
  802f40:	48 b8 f8 22 80 00 00 	movabs $0x8022f8,%rax
  802f47:	00 00 00 
  802f4a:	ff d0                	callq  *%rax
	return 0;
  802f4c:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802f51:	c9                   	leaveq 
  802f52:	c3                   	retq   

0000000000802f53 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802f53:	55                   	push   %rbp
  802f54:	48 89 e5             	mov    %rsp,%rbp
  802f57:	48 83 ec 20          	sub    $0x20,%rsp
  802f5b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802f5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f63:	8b 40 0c             	mov    0xc(%rax),%eax
  802f66:	85 c0                	test   %eax,%eax
  802f68:	7e 67                	jle    802fd1 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802f6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f6e:	8b 40 04             	mov    0x4(%rax),%eax
  802f71:	48 63 d0             	movslq %eax,%rdx
  802f74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f78:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802f7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f80:	8b 00                	mov    (%rax),%eax
  802f82:	48 89 ce             	mov    %rcx,%rsi
  802f85:	89 c7                	mov    %eax,%edi
  802f87:	48 b8 64 26 80 00 00 	movabs $0x802664,%rax
  802f8e:	00 00 00 
  802f91:	ff d0                	callq  *%rax
  802f93:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802f96:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f9a:	7e 13                	jle    802faf <writebuf+0x5c>
			b->result += result;
  802f9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fa0:	8b 50 08             	mov    0x8(%rax),%edx
  802fa3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fa6:	01 c2                	add    %eax,%edx
  802fa8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fac:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802faf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fb3:	8b 40 04             	mov    0x4(%rax),%eax
  802fb6:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802fb9:	74 16                	je     802fd1 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802fbb:	b8 00 00 00 00       	mov    $0x0,%eax
  802fc0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fc4:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802fc8:	89 c2                	mov    %eax,%edx
  802fca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fce:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802fd1:	c9                   	leaveq 
  802fd2:	c3                   	retq   

0000000000802fd3 <putch>:

static void
putch(int ch, void *thunk)
{
  802fd3:	55                   	push   %rbp
  802fd4:	48 89 e5             	mov    %rsp,%rbp
  802fd7:	48 83 ec 20          	sub    $0x20,%rsp
  802fdb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fde:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802fe2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fe6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802fea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fee:	8b 40 04             	mov    0x4(%rax),%eax
  802ff1:	8d 48 01             	lea    0x1(%rax),%ecx
  802ff4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ff8:	89 4a 04             	mov    %ecx,0x4(%rdx)
  802ffb:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802ffe:	89 d1                	mov    %edx,%ecx
  803000:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803004:	48 98                	cltq   
  803006:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  80300a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80300e:	8b 40 04             	mov    0x4(%rax),%eax
  803011:	3d 00 01 00 00       	cmp    $0x100,%eax
  803016:	75 1e                	jne    803036 <putch+0x63>
		writebuf(b);
  803018:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80301c:	48 89 c7             	mov    %rax,%rdi
  80301f:	48 b8 53 2f 80 00 00 	movabs $0x802f53,%rax
  803026:	00 00 00 
  803029:	ff d0                	callq  *%rax
		b->idx = 0;
  80302b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80302f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  803036:	c9                   	leaveq 
  803037:	c3                   	retq   

0000000000803038 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  803038:	55                   	push   %rbp
  803039:	48 89 e5             	mov    %rsp,%rbp
  80303c:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  803043:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  803049:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  803050:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  803057:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  80305d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  803063:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80306a:	00 00 00 
	b.result = 0;
  80306d:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  803074:	00 00 00 
	b.error = 1;
  803077:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  80307e:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  803081:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  803088:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  80308f:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  803096:	48 89 c6             	mov    %rax,%rsi
  803099:	48 bf d3 2f 80 00 00 	movabs $0x802fd3,%rdi
  8030a0:	00 00 00 
  8030a3:	48 b8 0a 0b 80 00 00 	movabs $0x800b0a,%rax
  8030aa:	00 00 00 
  8030ad:	ff d0                	callq  *%rax
	if (b.idx > 0)
  8030af:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  8030b5:	85 c0                	test   %eax,%eax
  8030b7:	7e 16                	jle    8030cf <vfprintf+0x97>
		writebuf(&b);
  8030b9:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8030c0:	48 89 c7             	mov    %rax,%rdi
  8030c3:	48 b8 53 2f 80 00 00 	movabs $0x802f53,%rax
  8030ca:	00 00 00 
  8030cd:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  8030cf:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  8030d5:	85 c0                	test   %eax,%eax
  8030d7:	74 08                	je     8030e1 <vfprintf+0xa9>
  8030d9:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  8030df:	eb 06                	jmp    8030e7 <vfprintf+0xaf>
  8030e1:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  8030e7:	c9                   	leaveq 
  8030e8:	c3                   	retq   

00000000008030e9 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8030e9:	55                   	push   %rbp
  8030ea:	48 89 e5             	mov    %rsp,%rbp
  8030ed:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8030f4:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  8030fa:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803101:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803108:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80310f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803116:	84 c0                	test   %al,%al
  803118:	74 20                	je     80313a <fprintf+0x51>
  80311a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80311e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803122:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803126:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80312a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80312e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803132:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803136:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80313a:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803141:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  803148:	00 00 00 
  80314b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803152:	00 00 00 
  803155:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803159:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803160:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803167:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  80316e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803175:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  80317c:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803182:	48 89 ce             	mov    %rcx,%rsi
  803185:	89 c7                	mov    %eax,%edi
  803187:	48 b8 38 30 80 00 00 	movabs $0x803038,%rax
  80318e:	00 00 00 
  803191:	ff d0                	callq  *%rax
  803193:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  803199:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80319f:	c9                   	leaveq 
  8031a0:	c3                   	retq   

00000000008031a1 <printf>:

int
printf(const char *fmt, ...)
{
  8031a1:	55                   	push   %rbp
  8031a2:	48 89 e5             	mov    %rsp,%rbp
  8031a5:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8031ac:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8031b3:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8031ba:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8031c1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8031c8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8031cf:	84 c0                	test   %al,%al
  8031d1:	74 20                	je     8031f3 <printf+0x52>
  8031d3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8031d7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8031db:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8031df:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8031e3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8031e7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8031eb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8031ef:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8031f3:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8031fa:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  803201:	00 00 00 
  803204:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80320b:	00 00 00 
  80320e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803212:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803219:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803220:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  803227:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80322e:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803235:	48 89 c6             	mov    %rax,%rsi
  803238:	bf 01 00 00 00       	mov    $0x1,%edi
  80323d:	48 b8 38 30 80 00 00 	movabs $0x803038,%rax
  803244:	00 00 00 
  803247:	ff d0                	callq  *%rax
  803249:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  80324f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803255:	c9                   	leaveq 
  803256:	c3                   	retq   

0000000000803257 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803257:	55                   	push   %rbp
  803258:	48 89 e5             	mov    %rsp,%rbp
  80325b:	53                   	push   %rbx
  80325c:	48 83 ec 38          	sub    $0x38,%rsp
  803260:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803264:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803268:	48 89 c7             	mov    %rax,%rdi
  80326b:	48 b8 50 20 80 00 00 	movabs $0x802050,%rax
  803272:	00 00 00 
  803275:	ff d0                	callq  *%rax
  803277:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80327a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80327e:	0f 88 bf 01 00 00    	js     803443 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803284:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803288:	ba 07 04 00 00       	mov    $0x407,%edx
  80328d:	48 89 c6             	mov    %rax,%rsi
  803290:	bf 00 00 00 00       	mov    $0x0,%edi
  803295:	48 b8 95 1d 80 00 00 	movabs $0x801d95,%rax
  80329c:	00 00 00 
  80329f:	ff d0                	callq  *%rax
  8032a1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032a8:	0f 88 95 01 00 00    	js     803443 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8032ae:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8032b2:	48 89 c7             	mov    %rax,%rdi
  8032b5:	48 b8 50 20 80 00 00 	movabs $0x802050,%rax
  8032bc:	00 00 00 
  8032bf:	ff d0                	callq  *%rax
  8032c1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032c8:	0f 88 5d 01 00 00    	js     80342b <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032ce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032d2:	ba 07 04 00 00       	mov    $0x407,%edx
  8032d7:	48 89 c6             	mov    %rax,%rsi
  8032da:	bf 00 00 00 00       	mov    $0x0,%edi
  8032df:	48 b8 95 1d 80 00 00 	movabs $0x801d95,%rax
  8032e6:	00 00 00 
  8032e9:	ff d0                	callq  *%rax
  8032eb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032f2:	0f 88 33 01 00 00    	js     80342b <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8032f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032fc:	48 89 c7             	mov    %rax,%rdi
  8032ff:	48 b8 25 20 80 00 00 	movabs $0x802025,%rax
  803306:	00 00 00 
  803309:	ff d0                	callq  *%rax
  80330b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80330f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803313:	ba 07 04 00 00       	mov    $0x407,%edx
  803318:	48 89 c6             	mov    %rax,%rsi
  80331b:	bf 00 00 00 00       	mov    $0x0,%edi
  803320:	48 b8 95 1d 80 00 00 	movabs $0x801d95,%rax
  803327:	00 00 00 
  80332a:	ff d0                	callq  *%rax
  80332c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80332f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803333:	79 05                	jns    80333a <pipe+0xe3>
		goto err2;
  803335:	e9 d9 00 00 00       	jmpq   803413 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80333a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80333e:	48 89 c7             	mov    %rax,%rdi
  803341:	48 b8 25 20 80 00 00 	movabs $0x802025,%rax
  803348:	00 00 00 
  80334b:	ff d0                	callq  *%rax
  80334d:	48 89 c2             	mov    %rax,%rdx
  803350:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803354:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80335a:	48 89 d1             	mov    %rdx,%rcx
  80335d:	ba 00 00 00 00       	mov    $0x0,%edx
  803362:	48 89 c6             	mov    %rax,%rsi
  803365:	bf 00 00 00 00       	mov    $0x0,%edi
  80336a:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  803371:	00 00 00 
  803374:	ff d0                	callq  *%rax
  803376:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803379:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80337d:	79 1b                	jns    80339a <pipe+0x143>
		goto err3;
  80337f:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803380:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803384:	48 89 c6             	mov    %rax,%rsi
  803387:	bf 00 00 00 00       	mov    $0x0,%edi
  80338c:	48 b8 40 1e 80 00 00 	movabs $0x801e40,%rax
  803393:	00 00 00 
  803396:	ff d0                	callq  *%rax
  803398:	eb 79                	jmp    803413 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80339a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80339e:	48 ba a0 50 80 00 00 	movabs $0x8050a0,%rdx
  8033a5:	00 00 00 
  8033a8:	8b 12                	mov    (%rdx),%edx
  8033aa:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8033ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033b0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8033b7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033bb:	48 ba a0 50 80 00 00 	movabs $0x8050a0,%rdx
  8033c2:	00 00 00 
  8033c5:	8b 12                	mov    (%rdx),%edx
  8033c7:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8033c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033cd:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8033d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033d8:	48 89 c7             	mov    %rax,%rdi
  8033db:	48 b8 02 20 80 00 00 	movabs $0x802002,%rax
  8033e2:	00 00 00 
  8033e5:	ff d0                	callq  *%rax
  8033e7:	89 c2                	mov    %eax,%edx
  8033e9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8033ed:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8033ef:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8033f3:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8033f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033fb:	48 89 c7             	mov    %rax,%rdi
  8033fe:	48 b8 02 20 80 00 00 	movabs $0x802002,%rax
  803405:	00 00 00 
  803408:	ff d0                	callq  *%rax
  80340a:	89 03                	mov    %eax,(%rbx)
	return 0;
  80340c:	b8 00 00 00 00       	mov    $0x0,%eax
  803411:	eb 33                	jmp    803446 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803413:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803417:	48 89 c6             	mov    %rax,%rsi
  80341a:	bf 00 00 00 00       	mov    $0x0,%edi
  80341f:	48 b8 40 1e 80 00 00 	movabs $0x801e40,%rax
  803426:	00 00 00 
  803429:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80342b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80342f:	48 89 c6             	mov    %rax,%rsi
  803432:	bf 00 00 00 00       	mov    $0x0,%edi
  803437:	48 b8 40 1e 80 00 00 	movabs $0x801e40,%rax
  80343e:	00 00 00 
  803441:	ff d0                	callq  *%rax
err:
	return r;
  803443:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803446:	48 83 c4 38          	add    $0x38,%rsp
  80344a:	5b                   	pop    %rbx
  80344b:	5d                   	pop    %rbp
  80344c:	c3                   	retq   

000000000080344d <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80344d:	55                   	push   %rbp
  80344e:	48 89 e5             	mov    %rsp,%rbp
  803451:	53                   	push   %rbx
  803452:	48 83 ec 28          	sub    $0x28,%rsp
  803456:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80345a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80345e:	48 b8 08 64 80 00 00 	movabs $0x806408,%rax
  803465:	00 00 00 
  803468:	48 8b 00             	mov    (%rax),%rax
  80346b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803471:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803474:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803478:	48 89 c7             	mov    %rax,%rdi
  80347b:	48 b8 05 3a 80 00 00 	movabs $0x803a05,%rax
  803482:	00 00 00 
  803485:	ff d0                	callq  *%rax
  803487:	89 c3                	mov    %eax,%ebx
  803489:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80348d:	48 89 c7             	mov    %rax,%rdi
  803490:	48 b8 05 3a 80 00 00 	movabs $0x803a05,%rax
  803497:	00 00 00 
  80349a:	ff d0                	callq  *%rax
  80349c:	39 c3                	cmp    %eax,%ebx
  80349e:	0f 94 c0             	sete   %al
  8034a1:	0f b6 c0             	movzbl %al,%eax
  8034a4:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8034a7:	48 b8 08 64 80 00 00 	movabs $0x806408,%rax
  8034ae:	00 00 00 
  8034b1:	48 8b 00             	mov    (%rax),%rax
  8034b4:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8034ba:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8034bd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034c0:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8034c3:	75 05                	jne    8034ca <_pipeisclosed+0x7d>
			return ret;
  8034c5:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8034c8:	eb 4f                	jmp    803519 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8034ca:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034cd:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8034d0:	74 42                	je     803514 <_pipeisclosed+0xc7>
  8034d2:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8034d6:	75 3c                	jne    803514 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8034d8:	48 b8 08 64 80 00 00 	movabs $0x806408,%rax
  8034df:	00 00 00 
  8034e2:	48 8b 00             	mov    (%rax),%rax
  8034e5:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8034eb:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8034ee:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034f1:	89 c6                	mov    %eax,%esi
  8034f3:	48 bf 44 41 80 00 00 	movabs $0x804144,%rdi
  8034fa:	00 00 00 
  8034fd:	b8 00 00 00 00       	mov    $0x0,%eax
  803502:	49 b8 57 07 80 00 00 	movabs $0x800757,%r8
  803509:	00 00 00 
  80350c:	41 ff d0             	callq  *%r8
	}
  80350f:	e9 4a ff ff ff       	jmpq   80345e <_pipeisclosed+0x11>
  803514:	e9 45 ff ff ff       	jmpq   80345e <_pipeisclosed+0x11>
}
  803519:	48 83 c4 28          	add    $0x28,%rsp
  80351d:	5b                   	pop    %rbx
  80351e:	5d                   	pop    %rbp
  80351f:	c3                   	retq   

0000000000803520 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803520:	55                   	push   %rbp
  803521:	48 89 e5             	mov    %rsp,%rbp
  803524:	48 83 ec 30          	sub    $0x30,%rsp
  803528:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80352b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80352f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803532:	48 89 d6             	mov    %rdx,%rsi
  803535:	89 c7                	mov    %eax,%edi
  803537:	48 b8 e8 20 80 00 00 	movabs $0x8020e8,%rax
  80353e:	00 00 00 
  803541:	ff d0                	callq  *%rax
  803543:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803546:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80354a:	79 05                	jns    803551 <pipeisclosed+0x31>
		return r;
  80354c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80354f:	eb 31                	jmp    803582 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803551:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803555:	48 89 c7             	mov    %rax,%rdi
  803558:	48 b8 25 20 80 00 00 	movabs $0x802025,%rax
  80355f:	00 00 00 
  803562:	ff d0                	callq  *%rax
  803564:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803568:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80356c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803570:	48 89 d6             	mov    %rdx,%rsi
  803573:	48 89 c7             	mov    %rax,%rdi
  803576:	48 b8 4d 34 80 00 00 	movabs $0x80344d,%rax
  80357d:	00 00 00 
  803580:	ff d0                	callq  *%rax
}
  803582:	c9                   	leaveq 
  803583:	c3                   	retq   

0000000000803584 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803584:	55                   	push   %rbp
  803585:	48 89 e5             	mov    %rsp,%rbp
  803588:	48 83 ec 40          	sub    $0x40,%rsp
  80358c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803590:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803594:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803598:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80359c:	48 89 c7             	mov    %rax,%rdi
  80359f:	48 b8 25 20 80 00 00 	movabs $0x802025,%rax
  8035a6:	00 00 00 
  8035a9:	ff d0                	callq  *%rax
  8035ab:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8035af:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035b3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8035b7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8035be:	00 
  8035bf:	e9 92 00 00 00       	jmpq   803656 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8035c4:	eb 41                	jmp    803607 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8035c6:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8035cb:	74 09                	je     8035d6 <devpipe_read+0x52>
				return i;
  8035cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035d1:	e9 92 00 00 00       	jmpq   803668 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8035d6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035de:	48 89 d6             	mov    %rdx,%rsi
  8035e1:	48 89 c7             	mov    %rax,%rdi
  8035e4:	48 b8 4d 34 80 00 00 	movabs $0x80344d,%rax
  8035eb:	00 00 00 
  8035ee:	ff d0                	callq  *%rax
  8035f0:	85 c0                	test   %eax,%eax
  8035f2:	74 07                	je     8035fb <devpipe_read+0x77>
				return 0;
  8035f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8035f9:	eb 6d                	jmp    803668 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8035fb:	48 b8 57 1d 80 00 00 	movabs $0x801d57,%rax
  803602:	00 00 00 
  803605:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803607:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80360b:	8b 10                	mov    (%rax),%edx
  80360d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803611:	8b 40 04             	mov    0x4(%rax),%eax
  803614:	39 c2                	cmp    %eax,%edx
  803616:	74 ae                	je     8035c6 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803618:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80361c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803620:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803624:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803628:	8b 00                	mov    (%rax),%eax
  80362a:	99                   	cltd   
  80362b:	c1 ea 1b             	shr    $0x1b,%edx
  80362e:	01 d0                	add    %edx,%eax
  803630:	83 e0 1f             	and    $0x1f,%eax
  803633:	29 d0                	sub    %edx,%eax
  803635:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803639:	48 98                	cltq   
  80363b:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803640:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803642:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803646:	8b 00                	mov    (%rax),%eax
  803648:	8d 50 01             	lea    0x1(%rax),%edx
  80364b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80364f:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803651:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803656:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80365a:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80365e:	0f 82 60 ff ff ff    	jb     8035c4 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803664:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803668:	c9                   	leaveq 
  803669:	c3                   	retq   

000000000080366a <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80366a:	55                   	push   %rbp
  80366b:	48 89 e5             	mov    %rsp,%rbp
  80366e:	48 83 ec 40          	sub    $0x40,%rsp
  803672:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803676:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80367a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80367e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803682:	48 89 c7             	mov    %rax,%rdi
  803685:	48 b8 25 20 80 00 00 	movabs $0x802025,%rax
  80368c:	00 00 00 
  80368f:	ff d0                	callq  *%rax
  803691:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803695:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803699:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80369d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8036a4:	00 
  8036a5:	e9 8e 00 00 00       	jmpq   803738 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8036aa:	eb 31                	jmp    8036dd <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8036ac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036b4:	48 89 d6             	mov    %rdx,%rsi
  8036b7:	48 89 c7             	mov    %rax,%rdi
  8036ba:	48 b8 4d 34 80 00 00 	movabs $0x80344d,%rax
  8036c1:	00 00 00 
  8036c4:	ff d0                	callq  *%rax
  8036c6:	85 c0                	test   %eax,%eax
  8036c8:	74 07                	je     8036d1 <devpipe_write+0x67>
				return 0;
  8036ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8036cf:	eb 79                	jmp    80374a <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8036d1:	48 b8 57 1d 80 00 00 	movabs $0x801d57,%rax
  8036d8:	00 00 00 
  8036db:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8036dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036e1:	8b 40 04             	mov    0x4(%rax),%eax
  8036e4:	48 63 d0             	movslq %eax,%rdx
  8036e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036eb:	8b 00                	mov    (%rax),%eax
  8036ed:	48 98                	cltq   
  8036ef:	48 83 c0 20          	add    $0x20,%rax
  8036f3:	48 39 c2             	cmp    %rax,%rdx
  8036f6:	73 b4                	jae    8036ac <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8036f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036fc:	8b 40 04             	mov    0x4(%rax),%eax
  8036ff:	99                   	cltd   
  803700:	c1 ea 1b             	shr    $0x1b,%edx
  803703:	01 d0                	add    %edx,%eax
  803705:	83 e0 1f             	and    $0x1f,%eax
  803708:	29 d0                	sub    %edx,%eax
  80370a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80370e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803712:	48 01 ca             	add    %rcx,%rdx
  803715:	0f b6 0a             	movzbl (%rdx),%ecx
  803718:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80371c:	48 98                	cltq   
  80371e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803722:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803726:	8b 40 04             	mov    0x4(%rax),%eax
  803729:	8d 50 01             	lea    0x1(%rax),%edx
  80372c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803730:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803733:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803738:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80373c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803740:	0f 82 64 ff ff ff    	jb     8036aa <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803746:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80374a:	c9                   	leaveq 
  80374b:	c3                   	retq   

000000000080374c <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80374c:	55                   	push   %rbp
  80374d:	48 89 e5             	mov    %rsp,%rbp
  803750:	48 83 ec 20          	sub    $0x20,%rsp
  803754:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803758:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80375c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803760:	48 89 c7             	mov    %rax,%rdi
  803763:	48 b8 25 20 80 00 00 	movabs $0x802025,%rax
  80376a:	00 00 00 
  80376d:	ff d0                	callq  *%rax
  80376f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803773:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803777:	48 be 57 41 80 00 00 	movabs $0x804157,%rsi
  80377e:	00 00 00 
  803781:	48 89 c7             	mov    %rax,%rdi
  803784:	48 b8 66 14 80 00 00 	movabs $0x801466,%rax
  80378b:	00 00 00 
  80378e:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803790:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803794:	8b 50 04             	mov    0x4(%rax),%edx
  803797:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80379b:	8b 00                	mov    (%rax),%eax
  80379d:	29 c2                	sub    %eax,%edx
  80379f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037a3:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8037a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037ad:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8037b4:	00 00 00 
	stat->st_dev = &devpipe;
  8037b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037bb:	48 b9 a0 50 80 00 00 	movabs $0x8050a0,%rcx
  8037c2:	00 00 00 
  8037c5:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8037cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037d1:	c9                   	leaveq 
  8037d2:	c3                   	retq   

00000000008037d3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8037d3:	55                   	push   %rbp
  8037d4:	48 89 e5             	mov    %rsp,%rbp
  8037d7:	48 83 ec 10          	sub    $0x10,%rsp
  8037db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8037df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037e3:	48 89 c6             	mov    %rax,%rsi
  8037e6:	bf 00 00 00 00       	mov    $0x0,%edi
  8037eb:	48 b8 40 1e 80 00 00 	movabs $0x801e40,%rax
  8037f2:	00 00 00 
  8037f5:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8037f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037fb:	48 89 c7             	mov    %rax,%rdi
  8037fe:	48 b8 25 20 80 00 00 	movabs $0x802025,%rax
  803805:	00 00 00 
  803808:	ff d0                	callq  *%rax
  80380a:	48 89 c6             	mov    %rax,%rsi
  80380d:	bf 00 00 00 00       	mov    $0x0,%edi
  803812:	48 b8 40 1e 80 00 00 	movabs $0x801e40,%rax
  803819:	00 00 00 
  80381c:	ff d0                	callq  *%rax
}
  80381e:	c9                   	leaveq 
  80381f:	c3                   	retq   

0000000000803820 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803820:	55                   	push   %rbp
  803821:	48 89 e5             	mov    %rsp,%rbp
  803824:	48 83 ec 30          	sub    $0x30,%rsp
  803828:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80382c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803830:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  803834:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803839:	74 18                	je     803853 <ipc_recv+0x33>
  80383b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80383f:	48 89 c7             	mov    %rax,%rdi
  803842:	48 b8 be 1f 80 00 00 	movabs $0x801fbe,%rax
  803849:	00 00 00 
  80384c:	ff d0                	callq  *%rax
  80384e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803851:	eb 19                	jmp    80386c <ipc_recv+0x4c>
  803853:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  80385a:	00 00 00 
  80385d:	48 b8 be 1f 80 00 00 	movabs $0x801fbe,%rax
  803864:	00 00 00 
  803867:	ff d0                	callq  *%rax
  803869:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  80386c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803871:	74 26                	je     803899 <ipc_recv+0x79>
  803873:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803877:	75 15                	jne    80388e <ipc_recv+0x6e>
  803879:	48 b8 08 64 80 00 00 	movabs $0x806408,%rax
  803880:	00 00 00 
  803883:	48 8b 00             	mov    (%rax),%rax
  803886:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  80388c:	eb 05                	jmp    803893 <ipc_recv+0x73>
  80388e:	b8 00 00 00 00       	mov    $0x0,%eax
  803893:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803897:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  803899:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80389e:	74 26                	je     8038c6 <ipc_recv+0xa6>
  8038a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038a4:	75 15                	jne    8038bb <ipc_recv+0x9b>
  8038a6:	48 b8 08 64 80 00 00 	movabs $0x806408,%rax
  8038ad:	00 00 00 
  8038b0:	48 8b 00             	mov    (%rax),%rax
  8038b3:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  8038b9:	eb 05                	jmp    8038c0 <ipc_recv+0xa0>
  8038bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8038c0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8038c4:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  8038c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038ca:	75 15                	jne    8038e1 <ipc_recv+0xc1>
  8038cc:	48 b8 08 64 80 00 00 	movabs $0x806408,%rax
  8038d3:	00 00 00 
  8038d6:	48 8b 00             	mov    (%rax),%rax
  8038d9:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  8038df:	eb 03                	jmp    8038e4 <ipc_recv+0xc4>
  8038e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8038e4:	c9                   	leaveq 
  8038e5:	c3                   	retq   

00000000008038e6 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8038e6:	55                   	push   %rbp
  8038e7:	48 89 e5             	mov    %rsp,%rbp
  8038ea:	48 83 ec 30          	sub    $0x30,%rsp
  8038ee:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038f1:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8038f4:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8038f8:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  8038fb:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  803902:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803907:	75 10                	jne    803919 <ipc_send+0x33>
  803909:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803910:	00 00 00 
  803913:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  803917:	eb 62                	jmp    80397b <ipc_send+0x95>
  803919:	eb 60                	jmp    80397b <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  80391b:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80391f:	74 30                	je     803951 <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  803921:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803924:	89 c1                	mov    %eax,%ecx
  803926:	48 ba 5e 41 80 00 00 	movabs $0x80415e,%rdx
  80392d:	00 00 00 
  803930:	be 33 00 00 00       	mov    $0x33,%esi
  803935:	48 bf 7a 41 80 00 00 	movabs $0x80417a,%rdi
  80393c:	00 00 00 
  80393f:	b8 00 00 00 00       	mov    $0x0,%eax
  803944:	49 b8 1e 05 80 00 00 	movabs $0x80051e,%r8
  80394b:	00 00 00 
  80394e:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  803951:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803954:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803957:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80395b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80395e:	89 c7                	mov    %eax,%edi
  803960:	48 b8 69 1f 80 00 00 	movabs $0x801f69,%rax
  803967:	00 00 00 
  80396a:	ff d0                	callq  *%rax
  80396c:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  80396f:	48 b8 57 1d 80 00 00 	movabs $0x801d57,%rax
  803976:	00 00 00 
  803979:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  80397b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80397f:	75 9a                	jne    80391b <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  803981:	c9                   	leaveq 
  803982:	c3                   	retq   

0000000000803983 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803983:	55                   	push   %rbp
  803984:	48 89 e5             	mov    %rsp,%rbp
  803987:	48 83 ec 14          	sub    $0x14,%rsp
  80398b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80398e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803995:	eb 5e                	jmp    8039f5 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803997:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80399e:	00 00 00 
  8039a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039a4:	48 63 d0             	movslq %eax,%rdx
  8039a7:	48 89 d0             	mov    %rdx,%rax
  8039aa:	48 c1 e0 03          	shl    $0x3,%rax
  8039ae:	48 01 d0             	add    %rdx,%rax
  8039b1:	48 c1 e0 05          	shl    $0x5,%rax
  8039b5:	48 01 c8             	add    %rcx,%rax
  8039b8:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8039be:	8b 00                	mov    (%rax),%eax
  8039c0:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8039c3:	75 2c                	jne    8039f1 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8039c5:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8039cc:	00 00 00 
  8039cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039d2:	48 63 d0             	movslq %eax,%rdx
  8039d5:	48 89 d0             	mov    %rdx,%rax
  8039d8:	48 c1 e0 03          	shl    $0x3,%rax
  8039dc:	48 01 d0             	add    %rdx,%rax
  8039df:	48 c1 e0 05          	shl    $0x5,%rax
  8039e3:	48 01 c8             	add    %rcx,%rax
  8039e6:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8039ec:	8b 40 08             	mov    0x8(%rax),%eax
  8039ef:	eb 12                	jmp    803a03 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8039f1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8039f5:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8039fc:	7e 99                	jle    803997 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8039fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a03:	c9                   	leaveq 
  803a04:	c3                   	retq   

0000000000803a05 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803a05:	55                   	push   %rbp
  803a06:	48 89 e5             	mov    %rsp,%rbp
  803a09:	48 83 ec 18          	sub    $0x18,%rsp
  803a0d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803a11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a15:	48 c1 e8 15          	shr    $0x15,%rax
  803a19:	48 89 c2             	mov    %rax,%rdx
  803a1c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803a23:	01 00 00 
  803a26:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803a2a:	83 e0 01             	and    $0x1,%eax
  803a2d:	48 85 c0             	test   %rax,%rax
  803a30:	75 07                	jne    803a39 <pageref+0x34>
		return 0;
  803a32:	b8 00 00 00 00       	mov    $0x0,%eax
  803a37:	eb 53                	jmp    803a8c <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803a39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a3d:	48 c1 e8 0c          	shr    $0xc,%rax
  803a41:	48 89 c2             	mov    %rax,%rdx
  803a44:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803a4b:	01 00 00 
  803a4e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803a52:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803a56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a5a:	83 e0 01             	and    $0x1,%eax
  803a5d:	48 85 c0             	test   %rax,%rax
  803a60:	75 07                	jne    803a69 <pageref+0x64>
		return 0;
  803a62:	b8 00 00 00 00       	mov    $0x0,%eax
  803a67:	eb 23                	jmp    803a8c <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803a69:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a6d:	48 c1 e8 0c          	shr    $0xc,%rax
  803a71:	48 89 c2             	mov    %rax,%rdx
  803a74:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803a7b:	00 00 00 
  803a7e:	48 c1 e2 04          	shl    $0x4,%rdx
  803a82:	48 01 d0             	add    %rdx,%rax
  803a85:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803a89:	0f b7 c0             	movzwl %ax,%eax
}
  803a8c:	c9                   	leaveq 
  803a8d:	c3                   	retq   
