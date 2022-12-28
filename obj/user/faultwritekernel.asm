
obj/user/faultwritekernel:     file format elf64-x86-64


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
  80003c:	e8 23 00 00 00       	callq  800064 <libmain>
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
	*(unsigned*)0x8004000000 = 0;
  800052:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  800059:	00 00 00 
  80005c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
  800062:	c9                   	leaveq 
  800063:	c3                   	retq   

0000000000800064 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800064:	55                   	push   %rbp
  800065:	48 89 e5             	mov    %rsp,%rbp
  800068:	48 83 ec 10          	sub    $0x10,%rsp
  80006c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80006f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	thisenv = &envs[ENVX(sys_getenvid())];
  800073:	48 b8 5f 02 80 00 00 	movabs $0x80025f,%rax
  80007a:	00 00 00 
  80007d:	ff d0                	callq  *%rax
  80007f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800084:	48 98                	cltq   
  800086:	48 c1 e0 03          	shl    $0x3,%rax
  80008a:	48 89 c2             	mov    %rax,%rdx
  80008d:	48 c1 e2 05          	shl    $0x5,%rdx
  800091:	48 29 c2             	sub    %rax,%rdx
  800094:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80009b:	00 00 00 
  80009e:	48 01 c2             	add    %rax,%rdx
  8000a1:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000a8:	00 00 00 
  8000ab:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000b2:	7e 14                	jle    8000c8 <libmain+0x64>
		binaryname = argv[0];
  8000b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000b8:	48 8b 10             	mov    (%rax),%rdx
  8000bb:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000c2:	00 00 00 
  8000c5:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000c8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000cf:	48 89 d6             	mov    %rdx,%rsi
  8000d2:	89 c7                	mov    %eax,%edi
  8000d4:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000db:	00 00 00 
  8000de:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000e0:	48 b8 ee 00 80 00 00 	movabs $0x8000ee,%rax
  8000e7:	00 00 00 
  8000ea:	ff d0                	callq  *%rax
}
  8000ec:	c9                   	leaveq 
  8000ed:	c3                   	retq   

00000000008000ee <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ee:	55                   	push   %rbp
  8000ef:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8000f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8000f7:	48 b8 1b 02 80 00 00 	movabs $0x80021b,%rax
  8000fe:	00 00 00 
  800101:	ff d0                	callq  *%rax
}
  800103:	5d                   	pop    %rbp
  800104:	c3                   	retq   

0000000000800105 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800105:	55                   	push   %rbp
  800106:	48 89 e5             	mov    %rsp,%rbp
  800109:	53                   	push   %rbx
  80010a:	48 83 ec 48          	sub    $0x48,%rsp
  80010e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800111:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800114:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800118:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80011c:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800120:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800124:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800127:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80012b:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80012f:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800133:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800137:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80013b:	4c 89 c3             	mov    %r8,%rbx
  80013e:	cd 30                	int    $0x30
  800140:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800144:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800148:	74 3e                	je     800188 <syscall+0x83>
  80014a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80014f:	7e 37                	jle    800188 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800151:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800155:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800158:	49 89 d0             	mov    %rdx,%r8
  80015b:	89 c1                	mov    %eax,%ecx
  80015d:	48 ba 0a 18 80 00 00 	movabs $0x80180a,%rdx
  800164:	00 00 00 
  800167:	be 23 00 00 00       	mov    $0x23,%esi
  80016c:	48 bf 27 18 80 00 00 	movabs $0x801827,%rdi
  800173:	00 00 00 
  800176:	b8 00 00 00 00       	mov    $0x0,%eax
  80017b:	49 b9 9d 02 80 00 00 	movabs $0x80029d,%r9
  800182:	00 00 00 
  800185:	41 ff d1             	callq  *%r9

	return ret;
  800188:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80018c:	48 83 c4 48          	add    $0x48,%rsp
  800190:	5b                   	pop    %rbx
  800191:	5d                   	pop    %rbp
  800192:	c3                   	retq   

0000000000800193 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800193:	55                   	push   %rbp
  800194:	48 89 e5             	mov    %rsp,%rbp
  800197:	48 83 ec 20          	sub    $0x20,%rsp
  80019b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80019f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001a7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001ab:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001b2:	00 
  8001b3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001b9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001bf:	48 89 d1             	mov    %rdx,%rcx
  8001c2:	48 89 c2             	mov    %rax,%rdx
  8001c5:	be 00 00 00 00       	mov    $0x0,%esi
  8001ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8001cf:	48 b8 05 01 80 00 00 	movabs $0x800105,%rax
  8001d6:	00 00 00 
  8001d9:	ff d0                	callq  *%rax
}
  8001db:	c9                   	leaveq 
  8001dc:	c3                   	retq   

00000000008001dd <sys_cgetc>:

int
sys_cgetc(void)
{
  8001dd:	55                   	push   %rbp
  8001de:	48 89 e5             	mov    %rsp,%rbp
  8001e1:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001e5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001ec:	00 
  8001ed:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001f3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001f9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800203:	be 00 00 00 00       	mov    $0x0,%esi
  800208:	bf 01 00 00 00       	mov    $0x1,%edi
  80020d:	48 b8 05 01 80 00 00 	movabs $0x800105,%rax
  800214:	00 00 00 
  800217:	ff d0                	callq  *%rax
}
  800219:	c9                   	leaveq 
  80021a:	c3                   	retq   

000000000080021b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80021b:	55                   	push   %rbp
  80021c:	48 89 e5             	mov    %rsp,%rbp
  80021f:	48 83 ec 10          	sub    $0x10,%rsp
  800223:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800226:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800229:	48 98                	cltq   
  80022b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800232:	00 
  800233:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800239:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80023f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800244:	48 89 c2             	mov    %rax,%rdx
  800247:	be 01 00 00 00       	mov    $0x1,%esi
  80024c:	bf 03 00 00 00       	mov    $0x3,%edi
  800251:	48 b8 05 01 80 00 00 	movabs $0x800105,%rax
  800258:	00 00 00 
  80025b:	ff d0                	callq  *%rax
}
  80025d:	c9                   	leaveq 
  80025e:	c3                   	retq   

000000000080025f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80025f:	55                   	push   %rbp
  800260:	48 89 e5             	mov    %rsp,%rbp
  800263:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800267:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80026e:	00 
  80026f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800275:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80027b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800280:	ba 00 00 00 00       	mov    $0x0,%edx
  800285:	be 00 00 00 00       	mov    $0x0,%esi
  80028a:	bf 02 00 00 00       	mov    $0x2,%edi
  80028f:	48 b8 05 01 80 00 00 	movabs $0x800105,%rax
  800296:	00 00 00 
  800299:	ff d0                	callq  *%rax
}
  80029b:	c9                   	leaveq 
  80029c:	c3                   	retq   

000000000080029d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80029d:	55                   	push   %rbp
  80029e:	48 89 e5             	mov    %rsp,%rbp
  8002a1:	53                   	push   %rbx
  8002a2:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8002a9:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8002b0:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8002b6:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8002bd:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8002c4:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8002cb:	84 c0                	test   %al,%al
  8002cd:	74 23                	je     8002f2 <_panic+0x55>
  8002cf:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8002d6:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002da:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002de:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002e2:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002e6:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002ea:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002ee:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002f2:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002f9:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800300:	00 00 00 
  800303:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80030a:	00 00 00 
  80030d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800311:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800318:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80031f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800326:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  80032d:	00 00 00 
  800330:	48 8b 18             	mov    (%rax),%rbx
  800333:	48 b8 5f 02 80 00 00 	movabs $0x80025f,%rax
  80033a:	00 00 00 
  80033d:	ff d0                	callq  *%rax
  80033f:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800345:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80034c:	41 89 c8             	mov    %ecx,%r8d
  80034f:	48 89 d1             	mov    %rdx,%rcx
  800352:	48 89 da             	mov    %rbx,%rdx
  800355:	89 c6                	mov    %eax,%esi
  800357:	48 bf 38 18 80 00 00 	movabs $0x801838,%rdi
  80035e:	00 00 00 
  800361:	b8 00 00 00 00       	mov    $0x0,%eax
  800366:	49 b9 d6 04 80 00 00 	movabs $0x8004d6,%r9
  80036d:	00 00 00 
  800370:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800373:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80037a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800381:	48 89 d6             	mov    %rdx,%rsi
  800384:	48 89 c7             	mov    %rax,%rdi
  800387:	48 b8 2a 04 80 00 00 	movabs $0x80042a,%rax
  80038e:	00 00 00 
  800391:	ff d0                	callq  *%rax
	cprintf("\n");
  800393:	48 bf 5b 18 80 00 00 	movabs $0x80185b,%rdi
  80039a:	00 00 00 
  80039d:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a2:	48 ba d6 04 80 00 00 	movabs $0x8004d6,%rdx
  8003a9:	00 00 00 
  8003ac:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003ae:	cc                   	int3   
  8003af:	eb fd                	jmp    8003ae <_panic+0x111>

00000000008003b1 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8003b1:	55                   	push   %rbp
  8003b2:	48 89 e5             	mov    %rsp,%rbp
  8003b5:	48 83 ec 10          	sub    $0x10,%rsp
  8003b9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003bc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8003c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c4:	8b 00                	mov    (%rax),%eax
  8003c6:	8d 48 01             	lea    0x1(%rax),%ecx
  8003c9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003cd:	89 0a                	mov    %ecx,(%rdx)
  8003cf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003d2:	89 d1                	mov    %edx,%ecx
  8003d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003d8:	48 98                	cltq   
  8003da:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8003de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003e2:	8b 00                	mov    (%rax),%eax
  8003e4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003e9:	75 2c                	jne    800417 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ef:	8b 00                	mov    (%rax),%eax
  8003f1:	48 98                	cltq   
  8003f3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003f7:	48 83 c2 08          	add    $0x8,%rdx
  8003fb:	48 89 c6             	mov    %rax,%rsi
  8003fe:	48 89 d7             	mov    %rdx,%rdi
  800401:	48 b8 93 01 80 00 00 	movabs $0x800193,%rax
  800408:	00 00 00 
  80040b:	ff d0                	callq  *%rax
        b->idx = 0;
  80040d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800411:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800417:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80041b:	8b 40 04             	mov    0x4(%rax),%eax
  80041e:	8d 50 01             	lea    0x1(%rax),%edx
  800421:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800425:	89 50 04             	mov    %edx,0x4(%rax)
}
  800428:	c9                   	leaveq 
  800429:	c3                   	retq   

000000000080042a <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80042a:	55                   	push   %rbp
  80042b:	48 89 e5             	mov    %rsp,%rbp
  80042e:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800435:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80043c:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800443:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80044a:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800451:	48 8b 0a             	mov    (%rdx),%rcx
  800454:	48 89 08             	mov    %rcx,(%rax)
  800457:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80045b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80045f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800463:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800467:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80046e:	00 00 00 
    b.cnt = 0;
  800471:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800478:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80047b:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800482:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800489:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800490:	48 89 c6             	mov    %rax,%rsi
  800493:	48 bf b1 03 80 00 00 	movabs $0x8003b1,%rdi
  80049a:	00 00 00 
  80049d:	48 b8 89 08 80 00 00 	movabs $0x800889,%rax
  8004a4:	00 00 00 
  8004a7:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8004a9:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8004af:	48 98                	cltq   
  8004b1:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8004b8:	48 83 c2 08          	add    $0x8,%rdx
  8004bc:	48 89 c6             	mov    %rax,%rsi
  8004bf:	48 89 d7             	mov    %rdx,%rdi
  8004c2:	48 b8 93 01 80 00 00 	movabs $0x800193,%rax
  8004c9:	00 00 00 
  8004cc:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8004ce:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004d4:	c9                   	leaveq 
  8004d5:	c3                   	retq   

00000000008004d6 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8004d6:	55                   	push   %rbp
  8004d7:	48 89 e5             	mov    %rsp,%rbp
  8004da:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004e1:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004e8:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004ef:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004f6:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004fd:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800504:	84 c0                	test   %al,%al
  800506:	74 20                	je     800528 <cprintf+0x52>
  800508:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80050c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800510:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800514:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800518:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80051c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800520:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800524:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800528:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80052f:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800536:	00 00 00 
  800539:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800540:	00 00 00 
  800543:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800547:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80054e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800555:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80055c:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800563:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80056a:	48 8b 0a             	mov    (%rdx),%rcx
  80056d:	48 89 08             	mov    %rcx,(%rax)
  800570:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800574:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800578:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80057c:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800580:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800587:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80058e:	48 89 d6             	mov    %rdx,%rsi
  800591:	48 89 c7             	mov    %rax,%rdi
  800594:	48 b8 2a 04 80 00 00 	movabs $0x80042a,%rax
  80059b:	00 00 00 
  80059e:	ff d0                	callq  *%rax
  8005a0:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8005a6:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8005ac:	c9                   	leaveq 
  8005ad:	c3                   	retq   

00000000008005ae <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005ae:	55                   	push   %rbp
  8005af:	48 89 e5             	mov    %rsp,%rbp
  8005b2:	53                   	push   %rbx
  8005b3:	48 83 ec 38          	sub    $0x38,%rsp
  8005b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005bb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8005bf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8005c3:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8005c6:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8005ca:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005ce:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8005d1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8005d5:	77 3b                	ja     800612 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005d7:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8005da:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005de:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8005e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ea:	48 f7 f3             	div    %rbx
  8005ed:	48 89 c2             	mov    %rax,%rdx
  8005f0:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005f3:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005f6:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005fe:	41 89 f9             	mov    %edi,%r9d
  800601:	48 89 c7             	mov    %rax,%rdi
  800604:	48 b8 ae 05 80 00 00 	movabs $0x8005ae,%rax
  80060b:	00 00 00 
  80060e:	ff d0                	callq  *%rax
  800610:	eb 1e                	jmp    800630 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800612:	eb 12                	jmp    800626 <printnum+0x78>
			putch(padc, putdat);
  800614:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800618:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80061b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061f:	48 89 ce             	mov    %rcx,%rsi
  800622:	89 d7                	mov    %edx,%edi
  800624:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800626:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80062a:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80062e:	7f e4                	jg     800614 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800630:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800633:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800637:	ba 00 00 00 00       	mov    $0x0,%edx
  80063c:	48 f7 f1             	div    %rcx
  80063f:	48 89 d0             	mov    %rdx,%rax
  800642:	48 ba 90 19 80 00 00 	movabs $0x801990,%rdx
  800649:	00 00 00 
  80064c:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800650:	0f be d0             	movsbl %al,%edx
  800653:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800657:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065b:	48 89 ce             	mov    %rcx,%rsi
  80065e:	89 d7                	mov    %edx,%edi
  800660:	ff d0                	callq  *%rax
}
  800662:	48 83 c4 38          	add    $0x38,%rsp
  800666:	5b                   	pop    %rbx
  800667:	5d                   	pop    %rbp
  800668:	c3                   	retq   

0000000000800669 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800669:	55                   	push   %rbp
  80066a:	48 89 e5             	mov    %rsp,%rbp
  80066d:	48 83 ec 1c          	sub    $0x1c,%rsp
  800671:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800675:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800678:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80067c:	7e 52                	jle    8006d0 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80067e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800682:	8b 00                	mov    (%rax),%eax
  800684:	83 f8 30             	cmp    $0x30,%eax
  800687:	73 24                	jae    8006ad <getuint+0x44>
  800689:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800691:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800695:	8b 00                	mov    (%rax),%eax
  800697:	89 c0                	mov    %eax,%eax
  800699:	48 01 d0             	add    %rdx,%rax
  80069c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a0:	8b 12                	mov    (%rdx),%edx
  8006a2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a9:	89 0a                	mov    %ecx,(%rdx)
  8006ab:	eb 17                	jmp    8006c4 <getuint+0x5b>
  8006ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006b5:	48 89 d0             	mov    %rdx,%rax
  8006b8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006c4:	48 8b 00             	mov    (%rax),%rax
  8006c7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006cb:	e9 a3 00 00 00       	jmpq   800773 <getuint+0x10a>
	else if (lflag)
  8006d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006d4:	74 4f                	je     800725 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8006d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006da:	8b 00                	mov    (%rax),%eax
  8006dc:	83 f8 30             	cmp    $0x30,%eax
  8006df:	73 24                	jae    800705 <getuint+0x9c>
  8006e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ed:	8b 00                	mov    (%rax),%eax
  8006ef:	89 c0                	mov    %eax,%eax
  8006f1:	48 01 d0             	add    %rdx,%rax
  8006f4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f8:	8b 12                	mov    (%rdx),%edx
  8006fa:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800701:	89 0a                	mov    %ecx,(%rdx)
  800703:	eb 17                	jmp    80071c <getuint+0xb3>
  800705:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800709:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80070d:	48 89 d0             	mov    %rdx,%rax
  800710:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800714:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800718:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80071c:	48 8b 00             	mov    (%rax),%rax
  80071f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800723:	eb 4e                	jmp    800773 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800725:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800729:	8b 00                	mov    (%rax),%eax
  80072b:	83 f8 30             	cmp    $0x30,%eax
  80072e:	73 24                	jae    800754 <getuint+0xeb>
  800730:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800734:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800738:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073c:	8b 00                	mov    (%rax),%eax
  80073e:	89 c0                	mov    %eax,%eax
  800740:	48 01 d0             	add    %rdx,%rax
  800743:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800747:	8b 12                	mov    (%rdx),%edx
  800749:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80074c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800750:	89 0a                	mov    %ecx,(%rdx)
  800752:	eb 17                	jmp    80076b <getuint+0x102>
  800754:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800758:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80075c:	48 89 d0             	mov    %rdx,%rax
  80075f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800763:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800767:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80076b:	8b 00                	mov    (%rax),%eax
  80076d:	89 c0                	mov    %eax,%eax
  80076f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800773:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800777:	c9                   	leaveq 
  800778:	c3                   	retq   

0000000000800779 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800779:	55                   	push   %rbp
  80077a:	48 89 e5             	mov    %rsp,%rbp
  80077d:	48 83 ec 1c          	sub    $0x1c,%rsp
  800781:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800785:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800788:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80078c:	7e 52                	jle    8007e0 <getint+0x67>
		x=va_arg(*ap, long long);
  80078e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800792:	8b 00                	mov    (%rax),%eax
  800794:	83 f8 30             	cmp    $0x30,%eax
  800797:	73 24                	jae    8007bd <getint+0x44>
  800799:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a5:	8b 00                	mov    (%rax),%eax
  8007a7:	89 c0                	mov    %eax,%eax
  8007a9:	48 01 d0             	add    %rdx,%rax
  8007ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b0:	8b 12                	mov    (%rdx),%edx
  8007b2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b9:	89 0a                	mov    %ecx,(%rdx)
  8007bb:	eb 17                	jmp    8007d4 <getint+0x5b>
  8007bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007c5:	48 89 d0             	mov    %rdx,%rax
  8007c8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007d4:	48 8b 00             	mov    (%rax),%rax
  8007d7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007db:	e9 a3 00 00 00       	jmpq   800883 <getint+0x10a>
	else if (lflag)
  8007e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007e4:	74 4f                	je     800835 <getint+0xbc>
		x=va_arg(*ap, long);
  8007e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ea:	8b 00                	mov    (%rax),%eax
  8007ec:	83 f8 30             	cmp    $0x30,%eax
  8007ef:	73 24                	jae    800815 <getint+0x9c>
  8007f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fd:	8b 00                	mov    (%rax),%eax
  8007ff:	89 c0                	mov    %eax,%eax
  800801:	48 01 d0             	add    %rdx,%rax
  800804:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800808:	8b 12                	mov    (%rdx),%edx
  80080a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80080d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800811:	89 0a                	mov    %ecx,(%rdx)
  800813:	eb 17                	jmp    80082c <getint+0xb3>
  800815:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800819:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80081d:	48 89 d0             	mov    %rdx,%rax
  800820:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800824:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800828:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80082c:	48 8b 00             	mov    (%rax),%rax
  80082f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800833:	eb 4e                	jmp    800883 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800835:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800839:	8b 00                	mov    (%rax),%eax
  80083b:	83 f8 30             	cmp    $0x30,%eax
  80083e:	73 24                	jae    800864 <getint+0xeb>
  800840:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800844:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800848:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084c:	8b 00                	mov    (%rax),%eax
  80084e:	89 c0                	mov    %eax,%eax
  800850:	48 01 d0             	add    %rdx,%rax
  800853:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800857:	8b 12                	mov    (%rdx),%edx
  800859:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80085c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800860:	89 0a                	mov    %ecx,(%rdx)
  800862:	eb 17                	jmp    80087b <getint+0x102>
  800864:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800868:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80086c:	48 89 d0             	mov    %rdx,%rax
  80086f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800873:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800877:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80087b:	8b 00                	mov    (%rax),%eax
  80087d:	48 98                	cltq   
  80087f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800883:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800887:	c9                   	leaveq 
  800888:	c3                   	retq   

0000000000800889 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800889:	55                   	push   %rbp
  80088a:	48 89 e5             	mov    %rsp,%rbp
  80088d:	41 54                	push   %r12
  80088f:	53                   	push   %rbx
  800890:	48 83 ec 60          	sub    $0x60,%rsp
  800894:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800898:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80089c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008a0:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8008a4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8008a8:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8008ac:	48 8b 0a             	mov    (%rdx),%rcx
  8008af:	48 89 08             	mov    %rcx,(%rax)
  8008b2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008b6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008ba:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008be:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008c2:	eb 17                	jmp    8008db <vprintfmt+0x52>
			if (ch == '\0')
  8008c4:	85 db                	test   %ebx,%ebx
  8008c6:	0f 84 df 04 00 00    	je     800dab <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  8008cc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008d0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008d4:	48 89 d6             	mov    %rdx,%rsi
  8008d7:	89 df                	mov    %ebx,%edi
  8008d9:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008db:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008df:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008e3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008e7:	0f b6 00             	movzbl (%rax),%eax
  8008ea:	0f b6 d8             	movzbl %al,%ebx
  8008ed:	83 fb 25             	cmp    $0x25,%ebx
  8008f0:	75 d2                	jne    8008c4 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008f2:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008f6:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008fd:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800904:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80090b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800912:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800916:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80091a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80091e:	0f b6 00             	movzbl (%rax),%eax
  800921:	0f b6 d8             	movzbl %al,%ebx
  800924:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800927:	83 f8 55             	cmp    $0x55,%eax
  80092a:	0f 87 47 04 00 00    	ja     800d77 <vprintfmt+0x4ee>
  800930:	89 c0                	mov    %eax,%eax
  800932:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800939:	00 
  80093a:	48 b8 b8 19 80 00 00 	movabs $0x8019b8,%rax
  800941:	00 00 00 
  800944:	48 01 d0             	add    %rdx,%rax
  800947:	48 8b 00             	mov    (%rax),%rax
  80094a:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80094c:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800950:	eb c0                	jmp    800912 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800952:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800956:	eb ba                	jmp    800912 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800958:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80095f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800962:	89 d0                	mov    %edx,%eax
  800964:	c1 e0 02             	shl    $0x2,%eax
  800967:	01 d0                	add    %edx,%eax
  800969:	01 c0                	add    %eax,%eax
  80096b:	01 d8                	add    %ebx,%eax
  80096d:	83 e8 30             	sub    $0x30,%eax
  800970:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800973:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800977:	0f b6 00             	movzbl (%rax),%eax
  80097a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80097d:	83 fb 2f             	cmp    $0x2f,%ebx
  800980:	7e 0c                	jle    80098e <vprintfmt+0x105>
  800982:	83 fb 39             	cmp    $0x39,%ebx
  800985:	7f 07                	jg     80098e <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800987:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80098c:	eb d1                	jmp    80095f <vprintfmt+0xd6>
			goto process_precision;
  80098e:	eb 58                	jmp    8009e8 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800990:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800993:	83 f8 30             	cmp    $0x30,%eax
  800996:	73 17                	jae    8009af <vprintfmt+0x126>
  800998:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80099c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80099f:	89 c0                	mov    %eax,%eax
  8009a1:	48 01 d0             	add    %rdx,%rax
  8009a4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009a7:	83 c2 08             	add    $0x8,%edx
  8009aa:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009ad:	eb 0f                	jmp    8009be <vprintfmt+0x135>
  8009af:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009b3:	48 89 d0             	mov    %rdx,%rax
  8009b6:	48 83 c2 08          	add    $0x8,%rdx
  8009ba:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009be:	8b 00                	mov    (%rax),%eax
  8009c0:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8009c3:	eb 23                	jmp    8009e8 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8009c5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009c9:	79 0c                	jns    8009d7 <vprintfmt+0x14e>
				width = 0;
  8009cb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009d2:	e9 3b ff ff ff       	jmpq   800912 <vprintfmt+0x89>
  8009d7:	e9 36 ff ff ff       	jmpq   800912 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009dc:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009e3:	e9 2a ff ff ff       	jmpq   800912 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009e8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009ec:	79 12                	jns    800a00 <vprintfmt+0x177>
				width = precision, precision = -1;
  8009ee:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009f1:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009f4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009fb:	e9 12 ff ff ff       	jmpq   800912 <vprintfmt+0x89>
  800a00:	e9 0d ff ff ff       	jmpq   800912 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a05:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a09:	e9 04 ff ff ff       	jmpq   800912 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a0e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a11:	83 f8 30             	cmp    $0x30,%eax
  800a14:	73 17                	jae    800a2d <vprintfmt+0x1a4>
  800a16:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a1a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a1d:	89 c0                	mov    %eax,%eax
  800a1f:	48 01 d0             	add    %rdx,%rax
  800a22:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a25:	83 c2 08             	add    $0x8,%edx
  800a28:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a2b:	eb 0f                	jmp    800a3c <vprintfmt+0x1b3>
  800a2d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a31:	48 89 d0             	mov    %rdx,%rax
  800a34:	48 83 c2 08          	add    $0x8,%rdx
  800a38:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a3c:	8b 10                	mov    (%rax),%edx
  800a3e:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a42:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a46:	48 89 ce             	mov    %rcx,%rsi
  800a49:	89 d7                	mov    %edx,%edi
  800a4b:	ff d0                	callq  *%rax
			break;
  800a4d:	e9 53 03 00 00       	jmpq   800da5 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a52:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a55:	83 f8 30             	cmp    $0x30,%eax
  800a58:	73 17                	jae    800a71 <vprintfmt+0x1e8>
  800a5a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a5e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a61:	89 c0                	mov    %eax,%eax
  800a63:	48 01 d0             	add    %rdx,%rax
  800a66:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a69:	83 c2 08             	add    $0x8,%edx
  800a6c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a6f:	eb 0f                	jmp    800a80 <vprintfmt+0x1f7>
  800a71:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a75:	48 89 d0             	mov    %rdx,%rax
  800a78:	48 83 c2 08          	add    $0x8,%rdx
  800a7c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a80:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a82:	85 db                	test   %ebx,%ebx
  800a84:	79 02                	jns    800a88 <vprintfmt+0x1ff>
				err = -err;
  800a86:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a88:	83 fb 15             	cmp    $0x15,%ebx
  800a8b:	7f 16                	jg     800aa3 <vprintfmt+0x21a>
  800a8d:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  800a94:	00 00 00 
  800a97:	48 63 d3             	movslq %ebx,%rdx
  800a9a:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a9e:	4d 85 e4             	test   %r12,%r12
  800aa1:	75 2e                	jne    800ad1 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800aa3:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800aa7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aab:	89 d9                	mov    %ebx,%ecx
  800aad:	48 ba a1 19 80 00 00 	movabs $0x8019a1,%rdx
  800ab4:	00 00 00 
  800ab7:	48 89 c7             	mov    %rax,%rdi
  800aba:	b8 00 00 00 00       	mov    $0x0,%eax
  800abf:	49 b8 b4 0d 80 00 00 	movabs $0x800db4,%r8
  800ac6:	00 00 00 
  800ac9:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800acc:	e9 d4 02 00 00       	jmpq   800da5 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ad1:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ad5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ad9:	4c 89 e1             	mov    %r12,%rcx
  800adc:	48 ba aa 19 80 00 00 	movabs $0x8019aa,%rdx
  800ae3:	00 00 00 
  800ae6:	48 89 c7             	mov    %rax,%rdi
  800ae9:	b8 00 00 00 00       	mov    $0x0,%eax
  800aee:	49 b8 b4 0d 80 00 00 	movabs $0x800db4,%r8
  800af5:	00 00 00 
  800af8:	41 ff d0             	callq  *%r8
			break;
  800afb:	e9 a5 02 00 00       	jmpq   800da5 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b00:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b03:	83 f8 30             	cmp    $0x30,%eax
  800b06:	73 17                	jae    800b1f <vprintfmt+0x296>
  800b08:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b0c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b0f:	89 c0                	mov    %eax,%eax
  800b11:	48 01 d0             	add    %rdx,%rax
  800b14:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b17:	83 c2 08             	add    $0x8,%edx
  800b1a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b1d:	eb 0f                	jmp    800b2e <vprintfmt+0x2a5>
  800b1f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b23:	48 89 d0             	mov    %rdx,%rax
  800b26:	48 83 c2 08          	add    $0x8,%rdx
  800b2a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b2e:	4c 8b 20             	mov    (%rax),%r12
  800b31:	4d 85 e4             	test   %r12,%r12
  800b34:	75 0a                	jne    800b40 <vprintfmt+0x2b7>
				p = "(null)";
  800b36:	49 bc ad 19 80 00 00 	movabs $0x8019ad,%r12
  800b3d:	00 00 00 
			if (width > 0 && padc != '-')
  800b40:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b44:	7e 3f                	jle    800b85 <vprintfmt+0x2fc>
  800b46:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b4a:	74 39                	je     800b85 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b4c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b4f:	48 98                	cltq   
  800b51:	48 89 c6             	mov    %rax,%rsi
  800b54:	4c 89 e7             	mov    %r12,%rdi
  800b57:	48 b8 60 10 80 00 00 	movabs $0x801060,%rax
  800b5e:	00 00 00 
  800b61:	ff d0                	callq  *%rax
  800b63:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b66:	eb 17                	jmp    800b7f <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b68:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b6c:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b70:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b74:	48 89 ce             	mov    %rcx,%rsi
  800b77:	89 d7                	mov    %edx,%edi
  800b79:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b7b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b7f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b83:	7f e3                	jg     800b68 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b85:	eb 37                	jmp    800bbe <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b87:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b8b:	74 1e                	je     800bab <vprintfmt+0x322>
  800b8d:	83 fb 1f             	cmp    $0x1f,%ebx
  800b90:	7e 05                	jle    800b97 <vprintfmt+0x30e>
  800b92:	83 fb 7e             	cmp    $0x7e,%ebx
  800b95:	7e 14                	jle    800bab <vprintfmt+0x322>
					putch('?', putdat);
  800b97:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b9b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b9f:	48 89 d6             	mov    %rdx,%rsi
  800ba2:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800ba7:	ff d0                	callq  *%rax
  800ba9:	eb 0f                	jmp    800bba <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800bab:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800baf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb3:	48 89 d6             	mov    %rdx,%rsi
  800bb6:	89 df                	mov    %ebx,%edi
  800bb8:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bba:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bbe:	4c 89 e0             	mov    %r12,%rax
  800bc1:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800bc5:	0f b6 00             	movzbl (%rax),%eax
  800bc8:	0f be d8             	movsbl %al,%ebx
  800bcb:	85 db                	test   %ebx,%ebx
  800bcd:	74 10                	je     800bdf <vprintfmt+0x356>
  800bcf:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bd3:	78 b2                	js     800b87 <vprintfmt+0x2fe>
  800bd5:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800bd9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bdd:	79 a8                	jns    800b87 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bdf:	eb 16                	jmp    800bf7 <vprintfmt+0x36e>
				putch(' ', putdat);
  800be1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800be5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800be9:	48 89 d6             	mov    %rdx,%rsi
  800bec:	bf 20 00 00 00       	mov    $0x20,%edi
  800bf1:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bf3:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bf7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bfb:	7f e4                	jg     800be1 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800bfd:	e9 a3 01 00 00       	jmpq   800da5 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c02:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c06:	be 03 00 00 00       	mov    $0x3,%esi
  800c0b:	48 89 c7             	mov    %rax,%rdi
  800c0e:	48 b8 79 07 80 00 00 	movabs $0x800779,%rax
  800c15:	00 00 00 
  800c18:	ff d0                	callq  *%rax
  800c1a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c22:	48 85 c0             	test   %rax,%rax
  800c25:	79 1d                	jns    800c44 <vprintfmt+0x3bb>
				putch('-', putdat);
  800c27:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c2b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c2f:	48 89 d6             	mov    %rdx,%rsi
  800c32:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c37:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c3d:	48 f7 d8             	neg    %rax
  800c40:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c44:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c4b:	e9 e8 00 00 00       	jmpq   800d38 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c50:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c54:	be 03 00 00 00       	mov    $0x3,%esi
  800c59:	48 89 c7             	mov    %rax,%rdi
  800c5c:	48 b8 69 06 80 00 00 	movabs $0x800669,%rax
  800c63:	00 00 00 
  800c66:	ff d0                	callq  *%rax
  800c68:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c6c:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c73:	e9 c0 00 00 00       	jmpq   800d38 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c78:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c7c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c80:	48 89 d6             	mov    %rdx,%rsi
  800c83:	bf 58 00 00 00       	mov    $0x58,%edi
  800c88:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c8a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c8e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c92:	48 89 d6             	mov    %rdx,%rsi
  800c95:	bf 58 00 00 00       	mov    $0x58,%edi
  800c9a:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c9c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ca0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ca4:	48 89 d6             	mov    %rdx,%rsi
  800ca7:	bf 58 00 00 00       	mov    $0x58,%edi
  800cac:	ff d0                	callq  *%rax
			break;
  800cae:	e9 f2 00 00 00       	jmpq   800da5 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800cb3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cb7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cbb:	48 89 d6             	mov    %rdx,%rsi
  800cbe:	bf 30 00 00 00       	mov    $0x30,%edi
  800cc3:	ff d0                	callq  *%rax
			putch('x', putdat);
  800cc5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cc9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ccd:	48 89 d6             	mov    %rdx,%rsi
  800cd0:	bf 78 00 00 00       	mov    $0x78,%edi
  800cd5:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800cd7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cda:	83 f8 30             	cmp    $0x30,%eax
  800cdd:	73 17                	jae    800cf6 <vprintfmt+0x46d>
  800cdf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ce3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ce6:	89 c0                	mov    %eax,%eax
  800ce8:	48 01 d0             	add    %rdx,%rax
  800ceb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cee:	83 c2 08             	add    $0x8,%edx
  800cf1:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cf4:	eb 0f                	jmp    800d05 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800cf6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cfa:	48 89 d0             	mov    %rdx,%rax
  800cfd:	48 83 c2 08          	add    $0x8,%rdx
  800d01:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d05:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d08:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d0c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d13:	eb 23                	jmp    800d38 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d15:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d19:	be 03 00 00 00       	mov    $0x3,%esi
  800d1e:	48 89 c7             	mov    %rax,%rdi
  800d21:	48 b8 69 06 80 00 00 	movabs $0x800669,%rax
  800d28:	00 00 00 
  800d2b:	ff d0                	callq  *%rax
  800d2d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d31:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d38:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d3d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d40:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d43:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d47:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d4b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d4f:	45 89 c1             	mov    %r8d,%r9d
  800d52:	41 89 f8             	mov    %edi,%r8d
  800d55:	48 89 c7             	mov    %rax,%rdi
  800d58:	48 b8 ae 05 80 00 00 	movabs $0x8005ae,%rax
  800d5f:	00 00 00 
  800d62:	ff d0                	callq  *%rax
			break;
  800d64:	eb 3f                	jmp    800da5 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d66:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d6a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d6e:	48 89 d6             	mov    %rdx,%rsi
  800d71:	89 df                	mov    %ebx,%edi
  800d73:	ff d0                	callq  *%rax
			break;
  800d75:	eb 2e                	jmp    800da5 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d77:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d7b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d7f:	48 89 d6             	mov    %rdx,%rsi
  800d82:	bf 25 00 00 00       	mov    $0x25,%edi
  800d87:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d89:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d8e:	eb 05                	jmp    800d95 <vprintfmt+0x50c>
  800d90:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d95:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d99:	48 83 e8 01          	sub    $0x1,%rax
  800d9d:	0f b6 00             	movzbl (%rax),%eax
  800da0:	3c 25                	cmp    $0x25,%al
  800da2:	75 ec                	jne    800d90 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800da4:	90                   	nop
		}
	}
  800da5:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800da6:	e9 30 fb ff ff       	jmpq   8008db <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800dab:	48 83 c4 60          	add    $0x60,%rsp
  800daf:	5b                   	pop    %rbx
  800db0:	41 5c                	pop    %r12
  800db2:	5d                   	pop    %rbp
  800db3:	c3                   	retq   

0000000000800db4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800db4:	55                   	push   %rbp
  800db5:	48 89 e5             	mov    %rsp,%rbp
  800db8:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800dbf:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800dc6:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800dcd:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800dd4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ddb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800de2:	84 c0                	test   %al,%al
  800de4:	74 20                	je     800e06 <printfmt+0x52>
  800de6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dea:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dee:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800df2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800df6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dfa:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dfe:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e02:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e06:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e0d:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e14:	00 00 00 
  800e17:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e1e:	00 00 00 
  800e21:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e25:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e2c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e33:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e3a:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e41:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e48:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e4f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e56:	48 89 c7             	mov    %rax,%rdi
  800e59:	48 b8 89 08 80 00 00 	movabs $0x800889,%rax
  800e60:	00 00 00 
  800e63:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e65:	c9                   	leaveq 
  800e66:	c3                   	retq   

0000000000800e67 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e67:	55                   	push   %rbp
  800e68:	48 89 e5             	mov    %rsp,%rbp
  800e6b:	48 83 ec 10          	sub    $0x10,%rsp
  800e6f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e72:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e7a:	8b 40 10             	mov    0x10(%rax),%eax
  800e7d:	8d 50 01             	lea    0x1(%rax),%edx
  800e80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e84:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e8b:	48 8b 10             	mov    (%rax),%rdx
  800e8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e92:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e96:	48 39 c2             	cmp    %rax,%rdx
  800e99:	73 17                	jae    800eb2 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e9f:	48 8b 00             	mov    (%rax),%rax
  800ea2:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800ea6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800eaa:	48 89 0a             	mov    %rcx,(%rdx)
  800ead:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800eb0:	88 10                	mov    %dl,(%rax)
}
  800eb2:	c9                   	leaveq 
  800eb3:	c3                   	retq   

0000000000800eb4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800eb4:	55                   	push   %rbp
  800eb5:	48 89 e5             	mov    %rsp,%rbp
  800eb8:	48 83 ec 50          	sub    $0x50,%rsp
  800ebc:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800ec0:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800ec3:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ec7:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ecb:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ecf:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800ed3:	48 8b 0a             	mov    (%rdx),%rcx
  800ed6:	48 89 08             	mov    %rcx,(%rax)
  800ed9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800edd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ee1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ee5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ee9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800eed:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ef1:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800ef4:	48 98                	cltq   
  800ef6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800efa:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800efe:	48 01 d0             	add    %rdx,%rax
  800f01:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f05:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f0c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f11:	74 06                	je     800f19 <vsnprintf+0x65>
  800f13:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f17:	7f 07                	jg     800f20 <vsnprintf+0x6c>
		return -E_INVAL;
  800f19:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f1e:	eb 2f                	jmp    800f4f <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f20:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f24:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f28:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f2c:	48 89 c6             	mov    %rax,%rsi
  800f2f:	48 bf 67 0e 80 00 00 	movabs $0x800e67,%rdi
  800f36:	00 00 00 
  800f39:	48 b8 89 08 80 00 00 	movabs $0x800889,%rax
  800f40:	00 00 00 
  800f43:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f45:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f49:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f4c:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f4f:	c9                   	leaveq 
  800f50:	c3                   	retq   

0000000000800f51 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f51:	55                   	push   %rbp
  800f52:	48 89 e5             	mov    %rsp,%rbp
  800f55:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f5c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f63:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f69:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f70:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f77:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f7e:	84 c0                	test   %al,%al
  800f80:	74 20                	je     800fa2 <snprintf+0x51>
  800f82:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f86:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f8a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f8e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f92:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f96:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f9a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f9e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fa2:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800fa9:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800fb0:	00 00 00 
  800fb3:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fba:	00 00 00 
  800fbd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fc1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fc8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fcf:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fd6:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fdd:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fe4:	48 8b 0a             	mov    (%rdx),%rcx
  800fe7:	48 89 08             	mov    %rcx,(%rax)
  800fea:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fee:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ff2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ff6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800ffa:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801001:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801008:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80100e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801015:	48 89 c7             	mov    %rax,%rdi
  801018:	48 b8 b4 0e 80 00 00 	movabs $0x800eb4,%rax
  80101f:	00 00 00 
  801022:	ff d0                	callq  *%rax
  801024:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80102a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801030:	c9                   	leaveq 
  801031:	c3                   	retq   

0000000000801032 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801032:	55                   	push   %rbp
  801033:	48 89 e5             	mov    %rsp,%rbp
  801036:	48 83 ec 18          	sub    $0x18,%rsp
  80103a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80103e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801045:	eb 09                	jmp    801050 <strlen+0x1e>
		n++;
  801047:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80104b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801050:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801054:	0f b6 00             	movzbl (%rax),%eax
  801057:	84 c0                	test   %al,%al
  801059:	75 ec                	jne    801047 <strlen+0x15>
		n++;
	return n;
  80105b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80105e:	c9                   	leaveq 
  80105f:	c3                   	retq   

0000000000801060 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801060:	55                   	push   %rbp
  801061:	48 89 e5             	mov    %rsp,%rbp
  801064:	48 83 ec 20          	sub    $0x20,%rsp
  801068:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80106c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801070:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801077:	eb 0e                	jmp    801087 <strnlen+0x27>
		n++;
  801079:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80107d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801082:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801087:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80108c:	74 0b                	je     801099 <strnlen+0x39>
  80108e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801092:	0f b6 00             	movzbl (%rax),%eax
  801095:	84 c0                	test   %al,%al
  801097:	75 e0                	jne    801079 <strnlen+0x19>
		n++;
	return n;
  801099:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80109c:	c9                   	leaveq 
  80109d:	c3                   	retq   

000000000080109e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80109e:	55                   	push   %rbp
  80109f:	48 89 e5             	mov    %rsp,%rbp
  8010a2:	48 83 ec 20          	sub    $0x20,%rsp
  8010a6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010aa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8010ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8010b6:	90                   	nop
  8010b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010bb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010bf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010c3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010c7:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010cb:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010cf:	0f b6 12             	movzbl (%rdx),%edx
  8010d2:	88 10                	mov    %dl,(%rax)
  8010d4:	0f b6 00             	movzbl (%rax),%eax
  8010d7:	84 c0                	test   %al,%al
  8010d9:	75 dc                	jne    8010b7 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010df:	c9                   	leaveq 
  8010e0:	c3                   	retq   

00000000008010e1 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010e1:	55                   	push   %rbp
  8010e2:	48 89 e5             	mov    %rsp,%rbp
  8010e5:	48 83 ec 20          	sub    $0x20,%rsp
  8010e9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010ed:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f5:	48 89 c7             	mov    %rax,%rdi
  8010f8:	48 b8 32 10 80 00 00 	movabs $0x801032,%rax
  8010ff:	00 00 00 
  801102:	ff d0                	callq  *%rax
  801104:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801107:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80110a:	48 63 d0             	movslq %eax,%rdx
  80110d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801111:	48 01 c2             	add    %rax,%rdx
  801114:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801118:	48 89 c6             	mov    %rax,%rsi
  80111b:	48 89 d7             	mov    %rdx,%rdi
  80111e:	48 b8 9e 10 80 00 00 	movabs $0x80109e,%rax
  801125:	00 00 00 
  801128:	ff d0                	callq  *%rax
	return dst;
  80112a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80112e:	c9                   	leaveq 
  80112f:	c3                   	retq   

0000000000801130 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801130:	55                   	push   %rbp
  801131:	48 89 e5             	mov    %rsp,%rbp
  801134:	48 83 ec 28          	sub    $0x28,%rsp
  801138:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80113c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801140:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801144:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801148:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80114c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801153:	00 
  801154:	eb 2a                	jmp    801180 <strncpy+0x50>
		*dst++ = *src;
  801156:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80115a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80115e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801162:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801166:	0f b6 12             	movzbl (%rdx),%edx
  801169:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80116b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80116f:	0f b6 00             	movzbl (%rax),%eax
  801172:	84 c0                	test   %al,%al
  801174:	74 05                	je     80117b <strncpy+0x4b>
			src++;
  801176:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80117b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801180:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801184:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801188:	72 cc                	jb     801156 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80118a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80118e:	c9                   	leaveq 
  80118f:	c3                   	retq   

0000000000801190 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801190:	55                   	push   %rbp
  801191:	48 89 e5             	mov    %rsp,%rbp
  801194:	48 83 ec 28          	sub    $0x28,%rsp
  801198:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80119c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8011a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8011ac:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011b1:	74 3d                	je     8011f0 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8011b3:	eb 1d                	jmp    8011d2 <strlcpy+0x42>
			*dst++ = *src++;
  8011b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011bd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011c1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011c5:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011c9:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011cd:	0f b6 12             	movzbl (%rdx),%edx
  8011d0:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011d2:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011d7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011dc:	74 0b                	je     8011e9 <strlcpy+0x59>
  8011de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011e2:	0f b6 00             	movzbl (%rax),%eax
  8011e5:	84 c0                	test   %al,%al
  8011e7:	75 cc                	jne    8011b5 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ed:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f8:	48 29 c2             	sub    %rax,%rdx
  8011fb:	48 89 d0             	mov    %rdx,%rax
}
  8011fe:	c9                   	leaveq 
  8011ff:	c3                   	retq   

0000000000801200 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801200:	55                   	push   %rbp
  801201:	48 89 e5             	mov    %rsp,%rbp
  801204:	48 83 ec 10          	sub    $0x10,%rsp
  801208:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80120c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801210:	eb 0a                	jmp    80121c <strcmp+0x1c>
		p++, q++;
  801212:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801217:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80121c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801220:	0f b6 00             	movzbl (%rax),%eax
  801223:	84 c0                	test   %al,%al
  801225:	74 12                	je     801239 <strcmp+0x39>
  801227:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122b:	0f b6 10             	movzbl (%rax),%edx
  80122e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801232:	0f b6 00             	movzbl (%rax),%eax
  801235:	38 c2                	cmp    %al,%dl
  801237:	74 d9                	je     801212 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801239:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80123d:	0f b6 00             	movzbl (%rax),%eax
  801240:	0f b6 d0             	movzbl %al,%edx
  801243:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801247:	0f b6 00             	movzbl (%rax),%eax
  80124a:	0f b6 c0             	movzbl %al,%eax
  80124d:	29 c2                	sub    %eax,%edx
  80124f:	89 d0                	mov    %edx,%eax
}
  801251:	c9                   	leaveq 
  801252:	c3                   	retq   

0000000000801253 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801253:	55                   	push   %rbp
  801254:	48 89 e5             	mov    %rsp,%rbp
  801257:	48 83 ec 18          	sub    $0x18,%rsp
  80125b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80125f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801263:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801267:	eb 0f                	jmp    801278 <strncmp+0x25>
		n--, p++, q++;
  801269:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80126e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801273:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801278:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80127d:	74 1d                	je     80129c <strncmp+0x49>
  80127f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801283:	0f b6 00             	movzbl (%rax),%eax
  801286:	84 c0                	test   %al,%al
  801288:	74 12                	je     80129c <strncmp+0x49>
  80128a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80128e:	0f b6 10             	movzbl (%rax),%edx
  801291:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801295:	0f b6 00             	movzbl (%rax),%eax
  801298:	38 c2                	cmp    %al,%dl
  80129a:	74 cd                	je     801269 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80129c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012a1:	75 07                	jne    8012aa <strncmp+0x57>
		return 0;
  8012a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a8:	eb 18                	jmp    8012c2 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ae:	0f b6 00             	movzbl (%rax),%eax
  8012b1:	0f b6 d0             	movzbl %al,%edx
  8012b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012b8:	0f b6 00             	movzbl (%rax),%eax
  8012bb:	0f b6 c0             	movzbl %al,%eax
  8012be:	29 c2                	sub    %eax,%edx
  8012c0:	89 d0                	mov    %edx,%eax
}
  8012c2:	c9                   	leaveq 
  8012c3:	c3                   	retq   

00000000008012c4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012c4:	55                   	push   %rbp
  8012c5:	48 89 e5             	mov    %rsp,%rbp
  8012c8:	48 83 ec 0c          	sub    $0xc,%rsp
  8012cc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012d0:	89 f0                	mov    %esi,%eax
  8012d2:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012d5:	eb 17                	jmp    8012ee <strchr+0x2a>
		if (*s == c)
  8012d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012db:	0f b6 00             	movzbl (%rax),%eax
  8012de:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012e1:	75 06                	jne    8012e9 <strchr+0x25>
			return (char *) s;
  8012e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e7:	eb 15                	jmp    8012fe <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012e9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f2:	0f b6 00             	movzbl (%rax),%eax
  8012f5:	84 c0                	test   %al,%al
  8012f7:	75 de                	jne    8012d7 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012fe:	c9                   	leaveq 
  8012ff:	c3                   	retq   

0000000000801300 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801300:	55                   	push   %rbp
  801301:	48 89 e5             	mov    %rsp,%rbp
  801304:	48 83 ec 0c          	sub    $0xc,%rsp
  801308:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80130c:	89 f0                	mov    %esi,%eax
  80130e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801311:	eb 13                	jmp    801326 <strfind+0x26>
		if (*s == c)
  801313:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801317:	0f b6 00             	movzbl (%rax),%eax
  80131a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80131d:	75 02                	jne    801321 <strfind+0x21>
			break;
  80131f:	eb 10                	jmp    801331 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801321:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801326:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132a:	0f b6 00             	movzbl (%rax),%eax
  80132d:	84 c0                	test   %al,%al
  80132f:	75 e2                	jne    801313 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801331:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801335:	c9                   	leaveq 
  801336:	c3                   	retq   

0000000000801337 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801337:	55                   	push   %rbp
  801338:	48 89 e5             	mov    %rsp,%rbp
  80133b:	48 83 ec 18          	sub    $0x18,%rsp
  80133f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801343:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801346:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80134a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80134f:	75 06                	jne    801357 <memset+0x20>
		return v;
  801351:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801355:	eb 69                	jmp    8013c0 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801357:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80135b:	83 e0 03             	and    $0x3,%eax
  80135e:	48 85 c0             	test   %rax,%rax
  801361:	75 48                	jne    8013ab <memset+0x74>
  801363:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801367:	83 e0 03             	and    $0x3,%eax
  80136a:	48 85 c0             	test   %rax,%rax
  80136d:	75 3c                	jne    8013ab <memset+0x74>
		c &= 0xFF;
  80136f:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801376:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801379:	c1 e0 18             	shl    $0x18,%eax
  80137c:	89 c2                	mov    %eax,%edx
  80137e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801381:	c1 e0 10             	shl    $0x10,%eax
  801384:	09 c2                	or     %eax,%edx
  801386:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801389:	c1 e0 08             	shl    $0x8,%eax
  80138c:	09 d0                	or     %edx,%eax
  80138e:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801391:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801395:	48 c1 e8 02          	shr    $0x2,%rax
  801399:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80139c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013a0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013a3:	48 89 d7             	mov    %rdx,%rdi
  8013a6:	fc                   	cld    
  8013a7:	f3 ab                	rep stos %eax,%es:(%rdi)
  8013a9:	eb 11                	jmp    8013bc <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013ab:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013af:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013b2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013b6:	48 89 d7             	mov    %rdx,%rdi
  8013b9:	fc                   	cld    
  8013ba:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8013bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013c0:	c9                   	leaveq 
  8013c1:	c3                   	retq   

00000000008013c2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013c2:	55                   	push   %rbp
  8013c3:	48 89 e5             	mov    %rsp,%rbp
  8013c6:	48 83 ec 28          	sub    $0x28,%rsp
  8013ca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013ce:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013d2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013da:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ea:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013ee:	0f 83 88 00 00 00    	jae    80147c <memmove+0xba>
  8013f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013fc:	48 01 d0             	add    %rdx,%rax
  8013ff:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801403:	76 77                	jbe    80147c <memmove+0xba>
		s += n;
  801405:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801409:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80140d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801411:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801415:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801419:	83 e0 03             	and    $0x3,%eax
  80141c:	48 85 c0             	test   %rax,%rax
  80141f:	75 3b                	jne    80145c <memmove+0x9a>
  801421:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801425:	83 e0 03             	and    $0x3,%eax
  801428:	48 85 c0             	test   %rax,%rax
  80142b:	75 2f                	jne    80145c <memmove+0x9a>
  80142d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801431:	83 e0 03             	and    $0x3,%eax
  801434:	48 85 c0             	test   %rax,%rax
  801437:	75 23                	jne    80145c <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801439:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80143d:	48 83 e8 04          	sub    $0x4,%rax
  801441:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801445:	48 83 ea 04          	sub    $0x4,%rdx
  801449:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80144d:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801451:	48 89 c7             	mov    %rax,%rdi
  801454:	48 89 d6             	mov    %rdx,%rsi
  801457:	fd                   	std    
  801458:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80145a:	eb 1d                	jmp    801479 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80145c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801460:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801464:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801468:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80146c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801470:	48 89 d7             	mov    %rdx,%rdi
  801473:	48 89 c1             	mov    %rax,%rcx
  801476:	fd                   	std    
  801477:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801479:	fc                   	cld    
  80147a:	eb 57                	jmp    8014d3 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80147c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801480:	83 e0 03             	and    $0x3,%eax
  801483:	48 85 c0             	test   %rax,%rax
  801486:	75 36                	jne    8014be <memmove+0xfc>
  801488:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80148c:	83 e0 03             	and    $0x3,%eax
  80148f:	48 85 c0             	test   %rax,%rax
  801492:	75 2a                	jne    8014be <memmove+0xfc>
  801494:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801498:	83 e0 03             	and    $0x3,%eax
  80149b:	48 85 c0             	test   %rax,%rax
  80149e:	75 1e                	jne    8014be <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8014a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a4:	48 c1 e8 02          	shr    $0x2,%rax
  8014a8:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8014ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014af:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014b3:	48 89 c7             	mov    %rax,%rdi
  8014b6:	48 89 d6             	mov    %rdx,%rsi
  8014b9:	fc                   	cld    
  8014ba:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014bc:	eb 15                	jmp    8014d3 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8014be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014c6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014ca:	48 89 c7             	mov    %rax,%rdi
  8014cd:	48 89 d6             	mov    %rdx,%rsi
  8014d0:	fc                   	cld    
  8014d1:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014d7:	c9                   	leaveq 
  8014d8:	c3                   	retq   

00000000008014d9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014d9:	55                   	push   %rbp
  8014da:	48 89 e5             	mov    %rsp,%rbp
  8014dd:	48 83 ec 18          	sub    $0x18,%rsp
  8014e1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014e5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014e9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014f1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f9:	48 89 ce             	mov    %rcx,%rsi
  8014fc:	48 89 c7             	mov    %rax,%rdi
  8014ff:	48 b8 c2 13 80 00 00 	movabs $0x8013c2,%rax
  801506:	00 00 00 
  801509:	ff d0                	callq  *%rax
}
  80150b:	c9                   	leaveq 
  80150c:	c3                   	retq   

000000000080150d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80150d:	55                   	push   %rbp
  80150e:	48 89 e5             	mov    %rsp,%rbp
  801511:	48 83 ec 28          	sub    $0x28,%rsp
  801515:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801519:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80151d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801521:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801525:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801529:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80152d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801531:	eb 36                	jmp    801569 <memcmp+0x5c>
		if (*s1 != *s2)
  801533:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801537:	0f b6 10             	movzbl (%rax),%edx
  80153a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80153e:	0f b6 00             	movzbl (%rax),%eax
  801541:	38 c2                	cmp    %al,%dl
  801543:	74 1a                	je     80155f <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801545:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801549:	0f b6 00             	movzbl (%rax),%eax
  80154c:	0f b6 d0             	movzbl %al,%edx
  80154f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801553:	0f b6 00             	movzbl (%rax),%eax
  801556:	0f b6 c0             	movzbl %al,%eax
  801559:	29 c2                	sub    %eax,%edx
  80155b:	89 d0                	mov    %edx,%eax
  80155d:	eb 20                	jmp    80157f <memcmp+0x72>
		s1++, s2++;
  80155f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801564:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801569:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801571:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801575:	48 85 c0             	test   %rax,%rax
  801578:	75 b9                	jne    801533 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80157a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80157f:	c9                   	leaveq 
  801580:	c3                   	retq   

0000000000801581 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801581:	55                   	push   %rbp
  801582:	48 89 e5             	mov    %rsp,%rbp
  801585:	48 83 ec 28          	sub    $0x28,%rsp
  801589:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80158d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801590:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801594:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801598:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80159c:	48 01 d0             	add    %rdx,%rax
  80159f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8015a3:	eb 15                	jmp    8015ba <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015a9:	0f b6 10             	movzbl (%rax),%edx
  8015ac:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8015af:	38 c2                	cmp    %al,%dl
  8015b1:	75 02                	jne    8015b5 <memfind+0x34>
			break;
  8015b3:	eb 0f                	jmp    8015c4 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015b5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015be:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8015c2:	72 e1                	jb     8015a5 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8015c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015c8:	c9                   	leaveq 
  8015c9:	c3                   	retq   

00000000008015ca <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015ca:	55                   	push   %rbp
  8015cb:	48 89 e5             	mov    %rsp,%rbp
  8015ce:	48 83 ec 34          	sub    $0x34,%rsp
  8015d2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015d6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015da:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015e4:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015eb:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015ec:	eb 05                	jmp    8015f3 <strtol+0x29>
		s++;
  8015ee:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f7:	0f b6 00             	movzbl (%rax),%eax
  8015fa:	3c 20                	cmp    $0x20,%al
  8015fc:	74 f0                	je     8015ee <strtol+0x24>
  8015fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801602:	0f b6 00             	movzbl (%rax),%eax
  801605:	3c 09                	cmp    $0x9,%al
  801607:	74 e5                	je     8015ee <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801609:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160d:	0f b6 00             	movzbl (%rax),%eax
  801610:	3c 2b                	cmp    $0x2b,%al
  801612:	75 07                	jne    80161b <strtol+0x51>
		s++;
  801614:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801619:	eb 17                	jmp    801632 <strtol+0x68>
	else if (*s == '-')
  80161b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161f:	0f b6 00             	movzbl (%rax),%eax
  801622:	3c 2d                	cmp    $0x2d,%al
  801624:	75 0c                	jne    801632 <strtol+0x68>
		s++, neg = 1;
  801626:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80162b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801632:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801636:	74 06                	je     80163e <strtol+0x74>
  801638:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80163c:	75 28                	jne    801666 <strtol+0x9c>
  80163e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801642:	0f b6 00             	movzbl (%rax),%eax
  801645:	3c 30                	cmp    $0x30,%al
  801647:	75 1d                	jne    801666 <strtol+0x9c>
  801649:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164d:	48 83 c0 01          	add    $0x1,%rax
  801651:	0f b6 00             	movzbl (%rax),%eax
  801654:	3c 78                	cmp    $0x78,%al
  801656:	75 0e                	jne    801666 <strtol+0x9c>
		s += 2, base = 16;
  801658:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80165d:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801664:	eb 2c                	jmp    801692 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801666:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80166a:	75 19                	jne    801685 <strtol+0xbb>
  80166c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801670:	0f b6 00             	movzbl (%rax),%eax
  801673:	3c 30                	cmp    $0x30,%al
  801675:	75 0e                	jne    801685 <strtol+0xbb>
		s++, base = 8;
  801677:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80167c:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801683:	eb 0d                	jmp    801692 <strtol+0xc8>
	else if (base == 0)
  801685:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801689:	75 07                	jne    801692 <strtol+0xc8>
		base = 10;
  80168b:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801692:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801696:	0f b6 00             	movzbl (%rax),%eax
  801699:	3c 2f                	cmp    $0x2f,%al
  80169b:	7e 1d                	jle    8016ba <strtol+0xf0>
  80169d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a1:	0f b6 00             	movzbl (%rax),%eax
  8016a4:	3c 39                	cmp    $0x39,%al
  8016a6:	7f 12                	jg     8016ba <strtol+0xf0>
			dig = *s - '0';
  8016a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ac:	0f b6 00             	movzbl (%rax),%eax
  8016af:	0f be c0             	movsbl %al,%eax
  8016b2:	83 e8 30             	sub    $0x30,%eax
  8016b5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016b8:	eb 4e                	jmp    801708 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8016ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016be:	0f b6 00             	movzbl (%rax),%eax
  8016c1:	3c 60                	cmp    $0x60,%al
  8016c3:	7e 1d                	jle    8016e2 <strtol+0x118>
  8016c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c9:	0f b6 00             	movzbl (%rax),%eax
  8016cc:	3c 7a                	cmp    $0x7a,%al
  8016ce:	7f 12                	jg     8016e2 <strtol+0x118>
			dig = *s - 'a' + 10;
  8016d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d4:	0f b6 00             	movzbl (%rax),%eax
  8016d7:	0f be c0             	movsbl %al,%eax
  8016da:	83 e8 57             	sub    $0x57,%eax
  8016dd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016e0:	eb 26                	jmp    801708 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e6:	0f b6 00             	movzbl (%rax),%eax
  8016e9:	3c 40                	cmp    $0x40,%al
  8016eb:	7e 48                	jle    801735 <strtol+0x16b>
  8016ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f1:	0f b6 00             	movzbl (%rax),%eax
  8016f4:	3c 5a                	cmp    $0x5a,%al
  8016f6:	7f 3d                	jg     801735 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016fc:	0f b6 00             	movzbl (%rax),%eax
  8016ff:	0f be c0             	movsbl %al,%eax
  801702:	83 e8 37             	sub    $0x37,%eax
  801705:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801708:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80170b:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80170e:	7c 02                	jl     801712 <strtol+0x148>
			break;
  801710:	eb 23                	jmp    801735 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801712:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801717:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80171a:	48 98                	cltq   
  80171c:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801721:	48 89 c2             	mov    %rax,%rdx
  801724:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801727:	48 98                	cltq   
  801729:	48 01 d0             	add    %rdx,%rax
  80172c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801730:	e9 5d ff ff ff       	jmpq   801692 <strtol+0xc8>

	if (endptr)
  801735:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80173a:	74 0b                	je     801747 <strtol+0x17d>
		*endptr = (char *) s;
  80173c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801740:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801744:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801747:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80174b:	74 09                	je     801756 <strtol+0x18c>
  80174d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801751:	48 f7 d8             	neg    %rax
  801754:	eb 04                	jmp    80175a <strtol+0x190>
  801756:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80175a:	c9                   	leaveq 
  80175b:	c3                   	retq   

000000000080175c <strstr>:

char * strstr(const char *in, const char *str)
{
  80175c:	55                   	push   %rbp
  80175d:	48 89 e5             	mov    %rsp,%rbp
  801760:	48 83 ec 30          	sub    $0x30,%rsp
  801764:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801768:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80176c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801770:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801774:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801778:	0f b6 00             	movzbl (%rax),%eax
  80177b:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80177e:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801782:	75 06                	jne    80178a <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801784:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801788:	eb 6b                	jmp    8017f5 <strstr+0x99>

	len = strlen(str);
  80178a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80178e:	48 89 c7             	mov    %rax,%rdi
  801791:	48 b8 32 10 80 00 00 	movabs $0x801032,%rax
  801798:	00 00 00 
  80179b:	ff d0                	callq  *%rax
  80179d:	48 98                	cltq   
  80179f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8017a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017ab:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017af:	0f b6 00             	movzbl (%rax),%eax
  8017b2:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8017b5:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8017b9:	75 07                	jne    8017c2 <strstr+0x66>
				return (char *) 0;
  8017bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c0:	eb 33                	jmp    8017f5 <strstr+0x99>
		} while (sc != c);
  8017c2:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8017c6:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8017c9:	75 d8                	jne    8017a3 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8017cb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017cf:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d7:	48 89 ce             	mov    %rcx,%rsi
  8017da:	48 89 c7             	mov    %rax,%rdi
  8017dd:	48 b8 53 12 80 00 00 	movabs $0x801253,%rax
  8017e4:	00 00 00 
  8017e7:	ff d0                	callq  *%rax
  8017e9:	85 c0                	test   %eax,%eax
  8017eb:	75 b6                	jne    8017a3 <strstr+0x47>

	return (char *) (in - 1);
  8017ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f1:	48 83 e8 01          	sub    $0x1,%rax
}
  8017f5:	c9                   	leaveq 
  8017f6:	c3                   	retq   
