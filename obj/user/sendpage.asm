
obj/user/sendpage:     file format elf64-x86-64


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
  80003c:	e8 66 02 00 00       	callq  8002a7 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#define TEMP_ADDR	((char*)0xa00000)
#define TEMP_ADDR_CHILD	((char*)0xb00000)

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	envid_t who;

	if ((who = fork()) == 0) {
  800052:	48 b8 2e 1f 80 00 00 	movabs $0x801f2e,%rax
  800059:	00 00 00 
  80005c:	ff d0                	callq  *%rax
  80005e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800061:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800064:	85 c0                	test   %eax,%eax
  800066:	0f 85 09 01 00 00    	jne    800175 <umain+0x132>
		// Child
		ipc_recv(&who, TEMP_ADDR_CHILD, 0);
  80006c:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
  800070:	ba 00 00 00 00       	mov    $0x0,%edx
  800075:	be 00 00 b0 00       	mov    $0xb00000,%esi
  80007a:	48 89 c7             	mov    %rax,%rdi
  80007d:	48 b8 ab 21 80 00 00 	movabs $0x8021ab,%rax
  800084:	00 00 00 
  800087:	ff d0                	callq  *%rax
		cprintf("%x got message : %s\n", who, TEMP_ADDR_CHILD);
  800089:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80008c:	ba 00 00 b0 00       	mov    $0xb00000,%edx
  800091:	89 c6                	mov    %eax,%esi
  800093:	48 bf 2c 26 80 00 00 	movabs $0x80262c,%rdi
  80009a:	00 00 00 
  80009d:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a2:	48 b9 87 04 80 00 00 	movabs $0x800487,%rcx
  8000a9:	00 00 00 
  8000ac:	ff d1                	callq  *%rcx
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  8000ae:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8000b5:	00 00 00 
  8000b8:	48 8b 00             	mov    (%rax),%rax
  8000bb:	48 89 c7             	mov    %rax,%rdi
  8000be:	48 b8 d0 0f 80 00 00 	movabs $0x800fd0,%rax
  8000c5:	00 00 00 
  8000c8:	ff d0                	callq  *%rax
  8000ca:	48 63 d0             	movslq %eax,%rdx
  8000cd:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8000d4:	00 00 00 
  8000d7:	48 8b 00             	mov    (%rax),%rax
  8000da:	48 89 c6             	mov    %rax,%rsi
  8000dd:	bf 00 00 b0 00       	mov    $0xb00000,%edi
  8000e2:	48 b8 f1 11 80 00 00 	movabs $0x8011f1,%rax
  8000e9:	00 00 00 
  8000ec:	ff d0                	callq  *%rax
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	75 1b                	jne    80010d <umain+0xca>
			cprintf("child received correct message\n");
  8000f2:	48 bf 48 26 80 00 00 	movabs $0x802648,%rdi
  8000f9:	00 00 00 
  8000fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800101:	48 ba 87 04 80 00 00 	movabs $0x800487,%rdx
  800108:	00 00 00 
  80010b:	ff d2                	callq  *%rdx

		memcpy(TEMP_ADDR_CHILD, str2, strlen(str1) + 1);
  80010d:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  800114:	00 00 00 
  800117:	48 8b 00             	mov    (%rax),%rax
  80011a:	48 89 c7             	mov    %rax,%rdi
  80011d:	48 b8 d0 0f 80 00 00 	movabs $0x800fd0,%rax
  800124:	00 00 00 
  800127:	ff d0                	callq  *%rax
  800129:	83 c0 01             	add    $0x1,%eax
  80012c:	48 63 d0             	movslq %eax,%rdx
  80012f:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  800136:	00 00 00 
  800139:	48 8b 00             	mov    (%rax),%rax
  80013c:	48 89 c6             	mov    %rax,%rsi
  80013f:	bf 00 00 b0 00       	mov    $0xb00000,%edi
  800144:	48 b8 77 14 80 00 00 	movabs $0x801477,%rax
  80014b:	00 00 00 
  80014e:	ff d0                	callq  *%rax
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  800150:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800153:	b9 07 00 00 00       	mov    $0x7,%ecx
  800158:	ba 00 00 b0 00       	mov    $0xb00000,%edx
  80015d:	be 00 00 00 00       	mov    $0x0,%esi
  800162:	89 c7                	mov    %eax,%edi
  800164:	48 b8 6c 22 80 00 00 	movabs $0x80226c,%rax
  80016b:	00 00 00 
  80016e:	ff d0                	callq  *%rax
		return;
  800170:	e9 30 01 00 00       	jmpq   8002a5 <umain+0x262>
	}

	// Parent
	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800175:	48 b8 18 40 80 00 00 	movabs $0x804018,%rax
  80017c:	00 00 00 
  80017f:	48 8b 00             	mov    (%rax),%rax
  800182:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800188:	ba 07 00 00 00       	mov    $0x7,%edx
  80018d:	be 00 00 a0 00       	mov    $0xa00000,%esi
  800192:	89 c7                	mov    %eax,%edi
  800194:	48 b8 6b 19 80 00 00 	movabs $0x80196b,%rax
  80019b:	00 00 00 
  80019e:	ff d0                	callq  *%rax
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  8001a0:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8001a7:	00 00 00 
  8001aa:	48 8b 00             	mov    (%rax),%rax
  8001ad:	48 89 c7             	mov    %rax,%rdi
  8001b0:	48 b8 d0 0f 80 00 00 	movabs $0x800fd0,%rax
  8001b7:	00 00 00 
  8001ba:	ff d0                	callq  *%rax
  8001bc:	83 c0 01             	add    $0x1,%eax
  8001bf:	48 63 d0             	movslq %eax,%rdx
  8001c2:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8001c9:	00 00 00 
  8001cc:	48 8b 00             	mov    (%rax),%rax
  8001cf:	48 89 c6             	mov    %rax,%rsi
  8001d2:	bf 00 00 a0 00       	mov    $0xa00000,%edi
  8001d7:	48 b8 77 14 80 00 00 	movabs $0x801477,%rax
  8001de:	00 00 00 
  8001e1:	ff d0                	callq  *%rax
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  8001e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001e6:	b9 07 00 00 00       	mov    $0x7,%ecx
  8001eb:	ba 00 00 a0 00       	mov    $0xa00000,%edx
  8001f0:	be 00 00 00 00       	mov    $0x0,%esi
  8001f5:	89 c7                	mov    %eax,%edi
  8001f7:	48 b8 6c 22 80 00 00 	movabs $0x80226c,%rax
  8001fe:	00 00 00 
  800201:	ff d0                	callq  *%rax

	ipc_recv(&who, TEMP_ADDR, 0);
  800203:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
  800207:	ba 00 00 00 00       	mov    $0x0,%edx
  80020c:	be 00 00 a0 00       	mov    $0xa00000,%esi
  800211:	48 89 c7             	mov    %rax,%rdi
  800214:	48 b8 ab 21 80 00 00 	movabs $0x8021ab,%rax
  80021b:	00 00 00 
  80021e:	ff d0                	callq  *%rax
	cprintf("%x got message : %s\n", who, TEMP_ADDR);
  800220:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800223:	ba 00 00 a0 00       	mov    $0xa00000,%edx
  800228:	89 c6                	mov    %eax,%esi
  80022a:	48 bf 2c 26 80 00 00 	movabs $0x80262c,%rdi
  800231:	00 00 00 
  800234:	b8 00 00 00 00       	mov    $0x0,%eax
  800239:	48 b9 87 04 80 00 00 	movabs $0x800487,%rcx
  800240:	00 00 00 
  800243:	ff d1                	callq  *%rcx
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  800245:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  80024c:	00 00 00 
  80024f:	48 8b 00             	mov    (%rax),%rax
  800252:	48 89 c7             	mov    %rax,%rdi
  800255:	48 b8 d0 0f 80 00 00 	movabs $0x800fd0,%rax
  80025c:	00 00 00 
  80025f:	ff d0                	callq  *%rax
  800261:	48 63 d0             	movslq %eax,%rdx
  800264:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  80026b:	00 00 00 
  80026e:	48 8b 00             	mov    (%rax),%rax
  800271:	48 89 c6             	mov    %rax,%rsi
  800274:	bf 00 00 a0 00       	mov    $0xa00000,%edi
  800279:	48 b8 f1 11 80 00 00 	movabs $0x8011f1,%rax
  800280:	00 00 00 
  800283:	ff d0                	callq  *%rax
  800285:	85 c0                	test   %eax,%eax
  800287:	75 1b                	jne    8002a4 <umain+0x261>
		cprintf("parent received correct message\n");
  800289:	48 bf 68 26 80 00 00 	movabs $0x802668,%rdi
  800290:	00 00 00 
  800293:	b8 00 00 00 00       	mov    $0x0,%eax
  800298:	48 ba 87 04 80 00 00 	movabs $0x800487,%rdx
  80029f:	00 00 00 
  8002a2:	ff d2                	callq  *%rdx
	return;
  8002a4:	90                   	nop
}
  8002a5:	c9                   	leaveq 
  8002a6:	c3                   	retq   

00000000008002a7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002a7:	55                   	push   %rbp
  8002a8:	48 89 e5             	mov    %rsp,%rbp
  8002ab:	48 83 ec 20          	sub    $0x20,%rsp
  8002af:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8002b2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8002b6:	48 b8 18 40 80 00 00 	movabs $0x804018,%rax
  8002bd:	00 00 00 
  8002c0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	envid_t id = sys_getenvid();
  8002c7:	48 b8 ef 18 80 00 00 	movabs $0x8018ef,%rax
  8002ce:	00 00 00 
  8002d1:	ff d0                	callq  *%rax
  8002d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
        id = ENVX(id);
  8002d6:	81 65 fc ff 03 00 00 	andl   $0x3ff,-0x4(%rbp)
	thisenv = &envs[id];
  8002dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002e0:	48 63 d0             	movslq %eax,%rdx
  8002e3:	48 89 d0             	mov    %rdx,%rax
  8002e6:	48 c1 e0 03          	shl    $0x3,%rax
  8002ea:	48 01 d0             	add    %rdx,%rax
  8002ed:	48 c1 e0 05          	shl    $0x5,%rax
  8002f1:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8002f8:	00 00 00 
  8002fb:	48 01 c2             	add    %rax,%rdx
  8002fe:	48 b8 18 40 80 00 00 	movabs $0x804018,%rax
  800305:	00 00 00 
  800308:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80030b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80030f:	7e 14                	jle    800325 <libmain+0x7e>
		binaryname = argv[0];
  800311:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800315:	48 8b 10             	mov    (%rax),%rdx
  800318:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  80031f:	00 00 00 
  800322:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800325:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800329:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80032c:	48 89 d6             	mov    %rdx,%rsi
  80032f:	89 c7                	mov    %eax,%edi
  800331:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800338:	00 00 00 
  80033b:	ff d0                	callq  *%rax
	
	//cprintf("\noutside\n");
	// exit gracefully
	exit();
  80033d:	48 b8 4b 03 80 00 00 	movabs $0x80034b,%rax
  800344:	00 00 00 
  800347:	ff d0                	callq  *%rax
}
  800349:	c9                   	leaveq 
  80034a:	c3                   	retq   

000000000080034b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80034b:	55                   	push   %rbp
  80034c:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  80034f:	bf 00 00 00 00       	mov    $0x0,%edi
  800354:	48 b8 ab 18 80 00 00 	movabs $0x8018ab,%rax
  80035b:	00 00 00 
  80035e:	ff d0                	callq  *%rax
}
  800360:	5d                   	pop    %rbp
  800361:	c3                   	retq   

0000000000800362 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800362:	55                   	push   %rbp
  800363:	48 89 e5             	mov    %rsp,%rbp
  800366:	48 83 ec 10          	sub    $0x10,%rsp
  80036a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80036d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800371:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800375:	8b 00                	mov    (%rax),%eax
  800377:	8d 48 01             	lea    0x1(%rax),%ecx
  80037a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80037e:	89 0a                	mov    %ecx,(%rdx)
  800380:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800383:	89 d1                	mov    %edx,%ecx
  800385:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800389:	48 98                	cltq   
  80038b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  80038f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800393:	8b 00                	mov    (%rax),%eax
  800395:	3d ff 00 00 00       	cmp    $0xff,%eax
  80039a:	75 2c                	jne    8003c8 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  80039c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a0:	8b 00                	mov    (%rax),%eax
  8003a2:	48 98                	cltq   
  8003a4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003a8:	48 83 c2 08          	add    $0x8,%rdx
  8003ac:	48 89 c6             	mov    %rax,%rsi
  8003af:	48 89 d7             	mov    %rdx,%rdi
  8003b2:	48 b8 23 18 80 00 00 	movabs $0x801823,%rax
  8003b9:	00 00 00 
  8003bc:	ff d0                	callq  *%rax
		b->idx = 0;
  8003be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8003c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003cc:	8b 40 04             	mov    0x4(%rax),%eax
  8003cf:	8d 50 01             	lea    0x1(%rax),%edx
  8003d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d6:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003d9:	c9                   	leaveq 
  8003da:	c3                   	retq   

00000000008003db <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003db:	55                   	push   %rbp
  8003dc:	48 89 e5             	mov    %rsp,%rbp
  8003df:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003e6:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003ed:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8003f4:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8003fb:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800402:	48 8b 0a             	mov    (%rdx),%rcx
  800405:	48 89 08             	mov    %rcx,(%rax)
  800408:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80040c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800410:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800414:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800418:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80041f:	00 00 00 
	b.cnt = 0;
  800422:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800429:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  80042c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800433:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80043a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800441:	48 89 c6             	mov    %rax,%rsi
  800444:	48 bf 62 03 80 00 00 	movabs $0x800362,%rdi
  80044b:	00 00 00 
  80044e:	48 b8 3a 08 80 00 00 	movabs $0x80083a,%rax
  800455:	00 00 00 
  800458:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  80045a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800460:	48 98                	cltq   
  800462:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800469:	48 83 c2 08          	add    $0x8,%rdx
  80046d:	48 89 c6             	mov    %rax,%rsi
  800470:	48 89 d7             	mov    %rdx,%rdi
  800473:	48 b8 23 18 80 00 00 	movabs $0x801823,%rax
  80047a:	00 00 00 
  80047d:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80047f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800485:	c9                   	leaveq 
  800486:	c3                   	retq   

0000000000800487 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800487:	55                   	push   %rbp
  800488:	48 89 e5             	mov    %rsp,%rbp
  80048b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800492:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800499:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004a0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004a7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004ae:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004b5:	84 c0                	test   %al,%al
  8004b7:	74 20                	je     8004d9 <cprintf+0x52>
  8004b9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004bd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004c1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004c5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004c9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004cd:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004d1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004d5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004d9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8004e0:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004e7:	00 00 00 
  8004ea:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004f1:	00 00 00 
  8004f4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004f8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8004ff:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800506:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80050d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800514:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80051b:	48 8b 0a             	mov    (%rdx),%rcx
  80051e:	48 89 08             	mov    %rcx,(%rax)
  800521:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800525:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800529:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80052d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800531:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800538:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80053f:	48 89 d6             	mov    %rdx,%rsi
  800542:	48 89 c7             	mov    %rax,%rdi
  800545:	48 b8 db 03 80 00 00 	movabs $0x8003db,%rax
  80054c:	00 00 00 
  80054f:	ff d0                	callq  *%rax
  800551:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800557:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80055d:	c9                   	leaveq 
  80055e:	c3                   	retq   

000000000080055f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80055f:	55                   	push   %rbp
  800560:	48 89 e5             	mov    %rsp,%rbp
  800563:	53                   	push   %rbx
  800564:	48 83 ec 38          	sub    $0x38,%rsp
  800568:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80056c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800570:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800574:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800577:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80057b:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80057f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800582:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800586:	77 3b                	ja     8005c3 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800588:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80058b:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80058f:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800592:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800596:	ba 00 00 00 00       	mov    $0x0,%edx
  80059b:	48 f7 f3             	div    %rbx
  80059e:	48 89 c2             	mov    %rax,%rdx
  8005a1:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005a4:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005a7:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005af:	41 89 f9             	mov    %edi,%r9d
  8005b2:	48 89 c7             	mov    %rax,%rdi
  8005b5:	48 b8 5f 05 80 00 00 	movabs $0x80055f,%rax
  8005bc:	00 00 00 
  8005bf:	ff d0                	callq  *%rax
  8005c1:	eb 1e                	jmp    8005e1 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005c3:	eb 12                	jmp    8005d7 <printnum+0x78>
			putch(padc, putdat);
  8005c5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005c9:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d0:	48 89 ce             	mov    %rcx,%rsi
  8005d3:	89 d7                	mov    %edx,%edi
  8005d5:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005d7:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8005db:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8005df:	7f e4                	jg     8005c5 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005e1:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ed:	48 f7 f1             	div    %rcx
  8005f0:	48 89 d0             	mov    %rdx,%rax
  8005f3:	48 ba 90 27 80 00 00 	movabs $0x802790,%rdx
  8005fa:	00 00 00 
  8005fd:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800601:	0f be d0             	movsbl %al,%edx
  800604:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800608:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80060c:	48 89 ce             	mov    %rcx,%rsi
  80060f:	89 d7                	mov    %edx,%edi
  800611:	ff d0                	callq  *%rax
}
  800613:	48 83 c4 38          	add    $0x38,%rsp
  800617:	5b                   	pop    %rbx
  800618:	5d                   	pop    %rbp
  800619:	c3                   	retq   

000000000080061a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80061a:	55                   	push   %rbp
  80061b:	48 89 e5             	mov    %rsp,%rbp
  80061e:	48 83 ec 1c          	sub    $0x1c,%rsp
  800622:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800626:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800629:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80062d:	7e 52                	jle    800681 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80062f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800633:	8b 00                	mov    (%rax),%eax
  800635:	83 f8 30             	cmp    $0x30,%eax
  800638:	73 24                	jae    80065e <getuint+0x44>
  80063a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800642:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800646:	8b 00                	mov    (%rax),%eax
  800648:	89 c0                	mov    %eax,%eax
  80064a:	48 01 d0             	add    %rdx,%rax
  80064d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800651:	8b 12                	mov    (%rdx),%edx
  800653:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800656:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065a:	89 0a                	mov    %ecx,(%rdx)
  80065c:	eb 17                	jmp    800675 <getuint+0x5b>
  80065e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800662:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800666:	48 89 d0             	mov    %rdx,%rax
  800669:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80066d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800671:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800675:	48 8b 00             	mov    (%rax),%rax
  800678:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80067c:	e9 a3 00 00 00       	jmpq   800724 <getuint+0x10a>
	else if (lflag)
  800681:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800685:	74 4f                	je     8006d6 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800687:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068b:	8b 00                	mov    (%rax),%eax
  80068d:	83 f8 30             	cmp    $0x30,%eax
  800690:	73 24                	jae    8006b6 <getuint+0x9c>
  800692:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800696:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80069a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069e:	8b 00                	mov    (%rax),%eax
  8006a0:	89 c0                	mov    %eax,%eax
  8006a2:	48 01 d0             	add    %rdx,%rax
  8006a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a9:	8b 12                	mov    (%rdx),%edx
  8006ab:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b2:	89 0a                	mov    %ecx,(%rdx)
  8006b4:	eb 17                	jmp    8006cd <getuint+0xb3>
  8006b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ba:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006be:	48 89 d0             	mov    %rdx,%rax
  8006c1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006cd:	48 8b 00             	mov    (%rax),%rax
  8006d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006d4:	eb 4e                	jmp    800724 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006da:	8b 00                	mov    (%rax),%eax
  8006dc:	83 f8 30             	cmp    $0x30,%eax
  8006df:	73 24                	jae    800705 <getuint+0xeb>
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
  800703:	eb 17                	jmp    80071c <getuint+0x102>
  800705:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800709:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80070d:	48 89 d0             	mov    %rdx,%rax
  800710:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800714:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800718:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80071c:	8b 00                	mov    (%rax),%eax
  80071e:	89 c0                	mov    %eax,%eax
  800720:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800724:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800728:	c9                   	leaveq 
  800729:	c3                   	retq   

000000000080072a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80072a:	55                   	push   %rbp
  80072b:	48 89 e5             	mov    %rsp,%rbp
  80072e:	48 83 ec 1c          	sub    $0x1c,%rsp
  800732:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800736:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800739:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80073d:	7e 52                	jle    800791 <getint+0x67>
		x=va_arg(*ap, long long);
  80073f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800743:	8b 00                	mov    (%rax),%eax
  800745:	83 f8 30             	cmp    $0x30,%eax
  800748:	73 24                	jae    80076e <getint+0x44>
  80074a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800752:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800756:	8b 00                	mov    (%rax),%eax
  800758:	89 c0                	mov    %eax,%eax
  80075a:	48 01 d0             	add    %rdx,%rax
  80075d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800761:	8b 12                	mov    (%rdx),%edx
  800763:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800766:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80076a:	89 0a                	mov    %ecx,(%rdx)
  80076c:	eb 17                	jmp    800785 <getint+0x5b>
  80076e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800772:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800776:	48 89 d0             	mov    %rdx,%rax
  800779:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80077d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800781:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800785:	48 8b 00             	mov    (%rax),%rax
  800788:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80078c:	e9 a3 00 00 00       	jmpq   800834 <getint+0x10a>
	else if (lflag)
  800791:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800795:	74 4f                	je     8007e6 <getint+0xbc>
		x=va_arg(*ap, long);
  800797:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079b:	8b 00                	mov    (%rax),%eax
  80079d:	83 f8 30             	cmp    $0x30,%eax
  8007a0:	73 24                	jae    8007c6 <getint+0x9c>
  8007a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ae:	8b 00                	mov    (%rax),%eax
  8007b0:	89 c0                	mov    %eax,%eax
  8007b2:	48 01 d0             	add    %rdx,%rax
  8007b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b9:	8b 12                	mov    (%rdx),%edx
  8007bb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c2:	89 0a                	mov    %ecx,(%rdx)
  8007c4:	eb 17                	jmp    8007dd <getint+0xb3>
  8007c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ca:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007ce:	48 89 d0             	mov    %rdx,%rax
  8007d1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007dd:	48 8b 00             	mov    (%rax),%rax
  8007e0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007e4:	eb 4e                	jmp    800834 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8007e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ea:	8b 00                	mov    (%rax),%eax
  8007ec:	83 f8 30             	cmp    $0x30,%eax
  8007ef:	73 24                	jae    800815 <getint+0xeb>
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
  800813:	eb 17                	jmp    80082c <getint+0x102>
  800815:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800819:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80081d:	48 89 d0             	mov    %rdx,%rax
  800820:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800824:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800828:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80082c:	8b 00                	mov    (%rax),%eax
  80082e:	48 98                	cltq   
  800830:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800834:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800838:	c9                   	leaveq 
  800839:	c3                   	retq   

000000000080083a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80083a:	55                   	push   %rbp
  80083b:	48 89 e5             	mov    %rsp,%rbp
  80083e:	41 54                	push   %r12
  800840:	53                   	push   %rbx
  800841:	48 83 ec 60          	sub    $0x60,%rsp
  800845:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800849:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80084d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800851:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800855:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800859:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80085d:	48 8b 0a             	mov    (%rdx),%rcx
  800860:	48 89 08             	mov    %rcx,(%rax)
  800863:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800867:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80086b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80086f:	48 89 50 10          	mov    %rdx,0x10(%rax)
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800873:	eb 17                	jmp    80088c <vprintfmt+0x52>
			if (ch == '\0')
  800875:	85 db                	test   %ebx,%ebx
  800877:	0f 84 cc 04 00 00    	je     800d49 <vprintfmt+0x50f>
                }
#endif

			  return;
			}
			putch(ch, putdat);
  80087d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800881:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800885:	48 89 d6             	mov    %rdx,%rsi
  800888:	89 df                	mov    %ebx,%edi
  80088a:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80088c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800890:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800894:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800898:	0f b6 00             	movzbl (%rax),%eax
  80089b:	0f b6 d8             	movzbl %al,%ebx
  80089e:	83 fb 25             	cmp    $0x25,%ebx
  8008a1:	75 d2                	jne    800875 <vprintfmt+0x3b>
			  return;
			}
			putch(ch, putdat);
		}
		// Process a %-escape sequence
		padc = ' ';
  8008a3:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008a7:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008ae:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008b5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008bc:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008c3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008c7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008cb:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008cf:	0f b6 00             	movzbl (%rax),%eax
  8008d2:	0f b6 d8             	movzbl %al,%ebx
  8008d5:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008d8:	83 f8 55             	cmp    $0x55,%eax
  8008db:	0f 87 34 04 00 00    	ja     800d15 <vprintfmt+0x4db>
  8008e1:	89 c0                	mov    %eax,%eax
  8008e3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008ea:	00 
  8008eb:	48 b8 b8 27 80 00 00 	movabs $0x8027b8,%rax
  8008f2:	00 00 00 
  8008f5:	48 01 d0             	add    %rdx,%rax
  8008f8:	48 8b 00             	mov    (%rax),%rax
  8008fb:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008fd:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800901:	eb c0                	jmp    8008c3 <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800903:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800907:	eb ba                	jmp    8008c3 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800909:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800910:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800913:	89 d0                	mov    %edx,%eax
  800915:	c1 e0 02             	shl    $0x2,%eax
  800918:	01 d0                	add    %edx,%eax
  80091a:	01 c0                	add    %eax,%eax
  80091c:	01 d8                	add    %ebx,%eax
  80091e:	83 e8 30             	sub    $0x30,%eax
  800921:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800924:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800928:	0f b6 00             	movzbl (%rax),%eax
  80092b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80092e:	83 fb 2f             	cmp    $0x2f,%ebx
  800931:	7e 0c                	jle    80093f <vprintfmt+0x105>
  800933:	83 fb 39             	cmp    $0x39,%ebx
  800936:	7f 07                	jg     80093f <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800938:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80093d:	eb d1                	jmp    800910 <vprintfmt+0xd6>
			goto process_precision;
  80093f:	eb 58                	jmp    800999 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800941:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800944:	83 f8 30             	cmp    $0x30,%eax
  800947:	73 17                	jae    800960 <vprintfmt+0x126>
  800949:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80094d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800950:	89 c0                	mov    %eax,%eax
  800952:	48 01 d0             	add    %rdx,%rax
  800955:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800958:	83 c2 08             	add    $0x8,%edx
  80095b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80095e:	eb 0f                	jmp    80096f <vprintfmt+0x135>
  800960:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800964:	48 89 d0             	mov    %rdx,%rax
  800967:	48 83 c2 08          	add    $0x8,%rdx
  80096b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80096f:	8b 00                	mov    (%rax),%eax
  800971:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800974:	eb 23                	jmp    800999 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800976:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80097a:	79 0c                	jns    800988 <vprintfmt+0x14e>
				width = 0;
  80097c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800983:	e9 3b ff ff ff       	jmpq   8008c3 <vprintfmt+0x89>
  800988:	e9 36 ff ff ff       	jmpq   8008c3 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80098d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800994:	e9 2a ff ff ff       	jmpq   8008c3 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800999:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80099d:	79 12                	jns    8009b1 <vprintfmt+0x177>
				width = precision, precision = -1;
  80099f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009a2:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009a5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009ac:	e9 12 ff ff ff       	jmpq   8008c3 <vprintfmt+0x89>
  8009b1:	e9 0d ff ff ff       	jmpq   8008c3 <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009b6:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009ba:	e9 04 ff ff ff       	jmpq   8008c3 <vprintfmt+0x89>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			putch(va_arg(aq, int), putdat);
  8009bf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c2:	83 f8 30             	cmp    $0x30,%eax
  8009c5:	73 17                	jae    8009de <vprintfmt+0x1a4>
  8009c7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009cb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ce:	89 c0                	mov    %eax,%eax
  8009d0:	48 01 d0             	add    %rdx,%rax
  8009d3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009d6:	83 c2 08             	add    $0x8,%edx
  8009d9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009dc:	eb 0f                	jmp    8009ed <vprintfmt+0x1b3>
  8009de:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009e2:	48 89 d0             	mov    %rdx,%rax
  8009e5:	48 83 c2 08          	add    $0x8,%rdx
  8009e9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009ed:	8b 10                	mov    (%rax),%edx
  8009ef:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009f3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009f7:	48 89 ce             	mov    %rcx,%rsi
  8009fa:	89 d7                	mov    %edx,%edi
  8009fc:	ff d0                	callq  *%rax
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  8009fe:	e9 40 03 00 00       	jmpq   800d43 <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800a03:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a06:	83 f8 30             	cmp    $0x30,%eax
  800a09:	73 17                	jae    800a22 <vprintfmt+0x1e8>
  800a0b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a0f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a12:	89 c0                	mov    %eax,%eax
  800a14:	48 01 d0             	add    %rdx,%rax
  800a17:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a1a:	83 c2 08             	add    $0x8,%edx
  800a1d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a20:	eb 0f                	jmp    800a31 <vprintfmt+0x1f7>
  800a22:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a26:	48 89 d0             	mov    %rdx,%rax
  800a29:	48 83 c2 08          	add    $0x8,%rdx
  800a2d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a31:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a33:	85 db                	test   %ebx,%ebx
  800a35:	79 02                	jns    800a39 <vprintfmt+0x1ff>
				err = -err;
  800a37:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a39:	83 fb 09             	cmp    $0x9,%ebx
  800a3c:	7f 16                	jg     800a54 <vprintfmt+0x21a>
  800a3e:	48 b8 40 27 80 00 00 	movabs $0x802740,%rax
  800a45:	00 00 00 
  800a48:	48 63 d3             	movslq %ebx,%rdx
  800a4b:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a4f:	4d 85 e4             	test   %r12,%r12
  800a52:	75 2e                	jne    800a82 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a54:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a58:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a5c:	89 d9                	mov    %ebx,%ecx
  800a5e:	48 ba a1 27 80 00 00 	movabs $0x8027a1,%rdx
  800a65:	00 00 00 
  800a68:	48 89 c7             	mov    %rax,%rdi
  800a6b:	b8 00 00 00 00       	mov    $0x0,%eax
  800a70:	49 b8 52 0d 80 00 00 	movabs $0x800d52,%r8
  800a77:	00 00 00 
  800a7a:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a7d:	e9 c1 02 00 00       	jmpq   800d43 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a82:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a86:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a8a:	4c 89 e1             	mov    %r12,%rcx
  800a8d:	48 ba aa 27 80 00 00 	movabs $0x8027aa,%rdx
  800a94:	00 00 00 
  800a97:	48 89 c7             	mov    %rax,%rdi
  800a9a:	b8 00 00 00 00       	mov    $0x0,%eax
  800a9f:	49 b8 52 0d 80 00 00 	movabs $0x800d52,%r8
  800aa6:	00 00 00 
  800aa9:	41 ff d0             	callq  *%r8
			break;
  800aac:	e9 92 02 00 00       	jmpq   800d43 <vprintfmt+0x509>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
  800ab1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ab4:	83 f8 30             	cmp    $0x30,%eax
  800ab7:	73 17                	jae    800ad0 <vprintfmt+0x296>
  800ab9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800abd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ac0:	89 c0                	mov    %eax,%eax
  800ac2:	48 01 d0             	add    %rdx,%rax
  800ac5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ac8:	83 c2 08             	add    $0x8,%edx
  800acb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ace:	eb 0f                	jmp    800adf <vprintfmt+0x2a5>
  800ad0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ad4:	48 89 d0             	mov    %rdx,%rax
  800ad7:	48 83 c2 08          	add    $0x8,%rdx
  800adb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800adf:	4c 8b 20             	mov    (%rax),%r12
  800ae2:	4d 85 e4             	test   %r12,%r12
  800ae5:	75 0a                	jne    800af1 <vprintfmt+0x2b7>
				p = "(null)";
  800ae7:	49 bc ad 27 80 00 00 	movabs $0x8027ad,%r12
  800aee:	00 00 00 
			if (width > 0 && padc != '-')
  800af1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800af5:	7e 3f                	jle    800b36 <vprintfmt+0x2fc>
  800af7:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800afb:	74 39                	je     800b36 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800afd:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b00:	48 98                	cltq   
  800b02:	48 89 c6             	mov    %rax,%rsi
  800b05:	4c 89 e7             	mov    %r12,%rdi
  800b08:	48 b8 fe 0f 80 00 00 	movabs $0x800ffe,%rax
  800b0f:	00 00 00 
  800b12:	ff d0                	callq  *%rax
  800b14:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b17:	eb 17                	jmp    800b30 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b19:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b1d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b21:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b25:	48 89 ce             	mov    %rcx,%rsi
  800b28:	89 d7                	mov    %edx,%edi
  800b2a:	ff d0                	callq  *%rax
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b2c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b30:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b34:	7f e3                	jg     800b19 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b36:	eb 37                	jmp    800b6f <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b38:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b3c:	74 1e                	je     800b5c <vprintfmt+0x322>
  800b3e:	83 fb 1f             	cmp    $0x1f,%ebx
  800b41:	7e 05                	jle    800b48 <vprintfmt+0x30e>
  800b43:	83 fb 7e             	cmp    $0x7e,%ebx
  800b46:	7e 14                	jle    800b5c <vprintfmt+0x322>
					putch('?', putdat);
  800b48:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b4c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b50:	48 89 d6             	mov    %rdx,%rsi
  800b53:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b58:	ff d0                	callq  *%rax
  800b5a:	eb 0f                	jmp    800b6b <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b5c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b60:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b64:	48 89 d6             	mov    %rdx,%rsi
  800b67:	89 df                	mov    %ebx,%edi
  800b69:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b6b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b6f:	4c 89 e0             	mov    %r12,%rax
  800b72:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b76:	0f b6 00             	movzbl (%rax),%eax
  800b79:	0f be d8             	movsbl %al,%ebx
  800b7c:	85 db                	test   %ebx,%ebx
  800b7e:	74 10                	je     800b90 <vprintfmt+0x356>
  800b80:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b84:	78 b2                	js     800b38 <vprintfmt+0x2fe>
  800b86:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b8a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b8e:	79 a8                	jns    800b38 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b90:	eb 16                	jmp    800ba8 <vprintfmt+0x36e>
				putch(' ', putdat);
  800b92:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b96:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b9a:	48 89 d6             	mov    %rdx,%rsi
  800b9d:	bf 20 00 00 00       	mov    $0x20,%edi
  800ba2:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ba4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ba8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bac:	7f e4                	jg     800b92 <vprintfmt+0x358>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  800bae:	e9 90 01 00 00       	jmpq   800d43 <vprintfmt+0x509>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getint(&aq, 3);
  800bb3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bb7:	be 03 00 00 00       	mov    $0x3,%esi
  800bbc:	48 89 c7             	mov    %rax,%rdi
  800bbf:	48 b8 2a 07 80 00 00 	movabs $0x80072a,%rax
  800bc6:	00 00 00 
  800bc9:	ff d0                	callq  *%rax
  800bcb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800bcf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bd3:	48 85 c0             	test   %rax,%rax
  800bd6:	79 1d                	jns    800bf5 <vprintfmt+0x3bb>
				putch('-', putdat);
  800bd8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bdc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800be0:	48 89 d6             	mov    %rdx,%rsi
  800be3:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800be8:	ff d0                	callq  *%rax
				num = -(long long) num;
  800bea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bee:	48 f7 d8             	neg    %rax
  800bf1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800bf5:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800bfc:	e9 d5 00 00 00       	jmpq   800cd6 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			
			num = getuint(&aq, 3);
  800c01:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c05:	be 03 00 00 00       	mov    $0x3,%esi
  800c0a:	48 89 c7             	mov    %rax,%rdi
  800c0d:	48 b8 1a 06 80 00 00 	movabs $0x80061a,%rax
  800c14:	00 00 00 
  800c17:	ff d0                	callq  *%rax
  800c19:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c1d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c24:	e9 ad 00 00 00       	jmpq   800cd6 <vprintfmt+0x49c>
                  ch = *(unsigned char *) color;
                }
#endif

			// Replace this with your code.
		        num = getuint(&aq, 3);
  800c29:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c2d:	be 03 00 00 00       	mov    $0x3,%esi
  800c32:	48 89 c7             	mov    %rax,%rdi
  800c35:	48 b8 1a 06 80 00 00 	movabs $0x80061a,%rax
  800c3c:	00 00 00 
  800c3f:	ff d0                	callq  *%rax
  800c41:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800c45:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800c4c:	e9 85 00 00 00       	jmpq   800cd6 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			putch('0', putdat);
  800c51:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c55:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c59:	48 89 d6             	mov    %rdx,%rsi
  800c5c:	bf 30 00 00 00       	mov    $0x30,%edi
  800c61:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c63:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c67:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c6b:	48 89 d6             	mov    %rdx,%rsi
  800c6e:	bf 78 00 00 00       	mov    $0x78,%edi
  800c73:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c75:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c78:	83 f8 30             	cmp    $0x30,%eax
  800c7b:	73 17                	jae    800c94 <vprintfmt+0x45a>
  800c7d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c81:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c84:	89 c0                	mov    %eax,%eax
  800c86:	48 01 d0             	add    %rdx,%rax
  800c89:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c8c:	83 c2 08             	add    $0x8,%edx
  800c8f:	89 55 b8             	mov    %edx,-0x48(%rbp)
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c92:	eb 0f                	jmp    800ca3 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800c94:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c98:	48 89 d0             	mov    %rdx,%rax
  800c9b:	48 83 c2 08          	add    $0x8,%rdx
  800c9f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ca3:	48 8b 00             	mov    (%rax),%rax
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ca6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800caa:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800cb1:	eb 23                	jmp    800cd6 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getuint(&aq, 3);
  800cb3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cb7:	be 03 00 00 00       	mov    $0x3,%esi
  800cbc:	48 89 c7             	mov    %rax,%rdi
  800cbf:	48 b8 1a 06 80 00 00 	movabs $0x80061a,%rax
  800cc6:	00 00 00 
  800cc9:	ff d0                	callq  *%rax
  800ccb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ccf:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:

			printnum(putch, putdat, num, base, width, padc);
  800cd6:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800cdb:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800cde:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ce1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ce5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ce9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ced:	45 89 c1             	mov    %r8d,%r9d
  800cf0:	41 89 f8             	mov    %edi,%r8d
  800cf3:	48 89 c7             	mov    %rax,%rdi
  800cf6:	48 b8 5f 05 80 00 00 	movabs $0x80055f,%rax
  800cfd:	00 00 00 
  800d00:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			break;
  800d02:	eb 3f                	jmp    800d43 <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d04:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d08:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d0c:	48 89 d6             	mov    %rdx,%rsi
  800d0f:	89 df                	mov    %ebx,%edi
  800d11:	ff d0                	callq  *%rax
			break;
  800d13:	eb 2e                	jmp    800d43 <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d15:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d19:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d1d:	48 89 d6             	mov    %rdx,%rsi
  800d20:	bf 25 00 00 00       	mov    $0x25,%edi
  800d25:	ff d0                	callq  *%rax

			for (fmt--; fmt[-1] != '%'; fmt--)
  800d27:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d2c:	eb 05                	jmp    800d33 <vprintfmt+0x4f9>
  800d2e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d33:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d37:	48 83 e8 01          	sub    $0x1,%rax
  800d3b:	0f b6 00             	movzbl (%rax),%eax
  800d3e:	3c 25                	cmp    $0x25,%al
  800d40:	75 ec                	jne    800d2e <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800d42:	90                   	nop
		}
	}
  800d43:	90                   	nop
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d44:	e9 43 fb ff ff       	jmpq   80088c <vprintfmt+0x52>
			break;
		}
	}
    
va_end(aq);
}
  800d49:	48 83 c4 60          	add    $0x60,%rsp
  800d4d:	5b                   	pop    %rbx
  800d4e:	41 5c                	pop    %r12
  800d50:	5d                   	pop    %rbp
  800d51:	c3                   	retq   

0000000000800d52 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d52:	55                   	push   %rbp
  800d53:	48 89 e5             	mov    %rsp,%rbp
  800d56:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d5d:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d64:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d6b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d72:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d79:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d80:	84 c0                	test   %al,%al
  800d82:	74 20                	je     800da4 <printfmt+0x52>
  800d84:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d88:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d8c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d90:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d94:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d98:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d9c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800da0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800da4:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800dab:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800db2:	00 00 00 
  800db5:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800dbc:	00 00 00 
  800dbf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dc3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800dca:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dd1:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800dd8:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800ddf:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800de6:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800ded:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800df4:	48 89 c7             	mov    %rax,%rdi
  800df7:	48 b8 3a 08 80 00 00 	movabs $0x80083a,%rax
  800dfe:	00 00 00 
  800e01:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e03:	c9                   	leaveq 
  800e04:	c3                   	retq   

0000000000800e05 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e05:	55                   	push   %rbp
  800e06:	48 89 e5             	mov    %rsp,%rbp
  800e09:	48 83 ec 10          	sub    $0x10,%rsp
  800e0d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e10:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e18:	8b 40 10             	mov    0x10(%rax),%eax
  800e1b:	8d 50 01             	lea    0x1(%rax),%edx
  800e1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e22:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e29:	48 8b 10             	mov    (%rax),%rdx
  800e2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e30:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e34:	48 39 c2             	cmp    %rax,%rdx
  800e37:	73 17                	jae    800e50 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e3d:	48 8b 00             	mov    (%rax),%rax
  800e40:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e44:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e48:	48 89 0a             	mov    %rcx,(%rdx)
  800e4b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e4e:	88 10                	mov    %dl,(%rax)
}
  800e50:	c9                   	leaveq 
  800e51:	c3                   	retq   

0000000000800e52 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e52:	55                   	push   %rbp
  800e53:	48 89 e5             	mov    %rsp,%rbp
  800e56:	48 83 ec 50          	sub    $0x50,%rsp
  800e5a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e5e:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e61:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e65:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e69:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e6d:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e71:	48 8b 0a             	mov    (%rdx),%rcx
  800e74:	48 89 08             	mov    %rcx,(%rax)
  800e77:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e7b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e7f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e83:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e87:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e8b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800e8f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e92:	48 98                	cltq   
  800e94:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800e98:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e9c:	48 01 d0             	add    %rdx,%rax
  800e9f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ea3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800eaa:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800eaf:	74 06                	je     800eb7 <vsnprintf+0x65>
  800eb1:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800eb5:	7f 07                	jg     800ebe <vsnprintf+0x6c>
		return -E_INVAL;
  800eb7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ebc:	eb 2f                	jmp    800eed <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ebe:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ec2:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ec6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800eca:	48 89 c6             	mov    %rax,%rsi
  800ecd:	48 bf 05 0e 80 00 00 	movabs $0x800e05,%rdi
  800ed4:	00 00 00 
  800ed7:	48 b8 3a 08 80 00 00 	movabs $0x80083a,%rax
  800ede:	00 00 00 
  800ee1:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800ee3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ee7:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800eea:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800eed:	c9                   	leaveq 
  800eee:	c3                   	retq   

0000000000800eef <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800eef:	55                   	push   %rbp
  800ef0:	48 89 e5             	mov    %rsp,%rbp
  800ef3:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800efa:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f01:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f07:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f0e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f15:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f1c:	84 c0                	test   %al,%al
  800f1e:	74 20                	je     800f40 <snprintf+0x51>
  800f20:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f24:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f28:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f2c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f30:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f34:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f38:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f3c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f40:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f47:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f4e:	00 00 00 
  800f51:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f58:	00 00 00 
  800f5b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f5f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f66:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f6d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f74:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f7b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f82:	48 8b 0a             	mov    (%rdx),%rcx
  800f85:	48 89 08             	mov    %rcx,(%rax)
  800f88:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f8c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f90:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f94:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800f98:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800f9f:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fa6:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fac:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fb3:	48 89 c7             	mov    %rax,%rdi
  800fb6:	48 b8 52 0e 80 00 00 	movabs $0x800e52,%rax
  800fbd:	00 00 00 
  800fc0:	ff d0                	callq  *%rax
  800fc2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800fc8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800fce:	c9                   	leaveq 
  800fcf:	c3                   	retq   

0000000000800fd0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800fd0:	55                   	push   %rbp
  800fd1:	48 89 e5             	mov    %rsp,%rbp
  800fd4:	48 83 ec 18          	sub    $0x18,%rsp
  800fd8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800fdc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fe3:	eb 09                	jmp    800fee <strlen+0x1e>
		n++;
  800fe5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800fe9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff2:	0f b6 00             	movzbl (%rax),%eax
  800ff5:	84 c0                	test   %al,%al
  800ff7:	75 ec                	jne    800fe5 <strlen+0x15>
		n++;
	return n;
  800ff9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ffc:	c9                   	leaveq 
  800ffd:	c3                   	retq   

0000000000800ffe <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ffe:	55                   	push   %rbp
  800fff:	48 89 e5             	mov    %rsp,%rbp
  801002:	48 83 ec 20          	sub    $0x20,%rsp
  801006:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80100a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80100e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801015:	eb 0e                	jmp    801025 <strnlen+0x27>
		n++;
  801017:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80101b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801020:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801025:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80102a:	74 0b                	je     801037 <strnlen+0x39>
  80102c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801030:	0f b6 00             	movzbl (%rax),%eax
  801033:	84 c0                	test   %al,%al
  801035:	75 e0                	jne    801017 <strnlen+0x19>
		n++;
	return n;
  801037:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80103a:	c9                   	leaveq 
  80103b:	c3                   	retq   

000000000080103c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80103c:	55                   	push   %rbp
  80103d:	48 89 e5             	mov    %rsp,%rbp
  801040:	48 83 ec 20          	sub    $0x20,%rsp
  801044:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801048:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80104c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801050:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801054:	90                   	nop
  801055:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801059:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80105d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801061:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801065:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801069:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80106d:	0f b6 12             	movzbl (%rdx),%edx
  801070:	88 10                	mov    %dl,(%rax)
  801072:	0f b6 00             	movzbl (%rax),%eax
  801075:	84 c0                	test   %al,%al
  801077:	75 dc                	jne    801055 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801079:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80107d:	c9                   	leaveq 
  80107e:	c3                   	retq   

000000000080107f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80107f:	55                   	push   %rbp
  801080:	48 89 e5             	mov    %rsp,%rbp
  801083:	48 83 ec 20          	sub    $0x20,%rsp
  801087:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80108b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80108f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801093:	48 89 c7             	mov    %rax,%rdi
  801096:	48 b8 d0 0f 80 00 00 	movabs $0x800fd0,%rax
  80109d:	00 00 00 
  8010a0:	ff d0                	callq  *%rax
  8010a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010a8:	48 63 d0             	movslq %eax,%rdx
  8010ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010af:	48 01 c2             	add    %rax,%rdx
  8010b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010b6:	48 89 c6             	mov    %rax,%rsi
  8010b9:	48 89 d7             	mov    %rdx,%rdi
  8010bc:	48 b8 3c 10 80 00 00 	movabs $0x80103c,%rax
  8010c3:	00 00 00 
  8010c6:	ff d0                	callq  *%rax
	return dst;
  8010c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010cc:	c9                   	leaveq 
  8010cd:	c3                   	retq   

00000000008010ce <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010ce:	55                   	push   %rbp
  8010cf:	48 89 e5             	mov    %rsp,%rbp
  8010d2:	48 83 ec 28          	sub    $0x28,%rsp
  8010d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010da:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010de:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8010e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8010ea:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8010f1:	00 
  8010f2:	eb 2a                	jmp    80111e <strncpy+0x50>
		*dst++ = *src;
  8010f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010fc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801100:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801104:	0f b6 12             	movzbl (%rdx),%edx
  801107:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801109:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80110d:	0f b6 00             	movzbl (%rax),%eax
  801110:	84 c0                	test   %al,%al
  801112:	74 05                	je     801119 <strncpy+0x4b>
			src++;
  801114:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801119:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80111e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801122:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801126:	72 cc                	jb     8010f4 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801128:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80112c:	c9                   	leaveq 
  80112d:	c3                   	retq   

000000000080112e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80112e:	55                   	push   %rbp
  80112f:	48 89 e5             	mov    %rsp,%rbp
  801132:	48 83 ec 28          	sub    $0x28,%rsp
  801136:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80113a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80113e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801142:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801146:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80114a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80114f:	74 3d                	je     80118e <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801151:	eb 1d                	jmp    801170 <strlcpy+0x42>
			*dst++ = *src++;
  801153:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801157:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80115b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80115f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801163:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801167:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80116b:	0f b6 12             	movzbl (%rdx),%edx
  80116e:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801170:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801175:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80117a:	74 0b                	je     801187 <strlcpy+0x59>
  80117c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801180:	0f b6 00             	movzbl (%rax),%eax
  801183:	84 c0                	test   %al,%al
  801185:	75 cc                	jne    801153 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801187:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118b:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80118e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801192:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801196:	48 29 c2             	sub    %rax,%rdx
  801199:	48 89 d0             	mov    %rdx,%rax
}
  80119c:	c9                   	leaveq 
  80119d:	c3                   	retq   

000000000080119e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80119e:	55                   	push   %rbp
  80119f:	48 89 e5             	mov    %rsp,%rbp
  8011a2:	48 83 ec 10          	sub    $0x10,%rsp
  8011a6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011aa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011ae:	eb 0a                	jmp    8011ba <strcmp+0x1c>
		p++, q++;
  8011b0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011b5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011be:	0f b6 00             	movzbl (%rax),%eax
  8011c1:	84 c0                	test   %al,%al
  8011c3:	74 12                	je     8011d7 <strcmp+0x39>
  8011c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c9:	0f b6 10             	movzbl (%rax),%edx
  8011cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011d0:	0f b6 00             	movzbl (%rax),%eax
  8011d3:	38 c2                	cmp    %al,%dl
  8011d5:	74 d9                	je     8011b0 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011db:	0f b6 00             	movzbl (%rax),%eax
  8011de:	0f b6 d0             	movzbl %al,%edx
  8011e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e5:	0f b6 00             	movzbl (%rax),%eax
  8011e8:	0f b6 c0             	movzbl %al,%eax
  8011eb:	29 c2                	sub    %eax,%edx
  8011ed:	89 d0                	mov    %edx,%eax
}
  8011ef:	c9                   	leaveq 
  8011f0:	c3                   	retq   

00000000008011f1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011f1:	55                   	push   %rbp
  8011f2:	48 89 e5             	mov    %rsp,%rbp
  8011f5:	48 83 ec 18          	sub    $0x18,%rsp
  8011f9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011fd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801201:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801205:	eb 0f                	jmp    801216 <strncmp+0x25>
		n--, p++, q++;
  801207:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80120c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801211:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801216:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80121b:	74 1d                	je     80123a <strncmp+0x49>
  80121d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801221:	0f b6 00             	movzbl (%rax),%eax
  801224:	84 c0                	test   %al,%al
  801226:	74 12                	je     80123a <strncmp+0x49>
  801228:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122c:	0f b6 10             	movzbl (%rax),%edx
  80122f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801233:	0f b6 00             	movzbl (%rax),%eax
  801236:	38 c2                	cmp    %al,%dl
  801238:	74 cd                	je     801207 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80123a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80123f:	75 07                	jne    801248 <strncmp+0x57>
		return 0;
  801241:	b8 00 00 00 00       	mov    $0x0,%eax
  801246:	eb 18                	jmp    801260 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801248:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80124c:	0f b6 00             	movzbl (%rax),%eax
  80124f:	0f b6 d0             	movzbl %al,%edx
  801252:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801256:	0f b6 00             	movzbl (%rax),%eax
  801259:	0f b6 c0             	movzbl %al,%eax
  80125c:	29 c2                	sub    %eax,%edx
  80125e:	89 d0                	mov    %edx,%eax
}
  801260:	c9                   	leaveq 
  801261:	c3                   	retq   

0000000000801262 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801262:	55                   	push   %rbp
  801263:	48 89 e5             	mov    %rsp,%rbp
  801266:	48 83 ec 0c          	sub    $0xc,%rsp
  80126a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80126e:	89 f0                	mov    %esi,%eax
  801270:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801273:	eb 17                	jmp    80128c <strchr+0x2a>
		if (*s == c)
  801275:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801279:	0f b6 00             	movzbl (%rax),%eax
  80127c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80127f:	75 06                	jne    801287 <strchr+0x25>
			return (char *) s;
  801281:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801285:	eb 15                	jmp    80129c <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801287:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80128c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801290:	0f b6 00             	movzbl (%rax),%eax
  801293:	84 c0                	test   %al,%al
  801295:	75 de                	jne    801275 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801297:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80129c:	c9                   	leaveq 
  80129d:	c3                   	retq   

000000000080129e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80129e:	55                   	push   %rbp
  80129f:	48 89 e5             	mov    %rsp,%rbp
  8012a2:	48 83 ec 0c          	sub    $0xc,%rsp
  8012a6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012aa:	89 f0                	mov    %esi,%eax
  8012ac:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012af:	eb 13                	jmp    8012c4 <strfind+0x26>
		if (*s == c)
  8012b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b5:	0f b6 00             	movzbl (%rax),%eax
  8012b8:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012bb:	75 02                	jne    8012bf <strfind+0x21>
			break;
  8012bd:	eb 10                	jmp    8012cf <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012bf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c8:	0f b6 00             	movzbl (%rax),%eax
  8012cb:	84 c0                	test   %al,%al
  8012cd:	75 e2                	jne    8012b1 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8012cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012d3:	c9                   	leaveq 
  8012d4:	c3                   	retq   

00000000008012d5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012d5:	55                   	push   %rbp
  8012d6:	48 89 e5             	mov    %rsp,%rbp
  8012d9:	48 83 ec 18          	sub    $0x18,%rsp
  8012dd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012e1:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8012e4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8012e8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012ed:	75 06                	jne    8012f5 <memset+0x20>
		return v;
  8012ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f3:	eb 69                	jmp    80135e <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8012f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f9:	83 e0 03             	and    $0x3,%eax
  8012fc:	48 85 c0             	test   %rax,%rax
  8012ff:	75 48                	jne    801349 <memset+0x74>
  801301:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801305:	83 e0 03             	and    $0x3,%eax
  801308:	48 85 c0             	test   %rax,%rax
  80130b:	75 3c                	jne    801349 <memset+0x74>
		c &= 0xFF;
  80130d:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801314:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801317:	c1 e0 18             	shl    $0x18,%eax
  80131a:	89 c2                	mov    %eax,%edx
  80131c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80131f:	c1 e0 10             	shl    $0x10,%eax
  801322:	09 c2                	or     %eax,%edx
  801324:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801327:	c1 e0 08             	shl    $0x8,%eax
  80132a:	09 d0                	or     %edx,%eax
  80132c:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80132f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801333:	48 c1 e8 02          	shr    $0x2,%rax
  801337:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80133a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80133e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801341:	48 89 d7             	mov    %rdx,%rdi
  801344:	fc                   	cld    
  801345:	f3 ab                	rep stos %eax,%es:(%rdi)
  801347:	eb 11                	jmp    80135a <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801349:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80134d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801350:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801354:	48 89 d7             	mov    %rdx,%rdi
  801357:	fc                   	cld    
  801358:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  80135a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80135e:	c9                   	leaveq 
  80135f:	c3                   	retq   

0000000000801360 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801360:	55                   	push   %rbp
  801361:	48 89 e5             	mov    %rsp,%rbp
  801364:	48 83 ec 28          	sub    $0x28,%rsp
  801368:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80136c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801370:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801374:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801378:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80137c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801380:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801384:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801388:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80138c:	0f 83 88 00 00 00    	jae    80141a <memmove+0xba>
  801392:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801396:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80139a:	48 01 d0             	add    %rdx,%rax
  80139d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013a1:	76 77                	jbe    80141a <memmove+0xba>
		s += n;
  8013a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a7:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013af:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b7:	83 e0 03             	and    $0x3,%eax
  8013ba:	48 85 c0             	test   %rax,%rax
  8013bd:	75 3b                	jne    8013fa <memmove+0x9a>
  8013bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c3:	83 e0 03             	and    $0x3,%eax
  8013c6:	48 85 c0             	test   %rax,%rax
  8013c9:	75 2f                	jne    8013fa <memmove+0x9a>
  8013cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013cf:	83 e0 03             	and    $0x3,%eax
  8013d2:	48 85 c0             	test   %rax,%rax
  8013d5:	75 23                	jne    8013fa <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013db:	48 83 e8 04          	sub    $0x4,%rax
  8013df:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013e3:	48 83 ea 04          	sub    $0x4,%rdx
  8013e7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013eb:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8013ef:	48 89 c7             	mov    %rax,%rdi
  8013f2:	48 89 d6             	mov    %rdx,%rsi
  8013f5:	fd                   	std    
  8013f6:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013f8:	eb 1d                	jmp    801417 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8013fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013fe:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801402:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801406:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80140a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140e:	48 89 d7             	mov    %rdx,%rdi
  801411:	48 89 c1             	mov    %rax,%rcx
  801414:	fd                   	std    
  801415:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801417:	fc                   	cld    
  801418:	eb 57                	jmp    801471 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80141a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80141e:	83 e0 03             	and    $0x3,%eax
  801421:	48 85 c0             	test   %rax,%rax
  801424:	75 36                	jne    80145c <memmove+0xfc>
  801426:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80142a:	83 e0 03             	and    $0x3,%eax
  80142d:	48 85 c0             	test   %rax,%rax
  801430:	75 2a                	jne    80145c <memmove+0xfc>
  801432:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801436:	83 e0 03             	and    $0x3,%eax
  801439:	48 85 c0             	test   %rax,%rax
  80143c:	75 1e                	jne    80145c <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80143e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801442:	48 c1 e8 02          	shr    $0x2,%rax
  801446:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801449:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80144d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801451:	48 89 c7             	mov    %rax,%rdi
  801454:	48 89 d6             	mov    %rdx,%rsi
  801457:	fc                   	cld    
  801458:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80145a:	eb 15                	jmp    801471 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80145c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801460:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801464:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801468:	48 89 c7             	mov    %rax,%rdi
  80146b:	48 89 d6             	mov    %rdx,%rsi
  80146e:	fc                   	cld    
  80146f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801471:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801475:	c9                   	leaveq 
  801476:	c3                   	retq   

0000000000801477 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801477:	55                   	push   %rbp
  801478:	48 89 e5             	mov    %rsp,%rbp
  80147b:	48 83 ec 18          	sub    $0x18,%rsp
  80147f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801483:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801487:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80148b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80148f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801493:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801497:	48 89 ce             	mov    %rcx,%rsi
  80149a:	48 89 c7             	mov    %rax,%rdi
  80149d:	48 b8 60 13 80 00 00 	movabs $0x801360,%rax
  8014a4:	00 00 00 
  8014a7:	ff d0                	callq  *%rax
}
  8014a9:	c9                   	leaveq 
  8014aa:	c3                   	retq   

00000000008014ab <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014ab:	55                   	push   %rbp
  8014ac:	48 89 e5             	mov    %rsp,%rbp
  8014af:	48 83 ec 28          	sub    $0x28,%rsp
  8014b3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014b7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014bb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014c7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014cb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014cf:	eb 36                	jmp    801507 <memcmp+0x5c>
		if (*s1 != *s2)
  8014d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d5:	0f b6 10             	movzbl (%rax),%edx
  8014d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014dc:	0f b6 00             	movzbl (%rax),%eax
  8014df:	38 c2                	cmp    %al,%dl
  8014e1:	74 1a                	je     8014fd <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8014e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e7:	0f b6 00             	movzbl (%rax),%eax
  8014ea:	0f b6 d0             	movzbl %al,%edx
  8014ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f1:	0f b6 00             	movzbl (%rax),%eax
  8014f4:	0f b6 c0             	movzbl %al,%eax
  8014f7:	29 c2                	sub    %eax,%edx
  8014f9:	89 d0                	mov    %edx,%eax
  8014fb:	eb 20                	jmp    80151d <memcmp+0x72>
		s1++, s2++;
  8014fd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801502:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801507:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80150f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801513:	48 85 c0             	test   %rax,%rax
  801516:	75 b9                	jne    8014d1 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801518:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80151d:	c9                   	leaveq 
  80151e:	c3                   	retq   

000000000080151f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80151f:	55                   	push   %rbp
  801520:	48 89 e5             	mov    %rsp,%rbp
  801523:	48 83 ec 28          	sub    $0x28,%rsp
  801527:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80152b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80152e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801532:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801536:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80153a:	48 01 d0             	add    %rdx,%rax
  80153d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801541:	eb 15                	jmp    801558 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801543:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801547:	0f b6 10             	movzbl (%rax),%edx
  80154a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80154d:	38 c2                	cmp    %al,%dl
  80154f:	75 02                	jne    801553 <memfind+0x34>
			break;
  801551:	eb 0f                	jmp    801562 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801553:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801558:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80155c:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801560:	72 e1                	jb     801543 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801562:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801566:	c9                   	leaveq 
  801567:	c3                   	retq   

0000000000801568 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801568:	55                   	push   %rbp
  801569:	48 89 e5             	mov    %rsp,%rbp
  80156c:	48 83 ec 34          	sub    $0x34,%rsp
  801570:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801574:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801578:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80157b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801582:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801589:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80158a:	eb 05                	jmp    801591 <strtol+0x29>
		s++;
  80158c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801591:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801595:	0f b6 00             	movzbl (%rax),%eax
  801598:	3c 20                	cmp    $0x20,%al
  80159a:	74 f0                	je     80158c <strtol+0x24>
  80159c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a0:	0f b6 00             	movzbl (%rax),%eax
  8015a3:	3c 09                	cmp    $0x9,%al
  8015a5:	74 e5                	je     80158c <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ab:	0f b6 00             	movzbl (%rax),%eax
  8015ae:	3c 2b                	cmp    $0x2b,%al
  8015b0:	75 07                	jne    8015b9 <strtol+0x51>
		s++;
  8015b2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015b7:	eb 17                	jmp    8015d0 <strtol+0x68>
	else if (*s == '-')
  8015b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015bd:	0f b6 00             	movzbl (%rax),%eax
  8015c0:	3c 2d                	cmp    $0x2d,%al
  8015c2:	75 0c                	jne    8015d0 <strtol+0x68>
		s++, neg = 1;
  8015c4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015c9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015d0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015d4:	74 06                	je     8015dc <strtol+0x74>
  8015d6:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015da:	75 28                	jne    801604 <strtol+0x9c>
  8015dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e0:	0f b6 00             	movzbl (%rax),%eax
  8015e3:	3c 30                	cmp    $0x30,%al
  8015e5:	75 1d                	jne    801604 <strtol+0x9c>
  8015e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015eb:	48 83 c0 01          	add    $0x1,%rax
  8015ef:	0f b6 00             	movzbl (%rax),%eax
  8015f2:	3c 78                	cmp    $0x78,%al
  8015f4:	75 0e                	jne    801604 <strtol+0x9c>
		s += 2, base = 16;
  8015f6:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8015fb:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801602:	eb 2c                	jmp    801630 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801604:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801608:	75 19                	jne    801623 <strtol+0xbb>
  80160a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160e:	0f b6 00             	movzbl (%rax),%eax
  801611:	3c 30                	cmp    $0x30,%al
  801613:	75 0e                	jne    801623 <strtol+0xbb>
		s++, base = 8;
  801615:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80161a:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801621:	eb 0d                	jmp    801630 <strtol+0xc8>
	else if (base == 0)
  801623:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801627:	75 07                	jne    801630 <strtol+0xc8>
		base = 10;
  801629:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801630:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801634:	0f b6 00             	movzbl (%rax),%eax
  801637:	3c 2f                	cmp    $0x2f,%al
  801639:	7e 1d                	jle    801658 <strtol+0xf0>
  80163b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163f:	0f b6 00             	movzbl (%rax),%eax
  801642:	3c 39                	cmp    $0x39,%al
  801644:	7f 12                	jg     801658 <strtol+0xf0>
			dig = *s - '0';
  801646:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164a:	0f b6 00             	movzbl (%rax),%eax
  80164d:	0f be c0             	movsbl %al,%eax
  801650:	83 e8 30             	sub    $0x30,%eax
  801653:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801656:	eb 4e                	jmp    8016a6 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801658:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165c:	0f b6 00             	movzbl (%rax),%eax
  80165f:	3c 60                	cmp    $0x60,%al
  801661:	7e 1d                	jle    801680 <strtol+0x118>
  801663:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801667:	0f b6 00             	movzbl (%rax),%eax
  80166a:	3c 7a                	cmp    $0x7a,%al
  80166c:	7f 12                	jg     801680 <strtol+0x118>
			dig = *s - 'a' + 10;
  80166e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801672:	0f b6 00             	movzbl (%rax),%eax
  801675:	0f be c0             	movsbl %al,%eax
  801678:	83 e8 57             	sub    $0x57,%eax
  80167b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80167e:	eb 26                	jmp    8016a6 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801680:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801684:	0f b6 00             	movzbl (%rax),%eax
  801687:	3c 40                	cmp    $0x40,%al
  801689:	7e 48                	jle    8016d3 <strtol+0x16b>
  80168b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168f:	0f b6 00             	movzbl (%rax),%eax
  801692:	3c 5a                	cmp    $0x5a,%al
  801694:	7f 3d                	jg     8016d3 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801696:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169a:	0f b6 00             	movzbl (%rax),%eax
  80169d:	0f be c0             	movsbl %al,%eax
  8016a0:	83 e8 37             	sub    $0x37,%eax
  8016a3:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016a6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016a9:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016ac:	7c 02                	jl     8016b0 <strtol+0x148>
			break;
  8016ae:	eb 23                	jmp    8016d3 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016b0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016b5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016b8:	48 98                	cltq   
  8016ba:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016bf:	48 89 c2             	mov    %rax,%rdx
  8016c2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016c5:	48 98                	cltq   
  8016c7:	48 01 d0             	add    %rdx,%rax
  8016ca:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016ce:	e9 5d ff ff ff       	jmpq   801630 <strtol+0xc8>

	if (endptr)
  8016d3:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016d8:	74 0b                	je     8016e5 <strtol+0x17d>
		*endptr = (char *) s;
  8016da:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016de:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016e2:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016e9:	74 09                	je     8016f4 <strtol+0x18c>
  8016eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ef:	48 f7 d8             	neg    %rax
  8016f2:	eb 04                	jmp    8016f8 <strtol+0x190>
  8016f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8016f8:	c9                   	leaveq 
  8016f9:	c3                   	retq   

00000000008016fa <strstr>:

char * strstr(const char *in, const char *str)
{
  8016fa:	55                   	push   %rbp
  8016fb:	48 89 e5             	mov    %rsp,%rbp
  8016fe:	48 83 ec 30          	sub    $0x30,%rsp
  801702:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801706:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  80170a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80170e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801712:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801716:	0f b6 00             	movzbl (%rax),%eax
  801719:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  80171c:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801720:	75 06                	jne    801728 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  801722:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801726:	eb 6b                	jmp    801793 <strstr+0x99>

    len = strlen(str);
  801728:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80172c:	48 89 c7             	mov    %rax,%rdi
  80172f:	48 b8 d0 0f 80 00 00 	movabs $0x800fd0,%rax
  801736:	00 00 00 
  801739:	ff d0                	callq  *%rax
  80173b:	48 98                	cltq   
  80173d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801741:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801745:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801749:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80174d:	0f b6 00             	movzbl (%rax),%eax
  801750:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801753:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801757:	75 07                	jne    801760 <strstr+0x66>
                return (char *) 0;
  801759:	b8 00 00 00 00       	mov    $0x0,%eax
  80175e:	eb 33                	jmp    801793 <strstr+0x99>
        } while (sc != c);
  801760:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801764:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801767:	75 d8                	jne    801741 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801769:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80176d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801771:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801775:	48 89 ce             	mov    %rcx,%rsi
  801778:	48 89 c7             	mov    %rax,%rdi
  80177b:	48 b8 f1 11 80 00 00 	movabs $0x8011f1,%rax
  801782:	00 00 00 
  801785:	ff d0                	callq  *%rax
  801787:	85 c0                	test   %eax,%eax
  801789:	75 b6                	jne    801741 <strstr+0x47>

    return (char *) (in - 1);
  80178b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178f:	48 83 e8 01          	sub    $0x1,%rax
}
  801793:	c9                   	leaveq 
  801794:	c3                   	retq   

0000000000801795 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801795:	55                   	push   %rbp
  801796:	48 89 e5             	mov    %rsp,%rbp
  801799:	53                   	push   %rbx
  80179a:	48 83 ec 48          	sub    $0x48,%rsp
  80179e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017a1:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8017a4:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017a8:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017ac:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017b0:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017b4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017b7:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017bb:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017bf:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017c3:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017c7:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017cb:	4c 89 c3             	mov    %r8,%rbx
  8017ce:	cd 30                	int    $0x30
  8017d0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8017d4:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017d8:	74 3e                	je     801818 <syscall+0x83>
  8017da:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017df:	7e 37                	jle    801818 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017e5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017e8:	49 89 d0             	mov    %rdx,%r8
  8017eb:	89 c1                	mov    %eax,%ecx
  8017ed:	48 ba 68 2a 80 00 00 	movabs $0x802a68,%rdx
  8017f4:	00 00 00 
  8017f7:	be 23 00 00 00       	mov    $0x23,%esi
  8017fc:	48 bf 85 2a 80 00 00 	movabs $0x802a85,%rdi
  801803:	00 00 00 
  801806:	b8 00 00 00 00       	mov    $0x0,%eax
  80180b:	49 b9 4f 23 80 00 00 	movabs $0x80234f,%r9
  801812:	00 00 00 
  801815:	41 ff d1             	callq  *%r9

	return ret;
  801818:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80181c:	48 83 c4 48          	add    $0x48,%rsp
  801820:	5b                   	pop    %rbx
  801821:	5d                   	pop    %rbp
  801822:	c3                   	retq   

0000000000801823 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801823:	55                   	push   %rbp
  801824:	48 89 e5             	mov    %rsp,%rbp
  801827:	48 83 ec 20          	sub    $0x20,%rsp
  80182b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80182f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801833:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801837:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80183b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801842:	00 
  801843:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801849:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80184f:	48 89 d1             	mov    %rdx,%rcx
  801852:	48 89 c2             	mov    %rax,%rdx
  801855:	be 00 00 00 00       	mov    $0x0,%esi
  80185a:	bf 00 00 00 00       	mov    $0x0,%edi
  80185f:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  801866:	00 00 00 
  801869:	ff d0                	callq  *%rax
}
  80186b:	c9                   	leaveq 
  80186c:	c3                   	retq   

000000000080186d <sys_cgetc>:

int
sys_cgetc(void)
{
  80186d:	55                   	push   %rbp
  80186e:	48 89 e5             	mov    %rsp,%rbp
  801871:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801875:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80187c:	00 
  80187d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801883:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801889:	b9 00 00 00 00       	mov    $0x0,%ecx
  80188e:	ba 00 00 00 00       	mov    $0x0,%edx
  801893:	be 00 00 00 00       	mov    $0x0,%esi
  801898:	bf 01 00 00 00       	mov    $0x1,%edi
  80189d:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  8018a4:	00 00 00 
  8018a7:	ff d0                	callq  *%rax
}
  8018a9:	c9                   	leaveq 
  8018aa:	c3                   	retq   

00000000008018ab <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018ab:	55                   	push   %rbp
  8018ac:	48 89 e5             	mov    %rsp,%rbp
  8018af:	48 83 ec 10          	sub    $0x10,%rsp
  8018b3:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018b9:	48 98                	cltq   
  8018bb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018c2:	00 
  8018c3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018c9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018cf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018d4:	48 89 c2             	mov    %rax,%rdx
  8018d7:	be 01 00 00 00       	mov    $0x1,%esi
  8018dc:	bf 03 00 00 00       	mov    $0x3,%edi
  8018e1:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  8018e8:	00 00 00 
  8018eb:	ff d0                	callq  *%rax
}
  8018ed:	c9                   	leaveq 
  8018ee:	c3                   	retq   

00000000008018ef <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8018ef:	55                   	push   %rbp
  8018f0:	48 89 e5             	mov    %rsp,%rbp
  8018f3:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8018f7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018fe:	00 
  8018ff:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801905:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80190b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801910:	ba 00 00 00 00       	mov    $0x0,%edx
  801915:	be 00 00 00 00       	mov    $0x0,%esi
  80191a:	bf 02 00 00 00       	mov    $0x2,%edi
  80191f:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  801926:	00 00 00 
  801929:	ff d0                	callq  *%rax
}
  80192b:	c9                   	leaveq 
  80192c:	c3                   	retq   

000000000080192d <sys_yield>:

void
sys_yield(void)
{
  80192d:	55                   	push   %rbp
  80192e:	48 89 e5             	mov    %rsp,%rbp
  801931:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801935:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80193c:	00 
  80193d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801943:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801949:	b9 00 00 00 00       	mov    $0x0,%ecx
  80194e:	ba 00 00 00 00       	mov    $0x0,%edx
  801953:	be 00 00 00 00       	mov    $0x0,%esi
  801958:	bf 0a 00 00 00       	mov    $0xa,%edi
  80195d:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  801964:	00 00 00 
  801967:	ff d0                	callq  *%rax
}
  801969:	c9                   	leaveq 
  80196a:	c3                   	retq   

000000000080196b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80196b:	55                   	push   %rbp
  80196c:	48 89 e5             	mov    %rsp,%rbp
  80196f:	48 83 ec 20          	sub    $0x20,%rsp
  801973:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801976:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80197a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80197d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801980:	48 63 c8             	movslq %eax,%rcx
  801983:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801987:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80198a:	48 98                	cltq   
  80198c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801993:	00 
  801994:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80199a:	49 89 c8             	mov    %rcx,%r8
  80199d:	48 89 d1             	mov    %rdx,%rcx
  8019a0:	48 89 c2             	mov    %rax,%rdx
  8019a3:	be 01 00 00 00       	mov    $0x1,%esi
  8019a8:	bf 04 00 00 00       	mov    $0x4,%edi
  8019ad:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  8019b4:	00 00 00 
  8019b7:	ff d0                	callq  *%rax
}
  8019b9:	c9                   	leaveq 
  8019ba:	c3                   	retq   

00000000008019bb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019bb:	55                   	push   %rbp
  8019bc:	48 89 e5             	mov    %rsp,%rbp
  8019bf:	48 83 ec 30          	sub    $0x30,%rsp
  8019c3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019c6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019ca:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019cd:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019d1:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019d5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019d8:	48 63 c8             	movslq %eax,%rcx
  8019db:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019df:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019e2:	48 63 f0             	movslq %eax,%rsi
  8019e5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019ec:	48 98                	cltq   
  8019ee:	48 89 0c 24          	mov    %rcx,(%rsp)
  8019f2:	49 89 f9             	mov    %rdi,%r9
  8019f5:	49 89 f0             	mov    %rsi,%r8
  8019f8:	48 89 d1             	mov    %rdx,%rcx
  8019fb:	48 89 c2             	mov    %rax,%rdx
  8019fe:	be 01 00 00 00       	mov    $0x1,%esi
  801a03:	bf 05 00 00 00       	mov    $0x5,%edi
  801a08:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  801a0f:	00 00 00 
  801a12:	ff d0                	callq  *%rax
}
  801a14:	c9                   	leaveq 
  801a15:	c3                   	retq   

0000000000801a16 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a16:	55                   	push   %rbp
  801a17:	48 89 e5             	mov    %rsp,%rbp
  801a1a:	48 83 ec 20          	sub    $0x20,%rsp
  801a1e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a21:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a25:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a2c:	48 98                	cltq   
  801a2e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a35:	00 
  801a36:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a3c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a42:	48 89 d1             	mov    %rdx,%rcx
  801a45:	48 89 c2             	mov    %rax,%rdx
  801a48:	be 01 00 00 00       	mov    $0x1,%esi
  801a4d:	bf 06 00 00 00       	mov    $0x6,%edi
  801a52:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  801a59:	00 00 00 
  801a5c:	ff d0                	callq  *%rax
}
  801a5e:	c9                   	leaveq 
  801a5f:	c3                   	retq   

0000000000801a60 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a60:	55                   	push   %rbp
  801a61:	48 89 e5             	mov    %rsp,%rbp
  801a64:	48 83 ec 10          	sub    $0x10,%rsp
  801a68:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a6b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a6e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a71:	48 63 d0             	movslq %eax,%rdx
  801a74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a77:	48 98                	cltq   
  801a79:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a80:	00 
  801a81:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a87:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a8d:	48 89 d1             	mov    %rdx,%rcx
  801a90:	48 89 c2             	mov    %rax,%rdx
  801a93:	be 01 00 00 00       	mov    $0x1,%esi
  801a98:	bf 08 00 00 00       	mov    $0x8,%edi
  801a9d:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  801aa4:	00 00 00 
  801aa7:	ff d0                	callq  *%rax
}
  801aa9:	c9                   	leaveq 
  801aaa:	c3                   	retq   

0000000000801aab <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801aab:	55                   	push   %rbp
  801aac:	48 89 e5             	mov    %rsp,%rbp
  801aaf:	48 83 ec 20          	sub    $0x20,%rsp
  801ab3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ab6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801aba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801abe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ac1:	48 98                	cltq   
  801ac3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aca:	00 
  801acb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ad7:	48 89 d1             	mov    %rdx,%rcx
  801ada:	48 89 c2             	mov    %rax,%rdx
  801add:	be 01 00 00 00       	mov    $0x1,%esi
  801ae2:	bf 09 00 00 00       	mov    $0x9,%edi
  801ae7:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  801aee:	00 00 00 
  801af1:	ff d0                	callq  *%rax
}
  801af3:	c9                   	leaveq 
  801af4:	c3                   	retq   

0000000000801af5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801af5:	55                   	push   %rbp
  801af6:	48 89 e5             	mov    %rsp,%rbp
  801af9:	48 83 ec 20          	sub    $0x20,%rsp
  801afd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b00:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b04:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b08:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b0b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b0e:	48 63 f0             	movslq %eax,%rsi
  801b11:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b18:	48 98                	cltq   
  801b1a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b1e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b25:	00 
  801b26:	49 89 f1             	mov    %rsi,%r9
  801b29:	49 89 c8             	mov    %rcx,%r8
  801b2c:	48 89 d1             	mov    %rdx,%rcx
  801b2f:	48 89 c2             	mov    %rax,%rdx
  801b32:	be 00 00 00 00       	mov    $0x0,%esi
  801b37:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b3c:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  801b43:	00 00 00 
  801b46:	ff d0                	callq  *%rax
}
  801b48:	c9                   	leaveq 
  801b49:	c3                   	retq   

0000000000801b4a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b4a:	55                   	push   %rbp
  801b4b:	48 89 e5             	mov    %rsp,%rbp
  801b4e:	48 83 ec 10          	sub    $0x10,%rsp
  801b52:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b5a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b61:	00 
  801b62:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b68:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b6e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b73:	48 89 c2             	mov    %rax,%rdx
  801b76:	be 01 00 00 00       	mov    $0x1,%esi
  801b7b:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b80:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  801b87:	00 00 00 
  801b8a:	ff d0                	callq  *%rax
}
  801b8c:	c9                   	leaveq 
  801b8d:	c3                   	retq   

0000000000801b8e <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801b8e:	55                   	push   %rbp
  801b8f:	48 89 e5             	mov    %rsp,%rbp
  801b92:	48 83 ec 30          	sub    $0x30,%rsp
  801b96:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801b9a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b9e:	48 8b 00             	mov    (%rax),%rax
  801ba1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  801ba5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ba9:	48 8b 40 08          	mov    0x8(%rax),%rax
  801bad:	89 45 fc             	mov    %eax,-0x4(%rbp)


	if (debug)
		cprintf("fault %08x %08x %d from %08x\n", addr, &uvpt[PGNUM(addr)], err & 7, (&addr)[4]);

	if (!(err & FEC_WR))
  801bb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bb3:	83 e0 02             	and    $0x2,%eax
  801bb6:	85 c0                	test   %eax,%eax
  801bb8:	75 40                	jne    801bfa <pgfault+0x6c>
		panic("read fault at %x, rip %x", addr, utf->utf_rip);
  801bba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bbe:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  801bc5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bc9:	49 89 d0             	mov    %rdx,%r8
  801bcc:	48 89 c1             	mov    %rax,%rcx
  801bcf:	48 ba 98 2a 80 00 00 	movabs $0x802a98,%rdx
  801bd6:	00 00 00 
  801bd9:	be 1a 00 00 00       	mov    $0x1a,%esi
  801bde:	48 bf b1 2a 80 00 00 	movabs $0x802ab1,%rdi
  801be5:	00 00 00 
  801be8:	b8 00 00 00 00       	mov    $0x0,%eax
  801bed:	49 b9 4f 23 80 00 00 	movabs $0x80234f,%r9
  801bf4:	00 00 00 
  801bf7:	41 ff d1             	callq  *%r9
	if ((uvpt[PGNUM(addr)] & (PTE_P|PTE_U|PTE_W|PTE_COW)) != (PTE_P|PTE_U|PTE_COW))
  801bfa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bfe:	48 c1 e8 0c          	shr    $0xc,%rax
  801c02:	48 89 c2             	mov    %rax,%rdx
  801c05:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c0c:	01 00 00 
  801c0f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c13:	25 07 08 00 00       	and    $0x807,%eax
  801c18:	48 3d 05 08 00 00    	cmp    $0x805,%rax
  801c1e:	74 4e                	je     801c6e <pgfault+0xe0>
		panic("fault at %x with pte %x, not copy-on-write",
  801c20:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c24:	48 c1 e8 0c          	shr    $0xc,%rax
  801c28:	48 89 c2             	mov    %rax,%rdx
  801c2b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c32:	01 00 00 
  801c35:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801c39:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c3d:	49 89 d0             	mov    %rdx,%r8
  801c40:	48 89 c1             	mov    %rax,%rcx
  801c43:	48 ba c0 2a 80 00 00 	movabs $0x802ac0,%rdx
  801c4a:	00 00 00 
  801c4d:	be 1d 00 00 00       	mov    $0x1d,%esi
  801c52:	48 bf b1 2a 80 00 00 	movabs $0x802ab1,%rdi
  801c59:	00 00 00 
  801c5c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c61:	49 b9 4f 23 80 00 00 	movabs $0x80234f,%r9
  801c68:	00 00 00 
  801c6b:	41 ff d1             	callq  *%r9
		      addr, uvpt[PGNUM(addr)]);



	// copy page
	if ((r = sys_page_alloc(0, (void*) PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801c6e:	ba 07 00 00 00       	mov    $0x7,%edx
  801c73:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c78:	bf 00 00 00 00       	mov    $0x0,%edi
  801c7d:	48 b8 6b 19 80 00 00 	movabs $0x80196b,%rax
  801c84:	00 00 00 
  801c87:	ff d0                	callq  *%rax
  801c89:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801c8c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801c90:	79 30                	jns    801cc2 <pgfault+0x134>
		panic("sys_page_alloc: %e", r);
  801c92:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c95:	89 c1                	mov    %eax,%ecx
  801c97:	48 ba eb 2a 80 00 00 	movabs $0x802aeb,%rdx
  801c9e:	00 00 00 
  801ca1:	be 23 00 00 00       	mov    $0x23,%esi
  801ca6:	48 bf b1 2a 80 00 00 	movabs $0x802ab1,%rdi
  801cad:	00 00 00 
  801cb0:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb5:	49 b8 4f 23 80 00 00 	movabs $0x80234f,%r8
  801cbc:	00 00 00 
  801cbf:	41 ff d0             	callq  *%r8
	memmove((void*) PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  801cc2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801cc6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  801cca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cce:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801cd4:	ba 00 10 00 00       	mov    $0x1000,%edx
  801cd9:	48 89 c6             	mov    %rax,%rsi
  801cdc:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801ce1:	48 b8 60 13 80 00 00 	movabs $0x801360,%rax
  801ce8:	00 00 00 
  801ceb:	ff d0                	callq  *%rax

	// remap over faulting page
	if ((r = sys_page_map(0, (void*) PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  801ced:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801cf1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801cf5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cf9:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801cff:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801d05:	48 89 c1             	mov    %rax,%rcx
  801d08:	ba 00 00 00 00       	mov    $0x0,%edx
  801d0d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d12:	bf 00 00 00 00       	mov    $0x0,%edi
  801d17:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  801d1e:	00 00 00 
  801d21:	ff d0                	callq  *%rax
  801d23:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801d26:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801d2a:	79 30                	jns    801d5c <pgfault+0x1ce>
		panic("sys_page_map: %e", r);
  801d2c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d2f:	89 c1                	mov    %eax,%ecx
  801d31:	48 ba fe 2a 80 00 00 	movabs $0x802afe,%rdx
  801d38:	00 00 00 
  801d3b:	be 28 00 00 00       	mov    $0x28,%esi
  801d40:	48 bf b1 2a 80 00 00 	movabs $0x802ab1,%rdi
  801d47:	00 00 00 
  801d4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d4f:	49 b8 4f 23 80 00 00 	movabs $0x80234f,%r8
  801d56:	00 00 00 
  801d59:	41 ff d0             	callq  *%r8

	// unmap our work space
	if ((r = sys_page_unmap(0, (void*) PFTEMP)) < 0)
  801d5c:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d61:	bf 00 00 00 00       	mov    $0x0,%edi
  801d66:	48 b8 16 1a 80 00 00 	movabs $0x801a16,%rax
  801d6d:	00 00 00 
  801d70:	ff d0                	callq  *%rax
  801d72:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801d75:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801d79:	79 30                	jns    801dab <pgfault+0x21d>
		panic("sys_page_unmap: %e", r);
  801d7b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d7e:	89 c1                	mov    %eax,%ecx
  801d80:	48 ba 0f 2b 80 00 00 	movabs $0x802b0f,%rdx
  801d87:	00 00 00 
  801d8a:	be 2c 00 00 00       	mov    $0x2c,%esi
  801d8f:	48 bf b1 2a 80 00 00 	movabs $0x802ab1,%rdi
  801d96:	00 00 00 
  801d99:	b8 00 00 00 00       	mov    $0x0,%eax
  801d9e:	49 b8 4f 23 80 00 00 	movabs $0x80234f,%r8
  801da5:	00 00 00 
  801da8:	41 ff d0             	callq  *%r8

}
  801dab:	c9                   	leaveq 
  801dac:	c3                   	retq   

0000000000801dad <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801dad:	55                   	push   %rbp
  801dae:	48 89 e5             	mov    %rsp,%rbp
  801db1:	48 83 ec 30          	sub    $0x30,%rsp
  801db5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801db8:	89 75 d8             	mov    %esi,-0x28(%rbp)


	void *addr;
	pte_t pte;

	addr = (void*) (uint64_t)(pn << PGSHIFT);
  801dbb:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801dbe:	c1 e0 0c             	shl    $0xc,%eax
  801dc1:	89 c0                	mov    %eax,%eax
  801dc3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	pte = uvpt[pn];
  801dc7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801dce:	01 00 00 
  801dd1:	8b 55 d8             	mov    -0x28(%rbp),%edx
  801dd4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dd8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	

	// if the page is just read-only or is library-shared, map it directly.
	if (!(pte & (PTE_W|PTE_COW)) || (pte & PTE_SHARE)) {
  801ddc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801de0:	25 02 08 00 00       	and    $0x802,%eax
  801de5:	48 85 c0             	test   %rax,%rax
  801de8:	74 0e                	je     801df8 <duppage+0x4b>
  801dea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dee:	25 00 04 00 00       	and    $0x400,%eax
  801df3:	48 85 c0             	test   %rax,%rax
  801df6:	74 70                	je     801e68 <duppage+0xbb>
		if ((r = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  801df8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dfc:	25 07 0e 00 00       	and    $0xe07,%eax
  801e01:	89 c6                	mov    %eax,%esi
  801e03:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  801e07:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801e0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e0e:	41 89 f0             	mov    %esi,%r8d
  801e11:	48 89 c6             	mov    %rax,%rsi
  801e14:	bf 00 00 00 00       	mov    $0x0,%edi
  801e19:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  801e20:	00 00 00 
  801e23:	ff d0                	callq  *%rax
  801e25:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801e28:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e2c:	79 30                	jns    801e5e <duppage+0xb1>
			panic("sys_page_map: %e", r);
  801e2e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e31:	89 c1                	mov    %eax,%ecx
  801e33:	48 ba fe 2a 80 00 00 	movabs $0x802afe,%rdx
  801e3a:	00 00 00 
  801e3d:	be 4b 00 00 00       	mov    $0x4b,%esi
  801e42:	48 bf b1 2a 80 00 00 	movabs $0x802ab1,%rdi
  801e49:	00 00 00 
  801e4c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e51:	49 b8 4f 23 80 00 00 	movabs $0x80234f,%r8
  801e58:	00 00 00 
  801e5b:	41 ff d0             	callq  *%r8
		return 0;
  801e5e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e63:	e9 c4 00 00 00       	jmpq   801f2c <duppage+0x17f>
	// Even if we think the page is already copy-on-write in our
	// address space, we need to mark it copy-on-write again after
	// the first sys_page_map, just in case a page fault has caused
	// us to copy the page in the interim.

	if ((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  801e68:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  801e6c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801e6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e73:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  801e79:	48 89 c6             	mov    %rax,%rsi
  801e7c:	bf 00 00 00 00       	mov    $0x0,%edi
  801e81:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  801e88:	00 00 00 
  801e8b:	ff d0                	callq  *%rax
  801e8d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801e90:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e94:	79 30                	jns    801ec6 <duppage+0x119>
		panic("sys_page_map: %e", r);
  801e96:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e99:	89 c1                	mov    %eax,%ecx
  801e9b:	48 ba fe 2a 80 00 00 	movabs $0x802afe,%rdx
  801ea2:	00 00 00 
  801ea5:	be 5f 00 00 00       	mov    $0x5f,%esi
  801eaa:	48 bf b1 2a 80 00 00 	movabs $0x802ab1,%rdi
  801eb1:	00 00 00 
  801eb4:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb9:	49 b8 4f 23 80 00 00 	movabs $0x80234f,%r8
  801ec0:	00 00 00 
  801ec3:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  801ec6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801eca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ece:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  801ed4:	48 89 d1             	mov    %rdx,%rcx
  801ed7:	ba 00 00 00 00       	mov    $0x0,%edx
  801edc:	48 89 c6             	mov    %rax,%rsi
  801edf:	bf 00 00 00 00       	mov    $0x0,%edi
  801ee4:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  801eeb:	00 00 00 
  801eee:	ff d0                	callq  *%rax
  801ef0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801ef3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ef7:	79 30                	jns    801f29 <duppage+0x17c>
		panic("sys_page_map: %e", r);
  801ef9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801efc:	89 c1                	mov    %eax,%ecx
  801efe:	48 ba fe 2a 80 00 00 	movabs $0x802afe,%rdx
  801f05:	00 00 00 
  801f08:	be 61 00 00 00       	mov    $0x61,%esi
  801f0d:	48 bf b1 2a 80 00 00 	movabs $0x802ab1,%rdi
  801f14:	00 00 00 
  801f17:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1c:	49 b8 4f 23 80 00 00 	movabs $0x80234f,%r8
  801f23:	00 00 00 
  801f26:	41 ff d0             	callq  *%r8
	return r;
  801f29:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  801f2c:	c9                   	leaveq 
  801f2d:	c3                   	retq   

0000000000801f2e <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801f2e:	55                   	push   %rbp
  801f2f:	48 89 e5             	mov    %rsp,%rbp
  801f32:	48 83 ec 20          	sub    $0x20,%rsp
	envid_t envid;
	int pn, end_pn, r;

	set_pgfault_handler(pgfault);
  801f36:	48 bf 8e 1b 80 00 00 	movabs $0x801b8e,%rdi
  801f3d:	00 00 00 
  801f40:	48 b8 63 24 80 00 00 	movabs $0x802463,%rax
  801f47:	00 00 00 
  801f4a:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801f4c:	b8 07 00 00 00       	mov    $0x7,%eax
  801f51:	cd 30                	int    $0x30
  801f53:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801f56:	8b 45 ec             	mov    -0x14(%rbp),%eax

	// Create a child.
	envid = sys_exofork();
  801f59:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (envid < 0)
  801f5c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801f60:	79 08                	jns    801f6a <fork+0x3c>
		return envid;
  801f62:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f65:	e9 11 02 00 00       	jmpq   80217b <fork+0x24d>
	if (envid == 0) {
  801f6a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801f6e:	75 46                	jne    801fb6 <fork+0x88>
		thisenv = &envs[ENVX(sys_getenvid())];
  801f70:	48 b8 ef 18 80 00 00 	movabs $0x8018ef,%rax
  801f77:	00 00 00 
  801f7a:	ff d0                	callq  *%rax
  801f7c:	25 ff 03 00 00       	and    $0x3ff,%eax
  801f81:	48 63 d0             	movslq %eax,%rdx
  801f84:	48 89 d0             	mov    %rdx,%rax
  801f87:	48 c1 e0 03          	shl    $0x3,%rax
  801f8b:	48 01 d0             	add    %rdx,%rax
  801f8e:	48 c1 e0 05          	shl    $0x5,%rax
  801f92:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801f99:	00 00 00 
  801f9c:	48 01 c2             	add    %rax,%rdx
  801f9f:	48 b8 18 40 80 00 00 	movabs $0x804018,%rax
  801fa6:	00 00 00 
  801fa9:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801fac:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb1:	e9 c5 01 00 00       	jmpq   80217b <fork+0x24d>
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  801fb6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fbd:	e9 a4 00 00 00       	jmpq   802066 <fork+0x138>
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
  801fc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fc5:	c1 f8 12             	sar    $0x12,%eax
  801fc8:	89 c2                	mov    %eax,%edx
  801fca:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801fd1:	01 00 00 
  801fd4:	48 63 d2             	movslq %edx,%rdx
  801fd7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fdb:	83 e0 01             	and    $0x1,%eax
  801fde:	48 85 c0             	test   %rax,%rax
  801fe1:	74 21                	je     802004 <fork+0xd6>
  801fe3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fe6:	c1 f8 09             	sar    $0x9,%eax
  801fe9:	89 c2                	mov    %eax,%edx
  801feb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ff2:	01 00 00 
  801ff5:	48 63 d2             	movslq %edx,%rdx
  801ff8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ffc:	83 e0 01             	and    $0x1,%eax
  801fff:	48 85 c0             	test   %rax,%rax
  802002:	75 09                	jne    80200d <fork+0xdf>
			pn += NPTENTRIES;
  802004:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%rbp)
			continue;
  80200b:	eb 59                	jmp    802066 <fork+0x138>
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  80200d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802010:	05 00 02 00 00       	add    $0x200,%eax
  802015:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802018:	eb 44                	jmp    80205e <fork+0x130>
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
  80201a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802021:	01 00 00 
  802024:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802027:	48 63 d2             	movslq %edx,%rdx
  80202a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80202e:	83 e0 05             	and    $0x5,%eax
  802031:	48 83 f8 05          	cmp    $0x5,%rax
  802035:	74 02                	je     802039 <fork+0x10b>
				continue;
  802037:	eb 21                	jmp    80205a <fork+0x12c>
			if (pn == PPN(UXSTACKTOP - 1))
  802039:	81 7d fc ff f7 0e 00 	cmpl   $0xef7ff,-0x4(%rbp)
  802040:	75 02                	jne    802044 <fork+0x116>
				continue;
  802042:	eb 16                	jmp    80205a <fork+0x12c>
			duppage(envid, pn);
  802044:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802047:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80204a:	89 d6                	mov    %edx,%esi
  80204c:	89 c7                	mov    %eax,%edi
  80204e:	48 b8 ad 1d 80 00 00 	movabs $0x801dad,%rax
  802055:	00 00 00 
  802058:	ff d0                	callq  *%rax
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  80205a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80205e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802061:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  802064:	7c b4                	jl     80201a <fork+0xec>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  802066:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802069:	3d ff 07 00 08       	cmp    $0x80007ff,%eax
  80206e:	0f 86 4e ff ff ff    	jbe    801fc2 <fork+0x94>
			duppage(envid, pn);
		}
	}

	// The child needs to start out with a valid exception stack.
	if ((r = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  802074:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802077:	ba 07 00 00 00       	mov    $0x7,%edx
  80207c:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802081:	89 c7                	mov    %eax,%edi
  802083:	48 b8 6b 19 80 00 00 	movabs $0x80196b,%rax
  80208a:	00 00 00 
  80208d:	ff d0                	callq  *%rax
  80208f:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802092:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802096:	79 30                	jns    8020c8 <fork+0x19a>
		panic("allocating exception stack: %e", r);
  802098:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80209b:	89 c1                	mov    %eax,%ecx
  80209d:	48 ba 28 2b 80 00 00 	movabs $0x802b28,%rdx
  8020a4:	00 00 00 
  8020a7:	be 98 00 00 00       	mov    $0x98,%esi
  8020ac:	48 bf b1 2a 80 00 00 	movabs $0x802ab1,%rdi
  8020b3:	00 00 00 
  8020b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8020bb:	49 b8 4f 23 80 00 00 	movabs $0x80234f,%r8
  8020c2:	00 00 00 
  8020c5:	41 ff d0             	callq  *%r8

	// Copy the user-mode exception entrypoint.
	if ((r = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall)) < 0)
  8020c8:	48 b8 18 40 80 00 00 	movabs $0x804018,%rax
  8020cf:	00 00 00 
  8020d2:	48 8b 00             	mov    (%rax),%rax
  8020d5:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  8020dc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020df:	48 89 d6             	mov    %rdx,%rsi
  8020e2:	89 c7                	mov    %eax,%edi
  8020e4:	48 b8 ab 1a 80 00 00 	movabs $0x801aab,%rax
  8020eb:	00 00 00 
  8020ee:	ff d0                	callq  *%rax
  8020f0:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8020f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8020f7:	79 30                	jns    802129 <fork+0x1fb>
		panic("sys_env_set_pgfault_upcall: %e", r);
  8020f9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8020fc:	89 c1                	mov    %eax,%ecx
  8020fe:	48 ba 48 2b 80 00 00 	movabs $0x802b48,%rdx
  802105:	00 00 00 
  802108:	be 9c 00 00 00       	mov    $0x9c,%esi
  80210d:	48 bf b1 2a 80 00 00 	movabs $0x802ab1,%rdi
  802114:	00 00 00 
  802117:	b8 00 00 00 00       	mov    $0x0,%eax
  80211c:	49 b8 4f 23 80 00 00 	movabs $0x80234f,%r8
  802123:	00 00 00 
  802126:	41 ff d0             	callq  *%r8


	// Okay, the child is ready for life on its own.
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  802129:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80212c:	be 02 00 00 00       	mov    $0x2,%esi
  802131:	89 c7                	mov    %eax,%edi
  802133:	48 b8 60 1a 80 00 00 	movabs $0x801a60,%rax
  80213a:	00 00 00 
  80213d:	ff d0                	callq  *%rax
  80213f:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802142:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802146:	79 30                	jns    802178 <fork+0x24a>
		panic("sys_env_set_status: %e", r);
  802148:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80214b:	89 c1                	mov    %eax,%ecx
  80214d:	48 ba 67 2b 80 00 00 	movabs $0x802b67,%rdx
  802154:	00 00 00 
  802157:	be a1 00 00 00       	mov    $0xa1,%esi
  80215c:	48 bf b1 2a 80 00 00 	movabs $0x802ab1,%rdi
  802163:	00 00 00 
  802166:	b8 00 00 00 00       	mov    $0x0,%eax
  80216b:	49 b8 4f 23 80 00 00 	movabs $0x80234f,%r8
  802172:	00 00 00 
  802175:	41 ff d0             	callq  *%r8

	return envid;
  802178:	8b 45 f8             	mov    -0x8(%rbp),%eax


}
  80217b:	c9                   	leaveq 
  80217c:	c3                   	retq   

000000000080217d <sfork>:

// Challenge!
int
sfork(void)
{
  80217d:	55                   	push   %rbp
  80217e:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802181:	48 ba 7e 2b 80 00 00 	movabs $0x802b7e,%rdx
  802188:	00 00 00 
  80218b:	be ac 00 00 00       	mov    $0xac,%esi
  802190:	48 bf b1 2a 80 00 00 	movabs $0x802ab1,%rdi
  802197:	00 00 00 
  80219a:	b8 00 00 00 00       	mov    $0x0,%eax
  80219f:	48 b9 4f 23 80 00 00 	movabs $0x80234f,%rcx
  8021a6:	00 00 00 
  8021a9:	ff d1                	callq  *%rcx

00000000008021ab <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021ab:	55                   	push   %rbp
  8021ac:	48 89 e5             	mov    %rsp,%rbp
  8021af:	48 83 ec 30          	sub    $0x30,%rsp
  8021b3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8021b7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8021bb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	
	if(pg == NULL)
  8021bf:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8021c4:	75 0e                	jne    8021d4 <ipc_recv+0x29>
	  pg = (void *)(UTOP); // We always check above and below UTOP
  8021c6:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8021cd:	00 00 00 
  8021d0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	 int retval = sys_ipc_recv(pg);
  8021d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021d8:	48 89 c7             	mov    %rax,%rdi
  8021db:	48 b8 4a 1b 80 00 00 	movabs $0x801b4a,%rax
  8021e2:	00 00 00 
  8021e5:	ff d0                	callq  *%rax
  8021e7:	89 45 fc             	mov    %eax,-0x4(%rbp)

	 if(retval == 0)
  8021ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021ee:	75 55                	jne    802245 <ipc_recv+0x9a>
	 {	
	    if(from_env_store != NULL)
  8021f0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8021f5:	74 19                	je     802210 <ipc_recv+0x65>
               *from_env_store = thisenv->env_ipc_from;
  8021f7:	48 b8 18 40 80 00 00 	movabs $0x804018,%rax
  8021fe:	00 00 00 
  802201:	48 8b 00             	mov    (%rax),%rax
  802204:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80220a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80220e:	89 10                	mov    %edx,(%rax)

	    if(perm_store != NULL)
  802210:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802215:	74 19                	je     802230 <ipc_recv+0x85>
               *perm_store = thisenv->env_ipc_perm;
  802217:	48 b8 18 40 80 00 00 	movabs $0x804018,%rax
  80221e:	00 00 00 
  802221:	48 8b 00             	mov    (%rax),%rax
  802224:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80222a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80222e:	89 10                	mov    %edx,(%rax)

	   return thisenv->env_ipc_value;
  802230:	48 b8 18 40 80 00 00 	movabs $0x804018,%rax
  802237:	00 00 00 
  80223a:	48 8b 00             	mov    (%rax),%rax
  80223d:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  802243:	eb 25                	jmp    80226a <ipc_recv+0xbf>

	 }
	 else
	 {
	      if(from_env_store)
  802245:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80224a:	74 0a                	je     802256 <ipc_recv+0xab>
	         *from_env_store = 0;
  80224c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802250:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	      
	      if(perm_store)
  802256:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80225b:	74 0a                	je     802267 <ipc_recv+0xbc>
	       *perm_store = 0;
  80225d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802261:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	       
	       return retval;
  802267:	8b 45 fc             	mov    -0x4(%rbp),%eax
	 }
	
	panic("problem in ipc_recv lib/ipc.c");
	//return 0;
}
  80226a:	c9                   	leaveq 
  80226b:	c3                   	retq   

000000000080226c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80226c:	55                   	push   %rbp
  80226d:	48 89 e5             	mov    %rsp,%rbp
  802270:	48 83 ec 30          	sub    $0x30,%rsp
  802274:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802277:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80227a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80227e:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.

	if(pg == NULL)
  802281:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802286:	75 0e                	jne    802296 <ipc_send+0x2a>
	   pg = (void *)(UTOP);
  802288:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80228f:	00 00 00 
  802292:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	int retval;
	while(1)
	{
	   retval = sys_ipc_try_send(to_env, val, pg, perm);
  802296:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802299:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80229c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8022a0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022a3:	89 c7                	mov    %eax,%edi
  8022a5:	48 b8 f5 1a 80 00 00 	movabs $0x801af5,%rax
  8022ac:	00 00 00 
  8022af:	ff d0                	callq  *%rax
  8022b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	   if(retval == 0)
  8022b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022b8:	75 02                	jne    8022bc <ipc_send+0x50>
	      break;
  8022ba:	eb 0e                	jmp    8022ca <ipc_send+0x5e>
	   
	   //if(retval < 0 && retval != -E_IPC_NOT_RECV)
	     //panic("receiver error other than NOT_RECV");

	   sys_yield(); 
  8022bc:	48 b8 2d 19 80 00 00 	movabs $0x80192d,%rax
  8022c3:	00 00 00 
  8022c6:	ff d0                	callq  *%rax
	 
	}
  8022c8:	eb cc                	jmp    802296 <ipc_send+0x2a>
	return;
  8022ca:	90                   	nop
	//panic("ipc_send not implemented");
}
  8022cb:	c9                   	leaveq 
  8022cc:	c3                   	retq   

00000000008022cd <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022cd:	55                   	push   %rbp
  8022ce:	48 89 e5             	mov    %rsp,%rbp
  8022d1:	48 83 ec 14          	sub    $0x14,%rsp
  8022d5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  8022d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022df:	eb 5e                	jmp    80233f <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8022e1:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8022e8:	00 00 00 
  8022eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022ee:	48 63 d0             	movslq %eax,%rdx
  8022f1:	48 89 d0             	mov    %rdx,%rax
  8022f4:	48 c1 e0 03          	shl    $0x3,%rax
  8022f8:	48 01 d0             	add    %rdx,%rax
  8022fb:	48 c1 e0 05          	shl    $0x5,%rax
  8022ff:	48 01 c8             	add    %rcx,%rax
  802302:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802308:	8b 00                	mov    (%rax),%eax
  80230a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80230d:	75 2c                	jne    80233b <ipc_find_env+0x6e>
			return envs[i].env_id;
  80230f:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802316:	00 00 00 
  802319:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80231c:	48 63 d0             	movslq %eax,%rdx
  80231f:	48 89 d0             	mov    %rdx,%rax
  802322:	48 c1 e0 03          	shl    $0x3,%rax
  802326:	48 01 d0             	add    %rdx,%rax
  802329:	48 c1 e0 05          	shl    $0x5,%rax
  80232d:	48 01 c8             	add    %rcx,%rax
  802330:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802336:	8b 40 08             	mov    0x8(%rax),%eax
  802339:	eb 12                	jmp    80234d <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80233b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80233f:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802346:	7e 99                	jle    8022e1 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802348:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80234d:	c9                   	leaveq 
  80234e:	c3                   	retq   

000000000080234f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80234f:	55                   	push   %rbp
  802350:	48 89 e5             	mov    %rsp,%rbp
  802353:	53                   	push   %rbx
  802354:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80235b:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  802362:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  802368:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80236f:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  802376:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80237d:	84 c0                	test   %al,%al
  80237f:	74 23                	je     8023a4 <_panic+0x55>
  802381:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  802388:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80238c:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  802390:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  802394:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  802398:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80239c:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8023a0:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8023a4:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8023ab:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8023b2:	00 00 00 
  8023b5:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8023bc:	00 00 00 
  8023bf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8023c3:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8023ca:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8023d1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8023d8:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  8023df:	00 00 00 
  8023e2:	48 8b 18             	mov    (%rax),%rbx
  8023e5:	48 b8 ef 18 80 00 00 	movabs $0x8018ef,%rax
  8023ec:	00 00 00 
  8023ef:	ff d0                	callq  *%rax
  8023f1:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8023f7:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8023fe:	41 89 c8             	mov    %ecx,%r8d
  802401:	48 89 d1             	mov    %rdx,%rcx
  802404:	48 89 da             	mov    %rbx,%rdx
  802407:	89 c6                	mov    %eax,%esi
  802409:	48 bf 98 2b 80 00 00 	movabs $0x802b98,%rdi
  802410:	00 00 00 
  802413:	b8 00 00 00 00       	mov    $0x0,%eax
  802418:	49 b9 87 04 80 00 00 	movabs $0x800487,%r9
  80241f:	00 00 00 
  802422:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802425:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80242c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802433:	48 89 d6             	mov    %rdx,%rsi
  802436:	48 89 c7             	mov    %rax,%rdi
  802439:	48 b8 db 03 80 00 00 	movabs $0x8003db,%rax
  802440:	00 00 00 
  802443:	ff d0                	callq  *%rax
	cprintf("\n");
  802445:	48 bf bb 2b 80 00 00 	movabs $0x802bbb,%rdi
  80244c:	00 00 00 
  80244f:	b8 00 00 00 00       	mov    $0x0,%eax
  802454:	48 ba 87 04 80 00 00 	movabs $0x800487,%rdx
  80245b:	00 00 00 
  80245e:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802460:	cc                   	int3   
  802461:	eb fd                	jmp    802460 <_panic+0x111>

0000000000802463 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802463:	55                   	push   %rbp
  802464:	48 89 e5             	mov    %rsp,%rbp
  802467:	48 83 ec 10          	sub    $0x10,%rsp
  80246b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;
	
	if (_pgfault_handler == 0) {
  80246f:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  802476:	00 00 00 
  802479:	48 8b 00             	mov    (%rax),%rax
  80247c:	48 85 c0             	test   %rax,%rax
  80247f:	0f 85 b2 00 00 00    	jne    802537 <set_pgfault_handler+0xd4>
		// First time through!
		// LAB 4: Your code here.
		
		if(sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP-PGSIZE), PTE_P|PTE_U|PTE_W) != 0)
  802485:	48 b8 18 40 80 00 00 	movabs $0x804018,%rax
  80248c:	00 00 00 
  80248f:	48 8b 00             	mov    (%rax),%rax
  802492:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802498:	ba 07 00 00 00       	mov    $0x7,%edx
  80249d:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8024a2:	89 c7                	mov    %eax,%edi
  8024a4:	48 b8 6b 19 80 00 00 	movabs $0x80196b,%rax
  8024ab:	00 00 00 
  8024ae:	ff d0                	callq  *%rax
  8024b0:	85 c0                	test   %eax,%eax
  8024b2:	74 2a                	je     8024de <set_pgfault_handler+0x7b>
		  panic("\nproblem in page allocation lib/pgfault.c\n");
  8024b4:	48 ba c0 2b 80 00 00 	movabs $0x802bc0,%rdx
  8024bb:	00 00 00 
  8024be:	be 22 00 00 00       	mov    $0x22,%esi
  8024c3:	48 bf eb 2b 80 00 00 	movabs $0x802beb,%rdi
  8024ca:	00 00 00 
  8024cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d2:	48 b9 4f 23 80 00 00 	movabs $0x80234f,%rcx
  8024d9:	00 00 00 
  8024dc:	ff d1                	callq  *%rcx
		
	         if(sys_env_set_pgfault_upcall(thisenv->env_id, (void *)_pgfault_upcall) != 0)
  8024de:	48 b8 18 40 80 00 00 	movabs $0x804018,%rax
  8024e5:	00 00 00 
  8024e8:	48 8b 00             	mov    (%rax),%rax
  8024eb:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024f1:	48 be 4a 25 80 00 00 	movabs $0x80254a,%rsi
  8024f8:	00 00 00 
  8024fb:	89 c7                	mov    %eax,%edi
  8024fd:	48 b8 ab 1a 80 00 00 	movabs $0x801aab,%rax
  802504:	00 00 00 
  802507:	ff d0                	callq  *%rax
  802509:	85 c0                	test   %eax,%eax
  80250b:	74 2a                	je     802537 <set_pgfault_handler+0xd4>
		   panic("set_pgfault_handler implemented but problems lib/pgfault.c");
  80250d:	48 ba 00 2c 80 00 00 	movabs $0x802c00,%rdx
  802514:	00 00 00 
  802517:	be 25 00 00 00       	mov    $0x25,%esi
  80251c:	48 bf eb 2b 80 00 00 	movabs $0x802beb,%rdi
  802523:	00 00 00 
  802526:	b8 00 00 00 00       	mov    $0x0,%eax
  80252b:	48 b9 4f 23 80 00 00 	movabs $0x80234f,%rcx
  802532:	00 00 00 
  802535:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802537:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  80253e:	00 00 00 
  802541:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802545:	48 89 10             	mov    %rdx,(%rax)
}
  802548:	c9                   	leaveq 
  802549:	c3                   	retq   

000000000080254a <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  80254a:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  80254d:	48 a1 20 40 80 00 00 	movabs 0x804020,%rax
  802554:	00 00 00 
	call *%rax
  802557:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.                
	movq %rsp, %rdi;	
  802559:	48 89 e7             	mov    %rsp,%rdi
	movq 136(%rsp), %rbx;
  80255c:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  802563:	00 
	movq 152(%rsp), %rsp;// Going to another stack for storing rip	
  802564:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  80256b:	00 
	pushq %rbx;
  80256c:	53                   	push   %rbx
	movq %rsp, %rbx;	
  80256d:	48 89 e3             	mov    %rsp,%rbx
	movq %rdi, %rsp;	
  802570:	48 89 fc             	mov    %rdi,%rsp
	movq %rbx, 152(%rsp)	
  802573:	48 89 9c 24 98 00 00 	mov    %rbx,0x98(%rsp)
  80257a:	00 
   
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16, %rsp;	
  80257b:	48 83 c4 10          	add    $0x10,%rsp
	POPA_;  // getting all register values back
  80257f:	4c 8b 3c 24          	mov    (%rsp),%r15
  802583:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  802588:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  80258d:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  802592:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  802597:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  80259c:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8025a1:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8025a6:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8025ab:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8025b0:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8025b5:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8025ba:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8025bf:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8025c4:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8025c9:	48 83 c4 78          	add    $0x78,%rsp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	add $8, %rsp; //Jump rip field  
  8025cd:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  8025d1:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp   //USTACK
  8025d2:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret   
  8025d3:	c3                   	retq   
