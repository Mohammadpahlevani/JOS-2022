
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
  800068:	48 83 ec 20          	sub    $0x20,%rsp
  80006c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80006f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800073:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  80007a:	00 00 00 
  80007d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	envid_t id = sys_getenvid();
  800084:	48 b8 79 02 80 00 00 	movabs $0x800279,%rax
  80008b:	00 00 00 
  80008e:	ff d0                	callq  *%rax
  800090:	89 45 fc             	mov    %eax,-0x4(%rbp)
        id = ENVX(id);
  800093:	81 65 fc ff 03 00 00 	andl   $0x3ff,-0x4(%rbp)
	thisenv = &envs[id];
  80009a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80009d:	48 63 d0             	movslq %eax,%rdx
  8000a0:	48 89 d0             	mov    %rdx,%rax
  8000a3:	48 c1 e0 03          	shl    $0x3,%rax
  8000a7:	48 01 d0             	add    %rdx,%rax
  8000aa:	48 c1 e0 05          	shl    $0x5,%rax
  8000ae:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000b5:	00 00 00 
  8000b8:	48 01 c2             	add    %rax,%rdx
  8000bb:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000c2:	00 00 00 
  8000c5:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000cc:	7e 14                	jle    8000e2 <libmain+0x7e>
		binaryname = argv[0];
  8000ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000d2:	48 8b 10             	mov    (%rax),%rdx
  8000d5:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000dc:	00 00 00 
  8000df:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000e2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8000e6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000e9:	48 89 d6             	mov    %rdx,%rsi
  8000ec:	89 c7                	mov    %eax,%edi
  8000ee:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000f5:	00 00 00 
  8000f8:	ff d0                	callq  *%rax
	
	//cprintf("\noutside\n");
	// exit gracefully
	exit();
  8000fa:	48 b8 08 01 80 00 00 	movabs $0x800108,%rax
  800101:	00 00 00 
  800104:	ff d0                	callq  *%rax
}
  800106:	c9                   	leaveq 
  800107:	c3                   	retq   

0000000000800108 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800108:	55                   	push   %rbp
  800109:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  80010c:	bf 00 00 00 00       	mov    $0x0,%edi
  800111:	48 b8 35 02 80 00 00 	movabs $0x800235,%rax
  800118:	00 00 00 
  80011b:	ff d0                	callq  *%rax
}
  80011d:	5d                   	pop    %rbp
  80011e:	c3                   	retq   

000000000080011f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80011f:	55                   	push   %rbp
  800120:	48 89 e5             	mov    %rsp,%rbp
  800123:	53                   	push   %rbx
  800124:	48 83 ec 48          	sub    $0x48,%rsp
  800128:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80012b:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80012e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800132:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800136:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80013a:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80013e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800141:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800145:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800149:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80014d:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800151:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800155:	4c 89 c3             	mov    %r8,%rbx
  800158:	cd 30                	int    $0x30
  80015a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80015e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800162:	74 3e                	je     8001a2 <syscall+0x83>
  800164:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800169:	7e 37                	jle    8001a2 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80016b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80016f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800172:	49 89 d0             	mov    %rdx,%r8
  800175:	89 c1                	mov    %eax,%ecx
  800177:	48 ba 6a 1a 80 00 00 	movabs $0x801a6a,%rdx
  80017e:	00 00 00 
  800181:	be 23 00 00 00       	mov    $0x23,%esi
  800186:	48 bf 87 1a 80 00 00 	movabs $0x801a87,%rdi
  80018d:	00 00 00 
  800190:	b8 00 00 00 00       	mov    $0x0,%eax
  800195:	49 b9 18 05 80 00 00 	movabs $0x800518,%r9
  80019c:	00 00 00 
  80019f:	41 ff d1             	callq  *%r9

	return ret;
  8001a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001a6:	48 83 c4 48          	add    $0x48,%rsp
  8001aa:	5b                   	pop    %rbx
  8001ab:	5d                   	pop    %rbp
  8001ac:	c3                   	retq   

00000000008001ad <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001ad:	55                   	push   %rbp
  8001ae:	48 89 e5             	mov    %rsp,%rbp
  8001b1:	48 83 ec 20          	sub    $0x20,%rsp
  8001b5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001b9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001c1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001c5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001cc:	00 
  8001cd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001d3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001d9:	48 89 d1             	mov    %rdx,%rcx
  8001dc:	48 89 c2             	mov    %rax,%rdx
  8001df:	be 00 00 00 00       	mov    $0x0,%esi
  8001e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8001e9:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  8001f0:	00 00 00 
  8001f3:	ff d0                	callq  *%rax
}
  8001f5:	c9                   	leaveq 
  8001f6:	c3                   	retq   

00000000008001f7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8001f7:	55                   	push   %rbp
  8001f8:	48 89 e5             	mov    %rsp,%rbp
  8001fb:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001ff:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800206:	00 
  800207:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80020d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800213:	b9 00 00 00 00       	mov    $0x0,%ecx
  800218:	ba 00 00 00 00       	mov    $0x0,%edx
  80021d:	be 00 00 00 00       	mov    $0x0,%esi
  800222:	bf 01 00 00 00       	mov    $0x1,%edi
  800227:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  80022e:	00 00 00 
  800231:	ff d0                	callq  *%rax
}
  800233:	c9                   	leaveq 
  800234:	c3                   	retq   

0000000000800235 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800235:	55                   	push   %rbp
  800236:	48 89 e5             	mov    %rsp,%rbp
  800239:	48 83 ec 10          	sub    $0x10,%rsp
  80023d:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800240:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800243:	48 98                	cltq   
  800245:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80024c:	00 
  80024d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800253:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800259:	b9 00 00 00 00       	mov    $0x0,%ecx
  80025e:	48 89 c2             	mov    %rax,%rdx
  800261:	be 01 00 00 00       	mov    $0x1,%esi
  800266:	bf 03 00 00 00       	mov    $0x3,%edi
  80026b:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  800272:	00 00 00 
  800275:	ff d0                	callq  *%rax
}
  800277:	c9                   	leaveq 
  800278:	c3                   	retq   

0000000000800279 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800279:	55                   	push   %rbp
  80027a:	48 89 e5             	mov    %rsp,%rbp
  80027d:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800281:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800288:	00 
  800289:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80028f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800295:	b9 00 00 00 00       	mov    $0x0,%ecx
  80029a:	ba 00 00 00 00       	mov    $0x0,%edx
  80029f:	be 00 00 00 00       	mov    $0x0,%esi
  8002a4:	bf 02 00 00 00       	mov    $0x2,%edi
  8002a9:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  8002b0:	00 00 00 
  8002b3:	ff d0                	callq  *%rax
}
  8002b5:	c9                   	leaveq 
  8002b6:	c3                   	retq   

00000000008002b7 <sys_yield>:

void
sys_yield(void)
{
  8002b7:	55                   	push   %rbp
  8002b8:	48 89 e5             	mov    %rsp,%rbp
  8002bb:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002bf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002c6:	00 
  8002c7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002cd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002d3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8002dd:	be 00 00 00 00       	mov    $0x0,%esi
  8002e2:	bf 0a 00 00 00       	mov    $0xa,%edi
  8002e7:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  8002ee:	00 00 00 
  8002f1:	ff d0                	callq  *%rax
}
  8002f3:	c9                   	leaveq 
  8002f4:	c3                   	retq   

00000000008002f5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002f5:	55                   	push   %rbp
  8002f6:	48 89 e5             	mov    %rsp,%rbp
  8002f9:	48 83 ec 20          	sub    $0x20,%rsp
  8002fd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800300:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800304:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800307:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80030a:	48 63 c8             	movslq %eax,%rcx
  80030d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800311:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800314:	48 98                	cltq   
  800316:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80031d:	00 
  80031e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800324:	49 89 c8             	mov    %rcx,%r8
  800327:	48 89 d1             	mov    %rdx,%rcx
  80032a:	48 89 c2             	mov    %rax,%rdx
  80032d:	be 01 00 00 00       	mov    $0x1,%esi
  800332:	bf 04 00 00 00       	mov    $0x4,%edi
  800337:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  80033e:	00 00 00 
  800341:	ff d0                	callq  *%rax
}
  800343:	c9                   	leaveq 
  800344:	c3                   	retq   

0000000000800345 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800345:	55                   	push   %rbp
  800346:	48 89 e5             	mov    %rsp,%rbp
  800349:	48 83 ec 30          	sub    $0x30,%rsp
  80034d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800350:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800354:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800357:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80035b:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80035f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800362:	48 63 c8             	movslq %eax,%rcx
  800365:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800369:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80036c:	48 63 f0             	movslq %eax,%rsi
  80036f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800373:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800376:	48 98                	cltq   
  800378:	48 89 0c 24          	mov    %rcx,(%rsp)
  80037c:	49 89 f9             	mov    %rdi,%r9
  80037f:	49 89 f0             	mov    %rsi,%r8
  800382:	48 89 d1             	mov    %rdx,%rcx
  800385:	48 89 c2             	mov    %rax,%rdx
  800388:	be 01 00 00 00       	mov    $0x1,%esi
  80038d:	bf 05 00 00 00       	mov    $0x5,%edi
  800392:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  800399:	00 00 00 
  80039c:	ff d0                	callq  *%rax
}
  80039e:	c9                   	leaveq 
  80039f:	c3                   	retq   

00000000008003a0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8003a0:	55                   	push   %rbp
  8003a1:	48 89 e5             	mov    %rsp,%rbp
  8003a4:	48 83 ec 20          	sub    $0x20,%rsp
  8003a8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003af:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003b6:	48 98                	cltq   
  8003b8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003bf:	00 
  8003c0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003c6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003cc:	48 89 d1             	mov    %rdx,%rcx
  8003cf:	48 89 c2             	mov    %rax,%rdx
  8003d2:	be 01 00 00 00       	mov    $0x1,%esi
  8003d7:	bf 06 00 00 00       	mov    $0x6,%edi
  8003dc:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  8003e3:	00 00 00 
  8003e6:	ff d0                	callq  *%rax
}
  8003e8:	c9                   	leaveq 
  8003e9:	c3                   	retq   

00000000008003ea <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003ea:	55                   	push   %rbp
  8003eb:	48 89 e5             	mov    %rsp,%rbp
  8003ee:	48 83 ec 10          	sub    $0x10,%rsp
  8003f2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003f5:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8003f8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003fb:	48 63 d0             	movslq %eax,%rdx
  8003fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800401:	48 98                	cltq   
  800403:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80040a:	00 
  80040b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800411:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800417:	48 89 d1             	mov    %rdx,%rcx
  80041a:	48 89 c2             	mov    %rax,%rdx
  80041d:	be 01 00 00 00       	mov    $0x1,%esi
  800422:	bf 08 00 00 00       	mov    $0x8,%edi
  800427:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  80042e:	00 00 00 
  800431:	ff d0                	callq  *%rax
}
  800433:	c9                   	leaveq 
  800434:	c3                   	retq   

0000000000800435 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800435:	55                   	push   %rbp
  800436:	48 89 e5             	mov    %rsp,%rbp
  800439:	48 83 ec 20          	sub    $0x20,%rsp
  80043d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800440:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800444:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800448:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80044b:	48 98                	cltq   
  80044d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800454:	00 
  800455:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80045b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800461:	48 89 d1             	mov    %rdx,%rcx
  800464:	48 89 c2             	mov    %rax,%rdx
  800467:	be 01 00 00 00       	mov    $0x1,%esi
  80046c:	bf 09 00 00 00       	mov    $0x9,%edi
  800471:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  800478:	00 00 00 
  80047b:	ff d0                	callq  *%rax
}
  80047d:	c9                   	leaveq 
  80047e:	c3                   	retq   

000000000080047f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  80047f:	55                   	push   %rbp
  800480:	48 89 e5             	mov    %rsp,%rbp
  800483:	48 83 ec 20          	sub    $0x20,%rsp
  800487:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80048a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80048e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800492:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  800495:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800498:	48 63 f0             	movslq %eax,%rsi
  80049b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80049f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004a2:	48 98                	cltq   
  8004a4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004a8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004af:	00 
  8004b0:	49 89 f1             	mov    %rsi,%r9
  8004b3:	49 89 c8             	mov    %rcx,%r8
  8004b6:	48 89 d1             	mov    %rdx,%rcx
  8004b9:	48 89 c2             	mov    %rax,%rdx
  8004bc:	be 00 00 00 00       	mov    $0x0,%esi
  8004c1:	bf 0b 00 00 00       	mov    $0xb,%edi
  8004c6:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  8004cd:	00 00 00 
  8004d0:	ff d0                	callq  *%rax
}
  8004d2:	c9                   	leaveq 
  8004d3:	c3                   	retq   

00000000008004d4 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8004d4:	55                   	push   %rbp
  8004d5:	48 89 e5             	mov    %rsp,%rbp
  8004d8:	48 83 ec 10          	sub    $0x10,%rsp
  8004dc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8004e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004e4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004eb:	00 
  8004ec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004f2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004f8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004fd:	48 89 c2             	mov    %rax,%rdx
  800500:	be 01 00 00 00       	mov    $0x1,%esi
  800505:	bf 0c 00 00 00       	mov    $0xc,%edi
  80050a:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  800511:	00 00 00 
  800514:	ff d0                	callq  *%rax
}
  800516:	c9                   	leaveq 
  800517:	c3                   	retq   

0000000000800518 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800518:	55                   	push   %rbp
  800519:	48 89 e5             	mov    %rsp,%rbp
  80051c:	53                   	push   %rbx
  80051d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800524:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80052b:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800531:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800538:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80053f:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800546:	84 c0                	test   %al,%al
  800548:	74 23                	je     80056d <_panic+0x55>
  80054a:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800551:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800555:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800559:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80055d:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800561:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800565:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800569:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80056d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800574:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80057b:	00 00 00 
  80057e:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800585:	00 00 00 
  800588:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80058c:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800593:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80059a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8005a1:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8005a8:	00 00 00 
  8005ab:	48 8b 18             	mov    (%rax),%rbx
  8005ae:	48 b8 79 02 80 00 00 	movabs $0x800279,%rax
  8005b5:	00 00 00 
  8005b8:	ff d0                	callq  *%rax
  8005ba:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8005c0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8005c7:	41 89 c8             	mov    %ecx,%r8d
  8005ca:	48 89 d1             	mov    %rdx,%rcx
  8005cd:	48 89 da             	mov    %rbx,%rdx
  8005d0:	89 c6                	mov    %eax,%esi
  8005d2:	48 bf 98 1a 80 00 00 	movabs $0x801a98,%rdi
  8005d9:	00 00 00 
  8005dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e1:	49 b9 51 07 80 00 00 	movabs $0x800751,%r9
  8005e8:	00 00 00 
  8005eb:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005ee:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8005f5:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005fc:	48 89 d6             	mov    %rdx,%rsi
  8005ff:	48 89 c7             	mov    %rax,%rdi
  800602:	48 b8 a5 06 80 00 00 	movabs $0x8006a5,%rax
  800609:	00 00 00 
  80060c:	ff d0                	callq  *%rax
	cprintf("\n");
  80060e:	48 bf bb 1a 80 00 00 	movabs $0x801abb,%rdi
  800615:	00 00 00 
  800618:	b8 00 00 00 00       	mov    $0x0,%eax
  80061d:	48 ba 51 07 80 00 00 	movabs $0x800751,%rdx
  800624:	00 00 00 
  800627:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800629:	cc                   	int3   
  80062a:	eb fd                	jmp    800629 <_panic+0x111>

000000000080062c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80062c:	55                   	push   %rbp
  80062d:	48 89 e5             	mov    %rsp,%rbp
  800630:	48 83 ec 10          	sub    $0x10,%rsp
  800634:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800637:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80063b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80063f:	8b 00                	mov    (%rax),%eax
  800641:	8d 48 01             	lea    0x1(%rax),%ecx
  800644:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800648:	89 0a                	mov    %ecx,(%rdx)
  80064a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80064d:	89 d1                	mov    %edx,%ecx
  80064f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800653:	48 98                	cltq   
  800655:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  800659:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80065d:	8b 00                	mov    (%rax),%eax
  80065f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800664:	75 2c                	jne    800692 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800666:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80066a:	8b 00                	mov    (%rax),%eax
  80066c:	48 98                	cltq   
  80066e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800672:	48 83 c2 08          	add    $0x8,%rdx
  800676:	48 89 c6             	mov    %rax,%rsi
  800679:	48 89 d7             	mov    %rdx,%rdi
  80067c:	48 b8 ad 01 80 00 00 	movabs $0x8001ad,%rax
  800683:	00 00 00 
  800686:	ff d0                	callq  *%rax
		b->idx = 0;
  800688:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80068c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800692:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800696:	8b 40 04             	mov    0x4(%rax),%eax
  800699:	8d 50 01             	lea    0x1(%rax),%edx
  80069c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006a0:	89 50 04             	mov    %edx,0x4(%rax)
}
  8006a3:	c9                   	leaveq 
  8006a4:	c3                   	retq   

00000000008006a5 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8006a5:	55                   	push   %rbp
  8006a6:	48 89 e5             	mov    %rsp,%rbp
  8006a9:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8006b0:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8006b7:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8006be:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006c5:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006cc:	48 8b 0a             	mov    (%rdx),%rcx
  8006cf:	48 89 08             	mov    %rcx,(%rax)
  8006d2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006d6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006da:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006de:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8006e2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8006e9:	00 00 00 
	b.cnt = 0;
  8006ec:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8006f3:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8006f6:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8006fd:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800704:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80070b:	48 89 c6             	mov    %rax,%rsi
  80070e:	48 bf 2c 06 80 00 00 	movabs $0x80062c,%rdi
  800715:	00 00 00 
  800718:	48 b8 04 0b 80 00 00 	movabs $0x800b04,%rax
  80071f:	00 00 00 
  800722:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800724:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80072a:	48 98                	cltq   
  80072c:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800733:	48 83 c2 08          	add    $0x8,%rdx
  800737:	48 89 c6             	mov    %rax,%rsi
  80073a:	48 89 d7             	mov    %rdx,%rdi
  80073d:	48 b8 ad 01 80 00 00 	movabs $0x8001ad,%rax
  800744:	00 00 00 
  800747:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800749:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80074f:	c9                   	leaveq 
  800750:	c3                   	retq   

0000000000800751 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800751:	55                   	push   %rbp
  800752:	48 89 e5             	mov    %rsp,%rbp
  800755:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80075c:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800763:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80076a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800771:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800778:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80077f:	84 c0                	test   %al,%al
  800781:	74 20                	je     8007a3 <cprintf+0x52>
  800783:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800787:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80078b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80078f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800793:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800797:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80079b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80079f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8007a3:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8007aa:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8007b1:	00 00 00 
  8007b4:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8007bb:	00 00 00 
  8007be:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007c2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007c9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007d0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8007d7:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007de:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007e5:	48 8b 0a             	mov    (%rdx),%rcx
  8007e8:	48 89 08             	mov    %rcx,(%rax)
  8007eb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007ef:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007f3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007f7:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8007fb:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800802:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800809:	48 89 d6             	mov    %rdx,%rsi
  80080c:	48 89 c7             	mov    %rax,%rdi
  80080f:	48 b8 a5 06 80 00 00 	movabs $0x8006a5,%rax
  800816:	00 00 00 
  800819:	ff d0                	callq  *%rax
  80081b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800821:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800827:	c9                   	leaveq 
  800828:	c3                   	retq   

0000000000800829 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800829:	55                   	push   %rbp
  80082a:	48 89 e5             	mov    %rsp,%rbp
  80082d:	53                   	push   %rbx
  80082e:	48 83 ec 38          	sub    $0x38,%rsp
  800832:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800836:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80083a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80083e:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800841:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800845:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800849:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80084c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800850:	77 3b                	ja     80088d <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800852:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800855:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800859:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80085c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800860:	ba 00 00 00 00       	mov    $0x0,%edx
  800865:	48 f7 f3             	div    %rbx
  800868:	48 89 c2             	mov    %rax,%rdx
  80086b:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80086e:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800871:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800875:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800879:	41 89 f9             	mov    %edi,%r9d
  80087c:	48 89 c7             	mov    %rax,%rdi
  80087f:	48 b8 29 08 80 00 00 	movabs $0x800829,%rax
  800886:	00 00 00 
  800889:	ff d0                	callq  *%rax
  80088b:	eb 1e                	jmp    8008ab <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80088d:	eb 12                	jmp    8008a1 <printnum+0x78>
			putch(padc, putdat);
  80088f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800893:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800896:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089a:	48 89 ce             	mov    %rcx,%rsi
  80089d:	89 d7                	mov    %edx,%edi
  80089f:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008a1:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8008a5:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8008a9:	7f e4                	jg     80088f <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008ab:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8008ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b7:	48 f7 f1             	div    %rcx
  8008ba:	48 89 d0             	mov    %rdx,%rax
  8008bd:	48 ba b0 1b 80 00 00 	movabs $0x801bb0,%rdx
  8008c4:	00 00 00 
  8008c7:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8008cb:	0f be d0             	movsbl %al,%edx
  8008ce:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8008d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d6:	48 89 ce             	mov    %rcx,%rsi
  8008d9:	89 d7                	mov    %edx,%edi
  8008db:	ff d0                	callq  *%rax
}
  8008dd:	48 83 c4 38          	add    $0x38,%rsp
  8008e1:	5b                   	pop    %rbx
  8008e2:	5d                   	pop    %rbp
  8008e3:	c3                   	retq   

00000000008008e4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008e4:	55                   	push   %rbp
  8008e5:	48 89 e5             	mov    %rsp,%rbp
  8008e8:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008ec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008f0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8008f3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008f7:	7e 52                	jle    80094b <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8008f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008fd:	8b 00                	mov    (%rax),%eax
  8008ff:	83 f8 30             	cmp    $0x30,%eax
  800902:	73 24                	jae    800928 <getuint+0x44>
  800904:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800908:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80090c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800910:	8b 00                	mov    (%rax),%eax
  800912:	89 c0                	mov    %eax,%eax
  800914:	48 01 d0             	add    %rdx,%rax
  800917:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80091b:	8b 12                	mov    (%rdx),%edx
  80091d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800920:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800924:	89 0a                	mov    %ecx,(%rdx)
  800926:	eb 17                	jmp    80093f <getuint+0x5b>
  800928:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800930:	48 89 d0             	mov    %rdx,%rax
  800933:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800937:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80093b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80093f:	48 8b 00             	mov    (%rax),%rax
  800942:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800946:	e9 a3 00 00 00       	jmpq   8009ee <getuint+0x10a>
	else if (lflag)
  80094b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80094f:	74 4f                	je     8009a0 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800951:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800955:	8b 00                	mov    (%rax),%eax
  800957:	83 f8 30             	cmp    $0x30,%eax
  80095a:	73 24                	jae    800980 <getuint+0x9c>
  80095c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800960:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800964:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800968:	8b 00                	mov    (%rax),%eax
  80096a:	89 c0                	mov    %eax,%eax
  80096c:	48 01 d0             	add    %rdx,%rax
  80096f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800973:	8b 12                	mov    (%rdx),%edx
  800975:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800978:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80097c:	89 0a                	mov    %ecx,(%rdx)
  80097e:	eb 17                	jmp    800997 <getuint+0xb3>
  800980:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800984:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800988:	48 89 d0             	mov    %rdx,%rax
  80098b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80098f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800993:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800997:	48 8b 00             	mov    (%rax),%rax
  80099a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80099e:	eb 4e                	jmp    8009ee <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8009a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a4:	8b 00                	mov    (%rax),%eax
  8009a6:	83 f8 30             	cmp    $0x30,%eax
  8009a9:	73 24                	jae    8009cf <getuint+0xeb>
  8009ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009af:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b7:	8b 00                	mov    (%rax),%eax
  8009b9:	89 c0                	mov    %eax,%eax
  8009bb:	48 01 d0             	add    %rdx,%rax
  8009be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c2:	8b 12                	mov    (%rdx),%edx
  8009c4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009cb:	89 0a                	mov    %ecx,(%rdx)
  8009cd:	eb 17                	jmp    8009e6 <getuint+0x102>
  8009cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009d7:	48 89 d0             	mov    %rdx,%rax
  8009da:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009e6:	8b 00                	mov    (%rax),%eax
  8009e8:	89 c0                	mov    %eax,%eax
  8009ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009f2:	c9                   	leaveq 
  8009f3:	c3                   	retq   

00000000008009f4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009f4:	55                   	push   %rbp
  8009f5:	48 89 e5             	mov    %rsp,%rbp
  8009f8:	48 83 ec 1c          	sub    $0x1c,%rsp
  8009fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a00:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800a03:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a07:	7e 52                	jle    800a5b <getint+0x67>
		x=va_arg(*ap, long long);
  800a09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a0d:	8b 00                	mov    (%rax),%eax
  800a0f:	83 f8 30             	cmp    $0x30,%eax
  800a12:	73 24                	jae    800a38 <getint+0x44>
  800a14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a18:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a20:	8b 00                	mov    (%rax),%eax
  800a22:	89 c0                	mov    %eax,%eax
  800a24:	48 01 d0             	add    %rdx,%rax
  800a27:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a2b:	8b 12                	mov    (%rdx),%edx
  800a2d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a30:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a34:	89 0a                	mov    %ecx,(%rdx)
  800a36:	eb 17                	jmp    800a4f <getint+0x5b>
  800a38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a3c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a40:	48 89 d0             	mov    %rdx,%rax
  800a43:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a47:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a4b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a4f:	48 8b 00             	mov    (%rax),%rax
  800a52:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a56:	e9 a3 00 00 00       	jmpq   800afe <getint+0x10a>
	else if (lflag)
  800a5b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a5f:	74 4f                	je     800ab0 <getint+0xbc>
		x=va_arg(*ap, long);
  800a61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a65:	8b 00                	mov    (%rax),%eax
  800a67:	83 f8 30             	cmp    $0x30,%eax
  800a6a:	73 24                	jae    800a90 <getint+0x9c>
  800a6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a70:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a78:	8b 00                	mov    (%rax),%eax
  800a7a:	89 c0                	mov    %eax,%eax
  800a7c:	48 01 d0             	add    %rdx,%rax
  800a7f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a83:	8b 12                	mov    (%rdx),%edx
  800a85:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a88:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a8c:	89 0a                	mov    %ecx,(%rdx)
  800a8e:	eb 17                	jmp    800aa7 <getint+0xb3>
  800a90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a94:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a98:	48 89 d0             	mov    %rdx,%rax
  800a9b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a9f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aa3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800aa7:	48 8b 00             	mov    (%rax),%rax
  800aaa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800aae:	eb 4e                	jmp    800afe <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800ab0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab4:	8b 00                	mov    (%rax),%eax
  800ab6:	83 f8 30             	cmp    $0x30,%eax
  800ab9:	73 24                	jae    800adf <getint+0xeb>
  800abb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800abf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ac3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac7:	8b 00                	mov    (%rax),%eax
  800ac9:	89 c0                	mov    %eax,%eax
  800acb:	48 01 d0             	add    %rdx,%rax
  800ace:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad2:	8b 12                	mov    (%rdx),%edx
  800ad4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ad7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800adb:	89 0a                	mov    %ecx,(%rdx)
  800add:	eb 17                	jmp    800af6 <getint+0x102>
  800adf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ae7:	48 89 d0             	mov    %rdx,%rax
  800aea:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800aee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800af2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800af6:	8b 00                	mov    (%rax),%eax
  800af8:	48 98                	cltq   
  800afa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800afe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800b02:	c9                   	leaveq 
  800b03:	c3                   	retq   

0000000000800b04 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b04:	55                   	push   %rbp
  800b05:	48 89 e5             	mov    %rsp,%rbp
  800b08:	41 54                	push   %r12
  800b0a:	53                   	push   %rbx
  800b0b:	48 83 ec 60          	sub    $0x60,%rsp
  800b0f:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800b13:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800b17:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b1b:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800b1f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b23:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b27:	48 8b 0a             	mov    (%rdx),%rcx
  800b2a:	48 89 08             	mov    %rcx,(%rax)
  800b2d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b31:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b35:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b39:	48 89 50 10          	mov    %rdx,0x10(%rax)
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b3d:	eb 17                	jmp    800b56 <vprintfmt+0x52>
			if (ch == '\0')
  800b3f:	85 db                	test   %ebx,%ebx
  800b41:	0f 84 cc 04 00 00    	je     801013 <vprintfmt+0x50f>
                }
#endif

			  return;
			}
			putch(ch, putdat);
  800b47:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b4b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b4f:	48 89 d6             	mov    %rdx,%rsi
  800b52:	89 df                	mov    %ebx,%edi
  800b54:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b56:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b5a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b5e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b62:	0f b6 00             	movzbl (%rax),%eax
  800b65:	0f b6 d8             	movzbl %al,%ebx
  800b68:	83 fb 25             	cmp    $0x25,%ebx
  800b6b:	75 d2                	jne    800b3f <vprintfmt+0x3b>
			  return;
			}
			putch(ch, putdat);
		}
		// Process a %-escape sequence
		padc = ' ';
  800b6d:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b71:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b78:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b7f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b86:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b8d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b91:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b95:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b99:	0f b6 00             	movzbl (%rax),%eax
  800b9c:	0f b6 d8             	movzbl %al,%ebx
  800b9f:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800ba2:	83 f8 55             	cmp    $0x55,%eax
  800ba5:	0f 87 34 04 00 00    	ja     800fdf <vprintfmt+0x4db>
  800bab:	89 c0                	mov    %eax,%eax
  800bad:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800bb4:	00 
  800bb5:	48 b8 d8 1b 80 00 00 	movabs $0x801bd8,%rax
  800bbc:	00 00 00 
  800bbf:	48 01 d0             	add    %rdx,%rax
  800bc2:	48 8b 00             	mov    (%rax),%rax
  800bc5:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bc7:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800bcb:	eb c0                	jmp    800b8d <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bcd:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800bd1:	eb ba                	jmp    800b8d <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bd3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800bda:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800bdd:	89 d0                	mov    %edx,%eax
  800bdf:	c1 e0 02             	shl    $0x2,%eax
  800be2:	01 d0                	add    %edx,%eax
  800be4:	01 c0                	add    %eax,%eax
  800be6:	01 d8                	add    %ebx,%eax
  800be8:	83 e8 30             	sub    $0x30,%eax
  800beb:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800bee:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bf2:	0f b6 00             	movzbl (%rax),%eax
  800bf5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bf8:	83 fb 2f             	cmp    $0x2f,%ebx
  800bfb:	7e 0c                	jle    800c09 <vprintfmt+0x105>
  800bfd:	83 fb 39             	cmp    $0x39,%ebx
  800c00:	7f 07                	jg     800c09 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c02:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c07:	eb d1                	jmp    800bda <vprintfmt+0xd6>
			goto process_precision;
  800c09:	eb 58                	jmp    800c63 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800c0b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c0e:	83 f8 30             	cmp    $0x30,%eax
  800c11:	73 17                	jae    800c2a <vprintfmt+0x126>
  800c13:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c17:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c1a:	89 c0                	mov    %eax,%eax
  800c1c:	48 01 d0             	add    %rdx,%rax
  800c1f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c22:	83 c2 08             	add    $0x8,%edx
  800c25:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c28:	eb 0f                	jmp    800c39 <vprintfmt+0x135>
  800c2a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c2e:	48 89 d0             	mov    %rdx,%rax
  800c31:	48 83 c2 08          	add    $0x8,%rdx
  800c35:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c39:	8b 00                	mov    (%rax),%eax
  800c3b:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c3e:	eb 23                	jmp    800c63 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800c40:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c44:	79 0c                	jns    800c52 <vprintfmt+0x14e>
				width = 0;
  800c46:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c4d:	e9 3b ff ff ff       	jmpq   800b8d <vprintfmt+0x89>
  800c52:	e9 36 ff ff ff       	jmpq   800b8d <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c57:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c5e:	e9 2a ff ff ff       	jmpq   800b8d <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800c63:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c67:	79 12                	jns    800c7b <vprintfmt+0x177>
				width = precision, precision = -1;
  800c69:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c6c:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c6f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c76:	e9 12 ff ff ff       	jmpq   800b8d <vprintfmt+0x89>
  800c7b:	e9 0d ff ff ff       	jmpq   800b8d <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c80:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c84:	e9 04 ff ff ff       	jmpq   800b8d <vprintfmt+0x89>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			putch(va_arg(aq, int), putdat);
  800c89:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c8c:	83 f8 30             	cmp    $0x30,%eax
  800c8f:	73 17                	jae    800ca8 <vprintfmt+0x1a4>
  800c91:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c95:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c98:	89 c0                	mov    %eax,%eax
  800c9a:	48 01 d0             	add    %rdx,%rax
  800c9d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ca0:	83 c2 08             	add    $0x8,%edx
  800ca3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ca6:	eb 0f                	jmp    800cb7 <vprintfmt+0x1b3>
  800ca8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cac:	48 89 d0             	mov    %rdx,%rax
  800caf:	48 83 c2 08          	add    $0x8,%rdx
  800cb3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cb7:	8b 10                	mov    (%rax),%edx
  800cb9:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cbd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cc1:	48 89 ce             	mov    %rcx,%rsi
  800cc4:	89 d7                	mov    %edx,%edi
  800cc6:	ff d0                	callq  *%rax
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  800cc8:	e9 40 03 00 00       	jmpq   80100d <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800ccd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cd0:	83 f8 30             	cmp    $0x30,%eax
  800cd3:	73 17                	jae    800cec <vprintfmt+0x1e8>
  800cd5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cd9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cdc:	89 c0                	mov    %eax,%eax
  800cde:	48 01 d0             	add    %rdx,%rax
  800ce1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ce4:	83 c2 08             	add    $0x8,%edx
  800ce7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cea:	eb 0f                	jmp    800cfb <vprintfmt+0x1f7>
  800cec:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cf0:	48 89 d0             	mov    %rdx,%rax
  800cf3:	48 83 c2 08          	add    $0x8,%rdx
  800cf7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cfb:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800cfd:	85 db                	test   %ebx,%ebx
  800cff:	79 02                	jns    800d03 <vprintfmt+0x1ff>
				err = -err;
  800d01:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d03:	83 fb 09             	cmp    $0x9,%ebx
  800d06:	7f 16                	jg     800d1e <vprintfmt+0x21a>
  800d08:	48 b8 60 1b 80 00 00 	movabs $0x801b60,%rax
  800d0f:	00 00 00 
  800d12:	48 63 d3             	movslq %ebx,%rdx
  800d15:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800d19:	4d 85 e4             	test   %r12,%r12
  800d1c:	75 2e                	jne    800d4c <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800d1e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d22:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d26:	89 d9                	mov    %ebx,%ecx
  800d28:	48 ba c1 1b 80 00 00 	movabs $0x801bc1,%rdx
  800d2f:	00 00 00 
  800d32:	48 89 c7             	mov    %rax,%rdi
  800d35:	b8 00 00 00 00       	mov    $0x0,%eax
  800d3a:	49 b8 1c 10 80 00 00 	movabs $0x80101c,%r8
  800d41:	00 00 00 
  800d44:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d47:	e9 c1 02 00 00       	jmpq   80100d <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d4c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d50:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d54:	4c 89 e1             	mov    %r12,%rcx
  800d57:	48 ba ca 1b 80 00 00 	movabs $0x801bca,%rdx
  800d5e:	00 00 00 
  800d61:	48 89 c7             	mov    %rax,%rdi
  800d64:	b8 00 00 00 00       	mov    $0x0,%eax
  800d69:	49 b8 1c 10 80 00 00 	movabs $0x80101c,%r8
  800d70:	00 00 00 
  800d73:	41 ff d0             	callq  *%r8
			break;
  800d76:	e9 92 02 00 00       	jmpq   80100d <vprintfmt+0x509>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
  800d7b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d7e:	83 f8 30             	cmp    $0x30,%eax
  800d81:	73 17                	jae    800d9a <vprintfmt+0x296>
  800d83:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d87:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d8a:	89 c0                	mov    %eax,%eax
  800d8c:	48 01 d0             	add    %rdx,%rax
  800d8f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d92:	83 c2 08             	add    $0x8,%edx
  800d95:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d98:	eb 0f                	jmp    800da9 <vprintfmt+0x2a5>
  800d9a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d9e:	48 89 d0             	mov    %rdx,%rax
  800da1:	48 83 c2 08          	add    $0x8,%rdx
  800da5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800da9:	4c 8b 20             	mov    (%rax),%r12
  800dac:	4d 85 e4             	test   %r12,%r12
  800daf:	75 0a                	jne    800dbb <vprintfmt+0x2b7>
				p = "(null)";
  800db1:	49 bc cd 1b 80 00 00 	movabs $0x801bcd,%r12
  800db8:	00 00 00 
			if (width > 0 && padc != '-')
  800dbb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dbf:	7e 3f                	jle    800e00 <vprintfmt+0x2fc>
  800dc1:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800dc5:	74 39                	je     800e00 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dc7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800dca:	48 98                	cltq   
  800dcc:	48 89 c6             	mov    %rax,%rsi
  800dcf:	4c 89 e7             	mov    %r12,%rdi
  800dd2:	48 b8 c8 12 80 00 00 	movabs $0x8012c8,%rax
  800dd9:	00 00 00 
  800ddc:	ff d0                	callq  *%rax
  800dde:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800de1:	eb 17                	jmp    800dfa <vprintfmt+0x2f6>
					putch(padc, putdat);
  800de3:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800de7:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800deb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800def:	48 89 ce             	mov    %rcx,%rsi
  800df2:	89 d7                	mov    %edx,%edi
  800df4:	ff d0                	callq  *%rax
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800df6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800dfa:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dfe:	7f e3                	jg     800de3 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e00:	eb 37                	jmp    800e39 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800e02:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800e06:	74 1e                	je     800e26 <vprintfmt+0x322>
  800e08:	83 fb 1f             	cmp    $0x1f,%ebx
  800e0b:	7e 05                	jle    800e12 <vprintfmt+0x30e>
  800e0d:	83 fb 7e             	cmp    $0x7e,%ebx
  800e10:	7e 14                	jle    800e26 <vprintfmt+0x322>
					putch('?', putdat);
  800e12:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e16:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e1a:	48 89 d6             	mov    %rdx,%rsi
  800e1d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e22:	ff d0                	callq  *%rax
  800e24:	eb 0f                	jmp    800e35 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800e26:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e2a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e2e:	48 89 d6             	mov    %rdx,%rsi
  800e31:	89 df                	mov    %ebx,%edi
  800e33:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e35:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e39:	4c 89 e0             	mov    %r12,%rax
  800e3c:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e40:	0f b6 00             	movzbl (%rax),%eax
  800e43:	0f be d8             	movsbl %al,%ebx
  800e46:	85 db                	test   %ebx,%ebx
  800e48:	74 10                	je     800e5a <vprintfmt+0x356>
  800e4a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e4e:	78 b2                	js     800e02 <vprintfmt+0x2fe>
  800e50:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e54:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e58:	79 a8                	jns    800e02 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e5a:	eb 16                	jmp    800e72 <vprintfmt+0x36e>
				putch(' ', putdat);
  800e5c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e60:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e64:	48 89 d6             	mov    %rdx,%rsi
  800e67:	bf 20 00 00 00       	mov    $0x20,%edi
  800e6c:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e6e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e72:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e76:	7f e4                	jg     800e5c <vprintfmt+0x358>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  800e78:	e9 90 01 00 00       	jmpq   80100d <vprintfmt+0x509>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getint(&aq, 3);
  800e7d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e81:	be 03 00 00 00       	mov    $0x3,%esi
  800e86:	48 89 c7             	mov    %rax,%rdi
  800e89:	48 b8 f4 09 80 00 00 	movabs $0x8009f4,%rax
  800e90:	00 00 00 
  800e93:	ff d0                	callq  *%rax
  800e95:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e9d:	48 85 c0             	test   %rax,%rax
  800ea0:	79 1d                	jns    800ebf <vprintfmt+0x3bb>
				putch('-', putdat);
  800ea2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ea6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eaa:	48 89 d6             	mov    %rdx,%rsi
  800ead:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800eb2:	ff d0                	callq  *%rax
				num = -(long long) num;
  800eb4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eb8:	48 f7 d8             	neg    %rax
  800ebb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800ebf:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ec6:	e9 d5 00 00 00       	jmpq   800fa0 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			
			num = getuint(&aq, 3);
  800ecb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ecf:	be 03 00 00 00       	mov    $0x3,%esi
  800ed4:	48 89 c7             	mov    %rax,%rdi
  800ed7:	48 b8 e4 08 80 00 00 	movabs $0x8008e4,%rax
  800ede:	00 00 00 
  800ee1:	ff d0                	callq  *%rax
  800ee3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ee7:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800eee:	e9 ad 00 00 00       	jmpq   800fa0 <vprintfmt+0x49c>
                  ch = *(unsigned char *) color;
                }
#endif

			// Replace this with your code.
		        num = getuint(&aq, 3);
  800ef3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ef7:	be 03 00 00 00       	mov    $0x3,%esi
  800efc:	48 89 c7             	mov    %rax,%rdi
  800eff:	48 b8 e4 08 80 00 00 	movabs $0x8008e4,%rax
  800f06:	00 00 00 
  800f09:	ff d0                	callq  *%rax
  800f0b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800f0f:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800f16:	e9 85 00 00 00       	jmpq   800fa0 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			putch('0', putdat);
  800f1b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f1f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f23:	48 89 d6             	mov    %rdx,%rsi
  800f26:	bf 30 00 00 00       	mov    $0x30,%edi
  800f2b:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f2d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f31:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f35:	48 89 d6             	mov    %rdx,%rsi
  800f38:	bf 78 00 00 00       	mov    $0x78,%edi
  800f3d:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f3f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f42:	83 f8 30             	cmp    $0x30,%eax
  800f45:	73 17                	jae    800f5e <vprintfmt+0x45a>
  800f47:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f4b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f4e:	89 c0                	mov    %eax,%eax
  800f50:	48 01 d0             	add    %rdx,%rax
  800f53:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f56:	83 c2 08             	add    $0x8,%edx
  800f59:	89 55 b8             	mov    %edx,-0x48(%rbp)
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f5c:	eb 0f                	jmp    800f6d <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800f5e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f62:	48 89 d0             	mov    %rdx,%rax
  800f65:	48 83 c2 08          	add    $0x8,%rdx
  800f69:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f6d:	48 8b 00             	mov    (%rax),%rax
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f70:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f74:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f7b:	eb 23                	jmp    800fa0 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getuint(&aq, 3);
  800f7d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f81:	be 03 00 00 00       	mov    $0x3,%esi
  800f86:	48 89 c7             	mov    %rax,%rdi
  800f89:	48 b8 e4 08 80 00 00 	movabs $0x8008e4,%rax
  800f90:	00 00 00 
  800f93:	ff d0                	callq  *%rax
  800f95:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f99:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:

			printnum(putch, putdat, num, base, width, padc);
  800fa0:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800fa5:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800fa8:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800fab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800faf:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800fb3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fb7:	45 89 c1             	mov    %r8d,%r9d
  800fba:	41 89 f8             	mov    %edi,%r8d
  800fbd:	48 89 c7             	mov    %rax,%rdi
  800fc0:	48 b8 29 08 80 00 00 	movabs $0x800829,%rax
  800fc7:	00 00 00 
  800fca:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			break;
  800fcc:	eb 3f                	jmp    80100d <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fce:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fd2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fd6:	48 89 d6             	mov    %rdx,%rsi
  800fd9:	89 df                	mov    %ebx,%edi
  800fdb:	ff d0                	callq  *%rax
			break;
  800fdd:	eb 2e                	jmp    80100d <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fdf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fe3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fe7:	48 89 d6             	mov    %rdx,%rsi
  800fea:	bf 25 00 00 00       	mov    $0x25,%edi
  800fef:	ff d0                	callq  *%rax

			for (fmt--; fmt[-1] != '%'; fmt--)
  800ff1:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ff6:	eb 05                	jmp    800ffd <vprintfmt+0x4f9>
  800ff8:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ffd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801001:	48 83 e8 01          	sub    $0x1,%rax
  801005:	0f b6 00             	movzbl (%rax),%eax
  801008:	3c 25                	cmp    $0x25,%al
  80100a:	75 ec                	jne    800ff8 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  80100c:	90                   	nop
		}
	}
  80100d:	90                   	nop
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80100e:	e9 43 fb ff ff       	jmpq   800b56 <vprintfmt+0x52>
			break;
		}
	}
    
va_end(aq);
}
  801013:	48 83 c4 60          	add    $0x60,%rsp
  801017:	5b                   	pop    %rbx
  801018:	41 5c                	pop    %r12
  80101a:	5d                   	pop    %rbp
  80101b:	c3                   	retq   

000000000080101c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80101c:	55                   	push   %rbp
  80101d:	48 89 e5             	mov    %rsp,%rbp
  801020:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801027:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80102e:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801035:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80103c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801043:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80104a:	84 c0                	test   %al,%al
  80104c:	74 20                	je     80106e <printfmt+0x52>
  80104e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801052:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801056:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80105a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80105e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801062:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801066:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80106a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80106e:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801075:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80107c:	00 00 00 
  80107f:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801086:	00 00 00 
  801089:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80108d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801094:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80109b:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8010a2:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8010a9:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8010b0:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8010b7:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8010be:	48 89 c7             	mov    %rax,%rdi
  8010c1:	48 b8 04 0b 80 00 00 	movabs $0x800b04,%rax
  8010c8:	00 00 00 
  8010cb:	ff d0                	callq  *%rax
	va_end(ap);
}
  8010cd:	c9                   	leaveq 
  8010ce:	c3                   	retq   

00000000008010cf <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010cf:	55                   	push   %rbp
  8010d0:	48 89 e5             	mov    %rsp,%rbp
  8010d3:	48 83 ec 10          	sub    $0x10,%rsp
  8010d7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010da:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e2:	8b 40 10             	mov    0x10(%rax),%eax
  8010e5:	8d 50 01             	lea    0x1(%rax),%edx
  8010e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ec:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8010ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010f3:	48 8b 10             	mov    (%rax),%rdx
  8010f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010fa:	48 8b 40 08          	mov    0x8(%rax),%rax
  8010fe:	48 39 c2             	cmp    %rax,%rdx
  801101:	73 17                	jae    80111a <sprintputch+0x4b>
		*b->buf++ = ch;
  801103:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801107:	48 8b 00             	mov    (%rax),%rax
  80110a:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80110e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801112:	48 89 0a             	mov    %rcx,(%rdx)
  801115:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801118:	88 10                	mov    %dl,(%rax)
}
  80111a:	c9                   	leaveq 
  80111b:	c3                   	retq   

000000000080111c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80111c:	55                   	push   %rbp
  80111d:	48 89 e5             	mov    %rsp,%rbp
  801120:	48 83 ec 50          	sub    $0x50,%rsp
  801124:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801128:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80112b:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80112f:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801133:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801137:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80113b:	48 8b 0a             	mov    (%rdx),%rcx
  80113e:	48 89 08             	mov    %rcx,(%rax)
  801141:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801145:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801149:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80114d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801151:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801155:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801159:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80115c:	48 98                	cltq   
  80115e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801162:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801166:	48 01 d0             	add    %rdx,%rax
  801169:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80116d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801174:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801179:	74 06                	je     801181 <vsnprintf+0x65>
  80117b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80117f:	7f 07                	jg     801188 <vsnprintf+0x6c>
		return -E_INVAL;
  801181:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801186:	eb 2f                	jmp    8011b7 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801188:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80118c:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801190:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801194:	48 89 c6             	mov    %rax,%rsi
  801197:	48 bf cf 10 80 00 00 	movabs $0x8010cf,%rdi
  80119e:	00 00 00 
  8011a1:	48 b8 04 0b 80 00 00 	movabs $0x800b04,%rax
  8011a8:	00 00 00 
  8011ab:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8011ad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8011b1:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8011b4:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8011b7:	c9                   	leaveq 
  8011b8:	c3                   	retq   

00000000008011b9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011b9:	55                   	push   %rbp
  8011ba:	48 89 e5             	mov    %rsp,%rbp
  8011bd:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8011c4:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8011cb:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8011d1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011d8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011df:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011e6:	84 c0                	test   %al,%al
  8011e8:	74 20                	je     80120a <snprintf+0x51>
  8011ea:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011ee:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011f2:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8011f6:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8011fa:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8011fe:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801202:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801206:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80120a:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801211:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801218:	00 00 00 
  80121b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801222:	00 00 00 
  801225:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801229:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801230:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801237:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80123e:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801245:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80124c:	48 8b 0a             	mov    (%rdx),%rcx
  80124f:	48 89 08             	mov    %rcx,(%rax)
  801252:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801256:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80125a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80125e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801262:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801269:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801270:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801276:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80127d:	48 89 c7             	mov    %rax,%rdi
  801280:	48 b8 1c 11 80 00 00 	movabs $0x80111c,%rax
  801287:	00 00 00 
  80128a:	ff d0                	callq  *%rax
  80128c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801292:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801298:	c9                   	leaveq 
  801299:	c3                   	retq   

000000000080129a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80129a:	55                   	push   %rbp
  80129b:	48 89 e5             	mov    %rsp,%rbp
  80129e:	48 83 ec 18          	sub    $0x18,%rsp
  8012a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8012a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012ad:	eb 09                	jmp    8012b8 <strlen+0x1e>
		n++;
  8012af:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012b3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012bc:	0f b6 00             	movzbl (%rax),%eax
  8012bf:	84 c0                	test   %al,%al
  8012c1:	75 ec                	jne    8012af <strlen+0x15>
		n++;
	return n;
  8012c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012c6:	c9                   	leaveq 
  8012c7:	c3                   	retq   

00000000008012c8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8012c8:	55                   	push   %rbp
  8012c9:	48 89 e5             	mov    %rsp,%rbp
  8012cc:	48 83 ec 20          	sub    $0x20,%rsp
  8012d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012d4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012df:	eb 0e                	jmp    8012ef <strnlen+0x27>
		n++;
  8012e1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012e5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012ea:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8012ef:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8012f4:	74 0b                	je     801301 <strnlen+0x39>
  8012f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012fa:	0f b6 00             	movzbl (%rax),%eax
  8012fd:	84 c0                	test   %al,%al
  8012ff:	75 e0                	jne    8012e1 <strnlen+0x19>
		n++;
	return n;
  801301:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801304:	c9                   	leaveq 
  801305:	c3                   	retq   

0000000000801306 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801306:	55                   	push   %rbp
  801307:	48 89 e5             	mov    %rsp,%rbp
  80130a:	48 83 ec 20          	sub    $0x20,%rsp
  80130e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801312:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801316:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80131a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80131e:	90                   	nop
  80131f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801323:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801327:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80132b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80132f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801333:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801337:	0f b6 12             	movzbl (%rdx),%edx
  80133a:	88 10                	mov    %dl,(%rax)
  80133c:	0f b6 00             	movzbl (%rax),%eax
  80133f:	84 c0                	test   %al,%al
  801341:	75 dc                	jne    80131f <strcpy+0x19>
		/* do nothing */;
	return ret;
  801343:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801347:	c9                   	leaveq 
  801348:	c3                   	retq   

0000000000801349 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801349:	55                   	push   %rbp
  80134a:	48 89 e5             	mov    %rsp,%rbp
  80134d:	48 83 ec 20          	sub    $0x20,%rsp
  801351:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801355:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801359:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80135d:	48 89 c7             	mov    %rax,%rdi
  801360:	48 b8 9a 12 80 00 00 	movabs $0x80129a,%rax
  801367:	00 00 00 
  80136a:	ff d0                	callq  *%rax
  80136c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80136f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801372:	48 63 d0             	movslq %eax,%rdx
  801375:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801379:	48 01 c2             	add    %rax,%rdx
  80137c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801380:	48 89 c6             	mov    %rax,%rsi
  801383:	48 89 d7             	mov    %rdx,%rdi
  801386:	48 b8 06 13 80 00 00 	movabs $0x801306,%rax
  80138d:	00 00 00 
  801390:	ff d0                	callq  *%rax
	return dst;
  801392:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801396:	c9                   	leaveq 
  801397:	c3                   	retq   

0000000000801398 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801398:	55                   	push   %rbp
  801399:	48 89 e5             	mov    %rsp,%rbp
  80139c:	48 83 ec 28          	sub    $0x28,%rsp
  8013a0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013a4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013a8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8013ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013b0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8013b4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8013bb:	00 
  8013bc:	eb 2a                	jmp    8013e8 <strncpy+0x50>
		*dst++ = *src;
  8013be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013c2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013c6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013ca:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013ce:	0f b6 12             	movzbl (%rdx),%edx
  8013d1:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013d7:	0f b6 00             	movzbl (%rax),%eax
  8013da:	84 c0                	test   %al,%al
  8013dc:	74 05                	je     8013e3 <strncpy+0x4b>
			src++;
  8013de:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013e3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ec:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8013f0:	72 cc                	jb     8013be <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8013f6:	c9                   	leaveq 
  8013f7:	c3                   	retq   

00000000008013f8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8013f8:	55                   	push   %rbp
  8013f9:	48 89 e5             	mov    %rsp,%rbp
  8013fc:	48 83 ec 28          	sub    $0x28,%rsp
  801400:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801404:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801408:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80140c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801410:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801414:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801419:	74 3d                	je     801458 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80141b:	eb 1d                	jmp    80143a <strlcpy+0x42>
			*dst++ = *src++;
  80141d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801421:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801425:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801429:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80142d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801431:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801435:	0f b6 12             	movzbl (%rdx),%edx
  801438:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80143a:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80143f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801444:	74 0b                	je     801451 <strlcpy+0x59>
  801446:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80144a:	0f b6 00             	movzbl (%rax),%eax
  80144d:	84 c0                	test   %al,%al
  80144f:	75 cc                	jne    80141d <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801451:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801455:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801458:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80145c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801460:	48 29 c2             	sub    %rax,%rdx
  801463:	48 89 d0             	mov    %rdx,%rax
}
  801466:	c9                   	leaveq 
  801467:	c3                   	retq   

0000000000801468 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801468:	55                   	push   %rbp
  801469:	48 89 e5             	mov    %rsp,%rbp
  80146c:	48 83 ec 10          	sub    $0x10,%rsp
  801470:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801474:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801478:	eb 0a                	jmp    801484 <strcmp+0x1c>
		p++, q++;
  80147a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80147f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801484:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801488:	0f b6 00             	movzbl (%rax),%eax
  80148b:	84 c0                	test   %al,%al
  80148d:	74 12                	je     8014a1 <strcmp+0x39>
  80148f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801493:	0f b6 10             	movzbl (%rax),%edx
  801496:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80149a:	0f b6 00             	movzbl (%rax),%eax
  80149d:	38 c2                	cmp    %al,%dl
  80149f:	74 d9                	je     80147a <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a5:	0f b6 00             	movzbl (%rax),%eax
  8014a8:	0f b6 d0             	movzbl %al,%edx
  8014ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014af:	0f b6 00             	movzbl (%rax),%eax
  8014b2:	0f b6 c0             	movzbl %al,%eax
  8014b5:	29 c2                	sub    %eax,%edx
  8014b7:	89 d0                	mov    %edx,%eax
}
  8014b9:	c9                   	leaveq 
  8014ba:	c3                   	retq   

00000000008014bb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8014bb:	55                   	push   %rbp
  8014bc:	48 89 e5             	mov    %rsp,%rbp
  8014bf:	48 83 ec 18          	sub    $0x18,%rsp
  8014c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014c7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014cb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8014cf:	eb 0f                	jmp    8014e0 <strncmp+0x25>
		n--, p++, q++;
  8014d1:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8014d6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014db:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8014e0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014e5:	74 1d                	je     801504 <strncmp+0x49>
  8014e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014eb:	0f b6 00             	movzbl (%rax),%eax
  8014ee:	84 c0                	test   %al,%al
  8014f0:	74 12                	je     801504 <strncmp+0x49>
  8014f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f6:	0f b6 10             	movzbl (%rax),%edx
  8014f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014fd:	0f b6 00             	movzbl (%rax),%eax
  801500:	38 c2                	cmp    %al,%dl
  801502:	74 cd                	je     8014d1 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801504:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801509:	75 07                	jne    801512 <strncmp+0x57>
		return 0;
  80150b:	b8 00 00 00 00       	mov    $0x0,%eax
  801510:	eb 18                	jmp    80152a <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801512:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801516:	0f b6 00             	movzbl (%rax),%eax
  801519:	0f b6 d0             	movzbl %al,%edx
  80151c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801520:	0f b6 00             	movzbl (%rax),%eax
  801523:	0f b6 c0             	movzbl %al,%eax
  801526:	29 c2                	sub    %eax,%edx
  801528:	89 d0                	mov    %edx,%eax
}
  80152a:	c9                   	leaveq 
  80152b:	c3                   	retq   

000000000080152c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80152c:	55                   	push   %rbp
  80152d:	48 89 e5             	mov    %rsp,%rbp
  801530:	48 83 ec 0c          	sub    $0xc,%rsp
  801534:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801538:	89 f0                	mov    %esi,%eax
  80153a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80153d:	eb 17                	jmp    801556 <strchr+0x2a>
		if (*s == c)
  80153f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801543:	0f b6 00             	movzbl (%rax),%eax
  801546:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801549:	75 06                	jne    801551 <strchr+0x25>
			return (char *) s;
  80154b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80154f:	eb 15                	jmp    801566 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801551:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801556:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155a:	0f b6 00             	movzbl (%rax),%eax
  80155d:	84 c0                	test   %al,%al
  80155f:	75 de                	jne    80153f <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801561:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801566:	c9                   	leaveq 
  801567:	c3                   	retq   

0000000000801568 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801568:	55                   	push   %rbp
  801569:	48 89 e5             	mov    %rsp,%rbp
  80156c:	48 83 ec 0c          	sub    $0xc,%rsp
  801570:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801574:	89 f0                	mov    %esi,%eax
  801576:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801579:	eb 13                	jmp    80158e <strfind+0x26>
		if (*s == c)
  80157b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80157f:	0f b6 00             	movzbl (%rax),%eax
  801582:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801585:	75 02                	jne    801589 <strfind+0x21>
			break;
  801587:	eb 10                	jmp    801599 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801589:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80158e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801592:	0f b6 00             	movzbl (%rax),%eax
  801595:	84 c0                	test   %al,%al
  801597:	75 e2                	jne    80157b <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801599:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80159d:	c9                   	leaveq 
  80159e:	c3                   	retq   

000000000080159f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80159f:	55                   	push   %rbp
  8015a0:	48 89 e5             	mov    %rsp,%rbp
  8015a3:	48 83 ec 18          	sub    $0x18,%rsp
  8015a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015ab:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8015ae:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8015b2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015b7:	75 06                	jne    8015bf <memset+0x20>
		return v;
  8015b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015bd:	eb 69                	jmp    801628 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8015bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c3:	83 e0 03             	and    $0x3,%eax
  8015c6:	48 85 c0             	test   %rax,%rax
  8015c9:	75 48                	jne    801613 <memset+0x74>
  8015cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015cf:	83 e0 03             	and    $0x3,%eax
  8015d2:	48 85 c0             	test   %rax,%rax
  8015d5:	75 3c                	jne    801613 <memset+0x74>
		c &= 0xFF;
  8015d7:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8015de:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015e1:	c1 e0 18             	shl    $0x18,%eax
  8015e4:	89 c2                	mov    %eax,%edx
  8015e6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015e9:	c1 e0 10             	shl    $0x10,%eax
  8015ec:	09 c2                	or     %eax,%edx
  8015ee:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015f1:	c1 e0 08             	shl    $0x8,%eax
  8015f4:	09 d0                	or     %edx,%eax
  8015f6:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8015f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015fd:	48 c1 e8 02          	shr    $0x2,%rax
  801601:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801604:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801608:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80160b:	48 89 d7             	mov    %rdx,%rdi
  80160e:	fc                   	cld    
  80160f:	f3 ab                	rep stos %eax,%es:(%rdi)
  801611:	eb 11                	jmp    801624 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801613:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801617:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80161a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80161e:	48 89 d7             	mov    %rdx,%rdi
  801621:	fc                   	cld    
  801622:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801624:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801628:	c9                   	leaveq 
  801629:	c3                   	retq   

000000000080162a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80162a:	55                   	push   %rbp
  80162b:	48 89 e5             	mov    %rsp,%rbp
  80162e:	48 83 ec 28          	sub    $0x28,%rsp
  801632:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801636:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80163a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80163e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801642:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801646:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80164a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80164e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801652:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801656:	0f 83 88 00 00 00    	jae    8016e4 <memmove+0xba>
  80165c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801660:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801664:	48 01 d0             	add    %rdx,%rax
  801667:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80166b:	76 77                	jbe    8016e4 <memmove+0xba>
		s += n;
  80166d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801671:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801675:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801679:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80167d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801681:	83 e0 03             	and    $0x3,%eax
  801684:	48 85 c0             	test   %rax,%rax
  801687:	75 3b                	jne    8016c4 <memmove+0x9a>
  801689:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80168d:	83 e0 03             	and    $0x3,%eax
  801690:	48 85 c0             	test   %rax,%rax
  801693:	75 2f                	jne    8016c4 <memmove+0x9a>
  801695:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801699:	83 e0 03             	and    $0x3,%eax
  80169c:	48 85 c0             	test   %rax,%rax
  80169f:	75 23                	jne    8016c4 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8016a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016a5:	48 83 e8 04          	sub    $0x4,%rax
  8016a9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016ad:	48 83 ea 04          	sub    $0x4,%rdx
  8016b1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8016b5:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8016b9:	48 89 c7             	mov    %rax,%rdi
  8016bc:	48 89 d6             	mov    %rdx,%rsi
  8016bf:	fd                   	std    
  8016c0:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016c2:	eb 1d                	jmp    8016e1 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8016c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016d0:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8016d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d8:	48 89 d7             	mov    %rdx,%rdi
  8016db:	48 89 c1             	mov    %rax,%rcx
  8016de:	fd                   	std    
  8016df:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8016e1:	fc                   	cld    
  8016e2:	eb 57                	jmp    80173b <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016e8:	83 e0 03             	and    $0x3,%eax
  8016eb:	48 85 c0             	test   %rax,%rax
  8016ee:	75 36                	jne    801726 <memmove+0xfc>
  8016f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f4:	83 e0 03             	and    $0x3,%eax
  8016f7:	48 85 c0             	test   %rax,%rax
  8016fa:	75 2a                	jne    801726 <memmove+0xfc>
  8016fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801700:	83 e0 03             	and    $0x3,%eax
  801703:	48 85 c0             	test   %rax,%rax
  801706:	75 1e                	jne    801726 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801708:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170c:	48 c1 e8 02          	shr    $0x2,%rax
  801710:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801713:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801717:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80171b:	48 89 c7             	mov    %rax,%rdi
  80171e:	48 89 d6             	mov    %rdx,%rsi
  801721:	fc                   	cld    
  801722:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801724:	eb 15                	jmp    80173b <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801726:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80172a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80172e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801732:	48 89 c7             	mov    %rax,%rdi
  801735:	48 89 d6             	mov    %rdx,%rsi
  801738:	fc                   	cld    
  801739:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80173b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80173f:	c9                   	leaveq 
  801740:	c3                   	retq   

0000000000801741 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801741:	55                   	push   %rbp
  801742:	48 89 e5             	mov    %rsp,%rbp
  801745:	48 83 ec 18          	sub    $0x18,%rsp
  801749:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80174d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801751:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801755:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801759:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80175d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801761:	48 89 ce             	mov    %rcx,%rsi
  801764:	48 89 c7             	mov    %rax,%rdi
  801767:	48 b8 2a 16 80 00 00 	movabs $0x80162a,%rax
  80176e:	00 00 00 
  801771:	ff d0                	callq  *%rax
}
  801773:	c9                   	leaveq 
  801774:	c3                   	retq   

0000000000801775 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801775:	55                   	push   %rbp
  801776:	48 89 e5             	mov    %rsp,%rbp
  801779:	48 83 ec 28          	sub    $0x28,%rsp
  80177d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801781:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801785:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801789:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80178d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801791:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801795:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801799:	eb 36                	jmp    8017d1 <memcmp+0x5c>
		if (*s1 != *s2)
  80179b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80179f:	0f b6 10             	movzbl (%rax),%edx
  8017a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017a6:	0f b6 00             	movzbl (%rax),%eax
  8017a9:	38 c2                	cmp    %al,%dl
  8017ab:	74 1a                	je     8017c7 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8017ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017b1:	0f b6 00             	movzbl (%rax),%eax
  8017b4:	0f b6 d0             	movzbl %al,%edx
  8017b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017bb:	0f b6 00             	movzbl (%rax),%eax
  8017be:	0f b6 c0             	movzbl %al,%eax
  8017c1:	29 c2                	sub    %eax,%edx
  8017c3:	89 d0                	mov    %edx,%eax
  8017c5:	eb 20                	jmp    8017e7 <memcmp+0x72>
		s1++, s2++;
  8017c7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017cc:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8017d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d5:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017d9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017dd:	48 85 c0             	test   %rax,%rax
  8017e0:	75 b9                	jne    80179b <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e7:	c9                   	leaveq 
  8017e8:	c3                   	retq   

00000000008017e9 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8017e9:	55                   	push   %rbp
  8017ea:	48 89 e5             	mov    %rsp,%rbp
  8017ed:	48 83 ec 28          	sub    $0x28,%rsp
  8017f1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017f5:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8017f8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8017fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801800:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801804:	48 01 d0             	add    %rdx,%rax
  801807:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80180b:	eb 15                	jmp    801822 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80180d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801811:	0f b6 10             	movzbl (%rax),%edx
  801814:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801817:	38 c2                	cmp    %al,%dl
  801819:	75 02                	jne    80181d <memfind+0x34>
			break;
  80181b:	eb 0f                	jmp    80182c <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80181d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801822:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801826:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80182a:	72 e1                	jb     80180d <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80182c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801830:	c9                   	leaveq 
  801831:	c3                   	retq   

0000000000801832 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801832:	55                   	push   %rbp
  801833:	48 89 e5             	mov    %rsp,%rbp
  801836:	48 83 ec 34          	sub    $0x34,%rsp
  80183a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80183e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801842:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801845:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80184c:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801853:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801854:	eb 05                	jmp    80185b <strtol+0x29>
		s++;
  801856:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80185b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185f:	0f b6 00             	movzbl (%rax),%eax
  801862:	3c 20                	cmp    $0x20,%al
  801864:	74 f0                	je     801856 <strtol+0x24>
  801866:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80186a:	0f b6 00             	movzbl (%rax),%eax
  80186d:	3c 09                	cmp    $0x9,%al
  80186f:	74 e5                	je     801856 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801871:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801875:	0f b6 00             	movzbl (%rax),%eax
  801878:	3c 2b                	cmp    $0x2b,%al
  80187a:	75 07                	jne    801883 <strtol+0x51>
		s++;
  80187c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801881:	eb 17                	jmp    80189a <strtol+0x68>
	else if (*s == '-')
  801883:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801887:	0f b6 00             	movzbl (%rax),%eax
  80188a:	3c 2d                	cmp    $0x2d,%al
  80188c:	75 0c                	jne    80189a <strtol+0x68>
		s++, neg = 1;
  80188e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801893:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80189a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80189e:	74 06                	je     8018a6 <strtol+0x74>
  8018a0:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8018a4:	75 28                	jne    8018ce <strtol+0x9c>
  8018a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018aa:	0f b6 00             	movzbl (%rax),%eax
  8018ad:	3c 30                	cmp    $0x30,%al
  8018af:	75 1d                	jne    8018ce <strtol+0x9c>
  8018b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b5:	48 83 c0 01          	add    $0x1,%rax
  8018b9:	0f b6 00             	movzbl (%rax),%eax
  8018bc:	3c 78                	cmp    $0x78,%al
  8018be:	75 0e                	jne    8018ce <strtol+0x9c>
		s += 2, base = 16;
  8018c0:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8018c5:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8018cc:	eb 2c                	jmp    8018fa <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8018ce:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018d2:	75 19                	jne    8018ed <strtol+0xbb>
  8018d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d8:	0f b6 00             	movzbl (%rax),%eax
  8018db:	3c 30                	cmp    $0x30,%al
  8018dd:	75 0e                	jne    8018ed <strtol+0xbb>
		s++, base = 8;
  8018df:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018e4:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8018eb:	eb 0d                	jmp    8018fa <strtol+0xc8>
	else if (base == 0)
  8018ed:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018f1:	75 07                	jne    8018fa <strtol+0xc8>
		base = 10;
  8018f3:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018fe:	0f b6 00             	movzbl (%rax),%eax
  801901:	3c 2f                	cmp    $0x2f,%al
  801903:	7e 1d                	jle    801922 <strtol+0xf0>
  801905:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801909:	0f b6 00             	movzbl (%rax),%eax
  80190c:	3c 39                	cmp    $0x39,%al
  80190e:	7f 12                	jg     801922 <strtol+0xf0>
			dig = *s - '0';
  801910:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801914:	0f b6 00             	movzbl (%rax),%eax
  801917:	0f be c0             	movsbl %al,%eax
  80191a:	83 e8 30             	sub    $0x30,%eax
  80191d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801920:	eb 4e                	jmp    801970 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801922:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801926:	0f b6 00             	movzbl (%rax),%eax
  801929:	3c 60                	cmp    $0x60,%al
  80192b:	7e 1d                	jle    80194a <strtol+0x118>
  80192d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801931:	0f b6 00             	movzbl (%rax),%eax
  801934:	3c 7a                	cmp    $0x7a,%al
  801936:	7f 12                	jg     80194a <strtol+0x118>
			dig = *s - 'a' + 10;
  801938:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80193c:	0f b6 00             	movzbl (%rax),%eax
  80193f:	0f be c0             	movsbl %al,%eax
  801942:	83 e8 57             	sub    $0x57,%eax
  801945:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801948:	eb 26                	jmp    801970 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80194a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80194e:	0f b6 00             	movzbl (%rax),%eax
  801951:	3c 40                	cmp    $0x40,%al
  801953:	7e 48                	jle    80199d <strtol+0x16b>
  801955:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801959:	0f b6 00             	movzbl (%rax),%eax
  80195c:	3c 5a                	cmp    $0x5a,%al
  80195e:	7f 3d                	jg     80199d <strtol+0x16b>
			dig = *s - 'A' + 10;
  801960:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801964:	0f b6 00             	movzbl (%rax),%eax
  801967:	0f be c0             	movsbl %al,%eax
  80196a:	83 e8 37             	sub    $0x37,%eax
  80196d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801970:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801973:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801976:	7c 02                	jl     80197a <strtol+0x148>
			break;
  801978:	eb 23                	jmp    80199d <strtol+0x16b>
		s++, val = (val * base) + dig;
  80197a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80197f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801982:	48 98                	cltq   
  801984:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801989:	48 89 c2             	mov    %rax,%rdx
  80198c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80198f:	48 98                	cltq   
  801991:	48 01 d0             	add    %rdx,%rax
  801994:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801998:	e9 5d ff ff ff       	jmpq   8018fa <strtol+0xc8>

	if (endptr)
  80199d:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8019a2:	74 0b                	je     8019af <strtol+0x17d>
		*endptr = (char *) s;
  8019a4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019a8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8019ac:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8019af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019b3:	74 09                	je     8019be <strtol+0x18c>
  8019b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019b9:	48 f7 d8             	neg    %rax
  8019bc:	eb 04                	jmp    8019c2 <strtol+0x190>
  8019be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019c2:	c9                   	leaveq 
  8019c3:	c3                   	retq   

00000000008019c4 <strstr>:

char * strstr(const char *in, const char *str)
{
  8019c4:	55                   	push   %rbp
  8019c5:	48 89 e5             	mov    %rsp,%rbp
  8019c8:	48 83 ec 30          	sub    $0x30,%rsp
  8019cc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019d0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8019d4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019d8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019dc:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019e0:	0f b6 00             	movzbl (%rax),%eax
  8019e3:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8019e6:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8019ea:	75 06                	jne    8019f2 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  8019ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019f0:	eb 6b                	jmp    801a5d <strstr+0x99>

    len = strlen(str);
  8019f2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019f6:	48 89 c7             	mov    %rax,%rdi
  8019f9:	48 b8 9a 12 80 00 00 	movabs $0x80129a,%rax
  801a00:	00 00 00 
  801a03:	ff d0                	callq  *%rax
  801a05:	48 98                	cltq   
  801a07:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801a0b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a0f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a13:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801a17:	0f b6 00             	movzbl (%rax),%eax
  801a1a:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801a1d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801a21:	75 07                	jne    801a2a <strstr+0x66>
                return (char *) 0;
  801a23:	b8 00 00 00 00       	mov    $0x0,%eax
  801a28:	eb 33                	jmp    801a5d <strstr+0x99>
        } while (sc != c);
  801a2a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801a2e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a31:	75 d8                	jne    801a0b <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801a33:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a37:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801a3b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a3f:	48 89 ce             	mov    %rcx,%rsi
  801a42:	48 89 c7             	mov    %rax,%rdi
  801a45:	48 b8 bb 14 80 00 00 	movabs $0x8014bb,%rax
  801a4c:	00 00 00 
  801a4f:	ff d0                	callq  *%rax
  801a51:	85 c0                	test   %eax,%eax
  801a53:	75 b6                	jne    801a0b <strstr+0x47>

    return (char *) (in - 1);
  801a55:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a59:	48 83 e8 01          	sub    $0x1,%rax
}
  801a5d:	c9                   	leaveq 
  801a5e:	c3                   	retq   
