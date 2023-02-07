
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
  80005e:	48 83 ec 20          	sub    $0x20,%rsp
  800062:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800065:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800069:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  800070:	00 00 00 
  800073:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	envid_t id = sys_getenvid();
  80007a:	48 b8 6f 02 80 00 00 	movabs $0x80026f,%rax
  800081:	00 00 00 
  800084:	ff d0                	callq  *%rax
  800086:	89 45 fc             	mov    %eax,-0x4(%rbp)
        id = ENVX(id);
  800089:	81 65 fc ff 03 00 00 	andl   $0x3ff,-0x4(%rbp)
	thisenv = &envs[id];
  800090:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800093:	48 63 d0             	movslq %eax,%rdx
  800096:	48 89 d0             	mov    %rdx,%rax
  800099:	48 c1 e0 03          	shl    $0x3,%rax
  80009d:	48 01 d0             	add    %rdx,%rax
  8000a0:	48 c1 e0 05          	shl    $0x5,%rax
  8000a4:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000ab:	00 00 00 
  8000ae:	48 01 c2             	add    %rax,%rdx
  8000b1:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000b8:	00 00 00 
  8000bb:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000be:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000c2:	7e 14                	jle    8000d8 <libmain+0x7e>
		binaryname = argv[0];
  8000c4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000c8:	48 8b 10             	mov    (%rax),%rdx
  8000cb:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000d2:	00 00 00 
  8000d5:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000d8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8000dc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000df:	48 89 d6             	mov    %rdx,%rsi
  8000e2:	89 c7                	mov    %eax,%edi
  8000e4:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000eb:	00 00 00 
  8000ee:	ff d0                	callq  *%rax
	
	//cprintf("\noutside\n");
	// exit gracefully
	exit();
  8000f0:	48 b8 fe 00 80 00 00 	movabs $0x8000fe,%rax
  8000f7:	00 00 00 
  8000fa:	ff d0                	callq  *%rax
}
  8000fc:	c9                   	leaveq 
  8000fd:	c3                   	retq   

00000000008000fe <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000fe:	55                   	push   %rbp
  8000ff:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  800102:	bf 00 00 00 00       	mov    $0x0,%edi
  800107:	48 b8 2b 02 80 00 00 	movabs $0x80022b,%rax
  80010e:	00 00 00 
  800111:	ff d0                	callq  *%rax
}
  800113:	5d                   	pop    %rbp
  800114:	c3                   	retq   

0000000000800115 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800115:	55                   	push   %rbp
  800116:	48 89 e5             	mov    %rsp,%rbp
  800119:	53                   	push   %rbx
  80011a:	48 83 ec 48          	sub    $0x48,%rsp
  80011e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800121:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800124:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800128:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80012c:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800130:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800134:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800137:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80013b:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80013f:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800143:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800147:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80014b:	4c 89 c3             	mov    %r8,%rbx
  80014e:	cd 30                	int    $0x30
  800150:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800154:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800158:	74 3e                	je     800198 <syscall+0x83>
  80015a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80015f:	7e 37                	jle    800198 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800161:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800165:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800168:	49 89 d0             	mov    %rdx,%r8
  80016b:	89 c1                	mov    %eax,%ecx
  80016d:	48 ba 6a 1a 80 00 00 	movabs $0x801a6a,%rdx
  800174:	00 00 00 
  800177:	be 23 00 00 00       	mov    $0x23,%esi
  80017c:	48 bf 87 1a 80 00 00 	movabs $0x801a87,%rdi
  800183:	00 00 00 
  800186:	b8 00 00 00 00       	mov    $0x0,%eax
  80018b:	49 b9 0e 05 80 00 00 	movabs $0x80050e,%r9
  800192:	00 00 00 
  800195:	41 ff d1             	callq  *%r9

	return ret;
  800198:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80019c:	48 83 c4 48          	add    $0x48,%rsp
  8001a0:	5b                   	pop    %rbx
  8001a1:	5d                   	pop    %rbp
  8001a2:	c3                   	retq   

00000000008001a3 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001a3:	55                   	push   %rbp
  8001a4:	48 89 e5             	mov    %rsp,%rbp
  8001a7:	48 83 ec 20          	sub    $0x20,%rsp
  8001ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001b7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001bb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001c2:	00 
  8001c3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001c9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001cf:	48 89 d1             	mov    %rdx,%rcx
  8001d2:	48 89 c2             	mov    %rax,%rdx
  8001d5:	be 00 00 00 00       	mov    $0x0,%esi
  8001da:	bf 00 00 00 00       	mov    $0x0,%edi
  8001df:	48 b8 15 01 80 00 00 	movabs $0x800115,%rax
  8001e6:	00 00 00 
  8001e9:	ff d0                	callq  *%rax
}
  8001eb:	c9                   	leaveq 
  8001ec:	c3                   	retq   

00000000008001ed <sys_cgetc>:

int
sys_cgetc(void)
{
  8001ed:	55                   	push   %rbp
  8001ee:	48 89 e5             	mov    %rsp,%rbp
  8001f1:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001f5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001fc:	00 
  8001fd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800203:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800209:	b9 00 00 00 00       	mov    $0x0,%ecx
  80020e:	ba 00 00 00 00       	mov    $0x0,%edx
  800213:	be 00 00 00 00       	mov    $0x0,%esi
  800218:	bf 01 00 00 00       	mov    $0x1,%edi
  80021d:	48 b8 15 01 80 00 00 	movabs $0x800115,%rax
  800224:	00 00 00 
  800227:	ff d0                	callq  *%rax
}
  800229:	c9                   	leaveq 
  80022a:	c3                   	retq   

000000000080022b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80022b:	55                   	push   %rbp
  80022c:	48 89 e5             	mov    %rsp,%rbp
  80022f:	48 83 ec 10          	sub    $0x10,%rsp
  800233:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800236:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800239:	48 98                	cltq   
  80023b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800242:	00 
  800243:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800249:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80024f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800254:	48 89 c2             	mov    %rax,%rdx
  800257:	be 01 00 00 00       	mov    $0x1,%esi
  80025c:	bf 03 00 00 00       	mov    $0x3,%edi
  800261:	48 b8 15 01 80 00 00 	movabs $0x800115,%rax
  800268:	00 00 00 
  80026b:	ff d0                	callq  *%rax
}
  80026d:	c9                   	leaveq 
  80026e:	c3                   	retq   

000000000080026f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80026f:	55                   	push   %rbp
  800270:	48 89 e5             	mov    %rsp,%rbp
  800273:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800277:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80027e:	00 
  80027f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800285:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80028b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800290:	ba 00 00 00 00       	mov    $0x0,%edx
  800295:	be 00 00 00 00       	mov    $0x0,%esi
  80029a:	bf 02 00 00 00       	mov    $0x2,%edi
  80029f:	48 b8 15 01 80 00 00 	movabs $0x800115,%rax
  8002a6:	00 00 00 
  8002a9:	ff d0                	callq  *%rax
}
  8002ab:	c9                   	leaveq 
  8002ac:	c3                   	retq   

00000000008002ad <sys_yield>:

void
sys_yield(void)
{
  8002ad:	55                   	push   %rbp
  8002ae:	48 89 e5             	mov    %rsp,%rbp
  8002b1:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002b5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002bc:	00 
  8002bd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002c3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002c9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8002d3:	be 00 00 00 00       	mov    $0x0,%esi
  8002d8:	bf 0a 00 00 00       	mov    $0xa,%edi
  8002dd:	48 b8 15 01 80 00 00 	movabs $0x800115,%rax
  8002e4:	00 00 00 
  8002e7:	ff d0                	callq  *%rax
}
  8002e9:	c9                   	leaveq 
  8002ea:	c3                   	retq   

00000000008002eb <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002eb:	55                   	push   %rbp
  8002ec:	48 89 e5             	mov    %rsp,%rbp
  8002ef:	48 83 ec 20          	sub    $0x20,%rsp
  8002f3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002f6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8002fa:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8002fd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800300:	48 63 c8             	movslq %eax,%rcx
  800303:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800307:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80030a:	48 98                	cltq   
  80030c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800313:	00 
  800314:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80031a:	49 89 c8             	mov    %rcx,%r8
  80031d:	48 89 d1             	mov    %rdx,%rcx
  800320:	48 89 c2             	mov    %rax,%rdx
  800323:	be 01 00 00 00       	mov    $0x1,%esi
  800328:	bf 04 00 00 00       	mov    $0x4,%edi
  80032d:	48 b8 15 01 80 00 00 	movabs $0x800115,%rax
  800334:	00 00 00 
  800337:	ff d0                	callq  *%rax
}
  800339:	c9                   	leaveq 
  80033a:	c3                   	retq   

000000000080033b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80033b:	55                   	push   %rbp
  80033c:	48 89 e5             	mov    %rsp,%rbp
  80033f:	48 83 ec 30          	sub    $0x30,%rsp
  800343:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800346:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80034a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80034d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800351:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800355:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800358:	48 63 c8             	movslq %eax,%rcx
  80035b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80035f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800362:	48 63 f0             	movslq %eax,%rsi
  800365:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800369:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80036c:	48 98                	cltq   
  80036e:	48 89 0c 24          	mov    %rcx,(%rsp)
  800372:	49 89 f9             	mov    %rdi,%r9
  800375:	49 89 f0             	mov    %rsi,%r8
  800378:	48 89 d1             	mov    %rdx,%rcx
  80037b:	48 89 c2             	mov    %rax,%rdx
  80037e:	be 01 00 00 00       	mov    $0x1,%esi
  800383:	bf 05 00 00 00       	mov    $0x5,%edi
  800388:	48 b8 15 01 80 00 00 	movabs $0x800115,%rax
  80038f:	00 00 00 
  800392:	ff d0                	callq  *%rax
}
  800394:	c9                   	leaveq 
  800395:	c3                   	retq   

0000000000800396 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800396:	55                   	push   %rbp
  800397:	48 89 e5             	mov    %rsp,%rbp
  80039a:	48 83 ec 20          	sub    $0x20,%rsp
  80039e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003a1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003a5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003ac:	48 98                	cltq   
  8003ae:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003b5:	00 
  8003b6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003bc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003c2:	48 89 d1             	mov    %rdx,%rcx
  8003c5:	48 89 c2             	mov    %rax,%rdx
  8003c8:	be 01 00 00 00       	mov    $0x1,%esi
  8003cd:	bf 06 00 00 00       	mov    $0x6,%edi
  8003d2:	48 b8 15 01 80 00 00 	movabs $0x800115,%rax
  8003d9:	00 00 00 
  8003dc:	ff d0                	callq  *%rax
}
  8003de:	c9                   	leaveq 
  8003df:	c3                   	retq   

00000000008003e0 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003e0:	55                   	push   %rbp
  8003e1:	48 89 e5             	mov    %rsp,%rbp
  8003e4:	48 83 ec 10          	sub    $0x10,%rsp
  8003e8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003eb:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8003ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003f1:	48 63 d0             	movslq %eax,%rdx
  8003f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003f7:	48 98                	cltq   
  8003f9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800400:	00 
  800401:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800407:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80040d:	48 89 d1             	mov    %rdx,%rcx
  800410:	48 89 c2             	mov    %rax,%rdx
  800413:	be 01 00 00 00       	mov    $0x1,%esi
  800418:	bf 08 00 00 00       	mov    $0x8,%edi
  80041d:	48 b8 15 01 80 00 00 	movabs $0x800115,%rax
  800424:	00 00 00 
  800427:	ff d0                	callq  *%rax
}
  800429:	c9                   	leaveq 
  80042a:	c3                   	retq   

000000000080042b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80042b:	55                   	push   %rbp
  80042c:	48 89 e5             	mov    %rsp,%rbp
  80042f:	48 83 ec 20          	sub    $0x20,%rsp
  800433:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800436:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80043a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80043e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800441:	48 98                	cltq   
  800443:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80044a:	00 
  80044b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800451:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800457:	48 89 d1             	mov    %rdx,%rcx
  80045a:	48 89 c2             	mov    %rax,%rdx
  80045d:	be 01 00 00 00       	mov    $0x1,%esi
  800462:	bf 09 00 00 00       	mov    $0x9,%edi
  800467:	48 b8 15 01 80 00 00 	movabs $0x800115,%rax
  80046e:	00 00 00 
  800471:	ff d0                	callq  *%rax
}
  800473:	c9                   	leaveq 
  800474:	c3                   	retq   

0000000000800475 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  800475:	55                   	push   %rbp
  800476:	48 89 e5             	mov    %rsp,%rbp
  800479:	48 83 ec 20          	sub    $0x20,%rsp
  80047d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800480:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800484:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800488:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80048b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80048e:	48 63 f0             	movslq %eax,%rsi
  800491:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800495:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800498:	48 98                	cltq   
  80049a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80049e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004a5:	00 
  8004a6:	49 89 f1             	mov    %rsi,%r9
  8004a9:	49 89 c8             	mov    %rcx,%r8
  8004ac:	48 89 d1             	mov    %rdx,%rcx
  8004af:	48 89 c2             	mov    %rax,%rdx
  8004b2:	be 00 00 00 00       	mov    $0x0,%esi
  8004b7:	bf 0b 00 00 00       	mov    $0xb,%edi
  8004bc:	48 b8 15 01 80 00 00 	movabs $0x800115,%rax
  8004c3:	00 00 00 
  8004c6:	ff d0                	callq  *%rax
}
  8004c8:	c9                   	leaveq 
  8004c9:	c3                   	retq   

00000000008004ca <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8004ca:	55                   	push   %rbp
  8004cb:	48 89 e5             	mov    %rsp,%rbp
  8004ce:	48 83 ec 10          	sub    $0x10,%rsp
  8004d2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8004d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004da:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004e1:	00 
  8004e2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004e8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004ee:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004f3:	48 89 c2             	mov    %rax,%rdx
  8004f6:	be 01 00 00 00       	mov    $0x1,%esi
  8004fb:	bf 0c 00 00 00       	mov    $0xc,%edi
  800500:	48 b8 15 01 80 00 00 	movabs $0x800115,%rax
  800507:	00 00 00 
  80050a:	ff d0                	callq  *%rax
}
  80050c:	c9                   	leaveq 
  80050d:	c3                   	retq   

000000000080050e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80050e:	55                   	push   %rbp
  80050f:	48 89 e5             	mov    %rsp,%rbp
  800512:	53                   	push   %rbx
  800513:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80051a:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800521:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800527:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80052e:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800535:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80053c:	84 c0                	test   %al,%al
  80053e:	74 23                	je     800563 <_panic+0x55>
  800540:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800547:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80054b:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80054f:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800553:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800557:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80055b:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80055f:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800563:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80056a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800571:	00 00 00 
  800574:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80057b:	00 00 00 
  80057e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800582:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800589:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800590:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800597:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  80059e:	00 00 00 
  8005a1:	48 8b 18             	mov    (%rax),%rbx
  8005a4:	48 b8 6f 02 80 00 00 	movabs $0x80026f,%rax
  8005ab:	00 00 00 
  8005ae:	ff d0                	callq  *%rax
  8005b0:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8005b6:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8005bd:	41 89 c8             	mov    %ecx,%r8d
  8005c0:	48 89 d1             	mov    %rdx,%rcx
  8005c3:	48 89 da             	mov    %rbx,%rdx
  8005c6:	89 c6                	mov    %eax,%esi
  8005c8:	48 bf 98 1a 80 00 00 	movabs $0x801a98,%rdi
  8005cf:	00 00 00 
  8005d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8005d7:	49 b9 47 07 80 00 00 	movabs $0x800747,%r9
  8005de:	00 00 00 
  8005e1:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005e4:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8005eb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005f2:	48 89 d6             	mov    %rdx,%rsi
  8005f5:	48 89 c7             	mov    %rax,%rdi
  8005f8:	48 b8 9b 06 80 00 00 	movabs $0x80069b,%rax
  8005ff:	00 00 00 
  800602:	ff d0                	callq  *%rax
	cprintf("\n");
  800604:	48 bf bb 1a 80 00 00 	movabs $0x801abb,%rdi
  80060b:	00 00 00 
  80060e:	b8 00 00 00 00       	mov    $0x0,%eax
  800613:	48 ba 47 07 80 00 00 	movabs $0x800747,%rdx
  80061a:	00 00 00 
  80061d:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80061f:	cc                   	int3   
  800620:	eb fd                	jmp    80061f <_panic+0x111>

0000000000800622 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800622:	55                   	push   %rbp
  800623:	48 89 e5             	mov    %rsp,%rbp
  800626:	48 83 ec 10          	sub    $0x10,%rsp
  80062a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80062d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800631:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800635:	8b 00                	mov    (%rax),%eax
  800637:	8d 48 01             	lea    0x1(%rax),%ecx
  80063a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80063e:	89 0a                	mov    %ecx,(%rdx)
  800640:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800643:	89 d1                	mov    %edx,%ecx
  800645:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800649:	48 98                	cltq   
  80064b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  80064f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800653:	8b 00                	mov    (%rax),%eax
  800655:	3d ff 00 00 00       	cmp    $0xff,%eax
  80065a:	75 2c                	jne    800688 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  80065c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800660:	8b 00                	mov    (%rax),%eax
  800662:	48 98                	cltq   
  800664:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800668:	48 83 c2 08          	add    $0x8,%rdx
  80066c:	48 89 c6             	mov    %rax,%rsi
  80066f:	48 89 d7             	mov    %rdx,%rdi
  800672:	48 b8 a3 01 80 00 00 	movabs $0x8001a3,%rax
  800679:	00 00 00 
  80067c:	ff d0                	callq  *%rax
		b->idx = 0;
  80067e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800682:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800688:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80068c:	8b 40 04             	mov    0x4(%rax),%eax
  80068f:	8d 50 01             	lea    0x1(%rax),%edx
  800692:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800696:	89 50 04             	mov    %edx,0x4(%rax)
}
  800699:	c9                   	leaveq 
  80069a:	c3                   	retq   

000000000080069b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80069b:	55                   	push   %rbp
  80069c:	48 89 e5             	mov    %rsp,%rbp
  80069f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8006a6:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8006ad:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8006b4:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006bb:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006c2:	48 8b 0a             	mov    (%rdx),%rcx
  8006c5:	48 89 08             	mov    %rcx,(%rax)
  8006c8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006cc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006d0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006d4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8006d8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8006df:	00 00 00 
	b.cnt = 0;
  8006e2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8006e9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8006ec:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8006f3:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8006fa:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800701:	48 89 c6             	mov    %rax,%rsi
  800704:	48 bf 22 06 80 00 00 	movabs $0x800622,%rdi
  80070b:	00 00 00 
  80070e:	48 b8 fa 0a 80 00 00 	movabs $0x800afa,%rax
  800715:	00 00 00 
  800718:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  80071a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800720:	48 98                	cltq   
  800722:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800729:	48 83 c2 08          	add    $0x8,%rdx
  80072d:	48 89 c6             	mov    %rax,%rsi
  800730:	48 89 d7             	mov    %rdx,%rdi
  800733:	48 b8 a3 01 80 00 00 	movabs $0x8001a3,%rax
  80073a:	00 00 00 
  80073d:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80073f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800745:	c9                   	leaveq 
  800746:	c3                   	retq   

0000000000800747 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800747:	55                   	push   %rbp
  800748:	48 89 e5             	mov    %rsp,%rbp
  80074b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800752:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800759:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800760:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800767:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80076e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800775:	84 c0                	test   %al,%al
  800777:	74 20                	je     800799 <cprintf+0x52>
  800779:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80077d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800781:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800785:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800789:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80078d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800791:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800795:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800799:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8007a0:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8007a7:	00 00 00 
  8007aa:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8007b1:	00 00 00 
  8007b4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007b8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007bf:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007c6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8007cd:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007d4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007db:	48 8b 0a             	mov    (%rdx),%rcx
  8007de:	48 89 08             	mov    %rcx,(%rax)
  8007e1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007e5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007e9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007ed:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8007f1:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8007f8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8007ff:	48 89 d6             	mov    %rdx,%rsi
  800802:	48 89 c7             	mov    %rax,%rdi
  800805:	48 b8 9b 06 80 00 00 	movabs $0x80069b,%rax
  80080c:	00 00 00 
  80080f:	ff d0                	callq  *%rax
  800811:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800817:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80081d:	c9                   	leaveq 
  80081e:	c3                   	retq   

000000000080081f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80081f:	55                   	push   %rbp
  800820:	48 89 e5             	mov    %rsp,%rbp
  800823:	53                   	push   %rbx
  800824:	48 83 ec 38          	sub    $0x38,%rsp
  800828:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80082c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800830:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800834:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800837:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80083b:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80083f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800842:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800846:	77 3b                	ja     800883 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800848:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80084b:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80084f:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800852:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800856:	ba 00 00 00 00       	mov    $0x0,%edx
  80085b:	48 f7 f3             	div    %rbx
  80085e:	48 89 c2             	mov    %rax,%rdx
  800861:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800864:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800867:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80086b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086f:	41 89 f9             	mov    %edi,%r9d
  800872:	48 89 c7             	mov    %rax,%rdi
  800875:	48 b8 1f 08 80 00 00 	movabs $0x80081f,%rax
  80087c:	00 00 00 
  80087f:	ff d0                	callq  *%rax
  800881:	eb 1e                	jmp    8008a1 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800883:	eb 12                	jmp    800897 <printnum+0x78>
			putch(padc, putdat);
  800885:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800889:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80088c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800890:	48 89 ce             	mov    %rcx,%rsi
  800893:	89 d7                	mov    %edx,%edi
  800895:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800897:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80089b:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80089f:	7f e4                	jg     800885 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008a1:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8008a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ad:	48 f7 f1             	div    %rcx
  8008b0:	48 89 d0             	mov    %rdx,%rax
  8008b3:	48 ba b0 1b 80 00 00 	movabs $0x801bb0,%rdx
  8008ba:	00 00 00 
  8008bd:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8008c1:	0f be d0             	movsbl %al,%edx
  8008c4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8008c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008cc:	48 89 ce             	mov    %rcx,%rsi
  8008cf:	89 d7                	mov    %edx,%edi
  8008d1:	ff d0                	callq  *%rax
}
  8008d3:	48 83 c4 38          	add    $0x38,%rsp
  8008d7:	5b                   	pop    %rbx
  8008d8:	5d                   	pop    %rbp
  8008d9:	c3                   	retq   

00000000008008da <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008da:	55                   	push   %rbp
  8008db:	48 89 e5             	mov    %rsp,%rbp
  8008de:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008e2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008e6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8008e9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008ed:	7e 52                	jle    800941 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8008ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f3:	8b 00                	mov    (%rax),%eax
  8008f5:	83 f8 30             	cmp    $0x30,%eax
  8008f8:	73 24                	jae    80091e <getuint+0x44>
  8008fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008fe:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800902:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800906:	8b 00                	mov    (%rax),%eax
  800908:	89 c0                	mov    %eax,%eax
  80090a:	48 01 d0             	add    %rdx,%rax
  80090d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800911:	8b 12                	mov    (%rdx),%edx
  800913:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800916:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80091a:	89 0a                	mov    %ecx,(%rdx)
  80091c:	eb 17                	jmp    800935 <getuint+0x5b>
  80091e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800922:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800926:	48 89 d0             	mov    %rdx,%rax
  800929:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80092d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800931:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800935:	48 8b 00             	mov    (%rax),%rax
  800938:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80093c:	e9 a3 00 00 00       	jmpq   8009e4 <getuint+0x10a>
	else if (lflag)
  800941:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800945:	74 4f                	je     800996 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800947:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80094b:	8b 00                	mov    (%rax),%eax
  80094d:	83 f8 30             	cmp    $0x30,%eax
  800950:	73 24                	jae    800976 <getuint+0x9c>
  800952:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800956:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80095a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095e:	8b 00                	mov    (%rax),%eax
  800960:	89 c0                	mov    %eax,%eax
  800962:	48 01 d0             	add    %rdx,%rax
  800965:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800969:	8b 12                	mov    (%rdx),%edx
  80096b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80096e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800972:	89 0a                	mov    %ecx,(%rdx)
  800974:	eb 17                	jmp    80098d <getuint+0xb3>
  800976:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80097a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80097e:	48 89 d0             	mov    %rdx,%rax
  800981:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800985:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800989:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80098d:	48 8b 00             	mov    (%rax),%rax
  800990:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800994:	eb 4e                	jmp    8009e4 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800996:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80099a:	8b 00                	mov    (%rax),%eax
  80099c:	83 f8 30             	cmp    $0x30,%eax
  80099f:	73 24                	jae    8009c5 <getuint+0xeb>
  8009a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ad:	8b 00                	mov    (%rax),%eax
  8009af:	89 c0                	mov    %eax,%eax
  8009b1:	48 01 d0             	add    %rdx,%rax
  8009b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b8:	8b 12                	mov    (%rdx),%edx
  8009ba:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c1:	89 0a                	mov    %ecx,(%rdx)
  8009c3:	eb 17                	jmp    8009dc <getuint+0x102>
  8009c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009cd:	48 89 d0             	mov    %rdx,%rax
  8009d0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009dc:	8b 00                	mov    (%rax),%eax
  8009de:	89 c0                	mov    %eax,%eax
  8009e0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009e8:	c9                   	leaveq 
  8009e9:	c3                   	retq   

00000000008009ea <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009ea:	55                   	push   %rbp
  8009eb:	48 89 e5             	mov    %rsp,%rbp
  8009ee:	48 83 ec 1c          	sub    $0x1c,%rsp
  8009f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009f6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8009f9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009fd:	7e 52                	jle    800a51 <getint+0x67>
		x=va_arg(*ap, long long);
  8009ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a03:	8b 00                	mov    (%rax),%eax
  800a05:	83 f8 30             	cmp    $0x30,%eax
  800a08:	73 24                	jae    800a2e <getint+0x44>
  800a0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a0e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a16:	8b 00                	mov    (%rax),%eax
  800a18:	89 c0                	mov    %eax,%eax
  800a1a:	48 01 d0             	add    %rdx,%rax
  800a1d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a21:	8b 12                	mov    (%rdx),%edx
  800a23:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a26:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a2a:	89 0a                	mov    %ecx,(%rdx)
  800a2c:	eb 17                	jmp    800a45 <getint+0x5b>
  800a2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a32:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a36:	48 89 d0             	mov    %rdx,%rax
  800a39:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a3d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a41:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a45:	48 8b 00             	mov    (%rax),%rax
  800a48:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a4c:	e9 a3 00 00 00       	jmpq   800af4 <getint+0x10a>
	else if (lflag)
  800a51:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a55:	74 4f                	je     800aa6 <getint+0xbc>
		x=va_arg(*ap, long);
  800a57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a5b:	8b 00                	mov    (%rax),%eax
  800a5d:	83 f8 30             	cmp    $0x30,%eax
  800a60:	73 24                	jae    800a86 <getint+0x9c>
  800a62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a66:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a6e:	8b 00                	mov    (%rax),%eax
  800a70:	89 c0                	mov    %eax,%eax
  800a72:	48 01 d0             	add    %rdx,%rax
  800a75:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a79:	8b 12                	mov    (%rdx),%edx
  800a7b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a7e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a82:	89 0a                	mov    %ecx,(%rdx)
  800a84:	eb 17                	jmp    800a9d <getint+0xb3>
  800a86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a8e:	48 89 d0             	mov    %rdx,%rax
  800a91:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a95:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a99:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a9d:	48 8b 00             	mov    (%rax),%rax
  800aa0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800aa4:	eb 4e                	jmp    800af4 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800aa6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aaa:	8b 00                	mov    (%rax),%eax
  800aac:	83 f8 30             	cmp    $0x30,%eax
  800aaf:	73 24                	jae    800ad5 <getint+0xeb>
  800ab1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ab9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800abd:	8b 00                	mov    (%rax),%eax
  800abf:	89 c0                	mov    %eax,%eax
  800ac1:	48 01 d0             	add    %rdx,%rax
  800ac4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ac8:	8b 12                	mov    (%rdx),%edx
  800aca:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800acd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad1:	89 0a                	mov    %ecx,(%rdx)
  800ad3:	eb 17                	jmp    800aec <getint+0x102>
  800ad5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800add:	48 89 d0             	mov    %rdx,%rax
  800ae0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ae4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ae8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800aec:	8b 00                	mov    (%rax),%eax
  800aee:	48 98                	cltq   
  800af0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800af4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800af8:	c9                   	leaveq 
  800af9:	c3                   	retq   

0000000000800afa <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800afa:	55                   	push   %rbp
  800afb:	48 89 e5             	mov    %rsp,%rbp
  800afe:	41 54                	push   %r12
  800b00:	53                   	push   %rbx
  800b01:	48 83 ec 60          	sub    $0x60,%rsp
  800b05:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800b09:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800b0d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b11:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800b15:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b19:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b1d:	48 8b 0a             	mov    (%rdx),%rcx
  800b20:	48 89 08             	mov    %rcx,(%rax)
  800b23:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b27:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b2b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b2f:	48 89 50 10          	mov    %rdx,0x10(%rax)
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b33:	eb 17                	jmp    800b4c <vprintfmt+0x52>
			if (ch == '\0')
  800b35:	85 db                	test   %ebx,%ebx
  800b37:	0f 84 cc 04 00 00    	je     801009 <vprintfmt+0x50f>
                }
#endif

			  return;
			}
			putch(ch, putdat);
  800b3d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b41:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b45:	48 89 d6             	mov    %rdx,%rsi
  800b48:	89 df                	mov    %ebx,%edi
  800b4a:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b4c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b50:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b54:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b58:	0f b6 00             	movzbl (%rax),%eax
  800b5b:	0f b6 d8             	movzbl %al,%ebx
  800b5e:	83 fb 25             	cmp    $0x25,%ebx
  800b61:	75 d2                	jne    800b35 <vprintfmt+0x3b>
			  return;
			}
			putch(ch, putdat);
		}
		// Process a %-escape sequence
		padc = ' ';
  800b63:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b67:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b6e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b75:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b7c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b83:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b87:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b8b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b8f:	0f b6 00             	movzbl (%rax),%eax
  800b92:	0f b6 d8             	movzbl %al,%ebx
  800b95:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800b98:	83 f8 55             	cmp    $0x55,%eax
  800b9b:	0f 87 34 04 00 00    	ja     800fd5 <vprintfmt+0x4db>
  800ba1:	89 c0                	mov    %eax,%eax
  800ba3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800baa:	00 
  800bab:	48 b8 d8 1b 80 00 00 	movabs $0x801bd8,%rax
  800bb2:	00 00 00 
  800bb5:	48 01 d0             	add    %rdx,%rax
  800bb8:	48 8b 00             	mov    (%rax),%rax
  800bbb:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bbd:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800bc1:	eb c0                	jmp    800b83 <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bc3:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800bc7:	eb ba                	jmp    800b83 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bc9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800bd0:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800bd3:	89 d0                	mov    %edx,%eax
  800bd5:	c1 e0 02             	shl    $0x2,%eax
  800bd8:	01 d0                	add    %edx,%eax
  800bda:	01 c0                	add    %eax,%eax
  800bdc:	01 d8                	add    %ebx,%eax
  800bde:	83 e8 30             	sub    $0x30,%eax
  800be1:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800be4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800be8:	0f b6 00             	movzbl (%rax),%eax
  800beb:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bee:	83 fb 2f             	cmp    $0x2f,%ebx
  800bf1:	7e 0c                	jle    800bff <vprintfmt+0x105>
  800bf3:	83 fb 39             	cmp    $0x39,%ebx
  800bf6:	7f 07                	jg     800bff <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bf8:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bfd:	eb d1                	jmp    800bd0 <vprintfmt+0xd6>
			goto process_precision;
  800bff:	eb 58                	jmp    800c59 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800c01:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c04:	83 f8 30             	cmp    $0x30,%eax
  800c07:	73 17                	jae    800c20 <vprintfmt+0x126>
  800c09:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c0d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c10:	89 c0                	mov    %eax,%eax
  800c12:	48 01 d0             	add    %rdx,%rax
  800c15:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c18:	83 c2 08             	add    $0x8,%edx
  800c1b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c1e:	eb 0f                	jmp    800c2f <vprintfmt+0x135>
  800c20:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c24:	48 89 d0             	mov    %rdx,%rax
  800c27:	48 83 c2 08          	add    $0x8,%rdx
  800c2b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c2f:	8b 00                	mov    (%rax),%eax
  800c31:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c34:	eb 23                	jmp    800c59 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800c36:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c3a:	79 0c                	jns    800c48 <vprintfmt+0x14e>
				width = 0;
  800c3c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c43:	e9 3b ff ff ff       	jmpq   800b83 <vprintfmt+0x89>
  800c48:	e9 36 ff ff ff       	jmpq   800b83 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c4d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c54:	e9 2a ff ff ff       	jmpq   800b83 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800c59:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c5d:	79 12                	jns    800c71 <vprintfmt+0x177>
				width = precision, precision = -1;
  800c5f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c62:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c65:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c6c:	e9 12 ff ff ff       	jmpq   800b83 <vprintfmt+0x89>
  800c71:	e9 0d ff ff ff       	jmpq   800b83 <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c76:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c7a:	e9 04 ff ff ff       	jmpq   800b83 <vprintfmt+0x89>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			putch(va_arg(aq, int), putdat);
  800c7f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c82:	83 f8 30             	cmp    $0x30,%eax
  800c85:	73 17                	jae    800c9e <vprintfmt+0x1a4>
  800c87:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c8b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c8e:	89 c0                	mov    %eax,%eax
  800c90:	48 01 d0             	add    %rdx,%rax
  800c93:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c96:	83 c2 08             	add    $0x8,%edx
  800c99:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c9c:	eb 0f                	jmp    800cad <vprintfmt+0x1b3>
  800c9e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ca2:	48 89 d0             	mov    %rdx,%rax
  800ca5:	48 83 c2 08          	add    $0x8,%rdx
  800ca9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cad:	8b 10                	mov    (%rax),%edx
  800caf:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cb3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cb7:	48 89 ce             	mov    %rcx,%rsi
  800cba:	89 d7                	mov    %edx,%edi
  800cbc:	ff d0                	callq  *%rax
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  800cbe:	e9 40 03 00 00       	jmpq   801003 <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800cc3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cc6:	83 f8 30             	cmp    $0x30,%eax
  800cc9:	73 17                	jae    800ce2 <vprintfmt+0x1e8>
  800ccb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ccf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cd2:	89 c0                	mov    %eax,%eax
  800cd4:	48 01 d0             	add    %rdx,%rax
  800cd7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cda:	83 c2 08             	add    $0x8,%edx
  800cdd:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ce0:	eb 0f                	jmp    800cf1 <vprintfmt+0x1f7>
  800ce2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ce6:	48 89 d0             	mov    %rdx,%rax
  800ce9:	48 83 c2 08          	add    $0x8,%rdx
  800ced:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cf1:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800cf3:	85 db                	test   %ebx,%ebx
  800cf5:	79 02                	jns    800cf9 <vprintfmt+0x1ff>
				err = -err;
  800cf7:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800cf9:	83 fb 09             	cmp    $0x9,%ebx
  800cfc:	7f 16                	jg     800d14 <vprintfmt+0x21a>
  800cfe:	48 b8 60 1b 80 00 00 	movabs $0x801b60,%rax
  800d05:	00 00 00 
  800d08:	48 63 d3             	movslq %ebx,%rdx
  800d0b:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800d0f:	4d 85 e4             	test   %r12,%r12
  800d12:	75 2e                	jne    800d42 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800d14:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d18:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d1c:	89 d9                	mov    %ebx,%ecx
  800d1e:	48 ba c1 1b 80 00 00 	movabs $0x801bc1,%rdx
  800d25:	00 00 00 
  800d28:	48 89 c7             	mov    %rax,%rdi
  800d2b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d30:	49 b8 12 10 80 00 00 	movabs $0x801012,%r8
  800d37:	00 00 00 
  800d3a:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d3d:	e9 c1 02 00 00       	jmpq   801003 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d42:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d46:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d4a:	4c 89 e1             	mov    %r12,%rcx
  800d4d:	48 ba ca 1b 80 00 00 	movabs $0x801bca,%rdx
  800d54:	00 00 00 
  800d57:	48 89 c7             	mov    %rax,%rdi
  800d5a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d5f:	49 b8 12 10 80 00 00 	movabs $0x801012,%r8
  800d66:	00 00 00 
  800d69:	41 ff d0             	callq  *%r8
			break;
  800d6c:	e9 92 02 00 00       	jmpq   801003 <vprintfmt+0x509>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
  800d71:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d74:	83 f8 30             	cmp    $0x30,%eax
  800d77:	73 17                	jae    800d90 <vprintfmt+0x296>
  800d79:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d7d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d80:	89 c0                	mov    %eax,%eax
  800d82:	48 01 d0             	add    %rdx,%rax
  800d85:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d88:	83 c2 08             	add    $0x8,%edx
  800d8b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d8e:	eb 0f                	jmp    800d9f <vprintfmt+0x2a5>
  800d90:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d94:	48 89 d0             	mov    %rdx,%rax
  800d97:	48 83 c2 08          	add    $0x8,%rdx
  800d9b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d9f:	4c 8b 20             	mov    (%rax),%r12
  800da2:	4d 85 e4             	test   %r12,%r12
  800da5:	75 0a                	jne    800db1 <vprintfmt+0x2b7>
				p = "(null)";
  800da7:	49 bc cd 1b 80 00 00 	movabs $0x801bcd,%r12
  800dae:	00 00 00 
			if (width > 0 && padc != '-')
  800db1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800db5:	7e 3f                	jle    800df6 <vprintfmt+0x2fc>
  800db7:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800dbb:	74 39                	je     800df6 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dbd:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800dc0:	48 98                	cltq   
  800dc2:	48 89 c6             	mov    %rax,%rsi
  800dc5:	4c 89 e7             	mov    %r12,%rdi
  800dc8:	48 b8 be 12 80 00 00 	movabs $0x8012be,%rax
  800dcf:	00 00 00 
  800dd2:	ff d0                	callq  *%rax
  800dd4:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800dd7:	eb 17                	jmp    800df0 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800dd9:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800ddd:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800de1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de5:	48 89 ce             	mov    %rcx,%rsi
  800de8:	89 d7                	mov    %edx,%edi
  800dea:	ff d0                	callq  *%rax
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dec:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800df0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800df4:	7f e3                	jg     800dd9 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800df6:	eb 37                	jmp    800e2f <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800df8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800dfc:	74 1e                	je     800e1c <vprintfmt+0x322>
  800dfe:	83 fb 1f             	cmp    $0x1f,%ebx
  800e01:	7e 05                	jle    800e08 <vprintfmt+0x30e>
  800e03:	83 fb 7e             	cmp    $0x7e,%ebx
  800e06:	7e 14                	jle    800e1c <vprintfmt+0x322>
					putch('?', putdat);
  800e08:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e0c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e10:	48 89 d6             	mov    %rdx,%rsi
  800e13:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e18:	ff d0                	callq  *%rax
  800e1a:	eb 0f                	jmp    800e2b <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800e1c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e20:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e24:	48 89 d6             	mov    %rdx,%rsi
  800e27:	89 df                	mov    %ebx,%edi
  800e29:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e2b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e2f:	4c 89 e0             	mov    %r12,%rax
  800e32:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e36:	0f b6 00             	movzbl (%rax),%eax
  800e39:	0f be d8             	movsbl %al,%ebx
  800e3c:	85 db                	test   %ebx,%ebx
  800e3e:	74 10                	je     800e50 <vprintfmt+0x356>
  800e40:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e44:	78 b2                	js     800df8 <vprintfmt+0x2fe>
  800e46:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e4a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e4e:	79 a8                	jns    800df8 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e50:	eb 16                	jmp    800e68 <vprintfmt+0x36e>
				putch(' ', putdat);
  800e52:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e56:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e5a:	48 89 d6             	mov    %rdx,%rsi
  800e5d:	bf 20 00 00 00       	mov    $0x20,%edi
  800e62:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e64:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e68:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e6c:	7f e4                	jg     800e52 <vprintfmt+0x358>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  800e6e:	e9 90 01 00 00       	jmpq   801003 <vprintfmt+0x509>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getint(&aq, 3);
  800e73:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e77:	be 03 00 00 00       	mov    $0x3,%esi
  800e7c:	48 89 c7             	mov    %rax,%rdi
  800e7f:	48 b8 ea 09 80 00 00 	movabs $0x8009ea,%rax
  800e86:	00 00 00 
  800e89:	ff d0                	callq  *%rax
  800e8b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e93:	48 85 c0             	test   %rax,%rax
  800e96:	79 1d                	jns    800eb5 <vprintfmt+0x3bb>
				putch('-', putdat);
  800e98:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e9c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ea0:	48 89 d6             	mov    %rdx,%rsi
  800ea3:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ea8:	ff d0                	callq  *%rax
				num = -(long long) num;
  800eaa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eae:	48 f7 d8             	neg    %rax
  800eb1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800eb5:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ebc:	e9 d5 00 00 00       	jmpq   800f96 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			
			num = getuint(&aq, 3);
  800ec1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ec5:	be 03 00 00 00       	mov    $0x3,%esi
  800eca:	48 89 c7             	mov    %rax,%rdi
  800ecd:	48 b8 da 08 80 00 00 	movabs $0x8008da,%rax
  800ed4:	00 00 00 
  800ed7:	ff d0                	callq  *%rax
  800ed9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800edd:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ee4:	e9 ad 00 00 00       	jmpq   800f96 <vprintfmt+0x49c>
                  ch = *(unsigned char *) color;
                }
#endif

			// Replace this with your code.
		        num = getuint(&aq, 3);
  800ee9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800eed:	be 03 00 00 00       	mov    $0x3,%esi
  800ef2:	48 89 c7             	mov    %rax,%rdi
  800ef5:	48 b8 da 08 80 00 00 	movabs $0x8008da,%rax
  800efc:	00 00 00 
  800eff:	ff d0                	callq  *%rax
  800f01:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800f05:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800f0c:	e9 85 00 00 00       	jmpq   800f96 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			putch('0', putdat);
  800f11:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f15:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f19:	48 89 d6             	mov    %rdx,%rsi
  800f1c:	bf 30 00 00 00       	mov    $0x30,%edi
  800f21:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f23:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f27:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f2b:	48 89 d6             	mov    %rdx,%rsi
  800f2e:	bf 78 00 00 00       	mov    $0x78,%edi
  800f33:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f35:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f38:	83 f8 30             	cmp    $0x30,%eax
  800f3b:	73 17                	jae    800f54 <vprintfmt+0x45a>
  800f3d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f41:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f44:	89 c0                	mov    %eax,%eax
  800f46:	48 01 d0             	add    %rdx,%rax
  800f49:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f4c:	83 c2 08             	add    $0x8,%edx
  800f4f:	89 55 b8             	mov    %edx,-0x48(%rbp)
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f52:	eb 0f                	jmp    800f63 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800f54:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f58:	48 89 d0             	mov    %rdx,%rax
  800f5b:	48 83 c2 08          	add    $0x8,%rdx
  800f5f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f63:	48 8b 00             	mov    (%rax),%rax
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f66:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f6a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f71:	eb 23                	jmp    800f96 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getuint(&aq, 3);
  800f73:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f77:	be 03 00 00 00       	mov    $0x3,%esi
  800f7c:	48 89 c7             	mov    %rax,%rdi
  800f7f:	48 b8 da 08 80 00 00 	movabs $0x8008da,%rax
  800f86:	00 00 00 
  800f89:	ff d0                	callq  *%rax
  800f8b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f8f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:

			printnum(putch, putdat, num, base, width, padc);
  800f96:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800f9b:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800f9e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800fa1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fa5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800fa9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fad:	45 89 c1             	mov    %r8d,%r9d
  800fb0:	41 89 f8             	mov    %edi,%r8d
  800fb3:	48 89 c7             	mov    %rax,%rdi
  800fb6:	48 b8 1f 08 80 00 00 	movabs $0x80081f,%rax
  800fbd:	00 00 00 
  800fc0:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			break;
  800fc2:	eb 3f                	jmp    801003 <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fc4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fc8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fcc:	48 89 d6             	mov    %rdx,%rsi
  800fcf:	89 df                	mov    %ebx,%edi
  800fd1:	ff d0                	callq  *%rax
			break;
  800fd3:	eb 2e                	jmp    801003 <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fd5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fd9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fdd:	48 89 d6             	mov    %rdx,%rsi
  800fe0:	bf 25 00 00 00       	mov    $0x25,%edi
  800fe5:	ff d0                	callq  *%rax

			for (fmt--; fmt[-1] != '%'; fmt--)
  800fe7:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fec:	eb 05                	jmp    800ff3 <vprintfmt+0x4f9>
  800fee:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ff3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ff7:	48 83 e8 01          	sub    $0x1,%rax
  800ffb:	0f b6 00             	movzbl (%rax),%eax
  800ffe:	3c 25                	cmp    $0x25,%al
  801000:	75 ec                	jne    800fee <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  801002:	90                   	nop
		}
	}
  801003:	90                   	nop
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801004:	e9 43 fb ff ff       	jmpq   800b4c <vprintfmt+0x52>
			break;
		}
	}
    
va_end(aq);
}
  801009:	48 83 c4 60          	add    $0x60,%rsp
  80100d:	5b                   	pop    %rbx
  80100e:	41 5c                	pop    %r12
  801010:	5d                   	pop    %rbp
  801011:	c3                   	retq   

0000000000801012 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801012:	55                   	push   %rbp
  801013:	48 89 e5             	mov    %rsp,%rbp
  801016:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80101d:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801024:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80102b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801032:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801039:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801040:	84 c0                	test   %al,%al
  801042:	74 20                	je     801064 <printfmt+0x52>
  801044:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801048:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80104c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801050:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801054:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801058:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80105c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801060:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801064:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80106b:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801072:	00 00 00 
  801075:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80107c:	00 00 00 
  80107f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801083:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80108a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801091:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801098:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80109f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8010a6:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8010ad:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8010b4:	48 89 c7             	mov    %rax,%rdi
  8010b7:	48 b8 fa 0a 80 00 00 	movabs $0x800afa,%rax
  8010be:	00 00 00 
  8010c1:	ff d0                	callq  *%rax
	va_end(ap);
}
  8010c3:	c9                   	leaveq 
  8010c4:	c3                   	retq   

00000000008010c5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010c5:	55                   	push   %rbp
  8010c6:	48 89 e5             	mov    %rsp,%rbp
  8010c9:	48 83 ec 10          	sub    $0x10,%rsp
  8010cd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010d0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010d8:	8b 40 10             	mov    0x10(%rax),%eax
  8010db:	8d 50 01             	lea    0x1(%rax),%edx
  8010de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e2:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8010e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e9:	48 8b 10             	mov    (%rax),%rdx
  8010ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010f0:	48 8b 40 08          	mov    0x8(%rax),%rax
  8010f4:	48 39 c2             	cmp    %rax,%rdx
  8010f7:	73 17                	jae    801110 <sprintputch+0x4b>
		*b->buf++ = ch;
  8010f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010fd:	48 8b 00             	mov    (%rax),%rax
  801100:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801104:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801108:	48 89 0a             	mov    %rcx,(%rdx)
  80110b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80110e:	88 10                	mov    %dl,(%rax)
}
  801110:	c9                   	leaveq 
  801111:	c3                   	retq   

0000000000801112 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801112:	55                   	push   %rbp
  801113:	48 89 e5             	mov    %rsp,%rbp
  801116:	48 83 ec 50          	sub    $0x50,%rsp
  80111a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80111e:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801121:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801125:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801129:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80112d:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801131:	48 8b 0a             	mov    (%rdx),%rcx
  801134:	48 89 08             	mov    %rcx,(%rax)
  801137:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80113b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80113f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801143:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801147:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80114b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80114f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801152:	48 98                	cltq   
  801154:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801158:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80115c:	48 01 d0             	add    %rdx,%rax
  80115f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801163:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80116a:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80116f:	74 06                	je     801177 <vsnprintf+0x65>
  801171:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801175:	7f 07                	jg     80117e <vsnprintf+0x6c>
		return -E_INVAL;
  801177:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80117c:	eb 2f                	jmp    8011ad <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80117e:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801182:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801186:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80118a:	48 89 c6             	mov    %rax,%rsi
  80118d:	48 bf c5 10 80 00 00 	movabs $0x8010c5,%rdi
  801194:	00 00 00 
  801197:	48 b8 fa 0a 80 00 00 	movabs $0x800afa,%rax
  80119e:	00 00 00 
  8011a1:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8011a3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8011a7:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8011aa:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8011ad:	c9                   	leaveq 
  8011ae:	c3                   	retq   

00000000008011af <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011af:	55                   	push   %rbp
  8011b0:	48 89 e5             	mov    %rsp,%rbp
  8011b3:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8011ba:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8011c1:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8011c7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011ce:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011d5:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011dc:	84 c0                	test   %al,%al
  8011de:	74 20                	je     801200 <snprintf+0x51>
  8011e0:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011e4:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011e8:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8011ec:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8011f0:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8011f4:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8011f8:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8011fc:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801200:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801207:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80120e:	00 00 00 
  801211:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801218:	00 00 00 
  80121b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80121f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801226:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80122d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801234:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80123b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801242:	48 8b 0a             	mov    (%rdx),%rcx
  801245:	48 89 08             	mov    %rcx,(%rax)
  801248:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80124c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801250:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801254:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801258:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80125f:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801266:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80126c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801273:	48 89 c7             	mov    %rax,%rdi
  801276:	48 b8 12 11 80 00 00 	movabs $0x801112,%rax
  80127d:	00 00 00 
  801280:	ff d0                	callq  *%rax
  801282:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801288:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80128e:	c9                   	leaveq 
  80128f:	c3                   	retq   

0000000000801290 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801290:	55                   	push   %rbp
  801291:	48 89 e5             	mov    %rsp,%rbp
  801294:	48 83 ec 18          	sub    $0x18,%rsp
  801298:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80129c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012a3:	eb 09                	jmp    8012ae <strlen+0x1e>
		n++;
  8012a5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012a9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012b2:	0f b6 00             	movzbl (%rax),%eax
  8012b5:	84 c0                	test   %al,%al
  8012b7:	75 ec                	jne    8012a5 <strlen+0x15>
		n++;
	return n;
  8012b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012bc:	c9                   	leaveq 
  8012bd:	c3                   	retq   

00000000008012be <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8012be:	55                   	push   %rbp
  8012bf:	48 89 e5             	mov    %rsp,%rbp
  8012c2:	48 83 ec 20          	sub    $0x20,%rsp
  8012c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012ca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012d5:	eb 0e                	jmp    8012e5 <strnlen+0x27>
		n++;
  8012d7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012db:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012e0:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8012e5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8012ea:	74 0b                	je     8012f7 <strnlen+0x39>
  8012ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f0:	0f b6 00             	movzbl (%rax),%eax
  8012f3:	84 c0                	test   %al,%al
  8012f5:	75 e0                	jne    8012d7 <strnlen+0x19>
		n++;
	return n;
  8012f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012fa:	c9                   	leaveq 
  8012fb:	c3                   	retq   

00000000008012fc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012fc:	55                   	push   %rbp
  8012fd:	48 89 e5             	mov    %rsp,%rbp
  801300:	48 83 ec 20          	sub    $0x20,%rsp
  801304:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801308:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80130c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801310:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801314:	90                   	nop
  801315:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801319:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80131d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801321:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801325:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801329:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80132d:	0f b6 12             	movzbl (%rdx),%edx
  801330:	88 10                	mov    %dl,(%rax)
  801332:	0f b6 00             	movzbl (%rax),%eax
  801335:	84 c0                	test   %al,%al
  801337:	75 dc                	jne    801315 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801339:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80133d:	c9                   	leaveq 
  80133e:	c3                   	retq   

000000000080133f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80133f:	55                   	push   %rbp
  801340:	48 89 e5             	mov    %rsp,%rbp
  801343:	48 83 ec 20          	sub    $0x20,%rsp
  801347:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80134b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80134f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801353:	48 89 c7             	mov    %rax,%rdi
  801356:	48 b8 90 12 80 00 00 	movabs $0x801290,%rax
  80135d:	00 00 00 
  801360:	ff d0                	callq  *%rax
  801362:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801365:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801368:	48 63 d0             	movslq %eax,%rdx
  80136b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80136f:	48 01 c2             	add    %rax,%rdx
  801372:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801376:	48 89 c6             	mov    %rax,%rsi
  801379:	48 89 d7             	mov    %rdx,%rdi
  80137c:	48 b8 fc 12 80 00 00 	movabs $0x8012fc,%rax
  801383:	00 00 00 
  801386:	ff d0                	callq  *%rax
	return dst;
  801388:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80138c:	c9                   	leaveq 
  80138d:	c3                   	retq   

000000000080138e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80138e:	55                   	push   %rbp
  80138f:	48 89 e5             	mov    %rsp,%rbp
  801392:	48 83 ec 28          	sub    $0x28,%rsp
  801396:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80139a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80139e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8013a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013a6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8013aa:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8013b1:	00 
  8013b2:	eb 2a                	jmp    8013de <strncpy+0x50>
		*dst++ = *src;
  8013b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013b8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013bc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013c0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013c4:	0f b6 12             	movzbl (%rdx),%edx
  8013c7:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013c9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013cd:	0f b6 00             	movzbl (%rax),%eax
  8013d0:	84 c0                	test   %al,%al
  8013d2:	74 05                	je     8013d9 <strncpy+0x4b>
			src++;
  8013d4:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013d9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8013e6:	72 cc                	jb     8013b4 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8013ec:	c9                   	leaveq 
  8013ed:	c3                   	retq   

00000000008013ee <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8013ee:	55                   	push   %rbp
  8013ef:	48 89 e5             	mov    %rsp,%rbp
  8013f2:	48 83 ec 28          	sub    $0x28,%rsp
  8013f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013fa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013fe:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801402:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801406:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80140a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80140f:	74 3d                	je     80144e <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801411:	eb 1d                	jmp    801430 <strlcpy+0x42>
			*dst++ = *src++;
  801413:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801417:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80141b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80141f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801423:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801427:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80142b:	0f b6 12             	movzbl (%rdx),%edx
  80142e:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801430:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801435:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80143a:	74 0b                	je     801447 <strlcpy+0x59>
  80143c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801440:	0f b6 00             	movzbl (%rax),%eax
  801443:	84 c0                	test   %al,%al
  801445:	75 cc                	jne    801413 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801447:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80144b:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80144e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801452:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801456:	48 29 c2             	sub    %rax,%rdx
  801459:	48 89 d0             	mov    %rdx,%rax
}
  80145c:	c9                   	leaveq 
  80145d:	c3                   	retq   

000000000080145e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80145e:	55                   	push   %rbp
  80145f:	48 89 e5             	mov    %rsp,%rbp
  801462:	48 83 ec 10          	sub    $0x10,%rsp
  801466:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80146a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80146e:	eb 0a                	jmp    80147a <strcmp+0x1c>
		p++, q++;
  801470:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801475:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80147a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80147e:	0f b6 00             	movzbl (%rax),%eax
  801481:	84 c0                	test   %al,%al
  801483:	74 12                	je     801497 <strcmp+0x39>
  801485:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801489:	0f b6 10             	movzbl (%rax),%edx
  80148c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801490:	0f b6 00             	movzbl (%rax),%eax
  801493:	38 c2                	cmp    %al,%dl
  801495:	74 d9                	je     801470 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801497:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80149b:	0f b6 00             	movzbl (%rax),%eax
  80149e:	0f b6 d0             	movzbl %al,%edx
  8014a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a5:	0f b6 00             	movzbl (%rax),%eax
  8014a8:	0f b6 c0             	movzbl %al,%eax
  8014ab:	29 c2                	sub    %eax,%edx
  8014ad:	89 d0                	mov    %edx,%eax
}
  8014af:	c9                   	leaveq 
  8014b0:	c3                   	retq   

00000000008014b1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8014b1:	55                   	push   %rbp
  8014b2:	48 89 e5             	mov    %rsp,%rbp
  8014b5:	48 83 ec 18          	sub    $0x18,%rsp
  8014b9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014bd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014c1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8014c5:	eb 0f                	jmp    8014d6 <strncmp+0x25>
		n--, p++, q++;
  8014c7:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8014cc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014d1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8014d6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014db:	74 1d                	je     8014fa <strncmp+0x49>
  8014dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e1:	0f b6 00             	movzbl (%rax),%eax
  8014e4:	84 c0                	test   %al,%al
  8014e6:	74 12                	je     8014fa <strncmp+0x49>
  8014e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ec:	0f b6 10             	movzbl (%rax),%edx
  8014ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f3:	0f b6 00             	movzbl (%rax),%eax
  8014f6:	38 c2                	cmp    %al,%dl
  8014f8:	74 cd                	je     8014c7 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8014fa:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014ff:	75 07                	jne    801508 <strncmp+0x57>
		return 0;
  801501:	b8 00 00 00 00       	mov    $0x0,%eax
  801506:	eb 18                	jmp    801520 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801508:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80150c:	0f b6 00             	movzbl (%rax),%eax
  80150f:	0f b6 d0             	movzbl %al,%edx
  801512:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801516:	0f b6 00             	movzbl (%rax),%eax
  801519:	0f b6 c0             	movzbl %al,%eax
  80151c:	29 c2                	sub    %eax,%edx
  80151e:	89 d0                	mov    %edx,%eax
}
  801520:	c9                   	leaveq 
  801521:	c3                   	retq   

0000000000801522 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801522:	55                   	push   %rbp
  801523:	48 89 e5             	mov    %rsp,%rbp
  801526:	48 83 ec 0c          	sub    $0xc,%rsp
  80152a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80152e:	89 f0                	mov    %esi,%eax
  801530:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801533:	eb 17                	jmp    80154c <strchr+0x2a>
		if (*s == c)
  801535:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801539:	0f b6 00             	movzbl (%rax),%eax
  80153c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80153f:	75 06                	jne    801547 <strchr+0x25>
			return (char *) s;
  801541:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801545:	eb 15                	jmp    80155c <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801547:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80154c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801550:	0f b6 00             	movzbl (%rax),%eax
  801553:	84 c0                	test   %al,%al
  801555:	75 de                	jne    801535 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801557:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80155c:	c9                   	leaveq 
  80155d:	c3                   	retq   

000000000080155e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80155e:	55                   	push   %rbp
  80155f:	48 89 e5             	mov    %rsp,%rbp
  801562:	48 83 ec 0c          	sub    $0xc,%rsp
  801566:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80156a:	89 f0                	mov    %esi,%eax
  80156c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80156f:	eb 13                	jmp    801584 <strfind+0x26>
		if (*s == c)
  801571:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801575:	0f b6 00             	movzbl (%rax),%eax
  801578:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80157b:	75 02                	jne    80157f <strfind+0x21>
			break;
  80157d:	eb 10                	jmp    80158f <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80157f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801584:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801588:	0f b6 00             	movzbl (%rax),%eax
  80158b:	84 c0                	test   %al,%al
  80158d:	75 e2                	jne    801571 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80158f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801593:	c9                   	leaveq 
  801594:	c3                   	retq   

0000000000801595 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801595:	55                   	push   %rbp
  801596:	48 89 e5             	mov    %rsp,%rbp
  801599:	48 83 ec 18          	sub    $0x18,%rsp
  80159d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015a1:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8015a4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8015a8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015ad:	75 06                	jne    8015b5 <memset+0x20>
		return v;
  8015af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b3:	eb 69                	jmp    80161e <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8015b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b9:	83 e0 03             	and    $0x3,%eax
  8015bc:	48 85 c0             	test   %rax,%rax
  8015bf:	75 48                	jne    801609 <memset+0x74>
  8015c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015c5:	83 e0 03             	and    $0x3,%eax
  8015c8:	48 85 c0             	test   %rax,%rax
  8015cb:	75 3c                	jne    801609 <memset+0x74>
		c &= 0xFF;
  8015cd:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8015d4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015d7:	c1 e0 18             	shl    $0x18,%eax
  8015da:	89 c2                	mov    %eax,%edx
  8015dc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015df:	c1 e0 10             	shl    $0x10,%eax
  8015e2:	09 c2                	or     %eax,%edx
  8015e4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015e7:	c1 e0 08             	shl    $0x8,%eax
  8015ea:	09 d0                	or     %edx,%eax
  8015ec:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8015ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015f3:	48 c1 e8 02          	shr    $0x2,%rax
  8015f7:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8015fa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015fe:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801601:	48 89 d7             	mov    %rdx,%rdi
  801604:	fc                   	cld    
  801605:	f3 ab                	rep stos %eax,%es:(%rdi)
  801607:	eb 11                	jmp    80161a <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801609:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80160d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801610:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801614:	48 89 d7             	mov    %rdx,%rdi
  801617:	fc                   	cld    
  801618:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  80161a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80161e:	c9                   	leaveq 
  80161f:	c3                   	retq   

0000000000801620 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801620:	55                   	push   %rbp
  801621:	48 89 e5             	mov    %rsp,%rbp
  801624:	48 83 ec 28          	sub    $0x28,%rsp
  801628:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80162c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801630:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801634:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801638:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80163c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801640:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801644:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801648:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80164c:	0f 83 88 00 00 00    	jae    8016da <memmove+0xba>
  801652:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801656:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80165a:	48 01 d0             	add    %rdx,%rax
  80165d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801661:	76 77                	jbe    8016da <memmove+0xba>
		s += n;
  801663:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801667:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80166b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166f:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801673:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801677:	83 e0 03             	and    $0x3,%eax
  80167a:	48 85 c0             	test   %rax,%rax
  80167d:	75 3b                	jne    8016ba <memmove+0x9a>
  80167f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801683:	83 e0 03             	and    $0x3,%eax
  801686:	48 85 c0             	test   %rax,%rax
  801689:	75 2f                	jne    8016ba <memmove+0x9a>
  80168b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168f:	83 e0 03             	and    $0x3,%eax
  801692:	48 85 c0             	test   %rax,%rax
  801695:	75 23                	jne    8016ba <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801697:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80169b:	48 83 e8 04          	sub    $0x4,%rax
  80169f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016a3:	48 83 ea 04          	sub    $0x4,%rdx
  8016a7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8016ab:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8016af:	48 89 c7             	mov    %rax,%rdi
  8016b2:	48 89 d6             	mov    %rdx,%rsi
  8016b5:	fd                   	std    
  8016b6:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016b8:	eb 1d                	jmp    8016d7 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8016ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016be:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016c6:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8016ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ce:	48 89 d7             	mov    %rdx,%rdi
  8016d1:	48 89 c1             	mov    %rax,%rcx
  8016d4:	fd                   	std    
  8016d5:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8016d7:	fc                   	cld    
  8016d8:	eb 57                	jmp    801731 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016de:	83 e0 03             	and    $0x3,%eax
  8016e1:	48 85 c0             	test   %rax,%rax
  8016e4:	75 36                	jne    80171c <memmove+0xfc>
  8016e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ea:	83 e0 03             	and    $0x3,%eax
  8016ed:	48 85 c0             	test   %rax,%rax
  8016f0:	75 2a                	jne    80171c <memmove+0xfc>
  8016f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f6:	83 e0 03             	and    $0x3,%eax
  8016f9:	48 85 c0             	test   %rax,%rax
  8016fc:	75 1e                	jne    80171c <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8016fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801702:	48 c1 e8 02          	shr    $0x2,%rax
  801706:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801709:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80170d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801711:	48 89 c7             	mov    %rax,%rdi
  801714:	48 89 d6             	mov    %rdx,%rsi
  801717:	fc                   	cld    
  801718:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80171a:	eb 15                	jmp    801731 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80171c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801720:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801724:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801728:	48 89 c7             	mov    %rax,%rdi
  80172b:	48 89 d6             	mov    %rdx,%rsi
  80172e:	fc                   	cld    
  80172f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801731:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801735:	c9                   	leaveq 
  801736:	c3                   	retq   

0000000000801737 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801737:	55                   	push   %rbp
  801738:	48 89 e5             	mov    %rsp,%rbp
  80173b:	48 83 ec 18          	sub    $0x18,%rsp
  80173f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801743:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801747:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80174b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80174f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801753:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801757:	48 89 ce             	mov    %rcx,%rsi
  80175a:	48 89 c7             	mov    %rax,%rdi
  80175d:	48 b8 20 16 80 00 00 	movabs $0x801620,%rax
  801764:	00 00 00 
  801767:	ff d0                	callq  *%rax
}
  801769:	c9                   	leaveq 
  80176a:	c3                   	retq   

000000000080176b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80176b:	55                   	push   %rbp
  80176c:	48 89 e5             	mov    %rsp,%rbp
  80176f:	48 83 ec 28          	sub    $0x28,%rsp
  801773:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801777:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80177b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80177f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801783:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801787:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80178b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80178f:	eb 36                	jmp    8017c7 <memcmp+0x5c>
		if (*s1 != *s2)
  801791:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801795:	0f b6 10             	movzbl (%rax),%edx
  801798:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80179c:	0f b6 00             	movzbl (%rax),%eax
  80179f:	38 c2                	cmp    %al,%dl
  8017a1:	74 1a                	je     8017bd <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8017a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017a7:	0f b6 00             	movzbl (%rax),%eax
  8017aa:	0f b6 d0             	movzbl %al,%edx
  8017ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017b1:	0f b6 00             	movzbl (%rax),%eax
  8017b4:	0f b6 c0             	movzbl %al,%eax
  8017b7:	29 c2                	sub    %eax,%edx
  8017b9:	89 d0                	mov    %edx,%eax
  8017bb:	eb 20                	jmp    8017dd <memcmp+0x72>
		s1++, s2++;
  8017bd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017c2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8017c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cb:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017cf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017d3:	48 85 c0             	test   %rax,%rax
  8017d6:	75 b9                	jne    801791 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017dd:	c9                   	leaveq 
  8017de:	c3                   	retq   

00000000008017df <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8017df:	55                   	push   %rbp
  8017e0:	48 89 e5             	mov    %rsp,%rbp
  8017e3:	48 83 ec 28          	sub    $0x28,%rsp
  8017e7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017eb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8017ee:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8017f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017fa:	48 01 d0             	add    %rdx,%rax
  8017fd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801801:	eb 15                	jmp    801818 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801803:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801807:	0f b6 10             	movzbl (%rax),%edx
  80180a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80180d:	38 c2                	cmp    %al,%dl
  80180f:	75 02                	jne    801813 <memfind+0x34>
			break;
  801811:	eb 0f                	jmp    801822 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801813:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801818:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80181c:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801820:	72 e1                	jb     801803 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801822:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801826:	c9                   	leaveq 
  801827:	c3                   	retq   

0000000000801828 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801828:	55                   	push   %rbp
  801829:	48 89 e5             	mov    %rsp,%rbp
  80182c:	48 83 ec 34          	sub    $0x34,%rsp
  801830:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801834:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801838:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80183b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801842:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801849:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80184a:	eb 05                	jmp    801851 <strtol+0x29>
		s++;
  80184c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801851:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801855:	0f b6 00             	movzbl (%rax),%eax
  801858:	3c 20                	cmp    $0x20,%al
  80185a:	74 f0                	je     80184c <strtol+0x24>
  80185c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801860:	0f b6 00             	movzbl (%rax),%eax
  801863:	3c 09                	cmp    $0x9,%al
  801865:	74 e5                	je     80184c <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801867:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80186b:	0f b6 00             	movzbl (%rax),%eax
  80186e:	3c 2b                	cmp    $0x2b,%al
  801870:	75 07                	jne    801879 <strtol+0x51>
		s++;
  801872:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801877:	eb 17                	jmp    801890 <strtol+0x68>
	else if (*s == '-')
  801879:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80187d:	0f b6 00             	movzbl (%rax),%eax
  801880:	3c 2d                	cmp    $0x2d,%al
  801882:	75 0c                	jne    801890 <strtol+0x68>
		s++, neg = 1;
  801884:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801889:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801890:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801894:	74 06                	je     80189c <strtol+0x74>
  801896:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80189a:	75 28                	jne    8018c4 <strtol+0x9c>
  80189c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a0:	0f b6 00             	movzbl (%rax),%eax
  8018a3:	3c 30                	cmp    $0x30,%al
  8018a5:	75 1d                	jne    8018c4 <strtol+0x9c>
  8018a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ab:	48 83 c0 01          	add    $0x1,%rax
  8018af:	0f b6 00             	movzbl (%rax),%eax
  8018b2:	3c 78                	cmp    $0x78,%al
  8018b4:	75 0e                	jne    8018c4 <strtol+0x9c>
		s += 2, base = 16;
  8018b6:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8018bb:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8018c2:	eb 2c                	jmp    8018f0 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8018c4:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018c8:	75 19                	jne    8018e3 <strtol+0xbb>
  8018ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ce:	0f b6 00             	movzbl (%rax),%eax
  8018d1:	3c 30                	cmp    $0x30,%al
  8018d3:	75 0e                	jne    8018e3 <strtol+0xbb>
		s++, base = 8;
  8018d5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018da:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8018e1:	eb 0d                	jmp    8018f0 <strtol+0xc8>
	else if (base == 0)
  8018e3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018e7:	75 07                	jne    8018f0 <strtol+0xc8>
		base = 10;
  8018e9:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f4:	0f b6 00             	movzbl (%rax),%eax
  8018f7:	3c 2f                	cmp    $0x2f,%al
  8018f9:	7e 1d                	jle    801918 <strtol+0xf0>
  8018fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ff:	0f b6 00             	movzbl (%rax),%eax
  801902:	3c 39                	cmp    $0x39,%al
  801904:	7f 12                	jg     801918 <strtol+0xf0>
			dig = *s - '0';
  801906:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80190a:	0f b6 00             	movzbl (%rax),%eax
  80190d:	0f be c0             	movsbl %al,%eax
  801910:	83 e8 30             	sub    $0x30,%eax
  801913:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801916:	eb 4e                	jmp    801966 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801918:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191c:	0f b6 00             	movzbl (%rax),%eax
  80191f:	3c 60                	cmp    $0x60,%al
  801921:	7e 1d                	jle    801940 <strtol+0x118>
  801923:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801927:	0f b6 00             	movzbl (%rax),%eax
  80192a:	3c 7a                	cmp    $0x7a,%al
  80192c:	7f 12                	jg     801940 <strtol+0x118>
			dig = *s - 'a' + 10;
  80192e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801932:	0f b6 00             	movzbl (%rax),%eax
  801935:	0f be c0             	movsbl %al,%eax
  801938:	83 e8 57             	sub    $0x57,%eax
  80193b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80193e:	eb 26                	jmp    801966 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801940:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801944:	0f b6 00             	movzbl (%rax),%eax
  801947:	3c 40                	cmp    $0x40,%al
  801949:	7e 48                	jle    801993 <strtol+0x16b>
  80194b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80194f:	0f b6 00             	movzbl (%rax),%eax
  801952:	3c 5a                	cmp    $0x5a,%al
  801954:	7f 3d                	jg     801993 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801956:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80195a:	0f b6 00             	movzbl (%rax),%eax
  80195d:	0f be c0             	movsbl %al,%eax
  801960:	83 e8 37             	sub    $0x37,%eax
  801963:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801966:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801969:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80196c:	7c 02                	jl     801970 <strtol+0x148>
			break;
  80196e:	eb 23                	jmp    801993 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801970:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801975:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801978:	48 98                	cltq   
  80197a:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80197f:	48 89 c2             	mov    %rax,%rdx
  801982:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801985:	48 98                	cltq   
  801987:	48 01 d0             	add    %rdx,%rax
  80198a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80198e:	e9 5d ff ff ff       	jmpq   8018f0 <strtol+0xc8>

	if (endptr)
  801993:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801998:	74 0b                	je     8019a5 <strtol+0x17d>
		*endptr = (char *) s;
  80199a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80199e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8019a2:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8019a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019a9:	74 09                	je     8019b4 <strtol+0x18c>
  8019ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019af:	48 f7 d8             	neg    %rax
  8019b2:	eb 04                	jmp    8019b8 <strtol+0x190>
  8019b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019b8:	c9                   	leaveq 
  8019b9:	c3                   	retq   

00000000008019ba <strstr>:

char * strstr(const char *in, const char *str)
{
  8019ba:	55                   	push   %rbp
  8019bb:	48 89 e5             	mov    %rsp,%rbp
  8019be:	48 83 ec 30          	sub    $0x30,%rsp
  8019c2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019c6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8019ca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019ce:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019d2:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019d6:	0f b6 00             	movzbl (%rax),%eax
  8019d9:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8019dc:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8019e0:	75 06                	jne    8019e8 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  8019e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e6:	eb 6b                	jmp    801a53 <strstr+0x99>

    len = strlen(str);
  8019e8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019ec:	48 89 c7             	mov    %rax,%rdi
  8019ef:	48 b8 90 12 80 00 00 	movabs $0x801290,%rax
  8019f6:	00 00 00 
  8019f9:	ff d0                	callq  *%rax
  8019fb:	48 98                	cltq   
  8019fd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801a01:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a05:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a09:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801a0d:	0f b6 00             	movzbl (%rax),%eax
  801a10:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801a13:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801a17:	75 07                	jne    801a20 <strstr+0x66>
                return (char *) 0;
  801a19:	b8 00 00 00 00       	mov    $0x0,%eax
  801a1e:	eb 33                	jmp    801a53 <strstr+0x99>
        } while (sc != c);
  801a20:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801a24:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a27:	75 d8                	jne    801a01 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801a29:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a2d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801a31:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a35:	48 89 ce             	mov    %rcx,%rsi
  801a38:	48 89 c7             	mov    %rax,%rdi
  801a3b:	48 b8 b1 14 80 00 00 	movabs $0x8014b1,%rax
  801a42:	00 00 00 
  801a45:	ff d0                	callq  *%rax
  801a47:	85 c0                	test   %eax,%eax
  801a49:	75 b6                	jne    801a01 <strstr+0x47>

    return (char *) (in - 1);
  801a4b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a4f:	48 83 e8 01          	sub    $0x1,%rax
}
  801a53:	c9                   	leaveq 
  801a54:	c3                   	retq   
