
obj/user/primespipe:     file format elf64-x86-64


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
  80003c:	e8 d3 03 00 00       	callq  800414 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 30          	sub    $0x30,%rsp
  80004b:	89 7d dc             	mov    %edi,-0x24(%rbp)
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  80004e:	48 8d 4d ec          	lea    -0x14(%rbp),%rcx
  800052:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800055:	ba 04 00 00 00       	mov    $0x4,%edx
  80005a:	48 89 ce             	mov    %rcx,%rsi
  80005d:	89 c7                	mov    %eax,%edi
  80005f:	48 b8 89 29 80 00 00 	movabs $0x802989,%rax
  800066:	00 00 00 
  800069:	ff d0                	callq  *%rax
  80006b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80006e:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800072:	74 42                	je     8000b6 <primeproc+0x73>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  800074:	b8 00 00 00 00       	mov    $0x0,%eax
  800079:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80007d:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  800081:	89 c2                	mov    %eax,%edx
  800083:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800086:	41 89 d0             	mov    %edx,%r8d
  800089:	89 c1                	mov    %eax,%ecx
  80008b:	48 ba 00 3f 80 00 00 	movabs $0x803f00,%rdx
  800092:	00 00 00 
  800095:	be 15 00 00 00       	mov    $0x15,%esi
  80009a:	48 bf 2f 3f 80 00 00 	movabs $0x803f2f,%rdi
  8000a1:	00 00 00 
  8000a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a9:	49 b9 c7 04 80 00 00 	movabs $0x8004c7,%r9
  8000b0:	00 00 00 
  8000b3:	41 ff d1             	callq  *%r9

	cprintf("%d\n", p);
  8000b6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000b9:	89 c6                	mov    %eax,%esi
  8000bb:	48 bf 41 3f 80 00 00 	movabs $0x803f41,%rdi
  8000c2:	00 00 00 
  8000c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ca:	48 ba 00 07 80 00 00 	movabs $0x800700,%rdx
  8000d1:	00 00 00 
  8000d4:	ff d2                	callq  *%rdx

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  8000d6:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8000da:	48 89 c7             	mov    %rax,%rdi
  8000dd:	48 b8 ed 32 80 00 00 	movabs $0x8032ed,%rax
  8000e4:	00 00 00 
  8000e7:	ff d0                	callq  *%rax
  8000e9:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8000ec:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000ef:	85 c0                	test   %eax,%eax
  8000f1:	79 30                	jns    800123 <primeproc+0xe0>
		panic("pipe: %e", i);
  8000f3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000f6:	89 c1                	mov    %eax,%ecx
  8000f8:	48 ba 45 3f 80 00 00 	movabs $0x803f45,%rdx
  8000ff:	00 00 00 
  800102:	be 1b 00 00 00       	mov    $0x1b,%esi
  800107:	48 bf 2f 3f 80 00 00 	movabs $0x803f2f,%rdi
  80010e:	00 00 00 
  800111:	b8 00 00 00 00       	mov    $0x0,%eax
  800116:	49 b8 c7 04 80 00 00 	movabs $0x8004c7,%r8
  80011d:	00 00 00 
  800120:	41 ff d0             	callq  *%r8
	if ((id = fork()) < 0)
  800123:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  80012a:	00 00 00 
  80012d:	ff d0                	callq  *%rax
  80012f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800132:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800136:	79 30                	jns    800168 <primeproc+0x125>
		panic("fork: %e", id);
  800138:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80013b:	89 c1                	mov    %eax,%ecx
  80013d:	48 ba 4e 3f 80 00 00 	movabs $0x803f4e,%rdx
  800144:	00 00 00 
  800147:	be 1d 00 00 00       	mov    $0x1d,%esi
  80014c:	48 bf 2f 3f 80 00 00 	movabs $0x803f2f,%rdi
  800153:	00 00 00 
  800156:	b8 00 00 00 00       	mov    $0x0,%eax
  80015b:	49 b8 c7 04 80 00 00 	movabs $0x8004c7,%r8
  800162:	00 00 00 
  800165:	41 ff d0             	callq  *%r8
	if (id == 0) {
  800168:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80016c:	75 2d                	jne    80019b <primeproc+0x158>
		close(fd);
  80016e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800171:	89 c7                	mov    %eax,%edi
  800173:	48 b8 92 26 80 00 00 	movabs $0x802692,%rax
  80017a:	00 00 00 
  80017d:	ff d0                	callq  *%rax
		close(pfd[1]);
  80017f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800182:	89 c7                	mov    %eax,%edi
  800184:	48 b8 92 26 80 00 00 	movabs $0x802692,%rax
  80018b:	00 00 00 
  80018e:	ff d0                	callq  *%rax
		fd = pfd[0];
  800190:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800193:	89 45 dc             	mov    %eax,-0x24(%rbp)
		goto top;
  800196:	e9 b3 fe ff ff       	jmpq   80004e <primeproc+0xb>
	}

	close(pfd[0]);
  80019b:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80019e:	89 c7                	mov    %eax,%edi
  8001a0:	48 b8 92 26 80 00 00 	movabs $0x802692,%rax
  8001a7:	00 00 00 
  8001aa:	ff d0                	callq  *%rax
	wfd = pfd[1];
  8001ac:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8001af:	89 45 f4             	mov    %eax,-0xc(%rbp)

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  8001b2:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  8001b6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8001b9:	ba 04 00 00 00       	mov    $0x4,%edx
  8001be:	48 89 ce             	mov    %rcx,%rsi
  8001c1:	89 c7                	mov    %eax,%edi
  8001c3:	48 b8 89 29 80 00 00 	movabs $0x802989,%rax
  8001ca:	00 00 00 
  8001cd:	ff d0                	callq  *%rax
  8001cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001d2:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8001d6:	74 4e                	je     800226 <primeproc+0x1e3>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  8001d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8001dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001e1:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  8001e5:	89 c2                	mov    %eax,%edx
  8001e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001ea:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8001ed:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8001f0:	89 14 24             	mov    %edx,(%rsp)
  8001f3:	41 89 f1             	mov    %esi,%r9d
  8001f6:	41 89 c8             	mov    %ecx,%r8d
  8001f9:	89 c1                	mov    %eax,%ecx
  8001fb:	48 ba 57 3f 80 00 00 	movabs $0x803f57,%rdx
  800202:	00 00 00 
  800205:	be 2b 00 00 00       	mov    $0x2b,%esi
  80020a:	48 bf 2f 3f 80 00 00 	movabs $0x803f2f,%rdi
  800211:	00 00 00 
  800214:	b8 00 00 00 00       	mov    $0x0,%eax
  800219:	49 ba c7 04 80 00 00 	movabs $0x8004c7,%r10
  800220:	00 00 00 
  800223:	41 ff d2             	callq  *%r10
		if (i%p)
  800226:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800229:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  80022c:	99                   	cltd   
  80022d:	f7 f9                	idiv   %ecx
  80022f:	89 d0                	mov    %edx,%eax
  800231:	85 c0                	test   %eax,%eax
  800233:	74 6e                	je     8002a3 <primeproc+0x260>
			if ((r=write(wfd, &i, 4)) != 4)
  800235:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  800239:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80023c:	ba 04 00 00 00       	mov    $0x4,%edx
  800241:	48 89 ce             	mov    %rcx,%rsi
  800244:	89 c7                	mov    %eax,%edi
  800246:	48 b8 fe 29 80 00 00 	movabs $0x8029fe,%rax
  80024d:	00 00 00 
  800250:	ff d0                	callq  *%rax
  800252:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800255:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800259:	74 48                	je     8002a3 <primeproc+0x260>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  80025b:	b8 00 00 00 00       	mov    $0x0,%eax
  800260:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800264:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  800268:	89 c1                	mov    %eax,%ecx
  80026a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80026d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800270:	41 89 c9             	mov    %ecx,%r9d
  800273:	41 89 d0             	mov    %edx,%r8d
  800276:	89 c1                	mov    %eax,%ecx
  800278:	48 ba 73 3f 80 00 00 	movabs $0x803f73,%rdx
  80027f:	00 00 00 
  800282:	be 2e 00 00 00       	mov    $0x2e,%esi
  800287:	48 bf 2f 3f 80 00 00 	movabs $0x803f2f,%rdi
  80028e:	00 00 00 
  800291:	b8 00 00 00 00       	mov    $0x0,%eax
  800296:	49 ba c7 04 80 00 00 	movabs $0x8004c7,%r10
  80029d:	00 00 00 
  8002a0:	41 ff d2             	callq  *%r10
	}
  8002a3:	e9 0a ff ff ff       	jmpq   8001b2 <primeproc+0x16f>

00000000008002a8 <umain>:
}

void
umain(int argc, char **argv)
{
  8002a8:	55                   	push   %rbp
  8002a9:	48 89 e5             	mov    %rsp,%rbp
  8002ac:	53                   	push   %rbx
  8002ad:	48 83 ec 38          	sub    $0x38,%rsp
  8002b1:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8002b4:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	int i, id, p[2], r;

	binaryname = "primespipe";
  8002b8:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002bf:	00 00 00 
  8002c2:	48 bb 8d 3f 80 00 00 	movabs $0x803f8d,%rbx
  8002c9:	00 00 00 
  8002cc:	48 89 18             	mov    %rbx,(%rax)

	if ((i=pipe(p)) < 0)
  8002cf:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8002d3:	48 89 c7             	mov    %rax,%rdi
  8002d6:	48 b8 ed 32 80 00 00 	movabs $0x8032ed,%rax
  8002dd:	00 00 00 
  8002e0:	ff d0                	callq  *%rax
  8002e2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8002e5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8002e8:	85 c0                	test   %eax,%eax
  8002ea:	79 30                	jns    80031c <umain+0x74>
		panic("pipe: %e", i);
  8002ec:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8002ef:	89 c1                	mov    %eax,%ecx
  8002f1:	48 ba 45 3f 80 00 00 	movabs $0x803f45,%rdx
  8002f8:	00 00 00 
  8002fb:	be 3a 00 00 00       	mov    $0x3a,%esi
  800300:	48 bf 2f 3f 80 00 00 	movabs $0x803f2f,%rdi
  800307:	00 00 00 
  80030a:	b8 00 00 00 00       	mov    $0x0,%eax
  80030f:	49 b8 c7 04 80 00 00 	movabs $0x8004c7,%r8
  800316:	00 00 00 
  800319:	41 ff d0             	callq  *%r8

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  80031c:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  800323:	00 00 00 
  800326:	ff d0                	callq  *%rax
  800328:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80032b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80032f:	79 30                	jns    800361 <umain+0xb9>
		panic("fork: %e", id);
  800331:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800334:	89 c1                	mov    %eax,%ecx
  800336:	48 ba 4e 3f 80 00 00 	movabs $0x803f4e,%rdx
  80033d:	00 00 00 
  800340:	be 3e 00 00 00       	mov    $0x3e,%esi
  800345:	48 bf 2f 3f 80 00 00 	movabs $0x803f2f,%rdi
  80034c:	00 00 00 
  80034f:	b8 00 00 00 00       	mov    $0x0,%eax
  800354:	49 b8 c7 04 80 00 00 	movabs $0x8004c7,%r8
  80035b:	00 00 00 
  80035e:	41 ff d0             	callq  *%r8

	if (id == 0) {
  800361:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800365:	75 22                	jne    800389 <umain+0xe1>
		close(p[1]);
  800367:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80036a:	89 c7                	mov    %eax,%edi
  80036c:	48 b8 92 26 80 00 00 	movabs $0x802692,%rax
  800373:	00 00 00 
  800376:	ff d0                	callq  *%rax
		primeproc(p[0]);
  800378:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80037b:	89 c7                	mov    %eax,%edi
  80037d:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800384:	00 00 00 
  800387:	ff d0                	callq  *%rax
	}

	close(p[0]);
  800389:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80038c:	89 c7                	mov    %eax,%edi
  80038e:	48 b8 92 26 80 00 00 	movabs $0x802692,%rax
  800395:	00 00 00 
  800398:	ff d0                	callq  *%rax

	// feed all the integers through
	for (i=2;; i++)
  80039a:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%rbp)
		if ((r=write(p[1], &i, 4)) != 4)
  8003a1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8003a4:	48 8d 4d e4          	lea    -0x1c(%rbp),%rcx
  8003a8:	ba 04 00 00 00       	mov    $0x4,%edx
  8003ad:	48 89 ce             	mov    %rcx,%rsi
  8003b0:	89 c7                	mov    %eax,%edi
  8003b2:	48 b8 fe 29 80 00 00 	movabs $0x8029fe,%rax
  8003b9:	00 00 00 
  8003bc:	ff d0                	callq  *%rax
  8003be:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8003c1:	83 7d e8 04          	cmpl   $0x4,-0x18(%rbp)
  8003c5:	74 42                	je     800409 <umain+0x161>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  8003c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003cc:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8003d0:	0f 4e 45 e8          	cmovle -0x18(%rbp),%eax
  8003d4:	89 c2                	mov    %eax,%edx
  8003d6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8003d9:	41 89 d0             	mov    %edx,%r8d
  8003dc:	89 c1                	mov    %eax,%ecx
  8003de:	48 ba 98 3f 80 00 00 	movabs $0x803f98,%rdx
  8003e5:	00 00 00 
  8003e8:	be 4a 00 00 00       	mov    $0x4a,%esi
  8003ed:	48 bf 2f 3f 80 00 00 	movabs $0x803f2f,%rdi
  8003f4:	00 00 00 
  8003f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003fc:	49 b9 c7 04 80 00 00 	movabs $0x8004c7,%r9
  800403:	00 00 00 
  800406:	41 ff d1             	callq  *%r9
	}

	close(p[0]);

	// feed all the integers through
	for (i=2;; i++)
  800409:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80040c:	83 c0 01             	add    $0x1,%eax
  80040f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if ((r=write(p[1], &i, 4)) != 4)
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
}
  800412:	eb 8d                	jmp    8003a1 <umain+0xf9>

0000000000800414 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800414:	55                   	push   %rbp
  800415:	48 89 e5             	mov    %rsp,%rbp
  800418:	48 83 ec 10          	sub    $0x10,%rsp
  80041c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80041f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  800423:	48 b8 68 1b 80 00 00 	movabs $0x801b68,%rax
  80042a:	00 00 00 
  80042d:	ff d0                	callq  *%rax
  80042f:	48 98                	cltq   
  800431:	25 ff 03 00 00       	and    $0x3ff,%eax
  800436:	48 89 c2             	mov    %rax,%rdx
  800439:	48 89 d0             	mov    %rdx,%rax
  80043c:	48 c1 e0 03          	shl    $0x3,%rax
  800440:	48 01 d0             	add    %rdx,%rax
  800443:	48 c1 e0 05          	shl    $0x5,%rax
  800447:	48 89 c2             	mov    %rax,%rdx
  80044a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800451:	00 00 00 
  800454:	48 01 c2             	add    %rax,%rdx
  800457:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80045e:	00 00 00 
  800461:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800464:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800468:	7e 14                	jle    80047e <libmain+0x6a>
		binaryname = argv[0];
  80046a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80046e:	48 8b 10             	mov    (%rax),%rdx
  800471:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800478:	00 00 00 
  80047b:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80047e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800482:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800485:	48 89 d6             	mov    %rdx,%rsi
  800488:	89 c7                	mov    %eax,%edi
  80048a:	48 b8 a8 02 80 00 00 	movabs $0x8002a8,%rax
  800491:	00 00 00 
  800494:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800496:	48 b8 a4 04 80 00 00 	movabs $0x8004a4,%rax
  80049d:	00 00 00 
  8004a0:	ff d0                	callq  *%rax
}
  8004a2:	c9                   	leaveq 
  8004a3:	c3                   	retq   

00000000008004a4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8004a4:	55                   	push   %rbp
  8004a5:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8004a8:	48 b8 dd 26 80 00 00 	movabs $0x8026dd,%rax
  8004af:	00 00 00 
  8004b2:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8004b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8004b9:	48 b8 24 1b 80 00 00 	movabs $0x801b24,%rax
  8004c0:	00 00 00 
  8004c3:	ff d0                	callq  *%rax
}
  8004c5:	5d                   	pop    %rbp
  8004c6:	c3                   	retq   

00000000008004c7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8004c7:	55                   	push   %rbp
  8004c8:	48 89 e5             	mov    %rsp,%rbp
  8004cb:	53                   	push   %rbx
  8004cc:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8004d3:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8004da:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8004e0:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8004e7:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8004ee:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8004f5:	84 c0                	test   %al,%al
  8004f7:	74 23                	je     80051c <_panic+0x55>
  8004f9:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800500:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800504:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800508:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80050c:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800510:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800514:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800518:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80051c:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800523:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80052a:	00 00 00 
  80052d:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800534:	00 00 00 
  800537:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80053b:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800542:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800549:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800550:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800557:	00 00 00 
  80055a:	48 8b 18             	mov    (%rax),%rbx
  80055d:	48 b8 68 1b 80 00 00 	movabs $0x801b68,%rax
  800564:	00 00 00 
  800567:	ff d0                	callq  *%rax
  800569:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80056f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800576:	41 89 c8             	mov    %ecx,%r8d
  800579:	48 89 d1             	mov    %rdx,%rcx
  80057c:	48 89 da             	mov    %rbx,%rdx
  80057f:	89 c6                	mov    %eax,%esi
  800581:	48 bf c0 3f 80 00 00 	movabs $0x803fc0,%rdi
  800588:	00 00 00 
  80058b:	b8 00 00 00 00       	mov    $0x0,%eax
  800590:	49 b9 00 07 80 00 00 	movabs $0x800700,%r9
  800597:	00 00 00 
  80059a:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80059d:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8005a4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005ab:	48 89 d6             	mov    %rdx,%rsi
  8005ae:	48 89 c7             	mov    %rax,%rdi
  8005b1:	48 b8 54 06 80 00 00 	movabs $0x800654,%rax
  8005b8:	00 00 00 
  8005bb:	ff d0                	callq  *%rax
	cprintf("\n");
  8005bd:	48 bf e3 3f 80 00 00 	movabs $0x803fe3,%rdi
  8005c4:	00 00 00 
  8005c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8005cc:	48 ba 00 07 80 00 00 	movabs $0x800700,%rdx
  8005d3:	00 00 00 
  8005d6:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8005d8:	cc                   	int3   
  8005d9:	eb fd                	jmp    8005d8 <_panic+0x111>

00000000008005db <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8005db:	55                   	push   %rbp
  8005dc:	48 89 e5             	mov    %rsp,%rbp
  8005df:	48 83 ec 10          	sub    $0x10,%rsp
  8005e3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8005e6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8005ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005ee:	8b 00                	mov    (%rax),%eax
  8005f0:	8d 48 01             	lea    0x1(%rax),%ecx
  8005f3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005f7:	89 0a                	mov    %ecx,(%rdx)
  8005f9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8005fc:	89 d1                	mov    %edx,%ecx
  8005fe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800602:	48 98                	cltq   
  800604:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800608:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80060c:	8b 00                	mov    (%rax),%eax
  80060e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800613:	75 2c                	jne    800641 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800615:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800619:	8b 00                	mov    (%rax),%eax
  80061b:	48 98                	cltq   
  80061d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800621:	48 83 c2 08          	add    $0x8,%rdx
  800625:	48 89 c6             	mov    %rax,%rsi
  800628:	48 89 d7             	mov    %rdx,%rdi
  80062b:	48 b8 9c 1a 80 00 00 	movabs $0x801a9c,%rax
  800632:	00 00 00 
  800635:	ff d0                	callq  *%rax
        b->idx = 0;
  800637:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80063b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800641:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800645:	8b 40 04             	mov    0x4(%rax),%eax
  800648:	8d 50 01             	lea    0x1(%rax),%edx
  80064b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80064f:	89 50 04             	mov    %edx,0x4(%rax)
}
  800652:	c9                   	leaveq 
  800653:	c3                   	retq   

0000000000800654 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800654:	55                   	push   %rbp
  800655:	48 89 e5             	mov    %rsp,%rbp
  800658:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80065f:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800666:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80066d:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800674:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80067b:	48 8b 0a             	mov    (%rdx),%rcx
  80067e:	48 89 08             	mov    %rcx,(%rax)
  800681:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800685:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800689:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80068d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800691:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800698:	00 00 00 
    b.cnt = 0;
  80069b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8006a2:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8006a5:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8006ac:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8006b3:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8006ba:	48 89 c6             	mov    %rax,%rsi
  8006bd:	48 bf db 05 80 00 00 	movabs $0x8005db,%rdi
  8006c4:	00 00 00 
  8006c7:	48 b8 b3 0a 80 00 00 	movabs $0x800ab3,%rax
  8006ce:	00 00 00 
  8006d1:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8006d3:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8006d9:	48 98                	cltq   
  8006db:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8006e2:	48 83 c2 08          	add    $0x8,%rdx
  8006e6:	48 89 c6             	mov    %rax,%rsi
  8006e9:	48 89 d7             	mov    %rdx,%rdi
  8006ec:	48 b8 9c 1a 80 00 00 	movabs $0x801a9c,%rax
  8006f3:	00 00 00 
  8006f6:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8006f8:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8006fe:	c9                   	leaveq 
  8006ff:	c3                   	retq   

0000000000800700 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800700:	55                   	push   %rbp
  800701:	48 89 e5             	mov    %rsp,%rbp
  800704:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80070b:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800712:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800719:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800720:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800727:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80072e:	84 c0                	test   %al,%al
  800730:	74 20                	je     800752 <cprintf+0x52>
  800732:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800736:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80073a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80073e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800742:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800746:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80074a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80074e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800752:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800759:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800760:	00 00 00 
  800763:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80076a:	00 00 00 
  80076d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800771:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800778:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80077f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800786:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80078d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800794:	48 8b 0a             	mov    (%rdx),%rcx
  800797:	48 89 08             	mov    %rcx,(%rax)
  80079a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80079e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007a2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007a6:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8007aa:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8007b1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8007b8:	48 89 d6             	mov    %rdx,%rsi
  8007bb:	48 89 c7             	mov    %rax,%rdi
  8007be:	48 b8 54 06 80 00 00 	movabs $0x800654,%rax
  8007c5:	00 00 00 
  8007c8:	ff d0                	callq  *%rax
  8007ca:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8007d0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8007d6:	c9                   	leaveq 
  8007d7:	c3                   	retq   

00000000008007d8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007d8:	55                   	push   %rbp
  8007d9:	48 89 e5             	mov    %rsp,%rbp
  8007dc:	53                   	push   %rbx
  8007dd:	48 83 ec 38          	sub    $0x38,%rsp
  8007e1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8007e9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8007ed:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8007f0:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8007f4:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007f8:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8007fb:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8007ff:	77 3b                	ja     80083c <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800801:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800804:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800808:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80080b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80080f:	ba 00 00 00 00       	mov    $0x0,%edx
  800814:	48 f7 f3             	div    %rbx
  800817:	48 89 c2             	mov    %rax,%rdx
  80081a:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80081d:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800820:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800824:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800828:	41 89 f9             	mov    %edi,%r9d
  80082b:	48 89 c7             	mov    %rax,%rdi
  80082e:	48 b8 d8 07 80 00 00 	movabs $0x8007d8,%rax
  800835:	00 00 00 
  800838:	ff d0                	callq  *%rax
  80083a:	eb 1e                	jmp    80085a <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80083c:	eb 12                	jmp    800850 <printnum+0x78>
			putch(padc, putdat);
  80083e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800842:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800845:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800849:	48 89 ce             	mov    %rcx,%rsi
  80084c:	89 d7                	mov    %edx,%edi
  80084e:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800850:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800854:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800858:	7f e4                	jg     80083e <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80085a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80085d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800861:	ba 00 00 00 00       	mov    $0x0,%edx
  800866:	48 f7 f1             	div    %rcx
  800869:	48 89 d0             	mov    %rdx,%rax
  80086c:	48 ba f0 41 80 00 00 	movabs $0x8041f0,%rdx
  800873:	00 00 00 
  800876:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80087a:	0f be d0             	movsbl %al,%edx
  80087d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800881:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800885:	48 89 ce             	mov    %rcx,%rsi
  800888:	89 d7                	mov    %edx,%edi
  80088a:	ff d0                	callq  *%rax
}
  80088c:	48 83 c4 38          	add    $0x38,%rsp
  800890:	5b                   	pop    %rbx
  800891:	5d                   	pop    %rbp
  800892:	c3                   	retq   

0000000000800893 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800893:	55                   	push   %rbp
  800894:	48 89 e5             	mov    %rsp,%rbp
  800897:	48 83 ec 1c          	sub    $0x1c,%rsp
  80089b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80089f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8008a2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008a6:	7e 52                	jle    8008fa <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8008a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ac:	8b 00                	mov    (%rax),%eax
  8008ae:	83 f8 30             	cmp    $0x30,%eax
  8008b1:	73 24                	jae    8008d7 <getuint+0x44>
  8008b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008bf:	8b 00                	mov    (%rax),%eax
  8008c1:	89 c0                	mov    %eax,%eax
  8008c3:	48 01 d0             	add    %rdx,%rax
  8008c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ca:	8b 12                	mov    (%rdx),%edx
  8008cc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d3:	89 0a                	mov    %ecx,(%rdx)
  8008d5:	eb 17                	jmp    8008ee <getuint+0x5b>
  8008d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008db:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008df:	48 89 d0             	mov    %rdx,%rax
  8008e2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ea:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008ee:	48 8b 00             	mov    (%rax),%rax
  8008f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008f5:	e9 a3 00 00 00       	jmpq   80099d <getuint+0x10a>
	else if (lflag)
  8008fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8008fe:	74 4f                	je     80094f <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800900:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800904:	8b 00                	mov    (%rax),%eax
  800906:	83 f8 30             	cmp    $0x30,%eax
  800909:	73 24                	jae    80092f <getuint+0x9c>
  80090b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800913:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800917:	8b 00                	mov    (%rax),%eax
  800919:	89 c0                	mov    %eax,%eax
  80091b:	48 01 d0             	add    %rdx,%rax
  80091e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800922:	8b 12                	mov    (%rdx),%edx
  800924:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800927:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80092b:	89 0a                	mov    %ecx,(%rdx)
  80092d:	eb 17                	jmp    800946 <getuint+0xb3>
  80092f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800933:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800937:	48 89 d0             	mov    %rdx,%rax
  80093a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80093e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800942:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800946:	48 8b 00             	mov    (%rax),%rax
  800949:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80094d:	eb 4e                	jmp    80099d <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80094f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800953:	8b 00                	mov    (%rax),%eax
  800955:	83 f8 30             	cmp    $0x30,%eax
  800958:	73 24                	jae    80097e <getuint+0xeb>
  80095a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800962:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800966:	8b 00                	mov    (%rax),%eax
  800968:	89 c0                	mov    %eax,%eax
  80096a:	48 01 d0             	add    %rdx,%rax
  80096d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800971:	8b 12                	mov    (%rdx),%edx
  800973:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800976:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80097a:	89 0a                	mov    %ecx,(%rdx)
  80097c:	eb 17                	jmp    800995 <getuint+0x102>
  80097e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800982:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800986:	48 89 d0             	mov    %rdx,%rax
  800989:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80098d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800991:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800995:	8b 00                	mov    (%rax),%eax
  800997:	89 c0                	mov    %eax,%eax
  800999:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80099d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009a1:	c9                   	leaveq 
  8009a2:	c3                   	retq   

00000000008009a3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009a3:	55                   	push   %rbp
  8009a4:	48 89 e5             	mov    %rsp,%rbp
  8009a7:	48 83 ec 1c          	sub    $0x1c,%rsp
  8009ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009af:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8009b2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009b6:	7e 52                	jle    800a0a <getint+0x67>
		x=va_arg(*ap, long long);
  8009b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009bc:	8b 00                	mov    (%rax),%eax
  8009be:	83 f8 30             	cmp    $0x30,%eax
  8009c1:	73 24                	jae    8009e7 <getint+0x44>
  8009c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009cf:	8b 00                	mov    (%rax),%eax
  8009d1:	89 c0                	mov    %eax,%eax
  8009d3:	48 01 d0             	add    %rdx,%rax
  8009d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009da:	8b 12                	mov    (%rdx),%edx
  8009dc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e3:	89 0a                	mov    %ecx,(%rdx)
  8009e5:	eb 17                	jmp    8009fe <getint+0x5b>
  8009e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009eb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009ef:	48 89 d0             	mov    %rdx,%rax
  8009f2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009fa:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009fe:	48 8b 00             	mov    (%rax),%rax
  800a01:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a05:	e9 a3 00 00 00       	jmpq   800aad <getint+0x10a>
	else if (lflag)
  800a0a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a0e:	74 4f                	je     800a5f <getint+0xbc>
		x=va_arg(*ap, long);
  800a10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a14:	8b 00                	mov    (%rax),%eax
  800a16:	83 f8 30             	cmp    $0x30,%eax
  800a19:	73 24                	jae    800a3f <getint+0x9c>
  800a1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a1f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a27:	8b 00                	mov    (%rax),%eax
  800a29:	89 c0                	mov    %eax,%eax
  800a2b:	48 01 d0             	add    %rdx,%rax
  800a2e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a32:	8b 12                	mov    (%rdx),%edx
  800a34:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a37:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a3b:	89 0a                	mov    %ecx,(%rdx)
  800a3d:	eb 17                	jmp    800a56 <getint+0xb3>
  800a3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a43:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a47:	48 89 d0             	mov    %rdx,%rax
  800a4a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a4e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a52:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a56:	48 8b 00             	mov    (%rax),%rax
  800a59:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a5d:	eb 4e                	jmp    800aad <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800a5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a63:	8b 00                	mov    (%rax),%eax
  800a65:	83 f8 30             	cmp    $0x30,%eax
  800a68:	73 24                	jae    800a8e <getint+0xeb>
  800a6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a6e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a76:	8b 00                	mov    (%rax),%eax
  800a78:	89 c0                	mov    %eax,%eax
  800a7a:	48 01 d0             	add    %rdx,%rax
  800a7d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a81:	8b 12                	mov    (%rdx),%edx
  800a83:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a86:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a8a:	89 0a                	mov    %ecx,(%rdx)
  800a8c:	eb 17                	jmp    800aa5 <getint+0x102>
  800a8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a92:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a96:	48 89 d0             	mov    %rdx,%rax
  800a99:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a9d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aa1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800aa5:	8b 00                	mov    (%rax),%eax
  800aa7:	48 98                	cltq   
  800aa9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800aad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ab1:	c9                   	leaveq 
  800ab2:	c3                   	retq   

0000000000800ab3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ab3:	55                   	push   %rbp
  800ab4:	48 89 e5             	mov    %rsp,%rbp
  800ab7:	41 54                	push   %r12
  800ab9:	53                   	push   %rbx
  800aba:	48 83 ec 60          	sub    $0x60,%rsp
  800abe:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800ac2:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800ac6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800aca:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800ace:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ad2:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800ad6:	48 8b 0a             	mov    (%rdx),%rcx
  800ad9:	48 89 08             	mov    %rcx,(%rax)
  800adc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ae0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ae4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ae8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800aec:	eb 17                	jmp    800b05 <vprintfmt+0x52>
			if (ch == '\0')
  800aee:	85 db                	test   %ebx,%ebx
  800af0:	0f 84 cc 04 00 00    	je     800fc2 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800af6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800afa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800afe:	48 89 d6             	mov    %rdx,%rsi
  800b01:	89 df                	mov    %ebx,%edi
  800b03:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b05:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b09:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b0d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b11:	0f b6 00             	movzbl (%rax),%eax
  800b14:	0f b6 d8             	movzbl %al,%ebx
  800b17:	83 fb 25             	cmp    $0x25,%ebx
  800b1a:	75 d2                	jne    800aee <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b1c:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b20:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b27:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b2e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b35:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b3c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b40:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b44:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b48:	0f b6 00             	movzbl (%rax),%eax
  800b4b:	0f b6 d8             	movzbl %al,%ebx
  800b4e:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800b51:	83 f8 55             	cmp    $0x55,%eax
  800b54:	0f 87 34 04 00 00    	ja     800f8e <vprintfmt+0x4db>
  800b5a:	89 c0                	mov    %eax,%eax
  800b5c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800b63:	00 
  800b64:	48 b8 18 42 80 00 00 	movabs $0x804218,%rax
  800b6b:	00 00 00 
  800b6e:	48 01 d0             	add    %rdx,%rax
  800b71:	48 8b 00             	mov    (%rax),%rax
  800b74:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800b76:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800b7a:	eb c0                	jmp    800b3c <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b7c:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800b80:	eb ba                	jmp    800b3c <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b82:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800b89:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800b8c:	89 d0                	mov    %edx,%eax
  800b8e:	c1 e0 02             	shl    $0x2,%eax
  800b91:	01 d0                	add    %edx,%eax
  800b93:	01 c0                	add    %eax,%eax
  800b95:	01 d8                	add    %ebx,%eax
  800b97:	83 e8 30             	sub    $0x30,%eax
  800b9a:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800b9d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ba1:	0f b6 00             	movzbl (%rax),%eax
  800ba4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ba7:	83 fb 2f             	cmp    $0x2f,%ebx
  800baa:	7e 0c                	jle    800bb8 <vprintfmt+0x105>
  800bac:	83 fb 39             	cmp    $0x39,%ebx
  800baf:	7f 07                	jg     800bb8 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bb1:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bb6:	eb d1                	jmp    800b89 <vprintfmt+0xd6>
			goto process_precision;
  800bb8:	eb 58                	jmp    800c12 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800bba:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bbd:	83 f8 30             	cmp    $0x30,%eax
  800bc0:	73 17                	jae    800bd9 <vprintfmt+0x126>
  800bc2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bc6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc9:	89 c0                	mov    %eax,%eax
  800bcb:	48 01 d0             	add    %rdx,%rax
  800bce:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bd1:	83 c2 08             	add    $0x8,%edx
  800bd4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bd7:	eb 0f                	jmp    800be8 <vprintfmt+0x135>
  800bd9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bdd:	48 89 d0             	mov    %rdx,%rax
  800be0:	48 83 c2 08          	add    $0x8,%rdx
  800be4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800be8:	8b 00                	mov    (%rax),%eax
  800bea:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800bed:	eb 23                	jmp    800c12 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800bef:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bf3:	79 0c                	jns    800c01 <vprintfmt+0x14e>
				width = 0;
  800bf5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800bfc:	e9 3b ff ff ff       	jmpq   800b3c <vprintfmt+0x89>
  800c01:	e9 36 ff ff ff       	jmpq   800b3c <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c06:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c0d:	e9 2a ff ff ff       	jmpq   800b3c <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800c12:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c16:	79 12                	jns    800c2a <vprintfmt+0x177>
				width = precision, precision = -1;
  800c18:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c1b:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c1e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c25:	e9 12 ff ff ff       	jmpq   800b3c <vprintfmt+0x89>
  800c2a:	e9 0d ff ff ff       	jmpq   800b3c <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c2f:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c33:	e9 04 ff ff ff       	jmpq   800b3c <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c38:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c3b:	83 f8 30             	cmp    $0x30,%eax
  800c3e:	73 17                	jae    800c57 <vprintfmt+0x1a4>
  800c40:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c44:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c47:	89 c0                	mov    %eax,%eax
  800c49:	48 01 d0             	add    %rdx,%rax
  800c4c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c4f:	83 c2 08             	add    $0x8,%edx
  800c52:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c55:	eb 0f                	jmp    800c66 <vprintfmt+0x1b3>
  800c57:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c5b:	48 89 d0             	mov    %rdx,%rax
  800c5e:	48 83 c2 08          	add    $0x8,%rdx
  800c62:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c66:	8b 10                	mov    (%rax),%edx
  800c68:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c6c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c70:	48 89 ce             	mov    %rcx,%rsi
  800c73:	89 d7                	mov    %edx,%edi
  800c75:	ff d0                	callq  *%rax
			break;
  800c77:	e9 40 03 00 00       	jmpq   800fbc <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800c7c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c7f:	83 f8 30             	cmp    $0x30,%eax
  800c82:	73 17                	jae    800c9b <vprintfmt+0x1e8>
  800c84:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c88:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c8b:	89 c0                	mov    %eax,%eax
  800c8d:	48 01 d0             	add    %rdx,%rax
  800c90:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c93:	83 c2 08             	add    $0x8,%edx
  800c96:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c99:	eb 0f                	jmp    800caa <vprintfmt+0x1f7>
  800c9b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c9f:	48 89 d0             	mov    %rdx,%rax
  800ca2:	48 83 c2 08          	add    $0x8,%rdx
  800ca6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800caa:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800cac:	85 db                	test   %ebx,%ebx
  800cae:	79 02                	jns    800cb2 <vprintfmt+0x1ff>
				err = -err;
  800cb0:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800cb2:	83 fb 15             	cmp    $0x15,%ebx
  800cb5:	7f 16                	jg     800ccd <vprintfmt+0x21a>
  800cb7:	48 b8 40 41 80 00 00 	movabs $0x804140,%rax
  800cbe:	00 00 00 
  800cc1:	48 63 d3             	movslq %ebx,%rdx
  800cc4:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800cc8:	4d 85 e4             	test   %r12,%r12
  800ccb:	75 2e                	jne    800cfb <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800ccd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cd1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd5:	89 d9                	mov    %ebx,%ecx
  800cd7:	48 ba 01 42 80 00 00 	movabs $0x804201,%rdx
  800cde:	00 00 00 
  800ce1:	48 89 c7             	mov    %rax,%rdi
  800ce4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce9:	49 b8 cb 0f 80 00 00 	movabs $0x800fcb,%r8
  800cf0:	00 00 00 
  800cf3:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800cf6:	e9 c1 02 00 00       	jmpq   800fbc <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800cfb:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cff:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d03:	4c 89 e1             	mov    %r12,%rcx
  800d06:	48 ba 0a 42 80 00 00 	movabs $0x80420a,%rdx
  800d0d:	00 00 00 
  800d10:	48 89 c7             	mov    %rax,%rdi
  800d13:	b8 00 00 00 00       	mov    $0x0,%eax
  800d18:	49 b8 cb 0f 80 00 00 	movabs $0x800fcb,%r8
  800d1f:	00 00 00 
  800d22:	41 ff d0             	callq  *%r8
			break;
  800d25:	e9 92 02 00 00       	jmpq   800fbc <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d2a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d2d:	83 f8 30             	cmp    $0x30,%eax
  800d30:	73 17                	jae    800d49 <vprintfmt+0x296>
  800d32:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d36:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d39:	89 c0                	mov    %eax,%eax
  800d3b:	48 01 d0             	add    %rdx,%rax
  800d3e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d41:	83 c2 08             	add    $0x8,%edx
  800d44:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d47:	eb 0f                	jmp    800d58 <vprintfmt+0x2a5>
  800d49:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d4d:	48 89 d0             	mov    %rdx,%rax
  800d50:	48 83 c2 08          	add    $0x8,%rdx
  800d54:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d58:	4c 8b 20             	mov    (%rax),%r12
  800d5b:	4d 85 e4             	test   %r12,%r12
  800d5e:	75 0a                	jne    800d6a <vprintfmt+0x2b7>
				p = "(null)";
  800d60:	49 bc 0d 42 80 00 00 	movabs $0x80420d,%r12
  800d67:	00 00 00 
			if (width > 0 && padc != '-')
  800d6a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d6e:	7e 3f                	jle    800daf <vprintfmt+0x2fc>
  800d70:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800d74:	74 39                	je     800daf <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d76:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d79:	48 98                	cltq   
  800d7b:	48 89 c6             	mov    %rax,%rsi
  800d7e:	4c 89 e7             	mov    %r12,%rdi
  800d81:	48 b8 77 12 80 00 00 	movabs $0x801277,%rax
  800d88:	00 00 00 
  800d8b:	ff d0                	callq  *%rax
  800d8d:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800d90:	eb 17                	jmp    800da9 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800d92:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800d96:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d9a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d9e:	48 89 ce             	mov    %rcx,%rsi
  800da1:	89 d7                	mov    %edx,%edi
  800da3:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800da5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800da9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dad:	7f e3                	jg     800d92 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800daf:	eb 37                	jmp    800de8 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800db1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800db5:	74 1e                	je     800dd5 <vprintfmt+0x322>
  800db7:	83 fb 1f             	cmp    $0x1f,%ebx
  800dba:	7e 05                	jle    800dc1 <vprintfmt+0x30e>
  800dbc:	83 fb 7e             	cmp    $0x7e,%ebx
  800dbf:	7e 14                	jle    800dd5 <vprintfmt+0x322>
					putch('?', putdat);
  800dc1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dc5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dc9:	48 89 d6             	mov    %rdx,%rsi
  800dcc:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800dd1:	ff d0                	callq  *%rax
  800dd3:	eb 0f                	jmp    800de4 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800dd5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dd9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ddd:	48 89 d6             	mov    %rdx,%rsi
  800de0:	89 df                	mov    %ebx,%edi
  800de2:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800de4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800de8:	4c 89 e0             	mov    %r12,%rax
  800deb:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800def:	0f b6 00             	movzbl (%rax),%eax
  800df2:	0f be d8             	movsbl %al,%ebx
  800df5:	85 db                	test   %ebx,%ebx
  800df7:	74 10                	je     800e09 <vprintfmt+0x356>
  800df9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800dfd:	78 b2                	js     800db1 <vprintfmt+0x2fe>
  800dff:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e03:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e07:	79 a8                	jns    800db1 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e09:	eb 16                	jmp    800e21 <vprintfmt+0x36e>
				putch(' ', putdat);
  800e0b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e0f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e13:	48 89 d6             	mov    %rdx,%rsi
  800e16:	bf 20 00 00 00       	mov    $0x20,%edi
  800e1b:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e1d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e21:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e25:	7f e4                	jg     800e0b <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800e27:	e9 90 01 00 00       	jmpq   800fbc <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e2c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e30:	be 03 00 00 00       	mov    $0x3,%esi
  800e35:	48 89 c7             	mov    %rax,%rdi
  800e38:	48 b8 a3 09 80 00 00 	movabs $0x8009a3,%rax
  800e3f:	00 00 00 
  800e42:	ff d0                	callq  *%rax
  800e44:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e4c:	48 85 c0             	test   %rax,%rax
  800e4f:	79 1d                	jns    800e6e <vprintfmt+0x3bb>
				putch('-', putdat);
  800e51:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e55:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e59:	48 89 d6             	mov    %rdx,%rsi
  800e5c:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e61:	ff d0                	callq  *%rax
				num = -(long long) num;
  800e63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e67:	48 f7 d8             	neg    %rax
  800e6a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800e6e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e75:	e9 d5 00 00 00       	jmpq   800f4f <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800e7a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e7e:	be 03 00 00 00       	mov    $0x3,%esi
  800e83:	48 89 c7             	mov    %rax,%rdi
  800e86:	48 b8 93 08 80 00 00 	movabs $0x800893,%rax
  800e8d:	00 00 00 
  800e90:	ff d0                	callq  *%rax
  800e92:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800e96:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e9d:	e9 ad 00 00 00       	jmpq   800f4f <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  800ea2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ea6:	be 03 00 00 00       	mov    $0x3,%esi
  800eab:	48 89 c7             	mov    %rax,%rdi
  800eae:	48 b8 93 08 80 00 00 	movabs $0x800893,%rax
  800eb5:	00 00 00 
  800eb8:	ff d0                	callq  *%rax
  800eba:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  800ebe:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  800ec5:	e9 85 00 00 00       	jmpq   800f4f <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  800eca:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ece:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ed2:	48 89 d6             	mov    %rdx,%rsi
  800ed5:	bf 30 00 00 00       	mov    $0x30,%edi
  800eda:	ff d0                	callq  *%rax
			putch('x', putdat);
  800edc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ee0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ee4:	48 89 d6             	mov    %rdx,%rsi
  800ee7:	bf 78 00 00 00       	mov    $0x78,%edi
  800eec:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800eee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ef1:	83 f8 30             	cmp    $0x30,%eax
  800ef4:	73 17                	jae    800f0d <vprintfmt+0x45a>
  800ef6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800efa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800efd:	89 c0                	mov    %eax,%eax
  800eff:	48 01 d0             	add    %rdx,%rax
  800f02:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f05:	83 c2 08             	add    $0x8,%edx
  800f08:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f0b:	eb 0f                	jmp    800f1c <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800f0d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f11:	48 89 d0             	mov    %rdx,%rax
  800f14:	48 83 c2 08          	add    $0x8,%rdx
  800f18:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f1c:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f1f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f23:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f2a:	eb 23                	jmp    800f4f <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f2c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f30:	be 03 00 00 00       	mov    $0x3,%esi
  800f35:	48 89 c7             	mov    %rax,%rdi
  800f38:	48 b8 93 08 80 00 00 	movabs $0x800893,%rax
  800f3f:	00 00 00 
  800f42:	ff d0                	callq  *%rax
  800f44:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f48:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f4f:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800f54:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800f57:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800f5a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f5e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f62:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f66:	45 89 c1             	mov    %r8d,%r9d
  800f69:	41 89 f8             	mov    %edi,%r8d
  800f6c:	48 89 c7             	mov    %rax,%rdi
  800f6f:	48 b8 d8 07 80 00 00 	movabs $0x8007d8,%rax
  800f76:	00 00 00 
  800f79:	ff d0                	callq  *%rax
			break;
  800f7b:	eb 3f                	jmp    800fbc <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f7d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f81:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f85:	48 89 d6             	mov    %rdx,%rsi
  800f88:	89 df                	mov    %ebx,%edi
  800f8a:	ff d0                	callq  *%rax
			break;
  800f8c:	eb 2e                	jmp    800fbc <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f8e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f92:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f96:	48 89 d6             	mov    %rdx,%rsi
  800f99:	bf 25 00 00 00       	mov    $0x25,%edi
  800f9e:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fa0:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fa5:	eb 05                	jmp    800fac <vprintfmt+0x4f9>
  800fa7:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fac:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fb0:	48 83 e8 01          	sub    $0x1,%rax
  800fb4:	0f b6 00             	movzbl (%rax),%eax
  800fb7:	3c 25                	cmp    $0x25,%al
  800fb9:	75 ec                	jne    800fa7 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800fbb:	90                   	nop
		}
	}
  800fbc:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800fbd:	e9 43 fb ff ff       	jmpq   800b05 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800fc2:	48 83 c4 60          	add    $0x60,%rsp
  800fc6:	5b                   	pop    %rbx
  800fc7:	41 5c                	pop    %r12
  800fc9:	5d                   	pop    %rbp
  800fca:	c3                   	retq   

0000000000800fcb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fcb:	55                   	push   %rbp
  800fcc:	48 89 e5             	mov    %rsp,%rbp
  800fcf:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800fd6:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800fdd:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800fe4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800feb:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ff2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ff9:	84 c0                	test   %al,%al
  800ffb:	74 20                	je     80101d <printfmt+0x52>
  800ffd:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801001:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801005:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801009:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80100d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801011:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801015:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801019:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80101d:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801024:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80102b:	00 00 00 
  80102e:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801035:	00 00 00 
  801038:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80103c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801043:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80104a:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801051:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801058:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80105f:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801066:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80106d:	48 89 c7             	mov    %rax,%rdi
  801070:	48 b8 b3 0a 80 00 00 	movabs $0x800ab3,%rax
  801077:	00 00 00 
  80107a:	ff d0                	callq  *%rax
	va_end(ap);
}
  80107c:	c9                   	leaveq 
  80107d:	c3                   	retq   

000000000080107e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80107e:	55                   	push   %rbp
  80107f:	48 89 e5             	mov    %rsp,%rbp
  801082:	48 83 ec 10          	sub    $0x10,%rsp
  801086:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801089:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  80108d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801091:	8b 40 10             	mov    0x10(%rax),%eax
  801094:	8d 50 01             	lea    0x1(%rax),%edx
  801097:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80109b:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80109e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010a2:	48 8b 10             	mov    (%rax),%rdx
  8010a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010a9:	48 8b 40 08          	mov    0x8(%rax),%rax
  8010ad:	48 39 c2             	cmp    %rax,%rdx
  8010b0:	73 17                	jae    8010c9 <sprintputch+0x4b>
		*b->buf++ = ch;
  8010b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010b6:	48 8b 00             	mov    (%rax),%rax
  8010b9:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8010bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8010c1:	48 89 0a             	mov    %rcx,(%rdx)
  8010c4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8010c7:	88 10                	mov    %dl,(%rax)
}
  8010c9:	c9                   	leaveq 
  8010ca:	c3                   	retq   

00000000008010cb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010cb:	55                   	push   %rbp
  8010cc:	48 89 e5             	mov    %rsp,%rbp
  8010cf:	48 83 ec 50          	sub    $0x50,%rsp
  8010d3:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8010d7:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8010da:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8010de:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8010e2:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8010e6:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8010ea:	48 8b 0a             	mov    (%rdx),%rcx
  8010ed:	48 89 08             	mov    %rcx,(%rax)
  8010f0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8010f4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8010f8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8010fc:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801100:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801104:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801108:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80110b:	48 98                	cltq   
  80110d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801111:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801115:	48 01 d0             	add    %rdx,%rax
  801118:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80111c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801123:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801128:	74 06                	je     801130 <vsnprintf+0x65>
  80112a:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80112e:	7f 07                	jg     801137 <vsnprintf+0x6c>
		return -E_INVAL;
  801130:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801135:	eb 2f                	jmp    801166 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801137:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80113b:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80113f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801143:	48 89 c6             	mov    %rax,%rsi
  801146:	48 bf 7e 10 80 00 00 	movabs $0x80107e,%rdi
  80114d:	00 00 00 
  801150:	48 b8 b3 0a 80 00 00 	movabs $0x800ab3,%rax
  801157:	00 00 00 
  80115a:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80115c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801160:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801163:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801166:	c9                   	leaveq 
  801167:	c3                   	retq   

0000000000801168 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801168:	55                   	push   %rbp
  801169:	48 89 e5             	mov    %rsp,%rbp
  80116c:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801173:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80117a:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801180:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801187:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80118e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801195:	84 c0                	test   %al,%al
  801197:	74 20                	je     8011b9 <snprintf+0x51>
  801199:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80119d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011a1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8011a5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8011a9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8011ad:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8011b1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8011b5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8011b9:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8011c0:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8011c7:	00 00 00 
  8011ca:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8011d1:	00 00 00 
  8011d4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8011d8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8011df:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8011e6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8011ed:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8011f4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8011fb:	48 8b 0a             	mov    (%rdx),%rcx
  8011fe:	48 89 08             	mov    %rcx,(%rax)
  801201:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801205:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801209:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80120d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801211:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801218:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80121f:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801225:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80122c:	48 89 c7             	mov    %rax,%rdi
  80122f:	48 b8 cb 10 80 00 00 	movabs $0x8010cb,%rax
  801236:	00 00 00 
  801239:	ff d0                	callq  *%rax
  80123b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801241:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801247:	c9                   	leaveq 
  801248:	c3                   	retq   

0000000000801249 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801249:	55                   	push   %rbp
  80124a:	48 89 e5             	mov    %rsp,%rbp
  80124d:	48 83 ec 18          	sub    $0x18,%rsp
  801251:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801255:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80125c:	eb 09                	jmp    801267 <strlen+0x1e>
		n++;
  80125e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801262:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801267:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80126b:	0f b6 00             	movzbl (%rax),%eax
  80126e:	84 c0                	test   %al,%al
  801270:	75 ec                	jne    80125e <strlen+0x15>
		n++;
	return n;
  801272:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801275:	c9                   	leaveq 
  801276:	c3                   	retq   

0000000000801277 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801277:	55                   	push   %rbp
  801278:	48 89 e5             	mov    %rsp,%rbp
  80127b:	48 83 ec 20          	sub    $0x20,%rsp
  80127f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801283:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801287:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80128e:	eb 0e                	jmp    80129e <strnlen+0x27>
		n++;
  801290:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801294:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801299:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80129e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8012a3:	74 0b                	je     8012b0 <strnlen+0x39>
  8012a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a9:	0f b6 00             	movzbl (%rax),%eax
  8012ac:	84 c0                	test   %al,%al
  8012ae:	75 e0                	jne    801290 <strnlen+0x19>
		n++;
	return n;
  8012b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012b3:	c9                   	leaveq 
  8012b4:	c3                   	retq   

00000000008012b5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012b5:	55                   	push   %rbp
  8012b6:	48 89 e5             	mov    %rsp,%rbp
  8012b9:	48 83 ec 20          	sub    $0x20,%rsp
  8012bd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012c1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8012c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8012cd:	90                   	nop
  8012ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012d6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012da:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012de:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8012e2:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8012e6:	0f b6 12             	movzbl (%rdx),%edx
  8012e9:	88 10                	mov    %dl,(%rax)
  8012eb:	0f b6 00             	movzbl (%rax),%eax
  8012ee:	84 c0                	test   %al,%al
  8012f0:	75 dc                	jne    8012ce <strcpy+0x19>
		/* do nothing */;
	return ret;
  8012f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012f6:	c9                   	leaveq 
  8012f7:	c3                   	retq   

00000000008012f8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8012f8:	55                   	push   %rbp
  8012f9:	48 89 e5             	mov    %rsp,%rbp
  8012fc:	48 83 ec 20          	sub    $0x20,%rsp
  801300:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801304:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801308:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80130c:	48 89 c7             	mov    %rax,%rdi
  80130f:	48 b8 49 12 80 00 00 	movabs $0x801249,%rax
  801316:	00 00 00 
  801319:	ff d0                	callq  *%rax
  80131b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80131e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801321:	48 63 d0             	movslq %eax,%rdx
  801324:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801328:	48 01 c2             	add    %rax,%rdx
  80132b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80132f:	48 89 c6             	mov    %rax,%rsi
  801332:	48 89 d7             	mov    %rdx,%rdi
  801335:	48 b8 b5 12 80 00 00 	movabs $0x8012b5,%rax
  80133c:	00 00 00 
  80133f:	ff d0                	callq  *%rax
	return dst;
  801341:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801345:	c9                   	leaveq 
  801346:	c3                   	retq   

0000000000801347 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801347:	55                   	push   %rbp
  801348:	48 89 e5             	mov    %rsp,%rbp
  80134b:	48 83 ec 28          	sub    $0x28,%rsp
  80134f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801353:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801357:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80135b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80135f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801363:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80136a:	00 
  80136b:	eb 2a                	jmp    801397 <strncpy+0x50>
		*dst++ = *src;
  80136d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801371:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801375:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801379:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80137d:	0f b6 12             	movzbl (%rdx),%edx
  801380:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801382:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801386:	0f b6 00             	movzbl (%rax),%eax
  801389:	84 c0                	test   %al,%al
  80138b:	74 05                	je     801392 <strncpy+0x4b>
			src++;
  80138d:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801392:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801397:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80139f:	72 cc                	jb     80136d <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8013a5:	c9                   	leaveq 
  8013a6:	c3                   	retq   

00000000008013a7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8013a7:	55                   	push   %rbp
  8013a8:	48 89 e5             	mov    %rsp,%rbp
  8013ab:	48 83 ec 28          	sub    $0x28,%rsp
  8013af:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013b7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8013bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013bf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8013c3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8013c8:	74 3d                	je     801407 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8013ca:	eb 1d                	jmp    8013e9 <strlcpy+0x42>
			*dst++ = *src++;
  8013cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013d4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013d8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013dc:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8013e0:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8013e4:	0f b6 12             	movzbl (%rdx),%edx
  8013e7:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013e9:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8013ee:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8013f3:	74 0b                	je     801400 <strlcpy+0x59>
  8013f5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013f9:	0f b6 00             	movzbl (%rax),%eax
  8013fc:	84 c0                	test   %al,%al
  8013fe:	75 cc                	jne    8013cc <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801400:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801404:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801407:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80140b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80140f:	48 29 c2             	sub    %rax,%rdx
  801412:	48 89 d0             	mov    %rdx,%rax
}
  801415:	c9                   	leaveq 
  801416:	c3                   	retq   

0000000000801417 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801417:	55                   	push   %rbp
  801418:	48 89 e5             	mov    %rsp,%rbp
  80141b:	48 83 ec 10          	sub    $0x10,%rsp
  80141f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801423:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801427:	eb 0a                	jmp    801433 <strcmp+0x1c>
		p++, q++;
  801429:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80142e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801433:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801437:	0f b6 00             	movzbl (%rax),%eax
  80143a:	84 c0                	test   %al,%al
  80143c:	74 12                	je     801450 <strcmp+0x39>
  80143e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801442:	0f b6 10             	movzbl (%rax),%edx
  801445:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801449:	0f b6 00             	movzbl (%rax),%eax
  80144c:	38 c2                	cmp    %al,%dl
  80144e:	74 d9                	je     801429 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801450:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801454:	0f b6 00             	movzbl (%rax),%eax
  801457:	0f b6 d0             	movzbl %al,%edx
  80145a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80145e:	0f b6 00             	movzbl (%rax),%eax
  801461:	0f b6 c0             	movzbl %al,%eax
  801464:	29 c2                	sub    %eax,%edx
  801466:	89 d0                	mov    %edx,%eax
}
  801468:	c9                   	leaveq 
  801469:	c3                   	retq   

000000000080146a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80146a:	55                   	push   %rbp
  80146b:	48 89 e5             	mov    %rsp,%rbp
  80146e:	48 83 ec 18          	sub    $0x18,%rsp
  801472:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801476:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80147a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80147e:	eb 0f                	jmp    80148f <strncmp+0x25>
		n--, p++, q++;
  801480:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801485:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80148a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80148f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801494:	74 1d                	je     8014b3 <strncmp+0x49>
  801496:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80149a:	0f b6 00             	movzbl (%rax),%eax
  80149d:	84 c0                	test   %al,%al
  80149f:	74 12                	je     8014b3 <strncmp+0x49>
  8014a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a5:	0f b6 10             	movzbl (%rax),%edx
  8014a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ac:	0f b6 00             	movzbl (%rax),%eax
  8014af:	38 c2                	cmp    %al,%dl
  8014b1:	74 cd                	je     801480 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8014b3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014b8:	75 07                	jne    8014c1 <strncmp+0x57>
		return 0;
  8014ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8014bf:	eb 18                	jmp    8014d9 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c5:	0f b6 00             	movzbl (%rax),%eax
  8014c8:	0f b6 d0             	movzbl %al,%edx
  8014cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014cf:	0f b6 00             	movzbl (%rax),%eax
  8014d2:	0f b6 c0             	movzbl %al,%eax
  8014d5:	29 c2                	sub    %eax,%edx
  8014d7:	89 d0                	mov    %edx,%eax
}
  8014d9:	c9                   	leaveq 
  8014da:	c3                   	retq   

00000000008014db <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014db:	55                   	push   %rbp
  8014dc:	48 89 e5             	mov    %rsp,%rbp
  8014df:	48 83 ec 0c          	sub    $0xc,%rsp
  8014e3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014e7:	89 f0                	mov    %esi,%eax
  8014e9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8014ec:	eb 17                	jmp    801505 <strchr+0x2a>
		if (*s == c)
  8014ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f2:	0f b6 00             	movzbl (%rax),%eax
  8014f5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8014f8:	75 06                	jne    801500 <strchr+0x25>
			return (char *) s;
  8014fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014fe:	eb 15                	jmp    801515 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801500:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801505:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801509:	0f b6 00             	movzbl (%rax),%eax
  80150c:	84 c0                	test   %al,%al
  80150e:	75 de                	jne    8014ee <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801510:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801515:	c9                   	leaveq 
  801516:	c3                   	retq   

0000000000801517 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801517:	55                   	push   %rbp
  801518:	48 89 e5             	mov    %rsp,%rbp
  80151b:	48 83 ec 0c          	sub    $0xc,%rsp
  80151f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801523:	89 f0                	mov    %esi,%eax
  801525:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801528:	eb 13                	jmp    80153d <strfind+0x26>
		if (*s == c)
  80152a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80152e:	0f b6 00             	movzbl (%rax),%eax
  801531:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801534:	75 02                	jne    801538 <strfind+0x21>
			break;
  801536:	eb 10                	jmp    801548 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801538:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80153d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801541:	0f b6 00             	movzbl (%rax),%eax
  801544:	84 c0                	test   %al,%al
  801546:	75 e2                	jne    80152a <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801548:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80154c:	c9                   	leaveq 
  80154d:	c3                   	retq   

000000000080154e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80154e:	55                   	push   %rbp
  80154f:	48 89 e5             	mov    %rsp,%rbp
  801552:	48 83 ec 18          	sub    $0x18,%rsp
  801556:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80155a:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80155d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801561:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801566:	75 06                	jne    80156e <memset+0x20>
		return v;
  801568:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80156c:	eb 69                	jmp    8015d7 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80156e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801572:	83 e0 03             	and    $0x3,%eax
  801575:	48 85 c0             	test   %rax,%rax
  801578:	75 48                	jne    8015c2 <memset+0x74>
  80157a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80157e:	83 e0 03             	and    $0x3,%eax
  801581:	48 85 c0             	test   %rax,%rax
  801584:	75 3c                	jne    8015c2 <memset+0x74>
		c &= 0xFF;
  801586:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80158d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801590:	c1 e0 18             	shl    $0x18,%eax
  801593:	89 c2                	mov    %eax,%edx
  801595:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801598:	c1 e0 10             	shl    $0x10,%eax
  80159b:	09 c2                	or     %eax,%edx
  80159d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015a0:	c1 e0 08             	shl    $0x8,%eax
  8015a3:	09 d0                	or     %edx,%eax
  8015a5:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8015a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015ac:	48 c1 e8 02          	shr    $0x2,%rax
  8015b0:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8015b3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015b7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015ba:	48 89 d7             	mov    %rdx,%rdi
  8015bd:	fc                   	cld    
  8015be:	f3 ab                	rep stos %eax,%es:(%rdi)
  8015c0:	eb 11                	jmp    8015d3 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8015c2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015c6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015c9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8015cd:	48 89 d7             	mov    %rdx,%rdi
  8015d0:	fc                   	cld    
  8015d1:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8015d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8015d7:	c9                   	leaveq 
  8015d8:	c3                   	retq   

00000000008015d9 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8015d9:	55                   	push   %rbp
  8015da:	48 89 e5             	mov    %rsp,%rbp
  8015dd:	48 83 ec 28          	sub    $0x28,%rsp
  8015e1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015e9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8015ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8015f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015f9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8015fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801601:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801605:	0f 83 88 00 00 00    	jae    801693 <memmove+0xba>
  80160b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801613:	48 01 d0             	add    %rdx,%rax
  801616:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80161a:	76 77                	jbe    801693 <memmove+0xba>
		s += n;
  80161c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801620:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801624:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801628:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80162c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801630:	83 e0 03             	and    $0x3,%eax
  801633:	48 85 c0             	test   %rax,%rax
  801636:	75 3b                	jne    801673 <memmove+0x9a>
  801638:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80163c:	83 e0 03             	and    $0x3,%eax
  80163f:	48 85 c0             	test   %rax,%rax
  801642:	75 2f                	jne    801673 <memmove+0x9a>
  801644:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801648:	83 e0 03             	and    $0x3,%eax
  80164b:	48 85 c0             	test   %rax,%rax
  80164e:	75 23                	jne    801673 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801650:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801654:	48 83 e8 04          	sub    $0x4,%rax
  801658:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80165c:	48 83 ea 04          	sub    $0x4,%rdx
  801660:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801664:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801668:	48 89 c7             	mov    %rax,%rdi
  80166b:	48 89 d6             	mov    %rdx,%rsi
  80166e:	fd                   	std    
  80166f:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801671:	eb 1d                	jmp    801690 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801673:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801677:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80167b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80167f:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801683:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801687:	48 89 d7             	mov    %rdx,%rdi
  80168a:	48 89 c1             	mov    %rax,%rcx
  80168d:	fd                   	std    
  80168e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801690:	fc                   	cld    
  801691:	eb 57                	jmp    8016ea <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801693:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801697:	83 e0 03             	and    $0x3,%eax
  80169a:	48 85 c0             	test   %rax,%rax
  80169d:	75 36                	jne    8016d5 <memmove+0xfc>
  80169f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016a3:	83 e0 03             	and    $0x3,%eax
  8016a6:	48 85 c0             	test   %rax,%rax
  8016a9:	75 2a                	jne    8016d5 <memmove+0xfc>
  8016ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016af:	83 e0 03             	and    $0x3,%eax
  8016b2:	48 85 c0             	test   %rax,%rax
  8016b5:	75 1e                	jne    8016d5 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8016b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016bb:	48 c1 e8 02          	shr    $0x2,%rax
  8016bf:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8016c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016ca:	48 89 c7             	mov    %rax,%rdi
  8016cd:	48 89 d6             	mov    %rdx,%rsi
  8016d0:	fc                   	cld    
  8016d1:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016d3:	eb 15                	jmp    8016ea <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8016d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016dd:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8016e1:	48 89 c7             	mov    %rax,%rdi
  8016e4:	48 89 d6             	mov    %rdx,%rsi
  8016e7:	fc                   	cld    
  8016e8:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8016ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016ee:	c9                   	leaveq 
  8016ef:	c3                   	retq   

00000000008016f0 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8016f0:	55                   	push   %rbp
  8016f1:	48 89 e5             	mov    %rsp,%rbp
  8016f4:	48 83 ec 18          	sub    $0x18,%rsp
  8016f8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016fc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801700:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801704:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801708:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80170c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801710:	48 89 ce             	mov    %rcx,%rsi
  801713:	48 89 c7             	mov    %rax,%rdi
  801716:	48 b8 d9 15 80 00 00 	movabs $0x8015d9,%rax
  80171d:	00 00 00 
  801720:	ff d0                	callq  *%rax
}
  801722:	c9                   	leaveq 
  801723:	c3                   	retq   

0000000000801724 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801724:	55                   	push   %rbp
  801725:	48 89 e5             	mov    %rsp,%rbp
  801728:	48 83 ec 28          	sub    $0x28,%rsp
  80172c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801730:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801734:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801738:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80173c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801740:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801744:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801748:	eb 36                	jmp    801780 <memcmp+0x5c>
		if (*s1 != *s2)
  80174a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80174e:	0f b6 10             	movzbl (%rax),%edx
  801751:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801755:	0f b6 00             	movzbl (%rax),%eax
  801758:	38 c2                	cmp    %al,%dl
  80175a:	74 1a                	je     801776 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80175c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801760:	0f b6 00             	movzbl (%rax),%eax
  801763:	0f b6 d0             	movzbl %al,%edx
  801766:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80176a:	0f b6 00             	movzbl (%rax),%eax
  80176d:	0f b6 c0             	movzbl %al,%eax
  801770:	29 c2                	sub    %eax,%edx
  801772:	89 d0                	mov    %edx,%eax
  801774:	eb 20                	jmp    801796 <memcmp+0x72>
		s1++, s2++;
  801776:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80177b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801780:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801784:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801788:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80178c:	48 85 c0             	test   %rax,%rax
  80178f:	75 b9                	jne    80174a <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801791:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801796:	c9                   	leaveq 
  801797:	c3                   	retq   

0000000000801798 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801798:	55                   	push   %rbp
  801799:	48 89 e5             	mov    %rsp,%rbp
  80179c:	48 83 ec 28          	sub    $0x28,%rsp
  8017a0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017a4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8017a7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8017ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017b3:	48 01 d0             	add    %rdx,%rax
  8017b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8017ba:	eb 15                	jmp    8017d1 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017c0:	0f b6 10             	movzbl (%rax),%edx
  8017c3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8017c6:	38 c2                	cmp    %al,%dl
  8017c8:	75 02                	jne    8017cc <memfind+0x34>
			break;
  8017ca:	eb 0f                	jmp    8017db <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8017cc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8017d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017d5:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8017d9:	72 e1                	jb     8017bc <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8017db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017df:	c9                   	leaveq 
  8017e0:	c3                   	retq   

00000000008017e1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8017e1:	55                   	push   %rbp
  8017e2:	48 89 e5             	mov    %rsp,%rbp
  8017e5:	48 83 ec 34          	sub    $0x34,%rsp
  8017e9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017ed:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8017f1:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8017f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8017fb:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801802:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801803:	eb 05                	jmp    80180a <strtol+0x29>
		s++;
  801805:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80180a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180e:	0f b6 00             	movzbl (%rax),%eax
  801811:	3c 20                	cmp    $0x20,%al
  801813:	74 f0                	je     801805 <strtol+0x24>
  801815:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801819:	0f b6 00             	movzbl (%rax),%eax
  80181c:	3c 09                	cmp    $0x9,%al
  80181e:	74 e5                	je     801805 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801820:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801824:	0f b6 00             	movzbl (%rax),%eax
  801827:	3c 2b                	cmp    $0x2b,%al
  801829:	75 07                	jne    801832 <strtol+0x51>
		s++;
  80182b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801830:	eb 17                	jmp    801849 <strtol+0x68>
	else if (*s == '-')
  801832:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801836:	0f b6 00             	movzbl (%rax),%eax
  801839:	3c 2d                	cmp    $0x2d,%al
  80183b:	75 0c                	jne    801849 <strtol+0x68>
		s++, neg = 1;
  80183d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801842:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801849:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80184d:	74 06                	je     801855 <strtol+0x74>
  80184f:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801853:	75 28                	jne    80187d <strtol+0x9c>
  801855:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801859:	0f b6 00             	movzbl (%rax),%eax
  80185c:	3c 30                	cmp    $0x30,%al
  80185e:	75 1d                	jne    80187d <strtol+0x9c>
  801860:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801864:	48 83 c0 01          	add    $0x1,%rax
  801868:	0f b6 00             	movzbl (%rax),%eax
  80186b:	3c 78                	cmp    $0x78,%al
  80186d:	75 0e                	jne    80187d <strtol+0x9c>
		s += 2, base = 16;
  80186f:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801874:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80187b:	eb 2c                	jmp    8018a9 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80187d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801881:	75 19                	jne    80189c <strtol+0xbb>
  801883:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801887:	0f b6 00             	movzbl (%rax),%eax
  80188a:	3c 30                	cmp    $0x30,%al
  80188c:	75 0e                	jne    80189c <strtol+0xbb>
		s++, base = 8;
  80188e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801893:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80189a:	eb 0d                	jmp    8018a9 <strtol+0xc8>
	else if (base == 0)
  80189c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018a0:	75 07                	jne    8018a9 <strtol+0xc8>
		base = 10;
  8018a2:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ad:	0f b6 00             	movzbl (%rax),%eax
  8018b0:	3c 2f                	cmp    $0x2f,%al
  8018b2:	7e 1d                	jle    8018d1 <strtol+0xf0>
  8018b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b8:	0f b6 00             	movzbl (%rax),%eax
  8018bb:	3c 39                	cmp    $0x39,%al
  8018bd:	7f 12                	jg     8018d1 <strtol+0xf0>
			dig = *s - '0';
  8018bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c3:	0f b6 00             	movzbl (%rax),%eax
  8018c6:	0f be c0             	movsbl %al,%eax
  8018c9:	83 e8 30             	sub    $0x30,%eax
  8018cc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8018cf:	eb 4e                	jmp    80191f <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8018d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d5:	0f b6 00             	movzbl (%rax),%eax
  8018d8:	3c 60                	cmp    $0x60,%al
  8018da:	7e 1d                	jle    8018f9 <strtol+0x118>
  8018dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e0:	0f b6 00             	movzbl (%rax),%eax
  8018e3:	3c 7a                	cmp    $0x7a,%al
  8018e5:	7f 12                	jg     8018f9 <strtol+0x118>
			dig = *s - 'a' + 10;
  8018e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018eb:	0f b6 00             	movzbl (%rax),%eax
  8018ee:	0f be c0             	movsbl %al,%eax
  8018f1:	83 e8 57             	sub    $0x57,%eax
  8018f4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8018f7:	eb 26                	jmp    80191f <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8018f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018fd:	0f b6 00             	movzbl (%rax),%eax
  801900:	3c 40                	cmp    $0x40,%al
  801902:	7e 48                	jle    80194c <strtol+0x16b>
  801904:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801908:	0f b6 00             	movzbl (%rax),%eax
  80190b:	3c 5a                	cmp    $0x5a,%al
  80190d:	7f 3d                	jg     80194c <strtol+0x16b>
			dig = *s - 'A' + 10;
  80190f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801913:	0f b6 00             	movzbl (%rax),%eax
  801916:	0f be c0             	movsbl %al,%eax
  801919:	83 e8 37             	sub    $0x37,%eax
  80191c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80191f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801922:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801925:	7c 02                	jl     801929 <strtol+0x148>
			break;
  801927:	eb 23                	jmp    80194c <strtol+0x16b>
		s++, val = (val * base) + dig;
  801929:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80192e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801931:	48 98                	cltq   
  801933:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801938:	48 89 c2             	mov    %rax,%rdx
  80193b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80193e:	48 98                	cltq   
  801940:	48 01 d0             	add    %rdx,%rax
  801943:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801947:	e9 5d ff ff ff       	jmpq   8018a9 <strtol+0xc8>

	if (endptr)
  80194c:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801951:	74 0b                	je     80195e <strtol+0x17d>
		*endptr = (char *) s;
  801953:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801957:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80195b:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80195e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801962:	74 09                	je     80196d <strtol+0x18c>
  801964:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801968:	48 f7 d8             	neg    %rax
  80196b:	eb 04                	jmp    801971 <strtol+0x190>
  80196d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801971:	c9                   	leaveq 
  801972:	c3                   	retq   

0000000000801973 <strstr>:

char * strstr(const char *in, const char *str)
{
  801973:	55                   	push   %rbp
  801974:	48 89 e5             	mov    %rsp,%rbp
  801977:	48 83 ec 30          	sub    $0x30,%rsp
  80197b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80197f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801983:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801987:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80198b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80198f:	0f b6 00             	movzbl (%rax),%eax
  801992:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801995:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801999:	75 06                	jne    8019a1 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80199b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80199f:	eb 6b                	jmp    801a0c <strstr+0x99>

	len = strlen(str);
  8019a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019a5:	48 89 c7             	mov    %rax,%rdi
  8019a8:	48 b8 49 12 80 00 00 	movabs $0x801249,%rax
  8019af:	00 00 00 
  8019b2:	ff d0                	callq  *%rax
  8019b4:	48 98                	cltq   
  8019b6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8019ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019be:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019c2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8019c6:	0f b6 00             	movzbl (%rax),%eax
  8019c9:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8019cc:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8019d0:	75 07                	jne    8019d9 <strstr+0x66>
				return (char *) 0;
  8019d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d7:	eb 33                	jmp    801a0c <strstr+0x99>
		} while (sc != c);
  8019d9:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8019dd:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8019e0:	75 d8                	jne    8019ba <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8019e2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019e6:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8019ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ee:	48 89 ce             	mov    %rcx,%rsi
  8019f1:	48 89 c7             	mov    %rax,%rdi
  8019f4:	48 b8 6a 14 80 00 00 	movabs $0x80146a,%rax
  8019fb:	00 00 00 
  8019fe:	ff d0                	callq  *%rax
  801a00:	85 c0                	test   %eax,%eax
  801a02:	75 b6                	jne    8019ba <strstr+0x47>

	return (char *) (in - 1);
  801a04:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a08:	48 83 e8 01          	sub    $0x1,%rax
}
  801a0c:	c9                   	leaveq 
  801a0d:	c3                   	retq   

0000000000801a0e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801a0e:	55                   	push   %rbp
  801a0f:	48 89 e5             	mov    %rsp,%rbp
  801a12:	53                   	push   %rbx
  801a13:	48 83 ec 48          	sub    $0x48,%rsp
  801a17:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801a1a:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801a1d:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801a21:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801a25:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801a29:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  801a2d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801a30:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801a34:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801a38:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801a3c:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801a40:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801a44:	4c 89 c3             	mov    %r8,%rbx
  801a47:	cd 30                	int    $0x30
  801a49:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  801a4d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801a51:	74 3e                	je     801a91 <syscall+0x83>
  801a53:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801a58:	7e 37                	jle    801a91 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801a5a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a5e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801a61:	49 89 d0             	mov    %rdx,%r8
  801a64:	89 c1                	mov    %eax,%ecx
  801a66:	48 ba c8 44 80 00 00 	movabs $0x8044c8,%rdx
  801a6d:	00 00 00 
  801a70:	be 4a 00 00 00       	mov    $0x4a,%esi
  801a75:	48 bf e5 44 80 00 00 	movabs $0x8044e5,%rdi
  801a7c:	00 00 00 
  801a7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a84:	49 b9 c7 04 80 00 00 	movabs $0x8004c7,%r9
  801a8b:	00 00 00 
  801a8e:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  801a91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a95:	48 83 c4 48          	add    $0x48,%rsp
  801a99:	5b                   	pop    %rbx
  801a9a:	5d                   	pop    %rbp
  801a9b:	c3                   	retq   

0000000000801a9c <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801a9c:	55                   	push   %rbp
  801a9d:	48 89 e5             	mov    %rsp,%rbp
  801aa0:	48 83 ec 20          	sub    $0x20,%rsp
  801aa4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801aa8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801aac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ab0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ab4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801abb:	00 
  801abc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ac2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ac8:	48 89 d1             	mov    %rdx,%rcx
  801acb:	48 89 c2             	mov    %rax,%rdx
  801ace:	be 00 00 00 00       	mov    $0x0,%esi
  801ad3:	bf 00 00 00 00       	mov    $0x0,%edi
  801ad8:	48 b8 0e 1a 80 00 00 	movabs $0x801a0e,%rax
  801adf:	00 00 00 
  801ae2:	ff d0                	callq  *%rax
}
  801ae4:	c9                   	leaveq 
  801ae5:	c3                   	retq   

0000000000801ae6 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ae6:	55                   	push   %rbp
  801ae7:	48 89 e5             	mov    %rsp,%rbp
  801aea:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801aee:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801af5:	00 
  801af6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801afc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b02:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b07:	ba 00 00 00 00       	mov    $0x0,%edx
  801b0c:	be 00 00 00 00       	mov    $0x0,%esi
  801b11:	bf 01 00 00 00       	mov    $0x1,%edi
  801b16:	48 b8 0e 1a 80 00 00 	movabs $0x801a0e,%rax
  801b1d:	00 00 00 
  801b20:	ff d0                	callq  *%rax
}
  801b22:	c9                   	leaveq 
  801b23:	c3                   	retq   

0000000000801b24 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801b24:	55                   	push   %rbp
  801b25:	48 89 e5             	mov    %rsp,%rbp
  801b28:	48 83 ec 10          	sub    $0x10,%rsp
  801b2c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801b2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b32:	48 98                	cltq   
  801b34:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b3b:	00 
  801b3c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b42:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b48:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b4d:	48 89 c2             	mov    %rax,%rdx
  801b50:	be 01 00 00 00       	mov    $0x1,%esi
  801b55:	bf 03 00 00 00       	mov    $0x3,%edi
  801b5a:	48 b8 0e 1a 80 00 00 	movabs $0x801a0e,%rax
  801b61:	00 00 00 
  801b64:	ff d0                	callq  *%rax
}
  801b66:	c9                   	leaveq 
  801b67:	c3                   	retq   

0000000000801b68 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801b68:	55                   	push   %rbp
  801b69:	48 89 e5             	mov    %rsp,%rbp
  801b6c:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801b70:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b77:	00 
  801b78:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b7e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b84:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b89:	ba 00 00 00 00       	mov    $0x0,%edx
  801b8e:	be 00 00 00 00       	mov    $0x0,%esi
  801b93:	bf 02 00 00 00       	mov    $0x2,%edi
  801b98:	48 b8 0e 1a 80 00 00 	movabs $0x801a0e,%rax
  801b9f:	00 00 00 
  801ba2:	ff d0                	callq  *%rax
}
  801ba4:	c9                   	leaveq 
  801ba5:	c3                   	retq   

0000000000801ba6 <sys_yield>:

void
sys_yield(void)
{
  801ba6:	55                   	push   %rbp
  801ba7:	48 89 e5             	mov    %rsp,%rbp
  801baa:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801bae:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bb5:	00 
  801bb6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bbc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bc2:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bc7:	ba 00 00 00 00       	mov    $0x0,%edx
  801bcc:	be 00 00 00 00       	mov    $0x0,%esi
  801bd1:	bf 0b 00 00 00       	mov    $0xb,%edi
  801bd6:	48 b8 0e 1a 80 00 00 	movabs $0x801a0e,%rax
  801bdd:	00 00 00 
  801be0:	ff d0                	callq  *%rax
}
  801be2:	c9                   	leaveq 
  801be3:	c3                   	retq   

0000000000801be4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801be4:	55                   	push   %rbp
  801be5:	48 89 e5             	mov    %rsp,%rbp
  801be8:	48 83 ec 20          	sub    $0x20,%rsp
  801bec:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bf3:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801bf6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bf9:	48 63 c8             	movslq %eax,%rcx
  801bfc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c03:	48 98                	cltq   
  801c05:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c0c:	00 
  801c0d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c13:	49 89 c8             	mov    %rcx,%r8
  801c16:	48 89 d1             	mov    %rdx,%rcx
  801c19:	48 89 c2             	mov    %rax,%rdx
  801c1c:	be 01 00 00 00       	mov    $0x1,%esi
  801c21:	bf 04 00 00 00       	mov    $0x4,%edi
  801c26:	48 b8 0e 1a 80 00 00 	movabs $0x801a0e,%rax
  801c2d:	00 00 00 
  801c30:	ff d0                	callq  *%rax
}
  801c32:	c9                   	leaveq 
  801c33:	c3                   	retq   

0000000000801c34 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801c34:	55                   	push   %rbp
  801c35:	48 89 e5             	mov    %rsp,%rbp
  801c38:	48 83 ec 30          	sub    $0x30,%rsp
  801c3c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c3f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c43:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801c46:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801c4a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801c4e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c51:	48 63 c8             	movslq %eax,%rcx
  801c54:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801c58:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c5b:	48 63 f0             	movslq %eax,%rsi
  801c5e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c65:	48 98                	cltq   
  801c67:	48 89 0c 24          	mov    %rcx,(%rsp)
  801c6b:	49 89 f9             	mov    %rdi,%r9
  801c6e:	49 89 f0             	mov    %rsi,%r8
  801c71:	48 89 d1             	mov    %rdx,%rcx
  801c74:	48 89 c2             	mov    %rax,%rdx
  801c77:	be 01 00 00 00       	mov    $0x1,%esi
  801c7c:	bf 05 00 00 00       	mov    $0x5,%edi
  801c81:	48 b8 0e 1a 80 00 00 	movabs $0x801a0e,%rax
  801c88:	00 00 00 
  801c8b:	ff d0                	callq  *%rax
}
  801c8d:	c9                   	leaveq 
  801c8e:	c3                   	retq   

0000000000801c8f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801c8f:	55                   	push   %rbp
  801c90:	48 89 e5             	mov    %rsp,%rbp
  801c93:	48 83 ec 20          	sub    $0x20,%rsp
  801c97:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c9a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801c9e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ca2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ca5:	48 98                	cltq   
  801ca7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cae:	00 
  801caf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cb5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cbb:	48 89 d1             	mov    %rdx,%rcx
  801cbe:	48 89 c2             	mov    %rax,%rdx
  801cc1:	be 01 00 00 00       	mov    $0x1,%esi
  801cc6:	bf 06 00 00 00       	mov    $0x6,%edi
  801ccb:	48 b8 0e 1a 80 00 00 	movabs $0x801a0e,%rax
  801cd2:	00 00 00 
  801cd5:	ff d0                	callq  *%rax
}
  801cd7:	c9                   	leaveq 
  801cd8:	c3                   	retq   

0000000000801cd9 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801cd9:	55                   	push   %rbp
  801cda:	48 89 e5             	mov    %rsp,%rbp
  801cdd:	48 83 ec 10          	sub    $0x10,%rsp
  801ce1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ce4:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801ce7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cea:	48 63 d0             	movslq %eax,%rdx
  801ced:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cf0:	48 98                	cltq   
  801cf2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cf9:	00 
  801cfa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d00:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d06:	48 89 d1             	mov    %rdx,%rcx
  801d09:	48 89 c2             	mov    %rax,%rdx
  801d0c:	be 01 00 00 00       	mov    $0x1,%esi
  801d11:	bf 08 00 00 00       	mov    $0x8,%edi
  801d16:	48 b8 0e 1a 80 00 00 	movabs $0x801a0e,%rax
  801d1d:	00 00 00 
  801d20:	ff d0                	callq  *%rax
}
  801d22:	c9                   	leaveq 
  801d23:	c3                   	retq   

0000000000801d24 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801d24:	55                   	push   %rbp
  801d25:	48 89 e5             	mov    %rsp,%rbp
  801d28:	48 83 ec 20          	sub    $0x20,%rsp
  801d2c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d2f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801d33:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d3a:	48 98                	cltq   
  801d3c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d43:	00 
  801d44:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d4a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d50:	48 89 d1             	mov    %rdx,%rcx
  801d53:	48 89 c2             	mov    %rax,%rdx
  801d56:	be 01 00 00 00       	mov    $0x1,%esi
  801d5b:	bf 09 00 00 00       	mov    $0x9,%edi
  801d60:	48 b8 0e 1a 80 00 00 	movabs $0x801a0e,%rax
  801d67:	00 00 00 
  801d6a:	ff d0                	callq  *%rax
}
  801d6c:	c9                   	leaveq 
  801d6d:	c3                   	retq   

0000000000801d6e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801d6e:	55                   	push   %rbp
  801d6f:	48 89 e5             	mov    %rsp,%rbp
  801d72:	48 83 ec 20          	sub    $0x20,%rsp
  801d76:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d79:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801d7d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d84:	48 98                	cltq   
  801d86:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d8d:	00 
  801d8e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d94:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d9a:	48 89 d1             	mov    %rdx,%rcx
  801d9d:	48 89 c2             	mov    %rax,%rdx
  801da0:	be 01 00 00 00       	mov    $0x1,%esi
  801da5:	bf 0a 00 00 00       	mov    $0xa,%edi
  801daa:	48 b8 0e 1a 80 00 00 	movabs $0x801a0e,%rax
  801db1:	00 00 00 
  801db4:	ff d0                	callq  *%rax
}
  801db6:	c9                   	leaveq 
  801db7:	c3                   	retq   

0000000000801db8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801db8:	55                   	push   %rbp
  801db9:	48 89 e5             	mov    %rsp,%rbp
  801dbc:	48 83 ec 20          	sub    $0x20,%rsp
  801dc0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dc3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801dc7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801dcb:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801dce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dd1:	48 63 f0             	movslq %eax,%rsi
  801dd4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801dd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ddb:	48 98                	cltq   
  801ddd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801de1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801de8:	00 
  801de9:	49 89 f1             	mov    %rsi,%r9
  801dec:	49 89 c8             	mov    %rcx,%r8
  801def:	48 89 d1             	mov    %rdx,%rcx
  801df2:	48 89 c2             	mov    %rax,%rdx
  801df5:	be 00 00 00 00       	mov    $0x0,%esi
  801dfa:	bf 0c 00 00 00       	mov    $0xc,%edi
  801dff:	48 b8 0e 1a 80 00 00 	movabs $0x801a0e,%rax
  801e06:	00 00 00 
  801e09:	ff d0                	callq  *%rax
}
  801e0b:	c9                   	leaveq 
  801e0c:	c3                   	retq   

0000000000801e0d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801e0d:	55                   	push   %rbp
  801e0e:	48 89 e5             	mov    %rsp,%rbp
  801e11:	48 83 ec 10          	sub    $0x10,%rsp
  801e15:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801e19:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e1d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e24:	00 
  801e25:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e2b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e31:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e36:	48 89 c2             	mov    %rax,%rdx
  801e39:	be 01 00 00 00       	mov    $0x1,%esi
  801e3e:	bf 0d 00 00 00       	mov    $0xd,%edi
  801e43:	48 b8 0e 1a 80 00 00 	movabs $0x801a0e,%rax
  801e4a:	00 00 00 
  801e4d:	ff d0                	callq  *%rax
}
  801e4f:	c9                   	leaveq 
  801e50:	c3                   	retq   

0000000000801e51 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801e51:	55                   	push   %rbp
  801e52:	48 89 e5             	mov    %rsp,%rbp
  801e55:	53                   	push   %rbx
  801e56:	48 83 ec 48          	sub    $0x48,%rsp
  801e5a:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801e5e:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801e62:	48 8b 00             	mov    (%rax),%rax
  801e65:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	uint32_t err = utf->utf_err;
  801e69:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801e6d:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e71:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	pte_t pte = uvpt[VPN(addr)];
  801e74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e78:	48 c1 e8 0c          	shr    $0xc,%rax
  801e7c:	48 89 c2             	mov    %rax,%rdx
  801e7f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e86:	01 00 00 
  801e89:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e8d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	envid_t pid = sys_getenvid();
  801e91:	48 b8 68 1b 80 00 00 	movabs $0x801b68,%rax
  801e98:	00 00 00 
  801e9b:	ff d0                	callq  *%rax
  801e9d:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	void* va = ROUNDDOWN(addr, PGSIZE);
  801ea0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ea4:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  801ea8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801eac:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801eb2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	if((err & FEC_WR) && (pte & PTE_COW)){
  801eb6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801eb9:	83 e0 02             	and    $0x2,%eax
  801ebc:	85 c0                	test   %eax,%eax
  801ebe:	0f 84 8d 00 00 00    	je     801f51 <pgfault+0x100>
  801ec4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ec8:	25 00 08 00 00       	and    $0x800,%eax
  801ecd:	48 85 c0             	test   %rax,%rax
  801ed0:	74 7f                	je     801f51 <pgfault+0x100>
		if(!sys_page_alloc(pid, (void*)PFTEMP, PTE_P | PTE_W | PTE_U)){
  801ed2:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801ed5:	ba 07 00 00 00       	mov    $0x7,%edx
  801eda:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801edf:	89 c7                	mov    %eax,%edi
  801ee1:	48 b8 e4 1b 80 00 00 	movabs $0x801be4,%rax
  801ee8:	00 00 00 
  801eeb:	ff d0                	callq  *%rax
  801eed:	85 c0                	test   %eax,%eax
  801eef:	75 60                	jne    801f51 <pgfault+0x100>
			memmove(PFTEMP, va, PGSIZE);
  801ef1:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801ef5:	ba 00 10 00 00       	mov    $0x1000,%edx
  801efa:	48 89 c6             	mov    %rax,%rsi
  801efd:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801f02:	48 b8 d9 15 80 00 00 	movabs $0x8015d9,%rax
  801f09:	00 00 00 
  801f0c:	ff d0                	callq  *%rax
			if(!(sys_page_map(pid, (void*)PFTEMP, pid, va, PTE_P | PTE_W | PTE_U) | 
  801f0e:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  801f12:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  801f15:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801f18:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801f1e:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f23:	89 c7                	mov    %eax,%edi
  801f25:	48 b8 34 1c 80 00 00 	movabs $0x801c34,%rax
  801f2c:	00 00 00 
  801f2f:	ff d0                	callq  *%rax
  801f31:	89 c3                	mov    %eax,%ebx
					 sys_page_unmap(pid, (void*) PFTEMP)))
  801f33:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801f36:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f3b:	89 c7                	mov    %eax,%edi
  801f3d:	48 b8 8f 1c 80 00 00 	movabs $0x801c8f,%rax
  801f44:	00 00 00 
  801f47:	ff d0                	callq  *%rax
	envid_t pid = sys_getenvid();
	void* va = ROUNDDOWN(addr, PGSIZE);
	if((err & FEC_WR) && (pte & PTE_COW)){
		if(!sys_page_alloc(pid, (void*)PFTEMP, PTE_P | PTE_W | PTE_U)){
			memmove(PFTEMP, va, PGSIZE);
			if(!(sys_page_map(pid, (void*)PFTEMP, pid, va, PTE_P | PTE_W | PTE_U) | 
  801f49:	09 d8                	or     %ebx,%eax
  801f4b:	85 c0                	test   %eax,%eax
  801f4d:	75 02                	jne    801f51 <pgfault+0x100>
					 sys_page_unmap(pid, (void*) PFTEMP)))
					return;
  801f4f:	eb 2a                	jmp    801f7b <pgfault+0x12a>
		}
	}
	panic("Page fault handler failure\n");
  801f51:	48 ba f3 44 80 00 00 	movabs $0x8044f3,%rdx
  801f58:	00 00 00 
  801f5b:	be 26 00 00 00       	mov    $0x26,%esi
  801f60:	48 bf 0f 45 80 00 00 	movabs $0x80450f,%rdi
  801f67:	00 00 00 
  801f6a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6f:	48 b9 c7 04 80 00 00 	movabs $0x8004c7,%rcx
  801f76:	00 00 00 
  801f79:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	//panic("pgfault not implemented");
}
  801f7b:	48 83 c4 48          	add    $0x48,%rsp
  801f7f:	5b                   	pop    %rbx
  801f80:	5d                   	pop    %rbp
  801f81:	c3                   	retq   

0000000000801f82 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801f82:	55                   	push   %rbp
  801f83:	48 89 e5             	mov    %rsp,%rbp
  801f86:	53                   	push   %rbx
  801f87:	48 83 ec 38          	sub    $0x38,%rsp
  801f8b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801f8e:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	//struct Env *env;
	pte_t pte = uvpt[pn];
  801f91:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f98:	01 00 00 
  801f9b:	8b 55 c8             	mov    -0x38(%rbp),%edx
  801f9e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fa2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int perm = pte & PTE_SYSCALL;
  801fa6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801faa:	25 07 0e 00 00       	and    $0xe07,%eax
  801faf:	89 45 dc             	mov    %eax,-0x24(%rbp)
	void *va = (void*)((uintptr_t)pn * PGSIZE);
  801fb2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801fb5:	48 c1 e0 0c          	shl    $0xc,%rax
  801fb9:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	if(perm & PTE_SHARE){
  801fbd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801fc0:	25 00 04 00 00       	and    $0x400,%eax
  801fc5:	85 c0                	test   %eax,%eax
  801fc7:	74 30                	je     801ff9 <duppage+0x77>
		r = sys_page_map(0, va, envid, va, perm);
  801fc9:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801fcc:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801fd0:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801fd3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fd7:	41 89 f0             	mov    %esi,%r8d
  801fda:	48 89 c6             	mov    %rax,%rsi
  801fdd:	bf 00 00 00 00       	mov    $0x0,%edi
  801fe2:	48 b8 34 1c 80 00 00 	movabs $0x801c34,%rax
  801fe9:	00 00 00 
  801fec:	ff d0                	callq  *%rax
  801fee:	89 45 ec             	mov    %eax,-0x14(%rbp)
		return r;
  801ff1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ff4:	e9 a4 00 00 00       	jmpq   80209d <duppage+0x11b>
	}
	//envid_t pid = sys_getenvid();
	if((perm & PTE_W) || (perm & PTE_COW)){
  801ff9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801ffc:	83 e0 02             	and    $0x2,%eax
  801fff:	85 c0                	test   %eax,%eax
  802001:	75 0c                	jne    80200f <duppage+0x8d>
  802003:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802006:	25 00 08 00 00       	and    $0x800,%eax
  80200b:	85 c0                	test   %eax,%eax
  80200d:	74 63                	je     802072 <duppage+0xf0>
		perm &= ~PTE_W;
  80200f:	83 65 dc fd          	andl   $0xfffffffd,-0x24(%rbp)
		perm |= PTE_COW;
  802013:	81 4d dc 00 08 00 00 	orl    $0x800,-0x24(%rbp)
		r = sys_page_map(0, va, envid, va, perm) | sys_page_map(0, va, 0, va, perm);
  80201a:	8b 75 dc             	mov    -0x24(%rbp),%esi
  80201d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802021:	8b 55 cc             	mov    -0x34(%rbp),%edx
  802024:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802028:	41 89 f0             	mov    %esi,%r8d
  80202b:	48 89 c6             	mov    %rax,%rsi
  80202e:	bf 00 00 00 00       	mov    $0x0,%edi
  802033:	48 b8 34 1c 80 00 00 	movabs $0x801c34,%rax
  80203a:	00 00 00 
  80203d:	ff d0                	callq  *%rax
  80203f:	89 c3                	mov    %eax,%ebx
  802041:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802044:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802048:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80204c:	41 89 c8             	mov    %ecx,%r8d
  80204f:	48 89 d1             	mov    %rdx,%rcx
  802052:	ba 00 00 00 00       	mov    $0x0,%edx
  802057:	48 89 c6             	mov    %rax,%rsi
  80205a:	bf 00 00 00 00       	mov    $0x0,%edi
  80205f:	48 b8 34 1c 80 00 00 	movabs $0x801c34,%rax
  802066:	00 00 00 
  802069:	ff d0                	callq  *%rax
  80206b:	09 d8                	or     %ebx,%eax
  80206d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802070:	eb 28                	jmp    80209a <duppage+0x118>
	}
	else{
		r = sys_page_map(0, va, envid, va, perm);
  802072:	8b 75 dc             	mov    -0x24(%rbp),%esi
  802075:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802079:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80207c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802080:	41 89 f0             	mov    %esi,%r8d
  802083:	48 89 c6             	mov    %rax,%rsi
  802086:	bf 00 00 00 00       	mov    $0x0,%edi
  80208b:	48 b8 34 1c 80 00 00 	movabs $0x801c34,%rax
  802092:	00 00 00 
  802095:	ff d0                	callq  *%rax
  802097:	89 45 ec             	mov    %eax,-0x14(%rbp)
	}

	// LAB 4: Your code here.
	//panic("duppage not implemented");
	//if(r != 0) panic("Duplicating page failed: %e\n", r);
	return r;
  80209a:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80209d:	48 83 c4 38          	add    $0x38,%rsp
  8020a1:	5b                   	pop    %rbx
  8020a2:	5d                   	pop    %rbp
  8020a3:	c3                   	retq   

00000000008020a4 <fork>:
//   so you must allocate a new page for the child's user exception stack.
//

envid_t
fork(void)
{
  8020a4:	55                   	push   %rbp
  8020a5:	48 89 e5             	mov    %rsp,%rbp
  8020a8:	53                   	push   %rbx
  8020a9:	48 83 ec 58          	sub    $0x58,%rsp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  8020ad:	48 bf 51 1e 80 00 00 	movabs $0x801e51,%rdi
  8020b4:	00 00 00 
  8020b7:	48 b8 69 3b 80 00 00 	movabs $0x803b69,%rax
  8020be:	00 00 00 
  8020c1:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8020c3:	b8 07 00 00 00       	mov    $0x7,%eax
  8020c8:	cd 30                	int    $0x30
  8020ca:	89 45 a4             	mov    %eax,-0x5c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8020cd:	8b 45 a4             	mov    -0x5c(%rbp),%eax
	envid_t cid = sys_exofork();
  8020d0:	89 45 cc             	mov    %eax,-0x34(%rbp)
	if(cid < 0) panic("fork failed: %e\n", cid);
  8020d3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8020d7:	79 30                	jns    802109 <fork+0x65>
  8020d9:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8020dc:	89 c1                	mov    %eax,%ecx
  8020de:	48 ba 1a 45 80 00 00 	movabs $0x80451a,%rdx
  8020e5:	00 00 00 
  8020e8:	be 72 00 00 00       	mov    $0x72,%esi
  8020ed:	48 bf 0f 45 80 00 00 	movabs $0x80450f,%rdi
  8020f4:	00 00 00 
  8020f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020fc:	49 b8 c7 04 80 00 00 	movabs $0x8004c7,%r8
  802103:	00 00 00 
  802106:	41 ff d0             	callq  *%r8
	if(cid == 0){
  802109:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80210d:	75 46                	jne    802155 <fork+0xb1>
		thisenv = &envs[ENVX(sys_getenvid())];
  80210f:	48 b8 68 1b 80 00 00 	movabs $0x801b68,%rax
  802116:	00 00 00 
  802119:	ff d0                	callq  *%rax
  80211b:	25 ff 03 00 00       	and    $0x3ff,%eax
  802120:	48 63 d0             	movslq %eax,%rdx
  802123:	48 89 d0             	mov    %rdx,%rax
  802126:	48 c1 e0 03          	shl    $0x3,%rax
  80212a:	48 01 d0             	add    %rdx,%rax
  80212d:	48 c1 e0 05          	shl    $0x5,%rax
  802131:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802138:	00 00 00 
  80213b:	48 01 c2             	add    %rax,%rdx
  80213e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802145:	00 00 00 
  802148:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  80214b:	b8 00 00 00 00       	mov    $0x0,%eax
  802150:	e9 12 02 00 00       	jmpq   802367 <fork+0x2c3>
	}
	int result;
	if((result = sys_page_alloc(cid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802155:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802158:	ba 07 00 00 00       	mov    $0x7,%edx
  80215d:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802162:	89 c7                	mov    %eax,%edi
  802164:	48 b8 e4 1b 80 00 00 	movabs $0x801be4,%rax
  80216b:	00 00 00 
  80216e:	ff d0                	callq  *%rax
  802170:	89 45 c8             	mov    %eax,-0x38(%rbp)
  802173:	83 7d c8 00          	cmpl   $0x0,-0x38(%rbp)
  802177:	79 30                	jns    8021a9 <fork+0x105>
		panic("fork failed: %e\n", result);
  802179:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80217c:	89 c1                	mov    %eax,%ecx
  80217e:	48 ba 1a 45 80 00 00 	movabs $0x80451a,%rdx
  802185:	00 00 00 
  802188:	be 79 00 00 00       	mov    $0x79,%esi
  80218d:	48 bf 0f 45 80 00 00 	movabs $0x80450f,%rdi
  802194:	00 00 00 
  802197:	b8 00 00 00 00       	mov    $0x0,%eax
  80219c:	49 b8 c7 04 80 00 00 	movabs $0x8004c7,%r8
  8021a3:	00 00 00 
  8021a6:	41 ff d0             	callq  *%r8
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  8021a9:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8021b0:	00 
  8021b1:	e9 40 01 00 00       	jmpq   8022f6 <fork+0x252>
		if(uvpml4e[pml4e] & PTE_P){
  8021b6:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8021bd:	01 00 00 
  8021c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8021c4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021c8:	83 e0 01             	and    $0x1,%eax
  8021cb:	48 85 c0             	test   %rax,%rax
  8021ce:	0f 84 1d 01 00 00    	je     8022f1 <fork+0x24d>
			base_pml4e = pml4e * NPDPENTRIES;
  8021d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021d8:	48 c1 e0 09          	shl    $0x9,%rax
  8021dc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  8021e0:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  8021e7:	00 
  8021e8:	e9 f6 00 00 00       	jmpq   8022e3 <fork+0x23f>
				if(uvpde[base_pml4e + pdpe] & PTE_P){
  8021ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021f1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8021f5:	48 01 c2             	add    %rax,%rdx
  8021f8:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8021ff:	01 00 00 
  802202:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802206:	83 e0 01             	and    $0x1,%eax
  802209:	48 85 c0             	test   %rax,%rax
  80220c:	0f 84 cc 00 00 00    	je     8022de <fork+0x23a>
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
  802212:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802216:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80221a:	48 01 d0             	add    %rdx,%rax
  80221d:	48 c1 e0 09          	shl    $0x9,%rax
  802221:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
					for(pde = 0; pde < NPDENTRIES; pde++){
  802225:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  80222c:	00 
  80222d:	e9 9e 00 00 00       	jmpq   8022d0 <fork+0x22c>
						if(uvpd[base_pdpe + pde] & PTE_P){
  802232:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802236:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80223a:	48 01 c2             	add    %rax,%rdx
  80223d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802244:	01 00 00 
  802247:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80224b:	83 e0 01             	and    $0x1,%eax
  80224e:	48 85 c0             	test   %rax,%rax
  802251:	74 78                	je     8022cb <fork+0x227>
							base_pde = (base_pdpe + pde) * NPTENTRIES;
  802253:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802257:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80225b:	48 01 d0             	add    %rdx,%rax
  80225e:	48 c1 e0 09          	shl    $0x9,%rax
  802262:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
							for(pte = 0; pte < NPTENTRIES; pte++){
  802266:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  80226d:	00 
  80226e:	eb 51                	jmp    8022c1 <fork+0x21d>
								entry = base_pde + pte;
  802270:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802274:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  802278:	48 01 d0             	add    %rdx,%rax
  80227b:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
								if((uvpt[entry] & PTE_P) && (entry != VPN(UXSTACKTOP - PGSIZE))){
  80227f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802286:	01 00 00 
  802289:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80228d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802291:	83 e0 01             	and    $0x1,%eax
  802294:	48 85 c0             	test   %rax,%rax
  802297:	74 23                	je     8022bc <fork+0x218>
  802299:	48 81 7d a8 ff f7 0e 	cmpq   $0xef7ff,-0x58(%rbp)
  8022a0:	00 
  8022a1:	74 19                	je     8022bc <fork+0x218>
									duppage(cid, entry);
  8022a3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8022a7:	89 c2                	mov    %eax,%edx
  8022a9:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8022ac:	89 d6                	mov    %edx,%esi
  8022ae:	89 c7                	mov    %eax,%edi
  8022b0:	48 b8 82 1f 80 00 00 	movabs $0x801f82,%rax
  8022b7:	00 00 00 
  8022ba:	ff d0                	callq  *%rax
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
						if(uvpd[base_pdpe + pde] & PTE_P){
							base_pde = (base_pdpe + pde) * NPTENTRIES;
							for(pte = 0; pte < NPTENTRIES; pte++){
  8022bc:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  8022c1:	48 81 7d d0 ff 01 00 	cmpq   $0x1ff,-0x30(%rbp)
  8022c8:	00 
  8022c9:	76 a5                	jbe    802270 <fork+0x1cc>
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
  8022cb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8022d0:	48 81 7d d8 ff 01 00 	cmpq   $0x1ff,-0x28(%rbp)
  8022d7:	00 
  8022d8:	0f 86 54 ff ff ff    	jbe    802232 <fork+0x18e>
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  8022de:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  8022e3:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  8022ea:	00 
  8022eb:	0f 86 fc fe ff ff    	jbe    8021ed <fork+0x149>
	int result;
	if((result = sys_page_alloc(cid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		panic("fork failed: %e\n", result);
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  8022f1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8022f6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8022fb:	0f 84 b5 fe ff ff    	je     8021b6 <fork+0x112>
					}
				}
			}
		}
	}
	if(sys_env_set_pgfault_upcall(cid, _pgfault_upcall) | sys_env_set_status(cid, ENV_RUNNABLE))
  802301:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802304:	48 be fe 3b 80 00 00 	movabs $0x803bfe,%rsi
  80230b:	00 00 00 
  80230e:	89 c7                	mov    %eax,%edi
  802310:	48 b8 6e 1d 80 00 00 	movabs $0x801d6e,%rax
  802317:	00 00 00 
  80231a:	ff d0                	callq  *%rax
  80231c:	89 c3                	mov    %eax,%ebx
  80231e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802321:	be 02 00 00 00       	mov    $0x2,%esi
  802326:	89 c7                	mov    %eax,%edi
  802328:	48 b8 d9 1c 80 00 00 	movabs $0x801cd9,%rax
  80232f:	00 00 00 
  802332:	ff d0                	callq  *%rax
  802334:	09 d8                	or     %ebx,%eax
  802336:	85 c0                	test   %eax,%eax
  802338:	74 2a                	je     802364 <fork+0x2c0>
		panic("fork failed\n");
  80233a:	48 ba 2b 45 80 00 00 	movabs $0x80452b,%rdx
  802341:	00 00 00 
  802344:	be 92 00 00 00       	mov    $0x92,%esi
  802349:	48 bf 0f 45 80 00 00 	movabs $0x80450f,%rdi
  802350:	00 00 00 
  802353:	b8 00 00 00 00       	mov    $0x0,%eax
  802358:	48 b9 c7 04 80 00 00 	movabs $0x8004c7,%rcx
  80235f:	00 00 00 
  802362:	ff d1                	callq  *%rcx
	return cid;
  802364:	8b 45 cc             	mov    -0x34(%rbp),%eax
	//panic("fork not implemented");
}
  802367:	48 83 c4 58          	add    $0x58,%rsp
  80236b:	5b                   	pop    %rbx
  80236c:	5d                   	pop    %rbp
  80236d:	c3                   	retq   

000000000080236e <sfork>:


// Challenge!
int
sfork(void)
{
  80236e:	55                   	push   %rbp
  80236f:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802372:	48 ba 38 45 80 00 00 	movabs $0x804538,%rdx
  802379:	00 00 00 
  80237c:	be 9c 00 00 00       	mov    $0x9c,%esi
  802381:	48 bf 0f 45 80 00 00 	movabs $0x80450f,%rdi
  802388:	00 00 00 
  80238b:	b8 00 00 00 00       	mov    $0x0,%eax
  802390:	48 b9 c7 04 80 00 00 	movabs $0x8004c7,%rcx
  802397:	00 00 00 
  80239a:	ff d1                	callq  *%rcx

000000000080239c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80239c:	55                   	push   %rbp
  80239d:	48 89 e5             	mov    %rsp,%rbp
  8023a0:	48 83 ec 08          	sub    $0x8,%rsp
  8023a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8023a8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8023ac:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8023b3:	ff ff ff 
  8023b6:	48 01 d0             	add    %rdx,%rax
  8023b9:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8023bd:	c9                   	leaveq 
  8023be:	c3                   	retq   

00000000008023bf <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8023bf:	55                   	push   %rbp
  8023c0:	48 89 e5             	mov    %rsp,%rbp
  8023c3:	48 83 ec 08          	sub    $0x8,%rsp
  8023c7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8023cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023cf:	48 89 c7             	mov    %rax,%rdi
  8023d2:	48 b8 9c 23 80 00 00 	movabs $0x80239c,%rax
  8023d9:	00 00 00 
  8023dc:	ff d0                	callq  *%rax
  8023de:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8023e4:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8023e8:	c9                   	leaveq 
  8023e9:	c3                   	retq   

00000000008023ea <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8023ea:	55                   	push   %rbp
  8023eb:	48 89 e5             	mov    %rsp,%rbp
  8023ee:	48 83 ec 18          	sub    $0x18,%rsp
  8023f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8023f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023fd:	eb 6b                	jmp    80246a <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8023ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802402:	48 98                	cltq   
  802404:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80240a:	48 c1 e0 0c          	shl    $0xc,%rax
  80240e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802412:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802416:	48 c1 e8 15          	shr    $0x15,%rax
  80241a:	48 89 c2             	mov    %rax,%rdx
  80241d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802424:	01 00 00 
  802427:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80242b:	83 e0 01             	and    $0x1,%eax
  80242e:	48 85 c0             	test   %rax,%rax
  802431:	74 21                	je     802454 <fd_alloc+0x6a>
  802433:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802437:	48 c1 e8 0c          	shr    $0xc,%rax
  80243b:	48 89 c2             	mov    %rax,%rdx
  80243e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802445:	01 00 00 
  802448:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80244c:	83 e0 01             	and    $0x1,%eax
  80244f:	48 85 c0             	test   %rax,%rax
  802452:	75 12                	jne    802466 <fd_alloc+0x7c>
			*fd_store = fd;
  802454:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802458:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80245c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80245f:	b8 00 00 00 00       	mov    $0x0,%eax
  802464:	eb 1a                	jmp    802480 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802466:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80246a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80246e:	7e 8f                	jle    8023ff <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802470:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802474:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80247b:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802480:	c9                   	leaveq 
  802481:	c3                   	retq   

0000000000802482 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802482:	55                   	push   %rbp
  802483:	48 89 e5             	mov    %rsp,%rbp
  802486:	48 83 ec 20          	sub    $0x20,%rsp
  80248a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80248d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802491:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802495:	78 06                	js     80249d <fd_lookup+0x1b>
  802497:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80249b:	7e 07                	jle    8024a4 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80249d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024a2:	eb 6c                	jmp    802510 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8024a4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024a7:	48 98                	cltq   
  8024a9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8024af:	48 c1 e0 0c          	shl    $0xc,%rax
  8024b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8024b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024bb:	48 c1 e8 15          	shr    $0x15,%rax
  8024bf:	48 89 c2             	mov    %rax,%rdx
  8024c2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024c9:	01 00 00 
  8024cc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024d0:	83 e0 01             	and    $0x1,%eax
  8024d3:	48 85 c0             	test   %rax,%rax
  8024d6:	74 21                	je     8024f9 <fd_lookup+0x77>
  8024d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024dc:	48 c1 e8 0c          	shr    $0xc,%rax
  8024e0:	48 89 c2             	mov    %rax,%rdx
  8024e3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024ea:	01 00 00 
  8024ed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024f1:	83 e0 01             	and    $0x1,%eax
  8024f4:	48 85 c0             	test   %rax,%rax
  8024f7:	75 07                	jne    802500 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8024f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024fe:	eb 10                	jmp    802510 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802500:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802504:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802508:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80250b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802510:	c9                   	leaveq 
  802511:	c3                   	retq   

0000000000802512 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802512:	55                   	push   %rbp
  802513:	48 89 e5             	mov    %rsp,%rbp
  802516:	48 83 ec 30          	sub    $0x30,%rsp
  80251a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80251e:	89 f0                	mov    %esi,%eax
  802520:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802523:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802527:	48 89 c7             	mov    %rax,%rdi
  80252a:	48 b8 9c 23 80 00 00 	movabs $0x80239c,%rax
  802531:	00 00 00 
  802534:	ff d0                	callq  *%rax
  802536:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80253a:	48 89 d6             	mov    %rdx,%rsi
  80253d:	89 c7                	mov    %eax,%edi
  80253f:	48 b8 82 24 80 00 00 	movabs $0x802482,%rax
  802546:	00 00 00 
  802549:	ff d0                	callq  *%rax
  80254b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80254e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802552:	78 0a                	js     80255e <fd_close+0x4c>
	    || fd != fd2)
  802554:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802558:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80255c:	74 12                	je     802570 <fd_close+0x5e>
		return (must_exist ? r : 0);
  80255e:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802562:	74 05                	je     802569 <fd_close+0x57>
  802564:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802567:	eb 05                	jmp    80256e <fd_close+0x5c>
  802569:	b8 00 00 00 00       	mov    $0x0,%eax
  80256e:	eb 69                	jmp    8025d9 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802570:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802574:	8b 00                	mov    (%rax),%eax
  802576:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80257a:	48 89 d6             	mov    %rdx,%rsi
  80257d:	89 c7                	mov    %eax,%edi
  80257f:	48 b8 db 25 80 00 00 	movabs $0x8025db,%rax
  802586:	00 00 00 
  802589:	ff d0                	callq  *%rax
  80258b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80258e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802592:	78 2a                	js     8025be <fd_close+0xac>
		if (dev->dev_close)
  802594:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802598:	48 8b 40 20          	mov    0x20(%rax),%rax
  80259c:	48 85 c0             	test   %rax,%rax
  80259f:	74 16                	je     8025b7 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8025a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025a5:	48 8b 40 20          	mov    0x20(%rax),%rax
  8025a9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8025ad:	48 89 d7             	mov    %rdx,%rdi
  8025b0:	ff d0                	callq  *%rax
  8025b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025b5:	eb 07                	jmp    8025be <fd_close+0xac>
		else
			r = 0;
  8025b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8025be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025c2:	48 89 c6             	mov    %rax,%rsi
  8025c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8025ca:	48 b8 8f 1c 80 00 00 	movabs $0x801c8f,%rax
  8025d1:	00 00 00 
  8025d4:	ff d0                	callq  *%rax
	return r;
  8025d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8025d9:	c9                   	leaveq 
  8025da:	c3                   	retq   

00000000008025db <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8025db:	55                   	push   %rbp
  8025dc:	48 89 e5             	mov    %rsp,%rbp
  8025df:	48 83 ec 20          	sub    $0x20,%rsp
  8025e3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025e6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8025ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025f1:	eb 41                	jmp    802634 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8025f3:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8025fa:	00 00 00 
  8025fd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802600:	48 63 d2             	movslq %edx,%rdx
  802603:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802607:	8b 00                	mov    (%rax),%eax
  802609:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80260c:	75 22                	jne    802630 <dev_lookup+0x55>
			*dev = devtab[i];
  80260e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802615:	00 00 00 
  802618:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80261b:	48 63 d2             	movslq %edx,%rdx
  80261e:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802622:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802626:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802629:	b8 00 00 00 00       	mov    $0x0,%eax
  80262e:	eb 60                	jmp    802690 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802630:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802634:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80263b:	00 00 00 
  80263e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802641:	48 63 d2             	movslq %edx,%rdx
  802644:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802648:	48 85 c0             	test   %rax,%rax
  80264b:	75 a6                	jne    8025f3 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80264d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802654:	00 00 00 
  802657:	48 8b 00             	mov    (%rax),%rax
  80265a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802660:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802663:	89 c6                	mov    %eax,%esi
  802665:	48 bf 50 45 80 00 00 	movabs $0x804550,%rdi
  80266c:	00 00 00 
  80266f:	b8 00 00 00 00       	mov    $0x0,%eax
  802674:	48 b9 00 07 80 00 00 	movabs $0x800700,%rcx
  80267b:	00 00 00 
  80267e:	ff d1                	callq  *%rcx
	*dev = 0;
  802680:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802684:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80268b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802690:	c9                   	leaveq 
  802691:	c3                   	retq   

0000000000802692 <close>:

int
close(int fdnum)
{
  802692:	55                   	push   %rbp
  802693:	48 89 e5             	mov    %rsp,%rbp
  802696:	48 83 ec 20          	sub    $0x20,%rsp
  80269a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80269d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026a1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026a4:	48 89 d6             	mov    %rdx,%rsi
  8026a7:	89 c7                	mov    %eax,%edi
  8026a9:	48 b8 82 24 80 00 00 	movabs $0x802482,%rax
  8026b0:	00 00 00 
  8026b3:	ff d0                	callq  *%rax
  8026b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026bc:	79 05                	jns    8026c3 <close+0x31>
		return r;
  8026be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026c1:	eb 18                	jmp    8026db <close+0x49>
	else
		return fd_close(fd, 1);
  8026c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026c7:	be 01 00 00 00       	mov    $0x1,%esi
  8026cc:	48 89 c7             	mov    %rax,%rdi
  8026cf:	48 b8 12 25 80 00 00 	movabs $0x802512,%rax
  8026d6:	00 00 00 
  8026d9:	ff d0                	callq  *%rax
}
  8026db:	c9                   	leaveq 
  8026dc:	c3                   	retq   

00000000008026dd <close_all>:

void
close_all(void)
{
  8026dd:	55                   	push   %rbp
  8026de:	48 89 e5             	mov    %rsp,%rbp
  8026e1:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8026e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026ec:	eb 15                	jmp    802703 <close_all+0x26>
		close(i);
  8026ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026f1:	89 c7                	mov    %eax,%edi
  8026f3:	48 b8 92 26 80 00 00 	movabs $0x802692,%rax
  8026fa:	00 00 00 
  8026fd:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8026ff:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802703:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802707:	7e e5                	jle    8026ee <close_all+0x11>
		close(i);
}
  802709:	c9                   	leaveq 
  80270a:	c3                   	retq   

000000000080270b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80270b:	55                   	push   %rbp
  80270c:	48 89 e5             	mov    %rsp,%rbp
  80270f:	48 83 ec 40          	sub    $0x40,%rsp
  802713:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802716:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802719:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80271d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802720:	48 89 d6             	mov    %rdx,%rsi
  802723:	89 c7                	mov    %eax,%edi
  802725:	48 b8 82 24 80 00 00 	movabs $0x802482,%rax
  80272c:	00 00 00 
  80272f:	ff d0                	callq  *%rax
  802731:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802734:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802738:	79 08                	jns    802742 <dup+0x37>
		return r;
  80273a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80273d:	e9 70 01 00 00       	jmpq   8028b2 <dup+0x1a7>
	close(newfdnum);
  802742:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802745:	89 c7                	mov    %eax,%edi
  802747:	48 b8 92 26 80 00 00 	movabs $0x802692,%rax
  80274e:	00 00 00 
  802751:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802753:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802756:	48 98                	cltq   
  802758:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80275e:	48 c1 e0 0c          	shl    $0xc,%rax
  802762:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802766:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80276a:	48 89 c7             	mov    %rax,%rdi
  80276d:	48 b8 bf 23 80 00 00 	movabs $0x8023bf,%rax
  802774:	00 00 00 
  802777:	ff d0                	callq  *%rax
  802779:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80277d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802781:	48 89 c7             	mov    %rax,%rdi
  802784:	48 b8 bf 23 80 00 00 	movabs $0x8023bf,%rax
  80278b:	00 00 00 
  80278e:	ff d0                	callq  *%rax
  802790:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802794:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802798:	48 c1 e8 15          	shr    $0x15,%rax
  80279c:	48 89 c2             	mov    %rax,%rdx
  80279f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8027a6:	01 00 00 
  8027a9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027ad:	83 e0 01             	and    $0x1,%eax
  8027b0:	48 85 c0             	test   %rax,%rax
  8027b3:	74 73                	je     802828 <dup+0x11d>
  8027b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b9:	48 c1 e8 0c          	shr    $0xc,%rax
  8027bd:	48 89 c2             	mov    %rax,%rdx
  8027c0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027c7:	01 00 00 
  8027ca:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027ce:	83 e0 01             	and    $0x1,%eax
  8027d1:	48 85 c0             	test   %rax,%rax
  8027d4:	74 52                	je     802828 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8027d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027da:	48 c1 e8 0c          	shr    $0xc,%rax
  8027de:	48 89 c2             	mov    %rax,%rdx
  8027e1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027e8:	01 00 00 
  8027eb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027ef:	25 07 0e 00 00       	and    $0xe07,%eax
  8027f4:	89 c1                	mov    %eax,%ecx
  8027f6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8027fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027fe:	41 89 c8             	mov    %ecx,%r8d
  802801:	48 89 d1             	mov    %rdx,%rcx
  802804:	ba 00 00 00 00       	mov    $0x0,%edx
  802809:	48 89 c6             	mov    %rax,%rsi
  80280c:	bf 00 00 00 00       	mov    $0x0,%edi
  802811:	48 b8 34 1c 80 00 00 	movabs $0x801c34,%rax
  802818:	00 00 00 
  80281b:	ff d0                	callq  *%rax
  80281d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802820:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802824:	79 02                	jns    802828 <dup+0x11d>
			goto err;
  802826:	eb 57                	jmp    80287f <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802828:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80282c:	48 c1 e8 0c          	shr    $0xc,%rax
  802830:	48 89 c2             	mov    %rax,%rdx
  802833:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80283a:	01 00 00 
  80283d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802841:	25 07 0e 00 00       	and    $0xe07,%eax
  802846:	89 c1                	mov    %eax,%ecx
  802848:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80284c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802850:	41 89 c8             	mov    %ecx,%r8d
  802853:	48 89 d1             	mov    %rdx,%rcx
  802856:	ba 00 00 00 00       	mov    $0x0,%edx
  80285b:	48 89 c6             	mov    %rax,%rsi
  80285e:	bf 00 00 00 00       	mov    $0x0,%edi
  802863:	48 b8 34 1c 80 00 00 	movabs $0x801c34,%rax
  80286a:	00 00 00 
  80286d:	ff d0                	callq  *%rax
  80286f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802872:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802876:	79 02                	jns    80287a <dup+0x16f>
		goto err;
  802878:	eb 05                	jmp    80287f <dup+0x174>

	return newfdnum;
  80287a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80287d:	eb 33                	jmp    8028b2 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80287f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802883:	48 89 c6             	mov    %rax,%rsi
  802886:	bf 00 00 00 00       	mov    $0x0,%edi
  80288b:	48 b8 8f 1c 80 00 00 	movabs $0x801c8f,%rax
  802892:	00 00 00 
  802895:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802897:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80289b:	48 89 c6             	mov    %rax,%rsi
  80289e:	bf 00 00 00 00       	mov    $0x0,%edi
  8028a3:	48 b8 8f 1c 80 00 00 	movabs $0x801c8f,%rax
  8028aa:	00 00 00 
  8028ad:	ff d0                	callq  *%rax
	return r;
  8028af:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8028b2:	c9                   	leaveq 
  8028b3:	c3                   	retq   

00000000008028b4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8028b4:	55                   	push   %rbp
  8028b5:	48 89 e5             	mov    %rsp,%rbp
  8028b8:	48 83 ec 40          	sub    $0x40,%rsp
  8028bc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028bf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8028c3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8028c7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028cb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028ce:	48 89 d6             	mov    %rdx,%rsi
  8028d1:	89 c7                	mov    %eax,%edi
  8028d3:	48 b8 82 24 80 00 00 	movabs $0x802482,%rax
  8028da:	00 00 00 
  8028dd:	ff d0                	callq  *%rax
  8028df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028e6:	78 24                	js     80290c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8028e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ec:	8b 00                	mov    (%rax),%eax
  8028ee:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028f2:	48 89 d6             	mov    %rdx,%rsi
  8028f5:	89 c7                	mov    %eax,%edi
  8028f7:	48 b8 db 25 80 00 00 	movabs $0x8025db,%rax
  8028fe:	00 00 00 
  802901:	ff d0                	callq  *%rax
  802903:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802906:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80290a:	79 05                	jns    802911 <read+0x5d>
		return r;
  80290c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80290f:	eb 76                	jmp    802987 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802911:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802915:	8b 40 08             	mov    0x8(%rax),%eax
  802918:	83 e0 03             	and    $0x3,%eax
  80291b:	83 f8 01             	cmp    $0x1,%eax
  80291e:	75 3a                	jne    80295a <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802920:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802927:	00 00 00 
  80292a:	48 8b 00             	mov    (%rax),%rax
  80292d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802933:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802936:	89 c6                	mov    %eax,%esi
  802938:	48 bf 6f 45 80 00 00 	movabs $0x80456f,%rdi
  80293f:	00 00 00 
  802942:	b8 00 00 00 00       	mov    $0x0,%eax
  802947:	48 b9 00 07 80 00 00 	movabs $0x800700,%rcx
  80294e:	00 00 00 
  802951:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802953:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802958:	eb 2d                	jmp    802987 <read+0xd3>
	}
	if (!dev->dev_read)
  80295a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80295e:	48 8b 40 10          	mov    0x10(%rax),%rax
  802962:	48 85 c0             	test   %rax,%rax
  802965:	75 07                	jne    80296e <read+0xba>
		return -E_NOT_SUPP;
  802967:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80296c:	eb 19                	jmp    802987 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80296e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802972:	48 8b 40 10          	mov    0x10(%rax),%rax
  802976:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80297a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80297e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802982:	48 89 cf             	mov    %rcx,%rdi
  802985:	ff d0                	callq  *%rax
}
  802987:	c9                   	leaveq 
  802988:	c3                   	retq   

0000000000802989 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802989:	55                   	push   %rbp
  80298a:	48 89 e5             	mov    %rsp,%rbp
  80298d:	48 83 ec 30          	sub    $0x30,%rsp
  802991:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802994:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802998:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80299c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8029a3:	eb 49                	jmp    8029ee <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8029a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029a8:	48 98                	cltq   
  8029aa:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029ae:	48 29 c2             	sub    %rax,%rdx
  8029b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029b4:	48 63 c8             	movslq %eax,%rcx
  8029b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029bb:	48 01 c1             	add    %rax,%rcx
  8029be:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029c1:	48 89 ce             	mov    %rcx,%rsi
  8029c4:	89 c7                	mov    %eax,%edi
  8029c6:	48 b8 b4 28 80 00 00 	movabs $0x8028b4,%rax
  8029cd:	00 00 00 
  8029d0:	ff d0                	callq  *%rax
  8029d2:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8029d5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8029d9:	79 05                	jns    8029e0 <readn+0x57>
			return m;
  8029db:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029de:	eb 1c                	jmp    8029fc <readn+0x73>
		if (m == 0)
  8029e0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8029e4:	75 02                	jne    8029e8 <readn+0x5f>
			break;
  8029e6:	eb 11                	jmp    8029f9 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8029e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029eb:	01 45 fc             	add    %eax,-0x4(%rbp)
  8029ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029f1:	48 98                	cltq   
  8029f3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8029f7:	72 ac                	jb     8029a5 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8029f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029fc:	c9                   	leaveq 
  8029fd:	c3                   	retq   

00000000008029fe <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8029fe:	55                   	push   %rbp
  8029ff:	48 89 e5             	mov    %rsp,%rbp
  802a02:	48 83 ec 40          	sub    $0x40,%rsp
  802a06:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a09:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a0d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a11:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a15:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a18:	48 89 d6             	mov    %rdx,%rsi
  802a1b:	89 c7                	mov    %eax,%edi
  802a1d:	48 b8 82 24 80 00 00 	movabs $0x802482,%rax
  802a24:	00 00 00 
  802a27:	ff d0                	callq  *%rax
  802a29:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a30:	78 24                	js     802a56 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a36:	8b 00                	mov    (%rax),%eax
  802a38:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a3c:	48 89 d6             	mov    %rdx,%rsi
  802a3f:	89 c7                	mov    %eax,%edi
  802a41:	48 b8 db 25 80 00 00 	movabs $0x8025db,%rax
  802a48:	00 00 00 
  802a4b:	ff d0                	callq  *%rax
  802a4d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a50:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a54:	79 05                	jns    802a5b <write+0x5d>
		return r;
  802a56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a59:	eb 75                	jmp    802ad0 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a5f:	8b 40 08             	mov    0x8(%rax),%eax
  802a62:	83 e0 03             	and    $0x3,%eax
  802a65:	85 c0                	test   %eax,%eax
  802a67:	75 3a                	jne    802aa3 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802a69:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802a70:	00 00 00 
  802a73:	48 8b 00             	mov    (%rax),%rax
  802a76:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a7c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a7f:	89 c6                	mov    %eax,%esi
  802a81:	48 bf 8b 45 80 00 00 	movabs $0x80458b,%rdi
  802a88:	00 00 00 
  802a8b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a90:	48 b9 00 07 80 00 00 	movabs $0x800700,%rcx
  802a97:	00 00 00 
  802a9a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a9c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802aa1:	eb 2d                	jmp    802ad0 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802aa3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aa7:	48 8b 40 18          	mov    0x18(%rax),%rax
  802aab:	48 85 c0             	test   %rax,%rax
  802aae:	75 07                	jne    802ab7 <write+0xb9>
		return -E_NOT_SUPP;
  802ab0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ab5:	eb 19                	jmp    802ad0 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802ab7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802abb:	48 8b 40 18          	mov    0x18(%rax),%rax
  802abf:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802ac3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ac7:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802acb:	48 89 cf             	mov    %rcx,%rdi
  802ace:	ff d0                	callq  *%rax
}
  802ad0:	c9                   	leaveq 
  802ad1:	c3                   	retq   

0000000000802ad2 <seek>:

int
seek(int fdnum, off_t offset)
{
  802ad2:	55                   	push   %rbp
  802ad3:	48 89 e5             	mov    %rsp,%rbp
  802ad6:	48 83 ec 18          	sub    $0x18,%rsp
  802ada:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802add:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ae0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ae4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ae7:	48 89 d6             	mov    %rdx,%rsi
  802aea:	89 c7                	mov    %eax,%edi
  802aec:	48 b8 82 24 80 00 00 	movabs $0x802482,%rax
  802af3:	00 00 00 
  802af6:	ff d0                	callq  *%rax
  802af8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802afb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aff:	79 05                	jns    802b06 <seek+0x34>
		return r;
  802b01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b04:	eb 0f                	jmp    802b15 <seek+0x43>
	fd->fd_offset = offset;
  802b06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b0a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802b0d:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802b10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b15:	c9                   	leaveq 
  802b16:	c3                   	retq   

0000000000802b17 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802b17:	55                   	push   %rbp
  802b18:	48 89 e5             	mov    %rsp,%rbp
  802b1b:	48 83 ec 30          	sub    $0x30,%rsp
  802b1f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b22:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b25:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b29:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b2c:	48 89 d6             	mov    %rdx,%rsi
  802b2f:	89 c7                	mov    %eax,%edi
  802b31:	48 b8 82 24 80 00 00 	movabs $0x802482,%rax
  802b38:	00 00 00 
  802b3b:	ff d0                	callq  *%rax
  802b3d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b40:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b44:	78 24                	js     802b6a <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b4a:	8b 00                	mov    (%rax),%eax
  802b4c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b50:	48 89 d6             	mov    %rdx,%rsi
  802b53:	89 c7                	mov    %eax,%edi
  802b55:	48 b8 db 25 80 00 00 	movabs $0x8025db,%rax
  802b5c:	00 00 00 
  802b5f:	ff d0                	callq  *%rax
  802b61:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b64:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b68:	79 05                	jns    802b6f <ftruncate+0x58>
		return r;
  802b6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b6d:	eb 72                	jmp    802be1 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b73:	8b 40 08             	mov    0x8(%rax),%eax
  802b76:	83 e0 03             	and    $0x3,%eax
  802b79:	85 c0                	test   %eax,%eax
  802b7b:	75 3a                	jne    802bb7 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802b7d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802b84:	00 00 00 
  802b87:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802b8a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b90:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b93:	89 c6                	mov    %eax,%esi
  802b95:	48 bf a8 45 80 00 00 	movabs $0x8045a8,%rdi
  802b9c:	00 00 00 
  802b9f:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba4:	48 b9 00 07 80 00 00 	movabs $0x800700,%rcx
  802bab:	00 00 00 
  802bae:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802bb0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bb5:	eb 2a                	jmp    802be1 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802bb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bbb:	48 8b 40 30          	mov    0x30(%rax),%rax
  802bbf:	48 85 c0             	test   %rax,%rax
  802bc2:	75 07                	jne    802bcb <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802bc4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802bc9:	eb 16                	jmp    802be1 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802bcb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bcf:	48 8b 40 30          	mov    0x30(%rax),%rax
  802bd3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bd7:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802bda:	89 ce                	mov    %ecx,%esi
  802bdc:	48 89 d7             	mov    %rdx,%rdi
  802bdf:	ff d0                	callq  *%rax
}
  802be1:	c9                   	leaveq 
  802be2:	c3                   	retq   

0000000000802be3 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802be3:	55                   	push   %rbp
  802be4:	48 89 e5             	mov    %rsp,%rbp
  802be7:	48 83 ec 30          	sub    $0x30,%rsp
  802beb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802bee:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802bf2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bf6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bf9:	48 89 d6             	mov    %rdx,%rsi
  802bfc:	89 c7                	mov    %eax,%edi
  802bfe:	48 b8 82 24 80 00 00 	movabs $0x802482,%rax
  802c05:	00 00 00 
  802c08:	ff d0                	callq  *%rax
  802c0a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c0d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c11:	78 24                	js     802c37 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c17:	8b 00                	mov    (%rax),%eax
  802c19:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c1d:	48 89 d6             	mov    %rdx,%rsi
  802c20:	89 c7                	mov    %eax,%edi
  802c22:	48 b8 db 25 80 00 00 	movabs $0x8025db,%rax
  802c29:	00 00 00 
  802c2c:	ff d0                	callq  *%rax
  802c2e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c31:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c35:	79 05                	jns    802c3c <fstat+0x59>
		return r;
  802c37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c3a:	eb 5e                	jmp    802c9a <fstat+0xb7>
	if (!dev->dev_stat)
  802c3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c40:	48 8b 40 28          	mov    0x28(%rax),%rax
  802c44:	48 85 c0             	test   %rax,%rax
  802c47:	75 07                	jne    802c50 <fstat+0x6d>
		return -E_NOT_SUPP;
  802c49:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c4e:	eb 4a                	jmp    802c9a <fstat+0xb7>
	stat->st_name[0] = 0;
  802c50:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c54:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802c57:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c5b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802c62:	00 00 00 
	stat->st_isdir = 0;
  802c65:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c69:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802c70:	00 00 00 
	stat->st_dev = dev;
  802c73:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c77:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c7b:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802c82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c86:	48 8b 40 28          	mov    0x28(%rax),%rax
  802c8a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c8e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802c92:	48 89 ce             	mov    %rcx,%rsi
  802c95:	48 89 d7             	mov    %rdx,%rdi
  802c98:	ff d0                	callq  *%rax
}
  802c9a:	c9                   	leaveq 
  802c9b:	c3                   	retq   

0000000000802c9c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802c9c:	55                   	push   %rbp
  802c9d:	48 89 e5             	mov    %rsp,%rbp
  802ca0:	48 83 ec 20          	sub    $0x20,%rsp
  802ca4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ca8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802cac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cb0:	be 00 00 00 00       	mov    $0x0,%esi
  802cb5:	48 89 c7             	mov    %rax,%rdi
  802cb8:	48 b8 8a 2d 80 00 00 	movabs $0x802d8a,%rax
  802cbf:	00 00 00 
  802cc2:	ff d0                	callq  *%rax
  802cc4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cc7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ccb:	79 05                	jns    802cd2 <stat+0x36>
		return fd;
  802ccd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cd0:	eb 2f                	jmp    802d01 <stat+0x65>
	r = fstat(fd, stat);
  802cd2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802cd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cd9:	48 89 d6             	mov    %rdx,%rsi
  802cdc:	89 c7                	mov    %eax,%edi
  802cde:	48 b8 e3 2b 80 00 00 	movabs $0x802be3,%rax
  802ce5:	00 00 00 
  802ce8:	ff d0                	callq  *%rax
  802cea:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802ced:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cf0:	89 c7                	mov    %eax,%edi
  802cf2:	48 b8 92 26 80 00 00 	movabs $0x802692,%rax
  802cf9:	00 00 00 
  802cfc:	ff d0                	callq  *%rax
	return r;
  802cfe:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802d01:	c9                   	leaveq 
  802d02:	c3                   	retq   

0000000000802d03 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802d03:	55                   	push   %rbp
  802d04:	48 89 e5             	mov    %rsp,%rbp
  802d07:	48 83 ec 10          	sub    $0x10,%rsp
  802d0b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802d0e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802d12:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802d19:	00 00 00 
  802d1c:	8b 00                	mov    (%rax),%eax
  802d1e:	85 c0                	test   %eax,%eax
  802d20:	75 1d                	jne    802d3f <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802d22:	bf 01 00 00 00       	mov    $0x1,%edi
  802d27:	48 b8 eb 3d 80 00 00 	movabs $0x803deb,%rax
  802d2e:	00 00 00 
  802d31:	ff d0                	callq  *%rax
  802d33:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802d3a:	00 00 00 
  802d3d:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802d3f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802d46:	00 00 00 
  802d49:	8b 00                	mov    (%rax),%eax
  802d4b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802d4e:	b9 07 00 00 00       	mov    $0x7,%ecx
  802d53:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802d5a:	00 00 00 
  802d5d:	89 c7                	mov    %eax,%edi
  802d5f:	48 b8 4e 3d 80 00 00 	movabs $0x803d4e,%rax
  802d66:	00 00 00 
  802d69:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802d6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d6f:	ba 00 00 00 00       	mov    $0x0,%edx
  802d74:	48 89 c6             	mov    %rax,%rsi
  802d77:	bf 00 00 00 00       	mov    $0x0,%edi
  802d7c:	48 b8 88 3c 80 00 00 	movabs $0x803c88,%rax
  802d83:	00 00 00 
  802d86:	ff d0                	callq  *%rax
}
  802d88:	c9                   	leaveq 
  802d89:	c3                   	retq   

0000000000802d8a <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802d8a:	55                   	push   %rbp
  802d8b:	48 89 e5             	mov    %rsp,%rbp
  802d8e:	48 83 ec 20          	sub    $0x20,%rsp
  802d92:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d96:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  802d99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d9d:	48 89 c7             	mov    %rax,%rdi
  802da0:	48 b8 49 12 80 00 00 	movabs $0x801249,%rax
  802da7:	00 00 00 
  802daa:	ff d0                	callq  *%rax
  802dac:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802db1:	7e 0a                	jle    802dbd <open+0x33>
  802db3:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802db8:	e9 a5 00 00 00       	jmpq   802e62 <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  802dbd:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802dc1:	48 89 c7             	mov    %rax,%rdi
  802dc4:	48 b8 ea 23 80 00 00 	movabs $0x8023ea,%rax
  802dcb:	00 00 00 
  802dce:	ff d0                	callq  *%rax
  802dd0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dd3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dd7:	79 08                	jns    802de1 <open+0x57>
		return r;
  802dd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ddc:	e9 81 00 00 00       	jmpq   802e62 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  802de1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802de8:	00 00 00 
  802deb:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802dee:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  802df4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802df8:	48 89 c6             	mov    %rax,%rsi
  802dfb:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802e02:	00 00 00 
  802e05:	48 b8 b5 12 80 00 00 	movabs $0x8012b5,%rax
  802e0c:	00 00 00 
  802e0f:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  802e11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e15:	48 89 c6             	mov    %rax,%rsi
  802e18:	bf 01 00 00 00       	mov    $0x1,%edi
  802e1d:	48 b8 03 2d 80 00 00 	movabs $0x802d03,%rax
  802e24:	00 00 00 
  802e27:	ff d0                	callq  *%rax
  802e29:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e30:	79 1d                	jns    802e4f <open+0xc5>
		fd_close(fd, 0);
  802e32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e36:	be 00 00 00 00       	mov    $0x0,%esi
  802e3b:	48 89 c7             	mov    %rax,%rdi
  802e3e:	48 b8 12 25 80 00 00 	movabs $0x802512,%rax
  802e45:	00 00 00 
  802e48:	ff d0                	callq  *%rax
		return r;
  802e4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e4d:	eb 13                	jmp    802e62 <open+0xd8>
	}
	return fd2num(fd);
  802e4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e53:	48 89 c7             	mov    %rax,%rdi
  802e56:	48 b8 9c 23 80 00 00 	movabs $0x80239c,%rax
  802e5d:	00 00 00 
  802e60:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  802e62:	c9                   	leaveq 
  802e63:	c3                   	retq   

0000000000802e64 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802e64:	55                   	push   %rbp
  802e65:	48 89 e5             	mov    %rsp,%rbp
  802e68:	48 83 ec 10          	sub    $0x10,%rsp
  802e6c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802e70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e74:	8b 50 0c             	mov    0xc(%rax),%edx
  802e77:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e7e:	00 00 00 
  802e81:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802e83:	be 00 00 00 00       	mov    $0x0,%esi
  802e88:	bf 06 00 00 00       	mov    $0x6,%edi
  802e8d:	48 b8 03 2d 80 00 00 	movabs $0x802d03,%rax
  802e94:	00 00 00 
  802e97:	ff d0                	callq  *%rax
}
  802e99:	c9                   	leaveq 
  802e9a:	c3                   	retq   

0000000000802e9b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802e9b:	55                   	push   %rbp
  802e9c:	48 89 e5             	mov    %rsp,%rbp
  802e9f:	48 83 ec 30          	sub    $0x30,%rsp
  802ea3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ea7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802eab:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802eaf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eb3:	8b 50 0c             	mov    0xc(%rax),%edx
  802eb6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ebd:	00 00 00 
  802ec0:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802ec2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ec9:	00 00 00 
  802ecc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ed0:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  802ed4:	be 00 00 00 00       	mov    $0x0,%esi
  802ed9:	bf 03 00 00 00       	mov    $0x3,%edi
  802ede:	48 b8 03 2d 80 00 00 	movabs $0x802d03,%rax
  802ee5:	00 00 00 
  802ee8:	ff d0                	callq  *%rax
  802eea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ef1:	79 05                	jns    802ef8 <devfile_read+0x5d>
		return r;
  802ef3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ef6:	eb 26                	jmp    802f1e <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  802ef8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802efb:	48 63 d0             	movslq %eax,%rdx
  802efe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f02:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802f09:	00 00 00 
  802f0c:	48 89 c7             	mov    %rax,%rdi
  802f0f:	48 b8 f0 16 80 00 00 	movabs $0x8016f0,%rax
  802f16:	00 00 00 
  802f19:	ff d0                	callq  *%rax
	return r;
  802f1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802f1e:	c9                   	leaveq 
  802f1f:	c3                   	retq   

0000000000802f20 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802f20:	55                   	push   %rbp
  802f21:	48 89 e5             	mov    %rsp,%rbp
  802f24:	48 83 ec 30          	sub    $0x30,%rsp
  802f28:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f2c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f30:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  802f34:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  802f3b:	00 
	n = n > max ? max : n;
  802f3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f40:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802f44:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  802f49:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802f4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f51:	8b 50 0c             	mov    0xc(%rax),%edx
  802f54:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f5b:	00 00 00 
  802f5e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802f60:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f67:	00 00 00 
  802f6a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f6e:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802f72:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f76:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f7a:	48 89 c6             	mov    %rax,%rsi
  802f7d:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802f84:	00 00 00 
  802f87:	48 b8 f0 16 80 00 00 	movabs $0x8016f0,%rax
  802f8e:	00 00 00 
  802f91:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  802f93:	be 00 00 00 00       	mov    $0x0,%esi
  802f98:	bf 04 00 00 00       	mov    $0x4,%edi
  802f9d:	48 b8 03 2d 80 00 00 	movabs $0x802d03,%rax
  802fa4:	00 00 00 
  802fa7:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  802fa9:	c9                   	leaveq 
  802faa:	c3                   	retq   

0000000000802fab <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802fab:	55                   	push   %rbp
  802fac:	48 89 e5             	mov    %rsp,%rbp
  802faf:	48 83 ec 20          	sub    $0x20,%rsp
  802fb3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fb7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802fbb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fbf:	8b 50 0c             	mov    0xc(%rax),%edx
  802fc2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fc9:	00 00 00 
  802fcc:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802fce:	be 00 00 00 00       	mov    $0x0,%esi
  802fd3:	bf 05 00 00 00       	mov    $0x5,%edi
  802fd8:	48 b8 03 2d 80 00 00 	movabs $0x802d03,%rax
  802fdf:	00 00 00 
  802fe2:	ff d0                	callq  *%rax
  802fe4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fe7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802feb:	79 05                	jns    802ff2 <devfile_stat+0x47>
		return r;
  802fed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ff0:	eb 56                	jmp    803048 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802ff2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ff6:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802ffd:	00 00 00 
  803000:	48 89 c7             	mov    %rax,%rdi
  803003:	48 b8 b5 12 80 00 00 	movabs $0x8012b5,%rax
  80300a:	00 00 00 
  80300d:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80300f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803016:	00 00 00 
  803019:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80301f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803023:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803029:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803030:	00 00 00 
  803033:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803039:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80303d:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803043:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803048:	c9                   	leaveq 
  803049:	c3                   	retq   

000000000080304a <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80304a:	55                   	push   %rbp
  80304b:	48 89 e5             	mov    %rsp,%rbp
  80304e:	48 83 ec 10          	sub    $0x10,%rsp
  803052:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803056:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803059:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80305d:	8b 50 0c             	mov    0xc(%rax),%edx
  803060:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803067:	00 00 00 
  80306a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80306c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803073:	00 00 00 
  803076:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803079:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80307c:	be 00 00 00 00       	mov    $0x0,%esi
  803081:	bf 02 00 00 00       	mov    $0x2,%edi
  803086:	48 b8 03 2d 80 00 00 	movabs $0x802d03,%rax
  80308d:	00 00 00 
  803090:	ff d0                	callq  *%rax
}
  803092:	c9                   	leaveq 
  803093:	c3                   	retq   

0000000000803094 <remove>:

// Delete a file
int
remove(const char *path)
{
  803094:	55                   	push   %rbp
  803095:	48 89 e5             	mov    %rsp,%rbp
  803098:	48 83 ec 10          	sub    $0x10,%rsp
  80309c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8030a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030a4:	48 89 c7             	mov    %rax,%rdi
  8030a7:	48 b8 49 12 80 00 00 	movabs $0x801249,%rax
  8030ae:	00 00 00 
  8030b1:	ff d0                	callq  *%rax
  8030b3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8030b8:	7e 07                	jle    8030c1 <remove+0x2d>
		return -E_BAD_PATH;
  8030ba:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8030bf:	eb 33                	jmp    8030f4 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8030c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030c5:	48 89 c6             	mov    %rax,%rsi
  8030c8:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8030cf:	00 00 00 
  8030d2:	48 b8 b5 12 80 00 00 	movabs $0x8012b5,%rax
  8030d9:	00 00 00 
  8030dc:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8030de:	be 00 00 00 00       	mov    $0x0,%esi
  8030e3:	bf 07 00 00 00       	mov    $0x7,%edi
  8030e8:	48 b8 03 2d 80 00 00 	movabs $0x802d03,%rax
  8030ef:	00 00 00 
  8030f2:	ff d0                	callq  *%rax
}
  8030f4:	c9                   	leaveq 
  8030f5:	c3                   	retq   

00000000008030f6 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8030f6:	55                   	push   %rbp
  8030f7:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8030fa:	be 00 00 00 00       	mov    $0x0,%esi
  8030ff:	bf 08 00 00 00       	mov    $0x8,%edi
  803104:	48 b8 03 2d 80 00 00 	movabs $0x802d03,%rax
  80310b:	00 00 00 
  80310e:	ff d0                	callq  *%rax
}
  803110:	5d                   	pop    %rbp
  803111:	c3                   	retq   

0000000000803112 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803112:	55                   	push   %rbp
  803113:	48 89 e5             	mov    %rsp,%rbp
  803116:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80311d:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803124:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80312b:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803132:	be 00 00 00 00       	mov    $0x0,%esi
  803137:	48 89 c7             	mov    %rax,%rdi
  80313a:	48 b8 8a 2d 80 00 00 	movabs $0x802d8a,%rax
  803141:	00 00 00 
  803144:	ff d0                	callq  *%rax
  803146:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803149:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80314d:	79 28                	jns    803177 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80314f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803152:	89 c6                	mov    %eax,%esi
  803154:	48 bf ce 45 80 00 00 	movabs $0x8045ce,%rdi
  80315b:	00 00 00 
  80315e:	b8 00 00 00 00       	mov    $0x0,%eax
  803163:	48 ba 00 07 80 00 00 	movabs $0x800700,%rdx
  80316a:	00 00 00 
  80316d:	ff d2                	callq  *%rdx
		return fd_src;
  80316f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803172:	e9 74 01 00 00       	jmpq   8032eb <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803177:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80317e:	be 01 01 00 00       	mov    $0x101,%esi
  803183:	48 89 c7             	mov    %rax,%rdi
  803186:	48 b8 8a 2d 80 00 00 	movabs $0x802d8a,%rax
  80318d:	00 00 00 
  803190:	ff d0                	callq  *%rax
  803192:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803195:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803199:	79 39                	jns    8031d4 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80319b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80319e:	89 c6                	mov    %eax,%esi
  8031a0:	48 bf e4 45 80 00 00 	movabs $0x8045e4,%rdi
  8031a7:	00 00 00 
  8031aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8031af:	48 ba 00 07 80 00 00 	movabs $0x800700,%rdx
  8031b6:	00 00 00 
  8031b9:	ff d2                	callq  *%rdx
		close(fd_src);
  8031bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031be:	89 c7                	mov    %eax,%edi
  8031c0:	48 b8 92 26 80 00 00 	movabs $0x802692,%rax
  8031c7:	00 00 00 
  8031ca:	ff d0                	callq  *%rax
		return fd_dest;
  8031cc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031cf:	e9 17 01 00 00       	jmpq   8032eb <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8031d4:	eb 74                	jmp    80324a <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8031d6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8031d9:	48 63 d0             	movslq %eax,%rdx
  8031dc:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8031e3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031e6:	48 89 ce             	mov    %rcx,%rsi
  8031e9:	89 c7                	mov    %eax,%edi
  8031eb:	48 b8 fe 29 80 00 00 	movabs $0x8029fe,%rax
  8031f2:	00 00 00 
  8031f5:	ff d0                	callq  *%rax
  8031f7:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8031fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8031fe:	79 4a                	jns    80324a <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803200:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803203:	89 c6                	mov    %eax,%esi
  803205:	48 bf fe 45 80 00 00 	movabs $0x8045fe,%rdi
  80320c:	00 00 00 
  80320f:	b8 00 00 00 00       	mov    $0x0,%eax
  803214:	48 ba 00 07 80 00 00 	movabs $0x800700,%rdx
  80321b:	00 00 00 
  80321e:	ff d2                	callq  *%rdx
			close(fd_src);
  803220:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803223:	89 c7                	mov    %eax,%edi
  803225:	48 b8 92 26 80 00 00 	movabs $0x802692,%rax
  80322c:	00 00 00 
  80322f:	ff d0                	callq  *%rax
			close(fd_dest);
  803231:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803234:	89 c7                	mov    %eax,%edi
  803236:	48 b8 92 26 80 00 00 	movabs $0x802692,%rax
  80323d:	00 00 00 
  803240:	ff d0                	callq  *%rax
			return write_size;
  803242:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803245:	e9 a1 00 00 00       	jmpq   8032eb <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80324a:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803251:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803254:	ba 00 02 00 00       	mov    $0x200,%edx
  803259:	48 89 ce             	mov    %rcx,%rsi
  80325c:	89 c7                	mov    %eax,%edi
  80325e:	48 b8 b4 28 80 00 00 	movabs $0x8028b4,%rax
  803265:	00 00 00 
  803268:	ff d0                	callq  *%rax
  80326a:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80326d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803271:	0f 8f 5f ff ff ff    	jg     8031d6 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803277:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80327b:	79 47                	jns    8032c4 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80327d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803280:	89 c6                	mov    %eax,%esi
  803282:	48 bf 11 46 80 00 00 	movabs $0x804611,%rdi
  803289:	00 00 00 
  80328c:	b8 00 00 00 00       	mov    $0x0,%eax
  803291:	48 ba 00 07 80 00 00 	movabs $0x800700,%rdx
  803298:	00 00 00 
  80329b:	ff d2                	callq  *%rdx
		close(fd_src);
  80329d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032a0:	89 c7                	mov    %eax,%edi
  8032a2:	48 b8 92 26 80 00 00 	movabs $0x802692,%rax
  8032a9:	00 00 00 
  8032ac:	ff d0                	callq  *%rax
		close(fd_dest);
  8032ae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032b1:	89 c7                	mov    %eax,%edi
  8032b3:	48 b8 92 26 80 00 00 	movabs $0x802692,%rax
  8032ba:	00 00 00 
  8032bd:	ff d0                	callq  *%rax
		return read_size;
  8032bf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8032c2:	eb 27                	jmp    8032eb <copy+0x1d9>
	}
	close(fd_src);
  8032c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032c7:	89 c7                	mov    %eax,%edi
  8032c9:	48 b8 92 26 80 00 00 	movabs $0x802692,%rax
  8032d0:	00 00 00 
  8032d3:	ff d0                	callq  *%rax
	close(fd_dest);
  8032d5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032d8:	89 c7                	mov    %eax,%edi
  8032da:	48 b8 92 26 80 00 00 	movabs $0x802692,%rax
  8032e1:	00 00 00 
  8032e4:	ff d0                	callq  *%rax
	return 0;
  8032e6:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8032eb:	c9                   	leaveq 
  8032ec:	c3                   	retq   

00000000008032ed <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8032ed:	55                   	push   %rbp
  8032ee:	48 89 e5             	mov    %rsp,%rbp
  8032f1:	53                   	push   %rbx
  8032f2:	48 83 ec 38          	sub    $0x38,%rsp
  8032f6:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8032fa:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8032fe:	48 89 c7             	mov    %rax,%rdi
  803301:	48 b8 ea 23 80 00 00 	movabs $0x8023ea,%rax
  803308:	00 00 00 
  80330b:	ff d0                	callq  *%rax
  80330d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803310:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803314:	0f 88 bf 01 00 00    	js     8034d9 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80331a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80331e:	ba 07 04 00 00       	mov    $0x407,%edx
  803323:	48 89 c6             	mov    %rax,%rsi
  803326:	bf 00 00 00 00       	mov    $0x0,%edi
  80332b:	48 b8 e4 1b 80 00 00 	movabs $0x801be4,%rax
  803332:	00 00 00 
  803335:	ff d0                	callq  *%rax
  803337:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80333a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80333e:	0f 88 95 01 00 00    	js     8034d9 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803344:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803348:	48 89 c7             	mov    %rax,%rdi
  80334b:	48 b8 ea 23 80 00 00 	movabs $0x8023ea,%rax
  803352:	00 00 00 
  803355:	ff d0                	callq  *%rax
  803357:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80335a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80335e:	0f 88 5d 01 00 00    	js     8034c1 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803364:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803368:	ba 07 04 00 00       	mov    $0x407,%edx
  80336d:	48 89 c6             	mov    %rax,%rsi
  803370:	bf 00 00 00 00       	mov    $0x0,%edi
  803375:	48 b8 e4 1b 80 00 00 	movabs $0x801be4,%rax
  80337c:	00 00 00 
  80337f:	ff d0                	callq  *%rax
  803381:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803384:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803388:	0f 88 33 01 00 00    	js     8034c1 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80338e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803392:	48 89 c7             	mov    %rax,%rdi
  803395:	48 b8 bf 23 80 00 00 	movabs $0x8023bf,%rax
  80339c:	00 00 00 
  80339f:	ff d0                	callq  *%rax
  8033a1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8033a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033a9:	ba 07 04 00 00       	mov    $0x407,%edx
  8033ae:	48 89 c6             	mov    %rax,%rsi
  8033b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8033b6:	48 b8 e4 1b 80 00 00 	movabs $0x801be4,%rax
  8033bd:	00 00 00 
  8033c0:	ff d0                	callq  *%rax
  8033c2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033c9:	79 05                	jns    8033d0 <pipe+0xe3>
		goto err2;
  8033cb:	e9 d9 00 00 00       	jmpq   8034a9 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8033d0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033d4:	48 89 c7             	mov    %rax,%rdi
  8033d7:	48 b8 bf 23 80 00 00 	movabs $0x8023bf,%rax
  8033de:	00 00 00 
  8033e1:	ff d0                	callq  *%rax
  8033e3:	48 89 c2             	mov    %rax,%rdx
  8033e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033ea:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8033f0:	48 89 d1             	mov    %rdx,%rcx
  8033f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8033f8:	48 89 c6             	mov    %rax,%rsi
  8033fb:	bf 00 00 00 00       	mov    $0x0,%edi
  803400:	48 b8 34 1c 80 00 00 	movabs $0x801c34,%rax
  803407:	00 00 00 
  80340a:	ff d0                	callq  *%rax
  80340c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80340f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803413:	79 1b                	jns    803430 <pipe+0x143>
		goto err3;
  803415:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803416:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80341a:	48 89 c6             	mov    %rax,%rsi
  80341d:	bf 00 00 00 00       	mov    $0x0,%edi
  803422:	48 b8 8f 1c 80 00 00 	movabs $0x801c8f,%rax
  803429:	00 00 00 
  80342c:	ff d0                	callq  *%rax
  80342e:	eb 79                	jmp    8034a9 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803430:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803434:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  80343b:	00 00 00 
  80343e:	8b 12                	mov    (%rdx),%edx
  803440:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803442:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803446:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80344d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803451:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803458:	00 00 00 
  80345b:	8b 12                	mov    (%rdx),%edx
  80345d:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80345f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803463:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80346a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80346e:	48 89 c7             	mov    %rax,%rdi
  803471:	48 b8 9c 23 80 00 00 	movabs $0x80239c,%rax
  803478:	00 00 00 
  80347b:	ff d0                	callq  *%rax
  80347d:	89 c2                	mov    %eax,%edx
  80347f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803483:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803485:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803489:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80348d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803491:	48 89 c7             	mov    %rax,%rdi
  803494:	48 b8 9c 23 80 00 00 	movabs $0x80239c,%rax
  80349b:	00 00 00 
  80349e:	ff d0                	callq  *%rax
  8034a0:	89 03                	mov    %eax,(%rbx)
	return 0;
  8034a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8034a7:	eb 33                	jmp    8034dc <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8034a9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034ad:	48 89 c6             	mov    %rax,%rsi
  8034b0:	bf 00 00 00 00       	mov    $0x0,%edi
  8034b5:	48 b8 8f 1c 80 00 00 	movabs $0x801c8f,%rax
  8034bc:	00 00 00 
  8034bf:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8034c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034c5:	48 89 c6             	mov    %rax,%rsi
  8034c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8034cd:	48 b8 8f 1c 80 00 00 	movabs $0x801c8f,%rax
  8034d4:	00 00 00 
  8034d7:	ff d0                	callq  *%rax
err:
	return r;
  8034d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8034dc:	48 83 c4 38          	add    $0x38,%rsp
  8034e0:	5b                   	pop    %rbx
  8034e1:	5d                   	pop    %rbp
  8034e2:	c3                   	retq   

00000000008034e3 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8034e3:	55                   	push   %rbp
  8034e4:	48 89 e5             	mov    %rsp,%rbp
  8034e7:	53                   	push   %rbx
  8034e8:	48 83 ec 28          	sub    $0x28,%rsp
  8034ec:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8034f0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8034f4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8034fb:	00 00 00 
  8034fe:	48 8b 00             	mov    (%rax),%rax
  803501:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803507:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80350a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80350e:	48 89 c7             	mov    %rax,%rdi
  803511:	48 b8 6d 3e 80 00 00 	movabs $0x803e6d,%rax
  803518:	00 00 00 
  80351b:	ff d0                	callq  *%rax
  80351d:	89 c3                	mov    %eax,%ebx
  80351f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803523:	48 89 c7             	mov    %rax,%rdi
  803526:	48 b8 6d 3e 80 00 00 	movabs $0x803e6d,%rax
  80352d:	00 00 00 
  803530:	ff d0                	callq  *%rax
  803532:	39 c3                	cmp    %eax,%ebx
  803534:	0f 94 c0             	sete   %al
  803537:	0f b6 c0             	movzbl %al,%eax
  80353a:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80353d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803544:	00 00 00 
  803547:	48 8b 00             	mov    (%rax),%rax
  80354a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803550:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803553:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803556:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803559:	75 05                	jne    803560 <_pipeisclosed+0x7d>
			return ret;
  80355b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80355e:	eb 4f                	jmp    8035af <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803560:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803563:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803566:	74 42                	je     8035aa <_pipeisclosed+0xc7>
  803568:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80356c:	75 3c                	jne    8035aa <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80356e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803575:	00 00 00 
  803578:	48 8b 00             	mov    (%rax),%rax
  80357b:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803581:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803584:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803587:	89 c6                	mov    %eax,%esi
  803589:	48 bf 2c 46 80 00 00 	movabs $0x80462c,%rdi
  803590:	00 00 00 
  803593:	b8 00 00 00 00       	mov    $0x0,%eax
  803598:	49 b8 00 07 80 00 00 	movabs $0x800700,%r8
  80359f:	00 00 00 
  8035a2:	41 ff d0             	callq  *%r8
	}
  8035a5:	e9 4a ff ff ff       	jmpq   8034f4 <_pipeisclosed+0x11>
  8035aa:	e9 45 ff ff ff       	jmpq   8034f4 <_pipeisclosed+0x11>
}
  8035af:	48 83 c4 28          	add    $0x28,%rsp
  8035b3:	5b                   	pop    %rbx
  8035b4:	5d                   	pop    %rbp
  8035b5:	c3                   	retq   

00000000008035b6 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8035b6:	55                   	push   %rbp
  8035b7:	48 89 e5             	mov    %rsp,%rbp
  8035ba:	48 83 ec 30          	sub    $0x30,%rsp
  8035be:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8035c1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8035c5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8035c8:	48 89 d6             	mov    %rdx,%rsi
  8035cb:	89 c7                	mov    %eax,%edi
  8035cd:	48 b8 82 24 80 00 00 	movabs $0x802482,%rax
  8035d4:	00 00 00 
  8035d7:	ff d0                	callq  *%rax
  8035d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035e0:	79 05                	jns    8035e7 <pipeisclosed+0x31>
		return r;
  8035e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035e5:	eb 31                	jmp    803618 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8035e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035eb:	48 89 c7             	mov    %rax,%rdi
  8035ee:	48 b8 bf 23 80 00 00 	movabs $0x8023bf,%rax
  8035f5:	00 00 00 
  8035f8:	ff d0                	callq  *%rax
  8035fa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8035fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803602:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803606:	48 89 d6             	mov    %rdx,%rsi
  803609:	48 89 c7             	mov    %rax,%rdi
  80360c:	48 b8 e3 34 80 00 00 	movabs $0x8034e3,%rax
  803613:	00 00 00 
  803616:	ff d0                	callq  *%rax
}
  803618:	c9                   	leaveq 
  803619:	c3                   	retq   

000000000080361a <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80361a:	55                   	push   %rbp
  80361b:	48 89 e5             	mov    %rsp,%rbp
  80361e:	48 83 ec 40          	sub    $0x40,%rsp
  803622:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803626:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80362a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80362e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803632:	48 89 c7             	mov    %rax,%rdi
  803635:	48 b8 bf 23 80 00 00 	movabs $0x8023bf,%rax
  80363c:	00 00 00 
  80363f:	ff d0                	callq  *%rax
  803641:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803645:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803649:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80364d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803654:	00 
  803655:	e9 92 00 00 00       	jmpq   8036ec <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80365a:	eb 41                	jmp    80369d <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80365c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803661:	74 09                	je     80366c <devpipe_read+0x52>
				return i;
  803663:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803667:	e9 92 00 00 00       	jmpq   8036fe <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80366c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803670:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803674:	48 89 d6             	mov    %rdx,%rsi
  803677:	48 89 c7             	mov    %rax,%rdi
  80367a:	48 b8 e3 34 80 00 00 	movabs $0x8034e3,%rax
  803681:	00 00 00 
  803684:	ff d0                	callq  *%rax
  803686:	85 c0                	test   %eax,%eax
  803688:	74 07                	je     803691 <devpipe_read+0x77>
				return 0;
  80368a:	b8 00 00 00 00       	mov    $0x0,%eax
  80368f:	eb 6d                	jmp    8036fe <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803691:	48 b8 a6 1b 80 00 00 	movabs $0x801ba6,%rax
  803698:	00 00 00 
  80369b:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80369d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036a1:	8b 10                	mov    (%rax),%edx
  8036a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036a7:	8b 40 04             	mov    0x4(%rax),%eax
  8036aa:	39 c2                	cmp    %eax,%edx
  8036ac:	74 ae                	je     80365c <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8036ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036b6:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8036ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036be:	8b 00                	mov    (%rax),%eax
  8036c0:	99                   	cltd   
  8036c1:	c1 ea 1b             	shr    $0x1b,%edx
  8036c4:	01 d0                	add    %edx,%eax
  8036c6:	83 e0 1f             	and    $0x1f,%eax
  8036c9:	29 d0                	sub    %edx,%eax
  8036cb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036cf:	48 98                	cltq   
  8036d1:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8036d6:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8036d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036dc:	8b 00                	mov    (%rax),%eax
  8036de:	8d 50 01             	lea    0x1(%rax),%edx
  8036e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036e5:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8036e7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8036ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036f0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8036f4:	0f 82 60 ff ff ff    	jb     80365a <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8036fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8036fe:	c9                   	leaveq 
  8036ff:	c3                   	retq   

0000000000803700 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803700:	55                   	push   %rbp
  803701:	48 89 e5             	mov    %rsp,%rbp
  803704:	48 83 ec 40          	sub    $0x40,%rsp
  803708:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80370c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803710:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803714:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803718:	48 89 c7             	mov    %rax,%rdi
  80371b:	48 b8 bf 23 80 00 00 	movabs $0x8023bf,%rax
  803722:	00 00 00 
  803725:	ff d0                	callq  *%rax
  803727:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80372b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80372f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803733:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80373a:	00 
  80373b:	e9 8e 00 00 00       	jmpq   8037ce <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803740:	eb 31                	jmp    803773 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803742:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803746:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80374a:	48 89 d6             	mov    %rdx,%rsi
  80374d:	48 89 c7             	mov    %rax,%rdi
  803750:	48 b8 e3 34 80 00 00 	movabs $0x8034e3,%rax
  803757:	00 00 00 
  80375a:	ff d0                	callq  *%rax
  80375c:	85 c0                	test   %eax,%eax
  80375e:	74 07                	je     803767 <devpipe_write+0x67>
				return 0;
  803760:	b8 00 00 00 00       	mov    $0x0,%eax
  803765:	eb 79                	jmp    8037e0 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803767:	48 b8 a6 1b 80 00 00 	movabs $0x801ba6,%rax
  80376e:	00 00 00 
  803771:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803773:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803777:	8b 40 04             	mov    0x4(%rax),%eax
  80377a:	48 63 d0             	movslq %eax,%rdx
  80377d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803781:	8b 00                	mov    (%rax),%eax
  803783:	48 98                	cltq   
  803785:	48 83 c0 20          	add    $0x20,%rax
  803789:	48 39 c2             	cmp    %rax,%rdx
  80378c:	73 b4                	jae    803742 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80378e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803792:	8b 40 04             	mov    0x4(%rax),%eax
  803795:	99                   	cltd   
  803796:	c1 ea 1b             	shr    $0x1b,%edx
  803799:	01 d0                	add    %edx,%eax
  80379b:	83 e0 1f             	and    $0x1f,%eax
  80379e:	29 d0                	sub    %edx,%eax
  8037a0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8037a4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8037a8:	48 01 ca             	add    %rcx,%rdx
  8037ab:	0f b6 0a             	movzbl (%rdx),%ecx
  8037ae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037b2:	48 98                	cltq   
  8037b4:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8037b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037bc:	8b 40 04             	mov    0x4(%rax),%eax
  8037bf:	8d 50 01             	lea    0x1(%rax),%edx
  8037c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037c6:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8037c9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8037ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037d2:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8037d6:	0f 82 64 ff ff ff    	jb     803740 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8037dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8037e0:	c9                   	leaveq 
  8037e1:	c3                   	retq   

00000000008037e2 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8037e2:	55                   	push   %rbp
  8037e3:	48 89 e5             	mov    %rsp,%rbp
  8037e6:	48 83 ec 20          	sub    $0x20,%rsp
  8037ea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8037ee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8037f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037f6:	48 89 c7             	mov    %rax,%rdi
  8037f9:	48 b8 bf 23 80 00 00 	movabs $0x8023bf,%rax
  803800:	00 00 00 
  803803:	ff d0                	callq  *%rax
  803805:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803809:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80380d:	48 be 3f 46 80 00 00 	movabs $0x80463f,%rsi
  803814:	00 00 00 
  803817:	48 89 c7             	mov    %rax,%rdi
  80381a:	48 b8 b5 12 80 00 00 	movabs $0x8012b5,%rax
  803821:	00 00 00 
  803824:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803826:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80382a:	8b 50 04             	mov    0x4(%rax),%edx
  80382d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803831:	8b 00                	mov    (%rax),%eax
  803833:	29 c2                	sub    %eax,%edx
  803835:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803839:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80383f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803843:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80384a:	00 00 00 
	stat->st_dev = &devpipe;
  80384d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803851:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803858:	00 00 00 
  80385b:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803862:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803867:	c9                   	leaveq 
  803868:	c3                   	retq   

0000000000803869 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803869:	55                   	push   %rbp
  80386a:	48 89 e5             	mov    %rsp,%rbp
  80386d:	48 83 ec 10          	sub    $0x10,%rsp
  803871:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803875:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803879:	48 89 c6             	mov    %rax,%rsi
  80387c:	bf 00 00 00 00       	mov    $0x0,%edi
  803881:	48 b8 8f 1c 80 00 00 	movabs $0x801c8f,%rax
  803888:	00 00 00 
  80388b:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80388d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803891:	48 89 c7             	mov    %rax,%rdi
  803894:	48 b8 bf 23 80 00 00 	movabs $0x8023bf,%rax
  80389b:	00 00 00 
  80389e:	ff d0                	callq  *%rax
  8038a0:	48 89 c6             	mov    %rax,%rsi
  8038a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8038a8:	48 b8 8f 1c 80 00 00 	movabs $0x801c8f,%rax
  8038af:	00 00 00 
  8038b2:	ff d0                	callq  *%rax
}
  8038b4:	c9                   	leaveq 
  8038b5:	c3                   	retq   

00000000008038b6 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8038b6:	55                   	push   %rbp
  8038b7:	48 89 e5             	mov    %rsp,%rbp
  8038ba:	48 83 ec 20          	sub    $0x20,%rsp
  8038be:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8038c1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038c4:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8038c7:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8038cb:	be 01 00 00 00       	mov    $0x1,%esi
  8038d0:	48 89 c7             	mov    %rax,%rdi
  8038d3:	48 b8 9c 1a 80 00 00 	movabs $0x801a9c,%rax
  8038da:	00 00 00 
  8038dd:	ff d0                	callq  *%rax
}
  8038df:	c9                   	leaveq 
  8038e0:	c3                   	retq   

00000000008038e1 <getchar>:

int
getchar(void)
{
  8038e1:	55                   	push   %rbp
  8038e2:	48 89 e5             	mov    %rsp,%rbp
  8038e5:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8038e9:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8038ed:	ba 01 00 00 00       	mov    $0x1,%edx
  8038f2:	48 89 c6             	mov    %rax,%rsi
  8038f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8038fa:	48 b8 b4 28 80 00 00 	movabs $0x8028b4,%rax
  803901:	00 00 00 
  803904:	ff d0                	callq  *%rax
  803906:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803909:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80390d:	79 05                	jns    803914 <getchar+0x33>
		return r;
  80390f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803912:	eb 14                	jmp    803928 <getchar+0x47>
	if (r < 1)
  803914:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803918:	7f 07                	jg     803921 <getchar+0x40>
		return -E_EOF;
  80391a:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80391f:	eb 07                	jmp    803928 <getchar+0x47>
	return c;
  803921:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803925:	0f b6 c0             	movzbl %al,%eax
}
  803928:	c9                   	leaveq 
  803929:	c3                   	retq   

000000000080392a <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80392a:	55                   	push   %rbp
  80392b:	48 89 e5             	mov    %rsp,%rbp
  80392e:	48 83 ec 20          	sub    $0x20,%rsp
  803932:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803935:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803939:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80393c:	48 89 d6             	mov    %rdx,%rsi
  80393f:	89 c7                	mov    %eax,%edi
  803941:	48 b8 82 24 80 00 00 	movabs $0x802482,%rax
  803948:	00 00 00 
  80394b:	ff d0                	callq  *%rax
  80394d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803950:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803954:	79 05                	jns    80395b <iscons+0x31>
		return r;
  803956:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803959:	eb 1a                	jmp    803975 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80395b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80395f:	8b 10                	mov    (%rax),%edx
  803961:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803968:	00 00 00 
  80396b:	8b 00                	mov    (%rax),%eax
  80396d:	39 c2                	cmp    %eax,%edx
  80396f:	0f 94 c0             	sete   %al
  803972:	0f b6 c0             	movzbl %al,%eax
}
  803975:	c9                   	leaveq 
  803976:	c3                   	retq   

0000000000803977 <opencons>:

int
opencons(void)
{
  803977:	55                   	push   %rbp
  803978:	48 89 e5             	mov    %rsp,%rbp
  80397b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80397f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803983:	48 89 c7             	mov    %rax,%rdi
  803986:	48 b8 ea 23 80 00 00 	movabs $0x8023ea,%rax
  80398d:	00 00 00 
  803990:	ff d0                	callq  *%rax
  803992:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803995:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803999:	79 05                	jns    8039a0 <opencons+0x29>
		return r;
  80399b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80399e:	eb 5b                	jmp    8039fb <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8039a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039a4:	ba 07 04 00 00       	mov    $0x407,%edx
  8039a9:	48 89 c6             	mov    %rax,%rsi
  8039ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8039b1:	48 b8 e4 1b 80 00 00 	movabs $0x801be4,%rax
  8039b8:	00 00 00 
  8039bb:	ff d0                	callq  *%rax
  8039bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039c4:	79 05                	jns    8039cb <opencons+0x54>
		return r;
  8039c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039c9:	eb 30                	jmp    8039fb <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8039cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039cf:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  8039d6:	00 00 00 
  8039d9:	8b 12                	mov    (%rdx),%edx
  8039db:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8039dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039e1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8039e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039ec:	48 89 c7             	mov    %rax,%rdi
  8039ef:	48 b8 9c 23 80 00 00 	movabs $0x80239c,%rax
  8039f6:	00 00 00 
  8039f9:	ff d0                	callq  *%rax
}
  8039fb:	c9                   	leaveq 
  8039fc:	c3                   	retq   

00000000008039fd <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8039fd:	55                   	push   %rbp
  8039fe:	48 89 e5             	mov    %rsp,%rbp
  803a01:	48 83 ec 30          	sub    $0x30,%rsp
  803a05:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a09:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a0d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803a11:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803a16:	75 07                	jne    803a1f <devcons_read+0x22>
		return 0;
  803a18:	b8 00 00 00 00       	mov    $0x0,%eax
  803a1d:	eb 4b                	jmp    803a6a <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803a1f:	eb 0c                	jmp    803a2d <devcons_read+0x30>
		sys_yield();
  803a21:	48 b8 a6 1b 80 00 00 	movabs $0x801ba6,%rax
  803a28:	00 00 00 
  803a2b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803a2d:	48 b8 e6 1a 80 00 00 	movabs $0x801ae6,%rax
  803a34:	00 00 00 
  803a37:	ff d0                	callq  *%rax
  803a39:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a3c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a40:	74 df                	je     803a21 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803a42:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a46:	79 05                	jns    803a4d <devcons_read+0x50>
		return c;
  803a48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a4b:	eb 1d                	jmp    803a6a <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803a4d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803a51:	75 07                	jne    803a5a <devcons_read+0x5d>
		return 0;
  803a53:	b8 00 00 00 00       	mov    $0x0,%eax
  803a58:	eb 10                	jmp    803a6a <devcons_read+0x6d>
	*(char*)vbuf = c;
  803a5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a5d:	89 c2                	mov    %eax,%edx
  803a5f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a63:	88 10                	mov    %dl,(%rax)
	return 1;
  803a65:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803a6a:	c9                   	leaveq 
  803a6b:	c3                   	retq   

0000000000803a6c <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a6c:	55                   	push   %rbp
  803a6d:	48 89 e5             	mov    %rsp,%rbp
  803a70:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803a77:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803a7e:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803a85:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803a8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803a93:	eb 76                	jmp    803b0b <devcons_write+0x9f>
		m = n - tot;
  803a95:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803a9c:	89 c2                	mov    %eax,%edx
  803a9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aa1:	29 c2                	sub    %eax,%edx
  803aa3:	89 d0                	mov    %edx,%eax
  803aa5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803aa8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803aab:	83 f8 7f             	cmp    $0x7f,%eax
  803aae:	76 07                	jbe    803ab7 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803ab0:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803ab7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803aba:	48 63 d0             	movslq %eax,%rdx
  803abd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ac0:	48 63 c8             	movslq %eax,%rcx
  803ac3:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803aca:	48 01 c1             	add    %rax,%rcx
  803acd:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803ad4:	48 89 ce             	mov    %rcx,%rsi
  803ad7:	48 89 c7             	mov    %rax,%rdi
  803ada:	48 b8 d9 15 80 00 00 	movabs $0x8015d9,%rax
  803ae1:	00 00 00 
  803ae4:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803ae6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ae9:	48 63 d0             	movslq %eax,%rdx
  803aec:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803af3:	48 89 d6             	mov    %rdx,%rsi
  803af6:	48 89 c7             	mov    %rax,%rdi
  803af9:	48 b8 9c 1a 80 00 00 	movabs $0x801a9c,%rax
  803b00:	00 00 00 
  803b03:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803b05:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b08:	01 45 fc             	add    %eax,-0x4(%rbp)
  803b0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b0e:	48 98                	cltq   
  803b10:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803b17:	0f 82 78 ff ff ff    	jb     803a95 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803b1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803b20:	c9                   	leaveq 
  803b21:	c3                   	retq   

0000000000803b22 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803b22:	55                   	push   %rbp
  803b23:	48 89 e5             	mov    %rsp,%rbp
  803b26:	48 83 ec 08          	sub    $0x8,%rsp
  803b2a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803b2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b33:	c9                   	leaveq 
  803b34:	c3                   	retq   

0000000000803b35 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803b35:	55                   	push   %rbp
  803b36:	48 89 e5             	mov    %rsp,%rbp
  803b39:	48 83 ec 10          	sub    $0x10,%rsp
  803b3d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803b41:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803b45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b49:	48 be 4b 46 80 00 00 	movabs $0x80464b,%rsi
  803b50:	00 00 00 
  803b53:	48 89 c7             	mov    %rax,%rdi
  803b56:	48 b8 b5 12 80 00 00 	movabs $0x8012b5,%rax
  803b5d:	00 00 00 
  803b60:	ff d0                	callq  *%rax
	return 0;
  803b62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b67:	c9                   	leaveq 
  803b68:	c3                   	retq   

0000000000803b69 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803b69:	55                   	push   %rbp
  803b6a:	48 89 e5             	mov    %rsp,%rbp
  803b6d:	48 83 ec 10          	sub    $0x10,%rsp
  803b71:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  803b75:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803b7c:	00 00 00 
  803b7f:	48 8b 00             	mov    (%rax),%rax
  803b82:	48 85 c0             	test   %rax,%rax
  803b85:	75 64                	jne    803beb <set_pgfault_handler+0x82>
		// First time through!
		// LAB 4: Your code here.
		//envid_t eid = sys_getenvid();
		if(sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) 
  803b87:	ba 07 00 00 00       	mov    $0x7,%edx
  803b8c:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803b91:	bf 00 00 00 00       	mov    $0x0,%edi
  803b96:	48 b8 e4 1b 80 00 00 	movabs $0x801be4,%rax
  803b9d:	00 00 00 
  803ba0:	ff d0                	callq  *%rax
  803ba2:	85 c0                	test   %eax,%eax
  803ba4:	74 2a                	je     803bd0 <set_pgfault_handler+0x67>
			panic("Allocation of space for UXSTACK failed\n");
  803ba6:	48 ba 58 46 80 00 00 	movabs $0x804658,%rdx
  803bad:	00 00 00 
  803bb0:	be 22 00 00 00       	mov    $0x22,%esi
  803bb5:	48 bf 80 46 80 00 00 	movabs $0x804680,%rdi
  803bbc:	00 00 00 
  803bbf:	b8 00 00 00 00       	mov    $0x0,%eax
  803bc4:	48 b9 c7 04 80 00 00 	movabs $0x8004c7,%rcx
  803bcb:	00 00 00 
  803bce:	ff d1                	callq  *%rcx
		else
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  803bd0:	48 be fe 3b 80 00 00 	movabs $0x803bfe,%rsi
  803bd7:	00 00 00 
  803bda:	bf 00 00 00 00       	mov    $0x0,%edi
  803bdf:	48 b8 6e 1d 80 00 00 	movabs $0x801d6e,%rax
  803be6:	00 00 00 
  803be9:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803beb:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803bf2:	00 00 00 
  803bf5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803bf9:	48 89 10             	mov    %rdx,(%rax)
}
  803bfc:	c9                   	leaveq 
  803bfd:	c3                   	retq   

0000000000803bfe <_pgfault_upcall>:
// Call the C page fault handler.
// function argument: pointer to UTF



movq  %rsp,%rdi                // passing the function argument in rdi
  803bfe:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  803c01:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803c08:	00 00 00 
call *%rax
  803c0b:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
mov 152(%rsp), %r8
  803c0d:	4c 8b 84 24 98 00 00 	mov    0x98(%rsp),%r8
  803c14:	00 
mov 136(%rsp), %r9
  803c15:	4c 8b 8c 24 88 00 00 	mov    0x88(%rsp),%r9
  803c1c:	00 
sub $8, %r8
  803c1d:	49 83 e8 08          	sub    $0x8,%r8
mov %r9, (%r8)
  803c21:	4d 89 08             	mov    %r9,(%r8)
mov %r8, 152(%rsp)
  803c24:	4c 89 84 24 98 00 00 	mov    %r8,0x98(%rsp)
  803c2b:	00 
add $16, %rsp
  803c2c:	48 83 c4 10          	add    $0x10,%rsp

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
POPA_
  803c30:	4c 8b 3c 24          	mov    (%rsp),%r15
  803c34:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803c39:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803c3e:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803c43:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803c48:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803c4d:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803c52:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803c57:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803c5c:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803c61:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803c66:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803c6b:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803c70:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803c75:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803c7a:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
		// LAB 4: Your code here.
add $8, %rsp
  803c7e:	48 83 c4 08          	add    $0x8,%rsp
popf
  803c82:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
mov (%rsp), %rsp
  803c83:	48 8b 24 24          	mov    (%rsp),%rsp
    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
ret
  803c87:	c3                   	retq   

0000000000803c88 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803c88:	55                   	push   %rbp
  803c89:	48 89 e5             	mov    %rsp,%rbp
  803c8c:	48 83 ec 30          	sub    $0x30,%rsp
  803c90:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c94:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c98:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  803c9c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803ca1:	74 18                	je     803cbb <ipc_recv+0x33>
  803ca3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ca7:	48 89 c7             	mov    %rax,%rdi
  803caa:	48 b8 0d 1e 80 00 00 	movabs $0x801e0d,%rax
  803cb1:	00 00 00 
  803cb4:	ff d0                	callq  *%rax
  803cb6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cb9:	eb 19                	jmp    803cd4 <ipc_recv+0x4c>
  803cbb:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  803cc2:	00 00 00 
  803cc5:	48 b8 0d 1e 80 00 00 	movabs $0x801e0d,%rax
  803ccc:	00 00 00 
  803ccf:	ff d0                	callq  *%rax
  803cd1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  803cd4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803cd9:	74 26                	je     803d01 <ipc_recv+0x79>
  803cdb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cdf:	75 15                	jne    803cf6 <ipc_recv+0x6e>
  803ce1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803ce8:	00 00 00 
  803ceb:	48 8b 00             	mov    (%rax),%rax
  803cee:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  803cf4:	eb 05                	jmp    803cfb <ipc_recv+0x73>
  803cf6:	b8 00 00 00 00       	mov    $0x0,%eax
  803cfb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803cff:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  803d01:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803d06:	74 26                	je     803d2e <ipc_recv+0xa6>
  803d08:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d0c:	75 15                	jne    803d23 <ipc_recv+0x9b>
  803d0e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d15:	00 00 00 
  803d18:	48 8b 00             	mov    (%rax),%rax
  803d1b:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  803d21:	eb 05                	jmp    803d28 <ipc_recv+0xa0>
  803d23:	b8 00 00 00 00       	mov    $0x0,%eax
  803d28:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803d2c:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  803d2e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d32:	75 15                	jne    803d49 <ipc_recv+0xc1>
  803d34:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d3b:	00 00 00 
  803d3e:	48 8b 00             	mov    (%rax),%rax
  803d41:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  803d47:	eb 03                	jmp    803d4c <ipc_recv+0xc4>
  803d49:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803d4c:	c9                   	leaveq 
  803d4d:	c3                   	retq   

0000000000803d4e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803d4e:	55                   	push   %rbp
  803d4f:	48 89 e5             	mov    %rsp,%rbp
  803d52:	48 83 ec 30          	sub    $0x30,%rsp
  803d56:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d59:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803d5c:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803d60:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  803d63:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  803d6a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803d6f:	75 10                	jne    803d81 <ipc_send+0x33>
  803d71:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803d78:	00 00 00 
  803d7b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  803d7f:	eb 62                	jmp    803de3 <ipc_send+0x95>
  803d81:	eb 60                	jmp    803de3 <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  803d83:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803d87:	74 30                	je     803db9 <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  803d89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d8c:	89 c1                	mov    %eax,%ecx
  803d8e:	48 ba 8e 46 80 00 00 	movabs $0x80468e,%rdx
  803d95:	00 00 00 
  803d98:	be 33 00 00 00       	mov    $0x33,%esi
  803d9d:	48 bf aa 46 80 00 00 	movabs $0x8046aa,%rdi
  803da4:	00 00 00 
  803da7:	b8 00 00 00 00       	mov    $0x0,%eax
  803dac:	49 b8 c7 04 80 00 00 	movabs $0x8004c7,%r8
  803db3:	00 00 00 
  803db6:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  803db9:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803dbc:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803dbf:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803dc3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dc6:	89 c7                	mov    %eax,%edi
  803dc8:	48 b8 b8 1d 80 00 00 	movabs $0x801db8,%rax
  803dcf:	00 00 00 
  803dd2:	ff d0                	callq  *%rax
  803dd4:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  803dd7:	48 b8 a6 1b 80 00 00 	movabs $0x801ba6,%rax
  803dde:	00 00 00 
  803de1:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  803de3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803de7:	75 9a                	jne    803d83 <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  803de9:	c9                   	leaveq 
  803dea:	c3                   	retq   

0000000000803deb <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803deb:	55                   	push   %rbp
  803dec:	48 89 e5             	mov    %rsp,%rbp
  803def:	48 83 ec 14          	sub    $0x14,%rsp
  803df3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803df6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803dfd:	eb 5e                	jmp    803e5d <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803dff:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803e06:	00 00 00 
  803e09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e0c:	48 63 d0             	movslq %eax,%rdx
  803e0f:	48 89 d0             	mov    %rdx,%rax
  803e12:	48 c1 e0 03          	shl    $0x3,%rax
  803e16:	48 01 d0             	add    %rdx,%rax
  803e19:	48 c1 e0 05          	shl    $0x5,%rax
  803e1d:	48 01 c8             	add    %rcx,%rax
  803e20:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803e26:	8b 00                	mov    (%rax),%eax
  803e28:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803e2b:	75 2c                	jne    803e59 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803e2d:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803e34:	00 00 00 
  803e37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e3a:	48 63 d0             	movslq %eax,%rdx
  803e3d:	48 89 d0             	mov    %rdx,%rax
  803e40:	48 c1 e0 03          	shl    $0x3,%rax
  803e44:	48 01 d0             	add    %rdx,%rax
  803e47:	48 c1 e0 05          	shl    $0x5,%rax
  803e4b:	48 01 c8             	add    %rcx,%rax
  803e4e:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803e54:	8b 40 08             	mov    0x8(%rax),%eax
  803e57:	eb 12                	jmp    803e6b <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803e59:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803e5d:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803e64:	7e 99                	jle    803dff <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803e66:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e6b:	c9                   	leaveq 
  803e6c:	c3                   	retq   

0000000000803e6d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803e6d:	55                   	push   %rbp
  803e6e:	48 89 e5             	mov    %rsp,%rbp
  803e71:	48 83 ec 18          	sub    $0x18,%rsp
  803e75:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803e79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e7d:	48 c1 e8 15          	shr    $0x15,%rax
  803e81:	48 89 c2             	mov    %rax,%rdx
  803e84:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803e8b:	01 00 00 
  803e8e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e92:	83 e0 01             	and    $0x1,%eax
  803e95:	48 85 c0             	test   %rax,%rax
  803e98:	75 07                	jne    803ea1 <pageref+0x34>
		return 0;
  803e9a:	b8 00 00 00 00       	mov    $0x0,%eax
  803e9f:	eb 53                	jmp    803ef4 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803ea1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ea5:	48 c1 e8 0c          	shr    $0xc,%rax
  803ea9:	48 89 c2             	mov    %rax,%rdx
  803eac:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803eb3:	01 00 00 
  803eb6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803eba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803ebe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ec2:	83 e0 01             	and    $0x1,%eax
  803ec5:	48 85 c0             	test   %rax,%rax
  803ec8:	75 07                	jne    803ed1 <pageref+0x64>
		return 0;
  803eca:	b8 00 00 00 00       	mov    $0x0,%eax
  803ecf:	eb 23                	jmp    803ef4 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803ed1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ed5:	48 c1 e8 0c          	shr    $0xc,%rax
  803ed9:	48 89 c2             	mov    %rax,%rdx
  803edc:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803ee3:	00 00 00 
  803ee6:	48 c1 e2 04          	shl    $0x4,%rdx
  803eea:	48 01 d0             	add    %rdx,%rax
  803eed:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803ef1:	0f b7 c0             	movzwl %ax,%eax
}
  803ef4:	c9                   	leaveq 
  803ef5:	c3                   	retq   
