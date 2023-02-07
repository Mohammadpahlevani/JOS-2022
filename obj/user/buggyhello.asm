
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
  80005c:	48 b8 b3 01 80 00 00 	movabs $0x8001b3,%rax
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
  80006e:	48 83 ec 20          	sub    $0x20,%rsp
  800072:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800075:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800079:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  800080:	00 00 00 
  800083:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	envid_t id = sys_getenvid();
  80008a:	48 b8 7f 02 80 00 00 	movabs $0x80027f,%rax
  800091:	00 00 00 
  800094:	ff d0                	callq  *%rax
  800096:	89 45 fc             	mov    %eax,-0x4(%rbp)
        id = ENVX(id);
  800099:	81 65 fc ff 03 00 00 	andl   $0x3ff,-0x4(%rbp)
	thisenv = &envs[id];
  8000a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000a3:	48 63 d0             	movslq %eax,%rdx
  8000a6:	48 89 d0             	mov    %rdx,%rax
  8000a9:	48 c1 e0 03          	shl    $0x3,%rax
  8000ad:	48 01 d0             	add    %rdx,%rax
  8000b0:	48 c1 e0 05          	shl    $0x5,%rax
  8000b4:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000bb:	00 00 00 
  8000be:	48 01 c2             	add    %rax,%rdx
  8000c1:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000c8:	00 00 00 
  8000cb:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000d2:	7e 14                	jle    8000e8 <libmain+0x7e>
		binaryname = argv[0];
  8000d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000d8:	48 8b 10             	mov    (%rax),%rdx
  8000db:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000e2:	00 00 00 
  8000e5:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000e8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8000ec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000ef:	48 89 d6             	mov    %rdx,%rsi
  8000f2:	89 c7                	mov    %eax,%edi
  8000f4:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000fb:	00 00 00 
  8000fe:	ff d0                	callq  *%rax
	
	//cprintf("\noutside\n");
	// exit gracefully
	exit();
  800100:	48 b8 0e 01 80 00 00 	movabs $0x80010e,%rax
  800107:	00 00 00 
  80010a:	ff d0                	callq  *%rax
}
  80010c:	c9                   	leaveq 
  80010d:	c3                   	retq   

000000000080010e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80010e:	55                   	push   %rbp
  80010f:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  800112:	bf 00 00 00 00       	mov    $0x0,%edi
  800117:	48 b8 3b 02 80 00 00 	movabs $0x80023b,%rax
  80011e:	00 00 00 
  800121:	ff d0                	callq  *%rax
}
  800123:	5d                   	pop    %rbp
  800124:	c3                   	retq   

0000000000800125 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800125:	55                   	push   %rbp
  800126:	48 89 e5             	mov    %rsp,%rbp
  800129:	53                   	push   %rbx
  80012a:	48 83 ec 48          	sub    $0x48,%rsp
  80012e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800131:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800134:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800138:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80013c:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800140:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800144:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800147:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80014b:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80014f:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800153:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800157:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80015b:	4c 89 c3             	mov    %r8,%rbx
  80015e:	cd 30                	int    $0x30
  800160:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800164:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800168:	74 3e                	je     8001a8 <syscall+0x83>
  80016a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80016f:	7e 37                	jle    8001a8 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800171:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800175:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800178:	49 89 d0             	mov    %rdx,%r8
  80017b:	89 c1                	mov    %eax,%ecx
  80017d:	48 ba 8a 1a 80 00 00 	movabs $0x801a8a,%rdx
  800184:	00 00 00 
  800187:	be 23 00 00 00       	mov    $0x23,%esi
  80018c:	48 bf a7 1a 80 00 00 	movabs $0x801aa7,%rdi
  800193:	00 00 00 
  800196:	b8 00 00 00 00       	mov    $0x0,%eax
  80019b:	49 b9 1e 05 80 00 00 	movabs $0x80051e,%r9
  8001a2:	00 00 00 
  8001a5:	41 ff d1             	callq  *%r9

	return ret;
  8001a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001ac:	48 83 c4 48          	add    $0x48,%rsp
  8001b0:	5b                   	pop    %rbx
  8001b1:	5d                   	pop    %rbp
  8001b2:	c3                   	retq   

00000000008001b3 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001b3:	55                   	push   %rbp
  8001b4:	48 89 e5             	mov    %rsp,%rbp
  8001b7:	48 83 ec 20          	sub    $0x20,%rsp
  8001bb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001bf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001c7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001cb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001d2:	00 
  8001d3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001d9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001df:	48 89 d1             	mov    %rdx,%rcx
  8001e2:	48 89 c2             	mov    %rax,%rdx
  8001e5:	be 00 00 00 00       	mov    $0x0,%esi
  8001ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8001ef:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  8001f6:	00 00 00 
  8001f9:	ff d0                	callq  *%rax
}
  8001fb:	c9                   	leaveq 
  8001fc:	c3                   	retq   

00000000008001fd <sys_cgetc>:

int
sys_cgetc(void)
{
  8001fd:	55                   	push   %rbp
  8001fe:	48 89 e5             	mov    %rsp,%rbp
  800201:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800205:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80020c:	00 
  80020d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800213:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800219:	b9 00 00 00 00       	mov    $0x0,%ecx
  80021e:	ba 00 00 00 00       	mov    $0x0,%edx
  800223:	be 00 00 00 00       	mov    $0x0,%esi
  800228:	bf 01 00 00 00       	mov    $0x1,%edi
  80022d:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  800234:	00 00 00 
  800237:	ff d0                	callq  *%rax
}
  800239:	c9                   	leaveq 
  80023a:	c3                   	retq   

000000000080023b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80023b:	55                   	push   %rbp
  80023c:	48 89 e5             	mov    %rsp,%rbp
  80023f:	48 83 ec 10          	sub    $0x10,%rsp
  800243:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800246:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800249:	48 98                	cltq   
  80024b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800252:	00 
  800253:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800259:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80025f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800264:	48 89 c2             	mov    %rax,%rdx
  800267:	be 01 00 00 00       	mov    $0x1,%esi
  80026c:	bf 03 00 00 00       	mov    $0x3,%edi
  800271:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  800278:	00 00 00 
  80027b:	ff d0                	callq  *%rax
}
  80027d:	c9                   	leaveq 
  80027e:	c3                   	retq   

000000000080027f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80027f:	55                   	push   %rbp
  800280:	48 89 e5             	mov    %rsp,%rbp
  800283:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800287:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80028e:	00 
  80028f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800295:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80029b:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8002a5:	be 00 00 00 00       	mov    $0x0,%esi
  8002aa:	bf 02 00 00 00       	mov    $0x2,%edi
  8002af:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  8002b6:	00 00 00 
  8002b9:	ff d0                	callq  *%rax
}
  8002bb:	c9                   	leaveq 
  8002bc:	c3                   	retq   

00000000008002bd <sys_yield>:

void
sys_yield(void)
{
  8002bd:	55                   	push   %rbp
  8002be:	48 89 e5             	mov    %rsp,%rbp
  8002c1:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002c5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002cc:	00 
  8002cd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002d3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002d9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002de:	ba 00 00 00 00       	mov    $0x0,%edx
  8002e3:	be 00 00 00 00       	mov    $0x0,%esi
  8002e8:	bf 0a 00 00 00       	mov    $0xa,%edi
  8002ed:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  8002f4:	00 00 00 
  8002f7:	ff d0                	callq  *%rax
}
  8002f9:	c9                   	leaveq 
  8002fa:	c3                   	retq   

00000000008002fb <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002fb:	55                   	push   %rbp
  8002fc:	48 89 e5             	mov    %rsp,%rbp
  8002ff:	48 83 ec 20          	sub    $0x20,%rsp
  800303:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800306:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80030a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80030d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800310:	48 63 c8             	movslq %eax,%rcx
  800313:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800317:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80031a:	48 98                	cltq   
  80031c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800323:	00 
  800324:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80032a:	49 89 c8             	mov    %rcx,%r8
  80032d:	48 89 d1             	mov    %rdx,%rcx
  800330:	48 89 c2             	mov    %rax,%rdx
  800333:	be 01 00 00 00       	mov    $0x1,%esi
  800338:	bf 04 00 00 00       	mov    $0x4,%edi
  80033d:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  800344:	00 00 00 
  800347:	ff d0                	callq  *%rax
}
  800349:	c9                   	leaveq 
  80034a:	c3                   	retq   

000000000080034b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80034b:	55                   	push   %rbp
  80034c:	48 89 e5             	mov    %rsp,%rbp
  80034f:	48 83 ec 30          	sub    $0x30,%rsp
  800353:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800356:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80035a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80035d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800361:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800365:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800368:	48 63 c8             	movslq %eax,%rcx
  80036b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80036f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800372:	48 63 f0             	movslq %eax,%rsi
  800375:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800379:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80037c:	48 98                	cltq   
  80037e:	48 89 0c 24          	mov    %rcx,(%rsp)
  800382:	49 89 f9             	mov    %rdi,%r9
  800385:	49 89 f0             	mov    %rsi,%r8
  800388:	48 89 d1             	mov    %rdx,%rcx
  80038b:	48 89 c2             	mov    %rax,%rdx
  80038e:	be 01 00 00 00       	mov    $0x1,%esi
  800393:	bf 05 00 00 00       	mov    $0x5,%edi
  800398:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  80039f:	00 00 00 
  8003a2:	ff d0                	callq  *%rax
}
  8003a4:	c9                   	leaveq 
  8003a5:	c3                   	retq   

00000000008003a6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8003a6:	55                   	push   %rbp
  8003a7:	48 89 e5             	mov    %rsp,%rbp
  8003aa:	48 83 ec 20          	sub    $0x20,%rsp
  8003ae:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003b5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003bc:	48 98                	cltq   
  8003be:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003c5:	00 
  8003c6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003cc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003d2:	48 89 d1             	mov    %rdx,%rcx
  8003d5:	48 89 c2             	mov    %rax,%rdx
  8003d8:	be 01 00 00 00       	mov    $0x1,%esi
  8003dd:	bf 06 00 00 00       	mov    $0x6,%edi
  8003e2:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  8003e9:	00 00 00 
  8003ec:	ff d0                	callq  *%rax
}
  8003ee:	c9                   	leaveq 
  8003ef:	c3                   	retq   

00000000008003f0 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003f0:	55                   	push   %rbp
  8003f1:	48 89 e5             	mov    %rsp,%rbp
  8003f4:	48 83 ec 10          	sub    $0x10,%rsp
  8003f8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003fb:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8003fe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800401:	48 63 d0             	movslq %eax,%rdx
  800404:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800407:	48 98                	cltq   
  800409:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800410:	00 
  800411:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800417:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80041d:	48 89 d1             	mov    %rdx,%rcx
  800420:	48 89 c2             	mov    %rax,%rdx
  800423:	be 01 00 00 00       	mov    $0x1,%esi
  800428:	bf 08 00 00 00       	mov    $0x8,%edi
  80042d:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  800434:	00 00 00 
  800437:	ff d0                	callq  *%rax
}
  800439:	c9                   	leaveq 
  80043a:	c3                   	retq   

000000000080043b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80043b:	55                   	push   %rbp
  80043c:	48 89 e5             	mov    %rsp,%rbp
  80043f:	48 83 ec 20          	sub    $0x20,%rsp
  800443:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800446:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80044a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80044e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800451:	48 98                	cltq   
  800453:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80045a:	00 
  80045b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800461:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800467:	48 89 d1             	mov    %rdx,%rcx
  80046a:	48 89 c2             	mov    %rax,%rdx
  80046d:	be 01 00 00 00       	mov    $0x1,%esi
  800472:	bf 09 00 00 00       	mov    $0x9,%edi
  800477:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  80047e:	00 00 00 
  800481:	ff d0                	callq  *%rax
}
  800483:	c9                   	leaveq 
  800484:	c3                   	retq   

0000000000800485 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  800485:	55                   	push   %rbp
  800486:	48 89 e5             	mov    %rsp,%rbp
  800489:	48 83 ec 20          	sub    $0x20,%rsp
  80048d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800490:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800494:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800498:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80049b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80049e:	48 63 f0             	movslq %eax,%rsi
  8004a1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004a8:	48 98                	cltq   
  8004aa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004ae:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004b5:	00 
  8004b6:	49 89 f1             	mov    %rsi,%r9
  8004b9:	49 89 c8             	mov    %rcx,%r8
  8004bc:	48 89 d1             	mov    %rdx,%rcx
  8004bf:	48 89 c2             	mov    %rax,%rdx
  8004c2:	be 00 00 00 00       	mov    $0x0,%esi
  8004c7:	bf 0b 00 00 00       	mov    $0xb,%edi
  8004cc:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  8004d3:	00 00 00 
  8004d6:	ff d0                	callq  *%rax
}
  8004d8:	c9                   	leaveq 
  8004d9:	c3                   	retq   

00000000008004da <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8004da:	55                   	push   %rbp
  8004db:	48 89 e5             	mov    %rsp,%rbp
  8004de:	48 83 ec 10          	sub    $0x10,%rsp
  8004e2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8004e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004ea:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004f1:	00 
  8004f2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004f8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800503:	48 89 c2             	mov    %rax,%rdx
  800506:	be 01 00 00 00       	mov    $0x1,%esi
  80050b:	bf 0c 00 00 00       	mov    $0xc,%edi
  800510:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  800517:	00 00 00 
  80051a:	ff d0                	callq  *%rax
}
  80051c:	c9                   	leaveq 
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
  8005a7:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8005ae:	00 00 00 
  8005b1:	48 8b 18             	mov    (%rax),%rbx
  8005b4:	48 b8 7f 02 80 00 00 	movabs $0x80027f,%rax
  8005bb:	00 00 00 
  8005be:	ff d0                	callq  *%rax
  8005c0:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8005c6:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8005cd:	41 89 c8             	mov    %ecx,%r8d
  8005d0:	48 89 d1             	mov    %rdx,%rcx
  8005d3:	48 89 da             	mov    %rbx,%rdx
  8005d6:	89 c6                	mov    %eax,%esi
  8005d8:	48 bf b8 1a 80 00 00 	movabs $0x801ab8,%rdi
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
  800614:	48 bf db 1a 80 00 00 	movabs $0x801adb,%rdi
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
  800682:	48 b8 b3 01 80 00 00 	movabs $0x8001b3,%rax
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
  800743:	48 b8 b3 01 80 00 00 	movabs $0x8001b3,%rax
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
  8008c3:	48 ba d0 1b 80 00 00 	movabs $0x801bd0,%rdx
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
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b43:	eb 17                	jmp    800b5c <vprintfmt+0x52>
			if (ch == '\0')
  800b45:	85 db                	test   %ebx,%ebx
  800b47:	0f 84 cc 04 00 00    	je     801019 <vprintfmt+0x50f>
                }
#endif

			  return;
			}
			putch(ch, putdat);
  800b4d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b51:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b55:	48 89 d6             	mov    %rdx,%rsi
  800b58:	89 df                	mov    %ebx,%edi
  800b5a:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b5c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b60:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b64:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b68:	0f b6 00             	movzbl (%rax),%eax
  800b6b:	0f b6 d8             	movzbl %al,%ebx
  800b6e:	83 fb 25             	cmp    $0x25,%ebx
  800b71:	75 d2                	jne    800b45 <vprintfmt+0x3b>
			  return;
			}
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
  800bbb:	48 b8 f8 1b 80 00 00 	movabs $0x801bf8,%rax
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
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
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
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
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
  800d09:	83 fb 09             	cmp    $0x9,%ebx
  800d0c:	7f 16                	jg     800d24 <vprintfmt+0x21a>
  800d0e:	48 b8 80 1b 80 00 00 	movabs $0x801b80,%rax
  800d15:	00 00 00 
  800d18:	48 63 d3             	movslq %ebx,%rdx
  800d1b:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800d1f:	4d 85 e4             	test   %r12,%r12
  800d22:	75 2e                	jne    800d52 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800d24:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d28:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d2c:	89 d9                	mov    %ebx,%ecx
  800d2e:	48 ba e1 1b 80 00 00 	movabs $0x801be1,%rdx
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
  800d5d:	48 ba ea 1b 80 00 00 	movabs $0x801bea,%rdx
  800d64:	00 00 00 
  800d67:	48 89 c7             	mov    %rax,%rdi
  800d6a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6f:	49 b8 22 10 80 00 00 	movabs $0x801022,%r8
  800d76:	00 00 00 
  800d79:	41 ff d0             	callq  *%r8
			break;
  800d7c:	e9 92 02 00 00       	jmpq   801013 <vprintfmt+0x509>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
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
  800db7:	49 bc ed 1b 80 00 00 	movabs $0x801bed,%r12
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
  800dd8:	48 b8 ce 12 80 00 00 	movabs $0x8012ce,%rax
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
                }
#endif
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
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  800e7e:	e9 90 01 00 00       	jmpq   801013 <vprintfmt+0x509>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

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
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			
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
                  ch = *(unsigned char *) color;
                }
#endif

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
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

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
                }
#endif

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
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f76:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f7a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f81:	eb 23                	jmp    800fa6 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

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
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

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
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801014:	e9 43 fb ff ff       	jmpq   800b5c <vprintfmt+0x52>
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

00000000008012a0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8012a0:	55                   	push   %rbp
  8012a1:	48 89 e5             	mov    %rsp,%rbp
  8012a4:	48 83 ec 18          	sub    $0x18,%rsp
  8012a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8012ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012b3:	eb 09                	jmp    8012be <strlen+0x1e>
		n++;
  8012b5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012b9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c2:	0f b6 00             	movzbl (%rax),%eax
  8012c5:	84 c0                	test   %al,%al
  8012c7:	75 ec                	jne    8012b5 <strlen+0x15>
		n++;
	return n;
  8012c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012cc:	c9                   	leaveq 
  8012cd:	c3                   	retq   

00000000008012ce <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8012ce:	55                   	push   %rbp
  8012cf:	48 89 e5             	mov    %rsp,%rbp
  8012d2:	48 83 ec 20          	sub    $0x20,%rsp
  8012d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012da:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012e5:	eb 0e                	jmp    8012f5 <strnlen+0x27>
		n++;
  8012e7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012eb:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012f0:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8012f5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8012fa:	74 0b                	je     801307 <strnlen+0x39>
  8012fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801300:	0f b6 00             	movzbl (%rax),%eax
  801303:	84 c0                	test   %al,%al
  801305:	75 e0                	jne    8012e7 <strnlen+0x19>
		n++;
	return n;
  801307:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80130a:	c9                   	leaveq 
  80130b:	c3                   	retq   

000000000080130c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80130c:	55                   	push   %rbp
  80130d:	48 89 e5             	mov    %rsp,%rbp
  801310:	48 83 ec 20          	sub    $0x20,%rsp
  801314:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801318:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80131c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801320:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801324:	90                   	nop
  801325:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801329:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80132d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801331:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801335:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801339:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80133d:	0f b6 12             	movzbl (%rdx),%edx
  801340:	88 10                	mov    %dl,(%rax)
  801342:	0f b6 00             	movzbl (%rax),%eax
  801345:	84 c0                	test   %al,%al
  801347:	75 dc                	jne    801325 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801349:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80134d:	c9                   	leaveq 
  80134e:	c3                   	retq   

000000000080134f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80134f:	55                   	push   %rbp
  801350:	48 89 e5             	mov    %rsp,%rbp
  801353:	48 83 ec 20          	sub    $0x20,%rsp
  801357:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80135b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80135f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801363:	48 89 c7             	mov    %rax,%rdi
  801366:	48 b8 a0 12 80 00 00 	movabs $0x8012a0,%rax
  80136d:	00 00 00 
  801370:	ff d0                	callq  *%rax
  801372:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801375:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801378:	48 63 d0             	movslq %eax,%rdx
  80137b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80137f:	48 01 c2             	add    %rax,%rdx
  801382:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801386:	48 89 c6             	mov    %rax,%rsi
  801389:	48 89 d7             	mov    %rdx,%rdi
  80138c:	48 b8 0c 13 80 00 00 	movabs $0x80130c,%rax
  801393:	00 00 00 
  801396:	ff d0                	callq  *%rax
	return dst;
  801398:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80139c:	c9                   	leaveq 
  80139d:	c3                   	retq   

000000000080139e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80139e:	55                   	push   %rbp
  80139f:	48 89 e5             	mov    %rsp,%rbp
  8013a2:	48 83 ec 28          	sub    $0x28,%rsp
  8013a6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013aa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013ae:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8013b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013b6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8013ba:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8013c1:	00 
  8013c2:	eb 2a                	jmp    8013ee <strncpy+0x50>
		*dst++ = *src;
  8013c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013c8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013cc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013d0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013d4:	0f b6 12             	movzbl (%rdx),%edx
  8013d7:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013dd:	0f b6 00             	movzbl (%rax),%eax
  8013e0:	84 c0                	test   %al,%al
  8013e2:	74 05                	je     8013e9 <strncpy+0x4b>
			src++;
  8013e4:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013e9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8013f6:	72 cc                	jb     8013c4 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8013fc:	c9                   	leaveq 
  8013fd:	c3                   	retq   

00000000008013fe <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8013fe:	55                   	push   %rbp
  8013ff:	48 89 e5             	mov    %rsp,%rbp
  801402:	48 83 ec 28          	sub    $0x28,%rsp
  801406:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80140a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80140e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801412:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801416:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80141a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80141f:	74 3d                	je     80145e <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801421:	eb 1d                	jmp    801440 <strlcpy+0x42>
			*dst++ = *src++;
  801423:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801427:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80142b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80142f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801433:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801437:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80143b:	0f b6 12             	movzbl (%rdx),%edx
  80143e:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801440:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801445:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80144a:	74 0b                	je     801457 <strlcpy+0x59>
  80144c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801450:	0f b6 00             	movzbl (%rax),%eax
  801453:	84 c0                	test   %al,%al
  801455:	75 cc                	jne    801423 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801457:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80145b:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80145e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801462:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801466:	48 29 c2             	sub    %rax,%rdx
  801469:	48 89 d0             	mov    %rdx,%rax
}
  80146c:	c9                   	leaveq 
  80146d:	c3                   	retq   

000000000080146e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80146e:	55                   	push   %rbp
  80146f:	48 89 e5             	mov    %rsp,%rbp
  801472:	48 83 ec 10          	sub    $0x10,%rsp
  801476:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80147a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80147e:	eb 0a                	jmp    80148a <strcmp+0x1c>
		p++, q++;
  801480:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801485:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80148a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80148e:	0f b6 00             	movzbl (%rax),%eax
  801491:	84 c0                	test   %al,%al
  801493:	74 12                	je     8014a7 <strcmp+0x39>
  801495:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801499:	0f b6 10             	movzbl (%rax),%edx
  80149c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a0:	0f b6 00             	movzbl (%rax),%eax
  8014a3:	38 c2                	cmp    %al,%dl
  8014a5:	74 d9                	je     801480 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ab:	0f b6 00             	movzbl (%rax),%eax
  8014ae:	0f b6 d0             	movzbl %al,%edx
  8014b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b5:	0f b6 00             	movzbl (%rax),%eax
  8014b8:	0f b6 c0             	movzbl %al,%eax
  8014bb:	29 c2                	sub    %eax,%edx
  8014bd:	89 d0                	mov    %edx,%eax
}
  8014bf:	c9                   	leaveq 
  8014c0:	c3                   	retq   

00000000008014c1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8014c1:	55                   	push   %rbp
  8014c2:	48 89 e5             	mov    %rsp,%rbp
  8014c5:	48 83 ec 18          	sub    $0x18,%rsp
  8014c9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014cd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014d1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8014d5:	eb 0f                	jmp    8014e6 <strncmp+0x25>
		n--, p++, q++;
  8014d7:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8014dc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014e1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8014e6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014eb:	74 1d                	je     80150a <strncmp+0x49>
  8014ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f1:	0f b6 00             	movzbl (%rax),%eax
  8014f4:	84 c0                	test   %al,%al
  8014f6:	74 12                	je     80150a <strncmp+0x49>
  8014f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014fc:	0f b6 10             	movzbl (%rax),%edx
  8014ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801503:	0f b6 00             	movzbl (%rax),%eax
  801506:	38 c2                	cmp    %al,%dl
  801508:	74 cd                	je     8014d7 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80150a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80150f:	75 07                	jne    801518 <strncmp+0x57>
		return 0;
  801511:	b8 00 00 00 00       	mov    $0x0,%eax
  801516:	eb 18                	jmp    801530 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801518:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80151c:	0f b6 00             	movzbl (%rax),%eax
  80151f:	0f b6 d0             	movzbl %al,%edx
  801522:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801526:	0f b6 00             	movzbl (%rax),%eax
  801529:	0f b6 c0             	movzbl %al,%eax
  80152c:	29 c2                	sub    %eax,%edx
  80152e:	89 d0                	mov    %edx,%eax
}
  801530:	c9                   	leaveq 
  801531:	c3                   	retq   

0000000000801532 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801532:	55                   	push   %rbp
  801533:	48 89 e5             	mov    %rsp,%rbp
  801536:	48 83 ec 0c          	sub    $0xc,%rsp
  80153a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80153e:	89 f0                	mov    %esi,%eax
  801540:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801543:	eb 17                	jmp    80155c <strchr+0x2a>
		if (*s == c)
  801545:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801549:	0f b6 00             	movzbl (%rax),%eax
  80154c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80154f:	75 06                	jne    801557 <strchr+0x25>
			return (char *) s;
  801551:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801555:	eb 15                	jmp    80156c <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801557:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80155c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801560:	0f b6 00             	movzbl (%rax),%eax
  801563:	84 c0                	test   %al,%al
  801565:	75 de                	jne    801545 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801567:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80156c:	c9                   	leaveq 
  80156d:	c3                   	retq   

000000000080156e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80156e:	55                   	push   %rbp
  80156f:	48 89 e5             	mov    %rsp,%rbp
  801572:	48 83 ec 0c          	sub    $0xc,%rsp
  801576:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80157a:	89 f0                	mov    %esi,%eax
  80157c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80157f:	eb 13                	jmp    801594 <strfind+0x26>
		if (*s == c)
  801581:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801585:	0f b6 00             	movzbl (%rax),%eax
  801588:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80158b:	75 02                	jne    80158f <strfind+0x21>
			break;
  80158d:	eb 10                	jmp    80159f <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80158f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801594:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801598:	0f b6 00             	movzbl (%rax),%eax
  80159b:	84 c0                	test   %al,%al
  80159d:	75 e2                	jne    801581 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80159f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8015a3:	c9                   	leaveq 
  8015a4:	c3                   	retq   

00000000008015a5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8015a5:	55                   	push   %rbp
  8015a6:	48 89 e5             	mov    %rsp,%rbp
  8015a9:	48 83 ec 18          	sub    $0x18,%rsp
  8015ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015b1:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8015b4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8015b8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015bd:	75 06                	jne    8015c5 <memset+0x20>
		return v;
  8015bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c3:	eb 69                	jmp    80162e <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8015c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c9:	83 e0 03             	and    $0x3,%eax
  8015cc:	48 85 c0             	test   %rax,%rax
  8015cf:	75 48                	jne    801619 <memset+0x74>
  8015d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015d5:	83 e0 03             	and    $0x3,%eax
  8015d8:	48 85 c0             	test   %rax,%rax
  8015db:	75 3c                	jne    801619 <memset+0x74>
		c &= 0xFF;
  8015dd:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8015e4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015e7:	c1 e0 18             	shl    $0x18,%eax
  8015ea:	89 c2                	mov    %eax,%edx
  8015ec:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015ef:	c1 e0 10             	shl    $0x10,%eax
  8015f2:	09 c2                	or     %eax,%edx
  8015f4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015f7:	c1 e0 08             	shl    $0x8,%eax
  8015fa:	09 d0                	or     %edx,%eax
  8015fc:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8015ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801603:	48 c1 e8 02          	shr    $0x2,%rax
  801607:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80160a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80160e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801611:	48 89 d7             	mov    %rdx,%rdi
  801614:	fc                   	cld    
  801615:	f3 ab                	rep stos %eax,%es:(%rdi)
  801617:	eb 11                	jmp    80162a <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801619:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80161d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801620:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801624:	48 89 d7             	mov    %rdx,%rdi
  801627:	fc                   	cld    
  801628:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  80162a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80162e:	c9                   	leaveq 
  80162f:	c3                   	retq   

0000000000801630 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801630:	55                   	push   %rbp
  801631:	48 89 e5             	mov    %rsp,%rbp
  801634:	48 83 ec 28          	sub    $0x28,%rsp
  801638:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80163c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801640:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801644:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801648:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80164c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801650:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801654:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801658:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80165c:	0f 83 88 00 00 00    	jae    8016ea <memmove+0xba>
  801662:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801666:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80166a:	48 01 d0             	add    %rdx,%rax
  80166d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801671:	76 77                	jbe    8016ea <memmove+0xba>
		s += n;
  801673:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801677:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80167b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167f:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801683:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801687:	83 e0 03             	and    $0x3,%eax
  80168a:	48 85 c0             	test   %rax,%rax
  80168d:	75 3b                	jne    8016ca <memmove+0x9a>
  80168f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801693:	83 e0 03             	and    $0x3,%eax
  801696:	48 85 c0             	test   %rax,%rax
  801699:	75 2f                	jne    8016ca <memmove+0x9a>
  80169b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169f:	83 e0 03             	and    $0x3,%eax
  8016a2:	48 85 c0             	test   %rax,%rax
  8016a5:	75 23                	jne    8016ca <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8016a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ab:	48 83 e8 04          	sub    $0x4,%rax
  8016af:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016b3:	48 83 ea 04          	sub    $0x4,%rdx
  8016b7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8016bb:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8016bf:	48 89 c7             	mov    %rax,%rdi
  8016c2:	48 89 d6             	mov    %rdx,%rsi
  8016c5:	fd                   	std    
  8016c6:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016c8:	eb 1d                	jmp    8016e7 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8016ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ce:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016d6:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8016da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016de:	48 89 d7             	mov    %rdx,%rdi
  8016e1:	48 89 c1             	mov    %rax,%rcx
  8016e4:	fd                   	std    
  8016e5:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8016e7:	fc                   	cld    
  8016e8:	eb 57                	jmp    801741 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ee:	83 e0 03             	and    $0x3,%eax
  8016f1:	48 85 c0             	test   %rax,%rax
  8016f4:	75 36                	jne    80172c <memmove+0xfc>
  8016f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016fa:	83 e0 03             	and    $0x3,%eax
  8016fd:	48 85 c0             	test   %rax,%rax
  801700:	75 2a                	jne    80172c <memmove+0xfc>
  801702:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801706:	83 e0 03             	and    $0x3,%eax
  801709:	48 85 c0             	test   %rax,%rax
  80170c:	75 1e                	jne    80172c <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80170e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801712:	48 c1 e8 02          	shr    $0x2,%rax
  801716:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801719:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80171d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801721:	48 89 c7             	mov    %rax,%rdi
  801724:	48 89 d6             	mov    %rdx,%rsi
  801727:	fc                   	cld    
  801728:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80172a:	eb 15                	jmp    801741 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80172c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801730:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801734:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801738:	48 89 c7             	mov    %rax,%rdi
  80173b:	48 89 d6             	mov    %rdx,%rsi
  80173e:	fc                   	cld    
  80173f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801741:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801745:	c9                   	leaveq 
  801746:	c3                   	retq   

0000000000801747 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801747:	55                   	push   %rbp
  801748:	48 89 e5             	mov    %rsp,%rbp
  80174b:	48 83 ec 18          	sub    $0x18,%rsp
  80174f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801753:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801757:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80175b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80175f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801763:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801767:	48 89 ce             	mov    %rcx,%rsi
  80176a:	48 89 c7             	mov    %rax,%rdi
  80176d:	48 b8 30 16 80 00 00 	movabs $0x801630,%rax
  801774:	00 00 00 
  801777:	ff d0                	callq  *%rax
}
  801779:	c9                   	leaveq 
  80177a:	c3                   	retq   

000000000080177b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80177b:	55                   	push   %rbp
  80177c:	48 89 e5             	mov    %rsp,%rbp
  80177f:	48 83 ec 28          	sub    $0x28,%rsp
  801783:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801787:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80178b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80178f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801793:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801797:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80179b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80179f:	eb 36                	jmp    8017d7 <memcmp+0x5c>
		if (*s1 != *s2)
  8017a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017a5:	0f b6 10             	movzbl (%rax),%edx
  8017a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017ac:	0f b6 00             	movzbl (%rax),%eax
  8017af:	38 c2                	cmp    %al,%dl
  8017b1:	74 1a                	je     8017cd <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8017b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017b7:	0f b6 00             	movzbl (%rax),%eax
  8017ba:	0f b6 d0             	movzbl %al,%edx
  8017bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017c1:	0f b6 00             	movzbl (%rax),%eax
  8017c4:	0f b6 c0             	movzbl %al,%eax
  8017c7:	29 c2                	sub    %eax,%edx
  8017c9:	89 d0                	mov    %edx,%eax
  8017cb:	eb 20                	jmp    8017ed <memcmp+0x72>
		s1++, s2++;
  8017cd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017d2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8017d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017db:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017df:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017e3:	48 85 c0             	test   %rax,%rax
  8017e6:	75 b9                	jne    8017a1 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ed:	c9                   	leaveq 
  8017ee:	c3                   	retq   

00000000008017ef <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8017ef:	55                   	push   %rbp
  8017f0:	48 89 e5             	mov    %rsp,%rbp
  8017f3:	48 83 ec 28          	sub    $0x28,%rsp
  8017f7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017fb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8017fe:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801802:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801806:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80180a:	48 01 d0             	add    %rdx,%rax
  80180d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801811:	eb 15                	jmp    801828 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801813:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801817:	0f b6 10             	movzbl (%rax),%edx
  80181a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80181d:	38 c2                	cmp    %al,%dl
  80181f:	75 02                	jne    801823 <memfind+0x34>
			break;
  801821:	eb 0f                	jmp    801832 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801823:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801828:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80182c:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801830:	72 e1                	jb     801813 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801832:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801836:	c9                   	leaveq 
  801837:	c3                   	retq   

0000000000801838 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801838:	55                   	push   %rbp
  801839:	48 89 e5             	mov    %rsp,%rbp
  80183c:	48 83 ec 34          	sub    $0x34,%rsp
  801840:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801844:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801848:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80184b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801852:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801859:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80185a:	eb 05                	jmp    801861 <strtol+0x29>
		s++;
  80185c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801861:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801865:	0f b6 00             	movzbl (%rax),%eax
  801868:	3c 20                	cmp    $0x20,%al
  80186a:	74 f0                	je     80185c <strtol+0x24>
  80186c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801870:	0f b6 00             	movzbl (%rax),%eax
  801873:	3c 09                	cmp    $0x9,%al
  801875:	74 e5                	je     80185c <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801877:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80187b:	0f b6 00             	movzbl (%rax),%eax
  80187e:	3c 2b                	cmp    $0x2b,%al
  801880:	75 07                	jne    801889 <strtol+0x51>
		s++;
  801882:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801887:	eb 17                	jmp    8018a0 <strtol+0x68>
	else if (*s == '-')
  801889:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80188d:	0f b6 00             	movzbl (%rax),%eax
  801890:	3c 2d                	cmp    $0x2d,%al
  801892:	75 0c                	jne    8018a0 <strtol+0x68>
		s++, neg = 1;
  801894:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801899:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8018a0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018a4:	74 06                	je     8018ac <strtol+0x74>
  8018a6:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8018aa:	75 28                	jne    8018d4 <strtol+0x9c>
  8018ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b0:	0f b6 00             	movzbl (%rax),%eax
  8018b3:	3c 30                	cmp    $0x30,%al
  8018b5:	75 1d                	jne    8018d4 <strtol+0x9c>
  8018b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018bb:	48 83 c0 01          	add    $0x1,%rax
  8018bf:	0f b6 00             	movzbl (%rax),%eax
  8018c2:	3c 78                	cmp    $0x78,%al
  8018c4:	75 0e                	jne    8018d4 <strtol+0x9c>
		s += 2, base = 16;
  8018c6:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8018cb:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8018d2:	eb 2c                	jmp    801900 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8018d4:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018d8:	75 19                	jne    8018f3 <strtol+0xbb>
  8018da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018de:	0f b6 00             	movzbl (%rax),%eax
  8018e1:	3c 30                	cmp    $0x30,%al
  8018e3:	75 0e                	jne    8018f3 <strtol+0xbb>
		s++, base = 8;
  8018e5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018ea:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8018f1:	eb 0d                	jmp    801900 <strtol+0xc8>
	else if (base == 0)
  8018f3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018f7:	75 07                	jne    801900 <strtol+0xc8>
		base = 10;
  8018f9:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801900:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801904:	0f b6 00             	movzbl (%rax),%eax
  801907:	3c 2f                	cmp    $0x2f,%al
  801909:	7e 1d                	jle    801928 <strtol+0xf0>
  80190b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80190f:	0f b6 00             	movzbl (%rax),%eax
  801912:	3c 39                	cmp    $0x39,%al
  801914:	7f 12                	jg     801928 <strtol+0xf0>
			dig = *s - '0';
  801916:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191a:	0f b6 00             	movzbl (%rax),%eax
  80191d:	0f be c0             	movsbl %al,%eax
  801920:	83 e8 30             	sub    $0x30,%eax
  801923:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801926:	eb 4e                	jmp    801976 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801928:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80192c:	0f b6 00             	movzbl (%rax),%eax
  80192f:	3c 60                	cmp    $0x60,%al
  801931:	7e 1d                	jle    801950 <strtol+0x118>
  801933:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801937:	0f b6 00             	movzbl (%rax),%eax
  80193a:	3c 7a                	cmp    $0x7a,%al
  80193c:	7f 12                	jg     801950 <strtol+0x118>
			dig = *s - 'a' + 10;
  80193e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801942:	0f b6 00             	movzbl (%rax),%eax
  801945:	0f be c0             	movsbl %al,%eax
  801948:	83 e8 57             	sub    $0x57,%eax
  80194b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80194e:	eb 26                	jmp    801976 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801950:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801954:	0f b6 00             	movzbl (%rax),%eax
  801957:	3c 40                	cmp    $0x40,%al
  801959:	7e 48                	jle    8019a3 <strtol+0x16b>
  80195b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80195f:	0f b6 00             	movzbl (%rax),%eax
  801962:	3c 5a                	cmp    $0x5a,%al
  801964:	7f 3d                	jg     8019a3 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801966:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80196a:	0f b6 00             	movzbl (%rax),%eax
  80196d:	0f be c0             	movsbl %al,%eax
  801970:	83 e8 37             	sub    $0x37,%eax
  801973:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801976:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801979:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80197c:	7c 02                	jl     801980 <strtol+0x148>
			break;
  80197e:	eb 23                	jmp    8019a3 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801980:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801985:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801988:	48 98                	cltq   
  80198a:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80198f:	48 89 c2             	mov    %rax,%rdx
  801992:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801995:	48 98                	cltq   
  801997:	48 01 d0             	add    %rdx,%rax
  80199a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80199e:	e9 5d ff ff ff       	jmpq   801900 <strtol+0xc8>

	if (endptr)
  8019a3:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8019a8:	74 0b                	je     8019b5 <strtol+0x17d>
		*endptr = (char *) s;
  8019aa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019ae:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8019b2:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8019b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019b9:	74 09                	je     8019c4 <strtol+0x18c>
  8019bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019bf:	48 f7 d8             	neg    %rax
  8019c2:	eb 04                	jmp    8019c8 <strtol+0x190>
  8019c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019c8:	c9                   	leaveq 
  8019c9:	c3                   	retq   

00000000008019ca <strstr>:

char * strstr(const char *in, const char *str)
{
  8019ca:	55                   	push   %rbp
  8019cb:	48 89 e5             	mov    %rsp,%rbp
  8019ce:	48 83 ec 30          	sub    $0x30,%rsp
  8019d2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019d6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8019da:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019de:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019e2:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019e6:	0f b6 00             	movzbl (%rax),%eax
  8019e9:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8019ec:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8019f0:	75 06                	jne    8019f8 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  8019f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019f6:	eb 6b                	jmp    801a63 <strstr+0x99>

    len = strlen(str);
  8019f8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019fc:	48 89 c7             	mov    %rax,%rdi
  8019ff:	48 b8 a0 12 80 00 00 	movabs $0x8012a0,%rax
  801a06:	00 00 00 
  801a09:	ff d0                	callq  *%rax
  801a0b:	48 98                	cltq   
  801a0d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801a11:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a15:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a19:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801a1d:	0f b6 00             	movzbl (%rax),%eax
  801a20:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801a23:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801a27:	75 07                	jne    801a30 <strstr+0x66>
                return (char *) 0;
  801a29:	b8 00 00 00 00       	mov    $0x0,%eax
  801a2e:	eb 33                	jmp    801a63 <strstr+0x99>
        } while (sc != c);
  801a30:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801a34:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a37:	75 d8                	jne    801a11 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801a39:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a3d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801a41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a45:	48 89 ce             	mov    %rcx,%rsi
  801a48:	48 89 c7             	mov    %rax,%rdi
  801a4b:	48 b8 c1 14 80 00 00 	movabs $0x8014c1,%rax
  801a52:	00 00 00 
  801a55:	ff d0                	callq  *%rax
  801a57:	85 c0                	test   %eax,%eax
  801a59:	75 b6                	jne    801a11 <strstr+0x47>

    return (char *) (in - 1);
  801a5b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a5f:	48 83 e8 01          	sub    $0x1,%rax
}
  801a63:	c9                   	leaveq 
  801a64:	c3                   	retq   
