
obj/user/faultwrite:     file format elf64-x86-64


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
  80003c:	e8 1e 00 00 00       	callq  80005f <libmain>
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
	*(unsigned*)0 = 0;
  800052:	b8 00 00 00 00       	mov    $0x0,%eax
  800057:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
  80005d:	c9                   	leaveq 
  80005e:	c3                   	retq   

000000000080005f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80005f:	55                   	push   %rbp
  800060:	48 89 e5             	mov    %rsp,%rbp
  800063:	48 83 ec 10          	sub    $0x10,%rsp
  800067:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80006a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	thisenv = &envs[ENVX(sys_getenvid())];
  80006e:	48 b8 5a 02 80 00 00 	movabs $0x80025a,%rax
  800075:	00 00 00 
  800078:	ff d0                	callq  *%rax
  80007a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80007f:	48 98                	cltq   
  800081:	48 c1 e0 03          	shl    $0x3,%rax
  800085:	48 89 c2             	mov    %rax,%rdx
  800088:	48 c1 e2 05          	shl    $0x5,%rdx
  80008c:	48 29 c2             	sub    %rax,%rdx
  80008f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800096:	00 00 00 
  800099:	48 01 c2             	add    %rax,%rdx
  80009c:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000a3:	00 00 00 
  8000a6:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000ad:	7e 14                	jle    8000c3 <libmain+0x64>
		binaryname = argv[0];
  8000af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000b3:	48 8b 10             	mov    (%rax),%rdx
  8000b6:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000bd:	00 00 00 
  8000c0:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000c3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000ca:	48 89 d6             	mov    %rdx,%rsi
  8000cd:	89 c7                	mov    %eax,%edi
  8000cf:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000d6:	00 00 00 
  8000d9:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000db:	48 b8 e9 00 80 00 00 	movabs $0x8000e9,%rax
  8000e2:	00 00 00 
  8000e5:	ff d0                	callq  *%rax
}
  8000e7:	c9                   	leaveq 
  8000e8:	c3                   	retq   

00000000008000e9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e9:	55                   	push   %rbp
  8000ea:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8000ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8000f2:	48 b8 16 02 80 00 00 	movabs $0x800216,%rax
  8000f9:	00 00 00 
  8000fc:	ff d0                	callq  *%rax
}
  8000fe:	5d                   	pop    %rbp
  8000ff:	c3                   	retq   

0000000000800100 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800100:	55                   	push   %rbp
  800101:	48 89 e5             	mov    %rsp,%rbp
  800104:	53                   	push   %rbx
  800105:	48 83 ec 48          	sub    $0x48,%rsp
  800109:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80010c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80010f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800113:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800117:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80011b:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80011f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800122:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800126:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80012a:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80012e:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800132:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800136:	4c 89 c3             	mov    %r8,%rbx
  800139:	cd 30                	int    $0x30
  80013b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80013f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800143:	74 3e                	je     800183 <syscall+0x83>
  800145:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80014a:	7e 37                	jle    800183 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80014c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800150:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800153:	49 89 d0             	mov    %rdx,%r8
  800156:	89 c1                	mov    %eax,%ecx
  800158:	48 ba 0a 18 80 00 00 	movabs $0x80180a,%rdx
  80015f:	00 00 00 
  800162:	be 23 00 00 00       	mov    $0x23,%esi
  800167:	48 bf 27 18 80 00 00 	movabs $0x801827,%rdi
  80016e:	00 00 00 
  800171:	b8 00 00 00 00       	mov    $0x0,%eax
  800176:	49 b9 98 02 80 00 00 	movabs $0x800298,%r9
  80017d:	00 00 00 
  800180:	41 ff d1             	callq  *%r9

	return ret;
  800183:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800187:	48 83 c4 48          	add    $0x48,%rsp
  80018b:	5b                   	pop    %rbx
  80018c:	5d                   	pop    %rbp
  80018d:	c3                   	retq   

000000000080018e <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80018e:	55                   	push   %rbp
  80018f:	48 89 e5             	mov    %rsp,%rbp
  800192:	48 83 ec 20          	sub    $0x20,%rsp
  800196:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80019a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80019e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001a2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001a6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001ad:	00 
  8001ae:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001b4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001ba:	48 89 d1             	mov    %rdx,%rcx
  8001bd:	48 89 c2             	mov    %rax,%rdx
  8001c0:	be 00 00 00 00       	mov    $0x0,%esi
  8001c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8001ca:	48 b8 00 01 80 00 00 	movabs $0x800100,%rax
  8001d1:	00 00 00 
  8001d4:	ff d0                	callq  *%rax
}
  8001d6:	c9                   	leaveq 
  8001d7:	c3                   	retq   

00000000008001d8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8001d8:	55                   	push   %rbp
  8001d9:	48 89 e5             	mov    %rsp,%rbp
  8001dc:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001e0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001e7:	00 
  8001e8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001ee:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8001fe:	be 00 00 00 00       	mov    $0x0,%esi
  800203:	bf 01 00 00 00       	mov    $0x1,%edi
  800208:	48 b8 00 01 80 00 00 	movabs $0x800100,%rax
  80020f:	00 00 00 
  800212:	ff d0                	callq  *%rax
}
  800214:	c9                   	leaveq 
  800215:	c3                   	retq   

0000000000800216 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800216:	55                   	push   %rbp
  800217:	48 89 e5             	mov    %rsp,%rbp
  80021a:	48 83 ec 10          	sub    $0x10,%rsp
  80021e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800221:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800224:	48 98                	cltq   
  800226:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80022d:	00 
  80022e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800234:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80023a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80023f:	48 89 c2             	mov    %rax,%rdx
  800242:	be 01 00 00 00       	mov    $0x1,%esi
  800247:	bf 03 00 00 00       	mov    $0x3,%edi
  80024c:	48 b8 00 01 80 00 00 	movabs $0x800100,%rax
  800253:	00 00 00 
  800256:	ff d0                	callq  *%rax
}
  800258:	c9                   	leaveq 
  800259:	c3                   	retq   

000000000080025a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80025a:	55                   	push   %rbp
  80025b:	48 89 e5             	mov    %rsp,%rbp
  80025e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800262:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800269:	00 
  80026a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800270:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800276:	b9 00 00 00 00       	mov    $0x0,%ecx
  80027b:	ba 00 00 00 00       	mov    $0x0,%edx
  800280:	be 00 00 00 00       	mov    $0x0,%esi
  800285:	bf 02 00 00 00       	mov    $0x2,%edi
  80028a:	48 b8 00 01 80 00 00 	movabs $0x800100,%rax
  800291:	00 00 00 
  800294:	ff d0                	callq  *%rax
}
  800296:	c9                   	leaveq 
  800297:	c3                   	retq   

0000000000800298 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800298:	55                   	push   %rbp
  800299:	48 89 e5             	mov    %rsp,%rbp
  80029c:	53                   	push   %rbx
  80029d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8002a4:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8002ab:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8002b1:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8002b8:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8002bf:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8002c6:	84 c0                	test   %al,%al
  8002c8:	74 23                	je     8002ed <_panic+0x55>
  8002ca:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8002d1:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002d5:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002d9:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002dd:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002e1:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002e5:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002e9:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002ed:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002f4:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002fb:	00 00 00 
  8002fe:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800305:	00 00 00 
  800308:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80030c:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800313:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80031a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800321:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  800328:	00 00 00 
  80032b:	48 8b 18             	mov    (%rax),%rbx
  80032e:	48 b8 5a 02 80 00 00 	movabs $0x80025a,%rax
  800335:	00 00 00 
  800338:	ff d0                	callq  *%rax
  80033a:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800340:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800347:	41 89 c8             	mov    %ecx,%r8d
  80034a:	48 89 d1             	mov    %rdx,%rcx
  80034d:	48 89 da             	mov    %rbx,%rdx
  800350:	89 c6                	mov    %eax,%esi
  800352:	48 bf 38 18 80 00 00 	movabs $0x801838,%rdi
  800359:	00 00 00 
  80035c:	b8 00 00 00 00       	mov    $0x0,%eax
  800361:	49 b9 d1 04 80 00 00 	movabs $0x8004d1,%r9
  800368:	00 00 00 
  80036b:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80036e:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800375:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80037c:	48 89 d6             	mov    %rdx,%rsi
  80037f:	48 89 c7             	mov    %rax,%rdi
  800382:	48 b8 25 04 80 00 00 	movabs $0x800425,%rax
  800389:	00 00 00 
  80038c:	ff d0                	callq  *%rax
	cprintf("\n");
  80038e:	48 bf 5b 18 80 00 00 	movabs $0x80185b,%rdi
  800395:	00 00 00 
  800398:	b8 00 00 00 00       	mov    $0x0,%eax
  80039d:	48 ba d1 04 80 00 00 	movabs $0x8004d1,%rdx
  8003a4:	00 00 00 
  8003a7:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003a9:	cc                   	int3   
  8003aa:	eb fd                	jmp    8003a9 <_panic+0x111>

00000000008003ac <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8003ac:	55                   	push   %rbp
  8003ad:	48 89 e5             	mov    %rsp,%rbp
  8003b0:	48 83 ec 10          	sub    $0x10,%rsp
  8003b4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003b7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8003bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003bf:	8b 00                	mov    (%rax),%eax
  8003c1:	8d 48 01             	lea    0x1(%rax),%ecx
  8003c4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003c8:	89 0a                	mov    %ecx,(%rdx)
  8003ca:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003cd:	89 d1                	mov    %edx,%ecx
  8003cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003d3:	48 98                	cltq   
  8003d5:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8003d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003dd:	8b 00                	mov    (%rax),%eax
  8003df:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003e4:	75 2c                	jne    800412 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ea:	8b 00                	mov    (%rax),%eax
  8003ec:	48 98                	cltq   
  8003ee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003f2:	48 83 c2 08          	add    $0x8,%rdx
  8003f6:	48 89 c6             	mov    %rax,%rsi
  8003f9:	48 89 d7             	mov    %rdx,%rdi
  8003fc:	48 b8 8e 01 80 00 00 	movabs $0x80018e,%rax
  800403:	00 00 00 
  800406:	ff d0                	callq  *%rax
        b->idx = 0;
  800408:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80040c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800412:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800416:	8b 40 04             	mov    0x4(%rax),%eax
  800419:	8d 50 01             	lea    0x1(%rax),%edx
  80041c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420:	89 50 04             	mov    %edx,0x4(%rax)
}
  800423:	c9                   	leaveq 
  800424:	c3                   	retq   

0000000000800425 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800425:	55                   	push   %rbp
  800426:	48 89 e5             	mov    %rsp,%rbp
  800429:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800430:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800437:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80043e:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800445:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80044c:	48 8b 0a             	mov    (%rdx),%rcx
  80044f:	48 89 08             	mov    %rcx,(%rax)
  800452:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800456:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80045a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80045e:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800462:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800469:	00 00 00 
    b.cnt = 0;
  80046c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800473:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800476:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80047d:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800484:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80048b:	48 89 c6             	mov    %rax,%rsi
  80048e:	48 bf ac 03 80 00 00 	movabs $0x8003ac,%rdi
  800495:	00 00 00 
  800498:	48 b8 84 08 80 00 00 	movabs $0x800884,%rax
  80049f:	00 00 00 
  8004a2:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8004a4:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8004aa:	48 98                	cltq   
  8004ac:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8004b3:	48 83 c2 08          	add    $0x8,%rdx
  8004b7:	48 89 c6             	mov    %rax,%rsi
  8004ba:	48 89 d7             	mov    %rdx,%rdi
  8004bd:	48 b8 8e 01 80 00 00 	movabs $0x80018e,%rax
  8004c4:	00 00 00 
  8004c7:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8004c9:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004cf:	c9                   	leaveq 
  8004d0:	c3                   	retq   

00000000008004d1 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8004d1:	55                   	push   %rbp
  8004d2:	48 89 e5             	mov    %rsp,%rbp
  8004d5:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004dc:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004e3:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004ea:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004f1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004f8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004ff:	84 c0                	test   %al,%al
  800501:	74 20                	je     800523 <cprintf+0x52>
  800503:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800507:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80050b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80050f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800513:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800517:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80051b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80051f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800523:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80052a:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800531:	00 00 00 
  800534:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80053b:	00 00 00 
  80053e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800542:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800549:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800550:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800557:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80055e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800565:	48 8b 0a             	mov    (%rdx),%rcx
  800568:	48 89 08             	mov    %rcx,(%rax)
  80056b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80056f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800573:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800577:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80057b:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800582:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800589:	48 89 d6             	mov    %rdx,%rsi
  80058c:	48 89 c7             	mov    %rax,%rdi
  80058f:	48 b8 25 04 80 00 00 	movabs $0x800425,%rax
  800596:	00 00 00 
  800599:	ff d0                	callq  *%rax
  80059b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8005a1:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8005a7:	c9                   	leaveq 
  8005a8:	c3                   	retq   

00000000008005a9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005a9:	55                   	push   %rbp
  8005aa:	48 89 e5             	mov    %rsp,%rbp
  8005ad:	53                   	push   %rbx
  8005ae:	48 83 ec 38          	sub    $0x38,%rsp
  8005b2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005b6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8005ba:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8005be:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8005c1:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8005c5:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005c9:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8005cc:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8005d0:	77 3b                	ja     80060d <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005d2:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8005d5:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005d9:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8005dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e5:	48 f7 f3             	div    %rbx
  8005e8:	48 89 c2             	mov    %rax,%rdx
  8005eb:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005ee:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005f1:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f9:	41 89 f9             	mov    %edi,%r9d
  8005fc:	48 89 c7             	mov    %rax,%rdi
  8005ff:	48 b8 a9 05 80 00 00 	movabs $0x8005a9,%rax
  800606:	00 00 00 
  800609:	ff d0                	callq  *%rax
  80060b:	eb 1e                	jmp    80062b <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80060d:	eb 12                	jmp    800621 <printnum+0x78>
			putch(padc, putdat);
  80060f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800613:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800616:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061a:	48 89 ce             	mov    %rcx,%rsi
  80061d:	89 d7                	mov    %edx,%edi
  80061f:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800621:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800625:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800629:	7f e4                	jg     80060f <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80062b:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80062e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800632:	ba 00 00 00 00       	mov    $0x0,%edx
  800637:	48 f7 f1             	div    %rcx
  80063a:	48 89 d0             	mov    %rdx,%rax
  80063d:	48 ba 90 19 80 00 00 	movabs $0x801990,%rdx
  800644:	00 00 00 
  800647:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80064b:	0f be d0             	movsbl %al,%edx
  80064e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800652:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800656:	48 89 ce             	mov    %rcx,%rsi
  800659:	89 d7                	mov    %edx,%edi
  80065b:	ff d0                	callq  *%rax
}
  80065d:	48 83 c4 38          	add    $0x38,%rsp
  800661:	5b                   	pop    %rbx
  800662:	5d                   	pop    %rbp
  800663:	c3                   	retq   

0000000000800664 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800664:	55                   	push   %rbp
  800665:	48 89 e5             	mov    %rsp,%rbp
  800668:	48 83 ec 1c          	sub    $0x1c,%rsp
  80066c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800670:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800673:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800677:	7e 52                	jle    8006cb <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800679:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067d:	8b 00                	mov    (%rax),%eax
  80067f:	83 f8 30             	cmp    $0x30,%eax
  800682:	73 24                	jae    8006a8 <getuint+0x44>
  800684:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800688:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80068c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800690:	8b 00                	mov    (%rax),%eax
  800692:	89 c0                	mov    %eax,%eax
  800694:	48 01 d0             	add    %rdx,%rax
  800697:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80069b:	8b 12                	mov    (%rdx),%edx
  80069d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a4:	89 0a                	mov    %ecx,(%rdx)
  8006a6:	eb 17                	jmp    8006bf <getuint+0x5b>
  8006a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ac:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006b0:	48 89 d0             	mov    %rdx,%rax
  8006b3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006bb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006bf:	48 8b 00             	mov    (%rax),%rax
  8006c2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006c6:	e9 a3 00 00 00       	jmpq   80076e <getuint+0x10a>
	else if (lflag)
  8006cb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006cf:	74 4f                	je     800720 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8006d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d5:	8b 00                	mov    (%rax),%eax
  8006d7:	83 f8 30             	cmp    $0x30,%eax
  8006da:	73 24                	jae    800700 <getuint+0x9c>
  8006dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e8:	8b 00                	mov    (%rax),%eax
  8006ea:	89 c0                	mov    %eax,%eax
  8006ec:	48 01 d0             	add    %rdx,%rax
  8006ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f3:	8b 12                	mov    (%rdx),%edx
  8006f5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006fc:	89 0a                	mov    %ecx,(%rdx)
  8006fe:	eb 17                	jmp    800717 <getuint+0xb3>
  800700:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800704:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800708:	48 89 d0             	mov    %rdx,%rax
  80070b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80070f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800713:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800717:	48 8b 00             	mov    (%rax),%rax
  80071a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80071e:	eb 4e                	jmp    80076e <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800720:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800724:	8b 00                	mov    (%rax),%eax
  800726:	83 f8 30             	cmp    $0x30,%eax
  800729:	73 24                	jae    80074f <getuint+0xeb>
  80072b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80072f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800733:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800737:	8b 00                	mov    (%rax),%eax
  800739:	89 c0                	mov    %eax,%eax
  80073b:	48 01 d0             	add    %rdx,%rax
  80073e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800742:	8b 12                	mov    (%rdx),%edx
  800744:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800747:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80074b:	89 0a                	mov    %ecx,(%rdx)
  80074d:	eb 17                	jmp    800766 <getuint+0x102>
  80074f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800753:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800757:	48 89 d0             	mov    %rdx,%rax
  80075a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80075e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800762:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800766:	8b 00                	mov    (%rax),%eax
  800768:	89 c0                	mov    %eax,%eax
  80076a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80076e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800772:	c9                   	leaveq 
  800773:	c3                   	retq   

0000000000800774 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800774:	55                   	push   %rbp
  800775:	48 89 e5             	mov    %rsp,%rbp
  800778:	48 83 ec 1c          	sub    $0x1c,%rsp
  80077c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800780:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800783:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800787:	7e 52                	jle    8007db <getint+0x67>
		x=va_arg(*ap, long long);
  800789:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078d:	8b 00                	mov    (%rax),%eax
  80078f:	83 f8 30             	cmp    $0x30,%eax
  800792:	73 24                	jae    8007b8 <getint+0x44>
  800794:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800798:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80079c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a0:	8b 00                	mov    (%rax),%eax
  8007a2:	89 c0                	mov    %eax,%eax
  8007a4:	48 01 d0             	add    %rdx,%rax
  8007a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ab:	8b 12                	mov    (%rdx),%edx
  8007ad:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b4:	89 0a                	mov    %ecx,(%rdx)
  8007b6:	eb 17                	jmp    8007cf <getint+0x5b>
  8007b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007bc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007c0:	48 89 d0             	mov    %rdx,%rax
  8007c3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007cb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007cf:	48 8b 00             	mov    (%rax),%rax
  8007d2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007d6:	e9 a3 00 00 00       	jmpq   80087e <getint+0x10a>
	else if (lflag)
  8007db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007df:	74 4f                	je     800830 <getint+0xbc>
		x=va_arg(*ap, long);
  8007e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e5:	8b 00                	mov    (%rax),%eax
  8007e7:	83 f8 30             	cmp    $0x30,%eax
  8007ea:	73 24                	jae    800810 <getint+0x9c>
  8007ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f8:	8b 00                	mov    (%rax),%eax
  8007fa:	89 c0                	mov    %eax,%eax
  8007fc:	48 01 d0             	add    %rdx,%rax
  8007ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800803:	8b 12                	mov    (%rdx),%edx
  800805:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800808:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080c:	89 0a                	mov    %ecx,(%rdx)
  80080e:	eb 17                	jmp    800827 <getint+0xb3>
  800810:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800814:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800818:	48 89 d0             	mov    %rdx,%rax
  80081b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80081f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800823:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800827:	48 8b 00             	mov    (%rax),%rax
  80082a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80082e:	eb 4e                	jmp    80087e <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800830:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800834:	8b 00                	mov    (%rax),%eax
  800836:	83 f8 30             	cmp    $0x30,%eax
  800839:	73 24                	jae    80085f <getint+0xeb>
  80083b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800843:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800847:	8b 00                	mov    (%rax),%eax
  800849:	89 c0                	mov    %eax,%eax
  80084b:	48 01 d0             	add    %rdx,%rax
  80084e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800852:	8b 12                	mov    (%rdx),%edx
  800854:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800857:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80085b:	89 0a                	mov    %ecx,(%rdx)
  80085d:	eb 17                	jmp    800876 <getint+0x102>
  80085f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800863:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800867:	48 89 d0             	mov    %rdx,%rax
  80086a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80086e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800872:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800876:	8b 00                	mov    (%rax),%eax
  800878:	48 98                	cltq   
  80087a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80087e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800882:	c9                   	leaveq 
  800883:	c3                   	retq   

0000000000800884 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800884:	55                   	push   %rbp
  800885:	48 89 e5             	mov    %rsp,%rbp
  800888:	41 54                	push   %r12
  80088a:	53                   	push   %rbx
  80088b:	48 83 ec 60          	sub    $0x60,%rsp
  80088f:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800893:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800897:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80089b:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80089f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8008a3:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8008a7:	48 8b 0a             	mov    (%rdx),%rcx
  8008aa:	48 89 08             	mov    %rcx,(%rax)
  8008ad:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008b1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008b5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008b9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008bd:	eb 17                	jmp    8008d6 <vprintfmt+0x52>
			if (ch == '\0')
  8008bf:	85 db                	test   %ebx,%ebx
  8008c1:	0f 84 df 04 00 00    	je     800da6 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  8008c7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008cb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008cf:	48 89 d6             	mov    %rdx,%rsi
  8008d2:	89 df                	mov    %ebx,%edi
  8008d4:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008d6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008da:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008de:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008e2:	0f b6 00             	movzbl (%rax),%eax
  8008e5:	0f b6 d8             	movzbl %al,%ebx
  8008e8:	83 fb 25             	cmp    $0x25,%ebx
  8008eb:	75 d2                	jne    8008bf <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008ed:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008f1:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008f8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008ff:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800906:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80090d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800911:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800915:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800919:	0f b6 00             	movzbl (%rax),%eax
  80091c:	0f b6 d8             	movzbl %al,%ebx
  80091f:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800922:	83 f8 55             	cmp    $0x55,%eax
  800925:	0f 87 47 04 00 00    	ja     800d72 <vprintfmt+0x4ee>
  80092b:	89 c0                	mov    %eax,%eax
  80092d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800934:	00 
  800935:	48 b8 b8 19 80 00 00 	movabs $0x8019b8,%rax
  80093c:	00 00 00 
  80093f:	48 01 d0             	add    %rdx,%rax
  800942:	48 8b 00             	mov    (%rax),%rax
  800945:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800947:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80094b:	eb c0                	jmp    80090d <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80094d:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800951:	eb ba                	jmp    80090d <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800953:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80095a:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80095d:	89 d0                	mov    %edx,%eax
  80095f:	c1 e0 02             	shl    $0x2,%eax
  800962:	01 d0                	add    %edx,%eax
  800964:	01 c0                	add    %eax,%eax
  800966:	01 d8                	add    %ebx,%eax
  800968:	83 e8 30             	sub    $0x30,%eax
  80096b:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80096e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800972:	0f b6 00             	movzbl (%rax),%eax
  800975:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800978:	83 fb 2f             	cmp    $0x2f,%ebx
  80097b:	7e 0c                	jle    800989 <vprintfmt+0x105>
  80097d:	83 fb 39             	cmp    $0x39,%ebx
  800980:	7f 07                	jg     800989 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800982:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800987:	eb d1                	jmp    80095a <vprintfmt+0xd6>
			goto process_precision;
  800989:	eb 58                	jmp    8009e3 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80098b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80098e:	83 f8 30             	cmp    $0x30,%eax
  800991:	73 17                	jae    8009aa <vprintfmt+0x126>
  800993:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800997:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80099a:	89 c0                	mov    %eax,%eax
  80099c:	48 01 d0             	add    %rdx,%rax
  80099f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009a2:	83 c2 08             	add    $0x8,%edx
  8009a5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009a8:	eb 0f                	jmp    8009b9 <vprintfmt+0x135>
  8009aa:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009ae:	48 89 d0             	mov    %rdx,%rax
  8009b1:	48 83 c2 08          	add    $0x8,%rdx
  8009b5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009b9:	8b 00                	mov    (%rax),%eax
  8009bb:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8009be:	eb 23                	jmp    8009e3 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8009c0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009c4:	79 0c                	jns    8009d2 <vprintfmt+0x14e>
				width = 0;
  8009c6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009cd:	e9 3b ff ff ff       	jmpq   80090d <vprintfmt+0x89>
  8009d2:	e9 36 ff ff ff       	jmpq   80090d <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009d7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009de:	e9 2a ff ff ff       	jmpq   80090d <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009e3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009e7:	79 12                	jns    8009fb <vprintfmt+0x177>
				width = precision, precision = -1;
  8009e9:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009ec:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009ef:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009f6:	e9 12 ff ff ff       	jmpq   80090d <vprintfmt+0x89>
  8009fb:	e9 0d ff ff ff       	jmpq   80090d <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a00:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a04:	e9 04 ff ff ff       	jmpq   80090d <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a09:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a0c:	83 f8 30             	cmp    $0x30,%eax
  800a0f:	73 17                	jae    800a28 <vprintfmt+0x1a4>
  800a11:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a15:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a18:	89 c0                	mov    %eax,%eax
  800a1a:	48 01 d0             	add    %rdx,%rax
  800a1d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a20:	83 c2 08             	add    $0x8,%edx
  800a23:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a26:	eb 0f                	jmp    800a37 <vprintfmt+0x1b3>
  800a28:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a2c:	48 89 d0             	mov    %rdx,%rax
  800a2f:	48 83 c2 08          	add    $0x8,%rdx
  800a33:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a37:	8b 10                	mov    (%rax),%edx
  800a39:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a3d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a41:	48 89 ce             	mov    %rcx,%rsi
  800a44:	89 d7                	mov    %edx,%edi
  800a46:	ff d0                	callq  *%rax
			break;
  800a48:	e9 53 03 00 00       	jmpq   800da0 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a4d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a50:	83 f8 30             	cmp    $0x30,%eax
  800a53:	73 17                	jae    800a6c <vprintfmt+0x1e8>
  800a55:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a59:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a5c:	89 c0                	mov    %eax,%eax
  800a5e:	48 01 d0             	add    %rdx,%rax
  800a61:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a64:	83 c2 08             	add    $0x8,%edx
  800a67:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a6a:	eb 0f                	jmp    800a7b <vprintfmt+0x1f7>
  800a6c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a70:	48 89 d0             	mov    %rdx,%rax
  800a73:	48 83 c2 08          	add    $0x8,%rdx
  800a77:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a7b:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a7d:	85 db                	test   %ebx,%ebx
  800a7f:	79 02                	jns    800a83 <vprintfmt+0x1ff>
				err = -err;
  800a81:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a83:	83 fb 15             	cmp    $0x15,%ebx
  800a86:	7f 16                	jg     800a9e <vprintfmt+0x21a>
  800a88:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  800a8f:	00 00 00 
  800a92:	48 63 d3             	movslq %ebx,%rdx
  800a95:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a99:	4d 85 e4             	test   %r12,%r12
  800a9c:	75 2e                	jne    800acc <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a9e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800aa2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aa6:	89 d9                	mov    %ebx,%ecx
  800aa8:	48 ba a1 19 80 00 00 	movabs $0x8019a1,%rdx
  800aaf:	00 00 00 
  800ab2:	48 89 c7             	mov    %rax,%rdi
  800ab5:	b8 00 00 00 00       	mov    $0x0,%eax
  800aba:	49 b8 af 0d 80 00 00 	movabs $0x800daf,%r8
  800ac1:	00 00 00 
  800ac4:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ac7:	e9 d4 02 00 00       	jmpq   800da0 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800acc:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ad0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ad4:	4c 89 e1             	mov    %r12,%rcx
  800ad7:	48 ba aa 19 80 00 00 	movabs $0x8019aa,%rdx
  800ade:	00 00 00 
  800ae1:	48 89 c7             	mov    %rax,%rdi
  800ae4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae9:	49 b8 af 0d 80 00 00 	movabs $0x800daf,%r8
  800af0:	00 00 00 
  800af3:	41 ff d0             	callq  *%r8
			break;
  800af6:	e9 a5 02 00 00       	jmpq   800da0 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800afb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800afe:	83 f8 30             	cmp    $0x30,%eax
  800b01:	73 17                	jae    800b1a <vprintfmt+0x296>
  800b03:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b07:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b0a:	89 c0                	mov    %eax,%eax
  800b0c:	48 01 d0             	add    %rdx,%rax
  800b0f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b12:	83 c2 08             	add    $0x8,%edx
  800b15:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b18:	eb 0f                	jmp    800b29 <vprintfmt+0x2a5>
  800b1a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b1e:	48 89 d0             	mov    %rdx,%rax
  800b21:	48 83 c2 08          	add    $0x8,%rdx
  800b25:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b29:	4c 8b 20             	mov    (%rax),%r12
  800b2c:	4d 85 e4             	test   %r12,%r12
  800b2f:	75 0a                	jne    800b3b <vprintfmt+0x2b7>
				p = "(null)";
  800b31:	49 bc ad 19 80 00 00 	movabs $0x8019ad,%r12
  800b38:	00 00 00 
			if (width > 0 && padc != '-')
  800b3b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b3f:	7e 3f                	jle    800b80 <vprintfmt+0x2fc>
  800b41:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b45:	74 39                	je     800b80 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b47:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b4a:	48 98                	cltq   
  800b4c:	48 89 c6             	mov    %rax,%rsi
  800b4f:	4c 89 e7             	mov    %r12,%rdi
  800b52:	48 b8 5b 10 80 00 00 	movabs $0x80105b,%rax
  800b59:	00 00 00 
  800b5c:	ff d0                	callq  *%rax
  800b5e:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b61:	eb 17                	jmp    800b7a <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b63:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b67:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b6b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b6f:	48 89 ce             	mov    %rcx,%rsi
  800b72:	89 d7                	mov    %edx,%edi
  800b74:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b76:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b7a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b7e:	7f e3                	jg     800b63 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b80:	eb 37                	jmp    800bb9 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b82:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b86:	74 1e                	je     800ba6 <vprintfmt+0x322>
  800b88:	83 fb 1f             	cmp    $0x1f,%ebx
  800b8b:	7e 05                	jle    800b92 <vprintfmt+0x30e>
  800b8d:	83 fb 7e             	cmp    $0x7e,%ebx
  800b90:	7e 14                	jle    800ba6 <vprintfmt+0x322>
					putch('?', putdat);
  800b92:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b96:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b9a:	48 89 d6             	mov    %rdx,%rsi
  800b9d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800ba2:	ff d0                	callq  *%rax
  800ba4:	eb 0f                	jmp    800bb5 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800ba6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800baa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bae:	48 89 d6             	mov    %rdx,%rsi
  800bb1:	89 df                	mov    %ebx,%edi
  800bb3:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bb5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bb9:	4c 89 e0             	mov    %r12,%rax
  800bbc:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800bc0:	0f b6 00             	movzbl (%rax),%eax
  800bc3:	0f be d8             	movsbl %al,%ebx
  800bc6:	85 db                	test   %ebx,%ebx
  800bc8:	74 10                	je     800bda <vprintfmt+0x356>
  800bca:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bce:	78 b2                	js     800b82 <vprintfmt+0x2fe>
  800bd0:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800bd4:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bd8:	79 a8                	jns    800b82 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bda:	eb 16                	jmp    800bf2 <vprintfmt+0x36e>
				putch(' ', putdat);
  800bdc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800be0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800be4:	48 89 d6             	mov    %rdx,%rsi
  800be7:	bf 20 00 00 00       	mov    $0x20,%edi
  800bec:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bee:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bf2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bf6:	7f e4                	jg     800bdc <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800bf8:	e9 a3 01 00 00       	jmpq   800da0 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800bfd:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c01:	be 03 00 00 00       	mov    $0x3,%esi
  800c06:	48 89 c7             	mov    %rax,%rdi
  800c09:	48 b8 74 07 80 00 00 	movabs $0x800774,%rax
  800c10:	00 00 00 
  800c13:	ff d0                	callq  *%rax
  800c15:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c1d:	48 85 c0             	test   %rax,%rax
  800c20:	79 1d                	jns    800c3f <vprintfmt+0x3bb>
				putch('-', putdat);
  800c22:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c26:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c2a:	48 89 d6             	mov    %rdx,%rsi
  800c2d:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c32:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c38:	48 f7 d8             	neg    %rax
  800c3b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c3f:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c46:	e9 e8 00 00 00       	jmpq   800d33 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c4b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c4f:	be 03 00 00 00       	mov    $0x3,%esi
  800c54:	48 89 c7             	mov    %rax,%rdi
  800c57:	48 b8 64 06 80 00 00 	movabs $0x800664,%rax
  800c5e:	00 00 00 
  800c61:	ff d0                	callq  *%rax
  800c63:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c67:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c6e:	e9 c0 00 00 00       	jmpq   800d33 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c73:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c77:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c7b:	48 89 d6             	mov    %rdx,%rsi
  800c7e:	bf 58 00 00 00       	mov    $0x58,%edi
  800c83:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c85:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c89:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c8d:	48 89 d6             	mov    %rdx,%rsi
  800c90:	bf 58 00 00 00       	mov    $0x58,%edi
  800c95:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c97:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c9b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c9f:	48 89 d6             	mov    %rdx,%rsi
  800ca2:	bf 58 00 00 00       	mov    $0x58,%edi
  800ca7:	ff d0                	callq  *%rax
			break;
  800ca9:	e9 f2 00 00 00       	jmpq   800da0 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800cae:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cb2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cb6:	48 89 d6             	mov    %rdx,%rsi
  800cb9:	bf 30 00 00 00       	mov    $0x30,%edi
  800cbe:	ff d0                	callq  *%rax
			putch('x', putdat);
  800cc0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cc4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cc8:	48 89 d6             	mov    %rdx,%rsi
  800ccb:	bf 78 00 00 00       	mov    $0x78,%edi
  800cd0:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800cd2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cd5:	83 f8 30             	cmp    $0x30,%eax
  800cd8:	73 17                	jae    800cf1 <vprintfmt+0x46d>
  800cda:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cde:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ce1:	89 c0                	mov    %eax,%eax
  800ce3:	48 01 d0             	add    %rdx,%rax
  800ce6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ce9:	83 c2 08             	add    $0x8,%edx
  800cec:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cef:	eb 0f                	jmp    800d00 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800cf1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cf5:	48 89 d0             	mov    %rdx,%rax
  800cf8:	48 83 c2 08          	add    $0x8,%rdx
  800cfc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d00:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d03:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d07:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d0e:	eb 23                	jmp    800d33 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d10:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d14:	be 03 00 00 00       	mov    $0x3,%esi
  800d19:	48 89 c7             	mov    %rax,%rdi
  800d1c:	48 b8 64 06 80 00 00 	movabs $0x800664,%rax
  800d23:	00 00 00 
  800d26:	ff d0                	callq  *%rax
  800d28:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d2c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d33:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d38:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d3b:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d3e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d42:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d46:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d4a:	45 89 c1             	mov    %r8d,%r9d
  800d4d:	41 89 f8             	mov    %edi,%r8d
  800d50:	48 89 c7             	mov    %rax,%rdi
  800d53:	48 b8 a9 05 80 00 00 	movabs $0x8005a9,%rax
  800d5a:	00 00 00 
  800d5d:	ff d0                	callq  *%rax
			break;
  800d5f:	eb 3f                	jmp    800da0 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d61:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d65:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d69:	48 89 d6             	mov    %rdx,%rsi
  800d6c:	89 df                	mov    %ebx,%edi
  800d6e:	ff d0                	callq  *%rax
			break;
  800d70:	eb 2e                	jmp    800da0 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d72:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d76:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d7a:	48 89 d6             	mov    %rdx,%rsi
  800d7d:	bf 25 00 00 00       	mov    $0x25,%edi
  800d82:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d84:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d89:	eb 05                	jmp    800d90 <vprintfmt+0x50c>
  800d8b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d90:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d94:	48 83 e8 01          	sub    $0x1,%rax
  800d98:	0f b6 00             	movzbl (%rax),%eax
  800d9b:	3c 25                	cmp    $0x25,%al
  800d9d:	75 ec                	jne    800d8b <vprintfmt+0x507>
				/* do nothing */;
			break;
  800d9f:	90                   	nop
		}
	}
  800da0:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800da1:	e9 30 fb ff ff       	jmpq   8008d6 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800da6:	48 83 c4 60          	add    $0x60,%rsp
  800daa:	5b                   	pop    %rbx
  800dab:	41 5c                	pop    %r12
  800dad:	5d                   	pop    %rbp
  800dae:	c3                   	retq   

0000000000800daf <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800daf:	55                   	push   %rbp
  800db0:	48 89 e5             	mov    %rsp,%rbp
  800db3:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800dba:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800dc1:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800dc8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800dcf:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800dd6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ddd:	84 c0                	test   %al,%al
  800ddf:	74 20                	je     800e01 <printfmt+0x52>
  800de1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800de5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800de9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ded:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800df1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800df5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800df9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dfd:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e01:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e08:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e0f:	00 00 00 
  800e12:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e19:	00 00 00 
  800e1c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e20:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e27:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e2e:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e35:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e3c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e43:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e4a:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e51:	48 89 c7             	mov    %rax,%rdi
  800e54:	48 b8 84 08 80 00 00 	movabs $0x800884,%rax
  800e5b:	00 00 00 
  800e5e:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e60:	c9                   	leaveq 
  800e61:	c3                   	retq   

0000000000800e62 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e62:	55                   	push   %rbp
  800e63:	48 89 e5             	mov    %rsp,%rbp
  800e66:	48 83 ec 10          	sub    $0x10,%rsp
  800e6a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e6d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e75:	8b 40 10             	mov    0x10(%rax),%eax
  800e78:	8d 50 01             	lea    0x1(%rax),%edx
  800e7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e7f:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e86:	48 8b 10             	mov    (%rax),%rdx
  800e89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e8d:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e91:	48 39 c2             	cmp    %rax,%rdx
  800e94:	73 17                	jae    800ead <sprintputch+0x4b>
		*b->buf++ = ch;
  800e96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e9a:	48 8b 00             	mov    (%rax),%rax
  800e9d:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800ea1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ea5:	48 89 0a             	mov    %rcx,(%rdx)
  800ea8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800eab:	88 10                	mov    %dl,(%rax)
}
  800ead:	c9                   	leaveq 
  800eae:	c3                   	retq   

0000000000800eaf <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800eaf:	55                   	push   %rbp
  800eb0:	48 89 e5             	mov    %rsp,%rbp
  800eb3:	48 83 ec 50          	sub    $0x50,%rsp
  800eb7:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800ebb:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800ebe:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ec2:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ec6:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800eca:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800ece:	48 8b 0a             	mov    (%rdx),%rcx
  800ed1:	48 89 08             	mov    %rcx,(%rax)
  800ed4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ed8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800edc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ee0:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ee4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ee8:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800eec:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800eef:	48 98                	cltq   
  800ef1:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800ef5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ef9:	48 01 d0             	add    %rdx,%rax
  800efc:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f00:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f07:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f0c:	74 06                	je     800f14 <vsnprintf+0x65>
  800f0e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f12:	7f 07                	jg     800f1b <vsnprintf+0x6c>
		return -E_INVAL;
  800f14:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f19:	eb 2f                	jmp    800f4a <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f1b:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f1f:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f23:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f27:	48 89 c6             	mov    %rax,%rsi
  800f2a:	48 bf 62 0e 80 00 00 	movabs $0x800e62,%rdi
  800f31:	00 00 00 
  800f34:	48 b8 84 08 80 00 00 	movabs $0x800884,%rax
  800f3b:	00 00 00 
  800f3e:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f40:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f44:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f47:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f4a:	c9                   	leaveq 
  800f4b:	c3                   	retq   

0000000000800f4c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f4c:	55                   	push   %rbp
  800f4d:	48 89 e5             	mov    %rsp,%rbp
  800f50:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f57:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f5e:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f64:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f6b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f72:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f79:	84 c0                	test   %al,%al
  800f7b:	74 20                	je     800f9d <snprintf+0x51>
  800f7d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f81:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f85:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f89:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f8d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f91:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f95:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f99:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f9d:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800fa4:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800fab:	00 00 00 
  800fae:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fb5:	00 00 00 
  800fb8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fbc:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fc3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fca:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fd1:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fd8:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fdf:	48 8b 0a             	mov    (%rdx),%rcx
  800fe2:	48 89 08             	mov    %rcx,(%rax)
  800fe5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fe9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fed:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ff1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800ff5:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800ffc:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801003:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801009:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801010:	48 89 c7             	mov    %rax,%rdi
  801013:	48 b8 af 0e 80 00 00 	movabs $0x800eaf,%rax
  80101a:	00 00 00 
  80101d:	ff d0                	callq  *%rax
  80101f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801025:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80102b:	c9                   	leaveq 
  80102c:	c3                   	retq   

000000000080102d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80102d:	55                   	push   %rbp
  80102e:	48 89 e5             	mov    %rsp,%rbp
  801031:	48 83 ec 18          	sub    $0x18,%rsp
  801035:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801039:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801040:	eb 09                	jmp    80104b <strlen+0x1e>
		n++;
  801042:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801046:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80104b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80104f:	0f b6 00             	movzbl (%rax),%eax
  801052:	84 c0                	test   %al,%al
  801054:	75 ec                	jne    801042 <strlen+0x15>
		n++;
	return n;
  801056:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801059:	c9                   	leaveq 
  80105a:	c3                   	retq   

000000000080105b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80105b:	55                   	push   %rbp
  80105c:	48 89 e5             	mov    %rsp,%rbp
  80105f:	48 83 ec 20          	sub    $0x20,%rsp
  801063:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801067:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80106b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801072:	eb 0e                	jmp    801082 <strnlen+0x27>
		n++;
  801074:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801078:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80107d:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801082:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801087:	74 0b                	je     801094 <strnlen+0x39>
  801089:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108d:	0f b6 00             	movzbl (%rax),%eax
  801090:	84 c0                	test   %al,%al
  801092:	75 e0                	jne    801074 <strnlen+0x19>
		n++;
	return n;
  801094:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801097:	c9                   	leaveq 
  801098:	c3                   	retq   

0000000000801099 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801099:	55                   	push   %rbp
  80109a:	48 89 e5             	mov    %rsp,%rbp
  80109d:	48 83 ec 20          	sub    $0x20,%rsp
  8010a1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010a5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8010a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8010b1:	90                   	nop
  8010b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010ba:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010be:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010c2:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010c6:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010ca:	0f b6 12             	movzbl (%rdx),%edx
  8010cd:	88 10                	mov    %dl,(%rax)
  8010cf:	0f b6 00             	movzbl (%rax),%eax
  8010d2:	84 c0                	test   %al,%al
  8010d4:	75 dc                	jne    8010b2 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010da:	c9                   	leaveq 
  8010db:	c3                   	retq   

00000000008010dc <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010dc:	55                   	push   %rbp
  8010dd:	48 89 e5             	mov    %rsp,%rbp
  8010e0:	48 83 ec 20          	sub    $0x20,%rsp
  8010e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f0:	48 89 c7             	mov    %rax,%rdi
  8010f3:	48 b8 2d 10 80 00 00 	movabs $0x80102d,%rax
  8010fa:	00 00 00 
  8010fd:	ff d0                	callq  *%rax
  8010ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801102:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801105:	48 63 d0             	movslq %eax,%rdx
  801108:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80110c:	48 01 c2             	add    %rax,%rdx
  80110f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801113:	48 89 c6             	mov    %rax,%rsi
  801116:	48 89 d7             	mov    %rdx,%rdi
  801119:	48 b8 99 10 80 00 00 	movabs $0x801099,%rax
  801120:	00 00 00 
  801123:	ff d0                	callq  *%rax
	return dst;
  801125:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801129:	c9                   	leaveq 
  80112a:	c3                   	retq   

000000000080112b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80112b:	55                   	push   %rbp
  80112c:	48 89 e5             	mov    %rsp,%rbp
  80112f:	48 83 ec 28          	sub    $0x28,%rsp
  801133:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801137:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80113b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80113f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801143:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801147:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80114e:	00 
  80114f:	eb 2a                	jmp    80117b <strncpy+0x50>
		*dst++ = *src;
  801151:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801155:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801159:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80115d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801161:	0f b6 12             	movzbl (%rdx),%edx
  801164:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801166:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80116a:	0f b6 00             	movzbl (%rax),%eax
  80116d:	84 c0                	test   %al,%al
  80116f:	74 05                	je     801176 <strncpy+0x4b>
			src++;
  801171:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801176:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80117b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80117f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801183:	72 cc                	jb     801151 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801185:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801189:	c9                   	leaveq 
  80118a:	c3                   	retq   

000000000080118b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80118b:	55                   	push   %rbp
  80118c:	48 89 e5             	mov    %rsp,%rbp
  80118f:	48 83 ec 28          	sub    $0x28,%rsp
  801193:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801197:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80119b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80119f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8011a7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011ac:	74 3d                	je     8011eb <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8011ae:	eb 1d                	jmp    8011cd <strlcpy+0x42>
			*dst++ = *src++;
  8011b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011b8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011bc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011c0:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011c4:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011c8:	0f b6 12             	movzbl (%rdx),%edx
  8011cb:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011cd:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011d2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011d7:	74 0b                	je     8011e4 <strlcpy+0x59>
  8011d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011dd:	0f b6 00             	movzbl (%rax),%eax
  8011e0:	84 c0                	test   %al,%al
  8011e2:	75 cc                	jne    8011b0 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e8:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f3:	48 29 c2             	sub    %rax,%rdx
  8011f6:	48 89 d0             	mov    %rdx,%rax
}
  8011f9:	c9                   	leaveq 
  8011fa:	c3                   	retq   

00000000008011fb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011fb:	55                   	push   %rbp
  8011fc:	48 89 e5             	mov    %rsp,%rbp
  8011ff:	48 83 ec 10          	sub    $0x10,%rsp
  801203:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801207:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80120b:	eb 0a                	jmp    801217 <strcmp+0x1c>
		p++, q++;
  80120d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801212:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801217:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80121b:	0f b6 00             	movzbl (%rax),%eax
  80121e:	84 c0                	test   %al,%al
  801220:	74 12                	je     801234 <strcmp+0x39>
  801222:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801226:	0f b6 10             	movzbl (%rax),%edx
  801229:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80122d:	0f b6 00             	movzbl (%rax),%eax
  801230:	38 c2                	cmp    %al,%dl
  801232:	74 d9                	je     80120d <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801234:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801238:	0f b6 00             	movzbl (%rax),%eax
  80123b:	0f b6 d0             	movzbl %al,%edx
  80123e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801242:	0f b6 00             	movzbl (%rax),%eax
  801245:	0f b6 c0             	movzbl %al,%eax
  801248:	29 c2                	sub    %eax,%edx
  80124a:	89 d0                	mov    %edx,%eax
}
  80124c:	c9                   	leaveq 
  80124d:	c3                   	retq   

000000000080124e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80124e:	55                   	push   %rbp
  80124f:	48 89 e5             	mov    %rsp,%rbp
  801252:	48 83 ec 18          	sub    $0x18,%rsp
  801256:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80125a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80125e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801262:	eb 0f                	jmp    801273 <strncmp+0x25>
		n--, p++, q++;
  801264:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801269:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80126e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801273:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801278:	74 1d                	je     801297 <strncmp+0x49>
  80127a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127e:	0f b6 00             	movzbl (%rax),%eax
  801281:	84 c0                	test   %al,%al
  801283:	74 12                	je     801297 <strncmp+0x49>
  801285:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801289:	0f b6 10             	movzbl (%rax),%edx
  80128c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801290:	0f b6 00             	movzbl (%rax),%eax
  801293:	38 c2                	cmp    %al,%dl
  801295:	74 cd                	je     801264 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801297:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80129c:	75 07                	jne    8012a5 <strncmp+0x57>
		return 0;
  80129e:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a3:	eb 18                	jmp    8012bd <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a9:	0f b6 00             	movzbl (%rax),%eax
  8012ac:	0f b6 d0             	movzbl %al,%edx
  8012af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012b3:	0f b6 00             	movzbl (%rax),%eax
  8012b6:	0f b6 c0             	movzbl %al,%eax
  8012b9:	29 c2                	sub    %eax,%edx
  8012bb:	89 d0                	mov    %edx,%eax
}
  8012bd:	c9                   	leaveq 
  8012be:	c3                   	retq   

00000000008012bf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012bf:	55                   	push   %rbp
  8012c0:	48 89 e5             	mov    %rsp,%rbp
  8012c3:	48 83 ec 0c          	sub    $0xc,%rsp
  8012c7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012cb:	89 f0                	mov    %esi,%eax
  8012cd:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012d0:	eb 17                	jmp    8012e9 <strchr+0x2a>
		if (*s == c)
  8012d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d6:	0f b6 00             	movzbl (%rax),%eax
  8012d9:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012dc:	75 06                	jne    8012e4 <strchr+0x25>
			return (char *) s;
  8012de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e2:	eb 15                	jmp    8012f9 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012e4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ed:	0f b6 00             	movzbl (%rax),%eax
  8012f0:	84 c0                	test   %al,%al
  8012f2:	75 de                	jne    8012d2 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012f9:	c9                   	leaveq 
  8012fa:	c3                   	retq   

00000000008012fb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012fb:	55                   	push   %rbp
  8012fc:	48 89 e5             	mov    %rsp,%rbp
  8012ff:	48 83 ec 0c          	sub    $0xc,%rsp
  801303:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801307:	89 f0                	mov    %esi,%eax
  801309:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80130c:	eb 13                	jmp    801321 <strfind+0x26>
		if (*s == c)
  80130e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801312:	0f b6 00             	movzbl (%rax),%eax
  801315:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801318:	75 02                	jne    80131c <strfind+0x21>
			break;
  80131a:	eb 10                	jmp    80132c <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80131c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801321:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801325:	0f b6 00             	movzbl (%rax),%eax
  801328:	84 c0                	test   %al,%al
  80132a:	75 e2                	jne    80130e <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80132c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801330:	c9                   	leaveq 
  801331:	c3                   	retq   

0000000000801332 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801332:	55                   	push   %rbp
  801333:	48 89 e5             	mov    %rsp,%rbp
  801336:	48 83 ec 18          	sub    $0x18,%rsp
  80133a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80133e:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801341:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801345:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80134a:	75 06                	jne    801352 <memset+0x20>
		return v;
  80134c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801350:	eb 69                	jmp    8013bb <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801352:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801356:	83 e0 03             	and    $0x3,%eax
  801359:	48 85 c0             	test   %rax,%rax
  80135c:	75 48                	jne    8013a6 <memset+0x74>
  80135e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801362:	83 e0 03             	and    $0x3,%eax
  801365:	48 85 c0             	test   %rax,%rax
  801368:	75 3c                	jne    8013a6 <memset+0x74>
		c &= 0xFF;
  80136a:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801371:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801374:	c1 e0 18             	shl    $0x18,%eax
  801377:	89 c2                	mov    %eax,%edx
  801379:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80137c:	c1 e0 10             	shl    $0x10,%eax
  80137f:	09 c2                	or     %eax,%edx
  801381:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801384:	c1 e0 08             	shl    $0x8,%eax
  801387:	09 d0                	or     %edx,%eax
  801389:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80138c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801390:	48 c1 e8 02          	shr    $0x2,%rax
  801394:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801397:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80139b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80139e:	48 89 d7             	mov    %rdx,%rdi
  8013a1:	fc                   	cld    
  8013a2:	f3 ab                	rep stos %eax,%es:(%rdi)
  8013a4:	eb 11                	jmp    8013b7 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013a6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013aa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013ad:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013b1:	48 89 d7             	mov    %rdx,%rdi
  8013b4:	fc                   	cld    
  8013b5:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8013b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013bb:	c9                   	leaveq 
  8013bc:	c3                   	retq   

00000000008013bd <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013bd:	55                   	push   %rbp
  8013be:	48 89 e5             	mov    %rsp,%rbp
  8013c1:	48 83 ec 28          	sub    $0x28,%rsp
  8013c5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013c9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013cd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013d5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013dd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e5:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013e9:	0f 83 88 00 00 00    	jae    801477 <memmove+0xba>
  8013ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013f7:	48 01 d0             	add    %rdx,%rax
  8013fa:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013fe:	76 77                	jbe    801477 <memmove+0xba>
		s += n;
  801400:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801404:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801408:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140c:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801410:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801414:	83 e0 03             	and    $0x3,%eax
  801417:	48 85 c0             	test   %rax,%rax
  80141a:	75 3b                	jne    801457 <memmove+0x9a>
  80141c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801420:	83 e0 03             	and    $0x3,%eax
  801423:	48 85 c0             	test   %rax,%rax
  801426:	75 2f                	jne    801457 <memmove+0x9a>
  801428:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142c:	83 e0 03             	and    $0x3,%eax
  80142f:	48 85 c0             	test   %rax,%rax
  801432:	75 23                	jne    801457 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801434:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801438:	48 83 e8 04          	sub    $0x4,%rax
  80143c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801440:	48 83 ea 04          	sub    $0x4,%rdx
  801444:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801448:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80144c:	48 89 c7             	mov    %rax,%rdi
  80144f:	48 89 d6             	mov    %rdx,%rsi
  801452:	fd                   	std    
  801453:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801455:	eb 1d                	jmp    801474 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801457:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80145b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80145f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801463:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801467:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80146b:	48 89 d7             	mov    %rdx,%rdi
  80146e:	48 89 c1             	mov    %rax,%rcx
  801471:	fd                   	std    
  801472:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801474:	fc                   	cld    
  801475:	eb 57                	jmp    8014ce <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801477:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80147b:	83 e0 03             	and    $0x3,%eax
  80147e:	48 85 c0             	test   %rax,%rax
  801481:	75 36                	jne    8014b9 <memmove+0xfc>
  801483:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801487:	83 e0 03             	and    $0x3,%eax
  80148a:	48 85 c0             	test   %rax,%rax
  80148d:	75 2a                	jne    8014b9 <memmove+0xfc>
  80148f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801493:	83 e0 03             	and    $0x3,%eax
  801496:	48 85 c0             	test   %rax,%rax
  801499:	75 1e                	jne    8014b9 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80149b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149f:	48 c1 e8 02          	shr    $0x2,%rax
  8014a3:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8014a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014aa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014ae:	48 89 c7             	mov    %rax,%rdi
  8014b1:	48 89 d6             	mov    %rdx,%rsi
  8014b4:	fc                   	cld    
  8014b5:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014b7:	eb 15                	jmp    8014ce <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8014b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014bd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014c1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014c5:	48 89 c7             	mov    %rax,%rdi
  8014c8:	48 89 d6             	mov    %rdx,%rsi
  8014cb:	fc                   	cld    
  8014cc:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014d2:	c9                   	leaveq 
  8014d3:	c3                   	retq   

00000000008014d4 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014d4:	55                   	push   %rbp
  8014d5:	48 89 e5             	mov    %rsp,%rbp
  8014d8:	48 83 ec 18          	sub    $0x18,%rsp
  8014dc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014e4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014ec:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f4:	48 89 ce             	mov    %rcx,%rsi
  8014f7:	48 89 c7             	mov    %rax,%rdi
  8014fa:	48 b8 bd 13 80 00 00 	movabs $0x8013bd,%rax
  801501:	00 00 00 
  801504:	ff d0                	callq  *%rax
}
  801506:	c9                   	leaveq 
  801507:	c3                   	retq   

0000000000801508 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801508:	55                   	push   %rbp
  801509:	48 89 e5             	mov    %rsp,%rbp
  80150c:	48 83 ec 28          	sub    $0x28,%rsp
  801510:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801514:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801518:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80151c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801520:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801524:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801528:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80152c:	eb 36                	jmp    801564 <memcmp+0x5c>
		if (*s1 != *s2)
  80152e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801532:	0f b6 10             	movzbl (%rax),%edx
  801535:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801539:	0f b6 00             	movzbl (%rax),%eax
  80153c:	38 c2                	cmp    %al,%dl
  80153e:	74 1a                	je     80155a <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801540:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801544:	0f b6 00             	movzbl (%rax),%eax
  801547:	0f b6 d0             	movzbl %al,%edx
  80154a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80154e:	0f b6 00             	movzbl (%rax),%eax
  801551:	0f b6 c0             	movzbl %al,%eax
  801554:	29 c2                	sub    %eax,%edx
  801556:	89 d0                	mov    %edx,%eax
  801558:	eb 20                	jmp    80157a <memcmp+0x72>
		s1++, s2++;
  80155a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80155f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801564:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801568:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80156c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801570:	48 85 c0             	test   %rax,%rax
  801573:	75 b9                	jne    80152e <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801575:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80157a:	c9                   	leaveq 
  80157b:	c3                   	retq   

000000000080157c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80157c:	55                   	push   %rbp
  80157d:	48 89 e5             	mov    %rsp,%rbp
  801580:	48 83 ec 28          	sub    $0x28,%rsp
  801584:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801588:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80158b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80158f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801593:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801597:	48 01 d0             	add    %rdx,%rax
  80159a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80159e:	eb 15                	jmp    8015b5 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015a4:	0f b6 10             	movzbl (%rax),%edx
  8015a7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8015aa:	38 c2                	cmp    %al,%dl
  8015ac:	75 02                	jne    8015b0 <memfind+0x34>
			break;
  8015ae:	eb 0f                	jmp    8015bf <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015b0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015b9:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8015bd:	72 e1                	jb     8015a0 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8015bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015c3:	c9                   	leaveq 
  8015c4:	c3                   	retq   

00000000008015c5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015c5:	55                   	push   %rbp
  8015c6:	48 89 e5             	mov    %rsp,%rbp
  8015c9:	48 83 ec 34          	sub    $0x34,%rsp
  8015cd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015d1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015d5:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015df:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015e6:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015e7:	eb 05                	jmp    8015ee <strtol+0x29>
		s++;
  8015e9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f2:	0f b6 00             	movzbl (%rax),%eax
  8015f5:	3c 20                	cmp    $0x20,%al
  8015f7:	74 f0                	je     8015e9 <strtol+0x24>
  8015f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fd:	0f b6 00             	movzbl (%rax),%eax
  801600:	3c 09                	cmp    $0x9,%al
  801602:	74 e5                	je     8015e9 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801604:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801608:	0f b6 00             	movzbl (%rax),%eax
  80160b:	3c 2b                	cmp    $0x2b,%al
  80160d:	75 07                	jne    801616 <strtol+0x51>
		s++;
  80160f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801614:	eb 17                	jmp    80162d <strtol+0x68>
	else if (*s == '-')
  801616:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161a:	0f b6 00             	movzbl (%rax),%eax
  80161d:	3c 2d                	cmp    $0x2d,%al
  80161f:	75 0c                	jne    80162d <strtol+0x68>
		s++, neg = 1;
  801621:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801626:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80162d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801631:	74 06                	je     801639 <strtol+0x74>
  801633:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801637:	75 28                	jne    801661 <strtol+0x9c>
  801639:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163d:	0f b6 00             	movzbl (%rax),%eax
  801640:	3c 30                	cmp    $0x30,%al
  801642:	75 1d                	jne    801661 <strtol+0x9c>
  801644:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801648:	48 83 c0 01          	add    $0x1,%rax
  80164c:	0f b6 00             	movzbl (%rax),%eax
  80164f:	3c 78                	cmp    $0x78,%al
  801651:	75 0e                	jne    801661 <strtol+0x9c>
		s += 2, base = 16;
  801653:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801658:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80165f:	eb 2c                	jmp    80168d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801661:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801665:	75 19                	jne    801680 <strtol+0xbb>
  801667:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166b:	0f b6 00             	movzbl (%rax),%eax
  80166e:	3c 30                	cmp    $0x30,%al
  801670:	75 0e                	jne    801680 <strtol+0xbb>
		s++, base = 8;
  801672:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801677:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80167e:	eb 0d                	jmp    80168d <strtol+0xc8>
	else if (base == 0)
  801680:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801684:	75 07                	jne    80168d <strtol+0xc8>
		base = 10;
  801686:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80168d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801691:	0f b6 00             	movzbl (%rax),%eax
  801694:	3c 2f                	cmp    $0x2f,%al
  801696:	7e 1d                	jle    8016b5 <strtol+0xf0>
  801698:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169c:	0f b6 00             	movzbl (%rax),%eax
  80169f:	3c 39                	cmp    $0x39,%al
  8016a1:	7f 12                	jg     8016b5 <strtol+0xf0>
			dig = *s - '0';
  8016a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a7:	0f b6 00             	movzbl (%rax),%eax
  8016aa:	0f be c0             	movsbl %al,%eax
  8016ad:	83 e8 30             	sub    $0x30,%eax
  8016b0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016b3:	eb 4e                	jmp    801703 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8016b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b9:	0f b6 00             	movzbl (%rax),%eax
  8016bc:	3c 60                	cmp    $0x60,%al
  8016be:	7e 1d                	jle    8016dd <strtol+0x118>
  8016c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c4:	0f b6 00             	movzbl (%rax),%eax
  8016c7:	3c 7a                	cmp    $0x7a,%al
  8016c9:	7f 12                	jg     8016dd <strtol+0x118>
			dig = *s - 'a' + 10;
  8016cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cf:	0f b6 00             	movzbl (%rax),%eax
  8016d2:	0f be c0             	movsbl %al,%eax
  8016d5:	83 e8 57             	sub    $0x57,%eax
  8016d8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016db:	eb 26                	jmp    801703 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e1:	0f b6 00             	movzbl (%rax),%eax
  8016e4:	3c 40                	cmp    $0x40,%al
  8016e6:	7e 48                	jle    801730 <strtol+0x16b>
  8016e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ec:	0f b6 00             	movzbl (%rax),%eax
  8016ef:	3c 5a                	cmp    $0x5a,%al
  8016f1:	7f 3d                	jg     801730 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f7:	0f b6 00             	movzbl (%rax),%eax
  8016fa:	0f be c0             	movsbl %al,%eax
  8016fd:	83 e8 37             	sub    $0x37,%eax
  801700:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801703:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801706:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801709:	7c 02                	jl     80170d <strtol+0x148>
			break;
  80170b:	eb 23                	jmp    801730 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80170d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801712:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801715:	48 98                	cltq   
  801717:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80171c:	48 89 c2             	mov    %rax,%rdx
  80171f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801722:	48 98                	cltq   
  801724:	48 01 d0             	add    %rdx,%rax
  801727:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80172b:	e9 5d ff ff ff       	jmpq   80168d <strtol+0xc8>

	if (endptr)
  801730:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801735:	74 0b                	je     801742 <strtol+0x17d>
		*endptr = (char *) s;
  801737:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80173b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80173f:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801742:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801746:	74 09                	je     801751 <strtol+0x18c>
  801748:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80174c:	48 f7 d8             	neg    %rax
  80174f:	eb 04                	jmp    801755 <strtol+0x190>
  801751:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801755:	c9                   	leaveq 
  801756:	c3                   	retq   

0000000000801757 <strstr>:

char * strstr(const char *in, const char *str)
{
  801757:	55                   	push   %rbp
  801758:	48 89 e5             	mov    %rsp,%rbp
  80175b:	48 83 ec 30          	sub    $0x30,%rsp
  80175f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801763:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801767:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80176b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80176f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801773:	0f b6 00             	movzbl (%rax),%eax
  801776:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801779:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80177d:	75 06                	jne    801785 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80177f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801783:	eb 6b                	jmp    8017f0 <strstr+0x99>

	len = strlen(str);
  801785:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801789:	48 89 c7             	mov    %rax,%rdi
  80178c:	48 b8 2d 10 80 00 00 	movabs $0x80102d,%rax
  801793:	00 00 00 
  801796:	ff d0                	callq  *%rax
  801798:	48 98                	cltq   
  80179a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80179e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017a6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017aa:	0f b6 00             	movzbl (%rax),%eax
  8017ad:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8017b0:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8017b4:	75 07                	jne    8017bd <strstr+0x66>
				return (char *) 0;
  8017b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017bb:	eb 33                	jmp    8017f0 <strstr+0x99>
		} while (sc != c);
  8017bd:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8017c1:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8017c4:	75 d8                	jne    80179e <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8017c6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017ca:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d2:	48 89 ce             	mov    %rcx,%rsi
  8017d5:	48 89 c7             	mov    %rax,%rdi
  8017d8:	48 b8 4e 12 80 00 00 	movabs $0x80124e,%rax
  8017df:	00 00 00 
  8017e2:	ff d0                	callq  *%rax
  8017e4:	85 c0                	test   %eax,%eax
  8017e6:	75 b6                	jne    80179e <strstr+0x47>

	return (char *) (in - 1);
  8017e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ec:	48 83 e8 01          	sub    $0x1,%rax
}
  8017f0:	c9                   	leaveq 
  8017f1:	c3                   	retq   
