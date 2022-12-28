
obj/user/evilhello:     file format elf64-x86-64


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
  80003c:	e8 2e 00 00 00       	callq  80006f <libmain>
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
	// try to print the kernel entry point as a string!  mua ha ha!
	sys_cputs((char*)0x800420000c, 100);
  800052:	be 64 00 00 00       	mov    $0x64,%esi
  800057:	48 bf 0c 00 20 04 80 	movabs $0x800420000c,%rdi
  80005e:	00 00 00 
  800061:	48 b8 9e 01 80 00 00 	movabs $0x80019e,%rax
  800068:	00 00 00 
  80006b:	ff d0                	callq  *%rax
}
  80006d:	c9                   	leaveq 
  80006e:	c3                   	retq   

000000000080006f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80006f:	55                   	push   %rbp
  800070:	48 89 e5             	mov    %rsp,%rbp
  800073:	48 83 ec 10          	sub    $0x10,%rsp
  800077:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80007a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	thisenv = &envs[ENVX(sys_getenvid())];
  80007e:	48 b8 6a 02 80 00 00 	movabs $0x80026a,%rax
  800085:	00 00 00 
  800088:	ff d0                	callq  *%rax
  80008a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80008f:	48 98                	cltq   
  800091:	48 c1 e0 03          	shl    $0x3,%rax
  800095:	48 89 c2             	mov    %rax,%rdx
  800098:	48 c1 e2 05          	shl    $0x5,%rdx
  80009c:	48 29 c2             	sub    %rax,%rdx
  80009f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000a6:	00 00 00 
  8000a9:	48 01 c2             	add    %rax,%rdx
  8000ac:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000b3:	00 00 00 
  8000b6:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000bd:	7e 14                	jle    8000d3 <libmain+0x64>
		binaryname = argv[0];
  8000bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000c3:	48 8b 10             	mov    (%rax),%rdx
  8000c6:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000cd:	00 00 00 
  8000d0:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000d3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000da:	48 89 d6             	mov    %rdx,%rsi
  8000dd:	89 c7                	mov    %eax,%edi
  8000df:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000e6:	00 00 00 
  8000e9:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000eb:	48 b8 f9 00 80 00 00 	movabs $0x8000f9,%rax
  8000f2:	00 00 00 
  8000f5:	ff d0                	callq  *%rax
}
  8000f7:	c9                   	leaveq 
  8000f8:	c3                   	retq   

00000000008000f9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000f9:	55                   	push   %rbp
  8000fa:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8000fd:	bf 00 00 00 00       	mov    $0x0,%edi
  800102:	48 b8 26 02 80 00 00 	movabs $0x800226,%rax
  800109:	00 00 00 
  80010c:	ff d0                	callq  *%rax
}
  80010e:	5d                   	pop    %rbp
  80010f:	c3                   	retq   

0000000000800110 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800110:	55                   	push   %rbp
  800111:	48 89 e5             	mov    %rsp,%rbp
  800114:	53                   	push   %rbx
  800115:	48 83 ec 48          	sub    $0x48,%rsp
  800119:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80011c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80011f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800123:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800127:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80012b:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80012f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800132:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800136:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80013a:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80013e:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800142:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800146:	4c 89 c3             	mov    %r8,%rbx
  800149:	cd 30                	int    $0x30
  80014b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80014f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800153:	74 3e                	je     800193 <syscall+0x83>
  800155:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80015a:	7e 37                	jle    800193 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80015c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800160:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800163:	49 89 d0             	mov    %rdx,%r8
  800166:	89 c1                	mov    %eax,%ecx
  800168:	48 ba 2a 18 80 00 00 	movabs $0x80182a,%rdx
  80016f:	00 00 00 
  800172:	be 23 00 00 00       	mov    $0x23,%esi
  800177:	48 bf 47 18 80 00 00 	movabs $0x801847,%rdi
  80017e:	00 00 00 
  800181:	b8 00 00 00 00       	mov    $0x0,%eax
  800186:	49 b9 a8 02 80 00 00 	movabs $0x8002a8,%r9
  80018d:	00 00 00 
  800190:	41 ff d1             	callq  *%r9

	return ret;
  800193:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800197:	48 83 c4 48          	add    $0x48,%rsp
  80019b:	5b                   	pop    %rbx
  80019c:	5d                   	pop    %rbp
  80019d:	c3                   	retq   

000000000080019e <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80019e:	55                   	push   %rbp
  80019f:	48 89 e5             	mov    %rsp,%rbp
  8001a2:	48 83 ec 20          	sub    $0x20,%rsp
  8001a6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001aa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001b2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001b6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001bd:	00 
  8001be:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001c4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001ca:	48 89 d1             	mov    %rdx,%rcx
  8001cd:	48 89 c2             	mov    %rax,%rdx
  8001d0:	be 00 00 00 00       	mov    $0x0,%esi
  8001d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8001da:	48 b8 10 01 80 00 00 	movabs $0x800110,%rax
  8001e1:	00 00 00 
  8001e4:	ff d0                	callq  *%rax
}
  8001e6:	c9                   	leaveq 
  8001e7:	c3                   	retq   

00000000008001e8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8001e8:	55                   	push   %rbp
  8001e9:	48 89 e5             	mov    %rsp,%rbp
  8001ec:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001f0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001f7:	00 
  8001f8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001fe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800204:	b9 00 00 00 00       	mov    $0x0,%ecx
  800209:	ba 00 00 00 00       	mov    $0x0,%edx
  80020e:	be 00 00 00 00       	mov    $0x0,%esi
  800213:	bf 01 00 00 00       	mov    $0x1,%edi
  800218:	48 b8 10 01 80 00 00 	movabs $0x800110,%rax
  80021f:	00 00 00 
  800222:	ff d0                	callq  *%rax
}
  800224:	c9                   	leaveq 
  800225:	c3                   	retq   

0000000000800226 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800226:	55                   	push   %rbp
  800227:	48 89 e5             	mov    %rsp,%rbp
  80022a:	48 83 ec 10          	sub    $0x10,%rsp
  80022e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800231:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800234:	48 98                	cltq   
  800236:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80023d:	00 
  80023e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800244:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80024a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80024f:	48 89 c2             	mov    %rax,%rdx
  800252:	be 01 00 00 00       	mov    $0x1,%esi
  800257:	bf 03 00 00 00       	mov    $0x3,%edi
  80025c:	48 b8 10 01 80 00 00 	movabs $0x800110,%rax
  800263:	00 00 00 
  800266:	ff d0                	callq  *%rax
}
  800268:	c9                   	leaveq 
  800269:	c3                   	retq   

000000000080026a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80026a:	55                   	push   %rbp
  80026b:	48 89 e5             	mov    %rsp,%rbp
  80026e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800272:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800279:	00 
  80027a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800280:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800286:	b9 00 00 00 00       	mov    $0x0,%ecx
  80028b:	ba 00 00 00 00       	mov    $0x0,%edx
  800290:	be 00 00 00 00       	mov    $0x0,%esi
  800295:	bf 02 00 00 00       	mov    $0x2,%edi
  80029a:	48 b8 10 01 80 00 00 	movabs $0x800110,%rax
  8002a1:	00 00 00 
  8002a4:	ff d0                	callq  *%rax
}
  8002a6:	c9                   	leaveq 
  8002a7:	c3                   	retq   

00000000008002a8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002a8:	55                   	push   %rbp
  8002a9:	48 89 e5             	mov    %rsp,%rbp
  8002ac:	53                   	push   %rbx
  8002ad:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8002b4:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8002bb:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8002c1:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8002c8:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8002cf:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8002d6:	84 c0                	test   %al,%al
  8002d8:	74 23                	je     8002fd <_panic+0x55>
  8002da:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8002e1:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002e5:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002e9:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002ed:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002f1:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002f5:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002f9:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002fd:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800304:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80030b:	00 00 00 
  80030e:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800315:	00 00 00 
  800318:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80031c:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800323:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80032a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800331:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  800338:	00 00 00 
  80033b:	48 8b 18             	mov    (%rax),%rbx
  80033e:	48 b8 6a 02 80 00 00 	movabs $0x80026a,%rax
  800345:	00 00 00 
  800348:	ff d0                	callq  *%rax
  80034a:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800350:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800357:	41 89 c8             	mov    %ecx,%r8d
  80035a:	48 89 d1             	mov    %rdx,%rcx
  80035d:	48 89 da             	mov    %rbx,%rdx
  800360:	89 c6                	mov    %eax,%esi
  800362:	48 bf 58 18 80 00 00 	movabs $0x801858,%rdi
  800369:	00 00 00 
  80036c:	b8 00 00 00 00       	mov    $0x0,%eax
  800371:	49 b9 e1 04 80 00 00 	movabs $0x8004e1,%r9
  800378:	00 00 00 
  80037b:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80037e:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800385:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80038c:	48 89 d6             	mov    %rdx,%rsi
  80038f:	48 89 c7             	mov    %rax,%rdi
  800392:	48 b8 35 04 80 00 00 	movabs $0x800435,%rax
  800399:	00 00 00 
  80039c:	ff d0                	callq  *%rax
	cprintf("\n");
  80039e:	48 bf 7b 18 80 00 00 	movabs $0x80187b,%rdi
  8003a5:	00 00 00 
  8003a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ad:	48 ba e1 04 80 00 00 	movabs $0x8004e1,%rdx
  8003b4:	00 00 00 
  8003b7:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003b9:	cc                   	int3   
  8003ba:	eb fd                	jmp    8003b9 <_panic+0x111>

00000000008003bc <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8003bc:	55                   	push   %rbp
  8003bd:	48 89 e5             	mov    %rsp,%rbp
  8003c0:	48 83 ec 10          	sub    $0x10,%rsp
  8003c4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003c7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8003cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003cf:	8b 00                	mov    (%rax),%eax
  8003d1:	8d 48 01             	lea    0x1(%rax),%ecx
  8003d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003d8:	89 0a                	mov    %ecx,(%rdx)
  8003da:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003dd:	89 d1                	mov    %edx,%ecx
  8003df:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003e3:	48 98                	cltq   
  8003e5:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8003e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ed:	8b 00                	mov    (%rax),%eax
  8003ef:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003f4:	75 2c                	jne    800422 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003fa:	8b 00                	mov    (%rax),%eax
  8003fc:	48 98                	cltq   
  8003fe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800402:	48 83 c2 08          	add    $0x8,%rdx
  800406:	48 89 c6             	mov    %rax,%rsi
  800409:	48 89 d7             	mov    %rdx,%rdi
  80040c:	48 b8 9e 01 80 00 00 	movabs $0x80019e,%rax
  800413:	00 00 00 
  800416:	ff d0                	callq  *%rax
        b->idx = 0;
  800418:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80041c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800422:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800426:	8b 40 04             	mov    0x4(%rax),%eax
  800429:	8d 50 01             	lea    0x1(%rax),%edx
  80042c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800430:	89 50 04             	mov    %edx,0x4(%rax)
}
  800433:	c9                   	leaveq 
  800434:	c3                   	retq   

0000000000800435 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800435:	55                   	push   %rbp
  800436:	48 89 e5             	mov    %rsp,%rbp
  800439:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800440:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800447:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80044e:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800455:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80045c:	48 8b 0a             	mov    (%rdx),%rcx
  80045f:	48 89 08             	mov    %rcx,(%rax)
  800462:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800466:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80046a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80046e:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800472:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800479:	00 00 00 
    b.cnt = 0;
  80047c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800483:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800486:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80048d:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800494:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80049b:	48 89 c6             	mov    %rax,%rsi
  80049e:	48 bf bc 03 80 00 00 	movabs $0x8003bc,%rdi
  8004a5:	00 00 00 
  8004a8:	48 b8 94 08 80 00 00 	movabs $0x800894,%rax
  8004af:	00 00 00 
  8004b2:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8004b4:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8004ba:	48 98                	cltq   
  8004bc:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8004c3:	48 83 c2 08          	add    $0x8,%rdx
  8004c7:	48 89 c6             	mov    %rax,%rsi
  8004ca:	48 89 d7             	mov    %rdx,%rdi
  8004cd:	48 b8 9e 01 80 00 00 	movabs $0x80019e,%rax
  8004d4:	00 00 00 
  8004d7:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8004d9:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004df:	c9                   	leaveq 
  8004e0:	c3                   	retq   

00000000008004e1 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8004e1:	55                   	push   %rbp
  8004e2:	48 89 e5             	mov    %rsp,%rbp
  8004e5:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004ec:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004f3:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004fa:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800501:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800508:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80050f:	84 c0                	test   %al,%al
  800511:	74 20                	je     800533 <cprintf+0x52>
  800513:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800517:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80051b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80051f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800523:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800527:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80052b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80052f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800533:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80053a:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800541:	00 00 00 
  800544:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80054b:	00 00 00 
  80054e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800552:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800559:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800560:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800567:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80056e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800575:	48 8b 0a             	mov    (%rdx),%rcx
  800578:	48 89 08             	mov    %rcx,(%rax)
  80057b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80057f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800583:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800587:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80058b:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800592:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800599:	48 89 d6             	mov    %rdx,%rsi
  80059c:	48 89 c7             	mov    %rax,%rdi
  80059f:	48 b8 35 04 80 00 00 	movabs $0x800435,%rax
  8005a6:	00 00 00 
  8005a9:	ff d0                	callq  *%rax
  8005ab:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8005b1:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8005b7:	c9                   	leaveq 
  8005b8:	c3                   	retq   

00000000008005b9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005b9:	55                   	push   %rbp
  8005ba:	48 89 e5             	mov    %rsp,%rbp
  8005bd:	53                   	push   %rbx
  8005be:	48 83 ec 38          	sub    $0x38,%rsp
  8005c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8005ca:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8005ce:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8005d1:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8005d5:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005d9:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8005dc:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8005e0:	77 3b                	ja     80061d <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005e2:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8005e5:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005e9:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8005ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f5:	48 f7 f3             	div    %rbx
  8005f8:	48 89 c2             	mov    %rax,%rdx
  8005fb:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005fe:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800601:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800605:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800609:	41 89 f9             	mov    %edi,%r9d
  80060c:	48 89 c7             	mov    %rax,%rdi
  80060f:	48 b8 b9 05 80 00 00 	movabs $0x8005b9,%rax
  800616:	00 00 00 
  800619:	ff d0                	callq  *%rax
  80061b:	eb 1e                	jmp    80063b <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80061d:	eb 12                	jmp    800631 <printnum+0x78>
			putch(padc, putdat);
  80061f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800623:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800626:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80062a:	48 89 ce             	mov    %rcx,%rsi
  80062d:	89 d7                	mov    %edx,%edi
  80062f:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800631:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800635:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800639:	7f e4                	jg     80061f <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80063b:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80063e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800642:	ba 00 00 00 00       	mov    $0x0,%edx
  800647:	48 f7 f1             	div    %rcx
  80064a:	48 89 d0             	mov    %rdx,%rax
  80064d:	48 ba b0 19 80 00 00 	movabs $0x8019b0,%rdx
  800654:	00 00 00 
  800657:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80065b:	0f be d0             	movsbl %al,%edx
  80065e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800662:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800666:	48 89 ce             	mov    %rcx,%rsi
  800669:	89 d7                	mov    %edx,%edi
  80066b:	ff d0                	callq  *%rax
}
  80066d:	48 83 c4 38          	add    $0x38,%rsp
  800671:	5b                   	pop    %rbx
  800672:	5d                   	pop    %rbp
  800673:	c3                   	retq   

0000000000800674 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800674:	55                   	push   %rbp
  800675:	48 89 e5             	mov    %rsp,%rbp
  800678:	48 83 ec 1c          	sub    $0x1c,%rsp
  80067c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800680:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800683:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800687:	7e 52                	jle    8006db <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800689:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068d:	8b 00                	mov    (%rax),%eax
  80068f:	83 f8 30             	cmp    $0x30,%eax
  800692:	73 24                	jae    8006b8 <getuint+0x44>
  800694:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800698:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80069c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a0:	8b 00                	mov    (%rax),%eax
  8006a2:	89 c0                	mov    %eax,%eax
  8006a4:	48 01 d0             	add    %rdx,%rax
  8006a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ab:	8b 12                	mov    (%rdx),%edx
  8006ad:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b4:	89 0a                	mov    %ecx,(%rdx)
  8006b6:	eb 17                	jmp    8006cf <getuint+0x5b>
  8006b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006c0:	48 89 d0             	mov    %rdx,%rax
  8006c3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006cb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006cf:	48 8b 00             	mov    (%rax),%rax
  8006d2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006d6:	e9 a3 00 00 00       	jmpq   80077e <getuint+0x10a>
	else if (lflag)
  8006db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006df:	74 4f                	je     800730 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8006e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e5:	8b 00                	mov    (%rax),%eax
  8006e7:	83 f8 30             	cmp    $0x30,%eax
  8006ea:	73 24                	jae    800710 <getuint+0x9c>
  8006ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f8:	8b 00                	mov    (%rax),%eax
  8006fa:	89 c0                	mov    %eax,%eax
  8006fc:	48 01 d0             	add    %rdx,%rax
  8006ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800703:	8b 12                	mov    (%rdx),%edx
  800705:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800708:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070c:	89 0a                	mov    %ecx,(%rdx)
  80070e:	eb 17                	jmp    800727 <getuint+0xb3>
  800710:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800714:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800718:	48 89 d0             	mov    %rdx,%rax
  80071b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80071f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800723:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800727:	48 8b 00             	mov    (%rax),%rax
  80072a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80072e:	eb 4e                	jmp    80077e <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800730:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800734:	8b 00                	mov    (%rax),%eax
  800736:	83 f8 30             	cmp    $0x30,%eax
  800739:	73 24                	jae    80075f <getuint+0xeb>
  80073b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800743:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800747:	8b 00                	mov    (%rax),%eax
  800749:	89 c0                	mov    %eax,%eax
  80074b:	48 01 d0             	add    %rdx,%rax
  80074e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800752:	8b 12                	mov    (%rdx),%edx
  800754:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800757:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80075b:	89 0a                	mov    %ecx,(%rdx)
  80075d:	eb 17                	jmp    800776 <getuint+0x102>
  80075f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800763:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800767:	48 89 d0             	mov    %rdx,%rax
  80076a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80076e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800772:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800776:	8b 00                	mov    (%rax),%eax
  800778:	89 c0                	mov    %eax,%eax
  80077a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80077e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800782:	c9                   	leaveq 
  800783:	c3                   	retq   

0000000000800784 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800784:	55                   	push   %rbp
  800785:	48 89 e5             	mov    %rsp,%rbp
  800788:	48 83 ec 1c          	sub    $0x1c,%rsp
  80078c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800790:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800793:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800797:	7e 52                	jle    8007eb <getint+0x67>
		x=va_arg(*ap, long long);
  800799:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079d:	8b 00                	mov    (%rax),%eax
  80079f:	83 f8 30             	cmp    $0x30,%eax
  8007a2:	73 24                	jae    8007c8 <getint+0x44>
  8007a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b0:	8b 00                	mov    (%rax),%eax
  8007b2:	89 c0                	mov    %eax,%eax
  8007b4:	48 01 d0             	add    %rdx,%rax
  8007b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007bb:	8b 12                	mov    (%rdx),%edx
  8007bd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c4:	89 0a                	mov    %ecx,(%rdx)
  8007c6:	eb 17                	jmp    8007df <getint+0x5b>
  8007c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007cc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007d0:	48 89 d0             	mov    %rdx,%rax
  8007d3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007db:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007df:	48 8b 00             	mov    (%rax),%rax
  8007e2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007e6:	e9 a3 00 00 00       	jmpq   80088e <getint+0x10a>
	else if (lflag)
  8007eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007ef:	74 4f                	je     800840 <getint+0xbc>
		x=va_arg(*ap, long);
  8007f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f5:	8b 00                	mov    (%rax),%eax
  8007f7:	83 f8 30             	cmp    $0x30,%eax
  8007fa:	73 24                	jae    800820 <getint+0x9c>
  8007fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800800:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800804:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800808:	8b 00                	mov    (%rax),%eax
  80080a:	89 c0                	mov    %eax,%eax
  80080c:	48 01 d0             	add    %rdx,%rax
  80080f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800813:	8b 12                	mov    (%rdx),%edx
  800815:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800818:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80081c:	89 0a                	mov    %ecx,(%rdx)
  80081e:	eb 17                	jmp    800837 <getint+0xb3>
  800820:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800824:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800828:	48 89 d0             	mov    %rdx,%rax
  80082b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80082f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800833:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800837:	48 8b 00             	mov    (%rax),%rax
  80083a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80083e:	eb 4e                	jmp    80088e <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800840:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800844:	8b 00                	mov    (%rax),%eax
  800846:	83 f8 30             	cmp    $0x30,%eax
  800849:	73 24                	jae    80086f <getint+0xeb>
  80084b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800853:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800857:	8b 00                	mov    (%rax),%eax
  800859:	89 c0                	mov    %eax,%eax
  80085b:	48 01 d0             	add    %rdx,%rax
  80085e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800862:	8b 12                	mov    (%rdx),%edx
  800864:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800867:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80086b:	89 0a                	mov    %ecx,(%rdx)
  80086d:	eb 17                	jmp    800886 <getint+0x102>
  80086f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800873:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800877:	48 89 d0             	mov    %rdx,%rax
  80087a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80087e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800882:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800886:	8b 00                	mov    (%rax),%eax
  800888:	48 98                	cltq   
  80088a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80088e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800892:	c9                   	leaveq 
  800893:	c3                   	retq   

0000000000800894 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800894:	55                   	push   %rbp
  800895:	48 89 e5             	mov    %rsp,%rbp
  800898:	41 54                	push   %r12
  80089a:	53                   	push   %rbx
  80089b:	48 83 ec 60          	sub    $0x60,%rsp
  80089f:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8008a3:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8008a7:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008ab:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8008af:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8008b3:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8008b7:	48 8b 0a             	mov    (%rdx),%rcx
  8008ba:	48 89 08             	mov    %rcx,(%rax)
  8008bd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008c1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008c5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008c9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008cd:	eb 17                	jmp    8008e6 <vprintfmt+0x52>
			if (ch == '\0')
  8008cf:	85 db                	test   %ebx,%ebx
  8008d1:	0f 84 df 04 00 00    	je     800db6 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  8008d7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008db:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008df:	48 89 d6             	mov    %rdx,%rsi
  8008e2:	89 df                	mov    %ebx,%edi
  8008e4:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008e6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008ea:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008ee:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008f2:	0f b6 00             	movzbl (%rax),%eax
  8008f5:	0f b6 d8             	movzbl %al,%ebx
  8008f8:	83 fb 25             	cmp    $0x25,%ebx
  8008fb:	75 d2                	jne    8008cf <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008fd:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800901:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800908:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80090f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800916:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80091d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800921:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800925:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800929:	0f b6 00             	movzbl (%rax),%eax
  80092c:	0f b6 d8             	movzbl %al,%ebx
  80092f:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800932:	83 f8 55             	cmp    $0x55,%eax
  800935:	0f 87 47 04 00 00    	ja     800d82 <vprintfmt+0x4ee>
  80093b:	89 c0                	mov    %eax,%eax
  80093d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800944:	00 
  800945:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  80094c:	00 00 00 
  80094f:	48 01 d0             	add    %rdx,%rax
  800952:	48 8b 00             	mov    (%rax),%rax
  800955:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800957:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80095b:	eb c0                	jmp    80091d <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80095d:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800961:	eb ba                	jmp    80091d <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800963:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80096a:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80096d:	89 d0                	mov    %edx,%eax
  80096f:	c1 e0 02             	shl    $0x2,%eax
  800972:	01 d0                	add    %edx,%eax
  800974:	01 c0                	add    %eax,%eax
  800976:	01 d8                	add    %ebx,%eax
  800978:	83 e8 30             	sub    $0x30,%eax
  80097b:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80097e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800982:	0f b6 00             	movzbl (%rax),%eax
  800985:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800988:	83 fb 2f             	cmp    $0x2f,%ebx
  80098b:	7e 0c                	jle    800999 <vprintfmt+0x105>
  80098d:	83 fb 39             	cmp    $0x39,%ebx
  800990:	7f 07                	jg     800999 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800992:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800997:	eb d1                	jmp    80096a <vprintfmt+0xd6>
			goto process_precision;
  800999:	eb 58                	jmp    8009f3 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80099b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80099e:	83 f8 30             	cmp    $0x30,%eax
  8009a1:	73 17                	jae    8009ba <vprintfmt+0x126>
  8009a3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009a7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009aa:	89 c0                	mov    %eax,%eax
  8009ac:	48 01 d0             	add    %rdx,%rax
  8009af:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009b2:	83 c2 08             	add    $0x8,%edx
  8009b5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009b8:	eb 0f                	jmp    8009c9 <vprintfmt+0x135>
  8009ba:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009be:	48 89 d0             	mov    %rdx,%rax
  8009c1:	48 83 c2 08          	add    $0x8,%rdx
  8009c5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009c9:	8b 00                	mov    (%rax),%eax
  8009cb:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8009ce:	eb 23                	jmp    8009f3 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8009d0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009d4:	79 0c                	jns    8009e2 <vprintfmt+0x14e>
				width = 0;
  8009d6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009dd:	e9 3b ff ff ff       	jmpq   80091d <vprintfmt+0x89>
  8009e2:	e9 36 ff ff ff       	jmpq   80091d <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009e7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009ee:	e9 2a ff ff ff       	jmpq   80091d <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009f3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009f7:	79 12                	jns    800a0b <vprintfmt+0x177>
				width = precision, precision = -1;
  8009f9:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009fc:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009ff:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a06:	e9 12 ff ff ff       	jmpq   80091d <vprintfmt+0x89>
  800a0b:	e9 0d ff ff ff       	jmpq   80091d <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a10:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a14:	e9 04 ff ff ff       	jmpq   80091d <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a19:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a1c:	83 f8 30             	cmp    $0x30,%eax
  800a1f:	73 17                	jae    800a38 <vprintfmt+0x1a4>
  800a21:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a25:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a28:	89 c0                	mov    %eax,%eax
  800a2a:	48 01 d0             	add    %rdx,%rax
  800a2d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a30:	83 c2 08             	add    $0x8,%edx
  800a33:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a36:	eb 0f                	jmp    800a47 <vprintfmt+0x1b3>
  800a38:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a3c:	48 89 d0             	mov    %rdx,%rax
  800a3f:	48 83 c2 08          	add    $0x8,%rdx
  800a43:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a47:	8b 10                	mov    (%rax),%edx
  800a49:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a4d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a51:	48 89 ce             	mov    %rcx,%rsi
  800a54:	89 d7                	mov    %edx,%edi
  800a56:	ff d0                	callq  *%rax
			break;
  800a58:	e9 53 03 00 00       	jmpq   800db0 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a5d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a60:	83 f8 30             	cmp    $0x30,%eax
  800a63:	73 17                	jae    800a7c <vprintfmt+0x1e8>
  800a65:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a69:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a6c:	89 c0                	mov    %eax,%eax
  800a6e:	48 01 d0             	add    %rdx,%rax
  800a71:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a74:	83 c2 08             	add    $0x8,%edx
  800a77:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a7a:	eb 0f                	jmp    800a8b <vprintfmt+0x1f7>
  800a7c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a80:	48 89 d0             	mov    %rdx,%rax
  800a83:	48 83 c2 08          	add    $0x8,%rdx
  800a87:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a8b:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a8d:	85 db                	test   %ebx,%ebx
  800a8f:	79 02                	jns    800a93 <vprintfmt+0x1ff>
				err = -err;
  800a91:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a93:	83 fb 15             	cmp    $0x15,%ebx
  800a96:	7f 16                	jg     800aae <vprintfmt+0x21a>
  800a98:	48 b8 00 19 80 00 00 	movabs $0x801900,%rax
  800a9f:	00 00 00 
  800aa2:	48 63 d3             	movslq %ebx,%rdx
  800aa5:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800aa9:	4d 85 e4             	test   %r12,%r12
  800aac:	75 2e                	jne    800adc <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800aae:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ab2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ab6:	89 d9                	mov    %ebx,%ecx
  800ab8:	48 ba c1 19 80 00 00 	movabs $0x8019c1,%rdx
  800abf:	00 00 00 
  800ac2:	48 89 c7             	mov    %rax,%rdi
  800ac5:	b8 00 00 00 00       	mov    $0x0,%eax
  800aca:	49 b8 bf 0d 80 00 00 	movabs $0x800dbf,%r8
  800ad1:	00 00 00 
  800ad4:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ad7:	e9 d4 02 00 00       	jmpq   800db0 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800adc:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ae0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae4:	4c 89 e1             	mov    %r12,%rcx
  800ae7:	48 ba ca 19 80 00 00 	movabs $0x8019ca,%rdx
  800aee:	00 00 00 
  800af1:	48 89 c7             	mov    %rax,%rdi
  800af4:	b8 00 00 00 00       	mov    $0x0,%eax
  800af9:	49 b8 bf 0d 80 00 00 	movabs $0x800dbf,%r8
  800b00:	00 00 00 
  800b03:	41 ff d0             	callq  *%r8
			break;
  800b06:	e9 a5 02 00 00       	jmpq   800db0 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b0b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b0e:	83 f8 30             	cmp    $0x30,%eax
  800b11:	73 17                	jae    800b2a <vprintfmt+0x296>
  800b13:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b17:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b1a:	89 c0                	mov    %eax,%eax
  800b1c:	48 01 d0             	add    %rdx,%rax
  800b1f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b22:	83 c2 08             	add    $0x8,%edx
  800b25:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b28:	eb 0f                	jmp    800b39 <vprintfmt+0x2a5>
  800b2a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b2e:	48 89 d0             	mov    %rdx,%rax
  800b31:	48 83 c2 08          	add    $0x8,%rdx
  800b35:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b39:	4c 8b 20             	mov    (%rax),%r12
  800b3c:	4d 85 e4             	test   %r12,%r12
  800b3f:	75 0a                	jne    800b4b <vprintfmt+0x2b7>
				p = "(null)";
  800b41:	49 bc cd 19 80 00 00 	movabs $0x8019cd,%r12
  800b48:	00 00 00 
			if (width > 0 && padc != '-')
  800b4b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b4f:	7e 3f                	jle    800b90 <vprintfmt+0x2fc>
  800b51:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b55:	74 39                	je     800b90 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b57:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b5a:	48 98                	cltq   
  800b5c:	48 89 c6             	mov    %rax,%rsi
  800b5f:	4c 89 e7             	mov    %r12,%rdi
  800b62:	48 b8 6b 10 80 00 00 	movabs $0x80106b,%rax
  800b69:	00 00 00 
  800b6c:	ff d0                	callq  *%rax
  800b6e:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b71:	eb 17                	jmp    800b8a <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b73:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b77:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b7b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b7f:	48 89 ce             	mov    %rcx,%rsi
  800b82:	89 d7                	mov    %edx,%edi
  800b84:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b86:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b8a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b8e:	7f e3                	jg     800b73 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b90:	eb 37                	jmp    800bc9 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b92:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b96:	74 1e                	je     800bb6 <vprintfmt+0x322>
  800b98:	83 fb 1f             	cmp    $0x1f,%ebx
  800b9b:	7e 05                	jle    800ba2 <vprintfmt+0x30e>
  800b9d:	83 fb 7e             	cmp    $0x7e,%ebx
  800ba0:	7e 14                	jle    800bb6 <vprintfmt+0x322>
					putch('?', putdat);
  800ba2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ba6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800baa:	48 89 d6             	mov    %rdx,%rsi
  800bad:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800bb2:	ff d0                	callq  *%rax
  800bb4:	eb 0f                	jmp    800bc5 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800bb6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bba:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bbe:	48 89 d6             	mov    %rdx,%rsi
  800bc1:	89 df                	mov    %ebx,%edi
  800bc3:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bc5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bc9:	4c 89 e0             	mov    %r12,%rax
  800bcc:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800bd0:	0f b6 00             	movzbl (%rax),%eax
  800bd3:	0f be d8             	movsbl %al,%ebx
  800bd6:	85 db                	test   %ebx,%ebx
  800bd8:	74 10                	je     800bea <vprintfmt+0x356>
  800bda:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bde:	78 b2                	js     800b92 <vprintfmt+0x2fe>
  800be0:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800be4:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800be8:	79 a8                	jns    800b92 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bea:	eb 16                	jmp    800c02 <vprintfmt+0x36e>
				putch(' ', putdat);
  800bec:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bf0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bf4:	48 89 d6             	mov    %rdx,%rsi
  800bf7:	bf 20 00 00 00       	mov    $0x20,%edi
  800bfc:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bfe:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c02:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c06:	7f e4                	jg     800bec <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800c08:	e9 a3 01 00 00       	jmpq   800db0 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c0d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c11:	be 03 00 00 00       	mov    $0x3,%esi
  800c16:	48 89 c7             	mov    %rax,%rdi
  800c19:	48 b8 84 07 80 00 00 	movabs $0x800784,%rax
  800c20:	00 00 00 
  800c23:	ff d0                	callq  *%rax
  800c25:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c2d:	48 85 c0             	test   %rax,%rax
  800c30:	79 1d                	jns    800c4f <vprintfmt+0x3bb>
				putch('-', putdat);
  800c32:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c36:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c3a:	48 89 d6             	mov    %rdx,%rsi
  800c3d:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c42:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c48:	48 f7 d8             	neg    %rax
  800c4b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c4f:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c56:	e9 e8 00 00 00       	jmpq   800d43 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c5b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c5f:	be 03 00 00 00       	mov    $0x3,%esi
  800c64:	48 89 c7             	mov    %rax,%rdi
  800c67:	48 b8 74 06 80 00 00 	movabs $0x800674,%rax
  800c6e:	00 00 00 
  800c71:	ff d0                	callq  *%rax
  800c73:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c77:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c7e:	e9 c0 00 00 00       	jmpq   800d43 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c83:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c87:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c8b:	48 89 d6             	mov    %rdx,%rsi
  800c8e:	bf 58 00 00 00       	mov    $0x58,%edi
  800c93:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c95:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c99:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c9d:	48 89 d6             	mov    %rdx,%rsi
  800ca0:	bf 58 00 00 00       	mov    $0x58,%edi
  800ca5:	ff d0                	callq  *%rax
			putch('X', putdat);
  800ca7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cab:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800caf:	48 89 d6             	mov    %rdx,%rsi
  800cb2:	bf 58 00 00 00       	mov    $0x58,%edi
  800cb7:	ff d0                	callq  *%rax
			break;
  800cb9:	e9 f2 00 00 00       	jmpq   800db0 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800cbe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cc2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cc6:	48 89 d6             	mov    %rdx,%rsi
  800cc9:	bf 30 00 00 00       	mov    $0x30,%edi
  800cce:	ff d0                	callq  *%rax
			putch('x', putdat);
  800cd0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cd4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd8:	48 89 d6             	mov    %rdx,%rsi
  800cdb:	bf 78 00 00 00       	mov    $0x78,%edi
  800ce0:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800ce2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ce5:	83 f8 30             	cmp    $0x30,%eax
  800ce8:	73 17                	jae    800d01 <vprintfmt+0x46d>
  800cea:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cf1:	89 c0                	mov    %eax,%eax
  800cf3:	48 01 d0             	add    %rdx,%rax
  800cf6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cf9:	83 c2 08             	add    $0x8,%edx
  800cfc:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cff:	eb 0f                	jmp    800d10 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800d01:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d05:	48 89 d0             	mov    %rdx,%rax
  800d08:	48 83 c2 08          	add    $0x8,%rdx
  800d0c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d10:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d13:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d17:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d1e:	eb 23                	jmp    800d43 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d20:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d24:	be 03 00 00 00       	mov    $0x3,%esi
  800d29:	48 89 c7             	mov    %rax,%rdi
  800d2c:	48 b8 74 06 80 00 00 	movabs $0x800674,%rax
  800d33:	00 00 00 
  800d36:	ff d0                	callq  *%rax
  800d38:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d3c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d43:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d48:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d4b:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d4e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d52:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d56:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d5a:	45 89 c1             	mov    %r8d,%r9d
  800d5d:	41 89 f8             	mov    %edi,%r8d
  800d60:	48 89 c7             	mov    %rax,%rdi
  800d63:	48 b8 b9 05 80 00 00 	movabs $0x8005b9,%rax
  800d6a:	00 00 00 
  800d6d:	ff d0                	callq  *%rax
			break;
  800d6f:	eb 3f                	jmp    800db0 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d71:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d75:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d79:	48 89 d6             	mov    %rdx,%rsi
  800d7c:	89 df                	mov    %ebx,%edi
  800d7e:	ff d0                	callq  *%rax
			break;
  800d80:	eb 2e                	jmp    800db0 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d82:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d86:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d8a:	48 89 d6             	mov    %rdx,%rsi
  800d8d:	bf 25 00 00 00       	mov    $0x25,%edi
  800d92:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d94:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d99:	eb 05                	jmp    800da0 <vprintfmt+0x50c>
  800d9b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800da0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800da4:	48 83 e8 01          	sub    $0x1,%rax
  800da8:	0f b6 00             	movzbl (%rax),%eax
  800dab:	3c 25                	cmp    $0x25,%al
  800dad:	75 ec                	jne    800d9b <vprintfmt+0x507>
				/* do nothing */;
			break;
  800daf:	90                   	nop
		}
	}
  800db0:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800db1:	e9 30 fb ff ff       	jmpq   8008e6 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800db6:	48 83 c4 60          	add    $0x60,%rsp
  800dba:	5b                   	pop    %rbx
  800dbb:	41 5c                	pop    %r12
  800dbd:	5d                   	pop    %rbp
  800dbe:	c3                   	retq   

0000000000800dbf <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800dbf:	55                   	push   %rbp
  800dc0:	48 89 e5             	mov    %rsp,%rbp
  800dc3:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800dca:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800dd1:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800dd8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ddf:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800de6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ded:	84 c0                	test   %al,%al
  800def:	74 20                	je     800e11 <printfmt+0x52>
  800df1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800df5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800df9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dfd:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e01:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e05:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e09:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e0d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e11:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e18:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e1f:	00 00 00 
  800e22:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e29:	00 00 00 
  800e2c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e30:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e37:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e3e:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e45:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e4c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e53:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e5a:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e61:	48 89 c7             	mov    %rax,%rdi
  800e64:	48 b8 94 08 80 00 00 	movabs $0x800894,%rax
  800e6b:	00 00 00 
  800e6e:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e70:	c9                   	leaveq 
  800e71:	c3                   	retq   

0000000000800e72 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e72:	55                   	push   %rbp
  800e73:	48 89 e5             	mov    %rsp,%rbp
  800e76:	48 83 ec 10          	sub    $0x10,%rsp
  800e7a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e7d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e85:	8b 40 10             	mov    0x10(%rax),%eax
  800e88:	8d 50 01             	lea    0x1(%rax),%edx
  800e8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e8f:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e96:	48 8b 10             	mov    (%rax),%rdx
  800e99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e9d:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ea1:	48 39 c2             	cmp    %rax,%rdx
  800ea4:	73 17                	jae    800ebd <sprintputch+0x4b>
		*b->buf++ = ch;
  800ea6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eaa:	48 8b 00             	mov    (%rax),%rax
  800ead:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800eb1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800eb5:	48 89 0a             	mov    %rcx,(%rdx)
  800eb8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800ebb:	88 10                	mov    %dl,(%rax)
}
  800ebd:	c9                   	leaveq 
  800ebe:	c3                   	retq   

0000000000800ebf <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ebf:	55                   	push   %rbp
  800ec0:	48 89 e5             	mov    %rsp,%rbp
  800ec3:	48 83 ec 50          	sub    $0x50,%rsp
  800ec7:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800ecb:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800ece:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ed2:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ed6:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800eda:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800ede:	48 8b 0a             	mov    (%rdx),%rcx
  800ee1:	48 89 08             	mov    %rcx,(%rax)
  800ee4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ee8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800eec:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ef0:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ef4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ef8:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800efc:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800eff:	48 98                	cltq   
  800f01:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800f05:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f09:	48 01 d0             	add    %rdx,%rax
  800f0c:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f10:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f17:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f1c:	74 06                	je     800f24 <vsnprintf+0x65>
  800f1e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f22:	7f 07                	jg     800f2b <vsnprintf+0x6c>
		return -E_INVAL;
  800f24:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f29:	eb 2f                	jmp    800f5a <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f2b:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f2f:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f33:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f37:	48 89 c6             	mov    %rax,%rsi
  800f3a:	48 bf 72 0e 80 00 00 	movabs $0x800e72,%rdi
  800f41:	00 00 00 
  800f44:	48 b8 94 08 80 00 00 	movabs $0x800894,%rax
  800f4b:	00 00 00 
  800f4e:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f50:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f54:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f57:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f5a:	c9                   	leaveq 
  800f5b:	c3                   	retq   

0000000000800f5c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f5c:	55                   	push   %rbp
  800f5d:	48 89 e5             	mov    %rsp,%rbp
  800f60:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f67:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f6e:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f74:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f7b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f82:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f89:	84 c0                	test   %al,%al
  800f8b:	74 20                	je     800fad <snprintf+0x51>
  800f8d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f91:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f95:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f99:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f9d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fa1:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fa5:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fa9:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fad:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800fb4:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800fbb:	00 00 00 
  800fbe:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fc5:	00 00 00 
  800fc8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fcc:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fd3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fda:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fe1:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fe8:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fef:	48 8b 0a             	mov    (%rdx),%rcx
  800ff2:	48 89 08             	mov    %rcx,(%rax)
  800ff5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ff9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ffd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801001:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801005:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80100c:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801013:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801019:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801020:	48 89 c7             	mov    %rax,%rdi
  801023:	48 b8 bf 0e 80 00 00 	movabs $0x800ebf,%rax
  80102a:	00 00 00 
  80102d:	ff d0                	callq  *%rax
  80102f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801035:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80103b:	c9                   	leaveq 
  80103c:	c3                   	retq   

000000000080103d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80103d:	55                   	push   %rbp
  80103e:	48 89 e5             	mov    %rsp,%rbp
  801041:	48 83 ec 18          	sub    $0x18,%rsp
  801045:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801049:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801050:	eb 09                	jmp    80105b <strlen+0x1e>
		n++;
  801052:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801056:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80105b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80105f:	0f b6 00             	movzbl (%rax),%eax
  801062:	84 c0                	test   %al,%al
  801064:	75 ec                	jne    801052 <strlen+0x15>
		n++;
	return n;
  801066:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801069:	c9                   	leaveq 
  80106a:	c3                   	retq   

000000000080106b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80106b:	55                   	push   %rbp
  80106c:	48 89 e5             	mov    %rsp,%rbp
  80106f:	48 83 ec 20          	sub    $0x20,%rsp
  801073:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801077:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80107b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801082:	eb 0e                	jmp    801092 <strnlen+0x27>
		n++;
  801084:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801088:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80108d:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801092:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801097:	74 0b                	je     8010a4 <strnlen+0x39>
  801099:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80109d:	0f b6 00             	movzbl (%rax),%eax
  8010a0:	84 c0                	test   %al,%al
  8010a2:	75 e0                	jne    801084 <strnlen+0x19>
		n++;
	return n;
  8010a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010a7:	c9                   	leaveq 
  8010a8:	c3                   	retq   

00000000008010a9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010a9:	55                   	push   %rbp
  8010aa:	48 89 e5             	mov    %rsp,%rbp
  8010ad:	48 83 ec 20          	sub    $0x20,%rsp
  8010b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8010b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010bd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8010c1:	90                   	nop
  8010c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010ca:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010ce:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010d2:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010d6:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010da:	0f b6 12             	movzbl (%rdx),%edx
  8010dd:	88 10                	mov    %dl,(%rax)
  8010df:	0f b6 00             	movzbl (%rax),%eax
  8010e2:	84 c0                	test   %al,%al
  8010e4:	75 dc                	jne    8010c2 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010ea:	c9                   	leaveq 
  8010eb:	c3                   	retq   

00000000008010ec <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010ec:	55                   	push   %rbp
  8010ed:	48 89 e5             	mov    %rsp,%rbp
  8010f0:	48 83 ec 20          	sub    $0x20,%rsp
  8010f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010f8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801100:	48 89 c7             	mov    %rax,%rdi
  801103:	48 b8 3d 10 80 00 00 	movabs $0x80103d,%rax
  80110a:	00 00 00 
  80110d:	ff d0                	callq  *%rax
  80110f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801112:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801115:	48 63 d0             	movslq %eax,%rdx
  801118:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80111c:	48 01 c2             	add    %rax,%rdx
  80111f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801123:	48 89 c6             	mov    %rax,%rsi
  801126:	48 89 d7             	mov    %rdx,%rdi
  801129:	48 b8 a9 10 80 00 00 	movabs $0x8010a9,%rax
  801130:	00 00 00 
  801133:	ff d0                	callq  *%rax
	return dst;
  801135:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801139:	c9                   	leaveq 
  80113a:	c3                   	retq   

000000000080113b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80113b:	55                   	push   %rbp
  80113c:	48 89 e5             	mov    %rsp,%rbp
  80113f:	48 83 ec 28          	sub    $0x28,%rsp
  801143:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801147:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80114b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80114f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801153:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801157:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80115e:	00 
  80115f:	eb 2a                	jmp    80118b <strncpy+0x50>
		*dst++ = *src;
  801161:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801165:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801169:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80116d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801171:	0f b6 12             	movzbl (%rdx),%edx
  801174:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801176:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80117a:	0f b6 00             	movzbl (%rax),%eax
  80117d:	84 c0                	test   %al,%al
  80117f:	74 05                	je     801186 <strncpy+0x4b>
			src++;
  801181:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801186:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80118b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80118f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801193:	72 cc                	jb     801161 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801195:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801199:	c9                   	leaveq 
  80119a:	c3                   	retq   

000000000080119b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80119b:	55                   	push   %rbp
  80119c:	48 89 e5             	mov    %rsp,%rbp
  80119f:	48 83 ec 28          	sub    $0x28,%rsp
  8011a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011a7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011ab:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8011af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8011b7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011bc:	74 3d                	je     8011fb <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8011be:	eb 1d                	jmp    8011dd <strlcpy+0x42>
			*dst++ = *src++;
  8011c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011c8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011cc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011d0:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011d4:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011d8:	0f b6 12             	movzbl (%rdx),%edx
  8011db:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011dd:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011e2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011e7:	74 0b                	je     8011f4 <strlcpy+0x59>
  8011e9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011ed:	0f b6 00             	movzbl (%rax),%eax
  8011f0:	84 c0                	test   %al,%al
  8011f2:	75 cc                	jne    8011c0 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f8:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801203:	48 29 c2             	sub    %rax,%rdx
  801206:	48 89 d0             	mov    %rdx,%rax
}
  801209:	c9                   	leaveq 
  80120a:	c3                   	retq   

000000000080120b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80120b:	55                   	push   %rbp
  80120c:	48 89 e5             	mov    %rsp,%rbp
  80120f:	48 83 ec 10          	sub    $0x10,%rsp
  801213:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801217:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80121b:	eb 0a                	jmp    801227 <strcmp+0x1c>
		p++, q++;
  80121d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801222:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801227:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122b:	0f b6 00             	movzbl (%rax),%eax
  80122e:	84 c0                	test   %al,%al
  801230:	74 12                	je     801244 <strcmp+0x39>
  801232:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801236:	0f b6 10             	movzbl (%rax),%edx
  801239:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80123d:	0f b6 00             	movzbl (%rax),%eax
  801240:	38 c2                	cmp    %al,%dl
  801242:	74 d9                	je     80121d <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801244:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801248:	0f b6 00             	movzbl (%rax),%eax
  80124b:	0f b6 d0             	movzbl %al,%edx
  80124e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801252:	0f b6 00             	movzbl (%rax),%eax
  801255:	0f b6 c0             	movzbl %al,%eax
  801258:	29 c2                	sub    %eax,%edx
  80125a:	89 d0                	mov    %edx,%eax
}
  80125c:	c9                   	leaveq 
  80125d:	c3                   	retq   

000000000080125e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80125e:	55                   	push   %rbp
  80125f:	48 89 e5             	mov    %rsp,%rbp
  801262:	48 83 ec 18          	sub    $0x18,%rsp
  801266:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80126a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80126e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801272:	eb 0f                	jmp    801283 <strncmp+0x25>
		n--, p++, q++;
  801274:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801279:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80127e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801283:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801288:	74 1d                	je     8012a7 <strncmp+0x49>
  80128a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80128e:	0f b6 00             	movzbl (%rax),%eax
  801291:	84 c0                	test   %al,%al
  801293:	74 12                	je     8012a7 <strncmp+0x49>
  801295:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801299:	0f b6 10             	movzbl (%rax),%edx
  80129c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012a0:	0f b6 00             	movzbl (%rax),%eax
  8012a3:	38 c2                	cmp    %al,%dl
  8012a5:	74 cd                	je     801274 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8012a7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012ac:	75 07                	jne    8012b5 <strncmp+0x57>
		return 0;
  8012ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b3:	eb 18                	jmp    8012cd <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b9:	0f b6 00             	movzbl (%rax),%eax
  8012bc:	0f b6 d0             	movzbl %al,%edx
  8012bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012c3:	0f b6 00             	movzbl (%rax),%eax
  8012c6:	0f b6 c0             	movzbl %al,%eax
  8012c9:	29 c2                	sub    %eax,%edx
  8012cb:	89 d0                	mov    %edx,%eax
}
  8012cd:	c9                   	leaveq 
  8012ce:	c3                   	retq   

00000000008012cf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012cf:	55                   	push   %rbp
  8012d0:	48 89 e5             	mov    %rsp,%rbp
  8012d3:	48 83 ec 0c          	sub    $0xc,%rsp
  8012d7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012db:	89 f0                	mov    %esi,%eax
  8012dd:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012e0:	eb 17                	jmp    8012f9 <strchr+0x2a>
		if (*s == c)
  8012e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e6:	0f b6 00             	movzbl (%rax),%eax
  8012e9:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012ec:	75 06                	jne    8012f4 <strchr+0x25>
			return (char *) s;
  8012ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f2:	eb 15                	jmp    801309 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012f4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012fd:	0f b6 00             	movzbl (%rax),%eax
  801300:	84 c0                	test   %al,%al
  801302:	75 de                	jne    8012e2 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801304:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801309:	c9                   	leaveq 
  80130a:	c3                   	retq   

000000000080130b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80130b:	55                   	push   %rbp
  80130c:	48 89 e5             	mov    %rsp,%rbp
  80130f:	48 83 ec 0c          	sub    $0xc,%rsp
  801313:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801317:	89 f0                	mov    %esi,%eax
  801319:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80131c:	eb 13                	jmp    801331 <strfind+0x26>
		if (*s == c)
  80131e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801322:	0f b6 00             	movzbl (%rax),%eax
  801325:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801328:	75 02                	jne    80132c <strfind+0x21>
			break;
  80132a:	eb 10                	jmp    80133c <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80132c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801331:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801335:	0f b6 00             	movzbl (%rax),%eax
  801338:	84 c0                	test   %al,%al
  80133a:	75 e2                	jne    80131e <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80133c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801340:	c9                   	leaveq 
  801341:	c3                   	retq   

0000000000801342 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801342:	55                   	push   %rbp
  801343:	48 89 e5             	mov    %rsp,%rbp
  801346:	48 83 ec 18          	sub    $0x18,%rsp
  80134a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80134e:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801351:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801355:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80135a:	75 06                	jne    801362 <memset+0x20>
		return v;
  80135c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801360:	eb 69                	jmp    8013cb <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801362:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801366:	83 e0 03             	and    $0x3,%eax
  801369:	48 85 c0             	test   %rax,%rax
  80136c:	75 48                	jne    8013b6 <memset+0x74>
  80136e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801372:	83 e0 03             	and    $0x3,%eax
  801375:	48 85 c0             	test   %rax,%rax
  801378:	75 3c                	jne    8013b6 <memset+0x74>
		c &= 0xFF;
  80137a:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801381:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801384:	c1 e0 18             	shl    $0x18,%eax
  801387:	89 c2                	mov    %eax,%edx
  801389:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80138c:	c1 e0 10             	shl    $0x10,%eax
  80138f:	09 c2                	or     %eax,%edx
  801391:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801394:	c1 e0 08             	shl    $0x8,%eax
  801397:	09 d0                	or     %edx,%eax
  801399:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80139c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013a0:	48 c1 e8 02          	shr    $0x2,%rax
  8013a4:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8013a7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013ab:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013ae:	48 89 d7             	mov    %rdx,%rdi
  8013b1:	fc                   	cld    
  8013b2:	f3 ab                	rep stos %eax,%es:(%rdi)
  8013b4:	eb 11                	jmp    8013c7 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013b6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013ba:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013bd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013c1:	48 89 d7             	mov    %rdx,%rdi
  8013c4:	fc                   	cld    
  8013c5:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8013c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013cb:	c9                   	leaveq 
  8013cc:	c3                   	retq   

00000000008013cd <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013cd:	55                   	push   %rbp
  8013ce:	48 89 e5             	mov    %rsp,%rbp
  8013d1:	48 83 ec 28          	sub    $0x28,%rsp
  8013d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013dd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013e5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ed:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f5:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013f9:	0f 83 88 00 00 00    	jae    801487 <memmove+0xba>
  8013ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801403:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801407:	48 01 d0             	add    %rdx,%rax
  80140a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80140e:	76 77                	jbe    801487 <memmove+0xba>
		s += n;
  801410:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801414:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801418:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80141c:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801420:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801424:	83 e0 03             	and    $0x3,%eax
  801427:	48 85 c0             	test   %rax,%rax
  80142a:	75 3b                	jne    801467 <memmove+0x9a>
  80142c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801430:	83 e0 03             	and    $0x3,%eax
  801433:	48 85 c0             	test   %rax,%rax
  801436:	75 2f                	jne    801467 <memmove+0x9a>
  801438:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143c:	83 e0 03             	and    $0x3,%eax
  80143f:	48 85 c0             	test   %rax,%rax
  801442:	75 23                	jne    801467 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801444:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801448:	48 83 e8 04          	sub    $0x4,%rax
  80144c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801450:	48 83 ea 04          	sub    $0x4,%rdx
  801454:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801458:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80145c:	48 89 c7             	mov    %rax,%rdi
  80145f:	48 89 d6             	mov    %rdx,%rsi
  801462:	fd                   	std    
  801463:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801465:	eb 1d                	jmp    801484 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801467:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80146b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80146f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801473:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801477:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147b:	48 89 d7             	mov    %rdx,%rdi
  80147e:	48 89 c1             	mov    %rax,%rcx
  801481:	fd                   	std    
  801482:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801484:	fc                   	cld    
  801485:	eb 57                	jmp    8014de <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801487:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80148b:	83 e0 03             	and    $0x3,%eax
  80148e:	48 85 c0             	test   %rax,%rax
  801491:	75 36                	jne    8014c9 <memmove+0xfc>
  801493:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801497:	83 e0 03             	and    $0x3,%eax
  80149a:	48 85 c0             	test   %rax,%rax
  80149d:	75 2a                	jne    8014c9 <memmove+0xfc>
  80149f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a3:	83 e0 03             	and    $0x3,%eax
  8014a6:	48 85 c0             	test   %rax,%rax
  8014a9:	75 1e                	jne    8014c9 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8014ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014af:	48 c1 e8 02          	shr    $0x2,%rax
  8014b3:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8014b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ba:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014be:	48 89 c7             	mov    %rax,%rdi
  8014c1:	48 89 d6             	mov    %rdx,%rsi
  8014c4:	fc                   	cld    
  8014c5:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014c7:	eb 15                	jmp    8014de <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8014c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014cd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014d1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014d5:	48 89 c7             	mov    %rax,%rdi
  8014d8:	48 89 d6             	mov    %rdx,%rsi
  8014db:	fc                   	cld    
  8014dc:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014e2:	c9                   	leaveq 
  8014e3:	c3                   	retq   

00000000008014e4 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014e4:	55                   	push   %rbp
  8014e5:	48 89 e5             	mov    %rsp,%rbp
  8014e8:	48 83 ec 18          	sub    $0x18,%rsp
  8014ec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014f0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014f4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014fc:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801500:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801504:	48 89 ce             	mov    %rcx,%rsi
  801507:	48 89 c7             	mov    %rax,%rdi
  80150a:	48 b8 cd 13 80 00 00 	movabs $0x8013cd,%rax
  801511:	00 00 00 
  801514:	ff d0                	callq  *%rax
}
  801516:	c9                   	leaveq 
  801517:	c3                   	retq   

0000000000801518 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801518:	55                   	push   %rbp
  801519:	48 89 e5             	mov    %rsp,%rbp
  80151c:	48 83 ec 28          	sub    $0x28,%rsp
  801520:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801524:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801528:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80152c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801530:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801534:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801538:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80153c:	eb 36                	jmp    801574 <memcmp+0x5c>
		if (*s1 != *s2)
  80153e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801542:	0f b6 10             	movzbl (%rax),%edx
  801545:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801549:	0f b6 00             	movzbl (%rax),%eax
  80154c:	38 c2                	cmp    %al,%dl
  80154e:	74 1a                	je     80156a <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801550:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801554:	0f b6 00             	movzbl (%rax),%eax
  801557:	0f b6 d0             	movzbl %al,%edx
  80155a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80155e:	0f b6 00             	movzbl (%rax),%eax
  801561:	0f b6 c0             	movzbl %al,%eax
  801564:	29 c2                	sub    %eax,%edx
  801566:	89 d0                	mov    %edx,%eax
  801568:	eb 20                	jmp    80158a <memcmp+0x72>
		s1++, s2++;
  80156a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80156f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801574:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801578:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80157c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801580:	48 85 c0             	test   %rax,%rax
  801583:	75 b9                	jne    80153e <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801585:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80158a:	c9                   	leaveq 
  80158b:	c3                   	retq   

000000000080158c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80158c:	55                   	push   %rbp
  80158d:	48 89 e5             	mov    %rsp,%rbp
  801590:	48 83 ec 28          	sub    $0x28,%rsp
  801594:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801598:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80159b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80159f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015a7:	48 01 d0             	add    %rdx,%rax
  8015aa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8015ae:	eb 15                	jmp    8015c5 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015b4:	0f b6 10             	movzbl (%rax),%edx
  8015b7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8015ba:	38 c2                	cmp    %al,%dl
  8015bc:	75 02                	jne    8015c0 <memfind+0x34>
			break;
  8015be:	eb 0f                	jmp    8015cf <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015c0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015c9:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8015cd:	72 e1                	jb     8015b0 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8015cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015d3:	c9                   	leaveq 
  8015d4:	c3                   	retq   

00000000008015d5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015d5:	55                   	push   %rbp
  8015d6:	48 89 e5             	mov    %rsp,%rbp
  8015d9:	48 83 ec 34          	sub    $0x34,%rsp
  8015dd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015e1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015e5:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015ef:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015f6:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015f7:	eb 05                	jmp    8015fe <strtol+0x29>
		s++;
  8015f9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801602:	0f b6 00             	movzbl (%rax),%eax
  801605:	3c 20                	cmp    $0x20,%al
  801607:	74 f0                	je     8015f9 <strtol+0x24>
  801609:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160d:	0f b6 00             	movzbl (%rax),%eax
  801610:	3c 09                	cmp    $0x9,%al
  801612:	74 e5                	je     8015f9 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801614:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801618:	0f b6 00             	movzbl (%rax),%eax
  80161b:	3c 2b                	cmp    $0x2b,%al
  80161d:	75 07                	jne    801626 <strtol+0x51>
		s++;
  80161f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801624:	eb 17                	jmp    80163d <strtol+0x68>
	else if (*s == '-')
  801626:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162a:	0f b6 00             	movzbl (%rax),%eax
  80162d:	3c 2d                	cmp    $0x2d,%al
  80162f:	75 0c                	jne    80163d <strtol+0x68>
		s++, neg = 1;
  801631:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801636:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80163d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801641:	74 06                	je     801649 <strtol+0x74>
  801643:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801647:	75 28                	jne    801671 <strtol+0x9c>
  801649:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164d:	0f b6 00             	movzbl (%rax),%eax
  801650:	3c 30                	cmp    $0x30,%al
  801652:	75 1d                	jne    801671 <strtol+0x9c>
  801654:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801658:	48 83 c0 01          	add    $0x1,%rax
  80165c:	0f b6 00             	movzbl (%rax),%eax
  80165f:	3c 78                	cmp    $0x78,%al
  801661:	75 0e                	jne    801671 <strtol+0x9c>
		s += 2, base = 16;
  801663:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801668:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80166f:	eb 2c                	jmp    80169d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801671:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801675:	75 19                	jne    801690 <strtol+0xbb>
  801677:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167b:	0f b6 00             	movzbl (%rax),%eax
  80167e:	3c 30                	cmp    $0x30,%al
  801680:	75 0e                	jne    801690 <strtol+0xbb>
		s++, base = 8;
  801682:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801687:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80168e:	eb 0d                	jmp    80169d <strtol+0xc8>
	else if (base == 0)
  801690:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801694:	75 07                	jne    80169d <strtol+0xc8>
		base = 10;
  801696:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80169d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a1:	0f b6 00             	movzbl (%rax),%eax
  8016a4:	3c 2f                	cmp    $0x2f,%al
  8016a6:	7e 1d                	jle    8016c5 <strtol+0xf0>
  8016a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ac:	0f b6 00             	movzbl (%rax),%eax
  8016af:	3c 39                	cmp    $0x39,%al
  8016b1:	7f 12                	jg     8016c5 <strtol+0xf0>
			dig = *s - '0';
  8016b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b7:	0f b6 00             	movzbl (%rax),%eax
  8016ba:	0f be c0             	movsbl %al,%eax
  8016bd:	83 e8 30             	sub    $0x30,%eax
  8016c0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016c3:	eb 4e                	jmp    801713 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8016c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c9:	0f b6 00             	movzbl (%rax),%eax
  8016cc:	3c 60                	cmp    $0x60,%al
  8016ce:	7e 1d                	jle    8016ed <strtol+0x118>
  8016d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d4:	0f b6 00             	movzbl (%rax),%eax
  8016d7:	3c 7a                	cmp    $0x7a,%al
  8016d9:	7f 12                	jg     8016ed <strtol+0x118>
			dig = *s - 'a' + 10;
  8016db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016df:	0f b6 00             	movzbl (%rax),%eax
  8016e2:	0f be c0             	movsbl %al,%eax
  8016e5:	83 e8 57             	sub    $0x57,%eax
  8016e8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016eb:	eb 26                	jmp    801713 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f1:	0f b6 00             	movzbl (%rax),%eax
  8016f4:	3c 40                	cmp    $0x40,%al
  8016f6:	7e 48                	jle    801740 <strtol+0x16b>
  8016f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016fc:	0f b6 00             	movzbl (%rax),%eax
  8016ff:	3c 5a                	cmp    $0x5a,%al
  801701:	7f 3d                	jg     801740 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801703:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801707:	0f b6 00             	movzbl (%rax),%eax
  80170a:	0f be c0             	movsbl %al,%eax
  80170d:	83 e8 37             	sub    $0x37,%eax
  801710:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801713:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801716:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801719:	7c 02                	jl     80171d <strtol+0x148>
			break;
  80171b:	eb 23                	jmp    801740 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80171d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801722:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801725:	48 98                	cltq   
  801727:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80172c:	48 89 c2             	mov    %rax,%rdx
  80172f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801732:	48 98                	cltq   
  801734:	48 01 d0             	add    %rdx,%rax
  801737:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80173b:	e9 5d ff ff ff       	jmpq   80169d <strtol+0xc8>

	if (endptr)
  801740:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801745:	74 0b                	je     801752 <strtol+0x17d>
		*endptr = (char *) s;
  801747:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80174b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80174f:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801752:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801756:	74 09                	je     801761 <strtol+0x18c>
  801758:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80175c:	48 f7 d8             	neg    %rax
  80175f:	eb 04                	jmp    801765 <strtol+0x190>
  801761:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801765:	c9                   	leaveq 
  801766:	c3                   	retq   

0000000000801767 <strstr>:

char * strstr(const char *in, const char *str)
{
  801767:	55                   	push   %rbp
  801768:	48 89 e5             	mov    %rsp,%rbp
  80176b:	48 83 ec 30          	sub    $0x30,%rsp
  80176f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801773:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801777:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80177b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80177f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801783:	0f b6 00             	movzbl (%rax),%eax
  801786:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801789:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80178d:	75 06                	jne    801795 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80178f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801793:	eb 6b                	jmp    801800 <strstr+0x99>

	len = strlen(str);
  801795:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801799:	48 89 c7             	mov    %rax,%rdi
  80179c:	48 b8 3d 10 80 00 00 	movabs $0x80103d,%rax
  8017a3:	00 00 00 
  8017a6:	ff d0                	callq  *%rax
  8017a8:	48 98                	cltq   
  8017aa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8017ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017b6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017ba:	0f b6 00             	movzbl (%rax),%eax
  8017bd:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8017c0:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8017c4:	75 07                	jne    8017cd <strstr+0x66>
				return (char *) 0;
  8017c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017cb:	eb 33                	jmp    801800 <strstr+0x99>
		} while (sc != c);
  8017cd:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8017d1:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8017d4:	75 d8                	jne    8017ae <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8017d6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017da:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e2:	48 89 ce             	mov    %rcx,%rsi
  8017e5:	48 89 c7             	mov    %rax,%rdi
  8017e8:	48 b8 5e 12 80 00 00 	movabs $0x80125e,%rax
  8017ef:	00 00 00 
  8017f2:	ff d0                	callq  *%rax
  8017f4:	85 c0                	test   %eax,%eax
  8017f6:	75 b6                	jne    8017ae <strstr+0x47>

	return (char *) (in - 1);
  8017f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017fc:	48 83 e8 01          	sub    $0x1,%rax
}
  801800:	c9                   	leaveq 
  801801:	c3                   	retq   
