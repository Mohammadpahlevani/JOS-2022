
obj/user/buggyhello:     file format elf64-x86-64


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
  80003c:	e8 29 00 00 00       	callq  80006a <libmain>
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
	sys_cputs((char*)1, 1);
  800052:	be 01 00 00 00       	mov    $0x1,%esi
  800057:	bf 01 00 00 00       	mov    $0x1,%edi
  80005c:	48 b8 99 01 80 00 00 	movabs $0x800199,%rax
  800063:	00 00 00 
  800066:	ff d0                	callq  *%rax
}
  800068:	c9                   	leaveq 
  800069:	c3                   	retq   

000000000080006a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80006a:	55                   	push   %rbp
  80006b:	48 89 e5             	mov    %rsp,%rbp
  80006e:	48 83 ec 10          	sub    $0x10,%rsp
  800072:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800075:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	thisenv = &envs[ENVX(sys_getenvid())];
  800079:	48 b8 65 02 80 00 00 	movabs $0x800265,%rax
  800080:	00 00 00 
  800083:	ff d0                	callq  *%rax
  800085:	25 ff 03 00 00       	and    $0x3ff,%eax
  80008a:	48 98                	cltq   
  80008c:	48 c1 e0 03          	shl    $0x3,%rax
  800090:	48 89 c2             	mov    %rax,%rdx
  800093:	48 c1 e2 05          	shl    $0x5,%rdx
  800097:	48 29 c2             	sub    %rax,%rdx
  80009a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000a1:	00 00 00 
  8000a4:	48 01 c2             	add    %rax,%rdx
  8000a7:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000ae:	00 00 00 
  8000b1:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000b8:	7e 14                	jle    8000ce <libmain+0x64>
		binaryname = argv[0];
  8000ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000be:	48 8b 10             	mov    (%rax),%rdx
  8000c1:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000c8:	00 00 00 
  8000cb:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000ce:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d5:	48 89 d6             	mov    %rdx,%rsi
  8000d8:	89 c7                	mov    %eax,%edi
  8000da:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000e1:	00 00 00 
  8000e4:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000e6:	48 b8 f4 00 80 00 00 	movabs $0x8000f4,%rax
  8000ed:	00 00 00 
  8000f0:	ff d0                	callq  *%rax
}
  8000f2:	c9                   	leaveq 
  8000f3:	c3                   	retq   

00000000008000f4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000f4:	55                   	push   %rbp
  8000f5:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8000f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8000fd:	48 b8 21 02 80 00 00 	movabs $0x800221,%rax
  800104:	00 00 00 
  800107:	ff d0                	callq  *%rax
}
  800109:	5d                   	pop    %rbp
  80010a:	c3                   	retq   

000000000080010b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80010b:	55                   	push   %rbp
  80010c:	48 89 e5             	mov    %rsp,%rbp
  80010f:	53                   	push   %rbx
  800110:	48 83 ec 48          	sub    $0x48,%rsp
  800114:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800117:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80011a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80011e:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800122:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800126:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80012a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80012d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800131:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800135:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800139:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80013d:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800141:	4c 89 c3             	mov    %r8,%rbx
  800144:	cd 30                	int    $0x30
  800146:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80014a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80014e:	74 3e                	je     80018e <syscall+0x83>
  800150:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800155:	7e 37                	jle    80018e <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800157:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80015b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80015e:	49 89 d0             	mov    %rdx,%r8
  800161:	89 c1                	mov    %eax,%ecx
  800163:	48 ba 0a 18 80 00 00 	movabs $0x80180a,%rdx
  80016a:	00 00 00 
  80016d:	be 23 00 00 00       	mov    $0x23,%esi
  800172:	48 bf 27 18 80 00 00 	movabs $0x801827,%rdi
  800179:	00 00 00 
  80017c:	b8 00 00 00 00       	mov    $0x0,%eax
  800181:	49 b9 a3 02 80 00 00 	movabs $0x8002a3,%r9
  800188:	00 00 00 
  80018b:	41 ff d1             	callq  *%r9

	return ret;
  80018e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800192:	48 83 c4 48          	add    $0x48,%rsp
  800196:	5b                   	pop    %rbx
  800197:	5d                   	pop    %rbp
  800198:	c3                   	retq   

0000000000800199 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800199:	55                   	push   %rbp
  80019a:	48 89 e5             	mov    %rsp,%rbp
  80019d:	48 83 ec 20          	sub    $0x20,%rsp
  8001a1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001a5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001ad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001b1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001b8:	00 
  8001b9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001bf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001c5:	48 89 d1             	mov    %rdx,%rcx
  8001c8:	48 89 c2             	mov    %rax,%rdx
  8001cb:	be 00 00 00 00       	mov    $0x0,%esi
  8001d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8001d5:	48 b8 0b 01 80 00 00 	movabs $0x80010b,%rax
  8001dc:	00 00 00 
  8001df:	ff d0                	callq  *%rax
}
  8001e1:	c9                   	leaveq 
  8001e2:	c3                   	retq   

00000000008001e3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8001e3:	55                   	push   %rbp
  8001e4:	48 89 e5             	mov    %rsp,%rbp
  8001e7:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001eb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001f2:	00 
  8001f3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001f9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  800204:	ba 00 00 00 00       	mov    $0x0,%edx
  800209:	be 00 00 00 00       	mov    $0x0,%esi
  80020e:	bf 01 00 00 00       	mov    $0x1,%edi
  800213:	48 b8 0b 01 80 00 00 	movabs $0x80010b,%rax
  80021a:	00 00 00 
  80021d:	ff d0                	callq  *%rax
}
  80021f:	c9                   	leaveq 
  800220:	c3                   	retq   

0000000000800221 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800221:	55                   	push   %rbp
  800222:	48 89 e5             	mov    %rsp,%rbp
  800225:	48 83 ec 10          	sub    $0x10,%rsp
  800229:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80022c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80022f:	48 98                	cltq   
  800231:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800238:	00 
  800239:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80023f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800245:	b9 00 00 00 00       	mov    $0x0,%ecx
  80024a:	48 89 c2             	mov    %rax,%rdx
  80024d:	be 01 00 00 00       	mov    $0x1,%esi
  800252:	bf 03 00 00 00       	mov    $0x3,%edi
  800257:	48 b8 0b 01 80 00 00 	movabs $0x80010b,%rax
  80025e:	00 00 00 
  800261:	ff d0                	callq  *%rax
}
  800263:	c9                   	leaveq 
  800264:	c3                   	retq   

0000000000800265 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800265:	55                   	push   %rbp
  800266:	48 89 e5             	mov    %rsp,%rbp
  800269:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80026d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800274:	00 
  800275:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80027b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800281:	b9 00 00 00 00       	mov    $0x0,%ecx
  800286:	ba 00 00 00 00       	mov    $0x0,%edx
  80028b:	be 00 00 00 00       	mov    $0x0,%esi
  800290:	bf 02 00 00 00       	mov    $0x2,%edi
  800295:	48 b8 0b 01 80 00 00 	movabs $0x80010b,%rax
  80029c:	00 00 00 
  80029f:	ff d0                	callq  *%rax
}
  8002a1:	c9                   	leaveq 
  8002a2:	c3                   	retq   

00000000008002a3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002a3:	55                   	push   %rbp
  8002a4:	48 89 e5             	mov    %rsp,%rbp
  8002a7:	53                   	push   %rbx
  8002a8:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8002af:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8002b6:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8002bc:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8002c3:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8002ca:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8002d1:	84 c0                	test   %al,%al
  8002d3:	74 23                	je     8002f8 <_panic+0x55>
  8002d5:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8002dc:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002e0:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002e4:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002e8:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002ec:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002f0:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002f4:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002f8:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002ff:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800306:	00 00 00 
  800309:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800310:	00 00 00 
  800313:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800317:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80031e:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800325:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80032c:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  800333:	00 00 00 
  800336:	48 8b 18             	mov    (%rax),%rbx
  800339:	48 b8 65 02 80 00 00 	movabs $0x800265,%rax
  800340:	00 00 00 
  800343:	ff d0                	callq  *%rax
  800345:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80034b:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800352:	41 89 c8             	mov    %ecx,%r8d
  800355:	48 89 d1             	mov    %rdx,%rcx
  800358:	48 89 da             	mov    %rbx,%rdx
  80035b:	89 c6                	mov    %eax,%esi
  80035d:	48 bf 38 18 80 00 00 	movabs $0x801838,%rdi
  800364:	00 00 00 
  800367:	b8 00 00 00 00       	mov    $0x0,%eax
  80036c:	49 b9 dc 04 80 00 00 	movabs $0x8004dc,%r9
  800373:	00 00 00 
  800376:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800379:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800380:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800387:	48 89 d6             	mov    %rdx,%rsi
  80038a:	48 89 c7             	mov    %rax,%rdi
  80038d:	48 b8 30 04 80 00 00 	movabs $0x800430,%rax
  800394:	00 00 00 
  800397:	ff d0                	callq  *%rax
	cprintf("\n");
  800399:	48 bf 5b 18 80 00 00 	movabs $0x80185b,%rdi
  8003a0:	00 00 00 
  8003a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a8:	48 ba dc 04 80 00 00 	movabs $0x8004dc,%rdx
  8003af:	00 00 00 
  8003b2:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003b4:	cc                   	int3   
  8003b5:	eb fd                	jmp    8003b4 <_panic+0x111>

00000000008003b7 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8003b7:	55                   	push   %rbp
  8003b8:	48 89 e5             	mov    %rsp,%rbp
  8003bb:	48 83 ec 10          	sub    $0x10,%rsp
  8003bf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003c2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8003c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ca:	8b 00                	mov    (%rax),%eax
  8003cc:	8d 48 01             	lea    0x1(%rax),%ecx
  8003cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003d3:	89 0a                	mov    %ecx,(%rdx)
  8003d5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003d8:	89 d1                	mov    %edx,%ecx
  8003da:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003de:	48 98                	cltq   
  8003e0:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8003e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003e8:	8b 00                	mov    (%rax),%eax
  8003ea:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003ef:	75 2c                	jne    80041d <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003f5:	8b 00                	mov    (%rax),%eax
  8003f7:	48 98                	cltq   
  8003f9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003fd:	48 83 c2 08          	add    $0x8,%rdx
  800401:	48 89 c6             	mov    %rax,%rsi
  800404:	48 89 d7             	mov    %rdx,%rdi
  800407:	48 b8 99 01 80 00 00 	movabs $0x800199,%rax
  80040e:	00 00 00 
  800411:	ff d0                	callq  *%rax
        b->idx = 0;
  800413:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800417:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80041d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800421:	8b 40 04             	mov    0x4(%rax),%eax
  800424:	8d 50 01             	lea    0x1(%rax),%edx
  800427:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042b:	89 50 04             	mov    %edx,0x4(%rax)
}
  80042e:	c9                   	leaveq 
  80042f:	c3                   	retq   

0000000000800430 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800430:	55                   	push   %rbp
  800431:	48 89 e5             	mov    %rsp,%rbp
  800434:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80043b:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800442:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800449:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800450:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800457:	48 8b 0a             	mov    (%rdx),%rcx
  80045a:	48 89 08             	mov    %rcx,(%rax)
  80045d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800461:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800465:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800469:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80046d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800474:	00 00 00 
    b.cnt = 0;
  800477:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80047e:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800481:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800488:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80048f:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800496:	48 89 c6             	mov    %rax,%rsi
  800499:	48 bf b7 03 80 00 00 	movabs $0x8003b7,%rdi
  8004a0:	00 00 00 
  8004a3:	48 b8 8f 08 80 00 00 	movabs $0x80088f,%rax
  8004aa:	00 00 00 
  8004ad:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8004af:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8004b5:	48 98                	cltq   
  8004b7:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8004be:	48 83 c2 08          	add    $0x8,%rdx
  8004c2:	48 89 c6             	mov    %rax,%rsi
  8004c5:	48 89 d7             	mov    %rdx,%rdi
  8004c8:	48 b8 99 01 80 00 00 	movabs $0x800199,%rax
  8004cf:	00 00 00 
  8004d2:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8004d4:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004da:	c9                   	leaveq 
  8004db:	c3                   	retq   

00000000008004dc <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8004dc:	55                   	push   %rbp
  8004dd:	48 89 e5             	mov    %rsp,%rbp
  8004e0:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004e7:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004ee:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004f5:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004fc:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800503:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80050a:	84 c0                	test   %al,%al
  80050c:	74 20                	je     80052e <cprintf+0x52>
  80050e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800512:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800516:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80051a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80051e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800522:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800526:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80052a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80052e:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800535:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80053c:	00 00 00 
  80053f:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800546:	00 00 00 
  800549:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80054d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800554:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80055b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800562:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800569:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800570:	48 8b 0a             	mov    (%rdx),%rcx
  800573:	48 89 08             	mov    %rcx,(%rax)
  800576:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80057a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80057e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800582:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800586:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80058d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800594:	48 89 d6             	mov    %rdx,%rsi
  800597:	48 89 c7             	mov    %rax,%rdi
  80059a:	48 b8 30 04 80 00 00 	movabs $0x800430,%rax
  8005a1:	00 00 00 
  8005a4:	ff d0                	callq  *%rax
  8005a6:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8005ac:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8005b2:	c9                   	leaveq 
  8005b3:	c3                   	retq   

00000000008005b4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005b4:	55                   	push   %rbp
  8005b5:	48 89 e5             	mov    %rsp,%rbp
  8005b8:	53                   	push   %rbx
  8005b9:	48 83 ec 38          	sub    $0x38,%rsp
  8005bd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005c1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8005c5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8005c9:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8005cc:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8005d0:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005d4:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8005d7:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8005db:	77 3b                	ja     800618 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005dd:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8005e0:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005e4:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8005e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f0:	48 f7 f3             	div    %rbx
  8005f3:	48 89 c2             	mov    %rax,%rdx
  8005f6:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005f9:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005fc:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800600:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800604:	41 89 f9             	mov    %edi,%r9d
  800607:	48 89 c7             	mov    %rax,%rdi
  80060a:	48 b8 b4 05 80 00 00 	movabs $0x8005b4,%rax
  800611:	00 00 00 
  800614:	ff d0                	callq  *%rax
  800616:	eb 1e                	jmp    800636 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800618:	eb 12                	jmp    80062c <printnum+0x78>
			putch(padc, putdat);
  80061a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80061e:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800621:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800625:	48 89 ce             	mov    %rcx,%rsi
  800628:	89 d7                	mov    %edx,%edi
  80062a:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80062c:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800630:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800634:	7f e4                	jg     80061a <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800636:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800639:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80063d:	ba 00 00 00 00       	mov    $0x0,%edx
  800642:	48 f7 f1             	div    %rcx
  800645:	48 89 d0             	mov    %rdx,%rax
  800648:	48 ba 90 19 80 00 00 	movabs $0x801990,%rdx
  80064f:	00 00 00 
  800652:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800656:	0f be d0             	movsbl %al,%edx
  800659:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80065d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800661:	48 89 ce             	mov    %rcx,%rsi
  800664:	89 d7                	mov    %edx,%edi
  800666:	ff d0                	callq  *%rax
}
  800668:	48 83 c4 38          	add    $0x38,%rsp
  80066c:	5b                   	pop    %rbx
  80066d:	5d                   	pop    %rbp
  80066e:	c3                   	retq   

000000000080066f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80066f:	55                   	push   %rbp
  800670:	48 89 e5             	mov    %rsp,%rbp
  800673:	48 83 ec 1c          	sub    $0x1c,%rsp
  800677:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80067b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80067e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800682:	7e 52                	jle    8006d6 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800684:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800688:	8b 00                	mov    (%rax),%eax
  80068a:	83 f8 30             	cmp    $0x30,%eax
  80068d:	73 24                	jae    8006b3 <getuint+0x44>
  80068f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800693:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800697:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069b:	8b 00                	mov    (%rax),%eax
  80069d:	89 c0                	mov    %eax,%eax
  80069f:	48 01 d0             	add    %rdx,%rax
  8006a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a6:	8b 12                	mov    (%rdx),%edx
  8006a8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006af:	89 0a                	mov    %ecx,(%rdx)
  8006b1:	eb 17                	jmp    8006ca <getuint+0x5b>
  8006b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006bb:	48 89 d0             	mov    %rdx,%rax
  8006be:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006c2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006ca:	48 8b 00             	mov    (%rax),%rax
  8006cd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006d1:	e9 a3 00 00 00       	jmpq   800779 <getuint+0x10a>
	else if (lflag)
  8006d6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006da:	74 4f                	je     80072b <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8006dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e0:	8b 00                	mov    (%rax),%eax
  8006e2:	83 f8 30             	cmp    $0x30,%eax
  8006e5:	73 24                	jae    80070b <getuint+0x9c>
  8006e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006eb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f3:	8b 00                	mov    (%rax),%eax
  8006f5:	89 c0                	mov    %eax,%eax
  8006f7:	48 01 d0             	add    %rdx,%rax
  8006fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006fe:	8b 12                	mov    (%rdx),%edx
  800700:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800703:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800707:	89 0a                	mov    %ecx,(%rdx)
  800709:	eb 17                	jmp    800722 <getuint+0xb3>
  80070b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800713:	48 89 d0             	mov    %rdx,%rax
  800716:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80071a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800722:	48 8b 00             	mov    (%rax),%rax
  800725:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800729:	eb 4e                	jmp    800779 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80072b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80072f:	8b 00                	mov    (%rax),%eax
  800731:	83 f8 30             	cmp    $0x30,%eax
  800734:	73 24                	jae    80075a <getuint+0xeb>
  800736:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80073e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800742:	8b 00                	mov    (%rax),%eax
  800744:	89 c0                	mov    %eax,%eax
  800746:	48 01 d0             	add    %rdx,%rax
  800749:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80074d:	8b 12                	mov    (%rdx),%edx
  80074f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800752:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800756:	89 0a                	mov    %ecx,(%rdx)
  800758:	eb 17                	jmp    800771 <getuint+0x102>
  80075a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800762:	48 89 d0             	mov    %rdx,%rax
  800765:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800769:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80076d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800771:	8b 00                	mov    (%rax),%eax
  800773:	89 c0                	mov    %eax,%eax
  800775:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800779:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80077d:	c9                   	leaveq 
  80077e:	c3                   	retq   

000000000080077f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80077f:	55                   	push   %rbp
  800780:	48 89 e5             	mov    %rsp,%rbp
  800783:	48 83 ec 1c          	sub    $0x1c,%rsp
  800787:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80078b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80078e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800792:	7e 52                	jle    8007e6 <getint+0x67>
		x=va_arg(*ap, long long);
  800794:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800798:	8b 00                	mov    (%rax),%eax
  80079a:	83 f8 30             	cmp    $0x30,%eax
  80079d:	73 24                	jae    8007c3 <getint+0x44>
  80079f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ab:	8b 00                	mov    (%rax),%eax
  8007ad:	89 c0                	mov    %eax,%eax
  8007af:	48 01 d0             	add    %rdx,%rax
  8007b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b6:	8b 12                	mov    (%rdx),%edx
  8007b8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007bf:	89 0a                	mov    %ecx,(%rdx)
  8007c1:	eb 17                	jmp    8007da <getint+0x5b>
  8007c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007cb:	48 89 d0             	mov    %rdx,%rax
  8007ce:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007d2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007da:	48 8b 00             	mov    (%rax),%rax
  8007dd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007e1:	e9 a3 00 00 00       	jmpq   800889 <getint+0x10a>
	else if (lflag)
  8007e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007ea:	74 4f                	je     80083b <getint+0xbc>
		x=va_arg(*ap, long);
  8007ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f0:	8b 00                	mov    (%rax),%eax
  8007f2:	83 f8 30             	cmp    $0x30,%eax
  8007f5:	73 24                	jae    80081b <getint+0x9c>
  8007f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800803:	8b 00                	mov    (%rax),%eax
  800805:	89 c0                	mov    %eax,%eax
  800807:	48 01 d0             	add    %rdx,%rax
  80080a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080e:	8b 12                	mov    (%rdx),%edx
  800810:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800813:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800817:	89 0a                	mov    %ecx,(%rdx)
  800819:	eb 17                	jmp    800832 <getint+0xb3>
  80081b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800823:	48 89 d0             	mov    %rdx,%rax
  800826:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80082a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800832:	48 8b 00             	mov    (%rax),%rax
  800835:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800839:	eb 4e                	jmp    800889 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80083b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083f:	8b 00                	mov    (%rax),%eax
  800841:	83 f8 30             	cmp    $0x30,%eax
  800844:	73 24                	jae    80086a <getint+0xeb>
  800846:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80084e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800852:	8b 00                	mov    (%rax),%eax
  800854:	89 c0                	mov    %eax,%eax
  800856:	48 01 d0             	add    %rdx,%rax
  800859:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80085d:	8b 12                	mov    (%rdx),%edx
  80085f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800862:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800866:	89 0a                	mov    %ecx,(%rdx)
  800868:	eb 17                	jmp    800881 <getint+0x102>
  80086a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800872:	48 89 d0             	mov    %rdx,%rax
  800875:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800879:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80087d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800881:	8b 00                	mov    (%rax),%eax
  800883:	48 98                	cltq   
  800885:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800889:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80088d:	c9                   	leaveq 
  80088e:	c3                   	retq   

000000000080088f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80088f:	55                   	push   %rbp
  800890:	48 89 e5             	mov    %rsp,%rbp
  800893:	41 54                	push   %r12
  800895:	53                   	push   %rbx
  800896:	48 83 ec 60          	sub    $0x60,%rsp
  80089a:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80089e:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8008a2:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008a6:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8008aa:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8008ae:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8008b2:	48 8b 0a             	mov    (%rdx),%rcx
  8008b5:	48 89 08             	mov    %rcx,(%rax)
  8008b8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008bc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008c0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008c4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008c8:	eb 17                	jmp    8008e1 <vprintfmt+0x52>
			if (ch == '\0')
  8008ca:	85 db                	test   %ebx,%ebx
  8008cc:	0f 84 df 04 00 00    	je     800db1 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  8008d2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008d6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008da:	48 89 d6             	mov    %rdx,%rsi
  8008dd:	89 df                	mov    %ebx,%edi
  8008df:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008e1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008e5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008e9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008ed:	0f b6 00             	movzbl (%rax),%eax
  8008f0:	0f b6 d8             	movzbl %al,%ebx
  8008f3:	83 fb 25             	cmp    $0x25,%ebx
  8008f6:	75 d2                	jne    8008ca <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008f8:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008fc:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800903:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80090a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800911:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800918:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80091c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800920:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800924:	0f b6 00             	movzbl (%rax),%eax
  800927:	0f b6 d8             	movzbl %al,%ebx
  80092a:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80092d:	83 f8 55             	cmp    $0x55,%eax
  800930:	0f 87 47 04 00 00    	ja     800d7d <vprintfmt+0x4ee>
  800936:	89 c0                	mov    %eax,%eax
  800938:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80093f:	00 
  800940:	48 b8 b8 19 80 00 00 	movabs $0x8019b8,%rax
  800947:	00 00 00 
  80094a:	48 01 d0             	add    %rdx,%rax
  80094d:	48 8b 00             	mov    (%rax),%rax
  800950:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800952:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800956:	eb c0                	jmp    800918 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800958:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80095c:	eb ba                	jmp    800918 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80095e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800965:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800968:	89 d0                	mov    %edx,%eax
  80096a:	c1 e0 02             	shl    $0x2,%eax
  80096d:	01 d0                	add    %edx,%eax
  80096f:	01 c0                	add    %eax,%eax
  800971:	01 d8                	add    %ebx,%eax
  800973:	83 e8 30             	sub    $0x30,%eax
  800976:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800979:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80097d:	0f b6 00             	movzbl (%rax),%eax
  800980:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800983:	83 fb 2f             	cmp    $0x2f,%ebx
  800986:	7e 0c                	jle    800994 <vprintfmt+0x105>
  800988:	83 fb 39             	cmp    $0x39,%ebx
  80098b:	7f 07                	jg     800994 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80098d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800992:	eb d1                	jmp    800965 <vprintfmt+0xd6>
			goto process_precision;
  800994:	eb 58                	jmp    8009ee <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800996:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800999:	83 f8 30             	cmp    $0x30,%eax
  80099c:	73 17                	jae    8009b5 <vprintfmt+0x126>
  80099e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009a2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009a5:	89 c0                	mov    %eax,%eax
  8009a7:	48 01 d0             	add    %rdx,%rax
  8009aa:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009ad:	83 c2 08             	add    $0x8,%edx
  8009b0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009b3:	eb 0f                	jmp    8009c4 <vprintfmt+0x135>
  8009b5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009b9:	48 89 d0             	mov    %rdx,%rax
  8009bc:	48 83 c2 08          	add    $0x8,%rdx
  8009c0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009c4:	8b 00                	mov    (%rax),%eax
  8009c6:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8009c9:	eb 23                	jmp    8009ee <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8009cb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009cf:	79 0c                	jns    8009dd <vprintfmt+0x14e>
				width = 0;
  8009d1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009d8:	e9 3b ff ff ff       	jmpq   800918 <vprintfmt+0x89>
  8009dd:	e9 36 ff ff ff       	jmpq   800918 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009e2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009e9:	e9 2a ff ff ff       	jmpq   800918 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009ee:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009f2:	79 12                	jns    800a06 <vprintfmt+0x177>
				width = precision, precision = -1;
  8009f4:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009f7:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009fa:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a01:	e9 12 ff ff ff       	jmpq   800918 <vprintfmt+0x89>
  800a06:	e9 0d ff ff ff       	jmpq   800918 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a0b:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a0f:	e9 04 ff ff ff       	jmpq   800918 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a14:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a17:	83 f8 30             	cmp    $0x30,%eax
  800a1a:	73 17                	jae    800a33 <vprintfmt+0x1a4>
  800a1c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a20:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a23:	89 c0                	mov    %eax,%eax
  800a25:	48 01 d0             	add    %rdx,%rax
  800a28:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a2b:	83 c2 08             	add    $0x8,%edx
  800a2e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a31:	eb 0f                	jmp    800a42 <vprintfmt+0x1b3>
  800a33:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a37:	48 89 d0             	mov    %rdx,%rax
  800a3a:	48 83 c2 08          	add    $0x8,%rdx
  800a3e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a42:	8b 10                	mov    (%rax),%edx
  800a44:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a48:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a4c:	48 89 ce             	mov    %rcx,%rsi
  800a4f:	89 d7                	mov    %edx,%edi
  800a51:	ff d0                	callq  *%rax
			break;
  800a53:	e9 53 03 00 00       	jmpq   800dab <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a58:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a5b:	83 f8 30             	cmp    $0x30,%eax
  800a5e:	73 17                	jae    800a77 <vprintfmt+0x1e8>
  800a60:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a64:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a67:	89 c0                	mov    %eax,%eax
  800a69:	48 01 d0             	add    %rdx,%rax
  800a6c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a6f:	83 c2 08             	add    $0x8,%edx
  800a72:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a75:	eb 0f                	jmp    800a86 <vprintfmt+0x1f7>
  800a77:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a7b:	48 89 d0             	mov    %rdx,%rax
  800a7e:	48 83 c2 08          	add    $0x8,%rdx
  800a82:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a86:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a88:	85 db                	test   %ebx,%ebx
  800a8a:	79 02                	jns    800a8e <vprintfmt+0x1ff>
				err = -err;
  800a8c:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a8e:	83 fb 15             	cmp    $0x15,%ebx
  800a91:	7f 16                	jg     800aa9 <vprintfmt+0x21a>
  800a93:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  800a9a:	00 00 00 
  800a9d:	48 63 d3             	movslq %ebx,%rdx
  800aa0:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800aa4:	4d 85 e4             	test   %r12,%r12
  800aa7:	75 2e                	jne    800ad7 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800aa9:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800aad:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ab1:	89 d9                	mov    %ebx,%ecx
  800ab3:	48 ba a1 19 80 00 00 	movabs $0x8019a1,%rdx
  800aba:	00 00 00 
  800abd:	48 89 c7             	mov    %rax,%rdi
  800ac0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac5:	49 b8 ba 0d 80 00 00 	movabs $0x800dba,%r8
  800acc:	00 00 00 
  800acf:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ad2:	e9 d4 02 00 00       	jmpq   800dab <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ad7:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800adb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800adf:	4c 89 e1             	mov    %r12,%rcx
  800ae2:	48 ba aa 19 80 00 00 	movabs $0x8019aa,%rdx
  800ae9:	00 00 00 
  800aec:	48 89 c7             	mov    %rax,%rdi
  800aef:	b8 00 00 00 00       	mov    $0x0,%eax
  800af4:	49 b8 ba 0d 80 00 00 	movabs $0x800dba,%r8
  800afb:	00 00 00 
  800afe:	41 ff d0             	callq  *%r8
			break;
  800b01:	e9 a5 02 00 00       	jmpq   800dab <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b06:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b09:	83 f8 30             	cmp    $0x30,%eax
  800b0c:	73 17                	jae    800b25 <vprintfmt+0x296>
  800b0e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b12:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b15:	89 c0                	mov    %eax,%eax
  800b17:	48 01 d0             	add    %rdx,%rax
  800b1a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b1d:	83 c2 08             	add    $0x8,%edx
  800b20:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b23:	eb 0f                	jmp    800b34 <vprintfmt+0x2a5>
  800b25:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b29:	48 89 d0             	mov    %rdx,%rax
  800b2c:	48 83 c2 08          	add    $0x8,%rdx
  800b30:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b34:	4c 8b 20             	mov    (%rax),%r12
  800b37:	4d 85 e4             	test   %r12,%r12
  800b3a:	75 0a                	jne    800b46 <vprintfmt+0x2b7>
				p = "(null)";
  800b3c:	49 bc ad 19 80 00 00 	movabs $0x8019ad,%r12
  800b43:	00 00 00 
			if (width > 0 && padc != '-')
  800b46:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b4a:	7e 3f                	jle    800b8b <vprintfmt+0x2fc>
  800b4c:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b50:	74 39                	je     800b8b <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b52:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b55:	48 98                	cltq   
  800b57:	48 89 c6             	mov    %rax,%rsi
  800b5a:	4c 89 e7             	mov    %r12,%rdi
  800b5d:	48 b8 66 10 80 00 00 	movabs $0x801066,%rax
  800b64:	00 00 00 
  800b67:	ff d0                	callq  *%rax
  800b69:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b6c:	eb 17                	jmp    800b85 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b6e:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b72:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b76:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b7a:	48 89 ce             	mov    %rcx,%rsi
  800b7d:	89 d7                	mov    %edx,%edi
  800b7f:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b81:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b85:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b89:	7f e3                	jg     800b6e <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b8b:	eb 37                	jmp    800bc4 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b8d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b91:	74 1e                	je     800bb1 <vprintfmt+0x322>
  800b93:	83 fb 1f             	cmp    $0x1f,%ebx
  800b96:	7e 05                	jle    800b9d <vprintfmt+0x30e>
  800b98:	83 fb 7e             	cmp    $0x7e,%ebx
  800b9b:	7e 14                	jle    800bb1 <vprintfmt+0x322>
					putch('?', putdat);
  800b9d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ba1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba5:	48 89 d6             	mov    %rdx,%rsi
  800ba8:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800bad:	ff d0                	callq  *%rax
  800baf:	eb 0f                	jmp    800bc0 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800bb1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bb5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb9:	48 89 d6             	mov    %rdx,%rsi
  800bbc:	89 df                	mov    %ebx,%edi
  800bbe:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bc0:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bc4:	4c 89 e0             	mov    %r12,%rax
  800bc7:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800bcb:	0f b6 00             	movzbl (%rax),%eax
  800bce:	0f be d8             	movsbl %al,%ebx
  800bd1:	85 db                	test   %ebx,%ebx
  800bd3:	74 10                	je     800be5 <vprintfmt+0x356>
  800bd5:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bd9:	78 b2                	js     800b8d <vprintfmt+0x2fe>
  800bdb:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800bdf:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800be3:	79 a8                	jns    800b8d <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800be5:	eb 16                	jmp    800bfd <vprintfmt+0x36e>
				putch(' ', putdat);
  800be7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800beb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bef:	48 89 d6             	mov    %rdx,%rsi
  800bf2:	bf 20 00 00 00       	mov    $0x20,%edi
  800bf7:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bf9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bfd:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c01:	7f e4                	jg     800be7 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800c03:	e9 a3 01 00 00       	jmpq   800dab <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c08:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c0c:	be 03 00 00 00       	mov    $0x3,%esi
  800c11:	48 89 c7             	mov    %rax,%rdi
  800c14:	48 b8 7f 07 80 00 00 	movabs $0x80077f,%rax
  800c1b:	00 00 00 
  800c1e:	ff d0                	callq  *%rax
  800c20:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c28:	48 85 c0             	test   %rax,%rax
  800c2b:	79 1d                	jns    800c4a <vprintfmt+0x3bb>
				putch('-', putdat);
  800c2d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c31:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c35:	48 89 d6             	mov    %rdx,%rsi
  800c38:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c3d:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c43:	48 f7 d8             	neg    %rax
  800c46:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c4a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c51:	e9 e8 00 00 00       	jmpq   800d3e <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c56:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c5a:	be 03 00 00 00       	mov    $0x3,%esi
  800c5f:	48 89 c7             	mov    %rax,%rdi
  800c62:	48 b8 6f 06 80 00 00 	movabs $0x80066f,%rax
  800c69:	00 00 00 
  800c6c:	ff d0                	callq  *%rax
  800c6e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c72:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c79:	e9 c0 00 00 00       	jmpq   800d3e <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c7e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c82:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c86:	48 89 d6             	mov    %rdx,%rsi
  800c89:	bf 58 00 00 00       	mov    $0x58,%edi
  800c8e:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c90:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c94:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c98:	48 89 d6             	mov    %rdx,%rsi
  800c9b:	bf 58 00 00 00       	mov    $0x58,%edi
  800ca0:	ff d0                	callq  *%rax
			putch('X', putdat);
  800ca2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ca6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800caa:	48 89 d6             	mov    %rdx,%rsi
  800cad:	bf 58 00 00 00       	mov    $0x58,%edi
  800cb2:	ff d0                	callq  *%rax
			break;
  800cb4:	e9 f2 00 00 00       	jmpq   800dab <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800cb9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cbd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cc1:	48 89 d6             	mov    %rdx,%rsi
  800cc4:	bf 30 00 00 00       	mov    $0x30,%edi
  800cc9:	ff d0                	callq  *%rax
			putch('x', putdat);
  800ccb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ccf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd3:	48 89 d6             	mov    %rdx,%rsi
  800cd6:	bf 78 00 00 00       	mov    $0x78,%edi
  800cdb:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800cdd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ce0:	83 f8 30             	cmp    $0x30,%eax
  800ce3:	73 17                	jae    800cfc <vprintfmt+0x46d>
  800ce5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ce9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cec:	89 c0                	mov    %eax,%eax
  800cee:	48 01 d0             	add    %rdx,%rax
  800cf1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cf4:	83 c2 08             	add    $0x8,%edx
  800cf7:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cfa:	eb 0f                	jmp    800d0b <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800cfc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d00:	48 89 d0             	mov    %rdx,%rax
  800d03:	48 83 c2 08          	add    $0x8,%rdx
  800d07:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d0b:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d0e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d12:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d19:	eb 23                	jmp    800d3e <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d1b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d1f:	be 03 00 00 00       	mov    $0x3,%esi
  800d24:	48 89 c7             	mov    %rax,%rdi
  800d27:	48 b8 6f 06 80 00 00 	movabs $0x80066f,%rax
  800d2e:	00 00 00 
  800d31:	ff d0                	callq  *%rax
  800d33:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d37:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d3e:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d43:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d46:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d49:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d4d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d51:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d55:	45 89 c1             	mov    %r8d,%r9d
  800d58:	41 89 f8             	mov    %edi,%r8d
  800d5b:	48 89 c7             	mov    %rax,%rdi
  800d5e:	48 b8 b4 05 80 00 00 	movabs $0x8005b4,%rax
  800d65:	00 00 00 
  800d68:	ff d0                	callq  *%rax
			break;
  800d6a:	eb 3f                	jmp    800dab <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d6c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d70:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d74:	48 89 d6             	mov    %rdx,%rsi
  800d77:	89 df                	mov    %ebx,%edi
  800d79:	ff d0                	callq  *%rax
			break;
  800d7b:	eb 2e                	jmp    800dab <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d7d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d81:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d85:	48 89 d6             	mov    %rdx,%rsi
  800d88:	bf 25 00 00 00       	mov    $0x25,%edi
  800d8d:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d8f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d94:	eb 05                	jmp    800d9b <vprintfmt+0x50c>
  800d96:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d9b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d9f:	48 83 e8 01          	sub    $0x1,%rax
  800da3:	0f b6 00             	movzbl (%rax),%eax
  800da6:	3c 25                	cmp    $0x25,%al
  800da8:	75 ec                	jne    800d96 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800daa:	90                   	nop
		}
	}
  800dab:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800dac:	e9 30 fb ff ff       	jmpq   8008e1 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800db1:	48 83 c4 60          	add    $0x60,%rsp
  800db5:	5b                   	pop    %rbx
  800db6:	41 5c                	pop    %r12
  800db8:	5d                   	pop    %rbp
  800db9:	c3                   	retq   

0000000000800dba <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800dba:	55                   	push   %rbp
  800dbb:	48 89 e5             	mov    %rsp,%rbp
  800dbe:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800dc5:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800dcc:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800dd3:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800dda:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800de1:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800de8:	84 c0                	test   %al,%al
  800dea:	74 20                	je     800e0c <printfmt+0x52>
  800dec:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800df0:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800df4:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800df8:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dfc:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e00:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e04:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e08:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e0c:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e13:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e1a:	00 00 00 
  800e1d:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e24:	00 00 00 
  800e27:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e2b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e32:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e39:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e40:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e47:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e4e:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e55:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e5c:	48 89 c7             	mov    %rax,%rdi
  800e5f:	48 b8 8f 08 80 00 00 	movabs $0x80088f,%rax
  800e66:	00 00 00 
  800e69:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e6b:	c9                   	leaveq 
  800e6c:	c3                   	retq   

0000000000800e6d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e6d:	55                   	push   %rbp
  800e6e:	48 89 e5             	mov    %rsp,%rbp
  800e71:	48 83 ec 10          	sub    $0x10,%rsp
  800e75:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e78:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e80:	8b 40 10             	mov    0x10(%rax),%eax
  800e83:	8d 50 01             	lea    0x1(%rax),%edx
  800e86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e8a:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e91:	48 8b 10             	mov    (%rax),%rdx
  800e94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e98:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e9c:	48 39 c2             	cmp    %rax,%rdx
  800e9f:	73 17                	jae    800eb8 <sprintputch+0x4b>
		*b->buf++ = ch;
  800ea1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ea5:	48 8b 00             	mov    (%rax),%rax
  800ea8:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800eac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800eb0:	48 89 0a             	mov    %rcx,(%rdx)
  800eb3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800eb6:	88 10                	mov    %dl,(%rax)
}
  800eb8:	c9                   	leaveq 
  800eb9:	c3                   	retq   

0000000000800eba <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800eba:	55                   	push   %rbp
  800ebb:	48 89 e5             	mov    %rsp,%rbp
  800ebe:	48 83 ec 50          	sub    $0x50,%rsp
  800ec2:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800ec6:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800ec9:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ecd:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ed1:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ed5:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800ed9:	48 8b 0a             	mov    (%rdx),%rcx
  800edc:	48 89 08             	mov    %rcx,(%rax)
  800edf:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ee3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ee7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800eeb:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800eef:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ef3:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ef7:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800efa:	48 98                	cltq   
  800efc:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800f00:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f04:	48 01 d0             	add    %rdx,%rax
  800f07:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f0b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f12:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f17:	74 06                	je     800f1f <vsnprintf+0x65>
  800f19:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f1d:	7f 07                	jg     800f26 <vsnprintf+0x6c>
		return -E_INVAL;
  800f1f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f24:	eb 2f                	jmp    800f55 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f26:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f2a:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f2e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f32:	48 89 c6             	mov    %rax,%rsi
  800f35:	48 bf 6d 0e 80 00 00 	movabs $0x800e6d,%rdi
  800f3c:	00 00 00 
  800f3f:	48 b8 8f 08 80 00 00 	movabs $0x80088f,%rax
  800f46:	00 00 00 
  800f49:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f4b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f4f:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f52:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f55:	c9                   	leaveq 
  800f56:	c3                   	retq   

0000000000800f57 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f57:	55                   	push   %rbp
  800f58:	48 89 e5             	mov    %rsp,%rbp
  800f5b:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f62:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f69:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f6f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f76:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f7d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f84:	84 c0                	test   %al,%al
  800f86:	74 20                	je     800fa8 <snprintf+0x51>
  800f88:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f8c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f90:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f94:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f98:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f9c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fa0:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fa4:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fa8:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800faf:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800fb6:	00 00 00 
  800fb9:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fc0:	00 00 00 
  800fc3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fc7:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fce:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fd5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fdc:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fe3:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fea:	48 8b 0a             	mov    (%rdx),%rcx
  800fed:	48 89 08             	mov    %rcx,(%rax)
  800ff0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ff4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ff8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ffc:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801000:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801007:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80100e:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801014:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80101b:	48 89 c7             	mov    %rax,%rdi
  80101e:	48 b8 ba 0e 80 00 00 	movabs $0x800eba,%rax
  801025:	00 00 00 
  801028:	ff d0                	callq  *%rax
  80102a:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801030:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801036:	c9                   	leaveq 
  801037:	c3                   	retq   

0000000000801038 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801038:	55                   	push   %rbp
  801039:	48 89 e5             	mov    %rsp,%rbp
  80103c:	48 83 ec 18          	sub    $0x18,%rsp
  801040:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801044:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80104b:	eb 09                	jmp    801056 <strlen+0x1e>
		n++;
  80104d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801051:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801056:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80105a:	0f b6 00             	movzbl (%rax),%eax
  80105d:	84 c0                	test   %al,%al
  80105f:	75 ec                	jne    80104d <strlen+0x15>
		n++;
	return n;
  801061:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801064:	c9                   	leaveq 
  801065:	c3                   	retq   

0000000000801066 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801066:	55                   	push   %rbp
  801067:	48 89 e5             	mov    %rsp,%rbp
  80106a:	48 83 ec 20          	sub    $0x20,%rsp
  80106e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801072:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801076:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80107d:	eb 0e                	jmp    80108d <strnlen+0x27>
		n++;
  80107f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801083:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801088:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80108d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801092:	74 0b                	je     80109f <strnlen+0x39>
  801094:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801098:	0f b6 00             	movzbl (%rax),%eax
  80109b:	84 c0                	test   %al,%al
  80109d:	75 e0                	jne    80107f <strnlen+0x19>
		n++;
	return n;
  80109f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010a2:	c9                   	leaveq 
  8010a3:	c3                   	retq   

00000000008010a4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010a4:	55                   	push   %rbp
  8010a5:	48 89 e5             	mov    %rsp,%rbp
  8010a8:	48 83 ec 20          	sub    $0x20,%rsp
  8010ac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010b0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8010b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8010bc:	90                   	nop
  8010bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010c5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010c9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010cd:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010d1:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010d5:	0f b6 12             	movzbl (%rdx),%edx
  8010d8:	88 10                	mov    %dl,(%rax)
  8010da:	0f b6 00             	movzbl (%rax),%eax
  8010dd:	84 c0                	test   %al,%al
  8010df:	75 dc                	jne    8010bd <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010e5:	c9                   	leaveq 
  8010e6:	c3                   	retq   

00000000008010e7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010e7:	55                   	push   %rbp
  8010e8:	48 89 e5             	mov    %rsp,%rbp
  8010eb:	48 83 ec 20          	sub    $0x20,%rsp
  8010ef:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010f3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010fb:	48 89 c7             	mov    %rax,%rdi
  8010fe:	48 b8 38 10 80 00 00 	movabs $0x801038,%rax
  801105:	00 00 00 
  801108:	ff d0                	callq  *%rax
  80110a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80110d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801110:	48 63 d0             	movslq %eax,%rdx
  801113:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801117:	48 01 c2             	add    %rax,%rdx
  80111a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80111e:	48 89 c6             	mov    %rax,%rsi
  801121:	48 89 d7             	mov    %rdx,%rdi
  801124:	48 b8 a4 10 80 00 00 	movabs $0x8010a4,%rax
  80112b:	00 00 00 
  80112e:	ff d0                	callq  *%rax
	return dst;
  801130:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801134:	c9                   	leaveq 
  801135:	c3                   	retq   

0000000000801136 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801136:	55                   	push   %rbp
  801137:	48 89 e5             	mov    %rsp,%rbp
  80113a:	48 83 ec 28          	sub    $0x28,%rsp
  80113e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801142:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801146:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80114a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80114e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801152:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801159:	00 
  80115a:	eb 2a                	jmp    801186 <strncpy+0x50>
		*dst++ = *src;
  80115c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801160:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801164:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801168:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80116c:	0f b6 12             	movzbl (%rdx),%edx
  80116f:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801171:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801175:	0f b6 00             	movzbl (%rax),%eax
  801178:	84 c0                	test   %al,%al
  80117a:	74 05                	je     801181 <strncpy+0x4b>
			src++;
  80117c:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801181:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801186:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80118a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80118e:	72 cc                	jb     80115c <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801190:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801194:	c9                   	leaveq 
  801195:	c3                   	retq   

0000000000801196 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801196:	55                   	push   %rbp
  801197:	48 89 e5             	mov    %rsp,%rbp
  80119a:	48 83 ec 28          	sub    $0x28,%rsp
  80119e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011a2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011a6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8011aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8011b2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011b7:	74 3d                	je     8011f6 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8011b9:	eb 1d                	jmp    8011d8 <strlcpy+0x42>
			*dst++ = *src++;
  8011bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011bf:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011c3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011c7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011cb:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011cf:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011d3:	0f b6 12             	movzbl (%rdx),%edx
  8011d6:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011d8:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011dd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011e2:	74 0b                	je     8011ef <strlcpy+0x59>
  8011e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011e8:	0f b6 00             	movzbl (%rax),%eax
  8011eb:	84 c0                	test   %al,%al
  8011ed:	75 cc                	jne    8011bb <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f3:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011fe:	48 29 c2             	sub    %rax,%rdx
  801201:	48 89 d0             	mov    %rdx,%rax
}
  801204:	c9                   	leaveq 
  801205:	c3                   	retq   

0000000000801206 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801206:	55                   	push   %rbp
  801207:	48 89 e5             	mov    %rsp,%rbp
  80120a:	48 83 ec 10          	sub    $0x10,%rsp
  80120e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801212:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801216:	eb 0a                	jmp    801222 <strcmp+0x1c>
		p++, q++;
  801218:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80121d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801222:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801226:	0f b6 00             	movzbl (%rax),%eax
  801229:	84 c0                	test   %al,%al
  80122b:	74 12                	je     80123f <strcmp+0x39>
  80122d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801231:	0f b6 10             	movzbl (%rax),%edx
  801234:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801238:	0f b6 00             	movzbl (%rax),%eax
  80123b:	38 c2                	cmp    %al,%dl
  80123d:	74 d9                	je     801218 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80123f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801243:	0f b6 00             	movzbl (%rax),%eax
  801246:	0f b6 d0             	movzbl %al,%edx
  801249:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80124d:	0f b6 00             	movzbl (%rax),%eax
  801250:	0f b6 c0             	movzbl %al,%eax
  801253:	29 c2                	sub    %eax,%edx
  801255:	89 d0                	mov    %edx,%eax
}
  801257:	c9                   	leaveq 
  801258:	c3                   	retq   

0000000000801259 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801259:	55                   	push   %rbp
  80125a:	48 89 e5             	mov    %rsp,%rbp
  80125d:	48 83 ec 18          	sub    $0x18,%rsp
  801261:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801265:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801269:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80126d:	eb 0f                	jmp    80127e <strncmp+0x25>
		n--, p++, q++;
  80126f:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801274:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801279:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80127e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801283:	74 1d                	je     8012a2 <strncmp+0x49>
  801285:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801289:	0f b6 00             	movzbl (%rax),%eax
  80128c:	84 c0                	test   %al,%al
  80128e:	74 12                	je     8012a2 <strncmp+0x49>
  801290:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801294:	0f b6 10             	movzbl (%rax),%edx
  801297:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80129b:	0f b6 00             	movzbl (%rax),%eax
  80129e:	38 c2                	cmp    %al,%dl
  8012a0:	74 cd                	je     80126f <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8012a2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012a7:	75 07                	jne    8012b0 <strncmp+0x57>
		return 0;
  8012a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ae:	eb 18                	jmp    8012c8 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b4:	0f b6 00             	movzbl (%rax),%eax
  8012b7:	0f b6 d0             	movzbl %al,%edx
  8012ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012be:	0f b6 00             	movzbl (%rax),%eax
  8012c1:	0f b6 c0             	movzbl %al,%eax
  8012c4:	29 c2                	sub    %eax,%edx
  8012c6:	89 d0                	mov    %edx,%eax
}
  8012c8:	c9                   	leaveq 
  8012c9:	c3                   	retq   

00000000008012ca <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012ca:	55                   	push   %rbp
  8012cb:	48 89 e5             	mov    %rsp,%rbp
  8012ce:	48 83 ec 0c          	sub    $0xc,%rsp
  8012d2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012d6:	89 f0                	mov    %esi,%eax
  8012d8:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012db:	eb 17                	jmp    8012f4 <strchr+0x2a>
		if (*s == c)
  8012dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e1:	0f b6 00             	movzbl (%rax),%eax
  8012e4:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012e7:	75 06                	jne    8012ef <strchr+0x25>
			return (char *) s;
  8012e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ed:	eb 15                	jmp    801304 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012ef:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f8:	0f b6 00             	movzbl (%rax),%eax
  8012fb:	84 c0                	test   %al,%al
  8012fd:	75 de                	jne    8012dd <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801304:	c9                   	leaveq 
  801305:	c3                   	retq   

0000000000801306 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801306:	55                   	push   %rbp
  801307:	48 89 e5             	mov    %rsp,%rbp
  80130a:	48 83 ec 0c          	sub    $0xc,%rsp
  80130e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801312:	89 f0                	mov    %esi,%eax
  801314:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801317:	eb 13                	jmp    80132c <strfind+0x26>
		if (*s == c)
  801319:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80131d:	0f b6 00             	movzbl (%rax),%eax
  801320:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801323:	75 02                	jne    801327 <strfind+0x21>
			break;
  801325:	eb 10                	jmp    801337 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801327:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80132c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801330:	0f b6 00             	movzbl (%rax),%eax
  801333:	84 c0                	test   %al,%al
  801335:	75 e2                	jne    801319 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801337:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80133b:	c9                   	leaveq 
  80133c:	c3                   	retq   

000000000080133d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80133d:	55                   	push   %rbp
  80133e:	48 89 e5             	mov    %rsp,%rbp
  801341:	48 83 ec 18          	sub    $0x18,%rsp
  801345:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801349:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80134c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801350:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801355:	75 06                	jne    80135d <memset+0x20>
		return v;
  801357:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80135b:	eb 69                	jmp    8013c6 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80135d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801361:	83 e0 03             	and    $0x3,%eax
  801364:	48 85 c0             	test   %rax,%rax
  801367:	75 48                	jne    8013b1 <memset+0x74>
  801369:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80136d:	83 e0 03             	and    $0x3,%eax
  801370:	48 85 c0             	test   %rax,%rax
  801373:	75 3c                	jne    8013b1 <memset+0x74>
		c &= 0xFF;
  801375:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80137c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80137f:	c1 e0 18             	shl    $0x18,%eax
  801382:	89 c2                	mov    %eax,%edx
  801384:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801387:	c1 e0 10             	shl    $0x10,%eax
  80138a:	09 c2                	or     %eax,%edx
  80138c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80138f:	c1 e0 08             	shl    $0x8,%eax
  801392:	09 d0                	or     %edx,%eax
  801394:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801397:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80139b:	48 c1 e8 02          	shr    $0x2,%rax
  80139f:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8013a2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013a6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013a9:	48 89 d7             	mov    %rdx,%rdi
  8013ac:	fc                   	cld    
  8013ad:	f3 ab                	rep stos %eax,%es:(%rdi)
  8013af:	eb 11                	jmp    8013c2 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013b1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013b5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013b8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013bc:	48 89 d7             	mov    %rdx,%rdi
  8013bf:	fc                   	cld    
  8013c0:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8013c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013c6:	c9                   	leaveq 
  8013c7:	c3                   	retq   

00000000008013c8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013c8:	55                   	push   %rbp
  8013c9:	48 89 e5             	mov    %rsp,%rbp
  8013cc:	48 83 ec 28          	sub    $0x28,%rsp
  8013d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013d4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013d8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013e0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f0:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013f4:	0f 83 88 00 00 00    	jae    801482 <memmove+0xba>
  8013fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013fe:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801402:	48 01 d0             	add    %rdx,%rax
  801405:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801409:	76 77                	jbe    801482 <memmove+0xba>
		s += n;
  80140b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140f:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801413:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801417:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80141b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80141f:	83 e0 03             	and    $0x3,%eax
  801422:	48 85 c0             	test   %rax,%rax
  801425:	75 3b                	jne    801462 <memmove+0x9a>
  801427:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80142b:	83 e0 03             	and    $0x3,%eax
  80142e:	48 85 c0             	test   %rax,%rax
  801431:	75 2f                	jne    801462 <memmove+0x9a>
  801433:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801437:	83 e0 03             	and    $0x3,%eax
  80143a:	48 85 c0             	test   %rax,%rax
  80143d:	75 23                	jne    801462 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80143f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801443:	48 83 e8 04          	sub    $0x4,%rax
  801447:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80144b:	48 83 ea 04          	sub    $0x4,%rdx
  80144f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801453:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801457:	48 89 c7             	mov    %rax,%rdi
  80145a:	48 89 d6             	mov    %rdx,%rsi
  80145d:	fd                   	std    
  80145e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801460:	eb 1d                	jmp    80147f <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801462:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801466:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80146a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80146e:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801472:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801476:	48 89 d7             	mov    %rdx,%rdi
  801479:	48 89 c1             	mov    %rax,%rcx
  80147c:	fd                   	std    
  80147d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80147f:	fc                   	cld    
  801480:	eb 57                	jmp    8014d9 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801482:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801486:	83 e0 03             	and    $0x3,%eax
  801489:	48 85 c0             	test   %rax,%rax
  80148c:	75 36                	jne    8014c4 <memmove+0xfc>
  80148e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801492:	83 e0 03             	and    $0x3,%eax
  801495:	48 85 c0             	test   %rax,%rax
  801498:	75 2a                	jne    8014c4 <memmove+0xfc>
  80149a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149e:	83 e0 03             	and    $0x3,%eax
  8014a1:	48 85 c0             	test   %rax,%rax
  8014a4:	75 1e                	jne    8014c4 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8014a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014aa:	48 c1 e8 02          	shr    $0x2,%rax
  8014ae:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8014b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014b9:	48 89 c7             	mov    %rax,%rdi
  8014bc:	48 89 d6             	mov    %rdx,%rsi
  8014bf:	fc                   	cld    
  8014c0:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014c2:	eb 15                	jmp    8014d9 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8014c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014cc:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014d0:	48 89 c7             	mov    %rax,%rdi
  8014d3:	48 89 d6             	mov    %rdx,%rsi
  8014d6:	fc                   	cld    
  8014d7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014dd:	c9                   	leaveq 
  8014de:	c3                   	retq   

00000000008014df <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014df:	55                   	push   %rbp
  8014e0:	48 89 e5             	mov    %rsp,%rbp
  8014e3:	48 83 ec 18          	sub    $0x18,%rsp
  8014e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014eb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014ef:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014f7:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ff:	48 89 ce             	mov    %rcx,%rsi
  801502:	48 89 c7             	mov    %rax,%rdi
  801505:	48 b8 c8 13 80 00 00 	movabs $0x8013c8,%rax
  80150c:	00 00 00 
  80150f:	ff d0                	callq  *%rax
}
  801511:	c9                   	leaveq 
  801512:	c3                   	retq   

0000000000801513 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801513:	55                   	push   %rbp
  801514:	48 89 e5             	mov    %rsp,%rbp
  801517:	48 83 ec 28          	sub    $0x28,%rsp
  80151b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80151f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801523:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801527:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80152b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80152f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801533:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801537:	eb 36                	jmp    80156f <memcmp+0x5c>
		if (*s1 != *s2)
  801539:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80153d:	0f b6 10             	movzbl (%rax),%edx
  801540:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801544:	0f b6 00             	movzbl (%rax),%eax
  801547:	38 c2                	cmp    %al,%dl
  801549:	74 1a                	je     801565 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80154b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80154f:	0f b6 00             	movzbl (%rax),%eax
  801552:	0f b6 d0             	movzbl %al,%edx
  801555:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801559:	0f b6 00             	movzbl (%rax),%eax
  80155c:	0f b6 c0             	movzbl %al,%eax
  80155f:	29 c2                	sub    %eax,%edx
  801561:	89 d0                	mov    %edx,%eax
  801563:	eb 20                	jmp    801585 <memcmp+0x72>
		s1++, s2++;
  801565:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80156a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80156f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801573:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801577:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80157b:	48 85 c0             	test   %rax,%rax
  80157e:	75 b9                	jne    801539 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801580:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801585:	c9                   	leaveq 
  801586:	c3                   	retq   

0000000000801587 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801587:	55                   	push   %rbp
  801588:	48 89 e5             	mov    %rsp,%rbp
  80158b:	48 83 ec 28          	sub    $0x28,%rsp
  80158f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801593:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801596:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80159a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015a2:	48 01 d0             	add    %rdx,%rax
  8015a5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8015a9:	eb 15                	jmp    8015c0 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015af:	0f b6 10             	movzbl (%rax),%edx
  8015b2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8015b5:	38 c2                	cmp    %al,%dl
  8015b7:	75 02                	jne    8015bb <memfind+0x34>
			break;
  8015b9:	eb 0f                	jmp    8015ca <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015bb:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015c4:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8015c8:	72 e1                	jb     8015ab <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8015ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015ce:	c9                   	leaveq 
  8015cf:	c3                   	retq   

00000000008015d0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015d0:	55                   	push   %rbp
  8015d1:	48 89 e5             	mov    %rsp,%rbp
  8015d4:	48 83 ec 34          	sub    $0x34,%rsp
  8015d8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015dc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015e0:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015ea:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015f1:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015f2:	eb 05                	jmp    8015f9 <strtol+0x29>
		s++;
  8015f4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fd:	0f b6 00             	movzbl (%rax),%eax
  801600:	3c 20                	cmp    $0x20,%al
  801602:	74 f0                	je     8015f4 <strtol+0x24>
  801604:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801608:	0f b6 00             	movzbl (%rax),%eax
  80160b:	3c 09                	cmp    $0x9,%al
  80160d:	74 e5                	je     8015f4 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80160f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801613:	0f b6 00             	movzbl (%rax),%eax
  801616:	3c 2b                	cmp    $0x2b,%al
  801618:	75 07                	jne    801621 <strtol+0x51>
		s++;
  80161a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80161f:	eb 17                	jmp    801638 <strtol+0x68>
	else if (*s == '-')
  801621:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801625:	0f b6 00             	movzbl (%rax),%eax
  801628:	3c 2d                	cmp    $0x2d,%al
  80162a:	75 0c                	jne    801638 <strtol+0x68>
		s++, neg = 1;
  80162c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801631:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801638:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80163c:	74 06                	je     801644 <strtol+0x74>
  80163e:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801642:	75 28                	jne    80166c <strtol+0x9c>
  801644:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801648:	0f b6 00             	movzbl (%rax),%eax
  80164b:	3c 30                	cmp    $0x30,%al
  80164d:	75 1d                	jne    80166c <strtol+0x9c>
  80164f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801653:	48 83 c0 01          	add    $0x1,%rax
  801657:	0f b6 00             	movzbl (%rax),%eax
  80165a:	3c 78                	cmp    $0x78,%al
  80165c:	75 0e                	jne    80166c <strtol+0x9c>
		s += 2, base = 16;
  80165e:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801663:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80166a:	eb 2c                	jmp    801698 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80166c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801670:	75 19                	jne    80168b <strtol+0xbb>
  801672:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801676:	0f b6 00             	movzbl (%rax),%eax
  801679:	3c 30                	cmp    $0x30,%al
  80167b:	75 0e                	jne    80168b <strtol+0xbb>
		s++, base = 8;
  80167d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801682:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801689:	eb 0d                	jmp    801698 <strtol+0xc8>
	else if (base == 0)
  80168b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80168f:	75 07                	jne    801698 <strtol+0xc8>
		base = 10;
  801691:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801698:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169c:	0f b6 00             	movzbl (%rax),%eax
  80169f:	3c 2f                	cmp    $0x2f,%al
  8016a1:	7e 1d                	jle    8016c0 <strtol+0xf0>
  8016a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a7:	0f b6 00             	movzbl (%rax),%eax
  8016aa:	3c 39                	cmp    $0x39,%al
  8016ac:	7f 12                	jg     8016c0 <strtol+0xf0>
			dig = *s - '0';
  8016ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b2:	0f b6 00             	movzbl (%rax),%eax
  8016b5:	0f be c0             	movsbl %al,%eax
  8016b8:	83 e8 30             	sub    $0x30,%eax
  8016bb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016be:	eb 4e                	jmp    80170e <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8016c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c4:	0f b6 00             	movzbl (%rax),%eax
  8016c7:	3c 60                	cmp    $0x60,%al
  8016c9:	7e 1d                	jle    8016e8 <strtol+0x118>
  8016cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cf:	0f b6 00             	movzbl (%rax),%eax
  8016d2:	3c 7a                	cmp    $0x7a,%al
  8016d4:	7f 12                	jg     8016e8 <strtol+0x118>
			dig = *s - 'a' + 10;
  8016d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016da:	0f b6 00             	movzbl (%rax),%eax
  8016dd:	0f be c0             	movsbl %al,%eax
  8016e0:	83 e8 57             	sub    $0x57,%eax
  8016e3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016e6:	eb 26                	jmp    80170e <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ec:	0f b6 00             	movzbl (%rax),%eax
  8016ef:	3c 40                	cmp    $0x40,%al
  8016f1:	7e 48                	jle    80173b <strtol+0x16b>
  8016f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f7:	0f b6 00             	movzbl (%rax),%eax
  8016fa:	3c 5a                	cmp    $0x5a,%al
  8016fc:	7f 3d                	jg     80173b <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801702:	0f b6 00             	movzbl (%rax),%eax
  801705:	0f be c0             	movsbl %al,%eax
  801708:	83 e8 37             	sub    $0x37,%eax
  80170b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80170e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801711:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801714:	7c 02                	jl     801718 <strtol+0x148>
			break;
  801716:	eb 23                	jmp    80173b <strtol+0x16b>
		s++, val = (val * base) + dig;
  801718:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80171d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801720:	48 98                	cltq   
  801722:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801727:	48 89 c2             	mov    %rax,%rdx
  80172a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80172d:	48 98                	cltq   
  80172f:	48 01 d0             	add    %rdx,%rax
  801732:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801736:	e9 5d ff ff ff       	jmpq   801698 <strtol+0xc8>

	if (endptr)
  80173b:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801740:	74 0b                	je     80174d <strtol+0x17d>
		*endptr = (char *) s;
  801742:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801746:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80174a:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80174d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801751:	74 09                	je     80175c <strtol+0x18c>
  801753:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801757:	48 f7 d8             	neg    %rax
  80175a:	eb 04                	jmp    801760 <strtol+0x190>
  80175c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801760:	c9                   	leaveq 
  801761:	c3                   	retq   

0000000000801762 <strstr>:

char * strstr(const char *in, const char *str)
{
  801762:	55                   	push   %rbp
  801763:	48 89 e5             	mov    %rsp,%rbp
  801766:	48 83 ec 30          	sub    $0x30,%rsp
  80176a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80176e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801772:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801776:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80177a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80177e:	0f b6 00             	movzbl (%rax),%eax
  801781:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801784:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801788:	75 06                	jne    801790 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80178a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178e:	eb 6b                	jmp    8017fb <strstr+0x99>

	len = strlen(str);
  801790:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801794:	48 89 c7             	mov    %rax,%rdi
  801797:	48 b8 38 10 80 00 00 	movabs $0x801038,%rax
  80179e:	00 00 00 
  8017a1:	ff d0                	callq  *%rax
  8017a3:	48 98                	cltq   
  8017a5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8017a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ad:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017b1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017b5:	0f b6 00             	movzbl (%rax),%eax
  8017b8:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8017bb:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8017bf:	75 07                	jne    8017c8 <strstr+0x66>
				return (char *) 0;
  8017c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c6:	eb 33                	jmp    8017fb <strstr+0x99>
		} while (sc != c);
  8017c8:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8017cc:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8017cf:	75 d8                	jne    8017a9 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8017d1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017d5:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017dd:	48 89 ce             	mov    %rcx,%rsi
  8017e0:	48 89 c7             	mov    %rax,%rdi
  8017e3:	48 b8 59 12 80 00 00 	movabs $0x801259,%rax
  8017ea:	00 00 00 
  8017ed:	ff d0                	callq  *%rax
  8017ef:	85 c0                	test   %eax,%eax
  8017f1:	75 b6                	jne    8017a9 <strstr+0x47>

	return (char *) (in - 1);
  8017f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f7:	48 83 e8 01          	sub    $0x1,%rax
}
  8017fb:	c9                   	leaveq 
  8017fc:	c3                   	retq   
