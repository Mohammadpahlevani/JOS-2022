
obj/user/breakpoint:     file format elf64-x86-64


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
  80003c:	e8 14 00 00 00       	callq  800055 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	asm volatile("int $3");
  800052:	cc                   	int3   
}
  800053:	c9                   	leaveq 
  800054:	c3                   	retq   

0000000000800055 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800055:	55                   	push   %rbp
  800056:	48 89 e5             	mov    %rsp,%rbp
  800059:	48 83 ec 10          	sub    $0x10,%rsp
  80005d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800060:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	thisenv = &envs[ENVX(sys_getenvid())];
  800064:	48 b8 50 02 80 00 00 	movabs $0x800250,%rax
  80006b:	00 00 00 
  80006e:	ff d0                	callq  *%rax
  800070:	25 ff 03 00 00       	and    $0x3ff,%eax
  800075:	48 98                	cltq   
  800077:	48 c1 e0 03          	shl    $0x3,%rax
  80007b:	48 89 c2             	mov    %rax,%rdx
  80007e:	48 c1 e2 05          	shl    $0x5,%rdx
  800082:	48 29 c2             	sub    %rax,%rdx
  800085:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80008c:	00 00 00 
  80008f:	48 01 c2             	add    %rax,%rdx
  800092:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  800099:	00 00 00 
  80009c:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80009f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000a3:	7e 14                	jle    8000b9 <libmain+0x64>
		binaryname = argv[0];
  8000a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000a9:	48 8b 10             	mov    (%rax),%rdx
  8000ac:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000b3:	00 00 00 
  8000b6:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000c0:	48 89 d6             	mov    %rdx,%rsi
  8000c3:	89 c7                	mov    %eax,%edi
  8000c5:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000cc:	00 00 00 
  8000cf:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000d1:	48 b8 df 00 80 00 00 	movabs $0x8000df,%rax
  8000d8:	00 00 00 
  8000db:	ff d0                	callq  *%rax
}
  8000dd:	c9                   	leaveq 
  8000de:	c3                   	retq   

00000000008000df <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000df:	55                   	push   %rbp
  8000e0:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8000e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8000e8:	48 b8 0c 02 80 00 00 	movabs $0x80020c,%rax
  8000ef:	00 00 00 
  8000f2:	ff d0                	callq  *%rax
}
  8000f4:	5d                   	pop    %rbp
  8000f5:	c3                   	retq   

00000000008000f6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8000f6:	55                   	push   %rbp
  8000f7:	48 89 e5             	mov    %rsp,%rbp
  8000fa:	53                   	push   %rbx
  8000fb:	48 83 ec 48          	sub    $0x48,%rsp
  8000ff:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800102:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800105:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800109:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80010d:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800111:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800115:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800118:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80011c:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800120:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800124:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800128:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80012c:	4c 89 c3             	mov    %r8,%rbx
  80012f:	cd 30                	int    $0x30
  800131:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800135:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800139:	74 3e                	je     800179 <syscall+0x83>
  80013b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800140:	7e 37                	jle    800179 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800142:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800146:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800149:	49 89 d0             	mov    %rdx,%r8
  80014c:	89 c1                	mov    %eax,%ecx
  80014e:	48 ba 0a 18 80 00 00 	movabs $0x80180a,%rdx
  800155:	00 00 00 
  800158:	be 23 00 00 00       	mov    $0x23,%esi
  80015d:	48 bf 27 18 80 00 00 	movabs $0x801827,%rdi
  800164:	00 00 00 
  800167:	b8 00 00 00 00       	mov    $0x0,%eax
  80016c:	49 b9 8e 02 80 00 00 	movabs $0x80028e,%r9
  800173:	00 00 00 
  800176:	41 ff d1             	callq  *%r9

	return ret;
  800179:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80017d:	48 83 c4 48          	add    $0x48,%rsp
  800181:	5b                   	pop    %rbx
  800182:	5d                   	pop    %rbp
  800183:	c3                   	retq   

0000000000800184 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800184:	55                   	push   %rbp
  800185:	48 89 e5             	mov    %rsp,%rbp
  800188:	48 83 ec 20          	sub    $0x20,%rsp
  80018c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800190:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  800194:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800198:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80019c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001a3:	00 
  8001a4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001aa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001b0:	48 89 d1             	mov    %rdx,%rcx
  8001b3:	48 89 c2             	mov    %rax,%rdx
  8001b6:	be 00 00 00 00       	mov    $0x0,%esi
  8001bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8001c0:	48 b8 f6 00 80 00 00 	movabs $0x8000f6,%rax
  8001c7:	00 00 00 
  8001ca:	ff d0                	callq  *%rax
}
  8001cc:	c9                   	leaveq 
  8001cd:	c3                   	retq   

00000000008001ce <sys_cgetc>:

int
sys_cgetc(void)
{
  8001ce:	55                   	push   %rbp
  8001cf:	48 89 e5             	mov    %rsp,%rbp
  8001d2:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001d6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001dd:	00 
  8001de:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001e4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8001f4:	be 00 00 00 00       	mov    $0x0,%esi
  8001f9:	bf 01 00 00 00       	mov    $0x1,%edi
  8001fe:	48 b8 f6 00 80 00 00 	movabs $0x8000f6,%rax
  800205:	00 00 00 
  800208:	ff d0                	callq  *%rax
}
  80020a:	c9                   	leaveq 
  80020b:	c3                   	retq   

000000000080020c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80020c:	55                   	push   %rbp
  80020d:	48 89 e5             	mov    %rsp,%rbp
  800210:	48 83 ec 10          	sub    $0x10,%rsp
  800214:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800217:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80021a:	48 98                	cltq   
  80021c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800223:	00 
  800224:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80022a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800230:	b9 00 00 00 00       	mov    $0x0,%ecx
  800235:	48 89 c2             	mov    %rax,%rdx
  800238:	be 01 00 00 00       	mov    $0x1,%esi
  80023d:	bf 03 00 00 00       	mov    $0x3,%edi
  800242:	48 b8 f6 00 80 00 00 	movabs $0x8000f6,%rax
  800249:	00 00 00 
  80024c:	ff d0                	callq  *%rax
}
  80024e:	c9                   	leaveq 
  80024f:	c3                   	retq   

0000000000800250 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800250:	55                   	push   %rbp
  800251:	48 89 e5             	mov    %rsp,%rbp
  800254:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800258:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80025f:	00 
  800260:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800266:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80026c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800271:	ba 00 00 00 00       	mov    $0x0,%edx
  800276:	be 00 00 00 00       	mov    $0x0,%esi
  80027b:	bf 02 00 00 00       	mov    $0x2,%edi
  800280:	48 b8 f6 00 80 00 00 	movabs $0x8000f6,%rax
  800287:	00 00 00 
  80028a:	ff d0                	callq  *%rax
}
  80028c:	c9                   	leaveq 
  80028d:	c3                   	retq   

000000000080028e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80028e:	55                   	push   %rbp
  80028f:	48 89 e5             	mov    %rsp,%rbp
  800292:	53                   	push   %rbx
  800293:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80029a:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8002a1:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8002a7:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8002ae:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8002b5:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8002bc:	84 c0                	test   %al,%al
  8002be:	74 23                	je     8002e3 <_panic+0x55>
  8002c0:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8002c7:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002cb:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002cf:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002d3:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002d7:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002db:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002df:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002e3:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002ea:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002f1:	00 00 00 
  8002f4:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002fb:	00 00 00 
  8002fe:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800302:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800309:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800310:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800317:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  80031e:	00 00 00 
  800321:	48 8b 18             	mov    (%rax),%rbx
  800324:	48 b8 50 02 80 00 00 	movabs $0x800250,%rax
  80032b:	00 00 00 
  80032e:	ff d0                	callq  *%rax
  800330:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800336:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80033d:	41 89 c8             	mov    %ecx,%r8d
  800340:	48 89 d1             	mov    %rdx,%rcx
  800343:	48 89 da             	mov    %rbx,%rdx
  800346:	89 c6                	mov    %eax,%esi
  800348:	48 bf 38 18 80 00 00 	movabs $0x801838,%rdi
  80034f:	00 00 00 
  800352:	b8 00 00 00 00       	mov    $0x0,%eax
  800357:	49 b9 c7 04 80 00 00 	movabs $0x8004c7,%r9
  80035e:	00 00 00 
  800361:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800364:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80036b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800372:	48 89 d6             	mov    %rdx,%rsi
  800375:	48 89 c7             	mov    %rax,%rdi
  800378:	48 b8 1b 04 80 00 00 	movabs $0x80041b,%rax
  80037f:	00 00 00 
  800382:	ff d0                	callq  *%rax
	cprintf("\n");
  800384:	48 bf 5b 18 80 00 00 	movabs $0x80185b,%rdi
  80038b:	00 00 00 
  80038e:	b8 00 00 00 00       	mov    $0x0,%eax
  800393:	48 ba c7 04 80 00 00 	movabs $0x8004c7,%rdx
  80039a:	00 00 00 
  80039d:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80039f:	cc                   	int3   
  8003a0:	eb fd                	jmp    80039f <_panic+0x111>

00000000008003a2 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8003a2:	55                   	push   %rbp
  8003a3:	48 89 e5             	mov    %rsp,%rbp
  8003a6:	48 83 ec 10          	sub    $0x10,%rsp
  8003aa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003ad:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8003b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003b5:	8b 00                	mov    (%rax),%eax
  8003b7:	8d 48 01             	lea    0x1(%rax),%ecx
  8003ba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003be:	89 0a                	mov    %ecx,(%rdx)
  8003c0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003c3:	89 d1                	mov    %edx,%ecx
  8003c5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003c9:	48 98                	cltq   
  8003cb:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8003cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d3:	8b 00                	mov    (%rax),%eax
  8003d5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003da:	75 2c                	jne    800408 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003e0:	8b 00                	mov    (%rax),%eax
  8003e2:	48 98                	cltq   
  8003e4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003e8:	48 83 c2 08          	add    $0x8,%rdx
  8003ec:	48 89 c6             	mov    %rax,%rsi
  8003ef:	48 89 d7             	mov    %rdx,%rdi
  8003f2:	48 b8 84 01 80 00 00 	movabs $0x800184,%rax
  8003f9:	00 00 00 
  8003fc:	ff d0                	callq  *%rax
        b->idx = 0;
  8003fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800402:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800408:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80040c:	8b 40 04             	mov    0x4(%rax),%eax
  80040f:	8d 50 01             	lea    0x1(%rax),%edx
  800412:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800416:	89 50 04             	mov    %edx,0x4(%rax)
}
  800419:	c9                   	leaveq 
  80041a:	c3                   	retq   

000000000080041b <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80041b:	55                   	push   %rbp
  80041c:	48 89 e5             	mov    %rsp,%rbp
  80041f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800426:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80042d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800434:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80043b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800442:	48 8b 0a             	mov    (%rdx),%rcx
  800445:	48 89 08             	mov    %rcx,(%rax)
  800448:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80044c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800450:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800454:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800458:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80045f:	00 00 00 
    b.cnt = 0;
  800462:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800469:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80046c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800473:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80047a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800481:	48 89 c6             	mov    %rax,%rsi
  800484:	48 bf a2 03 80 00 00 	movabs $0x8003a2,%rdi
  80048b:	00 00 00 
  80048e:	48 b8 7a 08 80 00 00 	movabs $0x80087a,%rax
  800495:	00 00 00 
  800498:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80049a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8004a0:	48 98                	cltq   
  8004a2:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8004a9:	48 83 c2 08          	add    $0x8,%rdx
  8004ad:	48 89 c6             	mov    %rax,%rsi
  8004b0:	48 89 d7             	mov    %rdx,%rdi
  8004b3:	48 b8 84 01 80 00 00 	movabs $0x800184,%rax
  8004ba:	00 00 00 
  8004bd:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8004bf:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004c5:	c9                   	leaveq 
  8004c6:	c3                   	retq   

00000000008004c7 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8004c7:	55                   	push   %rbp
  8004c8:	48 89 e5             	mov    %rsp,%rbp
  8004cb:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004d2:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004d9:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004e0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004e7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004ee:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004f5:	84 c0                	test   %al,%al
  8004f7:	74 20                	je     800519 <cprintf+0x52>
  8004f9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004fd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800501:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800505:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800509:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80050d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800511:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800515:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800519:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800520:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800527:	00 00 00 
  80052a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800531:	00 00 00 
  800534:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800538:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80053f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800546:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80054d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800554:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80055b:	48 8b 0a             	mov    (%rdx),%rcx
  80055e:	48 89 08             	mov    %rcx,(%rax)
  800561:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800565:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800569:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80056d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800571:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800578:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80057f:	48 89 d6             	mov    %rdx,%rsi
  800582:	48 89 c7             	mov    %rax,%rdi
  800585:	48 b8 1b 04 80 00 00 	movabs $0x80041b,%rax
  80058c:	00 00 00 
  80058f:	ff d0                	callq  *%rax
  800591:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800597:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80059d:	c9                   	leaveq 
  80059e:	c3                   	retq   

000000000080059f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80059f:	55                   	push   %rbp
  8005a0:	48 89 e5             	mov    %rsp,%rbp
  8005a3:	53                   	push   %rbx
  8005a4:	48 83 ec 38          	sub    $0x38,%rsp
  8005a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005ac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8005b0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8005b4:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8005b7:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8005bb:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005bf:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8005c2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8005c6:	77 3b                	ja     800603 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005c8:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8005cb:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005cf:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8005d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005db:	48 f7 f3             	div    %rbx
  8005de:	48 89 c2             	mov    %rax,%rdx
  8005e1:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005e4:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005e7:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ef:	41 89 f9             	mov    %edi,%r9d
  8005f2:	48 89 c7             	mov    %rax,%rdi
  8005f5:	48 b8 9f 05 80 00 00 	movabs $0x80059f,%rax
  8005fc:	00 00 00 
  8005ff:	ff d0                	callq  *%rax
  800601:	eb 1e                	jmp    800621 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800603:	eb 12                	jmp    800617 <printnum+0x78>
			putch(padc, putdat);
  800605:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800609:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80060c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800610:	48 89 ce             	mov    %rcx,%rsi
  800613:	89 d7                	mov    %edx,%edi
  800615:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800617:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80061b:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80061f:	7f e4                	jg     800605 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800621:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800624:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800628:	ba 00 00 00 00       	mov    $0x0,%edx
  80062d:	48 f7 f1             	div    %rcx
  800630:	48 89 d0             	mov    %rdx,%rax
  800633:	48 ba 90 19 80 00 00 	movabs $0x801990,%rdx
  80063a:	00 00 00 
  80063d:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800641:	0f be d0             	movsbl %al,%edx
  800644:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800648:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064c:	48 89 ce             	mov    %rcx,%rsi
  80064f:	89 d7                	mov    %edx,%edi
  800651:	ff d0                	callq  *%rax
}
  800653:	48 83 c4 38          	add    $0x38,%rsp
  800657:	5b                   	pop    %rbx
  800658:	5d                   	pop    %rbp
  800659:	c3                   	retq   

000000000080065a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80065a:	55                   	push   %rbp
  80065b:	48 89 e5             	mov    %rsp,%rbp
  80065e:	48 83 ec 1c          	sub    $0x1c,%rsp
  800662:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800666:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800669:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80066d:	7e 52                	jle    8006c1 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80066f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800673:	8b 00                	mov    (%rax),%eax
  800675:	83 f8 30             	cmp    $0x30,%eax
  800678:	73 24                	jae    80069e <getuint+0x44>
  80067a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800682:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800686:	8b 00                	mov    (%rax),%eax
  800688:	89 c0                	mov    %eax,%eax
  80068a:	48 01 d0             	add    %rdx,%rax
  80068d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800691:	8b 12                	mov    (%rdx),%edx
  800693:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800696:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80069a:	89 0a                	mov    %ecx,(%rdx)
  80069c:	eb 17                	jmp    8006b5 <getuint+0x5b>
  80069e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006a6:	48 89 d0             	mov    %rdx,%rax
  8006a9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006b5:	48 8b 00             	mov    (%rax),%rax
  8006b8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006bc:	e9 a3 00 00 00       	jmpq   800764 <getuint+0x10a>
	else if (lflag)
  8006c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006c5:	74 4f                	je     800716 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8006c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006cb:	8b 00                	mov    (%rax),%eax
  8006cd:	83 f8 30             	cmp    $0x30,%eax
  8006d0:	73 24                	jae    8006f6 <getuint+0x9c>
  8006d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006de:	8b 00                	mov    (%rax),%eax
  8006e0:	89 c0                	mov    %eax,%eax
  8006e2:	48 01 d0             	add    %rdx,%rax
  8006e5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e9:	8b 12                	mov    (%rdx),%edx
  8006eb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f2:	89 0a                	mov    %ecx,(%rdx)
  8006f4:	eb 17                	jmp    80070d <getuint+0xb3>
  8006f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fa:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006fe:	48 89 d0             	mov    %rdx,%rax
  800701:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800705:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800709:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80070d:	48 8b 00             	mov    (%rax),%rax
  800710:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800714:	eb 4e                	jmp    800764 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800716:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80071a:	8b 00                	mov    (%rax),%eax
  80071c:	83 f8 30             	cmp    $0x30,%eax
  80071f:	73 24                	jae    800745 <getuint+0xeb>
  800721:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800725:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800729:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80072d:	8b 00                	mov    (%rax),%eax
  80072f:	89 c0                	mov    %eax,%eax
  800731:	48 01 d0             	add    %rdx,%rax
  800734:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800738:	8b 12                	mov    (%rdx),%edx
  80073a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80073d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800741:	89 0a                	mov    %ecx,(%rdx)
  800743:	eb 17                	jmp    80075c <getuint+0x102>
  800745:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800749:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80074d:	48 89 d0             	mov    %rdx,%rax
  800750:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800754:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800758:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80075c:	8b 00                	mov    (%rax),%eax
  80075e:	89 c0                	mov    %eax,%eax
  800760:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800764:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800768:	c9                   	leaveq 
  800769:	c3                   	retq   

000000000080076a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80076a:	55                   	push   %rbp
  80076b:	48 89 e5             	mov    %rsp,%rbp
  80076e:	48 83 ec 1c          	sub    $0x1c,%rsp
  800772:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800776:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800779:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80077d:	7e 52                	jle    8007d1 <getint+0x67>
		x=va_arg(*ap, long long);
  80077f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800783:	8b 00                	mov    (%rax),%eax
  800785:	83 f8 30             	cmp    $0x30,%eax
  800788:	73 24                	jae    8007ae <getint+0x44>
  80078a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800792:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800796:	8b 00                	mov    (%rax),%eax
  800798:	89 c0                	mov    %eax,%eax
  80079a:	48 01 d0             	add    %rdx,%rax
  80079d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a1:	8b 12                	mov    (%rdx),%edx
  8007a3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007aa:	89 0a                	mov    %ecx,(%rdx)
  8007ac:	eb 17                	jmp    8007c5 <getint+0x5b>
  8007ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007b6:	48 89 d0             	mov    %rdx,%rax
  8007b9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007c5:	48 8b 00             	mov    (%rax),%rax
  8007c8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007cc:	e9 a3 00 00 00       	jmpq   800874 <getint+0x10a>
	else if (lflag)
  8007d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007d5:	74 4f                	je     800826 <getint+0xbc>
		x=va_arg(*ap, long);
  8007d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007db:	8b 00                	mov    (%rax),%eax
  8007dd:	83 f8 30             	cmp    $0x30,%eax
  8007e0:	73 24                	jae    800806 <getint+0x9c>
  8007e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ee:	8b 00                	mov    (%rax),%eax
  8007f0:	89 c0                	mov    %eax,%eax
  8007f2:	48 01 d0             	add    %rdx,%rax
  8007f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f9:	8b 12                	mov    (%rdx),%edx
  8007fb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800802:	89 0a                	mov    %ecx,(%rdx)
  800804:	eb 17                	jmp    80081d <getint+0xb3>
  800806:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80080e:	48 89 d0             	mov    %rdx,%rax
  800811:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800815:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800819:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80081d:	48 8b 00             	mov    (%rax),%rax
  800820:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800824:	eb 4e                	jmp    800874 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800826:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082a:	8b 00                	mov    (%rax),%eax
  80082c:	83 f8 30             	cmp    $0x30,%eax
  80082f:	73 24                	jae    800855 <getint+0xeb>
  800831:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800835:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800839:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083d:	8b 00                	mov    (%rax),%eax
  80083f:	89 c0                	mov    %eax,%eax
  800841:	48 01 d0             	add    %rdx,%rax
  800844:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800848:	8b 12                	mov    (%rdx),%edx
  80084a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80084d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800851:	89 0a                	mov    %ecx,(%rdx)
  800853:	eb 17                	jmp    80086c <getint+0x102>
  800855:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800859:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80085d:	48 89 d0             	mov    %rdx,%rax
  800860:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800864:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800868:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80086c:	8b 00                	mov    (%rax),%eax
  80086e:	48 98                	cltq   
  800870:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800874:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800878:	c9                   	leaveq 
  800879:	c3                   	retq   

000000000080087a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80087a:	55                   	push   %rbp
  80087b:	48 89 e5             	mov    %rsp,%rbp
  80087e:	41 54                	push   %r12
  800880:	53                   	push   %rbx
  800881:	48 83 ec 60          	sub    $0x60,%rsp
  800885:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800889:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80088d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800891:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800895:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800899:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80089d:	48 8b 0a             	mov    (%rdx),%rcx
  8008a0:	48 89 08             	mov    %rcx,(%rax)
  8008a3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008a7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008ab:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008af:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008b3:	eb 17                	jmp    8008cc <vprintfmt+0x52>
			if (ch == '\0')
  8008b5:	85 db                	test   %ebx,%ebx
  8008b7:	0f 84 df 04 00 00    	je     800d9c <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  8008bd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008c1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008c5:	48 89 d6             	mov    %rdx,%rsi
  8008c8:	89 df                	mov    %ebx,%edi
  8008ca:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008cc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008d0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008d4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008d8:	0f b6 00             	movzbl (%rax),%eax
  8008db:	0f b6 d8             	movzbl %al,%ebx
  8008de:	83 fb 25             	cmp    $0x25,%ebx
  8008e1:	75 d2                	jne    8008b5 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008e3:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008e7:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008ee:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008f5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008fc:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800903:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800907:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80090b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80090f:	0f b6 00             	movzbl (%rax),%eax
  800912:	0f b6 d8             	movzbl %al,%ebx
  800915:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800918:	83 f8 55             	cmp    $0x55,%eax
  80091b:	0f 87 47 04 00 00    	ja     800d68 <vprintfmt+0x4ee>
  800921:	89 c0                	mov    %eax,%eax
  800923:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80092a:	00 
  80092b:	48 b8 b8 19 80 00 00 	movabs $0x8019b8,%rax
  800932:	00 00 00 
  800935:	48 01 d0             	add    %rdx,%rax
  800938:	48 8b 00             	mov    (%rax),%rax
  80093b:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80093d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800941:	eb c0                	jmp    800903 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800943:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800947:	eb ba                	jmp    800903 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800949:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800950:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800953:	89 d0                	mov    %edx,%eax
  800955:	c1 e0 02             	shl    $0x2,%eax
  800958:	01 d0                	add    %edx,%eax
  80095a:	01 c0                	add    %eax,%eax
  80095c:	01 d8                	add    %ebx,%eax
  80095e:	83 e8 30             	sub    $0x30,%eax
  800961:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800964:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800968:	0f b6 00             	movzbl (%rax),%eax
  80096b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80096e:	83 fb 2f             	cmp    $0x2f,%ebx
  800971:	7e 0c                	jle    80097f <vprintfmt+0x105>
  800973:	83 fb 39             	cmp    $0x39,%ebx
  800976:	7f 07                	jg     80097f <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800978:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80097d:	eb d1                	jmp    800950 <vprintfmt+0xd6>
			goto process_precision;
  80097f:	eb 58                	jmp    8009d9 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800981:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800984:	83 f8 30             	cmp    $0x30,%eax
  800987:	73 17                	jae    8009a0 <vprintfmt+0x126>
  800989:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80098d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800990:	89 c0                	mov    %eax,%eax
  800992:	48 01 d0             	add    %rdx,%rax
  800995:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800998:	83 c2 08             	add    $0x8,%edx
  80099b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80099e:	eb 0f                	jmp    8009af <vprintfmt+0x135>
  8009a0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009a4:	48 89 d0             	mov    %rdx,%rax
  8009a7:	48 83 c2 08          	add    $0x8,%rdx
  8009ab:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009af:	8b 00                	mov    (%rax),%eax
  8009b1:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8009b4:	eb 23                	jmp    8009d9 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8009b6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009ba:	79 0c                	jns    8009c8 <vprintfmt+0x14e>
				width = 0;
  8009bc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009c3:	e9 3b ff ff ff       	jmpq   800903 <vprintfmt+0x89>
  8009c8:	e9 36 ff ff ff       	jmpq   800903 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009cd:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009d4:	e9 2a ff ff ff       	jmpq   800903 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009d9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009dd:	79 12                	jns    8009f1 <vprintfmt+0x177>
				width = precision, precision = -1;
  8009df:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009e2:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009e5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009ec:	e9 12 ff ff ff       	jmpq   800903 <vprintfmt+0x89>
  8009f1:	e9 0d ff ff ff       	jmpq   800903 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009f6:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009fa:	e9 04 ff ff ff       	jmpq   800903 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009ff:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a02:	83 f8 30             	cmp    $0x30,%eax
  800a05:	73 17                	jae    800a1e <vprintfmt+0x1a4>
  800a07:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a0b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a0e:	89 c0                	mov    %eax,%eax
  800a10:	48 01 d0             	add    %rdx,%rax
  800a13:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a16:	83 c2 08             	add    $0x8,%edx
  800a19:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a1c:	eb 0f                	jmp    800a2d <vprintfmt+0x1b3>
  800a1e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a22:	48 89 d0             	mov    %rdx,%rax
  800a25:	48 83 c2 08          	add    $0x8,%rdx
  800a29:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a2d:	8b 10                	mov    (%rax),%edx
  800a2f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a33:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a37:	48 89 ce             	mov    %rcx,%rsi
  800a3a:	89 d7                	mov    %edx,%edi
  800a3c:	ff d0                	callq  *%rax
			break;
  800a3e:	e9 53 03 00 00       	jmpq   800d96 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a43:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a46:	83 f8 30             	cmp    $0x30,%eax
  800a49:	73 17                	jae    800a62 <vprintfmt+0x1e8>
  800a4b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a4f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a52:	89 c0                	mov    %eax,%eax
  800a54:	48 01 d0             	add    %rdx,%rax
  800a57:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a5a:	83 c2 08             	add    $0x8,%edx
  800a5d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a60:	eb 0f                	jmp    800a71 <vprintfmt+0x1f7>
  800a62:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a66:	48 89 d0             	mov    %rdx,%rax
  800a69:	48 83 c2 08          	add    $0x8,%rdx
  800a6d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a71:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a73:	85 db                	test   %ebx,%ebx
  800a75:	79 02                	jns    800a79 <vprintfmt+0x1ff>
				err = -err;
  800a77:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a79:	83 fb 15             	cmp    $0x15,%ebx
  800a7c:	7f 16                	jg     800a94 <vprintfmt+0x21a>
  800a7e:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  800a85:	00 00 00 
  800a88:	48 63 d3             	movslq %ebx,%rdx
  800a8b:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a8f:	4d 85 e4             	test   %r12,%r12
  800a92:	75 2e                	jne    800ac2 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a94:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a98:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a9c:	89 d9                	mov    %ebx,%ecx
  800a9e:	48 ba a1 19 80 00 00 	movabs $0x8019a1,%rdx
  800aa5:	00 00 00 
  800aa8:	48 89 c7             	mov    %rax,%rdi
  800aab:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab0:	49 b8 a5 0d 80 00 00 	movabs $0x800da5,%r8
  800ab7:	00 00 00 
  800aba:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800abd:	e9 d4 02 00 00       	jmpq   800d96 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ac2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ac6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aca:	4c 89 e1             	mov    %r12,%rcx
  800acd:	48 ba aa 19 80 00 00 	movabs $0x8019aa,%rdx
  800ad4:	00 00 00 
  800ad7:	48 89 c7             	mov    %rax,%rdi
  800ada:	b8 00 00 00 00       	mov    $0x0,%eax
  800adf:	49 b8 a5 0d 80 00 00 	movabs $0x800da5,%r8
  800ae6:	00 00 00 
  800ae9:	41 ff d0             	callq  *%r8
			break;
  800aec:	e9 a5 02 00 00       	jmpq   800d96 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800af1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800af4:	83 f8 30             	cmp    $0x30,%eax
  800af7:	73 17                	jae    800b10 <vprintfmt+0x296>
  800af9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800afd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b00:	89 c0                	mov    %eax,%eax
  800b02:	48 01 d0             	add    %rdx,%rax
  800b05:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b08:	83 c2 08             	add    $0x8,%edx
  800b0b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b0e:	eb 0f                	jmp    800b1f <vprintfmt+0x2a5>
  800b10:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b14:	48 89 d0             	mov    %rdx,%rax
  800b17:	48 83 c2 08          	add    $0x8,%rdx
  800b1b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b1f:	4c 8b 20             	mov    (%rax),%r12
  800b22:	4d 85 e4             	test   %r12,%r12
  800b25:	75 0a                	jne    800b31 <vprintfmt+0x2b7>
				p = "(null)";
  800b27:	49 bc ad 19 80 00 00 	movabs $0x8019ad,%r12
  800b2e:	00 00 00 
			if (width > 0 && padc != '-')
  800b31:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b35:	7e 3f                	jle    800b76 <vprintfmt+0x2fc>
  800b37:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b3b:	74 39                	je     800b76 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b3d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b40:	48 98                	cltq   
  800b42:	48 89 c6             	mov    %rax,%rsi
  800b45:	4c 89 e7             	mov    %r12,%rdi
  800b48:	48 b8 51 10 80 00 00 	movabs $0x801051,%rax
  800b4f:	00 00 00 
  800b52:	ff d0                	callq  *%rax
  800b54:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b57:	eb 17                	jmp    800b70 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b59:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b5d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b61:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b65:	48 89 ce             	mov    %rcx,%rsi
  800b68:	89 d7                	mov    %edx,%edi
  800b6a:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b6c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b70:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b74:	7f e3                	jg     800b59 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b76:	eb 37                	jmp    800baf <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b78:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b7c:	74 1e                	je     800b9c <vprintfmt+0x322>
  800b7e:	83 fb 1f             	cmp    $0x1f,%ebx
  800b81:	7e 05                	jle    800b88 <vprintfmt+0x30e>
  800b83:	83 fb 7e             	cmp    $0x7e,%ebx
  800b86:	7e 14                	jle    800b9c <vprintfmt+0x322>
					putch('?', putdat);
  800b88:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b8c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b90:	48 89 d6             	mov    %rdx,%rsi
  800b93:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b98:	ff d0                	callq  *%rax
  800b9a:	eb 0f                	jmp    800bab <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b9c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ba0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba4:	48 89 d6             	mov    %rdx,%rsi
  800ba7:	89 df                	mov    %ebx,%edi
  800ba9:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bab:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800baf:	4c 89 e0             	mov    %r12,%rax
  800bb2:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800bb6:	0f b6 00             	movzbl (%rax),%eax
  800bb9:	0f be d8             	movsbl %al,%ebx
  800bbc:	85 db                	test   %ebx,%ebx
  800bbe:	74 10                	je     800bd0 <vprintfmt+0x356>
  800bc0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bc4:	78 b2                	js     800b78 <vprintfmt+0x2fe>
  800bc6:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800bca:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bce:	79 a8                	jns    800b78 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bd0:	eb 16                	jmp    800be8 <vprintfmt+0x36e>
				putch(' ', putdat);
  800bd2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bd6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bda:	48 89 d6             	mov    %rdx,%rsi
  800bdd:	bf 20 00 00 00       	mov    $0x20,%edi
  800be2:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800be4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800be8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bec:	7f e4                	jg     800bd2 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800bee:	e9 a3 01 00 00       	jmpq   800d96 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800bf3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bf7:	be 03 00 00 00       	mov    $0x3,%esi
  800bfc:	48 89 c7             	mov    %rax,%rdi
  800bff:	48 b8 6a 07 80 00 00 	movabs $0x80076a,%rax
  800c06:	00 00 00 
  800c09:	ff d0                	callq  *%rax
  800c0b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c13:	48 85 c0             	test   %rax,%rax
  800c16:	79 1d                	jns    800c35 <vprintfmt+0x3bb>
				putch('-', putdat);
  800c18:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c1c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c20:	48 89 d6             	mov    %rdx,%rsi
  800c23:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c28:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c2e:	48 f7 d8             	neg    %rax
  800c31:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c35:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c3c:	e9 e8 00 00 00       	jmpq   800d29 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c41:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c45:	be 03 00 00 00       	mov    $0x3,%esi
  800c4a:	48 89 c7             	mov    %rax,%rdi
  800c4d:	48 b8 5a 06 80 00 00 	movabs $0x80065a,%rax
  800c54:	00 00 00 
  800c57:	ff d0                	callq  *%rax
  800c59:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c5d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c64:	e9 c0 00 00 00       	jmpq   800d29 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c69:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c6d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c71:	48 89 d6             	mov    %rdx,%rsi
  800c74:	bf 58 00 00 00       	mov    $0x58,%edi
  800c79:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c7b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c7f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c83:	48 89 d6             	mov    %rdx,%rsi
  800c86:	bf 58 00 00 00       	mov    $0x58,%edi
  800c8b:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c8d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c91:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c95:	48 89 d6             	mov    %rdx,%rsi
  800c98:	bf 58 00 00 00       	mov    $0x58,%edi
  800c9d:	ff d0                	callq  *%rax
			break;
  800c9f:	e9 f2 00 00 00       	jmpq   800d96 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800ca4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ca8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cac:	48 89 d6             	mov    %rdx,%rsi
  800caf:	bf 30 00 00 00       	mov    $0x30,%edi
  800cb4:	ff d0                	callq  *%rax
			putch('x', putdat);
  800cb6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cba:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cbe:	48 89 d6             	mov    %rdx,%rsi
  800cc1:	bf 78 00 00 00       	mov    $0x78,%edi
  800cc6:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800cc8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ccb:	83 f8 30             	cmp    $0x30,%eax
  800cce:	73 17                	jae    800ce7 <vprintfmt+0x46d>
  800cd0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cd4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cd7:	89 c0                	mov    %eax,%eax
  800cd9:	48 01 d0             	add    %rdx,%rax
  800cdc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cdf:	83 c2 08             	add    $0x8,%edx
  800ce2:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ce5:	eb 0f                	jmp    800cf6 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800ce7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ceb:	48 89 d0             	mov    %rdx,%rax
  800cee:	48 83 c2 08          	add    $0x8,%rdx
  800cf2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cf6:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cf9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800cfd:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d04:	eb 23                	jmp    800d29 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d06:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d0a:	be 03 00 00 00       	mov    $0x3,%esi
  800d0f:	48 89 c7             	mov    %rax,%rdi
  800d12:	48 b8 5a 06 80 00 00 	movabs $0x80065a,%rax
  800d19:	00 00 00 
  800d1c:	ff d0                	callq  *%rax
  800d1e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d22:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d29:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d2e:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d31:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d34:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d38:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d3c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d40:	45 89 c1             	mov    %r8d,%r9d
  800d43:	41 89 f8             	mov    %edi,%r8d
  800d46:	48 89 c7             	mov    %rax,%rdi
  800d49:	48 b8 9f 05 80 00 00 	movabs $0x80059f,%rax
  800d50:	00 00 00 
  800d53:	ff d0                	callq  *%rax
			break;
  800d55:	eb 3f                	jmp    800d96 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d57:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d5b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d5f:	48 89 d6             	mov    %rdx,%rsi
  800d62:	89 df                	mov    %ebx,%edi
  800d64:	ff d0                	callq  *%rax
			break;
  800d66:	eb 2e                	jmp    800d96 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d68:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d6c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d70:	48 89 d6             	mov    %rdx,%rsi
  800d73:	bf 25 00 00 00       	mov    $0x25,%edi
  800d78:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d7a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d7f:	eb 05                	jmp    800d86 <vprintfmt+0x50c>
  800d81:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d86:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d8a:	48 83 e8 01          	sub    $0x1,%rax
  800d8e:	0f b6 00             	movzbl (%rax),%eax
  800d91:	3c 25                	cmp    $0x25,%al
  800d93:	75 ec                	jne    800d81 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800d95:	90                   	nop
		}
	}
  800d96:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d97:	e9 30 fb ff ff       	jmpq   8008cc <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d9c:	48 83 c4 60          	add    $0x60,%rsp
  800da0:	5b                   	pop    %rbx
  800da1:	41 5c                	pop    %r12
  800da3:	5d                   	pop    %rbp
  800da4:	c3                   	retq   

0000000000800da5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800da5:	55                   	push   %rbp
  800da6:	48 89 e5             	mov    %rsp,%rbp
  800da9:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800db0:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800db7:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800dbe:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800dc5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800dcc:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800dd3:	84 c0                	test   %al,%al
  800dd5:	74 20                	je     800df7 <printfmt+0x52>
  800dd7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ddb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ddf:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800de3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800de7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800deb:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800def:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800df3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800df7:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800dfe:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e05:	00 00 00 
  800e08:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e0f:	00 00 00 
  800e12:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e16:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e1d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e24:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e2b:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e32:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e39:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e40:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e47:	48 89 c7             	mov    %rax,%rdi
  800e4a:	48 b8 7a 08 80 00 00 	movabs $0x80087a,%rax
  800e51:	00 00 00 
  800e54:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e56:	c9                   	leaveq 
  800e57:	c3                   	retq   

0000000000800e58 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e58:	55                   	push   %rbp
  800e59:	48 89 e5             	mov    %rsp,%rbp
  800e5c:	48 83 ec 10          	sub    $0x10,%rsp
  800e60:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e63:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e6b:	8b 40 10             	mov    0x10(%rax),%eax
  800e6e:	8d 50 01             	lea    0x1(%rax),%edx
  800e71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e75:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e7c:	48 8b 10             	mov    (%rax),%rdx
  800e7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e83:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e87:	48 39 c2             	cmp    %rax,%rdx
  800e8a:	73 17                	jae    800ea3 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e90:	48 8b 00             	mov    (%rax),%rax
  800e93:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e97:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e9b:	48 89 0a             	mov    %rcx,(%rdx)
  800e9e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800ea1:	88 10                	mov    %dl,(%rax)
}
  800ea3:	c9                   	leaveq 
  800ea4:	c3                   	retq   

0000000000800ea5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ea5:	55                   	push   %rbp
  800ea6:	48 89 e5             	mov    %rsp,%rbp
  800ea9:	48 83 ec 50          	sub    $0x50,%rsp
  800ead:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800eb1:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800eb4:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800eb8:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ebc:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ec0:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800ec4:	48 8b 0a             	mov    (%rdx),%rcx
  800ec7:	48 89 08             	mov    %rcx,(%rax)
  800eca:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ece:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ed2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ed6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800eda:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ede:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ee2:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800ee5:	48 98                	cltq   
  800ee7:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800eeb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800eef:	48 01 d0             	add    %rdx,%rax
  800ef2:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ef6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800efd:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f02:	74 06                	je     800f0a <vsnprintf+0x65>
  800f04:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f08:	7f 07                	jg     800f11 <vsnprintf+0x6c>
		return -E_INVAL;
  800f0a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f0f:	eb 2f                	jmp    800f40 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f11:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f15:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f19:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f1d:	48 89 c6             	mov    %rax,%rsi
  800f20:	48 bf 58 0e 80 00 00 	movabs $0x800e58,%rdi
  800f27:	00 00 00 
  800f2a:	48 b8 7a 08 80 00 00 	movabs $0x80087a,%rax
  800f31:	00 00 00 
  800f34:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f36:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f3a:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f3d:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f40:	c9                   	leaveq 
  800f41:	c3                   	retq   

0000000000800f42 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f42:	55                   	push   %rbp
  800f43:	48 89 e5             	mov    %rsp,%rbp
  800f46:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f4d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f54:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f5a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f61:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f68:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f6f:	84 c0                	test   %al,%al
  800f71:	74 20                	je     800f93 <snprintf+0x51>
  800f73:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f77:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f7b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f7f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f83:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f87:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f8b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f8f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f93:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f9a:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800fa1:	00 00 00 
  800fa4:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fab:	00 00 00 
  800fae:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fb2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fb9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fc0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fc7:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fce:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fd5:	48 8b 0a             	mov    (%rdx),%rcx
  800fd8:	48 89 08             	mov    %rcx,(%rax)
  800fdb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fdf:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fe3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fe7:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800feb:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800ff2:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800ff9:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fff:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801006:	48 89 c7             	mov    %rax,%rdi
  801009:	48 b8 a5 0e 80 00 00 	movabs $0x800ea5,%rax
  801010:	00 00 00 
  801013:	ff d0                	callq  *%rax
  801015:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80101b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801021:	c9                   	leaveq 
  801022:	c3                   	retq   

0000000000801023 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801023:	55                   	push   %rbp
  801024:	48 89 e5             	mov    %rsp,%rbp
  801027:	48 83 ec 18          	sub    $0x18,%rsp
  80102b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80102f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801036:	eb 09                	jmp    801041 <strlen+0x1e>
		n++;
  801038:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80103c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801041:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801045:	0f b6 00             	movzbl (%rax),%eax
  801048:	84 c0                	test   %al,%al
  80104a:	75 ec                	jne    801038 <strlen+0x15>
		n++;
	return n;
  80104c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80104f:	c9                   	leaveq 
  801050:	c3                   	retq   

0000000000801051 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801051:	55                   	push   %rbp
  801052:	48 89 e5             	mov    %rsp,%rbp
  801055:	48 83 ec 20          	sub    $0x20,%rsp
  801059:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80105d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801061:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801068:	eb 0e                	jmp    801078 <strnlen+0x27>
		n++;
  80106a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80106e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801073:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801078:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80107d:	74 0b                	je     80108a <strnlen+0x39>
  80107f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801083:	0f b6 00             	movzbl (%rax),%eax
  801086:	84 c0                	test   %al,%al
  801088:	75 e0                	jne    80106a <strnlen+0x19>
		n++;
	return n;
  80108a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80108d:	c9                   	leaveq 
  80108e:	c3                   	retq   

000000000080108f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80108f:	55                   	push   %rbp
  801090:	48 89 e5             	mov    %rsp,%rbp
  801093:	48 83 ec 20          	sub    $0x20,%rsp
  801097:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80109b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80109f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8010a7:	90                   	nop
  8010a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ac:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010b0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010b4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010b8:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010bc:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010c0:	0f b6 12             	movzbl (%rdx),%edx
  8010c3:	88 10                	mov    %dl,(%rax)
  8010c5:	0f b6 00             	movzbl (%rax),%eax
  8010c8:	84 c0                	test   %al,%al
  8010ca:	75 dc                	jne    8010a8 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010d0:	c9                   	leaveq 
  8010d1:	c3                   	retq   

00000000008010d2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010d2:	55                   	push   %rbp
  8010d3:	48 89 e5             	mov    %rsp,%rbp
  8010d6:	48 83 ec 20          	sub    $0x20,%rsp
  8010da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e6:	48 89 c7             	mov    %rax,%rdi
  8010e9:	48 b8 23 10 80 00 00 	movabs $0x801023,%rax
  8010f0:	00 00 00 
  8010f3:	ff d0                	callq  *%rax
  8010f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010fb:	48 63 d0             	movslq %eax,%rdx
  8010fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801102:	48 01 c2             	add    %rax,%rdx
  801105:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801109:	48 89 c6             	mov    %rax,%rsi
  80110c:	48 89 d7             	mov    %rdx,%rdi
  80110f:	48 b8 8f 10 80 00 00 	movabs $0x80108f,%rax
  801116:	00 00 00 
  801119:	ff d0                	callq  *%rax
	return dst;
  80111b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80111f:	c9                   	leaveq 
  801120:	c3                   	retq   

0000000000801121 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801121:	55                   	push   %rbp
  801122:	48 89 e5             	mov    %rsp,%rbp
  801125:	48 83 ec 28          	sub    $0x28,%rsp
  801129:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80112d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801131:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801135:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801139:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80113d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801144:	00 
  801145:	eb 2a                	jmp    801171 <strncpy+0x50>
		*dst++ = *src;
  801147:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80114b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80114f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801153:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801157:	0f b6 12             	movzbl (%rdx),%edx
  80115a:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80115c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801160:	0f b6 00             	movzbl (%rax),%eax
  801163:	84 c0                	test   %al,%al
  801165:	74 05                	je     80116c <strncpy+0x4b>
			src++;
  801167:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80116c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801171:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801175:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801179:	72 cc                	jb     801147 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80117b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80117f:	c9                   	leaveq 
  801180:	c3                   	retq   

0000000000801181 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801181:	55                   	push   %rbp
  801182:	48 89 e5             	mov    %rsp,%rbp
  801185:	48 83 ec 28          	sub    $0x28,%rsp
  801189:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80118d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801191:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801195:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801199:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80119d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011a2:	74 3d                	je     8011e1 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8011a4:	eb 1d                	jmp    8011c3 <strlcpy+0x42>
			*dst++ = *src++;
  8011a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011aa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011ae:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011b2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011b6:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011ba:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011be:	0f b6 12             	movzbl (%rdx),%edx
  8011c1:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011c3:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011c8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011cd:	74 0b                	je     8011da <strlcpy+0x59>
  8011cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011d3:	0f b6 00             	movzbl (%rax),%eax
  8011d6:	84 c0                	test   %al,%al
  8011d8:	75 cc                	jne    8011a6 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011de:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e9:	48 29 c2             	sub    %rax,%rdx
  8011ec:	48 89 d0             	mov    %rdx,%rax
}
  8011ef:	c9                   	leaveq 
  8011f0:	c3                   	retq   

00000000008011f1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011f1:	55                   	push   %rbp
  8011f2:	48 89 e5             	mov    %rsp,%rbp
  8011f5:	48 83 ec 10          	sub    $0x10,%rsp
  8011f9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011fd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801201:	eb 0a                	jmp    80120d <strcmp+0x1c>
		p++, q++;
  801203:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801208:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80120d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801211:	0f b6 00             	movzbl (%rax),%eax
  801214:	84 c0                	test   %al,%al
  801216:	74 12                	je     80122a <strcmp+0x39>
  801218:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80121c:	0f b6 10             	movzbl (%rax),%edx
  80121f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801223:	0f b6 00             	movzbl (%rax),%eax
  801226:	38 c2                	cmp    %al,%dl
  801228:	74 d9                	je     801203 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80122a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122e:	0f b6 00             	movzbl (%rax),%eax
  801231:	0f b6 d0             	movzbl %al,%edx
  801234:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801238:	0f b6 00             	movzbl (%rax),%eax
  80123b:	0f b6 c0             	movzbl %al,%eax
  80123e:	29 c2                	sub    %eax,%edx
  801240:	89 d0                	mov    %edx,%eax
}
  801242:	c9                   	leaveq 
  801243:	c3                   	retq   

0000000000801244 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801244:	55                   	push   %rbp
  801245:	48 89 e5             	mov    %rsp,%rbp
  801248:	48 83 ec 18          	sub    $0x18,%rsp
  80124c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801250:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801254:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801258:	eb 0f                	jmp    801269 <strncmp+0x25>
		n--, p++, q++;
  80125a:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80125f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801264:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801269:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80126e:	74 1d                	je     80128d <strncmp+0x49>
  801270:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801274:	0f b6 00             	movzbl (%rax),%eax
  801277:	84 c0                	test   %al,%al
  801279:	74 12                	je     80128d <strncmp+0x49>
  80127b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127f:	0f b6 10             	movzbl (%rax),%edx
  801282:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801286:	0f b6 00             	movzbl (%rax),%eax
  801289:	38 c2                	cmp    %al,%dl
  80128b:	74 cd                	je     80125a <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80128d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801292:	75 07                	jne    80129b <strncmp+0x57>
		return 0;
  801294:	b8 00 00 00 00       	mov    $0x0,%eax
  801299:	eb 18                	jmp    8012b3 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80129b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129f:	0f b6 00             	movzbl (%rax),%eax
  8012a2:	0f b6 d0             	movzbl %al,%edx
  8012a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012a9:	0f b6 00             	movzbl (%rax),%eax
  8012ac:	0f b6 c0             	movzbl %al,%eax
  8012af:	29 c2                	sub    %eax,%edx
  8012b1:	89 d0                	mov    %edx,%eax
}
  8012b3:	c9                   	leaveq 
  8012b4:	c3                   	retq   

00000000008012b5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012b5:	55                   	push   %rbp
  8012b6:	48 89 e5             	mov    %rsp,%rbp
  8012b9:	48 83 ec 0c          	sub    $0xc,%rsp
  8012bd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012c1:	89 f0                	mov    %esi,%eax
  8012c3:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012c6:	eb 17                	jmp    8012df <strchr+0x2a>
		if (*s == c)
  8012c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012cc:	0f b6 00             	movzbl (%rax),%eax
  8012cf:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012d2:	75 06                	jne    8012da <strchr+0x25>
			return (char *) s;
  8012d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d8:	eb 15                	jmp    8012ef <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012da:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e3:	0f b6 00             	movzbl (%rax),%eax
  8012e6:	84 c0                	test   %al,%al
  8012e8:	75 de                	jne    8012c8 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012ef:	c9                   	leaveq 
  8012f0:	c3                   	retq   

00000000008012f1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012f1:	55                   	push   %rbp
  8012f2:	48 89 e5             	mov    %rsp,%rbp
  8012f5:	48 83 ec 0c          	sub    $0xc,%rsp
  8012f9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012fd:	89 f0                	mov    %esi,%eax
  8012ff:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801302:	eb 13                	jmp    801317 <strfind+0x26>
		if (*s == c)
  801304:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801308:	0f b6 00             	movzbl (%rax),%eax
  80130b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80130e:	75 02                	jne    801312 <strfind+0x21>
			break;
  801310:	eb 10                	jmp    801322 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801312:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801317:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80131b:	0f b6 00             	movzbl (%rax),%eax
  80131e:	84 c0                	test   %al,%al
  801320:	75 e2                	jne    801304 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801322:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801326:	c9                   	leaveq 
  801327:	c3                   	retq   

0000000000801328 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801328:	55                   	push   %rbp
  801329:	48 89 e5             	mov    %rsp,%rbp
  80132c:	48 83 ec 18          	sub    $0x18,%rsp
  801330:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801334:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801337:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80133b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801340:	75 06                	jne    801348 <memset+0x20>
		return v;
  801342:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801346:	eb 69                	jmp    8013b1 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801348:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134c:	83 e0 03             	and    $0x3,%eax
  80134f:	48 85 c0             	test   %rax,%rax
  801352:	75 48                	jne    80139c <memset+0x74>
  801354:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801358:	83 e0 03             	and    $0x3,%eax
  80135b:	48 85 c0             	test   %rax,%rax
  80135e:	75 3c                	jne    80139c <memset+0x74>
		c &= 0xFF;
  801360:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801367:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80136a:	c1 e0 18             	shl    $0x18,%eax
  80136d:	89 c2                	mov    %eax,%edx
  80136f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801372:	c1 e0 10             	shl    $0x10,%eax
  801375:	09 c2                	or     %eax,%edx
  801377:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80137a:	c1 e0 08             	shl    $0x8,%eax
  80137d:	09 d0                	or     %edx,%eax
  80137f:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801382:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801386:	48 c1 e8 02          	shr    $0x2,%rax
  80138a:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80138d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801391:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801394:	48 89 d7             	mov    %rdx,%rdi
  801397:	fc                   	cld    
  801398:	f3 ab                	rep stos %eax,%es:(%rdi)
  80139a:	eb 11                	jmp    8013ad <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80139c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013a0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013a3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013a7:	48 89 d7             	mov    %rdx,%rdi
  8013aa:	fc                   	cld    
  8013ab:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8013ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013b1:	c9                   	leaveq 
  8013b2:	c3                   	retq   

00000000008013b3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013b3:	55                   	push   %rbp
  8013b4:	48 89 e5             	mov    %rsp,%rbp
  8013b7:	48 83 ec 28          	sub    $0x28,%rsp
  8013bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013bf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013c3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013c7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013db:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013df:	0f 83 88 00 00 00    	jae    80146d <memmove+0xba>
  8013e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013ed:	48 01 d0             	add    %rdx,%rax
  8013f0:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013f4:	76 77                	jbe    80146d <memmove+0xba>
		s += n;
  8013f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013fa:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801402:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801406:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80140a:	83 e0 03             	and    $0x3,%eax
  80140d:	48 85 c0             	test   %rax,%rax
  801410:	75 3b                	jne    80144d <memmove+0x9a>
  801412:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801416:	83 e0 03             	and    $0x3,%eax
  801419:	48 85 c0             	test   %rax,%rax
  80141c:	75 2f                	jne    80144d <memmove+0x9a>
  80141e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801422:	83 e0 03             	and    $0x3,%eax
  801425:	48 85 c0             	test   %rax,%rax
  801428:	75 23                	jne    80144d <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80142a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80142e:	48 83 e8 04          	sub    $0x4,%rax
  801432:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801436:	48 83 ea 04          	sub    $0x4,%rdx
  80143a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80143e:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801442:	48 89 c7             	mov    %rax,%rdi
  801445:	48 89 d6             	mov    %rdx,%rsi
  801448:	fd                   	std    
  801449:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80144b:	eb 1d                	jmp    80146a <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80144d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801451:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801455:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801459:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80145d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801461:	48 89 d7             	mov    %rdx,%rdi
  801464:	48 89 c1             	mov    %rax,%rcx
  801467:	fd                   	std    
  801468:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80146a:	fc                   	cld    
  80146b:	eb 57                	jmp    8014c4 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80146d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801471:	83 e0 03             	and    $0x3,%eax
  801474:	48 85 c0             	test   %rax,%rax
  801477:	75 36                	jne    8014af <memmove+0xfc>
  801479:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80147d:	83 e0 03             	and    $0x3,%eax
  801480:	48 85 c0             	test   %rax,%rax
  801483:	75 2a                	jne    8014af <memmove+0xfc>
  801485:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801489:	83 e0 03             	and    $0x3,%eax
  80148c:	48 85 c0             	test   %rax,%rax
  80148f:	75 1e                	jne    8014af <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801491:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801495:	48 c1 e8 02          	shr    $0x2,%rax
  801499:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80149c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014a4:	48 89 c7             	mov    %rax,%rdi
  8014a7:	48 89 d6             	mov    %rdx,%rsi
  8014aa:	fc                   	cld    
  8014ab:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014ad:	eb 15                	jmp    8014c4 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8014af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014b7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014bb:	48 89 c7             	mov    %rax,%rdi
  8014be:	48 89 d6             	mov    %rdx,%rsi
  8014c1:	fc                   	cld    
  8014c2:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014c8:	c9                   	leaveq 
  8014c9:	c3                   	retq   

00000000008014ca <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014ca:	55                   	push   %rbp
  8014cb:	48 89 e5             	mov    %rsp,%rbp
  8014ce:	48 83 ec 18          	sub    $0x18,%rsp
  8014d2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014d6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014da:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014e2:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ea:	48 89 ce             	mov    %rcx,%rsi
  8014ed:	48 89 c7             	mov    %rax,%rdi
  8014f0:	48 b8 b3 13 80 00 00 	movabs $0x8013b3,%rax
  8014f7:	00 00 00 
  8014fa:	ff d0                	callq  *%rax
}
  8014fc:	c9                   	leaveq 
  8014fd:	c3                   	retq   

00000000008014fe <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014fe:	55                   	push   %rbp
  8014ff:	48 89 e5             	mov    %rsp,%rbp
  801502:	48 83 ec 28          	sub    $0x28,%rsp
  801506:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80150a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80150e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801512:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801516:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80151a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80151e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801522:	eb 36                	jmp    80155a <memcmp+0x5c>
		if (*s1 != *s2)
  801524:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801528:	0f b6 10             	movzbl (%rax),%edx
  80152b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80152f:	0f b6 00             	movzbl (%rax),%eax
  801532:	38 c2                	cmp    %al,%dl
  801534:	74 1a                	je     801550 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801536:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80153a:	0f b6 00             	movzbl (%rax),%eax
  80153d:	0f b6 d0             	movzbl %al,%edx
  801540:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801544:	0f b6 00             	movzbl (%rax),%eax
  801547:	0f b6 c0             	movzbl %al,%eax
  80154a:	29 c2                	sub    %eax,%edx
  80154c:	89 d0                	mov    %edx,%eax
  80154e:	eb 20                	jmp    801570 <memcmp+0x72>
		s1++, s2++;
  801550:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801555:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80155a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80155e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801562:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801566:	48 85 c0             	test   %rax,%rax
  801569:	75 b9                	jne    801524 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80156b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801570:	c9                   	leaveq 
  801571:	c3                   	retq   

0000000000801572 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801572:	55                   	push   %rbp
  801573:	48 89 e5             	mov    %rsp,%rbp
  801576:	48 83 ec 28          	sub    $0x28,%rsp
  80157a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80157e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801581:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801585:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801589:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80158d:	48 01 d0             	add    %rdx,%rax
  801590:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801594:	eb 15                	jmp    8015ab <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801596:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80159a:	0f b6 10             	movzbl (%rax),%edx
  80159d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8015a0:	38 c2                	cmp    %al,%dl
  8015a2:	75 02                	jne    8015a6 <memfind+0x34>
			break;
  8015a4:	eb 0f                	jmp    8015b5 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015a6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015af:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8015b3:	72 e1                	jb     801596 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8015b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015b9:	c9                   	leaveq 
  8015ba:	c3                   	retq   

00000000008015bb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015bb:	55                   	push   %rbp
  8015bc:	48 89 e5             	mov    %rsp,%rbp
  8015bf:	48 83 ec 34          	sub    $0x34,%rsp
  8015c3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015c7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015cb:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015d5:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015dc:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015dd:	eb 05                	jmp    8015e4 <strtol+0x29>
		s++;
  8015df:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e8:	0f b6 00             	movzbl (%rax),%eax
  8015eb:	3c 20                	cmp    $0x20,%al
  8015ed:	74 f0                	je     8015df <strtol+0x24>
  8015ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f3:	0f b6 00             	movzbl (%rax),%eax
  8015f6:	3c 09                	cmp    $0x9,%al
  8015f8:	74 e5                	je     8015df <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fe:	0f b6 00             	movzbl (%rax),%eax
  801601:	3c 2b                	cmp    $0x2b,%al
  801603:	75 07                	jne    80160c <strtol+0x51>
		s++;
  801605:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80160a:	eb 17                	jmp    801623 <strtol+0x68>
	else if (*s == '-')
  80160c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801610:	0f b6 00             	movzbl (%rax),%eax
  801613:	3c 2d                	cmp    $0x2d,%al
  801615:	75 0c                	jne    801623 <strtol+0x68>
		s++, neg = 1;
  801617:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80161c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801623:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801627:	74 06                	je     80162f <strtol+0x74>
  801629:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80162d:	75 28                	jne    801657 <strtol+0x9c>
  80162f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801633:	0f b6 00             	movzbl (%rax),%eax
  801636:	3c 30                	cmp    $0x30,%al
  801638:	75 1d                	jne    801657 <strtol+0x9c>
  80163a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163e:	48 83 c0 01          	add    $0x1,%rax
  801642:	0f b6 00             	movzbl (%rax),%eax
  801645:	3c 78                	cmp    $0x78,%al
  801647:	75 0e                	jne    801657 <strtol+0x9c>
		s += 2, base = 16;
  801649:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80164e:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801655:	eb 2c                	jmp    801683 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801657:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80165b:	75 19                	jne    801676 <strtol+0xbb>
  80165d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801661:	0f b6 00             	movzbl (%rax),%eax
  801664:	3c 30                	cmp    $0x30,%al
  801666:	75 0e                	jne    801676 <strtol+0xbb>
		s++, base = 8;
  801668:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80166d:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801674:	eb 0d                	jmp    801683 <strtol+0xc8>
	else if (base == 0)
  801676:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80167a:	75 07                	jne    801683 <strtol+0xc8>
		base = 10;
  80167c:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801683:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801687:	0f b6 00             	movzbl (%rax),%eax
  80168a:	3c 2f                	cmp    $0x2f,%al
  80168c:	7e 1d                	jle    8016ab <strtol+0xf0>
  80168e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801692:	0f b6 00             	movzbl (%rax),%eax
  801695:	3c 39                	cmp    $0x39,%al
  801697:	7f 12                	jg     8016ab <strtol+0xf0>
			dig = *s - '0';
  801699:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169d:	0f b6 00             	movzbl (%rax),%eax
  8016a0:	0f be c0             	movsbl %al,%eax
  8016a3:	83 e8 30             	sub    $0x30,%eax
  8016a6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016a9:	eb 4e                	jmp    8016f9 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8016ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016af:	0f b6 00             	movzbl (%rax),%eax
  8016b2:	3c 60                	cmp    $0x60,%al
  8016b4:	7e 1d                	jle    8016d3 <strtol+0x118>
  8016b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ba:	0f b6 00             	movzbl (%rax),%eax
  8016bd:	3c 7a                	cmp    $0x7a,%al
  8016bf:	7f 12                	jg     8016d3 <strtol+0x118>
			dig = *s - 'a' + 10;
  8016c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c5:	0f b6 00             	movzbl (%rax),%eax
  8016c8:	0f be c0             	movsbl %al,%eax
  8016cb:	83 e8 57             	sub    $0x57,%eax
  8016ce:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016d1:	eb 26                	jmp    8016f9 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d7:	0f b6 00             	movzbl (%rax),%eax
  8016da:	3c 40                	cmp    $0x40,%al
  8016dc:	7e 48                	jle    801726 <strtol+0x16b>
  8016de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e2:	0f b6 00             	movzbl (%rax),%eax
  8016e5:	3c 5a                	cmp    $0x5a,%al
  8016e7:	7f 3d                	jg     801726 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ed:	0f b6 00             	movzbl (%rax),%eax
  8016f0:	0f be c0             	movsbl %al,%eax
  8016f3:	83 e8 37             	sub    $0x37,%eax
  8016f6:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016f9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016fc:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016ff:	7c 02                	jl     801703 <strtol+0x148>
			break;
  801701:	eb 23                	jmp    801726 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801703:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801708:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80170b:	48 98                	cltq   
  80170d:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801712:	48 89 c2             	mov    %rax,%rdx
  801715:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801718:	48 98                	cltq   
  80171a:	48 01 d0             	add    %rdx,%rax
  80171d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801721:	e9 5d ff ff ff       	jmpq   801683 <strtol+0xc8>

	if (endptr)
  801726:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80172b:	74 0b                	je     801738 <strtol+0x17d>
		*endptr = (char *) s;
  80172d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801731:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801735:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801738:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80173c:	74 09                	je     801747 <strtol+0x18c>
  80173e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801742:	48 f7 d8             	neg    %rax
  801745:	eb 04                	jmp    80174b <strtol+0x190>
  801747:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80174b:	c9                   	leaveq 
  80174c:	c3                   	retq   

000000000080174d <strstr>:

char * strstr(const char *in, const char *str)
{
  80174d:	55                   	push   %rbp
  80174e:	48 89 e5             	mov    %rsp,%rbp
  801751:	48 83 ec 30          	sub    $0x30,%rsp
  801755:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801759:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80175d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801761:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801765:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801769:	0f b6 00             	movzbl (%rax),%eax
  80176c:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80176f:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801773:	75 06                	jne    80177b <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801775:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801779:	eb 6b                	jmp    8017e6 <strstr+0x99>

	len = strlen(str);
  80177b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80177f:	48 89 c7             	mov    %rax,%rdi
  801782:	48 b8 23 10 80 00 00 	movabs $0x801023,%rax
  801789:	00 00 00 
  80178c:	ff d0                	callq  *%rax
  80178e:	48 98                	cltq   
  801790:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801794:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801798:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80179c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017a0:	0f b6 00             	movzbl (%rax),%eax
  8017a3:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8017a6:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8017aa:	75 07                	jne    8017b3 <strstr+0x66>
				return (char *) 0;
  8017ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b1:	eb 33                	jmp    8017e6 <strstr+0x99>
		} while (sc != c);
  8017b3:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8017b7:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8017ba:	75 d8                	jne    801794 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8017bc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017c0:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c8:	48 89 ce             	mov    %rcx,%rsi
  8017cb:	48 89 c7             	mov    %rax,%rdi
  8017ce:	48 b8 44 12 80 00 00 	movabs $0x801244,%rax
  8017d5:	00 00 00 
  8017d8:	ff d0                	callq  *%rax
  8017da:	85 c0                	test   %eax,%eax
  8017dc:	75 b6                	jne    801794 <strstr+0x47>

	return (char *) (in - 1);
  8017de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e2:	48 83 e8 01          	sub    $0x1,%rax
}
  8017e6:	c9                   	leaveq 
  8017e7:	c3                   	retq   
