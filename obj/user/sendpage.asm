
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
  800052:	48 b8 23 1e 80 00 00 	movabs $0x801e23,%rax
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
  80007d:	48 b8 1b 21 80 00 00 	movabs $0x80211b,%rax
  800084:	00 00 00 
  800087:	ff d0                	callq  *%rax
		cprintf("%x got message : %s\n", who, TEMP_ADDR_CHILD);
  800089:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80008c:	ba 00 00 b0 00       	mov    $0xb00000,%edx
  800091:	89 c6                	mov    %eax,%esi
  800093:	48 bf ec 3d 80 00 00 	movabs $0x803dec,%rdi
  80009a:	00 00 00 
  80009d:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a2:	48 b9 7f 04 80 00 00 	movabs $0x80047f,%rcx
  8000a9:	00 00 00 
  8000ac:	ff d1                	callq  *%rcx
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  8000ae:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8000b5:	00 00 00 
  8000b8:	48 8b 00             	mov    (%rax),%rax
  8000bb:	48 89 c7             	mov    %rax,%rdi
  8000be:	48 b8 c8 0f 80 00 00 	movabs $0x800fc8,%rax
  8000c5:	00 00 00 
  8000c8:	ff d0                	callq  *%rax
  8000ca:	48 63 d0             	movslq %eax,%rdx
  8000cd:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8000d4:	00 00 00 
  8000d7:	48 8b 00             	mov    (%rax),%rax
  8000da:	48 89 c6             	mov    %rax,%rsi
  8000dd:	bf 00 00 b0 00       	mov    $0xb00000,%edi
  8000e2:	48 b8 e9 11 80 00 00 	movabs $0x8011e9,%rax
  8000e9:	00 00 00 
  8000ec:	ff d0                	callq  *%rax
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	75 1b                	jne    80010d <umain+0xca>
			cprintf("child received correct message\n");
  8000f2:	48 bf 08 3e 80 00 00 	movabs $0x803e08,%rdi
  8000f9:	00 00 00 
  8000fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800101:	48 ba 7f 04 80 00 00 	movabs $0x80047f,%rdx
  800108:	00 00 00 
  80010b:	ff d2                	callq  *%rdx

		memcpy(TEMP_ADDR_CHILD, str2, strlen(str1) + 1);
  80010d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800114:	00 00 00 
  800117:	48 8b 00             	mov    (%rax),%rax
  80011a:	48 89 c7             	mov    %rax,%rdi
  80011d:	48 b8 c8 0f 80 00 00 	movabs $0x800fc8,%rax
  800124:	00 00 00 
  800127:	ff d0                	callq  *%rax
  800129:	83 c0 01             	add    $0x1,%eax
  80012c:	48 63 d0             	movslq %eax,%rdx
  80012f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800136:	00 00 00 
  800139:	48 8b 00             	mov    (%rax),%rax
  80013c:	48 89 c6             	mov    %rax,%rsi
  80013f:	bf 00 00 b0 00       	mov    $0xb00000,%edi
  800144:	48 b8 6f 14 80 00 00 	movabs $0x80146f,%rax
  80014b:	00 00 00 
  80014e:	ff d0                	callq  *%rax
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  800150:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800153:	b9 07 00 00 00       	mov    $0x7,%ecx
  800158:	ba 00 00 b0 00       	mov    $0xb00000,%edx
  80015d:	be 00 00 00 00       	mov    $0x0,%esi
  800162:	89 c7                	mov    %eax,%edi
  800164:	48 b8 e1 21 80 00 00 	movabs $0x8021e1,%rax
  80016b:	00 00 00 
  80016e:	ff d0                	callq  *%rax
		return;
  800170:	e9 30 01 00 00       	jmpq   8002a5 <umain+0x262>
	}

	// Parent
	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800175:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80017c:	00 00 00 
  80017f:	48 8b 00             	mov    (%rax),%rax
  800182:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800188:	ba 07 00 00 00       	mov    $0x7,%edx
  80018d:	be 00 00 a0 00       	mov    $0xa00000,%esi
  800192:	89 c7                	mov    %eax,%edi
  800194:	48 b8 63 19 80 00 00 	movabs $0x801963,%rax
  80019b:	00 00 00 
  80019e:	ff d0                	callq  *%rax
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  8001a0:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001a7:	00 00 00 
  8001aa:	48 8b 00             	mov    (%rax),%rax
  8001ad:	48 89 c7             	mov    %rax,%rdi
  8001b0:	48 b8 c8 0f 80 00 00 	movabs $0x800fc8,%rax
  8001b7:	00 00 00 
  8001ba:	ff d0                	callq  *%rax
  8001bc:	83 c0 01             	add    $0x1,%eax
  8001bf:	48 63 d0             	movslq %eax,%rdx
  8001c2:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001c9:	00 00 00 
  8001cc:	48 8b 00             	mov    (%rax),%rax
  8001cf:	48 89 c6             	mov    %rax,%rsi
  8001d2:	bf 00 00 a0 00       	mov    $0xa00000,%edi
  8001d7:	48 b8 6f 14 80 00 00 	movabs $0x80146f,%rax
  8001de:	00 00 00 
  8001e1:	ff d0                	callq  *%rax
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  8001e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001e6:	b9 07 00 00 00       	mov    $0x7,%ecx
  8001eb:	ba 00 00 a0 00       	mov    $0xa00000,%edx
  8001f0:	be 00 00 00 00       	mov    $0x0,%esi
  8001f5:	89 c7                	mov    %eax,%edi
  8001f7:	48 b8 e1 21 80 00 00 	movabs $0x8021e1,%rax
  8001fe:	00 00 00 
  800201:	ff d0                	callq  *%rax

	ipc_recv(&who, TEMP_ADDR, 0);
  800203:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
  800207:	ba 00 00 00 00       	mov    $0x0,%edx
  80020c:	be 00 00 a0 00       	mov    $0xa00000,%esi
  800211:	48 89 c7             	mov    %rax,%rdi
  800214:	48 b8 1b 21 80 00 00 	movabs $0x80211b,%rax
  80021b:	00 00 00 
  80021e:	ff d0                	callq  *%rax
	cprintf("%x got message : %s\n", who, TEMP_ADDR);
  800220:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800223:	ba 00 00 a0 00       	mov    $0xa00000,%edx
  800228:	89 c6                	mov    %eax,%esi
  80022a:	48 bf ec 3d 80 00 00 	movabs $0x803dec,%rdi
  800231:	00 00 00 
  800234:	b8 00 00 00 00       	mov    $0x0,%eax
  800239:	48 b9 7f 04 80 00 00 	movabs $0x80047f,%rcx
  800240:	00 00 00 
  800243:	ff d1                	callq  *%rcx
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  800245:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80024c:	00 00 00 
  80024f:	48 8b 00             	mov    (%rax),%rax
  800252:	48 89 c7             	mov    %rax,%rdi
  800255:	48 b8 c8 0f 80 00 00 	movabs $0x800fc8,%rax
  80025c:	00 00 00 
  80025f:	ff d0                	callq  *%rax
  800261:	48 63 d0             	movslq %eax,%rdx
  800264:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80026b:	00 00 00 
  80026e:	48 8b 00             	mov    (%rax),%rax
  800271:	48 89 c6             	mov    %rax,%rsi
  800274:	bf 00 00 a0 00       	mov    $0xa00000,%edi
  800279:	48 b8 e9 11 80 00 00 	movabs $0x8011e9,%rax
  800280:	00 00 00 
  800283:	ff d0                	callq  *%rax
  800285:	85 c0                	test   %eax,%eax
  800287:	75 1b                	jne    8002a4 <umain+0x261>
		cprintf("parent received correct message\n");
  800289:	48 bf 28 3e 80 00 00 	movabs $0x803e28,%rdi
  800290:	00 00 00 
  800293:	b8 00 00 00 00       	mov    $0x0,%eax
  800298:	48 ba 7f 04 80 00 00 	movabs $0x80047f,%rdx
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
  8002ab:	48 83 ec 10          	sub    $0x10,%rsp
  8002af:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002b2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  8002b6:	48 b8 e7 18 80 00 00 	movabs $0x8018e7,%rax
  8002bd:	00 00 00 
  8002c0:	ff d0                	callq  *%rax
  8002c2:	48 98                	cltq   
  8002c4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002c9:	48 89 c2             	mov    %rax,%rdx
  8002cc:	48 89 d0             	mov    %rdx,%rax
  8002cf:	48 c1 e0 03          	shl    $0x3,%rax
  8002d3:	48 01 d0             	add    %rdx,%rax
  8002d6:	48 c1 e0 05          	shl    $0x5,%rax
  8002da:	48 89 c2             	mov    %rax,%rdx
  8002dd:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8002e4:	00 00 00 
  8002e7:	48 01 c2             	add    %rax,%rdx
  8002ea:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8002f1:	00 00 00 
  8002f4:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002fb:	7e 14                	jle    800311 <libmain+0x6a>
		binaryname = argv[0];
  8002fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800301:	48 8b 10             	mov    (%rax),%rdx
  800304:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  80030b:	00 00 00 
  80030e:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800311:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800315:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800318:	48 89 d6             	mov    %rdx,%rsi
  80031b:	89 c7                	mov    %eax,%edi
  80031d:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800324:	00 00 00 
  800327:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800329:	48 b8 37 03 80 00 00 	movabs $0x800337,%rax
  800330:	00 00 00 
  800333:	ff d0                	callq  *%rax
}
  800335:	c9                   	leaveq 
  800336:	c3                   	retq   

0000000000800337 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800337:	55                   	push   %rbp
  800338:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80033b:	48 b8 41 26 80 00 00 	movabs $0x802641,%rax
  800342:	00 00 00 
  800345:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800347:	bf 00 00 00 00       	mov    $0x0,%edi
  80034c:	48 b8 a3 18 80 00 00 	movabs $0x8018a3,%rax
  800353:	00 00 00 
  800356:	ff d0                	callq  *%rax
}
  800358:	5d                   	pop    %rbp
  800359:	c3                   	retq   

000000000080035a <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80035a:	55                   	push   %rbp
  80035b:	48 89 e5             	mov    %rsp,%rbp
  80035e:	48 83 ec 10          	sub    $0x10,%rsp
  800362:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800365:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800369:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80036d:	8b 00                	mov    (%rax),%eax
  80036f:	8d 48 01             	lea    0x1(%rax),%ecx
  800372:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800376:	89 0a                	mov    %ecx,(%rdx)
  800378:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80037b:	89 d1                	mov    %edx,%ecx
  80037d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800381:	48 98                	cltq   
  800383:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800387:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80038b:	8b 00                	mov    (%rax),%eax
  80038d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800392:	75 2c                	jne    8003c0 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800394:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800398:	8b 00                	mov    (%rax),%eax
  80039a:	48 98                	cltq   
  80039c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003a0:	48 83 c2 08          	add    $0x8,%rdx
  8003a4:	48 89 c6             	mov    %rax,%rsi
  8003a7:	48 89 d7             	mov    %rdx,%rdi
  8003aa:	48 b8 1b 18 80 00 00 	movabs $0x80181b,%rax
  8003b1:	00 00 00 
  8003b4:	ff d0                	callq  *%rax
        b->idx = 0;
  8003b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ba:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c4:	8b 40 04             	mov    0x4(%rax),%eax
  8003c7:	8d 50 01             	lea    0x1(%rax),%edx
  8003ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ce:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003d1:	c9                   	leaveq 
  8003d2:	c3                   	retq   

00000000008003d3 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8003d3:	55                   	push   %rbp
  8003d4:	48 89 e5             	mov    %rsp,%rbp
  8003d7:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003de:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003e5:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8003ec:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8003f3:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8003fa:	48 8b 0a             	mov    (%rdx),%rcx
  8003fd:	48 89 08             	mov    %rcx,(%rax)
  800400:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800404:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800408:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80040c:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800410:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800417:	00 00 00 
    b.cnt = 0;
  80041a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800421:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800424:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80042b:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800432:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800439:	48 89 c6             	mov    %rax,%rsi
  80043c:	48 bf 5a 03 80 00 00 	movabs $0x80035a,%rdi
  800443:	00 00 00 
  800446:	48 b8 32 08 80 00 00 	movabs $0x800832,%rax
  80044d:	00 00 00 
  800450:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800452:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800458:	48 98                	cltq   
  80045a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800461:	48 83 c2 08          	add    $0x8,%rdx
  800465:	48 89 c6             	mov    %rax,%rsi
  800468:	48 89 d7             	mov    %rdx,%rdi
  80046b:	48 b8 1b 18 80 00 00 	movabs $0x80181b,%rax
  800472:	00 00 00 
  800475:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800477:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80047d:	c9                   	leaveq 
  80047e:	c3                   	retq   

000000000080047f <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80047f:	55                   	push   %rbp
  800480:	48 89 e5             	mov    %rsp,%rbp
  800483:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80048a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800491:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800498:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80049f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004a6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004ad:	84 c0                	test   %al,%al
  8004af:	74 20                	je     8004d1 <cprintf+0x52>
  8004b1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004b5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004b9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004bd:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004c1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004c5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004c9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004cd:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004d1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8004d8:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004df:	00 00 00 
  8004e2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004e9:	00 00 00 
  8004ec:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004f0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8004f7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8004fe:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800505:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80050c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800513:	48 8b 0a             	mov    (%rdx),%rcx
  800516:	48 89 08             	mov    %rcx,(%rax)
  800519:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80051d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800521:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800525:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800529:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800530:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800537:	48 89 d6             	mov    %rdx,%rsi
  80053a:	48 89 c7             	mov    %rax,%rdi
  80053d:	48 b8 d3 03 80 00 00 	movabs $0x8003d3,%rax
  800544:	00 00 00 
  800547:	ff d0                	callq  *%rax
  800549:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80054f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800555:	c9                   	leaveq 
  800556:	c3                   	retq   

0000000000800557 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800557:	55                   	push   %rbp
  800558:	48 89 e5             	mov    %rsp,%rbp
  80055b:	53                   	push   %rbx
  80055c:	48 83 ec 38          	sub    $0x38,%rsp
  800560:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800564:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800568:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80056c:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80056f:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800573:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800577:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80057a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80057e:	77 3b                	ja     8005bb <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800580:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800583:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800587:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80058a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80058e:	ba 00 00 00 00       	mov    $0x0,%edx
  800593:	48 f7 f3             	div    %rbx
  800596:	48 89 c2             	mov    %rax,%rdx
  800599:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80059c:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80059f:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a7:	41 89 f9             	mov    %edi,%r9d
  8005aa:	48 89 c7             	mov    %rax,%rdi
  8005ad:	48 b8 57 05 80 00 00 	movabs $0x800557,%rax
  8005b4:	00 00 00 
  8005b7:	ff d0                	callq  *%rax
  8005b9:	eb 1e                	jmp    8005d9 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005bb:	eb 12                	jmp    8005cf <printnum+0x78>
			putch(padc, putdat);
  8005bd:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005c1:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c8:	48 89 ce             	mov    %rcx,%rsi
  8005cb:	89 d7                	mov    %edx,%edi
  8005cd:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005cf:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8005d3:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8005d7:	7f e4                	jg     8005bd <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005d9:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e5:	48 f7 f1             	div    %rcx
  8005e8:	48 89 d0             	mov    %rdx,%rax
  8005eb:	48 ba 50 40 80 00 00 	movabs $0x804050,%rdx
  8005f2:	00 00 00 
  8005f5:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8005f9:	0f be d0             	movsbl %al,%edx
  8005fc:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800600:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800604:	48 89 ce             	mov    %rcx,%rsi
  800607:	89 d7                	mov    %edx,%edi
  800609:	ff d0                	callq  *%rax
}
  80060b:	48 83 c4 38          	add    $0x38,%rsp
  80060f:	5b                   	pop    %rbx
  800610:	5d                   	pop    %rbp
  800611:	c3                   	retq   

0000000000800612 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800612:	55                   	push   %rbp
  800613:	48 89 e5             	mov    %rsp,%rbp
  800616:	48 83 ec 1c          	sub    $0x1c,%rsp
  80061a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80061e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800621:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800625:	7e 52                	jle    800679 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800627:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80062b:	8b 00                	mov    (%rax),%eax
  80062d:	83 f8 30             	cmp    $0x30,%eax
  800630:	73 24                	jae    800656 <getuint+0x44>
  800632:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800636:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80063a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063e:	8b 00                	mov    (%rax),%eax
  800640:	89 c0                	mov    %eax,%eax
  800642:	48 01 d0             	add    %rdx,%rax
  800645:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800649:	8b 12                	mov    (%rdx),%edx
  80064b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80064e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800652:	89 0a                	mov    %ecx,(%rdx)
  800654:	eb 17                	jmp    80066d <getuint+0x5b>
  800656:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80065e:	48 89 d0             	mov    %rdx,%rax
  800661:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800665:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800669:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80066d:	48 8b 00             	mov    (%rax),%rax
  800670:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800674:	e9 a3 00 00 00       	jmpq   80071c <getuint+0x10a>
	else if (lflag)
  800679:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80067d:	74 4f                	je     8006ce <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80067f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800683:	8b 00                	mov    (%rax),%eax
  800685:	83 f8 30             	cmp    $0x30,%eax
  800688:	73 24                	jae    8006ae <getuint+0x9c>
  80068a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800692:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800696:	8b 00                	mov    (%rax),%eax
  800698:	89 c0                	mov    %eax,%eax
  80069a:	48 01 d0             	add    %rdx,%rax
  80069d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a1:	8b 12                	mov    (%rdx),%edx
  8006a3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006aa:	89 0a                	mov    %ecx,(%rdx)
  8006ac:	eb 17                	jmp    8006c5 <getuint+0xb3>
  8006ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006b6:	48 89 d0             	mov    %rdx,%rax
  8006b9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006c5:	48 8b 00             	mov    (%rax),%rax
  8006c8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006cc:	eb 4e                	jmp    80071c <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d2:	8b 00                	mov    (%rax),%eax
  8006d4:	83 f8 30             	cmp    $0x30,%eax
  8006d7:	73 24                	jae    8006fd <getuint+0xeb>
  8006d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006dd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e5:	8b 00                	mov    (%rax),%eax
  8006e7:	89 c0                	mov    %eax,%eax
  8006e9:	48 01 d0             	add    %rdx,%rax
  8006ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f0:	8b 12                	mov    (%rdx),%edx
  8006f2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f9:	89 0a                	mov    %ecx,(%rdx)
  8006fb:	eb 17                	jmp    800714 <getuint+0x102>
  8006fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800701:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800705:	48 89 d0             	mov    %rdx,%rax
  800708:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80070c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800710:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800714:	8b 00                	mov    (%rax),%eax
  800716:	89 c0                	mov    %eax,%eax
  800718:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80071c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800720:	c9                   	leaveq 
  800721:	c3                   	retq   

0000000000800722 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800722:	55                   	push   %rbp
  800723:	48 89 e5             	mov    %rsp,%rbp
  800726:	48 83 ec 1c          	sub    $0x1c,%rsp
  80072a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80072e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800731:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800735:	7e 52                	jle    800789 <getint+0x67>
		x=va_arg(*ap, long long);
  800737:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073b:	8b 00                	mov    (%rax),%eax
  80073d:	83 f8 30             	cmp    $0x30,%eax
  800740:	73 24                	jae    800766 <getint+0x44>
  800742:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800746:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80074a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074e:	8b 00                	mov    (%rax),%eax
  800750:	89 c0                	mov    %eax,%eax
  800752:	48 01 d0             	add    %rdx,%rax
  800755:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800759:	8b 12                	mov    (%rdx),%edx
  80075b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80075e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800762:	89 0a                	mov    %ecx,(%rdx)
  800764:	eb 17                	jmp    80077d <getint+0x5b>
  800766:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80076e:	48 89 d0             	mov    %rdx,%rax
  800771:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800775:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800779:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80077d:	48 8b 00             	mov    (%rax),%rax
  800780:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800784:	e9 a3 00 00 00       	jmpq   80082c <getint+0x10a>
	else if (lflag)
  800789:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80078d:	74 4f                	je     8007de <getint+0xbc>
		x=va_arg(*ap, long);
  80078f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800793:	8b 00                	mov    (%rax),%eax
  800795:	83 f8 30             	cmp    $0x30,%eax
  800798:	73 24                	jae    8007be <getint+0x9c>
  80079a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a6:	8b 00                	mov    (%rax),%eax
  8007a8:	89 c0                	mov    %eax,%eax
  8007aa:	48 01 d0             	add    %rdx,%rax
  8007ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b1:	8b 12                	mov    (%rdx),%edx
  8007b3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ba:	89 0a                	mov    %ecx,(%rdx)
  8007bc:	eb 17                	jmp    8007d5 <getint+0xb3>
  8007be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007c6:	48 89 d0             	mov    %rdx,%rax
  8007c9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007d5:	48 8b 00             	mov    (%rax),%rax
  8007d8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007dc:	eb 4e                	jmp    80082c <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8007de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e2:	8b 00                	mov    (%rax),%eax
  8007e4:	83 f8 30             	cmp    $0x30,%eax
  8007e7:	73 24                	jae    80080d <getint+0xeb>
  8007e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ed:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f5:	8b 00                	mov    (%rax),%eax
  8007f7:	89 c0                	mov    %eax,%eax
  8007f9:	48 01 d0             	add    %rdx,%rax
  8007fc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800800:	8b 12                	mov    (%rdx),%edx
  800802:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800805:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800809:	89 0a                	mov    %ecx,(%rdx)
  80080b:	eb 17                	jmp    800824 <getint+0x102>
  80080d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800811:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800815:	48 89 d0             	mov    %rdx,%rax
  800818:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80081c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800820:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800824:	8b 00                	mov    (%rax),%eax
  800826:	48 98                	cltq   
  800828:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80082c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800830:	c9                   	leaveq 
  800831:	c3                   	retq   

0000000000800832 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800832:	55                   	push   %rbp
  800833:	48 89 e5             	mov    %rsp,%rbp
  800836:	41 54                	push   %r12
  800838:	53                   	push   %rbx
  800839:	48 83 ec 60          	sub    $0x60,%rsp
  80083d:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800841:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800845:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800849:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80084d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800851:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800855:	48 8b 0a             	mov    (%rdx),%rcx
  800858:	48 89 08             	mov    %rcx,(%rax)
  80085b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80085f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800863:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800867:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80086b:	eb 17                	jmp    800884 <vprintfmt+0x52>
			if (ch == '\0')
  80086d:	85 db                	test   %ebx,%ebx
  80086f:	0f 84 cc 04 00 00    	je     800d41 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800875:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800879:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80087d:	48 89 d6             	mov    %rdx,%rsi
  800880:	89 df                	mov    %ebx,%edi
  800882:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800884:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800888:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80088c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800890:	0f b6 00             	movzbl (%rax),%eax
  800893:	0f b6 d8             	movzbl %al,%ebx
  800896:	83 fb 25             	cmp    $0x25,%ebx
  800899:	75 d2                	jne    80086d <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80089b:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80089f:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008a6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008ad:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008b4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008bb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008bf:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008c3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008c7:	0f b6 00             	movzbl (%rax),%eax
  8008ca:	0f b6 d8             	movzbl %al,%ebx
  8008cd:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008d0:	83 f8 55             	cmp    $0x55,%eax
  8008d3:	0f 87 34 04 00 00    	ja     800d0d <vprintfmt+0x4db>
  8008d9:	89 c0                	mov    %eax,%eax
  8008db:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008e2:	00 
  8008e3:	48 b8 78 40 80 00 00 	movabs $0x804078,%rax
  8008ea:	00 00 00 
  8008ed:	48 01 d0             	add    %rdx,%rax
  8008f0:	48 8b 00             	mov    (%rax),%rax
  8008f3:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8008f5:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8008f9:	eb c0                	jmp    8008bb <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008fb:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8008ff:	eb ba                	jmp    8008bb <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800901:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800908:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80090b:	89 d0                	mov    %edx,%eax
  80090d:	c1 e0 02             	shl    $0x2,%eax
  800910:	01 d0                	add    %edx,%eax
  800912:	01 c0                	add    %eax,%eax
  800914:	01 d8                	add    %ebx,%eax
  800916:	83 e8 30             	sub    $0x30,%eax
  800919:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80091c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800920:	0f b6 00             	movzbl (%rax),%eax
  800923:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800926:	83 fb 2f             	cmp    $0x2f,%ebx
  800929:	7e 0c                	jle    800937 <vprintfmt+0x105>
  80092b:	83 fb 39             	cmp    $0x39,%ebx
  80092e:	7f 07                	jg     800937 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800930:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800935:	eb d1                	jmp    800908 <vprintfmt+0xd6>
			goto process_precision;
  800937:	eb 58                	jmp    800991 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800939:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80093c:	83 f8 30             	cmp    $0x30,%eax
  80093f:	73 17                	jae    800958 <vprintfmt+0x126>
  800941:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800945:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800948:	89 c0                	mov    %eax,%eax
  80094a:	48 01 d0             	add    %rdx,%rax
  80094d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800950:	83 c2 08             	add    $0x8,%edx
  800953:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800956:	eb 0f                	jmp    800967 <vprintfmt+0x135>
  800958:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80095c:	48 89 d0             	mov    %rdx,%rax
  80095f:	48 83 c2 08          	add    $0x8,%rdx
  800963:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800967:	8b 00                	mov    (%rax),%eax
  800969:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80096c:	eb 23                	jmp    800991 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80096e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800972:	79 0c                	jns    800980 <vprintfmt+0x14e>
				width = 0;
  800974:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80097b:	e9 3b ff ff ff       	jmpq   8008bb <vprintfmt+0x89>
  800980:	e9 36 ff ff ff       	jmpq   8008bb <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800985:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80098c:	e9 2a ff ff ff       	jmpq   8008bb <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800991:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800995:	79 12                	jns    8009a9 <vprintfmt+0x177>
				width = precision, precision = -1;
  800997:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80099a:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80099d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009a4:	e9 12 ff ff ff       	jmpq   8008bb <vprintfmt+0x89>
  8009a9:	e9 0d ff ff ff       	jmpq   8008bb <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009ae:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009b2:	e9 04 ff ff ff       	jmpq   8008bb <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009b7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ba:	83 f8 30             	cmp    $0x30,%eax
  8009bd:	73 17                	jae    8009d6 <vprintfmt+0x1a4>
  8009bf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009c3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c6:	89 c0                	mov    %eax,%eax
  8009c8:	48 01 d0             	add    %rdx,%rax
  8009cb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009ce:	83 c2 08             	add    $0x8,%edx
  8009d1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009d4:	eb 0f                	jmp    8009e5 <vprintfmt+0x1b3>
  8009d6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009da:	48 89 d0             	mov    %rdx,%rax
  8009dd:	48 83 c2 08          	add    $0x8,%rdx
  8009e1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009e5:	8b 10                	mov    (%rax),%edx
  8009e7:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009eb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009ef:	48 89 ce             	mov    %rcx,%rsi
  8009f2:	89 d7                	mov    %edx,%edi
  8009f4:	ff d0                	callq  *%rax
			break;
  8009f6:	e9 40 03 00 00       	jmpq   800d3b <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8009fb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009fe:	83 f8 30             	cmp    $0x30,%eax
  800a01:	73 17                	jae    800a1a <vprintfmt+0x1e8>
  800a03:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a07:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a0a:	89 c0                	mov    %eax,%eax
  800a0c:	48 01 d0             	add    %rdx,%rax
  800a0f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a12:	83 c2 08             	add    $0x8,%edx
  800a15:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a18:	eb 0f                	jmp    800a29 <vprintfmt+0x1f7>
  800a1a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a1e:	48 89 d0             	mov    %rdx,%rax
  800a21:	48 83 c2 08          	add    $0x8,%rdx
  800a25:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a29:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a2b:	85 db                	test   %ebx,%ebx
  800a2d:	79 02                	jns    800a31 <vprintfmt+0x1ff>
				err = -err;
  800a2f:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a31:	83 fb 15             	cmp    $0x15,%ebx
  800a34:	7f 16                	jg     800a4c <vprintfmt+0x21a>
  800a36:	48 b8 a0 3f 80 00 00 	movabs $0x803fa0,%rax
  800a3d:	00 00 00 
  800a40:	48 63 d3             	movslq %ebx,%rdx
  800a43:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a47:	4d 85 e4             	test   %r12,%r12
  800a4a:	75 2e                	jne    800a7a <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a4c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a50:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a54:	89 d9                	mov    %ebx,%ecx
  800a56:	48 ba 61 40 80 00 00 	movabs $0x804061,%rdx
  800a5d:	00 00 00 
  800a60:	48 89 c7             	mov    %rax,%rdi
  800a63:	b8 00 00 00 00       	mov    $0x0,%eax
  800a68:	49 b8 4a 0d 80 00 00 	movabs $0x800d4a,%r8
  800a6f:	00 00 00 
  800a72:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a75:	e9 c1 02 00 00       	jmpq   800d3b <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a7a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a7e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a82:	4c 89 e1             	mov    %r12,%rcx
  800a85:	48 ba 6a 40 80 00 00 	movabs $0x80406a,%rdx
  800a8c:	00 00 00 
  800a8f:	48 89 c7             	mov    %rax,%rdi
  800a92:	b8 00 00 00 00       	mov    $0x0,%eax
  800a97:	49 b8 4a 0d 80 00 00 	movabs $0x800d4a,%r8
  800a9e:	00 00 00 
  800aa1:	41 ff d0             	callq  *%r8
			break;
  800aa4:	e9 92 02 00 00       	jmpq   800d3b <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800aa9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aac:	83 f8 30             	cmp    $0x30,%eax
  800aaf:	73 17                	jae    800ac8 <vprintfmt+0x296>
  800ab1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ab5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ab8:	89 c0                	mov    %eax,%eax
  800aba:	48 01 d0             	add    %rdx,%rax
  800abd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ac0:	83 c2 08             	add    $0x8,%edx
  800ac3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ac6:	eb 0f                	jmp    800ad7 <vprintfmt+0x2a5>
  800ac8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800acc:	48 89 d0             	mov    %rdx,%rax
  800acf:	48 83 c2 08          	add    $0x8,%rdx
  800ad3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ad7:	4c 8b 20             	mov    (%rax),%r12
  800ada:	4d 85 e4             	test   %r12,%r12
  800add:	75 0a                	jne    800ae9 <vprintfmt+0x2b7>
				p = "(null)";
  800adf:	49 bc 6d 40 80 00 00 	movabs $0x80406d,%r12
  800ae6:	00 00 00 
			if (width > 0 && padc != '-')
  800ae9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800aed:	7e 3f                	jle    800b2e <vprintfmt+0x2fc>
  800aef:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800af3:	74 39                	je     800b2e <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800af5:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800af8:	48 98                	cltq   
  800afa:	48 89 c6             	mov    %rax,%rsi
  800afd:	4c 89 e7             	mov    %r12,%rdi
  800b00:	48 b8 f6 0f 80 00 00 	movabs $0x800ff6,%rax
  800b07:	00 00 00 
  800b0a:	ff d0                	callq  *%rax
  800b0c:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b0f:	eb 17                	jmp    800b28 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b11:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b15:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b19:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b1d:	48 89 ce             	mov    %rcx,%rsi
  800b20:	89 d7                	mov    %edx,%edi
  800b22:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b24:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b28:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b2c:	7f e3                	jg     800b11 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b2e:	eb 37                	jmp    800b67 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b30:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b34:	74 1e                	je     800b54 <vprintfmt+0x322>
  800b36:	83 fb 1f             	cmp    $0x1f,%ebx
  800b39:	7e 05                	jle    800b40 <vprintfmt+0x30e>
  800b3b:	83 fb 7e             	cmp    $0x7e,%ebx
  800b3e:	7e 14                	jle    800b54 <vprintfmt+0x322>
					putch('?', putdat);
  800b40:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b44:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b48:	48 89 d6             	mov    %rdx,%rsi
  800b4b:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b50:	ff d0                	callq  *%rax
  800b52:	eb 0f                	jmp    800b63 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b54:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b58:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b5c:	48 89 d6             	mov    %rdx,%rsi
  800b5f:	89 df                	mov    %ebx,%edi
  800b61:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b63:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b67:	4c 89 e0             	mov    %r12,%rax
  800b6a:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b6e:	0f b6 00             	movzbl (%rax),%eax
  800b71:	0f be d8             	movsbl %al,%ebx
  800b74:	85 db                	test   %ebx,%ebx
  800b76:	74 10                	je     800b88 <vprintfmt+0x356>
  800b78:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b7c:	78 b2                	js     800b30 <vprintfmt+0x2fe>
  800b7e:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b82:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b86:	79 a8                	jns    800b30 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b88:	eb 16                	jmp    800ba0 <vprintfmt+0x36e>
				putch(' ', putdat);
  800b8a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b8e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b92:	48 89 d6             	mov    %rdx,%rsi
  800b95:	bf 20 00 00 00       	mov    $0x20,%edi
  800b9a:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b9c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ba0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ba4:	7f e4                	jg     800b8a <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800ba6:	e9 90 01 00 00       	jmpq   800d3b <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800bab:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800baf:	be 03 00 00 00       	mov    $0x3,%esi
  800bb4:	48 89 c7             	mov    %rax,%rdi
  800bb7:	48 b8 22 07 80 00 00 	movabs $0x800722,%rax
  800bbe:	00 00 00 
  800bc1:	ff d0                	callq  *%rax
  800bc3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800bc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bcb:	48 85 c0             	test   %rax,%rax
  800bce:	79 1d                	jns    800bed <vprintfmt+0x3bb>
				putch('-', putdat);
  800bd0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bd4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bd8:	48 89 d6             	mov    %rdx,%rsi
  800bdb:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800be0:	ff d0                	callq  *%rax
				num = -(long long) num;
  800be2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800be6:	48 f7 d8             	neg    %rax
  800be9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800bed:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800bf4:	e9 d5 00 00 00       	jmpq   800cce <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800bf9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bfd:	be 03 00 00 00       	mov    $0x3,%esi
  800c02:	48 89 c7             	mov    %rax,%rdi
  800c05:	48 b8 12 06 80 00 00 	movabs $0x800612,%rax
  800c0c:	00 00 00 
  800c0f:	ff d0                	callq  *%rax
  800c11:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c15:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c1c:	e9 ad 00 00 00       	jmpq   800cce <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  800c21:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c25:	be 03 00 00 00       	mov    $0x3,%esi
  800c2a:	48 89 c7             	mov    %rax,%rdi
  800c2d:	48 b8 12 06 80 00 00 	movabs $0x800612,%rax
  800c34:	00 00 00 
  800c37:	ff d0                	callq  *%rax
  800c39:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  800c3d:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  800c44:	e9 85 00 00 00       	jmpq   800cce <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  800c49:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c4d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c51:	48 89 d6             	mov    %rdx,%rsi
  800c54:	bf 30 00 00 00       	mov    $0x30,%edi
  800c59:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c5b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c5f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c63:	48 89 d6             	mov    %rdx,%rsi
  800c66:	bf 78 00 00 00       	mov    $0x78,%edi
  800c6b:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c6d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c70:	83 f8 30             	cmp    $0x30,%eax
  800c73:	73 17                	jae    800c8c <vprintfmt+0x45a>
  800c75:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c79:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c7c:	89 c0                	mov    %eax,%eax
  800c7e:	48 01 d0             	add    %rdx,%rax
  800c81:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c84:	83 c2 08             	add    $0x8,%edx
  800c87:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c8a:	eb 0f                	jmp    800c9b <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800c8c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c90:	48 89 d0             	mov    %rdx,%rax
  800c93:	48 83 c2 08          	add    $0x8,%rdx
  800c97:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c9b:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c9e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800ca2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800ca9:	eb 23                	jmp    800cce <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800cab:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800caf:	be 03 00 00 00       	mov    $0x3,%esi
  800cb4:	48 89 c7             	mov    %rax,%rdi
  800cb7:	48 b8 12 06 80 00 00 	movabs $0x800612,%rax
  800cbe:	00 00 00 
  800cc1:	ff d0                	callq  *%rax
  800cc3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800cc7:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cce:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800cd3:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800cd6:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800cd9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cdd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ce1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ce5:	45 89 c1             	mov    %r8d,%r9d
  800ce8:	41 89 f8             	mov    %edi,%r8d
  800ceb:	48 89 c7             	mov    %rax,%rdi
  800cee:	48 b8 57 05 80 00 00 	movabs $0x800557,%rax
  800cf5:	00 00 00 
  800cf8:	ff d0                	callq  *%rax
			break;
  800cfa:	eb 3f                	jmp    800d3b <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cfc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d00:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d04:	48 89 d6             	mov    %rdx,%rsi
  800d07:	89 df                	mov    %ebx,%edi
  800d09:	ff d0                	callq  *%rax
			break;
  800d0b:	eb 2e                	jmp    800d3b <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d0d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d11:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d15:	48 89 d6             	mov    %rdx,%rsi
  800d18:	bf 25 00 00 00       	mov    $0x25,%edi
  800d1d:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d1f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d24:	eb 05                	jmp    800d2b <vprintfmt+0x4f9>
  800d26:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d2b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d2f:	48 83 e8 01          	sub    $0x1,%rax
  800d33:	0f b6 00             	movzbl (%rax),%eax
  800d36:	3c 25                	cmp    $0x25,%al
  800d38:	75 ec                	jne    800d26 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800d3a:	90                   	nop
		}
	}
  800d3b:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d3c:	e9 43 fb ff ff       	jmpq   800884 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d41:	48 83 c4 60          	add    $0x60,%rsp
  800d45:	5b                   	pop    %rbx
  800d46:	41 5c                	pop    %r12
  800d48:	5d                   	pop    %rbp
  800d49:	c3                   	retq   

0000000000800d4a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d4a:	55                   	push   %rbp
  800d4b:	48 89 e5             	mov    %rsp,%rbp
  800d4e:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d55:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d5c:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d63:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d6a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d71:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d78:	84 c0                	test   %al,%al
  800d7a:	74 20                	je     800d9c <printfmt+0x52>
  800d7c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d80:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d84:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d88:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d8c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d90:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d94:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d98:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d9c:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800da3:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800daa:	00 00 00 
  800dad:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800db4:	00 00 00 
  800db7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dbb:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800dc2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dc9:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800dd0:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800dd7:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800dde:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800de5:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800dec:	48 89 c7             	mov    %rax,%rdi
  800def:	48 b8 32 08 80 00 00 	movabs $0x800832,%rax
  800df6:	00 00 00 
  800df9:	ff d0                	callq  *%rax
	va_end(ap);
}
  800dfb:	c9                   	leaveq 
  800dfc:	c3                   	retq   

0000000000800dfd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800dfd:	55                   	push   %rbp
  800dfe:	48 89 e5             	mov    %rsp,%rbp
  800e01:	48 83 ec 10          	sub    $0x10,%rsp
  800e05:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e08:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e10:	8b 40 10             	mov    0x10(%rax),%eax
  800e13:	8d 50 01             	lea    0x1(%rax),%edx
  800e16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e1a:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e21:	48 8b 10             	mov    (%rax),%rdx
  800e24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e28:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e2c:	48 39 c2             	cmp    %rax,%rdx
  800e2f:	73 17                	jae    800e48 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e35:	48 8b 00             	mov    (%rax),%rax
  800e38:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e3c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e40:	48 89 0a             	mov    %rcx,(%rdx)
  800e43:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e46:	88 10                	mov    %dl,(%rax)
}
  800e48:	c9                   	leaveq 
  800e49:	c3                   	retq   

0000000000800e4a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e4a:	55                   	push   %rbp
  800e4b:	48 89 e5             	mov    %rsp,%rbp
  800e4e:	48 83 ec 50          	sub    $0x50,%rsp
  800e52:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e56:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e59:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e5d:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e61:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e65:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e69:	48 8b 0a             	mov    (%rdx),%rcx
  800e6c:	48 89 08             	mov    %rcx,(%rax)
  800e6f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e73:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e77:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e7b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e7f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e83:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800e87:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e8a:	48 98                	cltq   
  800e8c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800e90:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e94:	48 01 d0             	add    %rdx,%rax
  800e97:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800e9b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ea2:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ea7:	74 06                	je     800eaf <vsnprintf+0x65>
  800ea9:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ead:	7f 07                	jg     800eb6 <vsnprintf+0x6c>
		return -E_INVAL;
  800eaf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eb4:	eb 2f                	jmp    800ee5 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800eb6:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800eba:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ebe:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ec2:	48 89 c6             	mov    %rax,%rsi
  800ec5:	48 bf fd 0d 80 00 00 	movabs $0x800dfd,%rdi
  800ecc:	00 00 00 
  800ecf:	48 b8 32 08 80 00 00 	movabs $0x800832,%rax
  800ed6:	00 00 00 
  800ed9:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800edb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800edf:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800ee2:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800ee5:	c9                   	leaveq 
  800ee6:	c3                   	retq   

0000000000800ee7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ee7:	55                   	push   %rbp
  800ee8:	48 89 e5             	mov    %rsp,%rbp
  800eeb:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800ef2:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800ef9:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800eff:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f06:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f0d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f14:	84 c0                	test   %al,%al
  800f16:	74 20                	je     800f38 <snprintf+0x51>
  800f18:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f1c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f20:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f24:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f28:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f2c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f30:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f34:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f38:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f3f:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f46:	00 00 00 
  800f49:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f50:	00 00 00 
  800f53:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f57:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f5e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f65:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f6c:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f73:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f7a:	48 8b 0a             	mov    (%rdx),%rcx
  800f7d:	48 89 08             	mov    %rcx,(%rax)
  800f80:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f84:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f88:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f8c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800f90:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800f97:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800f9e:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fa4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fab:	48 89 c7             	mov    %rax,%rdi
  800fae:	48 b8 4a 0e 80 00 00 	movabs $0x800e4a,%rax
  800fb5:	00 00 00 
  800fb8:	ff d0                	callq  *%rax
  800fba:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800fc0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800fc6:	c9                   	leaveq 
  800fc7:	c3                   	retq   

0000000000800fc8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800fc8:	55                   	push   %rbp
  800fc9:	48 89 e5             	mov    %rsp,%rbp
  800fcc:	48 83 ec 18          	sub    $0x18,%rsp
  800fd0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800fd4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fdb:	eb 09                	jmp    800fe6 <strlen+0x1e>
		n++;
  800fdd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800fe1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fe6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fea:	0f b6 00             	movzbl (%rax),%eax
  800fed:	84 c0                	test   %al,%al
  800fef:	75 ec                	jne    800fdd <strlen+0x15>
		n++;
	return n;
  800ff1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ff4:	c9                   	leaveq 
  800ff5:	c3                   	retq   

0000000000800ff6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ff6:	55                   	push   %rbp
  800ff7:	48 89 e5             	mov    %rsp,%rbp
  800ffa:	48 83 ec 20          	sub    $0x20,%rsp
  800ffe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801002:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801006:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80100d:	eb 0e                	jmp    80101d <strnlen+0x27>
		n++;
  80100f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801013:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801018:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80101d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801022:	74 0b                	je     80102f <strnlen+0x39>
  801024:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801028:	0f b6 00             	movzbl (%rax),%eax
  80102b:	84 c0                	test   %al,%al
  80102d:	75 e0                	jne    80100f <strnlen+0x19>
		n++;
	return n;
  80102f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801032:	c9                   	leaveq 
  801033:	c3                   	retq   

0000000000801034 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801034:	55                   	push   %rbp
  801035:	48 89 e5             	mov    %rsp,%rbp
  801038:	48 83 ec 20          	sub    $0x20,%rsp
  80103c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801040:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801044:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801048:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80104c:	90                   	nop
  80104d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801051:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801055:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801059:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80105d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801061:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801065:	0f b6 12             	movzbl (%rdx),%edx
  801068:	88 10                	mov    %dl,(%rax)
  80106a:	0f b6 00             	movzbl (%rax),%eax
  80106d:	84 c0                	test   %al,%al
  80106f:	75 dc                	jne    80104d <strcpy+0x19>
		/* do nothing */;
	return ret;
  801071:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801075:	c9                   	leaveq 
  801076:	c3                   	retq   

0000000000801077 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801077:	55                   	push   %rbp
  801078:	48 89 e5             	mov    %rsp,%rbp
  80107b:	48 83 ec 20          	sub    $0x20,%rsp
  80107f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801083:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801087:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108b:	48 89 c7             	mov    %rax,%rdi
  80108e:	48 b8 c8 0f 80 00 00 	movabs $0x800fc8,%rax
  801095:	00 00 00 
  801098:	ff d0                	callq  *%rax
  80109a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80109d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010a0:	48 63 d0             	movslq %eax,%rdx
  8010a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a7:	48 01 c2             	add    %rax,%rdx
  8010aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010ae:	48 89 c6             	mov    %rax,%rsi
  8010b1:	48 89 d7             	mov    %rdx,%rdi
  8010b4:	48 b8 34 10 80 00 00 	movabs $0x801034,%rax
  8010bb:	00 00 00 
  8010be:	ff d0                	callq  *%rax
	return dst;
  8010c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010c4:	c9                   	leaveq 
  8010c5:	c3                   	retq   

00000000008010c6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010c6:	55                   	push   %rbp
  8010c7:	48 89 e5             	mov    %rsp,%rbp
  8010ca:	48 83 ec 28          	sub    $0x28,%rsp
  8010ce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010d2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010d6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8010da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010de:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8010e2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8010e9:	00 
  8010ea:	eb 2a                	jmp    801116 <strncpy+0x50>
		*dst++ = *src;
  8010ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010f4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010f8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010fc:	0f b6 12             	movzbl (%rdx),%edx
  8010ff:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801101:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801105:	0f b6 00             	movzbl (%rax),%eax
  801108:	84 c0                	test   %al,%al
  80110a:	74 05                	je     801111 <strncpy+0x4b>
			src++;
  80110c:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801111:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801116:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80111a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80111e:	72 cc                	jb     8010ec <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801120:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801124:	c9                   	leaveq 
  801125:	c3                   	retq   

0000000000801126 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801126:	55                   	push   %rbp
  801127:	48 89 e5             	mov    %rsp,%rbp
  80112a:	48 83 ec 28          	sub    $0x28,%rsp
  80112e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801132:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801136:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80113a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801142:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801147:	74 3d                	je     801186 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801149:	eb 1d                	jmp    801168 <strlcpy+0x42>
			*dst++ = *src++;
  80114b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80114f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801153:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801157:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80115b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80115f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801163:	0f b6 12             	movzbl (%rdx),%edx
  801166:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801168:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80116d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801172:	74 0b                	je     80117f <strlcpy+0x59>
  801174:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801178:	0f b6 00             	movzbl (%rax),%eax
  80117b:	84 c0                	test   %al,%al
  80117d:	75 cc                	jne    80114b <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80117f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801183:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801186:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80118a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80118e:	48 29 c2             	sub    %rax,%rdx
  801191:	48 89 d0             	mov    %rdx,%rax
}
  801194:	c9                   	leaveq 
  801195:	c3                   	retq   

0000000000801196 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801196:	55                   	push   %rbp
  801197:	48 89 e5             	mov    %rsp,%rbp
  80119a:	48 83 ec 10          	sub    $0x10,%rsp
  80119e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011a2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011a6:	eb 0a                	jmp    8011b2 <strcmp+0x1c>
		p++, q++;
  8011a8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011ad:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011b6:	0f b6 00             	movzbl (%rax),%eax
  8011b9:	84 c0                	test   %al,%al
  8011bb:	74 12                	je     8011cf <strcmp+0x39>
  8011bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c1:	0f b6 10             	movzbl (%rax),%edx
  8011c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011c8:	0f b6 00             	movzbl (%rax),%eax
  8011cb:	38 c2                	cmp    %al,%dl
  8011cd:	74 d9                	je     8011a8 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d3:	0f b6 00             	movzbl (%rax),%eax
  8011d6:	0f b6 d0             	movzbl %al,%edx
  8011d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011dd:	0f b6 00             	movzbl (%rax),%eax
  8011e0:	0f b6 c0             	movzbl %al,%eax
  8011e3:	29 c2                	sub    %eax,%edx
  8011e5:	89 d0                	mov    %edx,%eax
}
  8011e7:	c9                   	leaveq 
  8011e8:	c3                   	retq   

00000000008011e9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011e9:	55                   	push   %rbp
  8011ea:	48 89 e5             	mov    %rsp,%rbp
  8011ed:	48 83 ec 18          	sub    $0x18,%rsp
  8011f1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011f5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8011f9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8011fd:	eb 0f                	jmp    80120e <strncmp+0x25>
		n--, p++, q++;
  8011ff:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801204:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801209:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80120e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801213:	74 1d                	je     801232 <strncmp+0x49>
  801215:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801219:	0f b6 00             	movzbl (%rax),%eax
  80121c:	84 c0                	test   %al,%al
  80121e:	74 12                	je     801232 <strncmp+0x49>
  801220:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801224:	0f b6 10             	movzbl (%rax),%edx
  801227:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80122b:	0f b6 00             	movzbl (%rax),%eax
  80122e:	38 c2                	cmp    %al,%dl
  801230:	74 cd                	je     8011ff <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801232:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801237:	75 07                	jne    801240 <strncmp+0x57>
		return 0;
  801239:	b8 00 00 00 00       	mov    $0x0,%eax
  80123e:	eb 18                	jmp    801258 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801240:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801244:	0f b6 00             	movzbl (%rax),%eax
  801247:	0f b6 d0             	movzbl %al,%edx
  80124a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80124e:	0f b6 00             	movzbl (%rax),%eax
  801251:	0f b6 c0             	movzbl %al,%eax
  801254:	29 c2                	sub    %eax,%edx
  801256:	89 d0                	mov    %edx,%eax
}
  801258:	c9                   	leaveq 
  801259:	c3                   	retq   

000000000080125a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80125a:	55                   	push   %rbp
  80125b:	48 89 e5             	mov    %rsp,%rbp
  80125e:	48 83 ec 0c          	sub    $0xc,%rsp
  801262:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801266:	89 f0                	mov    %esi,%eax
  801268:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80126b:	eb 17                	jmp    801284 <strchr+0x2a>
		if (*s == c)
  80126d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801271:	0f b6 00             	movzbl (%rax),%eax
  801274:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801277:	75 06                	jne    80127f <strchr+0x25>
			return (char *) s;
  801279:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127d:	eb 15                	jmp    801294 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80127f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801284:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801288:	0f b6 00             	movzbl (%rax),%eax
  80128b:	84 c0                	test   %al,%al
  80128d:	75 de                	jne    80126d <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80128f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801294:	c9                   	leaveq 
  801295:	c3                   	retq   

0000000000801296 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801296:	55                   	push   %rbp
  801297:	48 89 e5             	mov    %rsp,%rbp
  80129a:	48 83 ec 0c          	sub    $0xc,%rsp
  80129e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012a2:	89 f0                	mov    %esi,%eax
  8012a4:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012a7:	eb 13                	jmp    8012bc <strfind+0x26>
		if (*s == c)
  8012a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ad:	0f b6 00             	movzbl (%rax),%eax
  8012b0:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012b3:	75 02                	jne    8012b7 <strfind+0x21>
			break;
  8012b5:	eb 10                	jmp    8012c7 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012b7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c0:	0f b6 00             	movzbl (%rax),%eax
  8012c3:	84 c0                	test   %al,%al
  8012c5:	75 e2                	jne    8012a9 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8012c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012cb:	c9                   	leaveq 
  8012cc:	c3                   	retq   

00000000008012cd <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012cd:	55                   	push   %rbp
  8012ce:	48 89 e5             	mov    %rsp,%rbp
  8012d1:	48 83 ec 18          	sub    $0x18,%rsp
  8012d5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012d9:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8012dc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8012e0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012e5:	75 06                	jne    8012ed <memset+0x20>
		return v;
  8012e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012eb:	eb 69                	jmp    801356 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8012ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f1:	83 e0 03             	and    $0x3,%eax
  8012f4:	48 85 c0             	test   %rax,%rax
  8012f7:	75 48                	jne    801341 <memset+0x74>
  8012f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012fd:	83 e0 03             	and    $0x3,%eax
  801300:	48 85 c0             	test   %rax,%rax
  801303:	75 3c                	jne    801341 <memset+0x74>
		c &= 0xFF;
  801305:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80130c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80130f:	c1 e0 18             	shl    $0x18,%eax
  801312:	89 c2                	mov    %eax,%edx
  801314:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801317:	c1 e0 10             	shl    $0x10,%eax
  80131a:	09 c2                	or     %eax,%edx
  80131c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80131f:	c1 e0 08             	shl    $0x8,%eax
  801322:	09 d0                	or     %edx,%eax
  801324:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801327:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132b:	48 c1 e8 02          	shr    $0x2,%rax
  80132f:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801332:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801336:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801339:	48 89 d7             	mov    %rdx,%rdi
  80133c:	fc                   	cld    
  80133d:	f3 ab                	rep stos %eax,%es:(%rdi)
  80133f:	eb 11                	jmp    801352 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801341:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801345:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801348:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80134c:	48 89 d7             	mov    %rdx,%rdi
  80134f:	fc                   	cld    
  801350:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801352:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801356:	c9                   	leaveq 
  801357:	c3                   	retq   

0000000000801358 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801358:	55                   	push   %rbp
  801359:	48 89 e5             	mov    %rsp,%rbp
  80135c:	48 83 ec 28          	sub    $0x28,%rsp
  801360:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801364:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801368:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80136c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801370:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801374:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801378:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80137c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801380:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801384:	0f 83 88 00 00 00    	jae    801412 <memmove+0xba>
  80138a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80138e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801392:	48 01 d0             	add    %rdx,%rax
  801395:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801399:	76 77                	jbe    801412 <memmove+0xba>
		s += n;
  80139b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80139f:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a7:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013af:	83 e0 03             	and    $0x3,%eax
  8013b2:	48 85 c0             	test   %rax,%rax
  8013b5:	75 3b                	jne    8013f2 <memmove+0x9a>
  8013b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013bb:	83 e0 03             	and    $0x3,%eax
  8013be:	48 85 c0             	test   %rax,%rax
  8013c1:	75 2f                	jne    8013f2 <memmove+0x9a>
  8013c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c7:	83 e0 03             	and    $0x3,%eax
  8013ca:	48 85 c0             	test   %rax,%rax
  8013cd:	75 23                	jne    8013f2 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013d3:	48 83 e8 04          	sub    $0x4,%rax
  8013d7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013db:	48 83 ea 04          	sub    $0x4,%rdx
  8013df:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013e3:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8013e7:	48 89 c7             	mov    %rax,%rdi
  8013ea:	48 89 d6             	mov    %rdx,%rsi
  8013ed:	fd                   	std    
  8013ee:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013f0:	eb 1d                	jmp    80140f <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8013f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013f6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013fe:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801402:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801406:	48 89 d7             	mov    %rdx,%rdi
  801409:	48 89 c1             	mov    %rax,%rcx
  80140c:	fd                   	std    
  80140d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80140f:	fc                   	cld    
  801410:	eb 57                	jmp    801469 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801412:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801416:	83 e0 03             	and    $0x3,%eax
  801419:	48 85 c0             	test   %rax,%rax
  80141c:	75 36                	jne    801454 <memmove+0xfc>
  80141e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801422:	83 e0 03             	and    $0x3,%eax
  801425:	48 85 c0             	test   %rax,%rax
  801428:	75 2a                	jne    801454 <memmove+0xfc>
  80142a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142e:	83 e0 03             	and    $0x3,%eax
  801431:	48 85 c0             	test   %rax,%rax
  801434:	75 1e                	jne    801454 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801436:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143a:	48 c1 e8 02          	shr    $0x2,%rax
  80143e:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801441:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801445:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801449:	48 89 c7             	mov    %rax,%rdi
  80144c:	48 89 d6             	mov    %rdx,%rsi
  80144f:	fc                   	cld    
  801450:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801452:	eb 15                	jmp    801469 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801454:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801458:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80145c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801460:	48 89 c7             	mov    %rax,%rdi
  801463:	48 89 d6             	mov    %rdx,%rsi
  801466:	fc                   	cld    
  801467:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801469:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80146d:	c9                   	leaveq 
  80146e:	c3                   	retq   

000000000080146f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80146f:	55                   	push   %rbp
  801470:	48 89 e5             	mov    %rsp,%rbp
  801473:	48 83 ec 18          	sub    $0x18,%rsp
  801477:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80147b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80147f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801483:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801487:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80148b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80148f:	48 89 ce             	mov    %rcx,%rsi
  801492:	48 89 c7             	mov    %rax,%rdi
  801495:	48 b8 58 13 80 00 00 	movabs $0x801358,%rax
  80149c:	00 00 00 
  80149f:	ff d0                	callq  *%rax
}
  8014a1:	c9                   	leaveq 
  8014a2:	c3                   	retq   

00000000008014a3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014a3:	55                   	push   %rbp
  8014a4:	48 89 e5             	mov    %rsp,%rbp
  8014a7:	48 83 ec 28          	sub    $0x28,%rsp
  8014ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014af:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014b3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014bb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014c3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014c7:	eb 36                	jmp    8014ff <memcmp+0x5c>
		if (*s1 != *s2)
  8014c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014cd:	0f b6 10             	movzbl (%rax),%edx
  8014d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d4:	0f b6 00             	movzbl (%rax),%eax
  8014d7:	38 c2                	cmp    %al,%dl
  8014d9:	74 1a                	je     8014f5 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8014db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014df:	0f b6 00             	movzbl (%rax),%eax
  8014e2:	0f b6 d0             	movzbl %al,%edx
  8014e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014e9:	0f b6 00             	movzbl (%rax),%eax
  8014ec:	0f b6 c0             	movzbl %al,%eax
  8014ef:	29 c2                	sub    %eax,%edx
  8014f1:	89 d0                	mov    %edx,%eax
  8014f3:	eb 20                	jmp    801515 <memcmp+0x72>
		s1++, s2++;
  8014f5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014fa:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8014ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801503:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801507:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80150b:	48 85 c0             	test   %rax,%rax
  80150e:	75 b9                	jne    8014c9 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801510:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801515:	c9                   	leaveq 
  801516:	c3                   	retq   

0000000000801517 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801517:	55                   	push   %rbp
  801518:	48 89 e5             	mov    %rsp,%rbp
  80151b:	48 83 ec 28          	sub    $0x28,%rsp
  80151f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801523:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801526:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80152a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801532:	48 01 d0             	add    %rdx,%rax
  801535:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801539:	eb 15                	jmp    801550 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80153b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80153f:	0f b6 10             	movzbl (%rax),%edx
  801542:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801545:	38 c2                	cmp    %al,%dl
  801547:	75 02                	jne    80154b <memfind+0x34>
			break;
  801549:	eb 0f                	jmp    80155a <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80154b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801550:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801554:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801558:	72 e1                	jb     80153b <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80155a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80155e:	c9                   	leaveq 
  80155f:	c3                   	retq   

0000000000801560 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801560:	55                   	push   %rbp
  801561:	48 89 e5             	mov    %rsp,%rbp
  801564:	48 83 ec 34          	sub    $0x34,%rsp
  801568:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80156c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801570:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801573:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80157a:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801581:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801582:	eb 05                	jmp    801589 <strtol+0x29>
		s++;
  801584:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801589:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158d:	0f b6 00             	movzbl (%rax),%eax
  801590:	3c 20                	cmp    $0x20,%al
  801592:	74 f0                	je     801584 <strtol+0x24>
  801594:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801598:	0f b6 00             	movzbl (%rax),%eax
  80159b:	3c 09                	cmp    $0x9,%al
  80159d:	74 e5                	je     801584 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80159f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a3:	0f b6 00             	movzbl (%rax),%eax
  8015a6:	3c 2b                	cmp    $0x2b,%al
  8015a8:	75 07                	jne    8015b1 <strtol+0x51>
		s++;
  8015aa:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015af:	eb 17                	jmp    8015c8 <strtol+0x68>
	else if (*s == '-')
  8015b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b5:	0f b6 00             	movzbl (%rax),%eax
  8015b8:	3c 2d                	cmp    $0x2d,%al
  8015ba:	75 0c                	jne    8015c8 <strtol+0x68>
		s++, neg = 1;
  8015bc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015c1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015c8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015cc:	74 06                	je     8015d4 <strtol+0x74>
  8015ce:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015d2:	75 28                	jne    8015fc <strtol+0x9c>
  8015d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d8:	0f b6 00             	movzbl (%rax),%eax
  8015db:	3c 30                	cmp    $0x30,%al
  8015dd:	75 1d                	jne    8015fc <strtol+0x9c>
  8015df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e3:	48 83 c0 01          	add    $0x1,%rax
  8015e7:	0f b6 00             	movzbl (%rax),%eax
  8015ea:	3c 78                	cmp    $0x78,%al
  8015ec:	75 0e                	jne    8015fc <strtol+0x9c>
		s += 2, base = 16;
  8015ee:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8015f3:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8015fa:	eb 2c                	jmp    801628 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8015fc:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801600:	75 19                	jne    80161b <strtol+0xbb>
  801602:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801606:	0f b6 00             	movzbl (%rax),%eax
  801609:	3c 30                	cmp    $0x30,%al
  80160b:	75 0e                	jne    80161b <strtol+0xbb>
		s++, base = 8;
  80160d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801612:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801619:	eb 0d                	jmp    801628 <strtol+0xc8>
	else if (base == 0)
  80161b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80161f:	75 07                	jne    801628 <strtol+0xc8>
		base = 10;
  801621:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801628:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162c:	0f b6 00             	movzbl (%rax),%eax
  80162f:	3c 2f                	cmp    $0x2f,%al
  801631:	7e 1d                	jle    801650 <strtol+0xf0>
  801633:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801637:	0f b6 00             	movzbl (%rax),%eax
  80163a:	3c 39                	cmp    $0x39,%al
  80163c:	7f 12                	jg     801650 <strtol+0xf0>
			dig = *s - '0';
  80163e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801642:	0f b6 00             	movzbl (%rax),%eax
  801645:	0f be c0             	movsbl %al,%eax
  801648:	83 e8 30             	sub    $0x30,%eax
  80164b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80164e:	eb 4e                	jmp    80169e <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801650:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801654:	0f b6 00             	movzbl (%rax),%eax
  801657:	3c 60                	cmp    $0x60,%al
  801659:	7e 1d                	jle    801678 <strtol+0x118>
  80165b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165f:	0f b6 00             	movzbl (%rax),%eax
  801662:	3c 7a                	cmp    $0x7a,%al
  801664:	7f 12                	jg     801678 <strtol+0x118>
			dig = *s - 'a' + 10;
  801666:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166a:	0f b6 00             	movzbl (%rax),%eax
  80166d:	0f be c0             	movsbl %al,%eax
  801670:	83 e8 57             	sub    $0x57,%eax
  801673:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801676:	eb 26                	jmp    80169e <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801678:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167c:	0f b6 00             	movzbl (%rax),%eax
  80167f:	3c 40                	cmp    $0x40,%al
  801681:	7e 48                	jle    8016cb <strtol+0x16b>
  801683:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801687:	0f b6 00             	movzbl (%rax),%eax
  80168a:	3c 5a                	cmp    $0x5a,%al
  80168c:	7f 3d                	jg     8016cb <strtol+0x16b>
			dig = *s - 'A' + 10;
  80168e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801692:	0f b6 00             	movzbl (%rax),%eax
  801695:	0f be c0             	movsbl %al,%eax
  801698:	83 e8 37             	sub    $0x37,%eax
  80169b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80169e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016a1:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016a4:	7c 02                	jl     8016a8 <strtol+0x148>
			break;
  8016a6:	eb 23                	jmp    8016cb <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016a8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016ad:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016b0:	48 98                	cltq   
  8016b2:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016b7:	48 89 c2             	mov    %rax,%rdx
  8016ba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016bd:	48 98                	cltq   
  8016bf:	48 01 d0             	add    %rdx,%rax
  8016c2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016c6:	e9 5d ff ff ff       	jmpq   801628 <strtol+0xc8>

	if (endptr)
  8016cb:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016d0:	74 0b                	je     8016dd <strtol+0x17d>
		*endptr = (char *) s;
  8016d2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016d6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016da:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016e1:	74 09                	je     8016ec <strtol+0x18c>
  8016e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016e7:	48 f7 d8             	neg    %rax
  8016ea:	eb 04                	jmp    8016f0 <strtol+0x190>
  8016ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8016f0:	c9                   	leaveq 
  8016f1:	c3                   	retq   

00000000008016f2 <strstr>:

char * strstr(const char *in, const char *str)
{
  8016f2:	55                   	push   %rbp
  8016f3:	48 89 e5             	mov    %rsp,%rbp
  8016f6:	48 83 ec 30          	sub    $0x30,%rsp
  8016fa:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016fe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801702:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801706:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80170a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80170e:	0f b6 00             	movzbl (%rax),%eax
  801711:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801714:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801718:	75 06                	jne    801720 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80171a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171e:	eb 6b                	jmp    80178b <strstr+0x99>

	len = strlen(str);
  801720:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801724:	48 89 c7             	mov    %rax,%rdi
  801727:	48 b8 c8 0f 80 00 00 	movabs $0x800fc8,%rax
  80172e:	00 00 00 
  801731:	ff d0                	callq  *%rax
  801733:	48 98                	cltq   
  801735:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801739:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801741:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801745:	0f b6 00             	movzbl (%rax),%eax
  801748:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80174b:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80174f:	75 07                	jne    801758 <strstr+0x66>
				return (char *) 0;
  801751:	b8 00 00 00 00       	mov    $0x0,%eax
  801756:	eb 33                	jmp    80178b <strstr+0x99>
		} while (sc != c);
  801758:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80175c:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80175f:	75 d8                	jne    801739 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801761:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801765:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801769:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176d:	48 89 ce             	mov    %rcx,%rsi
  801770:	48 89 c7             	mov    %rax,%rdi
  801773:	48 b8 e9 11 80 00 00 	movabs $0x8011e9,%rax
  80177a:	00 00 00 
  80177d:	ff d0                	callq  *%rax
  80177f:	85 c0                	test   %eax,%eax
  801781:	75 b6                	jne    801739 <strstr+0x47>

	return (char *) (in - 1);
  801783:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801787:	48 83 e8 01          	sub    $0x1,%rax
}
  80178b:	c9                   	leaveq 
  80178c:	c3                   	retq   

000000000080178d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80178d:	55                   	push   %rbp
  80178e:	48 89 e5             	mov    %rsp,%rbp
  801791:	53                   	push   %rbx
  801792:	48 83 ec 48          	sub    $0x48,%rsp
  801796:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801799:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80179c:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017a0:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017a4:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017a8:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  8017ac:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017af:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017b3:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017b7:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017bb:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017bf:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017c3:	4c 89 c3             	mov    %r8,%rbx
  8017c6:	cd 30                	int    $0x30
  8017c8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  8017cc:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017d0:	74 3e                	je     801810 <syscall+0x83>
  8017d2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017d7:	7e 37                	jle    801810 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017dd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017e0:	49 89 d0             	mov    %rdx,%r8
  8017e3:	89 c1                	mov    %eax,%ecx
  8017e5:	48 ba 28 43 80 00 00 	movabs $0x804328,%rdx
  8017ec:	00 00 00 
  8017ef:	be 4a 00 00 00       	mov    $0x4a,%esi
  8017f4:	48 bf 45 43 80 00 00 	movabs $0x804345,%rdi
  8017fb:	00 00 00 
  8017fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801803:	49 b9 cd 3a 80 00 00 	movabs $0x803acd,%r9
  80180a:	00 00 00 
  80180d:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  801810:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801814:	48 83 c4 48          	add    $0x48,%rsp
  801818:	5b                   	pop    %rbx
  801819:	5d                   	pop    %rbp
  80181a:	c3                   	retq   

000000000080181b <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80181b:	55                   	push   %rbp
  80181c:	48 89 e5             	mov    %rsp,%rbp
  80181f:	48 83 ec 20          	sub    $0x20,%rsp
  801823:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801827:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80182b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80182f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801833:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80183a:	00 
  80183b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801841:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801847:	48 89 d1             	mov    %rdx,%rcx
  80184a:	48 89 c2             	mov    %rax,%rdx
  80184d:	be 00 00 00 00       	mov    $0x0,%esi
  801852:	bf 00 00 00 00       	mov    $0x0,%edi
  801857:	48 b8 8d 17 80 00 00 	movabs $0x80178d,%rax
  80185e:	00 00 00 
  801861:	ff d0                	callq  *%rax
}
  801863:	c9                   	leaveq 
  801864:	c3                   	retq   

0000000000801865 <sys_cgetc>:

int
sys_cgetc(void)
{
  801865:	55                   	push   %rbp
  801866:	48 89 e5             	mov    %rsp,%rbp
  801869:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80186d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801874:	00 
  801875:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80187b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801881:	b9 00 00 00 00       	mov    $0x0,%ecx
  801886:	ba 00 00 00 00       	mov    $0x0,%edx
  80188b:	be 00 00 00 00       	mov    $0x0,%esi
  801890:	bf 01 00 00 00       	mov    $0x1,%edi
  801895:	48 b8 8d 17 80 00 00 	movabs $0x80178d,%rax
  80189c:	00 00 00 
  80189f:	ff d0                	callq  *%rax
}
  8018a1:	c9                   	leaveq 
  8018a2:	c3                   	retq   

00000000008018a3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018a3:	55                   	push   %rbp
  8018a4:	48 89 e5             	mov    %rsp,%rbp
  8018a7:	48 83 ec 10          	sub    $0x10,%rsp
  8018ab:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018b1:	48 98                	cltq   
  8018b3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018ba:	00 
  8018bb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018c1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018c7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018cc:	48 89 c2             	mov    %rax,%rdx
  8018cf:	be 01 00 00 00       	mov    $0x1,%esi
  8018d4:	bf 03 00 00 00       	mov    $0x3,%edi
  8018d9:	48 b8 8d 17 80 00 00 	movabs $0x80178d,%rax
  8018e0:	00 00 00 
  8018e3:	ff d0                	callq  *%rax
}
  8018e5:	c9                   	leaveq 
  8018e6:	c3                   	retq   

00000000008018e7 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8018e7:	55                   	push   %rbp
  8018e8:	48 89 e5             	mov    %rsp,%rbp
  8018eb:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8018ef:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018f6:	00 
  8018f7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018fd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801903:	b9 00 00 00 00       	mov    $0x0,%ecx
  801908:	ba 00 00 00 00       	mov    $0x0,%edx
  80190d:	be 00 00 00 00       	mov    $0x0,%esi
  801912:	bf 02 00 00 00       	mov    $0x2,%edi
  801917:	48 b8 8d 17 80 00 00 	movabs $0x80178d,%rax
  80191e:	00 00 00 
  801921:	ff d0                	callq  *%rax
}
  801923:	c9                   	leaveq 
  801924:	c3                   	retq   

0000000000801925 <sys_yield>:

void
sys_yield(void)
{
  801925:	55                   	push   %rbp
  801926:	48 89 e5             	mov    %rsp,%rbp
  801929:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80192d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801934:	00 
  801935:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80193b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801941:	b9 00 00 00 00       	mov    $0x0,%ecx
  801946:	ba 00 00 00 00       	mov    $0x0,%edx
  80194b:	be 00 00 00 00       	mov    $0x0,%esi
  801950:	bf 0b 00 00 00       	mov    $0xb,%edi
  801955:	48 b8 8d 17 80 00 00 	movabs $0x80178d,%rax
  80195c:	00 00 00 
  80195f:	ff d0                	callq  *%rax
}
  801961:	c9                   	leaveq 
  801962:	c3                   	retq   

0000000000801963 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801963:	55                   	push   %rbp
  801964:	48 89 e5             	mov    %rsp,%rbp
  801967:	48 83 ec 20          	sub    $0x20,%rsp
  80196b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80196e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801972:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801975:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801978:	48 63 c8             	movslq %eax,%rcx
  80197b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80197f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801982:	48 98                	cltq   
  801984:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80198b:	00 
  80198c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801992:	49 89 c8             	mov    %rcx,%r8
  801995:	48 89 d1             	mov    %rdx,%rcx
  801998:	48 89 c2             	mov    %rax,%rdx
  80199b:	be 01 00 00 00       	mov    $0x1,%esi
  8019a0:	bf 04 00 00 00       	mov    $0x4,%edi
  8019a5:	48 b8 8d 17 80 00 00 	movabs $0x80178d,%rax
  8019ac:	00 00 00 
  8019af:	ff d0                	callq  *%rax
}
  8019b1:	c9                   	leaveq 
  8019b2:	c3                   	retq   

00000000008019b3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019b3:	55                   	push   %rbp
  8019b4:	48 89 e5             	mov    %rsp,%rbp
  8019b7:	48 83 ec 30          	sub    $0x30,%rsp
  8019bb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019be:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019c2:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019c5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019c9:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019cd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019d0:	48 63 c8             	movslq %eax,%rcx
  8019d3:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019d7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019da:	48 63 f0             	movslq %eax,%rsi
  8019dd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019e4:	48 98                	cltq   
  8019e6:	48 89 0c 24          	mov    %rcx,(%rsp)
  8019ea:	49 89 f9             	mov    %rdi,%r9
  8019ed:	49 89 f0             	mov    %rsi,%r8
  8019f0:	48 89 d1             	mov    %rdx,%rcx
  8019f3:	48 89 c2             	mov    %rax,%rdx
  8019f6:	be 01 00 00 00       	mov    $0x1,%esi
  8019fb:	bf 05 00 00 00       	mov    $0x5,%edi
  801a00:	48 b8 8d 17 80 00 00 	movabs $0x80178d,%rax
  801a07:	00 00 00 
  801a0a:	ff d0                	callq  *%rax
}
  801a0c:	c9                   	leaveq 
  801a0d:	c3                   	retq   

0000000000801a0e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a0e:	55                   	push   %rbp
  801a0f:	48 89 e5             	mov    %rsp,%rbp
  801a12:	48 83 ec 20          	sub    $0x20,%rsp
  801a16:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a19:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a1d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a24:	48 98                	cltq   
  801a26:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a2d:	00 
  801a2e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a34:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a3a:	48 89 d1             	mov    %rdx,%rcx
  801a3d:	48 89 c2             	mov    %rax,%rdx
  801a40:	be 01 00 00 00       	mov    $0x1,%esi
  801a45:	bf 06 00 00 00       	mov    $0x6,%edi
  801a4a:	48 b8 8d 17 80 00 00 	movabs $0x80178d,%rax
  801a51:	00 00 00 
  801a54:	ff d0                	callq  *%rax
}
  801a56:	c9                   	leaveq 
  801a57:	c3                   	retq   

0000000000801a58 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a58:	55                   	push   %rbp
  801a59:	48 89 e5             	mov    %rsp,%rbp
  801a5c:	48 83 ec 10          	sub    $0x10,%rsp
  801a60:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a63:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a66:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a69:	48 63 d0             	movslq %eax,%rdx
  801a6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a6f:	48 98                	cltq   
  801a71:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a78:	00 
  801a79:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a7f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a85:	48 89 d1             	mov    %rdx,%rcx
  801a88:	48 89 c2             	mov    %rax,%rdx
  801a8b:	be 01 00 00 00       	mov    $0x1,%esi
  801a90:	bf 08 00 00 00       	mov    $0x8,%edi
  801a95:	48 b8 8d 17 80 00 00 	movabs $0x80178d,%rax
  801a9c:	00 00 00 
  801a9f:	ff d0                	callq  *%rax
}
  801aa1:	c9                   	leaveq 
  801aa2:	c3                   	retq   

0000000000801aa3 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801aa3:	55                   	push   %rbp
  801aa4:	48 89 e5             	mov    %rsp,%rbp
  801aa7:	48 83 ec 20          	sub    $0x20,%rsp
  801aab:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aae:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801ab2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ab6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ab9:	48 98                	cltq   
  801abb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ac2:	00 
  801ac3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ac9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801acf:	48 89 d1             	mov    %rdx,%rcx
  801ad2:	48 89 c2             	mov    %rax,%rdx
  801ad5:	be 01 00 00 00       	mov    $0x1,%esi
  801ada:	bf 09 00 00 00       	mov    $0x9,%edi
  801adf:	48 b8 8d 17 80 00 00 	movabs $0x80178d,%rax
  801ae6:	00 00 00 
  801ae9:	ff d0                	callq  *%rax
}
  801aeb:	c9                   	leaveq 
  801aec:	c3                   	retq   

0000000000801aed <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801aed:	55                   	push   %rbp
  801aee:	48 89 e5             	mov    %rsp,%rbp
  801af1:	48 83 ec 20          	sub    $0x20,%rsp
  801af5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801af8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801afc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b03:	48 98                	cltq   
  801b05:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b0c:	00 
  801b0d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b13:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b19:	48 89 d1             	mov    %rdx,%rcx
  801b1c:	48 89 c2             	mov    %rax,%rdx
  801b1f:	be 01 00 00 00       	mov    $0x1,%esi
  801b24:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b29:	48 b8 8d 17 80 00 00 	movabs $0x80178d,%rax
  801b30:	00 00 00 
  801b33:	ff d0                	callq  *%rax
}
  801b35:	c9                   	leaveq 
  801b36:	c3                   	retq   

0000000000801b37 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b37:	55                   	push   %rbp
  801b38:	48 89 e5             	mov    %rsp,%rbp
  801b3b:	48 83 ec 20          	sub    $0x20,%rsp
  801b3f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b42:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b46:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b4a:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b4d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b50:	48 63 f0             	movslq %eax,%rsi
  801b53:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b5a:	48 98                	cltq   
  801b5c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b60:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b67:	00 
  801b68:	49 89 f1             	mov    %rsi,%r9
  801b6b:	49 89 c8             	mov    %rcx,%r8
  801b6e:	48 89 d1             	mov    %rdx,%rcx
  801b71:	48 89 c2             	mov    %rax,%rdx
  801b74:	be 00 00 00 00       	mov    $0x0,%esi
  801b79:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b7e:	48 b8 8d 17 80 00 00 	movabs $0x80178d,%rax
  801b85:	00 00 00 
  801b88:	ff d0                	callq  *%rax
}
  801b8a:	c9                   	leaveq 
  801b8b:	c3                   	retq   

0000000000801b8c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b8c:	55                   	push   %rbp
  801b8d:	48 89 e5             	mov    %rsp,%rbp
  801b90:	48 83 ec 10          	sub    $0x10,%rsp
  801b94:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b9c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ba3:	00 
  801ba4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801baa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bb0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bb5:	48 89 c2             	mov    %rax,%rdx
  801bb8:	be 01 00 00 00       	mov    $0x1,%esi
  801bbd:	bf 0d 00 00 00       	mov    $0xd,%edi
  801bc2:	48 b8 8d 17 80 00 00 	movabs $0x80178d,%rax
  801bc9:	00 00 00 
  801bcc:	ff d0                	callq  *%rax
}
  801bce:	c9                   	leaveq 
  801bcf:	c3                   	retq   

0000000000801bd0 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801bd0:	55                   	push   %rbp
  801bd1:	48 89 e5             	mov    %rsp,%rbp
  801bd4:	53                   	push   %rbx
  801bd5:	48 83 ec 48          	sub    $0x48,%rsp
  801bd9:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801bdd:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801be1:	48 8b 00             	mov    (%rax),%rax
  801be4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	uint32_t err = utf->utf_err;
  801be8:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801bec:	48 8b 40 08          	mov    0x8(%rax),%rax
  801bf0:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	pte_t pte = uvpt[VPN(addr)];
  801bf3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bf7:	48 c1 e8 0c          	shr    $0xc,%rax
  801bfb:	48 89 c2             	mov    %rax,%rdx
  801bfe:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c05:	01 00 00 
  801c08:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c0c:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	envid_t pid = sys_getenvid();
  801c10:	48 b8 e7 18 80 00 00 	movabs $0x8018e7,%rax
  801c17:	00 00 00 
  801c1a:	ff d0                	callq  *%rax
  801c1c:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	void* va = ROUNDDOWN(addr, PGSIZE);
  801c1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c23:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  801c27:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801c2b:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801c31:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	if((err & FEC_WR) && (pte & PTE_COW)){
  801c35:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c38:	83 e0 02             	and    $0x2,%eax
  801c3b:	85 c0                	test   %eax,%eax
  801c3d:	0f 84 8d 00 00 00    	je     801cd0 <pgfault+0x100>
  801c43:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c47:	25 00 08 00 00       	and    $0x800,%eax
  801c4c:	48 85 c0             	test   %rax,%rax
  801c4f:	74 7f                	je     801cd0 <pgfault+0x100>
		if(!sys_page_alloc(pid, (void*)PFTEMP, PTE_P | PTE_W | PTE_U)){
  801c51:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801c54:	ba 07 00 00 00       	mov    $0x7,%edx
  801c59:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c5e:	89 c7                	mov    %eax,%edi
  801c60:	48 b8 63 19 80 00 00 	movabs $0x801963,%rax
  801c67:	00 00 00 
  801c6a:	ff d0                	callq  *%rax
  801c6c:	85 c0                	test   %eax,%eax
  801c6e:	75 60                	jne    801cd0 <pgfault+0x100>
			memmove(PFTEMP, va, PGSIZE);
  801c70:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801c74:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c79:	48 89 c6             	mov    %rax,%rsi
  801c7c:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801c81:	48 b8 58 13 80 00 00 	movabs $0x801358,%rax
  801c88:	00 00 00 
  801c8b:	ff d0                	callq  *%rax
			if(!(sys_page_map(pid, (void*)PFTEMP, pid, va, PTE_P | PTE_W | PTE_U) | 
  801c8d:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  801c91:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  801c94:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801c97:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801c9d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ca2:	89 c7                	mov    %eax,%edi
  801ca4:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  801cab:	00 00 00 
  801cae:	ff d0                	callq  *%rax
  801cb0:	89 c3                	mov    %eax,%ebx
					 sys_page_unmap(pid, (void*) PFTEMP)))
  801cb2:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801cb5:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801cba:	89 c7                	mov    %eax,%edi
  801cbc:	48 b8 0e 1a 80 00 00 	movabs $0x801a0e,%rax
  801cc3:	00 00 00 
  801cc6:	ff d0                	callq  *%rax
	envid_t pid = sys_getenvid();
	void* va = ROUNDDOWN(addr, PGSIZE);
	if((err & FEC_WR) && (pte & PTE_COW)){
		if(!sys_page_alloc(pid, (void*)PFTEMP, PTE_P | PTE_W | PTE_U)){
			memmove(PFTEMP, va, PGSIZE);
			if(!(sys_page_map(pid, (void*)PFTEMP, pid, va, PTE_P | PTE_W | PTE_U) | 
  801cc8:	09 d8                	or     %ebx,%eax
  801cca:	85 c0                	test   %eax,%eax
  801ccc:	75 02                	jne    801cd0 <pgfault+0x100>
					 sys_page_unmap(pid, (void*) PFTEMP)))
					return;
  801cce:	eb 2a                	jmp    801cfa <pgfault+0x12a>
		}
	}
	panic("Page fault handler failure\n");
  801cd0:	48 ba 53 43 80 00 00 	movabs $0x804353,%rdx
  801cd7:	00 00 00 
  801cda:	be 26 00 00 00       	mov    $0x26,%esi
  801cdf:	48 bf 6f 43 80 00 00 	movabs $0x80436f,%rdi
  801ce6:	00 00 00 
  801ce9:	b8 00 00 00 00       	mov    $0x0,%eax
  801cee:	48 b9 cd 3a 80 00 00 	movabs $0x803acd,%rcx
  801cf5:	00 00 00 
  801cf8:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	//panic("pgfault not implemented");
}
  801cfa:	48 83 c4 48          	add    $0x48,%rsp
  801cfe:	5b                   	pop    %rbx
  801cff:	5d                   	pop    %rbp
  801d00:	c3                   	retq   

0000000000801d01 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801d01:	55                   	push   %rbp
  801d02:	48 89 e5             	mov    %rsp,%rbp
  801d05:	53                   	push   %rbx
  801d06:	48 83 ec 38          	sub    $0x38,%rsp
  801d0a:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801d0d:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	//struct Env *env;
	pte_t pte = uvpt[pn];
  801d10:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d17:	01 00 00 
  801d1a:	8b 55 c8             	mov    -0x38(%rbp),%edx
  801d1d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d21:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int perm = pte & PTE_SYSCALL;
  801d25:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d29:	25 07 0e 00 00       	and    $0xe07,%eax
  801d2e:	89 45 dc             	mov    %eax,-0x24(%rbp)
	void *va = (void*)((uintptr_t)pn * PGSIZE);
  801d31:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801d34:	48 c1 e0 0c          	shl    $0xc,%rax
  801d38:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	if(perm & PTE_SHARE){
  801d3c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801d3f:	25 00 04 00 00       	and    $0x400,%eax
  801d44:	85 c0                	test   %eax,%eax
  801d46:	74 30                	je     801d78 <duppage+0x77>
		r = sys_page_map(0, va, envid, va, perm);
  801d48:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801d4b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801d4f:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801d52:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d56:	41 89 f0             	mov    %esi,%r8d
  801d59:	48 89 c6             	mov    %rax,%rsi
  801d5c:	bf 00 00 00 00       	mov    $0x0,%edi
  801d61:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  801d68:	00 00 00 
  801d6b:	ff d0                	callq  *%rax
  801d6d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		return r;
  801d70:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d73:	e9 a4 00 00 00       	jmpq   801e1c <duppage+0x11b>
	}
	//envid_t pid = sys_getenvid();
	if((perm & PTE_W) || (perm & PTE_COW)){
  801d78:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801d7b:	83 e0 02             	and    $0x2,%eax
  801d7e:	85 c0                	test   %eax,%eax
  801d80:	75 0c                	jne    801d8e <duppage+0x8d>
  801d82:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801d85:	25 00 08 00 00       	and    $0x800,%eax
  801d8a:	85 c0                	test   %eax,%eax
  801d8c:	74 63                	je     801df1 <duppage+0xf0>
		perm &= ~PTE_W;
  801d8e:	83 65 dc fd          	andl   $0xfffffffd,-0x24(%rbp)
		perm |= PTE_COW;
  801d92:	81 4d dc 00 08 00 00 	orl    $0x800,-0x24(%rbp)
		r = sys_page_map(0, va, envid, va, perm) | sys_page_map(0, va, 0, va, perm);
  801d99:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801d9c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801da0:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801da3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801da7:	41 89 f0             	mov    %esi,%r8d
  801daa:	48 89 c6             	mov    %rax,%rsi
  801dad:	bf 00 00 00 00       	mov    $0x0,%edi
  801db2:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  801db9:	00 00 00 
  801dbc:	ff d0                	callq  *%rax
  801dbe:	89 c3                	mov    %eax,%ebx
  801dc0:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  801dc3:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801dc7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801dcb:	41 89 c8             	mov    %ecx,%r8d
  801dce:	48 89 d1             	mov    %rdx,%rcx
  801dd1:	ba 00 00 00 00       	mov    $0x0,%edx
  801dd6:	48 89 c6             	mov    %rax,%rsi
  801dd9:	bf 00 00 00 00       	mov    $0x0,%edi
  801dde:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  801de5:	00 00 00 
  801de8:	ff d0                	callq  *%rax
  801dea:	09 d8                	or     %ebx,%eax
  801dec:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801def:	eb 28                	jmp    801e19 <duppage+0x118>
	}
	else{
		r = sys_page_map(0, va, envid, va, perm);
  801df1:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801df4:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801df8:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801dfb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801dff:	41 89 f0             	mov    %esi,%r8d
  801e02:	48 89 c6             	mov    %rax,%rsi
  801e05:	bf 00 00 00 00       	mov    $0x0,%edi
  801e0a:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  801e11:	00 00 00 
  801e14:	ff d0                	callq  *%rax
  801e16:	89 45 ec             	mov    %eax,-0x14(%rbp)
	}

	// LAB 4: Your code here.
	//panic("duppage not implemented");
	//if(r != 0) panic("Duplicating page failed: %e\n", r);
	return r;
  801e19:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  801e1c:	48 83 c4 38          	add    $0x38,%rsp
  801e20:	5b                   	pop    %rbx
  801e21:	5d                   	pop    %rbp
  801e22:	c3                   	retq   

0000000000801e23 <fork>:
//   so you must allocate a new page for the child's user exception stack.
//

envid_t
fork(void)
{
  801e23:	55                   	push   %rbp
  801e24:	48 89 e5             	mov    %rsp,%rbp
  801e27:	53                   	push   %rbx
  801e28:	48 83 ec 58          	sub    $0x58,%rsp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  801e2c:	48 bf d0 1b 80 00 00 	movabs $0x801bd0,%rdi
  801e33:	00 00 00 
  801e36:	48 b8 e1 3b 80 00 00 	movabs $0x803be1,%rax
  801e3d:	00 00 00 
  801e40:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801e42:	b8 07 00 00 00       	mov    $0x7,%eax
  801e47:	cd 30                	int    $0x30
  801e49:	89 45 a4             	mov    %eax,-0x5c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801e4c:	8b 45 a4             	mov    -0x5c(%rbp),%eax
	envid_t cid = sys_exofork();
  801e4f:	89 45 cc             	mov    %eax,-0x34(%rbp)
	if(cid < 0) panic("fork failed: %e\n", cid);
  801e52:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801e56:	79 30                	jns    801e88 <fork+0x65>
  801e58:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801e5b:	89 c1                	mov    %eax,%ecx
  801e5d:	48 ba 7a 43 80 00 00 	movabs $0x80437a,%rdx
  801e64:	00 00 00 
  801e67:	be 72 00 00 00       	mov    $0x72,%esi
  801e6c:	48 bf 6f 43 80 00 00 	movabs $0x80436f,%rdi
  801e73:	00 00 00 
  801e76:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7b:	49 b8 cd 3a 80 00 00 	movabs $0x803acd,%r8
  801e82:	00 00 00 
  801e85:	41 ff d0             	callq  *%r8
	if(cid == 0){
  801e88:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801e8c:	75 46                	jne    801ed4 <fork+0xb1>
		thisenv = &envs[ENVX(sys_getenvid())];
  801e8e:	48 b8 e7 18 80 00 00 	movabs $0x8018e7,%rax
  801e95:	00 00 00 
  801e98:	ff d0                	callq  *%rax
  801e9a:	25 ff 03 00 00       	and    $0x3ff,%eax
  801e9f:	48 63 d0             	movslq %eax,%rdx
  801ea2:	48 89 d0             	mov    %rdx,%rax
  801ea5:	48 c1 e0 03          	shl    $0x3,%rax
  801ea9:	48 01 d0             	add    %rdx,%rax
  801eac:	48 c1 e0 05          	shl    $0x5,%rax
  801eb0:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801eb7:	00 00 00 
  801eba:	48 01 c2             	add    %rax,%rdx
  801ebd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801ec4:	00 00 00 
  801ec7:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801eca:	b8 00 00 00 00       	mov    $0x0,%eax
  801ecf:	e9 12 02 00 00       	jmpq   8020e6 <fork+0x2c3>
	}
	int result;
	if((result = sys_page_alloc(cid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801ed4:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801ed7:	ba 07 00 00 00       	mov    $0x7,%edx
  801edc:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801ee1:	89 c7                	mov    %eax,%edi
  801ee3:	48 b8 63 19 80 00 00 	movabs $0x801963,%rax
  801eea:	00 00 00 
  801eed:	ff d0                	callq  *%rax
  801eef:	89 45 c8             	mov    %eax,-0x38(%rbp)
  801ef2:	83 7d c8 00          	cmpl   $0x0,-0x38(%rbp)
  801ef6:	79 30                	jns    801f28 <fork+0x105>
		panic("fork failed: %e\n", result);
  801ef8:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801efb:	89 c1                	mov    %eax,%ecx
  801efd:	48 ba 7a 43 80 00 00 	movabs $0x80437a,%rdx
  801f04:	00 00 00 
  801f07:	be 79 00 00 00       	mov    $0x79,%esi
  801f0c:	48 bf 6f 43 80 00 00 	movabs $0x80436f,%rdi
  801f13:	00 00 00 
  801f16:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1b:	49 b8 cd 3a 80 00 00 	movabs $0x803acd,%r8
  801f22:	00 00 00 
  801f25:	41 ff d0             	callq  *%r8
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  801f28:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801f2f:	00 
  801f30:	e9 40 01 00 00       	jmpq   802075 <fork+0x252>
		if(uvpml4e[pml4e] & PTE_P){
  801f35:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801f3c:	01 00 00 
  801f3f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801f43:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f47:	83 e0 01             	and    $0x1,%eax
  801f4a:	48 85 c0             	test   %rax,%rax
  801f4d:	0f 84 1d 01 00 00    	je     802070 <fork+0x24d>
			base_pml4e = pml4e * NPDPENTRIES;
  801f53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f57:	48 c1 e0 09          	shl    $0x9,%rax
  801f5b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  801f5f:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  801f66:	00 
  801f67:	e9 f6 00 00 00       	jmpq   802062 <fork+0x23f>
				if(uvpde[base_pml4e + pdpe] & PTE_P){
  801f6c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f70:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801f74:	48 01 c2             	add    %rax,%rdx
  801f77:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801f7e:	01 00 00 
  801f81:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f85:	83 e0 01             	and    $0x1,%eax
  801f88:	48 85 c0             	test   %rax,%rax
  801f8b:	0f 84 cc 00 00 00    	je     80205d <fork+0x23a>
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
  801f91:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f95:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801f99:	48 01 d0             	add    %rdx,%rax
  801f9c:	48 c1 e0 09          	shl    $0x9,%rax
  801fa0:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
					for(pde = 0; pde < NPDENTRIES; pde++){
  801fa4:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  801fab:	00 
  801fac:	e9 9e 00 00 00       	jmpq   80204f <fork+0x22c>
						if(uvpd[base_pdpe + pde] & PTE_P){
  801fb1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fb5:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801fb9:	48 01 c2             	add    %rax,%rdx
  801fbc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801fc3:	01 00 00 
  801fc6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fca:	83 e0 01             	and    $0x1,%eax
  801fcd:	48 85 c0             	test   %rax,%rax
  801fd0:	74 78                	je     80204a <fork+0x227>
							base_pde = (base_pdpe + pde) * NPTENTRIES;
  801fd2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fd6:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801fda:	48 01 d0             	add    %rdx,%rax
  801fdd:	48 c1 e0 09          	shl    $0x9,%rax
  801fe1:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
							for(pte = 0; pte < NPTENTRIES; pte++){
  801fe5:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  801fec:	00 
  801fed:	eb 51                	jmp    802040 <fork+0x21d>
								entry = base_pde + pte;
  801fef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ff3:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801ff7:	48 01 d0             	add    %rdx,%rax
  801ffa:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
								if((uvpt[entry] & PTE_P) && (entry != VPN(UXSTACKTOP - PGSIZE))){
  801ffe:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802005:	01 00 00 
  802008:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80200c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802010:	83 e0 01             	and    $0x1,%eax
  802013:	48 85 c0             	test   %rax,%rax
  802016:	74 23                	je     80203b <fork+0x218>
  802018:	48 81 7d a8 ff f7 0e 	cmpq   $0xef7ff,-0x58(%rbp)
  80201f:	00 
  802020:	74 19                	je     80203b <fork+0x218>
									duppage(cid, entry);
  802022:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802026:	89 c2                	mov    %eax,%edx
  802028:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80202b:	89 d6                	mov    %edx,%esi
  80202d:	89 c7                	mov    %eax,%edi
  80202f:	48 b8 01 1d 80 00 00 	movabs $0x801d01,%rax
  802036:	00 00 00 
  802039:	ff d0                	callq  *%rax
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
						if(uvpd[base_pdpe + pde] & PTE_P){
							base_pde = (base_pdpe + pde) * NPTENTRIES;
							for(pte = 0; pte < NPTENTRIES; pte++){
  80203b:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  802040:	48 81 7d d0 ff 01 00 	cmpq   $0x1ff,-0x30(%rbp)
  802047:	00 
  802048:	76 a5                	jbe    801fef <fork+0x1cc>
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
  80204a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80204f:	48 81 7d d8 ff 01 00 	cmpq   $0x1ff,-0x28(%rbp)
  802056:	00 
  802057:	0f 86 54 ff ff ff    	jbe    801fb1 <fork+0x18e>
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  80205d:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  802062:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  802069:	00 
  80206a:	0f 86 fc fe ff ff    	jbe    801f6c <fork+0x149>
	int result;
	if((result = sys_page_alloc(cid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		panic("fork failed: %e\n", result);
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  802070:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802075:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80207a:	0f 84 b5 fe ff ff    	je     801f35 <fork+0x112>
					}
				}
			}
		}
	}
	if(sys_env_set_pgfault_upcall(cid, _pgfault_upcall) | sys_env_set_status(cid, ENV_RUNNABLE))
  802080:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802083:	48 be 76 3c 80 00 00 	movabs $0x803c76,%rsi
  80208a:	00 00 00 
  80208d:	89 c7                	mov    %eax,%edi
  80208f:	48 b8 ed 1a 80 00 00 	movabs $0x801aed,%rax
  802096:	00 00 00 
  802099:	ff d0                	callq  *%rax
  80209b:	89 c3                	mov    %eax,%ebx
  80209d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8020a0:	be 02 00 00 00       	mov    $0x2,%esi
  8020a5:	89 c7                	mov    %eax,%edi
  8020a7:	48 b8 58 1a 80 00 00 	movabs $0x801a58,%rax
  8020ae:	00 00 00 
  8020b1:	ff d0                	callq  *%rax
  8020b3:	09 d8                	or     %ebx,%eax
  8020b5:	85 c0                	test   %eax,%eax
  8020b7:	74 2a                	je     8020e3 <fork+0x2c0>
		panic("fork failed\n");
  8020b9:	48 ba 8b 43 80 00 00 	movabs $0x80438b,%rdx
  8020c0:	00 00 00 
  8020c3:	be 92 00 00 00       	mov    $0x92,%esi
  8020c8:	48 bf 6f 43 80 00 00 	movabs $0x80436f,%rdi
  8020cf:	00 00 00 
  8020d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d7:	48 b9 cd 3a 80 00 00 	movabs $0x803acd,%rcx
  8020de:	00 00 00 
  8020e1:	ff d1                	callq  *%rcx
	return cid;
  8020e3:	8b 45 cc             	mov    -0x34(%rbp),%eax
	//panic("fork not implemented");
}
  8020e6:	48 83 c4 58          	add    $0x58,%rsp
  8020ea:	5b                   	pop    %rbx
  8020eb:	5d                   	pop    %rbp
  8020ec:	c3                   	retq   

00000000008020ed <sfork>:


// Challenge!
int
sfork(void)
{
  8020ed:	55                   	push   %rbp
  8020ee:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8020f1:	48 ba 98 43 80 00 00 	movabs $0x804398,%rdx
  8020f8:	00 00 00 
  8020fb:	be 9c 00 00 00       	mov    $0x9c,%esi
  802100:	48 bf 6f 43 80 00 00 	movabs $0x80436f,%rdi
  802107:	00 00 00 
  80210a:	b8 00 00 00 00       	mov    $0x0,%eax
  80210f:	48 b9 cd 3a 80 00 00 	movabs $0x803acd,%rcx
  802116:	00 00 00 
  802119:	ff d1                	callq  *%rcx

000000000080211b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80211b:	55                   	push   %rbp
  80211c:	48 89 e5             	mov    %rsp,%rbp
  80211f:	48 83 ec 30          	sub    $0x30,%rsp
  802123:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802127:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80212b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  80212f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802134:	74 18                	je     80214e <ipc_recv+0x33>
  802136:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80213a:	48 89 c7             	mov    %rax,%rdi
  80213d:	48 b8 8c 1b 80 00 00 	movabs $0x801b8c,%rax
  802144:	00 00 00 
  802147:	ff d0                	callq  *%rax
  802149:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80214c:	eb 19                	jmp    802167 <ipc_recv+0x4c>
  80214e:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  802155:	00 00 00 
  802158:	48 b8 8c 1b 80 00 00 	movabs $0x801b8c,%rax
  80215f:	00 00 00 
  802162:	ff d0                	callq  *%rax
  802164:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  802167:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80216c:	74 26                	je     802194 <ipc_recv+0x79>
  80216e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802172:	75 15                	jne    802189 <ipc_recv+0x6e>
  802174:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80217b:	00 00 00 
  80217e:	48 8b 00             	mov    (%rax),%rax
  802181:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  802187:	eb 05                	jmp    80218e <ipc_recv+0x73>
  802189:	b8 00 00 00 00       	mov    $0x0,%eax
  80218e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802192:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  802194:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802199:	74 26                	je     8021c1 <ipc_recv+0xa6>
  80219b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80219f:	75 15                	jne    8021b6 <ipc_recv+0x9b>
  8021a1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8021a8:	00 00 00 
  8021ab:	48 8b 00             	mov    (%rax),%rax
  8021ae:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  8021b4:	eb 05                	jmp    8021bb <ipc_recv+0xa0>
  8021b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021bb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8021bf:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  8021c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021c5:	75 15                	jne    8021dc <ipc_recv+0xc1>
  8021c7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8021ce:	00 00 00 
  8021d1:	48 8b 00             	mov    (%rax),%rax
  8021d4:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  8021da:	eb 03                	jmp    8021df <ipc_recv+0xc4>
  8021dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8021df:	c9                   	leaveq 
  8021e0:	c3                   	retq   

00000000008021e1 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8021e1:	55                   	push   %rbp
  8021e2:	48 89 e5             	mov    %rsp,%rbp
  8021e5:	48 83 ec 30          	sub    $0x30,%rsp
  8021e9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021ec:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8021ef:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8021f3:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  8021f6:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  8021fd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802202:	75 10                	jne    802214 <ipc_send+0x33>
  802204:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80220b:	00 00 00 
  80220e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  802212:	eb 62                	jmp    802276 <ipc_send+0x95>
  802214:	eb 60                	jmp    802276 <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  802216:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80221a:	74 30                	je     80224c <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  80221c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80221f:	89 c1                	mov    %eax,%ecx
  802221:	48 ba ae 43 80 00 00 	movabs $0x8043ae,%rdx
  802228:	00 00 00 
  80222b:	be 33 00 00 00       	mov    $0x33,%esi
  802230:	48 bf ca 43 80 00 00 	movabs $0x8043ca,%rdi
  802237:	00 00 00 
  80223a:	b8 00 00 00 00       	mov    $0x0,%eax
  80223f:	49 b8 cd 3a 80 00 00 	movabs $0x803acd,%r8
  802246:	00 00 00 
  802249:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  80224c:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80224f:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802252:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802256:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802259:	89 c7                	mov    %eax,%edi
  80225b:	48 b8 37 1b 80 00 00 	movabs $0x801b37,%rax
  802262:	00 00 00 
  802265:	ff d0                	callq  *%rax
  802267:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  80226a:	48 b8 25 19 80 00 00 	movabs $0x801925,%rax
  802271:	00 00 00 
  802274:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  802276:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80227a:	75 9a                	jne    802216 <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  80227c:	c9                   	leaveq 
  80227d:	c3                   	retq   

000000000080227e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80227e:	55                   	push   %rbp
  80227f:	48 89 e5             	mov    %rsp,%rbp
  802282:	48 83 ec 14          	sub    $0x14,%rsp
  802286:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  802289:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802290:	eb 5e                	jmp    8022f0 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  802292:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802299:	00 00 00 
  80229c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80229f:	48 63 d0             	movslq %eax,%rdx
  8022a2:	48 89 d0             	mov    %rdx,%rax
  8022a5:	48 c1 e0 03          	shl    $0x3,%rax
  8022a9:	48 01 d0             	add    %rdx,%rax
  8022ac:	48 c1 e0 05          	shl    $0x5,%rax
  8022b0:	48 01 c8             	add    %rcx,%rax
  8022b3:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8022b9:	8b 00                	mov    (%rax),%eax
  8022bb:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8022be:	75 2c                	jne    8022ec <ipc_find_env+0x6e>
			return envs[i].env_id;
  8022c0:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8022c7:	00 00 00 
  8022ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022cd:	48 63 d0             	movslq %eax,%rdx
  8022d0:	48 89 d0             	mov    %rdx,%rax
  8022d3:	48 c1 e0 03          	shl    $0x3,%rax
  8022d7:	48 01 d0             	add    %rdx,%rax
  8022da:	48 c1 e0 05          	shl    $0x5,%rax
  8022de:	48 01 c8             	add    %rcx,%rax
  8022e1:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8022e7:	8b 40 08             	mov    0x8(%rax),%eax
  8022ea:	eb 12                	jmp    8022fe <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8022ec:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8022f0:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8022f7:	7e 99                	jle    802292 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8022f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022fe:	c9                   	leaveq 
  8022ff:	c3                   	retq   

0000000000802300 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802300:	55                   	push   %rbp
  802301:	48 89 e5             	mov    %rsp,%rbp
  802304:	48 83 ec 08          	sub    $0x8,%rsp
  802308:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80230c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802310:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802317:	ff ff ff 
  80231a:	48 01 d0             	add    %rdx,%rax
  80231d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802321:	c9                   	leaveq 
  802322:	c3                   	retq   

0000000000802323 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802323:	55                   	push   %rbp
  802324:	48 89 e5             	mov    %rsp,%rbp
  802327:	48 83 ec 08          	sub    $0x8,%rsp
  80232b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80232f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802333:	48 89 c7             	mov    %rax,%rdi
  802336:	48 b8 00 23 80 00 00 	movabs $0x802300,%rax
  80233d:	00 00 00 
  802340:	ff d0                	callq  *%rax
  802342:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802348:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80234c:	c9                   	leaveq 
  80234d:	c3                   	retq   

000000000080234e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80234e:	55                   	push   %rbp
  80234f:	48 89 e5             	mov    %rsp,%rbp
  802352:	48 83 ec 18          	sub    $0x18,%rsp
  802356:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80235a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802361:	eb 6b                	jmp    8023ce <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802363:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802366:	48 98                	cltq   
  802368:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80236e:	48 c1 e0 0c          	shl    $0xc,%rax
  802372:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802376:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80237a:	48 c1 e8 15          	shr    $0x15,%rax
  80237e:	48 89 c2             	mov    %rax,%rdx
  802381:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802388:	01 00 00 
  80238b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80238f:	83 e0 01             	and    $0x1,%eax
  802392:	48 85 c0             	test   %rax,%rax
  802395:	74 21                	je     8023b8 <fd_alloc+0x6a>
  802397:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80239b:	48 c1 e8 0c          	shr    $0xc,%rax
  80239f:	48 89 c2             	mov    %rax,%rdx
  8023a2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023a9:	01 00 00 
  8023ac:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023b0:	83 e0 01             	and    $0x1,%eax
  8023b3:	48 85 c0             	test   %rax,%rax
  8023b6:	75 12                	jne    8023ca <fd_alloc+0x7c>
			*fd_store = fd;
  8023b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023bc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023c0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8023c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c8:	eb 1a                	jmp    8023e4 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8023ca:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8023ce:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8023d2:	7e 8f                	jle    802363 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8023d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023d8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8023df:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8023e4:	c9                   	leaveq 
  8023e5:	c3                   	retq   

00000000008023e6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8023e6:	55                   	push   %rbp
  8023e7:	48 89 e5             	mov    %rsp,%rbp
  8023ea:	48 83 ec 20          	sub    $0x20,%rsp
  8023ee:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023f1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8023f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8023f9:	78 06                	js     802401 <fd_lookup+0x1b>
  8023fb:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8023ff:	7e 07                	jle    802408 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802401:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802406:	eb 6c                	jmp    802474 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802408:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80240b:	48 98                	cltq   
  80240d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802413:	48 c1 e0 0c          	shl    $0xc,%rax
  802417:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80241b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80241f:	48 c1 e8 15          	shr    $0x15,%rax
  802423:	48 89 c2             	mov    %rax,%rdx
  802426:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80242d:	01 00 00 
  802430:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802434:	83 e0 01             	and    $0x1,%eax
  802437:	48 85 c0             	test   %rax,%rax
  80243a:	74 21                	je     80245d <fd_lookup+0x77>
  80243c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802440:	48 c1 e8 0c          	shr    $0xc,%rax
  802444:	48 89 c2             	mov    %rax,%rdx
  802447:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80244e:	01 00 00 
  802451:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802455:	83 e0 01             	and    $0x1,%eax
  802458:	48 85 c0             	test   %rax,%rax
  80245b:	75 07                	jne    802464 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80245d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802462:	eb 10                	jmp    802474 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802464:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802468:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80246c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80246f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802474:	c9                   	leaveq 
  802475:	c3                   	retq   

0000000000802476 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802476:	55                   	push   %rbp
  802477:	48 89 e5             	mov    %rsp,%rbp
  80247a:	48 83 ec 30          	sub    $0x30,%rsp
  80247e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802482:	89 f0                	mov    %esi,%eax
  802484:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802487:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80248b:	48 89 c7             	mov    %rax,%rdi
  80248e:	48 b8 00 23 80 00 00 	movabs $0x802300,%rax
  802495:	00 00 00 
  802498:	ff d0                	callq  *%rax
  80249a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80249e:	48 89 d6             	mov    %rdx,%rsi
  8024a1:	89 c7                	mov    %eax,%edi
  8024a3:	48 b8 e6 23 80 00 00 	movabs $0x8023e6,%rax
  8024aa:	00 00 00 
  8024ad:	ff d0                	callq  *%rax
  8024af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024b6:	78 0a                	js     8024c2 <fd_close+0x4c>
	    || fd != fd2)
  8024b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024bc:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8024c0:	74 12                	je     8024d4 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8024c2:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8024c6:	74 05                	je     8024cd <fd_close+0x57>
  8024c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024cb:	eb 05                	jmp    8024d2 <fd_close+0x5c>
  8024cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d2:	eb 69                	jmp    80253d <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8024d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024d8:	8b 00                	mov    (%rax),%eax
  8024da:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024de:	48 89 d6             	mov    %rdx,%rsi
  8024e1:	89 c7                	mov    %eax,%edi
  8024e3:	48 b8 3f 25 80 00 00 	movabs $0x80253f,%rax
  8024ea:	00 00 00 
  8024ed:	ff d0                	callq  *%rax
  8024ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f6:	78 2a                	js     802522 <fd_close+0xac>
		if (dev->dev_close)
  8024f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024fc:	48 8b 40 20          	mov    0x20(%rax),%rax
  802500:	48 85 c0             	test   %rax,%rax
  802503:	74 16                	je     80251b <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802505:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802509:	48 8b 40 20          	mov    0x20(%rax),%rax
  80250d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802511:	48 89 d7             	mov    %rdx,%rdi
  802514:	ff d0                	callq  *%rax
  802516:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802519:	eb 07                	jmp    802522 <fd_close+0xac>
		else
			r = 0;
  80251b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802522:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802526:	48 89 c6             	mov    %rax,%rsi
  802529:	bf 00 00 00 00       	mov    $0x0,%edi
  80252e:	48 b8 0e 1a 80 00 00 	movabs $0x801a0e,%rax
  802535:	00 00 00 
  802538:	ff d0                	callq  *%rax
	return r;
  80253a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80253d:	c9                   	leaveq 
  80253e:	c3                   	retq   

000000000080253f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80253f:	55                   	push   %rbp
  802540:	48 89 e5             	mov    %rsp,%rbp
  802543:	48 83 ec 20          	sub    $0x20,%rsp
  802547:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80254a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80254e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802555:	eb 41                	jmp    802598 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802557:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80255e:	00 00 00 
  802561:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802564:	48 63 d2             	movslq %edx,%rdx
  802567:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80256b:	8b 00                	mov    (%rax),%eax
  80256d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802570:	75 22                	jne    802594 <dev_lookup+0x55>
			*dev = devtab[i];
  802572:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802579:	00 00 00 
  80257c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80257f:	48 63 d2             	movslq %edx,%rdx
  802582:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802586:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80258a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80258d:	b8 00 00 00 00       	mov    $0x0,%eax
  802592:	eb 60                	jmp    8025f4 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802594:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802598:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80259f:	00 00 00 
  8025a2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025a5:	48 63 d2             	movslq %edx,%rdx
  8025a8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025ac:	48 85 c0             	test   %rax,%rax
  8025af:	75 a6                	jne    802557 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8025b1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8025b8:	00 00 00 
  8025bb:	48 8b 00             	mov    (%rax),%rax
  8025be:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025c4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8025c7:	89 c6                	mov    %eax,%esi
  8025c9:	48 bf d8 43 80 00 00 	movabs $0x8043d8,%rdi
  8025d0:	00 00 00 
  8025d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d8:	48 b9 7f 04 80 00 00 	movabs $0x80047f,%rcx
  8025df:	00 00 00 
  8025e2:	ff d1                	callq  *%rcx
	*dev = 0;
  8025e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025e8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8025ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8025f4:	c9                   	leaveq 
  8025f5:	c3                   	retq   

00000000008025f6 <close>:

int
close(int fdnum)
{
  8025f6:	55                   	push   %rbp
  8025f7:	48 89 e5             	mov    %rsp,%rbp
  8025fa:	48 83 ec 20          	sub    $0x20,%rsp
  8025fe:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802601:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802605:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802608:	48 89 d6             	mov    %rdx,%rsi
  80260b:	89 c7                	mov    %eax,%edi
  80260d:	48 b8 e6 23 80 00 00 	movabs $0x8023e6,%rax
  802614:	00 00 00 
  802617:	ff d0                	callq  *%rax
  802619:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80261c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802620:	79 05                	jns    802627 <close+0x31>
		return r;
  802622:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802625:	eb 18                	jmp    80263f <close+0x49>
	else
		return fd_close(fd, 1);
  802627:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80262b:	be 01 00 00 00       	mov    $0x1,%esi
  802630:	48 89 c7             	mov    %rax,%rdi
  802633:	48 b8 76 24 80 00 00 	movabs $0x802476,%rax
  80263a:	00 00 00 
  80263d:	ff d0                	callq  *%rax
}
  80263f:	c9                   	leaveq 
  802640:	c3                   	retq   

0000000000802641 <close_all>:

void
close_all(void)
{
  802641:	55                   	push   %rbp
  802642:	48 89 e5             	mov    %rsp,%rbp
  802645:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802649:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802650:	eb 15                	jmp    802667 <close_all+0x26>
		close(i);
  802652:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802655:	89 c7                	mov    %eax,%edi
  802657:	48 b8 f6 25 80 00 00 	movabs $0x8025f6,%rax
  80265e:	00 00 00 
  802661:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802663:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802667:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80266b:	7e e5                	jle    802652 <close_all+0x11>
		close(i);
}
  80266d:	c9                   	leaveq 
  80266e:	c3                   	retq   

000000000080266f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80266f:	55                   	push   %rbp
  802670:	48 89 e5             	mov    %rsp,%rbp
  802673:	48 83 ec 40          	sub    $0x40,%rsp
  802677:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80267a:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80267d:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802681:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802684:	48 89 d6             	mov    %rdx,%rsi
  802687:	89 c7                	mov    %eax,%edi
  802689:	48 b8 e6 23 80 00 00 	movabs $0x8023e6,%rax
  802690:	00 00 00 
  802693:	ff d0                	callq  *%rax
  802695:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802698:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80269c:	79 08                	jns    8026a6 <dup+0x37>
		return r;
  80269e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026a1:	e9 70 01 00 00       	jmpq   802816 <dup+0x1a7>
	close(newfdnum);
  8026a6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026a9:	89 c7                	mov    %eax,%edi
  8026ab:	48 b8 f6 25 80 00 00 	movabs $0x8025f6,%rax
  8026b2:	00 00 00 
  8026b5:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8026b7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026ba:	48 98                	cltq   
  8026bc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026c2:	48 c1 e0 0c          	shl    $0xc,%rax
  8026c6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8026ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026ce:	48 89 c7             	mov    %rax,%rdi
  8026d1:	48 b8 23 23 80 00 00 	movabs $0x802323,%rax
  8026d8:	00 00 00 
  8026db:	ff d0                	callq  *%rax
  8026dd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8026e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026e5:	48 89 c7             	mov    %rax,%rdi
  8026e8:	48 b8 23 23 80 00 00 	movabs $0x802323,%rax
  8026ef:	00 00 00 
  8026f2:	ff d0                	callq  *%rax
  8026f4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8026f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026fc:	48 c1 e8 15          	shr    $0x15,%rax
  802700:	48 89 c2             	mov    %rax,%rdx
  802703:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80270a:	01 00 00 
  80270d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802711:	83 e0 01             	and    $0x1,%eax
  802714:	48 85 c0             	test   %rax,%rax
  802717:	74 73                	je     80278c <dup+0x11d>
  802719:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80271d:	48 c1 e8 0c          	shr    $0xc,%rax
  802721:	48 89 c2             	mov    %rax,%rdx
  802724:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80272b:	01 00 00 
  80272e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802732:	83 e0 01             	and    $0x1,%eax
  802735:	48 85 c0             	test   %rax,%rax
  802738:	74 52                	je     80278c <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80273a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80273e:	48 c1 e8 0c          	shr    $0xc,%rax
  802742:	48 89 c2             	mov    %rax,%rdx
  802745:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80274c:	01 00 00 
  80274f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802753:	25 07 0e 00 00       	and    $0xe07,%eax
  802758:	89 c1                	mov    %eax,%ecx
  80275a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80275e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802762:	41 89 c8             	mov    %ecx,%r8d
  802765:	48 89 d1             	mov    %rdx,%rcx
  802768:	ba 00 00 00 00       	mov    $0x0,%edx
  80276d:	48 89 c6             	mov    %rax,%rsi
  802770:	bf 00 00 00 00       	mov    $0x0,%edi
  802775:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  80277c:	00 00 00 
  80277f:	ff d0                	callq  *%rax
  802781:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802784:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802788:	79 02                	jns    80278c <dup+0x11d>
			goto err;
  80278a:	eb 57                	jmp    8027e3 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80278c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802790:	48 c1 e8 0c          	shr    $0xc,%rax
  802794:	48 89 c2             	mov    %rax,%rdx
  802797:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80279e:	01 00 00 
  8027a1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027a5:	25 07 0e 00 00       	and    $0xe07,%eax
  8027aa:	89 c1                	mov    %eax,%ecx
  8027ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027b0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027b4:	41 89 c8             	mov    %ecx,%r8d
  8027b7:	48 89 d1             	mov    %rdx,%rcx
  8027ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8027bf:	48 89 c6             	mov    %rax,%rsi
  8027c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8027c7:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  8027ce:	00 00 00 
  8027d1:	ff d0                	callq  *%rax
  8027d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027da:	79 02                	jns    8027de <dup+0x16f>
		goto err;
  8027dc:	eb 05                	jmp    8027e3 <dup+0x174>

	return newfdnum;
  8027de:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027e1:	eb 33                	jmp    802816 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8027e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027e7:	48 89 c6             	mov    %rax,%rsi
  8027ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8027ef:	48 b8 0e 1a 80 00 00 	movabs $0x801a0e,%rax
  8027f6:	00 00 00 
  8027f9:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8027fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027ff:	48 89 c6             	mov    %rax,%rsi
  802802:	bf 00 00 00 00       	mov    $0x0,%edi
  802807:	48 b8 0e 1a 80 00 00 	movabs $0x801a0e,%rax
  80280e:	00 00 00 
  802811:	ff d0                	callq  *%rax
	return r;
  802813:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802816:	c9                   	leaveq 
  802817:	c3                   	retq   

0000000000802818 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802818:	55                   	push   %rbp
  802819:	48 89 e5             	mov    %rsp,%rbp
  80281c:	48 83 ec 40          	sub    $0x40,%rsp
  802820:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802823:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802827:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80282b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80282f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802832:	48 89 d6             	mov    %rdx,%rsi
  802835:	89 c7                	mov    %eax,%edi
  802837:	48 b8 e6 23 80 00 00 	movabs $0x8023e6,%rax
  80283e:	00 00 00 
  802841:	ff d0                	callq  *%rax
  802843:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802846:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80284a:	78 24                	js     802870 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80284c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802850:	8b 00                	mov    (%rax),%eax
  802852:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802856:	48 89 d6             	mov    %rdx,%rsi
  802859:	89 c7                	mov    %eax,%edi
  80285b:	48 b8 3f 25 80 00 00 	movabs $0x80253f,%rax
  802862:	00 00 00 
  802865:	ff d0                	callq  *%rax
  802867:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80286a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80286e:	79 05                	jns    802875 <read+0x5d>
		return r;
  802870:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802873:	eb 76                	jmp    8028eb <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802875:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802879:	8b 40 08             	mov    0x8(%rax),%eax
  80287c:	83 e0 03             	and    $0x3,%eax
  80287f:	83 f8 01             	cmp    $0x1,%eax
  802882:	75 3a                	jne    8028be <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802884:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80288b:	00 00 00 
  80288e:	48 8b 00             	mov    (%rax),%rax
  802891:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802897:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80289a:	89 c6                	mov    %eax,%esi
  80289c:	48 bf f7 43 80 00 00 	movabs $0x8043f7,%rdi
  8028a3:	00 00 00 
  8028a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ab:	48 b9 7f 04 80 00 00 	movabs $0x80047f,%rcx
  8028b2:	00 00 00 
  8028b5:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8028b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028bc:	eb 2d                	jmp    8028eb <read+0xd3>
	}
	if (!dev->dev_read)
  8028be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028c2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8028c6:	48 85 c0             	test   %rax,%rax
  8028c9:	75 07                	jne    8028d2 <read+0xba>
		return -E_NOT_SUPP;
  8028cb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028d0:	eb 19                	jmp    8028eb <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8028d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028d6:	48 8b 40 10          	mov    0x10(%rax),%rax
  8028da:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8028de:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8028e2:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8028e6:	48 89 cf             	mov    %rcx,%rdi
  8028e9:	ff d0                	callq  *%rax
}
  8028eb:	c9                   	leaveq 
  8028ec:	c3                   	retq   

00000000008028ed <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8028ed:	55                   	push   %rbp
  8028ee:	48 89 e5             	mov    %rsp,%rbp
  8028f1:	48 83 ec 30          	sub    $0x30,%rsp
  8028f5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028f8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028fc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802900:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802907:	eb 49                	jmp    802952 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802909:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80290c:	48 98                	cltq   
  80290e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802912:	48 29 c2             	sub    %rax,%rdx
  802915:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802918:	48 63 c8             	movslq %eax,%rcx
  80291b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80291f:	48 01 c1             	add    %rax,%rcx
  802922:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802925:	48 89 ce             	mov    %rcx,%rsi
  802928:	89 c7                	mov    %eax,%edi
  80292a:	48 b8 18 28 80 00 00 	movabs $0x802818,%rax
  802931:	00 00 00 
  802934:	ff d0                	callq  *%rax
  802936:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802939:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80293d:	79 05                	jns    802944 <readn+0x57>
			return m;
  80293f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802942:	eb 1c                	jmp    802960 <readn+0x73>
		if (m == 0)
  802944:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802948:	75 02                	jne    80294c <readn+0x5f>
			break;
  80294a:	eb 11                	jmp    80295d <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80294c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80294f:	01 45 fc             	add    %eax,-0x4(%rbp)
  802952:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802955:	48 98                	cltq   
  802957:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80295b:	72 ac                	jb     802909 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80295d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802960:	c9                   	leaveq 
  802961:	c3                   	retq   

0000000000802962 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802962:	55                   	push   %rbp
  802963:	48 89 e5             	mov    %rsp,%rbp
  802966:	48 83 ec 40          	sub    $0x40,%rsp
  80296a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80296d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802971:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802975:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802979:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80297c:	48 89 d6             	mov    %rdx,%rsi
  80297f:	89 c7                	mov    %eax,%edi
  802981:	48 b8 e6 23 80 00 00 	movabs $0x8023e6,%rax
  802988:	00 00 00 
  80298b:	ff d0                	callq  *%rax
  80298d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802990:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802994:	78 24                	js     8029ba <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802996:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80299a:	8b 00                	mov    (%rax),%eax
  80299c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029a0:	48 89 d6             	mov    %rdx,%rsi
  8029a3:	89 c7                	mov    %eax,%edi
  8029a5:	48 b8 3f 25 80 00 00 	movabs $0x80253f,%rax
  8029ac:	00 00 00 
  8029af:	ff d0                	callq  *%rax
  8029b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029b8:	79 05                	jns    8029bf <write+0x5d>
		return r;
  8029ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029bd:	eb 75                	jmp    802a34 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8029bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029c3:	8b 40 08             	mov    0x8(%rax),%eax
  8029c6:	83 e0 03             	and    $0x3,%eax
  8029c9:	85 c0                	test   %eax,%eax
  8029cb:	75 3a                	jne    802a07 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8029cd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8029d4:	00 00 00 
  8029d7:	48 8b 00             	mov    (%rax),%rax
  8029da:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029e0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8029e3:	89 c6                	mov    %eax,%esi
  8029e5:	48 bf 13 44 80 00 00 	movabs $0x804413,%rdi
  8029ec:	00 00 00 
  8029ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f4:	48 b9 7f 04 80 00 00 	movabs $0x80047f,%rcx
  8029fb:	00 00 00 
  8029fe:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a00:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a05:	eb 2d                	jmp    802a34 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802a07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a0b:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a0f:	48 85 c0             	test   %rax,%rax
  802a12:	75 07                	jne    802a1b <write+0xb9>
		return -E_NOT_SUPP;
  802a14:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a19:	eb 19                	jmp    802a34 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802a1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a1f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a23:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802a27:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a2b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802a2f:	48 89 cf             	mov    %rcx,%rdi
  802a32:	ff d0                	callq  *%rax
}
  802a34:	c9                   	leaveq 
  802a35:	c3                   	retq   

0000000000802a36 <seek>:

int
seek(int fdnum, off_t offset)
{
  802a36:	55                   	push   %rbp
  802a37:	48 89 e5             	mov    %rsp,%rbp
  802a3a:	48 83 ec 18          	sub    $0x18,%rsp
  802a3e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a41:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a44:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a48:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a4b:	48 89 d6             	mov    %rdx,%rsi
  802a4e:	89 c7                	mov    %eax,%edi
  802a50:	48 b8 e6 23 80 00 00 	movabs $0x8023e6,%rax
  802a57:	00 00 00 
  802a5a:	ff d0                	callq  *%rax
  802a5c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a5f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a63:	79 05                	jns    802a6a <seek+0x34>
		return r;
  802a65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a68:	eb 0f                	jmp    802a79 <seek+0x43>
	fd->fd_offset = offset;
  802a6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a6e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802a71:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802a74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a79:	c9                   	leaveq 
  802a7a:	c3                   	retq   

0000000000802a7b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802a7b:	55                   	push   %rbp
  802a7c:	48 89 e5             	mov    %rsp,%rbp
  802a7f:	48 83 ec 30          	sub    $0x30,%rsp
  802a83:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a86:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a89:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a8d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a90:	48 89 d6             	mov    %rdx,%rsi
  802a93:	89 c7                	mov    %eax,%edi
  802a95:	48 b8 e6 23 80 00 00 	movabs $0x8023e6,%rax
  802a9c:	00 00 00 
  802a9f:	ff d0                	callq  *%rax
  802aa1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aa4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aa8:	78 24                	js     802ace <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802aaa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aae:	8b 00                	mov    (%rax),%eax
  802ab0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ab4:	48 89 d6             	mov    %rdx,%rsi
  802ab7:	89 c7                	mov    %eax,%edi
  802ab9:	48 b8 3f 25 80 00 00 	movabs $0x80253f,%rax
  802ac0:	00 00 00 
  802ac3:	ff d0                	callq  *%rax
  802ac5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ac8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802acc:	79 05                	jns    802ad3 <ftruncate+0x58>
		return r;
  802ace:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ad1:	eb 72                	jmp    802b45 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802ad3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ad7:	8b 40 08             	mov    0x8(%rax),%eax
  802ada:	83 e0 03             	and    $0x3,%eax
  802add:	85 c0                	test   %eax,%eax
  802adf:	75 3a                	jne    802b1b <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802ae1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802ae8:	00 00 00 
  802aeb:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802aee:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802af4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802af7:	89 c6                	mov    %eax,%esi
  802af9:	48 bf 30 44 80 00 00 	movabs $0x804430,%rdi
  802b00:	00 00 00 
  802b03:	b8 00 00 00 00       	mov    $0x0,%eax
  802b08:	48 b9 7f 04 80 00 00 	movabs $0x80047f,%rcx
  802b0f:	00 00 00 
  802b12:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802b14:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b19:	eb 2a                	jmp    802b45 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802b1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b1f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b23:	48 85 c0             	test   %rax,%rax
  802b26:	75 07                	jne    802b2f <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802b28:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b2d:	eb 16                	jmp    802b45 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802b2f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b33:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b37:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b3b:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802b3e:	89 ce                	mov    %ecx,%esi
  802b40:	48 89 d7             	mov    %rdx,%rdi
  802b43:	ff d0                	callq  *%rax
}
  802b45:	c9                   	leaveq 
  802b46:	c3                   	retq   

0000000000802b47 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802b47:	55                   	push   %rbp
  802b48:	48 89 e5             	mov    %rsp,%rbp
  802b4b:	48 83 ec 30          	sub    $0x30,%rsp
  802b4f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b52:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b56:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b5a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b5d:	48 89 d6             	mov    %rdx,%rsi
  802b60:	89 c7                	mov    %eax,%edi
  802b62:	48 b8 e6 23 80 00 00 	movabs $0x8023e6,%rax
  802b69:	00 00 00 
  802b6c:	ff d0                	callq  *%rax
  802b6e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b71:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b75:	78 24                	js     802b9b <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b7b:	8b 00                	mov    (%rax),%eax
  802b7d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b81:	48 89 d6             	mov    %rdx,%rsi
  802b84:	89 c7                	mov    %eax,%edi
  802b86:	48 b8 3f 25 80 00 00 	movabs $0x80253f,%rax
  802b8d:	00 00 00 
  802b90:	ff d0                	callq  *%rax
  802b92:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b95:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b99:	79 05                	jns    802ba0 <fstat+0x59>
		return r;
  802b9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b9e:	eb 5e                	jmp    802bfe <fstat+0xb7>
	if (!dev->dev_stat)
  802ba0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ba4:	48 8b 40 28          	mov    0x28(%rax),%rax
  802ba8:	48 85 c0             	test   %rax,%rax
  802bab:	75 07                	jne    802bb4 <fstat+0x6d>
		return -E_NOT_SUPP;
  802bad:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802bb2:	eb 4a                	jmp    802bfe <fstat+0xb7>
	stat->st_name[0] = 0;
  802bb4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bb8:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802bbb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bbf:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802bc6:	00 00 00 
	stat->st_isdir = 0;
  802bc9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bcd:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802bd4:	00 00 00 
	stat->st_dev = dev;
  802bd7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802bdb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bdf:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802be6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bea:	48 8b 40 28          	mov    0x28(%rax),%rax
  802bee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bf2:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802bf6:	48 89 ce             	mov    %rcx,%rsi
  802bf9:	48 89 d7             	mov    %rdx,%rdi
  802bfc:	ff d0                	callq  *%rax
}
  802bfe:	c9                   	leaveq 
  802bff:	c3                   	retq   

0000000000802c00 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802c00:	55                   	push   %rbp
  802c01:	48 89 e5             	mov    %rsp,%rbp
  802c04:	48 83 ec 20          	sub    $0x20,%rsp
  802c08:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c0c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802c10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c14:	be 00 00 00 00       	mov    $0x0,%esi
  802c19:	48 89 c7             	mov    %rax,%rdi
  802c1c:	48 b8 ee 2c 80 00 00 	movabs $0x802cee,%rax
  802c23:	00 00 00 
  802c26:	ff d0                	callq  *%rax
  802c28:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c2b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c2f:	79 05                	jns    802c36 <stat+0x36>
		return fd;
  802c31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c34:	eb 2f                	jmp    802c65 <stat+0x65>
	r = fstat(fd, stat);
  802c36:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c3d:	48 89 d6             	mov    %rdx,%rsi
  802c40:	89 c7                	mov    %eax,%edi
  802c42:	48 b8 47 2b 80 00 00 	movabs $0x802b47,%rax
  802c49:	00 00 00 
  802c4c:	ff d0                	callq  *%rax
  802c4e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802c51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c54:	89 c7                	mov    %eax,%edi
  802c56:	48 b8 f6 25 80 00 00 	movabs $0x8025f6,%rax
  802c5d:	00 00 00 
  802c60:	ff d0                	callq  *%rax
	return r;
  802c62:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802c65:	c9                   	leaveq 
  802c66:	c3                   	retq   

0000000000802c67 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802c67:	55                   	push   %rbp
  802c68:	48 89 e5             	mov    %rsp,%rbp
  802c6b:	48 83 ec 10          	sub    $0x10,%rsp
  802c6f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c72:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802c76:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c7d:	00 00 00 
  802c80:	8b 00                	mov    (%rax),%eax
  802c82:	85 c0                	test   %eax,%eax
  802c84:	75 1d                	jne    802ca3 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802c86:	bf 01 00 00 00       	mov    $0x1,%edi
  802c8b:	48 b8 7e 22 80 00 00 	movabs $0x80227e,%rax
  802c92:	00 00 00 
  802c95:	ff d0                	callq  *%rax
  802c97:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802c9e:	00 00 00 
  802ca1:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802ca3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802caa:	00 00 00 
  802cad:	8b 00                	mov    (%rax),%eax
  802caf:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802cb2:	b9 07 00 00 00       	mov    $0x7,%ecx
  802cb7:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802cbe:	00 00 00 
  802cc1:	89 c7                	mov    %eax,%edi
  802cc3:	48 b8 e1 21 80 00 00 	movabs $0x8021e1,%rax
  802cca:	00 00 00 
  802ccd:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802ccf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cd3:	ba 00 00 00 00       	mov    $0x0,%edx
  802cd8:	48 89 c6             	mov    %rax,%rsi
  802cdb:	bf 00 00 00 00       	mov    $0x0,%edi
  802ce0:	48 b8 1b 21 80 00 00 	movabs $0x80211b,%rax
  802ce7:	00 00 00 
  802cea:	ff d0                	callq  *%rax
}
  802cec:	c9                   	leaveq 
  802ced:	c3                   	retq   

0000000000802cee <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802cee:	55                   	push   %rbp
  802cef:	48 89 e5             	mov    %rsp,%rbp
  802cf2:	48 83 ec 20          	sub    $0x20,%rsp
  802cf6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802cfa:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  802cfd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d01:	48 89 c7             	mov    %rax,%rdi
  802d04:	48 b8 c8 0f 80 00 00 	movabs $0x800fc8,%rax
  802d0b:	00 00 00 
  802d0e:	ff d0                	callq  *%rax
  802d10:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802d15:	7e 0a                	jle    802d21 <open+0x33>
  802d17:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802d1c:	e9 a5 00 00 00       	jmpq   802dc6 <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  802d21:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802d25:	48 89 c7             	mov    %rax,%rdi
  802d28:	48 b8 4e 23 80 00 00 	movabs $0x80234e,%rax
  802d2f:	00 00 00 
  802d32:	ff d0                	callq  *%rax
  802d34:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d37:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d3b:	79 08                	jns    802d45 <open+0x57>
		return r;
  802d3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d40:	e9 81 00 00 00       	jmpq   802dc6 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  802d45:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d4c:	00 00 00 
  802d4f:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802d52:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  802d58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d5c:	48 89 c6             	mov    %rax,%rsi
  802d5f:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802d66:	00 00 00 
  802d69:	48 b8 34 10 80 00 00 	movabs $0x801034,%rax
  802d70:	00 00 00 
  802d73:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  802d75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d79:	48 89 c6             	mov    %rax,%rsi
  802d7c:	bf 01 00 00 00       	mov    $0x1,%edi
  802d81:	48 b8 67 2c 80 00 00 	movabs $0x802c67,%rax
  802d88:	00 00 00 
  802d8b:	ff d0                	callq  *%rax
  802d8d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d90:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d94:	79 1d                	jns    802db3 <open+0xc5>
		fd_close(fd, 0);
  802d96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d9a:	be 00 00 00 00       	mov    $0x0,%esi
  802d9f:	48 89 c7             	mov    %rax,%rdi
  802da2:	48 b8 76 24 80 00 00 	movabs $0x802476,%rax
  802da9:	00 00 00 
  802dac:	ff d0                	callq  *%rax
		return r;
  802dae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db1:	eb 13                	jmp    802dc6 <open+0xd8>
	}
	return fd2num(fd);
  802db3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802db7:	48 89 c7             	mov    %rax,%rdi
  802dba:	48 b8 00 23 80 00 00 	movabs $0x802300,%rax
  802dc1:	00 00 00 
  802dc4:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  802dc6:	c9                   	leaveq 
  802dc7:	c3                   	retq   

0000000000802dc8 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802dc8:	55                   	push   %rbp
  802dc9:	48 89 e5             	mov    %rsp,%rbp
  802dcc:	48 83 ec 10          	sub    $0x10,%rsp
  802dd0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802dd4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dd8:	8b 50 0c             	mov    0xc(%rax),%edx
  802ddb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802de2:	00 00 00 
  802de5:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802de7:	be 00 00 00 00       	mov    $0x0,%esi
  802dec:	bf 06 00 00 00       	mov    $0x6,%edi
  802df1:	48 b8 67 2c 80 00 00 	movabs $0x802c67,%rax
  802df8:	00 00 00 
  802dfb:	ff d0                	callq  *%rax
}
  802dfd:	c9                   	leaveq 
  802dfe:	c3                   	retq   

0000000000802dff <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802dff:	55                   	push   %rbp
  802e00:	48 89 e5             	mov    %rsp,%rbp
  802e03:	48 83 ec 30          	sub    $0x30,%rsp
  802e07:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e0b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e0f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802e13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e17:	8b 50 0c             	mov    0xc(%rax),%edx
  802e1a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e21:	00 00 00 
  802e24:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802e26:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e2d:	00 00 00 
  802e30:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e34:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  802e38:	be 00 00 00 00       	mov    $0x0,%esi
  802e3d:	bf 03 00 00 00       	mov    $0x3,%edi
  802e42:	48 b8 67 2c 80 00 00 	movabs $0x802c67,%rax
  802e49:	00 00 00 
  802e4c:	ff d0                	callq  *%rax
  802e4e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e51:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e55:	79 05                	jns    802e5c <devfile_read+0x5d>
		return r;
  802e57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e5a:	eb 26                	jmp    802e82 <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  802e5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e5f:	48 63 d0             	movslq %eax,%rdx
  802e62:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e66:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802e6d:	00 00 00 
  802e70:	48 89 c7             	mov    %rax,%rdi
  802e73:	48 b8 6f 14 80 00 00 	movabs $0x80146f,%rax
  802e7a:	00 00 00 
  802e7d:	ff d0                	callq  *%rax
	return r;
  802e7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802e82:	c9                   	leaveq 
  802e83:	c3                   	retq   

0000000000802e84 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802e84:	55                   	push   %rbp
  802e85:	48 89 e5             	mov    %rsp,%rbp
  802e88:	48 83 ec 30          	sub    $0x30,%rsp
  802e8c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e90:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e94:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  802e98:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  802e9f:	00 
	n = n > max ? max : n;
  802ea0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ea4:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802ea8:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  802ead:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802eb1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eb5:	8b 50 0c             	mov    0xc(%rax),%edx
  802eb8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ebf:	00 00 00 
  802ec2:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802ec4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ecb:	00 00 00 
  802ece:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ed2:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802ed6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802eda:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ede:	48 89 c6             	mov    %rax,%rsi
  802ee1:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802ee8:	00 00 00 
  802eeb:	48 b8 6f 14 80 00 00 	movabs $0x80146f,%rax
  802ef2:	00 00 00 
  802ef5:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  802ef7:	be 00 00 00 00       	mov    $0x0,%esi
  802efc:	bf 04 00 00 00       	mov    $0x4,%edi
  802f01:	48 b8 67 2c 80 00 00 	movabs $0x802c67,%rax
  802f08:	00 00 00 
  802f0b:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  802f0d:	c9                   	leaveq 
  802f0e:	c3                   	retq   

0000000000802f0f <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802f0f:	55                   	push   %rbp
  802f10:	48 89 e5             	mov    %rsp,%rbp
  802f13:	48 83 ec 20          	sub    $0x20,%rsp
  802f17:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f1b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802f1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f23:	8b 50 0c             	mov    0xc(%rax),%edx
  802f26:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f2d:	00 00 00 
  802f30:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802f32:	be 00 00 00 00       	mov    $0x0,%esi
  802f37:	bf 05 00 00 00       	mov    $0x5,%edi
  802f3c:	48 b8 67 2c 80 00 00 	movabs $0x802c67,%rax
  802f43:	00 00 00 
  802f46:	ff d0                	callq  *%rax
  802f48:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f4b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f4f:	79 05                	jns    802f56 <devfile_stat+0x47>
		return r;
  802f51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f54:	eb 56                	jmp    802fac <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802f56:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f5a:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802f61:	00 00 00 
  802f64:	48 89 c7             	mov    %rax,%rdi
  802f67:	48 b8 34 10 80 00 00 	movabs $0x801034,%rax
  802f6e:	00 00 00 
  802f71:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802f73:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f7a:	00 00 00 
  802f7d:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802f83:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f87:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802f8d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f94:	00 00 00 
  802f97:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802f9d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fa1:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802fa7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fac:	c9                   	leaveq 
  802fad:	c3                   	retq   

0000000000802fae <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802fae:	55                   	push   %rbp
  802faf:	48 89 e5             	mov    %rsp,%rbp
  802fb2:	48 83 ec 10          	sub    $0x10,%rsp
  802fb6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802fba:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802fbd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fc1:	8b 50 0c             	mov    0xc(%rax),%edx
  802fc4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fcb:	00 00 00 
  802fce:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802fd0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fd7:	00 00 00 
  802fda:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802fdd:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802fe0:	be 00 00 00 00       	mov    $0x0,%esi
  802fe5:	bf 02 00 00 00       	mov    $0x2,%edi
  802fea:	48 b8 67 2c 80 00 00 	movabs $0x802c67,%rax
  802ff1:	00 00 00 
  802ff4:	ff d0                	callq  *%rax
}
  802ff6:	c9                   	leaveq 
  802ff7:	c3                   	retq   

0000000000802ff8 <remove>:

// Delete a file
int
remove(const char *path)
{
  802ff8:	55                   	push   %rbp
  802ff9:	48 89 e5             	mov    %rsp,%rbp
  802ffc:	48 83 ec 10          	sub    $0x10,%rsp
  803000:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803004:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803008:	48 89 c7             	mov    %rax,%rdi
  80300b:	48 b8 c8 0f 80 00 00 	movabs $0x800fc8,%rax
  803012:	00 00 00 
  803015:	ff d0                	callq  *%rax
  803017:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80301c:	7e 07                	jle    803025 <remove+0x2d>
		return -E_BAD_PATH;
  80301e:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803023:	eb 33                	jmp    803058 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803025:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803029:	48 89 c6             	mov    %rax,%rsi
  80302c:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803033:	00 00 00 
  803036:	48 b8 34 10 80 00 00 	movabs $0x801034,%rax
  80303d:	00 00 00 
  803040:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803042:	be 00 00 00 00       	mov    $0x0,%esi
  803047:	bf 07 00 00 00       	mov    $0x7,%edi
  80304c:	48 b8 67 2c 80 00 00 	movabs $0x802c67,%rax
  803053:	00 00 00 
  803056:	ff d0                	callq  *%rax
}
  803058:	c9                   	leaveq 
  803059:	c3                   	retq   

000000000080305a <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80305a:	55                   	push   %rbp
  80305b:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80305e:	be 00 00 00 00       	mov    $0x0,%esi
  803063:	bf 08 00 00 00       	mov    $0x8,%edi
  803068:	48 b8 67 2c 80 00 00 	movabs $0x802c67,%rax
  80306f:	00 00 00 
  803072:	ff d0                	callq  *%rax
}
  803074:	5d                   	pop    %rbp
  803075:	c3                   	retq   

0000000000803076 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803076:	55                   	push   %rbp
  803077:	48 89 e5             	mov    %rsp,%rbp
  80307a:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803081:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803088:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80308f:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803096:	be 00 00 00 00       	mov    $0x0,%esi
  80309b:	48 89 c7             	mov    %rax,%rdi
  80309e:	48 b8 ee 2c 80 00 00 	movabs $0x802cee,%rax
  8030a5:	00 00 00 
  8030a8:	ff d0                	callq  *%rax
  8030aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8030ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030b1:	79 28                	jns    8030db <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8030b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030b6:	89 c6                	mov    %eax,%esi
  8030b8:	48 bf 56 44 80 00 00 	movabs $0x804456,%rdi
  8030bf:	00 00 00 
  8030c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8030c7:	48 ba 7f 04 80 00 00 	movabs $0x80047f,%rdx
  8030ce:	00 00 00 
  8030d1:	ff d2                	callq  *%rdx
		return fd_src;
  8030d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030d6:	e9 74 01 00 00       	jmpq   80324f <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8030db:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8030e2:	be 01 01 00 00       	mov    $0x101,%esi
  8030e7:	48 89 c7             	mov    %rax,%rdi
  8030ea:	48 b8 ee 2c 80 00 00 	movabs $0x802cee,%rax
  8030f1:	00 00 00 
  8030f4:	ff d0                	callq  *%rax
  8030f6:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8030f9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8030fd:	79 39                	jns    803138 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8030ff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803102:	89 c6                	mov    %eax,%esi
  803104:	48 bf 6c 44 80 00 00 	movabs $0x80446c,%rdi
  80310b:	00 00 00 
  80310e:	b8 00 00 00 00       	mov    $0x0,%eax
  803113:	48 ba 7f 04 80 00 00 	movabs $0x80047f,%rdx
  80311a:	00 00 00 
  80311d:	ff d2                	callq  *%rdx
		close(fd_src);
  80311f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803122:	89 c7                	mov    %eax,%edi
  803124:	48 b8 f6 25 80 00 00 	movabs $0x8025f6,%rax
  80312b:	00 00 00 
  80312e:	ff d0                	callq  *%rax
		return fd_dest;
  803130:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803133:	e9 17 01 00 00       	jmpq   80324f <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803138:	eb 74                	jmp    8031ae <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80313a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80313d:	48 63 d0             	movslq %eax,%rdx
  803140:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803147:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80314a:	48 89 ce             	mov    %rcx,%rsi
  80314d:	89 c7                	mov    %eax,%edi
  80314f:	48 b8 62 29 80 00 00 	movabs $0x802962,%rax
  803156:	00 00 00 
  803159:	ff d0                	callq  *%rax
  80315b:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80315e:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803162:	79 4a                	jns    8031ae <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803164:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803167:	89 c6                	mov    %eax,%esi
  803169:	48 bf 86 44 80 00 00 	movabs $0x804486,%rdi
  803170:	00 00 00 
  803173:	b8 00 00 00 00       	mov    $0x0,%eax
  803178:	48 ba 7f 04 80 00 00 	movabs $0x80047f,%rdx
  80317f:	00 00 00 
  803182:	ff d2                	callq  *%rdx
			close(fd_src);
  803184:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803187:	89 c7                	mov    %eax,%edi
  803189:	48 b8 f6 25 80 00 00 	movabs $0x8025f6,%rax
  803190:	00 00 00 
  803193:	ff d0                	callq  *%rax
			close(fd_dest);
  803195:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803198:	89 c7                	mov    %eax,%edi
  80319a:	48 b8 f6 25 80 00 00 	movabs $0x8025f6,%rax
  8031a1:	00 00 00 
  8031a4:	ff d0                	callq  *%rax
			return write_size;
  8031a6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8031a9:	e9 a1 00 00 00       	jmpq   80324f <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8031ae:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8031b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031b8:	ba 00 02 00 00       	mov    $0x200,%edx
  8031bd:	48 89 ce             	mov    %rcx,%rsi
  8031c0:	89 c7                	mov    %eax,%edi
  8031c2:	48 b8 18 28 80 00 00 	movabs $0x802818,%rax
  8031c9:	00 00 00 
  8031cc:	ff d0                	callq  *%rax
  8031ce:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8031d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8031d5:	0f 8f 5f ff ff ff    	jg     80313a <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8031db:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8031df:	79 47                	jns    803228 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8031e1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8031e4:	89 c6                	mov    %eax,%esi
  8031e6:	48 bf 99 44 80 00 00 	movabs $0x804499,%rdi
  8031ed:	00 00 00 
  8031f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8031f5:	48 ba 7f 04 80 00 00 	movabs $0x80047f,%rdx
  8031fc:	00 00 00 
  8031ff:	ff d2                	callq  *%rdx
		close(fd_src);
  803201:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803204:	89 c7                	mov    %eax,%edi
  803206:	48 b8 f6 25 80 00 00 	movabs $0x8025f6,%rax
  80320d:	00 00 00 
  803210:	ff d0                	callq  *%rax
		close(fd_dest);
  803212:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803215:	89 c7                	mov    %eax,%edi
  803217:	48 b8 f6 25 80 00 00 	movabs $0x8025f6,%rax
  80321e:	00 00 00 
  803221:	ff d0                	callq  *%rax
		return read_size;
  803223:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803226:	eb 27                	jmp    80324f <copy+0x1d9>
	}
	close(fd_src);
  803228:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80322b:	89 c7                	mov    %eax,%edi
  80322d:	48 b8 f6 25 80 00 00 	movabs $0x8025f6,%rax
  803234:	00 00 00 
  803237:	ff d0                	callq  *%rax
	close(fd_dest);
  803239:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80323c:	89 c7                	mov    %eax,%edi
  80323e:	48 b8 f6 25 80 00 00 	movabs $0x8025f6,%rax
  803245:	00 00 00 
  803248:	ff d0                	callq  *%rax
	return 0;
  80324a:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80324f:	c9                   	leaveq 
  803250:	c3                   	retq   

0000000000803251 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803251:	55                   	push   %rbp
  803252:	48 89 e5             	mov    %rsp,%rbp
  803255:	53                   	push   %rbx
  803256:	48 83 ec 38          	sub    $0x38,%rsp
  80325a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80325e:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803262:	48 89 c7             	mov    %rax,%rdi
  803265:	48 b8 4e 23 80 00 00 	movabs $0x80234e,%rax
  80326c:	00 00 00 
  80326f:	ff d0                	callq  *%rax
  803271:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803274:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803278:	0f 88 bf 01 00 00    	js     80343d <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80327e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803282:	ba 07 04 00 00       	mov    $0x407,%edx
  803287:	48 89 c6             	mov    %rax,%rsi
  80328a:	bf 00 00 00 00       	mov    $0x0,%edi
  80328f:	48 b8 63 19 80 00 00 	movabs $0x801963,%rax
  803296:	00 00 00 
  803299:	ff d0                	callq  *%rax
  80329b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80329e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032a2:	0f 88 95 01 00 00    	js     80343d <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8032a8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8032ac:	48 89 c7             	mov    %rax,%rdi
  8032af:	48 b8 4e 23 80 00 00 	movabs $0x80234e,%rax
  8032b6:	00 00 00 
  8032b9:	ff d0                	callq  *%rax
  8032bb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032be:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032c2:	0f 88 5d 01 00 00    	js     803425 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032cc:	ba 07 04 00 00       	mov    $0x407,%edx
  8032d1:	48 89 c6             	mov    %rax,%rsi
  8032d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8032d9:	48 b8 63 19 80 00 00 	movabs $0x801963,%rax
  8032e0:	00 00 00 
  8032e3:	ff d0                	callq  *%rax
  8032e5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032e8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032ec:	0f 88 33 01 00 00    	js     803425 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8032f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032f6:	48 89 c7             	mov    %rax,%rdi
  8032f9:	48 b8 23 23 80 00 00 	movabs $0x802323,%rax
  803300:	00 00 00 
  803303:	ff d0                	callq  *%rax
  803305:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803309:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80330d:	ba 07 04 00 00       	mov    $0x407,%edx
  803312:	48 89 c6             	mov    %rax,%rsi
  803315:	bf 00 00 00 00       	mov    $0x0,%edi
  80331a:	48 b8 63 19 80 00 00 	movabs $0x801963,%rax
  803321:	00 00 00 
  803324:	ff d0                	callq  *%rax
  803326:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803329:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80332d:	79 05                	jns    803334 <pipe+0xe3>
		goto err2;
  80332f:	e9 d9 00 00 00       	jmpq   80340d <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803334:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803338:	48 89 c7             	mov    %rax,%rdi
  80333b:	48 b8 23 23 80 00 00 	movabs $0x802323,%rax
  803342:	00 00 00 
  803345:	ff d0                	callq  *%rax
  803347:	48 89 c2             	mov    %rax,%rdx
  80334a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80334e:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803354:	48 89 d1             	mov    %rdx,%rcx
  803357:	ba 00 00 00 00       	mov    $0x0,%edx
  80335c:	48 89 c6             	mov    %rax,%rsi
  80335f:	bf 00 00 00 00       	mov    $0x0,%edi
  803364:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  80336b:	00 00 00 
  80336e:	ff d0                	callq  *%rax
  803370:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803373:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803377:	79 1b                	jns    803394 <pipe+0x143>
		goto err3;
  803379:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80337a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80337e:	48 89 c6             	mov    %rax,%rsi
  803381:	bf 00 00 00 00       	mov    $0x0,%edi
  803386:	48 b8 0e 1a 80 00 00 	movabs $0x801a0e,%rax
  80338d:	00 00 00 
  803390:	ff d0                	callq  *%rax
  803392:	eb 79                	jmp    80340d <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803394:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803398:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  80339f:	00 00 00 
  8033a2:	8b 12                	mov    (%rdx),%edx
  8033a4:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8033a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033aa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8033b1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033b5:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  8033bc:	00 00 00 
  8033bf:	8b 12                	mov    (%rdx),%edx
  8033c1:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8033c3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033c7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8033ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033d2:	48 89 c7             	mov    %rax,%rdi
  8033d5:	48 b8 00 23 80 00 00 	movabs $0x802300,%rax
  8033dc:	00 00 00 
  8033df:	ff d0                	callq  *%rax
  8033e1:	89 c2                	mov    %eax,%edx
  8033e3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8033e7:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8033e9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8033ed:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8033f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033f5:	48 89 c7             	mov    %rax,%rdi
  8033f8:	48 b8 00 23 80 00 00 	movabs $0x802300,%rax
  8033ff:	00 00 00 
  803402:	ff d0                	callq  *%rax
  803404:	89 03                	mov    %eax,(%rbx)
	return 0;
  803406:	b8 00 00 00 00       	mov    $0x0,%eax
  80340b:	eb 33                	jmp    803440 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80340d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803411:	48 89 c6             	mov    %rax,%rsi
  803414:	bf 00 00 00 00       	mov    $0x0,%edi
  803419:	48 b8 0e 1a 80 00 00 	movabs $0x801a0e,%rax
  803420:	00 00 00 
  803423:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803425:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803429:	48 89 c6             	mov    %rax,%rsi
  80342c:	bf 00 00 00 00       	mov    $0x0,%edi
  803431:	48 b8 0e 1a 80 00 00 	movabs $0x801a0e,%rax
  803438:	00 00 00 
  80343b:	ff d0                	callq  *%rax
err:
	return r;
  80343d:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803440:	48 83 c4 38          	add    $0x38,%rsp
  803444:	5b                   	pop    %rbx
  803445:	5d                   	pop    %rbp
  803446:	c3                   	retq   

0000000000803447 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803447:	55                   	push   %rbp
  803448:	48 89 e5             	mov    %rsp,%rbp
  80344b:	53                   	push   %rbx
  80344c:	48 83 ec 28          	sub    $0x28,%rsp
  803450:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803454:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803458:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80345f:	00 00 00 
  803462:	48 8b 00             	mov    (%rax),%rax
  803465:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80346b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80346e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803472:	48 89 c7             	mov    %rax,%rdi
  803475:	48 b8 00 3d 80 00 00 	movabs $0x803d00,%rax
  80347c:	00 00 00 
  80347f:	ff d0                	callq  *%rax
  803481:	89 c3                	mov    %eax,%ebx
  803483:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803487:	48 89 c7             	mov    %rax,%rdi
  80348a:	48 b8 00 3d 80 00 00 	movabs $0x803d00,%rax
  803491:	00 00 00 
  803494:	ff d0                	callq  *%rax
  803496:	39 c3                	cmp    %eax,%ebx
  803498:	0f 94 c0             	sete   %al
  80349b:	0f b6 c0             	movzbl %al,%eax
  80349e:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8034a1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8034a8:	00 00 00 
  8034ab:	48 8b 00             	mov    (%rax),%rax
  8034ae:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8034b4:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8034b7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034ba:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8034bd:	75 05                	jne    8034c4 <_pipeisclosed+0x7d>
			return ret;
  8034bf:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8034c2:	eb 4f                	jmp    803513 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8034c4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034c7:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8034ca:	74 42                	je     80350e <_pipeisclosed+0xc7>
  8034cc:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8034d0:	75 3c                	jne    80350e <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8034d2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8034d9:	00 00 00 
  8034dc:	48 8b 00             	mov    (%rax),%rax
  8034df:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8034e5:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8034e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034eb:	89 c6                	mov    %eax,%esi
  8034ed:	48 bf b4 44 80 00 00 	movabs $0x8044b4,%rdi
  8034f4:	00 00 00 
  8034f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8034fc:	49 b8 7f 04 80 00 00 	movabs $0x80047f,%r8
  803503:	00 00 00 
  803506:	41 ff d0             	callq  *%r8
	}
  803509:	e9 4a ff ff ff       	jmpq   803458 <_pipeisclosed+0x11>
  80350e:	e9 45 ff ff ff       	jmpq   803458 <_pipeisclosed+0x11>
}
  803513:	48 83 c4 28          	add    $0x28,%rsp
  803517:	5b                   	pop    %rbx
  803518:	5d                   	pop    %rbp
  803519:	c3                   	retq   

000000000080351a <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80351a:	55                   	push   %rbp
  80351b:	48 89 e5             	mov    %rsp,%rbp
  80351e:	48 83 ec 30          	sub    $0x30,%rsp
  803522:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803525:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803529:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80352c:	48 89 d6             	mov    %rdx,%rsi
  80352f:	89 c7                	mov    %eax,%edi
  803531:	48 b8 e6 23 80 00 00 	movabs $0x8023e6,%rax
  803538:	00 00 00 
  80353b:	ff d0                	callq  *%rax
  80353d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803540:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803544:	79 05                	jns    80354b <pipeisclosed+0x31>
		return r;
  803546:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803549:	eb 31                	jmp    80357c <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80354b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80354f:	48 89 c7             	mov    %rax,%rdi
  803552:	48 b8 23 23 80 00 00 	movabs $0x802323,%rax
  803559:	00 00 00 
  80355c:	ff d0                	callq  *%rax
  80355e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803562:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803566:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80356a:	48 89 d6             	mov    %rdx,%rsi
  80356d:	48 89 c7             	mov    %rax,%rdi
  803570:	48 b8 47 34 80 00 00 	movabs $0x803447,%rax
  803577:	00 00 00 
  80357a:	ff d0                	callq  *%rax
}
  80357c:	c9                   	leaveq 
  80357d:	c3                   	retq   

000000000080357e <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80357e:	55                   	push   %rbp
  80357f:	48 89 e5             	mov    %rsp,%rbp
  803582:	48 83 ec 40          	sub    $0x40,%rsp
  803586:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80358a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80358e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803592:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803596:	48 89 c7             	mov    %rax,%rdi
  803599:	48 b8 23 23 80 00 00 	movabs $0x802323,%rax
  8035a0:	00 00 00 
  8035a3:	ff d0                	callq  *%rax
  8035a5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8035a9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035ad:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8035b1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8035b8:	00 
  8035b9:	e9 92 00 00 00       	jmpq   803650 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8035be:	eb 41                	jmp    803601 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8035c0:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8035c5:	74 09                	je     8035d0 <devpipe_read+0x52>
				return i;
  8035c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035cb:	e9 92 00 00 00       	jmpq   803662 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8035d0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035d8:	48 89 d6             	mov    %rdx,%rsi
  8035db:	48 89 c7             	mov    %rax,%rdi
  8035de:	48 b8 47 34 80 00 00 	movabs $0x803447,%rax
  8035e5:	00 00 00 
  8035e8:	ff d0                	callq  *%rax
  8035ea:	85 c0                	test   %eax,%eax
  8035ec:	74 07                	je     8035f5 <devpipe_read+0x77>
				return 0;
  8035ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8035f3:	eb 6d                	jmp    803662 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8035f5:	48 b8 25 19 80 00 00 	movabs $0x801925,%rax
  8035fc:	00 00 00 
  8035ff:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803601:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803605:	8b 10                	mov    (%rax),%edx
  803607:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80360b:	8b 40 04             	mov    0x4(%rax),%eax
  80360e:	39 c2                	cmp    %eax,%edx
  803610:	74 ae                	je     8035c0 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803612:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803616:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80361a:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80361e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803622:	8b 00                	mov    (%rax),%eax
  803624:	99                   	cltd   
  803625:	c1 ea 1b             	shr    $0x1b,%edx
  803628:	01 d0                	add    %edx,%eax
  80362a:	83 e0 1f             	and    $0x1f,%eax
  80362d:	29 d0                	sub    %edx,%eax
  80362f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803633:	48 98                	cltq   
  803635:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80363a:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80363c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803640:	8b 00                	mov    (%rax),%eax
  803642:	8d 50 01             	lea    0x1(%rax),%edx
  803645:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803649:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80364b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803650:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803654:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803658:	0f 82 60 ff ff ff    	jb     8035be <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80365e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803662:	c9                   	leaveq 
  803663:	c3                   	retq   

0000000000803664 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803664:	55                   	push   %rbp
  803665:	48 89 e5             	mov    %rsp,%rbp
  803668:	48 83 ec 40          	sub    $0x40,%rsp
  80366c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803670:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803674:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803678:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80367c:	48 89 c7             	mov    %rax,%rdi
  80367f:	48 b8 23 23 80 00 00 	movabs $0x802323,%rax
  803686:	00 00 00 
  803689:	ff d0                	callq  *%rax
  80368b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80368f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803693:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803697:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80369e:	00 
  80369f:	e9 8e 00 00 00       	jmpq   803732 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8036a4:	eb 31                	jmp    8036d7 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8036a6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036ae:	48 89 d6             	mov    %rdx,%rsi
  8036b1:	48 89 c7             	mov    %rax,%rdi
  8036b4:	48 b8 47 34 80 00 00 	movabs $0x803447,%rax
  8036bb:	00 00 00 
  8036be:	ff d0                	callq  *%rax
  8036c0:	85 c0                	test   %eax,%eax
  8036c2:	74 07                	je     8036cb <devpipe_write+0x67>
				return 0;
  8036c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8036c9:	eb 79                	jmp    803744 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8036cb:	48 b8 25 19 80 00 00 	movabs $0x801925,%rax
  8036d2:	00 00 00 
  8036d5:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8036d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036db:	8b 40 04             	mov    0x4(%rax),%eax
  8036de:	48 63 d0             	movslq %eax,%rdx
  8036e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036e5:	8b 00                	mov    (%rax),%eax
  8036e7:	48 98                	cltq   
  8036e9:	48 83 c0 20          	add    $0x20,%rax
  8036ed:	48 39 c2             	cmp    %rax,%rdx
  8036f0:	73 b4                	jae    8036a6 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8036f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036f6:	8b 40 04             	mov    0x4(%rax),%eax
  8036f9:	99                   	cltd   
  8036fa:	c1 ea 1b             	shr    $0x1b,%edx
  8036fd:	01 d0                	add    %edx,%eax
  8036ff:	83 e0 1f             	and    $0x1f,%eax
  803702:	29 d0                	sub    %edx,%eax
  803704:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803708:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80370c:	48 01 ca             	add    %rcx,%rdx
  80370f:	0f b6 0a             	movzbl (%rdx),%ecx
  803712:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803716:	48 98                	cltq   
  803718:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80371c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803720:	8b 40 04             	mov    0x4(%rax),%eax
  803723:	8d 50 01             	lea    0x1(%rax),%edx
  803726:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80372a:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80372d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803732:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803736:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80373a:	0f 82 64 ff ff ff    	jb     8036a4 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803740:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803744:	c9                   	leaveq 
  803745:	c3                   	retq   

0000000000803746 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803746:	55                   	push   %rbp
  803747:	48 89 e5             	mov    %rsp,%rbp
  80374a:	48 83 ec 20          	sub    $0x20,%rsp
  80374e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803752:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803756:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80375a:	48 89 c7             	mov    %rax,%rdi
  80375d:	48 b8 23 23 80 00 00 	movabs $0x802323,%rax
  803764:	00 00 00 
  803767:	ff d0                	callq  *%rax
  803769:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80376d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803771:	48 be c7 44 80 00 00 	movabs $0x8044c7,%rsi
  803778:	00 00 00 
  80377b:	48 89 c7             	mov    %rax,%rdi
  80377e:	48 b8 34 10 80 00 00 	movabs $0x801034,%rax
  803785:	00 00 00 
  803788:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80378a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80378e:	8b 50 04             	mov    0x4(%rax),%edx
  803791:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803795:	8b 00                	mov    (%rax),%eax
  803797:	29 c2                	sub    %eax,%edx
  803799:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80379d:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8037a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037a7:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8037ae:	00 00 00 
	stat->st_dev = &devpipe;
  8037b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037b5:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  8037bc:	00 00 00 
  8037bf:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8037c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037cb:	c9                   	leaveq 
  8037cc:	c3                   	retq   

00000000008037cd <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8037cd:	55                   	push   %rbp
  8037ce:	48 89 e5             	mov    %rsp,%rbp
  8037d1:	48 83 ec 10          	sub    $0x10,%rsp
  8037d5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8037d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037dd:	48 89 c6             	mov    %rax,%rsi
  8037e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8037e5:	48 b8 0e 1a 80 00 00 	movabs $0x801a0e,%rax
  8037ec:	00 00 00 
  8037ef:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8037f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037f5:	48 89 c7             	mov    %rax,%rdi
  8037f8:	48 b8 23 23 80 00 00 	movabs $0x802323,%rax
  8037ff:	00 00 00 
  803802:	ff d0                	callq  *%rax
  803804:	48 89 c6             	mov    %rax,%rsi
  803807:	bf 00 00 00 00       	mov    $0x0,%edi
  80380c:	48 b8 0e 1a 80 00 00 	movabs $0x801a0e,%rax
  803813:	00 00 00 
  803816:	ff d0                	callq  *%rax
}
  803818:	c9                   	leaveq 
  803819:	c3                   	retq   

000000000080381a <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80381a:	55                   	push   %rbp
  80381b:	48 89 e5             	mov    %rsp,%rbp
  80381e:	48 83 ec 20          	sub    $0x20,%rsp
  803822:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803825:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803828:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80382b:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80382f:	be 01 00 00 00       	mov    $0x1,%esi
  803834:	48 89 c7             	mov    %rax,%rdi
  803837:	48 b8 1b 18 80 00 00 	movabs $0x80181b,%rax
  80383e:	00 00 00 
  803841:	ff d0                	callq  *%rax
}
  803843:	c9                   	leaveq 
  803844:	c3                   	retq   

0000000000803845 <getchar>:

int
getchar(void)
{
  803845:	55                   	push   %rbp
  803846:	48 89 e5             	mov    %rsp,%rbp
  803849:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80384d:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803851:	ba 01 00 00 00       	mov    $0x1,%edx
  803856:	48 89 c6             	mov    %rax,%rsi
  803859:	bf 00 00 00 00       	mov    $0x0,%edi
  80385e:	48 b8 18 28 80 00 00 	movabs $0x802818,%rax
  803865:	00 00 00 
  803868:	ff d0                	callq  *%rax
  80386a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80386d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803871:	79 05                	jns    803878 <getchar+0x33>
		return r;
  803873:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803876:	eb 14                	jmp    80388c <getchar+0x47>
	if (r < 1)
  803878:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80387c:	7f 07                	jg     803885 <getchar+0x40>
		return -E_EOF;
  80387e:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803883:	eb 07                	jmp    80388c <getchar+0x47>
	return c;
  803885:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803889:	0f b6 c0             	movzbl %al,%eax
}
  80388c:	c9                   	leaveq 
  80388d:	c3                   	retq   

000000000080388e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80388e:	55                   	push   %rbp
  80388f:	48 89 e5             	mov    %rsp,%rbp
  803892:	48 83 ec 20          	sub    $0x20,%rsp
  803896:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803899:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80389d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038a0:	48 89 d6             	mov    %rdx,%rsi
  8038a3:	89 c7                	mov    %eax,%edi
  8038a5:	48 b8 e6 23 80 00 00 	movabs $0x8023e6,%rax
  8038ac:	00 00 00 
  8038af:	ff d0                	callq  *%rax
  8038b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038b8:	79 05                	jns    8038bf <iscons+0x31>
		return r;
  8038ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038bd:	eb 1a                	jmp    8038d9 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8038bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038c3:	8b 10                	mov    (%rax),%edx
  8038c5:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  8038cc:	00 00 00 
  8038cf:	8b 00                	mov    (%rax),%eax
  8038d1:	39 c2                	cmp    %eax,%edx
  8038d3:	0f 94 c0             	sete   %al
  8038d6:	0f b6 c0             	movzbl %al,%eax
}
  8038d9:	c9                   	leaveq 
  8038da:	c3                   	retq   

00000000008038db <opencons>:

int
opencons(void)
{
  8038db:	55                   	push   %rbp
  8038dc:	48 89 e5             	mov    %rsp,%rbp
  8038df:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8038e3:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8038e7:	48 89 c7             	mov    %rax,%rdi
  8038ea:	48 b8 4e 23 80 00 00 	movabs $0x80234e,%rax
  8038f1:	00 00 00 
  8038f4:	ff d0                	callq  *%rax
  8038f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038fd:	79 05                	jns    803904 <opencons+0x29>
		return r;
  8038ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803902:	eb 5b                	jmp    80395f <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803904:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803908:	ba 07 04 00 00       	mov    $0x407,%edx
  80390d:	48 89 c6             	mov    %rax,%rsi
  803910:	bf 00 00 00 00       	mov    $0x0,%edi
  803915:	48 b8 63 19 80 00 00 	movabs $0x801963,%rax
  80391c:	00 00 00 
  80391f:	ff d0                	callq  *%rax
  803921:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803924:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803928:	79 05                	jns    80392f <opencons+0x54>
		return r;
  80392a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80392d:	eb 30                	jmp    80395f <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80392f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803933:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  80393a:	00 00 00 
  80393d:	8b 12                	mov    (%rdx),%edx
  80393f:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803941:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803945:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80394c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803950:	48 89 c7             	mov    %rax,%rdi
  803953:	48 b8 00 23 80 00 00 	movabs $0x802300,%rax
  80395a:	00 00 00 
  80395d:	ff d0                	callq  *%rax
}
  80395f:	c9                   	leaveq 
  803960:	c3                   	retq   

0000000000803961 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803961:	55                   	push   %rbp
  803962:	48 89 e5             	mov    %rsp,%rbp
  803965:	48 83 ec 30          	sub    $0x30,%rsp
  803969:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80396d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803971:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803975:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80397a:	75 07                	jne    803983 <devcons_read+0x22>
		return 0;
  80397c:	b8 00 00 00 00       	mov    $0x0,%eax
  803981:	eb 4b                	jmp    8039ce <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803983:	eb 0c                	jmp    803991 <devcons_read+0x30>
		sys_yield();
  803985:	48 b8 25 19 80 00 00 	movabs $0x801925,%rax
  80398c:	00 00 00 
  80398f:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803991:	48 b8 65 18 80 00 00 	movabs $0x801865,%rax
  803998:	00 00 00 
  80399b:	ff d0                	callq  *%rax
  80399d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039a4:	74 df                	je     803985 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8039a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039aa:	79 05                	jns    8039b1 <devcons_read+0x50>
		return c;
  8039ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039af:	eb 1d                	jmp    8039ce <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8039b1:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8039b5:	75 07                	jne    8039be <devcons_read+0x5d>
		return 0;
  8039b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8039bc:	eb 10                	jmp    8039ce <devcons_read+0x6d>
	*(char*)vbuf = c;
  8039be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039c1:	89 c2                	mov    %eax,%edx
  8039c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039c7:	88 10                	mov    %dl,(%rax)
	return 1;
  8039c9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8039ce:	c9                   	leaveq 
  8039cf:	c3                   	retq   

00000000008039d0 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8039d0:	55                   	push   %rbp
  8039d1:	48 89 e5             	mov    %rsp,%rbp
  8039d4:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8039db:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8039e2:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8039e9:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8039f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8039f7:	eb 76                	jmp    803a6f <devcons_write+0x9f>
		m = n - tot;
  8039f9:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803a00:	89 c2                	mov    %eax,%edx
  803a02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a05:	29 c2                	sub    %eax,%edx
  803a07:	89 d0                	mov    %edx,%eax
  803a09:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803a0c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a0f:	83 f8 7f             	cmp    $0x7f,%eax
  803a12:	76 07                	jbe    803a1b <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803a14:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803a1b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a1e:	48 63 d0             	movslq %eax,%rdx
  803a21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a24:	48 63 c8             	movslq %eax,%rcx
  803a27:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803a2e:	48 01 c1             	add    %rax,%rcx
  803a31:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803a38:	48 89 ce             	mov    %rcx,%rsi
  803a3b:	48 89 c7             	mov    %rax,%rdi
  803a3e:	48 b8 58 13 80 00 00 	movabs $0x801358,%rax
  803a45:	00 00 00 
  803a48:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803a4a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a4d:	48 63 d0             	movslq %eax,%rdx
  803a50:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803a57:	48 89 d6             	mov    %rdx,%rsi
  803a5a:	48 89 c7             	mov    %rax,%rdi
  803a5d:	48 b8 1b 18 80 00 00 	movabs $0x80181b,%rax
  803a64:	00 00 00 
  803a67:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803a69:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a6c:	01 45 fc             	add    %eax,-0x4(%rbp)
  803a6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a72:	48 98                	cltq   
  803a74:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803a7b:	0f 82 78 ff ff ff    	jb     8039f9 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803a81:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803a84:	c9                   	leaveq 
  803a85:	c3                   	retq   

0000000000803a86 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803a86:	55                   	push   %rbp
  803a87:	48 89 e5             	mov    %rsp,%rbp
  803a8a:	48 83 ec 08          	sub    $0x8,%rsp
  803a8e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803a92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a97:	c9                   	leaveq 
  803a98:	c3                   	retq   

0000000000803a99 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803a99:	55                   	push   %rbp
  803a9a:	48 89 e5             	mov    %rsp,%rbp
  803a9d:	48 83 ec 10          	sub    $0x10,%rsp
  803aa1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803aa5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803aa9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aad:	48 be d3 44 80 00 00 	movabs $0x8044d3,%rsi
  803ab4:	00 00 00 
  803ab7:	48 89 c7             	mov    %rax,%rdi
  803aba:	48 b8 34 10 80 00 00 	movabs $0x801034,%rax
  803ac1:	00 00 00 
  803ac4:	ff d0                	callq  *%rax
	return 0;
  803ac6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803acb:	c9                   	leaveq 
  803acc:	c3                   	retq   

0000000000803acd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803acd:	55                   	push   %rbp
  803ace:	48 89 e5             	mov    %rsp,%rbp
  803ad1:	53                   	push   %rbx
  803ad2:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803ad9:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803ae0:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803ae6:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803aed:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803af4:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803afb:	84 c0                	test   %al,%al
  803afd:	74 23                	je     803b22 <_panic+0x55>
  803aff:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803b06:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803b0a:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803b0e:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803b12:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803b16:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803b1a:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803b1e:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803b22:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803b29:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803b30:	00 00 00 
  803b33:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803b3a:	00 00 00 
  803b3d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803b41:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803b48:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803b4f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803b56:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  803b5d:	00 00 00 
  803b60:	48 8b 18             	mov    (%rax),%rbx
  803b63:	48 b8 e7 18 80 00 00 	movabs $0x8018e7,%rax
  803b6a:	00 00 00 
  803b6d:	ff d0                	callq  *%rax
  803b6f:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803b75:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803b7c:	41 89 c8             	mov    %ecx,%r8d
  803b7f:	48 89 d1             	mov    %rdx,%rcx
  803b82:	48 89 da             	mov    %rbx,%rdx
  803b85:	89 c6                	mov    %eax,%esi
  803b87:	48 bf e0 44 80 00 00 	movabs $0x8044e0,%rdi
  803b8e:	00 00 00 
  803b91:	b8 00 00 00 00       	mov    $0x0,%eax
  803b96:	49 b9 7f 04 80 00 00 	movabs $0x80047f,%r9
  803b9d:	00 00 00 
  803ba0:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803ba3:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803baa:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803bb1:	48 89 d6             	mov    %rdx,%rsi
  803bb4:	48 89 c7             	mov    %rax,%rdi
  803bb7:	48 b8 d3 03 80 00 00 	movabs $0x8003d3,%rax
  803bbe:	00 00 00 
  803bc1:	ff d0                	callq  *%rax
	cprintf("\n");
  803bc3:	48 bf 03 45 80 00 00 	movabs $0x804503,%rdi
  803bca:	00 00 00 
  803bcd:	b8 00 00 00 00       	mov    $0x0,%eax
  803bd2:	48 ba 7f 04 80 00 00 	movabs $0x80047f,%rdx
  803bd9:	00 00 00 
  803bdc:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803bde:	cc                   	int3   
  803bdf:	eb fd                	jmp    803bde <_panic+0x111>

0000000000803be1 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803be1:	55                   	push   %rbp
  803be2:	48 89 e5             	mov    %rsp,%rbp
  803be5:	48 83 ec 10          	sub    $0x10,%rsp
  803be9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  803bed:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803bf4:	00 00 00 
  803bf7:	48 8b 00             	mov    (%rax),%rax
  803bfa:	48 85 c0             	test   %rax,%rax
  803bfd:	75 64                	jne    803c63 <set_pgfault_handler+0x82>
		// First time through!
		// LAB 4: Your code here.
		//envid_t eid = sys_getenvid();
		if(sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) 
  803bff:	ba 07 00 00 00       	mov    $0x7,%edx
  803c04:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803c09:	bf 00 00 00 00       	mov    $0x0,%edi
  803c0e:	48 b8 63 19 80 00 00 	movabs $0x801963,%rax
  803c15:	00 00 00 
  803c18:	ff d0                	callq  *%rax
  803c1a:	85 c0                	test   %eax,%eax
  803c1c:	74 2a                	je     803c48 <set_pgfault_handler+0x67>
			panic("Allocation of space for UXSTACK failed\n");
  803c1e:	48 ba 08 45 80 00 00 	movabs $0x804508,%rdx
  803c25:	00 00 00 
  803c28:	be 22 00 00 00       	mov    $0x22,%esi
  803c2d:	48 bf 30 45 80 00 00 	movabs $0x804530,%rdi
  803c34:	00 00 00 
  803c37:	b8 00 00 00 00       	mov    $0x0,%eax
  803c3c:	48 b9 cd 3a 80 00 00 	movabs $0x803acd,%rcx
  803c43:	00 00 00 
  803c46:	ff d1                	callq  *%rcx
		else
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  803c48:	48 be 76 3c 80 00 00 	movabs $0x803c76,%rsi
  803c4f:	00 00 00 
  803c52:	bf 00 00 00 00       	mov    $0x0,%edi
  803c57:	48 b8 ed 1a 80 00 00 	movabs $0x801aed,%rax
  803c5e:	00 00 00 
  803c61:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803c63:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803c6a:	00 00 00 
  803c6d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803c71:	48 89 10             	mov    %rdx,(%rax)
}
  803c74:	c9                   	leaveq 
  803c75:	c3                   	retq   

0000000000803c76 <_pgfault_upcall>:
// Call the C page fault handler.
// function argument: pointer to UTF



movq  %rsp,%rdi                // passing the function argument in rdi
  803c76:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  803c79:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803c80:	00 00 00 
call *%rax
  803c83:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
mov 152(%rsp), %r8
  803c85:	4c 8b 84 24 98 00 00 	mov    0x98(%rsp),%r8
  803c8c:	00 
mov 136(%rsp), %r9
  803c8d:	4c 8b 8c 24 88 00 00 	mov    0x88(%rsp),%r9
  803c94:	00 
sub $8, %r8
  803c95:	49 83 e8 08          	sub    $0x8,%r8
mov %r9, (%r8)
  803c99:	4d 89 08             	mov    %r9,(%r8)
mov %r8, 152(%rsp)
  803c9c:	4c 89 84 24 98 00 00 	mov    %r8,0x98(%rsp)
  803ca3:	00 
add $16, %rsp
  803ca4:	48 83 c4 10          	add    $0x10,%rsp

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
POPA_
  803ca8:	4c 8b 3c 24          	mov    (%rsp),%r15
  803cac:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803cb1:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803cb6:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803cbb:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803cc0:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803cc5:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803cca:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803ccf:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803cd4:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803cd9:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803cde:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803ce3:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803ce8:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803ced:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803cf2:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
		// LAB 4: Your code here.
add $8, %rsp
  803cf6:	48 83 c4 08          	add    $0x8,%rsp
popf
  803cfa:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
mov (%rsp), %rsp
  803cfb:	48 8b 24 24          	mov    (%rsp),%rsp
    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
ret
  803cff:	c3                   	retq   

0000000000803d00 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803d00:	55                   	push   %rbp
  803d01:	48 89 e5             	mov    %rsp,%rbp
  803d04:	48 83 ec 18          	sub    $0x18,%rsp
  803d08:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803d0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d10:	48 c1 e8 15          	shr    $0x15,%rax
  803d14:	48 89 c2             	mov    %rax,%rdx
  803d17:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803d1e:	01 00 00 
  803d21:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d25:	83 e0 01             	and    $0x1,%eax
  803d28:	48 85 c0             	test   %rax,%rax
  803d2b:	75 07                	jne    803d34 <pageref+0x34>
		return 0;
  803d2d:	b8 00 00 00 00       	mov    $0x0,%eax
  803d32:	eb 53                	jmp    803d87 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803d34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d38:	48 c1 e8 0c          	shr    $0xc,%rax
  803d3c:	48 89 c2             	mov    %rax,%rdx
  803d3f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803d46:	01 00 00 
  803d49:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d4d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803d51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d55:	83 e0 01             	and    $0x1,%eax
  803d58:	48 85 c0             	test   %rax,%rax
  803d5b:	75 07                	jne    803d64 <pageref+0x64>
		return 0;
  803d5d:	b8 00 00 00 00       	mov    $0x0,%eax
  803d62:	eb 23                	jmp    803d87 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803d64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d68:	48 c1 e8 0c          	shr    $0xc,%rax
  803d6c:	48 89 c2             	mov    %rax,%rdx
  803d6f:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803d76:	00 00 00 
  803d79:	48 c1 e2 04          	shl    $0x4,%rdx
  803d7d:	48 01 d0             	add    %rdx,%rax
  803d80:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803d84:	0f b7 c0             	movzwl %ax,%eax
}
  803d87:	c9                   	leaveq 
  803d88:	c3                   	retq   
