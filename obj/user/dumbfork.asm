
obj/user/dumbfork:     file format elf64-x86-64


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
  80003c:	e8 1c 03 00 00       	callq  80035d <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

envid_t dumbfork(void);

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	envid_t who;
	int i;

	// fork a child process
	who = dumbfork();
  800052:	48 b8 03 02 80 00 00 	movabs $0x800203,%rax
  800059:	00 00 00 
  80005c:	ff d0                	callq  *%rax
  80005e:	89 45 f8             	mov    %eax,-0x8(%rbp)

	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
  800061:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800068:	eb 4f                	jmp    8000b9 <umain+0x76>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  80006a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80006e:	74 0c                	je     80007c <umain+0x39>
  800070:	48 b8 e0 37 80 00 00 	movabs $0x8037e0,%rax
  800077:	00 00 00 
  80007a:	eb 0a                	jmp    800086 <umain+0x43>
  80007c:	48 b8 e7 37 80 00 00 	movabs $0x8037e7,%rax
  800083:	00 00 00 
  800086:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  800089:	48 89 c2             	mov    %rax,%rdx
  80008c:	89 ce                	mov    %ecx,%esi
  80008e:	48 bf ed 37 80 00 00 	movabs $0x8037ed,%rdi
  800095:	00 00 00 
  800098:	b8 00 00 00 00       	mov    $0x0,%eax
  80009d:	48 b9 49 06 80 00 00 	movabs $0x800649,%rcx
  8000a4:	00 00 00 
  8000a7:	ff d1                	callq  *%rcx
		sys_yield();
  8000a9:	48 b8 ef 1a 80 00 00 	movabs $0x801aef,%rax
  8000b0:	00 00 00 
  8000b3:	ff d0                	callq  *%rax

	// fork a child process
	who = dumbfork();

	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
  8000b5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8000b9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000bd:	74 07                	je     8000c6 <umain+0x83>
  8000bf:	b8 0a 00 00 00       	mov    $0xa,%eax
  8000c4:	eb 05                	jmp    8000cb <umain+0x88>
  8000c6:	b8 14 00 00 00       	mov    $0x14,%eax
  8000cb:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8000ce:	7f 9a                	jg     80006a <umain+0x27>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
		sys_yield();
	}
}
  8000d0:	c9                   	leaveq 
  8000d1:	c3                   	retq   

00000000008000d2 <duppage>:

void
duppage(envid_t dstenv, void *addr)
{
  8000d2:	55                   	push   %rbp
  8000d3:	48 89 e5             	mov    %rsp,%rbp
  8000d6:	48 83 ec 20          	sub    $0x20,%rsp
  8000da:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8000dd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	// This is NOT what you should do in your fork.
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  8000e1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8000e5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000e8:	ba 07 00 00 00       	mov    $0x7,%edx
  8000ed:	48 89 ce             	mov    %rcx,%rsi
  8000f0:	89 c7                	mov    %eax,%edi
  8000f2:	48 b8 2d 1b 80 00 00 	movabs $0x801b2d,%rax
  8000f9:	00 00 00 
  8000fc:	ff d0                	callq  *%rax
  8000fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800101:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800105:	79 30                	jns    800137 <duppage+0x65>
		panic("sys_page_alloc: %e", r);
  800107:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80010a:	89 c1                	mov    %eax,%ecx
  80010c:	48 ba ff 37 80 00 00 	movabs $0x8037ff,%rdx
  800113:	00 00 00 
  800116:	be 20 00 00 00       	mov    $0x20,%esi
  80011b:	48 bf 12 38 80 00 00 	movabs $0x803812,%rdi
  800122:	00 00 00 
  800125:	b8 00 00 00 00       	mov    $0x0,%eax
  80012a:	49 b8 10 04 80 00 00 	movabs $0x800410,%r8
  800131:	00 00 00 
  800134:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  800137:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80013b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80013e:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  800144:	b9 00 00 40 00       	mov    $0x400000,%ecx
  800149:	ba 00 00 00 00       	mov    $0x0,%edx
  80014e:	89 c7                	mov    %eax,%edi
  800150:	48 b8 7d 1b 80 00 00 	movabs $0x801b7d,%rax
  800157:	00 00 00 
  80015a:	ff d0                	callq  *%rax
  80015c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80015f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800163:	79 30                	jns    800195 <duppage+0xc3>
		panic("sys_page_map: %e", r);
  800165:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800168:	89 c1                	mov    %eax,%ecx
  80016a:	48 ba 22 38 80 00 00 	movabs $0x803822,%rdx
  800171:	00 00 00 
  800174:	be 22 00 00 00       	mov    $0x22,%esi
  800179:	48 bf 12 38 80 00 00 	movabs $0x803812,%rdi
  800180:	00 00 00 
  800183:	b8 00 00 00 00       	mov    $0x0,%eax
  800188:	49 b8 10 04 80 00 00 	movabs $0x800410,%r8
  80018f:	00 00 00 
  800192:	41 ff d0             	callq  *%r8
	memmove(UTEMP, addr, PGSIZE);
  800195:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800199:	ba 00 10 00 00       	mov    $0x1000,%edx
  80019e:	48 89 c6             	mov    %rax,%rsi
  8001a1:	bf 00 00 40 00       	mov    $0x400000,%edi
  8001a6:	48 b8 22 15 80 00 00 	movabs $0x801522,%rax
  8001ad:	00 00 00 
  8001b0:	ff d0                	callq  *%rax
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8001b2:	be 00 00 40 00       	mov    $0x400000,%esi
  8001b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8001bc:	48 b8 d8 1b 80 00 00 	movabs $0x801bd8,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
  8001c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001cf:	79 30                	jns    800201 <duppage+0x12f>
		panic("sys_page_unmap: %e", r);
  8001d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001d4:	89 c1                	mov    %eax,%ecx
  8001d6:	48 ba 33 38 80 00 00 	movabs $0x803833,%rdx
  8001dd:	00 00 00 
  8001e0:	be 25 00 00 00       	mov    $0x25,%esi
  8001e5:	48 bf 12 38 80 00 00 	movabs $0x803812,%rdi
  8001ec:	00 00 00 
  8001ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8001f4:	49 b8 10 04 80 00 00 	movabs $0x800410,%r8
  8001fb:	00 00 00 
  8001fe:	41 ff d0             	callq  *%r8
}
  800201:	c9                   	leaveq 
  800202:	c3                   	retq   

0000000000800203 <dumbfork>:

envid_t
dumbfork(void)
{
  800203:	55                   	push   %rbp
  800204:	48 89 e5             	mov    %rsp,%rbp
  800207:	48 83 ec 20          	sub    $0x20,%rsp
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80020b:	b8 07 00 00 00       	mov    $0x7,%eax
  800210:	cd 30                	int    $0x30
  800212:	89 45 e8             	mov    %eax,-0x18(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  800215:	8b 45 e8             	mov    -0x18(%rbp),%eax
	// Allocate a new child environment.
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
  800218:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (envid < 0)
  80021b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80021f:	79 30                	jns    800251 <dumbfork+0x4e>
		panic("sys_exofork: %e", envid);
  800221:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800224:	89 c1                	mov    %eax,%ecx
  800226:	48 ba 46 38 80 00 00 	movabs $0x803846,%rdx
  80022d:	00 00 00 
  800230:	be 37 00 00 00       	mov    $0x37,%esi
  800235:	48 bf 12 38 80 00 00 	movabs $0x803812,%rdi
  80023c:	00 00 00 
  80023f:	b8 00 00 00 00       	mov    $0x0,%eax
  800244:	49 b8 10 04 80 00 00 	movabs $0x800410,%r8
  80024b:	00 00 00 
  80024e:	41 ff d0             	callq  *%r8
	if (envid == 0) {
  800251:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800255:	75 46                	jne    80029d <dumbfork+0x9a>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  800257:	48 b8 b1 1a 80 00 00 	movabs $0x801ab1,%rax
  80025e:	00 00 00 
  800261:	ff d0                	callq  *%rax
  800263:	25 ff 03 00 00       	and    $0x3ff,%eax
  800268:	48 63 d0             	movslq %eax,%rdx
  80026b:	48 89 d0             	mov    %rdx,%rax
  80026e:	48 c1 e0 03          	shl    $0x3,%rax
  800272:	48 01 d0             	add    %rdx,%rax
  800275:	48 c1 e0 05          	shl    $0x5,%rax
  800279:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800280:	00 00 00 
  800283:	48 01 c2             	add    %rax,%rdx
  800286:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80028d:	00 00 00 
  800290:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  800293:	b8 00 00 00 00       	mov    $0x0,%eax
  800298:	e9 be 00 00 00       	jmpq   80035b <dumbfork+0x158>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  80029d:	48 c7 45 e0 00 00 80 	movq   $0x800000,-0x20(%rbp)
  8002a4:	00 
  8002a5:	eb 26                	jmp    8002cd <dumbfork+0xca>
		duppage(envid, addr);
  8002a7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8002ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002ae:	48 89 d6             	mov    %rdx,%rsi
  8002b1:	89 c7                	mov    %eax,%edi
  8002b3:	48 b8 d2 00 80 00 00 	movabs $0x8000d2,%rax
  8002ba:	00 00 00 
  8002bd:	ff d0                	callq  *%rax
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  8002bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8002c3:	48 05 00 10 00 00    	add    $0x1000,%rax
  8002c9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8002cd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8002d1:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8002d8:	00 00 00 
  8002db:	48 39 c2             	cmp    %rax,%rdx
  8002de:	72 c7                	jb     8002a7 <dumbfork+0xa4>
		duppage(envid, addr);

	// Also copy the stack we are currently running on.
	duppage(envid, ROUNDDOWN(&addr, PGSIZE));
  8002e0:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8002e4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8002e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002ec:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8002f2:	48 89 c2             	mov    %rax,%rdx
  8002f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002f8:	48 89 d6             	mov    %rdx,%rsi
  8002fb:	89 c7                	mov    %eax,%edi
  8002fd:	48 b8 d2 00 80 00 00 	movabs $0x8000d2,%rax
  800304:	00 00 00 
  800307:	ff d0                	callq  *%rax

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  800309:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80030c:	be 02 00 00 00       	mov    $0x2,%esi
  800311:	89 c7                	mov    %eax,%edi
  800313:	48 b8 22 1c 80 00 00 	movabs $0x801c22,%rax
  80031a:	00 00 00 
  80031d:	ff d0                	callq  *%rax
  80031f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800322:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800326:	79 30                	jns    800358 <dumbfork+0x155>
		panic("sys_env_set_status: %e", r);
  800328:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80032b:	89 c1                	mov    %eax,%ecx
  80032d:	48 ba 56 38 80 00 00 	movabs $0x803856,%rdx
  800334:	00 00 00 
  800337:	be 4c 00 00 00       	mov    $0x4c,%esi
  80033c:	48 bf 12 38 80 00 00 	movabs $0x803812,%rdi
  800343:	00 00 00 
  800346:	b8 00 00 00 00       	mov    $0x0,%eax
  80034b:	49 b8 10 04 80 00 00 	movabs $0x800410,%r8
  800352:	00 00 00 
  800355:	41 ff d0             	callq  *%r8

	return envid;
  800358:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80035b:	c9                   	leaveq 
  80035c:	c3                   	retq   

000000000080035d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80035d:	55                   	push   %rbp
  80035e:	48 89 e5             	mov    %rsp,%rbp
  800361:	48 83 ec 10          	sub    $0x10,%rsp
  800365:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800368:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  80036c:	48 b8 b1 1a 80 00 00 	movabs $0x801ab1,%rax
  800373:	00 00 00 
  800376:	ff d0                	callq  *%rax
  800378:	48 98                	cltq   
  80037a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80037f:	48 89 c2             	mov    %rax,%rdx
  800382:	48 89 d0             	mov    %rdx,%rax
  800385:	48 c1 e0 03          	shl    $0x3,%rax
  800389:	48 01 d0             	add    %rdx,%rax
  80038c:	48 c1 e0 05          	shl    $0x5,%rax
  800390:	48 89 c2             	mov    %rax,%rdx
  800393:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80039a:	00 00 00 
  80039d:	48 01 c2             	add    %rax,%rdx
  8003a0:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8003a7:	00 00 00 
  8003aa:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003b1:	7e 14                	jle    8003c7 <libmain+0x6a>
		binaryname = argv[0];
  8003b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003b7:	48 8b 10             	mov    (%rax),%rdx
  8003ba:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8003c1:	00 00 00 
  8003c4:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003c7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003ce:	48 89 d6             	mov    %rdx,%rsi
  8003d1:	89 c7                	mov    %eax,%edi
  8003d3:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8003da:	00 00 00 
  8003dd:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8003df:	48 b8 ed 03 80 00 00 	movabs $0x8003ed,%rax
  8003e6:	00 00 00 
  8003e9:	ff d0                	callq  *%rax
}
  8003eb:	c9                   	leaveq 
  8003ec:	c3                   	retq   

00000000008003ed <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003ed:	55                   	push   %rbp
  8003ee:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8003f1:	48 b8 db 20 80 00 00 	movabs $0x8020db,%rax
  8003f8:	00 00 00 
  8003fb:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8003fd:	bf 00 00 00 00       	mov    $0x0,%edi
  800402:	48 b8 6d 1a 80 00 00 	movabs $0x801a6d,%rax
  800409:	00 00 00 
  80040c:	ff d0                	callq  *%rax
}
  80040e:	5d                   	pop    %rbp
  80040f:	c3                   	retq   

0000000000800410 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800410:	55                   	push   %rbp
  800411:	48 89 e5             	mov    %rsp,%rbp
  800414:	53                   	push   %rbx
  800415:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80041c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800423:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800429:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800430:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800437:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80043e:	84 c0                	test   %al,%al
  800440:	74 23                	je     800465 <_panic+0x55>
  800442:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800449:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80044d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800451:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800455:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800459:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80045d:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800461:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800465:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80046c:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800473:	00 00 00 
  800476:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80047d:	00 00 00 
  800480:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800484:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80048b:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800492:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800499:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8004a0:	00 00 00 
  8004a3:	48 8b 18             	mov    (%rax),%rbx
  8004a6:	48 b8 b1 1a 80 00 00 	movabs $0x801ab1,%rax
  8004ad:	00 00 00 
  8004b0:	ff d0                	callq  *%rax
  8004b2:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8004b8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8004bf:	41 89 c8             	mov    %ecx,%r8d
  8004c2:	48 89 d1             	mov    %rdx,%rcx
  8004c5:	48 89 da             	mov    %rbx,%rdx
  8004c8:	89 c6                	mov    %eax,%esi
  8004ca:	48 bf 78 38 80 00 00 	movabs $0x803878,%rdi
  8004d1:	00 00 00 
  8004d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d9:	49 b9 49 06 80 00 00 	movabs $0x800649,%r9
  8004e0:	00 00 00 
  8004e3:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004e6:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8004ed:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004f4:	48 89 d6             	mov    %rdx,%rsi
  8004f7:	48 89 c7             	mov    %rax,%rdi
  8004fa:	48 b8 9d 05 80 00 00 	movabs $0x80059d,%rax
  800501:	00 00 00 
  800504:	ff d0                	callq  *%rax
	cprintf("\n");
  800506:	48 bf 9b 38 80 00 00 	movabs $0x80389b,%rdi
  80050d:	00 00 00 
  800510:	b8 00 00 00 00       	mov    $0x0,%eax
  800515:	48 ba 49 06 80 00 00 	movabs $0x800649,%rdx
  80051c:	00 00 00 
  80051f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800521:	cc                   	int3   
  800522:	eb fd                	jmp    800521 <_panic+0x111>

0000000000800524 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800524:	55                   	push   %rbp
  800525:	48 89 e5             	mov    %rsp,%rbp
  800528:	48 83 ec 10          	sub    $0x10,%rsp
  80052c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80052f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800533:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800537:	8b 00                	mov    (%rax),%eax
  800539:	8d 48 01             	lea    0x1(%rax),%ecx
  80053c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800540:	89 0a                	mov    %ecx,(%rdx)
  800542:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800545:	89 d1                	mov    %edx,%ecx
  800547:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80054b:	48 98                	cltq   
  80054d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800551:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800555:	8b 00                	mov    (%rax),%eax
  800557:	3d ff 00 00 00       	cmp    $0xff,%eax
  80055c:	75 2c                	jne    80058a <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80055e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800562:	8b 00                	mov    (%rax),%eax
  800564:	48 98                	cltq   
  800566:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80056a:	48 83 c2 08          	add    $0x8,%rdx
  80056e:	48 89 c6             	mov    %rax,%rsi
  800571:	48 89 d7             	mov    %rdx,%rdi
  800574:	48 b8 e5 19 80 00 00 	movabs $0x8019e5,%rax
  80057b:	00 00 00 
  80057e:	ff d0                	callq  *%rax
        b->idx = 0;
  800580:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800584:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80058a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80058e:	8b 40 04             	mov    0x4(%rax),%eax
  800591:	8d 50 01             	lea    0x1(%rax),%edx
  800594:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800598:	89 50 04             	mov    %edx,0x4(%rax)
}
  80059b:	c9                   	leaveq 
  80059c:	c3                   	retq   

000000000080059d <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80059d:	55                   	push   %rbp
  80059e:	48 89 e5             	mov    %rsp,%rbp
  8005a1:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8005a8:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8005af:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8005b6:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8005bd:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005c4:	48 8b 0a             	mov    (%rdx),%rcx
  8005c7:	48 89 08             	mov    %rcx,(%rax)
  8005ca:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005ce:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005d2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005d6:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8005da:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005e1:	00 00 00 
    b.cnt = 0;
  8005e4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8005eb:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8005ee:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8005f5:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8005fc:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800603:	48 89 c6             	mov    %rax,%rsi
  800606:	48 bf 24 05 80 00 00 	movabs $0x800524,%rdi
  80060d:	00 00 00 
  800610:	48 b8 fc 09 80 00 00 	movabs $0x8009fc,%rax
  800617:	00 00 00 
  80061a:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80061c:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800622:	48 98                	cltq   
  800624:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80062b:	48 83 c2 08          	add    $0x8,%rdx
  80062f:	48 89 c6             	mov    %rax,%rsi
  800632:	48 89 d7             	mov    %rdx,%rdi
  800635:	48 b8 e5 19 80 00 00 	movabs $0x8019e5,%rax
  80063c:	00 00 00 
  80063f:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800641:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800647:	c9                   	leaveq 
  800648:	c3                   	retq   

0000000000800649 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800649:	55                   	push   %rbp
  80064a:	48 89 e5             	mov    %rsp,%rbp
  80064d:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800654:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80065b:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800662:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800669:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800670:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800677:	84 c0                	test   %al,%al
  800679:	74 20                	je     80069b <cprintf+0x52>
  80067b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80067f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800683:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800687:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80068b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80068f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800693:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800697:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80069b:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8006a2:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8006a9:	00 00 00 
  8006ac:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8006b3:	00 00 00 
  8006b6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006ba:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8006c1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006c8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8006cf:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006d6:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006dd:	48 8b 0a             	mov    (%rdx),%rcx
  8006e0:	48 89 08             	mov    %rcx,(%rax)
  8006e3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006e7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006eb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006ef:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8006f3:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8006fa:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800701:	48 89 d6             	mov    %rdx,%rsi
  800704:	48 89 c7             	mov    %rax,%rdi
  800707:	48 b8 9d 05 80 00 00 	movabs $0x80059d,%rax
  80070e:	00 00 00 
  800711:	ff d0                	callq  *%rax
  800713:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800719:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80071f:	c9                   	leaveq 
  800720:	c3                   	retq   

0000000000800721 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800721:	55                   	push   %rbp
  800722:	48 89 e5             	mov    %rsp,%rbp
  800725:	53                   	push   %rbx
  800726:	48 83 ec 38          	sub    $0x38,%rsp
  80072a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80072e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800732:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800736:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800739:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80073d:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800741:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800744:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800748:	77 3b                	ja     800785 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80074a:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80074d:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800751:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800754:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800758:	ba 00 00 00 00       	mov    $0x0,%edx
  80075d:	48 f7 f3             	div    %rbx
  800760:	48 89 c2             	mov    %rax,%rdx
  800763:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800766:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800769:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80076d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800771:	41 89 f9             	mov    %edi,%r9d
  800774:	48 89 c7             	mov    %rax,%rdi
  800777:	48 b8 21 07 80 00 00 	movabs $0x800721,%rax
  80077e:	00 00 00 
  800781:	ff d0                	callq  *%rax
  800783:	eb 1e                	jmp    8007a3 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800785:	eb 12                	jmp    800799 <printnum+0x78>
			putch(padc, putdat);
  800787:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80078b:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80078e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800792:	48 89 ce             	mov    %rcx,%rsi
  800795:	89 d7                	mov    %edx,%edi
  800797:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800799:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80079d:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8007a1:	7f e4                	jg     800787 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007a3:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8007a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8007af:	48 f7 f1             	div    %rcx
  8007b2:	48 89 d0             	mov    %rdx,%rax
  8007b5:	48 ba 90 3a 80 00 00 	movabs $0x803a90,%rdx
  8007bc:	00 00 00 
  8007bf:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8007c3:	0f be d0             	movsbl %al,%edx
  8007c6:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ce:	48 89 ce             	mov    %rcx,%rsi
  8007d1:	89 d7                	mov    %edx,%edi
  8007d3:	ff d0                	callq  *%rax
}
  8007d5:	48 83 c4 38          	add    $0x38,%rsp
  8007d9:	5b                   	pop    %rbx
  8007da:	5d                   	pop    %rbp
  8007db:	c3                   	retq   

00000000008007dc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007dc:	55                   	push   %rbp
  8007dd:	48 89 e5             	mov    %rsp,%rbp
  8007e0:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007e8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8007eb:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007ef:	7e 52                	jle    800843 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8007f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f5:	8b 00                	mov    (%rax),%eax
  8007f7:	83 f8 30             	cmp    $0x30,%eax
  8007fa:	73 24                	jae    800820 <getuint+0x44>
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
  80081e:	eb 17                	jmp    800837 <getuint+0x5b>
  800820:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800824:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800828:	48 89 d0             	mov    %rdx,%rax
  80082b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80082f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800833:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800837:	48 8b 00             	mov    (%rax),%rax
  80083a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80083e:	e9 a3 00 00 00       	jmpq   8008e6 <getuint+0x10a>
	else if (lflag)
  800843:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800847:	74 4f                	je     800898 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800849:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084d:	8b 00                	mov    (%rax),%eax
  80084f:	83 f8 30             	cmp    $0x30,%eax
  800852:	73 24                	jae    800878 <getuint+0x9c>
  800854:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800858:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80085c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800860:	8b 00                	mov    (%rax),%eax
  800862:	89 c0                	mov    %eax,%eax
  800864:	48 01 d0             	add    %rdx,%rax
  800867:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80086b:	8b 12                	mov    (%rdx),%edx
  80086d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800870:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800874:	89 0a                	mov    %ecx,(%rdx)
  800876:	eb 17                	jmp    80088f <getuint+0xb3>
  800878:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800880:	48 89 d0             	mov    %rdx,%rax
  800883:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800887:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80088b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80088f:	48 8b 00             	mov    (%rax),%rax
  800892:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800896:	eb 4e                	jmp    8008e6 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800898:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089c:	8b 00                	mov    (%rax),%eax
  80089e:	83 f8 30             	cmp    $0x30,%eax
  8008a1:	73 24                	jae    8008c7 <getuint+0xeb>
  8008a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008af:	8b 00                	mov    (%rax),%eax
  8008b1:	89 c0                	mov    %eax,%eax
  8008b3:	48 01 d0             	add    %rdx,%rax
  8008b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ba:	8b 12                	mov    (%rdx),%edx
  8008bc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008c3:	89 0a                	mov    %ecx,(%rdx)
  8008c5:	eb 17                	jmp    8008de <getuint+0x102>
  8008c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008cb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008cf:	48 89 d0             	mov    %rdx,%rax
  8008d2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008da:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008de:	8b 00                	mov    (%rax),%eax
  8008e0:	89 c0                	mov    %eax,%eax
  8008e2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008ea:	c9                   	leaveq 
  8008eb:	c3                   	retq   

00000000008008ec <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008ec:	55                   	push   %rbp
  8008ed:	48 89 e5             	mov    %rsp,%rbp
  8008f0:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008f8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8008fb:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008ff:	7e 52                	jle    800953 <getint+0x67>
		x=va_arg(*ap, long long);
  800901:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800905:	8b 00                	mov    (%rax),%eax
  800907:	83 f8 30             	cmp    $0x30,%eax
  80090a:	73 24                	jae    800930 <getint+0x44>
  80090c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800910:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800914:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800918:	8b 00                	mov    (%rax),%eax
  80091a:	89 c0                	mov    %eax,%eax
  80091c:	48 01 d0             	add    %rdx,%rax
  80091f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800923:	8b 12                	mov    (%rdx),%edx
  800925:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800928:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80092c:	89 0a                	mov    %ecx,(%rdx)
  80092e:	eb 17                	jmp    800947 <getint+0x5b>
  800930:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800934:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800938:	48 89 d0             	mov    %rdx,%rax
  80093b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80093f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800943:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800947:	48 8b 00             	mov    (%rax),%rax
  80094a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80094e:	e9 a3 00 00 00       	jmpq   8009f6 <getint+0x10a>
	else if (lflag)
  800953:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800957:	74 4f                	je     8009a8 <getint+0xbc>
		x=va_arg(*ap, long);
  800959:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095d:	8b 00                	mov    (%rax),%eax
  80095f:	83 f8 30             	cmp    $0x30,%eax
  800962:	73 24                	jae    800988 <getint+0x9c>
  800964:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800968:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80096c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800970:	8b 00                	mov    (%rax),%eax
  800972:	89 c0                	mov    %eax,%eax
  800974:	48 01 d0             	add    %rdx,%rax
  800977:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80097b:	8b 12                	mov    (%rdx),%edx
  80097d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800980:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800984:	89 0a                	mov    %ecx,(%rdx)
  800986:	eb 17                	jmp    80099f <getint+0xb3>
  800988:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800990:	48 89 d0             	mov    %rdx,%rax
  800993:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800997:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80099b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80099f:	48 8b 00             	mov    (%rax),%rax
  8009a2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009a6:	eb 4e                	jmp    8009f6 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8009a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ac:	8b 00                	mov    (%rax),%eax
  8009ae:	83 f8 30             	cmp    $0x30,%eax
  8009b1:	73 24                	jae    8009d7 <getint+0xeb>
  8009b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009bf:	8b 00                	mov    (%rax),%eax
  8009c1:	89 c0                	mov    %eax,%eax
  8009c3:	48 01 d0             	add    %rdx,%rax
  8009c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ca:	8b 12                	mov    (%rdx),%edx
  8009cc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d3:	89 0a                	mov    %ecx,(%rdx)
  8009d5:	eb 17                	jmp    8009ee <getint+0x102>
  8009d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009db:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009df:	48 89 d0             	mov    %rdx,%rax
  8009e2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ea:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009ee:	8b 00                	mov    (%rax),%eax
  8009f0:	48 98                	cltq   
  8009f2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009fa:	c9                   	leaveq 
  8009fb:	c3                   	retq   

00000000008009fc <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009fc:	55                   	push   %rbp
  8009fd:	48 89 e5             	mov    %rsp,%rbp
  800a00:	41 54                	push   %r12
  800a02:	53                   	push   %rbx
  800a03:	48 83 ec 60          	sub    $0x60,%rsp
  800a07:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800a0b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800a0f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a13:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800a17:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a1b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800a1f:	48 8b 0a             	mov    (%rdx),%rcx
  800a22:	48 89 08             	mov    %rcx,(%rax)
  800a25:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a29:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a2d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a31:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a35:	eb 17                	jmp    800a4e <vprintfmt+0x52>
			if (ch == '\0')
  800a37:	85 db                	test   %ebx,%ebx
  800a39:	0f 84 cc 04 00 00    	je     800f0b <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800a3f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a43:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a47:	48 89 d6             	mov    %rdx,%rsi
  800a4a:	89 df                	mov    %ebx,%edi
  800a4c:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a4e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a52:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a56:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a5a:	0f b6 00             	movzbl (%rax),%eax
  800a5d:	0f b6 d8             	movzbl %al,%ebx
  800a60:	83 fb 25             	cmp    $0x25,%ebx
  800a63:	75 d2                	jne    800a37 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a65:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a69:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a70:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a77:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a7e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a85:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a89:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a8d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a91:	0f b6 00             	movzbl (%rax),%eax
  800a94:	0f b6 d8             	movzbl %al,%ebx
  800a97:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a9a:	83 f8 55             	cmp    $0x55,%eax
  800a9d:	0f 87 34 04 00 00    	ja     800ed7 <vprintfmt+0x4db>
  800aa3:	89 c0                	mov    %eax,%eax
  800aa5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800aac:	00 
  800aad:	48 b8 b8 3a 80 00 00 	movabs $0x803ab8,%rax
  800ab4:	00 00 00 
  800ab7:	48 01 d0             	add    %rdx,%rax
  800aba:	48 8b 00             	mov    (%rax),%rax
  800abd:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800abf:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800ac3:	eb c0                	jmp    800a85 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ac5:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800ac9:	eb ba                	jmp    800a85 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800acb:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800ad2:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800ad5:	89 d0                	mov    %edx,%eax
  800ad7:	c1 e0 02             	shl    $0x2,%eax
  800ada:	01 d0                	add    %edx,%eax
  800adc:	01 c0                	add    %eax,%eax
  800ade:	01 d8                	add    %ebx,%eax
  800ae0:	83 e8 30             	sub    $0x30,%eax
  800ae3:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800ae6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800aea:	0f b6 00             	movzbl (%rax),%eax
  800aed:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800af0:	83 fb 2f             	cmp    $0x2f,%ebx
  800af3:	7e 0c                	jle    800b01 <vprintfmt+0x105>
  800af5:	83 fb 39             	cmp    $0x39,%ebx
  800af8:	7f 07                	jg     800b01 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800afa:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800aff:	eb d1                	jmp    800ad2 <vprintfmt+0xd6>
			goto process_precision;
  800b01:	eb 58                	jmp    800b5b <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800b03:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b06:	83 f8 30             	cmp    $0x30,%eax
  800b09:	73 17                	jae    800b22 <vprintfmt+0x126>
  800b0b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b0f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b12:	89 c0                	mov    %eax,%eax
  800b14:	48 01 d0             	add    %rdx,%rax
  800b17:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b1a:	83 c2 08             	add    $0x8,%edx
  800b1d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b20:	eb 0f                	jmp    800b31 <vprintfmt+0x135>
  800b22:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b26:	48 89 d0             	mov    %rdx,%rax
  800b29:	48 83 c2 08          	add    $0x8,%rdx
  800b2d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b31:	8b 00                	mov    (%rax),%eax
  800b33:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b36:	eb 23                	jmp    800b5b <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800b38:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b3c:	79 0c                	jns    800b4a <vprintfmt+0x14e>
				width = 0;
  800b3e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b45:	e9 3b ff ff ff       	jmpq   800a85 <vprintfmt+0x89>
  800b4a:	e9 36 ff ff ff       	jmpq   800a85 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800b4f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b56:	e9 2a ff ff ff       	jmpq   800a85 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800b5b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b5f:	79 12                	jns    800b73 <vprintfmt+0x177>
				width = precision, precision = -1;
  800b61:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b64:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b67:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b6e:	e9 12 ff ff ff       	jmpq   800a85 <vprintfmt+0x89>
  800b73:	e9 0d ff ff ff       	jmpq   800a85 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b78:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b7c:	e9 04 ff ff ff       	jmpq   800a85 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b81:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b84:	83 f8 30             	cmp    $0x30,%eax
  800b87:	73 17                	jae    800ba0 <vprintfmt+0x1a4>
  800b89:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b8d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b90:	89 c0                	mov    %eax,%eax
  800b92:	48 01 d0             	add    %rdx,%rax
  800b95:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b98:	83 c2 08             	add    $0x8,%edx
  800b9b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b9e:	eb 0f                	jmp    800baf <vprintfmt+0x1b3>
  800ba0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ba4:	48 89 d0             	mov    %rdx,%rax
  800ba7:	48 83 c2 08          	add    $0x8,%rdx
  800bab:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800baf:	8b 10                	mov    (%rax),%edx
  800bb1:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800bb5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb9:	48 89 ce             	mov    %rcx,%rsi
  800bbc:	89 d7                	mov    %edx,%edi
  800bbe:	ff d0                	callq  *%rax
			break;
  800bc0:	e9 40 03 00 00       	jmpq   800f05 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800bc5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc8:	83 f8 30             	cmp    $0x30,%eax
  800bcb:	73 17                	jae    800be4 <vprintfmt+0x1e8>
  800bcd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bd1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bd4:	89 c0                	mov    %eax,%eax
  800bd6:	48 01 d0             	add    %rdx,%rax
  800bd9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bdc:	83 c2 08             	add    $0x8,%edx
  800bdf:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800be2:	eb 0f                	jmp    800bf3 <vprintfmt+0x1f7>
  800be4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800be8:	48 89 d0             	mov    %rdx,%rax
  800beb:	48 83 c2 08          	add    $0x8,%rdx
  800bef:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bf3:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800bf5:	85 db                	test   %ebx,%ebx
  800bf7:	79 02                	jns    800bfb <vprintfmt+0x1ff>
				err = -err;
  800bf9:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800bfb:	83 fb 15             	cmp    $0x15,%ebx
  800bfe:	7f 16                	jg     800c16 <vprintfmt+0x21a>
  800c00:	48 b8 e0 39 80 00 00 	movabs $0x8039e0,%rax
  800c07:	00 00 00 
  800c0a:	48 63 d3             	movslq %ebx,%rdx
  800c0d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c11:	4d 85 e4             	test   %r12,%r12
  800c14:	75 2e                	jne    800c44 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800c16:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c1a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c1e:	89 d9                	mov    %ebx,%ecx
  800c20:	48 ba a1 3a 80 00 00 	movabs $0x803aa1,%rdx
  800c27:	00 00 00 
  800c2a:	48 89 c7             	mov    %rax,%rdi
  800c2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c32:	49 b8 14 0f 80 00 00 	movabs $0x800f14,%r8
  800c39:	00 00 00 
  800c3c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c3f:	e9 c1 02 00 00       	jmpq   800f05 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c44:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c48:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c4c:	4c 89 e1             	mov    %r12,%rcx
  800c4f:	48 ba aa 3a 80 00 00 	movabs $0x803aaa,%rdx
  800c56:	00 00 00 
  800c59:	48 89 c7             	mov    %rax,%rdi
  800c5c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c61:	49 b8 14 0f 80 00 00 	movabs $0x800f14,%r8
  800c68:	00 00 00 
  800c6b:	41 ff d0             	callq  *%r8
			break;
  800c6e:	e9 92 02 00 00       	jmpq   800f05 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c73:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c76:	83 f8 30             	cmp    $0x30,%eax
  800c79:	73 17                	jae    800c92 <vprintfmt+0x296>
  800c7b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c7f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c82:	89 c0                	mov    %eax,%eax
  800c84:	48 01 d0             	add    %rdx,%rax
  800c87:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c8a:	83 c2 08             	add    $0x8,%edx
  800c8d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c90:	eb 0f                	jmp    800ca1 <vprintfmt+0x2a5>
  800c92:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c96:	48 89 d0             	mov    %rdx,%rax
  800c99:	48 83 c2 08          	add    $0x8,%rdx
  800c9d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ca1:	4c 8b 20             	mov    (%rax),%r12
  800ca4:	4d 85 e4             	test   %r12,%r12
  800ca7:	75 0a                	jne    800cb3 <vprintfmt+0x2b7>
				p = "(null)";
  800ca9:	49 bc ad 3a 80 00 00 	movabs $0x803aad,%r12
  800cb0:	00 00 00 
			if (width > 0 && padc != '-')
  800cb3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cb7:	7e 3f                	jle    800cf8 <vprintfmt+0x2fc>
  800cb9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800cbd:	74 39                	je     800cf8 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cbf:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800cc2:	48 98                	cltq   
  800cc4:	48 89 c6             	mov    %rax,%rsi
  800cc7:	4c 89 e7             	mov    %r12,%rdi
  800cca:	48 b8 c0 11 80 00 00 	movabs $0x8011c0,%rax
  800cd1:	00 00 00 
  800cd4:	ff d0                	callq  *%rax
  800cd6:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800cd9:	eb 17                	jmp    800cf2 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800cdb:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800cdf:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ce3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ce7:	48 89 ce             	mov    %rcx,%rsi
  800cea:	89 d7                	mov    %edx,%edi
  800cec:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800cee:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cf2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cf6:	7f e3                	jg     800cdb <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cf8:	eb 37                	jmp    800d31 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800cfa:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800cfe:	74 1e                	je     800d1e <vprintfmt+0x322>
  800d00:	83 fb 1f             	cmp    $0x1f,%ebx
  800d03:	7e 05                	jle    800d0a <vprintfmt+0x30e>
  800d05:	83 fb 7e             	cmp    $0x7e,%ebx
  800d08:	7e 14                	jle    800d1e <vprintfmt+0x322>
					putch('?', putdat);
  800d0a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d0e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d12:	48 89 d6             	mov    %rdx,%rsi
  800d15:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d1a:	ff d0                	callq  *%rax
  800d1c:	eb 0f                	jmp    800d2d <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800d1e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d22:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d26:	48 89 d6             	mov    %rdx,%rsi
  800d29:	89 df                	mov    %ebx,%edi
  800d2b:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d2d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d31:	4c 89 e0             	mov    %r12,%rax
  800d34:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d38:	0f b6 00             	movzbl (%rax),%eax
  800d3b:	0f be d8             	movsbl %al,%ebx
  800d3e:	85 db                	test   %ebx,%ebx
  800d40:	74 10                	je     800d52 <vprintfmt+0x356>
  800d42:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d46:	78 b2                	js     800cfa <vprintfmt+0x2fe>
  800d48:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d4c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d50:	79 a8                	jns    800cfa <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d52:	eb 16                	jmp    800d6a <vprintfmt+0x36e>
				putch(' ', putdat);
  800d54:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d58:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d5c:	48 89 d6             	mov    %rdx,%rsi
  800d5f:	bf 20 00 00 00       	mov    $0x20,%edi
  800d64:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d66:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d6a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d6e:	7f e4                	jg     800d54 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800d70:	e9 90 01 00 00       	jmpq   800f05 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d75:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d79:	be 03 00 00 00       	mov    $0x3,%esi
  800d7e:	48 89 c7             	mov    %rax,%rdi
  800d81:	48 b8 ec 08 80 00 00 	movabs $0x8008ec,%rax
  800d88:	00 00 00 
  800d8b:	ff d0                	callq  *%rax
  800d8d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d95:	48 85 c0             	test   %rax,%rax
  800d98:	79 1d                	jns    800db7 <vprintfmt+0x3bb>
				putch('-', putdat);
  800d9a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d9e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800da2:	48 89 d6             	mov    %rdx,%rsi
  800da5:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800daa:	ff d0                	callq  *%rax
				num = -(long long) num;
  800dac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800db0:	48 f7 d8             	neg    %rax
  800db3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800db7:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800dbe:	e9 d5 00 00 00       	jmpq   800e98 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800dc3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dc7:	be 03 00 00 00       	mov    $0x3,%esi
  800dcc:	48 89 c7             	mov    %rax,%rdi
  800dcf:	48 b8 dc 07 80 00 00 	movabs $0x8007dc,%rax
  800dd6:	00 00 00 
  800dd9:	ff d0                	callq  *%rax
  800ddb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ddf:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800de6:	e9 ad 00 00 00       	jmpq   800e98 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  800deb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800def:	be 03 00 00 00       	mov    $0x3,%esi
  800df4:	48 89 c7             	mov    %rax,%rdi
  800df7:	48 b8 dc 07 80 00 00 	movabs $0x8007dc,%rax
  800dfe:	00 00 00 
  800e01:	ff d0                	callq  *%rax
  800e03:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  800e07:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  800e0e:	e9 85 00 00 00       	jmpq   800e98 <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  800e13:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e17:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e1b:	48 89 d6             	mov    %rdx,%rsi
  800e1e:	bf 30 00 00 00       	mov    $0x30,%edi
  800e23:	ff d0                	callq  *%rax
			putch('x', putdat);
  800e25:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e29:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e2d:	48 89 d6             	mov    %rdx,%rsi
  800e30:	bf 78 00 00 00       	mov    $0x78,%edi
  800e35:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e37:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e3a:	83 f8 30             	cmp    $0x30,%eax
  800e3d:	73 17                	jae    800e56 <vprintfmt+0x45a>
  800e3f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e43:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e46:	89 c0                	mov    %eax,%eax
  800e48:	48 01 d0             	add    %rdx,%rax
  800e4b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e4e:	83 c2 08             	add    $0x8,%edx
  800e51:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e54:	eb 0f                	jmp    800e65 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800e56:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e5a:	48 89 d0             	mov    %rdx,%rax
  800e5d:	48 83 c2 08          	add    $0x8,%rdx
  800e61:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e65:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e68:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e6c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e73:	eb 23                	jmp    800e98 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e75:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e79:	be 03 00 00 00       	mov    $0x3,%esi
  800e7e:	48 89 c7             	mov    %rax,%rdi
  800e81:	48 b8 dc 07 80 00 00 	movabs $0x8007dc,%rax
  800e88:	00 00 00 
  800e8b:	ff d0                	callq  *%rax
  800e8d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e91:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e98:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e9d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ea0:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ea3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ea7:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800eab:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eaf:	45 89 c1             	mov    %r8d,%r9d
  800eb2:	41 89 f8             	mov    %edi,%r8d
  800eb5:	48 89 c7             	mov    %rax,%rdi
  800eb8:	48 b8 21 07 80 00 00 	movabs $0x800721,%rax
  800ebf:	00 00 00 
  800ec2:	ff d0                	callq  *%rax
			break;
  800ec4:	eb 3f                	jmp    800f05 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ec6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ece:	48 89 d6             	mov    %rdx,%rsi
  800ed1:	89 df                	mov    %ebx,%edi
  800ed3:	ff d0                	callq  *%rax
			break;
  800ed5:	eb 2e                	jmp    800f05 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ed7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800edb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800edf:	48 89 d6             	mov    %rdx,%rsi
  800ee2:	bf 25 00 00 00       	mov    $0x25,%edi
  800ee7:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ee9:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800eee:	eb 05                	jmp    800ef5 <vprintfmt+0x4f9>
  800ef0:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ef5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ef9:	48 83 e8 01          	sub    $0x1,%rax
  800efd:	0f b6 00             	movzbl (%rax),%eax
  800f00:	3c 25                	cmp    $0x25,%al
  800f02:	75 ec                	jne    800ef0 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800f04:	90                   	nop
		}
	}
  800f05:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f06:	e9 43 fb ff ff       	jmpq   800a4e <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800f0b:	48 83 c4 60          	add    $0x60,%rsp
  800f0f:	5b                   	pop    %rbx
  800f10:	41 5c                	pop    %r12
  800f12:	5d                   	pop    %rbp
  800f13:	c3                   	retq   

0000000000800f14 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f14:	55                   	push   %rbp
  800f15:	48 89 e5             	mov    %rsp,%rbp
  800f18:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f1f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f26:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f2d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f34:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f3b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f42:	84 c0                	test   %al,%al
  800f44:	74 20                	je     800f66 <printfmt+0x52>
  800f46:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f4a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f4e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f52:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f56:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f5a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f5e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f62:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f66:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f6d:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f74:	00 00 00 
  800f77:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f7e:	00 00 00 
  800f81:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f85:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f8c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f93:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f9a:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800fa1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800fa8:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800faf:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800fb6:	48 89 c7             	mov    %rax,%rdi
  800fb9:	48 b8 fc 09 80 00 00 	movabs $0x8009fc,%rax
  800fc0:	00 00 00 
  800fc3:	ff d0                	callq  *%rax
	va_end(ap);
}
  800fc5:	c9                   	leaveq 
  800fc6:	c3                   	retq   

0000000000800fc7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fc7:	55                   	push   %rbp
  800fc8:	48 89 e5             	mov    %rsp,%rbp
  800fcb:	48 83 ec 10          	sub    $0x10,%rsp
  800fcf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fd2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800fd6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fda:	8b 40 10             	mov    0x10(%rax),%eax
  800fdd:	8d 50 01             	lea    0x1(%rax),%edx
  800fe0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fe4:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800fe7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800feb:	48 8b 10             	mov    (%rax),%rdx
  800fee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff2:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ff6:	48 39 c2             	cmp    %rax,%rdx
  800ff9:	73 17                	jae    801012 <sprintputch+0x4b>
		*b->buf++ = ch;
  800ffb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fff:	48 8b 00             	mov    (%rax),%rax
  801002:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801006:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80100a:	48 89 0a             	mov    %rcx,(%rdx)
  80100d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801010:	88 10                	mov    %dl,(%rax)
}
  801012:	c9                   	leaveq 
  801013:	c3                   	retq   

0000000000801014 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801014:	55                   	push   %rbp
  801015:	48 89 e5             	mov    %rsp,%rbp
  801018:	48 83 ec 50          	sub    $0x50,%rsp
  80101c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801020:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801023:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801027:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80102b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80102f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801033:	48 8b 0a             	mov    (%rdx),%rcx
  801036:	48 89 08             	mov    %rcx,(%rax)
  801039:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80103d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801041:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801045:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801049:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80104d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801051:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801054:	48 98                	cltq   
  801056:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80105a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80105e:	48 01 d0             	add    %rdx,%rax
  801061:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801065:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80106c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801071:	74 06                	je     801079 <vsnprintf+0x65>
  801073:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801077:	7f 07                	jg     801080 <vsnprintf+0x6c>
		return -E_INVAL;
  801079:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80107e:	eb 2f                	jmp    8010af <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801080:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801084:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801088:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80108c:	48 89 c6             	mov    %rax,%rsi
  80108f:	48 bf c7 0f 80 00 00 	movabs $0x800fc7,%rdi
  801096:	00 00 00 
  801099:	48 b8 fc 09 80 00 00 	movabs $0x8009fc,%rax
  8010a0:	00 00 00 
  8010a3:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8010a5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8010a9:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8010ac:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8010af:	c9                   	leaveq 
  8010b0:	c3                   	retq   

00000000008010b1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010b1:	55                   	push   %rbp
  8010b2:	48 89 e5             	mov    %rsp,%rbp
  8010b5:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8010bc:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8010c3:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8010c9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010d0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010d7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010de:	84 c0                	test   %al,%al
  8010e0:	74 20                	je     801102 <snprintf+0x51>
  8010e2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010e6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010ea:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010ee:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010f2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010f6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8010fa:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010fe:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801102:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801109:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801110:	00 00 00 
  801113:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80111a:	00 00 00 
  80111d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801121:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801128:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80112f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801136:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80113d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801144:	48 8b 0a             	mov    (%rdx),%rcx
  801147:	48 89 08             	mov    %rcx,(%rax)
  80114a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80114e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801152:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801156:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80115a:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801161:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801168:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80116e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801175:	48 89 c7             	mov    %rax,%rdi
  801178:	48 b8 14 10 80 00 00 	movabs $0x801014,%rax
  80117f:	00 00 00 
  801182:	ff d0                	callq  *%rax
  801184:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80118a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801190:	c9                   	leaveq 
  801191:	c3                   	retq   

0000000000801192 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801192:	55                   	push   %rbp
  801193:	48 89 e5             	mov    %rsp,%rbp
  801196:	48 83 ec 18          	sub    $0x18,%rsp
  80119a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80119e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011a5:	eb 09                	jmp    8011b0 <strlen+0x1e>
		n++;
  8011a7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011ab:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b4:	0f b6 00             	movzbl (%rax),%eax
  8011b7:	84 c0                	test   %al,%al
  8011b9:	75 ec                	jne    8011a7 <strlen+0x15>
		n++;
	return n;
  8011bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011be:	c9                   	leaveq 
  8011bf:	c3                   	retq   

00000000008011c0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8011c0:	55                   	push   %rbp
  8011c1:	48 89 e5             	mov    %rsp,%rbp
  8011c4:	48 83 ec 20          	sub    $0x20,%rsp
  8011c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011cc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011d7:	eb 0e                	jmp    8011e7 <strnlen+0x27>
		n++;
  8011d9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011dd:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011e2:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8011e7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8011ec:	74 0b                	je     8011f9 <strnlen+0x39>
  8011ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f2:	0f b6 00             	movzbl (%rax),%eax
  8011f5:	84 c0                	test   %al,%al
  8011f7:	75 e0                	jne    8011d9 <strnlen+0x19>
		n++;
	return n;
  8011f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011fc:	c9                   	leaveq 
  8011fd:	c3                   	retq   

00000000008011fe <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011fe:	55                   	push   %rbp
  8011ff:	48 89 e5             	mov    %rsp,%rbp
  801202:	48 83 ec 20          	sub    $0x20,%rsp
  801206:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80120a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80120e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801212:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801216:	90                   	nop
  801217:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80121b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80121f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801223:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801227:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80122b:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80122f:	0f b6 12             	movzbl (%rdx),%edx
  801232:	88 10                	mov    %dl,(%rax)
  801234:	0f b6 00             	movzbl (%rax),%eax
  801237:	84 c0                	test   %al,%al
  801239:	75 dc                	jne    801217 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80123b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80123f:	c9                   	leaveq 
  801240:	c3                   	retq   

0000000000801241 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801241:	55                   	push   %rbp
  801242:	48 89 e5             	mov    %rsp,%rbp
  801245:	48 83 ec 20          	sub    $0x20,%rsp
  801249:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80124d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801251:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801255:	48 89 c7             	mov    %rax,%rdi
  801258:	48 b8 92 11 80 00 00 	movabs $0x801192,%rax
  80125f:	00 00 00 
  801262:	ff d0                	callq  *%rax
  801264:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801267:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80126a:	48 63 d0             	movslq %eax,%rdx
  80126d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801271:	48 01 c2             	add    %rax,%rdx
  801274:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801278:	48 89 c6             	mov    %rax,%rsi
  80127b:	48 89 d7             	mov    %rdx,%rdi
  80127e:	48 b8 fe 11 80 00 00 	movabs $0x8011fe,%rax
  801285:	00 00 00 
  801288:	ff d0                	callq  *%rax
	return dst;
  80128a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80128e:	c9                   	leaveq 
  80128f:	c3                   	retq   

0000000000801290 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801290:	55                   	push   %rbp
  801291:	48 89 e5             	mov    %rsp,%rbp
  801294:	48 83 ec 28          	sub    $0x28,%rsp
  801298:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80129c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8012a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8012ac:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8012b3:	00 
  8012b4:	eb 2a                	jmp    8012e0 <strncpy+0x50>
		*dst++ = *src;
  8012b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ba:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012be:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012c2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012c6:	0f b6 12             	movzbl (%rdx),%edx
  8012c9:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012cf:	0f b6 00             	movzbl (%rax),%eax
  8012d2:	84 c0                	test   %al,%al
  8012d4:	74 05                	je     8012db <strncpy+0x4b>
			src++;
  8012d6:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012db:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8012e8:	72 cc                	jb     8012b6 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8012ee:	c9                   	leaveq 
  8012ef:	c3                   	retq   

00000000008012f0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8012f0:	55                   	push   %rbp
  8012f1:	48 89 e5             	mov    %rsp,%rbp
  8012f4:	48 83 ec 28          	sub    $0x28,%rsp
  8012f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801300:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801304:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801308:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80130c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801311:	74 3d                	je     801350 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801313:	eb 1d                	jmp    801332 <strlcpy+0x42>
			*dst++ = *src++;
  801315:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801319:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80131d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801321:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801325:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801329:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80132d:	0f b6 12             	movzbl (%rdx),%edx
  801330:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801332:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801337:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80133c:	74 0b                	je     801349 <strlcpy+0x59>
  80133e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801342:	0f b6 00             	movzbl (%rax),%eax
  801345:	84 c0                	test   %al,%al
  801347:	75 cc                	jne    801315 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801349:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80134d:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801350:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801354:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801358:	48 29 c2             	sub    %rax,%rdx
  80135b:	48 89 d0             	mov    %rdx,%rax
}
  80135e:	c9                   	leaveq 
  80135f:	c3                   	retq   

0000000000801360 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801360:	55                   	push   %rbp
  801361:	48 89 e5             	mov    %rsp,%rbp
  801364:	48 83 ec 10          	sub    $0x10,%rsp
  801368:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80136c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801370:	eb 0a                	jmp    80137c <strcmp+0x1c>
		p++, q++;
  801372:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801377:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80137c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801380:	0f b6 00             	movzbl (%rax),%eax
  801383:	84 c0                	test   %al,%al
  801385:	74 12                	je     801399 <strcmp+0x39>
  801387:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80138b:	0f b6 10             	movzbl (%rax),%edx
  80138e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801392:	0f b6 00             	movzbl (%rax),%eax
  801395:	38 c2                	cmp    %al,%dl
  801397:	74 d9                	je     801372 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801399:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139d:	0f b6 00             	movzbl (%rax),%eax
  8013a0:	0f b6 d0             	movzbl %al,%edx
  8013a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a7:	0f b6 00             	movzbl (%rax),%eax
  8013aa:	0f b6 c0             	movzbl %al,%eax
  8013ad:	29 c2                	sub    %eax,%edx
  8013af:	89 d0                	mov    %edx,%eax
}
  8013b1:	c9                   	leaveq 
  8013b2:	c3                   	retq   

00000000008013b3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8013b3:	55                   	push   %rbp
  8013b4:	48 89 e5             	mov    %rsp,%rbp
  8013b7:	48 83 ec 18          	sub    $0x18,%rsp
  8013bb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013bf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013c3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8013c7:	eb 0f                	jmp    8013d8 <strncmp+0x25>
		n--, p++, q++;
  8013c9:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8013ce:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013d3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8013d8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013dd:	74 1d                	je     8013fc <strncmp+0x49>
  8013df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e3:	0f b6 00             	movzbl (%rax),%eax
  8013e6:	84 c0                	test   %al,%al
  8013e8:	74 12                	je     8013fc <strncmp+0x49>
  8013ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ee:	0f b6 10             	movzbl (%rax),%edx
  8013f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013f5:	0f b6 00             	movzbl (%rax),%eax
  8013f8:	38 c2                	cmp    %al,%dl
  8013fa:	74 cd                	je     8013c9 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8013fc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801401:	75 07                	jne    80140a <strncmp+0x57>
		return 0;
  801403:	b8 00 00 00 00       	mov    $0x0,%eax
  801408:	eb 18                	jmp    801422 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80140a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80140e:	0f b6 00             	movzbl (%rax),%eax
  801411:	0f b6 d0             	movzbl %al,%edx
  801414:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801418:	0f b6 00             	movzbl (%rax),%eax
  80141b:	0f b6 c0             	movzbl %al,%eax
  80141e:	29 c2                	sub    %eax,%edx
  801420:	89 d0                	mov    %edx,%eax
}
  801422:	c9                   	leaveq 
  801423:	c3                   	retq   

0000000000801424 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801424:	55                   	push   %rbp
  801425:	48 89 e5             	mov    %rsp,%rbp
  801428:	48 83 ec 0c          	sub    $0xc,%rsp
  80142c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801430:	89 f0                	mov    %esi,%eax
  801432:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801435:	eb 17                	jmp    80144e <strchr+0x2a>
		if (*s == c)
  801437:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80143b:	0f b6 00             	movzbl (%rax),%eax
  80143e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801441:	75 06                	jne    801449 <strchr+0x25>
			return (char *) s;
  801443:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801447:	eb 15                	jmp    80145e <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801449:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80144e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801452:	0f b6 00             	movzbl (%rax),%eax
  801455:	84 c0                	test   %al,%al
  801457:	75 de                	jne    801437 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801459:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80145e:	c9                   	leaveq 
  80145f:	c3                   	retq   

0000000000801460 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801460:	55                   	push   %rbp
  801461:	48 89 e5             	mov    %rsp,%rbp
  801464:	48 83 ec 0c          	sub    $0xc,%rsp
  801468:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80146c:	89 f0                	mov    %esi,%eax
  80146e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801471:	eb 13                	jmp    801486 <strfind+0x26>
		if (*s == c)
  801473:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801477:	0f b6 00             	movzbl (%rax),%eax
  80147a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80147d:	75 02                	jne    801481 <strfind+0x21>
			break;
  80147f:	eb 10                	jmp    801491 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801481:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801486:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80148a:	0f b6 00             	movzbl (%rax),%eax
  80148d:	84 c0                	test   %al,%al
  80148f:	75 e2                	jne    801473 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801491:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801495:	c9                   	leaveq 
  801496:	c3                   	retq   

0000000000801497 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801497:	55                   	push   %rbp
  801498:	48 89 e5             	mov    %rsp,%rbp
  80149b:	48 83 ec 18          	sub    $0x18,%rsp
  80149f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014a3:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8014a6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8014aa:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014af:	75 06                	jne    8014b7 <memset+0x20>
		return v;
  8014b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b5:	eb 69                	jmp    801520 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8014b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014bb:	83 e0 03             	and    $0x3,%eax
  8014be:	48 85 c0             	test   %rax,%rax
  8014c1:	75 48                	jne    80150b <memset+0x74>
  8014c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c7:	83 e0 03             	and    $0x3,%eax
  8014ca:	48 85 c0             	test   %rax,%rax
  8014cd:	75 3c                	jne    80150b <memset+0x74>
		c &= 0xFF;
  8014cf:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014d6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014d9:	c1 e0 18             	shl    $0x18,%eax
  8014dc:	89 c2                	mov    %eax,%edx
  8014de:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014e1:	c1 e0 10             	shl    $0x10,%eax
  8014e4:	09 c2                	or     %eax,%edx
  8014e6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014e9:	c1 e0 08             	shl    $0x8,%eax
  8014ec:	09 d0                	or     %edx,%eax
  8014ee:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8014f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014f5:	48 c1 e8 02          	shr    $0x2,%rax
  8014f9:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8014fc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801500:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801503:	48 89 d7             	mov    %rdx,%rdi
  801506:	fc                   	cld    
  801507:	f3 ab                	rep stos %eax,%es:(%rdi)
  801509:	eb 11                	jmp    80151c <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80150b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80150f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801512:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801516:	48 89 d7             	mov    %rdx,%rdi
  801519:	fc                   	cld    
  80151a:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80151c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801520:	c9                   	leaveq 
  801521:	c3                   	retq   

0000000000801522 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801522:	55                   	push   %rbp
  801523:	48 89 e5             	mov    %rsp,%rbp
  801526:	48 83 ec 28          	sub    $0x28,%rsp
  80152a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80152e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801532:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801536:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80153a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80153e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801542:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801546:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80154a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80154e:	0f 83 88 00 00 00    	jae    8015dc <memmove+0xba>
  801554:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801558:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80155c:	48 01 d0             	add    %rdx,%rax
  80155f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801563:	76 77                	jbe    8015dc <memmove+0xba>
		s += n;
  801565:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801569:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80156d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801571:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801575:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801579:	83 e0 03             	and    $0x3,%eax
  80157c:	48 85 c0             	test   %rax,%rax
  80157f:	75 3b                	jne    8015bc <memmove+0x9a>
  801581:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801585:	83 e0 03             	and    $0x3,%eax
  801588:	48 85 c0             	test   %rax,%rax
  80158b:	75 2f                	jne    8015bc <memmove+0x9a>
  80158d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801591:	83 e0 03             	and    $0x3,%eax
  801594:	48 85 c0             	test   %rax,%rax
  801597:	75 23                	jne    8015bc <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801599:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80159d:	48 83 e8 04          	sub    $0x4,%rax
  8015a1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015a5:	48 83 ea 04          	sub    $0x4,%rdx
  8015a9:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015ad:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8015b1:	48 89 c7             	mov    %rax,%rdi
  8015b4:	48 89 d6             	mov    %rdx,%rsi
  8015b7:	fd                   	std    
  8015b8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015ba:	eb 1d                	jmp    8015d9 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8015bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015c0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c8:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8015cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d0:	48 89 d7             	mov    %rdx,%rdi
  8015d3:	48 89 c1             	mov    %rax,%rcx
  8015d6:	fd                   	std    
  8015d7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015d9:	fc                   	cld    
  8015da:	eb 57                	jmp    801633 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e0:	83 e0 03             	and    $0x3,%eax
  8015e3:	48 85 c0             	test   %rax,%rax
  8015e6:	75 36                	jne    80161e <memmove+0xfc>
  8015e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015ec:	83 e0 03             	and    $0x3,%eax
  8015ef:	48 85 c0             	test   %rax,%rax
  8015f2:	75 2a                	jne    80161e <memmove+0xfc>
  8015f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f8:	83 e0 03             	and    $0x3,%eax
  8015fb:	48 85 c0             	test   %rax,%rax
  8015fe:	75 1e                	jne    80161e <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801600:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801604:	48 c1 e8 02          	shr    $0x2,%rax
  801608:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80160b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80160f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801613:	48 89 c7             	mov    %rax,%rdi
  801616:	48 89 d6             	mov    %rdx,%rsi
  801619:	fc                   	cld    
  80161a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80161c:	eb 15                	jmp    801633 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80161e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801622:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801626:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80162a:	48 89 c7             	mov    %rax,%rdi
  80162d:	48 89 d6             	mov    %rdx,%rsi
  801630:	fc                   	cld    
  801631:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801633:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801637:	c9                   	leaveq 
  801638:	c3                   	retq   

0000000000801639 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801639:	55                   	push   %rbp
  80163a:	48 89 e5             	mov    %rsp,%rbp
  80163d:	48 83 ec 18          	sub    $0x18,%rsp
  801641:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801645:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801649:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80164d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801651:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801655:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801659:	48 89 ce             	mov    %rcx,%rsi
  80165c:	48 89 c7             	mov    %rax,%rdi
  80165f:	48 b8 22 15 80 00 00 	movabs $0x801522,%rax
  801666:	00 00 00 
  801669:	ff d0                	callq  *%rax
}
  80166b:	c9                   	leaveq 
  80166c:	c3                   	retq   

000000000080166d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80166d:	55                   	push   %rbp
  80166e:	48 89 e5             	mov    %rsp,%rbp
  801671:	48 83 ec 28          	sub    $0x28,%rsp
  801675:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801679:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80167d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801681:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801685:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801689:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80168d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801691:	eb 36                	jmp    8016c9 <memcmp+0x5c>
		if (*s1 != *s2)
  801693:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801697:	0f b6 10             	movzbl (%rax),%edx
  80169a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80169e:	0f b6 00             	movzbl (%rax),%eax
  8016a1:	38 c2                	cmp    %al,%dl
  8016a3:	74 1a                	je     8016bf <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8016a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a9:	0f b6 00             	movzbl (%rax),%eax
  8016ac:	0f b6 d0             	movzbl %al,%edx
  8016af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b3:	0f b6 00             	movzbl (%rax),%eax
  8016b6:	0f b6 c0             	movzbl %al,%eax
  8016b9:	29 c2                	sub    %eax,%edx
  8016bb:	89 d0                	mov    %edx,%eax
  8016bd:	eb 20                	jmp    8016df <memcmp+0x72>
		s1++, s2++;
  8016bf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016c4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8016c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cd:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016d1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8016d5:	48 85 c0             	test   %rax,%rax
  8016d8:	75 b9                	jne    801693 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016df:	c9                   	leaveq 
  8016e0:	c3                   	retq   

00000000008016e1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016e1:	55                   	push   %rbp
  8016e2:	48 89 e5             	mov    %rsp,%rbp
  8016e5:	48 83 ec 28          	sub    $0x28,%rsp
  8016e9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016ed:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8016f0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8016f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016fc:	48 01 d0             	add    %rdx,%rax
  8016ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801703:	eb 15                	jmp    80171a <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801705:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801709:	0f b6 10             	movzbl (%rax),%edx
  80170c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80170f:	38 c2                	cmp    %al,%dl
  801711:	75 02                	jne    801715 <memfind+0x34>
			break;
  801713:	eb 0f                	jmp    801724 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801715:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80171a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80171e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801722:	72 e1                	jb     801705 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801724:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801728:	c9                   	leaveq 
  801729:	c3                   	retq   

000000000080172a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80172a:	55                   	push   %rbp
  80172b:	48 89 e5             	mov    %rsp,%rbp
  80172e:	48 83 ec 34          	sub    $0x34,%rsp
  801732:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801736:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80173a:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80173d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801744:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80174b:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80174c:	eb 05                	jmp    801753 <strtol+0x29>
		s++;
  80174e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801753:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801757:	0f b6 00             	movzbl (%rax),%eax
  80175a:	3c 20                	cmp    $0x20,%al
  80175c:	74 f0                	je     80174e <strtol+0x24>
  80175e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801762:	0f b6 00             	movzbl (%rax),%eax
  801765:	3c 09                	cmp    $0x9,%al
  801767:	74 e5                	je     80174e <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801769:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176d:	0f b6 00             	movzbl (%rax),%eax
  801770:	3c 2b                	cmp    $0x2b,%al
  801772:	75 07                	jne    80177b <strtol+0x51>
		s++;
  801774:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801779:	eb 17                	jmp    801792 <strtol+0x68>
	else if (*s == '-')
  80177b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177f:	0f b6 00             	movzbl (%rax),%eax
  801782:	3c 2d                	cmp    $0x2d,%al
  801784:	75 0c                	jne    801792 <strtol+0x68>
		s++, neg = 1;
  801786:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80178b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801792:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801796:	74 06                	je     80179e <strtol+0x74>
  801798:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80179c:	75 28                	jne    8017c6 <strtol+0x9c>
  80179e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a2:	0f b6 00             	movzbl (%rax),%eax
  8017a5:	3c 30                	cmp    $0x30,%al
  8017a7:	75 1d                	jne    8017c6 <strtol+0x9c>
  8017a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ad:	48 83 c0 01          	add    $0x1,%rax
  8017b1:	0f b6 00             	movzbl (%rax),%eax
  8017b4:	3c 78                	cmp    $0x78,%al
  8017b6:	75 0e                	jne    8017c6 <strtol+0x9c>
		s += 2, base = 16;
  8017b8:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8017bd:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8017c4:	eb 2c                	jmp    8017f2 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8017c6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017ca:	75 19                	jne    8017e5 <strtol+0xbb>
  8017cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d0:	0f b6 00             	movzbl (%rax),%eax
  8017d3:	3c 30                	cmp    $0x30,%al
  8017d5:	75 0e                	jne    8017e5 <strtol+0xbb>
		s++, base = 8;
  8017d7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017dc:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8017e3:	eb 0d                	jmp    8017f2 <strtol+0xc8>
	else if (base == 0)
  8017e5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017e9:	75 07                	jne    8017f2 <strtol+0xc8>
		base = 10;
  8017eb:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f6:	0f b6 00             	movzbl (%rax),%eax
  8017f9:	3c 2f                	cmp    $0x2f,%al
  8017fb:	7e 1d                	jle    80181a <strtol+0xf0>
  8017fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801801:	0f b6 00             	movzbl (%rax),%eax
  801804:	3c 39                	cmp    $0x39,%al
  801806:	7f 12                	jg     80181a <strtol+0xf0>
			dig = *s - '0';
  801808:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180c:	0f b6 00             	movzbl (%rax),%eax
  80180f:	0f be c0             	movsbl %al,%eax
  801812:	83 e8 30             	sub    $0x30,%eax
  801815:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801818:	eb 4e                	jmp    801868 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80181a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181e:	0f b6 00             	movzbl (%rax),%eax
  801821:	3c 60                	cmp    $0x60,%al
  801823:	7e 1d                	jle    801842 <strtol+0x118>
  801825:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801829:	0f b6 00             	movzbl (%rax),%eax
  80182c:	3c 7a                	cmp    $0x7a,%al
  80182e:	7f 12                	jg     801842 <strtol+0x118>
			dig = *s - 'a' + 10;
  801830:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801834:	0f b6 00             	movzbl (%rax),%eax
  801837:	0f be c0             	movsbl %al,%eax
  80183a:	83 e8 57             	sub    $0x57,%eax
  80183d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801840:	eb 26                	jmp    801868 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801842:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801846:	0f b6 00             	movzbl (%rax),%eax
  801849:	3c 40                	cmp    $0x40,%al
  80184b:	7e 48                	jle    801895 <strtol+0x16b>
  80184d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801851:	0f b6 00             	movzbl (%rax),%eax
  801854:	3c 5a                	cmp    $0x5a,%al
  801856:	7f 3d                	jg     801895 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801858:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185c:	0f b6 00             	movzbl (%rax),%eax
  80185f:	0f be c0             	movsbl %al,%eax
  801862:	83 e8 37             	sub    $0x37,%eax
  801865:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801868:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80186b:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80186e:	7c 02                	jl     801872 <strtol+0x148>
			break;
  801870:	eb 23                	jmp    801895 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801872:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801877:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80187a:	48 98                	cltq   
  80187c:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801881:	48 89 c2             	mov    %rax,%rdx
  801884:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801887:	48 98                	cltq   
  801889:	48 01 d0             	add    %rdx,%rax
  80188c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801890:	e9 5d ff ff ff       	jmpq   8017f2 <strtol+0xc8>

	if (endptr)
  801895:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80189a:	74 0b                	je     8018a7 <strtol+0x17d>
		*endptr = (char *) s;
  80189c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018a0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8018a4:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8018a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018ab:	74 09                	je     8018b6 <strtol+0x18c>
  8018ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018b1:	48 f7 d8             	neg    %rax
  8018b4:	eb 04                	jmp    8018ba <strtol+0x190>
  8018b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8018ba:	c9                   	leaveq 
  8018bb:	c3                   	retq   

00000000008018bc <strstr>:

char * strstr(const char *in, const char *str)
{
  8018bc:	55                   	push   %rbp
  8018bd:	48 89 e5             	mov    %rsp,%rbp
  8018c0:	48 83 ec 30          	sub    $0x30,%rsp
  8018c4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018c8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8018cc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018d0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018d4:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018d8:	0f b6 00             	movzbl (%rax),%eax
  8018db:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8018de:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8018e2:	75 06                	jne    8018ea <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8018e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e8:	eb 6b                	jmp    801955 <strstr+0x99>

	len = strlen(str);
  8018ea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018ee:	48 89 c7             	mov    %rax,%rdi
  8018f1:	48 b8 92 11 80 00 00 	movabs $0x801192,%rax
  8018f8:	00 00 00 
  8018fb:	ff d0                	callq  *%rax
  8018fd:	48 98                	cltq   
  8018ff:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801903:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801907:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80190b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80190f:	0f b6 00             	movzbl (%rax),%eax
  801912:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801915:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801919:	75 07                	jne    801922 <strstr+0x66>
				return (char *) 0;
  80191b:	b8 00 00 00 00       	mov    $0x0,%eax
  801920:	eb 33                	jmp    801955 <strstr+0x99>
		} while (sc != c);
  801922:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801926:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801929:	75 d8                	jne    801903 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80192b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80192f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801933:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801937:	48 89 ce             	mov    %rcx,%rsi
  80193a:	48 89 c7             	mov    %rax,%rdi
  80193d:	48 b8 b3 13 80 00 00 	movabs $0x8013b3,%rax
  801944:	00 00 00 
  801947:	ff d0                	callq  *%rax
  801949:	85 c0                	test   %eax,%eax
  80194b:	75 b6                	jne    801903 <strstr+0x47>

	return (char *) (in - 1);
  80194d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801951:	48 83 e8 01          	sub    $0x1,%rax
}
  801955:	c9                   	leaveq 
  801956:	c3                   	retq   

0000000000801957 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801957:	55                   	push   %rbp
  801958:	48 89 e5             	mov    %rsp,%rbp
  80195b:	53                   	push   %rbx
  80195c:	48 83 ec 48          	sub    $0x48,%rsp
  801960:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801963:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801966:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80196a:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80196e:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801972:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  801976:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801979:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80197d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801981:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801985:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801989:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80198d:	4c 89 c3             	mov    %r8,%rbx
  801990:	cd 30                	int    $0x30
  801992:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  801996:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80199a:	74 3e                	je     8019da <syscall+0x83>
  80199c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019a1:	7e 37                	jle    8019da <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019a7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019aa:	49 89 d0             	mov    %rdx,%r8
  8019ad:	89 c1                	mov    %eax,%ecx
  8019af:	48 ba 68 3d 80 00 00 	movabs $0x803d68,%rdx
  8019b6:	00 00 00 
  8019b9:	be 4a 00 00 00       	mov    $0x4a,%esi
  8019be:	48 bf 85 3d 80 00 00 	movabs $0x803d85,%rdi
  8019c5:	00 00 00 
  8019c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8019cd:	49 b9 10 04 80 00 00 	movabs $0x800410,%r9
  8019d4:	00 00 00 
  8019d7:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  8019da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019de:	48 83 c4 48          	add    $0x48,%rsp
  8019e2:	5b                   	pop    %rbx
  8019e3:	5d                   	pop    %rbp
  8019e4:	c3                   	retq   

00000000008019e5 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8019e5:	55                   	push   %rbp
  8019e6:	48 89 e5             	mov    %rsp,%rbp
  8019e9:	48 83 ec 20          	sub    $0x20,%rsp
  8019ed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019f1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8019f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019f9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019fd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a04:	00 
  801a05:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a0b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a11:	48 89 d1             	mov    %rdx,%rcx
  801a14:	48 89 c2             	mov    %rax,%rdx
  801a17:	be 00 00 00 00       	mov    $0x0,%esi
  801a1c:	bf 00 00 00 00       	mov    $0x0,%edi
  801a21:	48 b8 57 19 80 00 00 	movabs $0x801957,%rax
  801a28:	00 00 00 
  801a2b:	ff d0                	callq  *%rax
}
  801a2d:	c9                   	leaveq 
  801a2e:	c3                   	retq   

0000000000801a2f <sys_cgetc>:

int
sys_cgetc(void)
{
  801a2f:	55                   	push   %rbp
  801a30:	48 89 e5             	mov    %rsp,%rbp
  801a33:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a37:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a3e:	00 
  801a3f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a45:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a4b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a50:	ba 00 00 00 00       	mov    $0x0,%edx
  801a55:	be 00 00 00 00       	mov    $0x0,%esi
  801a5a:	bf 01 00 00 00       	mov    $0x1,%edi
  801a5f:	48 b8 57 19 80 00 00 	movabs $0x801957,%rax
  801a66:	00 00 00 
  801a69:	ff d0                	callq  *%rax
}
  801a6b:	c9                   	leaveq 
  801a6c:	c3                   	retq   

0000000000801a6d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a6d:	55                   	push   %rbp
  801a6e:	48 89 e5             	mov    %rsp,%rbp
  801a71:	48 83 ec 10          	sub    $0x10,%rsp
  801a75:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a7b:	48 98                	cltq   
  801a7d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a84:	00 
  801a85:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a8b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a91:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a96:	48 89 c2             	mov    %rax,%rdx
  801a99:	be 01 00 00 00       	mov    $0x1,%esi
  801a9e:	bf 03 00 00 00       	mov    $0x3,%edi
  801aa3:	48 b8 57 19 80 00 00 	movabs $0x801957,%rax
  801aaa:	00 00 00 
  801aad:	ff d0                	callq  *%rax
}
  801aaf:	c9                   	leaveq 
  801ab0:	c3                   	retq   

0000000000801ab1 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801ab1:	55                   	push   %rbp
  801ab2:	48 89 e5             	mov    %rsp,%rbp
  801ab5:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801ab9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ac0:	00 
  801ac1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ac7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801acd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ad2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ad7:	be 00 00 00 00       	mov    $0x0,%esi
  801adc:	bf 02 00 00 00       	mov    $0x2,%edi
  801ae1:	48 b8 57 19 80 00 00 	movabs $0x801957,%rax
  801ae8:	00 00 00 
  801aeb:	ff d0                	callq  *%rax
}
  801aed:	c9                   	leaveq 
  801aee:	c3                   	retq   

0000000000801aef <sys_yield>:

void
sys_yield(void)
{
  801aef:	55                   	push   %rbp
  801af0:	48 89 e5             	mov    %rsp,%rbp
  801af3:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801af7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801afe:	00 
  801aff:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b05:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b0b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b10:	ba 00 00 00 00       	mov    $0x0,%edx
  801b15:	be 00 00 00 00       	mov    $0x0,%esi
  801b1a:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b1f:	48 b8 57 19 80 00 00 	movabs $0x801957,%rax
  801b26:	00 00 00 
  801b29:	ff d0                	callq  *%rax
}
  801b2b:	c9                   	leaveq 
  801b2c:	c3                   	retq   

0000000000801b2d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b2d:	55                   	push   %rbp
  801b2e:	48 89 e5             	mov    %rsp,%rbp
  801b31:	48 83 ec 20          	sub    $0x20,%rsp
  801b35:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b38:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b3c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b3f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b42:	48 63 c8             	movslq %eax,%rcx
  801b45:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b4c:	48 98                	cltq   
  801b4e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b55:	00 
  801b56:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b5c:	49 89 c8             	mov    %rcx,%r8
  801b5f:	48 89 d1             	mov    %rdx,%rcx
  801b62:	48 89 c2             	mov    %rax,%rdx
  801b65:	be 01 00 00 00       	mov    $0x1,%esi
  801b6a:	bf 04 00 00 00       	mov    $0x4,%edi
  801b6f:	48 b8 57 19 80 00 00 	movabs $0x801957,%rax
  801b76:	00 00 00 
  801b79:	ff d0                	callq  *%rax
}
  801b7b:	c9                   	leaveq 
  801b7c:	c3                   	retq   

0000000000801b7d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b7d:	55                   	push   %rbp
  801b7e:	48 89 e5             	mov    %rsp,%rbp
  801b81:	48 83 ec 30          	sub    $0x30,%rsp
  801b85:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b88:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b8c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b8f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b93:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b97:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b9a:	48 63 c8             	movslq %eax,%rcx
  801b9d:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ba1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ba4:	48 63 f0             	movslq %eax,%rsi
  801ba7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bae:	48 98                	cltq   
  801bb0:	48 89 0c 24          	mov    %rcx,(%rsp)
  801bb4:	49 89 f9             	mov    %rdi,%r9
  801bb7:	49 89 f0             	mov    %rsi,%r8
  801bba:	48 89 d1             	mov    %rdx,%rcx
  801bbd:	48 89 c2             	mov    %rax,%rdx
  801bc0:	be 01 00 00 00       	mov    $0x1,%esi
  801bc5:	bf 05 00 00 00       	mov    $0x5,%edi
  801bca:	48 b8 57 19 80 00 00 	movabs $0x801957,%rax
  801bd1:	00 00 00 
  801bd4:	ff d0                	callq  *%rax
}
  801bd6:	c9                   	leaveq 
  801bd7:	c3                   	retq   

0000000000801bd8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801bd8:	55                   	push   %rbp
  801bd9:	48 89 e5             	mov    %rsp,%rbp
  801bdc:	48 83 ec 20          	sub    $0x20,%rsp
  801be0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801be3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801be7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801beb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bee:	48 98                	cltq   
  801bf0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bf7:	00 
  801bf8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bfe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c04:	48 89 d1             	mov    %rdx,%rcx
  801c07:	48 89 c2             	mov    %rax,%rdx
  801c0a:	be 01 00 00 00       	mov    $0x1,%esi
  801c0f:	bf 06 00 00 00       	mov    $0x6,%edi
  801c14:	48 b8 57 19 80 00 00 	movabs $0x801957,%rax
  801c1b:	00 00 00 
  801c1e:	ff d0                	callq  *%rax
}
  801c20:	c9                   	leaveq 
  801c21:	c3                   	retq   

0000000000801c22 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c22:	55                   	push   %rbp
  801c23:	48 89 e5             	mov    %rsp,%rbp
  801c26:	48 83 ec 10          	sub    $0x10,%rsp
  801c2a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c2d:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c30:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c33:	48 63 d0             	movslq %eax,%rdx
  801c36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c39:	48 98                	cltq   
  801c3b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c42:	00 
  801c43:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c49:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c4f:	48 89 d1             	mov    %rdx,%rcx
  801c52:	48 89 c2             	mov    %rax,%rdx
  801c55:	be 01 00 00 00       	mov    $0x1,%esi
  801c5a:	bf 08 00 00 00       	mov    $0x8,%edi
  801c5f:	48 b8 57 19 80 00 00 	movabs $0x801957,%rax
  801c66:	00 00 00 
  801c69:	ff d0                	callq  *%rax
}
  801c6b:	c9                   	leaveq 
  801c6c:	c3                   	retq   

0000000000801c6d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c6d:	55                   	push   %rbp
  801c6e:	48 89 e5             	mov    %rsp,%rbp
  801c71:	48 83 ec 20          	sub    $0x20,%rsp
  801c75:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c78:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c7c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c83:	48 98                	cltq   
  801c85:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c8c:	00 
  801c8d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c93:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c99:	48 89 d1             	mov    %rdx,%rcx
  801c9c:	48 89 c2             	mov    %rax,%rdx
  801c9f:	be 01 00 00 00       	mov    $0x1,%esi
  801ca4:	bf 09 00 00 00       	mov    $0x9,%edi
  801ca9:	48 b8 57 19 80 00 00 	movabs $0x801957,%rax
  801cb0:	00 00 00 
  801cb3:	ff d0                	callq  *%rax
}
  801cb5:	c9                   	leaveq 
  801cb6:	c3                   	retq   

0000000000801cb7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801cb7:	55                   	push   %rbp
  801cb8:	48 89 e5             	mov    %rsp,%rbp
  801cbb:	48 83 ec 20          	sub    $0x20,%rsp
  801cbf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cc2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801cc6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ccd:	48 98                	cltq   
  801ccf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cd6:	00 
  801cd7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cdd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ce3:	48 89 d1             	mov    %rdx,%rcx
  801ce6:	48 89 c2             	mov    %rax,%rdx
  801ce9:	be 01 00 00 00       	mov    $0x1,%esi
  801cee:	bf 0a 00 00 00       	mov    $0xa,%edi
  801cf3:	48 b8 57 19 80 00 00 	movabs $0x801957,%rax
  801cfa:	00 00 00 
  801cfd:	ff d0                	callq  *%rax
}
  801cff:	c9                   	leaveq 
  801d00:	c3                   	retq   

0000000000801d01 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801d01:	55                   	push   %rbp
  801d02:	48 89 e5             	mov    %rsp,%rbp
  801d05:	48 83 ec 20          	sub    $0x20,%rsp
  801d09:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d0c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d10:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d14:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d17:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d1a:	48 63 f0             	movslq %eax,%rsi
  801d1d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d24:	48 98                	cltq   
  801d26:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d2a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d31:	00 
  801d32:	49 89 f1             	mov    %rsi,%r9
  801d35:	49 89 c8             	mov    %rcx,%r8
  801d38:	48 89 d1             	mov    %rdx,%rcx
  801d3b:	48 89 c2             	mov    %rax,%rdx
  801d3e:	be 00 00 00 00       	mov    $0x0,%esi
  801d43:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d48:	48 b8 57 19 80 00 00 	movabs $0x801957,%rax
  801d4f:	00 00 00 
  801d52:	ff d0                	callq  *%rax
}
  801d54:	c9                   	leaveq 
  801d55:	c3                   	retq   

0000000000801d56 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d56:	55                   	push   %rbp
  801d57:	48 89 e5             	mov    %rsp,%rbp
  801d5a:	48 83 ec 10          	sub    $0x10,%rsp
  801d5e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d66:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d6d:	00 
  801d6e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d74:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d7a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d7f:	48 89 c2             	mov    %rax,%rdx
  801d82:	be 01 00 00 00       	mov    $0x1,%esi
  801d87:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d8c:	48 b8 57 19 80 00 00 	movabs $0x801957,%rax
  801d93:	00 00 00 
  801d96:	ff d0                	callq  *%rax
}
  801d98:	c9                   	leaveq 
  801d99:	c3                   	retq   

0000000000801d9a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801d9a:	55                   	push   %rbp
  801d9b:	48 89 e5             	mov    %rsp,%rbp
  801d9e:	48 83 ec 08          	sub    $0x8,%rsp
  801da2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801da6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801daa:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801db1:	ff ff ff 
  801db4:	48 01 d0             	add    %rdx,%rax
  801db7:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801dbb:	c9                   	leaveq 
  801dbc:	c3                   	retq   

0000000000801dbd <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801dbd:	55                   	push   %rbp
  801dbe:	48 89 e5             	mov    %rsp,%rbp
  801dc1:	48 83 ec 08          	sub    $0x8,%rsp
  801dc5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801dc9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dcd:	48 89 c7             	mov    %rax,%rdi
  801dd0:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  801dd7:	00 00 00 
  801dda:	ff d0                	callq  *%rax
  801ddc:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801de2:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801de6:	c9                   	leaveq 
  801de7:	c3                   	retq   

0000000000801de8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801de8:	55                   	push   %rbp
  801de9:	48 89 e5             	mov    %rsp,%rbp
  801dec:	48 83 ec 18          	sub    $0x18,%rsp
  801df0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801df4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801dfb:	eb 6b                	jmp    801e68 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801dfd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e00:	48 98                	cltq   
  801e02:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e08:	48 c1 e0 0c          	shl    $0xc,%rax
  801e0c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801e10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e14:	48 c1 e8 15          	shr    $0x15,%rax
  801e18:	48 89 c2             	mov    %rax,%rdx
  801e1b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e22:	01 00 00 
  801e25:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e29:	83 e0 01             	and    $0x1,%eax
  801e2c:	48 85 c0             	test   %rax,%rax
  801e2f:	74 21                	je     801e52 <fd_alloc+0x6a>
  801e31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e35:	48 c1 e8 0c          	shr    $0xc,%rax
  801e39:	48 89 c2             	mov    %rax,%rdx
  801e3c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e43:	01 00 00 
  801e46:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e4a:	83 e0 01             	and    $0x1,%eax
  801e4d:	48 85 c0             	test   %rax,%rax
  801e50:	75 12                	jne    801e64 <fd_alloc+0x7c>
			*fd_store = fd;
  801e52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e56:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e5a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e5d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e62:	eb 1a                	jmp    801e7e <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e64:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e68:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e6c:	7e 8f                	jle    801dfd <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e72:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801e79:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801e7e:	c9                   	leaveq 
  801e7f:	c3                   	retq   

0000000000801e80 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e80:	55                   	push   %rbp
  801e81:	48 89 e5             	mov    %rsp,%rbp
  801e84:	48 83 ec 20          	sub    $0x20,%rsp
  801e88:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e8b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e8f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e93:	78 06                	js     801e9b <fd_lookup+0x1b>
  801e95:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801e99:	7e 07                	jle    801ea2 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e9b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ea0:	eb 6c                	jmp    801f0e <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801ea2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ea5:	48 98                	cltq   
  801ea7:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ead:	48 c1 e0 0c          	shl    $0xc,%rax
  801eb1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801eb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eb9:	48 c1 e8 15          	shr    $0x15,%rax
  801ebd:	48 89 c2             	mov    %rax,%rdx
  801ec0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ec7:	01 00 00 
  801eca:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ece:	83 e0 01             	and    $0x1,%eax
  801ed1:	48 85 c0             	test   %rax,%rax
  801ed4:	74 21                	je     801ef7 <fd_lookup+0x77>
  801ed6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eda:	48 c1 e8 0c          	shr    $0xc,%rax
  801ede:	48 89 c2             	mov    %rax,%rdx
  801ee1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ee8:	01 00 00 
  801eeb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eef:	83 e0 01             	and    $0x1,%eax
  801ef2:	48 85 c0             	test   %rax,%rax
  801ef5:	75 07                	jne    801efe <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ef7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801efc:	eb 10                	jmp    801f0e <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801efe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f02:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f06:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801f09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f0e:	c9                   	leaveq 
  801f0f:	c3                   	retq   

0000000000801f10 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801f10:	55                   	push   %rbp
  801f11:	48 89 e5             	mov    %rsp,%rbp
  801f14:	48 83 ec 30          	sub    $0x30,%rsp
  801f18:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f1c:	89 f0                	mov    %esi,%eax
  801f1e:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f21:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f25:	48 89 c7             	mov    %rax,%rdi
  801f28:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  801f2f:	00 00 00 
  801f32:	ff d0                	callq  *%rax
  801f34:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f38:	48 89 d6             	mov    %rdx,%rsi
  801f3b:	89 c7                	mov    %eax,%edi
  801f3d:	48 b8 80 1e 80 00 00 	movabs $0x801e80,%rax
  801f44:	00 00 00 
  801f47:	ff d0                	callq  *%rax
  801f49:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f50:	78 0a                	js     801f5c <fd_close+0x4c>
	    || fd != fd2)
  801f52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f56:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f5a:	74 12                	je     801f6e <fd_close+0x5e>
		return (must_exist ? r : 0);
  801f5c:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801f60:	74 05                	je     801f67 <fd_close+0x57>
  801f62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f65:	eb 05                	jmp    801f6c <fd_close+0x5c>
  801f67:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6c:	eb 69                	jmp    801fd7 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f6e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f72:	8b 00                	mov    (%rax),%eax
  801f74:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f78:	48 89 d6             	mov    %rdx,%rsi
  801f7b:	89 c7                	mov    %eax,%edi
  801f7d:	48 b8 d9 1f 80 00 00 	movabs $0x801fd9,%rax
  801f84:	00 00 00 
  801f87:	ff d0                	callq  *%rax
  801f89:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f90:	78 2a                	js     801fbc <fd_close+0xac>
		if (dev->dev_close)
  801f92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f96:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f9a:	48 85 c0             	test   %rax,%rax
  801f9d:	74 16                	je     801fb5 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801f9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fa3:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fa7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801fab:	48 89 d7             	mov    %rdx,%rdi
  801fae:	ff d0                	callq  *%rax
  801fb0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fb3:	eb 07                	jmp    801fbc <fd_close+0xac>
		else
			r = 0;
  801fb5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801fbc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fc0:	48 89 c6             	mov    %rax,%rsi
  801fc3:	bf 00 00 00 00       	mov    $0x0,%edi
  801fc8:	48 b8 d8 1b 80 00 00 	movabs $0x801bd8,%rax
  801fcf:	00 00 00 
  801fd2:	ff d0                	callq  *%rax
	return r;
  801fd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801fd7:	c9                   	leaveq 
  801fd8:	c3                   	retq   

0000000000801fd9 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801fd9:	55                   	push   %rbp
  801fda:	48 89 e5             	mov    %rsp,%rbp
  801fdd:	48 83 ec 20          	sub    $0x20,%rsp
  801fe1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fe4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801fe8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fef:	eb 41                	jmp    802032 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801ff1:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801ff8:	00 00 00 
  801ffb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ffe:	48 63 d2             	movslq %edx,%rdx
  802001:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802005:	8b 00                	mov    (%rax),%eax
  802007:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80200a:	75 22                	jne    80202e <dev_lookup+0x55>
			*dev = devtab[i];
  80200c:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802013:	00 00 00 
  802016:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802019:	48 63 d2             	movslq %edx,%rdx
  80201c:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802020:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802024:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802027:	b8 00 00 00 00       	mov    $0x0,%eax
  80202c:	eb 60                	jmp    80208e <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80202e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802032:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802039:	00 00 00 
  80203c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80203f:	48 63 d2             	movslq %edx,%rdx
  802042:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802046:	48 85 c0             	test   %rax,%rax
  802049:	75 a6                	jne    801ff1 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80204b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802052:	00 00 00 
  802055:	48 8b 00             	mov    (%rax),%rax
  802058:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80205e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802061:	89 c6                	mov    %eax,%esi
  802063:	48 bf 98 3d 80 00 00 	movabs $0x803d98,%rdi
  80206a:	00 00 00 
  80206d:	b8 00 00 00 00       	mov    $0x0,%eax
  802072:	48 b9 49 06 80 00 00 	movabs $0x800649,%rcx
  802079:	00 00 00 
  80207c:	ff d1                	callq  *%rcx
	*dev = 0;
  80207e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802082:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802089:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80208e:	c9                   	leaveq 
  80208f:	c3                   	retq   

0000000000802090 <close>:

int
close(int fdnum)
{
  802090:	55                   	push   %rbp
  802091:	48 89 e5             	mov    %rsp,%rbp
  802094:	48 83 ec 20          	sub    $0x20,%rsp
  802098:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80209b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80209f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020a2:	48 89 d6             	mov    %rdx,%rsi
  8020a5:	89 c7                	mov    %eax,%edi
  8020a7:	48 b8 80 1e 80 00 00 	movabs $0x801e80,%rax
  8020ae:	00 00 00 
  8020b1:	ff d0                	callq  *%rax
  8020b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020ba:	79 05                	jns    8020c1 <close+0x31>
		return r;
  8020bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020bf:	eb 18                	jmp    8020d9 <close+0x49>
	else
		return fd_close(fd, 1);
  8020c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020c5:	be 01 00 00 00       	mov    $0x1,%esi
  8020ca:	48 89 c7             	mov    %rax,%rdi
  8020cd:	48 b8 10 1f 80 00 00 	movabs $0x801f10,%rax
  8020d4:	00 00 00 
  8020d7:	ff d0                	callq  *%rax
}
  8020d9:	c9                   	leaveq 
  8020da:	c3                   	retq   

00000000008020db <close_all>:

void
close_all(void)
{
  8020db:	55                   	push   %rbp
  8020dc:	48 89 e5             	mov    %rsp,%rbp
  8020df:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8020e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020ea:	eb 15                	jmp    802101 <close_all+0x26>
		close(i);
  8020ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020ef:	89 c7                	mov    %eax,%edi
  8020f1:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  8020f8:	00 00 00 
  8020fb:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8020fd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802101:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802105:	7e e5                	jle    8020ec <close_all+0x11>
		close(i);
}
  802107:	c9                   	leaveq 
  802108:	c3                   	retq   

0000000000802109 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802109:	55                   	push   %rbp
  80210a:	48 89 e5             	mov    %rsp,%rbp
  80210d:	48 83 ec 40          	sub    $0x40,%rsp
  802111:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802114:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802117:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80211b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80211e:	48 89 d6             	mov    %rdx,%rsi
  802121:	89 c7                	mov    %eax,%edi
  802123:	48 b8 80 1e 80 00 00 	movabs $0x801e80,%rax
  80212a:	00 00 00 
  80212d:	ff d0                	callq  *%rax
  80212f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802132:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802136:	79 08                	jns    802140 <dup+0x37>
		return r;
  802138:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80213b:	e9 70 01 00 00       	jmpq   8022b0 <dup+0x1a7>
	close(newfdnum);
  802140:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802143:	89 c7                	mov    %eax,%edi
  802145:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  80214c:	00 00 00 
  80214f:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802151:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802154:	48 98                	cltq   
  802156:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80215c:	48 c1 e0 0c          	shl    $0xc,%rax
  802160:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802164:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802168:	48 89 c7             	mov    %rax,%rdi
  80216b:	48 b8 bd 1d 80 00 00 	movabs $0x801dbd,%rax
  802172:	00 00 00 
  802175:	ff d0                	callq  *%rax
  802177:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80217b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80217f:	48 89 c7             	mov    %rax,%rdi
  802182:	48 b8 bd 1d 80 00 00 	movabs $0x801dbd,%rax
  802189:	00 00 00 
  80218c:	ff d0                	callq  *%rax
  80218e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802192:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802196:	48 c1 e8 15          	shr    $0x15,%rax
  80219a:	48 89 c2             	mov    %rax,%rdx
  80219d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021a4:	01 00 00 
  8021a7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021ab:	83 e0 01             	and    $0x1,%eax
  8021ae:	48 85 c0             	test   %rax,%rax
  8021b1:	74 73                	je     802226 <dup+0x11d>
  8021b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021b7:	48 c1 e8 0c          	shr    $0xc,%rax
  8021bb:	48 89 c2             	mov    %rax,%rdx
  8021be:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021c5:	01 00 00 
  8021c8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021cc:	83 e0 01             	and    $0x1,%eax
  8021cf:	48 85 c0             	test   %rax,%rax
  8021d2:	74 52                	je     802226 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8021d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021d8:	48 c1 e8 0c          	shr    $0xc,%rax
  8021dc:	48 89 c2             	mov    %rax,%rdx
  8021df:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021e6:	01 00 00 
  8021e9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021ed:	25 07 0e 00 00       	and    $0xe07,%eax
  8021f2:	89 c1                	mov    %eax,%ecx
  8021f4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8021f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021fc:	41 89 c8             	mov    %ecx,%r8d
  8021ff:	48 89 d1             	mov    %rdx,%rcx
  802202:	ba 00 00 00 00       	mov    $0x0,%edx
  802207:	48 89 c6             	mov    %rax,%rsi
  80220a:	bf 00 00 00 00       	mov    $0x0,%edi
  80220f:	48 b8 7d 1b 80 00 00 	movabs $0x801b7d,%rax
  802216:	00 00 00 
  802219:	ff d0                	callq  *%rax
  80221b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80221e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802222:	79 02                	jns    802226 <dup+0x11d>
			goto err;
  802224:	eb 57                	jmp    80227d <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802226:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80222a:	48 c1 e8 0c          	shr    $0xc,%rax
  80222e:	48 89 c2             	mov    %rax,%rdx
  802231:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802238:	01 00 00 
  80223b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80223f:	25 07 0e 00 00       	and    $0xe07,%eax
  802244:	89 c1                	mov    %eax,%ecx
  802246:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80224a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80224e:	41 89 c8             	mov    %ecx,%r8d
  802251:	48 89 d1             	mov    %rdx,%rcx
  802254:	ba 00 00 00 00       	mov    $0x0,%edx
  802259:	48 89 c6             	mov    %rax,%rsi
  80225c:	bf 00 00 00 00       	mov    $0x0,%edi
  802261:	48 b8 7d 1b 80 00 00 	movabs $0x801b7d,%rax
  802268:	00 00 00 
  80226b:	ff d0                	callq  *%rax
  80226d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802270:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802274:	79 02                	jns    802278 <dup+0x16f>
		goto err;
  802276:	eb 05                	jmp    80227d <dup+0x174>

	return newfdnum;
  802278:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80227b:	eb 33                	jmp    8022b0 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80227d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802281:	48 89 c6             	mov    %rax,%rsi
  802284:	bf 00 00 00 00       	mov    $0x0,%edi
  802289:	48 b8 d8 1b 80 00 00 	movabs $0x801bd8,%rax
  802290:	00 00 00 
  802293:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802295:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802299:	48 89 c6             	mov    %rax,%rsi
  80229c:	bf 00 00 00 00       	mov    $0x0,%edi
  8022a1:	48 b8 d8 1b 80 00 00 	movabs $0x801bd8,%rax
  8022a8:	00 00 00 
  8022ab:	ff d0                	callq  *%rax
	return r;
  8022ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022b0:	c9                   	leaveq 
  8022b1:	c3                   	retq   

00000000008022b2 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8022b2:	55                   	push   %rbp
  8022b3:	48 89 e5             	mov    %rsp,%rbp
  8022b6:	48 83 ec 40          	sub    $0x40,%rsp
  8022ba:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022bd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8022c1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022c5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022c9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022cc:	48 89 d6             	mov    %rdx,%rsi
  8022cf:	89 c7                	mov    %eax,%edi
  8022d1:	48 b8 80 1e 80 00 00 	movabs $0x801e80,%rax
  8022d8:	00 00 00 
  8022db:	ff d0                	callq  *%rax
  8022dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022e4:	78 24                	js     80230a <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ea:	8b 00                	mov    (%rax),%eax
  8022ec:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022f0:	48 89 d6             	mov    %rdx,%rsi
  8022f3:	89 c7                	mov    %eax,%edi
  8022f5:	48 b8 d9 1f 80 00 00 	movabs $0x801fd9,%rax
  8022fc:	00 00 00 
  8022ff:	ff d0                	callq  *%rax
  802301:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802304:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802308:	79 05                	jns    80230f <read+0x5d>
		return r;
  80230a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80230d:	eb 76                	jmp    802385 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80230f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802313:	8b 40 08             	mov    0x8(%rax),%eax
  802316:	83 e0 03             	and    $0x3,%eax
  802319:	83 f8 01             	cmp    $0x1,%eax
  80231c:	75 3a                	jne    802358 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80231e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802325:	00 00 00 
  802328:	48 8b 00             	mov    (%rax),%rax
  80232b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802331:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802334:	89 c6                	mov    %eax,%esi
  802336:	48 bf b7 3d 80 00 00 	movabs $0x803db7,%rdi
  80233d:	00 00 00 
  802340:	b8 00 00 00 00       	mov    $0x0,%eax
  802345:	48 b9 49 06 80 00 00 	movabs $0x800649,%rcx
  80234c:	00 00 00 
  80234f:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802351:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802356:	eb 2d                	jmp    802385 <read+0xd3>
	}
	if (!dev->dev_read)
  802358:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80235c:	48 8b 40 10          	mov    0x10(%rax),%rax
  802360:	48 85 c0             	test   %rax,%rax
  802363:	75 07                	jne    80236c <read+0xba>
		return -E_NOT_SUPP;
  802365:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80236a:	eb 19                	jmp    802385 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80236c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802370:	48 8b 40 10          	mov    0x10(%rax),%rax
  802374:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802378:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80237c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802380:	48 89 cf             	mov    %rcx,%rdi
  802383:	ff d0                	callq  *%rax
}
  802385:	c9                   	leaveq 
  802386:	c3                   	retq   

0000000000802387 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802387:	55                   	push   %rbp
  802388:	48 89 e5             	mov    %rsp,%rbp
  80238b:	48 83 ec 30          	sub    $0x30,%rsp
  80238f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802392:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802396:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80239a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023a1:	eb 49                	jmp    8023ec <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8023a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023a6:	48 98                	cltq   
  8023a8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023ac:	48 29 c2             	sub    %rax,%rdx
  8023af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023b2:	48 63 c8             	movslq %eax,%rcx
  8023b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023b9:	48 01 c1             	add    %rax,%rcx
  8023bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023bf:	48 89 ce             	mov    %rcx,%rsi
  8023c2:	89 c7                	mov    %eax,%edi
  8023c4:	48 b8 b2 22 80 00 00 	movabs $0x8022b2,%rax
  8023cb:	00 00 00 
  8023ce:	ff d0                	callq  *%rax
  8023d0:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8023d3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023d7:	79 05                	jns    8023de <readn+0x57>
			return m;
  8023d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023dc:	eb 1c                	jmp    8023fa <readn+0x73>
		if (m == 0)
  8023de:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023e2:	75 02                	jne    8023e6 <readn+0x5f>
			break;
  8023e4:	eb 11                	jmp    8023f7 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023e6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023e9:	01 45 fc             	add    %eax,-0x4(%rbp)
  8023ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ef:	48 98                	cltq   
  8023f1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8023f5:	72 ac                	jb     8023a3 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8023f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023fa:	c9                   	leaveq 
  8023fb:	c3                   	retq   

00000000008023fc <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8023fc:	55                   	push   %rbp
  8023fd:	48 89 e5             	mov    %rsp,%rbp
  802400:	48 83 ec 40          	sub    $0x40,%rsp
  802404:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802407:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80240b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80240f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802413:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802416:	48 89 d6             	mov    %rdx,%rsi
  802419:	89 c7                	mov    %eax,%edi
  80241b:	48 b8 80 1e 80 00 00 	movabs $0x801e80,%rax
  802422:	00 00 00 
  802425:	ff d0                	callq  *%rax
  802427:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80242a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80242e:	78 24                	js     802454 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802430:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802434:	8b 00                	mov    (%rax),%eax
  802436:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80243a:	48 89 d6             	mov    %rdx,%rsi
  80243d:	89 c7                	mov    %eax,%edi
  80243f:	48 b8 d9 1f 80 00 00 	movabs $0x801fd9,%rax
  802446:	00 00 00 
  802449:	ff d0                	callq  *%rax
  80244b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80244e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802452:	79 05                	jns    802459 <write+0x5d>
		return r;
  802454:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802457:	eb 75                	jmp    8024ce <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802459:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80245d:	8b 40 08             	mov    0x8(%rax),%eax
  802460:	83 e0 03             	and    $0x3,%eax
  802463:	85 c0                	test   %eax,%eax
  802465:	75 3a                	jne    8024a1 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802467:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80246e:	00 00 00 
  802471:	48 8b 00             	mov    (%rax),%rax
  802474:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80247a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80247d:	89 c6                	mov    %eax,%esi
  80247f:	48 bf d3 3d 80 00 00 	movabs $0x803dd3,%rdi
  802486:	00 00 00 
  802489:	b8 00 00 00 00       	mov    $0x0,%eax
  80248e:	48 b9 49 06 80 00 00 	movabs $0x800649,%rcx
  802495:	00 00 00 
  802498:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80249a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80249f:	eb 2d                	jmp    8024ce <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8024a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024a5:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024a9:	48 85 c0             	test   %rax,%rax
  8024ac:	75 07                	jne    8024b5 <write+0xb9>
		return -E_NOT_SUPP;
  8024ae:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024b3:	eb 19                	jmp    8024ce <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8024b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024b9:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024bd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8024c1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024c5:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8024c9:	48 89 cf             	mov    %rcx,%rdi
  8024cc:	ff d0                	callq  *%rax
}
  8024ce:	c9                   	leaveq 
  8024cf:	c3                   	retq   

00000000008024d0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8024d0:	55                   	push   %rbp
  8024d1:	48 89 e5             	mov    %rsp,%rbp
  8024d4:	48 83 ec 18          	sub    $0x18,%rsp
  8024d8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024db:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024de:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024e2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024e5:	48 89 d6             	mov    %rdx,%rsi
  8024e8:	89 c7                	mov    %eax,%edi
  8024ea:	48 b8 80 1e 80 00 00 	movabs $0x801e80,%rax
  8024f1:	00 00 00 
  8024f4:	ff d0                	callq  *%rax
  8024f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024fd:	79 05                	jns    802504 <seek+0x34>
		return r;
  8024ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802502:	eb 0f                	jmp    802513 <seek+0x43>
	fd->fd_offset = offset;
  802504:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802508:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80250b:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80250e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802513:	c9                   	leaveq 
  802514:	c3                   	retq   

0000000000802515 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802515:	55                   	push   %rbp
  802516:	48 89 e5             	mov    %rsp,%rbp
  802519:	48 83 ec 30          	sub    $0x30,%rsp
  80251d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802520:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802523:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802527:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80252a:	48 89 d6             	mov    %rdx,%rsi
  80252d:	89 c7                	mov    %eax,%edi
  80252f:	48 b8 80 1e 80 00 00 	movabs $0x801e80,%rax
  802536:	00 00 00 
  802539:	ff d0                	callq  *%rax
  80253b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80253e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802542:	78 24                	js     802568 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802544:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802548:	8b 00                	mov    (%rax),%eax
  80254a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80254e:	48 89 d6             	mov    %rdx,%rsi
  802551:	89 c7                	mov    %eax,%edi
  802553:	48 b8 d9 1f 80 00 00 	movabs $0x801fd9,%rax
  80255a:	00 00 00 
  80255d:	ff d0                	callq  *%rax
  80255f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802562:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802566:	79 05                	jns    80256d <ftruncate+0x58>
		return r;
  802568:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80256b:	eb 72                	jmp    8025df <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80256d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802571:	8b 40 08             	mov    0x8(%rax),%eax
  802574:	83 e0 03             	and    $0x3,%eax
  802577:	85 c0                	test   %eax,%eax
  802579:	75 3a                	jne    8025b5 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80257b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802582:	00 00 00 
  802585:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802588:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80258e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802591:	89 c6                	mov    %eax,%esi
  802593:	48 bf f0 3d 80 00 00 	movabs $0x803df0,%rdi
  80259a:	00 00 00 
  80259d:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a2:	48 b9 49 06 80 00 00 	movabs $0x800649,%rcx
  8025a9:	00 00 00 
  8025ac:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8025ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025b3:	eb 2a                	jmp    8025df <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8025b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025b9:	48 8b 40 30          	mov    0x30(%rax),%rax
  8025bd:	48 85 c0             	test   %rax,%rax
  8025c0:	75 07                	jne    8025c9 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8025c2:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025c7:	eb 16                	jmp    8025df <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8025c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025cd:	48 8b 40 30          	mov    0x30(%rax),%rax
  8025d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8025d5:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8025d8:	89 ce                	mov    %ecx,%esi
  8025da:	48 89 d7             	mov    %rdx,%rdi
  8025dd:	ff d0                	callq  *%rax
}
  8025df:	c9                   	leaveq 
  8025e0:	c3                   	retq   

00000000008025e1 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8025e1:	55                   	push   %rbp
  8025e2:	48 89 e5             	mov    %rsp,%rbp
  8025e5:	48 83 ec 30          	sub    $0x30,%rsp
  8025e9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025ec:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025f0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025f4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025f7:	48 89 d6             	mov    %rdx,%rsi
  8025fa:	89 c7                	mov    %eax,%edi
  8025fc:	48 b8 80 1e 80 00 00 	movabs $0x801e80,%rax
  802603:	00 00 00 
  802606:	ff d0                	callq  *%rax
  802608:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80260b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80260f:	78 24                	js     802635 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802611:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802615:	8b 00                	mov    (%rax),%eax
  802617:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80261b:	48 89 d6             	mov    %rdx,%rsi
  80261e:	89 c7                	mov    %eax,%edi
  802620:	48 b8 d9 1f 80 00 00 	movabs $0x801fd9,%rax
  802627:	00 00 00 
  80262a:	ff d0                	callq  *%rax
  80262c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80262f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802633:	79 05                	jns    80263a <fstat+0x59>
		return r;
  802635:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802638:	eb 5e                	jmp    802698 <fstat+0xb7>
	if (!dev->dev_stat)
  80263a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80263e:	48 8b 40 28          	mov    0x28(%rax),%rax
  802642:	48 85 c0             	test   %rax,%rax
  802645:	75 07                	jne    80264e <fstat+0x6d>
		return -E_NOT_SUPP;
  802647:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80264c:	eb 4a                	jmp    802698 <fstat+0xb7>
	stat->st_name[0] = 0;
  80264e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802652:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802655:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802659:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802660:	00 00 00 
	stat->st_isdir = 0;
  802663:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802667:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80266e:	00 00 00 
	stat->st_dev = dev;
  802671:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802675:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802679:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802680:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802684:	48 8b 40 28          	mov    0x28(%rax),%rax
  802688:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80268c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802690:	48 89 ce             	mov    %rcx,%rsi
  802693:	48 89 d7             	mov    %rdx,%rdi
  802696:	ff d0                	callq  *%rax
}
  802698:	c9                   	leaveq 
  802699:	c3                   	retq   

000000000080269a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80269a:	55                   	push   %rbp
  80269b:	48 89 e5             	mov    %rsp,%rbp
  80269e:	48 83 ec 20          	sub    $0x20,%rsp
  8026a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026a6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8026aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026ae:	be 00 00 00 00       	mov    $0x0,%esi
  8026b3:	48 89 c7             	mov    %rax,%rdi
  8026b6:	48 b8 88 27 80 00 00 	movabs $0x802788,%rax
  8026bd:	00 00 00 
  8026c0:	ff d0                	callq  *%rax
  8026c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026c9:	79 05                	jns    8026d0 <stat+0x36>
		return fd;
  8026cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026ce:	eb 2f                	jmp    8026ff <stat+0x65>
	r = fstat(fd, stat);
  8026d0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8026d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026d7:	48 89 d6             	mov    %rdx,%rsi
  8026da:	89 c7                	mov    %eax,%edi
  8026dc:	48 b8 e1 25 80 00 00 	movabs $0x8025e1,%rax
  8026e3:	00 00 00 
  8026e6:	ff d0                	callq  *%rax
  8026e8:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8026eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026ee:	89 c7                	mov    %eax,%edi
  8026f0:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  8026f7:	00 00 00 
  8026fa:	ff d0                	callq  *%rax
	return r;
  8026fc:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8026ff:	c9                   	leaveq 
  802700:	c3                   	retq   

0000000000802701 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802701:	55                   	push   %rbp
  802702:	48 89 e5             	mov    %rsp,%rbp
  802705:	48 83 ec 10          	sub    $0x10,%rsp
  802709:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80270c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802710:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802717:	00 00 00 
  80271a:	8b 00                	mov    (%rax),%eax
  80271c:	85 c0                	test   %eax,%eax
  80271e:	75 1d                	jne    80273d <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802720:	bf 01 00 00 00       	mov    $0x1,%edi
  802725:	48 b8 ca 36 80 00 00 	movabs $0x8036ca,%rax
  80272c:	00 00 00 
  80272f:	ff d0                	callq  *%rax
  802731:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  802738:	00 00 00 
  80273b:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80273d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802744:	00 00 00 
  802747:	8b 00                	mov    (%rax),%eax
  802749:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80274c:	b9 07 00 00 00       	mov    $0x7,%ecx
  802751:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802758:	00 00 00 
  80275b:	89 c7                	mov    %eax,%edi
  80275d:	48 b8 2d 36 80 00 00 	movabs $0x80362d,%rax
  802764:	00 00 00 
  802767:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802769:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80276d:	ba 00 00 00 00       	mov    $0x0,%edx
  802772:	48 89 c6             	mov    %rax,%rsi
  802775:	bf 00 00 00 00       	mov    $0x0,%edi
  80277a:	48 b8 67 35 80 00 00 	movabs $0x803567,%rax
  802781:	00 00 00 
  802784:	ff d0                	callq  *%rax
}
  802786:	c9                   	leaveq 
  802787:	c3                   	retq   

0000000000802788 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802788:	55                   	push   %rbp
  802789:	48 89 e5             	mov    %rsp,%rbp
  80278c:	48 83 ec 20          	sub    $0x20,%rsp
  802790:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802794:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  802797:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80279b:	48 89 c7             	mov    %rax,%rdi
  80279e:	48 b8 92 11 80 00 00 	movabs $0x801192,%rax
  8027a5:	00 00 00 
  8027a8:	ff d0                	callq  *%rax
  8027aa:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8027af:	7e 0a                	jle    8027bb <open+0x33>
  8027b1:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8027b6:	e9 a5 00 00 00       	jmpq   802860 <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  8027bb:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8027bf:	48 89 c7             	mov    %rax,%rdi
  8027c2:	48 b8 e8 1d 80 00 00 	movabs $0x801de8,%rax
  8027c9:	00 00 00 
  8027cc:	ff d0                	callq  *%rax
  8027ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027d5:	79 08                	jns    8027df <open+0x57>
		return r;
  8027d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027da:	e9 81 00 00 00       	jmpq   802860 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  8027df:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027e6:	00 00 00 
  8027e9:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8027ec:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  8027f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027f6:	48 89 c6             	mov    %rax,%rsi
  8027f9:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802800:	00 00 00 
  802803:	48 b8 fe 11 80 00 00 	movabs $0x8011fe,%rax
  80280a:	00 00 00 
  80280d:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  80280f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802813:	48 89 c6             	mov    %rax,%rsi
  802816:	bf 01 00 00 00       	mov    $0x1,%edi
  80281b:	48 b8 01 27 80 00 00 	movabs $0x802701,%rax
  802822:	00 00 00 
  802825:	ff d0                	callq  *%rax
  802827:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80282a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80282e:	79 1d                	jns    80284d <open+0xc5>
		fd_close(fd, 0);
  802830:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802834:	be 00 00 00 00       	mov    $0x0,%esi
  802839:	48 89 c7             	mov    %rax,%rdi
  80283c:	48 b8 10 1f 80 00 00 	movabs $0x801f10,%rax
  802843:	00 00 00 
  802846:	ff d0                	callq  *%rax
		return r;
  802848:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80284b:	eb 13                	jmp    802860 <open+0xd8>
	}
	return fd2num(fd);
  80284d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802851:	48 89 c7             	mov    %rax,%rdi
  802854:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  80285b:	00 00 00 
  80285e:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  802860:	c9                   	leaveq 
  802861:	c3                   	retq   

0000000000802862 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802862:	55                   	push   %rbp
  802863:	48 89 e5             	mov    %rsp,%rbp
  802866:	48 83 ec 10          	sub    $0x10,%rsp
  80286a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80286e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802872:	8b 50 0c             	mov    0xc(%rax),%edx
  802875:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80287c:	00 00 00 
  80287f:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802881:	be 00 00 00 00       	mov    $0x0,%esi
  802886:	bf 06 00 00 00       	mov    $0x6,%edi
  80288b:	48 b8 01 27 80 00 00 	movabs $0x802701,%rax
  802892:	00 00 00 
  802895:	ff d0                	callq  *%rax
}
  802897:	c9                   	leaveq 
  802898:	c3                   	retq   

0000000000802899 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802899:	55                   	push   %rbp
  80289a:	48 89 e5             	mov    %rsp,%rbp
  80289d:	48 83 ec 30          	sub    $0x30,%rsp
  8028a1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028a5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028a9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8028ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028b1:	8b 50 0c             	mov    0xc(%rax),%edx
  8028b4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028bb:	00 00 00 
  8028be:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8028c0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028c7:	00 00 00 
  8028ca:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028ce:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  8028d2:	be 00 00 00 00       	mov    $0x0,%esi
  8028d7:	bf 03 00 00 00       	mov    $0x3,%edi
  8028dc:	48 b8 01 27 80 00 00 	movabs $0x802701,%rax
  8028e3:	00 00 00 
  8028e6:	ff d0                	callq  *%rax
  8028e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028ef:	79 05                	jns    8028f6 <devfile_read+0x5d>
		return r;
  8028f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028f4:	eb 26                	jmp    80291c <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  8028f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028f9:	48 63 d0             	movslq %eax,%rdx
  8028fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802900:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802907:	00 00 00 
  80290a:	48 89 c7             	mov    %rax,%rdi
  80290d:	48 b8 39 16 80 00 00 	movabs $0x801639,%rax
  802914:	00 00 00 
  802917:	ff d0                	callq  *%rax
	return r;
  802919:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80291c:	c9                   	leaveq 
  80291d:	c3                   	retq   

000000000080291e <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80291e:	55                   	push   %rbp
  80291f:	48 89 e5             	mov    %rsp,%rbp
  802922:	48 83 ec 30          	sub    $0x30,%rsp
  802926:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80292a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80292e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  802932:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  802939:	00 
	n = n > max ? max : n;
  80293a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80293e:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802942:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  802947:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80294b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80294f:	8b 50 0c             	mov    0xc(%rax),%edx
  802952:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802959:	00 00 00 
  80295c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  80295e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802965:	00 00 00 
  802968:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80296c:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802970:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802974:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802978:	48 89 c6             	mov    %rax,%rsi
  80297b:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802982:	00 00 00 
  802985:	48 b8 39 16 80 00 00 	movabs $0x801639,%rax
  80298c:	00 00 00 
  80298f:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  802991:	be 00 00 00 00       	mov    $0x0,%esi
  802996:	bf 04 00 00 00       	mov    $0x4,%edi
  80299b:	48 b8 01 27 80 00 00 	movabs $0x802701,%rax
  8029a2:	00 00 00 
  8029a5:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  8029a7:	c9                   	leaveq 
  8029a8:	c3                   	retq   

00000000008029a9 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8029a9:	55                   	push   %rbp
  8029aa:	48 89 e5             	mov    %rsp,%rbp
  8029ad:	48 83 ec 20          	sub    $0x20,%rsp
  8029b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8029b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029bd:	8b 50 0c             	mov    0xc(%rax),%edx
  8029c0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029c7:	00 00 00 
  8029ca:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8029cc:	be 00 00 00 00       	mov    $0x0,%esi
  8029d1:	bf 05 00 00 00       	mov    $0x5,%edi
  8029d6:	48 b8 01 27 80 00 00 	movabs $0x802701,%rax
  8029dd:	00 00 00 
  8029e0:	ff d0                	callq  *%rax
  8029e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029e9:	79 05                	jns    8029f0 <devfile_stat+0x47>
		return r;
  8029eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ee:	eb 56                	jmp    802a46 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8029f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029f4:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8029fb:	00 00 00 
  8029fe:	48 89 c7             	mov    %rax,%rdi
  802a01:	48 b8 fe 11 80 00 00 	movabs $0x8011fe,%rax
  802a08:	00 00 00 
  802a0b:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802a0d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a14:	00 00 00 
  802a17:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802a1d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a21:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802a27:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a2e:	00 00 00 
  802a31:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802a37:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a3b:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802a41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a46:	c9                   	leaveq 
  802a47:	c3                   	retq   

0000000000802a48 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802a48:	55                   	push   %rbp
  802a49:	48 89 e5             	mov    %rsp,%rbp
  802a4c:	48 83 ec 10          	sub    $0x10,%rsp
  802a50:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802a54:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802a57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a5b:	8b 50 0c             	mov    0xc(%rax),%edx
  802a5e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a65:	00 00 00 
  802a68:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802a6a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a71:	00 00 00 
  802a74:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802a77:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802a7a:	be 00 00 00 00       	mov    $0x0,%esi
  802a7f:	bf 02 00 00 00       	mov    $0x2,%edi
  802a84:	48 b8 01 27 80 00 00 	movabs $0x802701,%rax
  802a8b:	00 00 00 
  802a8e:	ff d0                	callq  *%rax
}
  802a90:	c9                   	leaveq 
  802a91:	c3                   	retq   

0000000000802a92 <remove>:

// Delete a file
int
remove(const char *path)
{
  802a92:	55                   	push   %rbp
  802a93:	48 89 e5             	mov    %rsp,%rbp
  802a96:	48 83 ec 10          	sub    $0x10,%rsp
  802a9a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802a9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802aa2:	48 89 c7             	mov    %rax,%rdi
  802aa5:	48 b8 92 11 80 00 00 	movabs $0x801192,%rax
  802aac:	00 00 00 
  802aaf:	ff d0                	callq  *%rax
  802ab1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802ab6:	7e 07                	jle    802abf <remove+0x2d>
		return -E_BAD_PATH;
  802ab8:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802abd:	eb 33                	jmp    802af2 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802abf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ac3:	48 89 c6             	mov    %rax,%rsi
  802ac6:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802acd:	00 00 00 
  802ad0:	48 b8 fe 11 80 00 00 	movabs $0x8011fe,%rax
  802ad7:	00 00 00 
  802ada:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802adc:	be 00 00 00 00       	mov    $0x0,%esi
  802ae1:	bf 07 00 00 00       	mov    $0x7,%edi
  802ae6:	48 b8 01 27 80 00 00 	movabs $0x802701,%rax
  802aed:	00 00 00 
  802af0:	ff d0                	callq  *%rax
}
  802af2:	c9                   	leaveq 
  802af3:	c3                   	retq   

0000000000802af4 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802af4:	55                   	push   %rbp
  802af5:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802af8:	be 00 00 00 00       	mov    $0x0,%esi
  802afd:	bf 08 00 00 00       	mov    $0x8,%edi
  802b02:	48 b8 01 27 80 00 00 	movabs $0x802701,%rax
  802b09:	00 00 00 
  802b0c:	ff d0                	callq  *%rax
}
  802b0e:	5d                   	pop    %rbp
  802b0f:	c3                   	retq   

0000000000802b10 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802b10:	55                   	push   %rbp
  802b11:	48 89 e5             	mov    %rsp,%rbp
  802b14:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802b1b:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802b22:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802b29:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802b30:	be 00 00 00 00       	mov    $0x0,%esi
  802b35:	48 89 c7             	mov    %rax,%rdi
  802b38:	48 b8 88 27 80 00 00 	movabs $0x802788,%rax
  802b3f:	00 00 00 
  802b42:	ff d0                	callq  *%rax
  802b44:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802b47:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b4b:	79 28                	jns    802b75 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802b4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b50:	89 c6                	mov    %eax,%esi
  802b52:	48 bf 16 3e 80 00 00 	movabs $0x803e16,%rdi
  802b59:	00 00 00 
  802b5c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b61:	48 ba 49 06 80 00 00 	movabs $0x800649,%rdx
  802b68:	00 00 00 
  802b6b:	ff d2                	callq  *%rdx
		return fd_src;
  802b6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b70:	e9 74 01 00 00       	jmpq   802ce9 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802b75:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802b7c:	be 01 01 00 00       	mov    $0x101,%esi
  802b81:	48 89 c7             	mov    %rax,%rdi
  802b84:	48 b8 88 27 80 00 00 	movabs $0x802788,%rax
  802b8b:	00 00 00 
  802b8e:	ff d0                	callq  *%rax
  802b90:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802b93:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b97:	79 39                	jns    802bd2 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802b99:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b9c:	89 c6                	mov    %eax,%esi
  802b9e:	48 bf 2c 3e 80 00 00 	movabs $0x803e2c,%rdi
  802ba5:	00 00 00 
  802ba8:	b8 00 00 00 00       	mov    $0x0,%eax
  802bad:	48 ba 49 06 80 00 00 	movabs $0x800649,%rdx
  802bb4:	00 00 00 
  802bb7:	ff d2                	callq  *%rdx
		close(fd_src);
  802bb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bbc:	89 c7                	mov    %eax,%edi
  802bbe:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  802bc5:	00 00 00 
  802bc8:	ff d0                	callq  *%rax
		return fd_dest;
  802bca:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bcd:	e9 17 01 00 00       	jmpq   802ce9 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802bd2:	eb 74                	jmp    802c48 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802bd4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802bd7:	48 63 d0             	movslq %eax,%rdx
  802bda:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802be1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802be4:	48 89 ce             	mov    %rcx,%rsi
  802be7:	89 c7                	mov    %eax,%edi
  802be9:	48 b8 fc 23 80 00 00 	movabs $0x8023fc,%rax
  802bf0:	00 00 00 
  802bf3:	ff d0                	callq  *%rax
  802bf5:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802bf8:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802bfc:	79 4a                	jns    802c48 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802bfe:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c01:	89 c6                	mov    %eax,%esi
  802c03:	48 bf 46 3e 80 00 00 	movabs $0x803e46,%rdi
  802c0a:	00 00 00 
  802c0d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c12:	48 ba 49 06 80 00 00 	movabs $0x800649,%rdx
  802c19:	00 00 00 
  802c1c:	ff d2                	callq  *%rdx
			close(fd_src);
  802c1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c21:	89 c7                	mov    %eax,%edi
  802c23:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  802c2a:	00 00 00 
  802c2d:	ff d0                	callq  *%rax
			close(fd_dest);
  802c2f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c32:	89 c7                	mov    %eax,%edi
  802c34:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  802c3b:	00 00 00 
  802c3e:	ff d0                	callq  *%rax
			return write_size;
  802c40:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c43:	e9 a1 00 00 00       	jmpq   802ce9 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802c48:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c52:	ba 00 02 00 00       	mov    $0x200,%edx
  802c57:	48 89 ce             	mov    %rcx,%rsi
  802c5a:	89 c7                	mov    %eax,%edi
  802c5c:	48 b8 b2 22 80 00 00 	movabs $0x8022b2,%rax
  802c63:	00 00 00 
  802c66:	ff d0                	callq  *%rax
  802c68:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802c6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802c6f:	0f 8f 5f ff ff ff    	jg     802bd4 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802c75:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802c79:	79 47                	jns    802cc2 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802c7b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c7e:	89 c6                	mov    %eax,%esi
  802c80:	48 bf 59 3e 80 00 00 	movabs $0x803e59,%rdi
  802c87:	00 00 00 
  802c8a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c8f:	48 ba 49 06 80 00 00 	movabs $0x800649,%rdx
  802c96:	00 00 00 
  802c99:	ff d2                	callq  *%rdx
		close(fd_src);
  802c9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c9e:	89 c7                	mov    %eax,%edi
  802ca0:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  802ca7:	00 00 00 
  802caa:	ff d0                	callq  *%rax
		close(fd_dest);
  802cac:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802caf:	89 c7                	mov    %eax,%edi
  802cb1:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  802cb8:	00 00 00 
  802cbb:	ff d0                	callq  *%rax
		return read_size;
  802cbd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802cc0:	eb 27                	jmp    802ce9 <copy+0x1d9>
	}
	close(fd_src);
  802cc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cc5:	89 c7                	mov    %eax,%edi
  802cc7:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  802cce:	00 00 00 
  802cd1:	ff d0                	callq  *%rax
	close(fd_dest);
  802cd3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cd6:	89 c7                	mov    %eax,%edi
  802cd8:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  802cdf:	00 00 00 
  802ce2:	ff d0                	callq  *%rax
	return 0;
  802ce4:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802ce9:	c9                   	leaveq 
  802cea:	c3                   	retq   

0000000000802ceb <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802ceb:	55                   	push   %rbp
  802cec:	48 89 e5             	mov    %rsp,%rbp
  802cef:	53                   	push   %rbx
  802cf0:	48 83 ec 38          	sub    $0x38,%rsp
  802cf4:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802cf8:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802cfc:	48 89 c7             	mov    %rax,%rdi
  802cff:	48 b8 e8 1d 80 00 00 	movabs $0x801de8,%rax
  802d06:	00 00 00 
  802d09:	ff d0                	callq  *%rax
  802d0b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802d0e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802d12:	0f 88 bf 01 00 00    	js     802ed7 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d1c:	ba 07 04 00 00       	mov    $0x407,%edx
  802d21:	48 89 c6             	mov    %rax,%rsi
  802d24:	bf 00 00 00 00       	mov    $0x0,%edi
  802d29:	48 b8 2d 1b 80 00 00 	movabs $0x801b2d,%rax
  802d30:	00 00 00 
  802d33:	ff d0                	callq  *%rax
  802d35:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802d38:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802d3c:	0f 88 95 01 00 00    	js     802ed7 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802d42:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802d46:	48 89 c7             	mov    %rax,%rdi
  802d49:	48 b8 e8 1d 80 00 00 	movabs $0x801de8,%rax
  802d50:	00 00 00 
  802d53:	ff d0                	callq  *%rax
  802d55:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802d58:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802d5c:	0f 88 5d 01 00 00    	js     802ebf <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d62:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d66:	ba 07 04 00 00       	mov    $0x407,%edx
  802d6b:	48 89 c6             	mov    %rax,%rsi
  802d6e:	bf 00 00 00 00       	mov    $0x0,%edi
  802d73:	48 b8 2d 1b 80 00 00 	movabs $0x801b2d,%rax
  802d7a:	00 00 00 
  802d7d:	ff d0                	callq  *%rax
  802d7f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802d82:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802d86:	0f 88 33 01 00 00    	js     802ebf <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802d8c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d90:	48 89 c7             	mov    %rax,%rdi
  802d93:	48 b8 bd 1d 80 00 00 	movabs $0x801dbd,%rax
  802d9a:	00 00 00 
  802d9d:	ff d0                	callq  *%rax
  802d9f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802da3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802da7:	ba 07 04 00 00       	mov    $0x407,%edx
  802dac:	48 89 c6             	mov    %rax,%rsi
  802daf:	bf 00 00 00 00       	mov    $0x0,%edi
  802db4:	48 b8 2d 1b 80 00 00 	movabs $0x801b2d,%rax
  802dbb:	00 00 00 
  802dbe:	ff d0                	callq  *%rax
  802dc0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802dc3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802dc7:	79 05                	jns    802dce <pipe+0xe3>
		goto err2;
  802dc9:	e9 d9 00 00 00       	jmpq   802ea7 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802dce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dd2:	48 89 c7             	mov    %rax,%rdi
  802dd5:	48 b8 bd 1d 80 00 00 	movabs $0x801dbd,%rax
  802ddc:	00 00 00 
  802ddf:	ff d0                	callq  *%rax
  802de1:	48 89 c2             	mov    %rax,%rdx
  802de4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802de8:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802dee:	48 89 d1             	mov    %rdx,%rcx
  802df1:	ba 00 00 00 00       	mov    $0x0,%edx
  802df6:	48 89 c6             	mov    %rax,%rsi
  802df9:	bf 00 00 00 00       	mov    $0x0,%edi
  802dfe:	48 b8 7d 1b 80 00 00 	movabs $0x801b7d,%rax
  802e05:	00 00 00 
  802e08:	ff d0                	callq  *%rax
  802e0a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802e0d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802e11:	79 1b                	jns    802e2e <pipe+0x143>
		goto err3;
  802e13:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  802e14:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e18:	48 89 c6             	mov    %rax,%rsi
  802e1b:	bf 00 00 00 00       	mov    $0x0,%edi
  802e20:	48 b8 d8 1b 80 00 00 	movabs $0x801bd8,%rax
  802e27:	00 00 00 
  802e2a:	ff d0                	callq  *%rax
  802e2c:	eb 79                	jmp    802ea7 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802e2e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e32:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802e39:	00 00 00 
  802e3c:	8b 12                	mov    (%rdx),%edx
  802e3e:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802e40:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e44:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802e4b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e4f:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802e56:	00 00 00 
  802e59:	8b 12                	mov    (%rdx),%edx
  802e5b:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802e5d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e61:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802e68:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e6c:	48 89 c7             	mov    %rax,%rdi
  802e6f:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  802e76:	00 00 00 
  802e79:	ff d0                	callq  *%rax
  802e7b:	89 c2                	mov    %eax,%edx
  802e7d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802e81:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802e83:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802e87:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802e8b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e8f:	48 89 c7             	mov    %rax,%rdi
  802e92:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  802e99:	00 00 00 
  802e9c:	ff d0                	callq  *%rax
  802e9e:	89 03                	mov    %eax,(%rbx)
	return 0;
  802ea0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ea5:	eb 33                	jmp    802eda <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  802ea7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802eab:	48 89 c6             	mov    %rax,%rsi
  802eae:	bf 00 00 00 00       	mov    $0x0,%edi
  802eb3:	48 b8 d8 1b 80 00 00 	movabs $0x801bd8,%rax
  802eba:	00 00 00 
  802ebd:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  802ebf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ec3:	48 89 c6             	mov    %rax,%rsi
  802ec6:	bf 00 00 00 00       	mov    $0x0,%edi
  802ecb:	48 b8 d8 1b 80 00 00 	movabs $0x801bd8,%rax
  802ed2:	00 00 00 
  802ed5:	ff d0                	callq  *%rax
err:
	return r;
  802ed7:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802eda:	48 83 c4 38          	add    $0x38,%rsp
  802ede:	5b                   	pop    %rbx
  802edf:	5d                   	pop    %rbp
  802ee0:	c3                   	retq   

0000000000802ee1 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802ee1:	55                   	push   %rbp
  802ee2:	48 89 e5             	mov    %rsp,%rbp
  802ee5:	53                   	push   %rbx
  802ee6:	48 83 ec 28          	sub    $0x28,%rsp
  802eea:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802eee:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802ef2:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802ef9:	00 00 00 
  802efc:	48 8b 00             	mov    (%rax),%rax
  802eff:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802f05:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802f08:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f0c:	48 89 c7             	mov    %rax,%rdi
  802f0f:	48 b8 4c 37 80 00 00 	movabs $0x80374c,%rax
  802f16:	00 00 00 
  802f19:	ff d0                	callq  *%rax
  802f1b:	89 c3                	mov    %eax,%ebx
  802f1d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f21:	48 89 c7             	mov    %rax,%rdi
  802f24:	48 b8 4c 37 80 00 00 	movabs $0x80374c,%rax
  802f2b:	00 00 00 
  802f2e:	ff d0                	callq  *%rax
  802f30:	39 c3                	cmp    %eax,%ebx
  802f32:	0f 94 c0             	sete   %al
  802f35:	0f b6 c0             	movzbl %al,%eax
  802f38:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802f3b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802f42:	00 00 00 
  802f45:	48 8b 00             	mov    (%rax),%rax
  802f48:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802f4e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802f51:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f54:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802f57:	75 05                	jne    802f5e <_pipeisclosed+0x7d>
			return ret;
  802f59:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802f5c:	eb 4f                	jmp    802fad <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802f5e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f61:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802f64:	74 42                	je     802fa8 <_pipeisclosed+0xc7>
  802f66:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802f6a:	75 3c                	jne    802fa8 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802f6c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802f73:	00 00 00 
  802f76:	48 8b 00             	mov    (%rax),%rax
  802f79:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802f7f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802f82:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f85:	89 c6                	mov    %eax,%esi
  802f87:	48 bf 74 3e 80 00 00 	movabs $0x803e74,%rdi
  802f8e:	00 00 00 
  802f91:	b8 00 00 00 00       	mov    $0x0,%eax
  802f96:	49 b8 49 06 80 00 00 	movabs $0x800649,%r8
  802f9d:	00 00 00 
  802fa0:	41 ff d0             	callq  *%r8
	}
  802fa3:	e9 4a ff ff ff       	jmpq   802ef2 <_pipeisclosed+0x11>
  802fa8:	e9 45 ff ff ff       	jmpq   802ef2 <_pipeisclosed+0x11>
}
  802fad:	48 83 c4 28          	add    $0x28,%rsp
  802fb1:	5b                   	pop    %rbx
  802fb2:	5d                   	pop    %rbp
  802fb3:	c3                   	retq   

0000000000802fb4 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802fb4:	55                   	push   %rbp
  802fb5:	48 89 e5             	mov    %rsp,%rbp
  802fb8:	48 83 ec 30          	sub    $0x30,%rsp
  802fbc:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802fbf:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802fc3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802fc6:	48 89 d6             	mov    %rdx,%rsi
  802fc9:	89 c7                	mov    %eax,%edi
  802fcb:	48 b8 80 1e 80 00 00 	movabs $0x801e80,%rax
  802fd2:	00 00 00 
  802fd5:	ff d0                	callq  *%rax
  802fd7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fda:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fde:	79 05                	jns    802fe5 <pipeisclosed+0x31>
		return r;
  802fe0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fe3:	eb 31                	jmp    803016 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802fe5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fe9:	48 89 c7             	mov    %rax,%rdi
  802fec:	48 b8 bd 1d 80 00 00 	movabs $0x801dbd,%rax
  802ff3:	00 00 00 
  802ff6:	ff d0                	callq  *%rax
  802ff8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802ffc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803000:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803004:	48 89 d6             	mov    %rdx,%rsi
  803007:	48 89 c7             	mov    %rax,%rdi
  80300a:	48 b8 e1 2e 80 00 00 	movabs $0x802ee1,%rax
  803011:	00 00 00 
  803014:	ff d0                	callq  *%rax
}
  803016:	c9                   	leaveq 
  803017:	c3                   	retq   

0000000000803018 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803018:	55                   	push   %rbp
  803019:	48 89 e5             	mov    %rsp,%rbp
  80301c:	48 83 ec 40          	sub    $0x40,%rsp
  803020:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803024:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803028:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80302c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803030:	48 89 c7             	mov    %rax,%rdi
  803033:	48 b8 bd 1d 80 00 00 	movabs $0x801dbd,%rax
  80303a:	00 00 00 
  80303d:	ff d0                	callq  *%rax
  80303f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803043:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803047:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80304b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803052:	00 
  803053:	e9 92 00 00 00       	jmpq   8030ea <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803058:	eb 41                	jmp    80309b <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80305a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80305f:	74 09                	je     80306a <devpipe_read+0x52>
				return i;
  803061:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803065:	e9 92 00 00 00       	jmpq   8030fc <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80306a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80306e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803072:	48 89 d6             	mov    %rdx,%rsi
  803075:	48 89 c7             	mov    %rax,%rdi
  803078:	48 b8 e1 2e 80 00 00 	movabs $0x802ee1,%rax
  80307f:	00 00 00 
  803082:	ff d0                	callq  *%rax
  803084:	85 c0                	test   %eax,%eax
  803086:	74 07                	je     80308f <devpipe_read+0x77>
				return 0;
  803088:	b8 00 00 00 00       	mov    $0x0,%eax
  80308d:	eb 6d                	jmp    8030fc <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80308f:	48 b8 ef 1a 80 00 00 	movabs $0x801aef,%rax
  803096:	00 00 00 
  803099:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80309b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80309f:	8b 10                	mov    (%rax),%edx
  8030a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030a5:	8b 40 04             	mov    0x4(%rax),%eax
  8030a8:	39 c2                	cmp    %eax,%edx
  8030aa:	74 ae                	je     80305a <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8030ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8030b4:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8030b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030bc:	8b 00                	mov    (%rax),%eax
  8030be:	99                   	cltd   
  8030bf:	c1 ea 1b             	shr    $0x1b,%edx
  8030c2:	01 d0                	add    %edx,%eax
  8030c4:	83 e0 1f             	and    $0x1f,%eax
  8030c7:	29 d0                	sub    %edx,%eax
  8030c9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8030cd:	48 98                	cltq   
  8030cf:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8030d4:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8030d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030da:	8b 00                	mov    (%rax),%eax
  8030dc:	8d 50 01             	lea    0x1(%rax),%edx
  8030df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030e3:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8030e5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8030ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030ee:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8030f2:	0f 82 60 ff ff ff    	jb     803058 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8030f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8030fc:	c9                   	leaveq 
  8030fd:	c3                   	retq   

00000000008030fe <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8030fe:	55                   	push   %rbp
  8030ff:	48 89 e5             	mov    %rsp,%rbp
  803102:	48 83 ec 40          	sub    $0x40,%rsp
  803106:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80310a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80310e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803112:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803116:	48 89 c7             	mov    %rax,%rdi
  803119:	48 b8 bd 1d 80 00 00 	movabs $0x801dbd,%rax
  803120:	00 00 00 
  803123:	ff d0                	callq  *%rax
  803125:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803129:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80312d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803131:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803138:	00 
  803139:	e9 8e 00 00 00       	jmpq   8031cc <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80313e:	eb 31                	jmp    803171 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803140:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803144:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803148:	48 89 d6             	mov    %rdx,%rsi
  80314b:	48 89 c7             	mov    %rax,%rdi
  80314e:	48 b8 e1 2e 80 00 00 	movabs $0x802ee1,%rax
  803155:	00 00 00 
  803158:	ff d0                	callq  *%rax
  80315a:	85 c0                	test   %eax,%eax
  80315c:	74 07                	je     803165 <devpipe_write+0x67>
				return 0;
  80315e:	b8 00 00 00 00       	mov    $0x0,%eax
  803163:	eb 79                	jmp    8031de <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803165:	48 b8 ef 1a 80 00 00 	movabs $0x801aef,%rax
  80316c:	00 00 00 
  80316f:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803171:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803175:	8b 40 04             	mov    0x4(%rax),%eax
  803178:	48 63 d0             	movslq %eax,%rdx
  80317b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80317f:	8b 00                	mov    (%rax),%eax
  803181:	48 98                	cltq   
  803183:	48 83 c0 20          	add    $0x20,%rax
  803187:	48 39 c2             	cmp    %rax,%rdx
  80318a:	73 b4                	jae    803140 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80318c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803190:	8b 40 04             	mov    0x4(%rax),%eax
  803193:	99                   	cltd   
  803194:	c1 ea 1b             	shr    $0x1b,%edx
  803197:	01 d0                	add    %edx,%eax
  803199:	83 e0 1f             	and    $0x1f,%eax
  80319c:	29 d0                	sub    %edx,%eax
  80319e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8031a2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8031a6:	48 01 ca             	add    %rcx,%rdx
  8031a9:	0f b6 0a             	movzbl (%rdx),%ecx
  8031ac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8031b0:	48 98                	cltq   
  8031b2:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8031b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031ba:	8b 40 04             	mov    0x4(%rax),%eax
  8031bd:	8d 50 01             	lea    0x1(%rax),%edx
  8031c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031c4:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8031c7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8031cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031d0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8031d4:	0f 82 64 ff ff ff    	jb     80313e <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8031da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8031de:	c9                   	leaveq 
  8031df:	c3                   	retq   

00000000008031e0 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8031e0:	55                   	push   %rbp
  8031e1:	48 89 e5             	mov    %rsp,%rbp
  8031e4:	48 83 ec 20          	sub    $0x20,%rsp
  8031e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8031f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031f4:	48 89 c7             	mov    %rax,%rdi
  8031f7:	48 b8 bd 1d 80 00 00 	movabs $0x801dbd,%rax
  8031fe:	00 00 00 
  803201:	ff d0                	callq  *%rax
  803203:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803207:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80320b:	48 be 87 3e 80 00 00 	movabs $0x803e87,%rsi
  803212:	00 00 00 
  803215:	48 89 c7             	mov    %rax,%rdi
  803218:	48 b8 fe 11 80 00 00 	movabs $0x8011fe,%rax
  80321f:	00 00 00 
  803222:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803224:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803228:	8b 50 04             	mov    0x4(%rax),%edx
  80322b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80322f:	8b 00                	mov    (%rax),%eax
  803231:	29 c2                	sub    %eax,%edx
  803233:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803237:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80323d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803241:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803248:	00 00 00 
	stat->st_dev = &devpipe;
  80324b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80324f:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  803256:	00 00 00 
  803259:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803260:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803265:	c9                   	leaveq 
  803266:	c3                   	retq   

0000000000803267 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803267:	55                   	push   %rbp
  803268:	48 89 e5             	mov    %rsp,%rbp
  80326b:	48 83 ec 10          	sub    $0x10,%rsp
  80326f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803273:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803277:	48 89 c6             	mov    %rax,%rsi
  80327a:	bf 00 00 00 00       	mov    $0x0,%edi
  80327f:	48 b8 d8 1b 80 00 00 	movabs $0x801bd8,%rax
  803286:	00 00 00 
  803289:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80328b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80328f:	48 89 c7             	mov    %rax,%rdi
  803292:	48 b8 bd 1d 80 00 00 	movabs $0x801dbd,%rax
  803299:	00 00 00 
  80329c:	ff d0                	callq  *%rax
  80329e:	48 89 c6             	mov    %rax,%rsi
  8032a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8032a6:	48 b8 d8 1b 80 00 00 	movabs $0x801bd8,%rax
  8032ad:	00 00 00 
  8032b0:	ff d0                	callq  *%rax
}
  8032b2:	c9                   	leaveq 
  8032b3:	c3                   	retq   

00000000008032b4 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8032b4:	55                   	push   %rbp
  8032b5:	48 89 e5             	mov    %rsp,%rbp
  8032b8:	48 83 ec 20          	sub    $0x20,%rsp
  8032bc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8032bf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032c2:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8032c5:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8032c9:	be 01 00 00 00       	mov    $0x1,%esi
  8032ce:	48 89 c7             	mov    %rax,%rdi
  8032d1:	48 b8 e5 19 80 00 00 	movabs $0x8019e5,%rax
  8032d8:	00 00 00 
  8032db:	ff d0                	callq  *%rax
}
  8032dd:	c9                   	leaveq 
  8032de:	c3                   	retq   

00000000008032df <getchar>:

int
getchar(void)
{
  8032df:	55                   	push   %rbp
  8032e0:	48 89 e5             	mov    %rsp,%rbp
  8032e3:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8032e7:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8032eb:	ba 01 00 00 00       	mov    $0x1,%edx
  8032f0:	48 89 c6             	mov    %rax,%rsi
  8032f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8032f8:	48 b8 b2 22 80 00 00 	movabs $0x8022b2,%rax
  8032ff:	00 00 00 
  803302:	ff d0                	callq  *%rax
  803304:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803307:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80330b:	79 05                	jns    803312 <getchar+0x33>
		return r;
  80330d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803310:	eb 14                	jmp    803326 <getchar+0x47>
	if (r < 1)
  803312:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803316:	7f 07                	jg     80331f <getchar+0x40>
		return -E_EOF;
  803318:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80331d:	eb 07                	jmp    803326 <getchar+0x47>
	return c;
  80331f:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803323:	0f b6 c0             	movzbl %al,%eax
}
  803326:	c9                   	leaveq 
  803327:	c3                   	retq   

0000000000803328 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803328:	55                   	push   %rbp
  803329:	48 89 e5             	mov    %rsp,%rbp
  80332c:	48 83 ec 20          	sub    $0x20,%rsp
  803330:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803333:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803337:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80333a:	48 89 d6             	mov    %rdx,%rsi
  80333d:	89 c7                	mov    %eax,%edi
  80333f:	48 b8 80 1e 80 00 00 	movabs $0x801e80,%rax
  803346:	00 00 00 
  803349:	ff d0                	callq  *%rax
  80334b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80334e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803352:	79 05                	jns    803359 <iscons+0x31>
		return r;
  803354:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803357:	eb 1a                	jmp    803373 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803359:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80335d:	8b 10                	mov    (%rax),%edx
  80335f:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  803366:	00 00 00 
  803369:	8b 00                	mov    (%rax),%eax
  80336b:	39 c2                	cmp    %eax,%edx
  80336d:	0f 94 c0             	sete   %al
  803370:	0f b6 c0             	movzbl %al,%eax
}
  803373:	c9                   	leaveq 
  803374:	c3                   	retq   

0000000000803375 <opencons>:

int
opencons(void)
{
  803375:	55                   	push   %rbp
  803376:	48 89 e5             	mov    %rsp,%rbp
  803379:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80337d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803381:	48 89 c7             	mov    %rax,%rdi
  803384:	48 b8 e8 1d 80 00 00 	movabs $0x801de8,%rax
  80338b:	00 00 00 
  80338e:	ff d0                	callq  *%rax
  803390:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803393:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803397:	79 05                	jns    80339e <opencons+0x29>
		return r;
  803399:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80339c:	eb 5b                	jmp    8033f9 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80339e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033a2:	ba 07 04 00 00       	mov    $0x407,%edx
  8033a7:	48 89 c6             	mov    %rax,%rsi
  8033aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8033af:	48 b8 2d 1b 80 00 00 	movabs $0x801b2d,%rax
  8033b6:	00 00 00 
  8033b9:	ff d0                	callq  *%rax
  8033bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033c2:	79 05                	jns    8033c9 <opencons+0x54>
		return r;
  8033c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033c7:	eb 30                	jmp    8033f9 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8033c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033cd:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  8033d4:	00 00 00 
  8033d7:	8b 12                	mov    (%rdx),%edx
  8033d9:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8033db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033df:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8033e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033ea:	48 89 c7             	mov    %rax,%rdi
  8033ed:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  8033f4:	00 00 00 
  8033f7:	ff d0                	callq  *%rax
}
  8033f9:	c9                   	leaveq 
  8033fa:	c3                   	retq   

00000000008033fb <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8033fb:	55                   	push   %rbp
  8033fc:	48 89 e5             	mov    %rsp,%rbp
  8033ff:	48 83 ec 30          	sub    $0x30,%rsp
  803403:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803407:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80340b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80340f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803414:	75 07                	jne    80341d <devcons_read+0x22>
		return 0;
  803416:	b8 00 00 00 00       	mov    $0x0,%eax
  80341b:	eb 4b                	jmp    803468 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80341d:	eb 0c                	jmp    80342b <devcons_read+0x30>
		sys_yield();
  80341f:	48 b8 ef 1a 80 00 00 	movabs $0x801aef,%rax
  803426:	00 00 00 
  803429:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80342b:	48 b8 2f 1a 80 00 00 	movabs $0x801a2f,%rax
  803432:	00 00 00 
  803435:	ff d0                	callq  *%rax
  803437:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80343a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80343e:	74 df                	je     80341f <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803440:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803444:	79 05                	jns    80344b <devcons_read+0x50>
		return c;
  803446:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803449:	eb 1d                	jmp    803468 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80344b:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80344f:	75 07                	jne    803458 <devcons_read+0x5d>
		return 0;
  803451:	b8 00 00 00 00       	mov    $0x0,%eax
  803456:	eb 10                	jmp    803468 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803458:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80345b:	89 c2                	mov    %eax,%edx
  80345d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803461:	88 10                	mov    %dl,(%rax)
	return 1;
  803463:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803468:	c9                   	leaveq 
  803469:	c3                   	retq   

000000000080346a <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80346a:	55                   	push   %rbp
  80346b:	48 89 e5             	mov    %rsp,%rbp
  80346e:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803475:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80347c:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803483:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80348a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803491:	eb 76                	jmp    803509 <devcons_write+0x9f>
		m = n - tot;
  803493:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80349a:	89 c2                	mov    %eax,%edx
  80349c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80349f:	29 c2                	sub    %eax,%edx
  8034a1:	89 d0                	mov    %edx,%eax
  8034a3:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8034a6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034a9:	83 f8 7f             	cmp    $0x7f,%eax
  8034ac:	76 07                	jbe    8034b5 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8034ae:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8034b5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034b8:	48 63 d0             	movslq %eax,%rdx
  8034bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034be:	48 63 c8             	movslq %eax,%rcx
  8034c1:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8034c8:	48 01 c1             	add    %rax,%rcx
  8034cb:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8034d2:	48 89 ce             	mov    %rcx,%rsi
  8034d5:	48 89 c7             	mov    %rax,%rdi
  8034d8:	48 b8 22 15 80 00 00 	movabs $0x801522,%rax
  8034df:	00 00 00 
  8034e2:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8034e4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034e7:	48 63 d0             	movslq %eax,%rdx
  8034ea:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8034f1:	48 89 d6             	mov    %rdx,%rsi
  8034f4:	48 89 c7             	mov    %rax,%rdi
  8034f7:	48 b8 e5 19 80 00 00 	movabs $0x8019e5,%rax
  8034fe:	00 00 00 
  803501:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803503:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803506:	01 45 fc             	add    %eax,-0x4(%rbp)
  803509:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80350c:	48 98                	cltq   
  80350e:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803515:	0f 82 78 ff ff ff    	jb     803493 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80351b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80351e:	c9                   	leaveq 
  80351f:	c3                   	retq   

0000000000803520 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803520:	55                   	push   %rbp
  803521:	48 89 e5             	mov    %rsp,%rbp
  803524:	48 83 ec 08          	sub    $0x8,%rsp
  803528:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80352c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803531:	c9                   	leaveq 
  803532:	c3                   	retq   

0000000000803533 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803533:	55                   	push   %rbp
  803534:	48 89 e5             	mov    %rsp,%rbp
  803537:	48 83 ec 10          	sub    $0x10,%rsp
  80353b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80353f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803543:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803547:	48 be 93 3e 80 00 00 	movabs $0x803e93,%rsi
  80354e:	00 00 00 
  803551:	48 89 c7             	mov    %rax,%rdi
  803554:	48 b8 fe 11 80 00 00 	movabs $0x8011fe,%rax
  80355b:	00 00 00 
  80355e:	ff d0                	callq  *%rax
	return 0;
  803560:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803565:	c9                   	leaveq 
  803566:	c3                   	retq   

0000000000803567 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803567:	55                   	push   %rbp
  803568:	48 89 e5             	mov    %rsp,%rbp
  80356b:	48 83 ec 30          	sub    $0x30,%rsp
  80356f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803573:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803577:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  80357b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803580:	74 18                	je     80359a <ipc_recv+0x33>
  803582:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803586:	48 89 c7             	mov    %rax,%rdi
  803589:	48 b8 56 1d 80 00 00 	movabs $0x801d56,%rax
  803590:	00 00 00 
  803593:	ff d0                	callq  *%rax
  803595:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803598:	eb 19                	jmp    8035b3 <ipc_recv+0x4c>
  80359a:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  8035a1:	00 00 00 
  8035a4:	48 b8 56 1d 80 00 00 	movabs $0x801d56,%rax
  8035ab:	00 00 00 
  8035ae:	ff d0                	callq  *%rax
  8035b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  8035b3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8035b8:	74 26                	je     8035e0 <ipc_recv+0x79>
  8035ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035be:	75 15                	jne    8035d5 <ipc_recv+0x6e>
  8035c0:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8035c7:	00 00 00 
  8035ca:	48 8b 00             	mov    (%rax),%rax
  8035cd:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  8035d3:	eb 05                	jmp    8035da <ipc_recv+0x73>
  8035d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8035da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8035de:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  8035e0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8035e5:	74 26                	je     80360d <ipc_recv+0xa6>
  8035e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035eb:	75 15                	jne    803602 <ipc_recv+0x9b>
  8035ed:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8035f4:	00 00 00 
  8035f7:	48 8b 00             	mov    (%rax),%rax
  8035fa:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  803600:	eb 05                	jmp    803607 <ipc_recv+0xa0>
  803602:	b8 00 00 00 00       	mov    $0x0,%eax
  803607:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80360b:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  80360d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803611:	75 15                	jne    803628 <ipc_recv+0xc1>
  803613:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80361a:	00 00 00 
  80361d:	48 8b 00             	mov    (%rax),%rax
  803620:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  803626:	eb 03                	jmp    80362b <ipc_recv+0xc4>
  803628:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80362b:	c9                   	leaveq 
  80362c:	c3                   	retq   

000000000080362d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80362d:	55                   	push   %rbp
  80362e:	48 89 e5             	mov    %rsp,%rbp
  803631:	48 83 ec 30          	sub    $0x30,%rsp
  803635:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803638:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80363b:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80363f:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  803642:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  803649:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80364e:	75 10                	jne    803660 <ipc_send+0x33>
  803650:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803657:	00 00 00 
  80365a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  80365e:	eb 62                	jmp    8036c2 <ipc_send+0x95>
  803660:	eb 60                	jmp    8036c2 <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  803662:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803666:	74 30                	je     803698 <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  803668:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80366b:	89 c1                	mov    %eax,%ecx
  80366d:	48 ba 9a 3e 80 00 00 	movabs $0x803e9a,%rdx
  803674:	00 00 00 
  803677:	be 33 00 00 00       	mov    $0x33,%esi
  80367c:	48 bf b6 3e 80 00 00 	movabs $0x803eb6,%rdi
  803683:	00 00 00 
  803686:	b8 00 00 00 00       	mov    $0x0,%eax
  80368b:	49 b8 10 04 80 00 00 	movabs $0x800410,%r8
  803692:	00 00 00 
  803695:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  803698:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80369b:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80369e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8036a2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036a5:	89 c7                	mov    %eax,%edi
  8036a7:	48 b8 01 1d 80 00 00 	movabs $0x801d01,%rax
  8036ae:	00 00 00 
  8036b1:	ff d0                	callq  *%rax
  8036b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  8036b6:	48 b8 ef 1a 80 00 00 	movabs $0x801aef,%rax
  8036bd:	00 00 00 
  8036c0:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  8036c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036c6:	75 9a                	jne    803662 <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  8036c8:	c9                   	leaveq 
  8036c9:	c3                   	retq   

00000000008036ca <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8036ca:	55                   	push   %rbp
  8036cb:	48 89 e5             	mov    %rsp,%rbp
  8036ce:	48 83 ec 14          	sub    $0x14,%rsp
  8036d2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8036d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8036dc:	eb 5e                	jmp    80373c <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8036de:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8036e5:	00 00 00 
  8036e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036eb:	48 63 d0             	movslq %eax,%rdx
  8036ee:	48 89 d0             	mov    %rdx,%rax
  8036f1:	48 c1 e0 03          	shl    $0x3,%rax
  8036f5:	48 01 d0             	add    %rdx,%rax
  8036f8:	48 c1 e0 05          	shl    $0x5,%rax
  8036fc:	48 01 c8             	add    %rcx,%rax
  8036ff:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803705:	8b 00                	mov    (%rax),%eax
  803707:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80370a:	75 2c                	jne    803738 <ipc_find_env+0x6e>
			return envs[i].env_id;
  80370c:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803713:	00 00 00 
  803716:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803719:	48 63 d0             	movslq %eax,%rdx
  80371c:	48 89 d0             	mov    %rdx,%rax
  80371f:	48 c1 e0 03          	shl    $0x3,%rax
  803723:	48 01 d0             	add    %rdx,%rax
  803726:	48 c1 e0 05          	shl    $0x5,%rax
  80372a:	48 01 c8             	add    %rcx,%rax
  80372d:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803733:	8b 40 08             	mov    0x8(%rax),%eax
  803736:	eb 12                	jmp    80374a <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803738:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80373c:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803743:	7e 99                	jle    8036de <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803745:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80374a:	c9                   	leaveq 
  80374b:	c3                   	retq   

000000000080374c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80374c:	55                   	push   %rbp
  80374d:	48 89 e5             	mov    %rsp,%rbp
  803750:	48 83 ec 18          	sub    $0x18,%rsp
  803754:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803758:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80375c:	48 c1 e8 15          	shr    $0x15,%rax
  803760:	48 89 c2             	mov    %rax,%rdx
  803763:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80376a:	01 00 00 
  80376d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803771:	83 e0 01             	and    $0x1,%eax
  803774:	48 85 c0             	test   %rax,%rax
  803777:	75 07                	jne    803780 <pageref+0x34>
		return 0;
  803779:	b8 00 00 00 00       	mov    $0x0,%eax
  80377e:	eb 53                	jmp    8037d3 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803780:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803784:	48 c1 e8 0c          	shr    $0xc,%rax
  803788:	48 89 c2             	mov    %rax,%rdx
  80378b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803792:	01 00 00 
  803795:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803799:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80379d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037a1:	83 e0 01             	and    $0x1,%eax
  8037a4:	48 85 c0             	test   %rax,%rax
  8037a7:	75 07                	jne    8037b0 <pageref+0x64>
		return 0;
  8037a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8037ae:	eb 23                	jmp    8037d3 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8037b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037b4:	48 c1 e8 0c          	shr    $0xc,%rax
  8037b8:	48 89 c2             	mov    %rax,%rdx
  8037bb:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8037c2:	00 00 00 
  8037c5:	48 c1 e2 04          	shl    $0x4,%rdx
  8037c9:	48 01 d0             	add    %rdx,%rax
  8037cc:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8037d0:	0f b7 c0             	movzwl %ax,%eax
}
  8037d3:	c9                   	leaveq 
  8037d4:	c3                   	retq   
