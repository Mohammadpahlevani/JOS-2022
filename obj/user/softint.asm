
obj/user/softint:     file format elf64-x86-64


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
  80003c:	e8 15 00 00 00       	callq  800056 <libmain>
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
	asm volatile("int $14");	// page fault
  800052:	cd 0e                	int    $0xe
}
  800054:	c9                   	leaveq 
  800055:	c3                   	retq   

0000000000800056 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800056:	55                   	push   %rbp
  800057:	48 89 e5             	mov    %rsp,%rbp
  80005a:	48 83 ec 10          	sub    $0x10,%rsp
  80005e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800061:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	thisenv = &envs[ENVX(sys_getenvid())];
  800065:	48 b8 51 02 80 00 00 	movabs $0x800251,%rax
  80006c:	00 00 00 
  80006f:	ff d0                	callq  *%rax
  800071:	25 ff 03 00 00       	and    $0x3ff,%eax
  800076:	48 98                	cltq   
  800078:	48 c1 e0 03          	shl    $0x3,%rax
  80007c:	48 89 c2             	mov    %rax,%rdx
  80007f:	48 c1 e2 05          	shl    $0x5,%rdx
  800083:	48 29 c2             	sub    %rax,%rdx
  800086:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80008d:	00 00 00 
  800090:	48 01 c2             	add    %rax,%rdx
  800093:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  80009a:	00 00 00 
  80009d:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000a4:	7e 14                	jle    8000ba <libmain+0x64>
		binaryname = argv[0];
  8000a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000aa:	48 8b 10             	mov    (%rax),%rdx
  8000ad:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000b4:	00 00 00 
  8000b7:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000ba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000c1:	48 89 d6             	mov    %rdx,%rsi
  8000c4:	89 c7                	mov    %eax,%edi
  8000c6:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000cd:	00 00 00 
  8000d0:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000d2:	48 b8 e0 00 80 00 00 	movabs $0x8000e0,%rax
  8000d9:	00 00 00 
  8000dc:	ff d0                	callq  *%rax
}
  8000de:	c9                   	leaveq 
  8000df:	c3                   	retq   

00000000008000e0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e0:	55                   	push   %rbp
  8000e1:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8000e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8000e9:	48 b8 0d 02 80 00 00 	movabs $0x80020d,%rax
  8000f0:	00 00 00 
  8000f3:	ff d0                	callq  *%rax
}
  8000f5:	5d                   	pop    %rbp
  8000f6:	c3                   	retq   

00000000008000f7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8000f7:	55                   	push   %rbp
  8000f8:	48 89 e5             	mov    %rsp,%rbp
  8000fb:	53                   	push   %rbx
  8000fc:	48 83 ec 48          	sub    $0x48,%rsp
  800100:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800103:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800106:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80010a:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80010e:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800112:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800116:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800119:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80011d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800121:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800125:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800129:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80012d:	4c 89 c3             	mov    %r8,%rbx
  800130:	cd 30                	int    $0x30
  800132:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800136:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80013a:	74 3e                	je     80017a <syscall+0x83>
  80013c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800141:	7e 37                	jle    80017a <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800143:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800147:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80014a:	49 89 d0             	mov    %rdx,%r8
  80014d:	89 c1                	mov    %eax,%ecx
  80014f:	48 ba 0a 18 80 00 00 	movabs $0x80180a,%rdx
  800156:	00 00 00 
  800159:	be 23 00 00 00       	mov    $0x23,%esi
  80015e:	48 bf 27 18 80 00 00 	movabs $0x801827,%rdi
  800165:	00 00 00 
  800168:	b8 00 00 00 00       	mov    $0x0,%eax
  80016d:	49 b9 8f 02 80 00 00 	movabs $0x80028f,%r9
  800174:	00 00 00 
  800177:	41 ff d1             	callq  *%r9

	return ret;
  80017a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80017e:	48 83 c4 48          	add    $0x48,%rsp
  800182:	5b                   	pop    %rbx
  800183:	5d                   	pop    %rbp
  800184:	c3                   	retq   

0000000000800185 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800185:	55                   	push   %rbp
  800186:	48 89 e5             	mov    %rsp,%rbp
  800189:	48 83 ec 20          	sub    $0x20,%rsp
  80018d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800191:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  800195:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800199:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80019d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001a4:	00 
  8001a5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001ab:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001b1:	48 89 d1             	mov    %rdx,%rcx
  8001b4:	48 89 c2             	mov    %rax,%rdx
  8001b7:	be 00 00 00 00       	mov    $0x0,%esi
  8001bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8001c1:	48 b8 f7 00 80 00 00 	movabs $0x8000f7,%rax
  8001c8:	00 00 00 
  8001cb:	ff d0                	callq  *%rax
}
  8001cd:	c9                   	leaveq 
  8001ce:	c3                   	retq   

00000000008001cf <sys_cgetc>:

int
sys_cgetc(void)
{
  8001cf:	55                   	push   %rbp
  8001d0:	48 89 e5             	mov    %rsp,%rbp
  8001d3:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001d7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001de:	00 
  8001df:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001e5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001eb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8001f5:	be 00 00 00 00       	mov    $0x0,%esi
  8001fa:	bf 01 00 00 00       	mov    $0x1,%edi
  8001ff:	48 b8 f7 00 80 00 00 	movabs $0x8000f7,%rax
  800206:	00 00 00 
  800209:	ff d0                	callq  *%rax
}
  80020b:	c9                   	leaveq 
  80020c:	c3                   	retq   

000000000080020d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80020d:	55                   	push   %rbp
  80020e:	48 89 e5             	mov    %rsp,%rbp
  800211:	48 83 ec 10          	sub    $0x10,%rsp
  800215:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800218:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80021b:	48 98                	cltq   
  80021d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800224:	00 
  800225:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80022b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800231:	b9 00 00 00 00       	mov    $0x0,%ecx
  800236:	48 89 c2             	mov    %rax,%rdx
  800239:	be 01 00 00 00       	mov    $0x1,%esi
  80023e:	bf 03 00 00 00       	mov    $0x3,%edi
  800243:	48 b8 f7 00 80 00 00 	movabs $0x8000f7,%rax
  80024a:	00 00 00 
  80024d:	ff d0                	callq  *%rax
}
  80024f:	c9                   	leaveq 
  800250:	c3                   	retq   

0000000000800251 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800251:	55                   	push   %rbp
  800252:	48 89 e5             	mov    %rsp,%rbp
  800255:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800259:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800260:	00 
  800261:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800267:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80026d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800272:	ba 00 00 00 00       	mov    $0x0,%edx
  800277:	be 00 00 00 00       	mov    $0x0,%esi
  80027c:	bf 02 00 00 00       	mov    $0x2,%edi
  800281:	48 b8 f7 00 80 00 00 	movabs $0x8000f7,%rax
  800288:	00 00 00 
  80028b:	ff d0                	callq  *%rax
}
  80028d:	c9                   	leaveq 
  80028e:	c3                   	retq   

000000000080028f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80028f:	55                   	push   %rbp
  800290:	48 89 e5             	mov    %rsp,%rbp
  800293:	53                   	push   %rbx
  800294:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80029b:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8002a2:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8002a8:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8002af:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8002b6:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8002bd:	84 c0                	test   %al,%al
  8002bf:	74 23                	je     8002e4 <_panic+0x55>
  8002c1:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8002c8:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002cc:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002d0:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002d4:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002d8:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002dc:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002e0:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002e4:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002eb:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002f2:	00 00 00 
  8002f5:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002fc:	00 00 00 
  8002ff:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800303:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80030a:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800311:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800318:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  80031f:	00 00 00 
  800322:	48 8b 18             	mov    (%rax),%rbx
  800325:	48 b8 51 02 80 00 00 	movabs $0x800251,%rax
  80032c:	00 00 00 
  80032f:	ff d0                	callq  *%rax
  800331:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800337:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80033e:	41 89 c8             	mov    %ecx,%r8d
  800341:	48 89 d1             	mov    %rdx,%rcx
  800344:	48 89 da             	mov    %rbx,%rdx
  800347:	89 c6                	mov    %eax,%esi
  800349:	48 bf 38 18 80 00 00 	movabs $0x801838,%rdi
  800350:	00 00 00 
  800353:	b8 00 00 00 00       	mov    $0x0,%eax
  800358:	49 b9 c8 04 80 00 00 	movabs $0x8004c8,%r9
  80035f:	00 00 00 
  800362:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800365:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80036c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800373:	48 89 d6             	mov    %rdx,%rsi
  800376:	48 89 c7             	mov    %rax,%rdi
  800379:	48 b8 1c 04 80 00 00 	movabs $0x80041c,%rax
  800380:	00 00 00 
  800383:	ff d0                	callq  *%rax
	cprintf("\n");
  800385:	48 bf 5b 18 80 00 00 	movabs $0x80185b,%rdi
  80038c:	00 00 00 
  80038f:	b8 00 00 00 00       	mov    $0x0,%eax
  800394:	48 ba c8 04 80 00 00 	movabs $0x8004c8,%rdx
  80039b:	00 00 00 
  80039e:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003a0:	cc                   	int3   
  8003a1:	eb fd                	jmp    8003a0 <_panic+0x111>

00000000008003a3 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8003a3:	55                   	push   %rbp
  8003a4:	48 89 e5             	mov    %rsp,%rbp
  8003a7:	48 83 ec 10          	sub    $0x10,%rsp
  8003ab:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003ae:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8003b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003b6:	8b 00                	mov    (%rax),%eax
  8003b8:	8d 48 01             	lea    0x1(%rax),%ecx
  8003bb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003bf:	89 0a                	mov    %ecx,(%rdx)
  8003c1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003c4:	89 d1                	mov    %edx,%ecx
  8003c6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003ca:	48 98                	cltq   
  8003cc:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8003d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d4:	8b 00                	mov    (%rax),%eax
  8003d6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003db:	75 2c                	jne    800409 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003e1:	8b 00                	mov    (%rax),%eax
  8003e3:	48 98                	cltq   
  8003e5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003e9:	48 83 c2 08          	add    $0x8,%rdx
  8003ed:	48 89 c6             	mov    %rax,%rsi
  8003f0:	48 89 d7             	mov    %rdx,%rdi
  8003f3:	48 b8 85 01 80 00 00 	movabs $0x800185,%rax
  8003fa:	00 00 00 
  8003fd:	ff d0                	callq  *%rax
        b->idx = 0;
  8003ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800403:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800409:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80040d:	8b 40 04             	mov    0x4(%rax),%eax
  800410:	8d 50 01             	lea    0x1(%rax),%edx
  800413:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800417:	89 50 04             	mov    %edx,0x4(%rax)
}
  80041a:	c9                   	leaveq 
  80041b:	c3                   	retq   

000000000080041c <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80041c:	55                   	push   %rbp
  80041d:	48 89 e5             	mov    %rsp,%rbp
  800420:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800427:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80042e:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800435:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80043c:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800443:	48 8b 0a             	mov    (%rdx),%rcx
  800446:	48 89 08             	mov    %rcx,(%rax)
  800449:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80044d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800451:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800455:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800459:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800460:	00 00 00 
    b.cnt = 0;
  800463:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80046a:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80046d:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800474:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80047b:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800482:	48 89 c6             	mov    %rax,%rsi
  800485:	48 bf a3 03 80 00 00 	movabs $0x8003a3,%rdi
  80048c:	00 00 00 
  80048f:	48 b8 7b 08 80 00 00 	movabs $0x80087b,%rax
  800496:	00 00 00 
  800499:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80049b:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8004a1:	48 98                	cltq   
  8004a3:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8004aa:	48 83 c2 08          	add    $0x8,%rdx
  8004ae:	48 89 c6             	mov    %rax,%rsi
  8004b1:	48 89 d7             	mov    %rdx,%rdi
  8004b4:	48 b8 85 01 80 00 00 	movabs $0x800185,%rax
  8004bb:	00 00 00 
  8004be:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8004c0:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004c6:	c9                   	leaveq 
  8004c7:	c3                   	retq   

00000000008004c8 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8004c8:	55                   	push   %rbp
  8004c9:	48 89 e5             	mov    %rsp,%rbp
  8004cc:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004d3:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004da:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004e1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004e8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004ef:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004f6:	84 c0                	test   %al,%al
  8004f8:	74 20                	je     80051a <cprintf+0x52>
  8004fa:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004fe:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800502:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800506:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80050a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80050e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800512:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800516:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80051a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800521:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800528:	00 00 00 
  80052b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800532:	00 00 00 
  800535:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800539:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800540:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800547:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80054e:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800555:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80055c:	48 8b 0a             	mov    (%rdx),%rcx
  80055f:	48 89 08             	mov    %rcx,(%rax)
  800562:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800566:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80056a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80056e:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800572:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800579:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800580:	48 89 d6             	mov    %rdx,%rsi
  800583:	48 89 c7             	mov    %rax,%rdi
  800586:	48 b8 1c 04 80 00 00 	movabs $0x80041c,%rax
  80058d:	00 00 00 
  800590:	ff d0                	callq  *%rax
  800592:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800598:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80059e:	c9                   	leaveq 
  80059f:	c3                   	retq   

00000000008005a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005a0:	55                   	push   %rbp
  8005a1:	48 89 e5             	mov    %rsp,%rbp
  8005a4:	53                   	push   %rbx
  8005a5:	48 83 ec 38          	sub    $0x38,%rsp
  8005a9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005ad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8005b1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8005b5:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8005b8:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8005bc:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005c0:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8005c3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8005c7:	77 3b                	ja     800604 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005c9:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8005cc:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005d0:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8005d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005dc:	48 f7 f3             	div    %rbx
  8005df:	48 89 c2             	mov    %rax,%rdx
  8005e2:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005e5:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005e8:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f0:	41 89 f9             	mov    %edi,%r9d
  8005f3:	48 89 c7             	mov    %rax,%rdi
  8005f6:	48 b8 a0 05 80 00 00 	movabs $0x8005a0,%rax
  8005fd:	00 00 00 
  800600:	ff d0                	callq  *%rax
  800602:	eb 1e                	jmp    800622 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800604:	eb 12                	jmp    800618 <printnum+0x78>
			putch(padc, putdat);
  800606:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80060a:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80060d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800611:	48 89 ce             	mov    %rcx,%rsi
  800614:	89 d7                	mov    %edx,%edi
  800616:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800618:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80061c:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800620:	7f e4                	jg     800606 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800622:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800625:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800629:	ba 00 00 00 00       	mov    $0x0,%edx
  80062e:	48 f7 f1             	div    %rcx
  800631:	48 89 d0             	mov    %rdx,%rax
  800634:	48 ba 90 19 80 00 00 	movabs $0x801990,%rdx
  80063b:	00 00 00 
  80063e:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800642:	0f be d0             	movsbl %al,%edx
  800645:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800649:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064d:	48 89 ce             	mov    %rcx,%rsi
  800650:	89 d7                	mov    %edx,%edi
  800652:	ff d0                	callq  *%rax
}
  800654:	48 83 c4 38          	add    $0x38,%rsp
  800658:	5b                   	pop    %rbx
  800659:	5d                   	pop    %rbp
  80065a:	c3                   	retq   

000000000080065b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80065b:	55                   	push   %rbp
  80065c:	48 89 e5             	mov    %rsp,%rbp
  80065f:	48 83 ec 1c          	sub    $0x1c,%rsp
  800663:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800667:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80066a:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80066e:	7e 52                	jle    8006c2 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800670:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800674:	8b 00                	mov    (%rax),%eax
  800676:	83 f8 30             	cmp    $0x30,%eax
  800679:	73 24                	jae    80069f <getuint+0x44>
  80067b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800683:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800687:	8b 00                	mov    (%rax),%eax
  800689:	89 c0                	mov    %eax,%eax
  80068b:	48 01 d0             	add    %rdx,%rax
  80068e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800692:	8b 12                	mov    (%rdx),%edx
  800694:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800697:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80069b:	89 0a                	mov    %ecx,(%rdx)
  80069d:	eb 17                	jmp    8006b6 <getuint+0x5b>
  80069f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006a7:	48 89 d0             	mov    %rdx,%rax
  8006aa:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006b6:	48 8b 00             	mov    (%rax),%rax
  8006b9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006bd:	e9 a3 00 00 00       	jmpq   800765 <getuint+0x10a>
	else if (lflag)
  8006c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006c6:	74 4f                	je     800717 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8006c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006cc:	8b 00                	mov    (%rax),%eax
  8006ce:	83 f8 30             	cmp    $0x30,%eax
  8006d1:	73 24                	jae    8006f7 <getuint+0x9c>
  8006d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006df:	8b 00                	mov    (%rax),%eax
  8006e1:	89 c0                	mov    %eax,%eax
  8006e3:	48 01 d0             	add    %rdx,%rax
  8006e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ea:	8b 12                	mov    (%rdx),%edx
  8006ec:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f3:	89 0a                	mov    %ecx,(%rdx)
  8006f5:	eb 17                	jmp    80070e <getuint+0xb3>
  8006f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006ff:	48 89 d0             	mov    %rdx,%rax
  800702:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800706:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80070e:	48 8b 00             	mov    (%rax),%rax
  800711:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800715:	eb 4e                	jmp    800765 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800717:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80071b:	8b 00                	mov    (%rax),%eax
  80071d:	83 f8 30             	cmp    $0x30,%eax
  800720:	73 24                	jae    800746 <getuint+0xeb>
  800722:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800726:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80072a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80072e:	8b 00                	mov    (%rax),%eax
  800730:	89 c0                	mov    %eax,%eax
  800732:	48 01 d0             	add    %rdx,%rax
  800735:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800739:	8b 12                	mov    (%rdx),%edx
  80073b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80073e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800742:	89 0a                	mov    %ecx,(%rdx)
  800744:	eb 17                	jmp    80075d <getuint+0x102>
  800746:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80074e:	48 89 d0             	mov    %rdx,%rax
  800751:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800755:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800759:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80075d:	8b 00                	mov    (%rax),%eax
  80075f:	89 c0                	mov    %eax,%eax
  800761:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800765:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800769:	c9                   	leaveq 
  80076a:	c3                   	retq   

000000000080076b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80076b:	55                   	push   %rbp
  80076c:	48 89 e5             	mov    %rsp,%rbp
  80076f:	48 83 ec 1c          	sub    $0x1c,%rsp
  800773:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800777:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80077a:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80077e:	7e 52                	jle    8007d2 <getint+0x67>
		x=va_arg(*ap, long long);
  800780:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800784:	8b 00                	mov    (%rax),%eax
  800786:	83 f8 30             	cmp    $0x30,%eax
  800789:	73 24                	jae    8007af <getint+0x44>
  80078b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800793:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800797:	8b 00                	mov    (%rax),%eax
  800799:	89 c0                	mov    %eax,%eax
  80079b:	48 01 d0             	add    %rdx,%rax
  80079e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a2:	8b 12                	mov    (%rdx),%edx
  8007a4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ab:	89 0a                	mov    %ecx,(%rdx)
  8007ad:	eb 17                	jmp    8007c6 <getint+0x5b>
  8007af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007b7:	48 89 d0             	mov    %rdx,%rax
  8007ba:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007c6:	48 8b 00             	mov    (%rax),%rax
  8007c9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007cd:	e9 a3 00 00 00       	jmpq   800875 <getint+0x10a>
	else if (lflag)
  8007d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007d6:	74 4f                	je     800827 <getint+0xbc>
		x=va_arg(*ap, long);
  8007d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007dc:	8b 00                	mov    (%rax),%eax
  8007de:	83 f8 30             	cmp    $0x30,%eax
  8007e1:	73 24                	jae    800807 <getint+0x9c>
  8007e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ef:	8b 00                	mov    (%rax),%eax
  8007f1:	89 c0                	mov    %eax,%eax
  8007f3:	48 01 d0             	add    %rdx,%rax
  8007f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007fa:	8b 12                	mov    (%rdx),%edx
  8007fc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800803:	89 0a                	mov    %ecx,(%rdx)
  800805:	eb 17                	jmp    80081e <getint+0xb3>
  800807:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80080f:	48 89 d0             	mov    %rdx,%rax
  800812:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800816:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80081a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80081e:	48 8b 00             	mov    (%rax),%rax
  800821:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800825:	eb 4e                	jmp    800875 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800827:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082b:	8b 00                	mov    (%rax),%eax
  80082d:	83 f8 30             	cmp    $0x30,%eax
  800830:	73 24                	jae    800856 <getint+0xeb>
  800832:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800836:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80083a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083e:	8b 00                	mov    (%rax),%eax
  800840:	89 c0                	mov    %eax,%eax
  800842:	48 01 d0             	add    %rdx,%rax
  800845:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800849:	8b 12                	mov    (%rdx),%edx
  80084b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80084e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800852:	89 0a                	mov    %ecx,(%rdx)
  800854:	eb 17                	jmp    80086d <getint+0x102>
  800856:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80085a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80085e:	48 89 d0             	mov    %rdx,%rax
  800861:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800865:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800869:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80086d:	8b 00                	mov    (%rax),%eax
  80086f:	48 98                	cltq   
  800871:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800875:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800879:	c9                   	leaveq 
  80087a:	c3                   	retq   

000000000080087b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80087b:	55                   	push   %rbp
  80087c:	48 89 e5             	mov    %rsp,%rbp
  80087f:	41 54                	push   %r12
  800881:	53                   	push   %rbx
  800882:	48 83 ec 60          	sub    $0x60,%rsp
  800886:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80088a:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80088e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800892:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800896:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80089a:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80089e:	48 8b 0a             	mov    (%rdx),%rcx
  8008a1:	48 89 08             	mov    %rcx,(%rax)
  8008a4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008a8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008ac:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008b0:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008b4:	eb 17                	jmp    8008cd <vprintfmt+0x52>
			if (ch == '\0')
  8008b6:	85 db                	test   %ebx,%ebx
  8008b8:	0f 84 df 04 00 00    	je     800d9d <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  8008be:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008c2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008c6:	48 89 d6             	mov    %rdx,%rsi
  8008c9:	89 df                	mov    %ebx,%edi
  8008cb:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008cd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008d1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008d5:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008d9:	0f b6 00             	movzbl (%rax),%eax
  8008dc:	0f b6 d8             	movzbl %al,%ebx
  8008df:	83 fb 25             	cmp    $0x25,%ebx
  8008e2:	75 d2                	jne    8008b6 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008e4:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008e8:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008ef:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008f6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008fd:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800904:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800908:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80090c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800910:	0f b6 00             	movzbl (%rax),%eax
  800913:	0f b6 d8             	movzbl %al,%ebx
  800916:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800919:	83 f8 55             	cmp    $0x55,%eax
  80091c:	0f 87 47 04 00 00    	ja     800d69 <vprintfmt+0x4ee>
  800922:	89 c0                	mov    %eax,%eax
  800924:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80092b:	00 
  80092c:	48 b8 b8 19 80 00 00 	movabs $0x8019b8,%rax
  800933:	00 00 00 
  800936:	48 01 d0             	add    %rdx,%rax
  800939:	48 8b 00             	mov    (%rax),%rax
  80093c:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80093e:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800942:	eb c0                	jmp    800904 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800944:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800948:	eb ba                	jmp    800904 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80094a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800951:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800954:	89 d0                	mov    %edx,%eax
  800956:	c1 e0 02             	shl    $0x2,%eax
  800959:	01 d0                	add    %edx,%eax
  80095b:	01 c0                	add    %eax,%eax
  80095d:	01 d8                	add    %ebx,%eax
  80095f:	83 e8 30             	sub    $0x30,%eax
  800962:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800965:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800969:	0f b6 00             	movzbl (%rax),%eax
  80096c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80096f:	83 fb 2f             	cmp    $0x2f,%ebx
  800972:	7e 0c                	jle    800980 <vprintfmt+0x105>
  800974:	83 fb 39             	cmp    $0x39,%ebx
  800977:	7f 07                	jg     800980 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800979:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80097e:	eb d1                	jmp    800951 <vprintfmt+0xd6>
			goto process_precision;
  800980:	eb 58                	jmp    8009da <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800982:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800985:	83 f8 30             	cmp    $0x30,%eax
  800988:	73 17                	jae    8009a1 <vprintfmt+0x126>
  80098a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80098e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800991:	89 c0                	mov    %eax,%eax
  800993:	48 01 d0             	add    %rdx,%rax
  800996:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800999:	83 c2 08             	add    $0x8,%edx
  80099c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80099f:	eb 0f                	jmp    8009b0 <vprintfmt+0x135>
  8009a1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009a5:	48 89 d0             	mov    %rdx,%rax
  8009a8:	48 83 c2 08          	add    $0x8,%rdx
  8009ac:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009b0:	8b 00                	mov    (%rax),%eax
  8009b2:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8009b5:	eb 23                	jmp    8009da <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8009b7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009bb:	79 0c                	jns    8009c9 <vprintfmt+0x14e>
				width = 0;
  8009bd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009c4:	e9 3b ff ff ff       	jmpq   800904 <vprintfmt+0x89>
  8009c9:	e9 36 ff ff ff       	jmpq   800904 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009ce:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009d5:	e9 2a ff ff ff       	jmpq   800904 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009da:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009de:	79 12                	jns    8009f2 <vprintfmt+0x177>
				width = precision, precision = -1;
  8009e0:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009e3:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009e6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009ed:	e9 12 ff ff ff       	jmpq   800904 <vprintfmt+0x89>
  8009f2:	e9 0d ff ff ff       	jmpq   800904 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009f7:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009fb:	e9 04 ff ff ff       	jmpq   800904 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a00:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a03:	83 f8 30             	cmp    $0x30,%eax
  800a06:	73 17                	jae    800a1f <vprintfmt+0x1a4>
  800a08:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a0c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a0f:	89 c0                	mov    %eax,%eax
  800a11:	48 01 d0             	add    %rdx,%rax
  800a14:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a17:	83 c2 08             	add    $0x8,%edx
  800a1a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a1d:	eb 0f                	jmp    800a2e <vprintfmt+0x1b3>
  800a1f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a23:	48 89 d0             	mov    %rdx,%rax
  800a26:	48 83 c2 08          	add    $0x8,%rdx
  800a2a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a2e:	8b 10                	mov    (%rax),%edx
  800a30:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a34:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a38:	48 89 ce             	mov    %rcx,%rsi
  800a3b:	89 d7                	mov    %edx,%edi
  800a3d:	ff d0                	callq  *%rax
			break;
  800a3f:	e9 53 03 00 00       	jmpq   800d97 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a44:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a47:	83 f8 30             	cmp    $0x30,%eax
  800a4a:	73 17                	jae    800a63 <vprintfmt+0x1e8>
  800a4c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a50:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a53:	89 c0                	mov    %eax,%eax
  800a55:	48 01 d0             	add    %rdx,%rax
  800a58:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a5b:	83 c2 08             	add    $0x8,%edx
  800a5e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a61:	eb 0f                	jmp    800a72 <vprintfmt+0x1f7>
  800a63:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a67:	48 89 d0             	mov    %rdx,%rax
  800a6a:	48 83 c2 08          	add    $0x8,%rdx
  800a6e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a72:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a74:	85 db                	test   %ebx,%ebx
  800a76:	79 02                	jns    800a7a <vprintfmt+0x1ff>
				err = -err;
  800a78:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a7a:	83 fb 15             	cmp    $0x15,%ebx
  800a7d:	7f 16                	jg     800a95 <vprintfmt+0x21a>
  800a7f:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  800a86:	00 00 00 
  800a89:	48 63 d3             	movslq %ebx,%rdx
  800a8c:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a90:	4d 85 e4             	test   %r12,%r12
  800a93:	75 2e                	jne    800ac3 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a95:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a99:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a9d:	89 d9                	mov    %ebx,%ecx
  800a9f:	48 ba a1 19 80 00 00 	movabs $0x8019a1,%rdx
  800aa6:	00 00 00 
  800aa9:	48 89 c7             	mov    %rax,%rdi
  800aac:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab1:	49 b8 a6 0d 80 00 00 	movabs $0x800da6,%r8
  800ab8:	00 00 00 
  800abb:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800abe:	e9 d4 02 00 00       	jmpq   800d97 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ac3:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ac7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800acb:	4c 89 e1             	mov    %r12,%rcx
  800ace:	48 ba aa 19 80 00 00 	movabs $0x8019aa,%rdx
  800ad5:	00 00 00 
  800ad8:	48 89 c7             	mov    %rax,%rdi
  800adb:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae0:	49 b8 a6 0d 80 00 00 	movabs $0x800da6,%r8
  800ae7:	00 00 00 
  800aea:	41 ff d0             	callq  *%r8
			break;
  800aed:	e9 a5 02 00 00       	jmpq   800d97 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800af2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800af5:	83 f8 30             	cmp    $0x30,%eax
  800af8:	73 17                	jae    800b11 <vprintfmt+0x296>
  800afa:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800afe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b01:	89 c0                	mov    %eax,%eax
  800b03:	48 01 d0             	add    %rdx,%rax
  800b06:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b09:	83 c2 08             	add    $0x8,%edx
  800b0c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b0f:	eb 0f                	jmp    800b20 <vprintfmt+0x2a5>
  800b11:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b15:	48 89 d0             	mov    %rdx,%rax
  800b18:	48 83 c2 08          	add    $0x8,%rdx
  800b1c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b20:	4c 8b 20             	mov    (%rax),%r12
  800b23:	4d 85 e4             	test   %r12,%r12
  800b26:	75 0a                	jne    800b32 <vprintfmt+0x2b7>
				p = "(null)";
  800b28:	49 bc ad 19 80 00 00 	movabs $0x8019ad,%r12
  800b2f:	00 00 00 
			if (width > 0 && padc != '-')
  800b32:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b36:	7e 3f                	jle    800b77 <vprintfmt+0x2fc>
  800b38:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b3c:	74 39                	je     800b77 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b3e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b41:	48 98                	cltq   
  800b43:	48 89 c6             	mov    %rax,%rsi
  800b46:	4c 89 e7             	mov    %r12,%rdi
  800b49:	48 b8 52 10 80 00 00 	movabs $0x801052,%rax
  800b50:	00 00 00 
  800b53:	ff d0                	callq  *%rax
  800b55:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b58:	eb 17                	jmp    800b71 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b5a:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b5e:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b62:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b66:	48 89 ce             	mov    %rcx,%rsi
  800b69:	89 d7                	mov    %edx,%edi
  800b6b:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b6d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b71:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b75:	7f e3                	jg     800b5a <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b77:	eb 37                	jmp    800bb0 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b79:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b7d:	74 1e                	je     800b9d <vprintfmt+0x322>
  800b7f:	83 fb 1f             	cmp    $0x1f,%ebx
  800b82:	7e 05                	jle    800b89 <vprintfmt+0x30e>
  800b84:	83 fb 7e             	cmp    $0x7e,%ebx
  800b87:	7e 14                	jle    800b9d <vprintfmt+0x322>
					putch('?', putdat);
  800b89:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b8d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b91:	48 89 d6             	mov    %rdx,%rsi
  800b94:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b99:	ff d0                	callq  *%rax
  800b9b:	eb 0f                	jmp    800bac <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b9d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ba1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba5:	48 89 d6             	mov    %rdx,%rsi
  800ba8:	89 df                	mov    %ebx,%edi
  800baa:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bac:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bb0:	4c 89 e0             	mov    %r12,%rax
  800bb3:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800bb7:	0f b6 00             	movzbl (%rax),%eax
  800bba:	0f be d8             	movsbl %al,%ebx
  800bbd:	85 db                	test   %ebx,%ebx
  800bbf:	74 10                	je     800bd1 <vprintfmt+0x356>
  800bc1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bc5:	78 b2                	js     800b79 <vprintfmt+0x2fe>
  800bc7:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800bcb:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bcf:	79 a8                	jns    800b79 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bd1:	eb 16                	jmp    800be9 <vprintfmt+0x36e>
				putch(' ', putdat);
  800bd3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bd7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bdb:	48 89 d6             	mov    %rdx,%rsi
  800bde:	bf 20 00 00 00       	mov    $0x20,%edi
  800be3:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800be5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800be9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bed:	7f e4                	jg     800bd3 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800bef:	e9 a3 01 00 00       	jmpq   800d97 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800bf4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bf8:	be 03 00 00 00       	mov    $0x3,%esi
  800bfd:	48 89 c7             	mov    %rax,%rdi
  800c00:	48 b8 6b 07 80 00 00 	movabs $0x80076b,%rax
  800c07:	00 00 00 
  800c0a:	ff d0                	callq  *%rax
  800c0c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c14:	48 85 c0             	test   %rax,%rax
  800c17:	79 1d                	jns    800c36 <vprintfmt+0x3bb>
				putch('-', putdat);
  800c19:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c1d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c21:	48 89 d6             	mov    %rdx,%rsi
  800c24:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c29:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c2f:	48 f7 d8             	neg    %rax
  800c32:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c36:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c3d:	e9 e8 00 00 00       	jmpq   800d2a <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c42:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c46:	be 03 00 00 00       	mov    $0x3,%esi
  800c4b:	48 89 c7             	mov    %rax,%rdi
  800c4e:	48 b8 5b 06 80 00 00 	movabs $0x80065b,%rax
  800c55:	00 00 00 
  800c58:	ff d0                	callq  *%rax
  800c5a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c5e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c65:	e9 c0 00 00 00       	jmpq   800d2a <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c6a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c6e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c72:	48 89 d6             	mov    %rdx,%rsi
  800c75:	bf 58 00 00 00       	mov    $0x58,%edi
  800c7a:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c7c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c80:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c84:	48 89 d6             	mov    %rdx,%rsi
  800c87:	bf 58 00 00 00       	mov    $0x58,%edi
  800c8c:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c8e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c92:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c96:	48 89 d6             	mov    %rdx,%rsi
  800c99:	bf 58 00 00 00       	mov    $0x58,%edi
  800c9e:	ff d0                	callq  *%rax
			break;
  800ca0:	e9 f2 00 00 00       	jmpq   800d97 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800ca5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ca9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cad:	48 89 d6             	mov    %rdx,%rsi
  800cb0:	bf 30 00 00 00       	mov    $0x30,%edi
  800cb5:	ff d0                	callq  *%rax
			putch('x', putdat);
  800cb7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cbb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cbf:	48 89 d6             	mov    %rdx,%rsi
  800cc2:	bf 78 00 00 00       	mov    $0x78,%edi
  800cc7:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800cc9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ccc:	83 f8 30             	cmp    $0x30,%eax
  800ccf:	73 17                	jae    800ce8 <vprintfmt+0x46d>
  800cd1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cd5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cd8:	89 c0                	mov    %eax,%eax
  800cda:	48 01 d0             	add    %rdx,%rax
  800cdd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ce0:	83 c2 08             	add    $0x8,%edx
  800ce3:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ce6:	eb 0f                	jmp    800cf7 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800ce8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cec:	48 89 d0             	mov    %rdx,%rax
  800cef:	48 83 c2 08          	add    $0x8,%rdx
  800cf3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cf7:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cfa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800cfe:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d05:	eb 23                	jmp    800d2a <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d07:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d0b:	be 03 00 00 00       	mov    $0x3,%esi
  800d10:	48 89 c7             	mov    %rax,%rdi
  800d13:	48 b8 5b 06 80 00 00 	movabs $0x80065b,%rax
  800d1a:	00 00 00 
  800d1d:	ff d0                	callq  *%rax
  800d1f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d23:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d2a:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d2f:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d32:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d35:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d39:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d3d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d41:	45 89 c1             	mov    %r8d,%r9d
  800d44:	41 89 f8             	mov    %edi,%r8d
  800d47:	48 89 c7             	mov    %rax,%rdi
  800d4a:	48 b8 a0 05 80 00 00 	movabs $0x8005a0,%rax
  800d51:	00 00 00 
  800d54:	ff d0                	callq  *%rax
			break;
  800d56:	eb 3f                	jmp    800d97 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d58:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d5c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d60:	48 89 d6             	mov    %rdx,%rsi
  800d63:	89 df                	mov    %ebx,%edi
  800d65:	ff d0                	callq  *%rax
			break;
  800d67:	eb 2e                	jmp    800d97 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d69:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d6d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d71:	48 89 d6             	mov    %rdx,%rsi
  800d74:	bf 25 00 00 00       	mov    $0x25,%edi
  800d79:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d7b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d80:	eb 05                	jmp    800d87 <vprintfmt+0x50c>
  800d82:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d87:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d8b:	48 83 e8 01          	sub    $0x1,%rax
  800d8f:	0f b6 00             	movzbl (%rax),%eax
  800d92:	3c 25                	cmp    $0x25,%al
  800d94:	75 ec                	jne    800d82 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800d96:	90                   	nop
		}
	}
  800d97:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d98:	e9 30 fb ff ff       	jmpq   8008cd <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d9d:	48 83 c4 60          	add    $0x60,%rsp
  800da1:	5b                   	pop    %rbx
  800da2:	41 5c                	pop    %r12
  800da4:	5d                   	pop    %rbp
  800da5:	c3                   	retq   

0000000000800da6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800da6:	55                   	push   %rbp
  800da7:	48 89 e5             	mov    %rsp,%rbp
  800daa:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800db1:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800db8:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800dbf:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800dc6:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800dcd:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800dd4:	84 c0                	test   %al,%al
  800dd6:	74 20                	je     800df8 <printfmt+0x52>
  800dd8:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ddc:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800de0:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800de4:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800de8:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dec:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800df0:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800df4:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800df8:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800dff:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e06:	00 00 00 
  800e09:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e10:	00 00 00 
  800e13:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e17:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e1e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e25:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e2c:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e33:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e3a:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e41:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e48:	48 89 c7             	mov    %rax,%rdi
  800e4b:	48 b8 7b 08 80 00 00 	movabs $0x80087b,%rax
  800e52:	00 00 00 
  800e55:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e57:	c9                   	leaveq 
  800e58:	c3                   	retq   

0000000000800e59 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e59:	55                   	push   %rbp
  800e5a:	48 89 e5             	mov    %rsp,%rbp
  800e5d:	48 83 ec 10          	sub    $0x10,%rsp
  800e61:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e64:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e6c:	8b 40 10             	mov    0x10(%rax),%eax
  800e6f:	8d 50 01             	lea    0x1(%rax),%edx
  800e72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e76:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e7d:	48 8b 10             	mov    (%rax),%rdx
  800e80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e84:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e88:	48 39 c2             	cmp    %rax,%rdx
  800e8b:	73 17                	jae    800ea4 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e91:	48 8b 00             	mov    (%rax),%rax
  800e94:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e98:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e9c:	48 89 0a             	mov    %rcx,(%rdx)
  800e9f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800ea2:	88 10                	mov    %dl,(%rax)
}
  800ea4:	c9                   	leaveq 
  800ea5:	c3                   	retq   

0000000000800ea6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ea6:	55                   	push   %rbp
  800ea7:	48 89 e5             	mov    %rsp,%rbp
  800eaa:	48 83 ec 50          	sub    $0x50,%rsp
  800eae:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800eb2:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800eb5:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800eb9:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ebd:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ec1:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800ec5:	48 8b 0a             	mov    (%rdx),%rcx
  800ec8:	48 89 08             	mov    %rcx,(%rax)
  800ecb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ecf:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ed3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ed7:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800edb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800edf:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ee3:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800ee6:	48 98                	cltq   
  800ee8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800eec:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ef0:	48 01 d0             	add    %rdx,%rax
  800ef3:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ef7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800efe:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f03:	74 06                	je     800f0b <vsnprintf+0x65>
  800f05:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f09:	7f 07                	jg     800f12 <vsnprintf+0x6c>
		return -E_INVAL;
  800f0b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f10:	eb 2f                	jmp    800f41 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f12:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f16:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f1a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f1e:	48 89 c6             	mov    %rax,%rsi
  800f21:	48 bf 59 0e 80 00 00 	movabs $0x800e59,%rdi
  800f28:	00 00 00 
  800f2b:	48 b8 7b 08 80 00 00 	movabs $0x80087b,%rax
  800f32:	00 00 00 
  800f35:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f37:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f3b:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f3e:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f41:	c9                   	leaveq 
  800f42:	c3                   	retq   

0000000000800f43 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f43:	55                   	push   %rbp
  800f44:	48 89 e5             	mov    %rsp,%rbp
  800f47:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f4e:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f55:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f5b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f62:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f69:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f70:	84 c0                	test   %al,%al
  800f72:	74 20                	je     800f94 <snprintf+0x51>
  800f74:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f78:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f7c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f80:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f84:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f88:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f8c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f90:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f94:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f9b:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800fa2:	00 00 00 
  800fa5:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fac:	00 00 00 
  800faf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fb3:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fba:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fc1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fc8:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fcf:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fd6:	48 8b 0a             	mov    (%rdx),%rcx
  800fd9:	48 89 08             	mov    %rcx,(%rax)
  800fdc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fe0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fe4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fe8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800fec:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800ff3:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800ffa:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801000:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801007:	48 89 c7             	mov    %rax,%rdi
  80100a:	48 b8 a6 0e 80 00 00 	movabs $0x800ea6,%rax
  801011:	00 00 00 
  801014:	ff d0                	callq  *%rax
  801016:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80101c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801022:	c9                   	leaveq 
  801023:	c3                   	retq   

0000000000801024 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801024:	55                   	push   %rbp
  801025:	48 89 e5             	mov    %rsp,%rbp
  801028:	48 83 ec 18          	sub    $0x18,%rsp
  80102c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801030:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801037:	eb 09                	jmp    801042 <strlen+0x1e>
		n++;
  801039:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80103d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801042:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801046:	0f b6 00             	movzbl (%rax),%eax
  801049:	84 c0                	test   %al,%al
  80104b:	75 ec                	jne    801039 <strlen+0x15>
		n++;
	return n;
  80104d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801050:	c9                   	leaveq 
  801051:	c3                   	retq   

0000000000801052 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801052:	55                   	push   %rbp
  801053:	48 89 e5             	mov    %rsp,%rbp
  801056:	48 83 ec 20          	sub    $0x20,%rsp
  80105a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80105e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801062:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801069:	eb 0e                	jmp    801079 <strnlen+0x27>
		n++;
  80106b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80106f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801074:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801079:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80107e:	74 0b                	je     80108b <strnlen+0x39>
  801080:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801084:	0f b6 00             	movzbl (%rax),%eax
  801087:	84 c0                	test   %al,%al
  801089:	75 e0                	jne    80106b <strnlen+0x19>
		n++;
	return n;
  80108b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80108e:	c9                   	leaveq 
  80108f:	c3                   	retq   

0000000000801090 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801090:	55                   	push   %rbp
  801091:	48 89 e5             	mov    %rsp,%rbp
  801094:	48 83 ec 20          	sub    $0x20,%rsp
  801098:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80109c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8010a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8010a8:	90                   	nop
  8010a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ad:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010b1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010b5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010b9:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010bd:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010c1:	0f b6 12             	movzbl (%rdx),%edx
  8010c4:	88 10                	mov    %dl,(%rax)
  8010c6:	0f b6 00             	movzbl (%rax),%eax
  8010c9:	84 c0                	test   %al,%al
  8010cb:	75 dc                	jne    8010a9 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010d1:	c9                   	leaveq 
  8010d2:	c3                   	retq   

00000000008010d3 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010d3:	55                   	push   %rbp
  8010d4:	48 89 e5             	mov    %rsp,%rbp
  8010d7:	48 83 ec 20          	sub    $0x20,%rsp
  8010db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010df:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e7:	48 89 c7             	mov    %rax,%rdi
  8010ea:	48 b8 24 10 80 00 00 	movabs $0x801024,%rax
  8010f1:	00 00 00 
  8010f4:	ff d0                	callq  *%rax
  8010f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010fc:	48 63 d0             	movslq %eax,%rdx
  8010ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801103:	48 01 c2             	add    %rax,%rdx
  801106:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80110a:	48 89 c6             	mov    %rax,%rsi
  80110d:	48 89 d7             	mov    %rdx,%rdi
  801110:	48 b8 90 10 80 00 00 	movabs $0x801090,%rax
  801117:	00 00 00 
  80111a:	ff d0                	callq  *%rax
	return dst;
  80111c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801120:	c9                   	leaveq 
  801121:	c3                   	retq   

0000000000801122 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801122:	55                   	push   %rbp
  801123:	48 89 e5             	mov    %rsp,%rbp
  801126:	48 83 ec 28          	sub    $0x28,%rsp
  80112a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80112e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801132:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801136:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80113e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801145:	00 
  801146:	eb 2a                	jmp    801172 <strncpy+0x50>
		*dst++ = *src;
  801148:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80114c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801150:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801154:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801158:	0f b6 12             	movzbl (%rdx),%edx
  80115b:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80115d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801161:	0f b6 00             	movzbl (%rax),%eax
  801164:	84 c0                	test   %al,%al
  801166:	74 05                	je     80116d <strncpy+0x4b>
			src++;
  801168:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80116d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801172:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801176:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80117a:	72 cc                	jb     801148 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80117c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801180:	c9                   	leaveq 
  801181:	c3                   	retq   

0000000000801182 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801182:	55                   	push   %rbp
  801183:	48 89 e5             	mov    %rsp,%rbp
  801186:	48 83 ec 28          	sub    $0x28,%rsp
  80118a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80118e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801192:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801196:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80119a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80119e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011a3:	74 3d                	je     8011e2 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8011a5:	eb 1d                	jmp    8011c4 <strlcpy+0x42>
			*dst++ = *src++;
  8011a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ab:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011af:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011b3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011b7:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011bb:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011bf:	0f b6 12             	movzbl (%rdx),%edx
  8011c2:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011c4:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011c9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011ce:	74 0b                	je     8011db <strlcpy+0x59>
  8011d0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011d4:	0f b6 00             	movzbl (%rax),%eax
  8011d7:	84 c0                	test   %al,%al
  8011d9:	75 cc                	jne    8011a7 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011df:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ea:	48 29 c2             	sub    %rax,%rdx
  8011ed:	48 89 d0             	mov    %rdx,%rax
}
  8011f0:	c9                   	leaveq 
  8011f1:	c3                   	retq   

00000000008011f2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011f2:	55                   	push   %rbp
  8011f3:	48 89 e5             	mov    %rsp,%rbp
  8011f6:	48 83 ec 10          	sub    $0x10,%rsp
  8011fa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011fe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801202:	eb 0a                	jmp    80120e <strcmp+0x1c>
		p++, q++;
  801204:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801209:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80120e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801212:	0f b6 00             	movzbl (%rax),%eax
  801215:	84 c0                	test   %al,%al
  801217:	74 12                	je     80122b <strcmp+0x39>
  801219:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80121d:	0f b6 10             	movzbl (%rax),%edx
  801220:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801224:	0f b6 00             	movzbl (%rax),%eax
  801227:	38 c2                	cmp    %al,%dl
  801229:	74 d9                	je     801204 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80122b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122f:	0f b6 00             	movzbl (%rax),%eax
  801232:	0f b6 d0             	movzbl %al,%edx
  801235:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801239:	0f b6 00             	movzbl (%rax),%eax
  80123c:	0f b6 c0             	movzbl %al,%eax
  80123f:	29 c2                	sub    %eax,%edx
  801241:	89 d0                	mov    %edx,%eax
}
  801243:	c9                   	leaveq 
  801244:	c3                   	retq   

0000000000801245 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801245:	55                   	push   %rbp
  801246:	48 89 e5             	mov    %rsp,%rbp
  801249:	48 83 ec 18          	sub    $0x18,%rsp
  80124d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801251:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801255:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801259:	eb 0f                	jmp    80126a <strncmp+0x25>
		n--, p++, q++;
  80125b:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801260:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801265:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80126a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80126f:	74 1d                	je     80128e <strncmp+0x49>
  801271:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801275:	0f b6 00             	movzbl (%rax),%eax
  801278:	84 c0                	test   %al,%al
  80127a:	74 12                	je     80128e <strncmp+0x49>
  80127c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801280:	0f b6 10             	movzbl (%rax),%edx
  801283:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801287:	0f b6 00             	movzbl (%rax),%eax
  80128a:	38 c2                	cmp    %al,%dl
  80128c:	74 cd                	je     80125b <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80128e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801293:	75 07                	jne    80129c <strncmp+0x57>
		return 0;
  801295:	b8 00 00 00 00       	mov    $0x0,%eax
  80129a:	eb 18                	jmp    8012b4 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80129c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a0:	0f b6 00             	movzbl (%rax),%eax
  8012a3:	0f b6 d0             	movzbl %al,%edx
  8012a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012aa:	0f b6 00             	movzbl (%rax),%eax
  8012ad:	0f b6 c0             	movzbl %al,%eax
  8012b0:	29 c2                	sub    %eax,%edx
  8012b2:	89 d0                	mov    %edx,%eax
}
  8012b4:	c9                   	leaveq 
  8012b5:	c3                   	retq   

00000000008012b6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012b6:	55                   	push   %rbp
  8012b7:	48 89 e5             	mov    %rsp,%rbp
  8012ba:	48 83 ec 0c          	sub    $0xc,%rsp
  8012be:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012c2:	89 f0                	mov    %esi,%eax
  8012c4:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012c7:	eb 17                	jmp    8012e0 <strchr+0x2a>
		if (*s == c)
  8012c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012cd:	0f b6 00             	movzbl (%rax),%eax
  8012d0:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012d3:	75 06                	jne    8012db <strchr+0x25>
			return (char *) s;
  8012d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d9:	eb 15                	jmp    8012f0 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012db:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e4:	0f b6 00             	movzbl (%rax),%eax
  8012e7:	84 c0                	test   %al,%al
  8012e9:	75 de                	jne    8012c9 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012f0:	c9                   	leaveq 
  8012f1:	c3                   	retq   

00000000008012f2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012f2:	55                   	push   %rbp
  8012f3:	48 89 e5             	mov    %rsp,%rbp
  8012f6:	48 83 ec 0c          	sub    $0xc,%rsp
  8012fa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012fe:	89 f0                	mov    %esi,%eax
  801300:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801303:	eb 13                	jmp    801318 <strfind+0x26>
		if (*s == c)
  801305:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801309:	0f b6 00             	movzbl (%rax),%eax
  80130c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80130f:	75 02                	jne    801313 <strfind+0x21>
			break;
  801311:	eb 10                	jmp    801323 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801313:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801318:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80131c:	0f b6 00             	movzbl (%rax),%eax
  80131f:	84 c0                	test   %al,%al
  801321:	75 e2                	jne    801305 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801323:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801327:	c9                   	leaveq 
  801328:	c3                   	retq   

0000000000801329 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801329:	55                   	push   %rbp
  80132a:	48 89 e5             	mov    %rsp,%rbp
  80132d:	48 83 ec 18          	sub    $0x18,%rsp
  801331:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801335:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801338:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80133c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801341:	75 06                	jne    801349 <memset+0x20>
		return v;
  801343:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801347:	eb 69                	jmp    8013b2 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801349:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134d:	83 e0 03             	and    $0x3,%eax
  801350:	48 85 c0             	test   %rax,%rax
  801353:	75 48                	jne    80139d <memset+0x74>
  801355:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801359:	83 e0 03             	and    $0x3,%eax
  80135c:	48 85 c0             	test   %rax,%rax
  80135f:	75 3c                	jne    80139d <memset+0x74>
		c &= 0xFF;
  801361:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801368:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80136b:	c1 e0 18             	shl    $0x18,%eax
  80136e:	89 c2                	mov    %eax,%edx
  801370:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801373:	c1 e0 10             	shl    $0x10,%eax
  801376:	09 c2                	or     %eax,%edx
  801378:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80137b:	c1 e0 08             	shl    $0x8,%eax
  80137e:	09 d0                	or     %edx,%eax
  801380:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801383:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801387:	48 c1 e8 02          	shr    $0x2,%rax
  80138b:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80138e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801392:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801395:	48 89 d7             	mov    %rdx,%rdi
  801398:	fc                   	cld    
  801399:	f3 ab                	rep stos %eax,%es:(%rdi)
  80139b:	eb 11                	jmp    8013ae <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80139d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013a1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013a4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013a8:	48 89 d7             	mov    %rdx,%rdi
  8013ab:	fc                   	cld    
  8013ac:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8013ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013b2:	c9                   	leaveq 
  8013b3:	c3                   	retq   

00000000008013b4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013b4:	55                   	push   %rbp
  8013b5:	48 89 e5             	mov    %rsp,%rbp
  8013b8:	48 83 ec 28          	sub    $0x28,%rsp
  8013bc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013c0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013c4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013cc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013dc:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013e0:	0f 83 88 00 00 00    	jae    80146e <memmove+0xba>
  8013e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ea:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013ee:	48 01 d0             	add    %rdx,%rax
  8013f1:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013f5:	76 77                	jbe    80146e <memmove+0xba>
		s += n;
  8013f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013fb:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801403:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801407:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80140b:	83 e0 03             	and    $0x3,%eax
  80140e:	48 85 c0             	test   %rax,%rax
  801411:	75 3b                	jne    80144e <memmove+0x9a>
  801413:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801417:	83 e0 03             	and    $0x3,%eax
  80141a:	48 85 c0             	test   %rax,%rax
  80141d:	75 2f                	jne    80144e <memmove+0x9a>
  80141f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801423:	83 e0 03             	and    $0x3,%eax
  801426:	48 85 c0             	test   %rax,%rax
  801429:	75 23                	jne    80144e <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80142b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80142f:	48 83 e8 04          	sub    $0x4,%rax
  801433:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801437:	48 83 ea 04          	sub    $0x4,%rdx
  80143b:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80143f:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801443:	48 89 c7             	mov    %rax,%rdi
  801446:	48 89 d6             	mov    %rdx,%rsi
  801449:	fd                   	std    
  80144a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80144c:	eb 1d                	jmp    80146b <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80144e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801452:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801456:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80145a:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80145e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801462:	48 89 d7             	mov    %rdx,%rdi
  801465:	48 89 c1             	mov    %rax,%rcx
  801468:	fd                   	std    
  801469:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80146b:	fc                   	cld    
  80146c:	eb 57                	jmp    8014c5 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80146e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801472:	83 e0 03             	and    $0x3,%eax
  801475:	48 85 c0             	test   %rax,%rax
  801478:	75 36                	jne    8014b0 <memmove+0xfc>
  80147a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80147e:	83 e0 03             	and    $0x3,%eax
  801481:	48 85 c0             	test   %rax,%rax
  801484:	75 2a                	jne    8014b0 <memmove+0xfc>
  801486:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80148a:	83 e0 03             	and    $0x3,%eax
  80148d:	48 85 c0             	test   %rax,%rax
  801490:	75 1e                	jne    8014b0 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801492:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801496:	48 c1 e8 02          	shr    $0x2,%rax
  80149a:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80149d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014a5:	48 89 c7             	mov    %rax,%rdi
  8014a8:	48 89 d6             	mov    %rdx,%rsi
  8014ab:	fc                   	cld    
  8014ac:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014ae:	eb 15                	jmp    8014c5 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8014b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014b8:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014bc:	48 89 c7             	mov    %rax,%rdi
  8014bf:	48 89 d6             	mov    %rdx,%rsi
  8014c2:	fc                   	cld    
  8014c3:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014c9:	c9                   	leaveq 
  8014ca:	c3                   	retq   

00000000008014cb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014cb:	55                   	push   %rbp
  8014cc:	48 89 e5             	mov    %rsp,%rbp
  8014cf:	48 83 ec 18          	sub    $0x18,%rsp
  8014d3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014d7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014db:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014e3:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014eb:	48 89 ce             	mov    %rcx,%rsi
  8014ee:	48 89 c7             	mov    %rax,%rdi
  8014f1:	48 b8 b4 13 80 00 00 	movabs $0x8013b4,%rax
  8014f8:	00 00 00 
  8014fb:	ff d0                	callq  *%rax
}
  8014fd:	c9                   	leaveq 
  8014fe:	c3                   	retq   

00000000008014ff <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014ff:	55                   	push   %rbp
  801500:	48 89 e5             	mov    %rsp,%rbp
  801503:	48 83 ec 28          	sub    $0x28,%rsp
  801507:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80150b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80150f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801513:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801517:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80151b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80151f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801523:	eb 36                	jmp    80155b <memcmp+0x5c>
		if (*s1 != *s2)
  801525:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801529:	0f b6 10             	movzbl (%rax),%edx
  80152c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801530:	0f b6 00             	movzbl (%rax),%eax
  801533:	38 c2                	cmp    %al,%dl
  801535:	74 1a                	je     801551 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801537:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80153b:	0f b6 00             	movzbl (%rax),%eax
  80153e:	0f b6 d0             	movzbl %al,%edx
  801541:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801545:	0f b6 00             	movzbl (%rax),%eax
  801548:	0f b6 c0             	movzbl %al,%eax
  80154b:	29 c2                	sub    %eax,%edx
  80154d:	89 d0                	mov    %edx,%eax
  80154f:	eb 20                	jmp    801571 <memcmp+0x72>
		s1++, s2++;
  801551:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801556:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80155b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80155f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801563:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801567:	48 85 c0             	test   %rax,%rax
  80156a:	75 b9                	jne    801525 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80156c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801571:	c9                   	leaveq 
  801572:	c3                   	retq   

0000000000801573 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801573:	55                   	push   %rbp
  801574:	48 89 e5             	mov    %rsp,%rbp
  801577:	48 83 ec 28          	sub    $0x28,%rsp
  80157b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80157f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801582:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801586:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80158e:	48 01 d0             	add    %rdx,%rax
  801591:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801595:	eb 15                	jmp    8015ac <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801597:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80159b:	0f b6 10             	movzbl (%rax),%edx
  80159e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8015a1:	38 c2                	cmp    %al,%dl
  8015a3:	75 02                	jne    8015a7 <memfind+0x34>
			break;
  8015a5:	eb 0f                	jmp    8015b6 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015a7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015b0:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8015b4:	72 e1                	jb     801597 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8015b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015ba:	c9                   	leaveq 
  8015bb:	c3                   	retq   

00000000008015bc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015bc:	55                   	push   %rbp
  8015bd:	48 89 e5             	mov    %rsp,%rbp
  8015c0:	48 83 ec 34          	sub    $0x34,%rsp
  8015c4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015c8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015cc:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015d6:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015dd:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015de:	eb 05                	jmp    8015e5 <strtol+0x29>
		s++;
  8015e0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e9:	0f b6 00             	movzbl (%rax),%eax
  8015ec:	3c 20                	cmp    $0x20,%al
  8015ee:	74 f0                	je     8015e0 <strtol+0x24>
  8015f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f4:	0f b6 00             	movzbl (%rax),%eax
  8015f7:	3c 09                	cmp    $0x9,%al
  8015f9:	74 e5                	je     8015e0 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ff:	0f b6 00             	movzbl (%rax),%eax
  801602:	3c 2b                	cmp    $0x2b,%al
  801604:	75 07                	jne    80160d <strtol+0x51>
		s++;
  801606:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80160b:	eb 17                	jmp    801624 <strtol+0x68>
	else if (*s == '-')
  80160d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801611:	0f b6 00             	movzbl (%rax),%eax
  801614:	3c 2d                	cmp    $0x2d,%al
  801616:	75 0c                	jne    801624 <strtol+0x68>
		s++, neg = 1;
  801618:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80161d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801624:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801628:	74 06                	je     801630 <strtol+0x74>
  80162a:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80162e:	75 28                	jne    801658 <strtol+0x9c>
  801630:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801634:	0f b6 00             	movzbl (%rax),%eax
  801637:	3c 30                	cmp    $0x30,%al
  801639:	75 1d                	jne    801658 <strtol+0x9c>
  80163b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163f:	48 83 c0 01          	add    $0x1,%rax
  801643:	0f b6 00             	movzbl (%rax),%eax
  801646:	3c 78                	cmp    $0x78,%al
  801648:	75 0e                	jne    801658 <strtol+0x9c>
		s += 2, base = 16;
  80164a:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80164f:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801656:	eb 2c                	jmp    801684 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801658:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80165c:	75 19                	jne    801677 <strtol+0xbb>
  80165e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801662:	0f b6 00             	movzbl (%rax),%eax
  801665:	3c 30                	cmp    $0x30,%al
  801667:	75 0e                	jne    801677 <strtol+0xbb>
		s++, base = 8;
  801669:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80166e:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801675:	eb 0d                	jmp    801684 <strtol+0xc8>
	else if (base == 0)
  801677:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80167b:	75 07                	jne    801684 <strtol+0xc8>
		base = 10;
  80167d:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801684:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801688:	0f b6 00             	movzbl (%rax),%eax
  80168b:	3c 2f                	cmp    $0x2f,%al
  80168d:	7e 1d                	jle    8016ac <strtol+0xf0>
  80168f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801693:	0f b6 00             	movzbl (%rax),%eax
  801696:	3c 39                	cmp    $0x39,%al
  801698:	7f 12                	jg     8016ac <strtol+0xf0>
			dig = *s - '0';
  80169a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169e:	0f b6 00             	movzbl (%rax),%eax
  8016a1:	0f be c0             	movsbl %al,%eax
  8016a4:	83 e8 30             	sub    $0x30,%eax
  8016a7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016aa:	eb 4e                	jmp    8016fa <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8016ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b0:	0f b6 00             	movzbl (%rax),%eax
  8016b3:	3c 60                	cmp    $0x60,%al
  8016b5:	7e 1d                	jle    8016d4 <strtol+0x118>
  8016b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016bb:	0f b6 00             	movzbl (%rax),%eax
  8016be:	3c 7a                	cmp    $0x7a,%al
  8016c0:	7f 12                	jg     8016d4 <strtol+0x118>
			dig = *s - 'a' + 10;
  8016c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c6:	0f b6 00             	movzbl (%rax),%eax
  8016c9:	0f be c0             	movsbl %al,%eax
  8016cc:	83 e8 57             	sub    $0x57,%eax
  8016cf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016d2:	eb 26                	jmp    8016fa <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d8:	0f b6 00             	movzbl (%rax),%eax
  8016db:	3c 40                	cmp    $0x40,%al
  8016dd:	7e 48                	jle    801727 <strtol+0x16b>
  8016df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e3:	0f b6 00             	movzbl (%rax),%eax
  8016e6:	3c 5a                	cmp    $0x5a,%al
  8016e8:	7f 3d                	jg     801727 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ee:	0f b6 00             	movzbl (%rax),%eax
  8016f1:	0f be c0             	movsbl %al,%eax
  8016f4:	83 e8 37             	sub    $0x37,%eax
  8016f7:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016fd:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801700:	7c 02                	jl     801704 <strtol+0x148>
			break;
  801702:	eb 23                	jmp    801727 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801704:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801709:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80170c:	48 98                	cltq   
  80170e:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801713:	48 89 c2             	mov    %rax,%rdx
  801716:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801719:	48 98                	cltq   
  80171b:	48 01 d0             	add    %rdx,%rax
  80171e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801722:	e9 5d ff ff ff       	jmpq   801684 <strtol+0xc8>

	if (endptr)
  801727:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80172c:	74 0b                	je     801739 <strtol+0x17d>
		*endptr = (char *) s;
  80172e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801732:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801736:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801739:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80173d:	74 09                	je     801748 <strtol+0x18c>
  80173f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801743:	48 f7 d8             	neg    %rax
  801746:	eb 04                	jmp    80174c <strtol+0x190>
  801748:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80174c:	c9                   	leaveq 
  80174d:	c3                   	retq   

000000000080174e <strstr>:

char * strstr(const char *in, const char *str)
{
  80174e:	55                   	push   %rbp
  80174f:	48 89 e5             	mov    %rsp,%rbp
  801752:	48 83 ec 30          	sub    $0x30,%rsp
  801756:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80175a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80175e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801762:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801766:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80176a:	0f b6 00             	movzbl (%rax),%eax
  80176d:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801770:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801774:	75 06                	jne    80177c <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801776:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177a:	eb 6b                	jmp    8017e7 <strstr+0x99>

	len = strlen(str);
  80177c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801780:	48 89 c7             	mov    %rax,%rdi
  801783:	48 b8 24 10 80 00 00 	movabs $0x801024,%rax
  80178a:	00 00 00 
  80178d:	ff d0                	callq  *%rax
  80178f:	48 98                	cltq   
  801791:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801795:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801799:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80179d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017a1:	0f b6 00             	movzbl (%rax),%eax
  8017a4:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8017a7:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8017ab:	75 07                	jne    8017b4 <strstr+0x66>
				return (char *) 0;
  8017ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b2:	eb 33                	jmp    8017e7 <strstr+0x99>
		} while (sc != c);
  8017b4:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8017b8:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8017bb:	75 d8                	jne    801795 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8017bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017c1:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c9:	48 89 ce             	mov    %rcx,%rsi
  8017cc:	48 89 c7             	mov    %rax,%rdi
  8017cf:	48 b8 45 12 80 00 00 	movabs $0x801245,%rax
  8017d6:	00 00 00 
  8017d9:	ff d0                	callq  *%rax
  8017db:	85 c0                	test   %eax,%eax
  8017dd:	75 b6                	jne    801795 <strstr+0x47>

	return (char *) (in - 1);
  8017df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e3:	48 83 e8 01          	sub    $0x1,%rax
}
  8017e7:	c9                   	leaveq 
  8017e8:	c3                   	retq   
