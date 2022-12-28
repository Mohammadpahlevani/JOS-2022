
obj/user/badsegment:     file format elf64-x86-64


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
  80003c:	e8 19 00 00 00       	callq  80005a <libmain>
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
	// Try to load the kernel's TSS selector into the DS register.
	asm volatile("movw $0x28,%ax; movw %ax,%ds");
  800052:	66 b8 28 00          	mov    $0x28,%ax
  800056:	8e d8                	mov    %eax,%ds
}
  800058:	c9                   	leaveq 
  800059:	c3                   	retq   

000000000080005a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80005a:	55                   	push   %rbp
  80005b:	48 89 e5             	mov    %rsp,%rbp
  80005e:	48 83 ec 10          	sub    $0x10,%rsp
  800062:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800065:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	thisenv = &envs[ENVX(sys_getenvid())];
  800069:	48 b8 55 02 80 00 00 	movabs $0x800255,%rax
  800070:	00 00 00 
  800073:	ff d0                	callq  *%rax
  800075:	25 ff 03 00 00       	and    $0x3ff,%eax
  80007a:	48 98                	cltq   
  80007c:	48 c1 e0 03          	shl    $0x3,%rax
  800080:	48 89 c2             	mov    %rax,%rdx
  800083:	48 c1 e2 05          	shl    $0x5,%rdx
  800087:	48 29 c2             	sub    %rax,%rdx
  80008a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800091:	00 00 00 
  800094:	48 01 c2             	add    %rax,%rdx
  800097:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  80009e:	00 00 00 
  8000a1:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000a8:	7e 14                	jle    8000be <libmain+0x64>
		binaryname = argv[0];
  8000aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000ae:	48 8b 10             	mov    (%rax),%rdx
  8000b1:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000b8:	00 00 00 
  8000bb:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000be:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000c5:	48 89 d6             	mov    %rdx,%rsi
  8000c8:	89 c7                	mov    %eax,%edi
  8000ca:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000d1:	00 00 00 
  8000d4:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000d6:	48 b8 e4 00 80 00 00 	movabs $0x8000e4,%rax
  8000dd:	00 00 00 
  8000e0:	ff d0                	callq  *%rax
}
  8000e2:	c9                   	leaveq 
  8000e3:	c3                   	retq   

00000000008000e4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e4:	55                   	push   %rbp
  8000e5:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8000e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8000ed:	48 b8 11 02 80 00 00 	movabs $0x800211,%rax
  8000f4:	00 00 00 
  8000f7:	ff d0                	callq  *%rax
}
  8000f9:	5d                   	pop    %rbp
  8000fa:	c3                   	retq   

00000000008000fb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8000fb:	55                   	push   %rbp
  8000fc:	48 89 e5             	mov    %rsp,%rbp
  8000ff:	53                   	push   %rbx
  800100:	48 83 ec 48          	sub    $0x48,%rsp
  800104:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800107:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80010a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80010e:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800112:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800116:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80011a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80011d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800121:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800125:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800129:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80012d:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800131:	4c 89 c3             	mov    %r8,%rbx
  800134:	cd 30                	int    $0x30
  800136:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80013a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80013e:	74 3e                	je     80017e <syscall+0x83>
  800140:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800145:	7e 37                	jle    80017e <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800147:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80014b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80014e:	49 89 d0             	mov    %rdx,%r8
  800151:	89 c1                	mov    %eax,%ecx
  800153:	48 ba 0a 18 80 00 00 	movabs $0x80180a,%rdx
  80015a:	00 00 00 
  80015d:	be 23 00 00 00       	mov    $0x23,%esi
  800162:	48 bf 27 18 80 00 00 	movabs $0x801827,%rdi
  800169:	00 00 00 
  80016c:	b8 00 00 00 00       	mov    $0x0,%eax
  800171:	49 b9 93 02 80 00 00 	movabs $0x800293,%r9
  800178:	00 00 00 
  80017b:	41 ff d1             	callq  *%r9

	return ret;
  80017e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800182:	48 83 c4 48          	add    $0x48,%rsp
  800186:	5b                   	pop    %rbx
  800187:	5d                   	pop    %rbp
  800188:	c3                   	retq   

0000000000800189 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800189:	55                   	push   %rbp
  80018a:	48 89 e5             	mov    %rsp,%rbp
  80018d:	48 83 ec 20          	sub    $0x20,%rsp
  800191:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800195:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  800199:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80019d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001a1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001a8:	00 
  8001a9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001af:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001b5:	48 89 d1             	mov    %rdx,%rcx
  8001b8:	48 89 c2             	mov    %rax,%rdx
  8001bb:	be 00 00 00 00       	mov    $0x0,%esi
  8001c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8001c5:	48 b8 fb 00 80 00 00 	movabs $0x8000fb,%rax
  8001cc:	00 00 00 
  8001cf:	ff d0                	callq  *%rax
}
  8001d1:	c9                   	leaveq 
  8001d2:	c3                   	retq   

00000000008001d3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8001d3:	55                   	push   %rbp
  8001d4:	48 89 e5             	mov    %rsp,%rbp
  8001d7:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001db:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001e2:	00 
  8001e3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001e9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001ef:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8001f9:	be 00 00 00 00       	mov    $0x0,%esi
  8001fe:	bf 01 00 00 00       	mov    $0x1,%edi
  800203:	48 b8 fb 00 80 00 00 	movabs $0x8000fb,%rax
  80020a:	00 00 00 
  80020d:	ff d0                	callq  *%rax
}
  80020f:	c9                   	leaveq 
  800210:	c3                   	retq   

0000000000800211 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800211:	55                   	push   %rbp
  800212:	48 89 e5             	mov    %rsp,%rbp
  800215:	48 83 ec 10          	sub    $0x10,%rsp
  800219:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80021c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80021f:	48 98                	cltq   
  800221:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800228:	00 
  800229:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80022f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800235:	b9 00 00 00 00       	mov    $0x0,%ecx
  80023a:	48 89 c2             	mov    %rax,%rdx
  80023d:	be 01 00 00 00       	mov    $0x1,%esi
  800242:	bf 03 00 00 00       	mov    $0x3,%edi
  800247:	48 b8 fb 00 80 00 00 	movabs $0x8000fb,%rax
  80024e:	00 00 00 
  800251:	ff d0                	callq  *%rax
}
  800253:	c9                   	leaveq 
  800254:	c3                   	retq   

0000000000800255 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800255:	55                   	push   %rbp
  800256:	48 89 e5             	mov    %rsp,%rbp
  800259:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80025d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800264:	00 
  800265:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80026b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800271:	b9 00 00 00 00       	mov    $0x0,%ecx
  800276:	ba 00 00 00 00       	mov    $0x0,%edx
  80027b:	be 00 00 00 00       	mov    $0x0,%esi
  800280:	bf 02 00 00 00       	mov    $0x2,%edi
  800285:	48 b8 fb 00 80 00 00 	movabs $0x8000fb,%rax
  80028c:	00 00 00 
  80028f:	ff d0                	callq  *%rax
}
  800291:	c9                   	leaveq 
  800292:	c3                   	retq   

0000000000800293 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800293:	55                   	push   %rbp
  800294:	48 89 e5             	mov    %rsp,%rbp
  800297:	53                   	push   %rbx
  800298:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80029f:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8002a6:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8002ac:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8002b3:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8002ba:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8002c1:	84 c0                	test   %al,%al
  8002c3:	74 23                	je     8002e8 <_panic+0x55>
  8002c5:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8002cc:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002d0:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002d4:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002d8:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002dc:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002e0:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002e4:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002e8:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002ef:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002f6:	00 00 00 
  8002f9:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800300:	00 00 00 
  800303:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800307:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80030e:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800315:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80031c:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  800323:	00 00 00 
  800326:	48 8b 18             	mov    (%rax),%rbx
  800329:	48 b8 55 02 80 00 00 	movabs $0x800255,%rax
  800330:	00 00 00 
  800333:	ff d0                	callq  *%rax
  800335:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80033b:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800342:	41 89 c8             	mov    %ecx,%r8d
  800345:	48 89 d1             	mov    %rdx,%rcx
  800348:	48 89 da             	mov    %rbx,%rdx
  80034b:	89 c6                	mov    %eax,%esi
  80034d:	48 bf 38 18 80 00 00 	movabs $0x801838,%rdi
  800354:	00 00 00 
  800357:	b8 00 00 00 00       	mov    $0x0,%eax
  80035c:	49 b9 cc 04 80 00 00 	movabs $0x8004cc,%r9
  800363:	00 00 00 
  800366:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800369:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800370:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800377:	48 89 d6             	mov    %rdx,%rsi
  80037a:	48 89 c7             	mov    %rax,%rdi
  80037d:	48 b8 20 04 80 00 00 	movabs $0x800420,%rax
  800384:	00 00 00 
  800387:	ff d0                	callq  *%rax
	cprintf("\n");
  800389:	48 bf 5b 18 80 00 00 	movabs $0x80185b,%rdi
  800390:	00 00 00 
  800393:	b8 00 00 00 00       	mov    $0x0,%eax
  800398:	48 ba cc 04 80 00 00 	movabs $0x8004cc,%rdx
  80039f:	00 00 00 
  8003a2:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003a4:	cc                   	int3   
  8003a5:	eb fd                	jmp    8003a4 <_panic+0x111>

00000000008003a7 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8003a7:	55                   	push   %rbp
  8003a8:	48 89 e5             	mov    %rsp,%rbp
  8003ab:	48 83 ec 10          	sub    $0x10,%rsp
  8003af:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003b2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8003b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ba:	8b 00                	mov    (%rax),%eax
  8003bc:	8d 48 01             	lea    0x1(%rax),%ecx
  8003bf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003c3:	89 0a                	mov    %ecx,(%rdx)
  8003c5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003c8:	89 d1                	mov    %edx,%ecx
  8003ca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003ce:	48 98                	cltq   
  8003d0:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8003d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d8:	8b 00                	mov    (%rax),%eax
  8003da:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003df:	75 2c                	jne    80040d <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003e5:	8b 00                	mov    (%rax),%eax
  8003e7:	48 98                	cltq   
  8003e9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003ed:	48 83 c2 08          	add    $0x8,%rdx
  8003f1:	48 89 c6             	mov    %rax,%rsi
  8003f4:	48 89 d7             	mov    %rdx,%rdi
  8003f7:	48 b8 89 01 80 00 00 	movabs $0x800189,%rax
  8003fe:	00 00 00 
  800401:	ff d0                	callq  *%rax
        b->idx = 0;
  800403:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800407:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80040d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800411:	8b 40 04             	mov    0x4(%rax),%eax
  800414:	8d 50 01             	lea    0x1(%rax),%edx
  800417:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80041b:	89 50 04             	mov    %edx,0x4(%rax)
}
  80041e:	c9                   	leaveq 
  80041f:	c3                   	retq   

0000000000800420 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800420:	55                   	push   %rbp
  800421:	48 89 e5             	mov    %rsp,%rbp
  800424:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80042b:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800432:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800439:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800440:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800447:	48 8b 0a             	mov    (%rdx),%rcx
  80044a:	48 89 08             	mov    %rcx,(%rax)
  80044d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800451:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800455:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800459:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80045d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800464:	00 00 00 
    b.cnt = 0;
  800467:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80046e:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800471:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800478:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80047f:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800486:	48 89 c6             	mov    %rax,%rsi
  800489:	48 bf a7 03 80 00 00 	movabs $0x8003a7,%rdi
  800490:	00 00 00 
  800493:	48 b8 7f 08 80 00 00 	movabs $0x80087f,%rax
  80049a:	00 00 00 
  80049d:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80049f:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8004a5:	48 98                	cltq   
  8004a7:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8004ae:	48 83 c2 08          	add    $0x8,%rdx
  8004b2:	48 89 c6             	mov    %rax,%rsi
  8004b5:	48 89 d7             	mov    %rdx,%rdi
  8004b8:	48 b8 89 01 80 00 00 	movabs $0x800189,%rax
  8004bf:	00 00 00 
  8004c2:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8004c4:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004ca:	c9                   	leaveq 
  8004cb:	c3                   	retq   

00000000008004cc <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8004cc:	55                   	push   %rbp
  8004cd:	48 89 e5             	mov    %rsp,%rbp
  8004d0:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004d7:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004de:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004e5:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004ec:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004f3:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004fa:	84 c0                	test   %al,%al
  8004fc:	74 20                	je     80051e <cprintf+0x52>
  8004fe:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800502:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800506:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80050a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80050e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800512:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800516:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80051a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80051e:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800525:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80052c:	00 00 00 
  80052f:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800536:	00 00 00 
  800539:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80053d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800544:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80054b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800552:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800559:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800560:	48 8b 0a             	mov    (%rdx),%rcx
  800563:	48 89 08             	mov    %rcx,(%rax)
  800566:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80056a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80056e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800572:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800576:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80057d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800584:	48 89 d6             	mov    %rdx,%rsi
  800587:	48 89 c7             	mov    %rax,%rdi
  80058a:	48 b8 20 04 80 00 00 	movabs $0x800420,%rax
  800591:	00 00 00 
  800594:	ff d0                	callq  *%rax
  800596:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80059c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8005a2:	c9                   	leaveq 
  8005a3:	c3                   	retq   

00000000008005a4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005a4:	55                   	push   %rbp
  8005a5:	48 89 e5             	mov    %rsp,%rbp
  8005a8:	53                   	push   %rbx
  8005a9:	48 83 ec 38          	sub    $0x38,%rsp
  8005ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8005b5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8005b9:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8005bc:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8005c0:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005c4:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8005c7:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8005cb:	77 3b                	ja     800608 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005cd:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8005d0:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005d4:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8005d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005db:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e0:	48 f7 f3             	div    %rbx
  8005e3:	48 89 c2             	mov    %rax,%rdx
  8005e6:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005e9:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005ec:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f4:	41 89 f9             	mov    %edi,%r9d
  8005f7:	48 89 c7             	mov    %rax,%rdi
  8005fa:	48 b8 a4 05 80 00 00 	movabs $0x8005a4,%rax
  800601:	00 00 00 
  800604:	ff d0                	callq  *%rax
  800606:	eb 1e                	jmp    800626 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800608:	eb 12                	jmp    80061c <printnum+0x78>
			putch(padc, putdat);
  80060a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80060e:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800611:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800615:	48 89 ce             	mov    %rcx,%rsi
  800618:	89 d7                	mov    %edx,%edi
  80061a:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80061c:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800620:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800624:	7f e4                	jg     80060a <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800626:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800629:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80062d:	ba 00 00 00 00       	mov    $0x0,%edx
  800632:	48 f7 f1             	div    %rcx
  800635:	48 89 d0             	mov    %rdx,%rax
  800638:	48 ba 90 19 80 00 00 	movabs $0x801990,%rdx
  80063f:	00 00 00 
  800642:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800646:	0f be d0             	movsbl %al,%edx
  800649:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80064d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800651:	48 89 ce             	mov    %rcx,%rsi
  800654:	89 d7                	mov    %edx,%edi
  800656:	ff d0                	callq  *%rax
}
  800658:	48 83 c4 38          	add    $0x38,%rsp
  80065c:	5b                   	pop    %rbx
  80065d:	5d                   	pop    %rbp
  80065e:	c3                   	retq   

000000000080065f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80065f:	55                   	push   %rbp
  800660:	48 89 e5             	mov    %rsp,%rbp
  800663:	48 83 ec 1c          	sub    $0x1c,%rsp
  800667:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80066b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80066e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800672:	7e 52                	jle    8006c6 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800674:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800678:	8b 00                	mov    (%rax),%eax
  80067a:	83 f8 30             	cmp    $0x30,%eax
  80067d:	73 24                	jae    8006a3 <getuint+0x44>
  80067f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800683:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800687:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068b:	8b 00                	mov    (%rax),%eax
  80068d:	89 c0                	mov    %eax,%eax
  80068f:	48 01 d0             	add    %rdx,%rax
  800692:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800696:	8b 12                	mov    (%rdx),%edx
  800698:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80069b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80069f:	89 0a                	mov    %ecx,(%rdx)
  8006a1:	eb 17                	jmp    8006ba <getuint+0x5b>
  8006a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006ab:	48 89 d0             	mov    %rdx,%rax
  8006ae:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006ba:	48 8b 00             	mov    (%rax),%rax
  8006bd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006c1:	e9 a3 00 00 00       	jmpq   800769 <getuint+0x10a>
	else if (lflag)
  8006c6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006ca:	74 4f                	je     80071b <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8006cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d0:	8b 00                	mov    (%rax),%eax
  8006d2:	83 f8 30             	cmp    $0x30,%eax
  8006d5:	73 24                	jae    8006fb <getuint+0x9c>
  8006d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006db:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e3:	8b 00                	mov    (%rax),%eax
  8006e5:	89 c0                	mov    %eax,%eax
  8006e7:	48 01 d0             	add    %rdx,%rax
  8006ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ee:	8b 12                	mov    (%rdx),%edx
  8006f0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f7:	89 0a                	mov    %ecx,(%rdx)
  8006f9:	eb 17                	jmp    800712 <getuint+0xb3>
  8006fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ff:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800703:	48 89 d0             	mov    %rdx,%rax
  800706:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80070a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800712:	48 8b 00             	mov    (%rax),%rax
  800715:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800719:	eb 4e                	jmp    800769 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80071b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80071f:	8b 00                	mov    (%rax),%eax
  800721:	83 f8 30             	cmp    $0x30,%eax
  800724:	73 24                	jae    80074a <getuint+0xeb>
  800726:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80072a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80072e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800732:	8b 00                	mov    (%rax),%eax
  800734:	89 c0                	mov    %eax,%eax
  800736:	48 01 d0             	add    %rdx,%rax
  800739:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80073d:	8b 12                	mov    (%rdx),%edx
  80073f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800742:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800746:	89 0a                	mov    %ecx,(%rdx)
  800748:	eb 17                	jmp    800761 <getuint+0x102>
  80074a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800752:	48 89 d0             	mov    %rdx,%rax
  800755:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800759:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80075d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800761:	8b 00                	mov    (%rax),%eax
  800763:	89 c0                	mov    %eax,%eax
  800765:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800769:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80076d:	c9                   	leaveq 
  80076e:	c3                   	retq   

000000000080076f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80076f:	55                   	push   %rbp
  800770:	48 89 e5             	mov    %rsp,%rbp
  800773:	48 83 ec 1c          	sub    $0x1c,%rsp
  800777:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80077b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80077e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800782:	7e 52                	jle    8007d6 <getint+0x67>
		x=va_arg(*ap, long long);
  800784:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800788:	8b 00                	mov    (%rax),%eax
  80078a:	83 f8 30             	cmp    $0x30,%eax
  80078d:	73 24                	jae    8007b3 <getint+0x44>
  80078f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800793:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800797:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079b:	8b 00                	mov    (%rax),%eax
  80079d:	89 c0                	mov    %eax,%eax
  80079f:	48 01 d0             	add    %rdx,%rax
  8007a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a6:	8b 12                	mov    (%rdx),%edx
  8007a8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007af:	89 0a                	mov    %ecx,(%rdx)
  8007b1:	eb 17                	jmp    8007ca <getint+0x5b>
  8007b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007bb:	48 89 d0             	mov    %rdx,%rax
  8007be:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007c2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007ca:	48 8b 00             	mov    (%rax),%rax
  8007cd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007d1:	e9 a3 00 00 00       	jmpq   800879 <getint+0x10a>
	else if (lflag)
  8007d6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007da:	74 4f                	je     80082b <getint+0xbc>
		x=va_arg(*ap, long);
  8007dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e0:	8b 00                	mov    (%rax),%eax
  8007e2:	83 f8 30             	cmp    $0x30,%eax
  8007e5:	73 24                	jae    80080b <getint+0x9c>
  8007e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007eb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f3:	8b 00                	mov    (%rax),%eax
  8007f5:	89 c0                	mov    %eax,%eax
  8007f7:	48 01 d0             	add    %rdx,%rax
  8007fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007fe:	8b 12                	mov    (%rdx),%edx
  800800:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800803:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800807:	89 0a                	mov    %ecx,(%rdx)
  800809:	eb 17                	jmp    800822 <getint+0xb3>
  80080b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800813:	48 89 d0             	mov    %rdx,%rax
  800816:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80081a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80081e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800822:	48 8b 00             	mov    (%rax),%rax
  800825:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800829:	eb 4e                	jmp    800879 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80082b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082f:	8b 00                	mov    (%rax),%eax
  800831:	83 f8 30             	cmp    $0x30,%eax
  800834:	73 24                	jae    80085a <getint+0xeb>
  800836:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80083e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800842:	8b 00                	mov    (%rax),%eax
  800844:	89 c0                	mov    %eax,%eax
  800846:	48 01 d0             	add    %rdx,%rax
  800849:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80084d:	8b 12                	mov    (%rdx),%edx
  80084f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800852:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800856:	89 0a                	mov    %ecx,(%rdx)
  800858:	eb 17                	jmp    800871 <getint+0x102>
  80085a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80085e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800862:	48 89 d0             	mov    %rdx,%rax
  800865:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800869:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80086d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800871:	8b 00                	mov    (%rax),%eax
  800873:	48 98                	cltq   
  800875:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800879:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80087d:	c9                   	leaveq 
  80087e:	c3                   	retq   

000000000080087f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80087f:	55                   	push   %rbp
  800880:	48 89 e5             	mov    %rsp,%rbp
  800883:	41 54                	push   %r12
  800885:	53                   	push   %rbx
  800886:	48 83 ec 60          	sub    $0x60,%rsp
  80088a:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80088e:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800892:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800896:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80089a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80089e:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8008a2:	48 8b 0a             	mov    (%rdx),%rcx
  8008a5:	48 89 08             	mov    %rcx,(%rax)
  8008a8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008ac:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008b0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008b4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008b8:	eb 17                	jmp    8008d1 <vprintfmt+0x52>
			if (ch == '\0')
  8008ba:	85 db                	test   %ebx,%ebx
  8008bc:	0f 84 df 04 00 00    	je     800da1 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  8008c2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008c6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008ca:	48 89 d6             	mov    %rdx,%rsi
  8008cd:	89 df                	mov    %ebx,%edi
  8008cf:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008d1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008d5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008d9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008dd:	0f b6 00             	movzbl (%rax),%eax
  8008e0:	0f b6 d8             	movzbl %al,%ebx
  8008e3:	83 fb 25             	cmp    $0x25,%ebx
  8008e6:	75 d2                	jne    8008ba <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008e8:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008ec:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008f3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008fa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800901:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800908:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80090c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800910:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800914:	0f b6 00             	movzbl (%rax),%eax
  800917:	0f b6 d8             	movzbl %al,%ebx
  80091a:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80091d:	83 f8 55             	cmp    $0x55,%eax
  800920:	0f 87 47 04 00 00    	ja     800d6d <vprintfmt+0x4ee>
  800926:	89 c0                	mov    %eax,%eax
  800928:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80092f:	00 
  800930:	48 b8 b8 19 80 00 00 	movabs $0x8019b8,%rax
  800937:	00 00 00 
  80093a:	48 01 d0             	add    %rdx,%rax
  80093d:	48 8b 00             	mov    (%rax),%rax
  800940:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800942:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800946:	eb c0                	jmp    800908 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800948:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80094c:	eb ba                	jmp    800908 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80094e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800955:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800958:	89 d0                	mov    %edx,%eax
  80095a:	c1 e0 02             	shl    $0x2,%eax
  80095d:	01 d0                	add    %edx,%eax
  80095f:	01 c0                	add    %eax,%eax
  800961:	01 d8                	add    %ebx,%eax
  800963:	83 e8 30             	sub    $0x30,%eax
  800966:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800969:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80096d:	0f b6 00             	movzbl (%rax),%eax
  800970:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800973:	83 fb 2f             	cmp    $0x2f,%ebx
  800976:	7e 0c                	jle    800984 <vprintfmt+0x105>
  800978:	83 fb 39             	cmp    $0x39,%ebx
  80097b:	7f 07                	jg     800984 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80097d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800982:	eb d1                	jmp    800955 <vprintfmt+0xd6>
			goto process_precision;
  800984:	eb 58                	jmp    8009de <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800986:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800989:	83 f8 30             	cmp    $0x30,%eax
  80098c:	73 17                	jae    8009a5 <vprintfmt+0x126>
  80098e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800992:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800995:	89 c0                	mov    %eax,%eax
  800997:	48 01 d0             	add    %rdx,%rax
  80099a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80099d:	83 c2 08             	add    $0x8,%edx
  8009a0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009a3:	eb 0f                	jmp    8009b4 <vprintfmt+0x135>
  8009a5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009a9:	48 89 d0             	mov    %rdx,%rax
  8009ac:	48 83 c2 08          	add    $0x8,%rdx
  8009b0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009b4:	8b 00                	mov    (%rax),%eax
  8009b6:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8009b9:	eb 23                	jmp    8009de <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8009bb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009bf:	79 0c                	jns    8009cd <vprintfmt+0x14e>
				width = 0;
  8009c1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009c8:	e9 3b ff ff ff       	jmpq   800908 <vprintfmt+0x89>
  8009cd:	e9 36 ff ff ff       	jmpq   800908 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009d2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009d9:	e9 2a ff ff ff       	jmpq   800908 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009de:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009e2:	79 12                	jns    8009f6 <vprintfmt+0x177>
				width = precision, precision = -1;
  8009e4:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009e7:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009ea:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009f1:	e9 12 ff ff ff       	jmpq   800908 <vprintfmt+0x89>
  8009f6:	e9 0d ff ff ff       	jmpq   800908 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009fb:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009ff:	e9 04 ff ff ff       	jmpq   800908 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a04:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a07:	83 f8 30             	cmp    $0x30,%eax
  800a0a:	73 17                	jae    800a23 <vprintfmt+0x1a4>
  800a0c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a10:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a13:	89 c0                	mov    %eax,%eax
  800a15:	48 01 d0             	add    %rdx,%rax
  800a18:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a1b:	83 c2 08             	add    $0x8,%edx
  800a1e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a21:	eb 0f                	jmp    800a32 <vprintfmt+0x1b3>
  800a23:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a27:	48 89 d0             	mov    %rdx,%rax
  800a2a:	48 83 c2 08          	add    $0x8,%rdx
  800a2e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a32:	8b 10                	mov    (%rax),%edx
  800a34:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a38:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a3c:	48 89 ce             	mov    %rcx,%rsi
  800a3f:	89 d7                	mov    %edx,%edi
  800a41:	ff d0                	callq  *%rax
			break;
  800a43:	e9 53 03 00 00       	jmpq   800d9b <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a48:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a4b:	83 f8 30             	cmp    $0x30,%eax
  800a4e:	73 17                	jae    800a67 <vprintfmt+0x1e8>
  800a50:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a54:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a57:	89 c0                	mov    %eax,%eax
  800a59:	48 01 d0             	add    %rdx,%rax
  800a5c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a5f:	83 c2 08             	add    $0x8,%edx
  800a62:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a65:	eb 0f                	jmp    800a76 <vprintfmt+0x1f7>
  800a67:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a6b:	48 89 d0             	mov    %rdx,%rax
  800a6e:	48 83 c2 08          	add    $0x8,%rdx
  800a72:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a76:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a78:	85 db                	test   %ebx,%ebx
  800a7a:	79 02                	jns    800a7e <vprintfmt+0x1ff>
				err = -err;
  800a7c:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a7e:	83 fb 15             	cmp    $0x15,%ebx
  800a81:	7f 16                	jg     800a99 <vprintfmt+0x21a>
  800a83:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  800a8a:	00 00 00 
  800a8d:	48 63 d3             	movslq %ebx,%rdx
  800a90:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a94:	4d 85 e4             	test   %r12,%r12
  800a97:	75 2e                	jne    800ac7 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a99:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a9d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aa1:	89 d9                	mov    %ebx,%ecx
  800aa3:	48 ba a1 19 80 00 00 	movabs $0x8019a1,%rdx
  800aaa:	00 00 00 
  800aad:	48 89 c7             	mov    %rax,%rdi
  800ab0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab5:	49 b8 aa 0d 80 00 00 	movabs $0x800daa,%r8
  800abc:	00 00 00 
  800abf:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ac2:	e9 d4 02 00 00       	jmpq   800d9b <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ac7:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800acb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800acf:	4c 89 e1             	mov    %r12,%rcx
  800ad2:	48 ba aa 19 80 00 00 	movabs $0x8019aa,%rdx
  800ad9:	00 00 00 
  800adc:	48 89 c7             	mov    %rax,%rdi
  800adf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae4:	49 b8 aa 0d 80 00 00 	movabs $0x800daa,%r8
  800aeb:	00 00 00 
  800aee:	41 ff d0             	callq  *%r8
			break;
  800af1:	e9 a5 02 00 00       	jmpq   800d9b <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800af6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800af9:	83 f8 30             	cmp    $0x30,%eax
  800afc:	73 17                	jae    800b15 <vprintfmt+0x296>
  800afe:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b02:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b05:	89 c0                	mov    %eax,%eax
  800b07:	48 01 d0             	add    %rdx,%rax
  800b0a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b0d:	83 c2 08             	add    $0x8,%edx
  800b10:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b13:	eb 0f                	jmp    800b24 <vprintfmt+0x2a5>
  800b15:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b19:	48 89 d0             	mov    %rdx,%rax
  800b1c:	48 83 c2 08          	add    $0x8,%rdx
  800b20:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b24:	4c 8b 20             	mov    (%rax),%r12
  800b27:	4d 85 e4             	test   %r12,%r12
  800b2a:	75 0a                	jne    800b36 <vprintfmt+0x2b7>
				p = "(null)";
  800b2c:	49 bc ad 19 80 00 00 	movabs $0x8019ad,%r12
  800b33:	00 00 00 
			if (width > 0 && padc != '-')
  800b36:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b3a:	7e 3f                	jle    800b7b <vprintfmt+0x2fc>
  800b3c:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b40:	74 39                	je     800b7b <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b42:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b45:	48 98                	cltq   
  800b47:	48 89 c6             	mov    %rax,%rsi
  800b4a:	4c 89 e7             	mov    %r12,%rdi
  800b4d:	48 b8 56 10 80 00 00 	movabs $0x801056,%rax
  800b54:	00 00 00 
  800b57:	ff d0                	callq  *%rax
  800b59:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b5c:	eb 17                	jmp    800b75 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b5e:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b62:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b66:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b6a:	48 89 ce             	mov    %rcx,%rsi
  800b6d:	89 d7                	mov    %edx,%edi
  800b6f:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b71:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b75:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b79:	7f e3                	jg     800b5e <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b7b:	eb 37                	jmp    800bb4 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b7d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b81:	74 1e                	je     800ba1 <vprintfmt+0x322>
  800b83:	83 fb 1f             	cmp    $0x1f,%ebx
  800b86:	7e 05                	jle    800b8d <vprintfmt+0x30e>
  800b88:	83 fb 7e             	cmp    $0x7e,%ebx
  800b8b:	7e 14                	jle    800ba1 <vprintfmt+0x322>
					putch('?', putdat);
  800b8d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b91:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b95:	48 89 d6             	mov    %rdx,%rsi
  800b98:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b9d:	ff d0                	callq  *%rax
  800b9f:	eb 0f                	jmp    800bb0 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800ba1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ba5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba9:	48 89 d6             	mov    %rdx,%rsi
  800bac:	89 df                	mov    %ebx,%edi
  800bae:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bb0:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bb4:	4c 89 e0             	mov    %r12,%rax
  800bb7:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800bbb:	0f b6 00             	movzbl (%rax),%eax
  800bbe:	0f be d8             	movsbl %al,%ebx
  800bc1:	85 db                	test   %ebx,%ebx
  800bc3:	74 10                	je     800bd5 <vprintfmt+0x356>
  800bc5:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bc9:	78 b2                	js     800b7d <vprintfmt+0x2fe>
  800bcb:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800bcf:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bd3:	79 a8                	jns    800b7d <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bd5:	eb 16                	jmp    800bed <vprintfmt+0x36e>
				putch(' ', putdat);
  800bd7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bdb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bdf:	48 89 d6             	mov    %rdx,%rsi
  800be2:	bf 20 00 00 00       	mov    $0x20,%edi
  800be7:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800be9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bed:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bf1:	7f e4                	jg     800bd7 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800bf3:	e9 a3 01 00 00       	jmpq   800d9b <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800bf8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bfc:	be 03 00 00 00       	mov    $0x3,%esi
  800c01:	48 89 c7             	mov    %rax,%rdi
  800c04:	48 b8 6f 07 80 00 00 	movabs $0x80076f,%rax
  800c0b:	00 00 00 
  800c0e:	ff d0                	callq  *%rax
  800c10:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c18:	48 85 c0             	test   %rax,%rax
  800c1b:	79 1d                	jns    800c3a <vprintfmt+0x3bb>
				putch('-', putdat);
  800c1d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c21:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c25:	48 89 d6             	mov    %rdx,%rsi
  800c28:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c2d:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c33:	48 f7 d8             	neg    %rax
  800c36:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c3a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c41:	e9 e8 00 00 00       	jmpq   800d2e <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c46:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c4a:	be 03 00 00 00       	mov    $0x3,%esi
  800c4f:	48 89 c7             	mov    %rax,%rdi
  800c52:	48 b8 5f 06 80 00 00 	movabs $0x80065f,%rax
  800c59:	00 00 00 
  800c5c:	ff d0                	callq  *%rax
  800c5e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c62:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c69:	e9 c0 00 00 00       	jmpq   800d2e <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c6e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c72:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c76:	48 89 d6             	mov    %rdx,%rsi
  800c79:	bf 58 00 00 00       	mov    $0x58,%edi
  800c7e:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c80:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c84:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c88:	48 89 d6             	mov    %rdx,%rsi
  800c8b:	bf 58 00 00 00       	mov    $0x58,%edi
  800c90:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c92:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c96:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c9a:	48 89 d6             	mov    %rdx,%rsi
  800c9d:	bf 58 00 00 00       	mov    $0x58,%edi
  800ca2:	ff d0                	callq  *%rax
			break;
  800ca4:	e9 f2 00 00 00       	jmpq   800d9b <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800ca9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cad:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cb1:	48 89 d6             	mov    %rdx,%rsi
  800cb4:	bf 30 00 00 00       	mov    $0x30,%edi
  800cb9:	ff d0                	callq  *%rax
			putch('x', putdat);
  800cbb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cbf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cc3:	48 89 d6             	mov    %rdx,%rsi
  800cc6:	bf 78 00 00 00       	mov    $0x78,%edi
  800ccb:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800ccd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cd0:	83 f8 30             	cmp    $0x30,%eax
  800cd3:	73 17                	jae    800cec <vprintfmt+0x46d>
  800cd5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cd9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cdc:	89 c0                	mov    %eax,%eax
  800cde:	48 01 d0             	add    %rdx,%rax
  800ce1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ce4:	83 c2 08             	add    $0x8,%edx
  800ce7:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cea:	eb 0f                	jmp    800cfb <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800cec:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cf0:	48 89 d0             	mov    %rdx,%rax
  800cf3:	48 83 c2 08          	add    $0x8,%rdx
  800cf7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cfb:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cfe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d02:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d09:	eb 23                	jmp    800d2e <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d0b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d0f:	be 03 00 00 00       	mov    $0x3,%esi
  800d14:	48 89 c7             	mov    %rax,%rdi
  800d17:	48 b8 5f 06 80 00 00 	movabs $0x80065f,%rax
  800d1e:	00 00 00 
  800d21:	ff d0                	callq  *%rax
  800d23:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d27:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d2e:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d33:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d36:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d39:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d3d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d41:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d45:	45 89 c1             	mov    %r8d,%r9d
  800d48:	41 89 f8             	mov    %edi,%r8d
  800d4b:	48 89 c7             	mov    %rax,%rdi
  800d4e:	48 b8 a4 05 80 00 00 	movabs $0x8005a4,%rax
  800d55:	00 00 00 
  800d58:	ff d0                	callq  *%rax
			break;
  800d5a:	eb 3f                	jmp    800d9b <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d5c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d60:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d64:	48 89 d6             	mov    %rdx,%rsi
  800d67:	89 df                	mov    %ebx,%edi
  800d69:	ff d0                	callq  *%rax
			break;
  800d6b:	eb 2e                	jmp    800d9b <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d6d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d71:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d75:	48 89 d6             	mov    %rdx,%rsi
  800d78:	bf 25 00 00 00       	mov    $0x25,%edi
  800d7d:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d7f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d84:	eb 05                	jmp    800d8b <vprintfmt+0x50c>
  800d86:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d8b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d8f:	48 83 e8 01          	sub    $0x1,%rax
  800d93:	0f b6 00             	movzbl (%rax),%eax
  800d96:	3c 25                	cmp    $0x25,%al
  800d98:	75 ec                	jne    800d86 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800d9a:	90                   	nop
		}
	}
  800d9b:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d9c:	e9 30 fb ff ff       	jmpq   8008d1 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800da1:	48 83 c4 60          	add    $0x60,%rsp
  800da5:	5b                   	pop    %rbx
  800da6:	41 5c                	pop    %r12
  800da8:	5d                   	pop    %rbp
  800da9:	c3                   	retq   

0000000000800daa <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800daa:	55                   	push   %rbp
  800dab:	48 89 e5             	mov    %rsp,%rbp
  800dae:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800db5:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800dbc:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800dc3:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800dca:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800dd1:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800dd8:	84 c0                	test   %al,%al
  800dda:	74 20                	je     800dfc <printfmt+0x52>
  800ddc:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800de0:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800de4:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800de8:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dec:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800df0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800df4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800df8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800dfc:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e03:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e0a:	00 00 00 
  800e0d:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e14:	00 00 00 
  800e17:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e1b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e22:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e29:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e30:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e37:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e3e:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e45:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e4c:	48 89 c7             	mov    %rax,%rdi
  800e4f:	48 b8 7f 08 80 00 00 	movabs $0x80087f,%rax
  800e56:	00 00 00 
  800e59:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e5b:	c9                   	leaveq 
  800e5c:	c3                   	retq   

0000000000800e5d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e5d:	55                   	push   %rbp
  800e5e:	48 89 e5             	mov    %rsp,%rbp
  800e61:	48 83 ec 10          	sub    $0x10,%rsp
  800e65:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e68:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e70:	8b 40 10             	mov    0x10(%rax),%eax
  800e73:	8d 50 01             	lea    0x1(%rax),%edx
  800e76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e7a:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e81:	48 8b 10             	mov    (%rax),%rdx
  800e84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e88:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e8c:	48 39 c2             	cmp    %rax,%rdx
  800e8f:	73 17                	jae    800ea8 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e95:	48 8b 00             	mov    (%rax),%rax
  800e98:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e9c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ea0:	48 89 0a             	mov    %rcx,(%rdx)
  800ea3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800ea6:	88 10                	mov    %dl,(%rax)
}
  800ea8:	c9                   	leaveq 
  800ea9:	c3                   	retq   

0000000000800eaa <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800eaa:	55                   	push   %rbp
  800eab:	48 89 e5             	mov    %rsp,%rbp
  800eae:	48 83 ec 50          	sub    $0x50,%rsp
  800eb2:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800eb6:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800eb9:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ebd:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ec1:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ec5:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800ec9:	48 8b 0a             	mov    (%rdx),%rcx
  800ecc:	48 89 08             	mov    %rcx,(%rax)
  800ecf:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ed3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ed7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800edb:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800edf:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ee3:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ee7:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800eea:	48 98                	cltq   
  800eec:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800ef0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ef4:	48 01 d0             	add    %rdx,%rax
  800ef7:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800efb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f02:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f07:	74 06                	je     800f0f <vsnprintf+0x65>
  800f09:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f0d:	7f 07                	jg     800f16 <vsnprintf+0x6c>
		return -E_INVAL;
  800f0f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f14:	eb 2f                	jmp    800f45 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f16:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f1a:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f1e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f22:	48 89 c6             	mov    %rax,%rsi
  800f25:	48 bf 5d 0e 80 00 00 	movabs $0x800e5d,%rdi
  800f2c:	00 00 00 
  800f2f:	48 b8 7f 08 80 00 00 	movabs $0x80087f,%rax
  800f36:	00 00 00 
  800f39:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f3b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f3f:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f42:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f45:	c9                   	leaveq 
  800f46:	c3                   	retq   

0000000000800f47 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f47:	55                   	push   %rbp
  800f48:	48 89 e5             	mov    %rsp,%rbp
  800f4b:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f52:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f59:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f5f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f66:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f6d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f74:	84 c0                	test   %al,%al
  800f76:	74 20                	je     800f98 <snprintf+0x51>
  800f78:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f7c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f80:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f84:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f88:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f8c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f90:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f94:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f98:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f9f:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800fa6:	00 00 00 
  800fa9:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fb0:	00 00 00 
  800fb3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fb7:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fbe:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fc5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fcc:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fd3:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fda:	48 8b 0a             	mov    (%rdx),%rcx
  800fdd:	48 89 08             	mov    %rcx,(%rax)
  800fe0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fe4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fe8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fec:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800ff0:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800ff7:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800ffe:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801004:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80100b:	48 89 c7             	mov    %rax,%rdi
  80100e:	48 b8 aa 0e 80 00 00 	movabs $0x800eaa,%rax
  801015:	00 00 00 
  801018:	ff d0                	callq  *%rax
  80101a:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801020:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801026:	c9                   	leaveq 
  801027:	c3                   	retq   

0000000000801028 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801028:	55                   	push   %rbp
  801029:	48 89 e5             	mov    %rsp,%rbp
  80102c:	48 83 ec 18          	sub    $0x18,%rsp
  801030:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801034:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80103b:	eb 09                	jmp    801046 <strlen+0x1e>
		n++;
  80103d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801041:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801046:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80104a:	0f b6 00             	movzbl (%rax),%eax
  80104d:	84 c0                	test   %al,%al
  80104f:	75 ec                	jne    80103d <strlen+0x15>
		n++;
	return n;
  801051:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801054:	c9                   	leaveq 
  801055:	c3                   	retq   

0000000000801056 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801056:	55                   	push   %rbp
  801057:	48 89 e5             	mov    %rsp,%rbp
  80105a:	48 83 ec 20          	sub    $0x20,%rsp
  80105e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801062:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801066:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80106d:	eb 0e                	jmp    80107d <strnlen+0x27>
		n++;
  80106f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801073:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801078:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80107d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801082:	74 0b                	je     80108f <strnlen+0x39>
  801084:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801088:	0f b6 00             	movzbl (%rax),%eax
  80108b:	84 c0                	test   %al,%al
  80108d:	75 e0                	jne    80106f <strnlen+0x19>
		n++;
	return n;
  80108f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801092:	c9                   	leaveq 
  801093:	c3                   	retq   

0000000000801094 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801094:	55                   	push   %rbp
  801095:	48 89 e5             	mov    %rsp,%rbp
  801098:	48 83 ec 20          	sub    $0x20,%rsp
  80109c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010a0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8010a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8010ac:	90                   	nop
  8010ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010b5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010b9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010bd:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010c1:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010c5:	0f b6 12             	movzbl (%rdx),%edx
  8010c8:	88 10                	mov    %dl,(%rax)
  8010ca:	0f b6 00             	movzbl (%rax),%eax
  8010cd:	84 c0                	test   %al,%al
  8010cf:	75 dc                	jne    8010ad <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010d5:	c9                   	leaveq 
  8010d6:	c3                   	retq   

00000000008010d7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010d7:	55                   	push   %rbp
  8010d8:	48 89 e5             	mov    %rsp,%rbp
  8010db:	48 83 ec 20          	sub    $0x20,%rsp
  8010df:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010e3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010eb:	48 89 c7             	mov    %rax,%rdi
  8010ee:	48 b8 28 10 80 00 00 	movabs $0x801028,%rax
  8010f5:	00 00 00 
  8010f8:	ff d0                	callq  *%rax
  8010fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801100:	48 63 d0             	movslq %eax,%rdx
  801103:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801107:	48 01 c2             	add    %rax,%rdx
  80110a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80110e:	48 89 c6             	mov    %rax,%rsi
  801111:	48 89 d7             	mov    %rdx,%rdi
  801114:	48 b8 94 10 80 00 00 	movabs $0x801094,%rax
  80111b:	00 00 00 
  80111e:	ff d0                	callq  *%rax
	return dst;
  801120:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801124:	c9                   	leaveq 
  801125:	c3                   	retq   

0000000000801126 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801126:	55                   	push   %rbp
  801127:	48 89 e5             	mov    %rsp,%rbp
  80112a:	48 83 ec 28          	sub    $0x28,%rsp
  80112e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801132:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801136:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80113a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801142:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801149:	00 
  80114a:	eb 2a                	jmp    801176 <strncpy+0x50>
		*dst++ = *src;
  80114c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801150:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801154:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801158:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80115c:	0f b6 12             	movzbl (%rdx),%edx
  80115f:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801161:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801165:	0f b6 00             	movzbl (%rax),%eax
  801168:	84 c0                	test   %al,%al
  80116a:	74 05                	je     801171 <strncpy+0x4b>
			src++;
  80116c:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801171:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801176:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80117a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80117e:	72 cc                	jb     80114c <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801180:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801184:	c9                   	leaveq 
  801185:	c3                   	retq   

0000000000801186 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801186:	55                   	push   %rbp
  801187:	48 89 e5             	mov    %rsp,%rbp
  80118a:	48 83 ec 28          	sub    $0x28,%rsp
  80118e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801192:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801196:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80119a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80119e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8011a2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011a7:	74 3d                	je     8011e6 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8011a9:	eb 1d                	jmp    8011c8 <strlcpy+0x42>
			*dst++ = *src++;
  8011ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011af:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011b3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011b7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011bb:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011bf:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011c3:	0f b6 12             	movzbl (%rdx),%edx
  8011c6:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011c8:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011cd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011d2:	74 0b                	je     8011df <strlcpy+0x59>
  8011d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011d8:	0f b6 00             	movzbl (%rax),%eax
  8011db:	84 c0                	test   %al,%al
  8011dd:	75 cc                	jne    8011ab <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e3:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ee:	48 29 c2             	sub    %rax,%rdx
  8011f1:	48 89 d0             	mov    %rdx,%rax
}
  8011f4:	c9                   	leaveq 
  8011f5:	c3                   	retq   

00000000008011f6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011f6:	55                   	push   %rbp
  8011f7:	48 89 e5             	mov    %rsp,%rbp
  8011fa:	48 83 ec 10          	sub    $0x10,%rsp
  8011fe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801202:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801206:	eb 0a                	jmp    801212 <strcmp+0x1c>
		p++, q++;
  801208:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80120d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801212:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801216:	0f b6 00             	movzbl (%rax),%eax
  801219:	84 c0                	test   %al,%al
  80121b:	74 12                	je     80122f <strcmp+0x39>
  80121d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801221:	0f b6 10             	movzbl (%rax),%edx
  801224:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801228:	0f b6 00             	movzbl (%rax),%eax
  80122b:	38 c2                	cmp    %al,%dl
  80122d:	74 d9                	je     801208 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80122f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801233:	0f b6 00             	movzbl (%rax),%eax
  801236:	0f b6 d0             	movzbl %al,%edx
  801239:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80123d:	0f b6 00             	movzbl (%rax),%eax
  801240:	0f b6 c0             	movzbl %al,%eax
  801243:	29 c2                	sub    %eax,%edx
  801245:	89 d0                	mov    %edx,%eax
}
  801247:	c9                   	leaveq 
  801248:	c3                   	retq   

0000000000801249 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801249:	55                   	push   %rbp
  80124a:	48 89 e5             	mov    %rsp,%rbp
  80124d:	48 83 ec 18          	sub    $0x18,%rsp
  801251:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801255:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801259:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80125d:	eb 0f                	jmp    80126e <strncmp+0x25>
		n--, p++, q++;
  80125f:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801264:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801269:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80126e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801273:	74 1d                	je     801292 <strncmp+0x49>
  801275:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801279:	0f b6 00             	movzbl (%rax),%eax
  80127c:	84 c0                	test   %al,%al
  80127e:	74 12                	je     801292 <strncmp+0x49>
  801280:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801284:	0f b6 10             	movzbl (%rax),%edx
  801287:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80128b:	0f b6 00             	movzbl (%rax),%eax
  80128e:	38 c2                	cmp    %al,%dl
  801290:	74 cd                	je     80125f <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801292:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801297:	75 07                	jne    8012a0 <strncmp+0x57>
		return 0;
  801299:	b8 00 00 00 00       	mov    $0x0,%eax
  80129e:	eb 18                	jmp    8012b8 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a4:	0f b6 00             	movzbl (%rax),%eax
  8012a7:	0f b6 d0             	movzbl %al,%edx
  8012aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ae:	0f b6 00             	movzbl (%rax),%eax
  8012b1:	0f b6 c0             	movzbl %al,%eax
  8012b4:	29 c2                	sub    %eax,%edx
  8012b6:	89 d0                	mov    %edx,%eax
}
  8012b8:	c9                   	leaveq 
  8012b9:	c3                   	retq   

00000000008012ba <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012ba:	55                   	push   %rbp
  8012bb:	48 89 e5             	mov    %rsp,%rbp
  8012be:	48 83 ec 0c          	sub    $0xc,%rsp
  8012c2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012c6:	89 f0                	mov    %esi,%eax
  8012c8:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012cb:	eb 17                	jmp    8012e4 <strchr+0x2a>
		if (*s == c)
  8012cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d1:	0f b6 00             	movzbl (%rax),%eax
  8012d4:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012d7:	75 06                	jne    8012df <strchr+0x25>
			return (char *) s;
  8012d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012dd:	eb 15                	jmp    8012f4 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012df:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e8:	0f b6 00             	movzbl (%rax),%eax
  8012eb:	84 c0                	test   %al,%al
  8012ed:	75 de                	jne    8012cd <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012f4:	c9                   	leaveq 
  8012f5:	c3                   	retq   

00000000008012f6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012f6:	55                   	push   %rbp
  8012f7:	48 89 e5             	mov    %rsp,%rbp
  8012fa:	48 83 ec 0c          	sub    $0xc,%rsp
  8012fe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801302:	89 f0                	mov    %esi,%eax
  801304:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801307:	eb 13                	jmp    80131c <strfind+0x26>
		if (*s == c)
  801309:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130d:	0f b6 00             	movzbl (%rax),%eax
  801310:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801313:	75 02                	jne    801317 <strfind+0x21>
			break;
  801315:	eb 10                	jmp    801327 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801317:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80131c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801320:	0f b6 00             	movzbl (%rax),%eax
  801323:	84 c0                	test   %al,%al
  801325:	75 e2                	jne    801309 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801327:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80132b:	c9                   	leaveq 
  80132c:	c3                   	retq   

000000000080132d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80132d:	55                   	push   %rbp
  80132e:	48 89 e5             	mov    %rsp,%rbp
  801331:	48 83 ec 18          	sub    $0x18,%rsp
  801335:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801339:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80133c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801340:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801345:	75 06                	jne    80134d <memset+0x20>
		return v;
  801347:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134b:	eb 69                	jmp    8013b6 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80134d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801351:	83 e0 03             	and    $0x3,%eax
  801354:	48 85 c0             	test   %rax,%rax
  801357:	75 48                	jne    8013a1 <memset+0x74>
  801359:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80135d:	83 e0 03             	and    $0x3,%eax
  801360:	48 85 c0             	test   %rax,%rax
  801363:	75 3c                	jne    8013a1 <memset+0x74>
		c &= 0xFF;
  801365:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80136c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80136f:	c1 e0 18             	shl    $0x18,%eax
  801372:	89 c2                	mov    %eax,%edx
  801374:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801377:	c1 e0 10             	shl    $0x10,%eax
  80137a:	09 c2                	or     %eax,%edx
  80137c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80137f:	c1 e0 08             	shl    $0x8,%eax
  801382:	09 d0                	or     %edx,%eax
  801384:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801387:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80138b:	48 c1 e8 02          	shr    $0x2,%rax
  80138f:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801392:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801396:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801399:	48 89 d7             	mov    %rdx,%rdi
  80139c:	fc                   	cld    
  80139d:	f3 ab                	rep stos %eax,%es:(%rdi)
  80139f:	eb 11                	jmp    8013b2 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013a1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013a5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013a8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013ac:	48 89 d7             	mov    %rdx,%rdi
  8013af:	fc                   	cld    
  8013b0:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8013b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013b6:	c9                   	leaveq 
  8013b7:	c3                   	retq   

00000000008013b8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013b8:	55                   	push   %rbp
  8013b9:	48 89 e5             	mov    %rsp,%rbp
  8013bc:	48 83 ec 28          	sub    $0x28,%rsp
  8013c0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013c4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013c8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e0:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013e4:	0f 83 88 00 00 00    	jae    801472 <memmove+0xba>
  8013ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013f2:	48 01 d0             	add    %rdx,%rax
  8013f5:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013f9:	76 77                	jbe    801472 <memmove+0xba>
		s += n;
  8013fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ff:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801403:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801407:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80140b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80140f:	83 e0 03             	and    $0x3,%eax
  801412:	48 85 c0             	test   %rax,%rax
  801415:	75 3b                	jne    801452 <memmove+0x9a>
  801417:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80141b:	83 e0 03             	and    $0x3,%eax
  80141e:	48 85 c0             	test   %rax,%rax
  801421:	75 2f                	jne    801452 <memmove+0x9a>
  801423:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801427:	83 e0 03             	and    $0x3,%eax
  80142a:	48 85 c0             	test   %rax,%rax
  80142d:	75 23                	jne    801452 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80142f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801433:	48 83 e8 04          	sub    $0x4,%rax
  801437:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80143b:	48 83 ea 04          	sub    $0x4,%rdx
  80143f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801443:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801447:	48 89 c7             	mov    %rax,%rdi
  80144a:	48 89 d6             	mov    %rdx,%rsi
  80144d:	fd                   	std    
  80144e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801450:	eb 1d                	jmp    80146f <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801452:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801456:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80145a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80145e:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801462:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801466:	48 89 d7             	mov    %rdx,%rdi
  801469:	48 89 c1             	mov    %rax,%rcx
  80146c:	fd                   	std    
  80146d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80146f:	fc                   	cld    
  801470:	eb 57                	jmp    8014c9 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801472:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801476:	83 e0 03             	and    $0x3,%eax
  801479:	48 85 c0             	test   %rax,%rax
  80147c:	75 36                	jne    8014b4 <memmove+0xfc>
  80147e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801482:	83 e0 03             	and    $0x3,%eax
  801485:	48 85 c0             	test   %rax,%rax
  801488:	75 2a                	jne    8014b4 <memmove+0xfc>
  80148a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80148e:	83 e0 03             	and    $0x3,%eax
  801491:	48 85 c0             	test   %rax,%rax
  801494:	75 1e                	jne    8014b4 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801496:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149a:	48 c1 e8 02          	shr    $0x2,%rax
  80149e:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8014a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014a9:	48 89 c7             	mov    %rax,%rdi
  8014ac:	48 89 d6             	mov    %rdx,%rsi
  8014af:	fc                   	cld    
  8014b0:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014b2:	eb 15                	jmp    8014c9 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8014b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014bc:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014c0:	48 89 c7             	mov    %rax,%rdi
  8014c3:	48 89 d6             	mov    %rdx,%rsi
  8014c6:	fc                   	cld    
  8014c7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014cd:	c9                   	leaveq 
  8014ce:	c3                   	retq   

00000000008014cf <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014cf:	55                   	push   %rbp
  8014d0:	48 89 e5             	mov    %rsp,%rbp
  8014d3:	48 83 ec 18          	sub    $0x18,%rsp
  8014d7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014db:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014df:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014e7:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ef:	48 89 ce             	mov    %rcx,%rsi
  8014f2:	48 89 c7             	mov    %rax,%rdi
  8014f5:	48 b8 b8 13 80 00 00 	movabs $0x8013b8,%rax
  8014fc:	00 00 00 
  8014ff:	ff d0                	callq  *%rax
}
  801501:	c9                   	leaveq 
  801502:	c3                   	retq   

0000000000801503 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801503:	55                   	push   %rbp
  801504:	48 89 e5             	mov    %rsp,%rbp
  801507:	48 83 ec 28          	sub    $0x28,%rsp
  80150b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80150f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801513:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801517:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80151b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80151f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801523:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801527:	eb 36                	jmp    80155f <memcmp+0x5c>
		if (*s1 != *s2)
  801529:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80152d:	0f b6 10             	movzbl (%rax),%edx
  801530:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801534:	0f b6 00             	movzbl (%rax),%eax
  801537:	38 c2                	cmp    %al,%dl
  801539:	74 1a                	je     801555 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80153b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80153f:	0f b6 00             	movzbl (%rax),%eax
  801542:	0f b6 d0             	movzbl %al,%edx
  801545:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801549:	0f b6 00             	movzbl (%rax),%eax
  80154c:	0f b6 c0             	movzbl %al,%eax
  80154f:	29 c2                	sub    %eax,%edx
  801551:	89 d0                	mov    %edx,%eax
  801553:	eb 20                	jmp    801575 <memcmp+0x72>
		s1++, s2++;
  801555:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80155a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80155f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801563:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801567:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80156b:	48 85 c0             	test   %rax,%rax
  80156e:	75 b9                	jne    801529 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801570:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801575:	c9                   	leaveq 
  801576:	c3                   	retq   

0000000000801577 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801577:	55                   	push   %rbp
  801578:	48 89 e5             	mov    %rsp,%rbp
  80157b:	48 83 ec 28          	sub    $0x28,%rsp
  80157f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801583:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801586:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80158a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801592:	48 01 d0             	add    %rdx,%rax
  801595:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801599:	eb 15                	jmp    8015b0 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80159b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80159f:	0f b6 10             	movzbl (%rax),%edx
  8015a2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8015a5:	38 c2                	cmp    %al,%dl
  8015a7:	75 02                	jne    8015ab <memfind+0x34>
			break;
  8015a9:	eb 0f                	jmp    8015ba <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015ab:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015b4:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8015b8:	72 e1                	jb     80159b <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8015ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015be:	c9                   	leaveq 
  8015bf:	c3                   	retq   

00000000008015c0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015c0:	55                   	push   %rbp
  8015c1:	48 89 e5             	mov    %rsp,%rbp
  8015c4:	48 83 ec 34          	sub    $0x34,%rsp
  8015c8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015cc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015d0:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015da:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015e1:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015e2:	eb 05                	jmp    8015e9 <strtol+0x29>
		s++;
  8015e4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ed:	0f b6 00             	movzbl (%rax),%eax
  8015f0:	3c 20                	cmp    $0x20,%al
  8015f2:	74 f0                	je     8015e4 <strtol+0x24>
  8015f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f8:	0f b6 00             	movzbl (%rax),%eax
  8015fb:	3c 09                	cmp    $0x9,%al
  8015fd:	74 e5                	je     8015e4 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801603:	0f b6 00             	movzbl (%rax),%eax
  801606:	3c 2b                	cmp    $0x2b,%al
  801608:	75 07                	jne    801611 <strtol+0x51>
		s++;
  80160a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80160f:	eb 17                	jmp    801628 <strtol+0x68>
	else if (*s == '-')
  801611:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801615:	0f b6 00             	movzbl (%rax),%eax
  801618:	3c 2d                	cmp    $0x2d,%al
  80161a:	75 0c                	jne    801628 <strtol+0x68>
		s++, neg = 1;
  80161c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801621:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801628:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80162c:	74 06                	je     801634 <strtol+0x74>
  80162e:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801632:	75 28                	jne    80165c <strtol+0x9c>
  801634:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801638:	0f b6 00             	movzbl (%rax),%eax
  80163b:	3c 30                	cmp    $0x30,%al
  80163d:	75 1d                	jne    80165c <strtol+0x9c>
  80163f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801643:	48 83 c0 01          	add    $0x1,%rax
  801647:	0f b6 00             	movzbl (%rax),%eax
  80164a:	3c 78                	cmp    $0x78,%al
  80164c:	75 0e                	jne    80165c <strtol+0x9c>
		s += 2, base = 16;
  80164e:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801653:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80165a:	eb 2c                	jmp    801688 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80165c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801660:	75 19                	jne    80167b <strtol+0xbb>
  801662:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801666:	0f b6 00             	movzbl (%rax),%eax
  801669:	3c 30                	cmp    $0x30,%al
  80166b:	75 0e                	jne    80167b <strtol+0xbb>
		s++, base = 8;
  80166d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801672:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801679:	eb 0d                	jmp    801688 <strtol+0xc8>
	else if (base == 0)
  80167b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80167f:	75 07                	jne    801688 <strtol+0xc8>
		base = 10;
  801681:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801688:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168c:	0f b6 00             	movzbl (%rax),%eax
  80168f:	3c 2f                	cmp    $0x2f,%al
  801691:	7e 1d                	jle    8016b0 <strtol+0xf0>
  801693:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801697:	0f b6 00             	movzbl (%rax),%eax
  80169a:	3c 39                	cmp    $0x39,%al
  80169c:	7f 12                	jg     8016b0 <strtol+0xf0>
			dig = *s - '0';
  80169e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a2:	0f b6 00             	movzbl (%rax),%eax
  8016a5:	0f be c0             	movsbl %al,%eax
  8016a8:	83 e8 30             	sub    $0x30,%eax
  8016ab:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016ae:	eb 4e                	jmp    8016fe <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8016b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b4:	0f b6 00             	movzbl (%rax),%eax
  8016b7:	3c 60                	cmp    $0x60,%al
  8016b9:	7e 1d                	jle    8016d8 <strtol+0x118>
  8016bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016bf:	0f b6 00             	movzbl (%rax),%eax
  8016c2:	3c 7a                	cmp    $0x7a,%al
  8016c4:	7f 12                	jg     8016d8 <strtol+0x118>
			dig = *s - 'a' + 10;
  8016c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ca:	0f b6 00             	movzbl (%rax),%eax
  8016cd:	0f be c0             	movsbl %al,%eax
  8016d0:	83 e8 57             	sub    $0x57,%eax
  8016d3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016d6:	eb 26                	jmp    8016fe <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016dc:	0f b6 00             	movzbl (%rax),%eax
  8016df:	3c 40                	cmp    $0x40,%al
  8016e1:	7e 48                	jle    80172b <strtol+0x16b>
  8016e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e7:	0f b6 00             	movzbl (%rax),%eax
  8016ea:	3c 5a                	cmp    $0x5a,%al
  8016ec:	7f 3d                	jg     80172b <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f2:	0f b6 00             	movzbl (%rax),%eax
  8016f5:	0f be c0             	movsbl %al,%eax
  8016f8:	83 e8 37             	sub    $0x37,%eax
  8016fb:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016fe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801701:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801704:	7c 02                	jl     801708 <strtol+0x148>
			break;
  801706:	eb 23                	jmp    80172b <strtol+0x16b>
		s++, val = (val * base) + dig;
  801708:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80170d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801710:	48 98                	cltq   
  801712:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801717:	48 89 c2             	mov    %rax,%rdx
  80171a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80171d:	48 98                	cltq   
  80171f:	48 01 d0             	add    %rdx,%rax
  801722:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801726:	e9 5d ff ff ff       	jmpq   801688 <strtol+0xc8>

	if (endptr)
  80172b:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801730:	74 0b                	je     80173d <strtol+0x17d>
		*endptr = (char *) s;
  801732:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801736:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80173a:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80173d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801741:	74 09                	je     80174c <strtol+0x18c>
  801743:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801747:	48 f7 d8             	neg    %rax
  80174a:	eb 04                	jmp    801750 <strtol+0x190>
  80174c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801750:	c9                   	leaveq 
  801751:	c3                   	retq   

0000000000801752 <strstr>:

char * strstr(const char *in, const char *str)
{
  801752:	55                   	push   %rbp
  801753:	48 89 e5             	mov    %rsp,%rbp
  801756:	48 83 ec 30          	sub    $0x30,%rsp
  80175a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80175e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801762:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801766:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80176a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80176e:	0f b6 00             	movzbl (%rax),%eax
  801771:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801774:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801778:	75 06                	jne    801780 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80177a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177e:	eb 6b                	jmp    8017eb <strstr+0x99>

	len = strlen(str);
  801780:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801784:	48 89 c7             	mov    %rax,%rdi
  801787:	48 b8 28 10 80 00 00 	movabs $0x801028,%rax
  80178e:	00 00 00 
  801791:	ff d0                	callq  *%rax
  801793:	48 98                	cltq   
  801795:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801799:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017a1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017a5:	0f b6 00             	movzbl (%rax),%eax
  8017a8:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8017ab:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8017af:	75 07                	jne    8017b8 <strstr+0x66>
				return (char *) 0;
  8017b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b6:	eb 33                	jmp    8017eb <strstr+0x99>
		} while (sc != c);
  8017b8:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8017bc:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8017bf:	75 d8                	jne    801799 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8017c1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017c5:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cd:	48 89 ce             	mov    %rcx,%rsi
  8017d0:	48 89 c7             	mov    %rax,%rdi
  8017d3:	48 b8 49 12 80 00 00 	movabs $0x801249,%rax
  8017da:	00 00 00 
  8017dd:	ff d0                	callq  *%rax
  8017df:	85 c0                	test   %eax,%eax
  8017e1:	75 b6                	jne    801799 <strstr+0x47>

	return (char *) (in - 1);
  8017e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e7:	48 83 e8 01          	sub    $0x1,%rax
}
  8017eb:	c9                   	leaveq 
  8017ec:	c3                   	retq   
